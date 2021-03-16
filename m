Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82DEC433E9
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 21:35:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4768464F77
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 21:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4768464F77
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD6244B4EA;
	Tue, 16 Mar 2021 17:35:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4UCkOKiEdSDw; Tue, 16 Mar 2021 17:35:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF6E4B576;
	Tue, 16 Mar 2021 17:35:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48B8F4B4FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 11:16:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SXNX2gAxCnWL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 11:16:48 -0400 (EDT)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2047.outbound.protection.outlook.com [40.107.22.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75BB64B4FB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 11:16:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m76hduhZsbCR9s/riWDP8mZNe+vGphT9eQjcCsrNeuw=;
 b=9OmNo8/A35HMq+uVXWuwv5lTms3hqs2m318erSVI34tjhjde+2S2S0Ix506kiFdulOP3jrUxT+YidWlUCnNmv2v9AB+xDq07ZUL2kBC5lKBRGUqNTeF6YmG/LJWGCWQKuu5x0aBT5b6g7HmiHtrZMuACCj1biZ11HJpOCh8C9P8=
Received: from AM5PR1001CA0066.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::43) by VI1PR08MB4352.eurprd08.prod.outlook.com
 (2603:10a6:803:f1::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 15:16:43 +0000
Received: from AM5EUR03FT020.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:15:cafe::9c) by AM5PR1001CA0066.outlook.office365.com
 (2603:10a6:206:15::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 15:16:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT020.mail.protection.outlook.com (10.152.16.116) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.30 via Frontend Transport; Tue, 16 Mar 2021 15:16:42 +0000
Received: ("Tessian outbound de94f9ae513a:v87");
 Tue, 16 Mar 2021 15:16:41 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 25bdad550c67f67e
X-CR-MTA-TID: 64aa7808
Received: from d4c78d0f6cda.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 95DA7F17-8902-4602-A78E-76A60B50720B.1; 
 Tue, 16 Mar 2021 15:16:25 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d4c78d0f6cda.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 16 Mar 2021 15:16:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Byh2L+QoCoQLrhEgfKh8DH3RX+H9/xW3eH/7ahzIVsjSGNCBy7Bj4Yflio9vtNHedb3RrMPuIwFpG5itCZYkoXQ/Sv2VMhJ+FLWwb5lpJCiGRTKBGZCOOTO2WyJUXF8QV+mI1pHB5OBIQn/pwMTxaLp+fo6lelrHxA3GhNNw3dWwJ5KwNPNEiHdd9vt+oqDreVuNXKgkv19Dbljt+CmHhI2HaQxTbQWXrAkuM8kd5Xzy8pOihuwJknIHABxJSiJcFqfMy36aJ+H0TyekM/t6k28THnhFT+Sd0G84aGx1BJH50cL67xTS4UuAzWG7OgYVfGda7yZv1/eZxj+mb4Q1TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m76hduhZsbCR9s/riWDP8mZNe+vGphT9eQjcCsrNeuw=;
 b=cDVnHvVlx3jDmV1PkloBaOvIRPtb7CuJ3Tbd3I1WK6JTLiGTuF77TgZHAExiBvmDDYzzK5b+SL7hDSU20l3svsxQruQEESrZOO/ywE32eGt5TnQY6e4OGg4N5TRY7B0344bIxXcSCspGZI2cBMLY6QCA4BxwFhOexTvnei27TxVsaV4GmbJNaR7SbqD/kzAjwfddHGfntSBAuvesngyOICJ+EHZUYHro6SQtT+oc2qfrOkkWnQnINnaRFkWtHlh5QHodOJTmyCh76aUWBbi9yF7ngj67O5voeE3nEdSRWx4uxNlDX0cxLRiuwO0VcITclo/fISEW//VDeEI51u5FTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m76hduhZsbCR9s/riWDP8mZNe+vGphT9eQjcCsrNeuw=;
 b=9OmNo8/A35HMq+uVXWuwv5lTms3hqs2m318erSVI34tjhjde+2S2S0Ix506kiFdulOP3jrUxT+YidWlUCnNmv2v9AB+xDq07ZUL2kBC5lKBRGUqNTeF6YmG/LJWGCWQKuu5x0aBT5b6g7HmiHtrZMuACCj1biZ11HJpOCh8C9P8=
Authentication-Results-Original: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com (2603:10a6:803:7f::19)
 by VI1PR08MB5310.eurprd08.prod.outlook.com (2603:10a6:803:135::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 15:16:23 +0000
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::d032:5b3f:97cc:6c4f]) by VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::d032:5b3f:97cc:6c4f%7]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 15:16:23 +0000
Subject: Re: [PATCH v5 33/36] KVM: arm64: Wrap the host with a stage 2
To: Quentin Perret <qperret@google.com>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-34-qperret@google.com>
 <ec9df9a4-a419-089c-469f-1a1509597dd9@arm.com> <YFCqYT3Ib8kAN7/c@google.com>
 <YFDAyhjPEsnZ4N3P@google.com>
From: Mate Toth-Pal <mate.toth-pal@arm.com>
Message-ID: <eb70a071-4d4a-885f-36a7-3b20358e5513@arm.com>
Date: Tue, 16 Mar 2021 16:16:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YFDAyhjPEsnZ4N3P@google.com>
Content-Language: en-US
X-Originating-IP: [188.142.195.117]
X-ClientProxiedBy: LNXP123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::16) To VI1PR08MB3568.eurprd08.prod.outlook.com
 (2603:10a6:803:7f::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.45] (188.142.195.117) by
 LNXP123CA0004.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:d2::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 15:16:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 488d32fe-e98a-40e0-b35b-08d8e88e814a
X-MS-TrafficTypeDiagnostic: VI1PR08MB5310:|VI1PR08MB4352:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB43521799FBD21D701CE05163AF6B9@VI1PR08MB4352.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: buO3ejYubd5Pd94yZNzXlZRp6Kbqto8YmKSWQhlsK4V+7nU9orfSazeHag6ivbBaveiRA+bxbQj0l/unblPckXRasrTN2ZN1ho1/ovEmrXNWaqL+DQDlir6VZJi/qkIbOiYbnqyCyvFPXYdZCIaHj6mRtOKHnnUPRdbBQT5QaY4vXPoQI+6BD56BTSjig4V+QWaKZePQNZWjN4F1a2Wq9nAdT7T9SxgDu7DsbkbEIMKnDmKPfia+TOgJi441VDCtzFdiS69i5P//dIVeM6zj9BJQz27tnIrDh6U0X/318OchoCopK+YzeAOmUaGf9kNjpN2jSJ4BRFoZAJyn7KtfW0efmw4vmU7L1Z+YfHFNf9i9bSJIxJviz3My9tGDefVH5Z8FyfmPyeRw/mQ8FK7Z248Jd0bR/h4hhmWN3Pe7IU4WQF6qZRyAHGSwgm/wEJ0UmVHFyw0vorUgkcRSwVG8za2unxXJJLtxUq+XeMabjJm7Cq1cMdeknIFRNtx4gRiXz6OTXefwKo+m0p4pmNE/4klXthl9TrPlfFxJe63BgPquDDiH3UfRJqEsyC7PUXsKEE0Bo+7WLuXsrU8Dzp0gCSh0jUqI1PDY/DAb4/1p75We7mIEUB9vYmD0sNQJXf+HgsXKj1nhbsXVjG57jMWqOA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VI1PR08MB3568.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(39850400004)(366004)(136003)(376002)(346002)(53546011)(31696002)(6666004)(7416002)(36756003)(6916009)(478600001)(8676002)(66556008)(4326008)(26005)(66946007)(8936002)(66476007)(16576012)(55236004)(6486002)(16526019)(186003)(86362001)(956004)(2906002)(5660300002)(4744005)(31686004)(2616005)(316002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N2d5elRCcVdGRzZOejJPVmowL1oyMUFWdjE3V3JXV0dhSUV0MllHK1pGTEJk?=
 =?utf-8?B?am03OURSOW1qRFB3RnIwY2lNcjhmc2d3SnQvRFk2UkZZS3VVZzZFOFV4bTVT?=
 =?utf-8?B?THpmVjBiT0NUWWZCZHRJYlJjYm5OWGxVRDVmVlplZmkzUy9Qbkc1WkU5QXZm?=
 =?utf-8?B?Ni84Zml0OEZhZ0pHNWh3ejZOQTNDQUpYT2ZVY29vbjBDSi9JeHdkUlJWUmFr?=
 =?utf-8?B?eEdKNjZ2RHRrd3BxWktYcWhMUUd5YTcxMy82TzkrbmdPZVV2azV1ODhKdHZZ?=
 =?utf-8?B?d3h4cWwvMDR3ZjBHbUczR3JSczhkRWtqNHljYWVRSEdiTER6YVRuTXl2UkdF?=
 =?utf-8?B?RTdLd1VZQjBiL0NpaU9iUXdFYi8ybERUYzNjRXVnRUVyMzEyM2Via2ZUQjlp?=
 =?utf-8?B?NW02dGRSNG96VkN6dS8xcWQzbkpVTWtaSlpKdVZnWXpPRkQ3VVFhRVVMalFx?=
 =?utf-8?B?SDlqNWkvdjJFVXl6eVhGNkJQL2xwcmNUU2xORFdUQ21nbXVrdDJMNFRleU1B?=
 =?utf-8?B?bEZrRldRU3kzblVlSFRkL3Vjb2hjaFAwbUt6Z0s1Z1BadktjTjJwZkdMUUJG?=
 =?utf-8?B?a0VCeVVlOCs1NWQycThlcVYzWHNBWTdOUURVQUJYTHA0UUxyWkszcW4yaFlE?=
 =?utf-8?B?WlpibU1FSVVnSmJhQlBnQWY4RUU5UnJuWjhlaW9GWUl2V054MncwY0UrV2RT?=
 =?utf-8?B?UzJpU0FlQVVTcEJ6MCszdEZ4dE5jeVNaTkpienIzTC9uUFArUWVOQkF2TUdQ?=
 =?utf-8?B?YU1FODRJRTcwWmNZMlhaSVdZbkkrU3QvUEQrNmJ5SEZmcUFrNmJyektremJS?=
 =?utf-8?B?dmwrMlZwRmUvVjA2QlJsNzMrMDlMTGZQY0tYbHpnUnVFTkxpSXkwQm8vOTFh?=
 =?utf-8?B?ZGs3dHU3akhFa3ppb1J1Y2pLYWJFeWNDOEMyby9ma3ZVaGJBVmg5aXBNSHcv?=
 =?utf-8?B?WVh6NFc2OHNHdXhIajM2YUFxRnRvMHA5MkdOQ1QydWtWSmNlRVN2ZWt2a0dW?=
 =?utf-8?B?NVd1aGFRV2RDZnVPTjY1MWNJWWJnYnZlVzVlWEtQMTZOS2pJaWkrMlFRME92?=
 =?utf-8?B?ZkZZeGFnTGM3QUd6U1FBQlg0Vm52QUoxWklkdmpqM2hCSDRETGwzbTFxc0xV?=
 =?utf-8?B?OHhia3FEZFlTY0tFUDg2Qjg5QW01Q3pxM1FlR1NaeVZIOTZkSWZPRDJDaUw3?=
 =?utf-8?B?TzkydHFFTWFIcWhaelZwZEh0UDNJVnZGQk1XNlBVM2sxSWplc0J2aldWVXFk?=
 =?utf-8?B?cTNSalR2ZXdITXh3cDRLTFZzdXIyZFNJR2NaQVF3UjN2NXFmSWp3VXBLVXVp?=
 =?utf-8?B?dm54SjdVaDQxcFM3ejJCSXRsTGpaTnRPWGlwODVXb09qeWFGbnZnamk0ajNj?=
 =?utf-8?B?TjlEVlFXUUh4cXVEM3VWUVNVRlZKTXdLNUxNeWx1ZHl2UEtvblhJNkJwdjl5?=
 =?utf-8?B?ZHFDVkRQdXBHYjJnTjVaaE5uTVFlNHNvR3JVS2xXWitTbHB0cFpuVVhWY1h2?=
 =?utf-8?B?cTJ4Zzh0WTJDbmF2RkhlTTkyYXMvbXJ3cjY2Vmc5V0RWWFRaVmZaL0tGMGlB?=
 =?utf-8?B?clI2c0d5MWx1c1ljcUlEZXFyOUo4RkxxQmhMWnZmVG9NUG8yc2V2b1J1a3I0?=
 =?utf-8?B?WWtVeUlYVnVyNGtoeE5iZDhNYjU4T3ZxSkxkRE9BTWE1YkZoUTIxb1pZVFhZ?=
 =?utf-8?B?R256aGtkNGIwNE01L1pLbWVaVVFwSlJZVDMxTkNNZFo5cEpDZFZZazN5alN3?=
 =?utf-8?Q?GhuYKSRgMryhN2c3WlgHeM9gj4tkrI3VlIYP1SG?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5310
Original-Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 120575b6-5dcc-4870-bf99-08d8e88e7565
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yFDFUJnHQlG4eWO5+5u8HCS82eAcPNOK4zNkork9t/8yXGgqjPLkFukITY9NMNsXSdAExxy4kYSEnQFuEZrcSBFtkLabq9ouxDeYrzTJ5vgI6/wzqoydUqmmNJnpphEauU6EYNdz/kfkEPNlwqQJ94esRCmZM4LbIXT7HW/+egEoKvC1VCKxubSqkSeyoiq59AIqX43ByNahyuJzK8Rn+x9NE6IRkYjXEwULyJ8SJ+YVlwBEJSHlWDHKWWZaH5Qz1FdarYtuDe3K/ZQTCqb7UnoexOJP3Bpn/4B4HmAKsA/qZlWfu9izfaeauhZjvfFhS82ToQGOvpRZK6qouQhwx+g73y7h1osEgwk9I+N9ZFBktZ7eKnbAZEleWdUlfqOKCLWLxhFcU33y4XG0eic9lBH0xpykDxb7zvUfUN5WS1Zkvg2Dw/jzft7pJ+Z67rCdIz7cwiCJbl2zBrsNUellBJ7/NJbzjtV2qp7L+5q8sUWLiDYLc59tNmUZ659hI4qDoigPa41wIDRiZO6P97kZeiLoberlTx4h/wHefgnFELtiaZpILiu8NsgSeC6FJeDajhnT5JuDoy8em2ukoPyKuywbMIZSJOcxTjlVKZSp+GMckvajDr5HY6SGNf+la0JUJ1npFjVFUaYyK/LgYhQiakmU7YBWQ0Hax9BTEanslp7QWJimC5NFq9ZcR9t1d0oe
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(396003)(136003)(346002)(39850400004)(376002)(36840700001)(46966006)(6666004)(4744005)(2906002)(8936002)(82740400003)(26005)(55236004)(478600001)(82310400003)(16576012)(36860700001)(8676002)(70586007)(70206006)(31696002)(53546011)(2616005)(4326008)(47076005)(186003)(86362001)(336012)(956004)(16526019)(6862004)(107886003)(31686004)(81166007)(356005)(6486002)(5660300002)(36756003)(316002)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 15:16:42.4462 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 488d32fe-e98a-40e0-b35b-08d8e88e814a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4352
X-Mailman-Approved-At: Tue, 16 Mar 2021 17:35:18 -0400
Cc: kernel-team@android.com, android-kvm@google.com, catalin.marinas@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On 2021-03-16 15:29, Quentin Perret wrote:
> On Tuesday 16 Mar 2021 at 12:53:53 (+0000), Quentin Perret wrote:
>> On Tuesday 16 Mar 2021 at 13:28:42 (+0100), Mate Toth-Pal wrote:
>>> Changing the value of MT_S2_FWB_NORMAL to 7 would change this behavior, and
>>> the resulting memory type would be device.
>>
>> Sounds like the correct fix here -- see below.
> 
> Just to clarify this, I meant this should be the configuration for the
> host stage-2. We'll want to keep the existing behaviour for guests I
> believe.

I Agree.

Thanks,
Mate
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
