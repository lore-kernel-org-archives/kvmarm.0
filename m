Return-Path: <SRS0=sZMl=B5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB89EC433E1
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 10:18:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 55F2B20786
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 10:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="M9rnylaw";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="M9rnylaw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55F2B20786
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA5DB4B9CC;
	Wed, 19 Aug 2020 06:18:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HEB2FdT0uQGn; Wed, 19 Aug 2020 06:18:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F12F4B9C6;
	Wed, 19 Aug 2020 06:18:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC87A4B9CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 06:18:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id opug2UBy5jVX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2020 06:18:42 -0400 (EDT)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA7324B8DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 06:18:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aoi0FMwj6bC2BU/gtbl43MDFSQx1Ef2A9PggPdP8CRs=;
 b=M9rnylawN8c3PtSgn6fCs4xu/S6cOIoszPyVEKyJJleyC7Or/9vbq4tjULaT8Z6sgT3kR124LWIlxzpsKFA++XNZ02qZxtgXX6hCOYVygcOjVWEfInLrHvIJd+Nb41d/7/E/LPpDQBbMk6innNOrEUjfUIYt903PUB9uS+LdxX4=
Received: from AM6P193CA0082.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::23)
 by DBBPR08MB4632.eurprd08.prod.outlook.com (2603:10a6:10:db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.21; Wed, 19 Aug
 2020 10:18:34 +0000
Received: from VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:88:cafe::5) by AM6P193CA0082.outlook.office365.com
 (2603:10a6:209:88::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend
 Transport; Wed, 19 Aug 2020 10:18:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT041.mail.protection.outlook.com (10.152.19.163) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 10:18:33 +0000
Received: ("Tessian outbound 7fc8f57bdedc:v64");
 Wed, 19 Aug 2020 10:18:33 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8042e54646a5.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 FF78DDFD-C69A-4EB8-B2B4-1CAD106CCE10.1; 
 Wed, 19 Aug 2020 10:18:28 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8042e54646a5.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 19 Aug 2020 10:18:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QidqKe8DGygR4ITrZjs+G1xzyvrOvLOF8p3bE1NqbFDgFLqw4+atAddzVVhtEqcrw0++NZe5OLH4gfNnFxzNGA9KwhpkMwwLp2tKFB2LaZEWcwvwFdTM2qB01ZOWgVX48fEdicp738GhonYQuIMYmCMWMY42ZbHfwS5f9kS+ndnc7AUiukSEbwiSSscNVmraMx0SQ6CvlE1jz7n87g4LsjwnNLjhH+452BOpwYE+9r6jaRIgdlMM7FQhUy9F2C48nBqtnV082Rk+/RvvdGdKU/CYGUCc0kIiH4F6dn5EBUZSBprHtXySgRaIhZ6d60XR5pRstvBTeYTiwRJdgsvrIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aoi0FMwj6bC2BU/gtbl43MDFSQx1Ef2A9PggPdP8CRs=;
 b=cydiBBe69ruksHYs04AYtllDgi69XtHQafaDPMrSpGRCvzk6pzCniqM5cq2Z1rVN+7X+h7gDNg6jnMoMUN47sCZnCxnKCPVNlfSbn/tUIvx9ooRjwx2G4+90/7AuPZSL2ac0Y909t0+3VOq0YM6Z3S7ARHYgodQWAVvHC2L1M9oiOsfoRdyV/UGOnKGB4HnushwQV9F3CvOYBlgpi3LumXlJDH3YiAUzTwDDehLx6+Xj4kberFqBw2j0v5oEaEYO3qkuAU7Yo9frGrTl05PWoU4F8TR+64+C5Ny26UC8x/4Cqvu6mLZddxcasmat4xI/4yr0bF5sqCQP7It97wGT0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aoi0FMwj6bC2BU/gtbl43MDFSQx1Ef2A9PggPdP8CRs=;
 b=M9rnylawN8c3PtSgn6fCs4xu/S6cOIoszPyVEKyJJleyC7Or/9vbq4tjULaT8Z6sgT3kR124LWIlxzpsKFA++XNZ02qZxtgXX6hCOYVygcOjVWEfInLrHvIJd+Nb41d/7/E/LPpDQBbMk6innNOrEUjfUIYt903PUB9uS+LdxX4=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB1977.eurprd08.prod.outlook.com (2603:10a6:3:4d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 19 Aug
 2020 10:18:18 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0%5]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 10:18:18 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
Thread-Topic: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
Thread-Index: AQHWa1Xu75d1j9xetEK2hY75HyglSak/PN3ggAALmACAAAFIoA==
Date: Wed, 19 Aug 2020 10:18:18 +0000
Message-ID: <HE1PR0802MB25552F2502B47554C6B53CADF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-48-maz@kernel.org>
 <HE1PR0802MB2555B630F149E07AF11846DEF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <551eac52dcd3b19ae6db45dd6f6e168b@kernel.org>
In-Reply-To: <551eac52dcd3b19ae6db45dd6f6e168b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: F86E3AC848FF8E419C992080C2A9B61C.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61fbdc33-0988-41ce-c519-08d844293a60
x-ms-traffictypediagnostic: HE1PR0801MB1977:|DBBPR08MB4632:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB46324A59634EA53F58E2D356F45D0@DBBPR08MB4632.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:489;OLM:489;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 8bXqE66Sg706QvPREXnCtdkMSQUwyH/ET+CorMfSeudvTaeKiT+4XHWzj8TKq+D+7eNjlFj2n6UKUcJENscAhRMCflvqmJJU3Oh2jnZNBnmCk/wZf7sl5g+g+/IZX9/HNz8HfT0SZ6awyfX3VRXyndDkQcSrX9nVOT9TwEDiXX9lqArtfj1xXbip0xBlrl+oPsQYdH1KjmYKNMyXRmEJDQZITZ9Q0MrpZmYxmPDGd6kr/yMiRzuq6Nmm5DoZoXICHckTLKKr5cOnLltD1Vg+Zu3V/SjBBWMyWmmqU4ejjOBfw83Xy2Bxsg+ve7LVfzpJ2FIfAV3cRFNsXPOVsjq/tXdXTo4AS4eT6DxSK6TRvuS2GvfJNbU+92lFE6XtcIDCnZU76Q73x7BPPNbxqMcwiQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(4326008)(86362001)(478600001)(71200400001)(5660300002)(966005)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(52536014)(316002)(26005)(8676002)(2906002)(186003)(6916009)(33656002)(9686003)(54906003)(55016002)(7696005)(8936002)(6506007)(53546011)(83380400001);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: bhwT1X+O/D7o3QnkYMYWDCanVzkIixxQWHT7ULaxey1H/4sd1PY0kVcceGsFIZMyg0c+G+hnvluXW96X1FiWHenWSNDd3o0CrWmgZWon7i4YdCAK1++g0oogRtozZnyWfq4IZsAAU5n1/Y7O5fcJ6f+/3dePTl58bvvCjsJfiUHlCYrvl+TyyAWRZu0rCD3g7jSHhKF2Fxzv1/7qhG91wu73t+JDxypXc/vuh5ExmY7llbEym/pjZIpMq6Hl0UFUOkpjXPoaLg/Qefuvmo2+r/hQvW4DzzFVC0C0feXllfrNM2ZG4MVlguEnm1iEML/ZoS3cIar4EDMQQZigMBjOICNexY2PGS4yaqfNT7oYO601n1xiZyqZjp8oUNUQHWltQspTJovg8NaOoWRNbPPNbqcMyy9cjkWi7KKuXCC4i5cQcsXkfOudiKKnWw8dvKvWj5CKzziixF5aTwU8JO09lyT8rBuAAm0HsU1SMP0p1EswhVVymzb1EBCB0+cHHT14inUfxsfqthpgFz/23jg0h9mh0KA8sKPTiLUX/ui5dCBoetNK/n2GxnrWQtlprJ8FhkY+pis4/pUHoeBTyFda8j0pjarrLylgXEZU91A4KSKXWVkHThTMUE/hMfCL/KWV15HXt5yfqOPpbkItkRq4Iw==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1977
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: daf8c6cb-1902-4f2a-f075-08d84429317f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sWYY77G7JTDSN+Np1NrUimgqn+WwfTj59yBO3FD0vPmF4gl6E5HADyYo2Oyqqz95jm7UcrSjJulnw8NrJaX7/G2HPszBNTq2dmrYEAGLzhcwTYMluuX8/u7FHHouyHP9k6/ewBeiCBPBXdAZOGKV1YyM9dJW4Vz3xuuU2ajIhVzsbQZNwKdN1Rq/muYc83/RCLv8lOtjTzbO4aJmp7Jmzw6mqo6N758+M+xjMsdUyDMuxSaardxywBo8EkX5lnLai+p1y5vkRwhle69D/lfK7Gjls5m4JWcqBEu0IA0W4o1hsQgwbyIlXAMmrKvVm+bq7WDaBHkapdqK24ycS1ws2hMD70uHMeB4zgjvdZJIhMLfCMt2ah6KE2to1ee2RQfIjzKlG+e8DYV4Ts3x9XrpR2vSBVEgawWjqMIp94cISFDSVOmb9yuXw+WkyMMJK30+ZX3hxW6d6sDfzb7YRLef3QExky1PQCvetFOXRrbFeZE=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(46966005)(52536014)(9686003)(966005)(4326008)(26005)(54906003)(47076004)(82740400003)(5660300002)(7696005)(83380400001)(2906002)(36906005)(6862004)(316002)(8936002)(81166007)(86362001)(53546011)(6506007)(70206006)(70586007)(336012)(8676002)(186003)(33656002)(55016002)(82310400002)(478600001)(107886003)(356005);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 10:18:33.5574 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fbdc33-0988-41ce-c519-08d844293a60
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4632
Cc: Peng Hao <richard.peng@oppo.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kernel-team@android.com" <kernel-team@android.com>,
 Alexander Graf <graf@amazon.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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
> Sent: Wednesday, August 19, 2020 6:00 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Peng Hao
> <richard.peng@oppo.com>; kernel-team@android.com;
> kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
> <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
> sys_regs file
> 
> On 2020-08-19 10:24, Jianyong Wu wrote:
> > Hi Marc,
> >
> > -----Original Message-----
> > From: kvmarm-bounces@lists.cs.columbia.edu
> > <kvmarm-bounces@lists.cs.columbia.edu> On Behalf Of Marc Zyngier
> > Sent: Thursday, August 6, 2020 1:57 AM
> > To: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Peng Hao <richard.peng@oppo.com>; kernel-team@android.com;
> > kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
> > <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
> > kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
> > Subject: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
> > sys_regs file
> >
> > Move the timer gsisters to the sysreg file. This will further help
> > when they are directly changed by a nesting hypervisor in the VNCR
> > page.
> >
> > This requires moving the initialisation of the timer struct so that
> > some of the helpers (such as arch_timer_ctx_index) can work correctly
> > at an early stage.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |   6 ++
> >  arch/arm64/kvm/arch_timer.c       | 155 +++++++++++++++++++++++-------
> >  arch/arm64/kvm/trace_arm.h        |   8 +-
> >  include/kvm/arm_arch_timer.h      |  11 +--
> >  4 files changed, 136 insertions(+), 44 deletions(-)
> >
> > +static u64 timer_get_offset(struct arch_timer_context *ctxt) {
> > +	struct kvm_vcpu *vcpu = ctxt->vcpu;
> > +
> > +	switch(arch_timer_ctx_index(ctxt)) {
> > +	case TIMER_VTIMER:
> > +		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> > +	default:
> > +		return 0;
> > +	}
> > +}
> > +
> > Can I export this helper? As in my ptp_kvm implementation I need get
> > VCNT offset value separately not just give me a result of VCNT.
> 
> Sorry, you need to give me a bit more context. What do you need the offset
> for exactly?

Yeah,
In my ptp_kvm implementation, I need acquire wall time and counter cycle in the same time in host. After get host counter cycle, I need subtract it by VCNT offset to obtain VCNT. See https://lkml.org/lkml/2020/6/19/441 https://lkml.org/lkml/2020/6/19/441
But now I can't get the VCNT offset easily like before using " vcpu_vtimer(vcpu)->cntvoff" and I can't use the helper like "kvm_arm_timer_read" as I need acquire the counter cycle in the same time with the host wall time.

Thanks
Jianyong

> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
