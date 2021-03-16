Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C02DC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 21:35:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A2B164F77
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 21:35:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A2B164F77
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 763154B4E5;
	Tue, 16 Mar 2021 17:35:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M+v+GiuhSRcK; Tue, 16 Mar 2021 17:35:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0995F4B508;
	Tue, 16 Mar 2021 17:35:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9206E4B278
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 08:29:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rzBliJNAxWOc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 08:28:58 -0400 (EDT)
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr20040.outbound.protection.outlook.com [40.107.2.40])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55E564B1AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 08:28:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1j9Be0NWsBxJXa1DDvUd6REtlrVC8MF/CtLqG87+wQ=;
 b=q3rTIWgzr6lvIoTeBgpYEDDEuzAtc2fwxnzapEbANOlV4THdT4KBBXsmaAOueA4Moxc2PmdSfXar/XcV6HNn5nywkDYmYX9SHirOIPfnmeRyxeOZIXh2iAi0lMjdsIGhM/VE7FFrQj52+prAMhtMSMIMtlq5F+kX4H8QwD2Vjmc=
Received: from DB3PR06CA0003.eurprd06.prod.outlook.com (2603:10a6:8:1::16) by
 DB6PR08MB2871.eurprd08.prod.outlook.com (2603:10a6:6:23::33) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Tue, 16 Mar 2021 12:28:53 +0000
Received: from DB5EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:8:1:cafe::5f) by DB3PR06CA0003.outlook.office365.com
 (2603:10a6:8:1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 12:28:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT050.mail.protection.outlook.com (10.152.21.128) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 12:28:53 +0000
Received: ("Tessian outbound 259fb7427a57:v87");
 Tue, 16 Mar 2021 12:28:53 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 4d8e886c46346694
X-CR-MTA-TID: 64aa7808
Received: from d1aa31154d56.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 D44211FF-3B1F-49D6-A125-C64A4F4733C2.1; 
 Tue, 16 Mar 2021 12:28:47 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d1aa31154d56.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 16 Mar 2021 12:28:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWqFguNwwKpt4xpLO93YzuSWsHmrOecEMg0YMZ+Z4DfQfrHvKslOn0klBEN+s64QUor2DQy3yqYQ5QAYnQ4hxMpIFUIsdDNhlnpbYgTUra3z1lQPXOfYF46Hrfr04/RsXgdJduY9fOKl/a8oogvkimTekGLGvqCieWzXeKPPk+8sAegctNLO5ybK1G+vC7i9U9zqeLe12xFBTfhF8KJln6iwXMbIHwbUoESrbfmu1Slzv3QktC9li0MU9CvQ1xw/zvIRK9pChU0NKAD5vFDj7l2fFOMzaXKAzU/sLPTsyzOJ/cWkJfoJHeoFH3w3KXEaHjOUnM3O7kpcMzPkIjesJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1j9Be0NWsBxJXa1DDvUd6REtlrVC8MF/CtLqG87+wQ=;
 b=JF0iZHBEGFRmzOGG8c0MXV+RV6t73oRa6tHoaWQUTpv1xfIAiI4/cIpqDX164MajcSFihhyqdex0Em+fRi0Tqm7MjkzpkoJaqtptqMKs05CdB5QlZ6MKCX55GrDGjDESJhM0pjEZGcnk/uymDKHWNZ7ulKb5rufOsBG6SMXZrnGvqcXpcqG/eu61QxkGCEpeIAEdrsbfwicN2E3hmxTITmOZhrnNRX5VevQsA8URicsBoqe328jMTnPBGa8Zb2sVQVLjAFn+tGjlH/+xI/jDJ6b7SOGPrSKg6kmAqq7cfz9fym8Dh9cchWUEzfwH1ZgRWxnufzzssUeg2s8vOnxcrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1j9Be0NWsBxJXa1DDvUd6REtlrVC8MF/CtLqG87+wQ=;
 b=q3rTIWgzr6lvIoTeBgpYEDDEuzAtc2fwxnzapEbANOlV4THdT4KBBXsmaAOueA4Moxc2PmdSfXar/XcV6HNn5nywkDYmYX9SHirOIPfnmeRyxeOZIXh2iAi0lMjdsIGhM/VE7FFrQj52+prAMhtMSMIMtlq5F+kX4H8QwD2Vjmc=
Authentication-Results-Original: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com (2603:10a6:803:7f::19)
 by VE1PR08MB5742.eurprd08.prod.outlook.com (2603:10a6:800:1a9::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 12:28:46 +0000
Received: from VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::d032:5b3f:97cc:6c4f]) by VI1PR08MB3568.eurprd08.prod.outlook.com
 ([fe80::d032:5b3f:97cc:6c4f%7]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 12:28:46 +0000
From: Mate Toth-Pal <mate.toth-pal@arm.com>
Subject: Re: [PATCH v5 33/36] KVM: arm64: Wrap the host with a stage 2
To: Quentin Perret <qperret@google.com>, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-34-qperret@google.com>
Message-ID: <ec9df9a4-a419-089c-469f-1a1509597dd9@arm.com>
Date: Tue, 16 Mar 2021 13:28:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210315143536.214621-34-qperret@google.com>
Content-Language: en-US
X-Originating-IP: [188.142.195.117]
X-ClientProxiedBy: LO4P123CA0063.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::14) To VI1PR08MB3568.eurprd08.prod.outlook.com
 (2603:10a6:803:7f::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.45] (188.142.195.117) by
 LO4P123CA0063.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:153::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 12:28:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a26e425e-aee4-40da-9930-08d8e8770fd0
X-MS-TrafficTypeDiagnostic: VE1PR08MB5742:|DB6PR08MB2871:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR08MB2871B4E59FF468EBABAE12C7AF6B9@DB6PR08MB2871.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: xELQn9BI6ZIOWAENqPiMyjo4BTdo5s98c6UsZIR8GBTnp6Jm16xT4vSsCcEwrZ5DcwlVyGALPBDKWFkDMREcBrl1CUGDNPJlzkJB2axqO+itYYF8w207AuINNGJT4OtDDqBGwwAztwBzu/iKPf4Q91Gs/T3HmqtgbqG8Uo9Dea6X5VENnT6hXY+5TLjhLANJ3Q/nFLDlqebHITu2ls9KxFeW08K3GCHfRkcuKUWoMlGn0GNzq47peeSKZKenvGG6/74t2tysUgqbZZr1PVmn+m3rHZ9KqVeLwEzqOl8sYCqXZS4KcJ0JlqJJG/ZU5jTzvcE58B+Mw77L1bqHVdCPE5TpKPeKw48pwH8EKZoIDM1ZXaT5hPsWefNQR9kaus5ykp9UlzLHao+1tQKWsaoLnPgIuBDoiNEEZIHlqUcEo04X3hr3NWvtkvedQ1ln8kpTakq1uYReKLwLTADQcy9V9UiGwhVfnOoqCJeztMbdcePor1/ad9ZysgU65v2gmBB9AbnUs5pq+vyqGWOMn8Rrq7LC0HfDzA4wbZWmo1/n9vOlXFFSSTOG4SeSBNA7MaH6qEqjJDUVUeh99aJI1k8GB78mW9PMJ8dkLGs0cmZlQHlswtcXyg8h9hsuNEV1FpdcMOAbL2mYHuc7mG1v8/RNxg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VI1PR08MB3568.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(366004)(396003)(39850400004)(346002)(376002)(136003)(186003)(31696002)(6636002)(66946007)(31686004)(66556008)(66476007)(7416002)(26005)(8936002)(55236004)(53546011)(36756003)(5660300002)(83380400001)(2616005)(6486002)(16576012)(86362001)(316002)(956004)(16526019)(478600001)(8676002)(2906002)(4326008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SC9mNlZRV0hpRitMN3o2NHVNM3ZzclljM3N2djNGd0hESGxVSU1VcEhLVjdw?=
 =?utf-8?B?eG9pVzViRVV1cmFrVW44U1ZrWXloQlcybkZRNUdIcERKdlVJYUd3V0ZqTzlV?=
 =?utf-8?B?Tk5McjB2bENEeGtEcUp6NnltZHRxZ094MWxyWS9jRVBlc0N5eUNRR1o2OXkz?=
 =?utf-8?B?YTlacnhkZkFRYXY5enE2QTBPUjR2bG9IZlJNRTJqb21yaGdwVlkzVTV6NVYx?=
 =?utf-8?B?UlF0ZHhkTTJvN2ZocEc0aWxtT243bHJLYjkrTzlQWURLK1BaWWVOMUxDVjQz?=
 =?utf-8?B?aVZNM1RVWXRicER1bFl3aWJCcEpQcmFQcE9POHR0VjFDekliaURtdDJ5ckdK?=
 =?utf-8?B?TGd4b01kWDFqcGR2Y1haS3JCa0ZxNEIrUUhEVThoQUlMRFZpRjdtSmpJbnNu?=
 =?utf-8?B?VGNyWktuMUMxdjNJUlNZejVac0VaUHh2dGpnOGJtTG9vQUROVVhhMktRKyth?=
 =?utf-8?B?ZFdwV2xvc2FlZTFQcWJkNVhXVGFQKzdkZHBkSW9aUHR3RTV5bkE5VmlUNUNE?=
 =?utf-8?B?U3QzVm0zNU1aaHhsSVJXZWd5dkIwaUhXbzJhT0JJWkE0UDN1N0NSc0pjQnNQ?=
 =?utf-8?B?Vnl0V1hEdjZKc3RHcXNNOHFhMkdJQ3ZUclBsTEZXUGlMcXNlVWdZQVh1ZWRV?=
 =?utf-8?B?bzM5ckRXemVtblJGZjZSUVhzTHFRYUJMZlovSHRIVjR0QklYa1RvK0NLQko2?=
 =?utf-8?B?TXBBU0hBbXdMc2R2N1RCNS9oQWo2cmI1QlBRa09PSVM2ZktlUGJSMWxWdU1t?=
 =?utf-8?B?TiszaVFtRlYvUUNLTFB2b29iRGxiNHV3ME0zZllzQVhKeWExUk1xMFlZbjVB?=
 =?utf-8?B?dGdXdmZyTWo0emx4VlFPa3Z3WGtubTVFcEFPdFhnKzJUN2huOVEzcmVmSjJz?=
 =?utf-8?B?bzdCSUgxaERHY1NnNEx3SEM3endDT2NqZHJSWjVrU0FPcnlRMjYwSkhtUkkr?=
 =?utf-8?B?WHRKbStQRWR2ZTRZTEtZTGltdGdNTzJMRlpjT2k1anFqanJQSG1HUFYzYm9B?=
 =?utf-8?B?b3dzUlE1V3ZnNUVocldpL0gxeWNFa3lQN2xUSjU2aHNRcWxKekpPUkxBT205?=
 =?utf-8?B?akxDYU1xV2tEU1dONGZyN1I5SldWNkxkTFFNeGgwZmhkWmJmRHdXOWdsMFRF?=
 =?utf-8?B?UmYzOEZpbzNoZndhd29IUkhTbHpVR3ZENjhxZWxMNUF4c2FtT2VTMzV6K3Yv?=
 =?utf-8?B?WTU4ZXhZaHJMK2V0Y29hamJ6bWNUM0JLQTNpM3lpT2VUTUJMWjgxRkRaRjRV?=
 =?utf-8?B?LzBqTXhFN2lzSmR1cHZrOS83WFphbXJGSDdrVWxMQnVIVDZEUEFxWk0zSTZN?=
 =?utf-8?B?UmMxcS9ZOS9KdHQwUmJrZzZyUk5UYXB2cnJlaXhHWTFOaTBvaHJ5VVdlWEx5?=
 =?utf-8?B?SlQ4TUtNZVV4dGdTS2dGWm9oTEJ0VklWTHliTlpxLyt6KzNweTFIVUZKRFJT?=
 =?utf-8?B?K0o5cGw4SGFSQTVFY1hLcXdDQXlWWHJQNmExbjJab0ErZ1owTHZ4b25KcTNJ?=
 =?utf-8?B?ZVRUdjNjNWdRdWFhTU5BeUlOZDZKNkRyd0FWclJFbzRLQkxXYTlNcUF2ZHVM?=
 =?utf-8?B?Q3l0TXJqTlhEL1o4K1FTcmVudTB4VXVVaHlnbDQ4bmhOSU54SEQ2T2pmbzk5?=
 =?utf-8?B?L1o5bUZ2NkFHUTY1M2JyZjUzQnZIYm1LMThUZW9xa05HU2NCMUxYZGM1Z3Jy?=
 =?utf-8?B?RSt5cENXeGdFZDlGejh5ellvTWZ2b0hhVXFFRDN5ZW45RXRoL0ZqaTNHYzZp?=
 =?utf-8?Q?Qe/YvFCjXOImFJ2QFz2lBFiKOd+3h9KIuva0mzw?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5742
Original-Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: a99b59fa-5ab2-4325-8b64-08d8e8770b47
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: atWgT6e510tV5lUfjkaMWa/BzYTEGSdJk+JWaiJCKZs39kaKuQI0R+pcahmeAhRekU2fTRwGDb9MIwFQ5SkUvV+fay/5hk9Q07wjB12xGG3szN4eA+orLXV1eQ8bzJWxFed+IVr+02I807QreHNI2FvOvHXt6nz6TZoItDe7TMMPTGVOgRlpZ7CxAT3Anr6HkMMpzLpziqTTMspq6WsZF0Yog7K7hAQfKDTORO38orgX44b1vLElzCBVpkiVEhOmReZImHDVER50jVMSEyb2w5mrIItqtN35fwM/JrdNR8ovA3PAGT5KIU8CLqNV4K4ai045LQU7MVF05k2OYFWNQD+/VmxRNr+FFLdiLXaDmUqiz5O6rIvRFv9+/Hqd7tCq0Y1hQFYnD/80PAzEsaovUz43Sigxz7pDfrprdrsMv/64dC6zw7sZfeBFNUhXCdkMJI0kt2Vfgp/8rsUPuQZPkXOFxbnoTr96tAqqMbUdmK844cajvEw47tVKazYprIbj0qWCjn2bzlaiOis9ICvFdw9y869I57xe7PiRmwdSe7JVId8ez/F2wcS3BT9p7LczQPHlnIcAT/8tn5CaHvaOXZwkqS723sbSHbogTIoA30NtEFsBDzLLt2ep5GjWoPGUJZFQYWWPCkRpDZhQIS6PDRjjC8PX52Xb9++RC7VLhu9PZKHM/yItJXHPT3q0BUQ0
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(376002)(396003)(136003)(39850400004)(346002)(36840700001)(46966006)(6486002)(47076005)(31696002)(36860700001)(4326008)(107886003)(2906002)(31686004)(8676002)(86362001)(2616005)(82310400003)(5660300002)(83380400001)(336012)(81166007)(8936002)(356005)(70206006)(53546011)(82740400003)(16576012)(316002)(26005)(36756003)(16526019)(186003)(6636002)(70586007)(956004)(55236004)(478600001)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 12:28:53.6936 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a26e425e-aee4-40da-9930-08d8e8770fd0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR08MB2871
X-Mailman-Approved-At: Tue, 16 Mar 2021 17:35:18 -0400
Cc: android-kvm@google.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, tabba@google.com, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMS0wMy0xNSAxNTozNSwgUXVlbnRpbiBQZXJyZXQgd3JvdGU6Cj4gK3N0YXRpYyBpbnQg
aG9zdF9zdGFnZTJfaWRtYXAodTY0IGFkZHIpCj4gK3sKPiArCWVudW0ga3ZtX3BndGFibGVfcHJv
dCBwcm90ID0gS1ZNX1BHVEFCTEVfUFJPVF9SIHwgS1ZNX1BHVEFCTEVfUFJPVF9XOwo+ICsJc3Ry
dWN0IGt2bV9tZW1fcmFuZ2UgcmFuZ2U7Cj4gKwlib29sIGlzX21lbW9yeSA9IGZpbmRfbWVtX3Jh
bmdlKGFkZHIsICZyYW5nZSk7Cj4gKwlzdHJ1Y3QgaHlwX3Bvb2wgKnBvb2wgPSBpc19tZW1vcnkg
PyAmaG9zdF9zMl9tZW0gOiAmaG9zdF9zMl9kZXY7Cj4gKwlpbnQgcmV0Owo+ICsKPiArCWlmIChp
c19tZW1vcnkpCj4gKwkJcHJvdCB8PSBLVk1fUEdUQUJMRV9QUk9UX1g7Cj4gKwo+ICAgCQkvKiBF
bnN1cmUgd3JpdGUgb2YgdGhlIGhvc3QgVk1JRCAqLwoKSGkgUXVlbnRpbiwKClRlc3RpbmcgdGhl
IGxhdGVzdCB2ZXJzaW9uIG9mIHRoZSBwYXRjaHNldCwgd2Ugc2VlbSB0byBoYXZlIGZvdW5kIAph
bm90aGVyIHRoaW5nIHJlbGF0ZWQgdG8gRkVBVF9TMkZXQi4KClRoaXMgZnVuY3Rpb24gYWx3YXlz
IHNldHMgTm9ybWFsIG1lbW9yeSBpbiB0aGUgc3RhZ2UgMiB0YWJsZSwgZXZlbiBpZiAKdGhlIGFk
ZHJlc3MgaW4gc3RhZ2UgMSB3YXMgbWFwcGVkIGFzIGEgZGV2aWNlIG1lbW9yeS4gSG93ZXZlciB3
aXRoIHRoZSAKY3VycmVudCBzZXR0aW5ncyBmb3Igbm9ybWFsIG1lbW9yeSAoaS5lLiBNVF9TMl9G
V0JfTk9STUFMIGJlaW5nIGRlZmluZWQgCnRvIDYpIGFjY29yZGluZyB0byB0aGUgYXJjaGl0ZWN0
dXJlIChTZWUgQXJtIEFSTSwgJ0Q1LjUuNSBTdGFnZSAyIG1lbW9yeSAKcmVnaW9uIHR5cGUgYW5k
IGNhY2hlYWJpbGl0eSBhdHRyaWJ1dGVzIHdoZW4gRkVBVF9TMkZXQiBpcyBpbXBsZW1lbnRlZCcp
IAp0aGUgcmVzdWx0aW5nIGF0dHJpYnV0ZXMgd2lsbCBiZSAnTm9ybWFsIFdyaXRlLUJhY2snIGV2
ZW4gaWYgdGhlIHN0YWdlIDEgCm1hcHBpbmcgc2V0cyBkZXZpY2UgbWVtb3J5LiBBY2Nlc3Npbmcg
ZGV2aWNlIG1lbW9yeSBtYXBwZWQgbGlrZSB0aGlzIApjYXVzZXMgYW4gU0Vycm9yIG9uIHNvbWUg
cGxhdGZvcm1zIHdpdGggRkVBVF9TMkZXQiBiZWluZyBpbXBsZW1lbnRlZC4KCkNoYW5naW5nIHRo
ZSB2YWx1ZSBvZiBNVF9TMl9GV0JfTk9STUFMIHRvIDcgd291bGQgY2hhbmdlIHRoaXMgYmVoYXZp
b3IsIAphbmQgdGhlIHJlc3VsdGluZyBtZW1vcnkgdHlwZSB3b3VsZCBiZSBkZXZpY2UuCgpBbm90
aGVyIHNvbHV0aW9uIHdvdWxkIGJlIHRvIGFkZCBhbiBlbHNlIGJyYW5jaCB0byB0aGUgbGFzdCAn
aWYnIGFib3ZlIApsaWtlIHRoaXM6CgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaHlwL252
aGUvbWVtX3Byb3RlY3QuYyAKYi9hcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9tZW1fcHJvdGVjdC5j
CmluZGV4IGZmZmE0MzJjZTNlYi4uNTRlNWQzYjBiMmUxIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0
L2t2bS9oeXAvbnZoZS9tZW1fcHJvdGVjdC5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhl
L21lbV9wcm90ZWN0LmMKQEAgLTIxNCw2ICsyMTQsOCBAQCBzdGF0aWMgaW50IGhvc3Rfc3RhZ2Uy
X2lkbWFwKHU2NCBhZGRyKQoKIMKgwqDCoMKgwqDCoMKgIGlmIChpc19tZW1vcnkpCiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJvdCB8PSBLVk1fUEdUQUJMRV9QUk9UX1g7CivCoMKg
wqDCoMKgwqAgZWxzZQorwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcm90IHw9IEtWTV9Q
R1RBQkxFX1BST1RfREVWSUNFOwoKIMKgwqDCoMKgwqDCoMKgIGh5cF9zcGluX2xvY2soJmhvc3Rf
a3ZtLmxvY2spOwogwqDCoMKgwqDCoMKgwqAgcmV0ID0ga3ZtX3BndGFibGVfc3RhZ2UyX2ZpbmRf
cmFuZ2UoJmhvc3Rfa3ZtLnBndCwgYWRkciwgcHJvdCwgCiZyYW5nZSk7CgpCZXN0IHJlZ2FyZHMs
Ck1hdGUgVG90aC1QYWwKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
