Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09096C433E6
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 15:17:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D7DD64EFC
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 15:17:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D7DD64EFC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B06D94B679;
	Wed, 17 Mar 2021 11:17:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lgFMeIgcbGBY; Wed, 17 Mar 2021 11:17:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B2134B683;
	Wed, 17 Mar 2021 11:17:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BC614B676
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:57:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VBr4sternsPc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 10:57:32 -0400 (EDT)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05on2076.outbound.protection.outlook.com [40.107.21.76])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 046324B670
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:57:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egX6TzQiWS5v06oPwfCFDc1fmLhn5G7VI4GOgWJnJwA=;
 b=H8Bpr03rzURON4XfDZDqks9BJsADMVMvmma9zk3OiI04L5bschJHAcr6+gpVPBLPbxKNse1UGWU4Pq+uwAZxrN6eUcLYRQTU/oLtccOwiRV0ypig+xSWSdvNKk69jFTlQNi520+LTLQ0wA5ZS2xbG/qK12jTfNHv6HudxGEkhvg=
Received: from MR2P264CA0101.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::17)
 by AM9PR08MB6100.eurprd08.prod.outlook.com (2603:10a6:20b:287::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 14:57:29 +0000
Received: from VE1EUR03FT046.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:33:cafe::2a) by MR2P264CA0101.outlook.office365.com
 (2603:10a6:500:33::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 14:57:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT046.mail.protection.outlook.com (10.152.19.226) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 17 Mar 2021 14:57:28 +0000
Received: ("Tessian outbound 04b74cf98e3c:v87");
 Wed, 17 Mar 2021 14:57:28 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 51b1e4f84e977f0b
X-CR-MTA-TID: 64aa7808
Received: from 8128cb3dfe86.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 8C25A7F7-4771-476A-8C75-F47CAEC6304E.1; 
 Wed, 17 Mar 2021 14:57:17 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8128cb3dfe86.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 17 Mar 2021 14:57:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUCf18NgyJLnA86VWIx04w/USDInRfoSx7E2qFu/6dibytDFAbZNPIW1TsV2b+0NsR3ffFbFPNw+DV2X/RYNK/Sr91f0ohvzjKBWAwwirOw80Y9GiGvIl7Hx/uZq3xnn1Xc2/PMOFTs6XZnP+d1sRghWrAqQiS8ulXUEJsj/dtujeqDuFbYwZNw1AP42v9NEFvhq9kRYcbogKNN/uXQsMajXMnBF3lA6hqtKDf8QPA0cYr8wUM5/XNBvIHOlPNC6BwYsyOvSTGZ073g1r4J8lLdtofT+YkxsSCqZChyoeAIohdHv5O0bd/uF/D6T/BXfIOYGvLvCDT9Q8aVioTPhWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egX6TzQiWS5v06oPwfCFDc1fmLhn5G7VI4GOgWJnJwA=;
 b=Gx5XA+9cglk4sbmD4dxIPtwSxjhoSbin/E99El8qjk63kQ9a94caD5szIkMwRumbID8ec9ElayrNEWab0p6oFnSOex4miYx4Ds/zOucvM60IuXZjQ6hTOJFjYUAXhSnRJgkixZNXqMg29Q1tnrsjmuHniWxhJbvsKbozKxJNH4MGBtLayF5UENd3gE4jtWPsumgVdYhqA5QSGPaJFJWORT3pIsYt9Q+Zt67vzqYa5RaRTEz0vJY44VKYqPgR8BQe8B1iTkv59Z7QHXTZynVmR9sU7mEa9wuEarXb07mY6rBkE7TpuATJVKG/4TGTDqdmkGjKiclpEicymvx2IZQpcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egX6TzQiWS5v06oPwfCFDc1fmLhn5G7VI4GOgWJnJwA=;
 b=H8Bpr03rzURON4XfDZDqks9BJsADMVMvmma9zk3OiI04L5bschJHAcr6+gpVPBLPbxKNse1UGWU4Pq+uwAZxrN6eUcLYRQTU/oLtccOwiRV0ypig+xSWSdvNKk69jFTlQNi520+LTLQ0wA5ZS2xbG/qK12jTfNHv6HudxGEkhvg=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com (2603:10a6:803:7f::19)
 by VI1PR08MB3856.eurprd08.prod.outlook.com (2603:10a6:803:c4::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 14:57:14 +0000
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::d032:5b3f:97cc:6c4f]) by VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::d032:5b3f:97cc:6c4f%7]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 14:57:14 +0000
Subject: Re: [PATCH v5 33/36] KVM: arm64: Wrap the host with a stage 2
To: Quentin Perret <qperret@google.com>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-34-qperret@google.com>
 <ec9df9a4-a419-089c-469f-1a1509597dd9@arm.com> <YFCqYT3Ib8kAN7/c@google.com>
 <YFDAyhjPEsnZ4N3P@google.com> <eb70a071-4d4a-885f-36a7-3b20358e5513@arm.com>
 <YFDvAqgimPvpgiwQ@google.com> <da9e7839-6d12-c69d-9f23-a091219e1da8@arm.com>
 <YFHFkaKZyAEheWZV@google.com>
From: Mate Toth-Pal <mate.toth-pal@arm.com>
Message-ID: <a76ebcf8-7367-0567-e624-11a098a08b5c@arm.com>
Date: Wed, 17 Mar 2021 15:57:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YFHFkaKZyAEheWZV@google.com>
Content-Language: en-US
X-Originating-IP: [188.142.195.117]
X-ClientProxiedBy: LNXP265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::22) To VI1PR08MB3568.eurprd08.prod.outlook.com
 (2603:10a6:803:7f::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.45] (188.142.195.117) by
 LNXP265CA0010.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32 via Frontend Transport; Wed, 17 Mar 2021 14:57:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc24e351-1e02-439b-121b-08d8e954fc32
X-MS-TrafficTypeDiagnostic: VI1PR08MB3856:|AM9PR08MB6100:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB610075C49C54C47019B1008DAF6A9@AM9PR08MB6100.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: KUzQCqXmigorUhaTql5y7WHPbww0rrycAVUzB/ASqiFzIGCcp8NZvoXVaeR2PUHpH5O8tvB7Ssf4X1SeQmaPp95s35bdUJqL1CcDAXpmmAWscTqdVq7JexbtAFkQ2miWy6a7OilJpNpwOVDK1qnnmvyuf6LeQPSZHCXbKoXud4OWpFLfBf+bvJ394FU0Sy6PzOqdvloQ8FexJWHa/E2TEAOuSNsL9M0+eiAdZzDO6I5M5BYXpbuqUtq7whuMlhYUX/r1+Vu4J3QEeAzz6e43qm6ReZecQnD5GHVXoOlQHK7No07xeUpx4CHqAhTnmDaUO5rxkqr5bCSkRLBqdERr8LgJ4VYX0PD5Pl9nonyU2xRaTic9/yXKtPKVFtg41hWOs5n01NGcL1KZ5LW7NKFSX5WHTQhvZD7UyqFOfr8RlR6rm9rpM58vQvb/wluwtUZKMBiJDxU31/AVu+3J89TZFDf57wg5xTESAAb/7D9djBxSe+fNpof5WUsrlW2x7yFoueP1Ch8Z1hyB+zIr2Dgbv130JYE6r9sO/DC4qI6j3xst+Xn4p9Ts+V4SCG35AU3mVopY5HoVwb3QlN/KIk7texSJUj2aNoNrpdigu83bD2idYrh0X0csPtl+XaY7jHq+vlEbdkY920baTZiAb9DsmaLgH7kEm4g0yCm6lZbvuS+nYXQO68FiDxJRTqyvh4wNWImu73Y6A1THVzSeQ5rmTpuxQuOhCCdt5t4QkURl7JU=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VI1PR08MB3568.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(966005)(478600001)(956004)(55236004)(6916009)(316002)(53546011)(66476007)(6486002)(8936002)(16526019)(7416002)(2906002)(186003)(4326008)(2616005)(8676002)(36756003)(16576012)(5660300002)(31696002)(26005)(66556008)(86362001)(66946007)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TmtPRm5Mb3kvUUtjZWF4TXpVc2hkZ0w4TU9JMStTQ20weUVIM0NrSmNjdE1G?=
 =?utf-8?B?b2xxd2U0cmRuM0dJS2llUkVIR1RCbFBMYm1QRXdaWmFGNVJydXFUdlR0Sm5H?=
 =?utf-8?B?RlUwbHg3cVd3RllrSTlDdWZYMkVET3JYNW1PbHhzWEJneDE5bFJsdlZPRGJx?=
 =?utf-8?B?WDRYd3FEcHErbXhQNnNHTWRhdU1EZGdvZEhoTjBKNEEwZTZKOTc3OVpFWkVC?=
 =?utf-8?B?ODlMa3BzMWNoSnE5NWFTVGlkSzZUaXBPS3NlMkJzam5MWUdVSHRNTEMvMmxm?=
 =?utf-8?B?R2tBc1RvZ1J4ZWYwWXg0bnVDMzAxeVAwWXorNXVScTM2VVFSVk1KVjAwekcx?=
 =?utf-8?B?VmZMNERNZC96aDREUDZuQjhYbnBySkZQRnczaXRBd1poYmZSQlc0ekFLekhF?=
 =?utf-8?B?N2VaYS9udC9IYnpaTElYYjFvZ212S25HZE5QdGNTQmpKUlRGT3dxcndnNW5N?=
 =?utf-8?B?amNVeGR2akpta29sM2IrWXhJMXUyYVprYldZb3JaVk5XdWMxM3hTV25XVnA4?=
 =?utf-8?B?eDdLMEhRUUU3cmV3WGZ6QVRKY2lDZnF5UFY1cURxell2ckhCYXdTemJzTFNH?=
 =?utf-8?B?ZXhQZkZxUkptZm9NeFRtZmRGdjVnZG1GMDdYa3VzQ2s4d0xlWlF2MmwzRWJ6?=
 =?utf-8?B?VEhLQ2pIZzZCeFRlV0Y5NE1wd1o4ZGdwYjVXUllWY2dEYStGS2JDKzBXLzRC?=
 =?utf-8?B?eVdESm1XRG5LeWFpVC9NcHpmejJCUkxoN2RyR0lTUHNMZVd5NGVGY2hYODI5?=
 =?utf-8?B?ZmVUSjdlNFJGMWFIajVtbyszSEIrYndkR0R4NTdaVDNNQVE2UlZORC9kejNO?=
 =?utf-8?B?Y3h4NS9vUDhzclVTbnhOQTBRNFNDc0xGSkZiTEt3c3FOYUFyZWh6cWFVK1Np?=
 =?utf-8?B?dTNSaWNtd01aYnYrVWV2dHB3OVNabEIvQStOaWpPc2dCWDNyRVlGTWZjQVNa?=
 =?utf-8?B?Q0RWSDBzZVVwR3ZYSXoySWZMQWlXRlpHTEhJaU52MS9jbEJ4TDNiT25TM0lz?=
 =?utf-8?B?UWxiK2hGdVBoZGR4WmdHZUxFNGpPbk1zTWpGV2RhSnltcmdqK0gycGVmY01j?=
 =?utf-8?B?WjRHSXlZcks2NmxaUVFxVTN1STBhTEh0cWc4SC9xQlh4LzRXcmRsaDQ3dVBx?=
 =?utf-8?B?M0JHbDhUVCtFczdTZG9qdEdjUnVOVlJ6WUR0aW42QkhockUyWE9SNVhWT2tW?=
 =?utf-8?B?TFVucFE0eVNDU21pRjhOVk03SWpNakg2ZVBOK3hsWTI4SDBEODRQMWFIV05V?=
 =?utf-8?B?NFVCT2wzUnJDWDR5SG00TWhiL05tRHBGcUp2Yi9Iai9vMTdHbGZ1OFVPWVF0?=
 =?utf-8?B?ZTZ2V3pmbDVIbGo4SlJGR1pNbW9YdjBtQU9MRXB5U3Y2OXpnTjJLZU9qNGov?=
 =?utf-8?B?N3piSWZrbzJRVUlpSms1SkV1cHdRZXM4QlB4b0FJdDYrMmlLZ09wMkJBdUtQ?=
 =?utf-8?B?SkNyQ1UvOWVHUlZzaG5BcFdCNU16THFHTGhYR2tmaUJxL3ljUlNUWEljdDN4?=
 =?utf-8?B?YXhGcWpuWHlReUkzdTl2bmpUcFNFVDA4RjVGUXVkeEJ4RW9aNm4wSjBLanpF?=
 =?utf-8?B?MVY2VGdlRFpaVlNicjFWaU1DQ25oK2xUNEw3andTb0FOc2FmcWJMUG5lQUxx?=
 =?utf-8?B?eXd2SUFnUE50RUhqU2FKa2JFTGdjeW81THIzSlBOOEJFL0VMblJtRnNoNTVW?=
 =?utf-8?B?ZVZiRUZoZWFRQ0k0WDBIdHJGRVFITUV2MWVNZlhwcHViYVRFekgvSVNpZFFw?=
 =?utf-8?Q?vthq6qODpGuOTjSbZ8gEcutwdIntNGKHsqebz1y?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3856
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT046.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 7eeda0c1-f718-4082-ed6b-08d8e954f310
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RoNSJfYSXnXW2MOdBpBRSjEbpthGKQML26/FcQ4aAtSyiHEISz719oGgJ43WqyqhyIPHwVhPAivOoilgF+OpNLffnZjxaVH51TquTY/ieHJFMzqaQlN0wI2vTsXzm76lQqoOLrTPdBstLSXha6X8tgX9T6+jlcAcEkjykDQtQ8RqcWsBoGxyjUY5ROAQTP1JfISBfYcbegy4M3nsf0dj5OMVNYSw2rRBqxOSTDnQWKMcBBV8KSTny4MvhME85r2NP5ftGVhQnuvK6aWlIO8wyVrp++qqTQ/Fk73lhs+mf3e7FLCADl058Ed4eTM9F3lBkt5ceLZm0uO4+a1b7ntaxVQPmQx4PY1IzyXg7COx832TZwAbP6mfnexdcY3S+RVIcveIluc7qTBuBVeQ1xsJFEJ3c425GHfrb9CitAIl/kul6rQSVP+ZJ3jblB3i9zvhSVv2LCYPOXlzjY7oFBVjyEHgb6dMRDmzgkYDHEUydnSM5we6oNT6te2gw3PhwAOuyqTxSlC2KyRABG9/rdudvDbLaxV1eMJ7FJhsOZgadknIXAng7XKQgYO7ka5A1yPkU0NFs3YVPEkQPMuShmgn674+r3G2OQXwLeHPiG06x7z+nvI1RPmGQtvluhaDdevfhrc912c76msR1DmjGma04dEmqQQptHpzKPvX3rRS/rgBDNQOJj8t3o1UGn+lldN1HxHStsR/XifyP4apV9qz7VE//hW4TU+s0Wy3JUsz6rfxlbtSMn1wnu47p2fAorgsOp5LEf+1TtesvHOrMVtjJw==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(36840700001)(46966006)(8676002)(82740400003)(336012)(82310400003)(26005)(70586007)(55236004)(2616005)(31686004)(31696002)(956004)(16576012)(478600001)(8936002)(966005)(36860700001)(2906002)(36756003)(5660300002)(356005)(16526019)(6862004)(86362001)(70206006)(53546011)(186003)(6486002)(316002)(81166007)(4326008)(47076005)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 14:57:28.9270 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc24e351-1e02-439b-121b-08d8e954fc32
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT046.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6100
X-Mailman-Approved-At: Wed, 17 Mar 2021 11:17:47 -0400
Cc: nd@arm.com, kernel-team@android.com, android-kvm@google.com,
 catalin.marinas@arm.com, seanjc@google.com, tabba@google.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-03-17 10:02, Quentin Perret wrote:
> On Wednesday 17 Mar 2021 at 09:41:09 (+0100), Mate Toth-Pal wrote:
>> On 2021-03-16 18:46, Quentin Perret wrote:
>>> On Tuesday 16 Mar 2021 at 16:16:18 (+0100), Mate Toth-Pal wrote:
>>>> On 2021-03-16 15:29, Quentin Perret wrote:
>>>>> On Tuesday 16 Mar 2021 at 12:53:53 (+0000), Quentin Perret wrote:
>>>>>> On Tuesday 16 Mar 2021 at 13:28:42 (+0100), Mate Toth-Pal wrote:
>>>>>>> Changing the value of MT_S2_FWB_NORMAL to 7 would change this behavior, and
>>>>>>> the resulting memory type would be device.
>>>>>>
>>>>>> Sounds like the correct fix here -- see below.
>>>>>
>>>>> Just to clarify this, I meant this should be the configuration for the
>>>>> host stage-2. We'll want to keep the existing behaviour for guests I
>>>>> believe.
>>>>
>>>> I Agree.
>>>
>>> OK, so the below seems to boot on my non-FWB-capable hardware and should
>>> fix the issue. Could you by any chance give it a spin?
>>>
>>
>> Sure, I can give it a go. I was trying to apply the patch on top of https://android-kvm.googlesource.com/linux/+/refs/heads/qperret/host-stage2-v5
>> but it seems that your base is significantly different. Can you give some
>> hints what should I use as base?
> 
> Oh interesting, it _should_ apply on v5. I just pushed a branch with
> everything applied if that helps:
> 
>    https://android-kvm.googlesource.com/linux qperret/wip/fix-fwb-host-stage2
> 
> Thanks again!
> Quentin
> 

Sorry, it was my mistake. I must have messed up my source, because the 
patch should really have applied on the v5 patchset.

So I was able to boot the kernel from the branch 
qperret/wip/fix-fwb-host-stage2 on the machine I was testing, so the fix 
looks to be OK.

Thanks,
Mate
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
