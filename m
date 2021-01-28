Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2507DC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 09:56:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A3F364DDA
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 09:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A3F364DDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91D694B1AF;
	Thu, 28 Jan 2021 04:56:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2x71PRuAlw-I; Thu, 28 Jan 2021 04:56:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5335D4B166;
	Thu, 28 Jan 2021 04:56:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F7964B138
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 04:56:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bdpkcC2eH6sj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 04:56:06 -0500 (EST)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 740AA4B121
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 04:56:05 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WEOwVUH+JgT3yJVrEz7LuQ48dnY0FWDWEDHjT5X9Ds=;
 b=VzZ1pqmRnGxHfqwFlozQOerNa16QS/gbKI5LE9+ltzKLIlPo3b5wh/7YkStdCyJ6u+UkS3LHIrbG58P1RNEPlCAV4Gjq26ETxcpBJu8gwuAmb10XGr24Pv5bOSOm/CyhoewZc2eZkQkCYobeFvKzObXwDLrCOSxDe1pYSv1scXM=
Received: from AM6P193CA0051.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::28)
 by DB7PR08MB3881.eurprd08.prod.outlook.com (2603:10a6:10:77::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Thu, 28 Jan
 2021 09:55:54 +0000
Received: from VE1EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8e:cafe::ad) by AM6P193CA0051.outlook.office365.com
 (2603:10a6:209:8e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend
 Transport; Thu, 28 Jan 2021 09:55:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT013.mail.protection.outlook.com (10.152.19.37) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11 via Frontend Transport; Thu, 28 Jan 2021 09:55:52 +0000
Received: ("Tessian outbound 2b57fdd78668:v71");
 Thu, 28 Jan 2021 09:55:52 +0000
X-CR-MTA-TID: 64aa7808
Received: from 174162dd13a9.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 D3797BBC-C1C2-426A-8B1C-932E8FD23FC4.1; 
 Thu, 28 Jan 2021 09:55:47 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 174162dd13a9.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Thu, 28 Jan 2021 09:55:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZE1V6IebTaTyoSh0MR4rYC53pC0Xs53GpgiEbEh86GmyLIpF84CDSEirLtSlRDRgrokmQx9q9IgBEL9efQFAipb8KEISt7hzSwvexM8FCNdJTatoxhf3+UYxaIydW4yfx/0HGXQlOucQ0F73NZtji/rXfQo2JulXH3DkWL+PUbix9VafF9K2AE/ytnWjEyYM1t1wfzD5Wnfkn9ECvSAbCOdrr0fXzohFji0e04ql+aOrwS8bkJMMP3xMKGJEq8acDScRGkerQ8mDkNfC0nyAqX4PWY7oFZTuZEZkR8ZZ+0kC3fjUQD/DbrTWcKyh551Wf9YUhv0iZuWT3Om+aX3pnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WEOwVUH+JgT3yJVrEz7LuQ48dnY0FWDWEDHjT5X9Ds=;
 b=U40v1BPvn3oFV/YCjtY+A9JaMmzwMUwOZrVmSkFRnUakAqwu1u/KTHOGT0hair230bkChH0KR0iVGBm1uyvUJzSBOl/Ja0kbi46QbDsVdb4///vlcOSO9+nKgDU4aK1FRAURFpv3ga4E4lKVmZrxf5iwHGLLq46RCDmfHpQIpmiXjJUcXdMRZW406rUwl0eaz36BWKbsvBuEf775m3edl0bS8OeTh6rURStAkG+OeSf/kY/nvtTaRAWDXzmDP8nCh1ZD+3TKbw43IE/kQ/IORPUKIZd7/m7Jq3/utY0VzmLtax6zePHe1zPl/ZbJXahW4jXGHb/GMvAx9iowqyTAXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WEOwVUH+JgT3yJVrEz7LuQ48dnY0FWDWEDHjT5X9Ds=;
 b=VzZ1pqmRnGxHfqwFlozQOerNa16QS/gbKI5LE9+ltzKLIlPo3b5wh/7YkStdCyJ6u+UkS3LHIrbG58P1RNEPlCAV4Gjq26ETxcpBJu8gwuAmb10XGr24Pv5bOSOm/CyhoewZc2eZkQkCYobeFvKzObXwDLrCOSxDe1pYSv1scXM=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VI1PR08MB5456.eurprd08.prod.outlook.com (2603:10a6:803:12d::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 28 Jan
 2021 09:55:44 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::11f1:cc3d:cb34:b3f1]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::11f1:cc3d:cb34:b3f1%4]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 09:55:44 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Topic: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Index: AQHW6yEqdqBYWsMmd0S229FS8rLcnqooiq0AgA+gwQCAAYaYAIACtleQgABrTICAAAFoUA==
Date: Thu, 28 Jan 2021 09:55:43 +0000
Message-ID: <VE1PR08MB476658E8559DDA76EFC89D93F4BA9@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20210115093028.6504-1-jianyong.wu@arm.com>
 <6f5a2ce458e33f879635f45140293517@kernel.org>
 <VE1PR08MB4766C767F3ACB3D774B4EFE8F4BC0@VE1PR08MB4766.eurprd08.prod.outlook.com>
 <73b606d9c49e05435113a40a534af133@kernel.org>
 <VE1PR08MB47665F987B86F85454434377F4BA9@VE1PR08MB4766.eurprd08.prod.outlook.com>
 <f11a46325548ad5b93e24f4cfdb22d65@kernel.org>
In-Reply-To: <f11a46325548ad5b93e24f4cfdb22d65@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 5DE81B770BC23042BF921984445C5897.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c8f5051-07a3-474c-e106-08d8c372e60c
x-ms-traffictypediagnostic: VI1PR08MB5456:|DB7PR08MB3881:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB3881BEDF0CEDBBC201B0FA24F4BA9@DB7PR08MB3881.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:139;OLM:139;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: qBtE1yfZJlK5td0TxJVlH7YP60tXH/HaoxLX1GrNs0XlJ75t40TkdQnJio6K6amnYkV5eq5VZotysgvwibm6HCni18q9ld2iiHuZ1sFqGfHSDw6/19TNknswZBKUimb6hj7hcNvwyujWSRnw2w2gPznKU8/F8Wd4s4KV6sBzh98zUMriYSlOZI4d08aGiuqd3HYiUBUr5mYeTwqOaef+9PmEsNZwLWMBmUqitDPNkRR24LymzD28yaZRIfXlUzl+wLjBj5S1UEXPtaHAaus6Qge/jU2EDN0jzXtbpAku+fdxxi+VUt53KOO42E+JdhWu+SpHdDChR5AbCmSu8LP7NwpddMJUJFkPQqDFCybKDmrMVEWxf/cKja1xUJMXC7Zfe3vzRiS1L/3XHMWF8Ve5E3vHOpS9xsDyGRvUo78uJDAcKd9E8dFxZt5/YCSFb3Zoc4M1zieZAbypifp2bmnzQWwmTrWLUbNhbIDJPp22AmMLQ5EC5jflhcloUEwCK16iVnAGFdQZPd4jRYQXg1BvtQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VE1PR08MB4766.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(53546011)(52536014)(86362001)(8936002)(54906003)(5660300002)(9686003)(316002)(6916009)(8676002)(186003)(76116006)(64756008)(33656002)(4326008)(478600001)(83380400001)(2906002)(66946007)(55016002)(66556008)(7696005)(26005)(66446008)(6506007)(71200400001)(66476007);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JGiKh6Tr3B3u376X+SnzBsrCyOCceP2jqxbmAjG5zGGhx6QGaiM3G+Fgwehc?=
 =?us-ascii?Q?YhPH34VCZDnYWl++P0mnUXfBKQtdXxG3pRD070ZwEf299CUW1VUrKxIQnO4b?=
 =?us-ascii?Q?i9FOirMXJkLaFOLdjn0mq3myqLy9oWVMKjweUyp7V89HJrmfD0iVThKGSZQq?=
 =?us-ascii?Q?DGMnFTizA97nVLLLhxkeZUoRBki2jwt+TChL1anOjcQoavgBBARLlTtGV+br?=
 =?us-ascii?Q?dpjTzw4/NshxxcCftqYYusxvX0bbUsquJjI88hr/Z9U+zE0abVoNXuT2Mfk7?=
 =?us-ascii?Q?MIBwt/PnnmN2UYaMVAdbOgCNjol3+MKt1y+AxuF08lOvkWrL4Wr5YXnaYagP?=
 =?us-ascii?Q?guNkMcivKoWMzlAiNvhGfhtlY02zX8vmvAfkQ5+g+g1lamnawe5RH10nUcp3?=
 =?us-ascii?Q?7+BbgfTQw+m06srBG3D4MMrkgjkmI2Z/BxJe2WraZTZ9pk74biFQafs0p0eY?=
 =?us-ascii?Q?KZvwm5rBckAHpkOgFHo9Kkwy1KwDBCZzVw4nV/p9FTip7suzMeaYOFXIqpii?=
 =?us-ascii?Q?fZHT46n/awZX1s1rmF9lb8KnM3sbEWSFT18DFgv03zqj39YHMhA6DYqJYXa9?=
 =?us-ascii?Q?MJs6KdFca3O2KZ1dNlASc9HYExYCvoqu07Vu9jTVqGmATnbsWvzky+8wmoMv?=
 =?us-ascii?Q?JyiStIIwR1HoGYilgEdyRXtnRCLMdul/YejHMfGuGLd2hDl9FiYF1riZ+MjS?=
 =?us-ascii?Q?dBqG2Gh6RTbxgab1Gqk72cHSvNNkqaZ1KhFc+TrDLhTrKfHcESe4E3dW2KV2?=
 =?us-ascii?Q?KBrAk1GDRNIuhQHKTSqF5UPbzugk9CAom3gn4au7QCGqe4/SAQuxnPmeYjDI?=
 =?us-ascii?Q?iAUuYnVIUf80ZSmiE6BEkO76IyGRGMJxhVs3FqvdtPd9mLpcRppcmnJiGhKb?=
 =?us-ascii?Q?mhATFcL9seY8Xh72dlOvXXaBcSpV9pjFKXIfIjWy6AoFgOBAX2Hx4lK3+Pso?=
 =?us-ascii?Q?troHlKB51sIHzfxLeV4MOnZhr5cc0oXg+x5s94vK95LjoxBD+1ZVompVvQQ8?=
 =?us-ascii?Q?5I+h7X6T//Azi7Jyg/Q8c40szBiVE7Kl9koLIqHoo6/OBFA++dL40ZghF52r?=
 =?us-ascii?Q?aZ5uKCQ4?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5456
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 848a550b-fbdb-4b73-bf62-08d8c372e101
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9bvz6TFhFCKA7VOghiaQGrdiTzas9/OAmfnunDBY4tLpCX+joyIeTYU19WauBNpIod+Mq2POx/h0799h8R+5fRk2IMYHhozOp3fd9j69UpC/SiNn84wz9sgew68JnVUNHyz3dnH+g+EPSnzWhTJUDny9ICkNz2l4YNilXyayjgqSvmKB8apHpwxwCECslEMBpIqpx3vGmmLZVAw+YxaXwIQEhHOPZJweqt72BIw4DQ1HWjV1SfcMtHvoZRY2IkA7FdeYNoHAW8Utd5gFKS2RmkZ3PuAQaw6Be67sJUi9S08zdq5yEEZesB1OREw1SRb2tnWQqRKGhO+qxWgNJzz29wCU2zG9teEkVjIVJA4P1FUMeewVOhZneGYNI6aLPep0M6nxa+7EIidN/LgKiQFS7Du2ULMZ2e0UoPjF3TbwrciVzy9evgJQxH9fj5gytq+j+28d6SebEvXYd/5rqk3+4qRzCydUNdj1mDLlxIkO0zerZzyKNaxIVAQAwGNYw0+ev/MyrPoRJcl4dWNeEOtwzzkidaGEChHU9Ij/spbkizUOWfs/Yz/ppMAHVhkFOmWlg+6Vz7W+v6uQzhuInD7Q+Qg07czYlaYml6JpqJ+Uxs=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966006)(6862004)(47076005)(81166007)(8936002)(33656002)(4326008)(5660300002)(52536014)(86362001)(70206006)(54906003)(7696005)(478600001)(70586007)(26005)(9686003)(2906002)(53546011)(83380400001)(55016002)(316002)(356005)(336012)(6506007)(186003)(82310400003)(82740400003)(8676002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 09:55:52.4537 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8f5051-07a3-474c-e106-08d8c372e60c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3881
Cc: Justin He <Justin.He@arm.com>, nd <nd@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Thursday, January 28, 2021 5:07 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: James Morse <James.Morse@arm.com>; will@kernel.org; Suzuki
> Poulose <Suzuki.Poulose@arm.com>; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; Steve Capper <Steve.Capper@arm.com>;
> Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH] arm64/kvm: correct the error report in
> kvm_handle_guest_abort
> 
> On 2021-01-28 03:01, Jianyong Wu wrote:
> > Hi Marc,
> >
> >>
> >>  From 8f2a919d6f13d36445974794c76821fbb6b40f88 Mon Sep 17 00:00:00
> >> 2001
> >>  From: Marc Zyngier <maz@kernel.org>
> >> Date: Sat, 16 Jan 2021 10:53:21 +0000
> >> Subject: [PATCH] CMO on RO memslot
> >>
> >> Signed-off-by: Marc Zyngier <maz@kernel.org>
> >> ---
> >>   arch/arm64/kvm/mmu.c | 51
> +++++++++++++++++++++++++++++++++----
> >> -------
> >>   1 file changed, 39 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c index
> >> 7d2257cc5438..3c176b5b0a28 100644
> >> --- a/arch/arm64/kvm/mmu.c
> >> +++ b/arch/arm64/kvm/mmu.c
> >> @@ -760,7 +760,15 @@ static int user_mem_abort(struct kvm_vcpu
> *vcpu,
> >> phys_addr_t fault_ipa,
> >>   	struct kvm_pgtable *pgt;
> >>
> >>   	fault_granule = 1UL <<
> >> ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
> >> -	write_fault = kvm_is_write_fault(vcpu);
> >> +	/*
> >> +	 * Treat translation faults on CMOs as read faults. Should
> >> +	 * this further generate a permission fault, it will be caught
> >> +	 * in kvm_handle_guest_abort(), with prejudice...
> >> +	 */
> >> +	if (fault_status == FSC_FAULT && kvm_vcpu_dabt_is_cm(vcpu))
> >> +		write_fault = false;
> >> +	else
> >> +		write_fault = kvm_is_write_fault(vcpu);
> >>   	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> >>   	VM_BUG_ON(write_fault && exec_fault);
> >>
> >> @@ -1013,19 +1021,37 @@ int kvm_handle_guest_abort(struct
> kvm_vcpu
> >> *vcpu)
> >>   		}
> >>
> >>   		/*
> >> -		 * Check for a cache maintenance operation. Since we
> >> -		 * ended-up here, we know it is outside of any memory
> >> -		 * slot. But we can't find out if that is for a device,
> >> -		 * or if the guest is just being stupid. The only thing
> >> -		 * we know for sure is that this range cannot be cached.
> >> +		 * Check for a cache maintenance operation. Two cases:
> >> +		 *
> >> +		 * - It is outside of any memory slot. But we can't find out
> >> +		 *   if that is for a device, or if the guest is just being
> >> +		 *   stupid. The only thing we know for sure is that this
> >> +		 *   range cannot be cached.  So let's assume that the guest
> >> +		 *   is just being cautious, and skip the instruction.
> >> +		 *
> >> +		 * - Otherwise, check whether this is a permission fault.
> >> +		 *   If so, that's a DC IVAC on a R/O memslot, which is a
> >> +		 *   pretty bad idea, and we tell the guest so.
> >>   		 *
> >> -		 * So let's assume that the guest is just being
> >> -		 * cautious, and skip the instruction.
> >> +		 * - If this wasn't a permission fault, pass it along for
> >> +                 *   further handling (including faulting the page in
> >> if it
> >> +                 *   was a translation fault).
> >>   		 */
> >> -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
> >> {
> >> -			kvm_incr_pc(vcpu);
> >> -			ret = 1;
> >> -			goto out_unlock;
> >> +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> >> +			if (kvm_is_error_hva(hva)) {
> >> +				kvm_incr_pc(vcpu);
> >> +				ret = 1;
> >> +				goto out_unlock;
> >> +			}
> >> +
> >> +			if (fault_status == FSC_PERM) {
> >> +				/* DC IVAC on a R/O memslot */
> >> +				kvm_inject_dabt(vcpu,
> >> kvm_vcpu_get_hfar(vcpu));
> >
> > One question:
> > In general, the "DC" ops show up very early in guest. So what if the
> > guest do this before interrupt initialization? If so, the guest may
> > stuck here.
> 
> I don't understand your question. Do you mean "what if the guest does this
> without being able to handle an exception"?
> 
> If that's your question, then the answer is "don't do that".
> The architecture is clear that DC IVAC needs write permission, and will result
> in an abort being delivered if there is no writable mapping (and there can't be,
> the memslot is R/O).
> 
> DC CIVAC doesn't have that requirement, and will not generate an exception.
> 

OK, get it.
I have tested the patch above using my test case. It works well for "dc civac" and for "dc ivac" , a "Synchronous External Abort" occurs in guest as expected.

Thanks
Jianyong

> Thanks,
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
