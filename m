Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,RAND_MKTG_HEADER,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40009C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 00:47:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F7D564E99
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 00:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F7D564E99
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24CE94B397;
	Wed,  3 Mar 2021 19:47:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QNY0M2JhvRq5; Wed,  3 Mar 2021 19:47:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFABC4B62E;
	Wed,  3 Mar 2021 19:47:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69E264B399
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 19:47:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lsq7-dKLuZxC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Mar 2021 19:47:11 -0500 (EST)
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr10064.outbound.protection.outlook.com [40.107.1.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00AF64B397
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 19:47:10 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGJoCjGTOOxu6b1xQzju//OpBbXz2Le9eLdeOXbl2N8=;
 b=hwDZv0Nmy3q6ziTENWxZNCehoF0r13HKHddJh+ITh4ljEVeXih+H5L4ONCJNeIJFmLecNdq2gM8tzTJ9TZl9cPt6VtflcI6ssfwz8GTgJxyyi+k1GTPuKNAyeOjBTgWOvD4a76/8ek1/8XTGdLjsqnsR+MR1YluPeYGsRLvK+aI=
Received: from AS8PR04CA0012.eurprd04.prod.outlook.com (2603:10a6:20b:310::17)
 by VI1PR0802MB2237.eurprd08.prod.outlook.com (2603:10a6:800:9c::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 4 Mar
 2021 00:47:07 +0000
Received: from AM5EUR03FT063.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:310:cafe::80) by AS8PR04CA0012.outlook.office365.com
 (2603:10a6:20b:310::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 4 Mar 2021 00:47:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT063.mail.protection.outlook.com (10.152.16.226) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17 via Frontend Transport; Thu, 4 Mar 2021 00:47:06 +0000
Received: ("Tessian outbound 7213b86582b6:v71");
 Thu, 04 Mar 2021 00:47:05 +0000
X-CR-MTA-TID: 64aa7808
Received: from a758f48e1fe0.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 B797A172-12FB-4670-9493-A40F0B7C1176.1; 
 Thu, 04 Mar 2021 00:47:00 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a758f48e1fe0.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Thu, 04 Mar 2021 00:47:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0jdXRFUAnRdffZ1KsVnPzQ7sFhjLD4vTDkc9e0CGbWaGZ2H+M+NOKSIbsu2lNPmxzWo7oeMYoLWK4n1XNkNWwC7q2A98MJZ7vdSYVoXJYH5gsMGmYYgz2cOUJZIiXnjr28/7S0oNuc68ZOaS3NesTwJSufFvHl1SVJS6wtYHjLFiZ0spoqugCEpFPa2W2M//wuEOZLS72vYbUbcnBLkV1jG5jbl/lZTsDfGcUrn2dt8LJmCLTyVQuCJ9xFXuhOrX4486lst+S5NC+xaUyRTvMWMmLVpAAWrYHl8NbTFwZZm4fd2PZGqFWWCtvNqbzg/dwqk8bssNEQ3IjXkLXh73A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGJoCjGTOOxu6b1xQzju//OpBbXz2Le9eLdeOXbl2N8=;
 b=TTRBU6bigKBQXMVNTgaSZJ9i2Cy/D+XR3c3ks92l9feiDcfvUzyNa5lsgzGAQcbdqNNqLbmGTAN9e+NGPqfR11vzPPG48HE7rLSbNEsBn0kkbqJmrAgD0giabEvKEBYZKNpcCvX0kZcqdkQEW1t1HKYs15ITjPEGFOIqXYNON5h8w40lSxNC0lgielgH1k3sWgEJi6fwn+c1vimop5GeO8h4izxP2CQKA1UwiH8Fo9fcuDIOQur/Ab1xgQSF9pCgT973lZy1SwWZY2fNM0QW/0y83y8pqJW7wdYc4Fx+qLQX5kRjZkVzychYl+A9jPIPRYo/baN/ZOgY9HjqRxebyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGJoCjGTOOxu6b1xQzju//OpBbXz2Le9eLdeOXbl2N8=;
 b=hwDZv0Nmy3q6ziTENWxZNCehoF0r13HKHddJh+ITh4ljEVeXih+H5L4ONCJNeIJFmLecNdq2gM8tzTJ9TZl9cPt6VtflcI6ssfwz8GTgJxyyi+k1GTPuKNAyeOjBTgWOvD4a76/8ek1/8XTGdLjsqnsR+MR1YluPeYGsRLvK+aI=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB3125.eurprd08.prod.outlook.com (2603:10a6:209:46::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Thu, 4 Mar
 2021 00:46:56 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::5192:4597:8d30:5800]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::5192:4597:8d30:5800%4]) with mapi id 15.20.3912.019; Thu, 4 Mar 2021
 00:46:56 +0000
From: Justin He <Justin.He@arm.com>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] KVM: arm64: Fix unaligned addr case in mmu walking
Thread-Topic: [PATCH] KVM: arm64: Fix unaligned addr case in mmu walking
Thread-Index: AQHXD9bsiwf2wq23AEqHAHP4tBiTG6pyIUoAgAB/+oCAACMoAIAAOX+g
Date: Thu, 4 Mar 2021 00:46:55 +0000
Message-ID: <AM6PR08MB437695640C272E4F065A8B2DF7979@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210303024225.2591-1-justin.he@arm.com>
 <20210303112934.GA18452@willie-the-truck> <87mtvkys1y.wl-maz@kernel.org>
 <20210303211325.GA20055@willie-the-truck>
In-Reply-To: <20210303211325.GA20055@willie-the-truck>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: FE3E02CC55BB23418F7C08C9B85A2460.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35195aad-f914-40c8-e793-08d8dea708ea
x-ms-traffictypediagnostic: AM6PR08MB3125:|VI1PR0802MB2237:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0802MB2237B43286B5F3654873472DF7979@VI1PR0802MB2237.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:5516;OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: mnCIKnB9Nq1f6TH9EcFq3CiqGkxPjAvRQtoRzCs6pC8cEHZpCWyKt7pl/p7JyMZWucKVf0xwD2H3WMPMSyVWdveqDCCtvL7Ocp4DCz4yENIfc/CezIa0a/U1XoPiIGLnGy/Byr4lm7Md2FZPt2lzObMAw+zTEXspbgRl8nhMsw+9BxL8pWOa49nN7TE4UQlyJ2JKvcdpbZxsv76q4XlnFvO7yVxYNy2QEdTtRw9+QwT1jDw8g+J5bqSx74PJZOy/5OtyZgemd0/ZJGI28zlH5l+AOGIovNsUcszNscrGToSYSJmfmjzcEDqpLRt7o0HdcUqwK05SbzoVElFu5XRPHcw4Ba0wSOylkL9xZ5HSUif9Cga4MmufOCqVx04m4KdtHtBiqZQ80RySi693n0MeOQXq65HSkxDefz02tJkXSZrxaeKXyO6TLXTEvwvaxjHbTYYA25/gpas2CJV1eybvs8VqDcVxT7/bpEHcYBW3LjwP3MC7W3ZAZ9waxIEMIrAv7l26IEhJCDGL1sZzYsAKcRQJS/WUFpQMraZS4hjhm5dEz5u6NhTdmbSuYP5C6skNbk+PZEVCRjOnSi3dqgM3oArn/us9F0e5tdfSyNk2lj4=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AM6PR08MB4376.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(478600001)(66946007)(52536014)(66556008)(66476007)(9686003)(7696005)(316002)(64756008)(66446008)(55016002)(71200400001)(86362001)(110136005)(54906003)(2906002)(26005)(186003)(6506007)(8676002)(4326008)(8936002)(53546011)(966005)(76116006)(83380400001)(33656002)(5660300002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?U7o1ry6mhSVqhvTEHlWOcHCSTwxlw1imYXdSI55u5ULlMpACu3UBUF4xt4G2?=
 =?us-ascii?Q?N9KwgkvweOYJ+bsCBF8L4CoIlitnJSl6g5cv9WSSyV/ko19/wCXadd7+tQtR?=
 =?us-ascii?Q?xLbNQwaC3GvnlWXWBQ2O956eLqOC4CNwtE4k+wHpt7kRR2M2yC7Ee9XP5DHL?=
 =?us-ascii?Q?Om3Qi2HDGo/75HQCx/AePHHSoKvhkE8LkHJo7ye/TZ4r8AmcLra6feV0qzOe?=
 =?us-ascii?Q?qGkgN5GK9ayoiHMg44j78VeES3DmOPR9uJ6JSX4uRPN10N8SlhDf107Hww6o?=
 =?us-ascii?Q?AWZpltR2OOprcinyLgVSNNqdNQdljfXY3uK2hnjOwISJFqe9KRdyF+8p9wO0?=
 =?us-ascii?Q?DCqUGN0BgYTP+tK63kCAXjJJiVoluNmrlBXzdflQHon4ObPs2nbt9PBXdH8e?=
 =?us-ascii?Q?F9gM8iG2sfPr7s33lG+vVRxIaQ241YtpA+BfO8jQtf2BSM/jeAlib6k1Y3j6?=
 =?us-ascii?Q?HAT1LyHJuFdicZj8rFUhPq3vJYJ2l7TXnAIdIw3MuNwZPo620d6iXXmf0/y+?=
 =?us-ascii?Q?hNPQD2CqWzzywkAEMS/hWHOt4RWTAUhVI60KOp0a0RUclADf1/OL+90qDZYD?=
 =?us-ascii?Q?fy6k0uakTPK3WOiPOhICvATimj8SV4T8+BSFXGRgWGTxwg+hoDTnRT43unrf?=
 =?us-ascii?Q?lfGMvo1tGD7ST1HxadPri/zYqbcDB2agreciWUXR1dEt19wjdpCJ03EKYVdT?=
 =?us-ascii?Q?lrZyb9HXCBfBQkBxi8STfOlNc5qW5EWglWbwLOJKDDK6AsD9DTvL2XF8iyI9?=
 =?us-ascii?Q?glyZturBjLJaLbrftKIVR4OV4u+uHnFOxgkjtWxkyH2xvfdTUOYBR1whUxJX?=
 =?us-ascii?Q?dFgUzlcfmQItEPKUZOzB4WmzykjsTrVFh9udmLECR7QOh07IxvUpWhsd2yu8?=
 =?us-ascii?Q?J/lLSnUF3s5GZdLi/521rxkmF5OjOBUKRYwjfXnvVf4TLdUSNCZkf1rl4hAF?=
 =?us-ascii?Q?EkQtjgiksZ/honwcgDJhNNQW6zru9u7TNRNGktjlqvPNjdyYifbg1616l6Vm?=
 =?us-ascii?Q?Tk0VN9L7vcExxS78F/cz840lETKBaTS3Jp/OFeqlFUufZxke/4hxfC9c7ZyA?=
 =?us-ascii?Q?gcAq6J6EaKYaM8A+arZ8k9qEQETQ80s5DIXbGYaqC3i4mY7pH1jdLdQNcwsd?=
 =?us-ascii?Q?/7nOv9OA9prAbgP9z2iS0j5DfcYV1bu1FAU7ZF0/r2/sWPtLGTzdQWg3jYQk?=
 =?us-ascii?Q?/fFB77lj8zfm1ZLvJStWOoxrb/4HgSCwTwHCl1y4dnK6BwpGTlhhSC4ImrOq?=
 =?us-ascii?Q?nO9wq3KJvBqMJhaZ8d2NSVFBjCB4NiHntzcEoITlnFPFRcSaoJnESTrYmS4O?=
 =?us-ascii?Q?P3L3pzAu9Qr8cEqEb1dcyLXh?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3125
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: ddf736f2-302e-46fc-69df-08d8dea70324
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tdj8KlwZ1PGnn7AGavKoCXBauOAvyZWCKRZb2+auel4OMVnTILZkTVwCW79WBL0ISfqM16jY1scogAup7x+spFxkedmfn9GzcDx/IMKKgUDPiII10kb6Q5TkplTnBP0S9f0tw3xNicBxipMZPHaJW7Qxr7EttPvU/B7MSctJMUXDTSTy31JwBWnxBCY1FahOws4L8PGZ+cNuwBqfY/zof9/cw+wI/uqygjgSNUiDAi0ZJPv5jqnKKd+As/HxhBOLWW8VkW+Hj7jJrYo7dbfysF5143oMaxLnDCjRH+vTcXURuYa7xTJcj0mai6hTrYbHNt9NPj2sgu9e+mdMtrXNx1oDJ0Rr3ZE6+nzRCfqlv6t7Nw1SKE4uhZFweIHmp51+Z6csjL1PIzCZ6HI0MgH+16wdT/pYrJFEeXR06jlcjozZtk6F7Q6Mv0u5u1Y9Jb/oYd8MlA5zlHYkuBIQ/GAJH4mV1EULguqk+5Ab8mPhRPjX0gAyzoDSPJAku2KupwNRil6ogX3+sCnWTqgwb9ZP4so+6wF6MQ6f4LCGEHwqsucRYw8uSPnbP7FRgkkiAVkmI6+1LKdxY9PHyS3qPoDxp7mMTsbgfZBn5vq226W5kRxDEeDAK63AzZqdUunRW1ery/0w5vit2bJPt5Gf4OPxp+UAp4CF5QL1M+vWBZQm6v/GorriOdLanTXn1pO1idaen2cDezUCx8kx9XErxuw3bWtJHriqdz387MxUWdfCQMc=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(36840700001)(46966006)(36860700001)(4326008)(53546011)(316002)(26005)(110136005)(6506007)(966005)(7696005)(47076005)(52536014)(5660300002)(86362001)(186003)(336012)(8936002)(107886003)(70206006)(33656002)(9686003)(478600001)(70586007)(55016002)(82740400003)(8676002)(2906002)(54906003)(356005)(81166007)(83380400001)(82310400003);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 00:47:06.2882 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35195aad-f914-40c8-e793-08d8dea708ea
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2237
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc

> -----Original Message-----
> From: Will Deacon <will@kernel.org>
> Sent: Thursday, March 4, 2021 5:13 AM
> To: Marc Zyngier <maz@kernel.org>
> Cc: Justin He <Justin.He@arm.com>; kvmarm@lists.cs.columbia.edu; James
> Morse <James.Morse@arm.com>; Julien Thierry <julien.thierry.kdev@gmail.com>;
> Suzuki Poulose <Suzuki.Poulose@arm.com>; Catalin Marinas
> <Catalin.Marinas@arm.com>; Gavin Shan <gshan@redhat.com>; Yanan Wang
> <wangyanan55@huawei.com>; Quentin Perret <qperret@google.com>; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] KVM: arm64: Fix unaligned addr case in mmu walking
> 
> On Wed, Mar 03, 2021 at 07:07:37PM +0000, Marc Zyngier wrote:
> > From e0524b41a71e0f17d6dc8f197e421e677d584e72 Mon Sep 17 00:00:00 2001
> > From: Jia He <justin.he@arm.com>
> > Date: Wed, 3 Mar 2021 10:42:25 +0800
> > Subject: [PATCH] KVM: arm64: Fix range alignment when walking page tables
> >
> > When walking the page tables at a given level, and if the start
> > address for the range isn't aligned for that level, we propagate
> > the misalignment on each iteration at that level.
> >
> > This results in the walker ignoring a number of entries (depending
> > on the original misalignment) on each subsequent iteration.
> >
> > Properly aligning the address at the before the next iteration
> 
> "at the before the next" ???
> 
> > addresses the issue.
> >
> > Cc: stable@vger.kernel.org
> > Reported-by: Howard Zhang <Howard.Zhang@arm.com>
> > Signed-off-by: Jia He <justin.he@arm.com>
> > Fixes: b1e57de62cfb ("KVM: arm64: Add stand-alone page-table walker
> infrastructure")
> > [maz: rewrite commit message]
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Link: https://lore.kernel.org/r/20210303024225.2591-1-justin.he@arm.com
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 4d177ce1d536..124cd2f93020 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -223,7 +223,7 @@ static inline int __kvm_pgtable_visit(struct
> kvm_pgtable_walk_data *data,
> >  		goto out;
> >
> >  	if (!table) {
> > -		data->addr += kvm_granule_size(level);
> > +		data->addr = ALIGN(data->addr, kvm_granule_size(level));

What if previous data->addr is already aligned with kvm_granule_size(level)?
Hence a deadloop? Am I missing anything else?

--
Cheers,
Justin (Jia He)

> >  		goto out;
> >  	}
> 
> If Jia is happy with it, please feel free to add:
> 
> Acked-by: Will Deacon <will@kernel.org>
> 
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
