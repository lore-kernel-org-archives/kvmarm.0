Return-Path: <SRS0=T+on=IV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457BDC433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 18:44:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2431619C0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 18:44:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2431619C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B7894B2A2;
	Tue, 23 Mar 2021 14:44:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R5vpCD1RLOLX; Tue, 23 Mar 2021 14:44:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2E224B2D8;
	Tue, 23 Mar 2021 14:44:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E67BB4AEF8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 13:54:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LUOdgmDGATxV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Mar 2021 13:54:00 -0400 (EDT)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50053.outbound.protection.outlook.com [40.107.5.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABBAA4A524
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 13:53:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8uKtS7JB+ESvMRaUbyOwMltgwcfRJHaS5gEEnHC+hg=;
 b=XKvHxqLbOcmK1fQnkxFxjVueHF8H0nveOa0Xz4JGYhv5IFD9MSE6u5GgIoaAjhoUASttNxTMli4gX5WmHdroAOBrhl1H1y8RWY2pnYPNsQKS0c1i0YSUQpyly9sSi40Zen5JnconjVyQDmqE9oze4vqtM+oDN8MFvMt2TbPZIxk=
Received: from MR1P264CA0030.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2f::17)
 by PA4PR08MB6301.eurprd08.prod.outlook.com (2603:10a6:102:e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:53:52 +0000
Received: from VE1EUR03FT060.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:501:2f:cafe::74) by MR1P264CA0030.outlook.office365.com
 (2603:10a6:501:2f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend
 Transport; Tue, 23 Mar 2021 17:53:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT060.mail.protection.outlook.com (10.152.19.187) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 17:53:51 +0000
Received: ("Tessian outbound 31ead7df1201:v89");
 Tue, 23 Mar 2021 17:53:51 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: e6c42386a39274ed
X-CR-MTA-TID: 64aa7808
Received: from ebbf8b18c0b8.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 0A075586-8065-4759-BCE2-3BBF8F2DE418.1; 
 Tue, 23 Mar 2021 17:53:45 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ebbf8b18c0b8.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 23 Mar 2021 17:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBx41n4qdjJizjENrnPKO+q6rWTrlZjqYtJSvxSJ4ke90LACqSP25rFkKpBbydrHvHwZrQewm6UIk0fQVhMQCaE4VyLOFttxiRiryyRO3+yLtKIjZ1AqSGuggRRn7LdYUC7Iaq0y1OddubBLJHMoqIH+g1JmDcWoHlj7vmf4Y0iHU+CBOpFWkjj2Pd29csZI8Z4rNYOu6Cw7694zbD0+50qbpTH1aObwtb0aBCrdQb7lLG3qwQCl1hvgx8MNcgxIf7U4+teb/+mhpQcymIUsQg2lYhe++bGZX54suyS4/ZueBS9itCpOGAg1egwOSo21veHr+mJk7zT1W/YzNEoFsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8uKtS7JB+ESvMRaUbyOwMltgwcfRJHaS5gEEnHC+hg=;
 b=A7QEJlfMljbqjoMbl7dk4qoHG8wvF/O+DymRc/k4bCnCfNpRg/h4PyeHomMb0zT7XfxZHnXgu2TxKx7ZhkM94PdlxBRI+1dTLlv0DrHVvg8RLhbdLT/XAZRt1cFQYxA1gkBl7NFNiaR2K2hfNuRdJst548npk+dsGhDfLGOsPGo+xBDUegikHkGNf6dA90j9sb/Dzj35uZG6vIcMQGUPiofcrJm480IVxZnhkdVzo7z6b4WsNa/RrlLcbcTUrAyz4WwHq8yPGV5gTOFUi2X07DYL2zJXWtj42LBT6C2Ls2QgsUzPE6eyEcZNZH3VzcUtRbMUf6OpiykyHwMxuZbvbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8uKtS7JB+ESvMRaUbyOwMltgwcfRJHaS5gEEnHC+hg=;
 b=XKvHxqLbOcmK1fQnkxFxjVueHF8H0nveOa0Xz4JGYhv5IFD9MSE6u5GgIoaAjhoUASttNxTMli4gX5WmHdroAOBrhl1H1y8RWY2pnYPNsQKS0c1i0YSUQpyly9sSi40Zen5JnconjVyQDmqE9oze4vqtM+oDN8MFvMt2TbPZIxk=
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
Received: from PR3PR08MB5868.eurprd08.prod.outlook.com (2603:10a6:102:81::6)
 by PR3PR08MB5612.eurprd08.prod.outlook.com (2603:10a6:102:8f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:53:44 +0000
Received: from PR3PR08MB5868.eurprd08.prod.outlook.com
 ([fe80::e09f:8ece:7f43:3fc4]) by PR3PR08MB5868.eurprd08.prod.outlook.com
 ([fe80::e09f:8ece:7f43:3fc4%7]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:53:43 +0000
Subject: Re: [PATCH 7/7] KVM: arm64: Add irq_inject counter for kvm_stat
To: Marc Zyngier <maz@kernel.org>
References: <20210319161711.24972-1-yoan.picchi@arm.com>
 <20210319161711.24972-8-yoan.picchi@arm.com> <87lfadkbyz.wl-maz@kernel.org>
From: Yoan Picchi <yoan.picchi@arm.com>
Message-ID: <c1ca65a5-1b7e-8ec2-ecbb-8ceda973bb14@arm.com>
Date: Tue, 23 Mar 2021 17:53:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87lfadkbyz.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [2a02:c7f:1ea5:1f00:392e:621b:d12d:a0e5]
X-ClientProxiedBy: LO2P265CA0425.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::29) To PR3PR08MB5868.eurprd08.prod.outlook.com
 (2603:10a6:102:81::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:c7f:1ea5:1f00:392e:621b:d12d:a0e5]
 (2a02:c7f:1ea5:1f00:392e:621b:d12d:a0e5) by
 LO2P265CA0425.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a0::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.24 via Frontend Transport; Tue, 23 Mar 2021 17:53:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f4e1e4c4-583c-45a6-f69a-08d8ee249e54
X-MS-TrafficTypeDiagnostic: PR3PR08MB5612:|PA4PR08MB6301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PA4PR08MB63010F849C81CA5DF99B91B4E4649@PA4PR08MB6301.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 1MN97inpj57qxt0k4tI14eFo+b8bZbUyytr6VihjdtNoJT6zL01DNBHeq5ULMUznU1q5gqCu9y0GFwN3NgO1nlWZzYdeXTeEgmiAAU4gdjs4rzl5VUAiajpEbpjr1fUYEisbepERwT2BsxicS4+RNjCrTIZ0AivkOY92LWtQIgImoL/f6xHLCUPaiKTTdd0pZHSa/076KZW8hBvNxWFmS/WHjsIeSXQfC4q3UtwpQT/6xoLeLmIjTfYDqsdbu3ZFxHkLG2uTHMNf+2iuHgJ+vAZ7W6JsfVmmxCOLR5/1EpNNYwI+Q4UQRpY5yx8K5y1jk6o8uIdiUHO72umrus2pxHTWRu6UGaqxd8m0nUa1Fu6pZTMbnCaY2TRpWN9jGsr6OJ665T2LkJAHTESZUieBMOj1BEqO5/+N3bYGFcwxfVY5l7N4DOpr5cvjAwzf6B3L9Wrs7s4VUgolyU7amimGxxzXsfc9vsrKyqq6Znzoi04Y20Idg8RaVXV5eOJYnKGr5CDJfZ7VRokkM2GD5SKhNp3wN3kni3HR/V2ycAMS1M4anOszY1umbVrLlhsRrFLsjhKZYKRRYelYWBxsvBvLoqS1D5dyqZ1O7IXb12wn6sPgZlBoM/9zzuP438CN24balz5ldSIYhRIoGO+ZF+Oie8DRrCOeJUjZXJGxbmF1yCxi8Cx28dJ9+ri4kT3EdtmZKRcygZjHTCyAaTaP8x6aD5LwaIlqbSEckdL3zit3Oso=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:PR3PR08MB5868.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(31686004)(66946007)(83380400001)(66556008)(6486002)(38100700001)(8676002)(8936002)(66476007)(31696002)(44832011)(16526019)(186003)(6916009)(53546011)(5660300002)(4326008)(478600001)(316002)(86362001)(2616005)(36756003)(2906002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UjBNS2JzYktFS0RtR01XajgvVENSTDBNb2lQbEJaZ1NwcWY3VDk4ejJCSXpD?=
 =?utf-8?B?WFN3WjI4K2xPNU1RRk9FNE1jU2ZoamhJcTBLbk9pYW5sMEdUS3ZHWnRJeW1Q?=
 =?utf-8?B?alliV2RuZXNNbDdUbjcrdHN4R0hEbTFQa0RTcWgrMzJLRDV6R04zSm9kbjhw?=
 =?utf-8?B?alFmbHJzRDNhYWdNaTRVb0NLQk40ZUFveFozV2RTZ2NWZnEzSG50WVRBaXQ4?=
 =?utf-8?B?NmdlMklnVEFyTDdCYkZpdmlwOHg3T2tIRmM4M1g3blNNYmdNcmJEWHhTMzBl?=
 =?utf-8?B?QkZjbC8zRFQwbEo1M3VoSS81eWM1Mkw0TmxQSTcwTGI1YWZRVFU4Ym5LaHQz?=
 =?utf-8?B?RWZxUW0zZTRoNUprNnBhekd3N2x2L0JYcVZDWVBIaWFrMGlsWjVIU0pHejNw?=
 =?utf-8?B?Z1pEUHYrbVMzSlg2MnBZaU9QUFpQZlBwazhYSWV5TGVVOHczeERNN3JYT2x3?=
 =?utf-8?B?UFpxdytYTVB6Y25LRnlCS0tqQ0htdEhWM1lJK3BhWnB6Qm4rVUNYNTg1T1hZ?=
 =?utf-8?B?STRpYWlBdDd5TEdCWkZXc0Y3TzZjVTBqSUhpZ0VTWjB0Tk42ejk1cVNHRUxk?=
 =?utf-8?B?SytHQzdYY21Kam9xYmFyMXkwUmNzUWRqN3FNWlRRTzdlUEIvZG5GZTAzaU5P?=
 =?utf-8?B?YjFNeHY2NUF0SEtFdElFZURsc1NwS0RLaExnWkJCTDUybmN6T1gwTFR4WkJp?=
 =?utf-8?B?eXFmWmRGcFJoUWJqanduUVY3UU43eXBLand6bDdaQjJhUEFnOTE3bkVpOFZL?=
 =?utf-8?B?WUJxVzlFUEJTZkl2em0yODlBcHcxSzJoZ002RlIrcHA5YThBS1FpVThpSitM?=
 =?utf-8?B?WU9BTTB3ZXFndHpXMkxZMlp3czJwNjlaRTFOV1VCUWZmK1hxNjVTMkRDc3V5?=
 =?utf-8?B?OUFKbXdWdnU2TzNDdVBTZDVxK2laV2lub3dXSEtTbEh4Qmx1VVFBTjJ4ZWRk?=
 =?utf-8?B?K0h6dWZVRjkzN0NxNEtxZXdRM3FLdG1MU0tGbXp1dmtDY2RnME9NczJuVExU?=
 =?utf-8?B?QTNuZldxSGxuYmtkK3RvdWViSG90SEovNmtvR2psRmNhdFVnU1hsbFRJOTZq?=
 =?utf-8?B?RWdRYWhrSE1BMmdYeUQ3TG9wV1Fra1MrNitjNXVSNUhTZ3o5UWNHY3dnZHRN?=
 =?utf-8?B?WlFlV3dJa3A3WTFvam9IZ3cveXZpSlRBY3llNit4Q1I5eXhiSWt6ZGhramVt?=
 =?utf-8?B?M29sczJJWmozWE96bmVhNGdpY3VhNTdIMHJqWlNiZUxwdDl6b0l3Y2dBYTFl?=
 =?utf-8?B?NTNUZGpBYm5HcS9KeG1hMXRiZjZOQzEvYXpNSXc1dm9CeHVLMGNZaU1oS3gr?=
 =?utf-8?B?SlN4ZDVYajZhR1ZNNWZ4ZmFoRWFUdDlBaWhuTUNpcHFRVld0cG8xTmlIdXFI?=
 =?utf-8?B?Y1VPYzlHQW9yZWNVdjV5Y3A2aXJZekR5SnBtNHhMbVpCOU96VGJQTzJERzZ1?=
 =?utf-8?B?aEVOY0d0VHpPUUJRRmFHNlZ4MjhVNWo1Y0FydnErSjJHK0tDWjZEQ3RzcWZZ?=
 =?utf-8?B?WkVZcVNOMDNleWtVTll0YkNWVkJFWURjSzZkRWJ1YkZPQzdLOTZVOTFLMjJ5?=
 =?utf-8?B?ZVlhR2Z3aXN1K0xSMzRhdmFuZ2dYS1VKTHFEblp1aXgrWm1MUjB3SldwSmtL?=
 =?utf-8?B?ZkhVY2FESEt0TWI2YjFaSXp3SGd5RnlyVTRKUDlhYmk3LzgvaFRjRHdaU3kz?=
 =?utf-8?B?UExlK0JNaXE3dStaVW1xOGg0aFBTWE4vbnpSRjJNSndoaDFYQUdhc3RVSkhq?=
 =?utf-8?B?TjUvaEhuUWdReEY4NllxZHJWTjZOd3BJdkhpWTVjb290NWxLRU5XMHZva3Iy?=
 =?utf-8?B?eTN1TGNyRnl1WW1zbGZxM1dseEZrdnJRUWw2V3MzNEx2S1BjbnFWblNWNXoy?=
 =?utf-8?Q?WI/XeQIXhcf4e?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5612
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT060.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 29195383-d94b-4b09-dcfe-08d8ee249968
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ye/AjwYCAO9VCpmmClxGG8C9H7lEtxdzGhre05XX0Ef/gqEcnisWZXzutihTrgIxcBGOf392jjOLHd1yjaS/y9Waj7bxrzW3QqorO+a3jgx8Dm5uS+MO4zAs/7rlJEigTIHuOqz+H18TUVYoOjc6QCFl/vEA5asaeerbgRNuTraiDd9Ai/btq/rpyXMbpdIkz/apeXZVaohkYVxREdyQN/sU+kqIFi0+4AXiGJghqP+KBK6/x0nsh6gjdsrFq3z45ukuhRO6GJC9KnsV3hDSvwdXln1exM3vzCPhVBWDEQ9U1gu0QkF5SG0au9Pzubh4NblGrZvUzNi/Xippvs591JLAe2TPRpKSNQUbnjATbysgHJ0gFOkXV+bus8etx3mXJSOdxBBHQOIMVaWAw1K5ZSqYsCaFTHUCJsTeyyJ8Tdh2FbelSvMkhs8BelG7wF23S/HhTsR4zuYeqQpa/CMJhMFzyDlr31hIyASgmI/rHDNmEqfs/yf82SAImG1sCdjshfLbp/xrw7EbQnPCH5dHAMIHVBhdtKJzs5KALzOHpv41wsNC82Y/rV0etgOdpClWVpjIHK3zZdTkyGh2f3P1mfa4N3/XETgwush/X51WNYS6VNZhQUOJVLeKIWos9Xd7DHQHUtyHr+hUgoJ+VoNij0c4xP4Navrsigw+hD7lq8QU3PmauCSyQK7ZTeDDL/gq
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(46966006)(36840700001)(53546011)(16526019)(47076005)(478600001)(6862004)(6486002)(107886003)(5660300002)(36756003)(26005)(336012)(82310400003)(4326008)(186003)(8676002)(81166007)(316002)(356005)(44832011)(70586007)(2616005)(86362001)(70206006)(31696002)(82740400003)(83380400001)(2906002)(31686004)(8936002)(36860700001)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:53:51.4277 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4e1e4c4-583c-45a6-f69a-08d8ee249e54
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT060.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6301
X-Mailman-Approved-At: Tue, 23 Mar 2021 14:44:47 -0400
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Mark.

Thanks for all the reviews. I am a beginner and you gave me a lot to 
learn about.
I will reply to the other patch progressively once I understand better 
the issues.

On 23/03/2021 17:37, Marc Zyngier wrote:
> On Fri, 19 Mar 2021 16:17:11 +0000,
> Yoan Picchi <yoan.picchi@arm.com> wrote:
>> Add a counter for interrupt injections. That is when kvm relay an
>> interrupt to the guest (for instance a timer, or a device interrupt
>> like from a network card)
>>
>> Signed-off-by: Yoan Picchi <yoan.picchi@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 2 ++
>>   arch/arm64/kvm/arm.c              | 2 ++
>>   arch/arm64/kvm/guest.c            | 2 ++
>>   arch/arm64/kvm/vgic/vgic.c        | 2 ++
>>   4 files changed, 8 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index fa59b669c..253acb8c2 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -551,6 +551,7 @@ struct kvm_vm_stat {
>>   	ulong memory_slot_unmaped;
>>   	ulong stage2_unmap_vm;
>>   	ulong cached_page_invalidated;
>> +	ulong irq_inject;
>>   };
>>   
>>   struct kvm_vcpu_stat {
>> @@ -567,6 +568,7 @@ struct kvm_vcpu_stat {
>>   	u64 mmio_exit_kernel;
>>   	u64 regular_page_mapped;
>>   	u64 huge_page_mapped;
>> +	u64 irq_inject;
>>   	u64 exits;
>>   };
>>   
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index fc4c95dd2..841551f14 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -895,6 +895,8 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
>>   	bool set;
>>   	unsigned long *hcr;
>>   
>> +	vcpu->stat.irq_inject++;
>> +
>>   	if (number == KVM_ARM_IRQ_CPU_IRQ)
>>   		bit_index = __ffs(HCR_VI);
>>   	else /* KVM_ARM_IRQ_CPU_FIQ */
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index 129c0d53d..f663b03ae 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -45,6 +45,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>>   	VM_STAT("memory_slot_unmaped", memory_slot_unmaped),
>>   	VM_STAT("stage2_unmap_vm", stage2_unmap_vm),
>>   	VM_STAT("cached_page_invalidated", cached_page_invalidated),
>> +	VM_STAT("irq_inject", irq_inject),
>> +	VCPU_STAT("irq_inject", irq_inject),
>>   	VCPU_STAT("exits", exits),
>>   	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
>>   	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
>> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
>> index 1c597c988..9e504243b 100644
>> --- a/arch/arm64/kvm/vgic/vgic.c
>> +++ b/arch/arm64/kvm/vgic/vgic.c
>> @@ -458,6 +458,8 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>>   
>>   	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>>   
>> +	kvm->stat.irq_inject++;
>> +
>>   	if (!vgic_validate_injection(irq, level, owner)) {
> So even if the injection failed, you report an injection? And what
> about injection that occur via the MMIO interface? What about direct
> injection? What about a level interrupt that is forever high?
>
> 	M.
>
This one I actually started to fix this afternoon by moving the counter 
into vgic_queue_irq_unlock().
This way it is only incremented when the interrupt is inserted into a 
vcpu, and it also takes care of the
vgic_mmio injections. I also fixed the issue with the interrupt line so 
it only increment when the line
change of level.

I'm not sure about what you mean by direct injection yet though.

Kindly,
Yoan

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
