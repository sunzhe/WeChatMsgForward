//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  WeChatMsgForward.m
//  WeChatMsgForward
//
//  Created by admin on 2017/11/24.
//  Copyright (c) 2017年 ahaschool. All rights reserved.
//

#import "WeChatMsgForward.h"
#import <CaptainHook/CaptainHook.h>
#import "WeChatMsgForwardHeader.h"

void forwardMsg(CMessageWrap *msg){
    CMessageWrap *wrap = [[objc_getClass("CMessageWrap") alloc] initWithMsgType:msg.m_uiMessageType];
    wrap.m_extendInfoWithMsgType = msg.m_extendInfoWithMsgType;
    if ([wrap.m_extendInfoWithMsgType respondsToSelector:@selector(setM_refMessageWrap:)]){
        wrap.m_extendInfoWithMsgType.m_refMessageWrap = wrap;
    }
    wrap.m_forwardType = 2;
    if (wrap.m_uiMessageType == 3){//图片
        wrap.m_uiImgStatus = 2;
        NSData *data = [objc_getClass("CMessageWrap") getMsgMiddleImgData:msg];
        if (!wrap.m_dtThumbnail) wrap.m_dtThumbnail = data;
    }else if (wrap.m_uiMessageType == 34){//语音
        wrap.m_uiImgStatus = 1;//暂不支持
    }else if (wrap.m_uiMessageType != 47){//非表情
        wrap.m_nsContent = msg.m_nsContent;
    }
    id usrName = [objc_getClass("SettingUtil") getLocalUsrName:0];
    [wrap setM_nsFromUsr:usrName];
    
    NSString * toUserName = msg.m_nsFromUsr;
    if ([objc_getClass("CMessageWrap") isSenderFromMsgWrap:msg]){
        toUserName = msg.m_nsToUsr;
    }
    [wrap setM_nsToUsr:toUserName];
    
    MMNewSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMNewSessionMgr")];
    [wrap setM_uiCreateTime:[sessionMgr GenSendMsgTime]];
    [wrap setM_uiStatus:YES];
    
    CMessageMgr *chatMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CMessageMgr")];
    if (wrap.m_uiMessageType == 47){
        [chatMgr AddEmoticonMsg:toUserName MsgWrap:wrap];
    }else {
        [chatMgr AddMsg:toUserName MsgWrap:wrap];
    }
};



CHDeclareClass(BaseChatViewModel)
CHPropertyRetainNonatomic(BaseChatViewModel, NSString *, intervaleTime, setIntervaleTime);


CHDeclareClass(CommonMessageCellView)
CHPropertyRetainNonatomic(CommonMessageCellView, UIView *, expandBtn, setExpandBtn);

CHOptimizedMethod(1, self,id,CommonMessageCellView,initWithViewModel,BaseChatViewModel *,arg1){
    CommonMessageCellView *view =  CHSuper(1,CommonMessageCellView,initWithViewModel,arg1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 40);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitle:@"+1" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onExpandBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    view.expandBtn = btn;
    return view;
}

CHMethod0(void, CommonMessageCellView, onExpandBtnClick){
    CommonMessageViewModel *msgNode = (CommonMessageViewModel *)self.viewModel;
    CMessageWrap *wrap = [msgNode valueForKey:@"m_messageWrap"];
    forwardMsg(wrap);
}


CHOptimizedMethod(0, self,void,CommonMessageCellView,updateNodeStatus){
    CHSuper(0,CommonMessageCellView,updateNodeStatus);
    
    CommonMessageViewModel *msgNode = (CommonMessageViewModel *)self.viewModel;
    CMessageWrap *wrap = [msgNode valueForKey:@"m_messageWrap"];
    //文字图片表情支持盖楼
    BOOL shouldShow = (wrap && (wrap.m_uiMessageType == 1 || wrap.m_uiMessageType == 3 || wrap.m_uiMessageType == 47));
    if (shouldShow && [msgNode isKindOfClass:NSClassFromString(@"TextMessageSubViewModel")]) {//长文本分割ui处理
        NSArray *arr = [msgNode valueForKeyPath:@"_parentModel.m_subViewModels"];
        shouldShow = arr.firstObject == msgNode;
    }
    
    if (shouldShow) {
        UIView *m_contentView = CHIvar(self, m_contentView, __strong UIView *);
        CGRect rect = self.expandBtn.frame;
        rect.origin.y = m_contentView.frame.origin.y + 4;
        if ([objc_getClass("CMessageWrap") isSenderFromMsgWrap:wrap]) {
            self.expandBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            rect.origin.x = CGRectGetMinX(m_contentView.frame) - 4 - rect.size.width;
        }else {
            self.expandBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            rect.origin.x = CGRectGetMaxX(m_contentView.frame) + 4;
        }
        self.expandBtn.frame = rect;
        if (![self.expandBtn isDescendantOfView:self]) {
            [self addSubview:self.expandBtn];
        }
        self.expandBtn.hidden = NO;
    }else{
        self.expandBtn.hidden = YES;
    }
}

CHConstructor{
    
    CHLoadLateClass(BaseChatViewModel);
    CHClassHook(0,BaseChatViewModel, intervaleTime);
    CHClassHook(1,BaseChatViewModel, setIntervaleTime);
    
    
    CHLoadLateClass(CommonMessageCellView);
    CHClassHook(1,CommonMessageCellView, initWithViewModel);
    
    CHClassHook(0, CommonMessageCellView,expandBtn);
    CHClassHook(1, CommonMessageCellView,setExpandBtn);
    
    CHClassHook(0, CommonMessageCellView,updateNodeStatus);
    CHClassHook(0, CommonMessageCellView,onExpandBtnClick);
    
    
}

