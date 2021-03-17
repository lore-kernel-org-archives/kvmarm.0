Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDB5C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 15:17:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1440B64F77
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 15:17:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1440B64F77
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E7A44B681;
	Wed, 17 Mar 2021 11:17:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BmQ3o3WerJqp; Wed, 17 Mar 2021 11:17:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C47C4B67F;
	Wed, 17 Mar 2021 11:17:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2798E4B5FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 04:41:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hIgjEPBunGQW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 04:41:28 -0400 (EDT)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F4674B359
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 04:41:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u62wW1g/M5zIua4uZ5xclTEL81fk4L68Gz6/PHxbTws=;
 b=dXqTzldIG8yCq5kk0nSZFG5dh0R3gGPQcKCXMrZviIxTcES3ZgrR4C3A2vl41S8gYok1m5Db7/kB6uZ26IgtdPxAyP2eEhmugQDa0azyzVjGRjdu07/osMTgdYLlgA73TxeVq7TZ2Csl/RPX6iwJcyK4x5HtmllUaK2gUwXsR8U=
Received: from AM6P193CA0126.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::31)
 by AM6PR08MB4721.eurprd08.prod.outlook.com (2603:10a6:20b:c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Wed, 17 Mar
 2021 08:41:24 +0000
Received: from VE1EUR03FT040.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:85:cafe::16) by AM6P193CA0126.outlook.office365.com
 (2603:10a6:209:85::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 08:41:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT040.mail.protection.outlook.com (10.152.18.210) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 17 Mar 2021 08:41:23 +0000
Received: ("Tessian outbound 04b74cf98e3c:v87");
 Wed, 17 Mar 2021 08:41:23 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 39162f545af93fd8
X-CR-MTA-TID: 64aa7808
Received: from cf69e5f50ca2.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 D941247A-4891-459B-AFB5-0DD90536FB32.1; 
 Wed, 17 Mar 2021 08:41:17 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id cf69e5f50ca2.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 17 Mar 2021 08:41:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUixXjLNv2OBdQnJOliKJXx1WNXkuEMfXpny3VuyG8YuP290EPNi0R0CR+Tu0tL7tRNUJWm10ji80XVP7ZraolmkFDB7lP88j/z66EiwZm2En17imT2hBt879nIkFahx33vKwwhkmMKSBUM2xHBqGLAKr6H7dvZ3h4eoHlNlojJ8D4fHgnKESssI3XdZb4TM+o+wYTYA3I3ECZ6s+fjJqJv7pPK2GEaRyc5kiVKM3MvpgcTUHudTwCQF3uJv9pVfbLMU+ZD9HvY9KYMMEmz7vlntsy3ncgZCT/A9DPwdyeNCNCLNMQrl2Z/yq7YCLGzwnQS5IlB6AsmxdeklvhWT7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u62wW1g/M5zIua4uZ5xclTEL81fk4L68Gz6/PHxbTws=;
 b=T7NNOgBy4E9DlLkxVL6ZySG84ghmm3X/e+msUF+yaFrqwvo1s1v3eEMEd6i4FK+WI902zkmLpNYGX8LYFgYovux9616DG0IjxUr3/XLInNSuBP1BwqMru7kkgtCNuRAvq7w1qkmlTOuM0Adz88lcpsFNO2EVi1WmFBDr/QvJ9Vmx0Pdwz7ZBJdE8+vlrynbWAJBAmIgtMiSO2QFmrBWwxc+CNK6DpJXQXwT9mFAxmWFUQmJH2Iqe+8ZfqUPJh5w+SaPimd9Ti7Z/09unC8oABxZsNgl3qYfkeQukF52egx9KFrYHcMje/BZyrSLDoI1mcKCZmc/9ceze0KXuXQT1Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u62wW1g/M5zIua4uZ5xclTEL81fk4L68Gz6/PHxbTws=;
 b=dXqTzldIG8yCq5kk0nSZFG5dh0R3gGPQcKCXMrZviIxTcES3ZgrR4C3A2vl41S8gYok1m5Db7/kB6uZ26IgtdPxAyP2eEhmugQDa0azyzVjGRjdu07/osMTgdYLlgA73TxeVq7TZ2Csl/RPX6iwJcyK4x5HtmllUaK2gUwXsR8U=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com (2603:10a6:803:7f::19)
 by VE1PR08MB5632.eurprd08.prod.outlook.com (2603:10a6:800:1b3::24)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 08:41:14 +0000
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::d032:5b3f:97cc:6c4f]) by VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::d032:5b3f:97cc:6c4f%7]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 08:41:14 +0000
Subject: Re: [PATCH v5 33/36] KVM: arm64: Wrap the host with a stage 2
To: Quentin Perret <qperret@google.com>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-34-qperret@google.com>
 <ec9df9a4-a419-089c-469f-1a1509597dd9@arm.com> <YFCqYT3Ib8kAN7/c@google.com>
 <YFDAyhjPEsnZ4N3P@google.com> <eb70a071-4d4a-885f-36a7-3b20358e5513@arm.com>
 <YFDvAqgimPvpgiwQ@google.com>
From: Mate Toth-Pal <mate.toth-pal@arm.com>
Message-ID: <da9e7839-6d12-c69d-9f23-a091219e1da8@arm.com>
Date: Wed, 17 Mar 2021 09:41:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YFDvAqgimPvpgiwQ@google.com>
Content-Language: en-US
X-Originating-IP: [188.142.195.117]
X-ClientProxiedBy: LNXP265CA0023.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::35) To VI1PR08MB3568.eurprd08.prod.outlook.com
 (2603:10a6:803:7f::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.45] (188.142.195.117) by
 LNXP265CA0023.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5e::35) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32 via Frontend Transport; Wed, 17 Mar 2021 08:41:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 405ea1ad-2867-49e1-95de-08d8e920723b
X-MS-TrafficTypeDiagnostic: VE1PR08MB5632:|AM6PR08MB4721:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB47219A49BBA2E363DC618059AF6A9@AM6PR08MB4721.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: hDRb++svfTqFB+NIaitVb2FiIQov3R0KFzS71SN0oRyir08o5r/kIYLbUEbjfb5S2zMHt/Sfpo4BpCibrF0KPkRLFlO/SdacSm1byxnhrbBX+g7StHxibdwXQFTALyeeMF4I2kNgNUZesgIMiNpqw7aHrSix7sbjvZZLpx60ID5WjZOlPh+eOhwTaMs8NfF18Ax9UP7ptAijIzXA1i5NgHxrtOSCz+B3RmLrCDx0Q4y0OrHojLd9Q7t3AFwSNe68obEjtXANFPxjjt99jNWW9WFgTpBGjmtTUtUXKFaHfL2IBDFVdaJaGOFjGlg8NiUAtHEu3w8PY/CviEhHvJaPmiH/yQ5WNbCpDEBPkdMgentPLxjrhwiRy+llY0P2CmQ7zW8Ik6o/EHbYzBQqIofkjU06Xb/p5erYk4a+cz1DFQLSi5I5scIUWBfouq4xibP/FDdT+yWQxaDdCbc4KSXfyxeUL2tMbtnZIPaWmaoKgay4PcoD+APDiB0xsTw2YjgDzlK3bnmHS+6s66A53Z8sHG0+QCe3XAI7xckcryEBcYuXf+rPPleg2zQUMgVWcaHTXeurYx2RsqCb9bVjjedRr4GMjzmsgpczj9H67LOtSTym0LtwawPieWSvIT7Z/HDshEacRIgIpPB4eRQbfTMyESAOhre/M6zAVMW77Hda1jhYC7PcdVM/n3q6cNkrXUNnXpWac17yUq6f3aF3IOtNyW4MA+gzolMd5AiKjRqodA4=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VI1PR08MB3568.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(966005)(7416002)(26005)(36756003)(53546011)(6666004)(8936002)(55236004)(8676002)(5660300002)(4326008)(66946007)(6916009)(186003)(66556008)(66476007)(16526019)(31696002)(478600001)(316002)(6486002)(16576012)(86362001)(2616005)(956004)(31686004)(2906002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aCt2VjUwbnRCNVhvYnZkRHBZZEJBOEp2VTU0Y3ovRXU5UWFGTGY1RjZIUW9R?=
 =?utf-8?B?NWhURnAvS1pweFIwd2VnYVNUTGEzTHVyUmFQdFlNVEVFTVlEejV3c2tEQmR0?=
 =?utf-8?B?Q0xaUjVFdlBaR0YwOStZbTNaZGx0Rm1BRFRIVVlkazI5Y3IvUTJoSmVVNi9m?=
 =?utf-8?B?b0JlU094cSs4NThOSEhLSHBpNlhxZ3lqNHEyR0VpVEhIamZxVDIwaUU4RXZE?=
 =?utf-8?B?bUJUQmpQbm9yWm15dlc3dGhDVFl0ZzN3dzlaTXRCRENQeVByemNsOEVjZWdF?=
 =?utf-8?B?d2V1WWltMHlWTi9zTDFvb0tQTlZtWkxRbjZKU0wyYXJ4UGRHaXFENFlVaHN5?=
 =?utf-8?B?eVFCaC9DRzg5c0Z5YUtQcXpSdTMyZmhrS2FsdUExWkIyTzIvWXd3UzlGTGg2?=
 =?utf-8?B?bk1FRmZKVkhyb3ppelBLV0h0UElPZHQ3QmxKNU5CazV2UDF6TnhhYzkvbzEz?=
 =?utf-8?B?VVM4KysxOE9kUDE0dzdmMitlZHN0bFdTK1dDNElNU21aa1U3YTA3MjRxTWhK?=
 =?utf-8?B?Mkx6VFF2QnB2L3IxUUxNaklZY3c2ZDhvT3NQMWxZa3ZISGhVRmpIVm9aVjBN?=
 =?utf-8?B?Y0p4cVJYcmhIcmhvVVBBaENCZVhDQkd2WDk4Zk8wQlZRNTEwY212RjB5WHNu?=
 =?utf-8?B?T0pPNjhybUNudG5IWUE5cDFDYXNkblk2QVEvTkg4MUo4R25idmNHTUNpWjRR?=
 =?utf-8?B?Ulh0eVlId3AxWFlBcm1UcEFmQkZmYzdXVHFKaFhMMlpFQXNkL1FhZEdJQTNP?=
 =?utf-8?B?U1RITmxwK3RGQ1FMMU5idE16ZkcweXNRZ3BROTJnVXFkWmZmUlZab25xTG1k?=
 =?utf-8?B?NzQwQXdTQlZaeUlGeGp3ME9keGVMT1RnWEpmWFU3MVR5bnBoMmNDTytoMk9Y?=
 =?utf-8?B?akJKM3FUWHhsZWJGMkJianhhLy8yTmFTSXdicWU2UDBMTmhqYnl3bzRSdUo2?=
 =?utf-8?B?Yi96WGpKbkN5NHZScFpiUVZ6b0xmcDQ1bi9RMElqSHA1RU12OGtMS3cwQzNL?=
 =?utf-8?B?U0JQeWxTYjdra2hYSnk4NFdJQmRTbC9HQkdBYTB6TFUrb0NEQmxUVkRoc1V6?=
 =?utf-8?B?Q0tUaWFwV1NPUDAvSmNiMkJ2a1NQeStXVFVpdnhrNXBpWXp3aGlVcjl3ZVFY?=
 =?utf-8?B?UkNtbU0zVXBqTUFCYlRxYnJCNjAwTG5uRVRjd0VUdU5VUnU3bnJwYVBtM0dP?=
 =?utf-8?B?Y3FaOGRIcHFxNkZQMmNaeTBOUXZtbVFHbUpUbDdZOFdGdUVzQnNFRkV6RzF3?=
 =?utf-8?B?ZTFWazAwMUh1TlBXai83aDkrWllSdHZldWpVNUUwTXdCb0VFSmFkOWJwMVNI?=
 =?utf-8?B?a0M4OTBtTks2UjUvUzdSVkZZbTRzV1dHMzN4ZnpkbFlHSlIvNFV4bGwyclNN?=
 =?utf-8?B?L1N0MFYvL0Iwdk14dnNtUGNVS0xvYWlWM1A5R056Y3M1eEJwTkFZTk9LVUhm?=
 =?utf-8?B?TUpSN2t5UHYzajQwU2thUmFtTlN4T09qMkxDQW9QeDlZZUtRRkx4V3VoUzg5?=
 =?utf-8?B?eE45V3ZsaExYMExEbkVhaVVEd0ZTZmNoVERsNSt4cXNEbHJ3b0dUcUZ0SkZC?=
 =?utf-8?B?VDVhVWVtUURHZ2Z2eEhLazhGcTdmSkt1ODFDZFc1cjZZcFRWbEhtRUpiUzVm?=
 =?utf-8?B?TzVCOEtwMkc2eDdjOFRxUnVEaEFBZXZGVUR2VkdGUThXMnE2QUtlK1EzNmEy?=
 =?utf-8?B?aUxER2ZkUEp3WjdENkZPWVNhY3RLa3F0M2ZWZGpLQVlwWWxvUEQrMWRNTjhw?=
 =?utf-8?Q?zc4OlSjpJuh3nPXj3UxCo/Rmx68wJMrByacuZeh?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5632
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 1ebb8b08-fab3-4b01-ecc1-08d8e9206c31
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bLACyxgzC97gYjN0nDyLSb2iWm8k+LUcF79iIMy/leDujxSB2IK2jyz7SLoaOMj8/iKVnBtgf+UCoSF3QxMmUJANQxnhPGcC1rEuDw+1O0gMA7gpoR2A0RlOu/M08h+anO3N8/c5bEyFhGmcgkLENQvgQT+PCfk2n671u+lvBY33c9GmD+1k4xkyqZrXqdk1SO7rgcc7BNzRYuTenLh7jegYoUqiTcRcGrgQksywLFCHxto0Pcf4hjCzUmwBUPkZRoaBioiu/emOZzBowXRgluS+RTMekN2zbpiPR6wvL410/woxBfXNJlB9AlUvaabbmIriwYsUD1h9E/bEbVbcjvKrcXE7N+HEZ20QBjqn0PWrfwM6cQWU+gt3M8sj/48eLKHCtRiyowKER0hefhPZt7EFmlrVlakbJC+qKWLFWG4ssPt5bFxp8cKjzRuOu1f6+GxIzz07zkdi39Z4n7epsLns5zGPNM8UaUqym37FudNCGHpjxRvgoEL0YESwSW0qYgKhDm5LoXLrddW6qxggQ25b4WxbbSUdJBPr4pOQBfheM6WWg8jO0oVhOiWHLDXUob3VCW0hLGnR80/q/sDivhYwx2CJ+Lkg7mI+IgRIa6CjAplHGbXuudnXeqOiWc5D6W791daXBX9bFYKeTRiaQElboUJU++QZM3pEsyDbNZbzsn/9rKC9iumzIb/2U3laSjgYxbUTQQzCdhuZMTd4bhNj+Id5FRIQ1KAngnShy0RTJRfiVT6smzor0pfXQEhxe1BfMXeFdH9RZLt8p6FVRQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(36840700001)(46966006)(47076005)(31686004)(316002)(356005)(16576012)(6666004)(36860700001)(4326008)(6862004)(86362001)(16526019)(2906002)(8936002)(70586007)(478600001)(81166007)(5660300002)(55236004)(956004)(966005)(336012)(31696002)(26005)(82740400003)(70206006)(36756003)(53546011)(8676002)(186003)(6486002)(2616005)(82310400003)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 08:41:23.6355 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 405ea1ad-2867-49e1-95de-08d8e920723b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4721
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

On 2021-03-16 18:46, Quentin Perret wrote:
> On Tuesday 16 Mar 2021 at 16:16:18 (+0100), Mate Toth-Pal wrote:
>> On 2021-03-16 15:29, Quentin Perret wrote:
>>> On Tuesday 16 Mar 2021 at 12:53:53 (+0000), Quentin Perret wrote:
>>>> On Tuesday 16 Mar 2021 at 13:28:42 (+0100), Mate Toth-Pal wrote:
>>>>> Changing the value of MT_S2_FWB_NORMAL to 7 would change this behavior, and
>>>>> the resulting memory type would be device.
>>>>
>>>> Sounds like the correct fix here -- see below.
>>>
>>> Just to clarify this, I meant this should be the configuration for the
>>> host stage-2. We'll want to keep the existing behaviour for guests I
>>> believe.
>>
>> I Agree.
> 
> OK, so the below seems to boot on my non-FWB-capable hardware and should
> fix the issue. Could you by any chance give it a spin?
> 

Sure, I can give it a go. I was trying to apply the patch on top of 
https://android-kvm.googlesource.com/linux/+/refs/heads/qperret/host-stage2-v5 
but it seems that your base is significantly different. Can you give 
some hints what should I use as base?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
