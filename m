Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95331C433E3
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 01:07:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 090752083E
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 01:07:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="jwwk/IqU";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="jwwk/IqU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 090752083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CE1A4B724;
	Mon, 27 Jul 2020 21:07:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U3Pnt2Uwofum; Mon, 27 Jul 2020 21:07:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F18F4B70A;
	Mon, 27 Jul 2020 21:07:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 484EA4B626
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 21:07:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F1cHh8mMcyVd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 21:07:26 -0400 (EDT)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60051.outbound.protection.outlook.com [40.107.6.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 468F54B70D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 21:07:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yGnY3tCA5//GCNAc72cP1ww2KSqx/h6KdDSK9PfS40=;
 b=jwwk/IqUi7ZCRtaRkN/xrY8BklUiLwiaUCYwtB2ygRVgLW01rDTVd7qa3qXCUiissAHViq6ARF/2upSHemJ+uMDOIVqb985xqQqGoN1rI9JhQGOPRfMlDAOez/Si6ziLtevHxxR357zVP8nsY1GxAve2I0Tx5G0CPNT/ax8OYc8=
Received: from AM6PR0502CA0069.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::46) by DB6PR0801MB1670.eurprd08.prod.outlook.com
 (2603:10a6:4:37::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Tue, 28 Jul
 2020 01:07:24 +0000
Received: from AM5EUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:56:cafe::f4) by AM6PR0502CA0069.outlook.office365.com
 (2603:10a6:20b:56::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend
 Transport; Tue, 28 Jul 2020 01:07:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu;
 dmarc=bestguesspass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT015.mail.protection.outlook.com (10.152.16.132) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.10 via Frontend Transport; Tue, 28 Jul 2020 01:07:23 +0000
Received: ("Tessian outbound 1c27ecaec3d6:v62");
 Tue, 28 Jul 2020 01:07:23 +0000
X-CR-MTA-TID: 64aa7808
Received: from c4811bf5fe9f.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 31822CCE-3BBB-4FFE-B661-695E1AE4A30A.1; 
 Tue, 28 Jul 2020 01:07:18 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c4811bf5fe9f.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 28 Jul 2020 01:07:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9ljKl1hsqJ/xMHHkLe0mZHc/2grsuTAhnVny87jN5r/086Imuc8wYqQX1wZKW4wWOKYD39OilPAkUZumfW/HqAiy1qDPnnwAwLKGurlTUZixPDNYIdtD5Wmi7IMVRWgiIcXvdMSjh57anFOkhhNB7SDyNfkFy+BP2x5jL980nSE3AukJV4zrUeeXWw5f33LMOqPycEUWzNxKk3096QXNdkcAL5wacwo8UgDrxexupGykuUmgvh3q4TWx6vzkkvO0USlQOrZSgAd5rggVSOgT0KYLeoMyMStzMpnhljCg9Qzb2Cn1eoouvLziZtSAZO6aV1nRe0n/IBPnH3JS+jQOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yGnY3tCA5//GCNAc72cP1ww2KSqx/h6KdDSK9PfS40=;
 b=oAd09pOSpUl4ebyEuhlSRyCVoPib+jfPrr2vP8NjN98EnU156/TC1ZtBij8WvqltdQGFNdhhWvIChKLvdF0e2/wKSmHfTTYqCgt7/Vvh53Y0n09y58v9kuXeIeLDuDwazfDtuTfbWNjV6lG0nkioEL2jCeNJgC1FQ7yaT88QbcRV7pMlcrhTC1inrQ9o0aSnhrE9FhSSb0thhXEkxkn3bn+E+ChKf7NhRm6PNHPHdjW9RyjB7SztvXF1WKjQwbC1GAYrSHWAsi9iINstoV+OPjKsV+ldNBeM8ppRebPPLJXYG107S0h5KwYRMEegt2BnT6op+VvJGc2b41grsPLCFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yGnY3tCA5//GCNAc72cP1ww2KSqx/h6KdDSK9PfS40=;
 b=jwwk/IqUi7ZCRtaRkN/xrY8BklUiLwiaUCYwtB2ygRVgLW01rDTVd7qa3qXCUiissAHViq6ARF/2upSHemJ+uMDOIVqb985xqQqGoN1rI9JhQGOPRfMlDAOez/Si6ziLtevHxxR357zVP8nsY1GxAve2I0Tx5G0CPNT/ax8OYc8=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2554.eurprd08.prod.outlook.com (2603:10a6:3:d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 01:07:14 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9:c111:edc1:d65a%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 01:07:14 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Will Deacon <will@kernel.org>
Subject: RE: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
 SMCCC
Thread-Topic: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests via
 SMCCC
Thread-Index: AQHWRjnTCp2aKUWCLkK9Y7ZKWPQzQKka//qwgACIboCAANxJIA==
Date: Tue, 28 Jul 2020 01:07:14 +0000
Message-ID: <HE1PR0802MB25551F426910F76E95523383F4730@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200619130120.40556-1-jianyong.wu@arm.com>
 <20200619130120.40556-3-jianyong.wu@arm.com>
 <HE1PR0802MB255577943C260898A6C686ABF4720@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <20200727113821.GB20437@willie-the-truck>
In-Reply-To: <20200727113821.GB20437@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 2c2709e5-9248-405e-95a3-96a1b63a0504.1
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9fbd1faf-6c98-40f7-a9bf-08d832929606
x-ms-traffictypediagnostic: HE1PR0802MB2554:|DB6PR0801MB1670:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0801MB1670DFD3BDC6F58707544745F4730@DB6PR0801MB1670.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6430;OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: AHL81wIJOSyir2m00PCT9y9xNDdjIz51KbLICp9O9BiF/N5ZRflFhwN3N7a7gNpgQDagidwtApFMVVnB97qGTTwmkVo+JAkLd3QnGhxY0h32UE5TUanfrIVzMIbOkjF7Vg2vyiy0lDVdV2Yjg8a2UkohlFrByuYvheH+bp4Zc8IGxIN6x6NqqyhdhtxY00aYy9CpAxVIlWNhIKShhmKfFPtMSoDugiOIrBA/LZDGTo3Z2FGYz3niW/UgC7+eSBzLvhxBlzBhK53ISLUZfGlxpdNdg/FQPcdFlx3zCjZ3wurw9zyW439QWopSgaC/zbbw3feXYae9Q0Mzv+8XahjFow==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:HE1PR0802MB2555.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE; SFTY:;
 SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(55016002)(9686003)(54906003)(316002)(71200400001)(86362001)(8676002)(6916009)(186003)(7696005)(6506007)(33656002)(83380400001)(26005)(478600001)(2906002)(5660300002)(76116006)(52536014)(53546011)(66476007)(66556008)(64756008)(66446008)(8936002)(4326008)(7416002)(66946007);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: 94HlQIIz6WNdy4B8Lx8VxYdgF4ydylsCuvc6vZP7Van6cZxC9Vg6KBh5p3z+qgpOSB+Q7/2IoUwUtswBlRp4NKRESUhrayTTaLWditzQhgDBbJ7tQ3NYiBOLdVjJWsssGvd7OHT41nTrfcTICVVpyD99uYmGxFMgQluuWSfZrR3c3+f2+minrVvrgMhqzv+iPVNbpbrVTK3MUZrcLb9ELS5lv0/JvaHjZKwON6mOL+c9+XtJ7xnkDqsnoIh5+ZPFq/jFbFeRSZjuzHBHJKeJ6C+Lq+rCcml3f5kupXU8H2VqfpT8wUrJ89de0H0iF2NIDc5o+Xk958hvq+bxMR/iZ0EPzIBih9necqFDxT7Vbji89/24Aq4sVYX9li3bmsE4J11hlBz7IMTa0nZayFKp7AceXfLO0FMi/wMhWNKH1+5WooKjAfU+hIDH1xpsGFcV9tOeS0hxC/951S0O1ex7bGDkWNPBYSoq+sbNxpTie1E=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2554
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: f87590a5-58f3-4827-72d1-08d8329290c6
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pO26lOMK6dOz1arpyxPfsAOXcNnQHgDP139QgyXa5ALjfISqIjwKdo8TuzOTOdhXtjKy3NiocC5vM6fCHVSBrsmKr9odtzu3aVE6HzAUB0QkzPbE7cOD5TNQdYsd+uQht2+m9F/HYNA66h/ihjvKR84pZGI5sIIBTWUdZzra3mt/Vqhudd7BWKCHaEubALZmDScW3O+h+TbfW1QGmxfGZ9cVFa0DgjhKqL81WA2JCHtHkvkO+AhXxRhs7xDGnVGOOF6rMRDLPZ+FGS7cUMZn4fYHcfGUNKS6jc3+MvL3k9NYveSDMxcDwa47rQrkVCo+dYqjQOHDQHcyc7xSlgXLT9MK4BGhOnTvbKavd3fx9hoU/tSKSxxmoigGYm/CmvHLr6w8GfnVevIYFVh/ZwFCOw==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE; SFTY:;
 SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(46966005)(54906003)(86362001)(8936002)(7696005)(47076004)(26005)(83380400001)(5660300002)(52536014)(33656002)(186003)(53546011)(6862004)(55016002)(6506007)(9686003)(82310400002)(36906005)(336012)(316002)(478600001)(8676002)(356005)(2906002)(81166007)(4326008)(70586007)(70206006)(82740400003);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 01:07:23.5788 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fbd1faf-6c98-40f7-a9bf-08d832929606
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1670
Cc: "maz@kernel.org" <maz@kernel.org>, Justin He <Justin.He@arm.com>,
 Wei Chen <Wei.Chen@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 Steven Price <Steven.Price@arm.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, nd <nd@arm.com>,
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
> From: Will Deacon <will@kernel.org>
> Sent: Monday, July 27, 2020 7:38 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; Suzuki Poulose <Suzuki.Poulose@arm.com>;
> Steven Price <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; Wei Chen
> <Wei.Chen@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v13 2/9] arm/arm64: KVM: Advertise KVM UID to guests
> via SMCCC
> 
> On Mon, Jul 27, 2020 at 03:45:37AM +0000, Jianyong Wu wrote:
> > > From: Will Deacon <will@kernel.org>
> > >
> > > We can advertise ourselves to guests as KVM and provide a basic
> > > features bitmap for discoverability of future hypervisor services.
> > >
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > > ---
> > >  arch/arm64/kvm/hypercalls.c | 29 +++++++++++++++++++----------
> > >  1 file changed, 19 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/hypercalls.c
> > > b/arch/arm64/kvm/hypercalls.c index 550dfa3e53cd..db6dce3d0e23
> > > 100644
> > > --- a/arch/arm64/kvm/hypercalls.c
> > > +++ b/arch/arm64/kvm/hypercalls.c
> > > @@ -12,13 +12,13 @@
> > >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> > >  	u32 func_id = smccc_get_function(vcpu);
> > > -	long val = SMCCC_RET_NOT_SUPPORTED;
> > > +	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
> >
> > There is a risk as this u32 value will return here and a u64 value
> > will be obtained in guest. For example, The val[0] is initialized as
> > -1 of 0xffffffff and the guest get 0xffffffff then it will be compared
> > with -1 of 0xffffffffffffffff Also this problem exists for the
> > transfer of address in u64 type. So the following assignment to "val"
> > should be split into two
> > u32 value and assign to val[0] and val[1] respectively.
> > WDYT?
> 
> Yes, I think you're right that this is a bug, but isn't the solution just to make
> that an array of 'long'?
> 
> 	long val [4];
> 
> That will sign-extend the negative error codes as required, while leaving the
> explicitly unsigned UID constants alone.

Ok, that's much better. I will fix it at next version.

By the way, I wonder when will you update this patch set. I see someone like me
adopt this patch set as code base and need rebase it every time, so expect your update.

Thanks
Jianyong 
> 
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
