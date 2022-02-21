Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B7EC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 16:07:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 309604B1C0;
	Mon, 21 Feb 2022 11:07:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X9HpldoQOEk2; Mon, 21 Feb 2022 11:07:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 625E64B1C9;
	Mon, 21 Feb 2022 11:07:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D4B4B1BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 11:07:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EV7Vug0FYOMJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 11:07:21 -0500 (EST)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr140084.outbound.protection.outlook.com [40.107.14.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95B954B1B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 11:07:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQ1Te0Z2VY3QLKeCul5toqF5YfU1gWf69/DM2WNyGzo=;
 b=UD/pZyqCXR/H3MitbHZtA93qcTa4+SsS+8ITI6fV5J23HzY1E6r4lOdok1hrwBRmu2fpDu8EPJD156RSs32dS6KqHFx1d8rct96ZoUtBJRSKOajgL5HtqqTAUd/qz4Rg+hcClxGXkgbB4C5u/o70EqKcqz4a1lo8l+QMI6CiLrs=
Received: from AM7PR03CA0030.eurprd03.prod.outlook.com (2603:10a6:20b:130::40)
 by AM8PR08MB6404.eurprd08.prod.outlook.com (2603:10a6:20b:362::5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 16:07:18 +0000
Received: from AM5EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:130:cafe::4) by AM7PR03CA0030.outlook.office365.com
 (2603:10a6:20b:130::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27 via Frontend
 Transport; Mon, 21 Feb 2022 16:07:18 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 63.35.35.123) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=temperror action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT050.mail.protection.outlook.com (10.152.17.47) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.20 via Frontend Transport; Mon, 21 Feb 2022 16:07:17 +0000
Received: ("Tessian outbound 741ca6c82739:v113");
 Mon, 21 Feb 2022 16:07:16 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8392cc25391f3ad1
X-CR-MTA-TID: 64aa7808
Received: from bb7b34e8e996.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 41416247-60D3-45E1-A68F-198D43274806.1; 
 Mon, 21 Feb 2022 16:07:10 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id bb7b34e8e996.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 21 Feb 2022 16:07:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADSITfUnNyuJPDPD4z1m+PXSmMivXmYjqWvub7f6kOB0EEpI+4kfHdbdsn3RN8XQfW4+TFU58/Ut1mVb9mV0qcW1cbauZHWdsIg6IUENA0Et/2c/HCtAR3xDDCgutua69TvMKEplbBEFczrABG7WQv6GWIAHKG5jdUFmTZHNHSJNiua/SsaNjRedG6IULMJshbV2n+ulIPbOrxuBZRYOVWBiwuJcH6vUyrr2q9sjEX9mRLwLX2Ynlh5X4xOM0EzxD4Bns/VTQ497vp5KcOyss9xkeXsjZd8Xsar4RyQ5TwPV2jCIzh7hMTTcCbu27iv4ch4DM+yqscaRfFnIvySRLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQ1Te0Z2VY3QLKeCul5toqF5YfU1gWf69/DM2WNyGzo=;
 b=ViE4ndqyfeMqZgeUYTeU7wGFaRTZI5ZfBuyuZwkR5doiIFYffaN+Vfu4MnTphldFxEAmPGsV8bCHGmnHayuHt5cRW3VQMpbaoZyxjucfLsIFGyyHMt8dwhE5bNNUopEwABqypYJATFJPv8uUfa8ZgtCfrzony6bF5jQ1Pmm2jk/yPHR68lumg473MslUhiYik2BhWLj69tN7RdIPGwHt/Y9k9TD3C5eS6E35TAlU8jeNW012kKoqx3oi6B77o3okJy/0UwaXB7ltdxdXzp7ejf9ddL7D+iFZX4lcD8fqt7FjXgNE90D0TEmdbV+JQEr1hW8czcIHQNVHYT5P7a/Jhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQ1Te0Z2VY3QLKeCul5toqF5YfU1gWf69/DM2WNyGzo=;
 b=UD/pZyqCXR/H3MitbHZtA93qcTa4+SsS+8ITI6fV5J23HzY1E6r4lOdok1hrwBRmu2fpDu8EPJD156RSs32dS6KqHFx1d8rct96ZoUtBJRSKOajgL5HtqqTAUd/qz4Rg+hcClxGXkgbB4C5u/o70EqKcqz4a1lo8l+QMI6CiLrs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by PAXPR08MB7247.eurprd08.prod.outlook.com (2603:10a6:102:212::7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 16:07:09 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::dca:9146:2814:3f63]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::dca:9146:2814:3f63%7]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 16:07:09 +0000
Date: Mon, 21 Feb 2022 16:07:06 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v11 10/40] arm64/sme: Basic enumeration support
Message-ID: <20220221160706.GK2692478@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-11-broonie@kernel.org>
 <YhOihgeVRTztfDqv@arm.com>
Content-Disposition: inline
In-Reply-To: <YhOihgeVRTztfDqv@arm.com>
X-ClientProxiedBy: LO2P265CA0308.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::32) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 79fcfae4-b464-4edb-d308-08d9f5543b64
X-MS-TrafficTypeDiagnostic: PAXPR08MB7247:EE_|AM5EUR03FT050:EE_|AM8PR08MB6404:EE_
X-Microsoft-Antispam-PRVS: <AM8PR08MB64047EE4F0A85E9393C0769EED3A9@AM8PR08MB6404.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: gJcJRITGicRibPCZLT7r64dJPQyOMcXGiGlfv4LfdlFjG/zrGfioUt/+tA/RlDY39i3LeVywuS0Ms7J3tQNP80gy2ETEjK2TIBBO4FjpP70iRPxkdxZytMwh0mY5+2TAuvK11nPVqalt/tm76Vakd813SmHwozIwjXtRH3lcsfubJrOfnT8Ea8Y9g86zyoE9PSCCg6uW3IR7Hi+64DSh9SoQ85AlzXdSzpenU/SmBt+5g2a0c6rEtmUZESJpLQ3nn8eBGewRHT5ixP/w091nVIXHfPALFaLmitp4dWn5qS4SI9rmVY0xS2acWx+DRJZtZ0vBq8D0cp3aTMS7T/uauhIgiYtxux1Ivp4xZV1piUp7DPEP4MbMxJ4Y3MDGbcZy/cAHMca3fuRSdE2VnG5MZGuqnu/1LQhzJ+GwIAzbVtlH/SKUO7836dQyR6pNj53BhnVbAi8+scPWyKq+I0uXm64hYTSk5hUZGJ5+DquzZzyl1AoLSY5EkJ1IsRmmMglOBH23Cr/Zjaw6OVDKvWESAdi6nzWCldXmcWlZ3B3hbBYnMO9zIW0ILRbu4CqlqzIFnrCnVop3a0erJHiOQsAOaAeIMJRrQAaS7BwBYqxAGPYw8DQJYkao5upe87b/GPuxexPPxshOZAAtNaAwbfCIZ6s5EPjGvSQrEMHvDDBd5sIf7gWT4iIw4c88EQRj4WkjJ92wRhLEVkvO12IfYUsJUw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:DB9PR08MB7179.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(316002)(6636002)(33656002)(52116002)(66946007)(36756003)(37006003)(54906003)(8676002)(86362001)(2906002)(44832011)(1076003)(5660300002)(6862004)(4326008)(2616005)(508600001)(6512007)(26005)(186003)(8936002)(66476007)(66556008)(6486002)(6666004)(6506007);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7247
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: a6ec36e9-1e36-45a3-6760-08d9f554361e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Buim9Bf35bXBd4K8xysf7lRzVfjVoR22WRIReJpvKuSxxMmnLPOGfuPjrXwA6I/zLzo3Ac0kxIEB/V8t5zzYjeQjA/HNMctULt8BowxlICZjUI1yfYIJU6l3rMesC1mrBuA/TNgyP7Ppeg+oO5Ht0rNbYOCtKyoJ+8hsD9nd0OLv6+LPp1K8iGl+Xc3CcJbS7070SrhbURQVBBW1hoLySPPFSebDemrnOF1efH+qgSpMygI7RBXzlVIXfn+dwk/F2IqDgthhVXaZWum/Y1N2pe0O4ecwfQT2Jfu+7LWsCEhMbHLf1el5Y7ezTvLHVd5/NlK2kZOIhwaMaSGU1F5QIs3UE0M4/GUipvfMP+zLTGgxIU7n45gys4fkqYqKJG0kDQjmy7f/AIl6ZdfeK0ESD+w363dNo11ctS7LthlT7uP7Rxq731awOauzVixL2Me/a8T78s8A3PGxgEwr/bn1gKRuFf9X1UWZETkqcWBgAx3YzztGoccSDJ88uJKwkAP4BObqHgtYJq/VabSN6kRGyF0w17NkeEUEBVgLktwzV2nEwxHMMyPdP/lk4TaHqMklpHOHCZTISH/eEBPq4B4V2OB+QsYm4oZ2FIM0jgJvxj6OD5gEbWiw5GFzX9fjLcvOtwYTnaCUepbocQGYOXupYsjK1oEFx0ASq2+tFMXtkXPjtlh0PwyvMtPHcSyXFYl
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(63370400001)(6486002)(37006003)(508600001)(82310400004)(54906003)(70206006)(33656002)(6636002)(70586007)(86362001)(8676002)(6862004)(4326008)(316002)(36860700001)(63350400001)(26005)(81166007)(47076005)(6506007)(336012)(40460700003)(6666004)(6512007)(356005)(44832011)(8936002)(186003)(1076003)(2616005)(36756003)(2906002)(5660300002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 16:07:17.1532 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fcfae4-b464-4edb-d308-08d9f5543b64
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6404
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

The 02/21/2022 14:32, Catalin Marinas wrote:
> On Mon, Feb 07, 2022 at 03:20:39PM +0000, Mark Brown wrote:
> > diff --git a/Documentation/arm64/elf_hwcaps.rst b/Documentation/arm64/elf_hwcaps.rst
> > index b72ff17d600a..5626cf208000 100644
> > --- a/Documentation/arm64/elf_hwcaps.rst
> > +++ b/Documentation/arm64/elf_hwcaps.rst
> > @@ -259,6 +259,39 @@ HWCAP2_RPRES
> >  
> >      Functionality implied by ID_AA64ISAR2_EL1.RPRES == 0b0001.
> >  
> > +HWCAP2_SME
> > +
> > +    Functionality implied by ID_AA64PFR1_EL1.SME == 0b0001, as described
> > +    by Documentation/arm64/sme.rst.
> > +
> > +HWCAP2_SME_I16I64
> > +
> > +    Functionality implied by ID_AA64SMFR0_EL1.I16I64 == 0b1111.
> > +
> > +HWCAP2_SME_F64F64
> > +
> > +    Functionality implied by ID_AA64SMFR0_EL1.F64F64 == 0b1.
> > +
> > +HWCAP2_SME_I8I32
> > +
> > +    Functionality implied by ID_AA64SMFR0_EL1.I8I32 == 0b1111.
> > +
> > +HWCAP2_SME_F16F32
> > +
> > +    Functionality implied by ID_AA64SMFR0_EL1.F16F32 == 0b1.
> > +
> > +HWCAP2_SME_B16F32
> > +
> > +    Functionality implied by ID_AA64SMFR0_EL1.B16F32 == 0b1.
> > +
> > +HWCAP2_SME_F32F32
> > +
> > +    Functionality implied by ID_AA64SMFR0_EL1.F32F32 == 0b1.
> > +
> > +HWCAP2_SME_FA64
> > +
> > +    Functionality implied by ID_AA64SMFR0_EL1.FA64 == 0b1.
> 
> More of a question for the libc people: should we drop the fine-grained
> HWCAP corresponding to the new ID_AA64SMFR0_EL1 register (only keep
> HWCAP2_SME) and get the user space to use the MRS emulation? Would any
> ifunc resolver be affected?
> 

good question.

within glibc HWCAP2_SME is enough (to decide if we need to
deal with additional register state and the lazy ZA save
scheme) but i guess user code that actually uses sme would
need the details (including in ifunc resolvers in principle).

since we have mrs, there is no strict need for hwcaps.
if ifunc resolvers using this info are not widespread then
the mrs emulation overhead is acceptable, but i suspect
hwcaps are nicer to use.

do we have a plan after hwcap2 bits run out? :)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
