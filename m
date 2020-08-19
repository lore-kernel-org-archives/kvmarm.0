Return-Path: <SRS0=sZMl=B5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52604C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 09:24:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C412320639
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 09:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="+RIJDjml";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="+RIJDjml"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C412320639
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FEA44B99F;
	Wed, 19 Aug 2020 05:24:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 24Sn+swvJOeg; Wed, 19 Aug 2020 05:24:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 297DB4B9AB;
	Wed, 19 Aug 2020 05:24:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26E124B99F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 05:24:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XFNSSgjXzf5j for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2020 05:24:52 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0CFA4B91A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 05:24:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSq44xjI3XI1g+8VO0sjPh+8S8KOyRLvZnLDVUs4OZ0=;
 b=+RIJDjmlKfAX09SvJgT1gQq787T+HmKMMl2z7Mim8uL19xXpEw2GVeA+2HVvk9RMlTbiuj48fkKKZQBnfpsDNtBYO/angvG5xAQFuvn0p5L0fUpRLvnoU8Rf21Pz4fFgvqqT10YrCrUbf3RYkgPloavFlF5YVWEcDpVvvWRBDN4=
Received: from DB6PR0501CA0005.eurprd05.prod.outlook.com (2603:10a6:4:8f::15)
 by AM6PR08MB3751.eurprd08.prod.outlook.com (2603:10a6:20b:84::27)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 09:24:49 +0000
Received: from DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:8f:cafe::c) by DB6PR0501CA0005.outlook.office365.com
 (2603:10a6:4:8f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend
 Transport; Wed, 19 Aug 2020 09:24:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT005.mail.protection.outlook.com (10.152.20.122) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 09:24:48 +0000
Received: ("Tessian outbound 7a6fb63c1e64:v64");
 Wed, 19 Aug 2020 09:24:48 +0000
X-CR-MTA-TID: 64aa7808
Received: from 0a134c5af661.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 DC653A3F-3496-4083-986B-DAE4821657C0.1; 
 Wed, 19 Aug 2020 09:24:43 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0a134c5af661.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 19 Aug 2020 09:24:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0DCRWq/UNL/wIABNnI8Sow3AIHPDvdyi6GOXgUEDV92H2eYGDHuj8FQdkIdRuIteZFRNiakOtjQQ6jLWbF00+Nz1c3LRYOQQpisC14iohv87aN3pP7KDx1/Wqe6GCH45osffozFkMUpvNwrT3J3dghpcTb7LTWgW/TnCr+QD1aRBmJFSrNG/BVYszmX4PDbFBKUAUReHBRPfsDOOt0PNeqNJHtCE2V5jl4vhrko1URkandvg76BYtT6B0RsDlNpuzdaiP2rKq7C8qMJN+uEPrGJJADsEXDPT1xMmBThHTmr4I+BUJVnGC2Q1sqckcOBFDV4d9MNC7meEZdh0n1eag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSq44xjI3XI1g+8VO0sjPh+8S8KOyRLvZnLDVUs4OZ0=;
 b=GC2WzO/n5a4J552AS9JUBDF8esGxw3JFHdIV2xfTcQ4jPWg2C6s5pOvGT45PpKYWj18ysz5prfFGs9pUoXO9nP+B0Kcz3NDsEFeQRdFQ89kBR2peVcV5B2dMjInOwBHIScrz0uo3gEpEtC2TECzV5S2/As+jA/jOPu61Zrc43gl53K3v+KOoh6p+pyxfxRn16Y2jvreHqQqqH9XFaIQHrTxT3pMyMKsEzuUZ9nQuNQML78PBT+OrnOL+YskNS2pPtx0nHdY19fDZcQqJnc3Iq3eUVrvOI4PRfmK8GuGKMuBPEPMGHXZMiqS9mQHwpA0A7nF8eDNGkw9v/qrbKrUivQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSq44xjI3XI1g+8VO0sjPh+8S8KOyRLvZnLDVUs4OZ0=;
 b=+RIJDjmlKfAX09SvJgT1gQq787T+HmKMMl2z7Mim8uL19xXpEw2GVeA+2HVvk9RMlTbiuj48fkKKZQBnfpsDNtBYO/angvG5xAQFuvn0p5L0fUpRLvnoU8Rf21Pz4fFgvqqT10YrCrUbf3RYkgPloavFlF5YVWEcDpVvvWRBDN4=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB2108.eurprd08.prod.outlook.com (2603:10a6:3:51::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 19 Aug
 2020 09:24:40 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::a457:845c:78c6:29c0%5]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 09:24:40 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
Thread-Topic: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
Thread-Index: AQHWa1Xu75d1j9xetEK2hY75HyglSak/PN3g
Date: Wed, 19 Aug 2020 09:24:40 +0000
Message-ID: <HE1PR0802MB2555B630F149E07AF11846DEF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-48-maz@kernel.org>
In-Reply-To: <20200805175700.62775-48-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 174DC4FF4714444F8D113E09FD85505A.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6dd3cebb-9ed3-4e5d-9a52-08d84421b7ed
x-ms-traffictypediagnostic: HE1PR0801MB2108:|AM6PR08MB3751:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB375122E65C6A3E85ECDFDA44F45D0@AM6PR08MB3751.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6430;OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: J9pWIrWyTZC5H7woAIreXTaNg8mDcZdRaesu7t4hSL9B3n0sFGEENN6TJt2+HXnev4Dp0I4H0B3JiCowkgBbdN99dsdFRctaZ37YD4nDcZD+niu0pn2jUETSerDjga4apKQghlSRke3yxzd7PgCNHIVCttxvzAHRjQdF7ZCFXS84Xyf9XRF5xMixknLWHP6M6JHXccGNwiHnDbj/U4uEGliSqe3WYey2b4+SYKE4r8sjt+pdGvrtMHUDz+N55y/UHeKDkPV9utgI/MItuTUGHGIVaTbRy+hJZztB/idLkSDflMRD7pejOVhrC7UXnDxCACXyeNKrkZ2+ALTHoBLevUoLo6kOYSwWrFZ51SSNNye7V682nLJmRLbthGMdTk4f9W1MQV1hocLHOTvyPNgXUw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(33656002)(66946007)(76116006)(2906002)(478600001)(83380400001)(966005)(71200400001)(64756008)(55016002)(8676002)(316002)(4326008)(66476007)(54906003)(26005)(110136005)(53546011)(7696005)(66446008)(86362001)(6506007)(5660300002)(186003)(9686003)(8936002)(66556008)(52536014);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: VsY8w211r3WIisHP/miFPjaRs4SdXz/DGe89jj88AxtB9k2K9XSNVUbk9aOHTo8/Exo5S3TPHs/sfwoYK5kD0ZSNlXRkX9neZcgftbW1S5y5pLIFdJTVL5UN02JeT6EJmuwduJSI+/eoT6ActbdmHnAvODpNzFCOXtq5PcX4TRI3w7LdlRbxQloNGa7T3fqqde4wi20S/dJQoi2ros4L+7mmDYX+28PG8HdLO8TflCucsCfwje7g1ze5sqiPEUNsl3Weit8IeH1yO9p6+be6TggtEh53DMqYWXxfKX7/ajlM2YchLq3oZHISHxIbwSTRWeact0bvN86rsI8VvGmY1+kaSmhmAwRLgTkqy9nqbsHgOgEZ3IZWxhmUAKnj+68fRfch1s8phLwACVg3X4cN5DdSuiwnMrWKekEejVizqhPEOqRoxZ4cLN2Vtoyz63n5mKmujVHKpv0XUvgpArug+XiQp52isXiGcBKzBHkxl8nh8vzM+seC5KAXmFHIM9lNRg2VDR1QCt0p+W0wouPh93645usIcqeIKN1VrAPxiGi2KSiKW09u6HGW5aN+XTt025sI5FKOShzfc/Vx4lJ4qjTJISmWRkuUtUibRUCkAKrLYZiAuLpItIb06KJw+g4WCVDWMIFQTCAWmgQHd+4taw==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2108
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 28bc0b19-aba9-4daa-3746-08d84421b33e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IsmON86i4irA+evSAjTxgiheS5tkcV4GweLawSzjpAwzlTbJE5Z5gnwCCPPB/hykMWu+BJoAde2Bfwz3AYVK+Zw4DIIEPC9POWOuNahFBGLGP4WLrnflFo11tO0GWNiRXUXouj3b4fdWfodoPGIgsbQhSCRHZQLoYsfQ852JHvRrysC2+y1mQXqK28SW00ozRjpvWY9xwn2fnL/VSEyWQFdZpPz1JeDOlq4XkwCtgtchHTZqj+YXrtY4BEyBr1bdJk0F8lwCpSYNSOyH4QOnfQlRxQNeiojuoU62dA1+DB5L5LjOhMHQwscO8/XUsAVjvxxloZVqoaH2yUq0TdH8EYgV5zE8Hx5BYrQRkIN9YwrDv0O/qM4VTlbuhlRmXiBjN0YpOOfCo4bf+zMHk2m+cwC8UieWpcSnomOv+SJYO0VpR0Gu8XBd54gn4OvpMjIQW7koGMGOASpEGK2rcKhTFw==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(46966005)(54906003)(2906002)(356005)(107886003)(81166007)(52536014)(336012)(82310400002)(86362001)(47076004)(70586007)(82740400003)(478600001)(53546011)(110136005)(5660300002)(6506007)(26005)(966005)(70206006)(186003)(9686003)(8936002)(8676002)(316002)(7696005)(55016002)(33656002)(83380400001)(4326008);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 09:24:48.3216 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd3cebb-9ed3-4e5d-9a52-08d84421b7ed
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3751
Cc: Peng Hao <richard.peng@oppo.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kernel-team@android.com" <kernel-team@android.com>,
 Alexander Graf <graf@amazon.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
 Will Deacon <will@kernel.org>,
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

Hi Marc,

-----Original Message-----
From: kvmarm-bounces@lists.cs.columbia.edu <kvmarm-bounces@lists.cs.columbia.edu> On Behalf Of Marc Zyngier
Sent: Thursday, August 6, 2020 1:57 AM
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peng Hao <richard.peng@oppo.com>; kernel-team@android.com; kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>; kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
Subject: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the sys_regs file

Move the timer gsisters to the sysreg file. This will further help when they are directly changed by a nesting hypervisor in the VNCR page.

This requires moving the initialisation of the timer struct so that some of the helpers (such as arch_timer_ctx_index) can work correctly at an early stage.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   6 ++
 arch/arm64/kvm/arch_timer.c       | 155 +++++++++++++++++++++++-------
 arch/arm64/kvm/trace_arm.h        |   8 +-
 include/kvm/arm_arch_timer.h      |  11 +--
 4 files changed, 136 insertions(+), 44 deletions(-)

+static u64 timer_get_offset(struct arch_timer_context *ctxt) {
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+	default:
+		return 0;
+	}
+}
+
Can I export this helper? As in my ptp_kvm implementation I need get VCNT offset value separately not just give me a result of VCNT.

Thanks
Jianyong 


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
