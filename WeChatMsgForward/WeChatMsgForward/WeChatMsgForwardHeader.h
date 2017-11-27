//
//  WeChatMsgForwardTool.h
//  WeChatMsgForward
//
//  Created by admin on 2017/11/24.
//  Copyright © 2017年 ahaschool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface CContact : NSObject
@property (nonatomic, copy) NSString *m_nsOwner;                        // 拥有者
@property (nonatomic, copy) NSString *m_nsNickName;                     // 用户昵称
@property (nonatomic, copy) NSString *m_nsUsrName;                      // 微信id
@property (nonatomic, copy) NSString *m_nsMemberName;
@property(retain, nonatomic) NSString *m_nsHeadImgUrl;

- (id)getContactDisplayName;
- (NSString *)getChatRoomMemberDisplayName:(id)obj;
@end

@class CMessageWrap;
@interface BaseChatViewModel : NSObject
@property (weak, nonatomic) id cellView;
@property (nonatomic) double createTime;
@property (nonatomic) NSString *intervaleTime;
@end

@interface BaseMessageViewModel : BaseChatViewModel
@end

@interface CommonMessageViewModel : BaseMessageViewModel
@property(readonly, nonatomic) _Bool isSender; // @synthesize isSender=m_isSender;
@property(readonly, nonatomic) CContact *m_contact;
@property(readonly, nonatomic) CMessageWrap *m_messageWrap;
@end


@interface CommonMessageCellView : UIView{
    UIView *m_contentView;
}
@property (readonly, nonatomic) CommonMessageViewModel *viewModel;
@property (nonatomic) UIButton *expandBtn;
- (void) updateNodeStatus;
- (void) initWithViewModel:(id)model;
- (void) onExpandBtnClick;
@end


@class CMessageWrap;
@interface CExtendInfoOfEmoticon : NSObject
@property(nonatomic) CMessageWrap *m_refMessageWrap;
@property(retain, nonatomic) id m_oImageInfo;
@property(retain, nonatomic) NSData *m_dtImg;
@property(retain, nonatomic) NSString *m_nsMsgMd5;
@property(retain, nonatomic) NSString *m_nsAutoDownloadControl;
@end

@interface CMessageWrap : NSObject
@property (retain, nonatomic) NSString* m_nsFromUsr;            ///< 发信人，可能是群或个人
@property (retain, nonatomic) NSString* m_nsToUsr;              ///< 收信人
@property (assign, nonatomic) NSUInteger m_uiStatus;
@property (retain, nonatomic) NSString* m_nsContent;            ///< 消息内容
@property (retain, nonatomic) NSString* m_nsRealChatUsr;        ///< 群消息的发信人，具体是群里的哪个人
@property (assign, nonatomic) NSUInteger m_uiMessageType;
@property (assign, nonatomic) NSUInteger m_uiCreateTime;
@property (retain, nonatomic) NSString *m_nsAppExtInfo;
@property (assign, nonatomic) NSUInteger m_uiAppDataSize;
@property (assign, nonatomic) NSUInteger m_uiAppMsgInnerType;
@property (retain, nonatomic) NSString *m_nsShareOpenUrl;
@property (retain, nonatomic) NSString *m_nsShareOriginUrl;
@property (retain, nonatomic) NSString *m_nsJsAppId;
@property (retain, nonatomic) NSString *m_nsPrePublishId;
@property (retain, nonatomic) NSString *m_nsAppID;
@property (retain, nonatomic) NSString *m_nsAppName;
@property (retain, nonatomic) NSString *m_nsThumbUrl;
@property (retain, nonatomic) NSString *m_nsAppMediaUrl;
@property (retain, nonatomic) NSData *m_dtThumbnail;
@property (retain, nonatomic) NSString *m_nsTitle;
@property (retain, nonatomic) NSString *m_nsMsgSource;
@property (nonatomic, copy)   NSString *m_nsLastDisplayContent;
@property (nonatomic, copy)   NSString *m_nsPushContent;

@property (nonatomic, copy) NSString *m_nsPushBody;

@property (nonatomic) CExtendInfoOfEmoticon *m_extendInfoWithMsgType;
@property (assign, nonatomic) NSUInteger m_forwardType;//2
@property (assign, nonatomic) NSUInteger m_uiImgStatus;//2
@property (assign, nonatomic) NSUInteger m_sequenceId;//
@property (assign, nonatomic) BOOL m_bNew;//1

- (id)initWithMsgType:(long long)arg1;
+ (_Bool)isSenderFromMsgWrap:(id)arg1;

+ (id)getMsgMiddleImgData:(id)arg1;
+ (id)getMsgImgData:(id)arg1;
@end

@interface SettingUtil : NSObject
+ (id)getLocalUsrName:(unsigned int)arg1;
@end

@interface MMNewSessionMgr : NSObject
- (unsigned int)GenSendMsgTime;
@end


@interface CMessageMgr : NSObject
- (void)AddMsg:(id)arg1 MsgWrap:(id)arg2;
- (void)AddEmoticonMsg:(id)arg1 MsgWrap:(id)arg2;@end

@interface MMServiceCenter : NSObject
+ (instancetype)defaultCenter;
- (id)getService:(Class)service;
@end

