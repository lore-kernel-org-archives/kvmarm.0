Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28FDC433E6
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 08:10:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 332C322228
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 08:10:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 332C322228
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2D24B201;
	Tue, 26 Jan 2021 03:10:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oLty4x+C25Oi; Tue, 26 Jan 2021 03:10:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A92C4B203;
	Tue, 26 Jan 2021 03:10:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF6044B1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 03:10:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3vB+rV7gQMWi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 03:10:37 -0500 (EST)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DBC64B1D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 03:10:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTZPMdR2MVvta7aQ12Zybjj+sxFy0qgLJ/eNd+KHFwo=;
 b=AwG0uVtlnVTHi0llbiI6KgxxW9/mudAbFNYbeP0Tr2fWM/d9MJeYsrRzCw+i4IBVw4ocr7+kNmm4Kpeqxr3kMvnvu9L0Yiz8hBRjZ2vPY78x/JBywj6MaAuEZxHQLbiANwA2MaLEiphgqwGG5IHh/Ad3HC4aHueRtSOuv6ny+hw=
Received: from DU2PR04CA0123.eurprd04.prod.outlook.com (2603:10a6:10:231::8)
 by DBBPR08MB6267.eurprd08.prod.outlook.com (2603:10a6:10:20d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Tue, 26 Jan
 2021 08:10:34 +0000
Received: from DB5EUR03FT040.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:231:cafe::23) by DU2PR04CA0123.outlook.office365.com
 (2603:10a6:10:231::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend
 Transport; Tue, 26 Jan 2021 08:10:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT040.mail.protection.outlook.com (10.152.20.243) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 08:10:33 +0000
Received: ("Tessian outbound 4d8113405d55:v71");
 Tue, 26 Jan 2021 08:10:33 +0000
X-CR-MTA-TID: 64aa7808
Received: from 1dc45c7c14f4.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 07E588EE-273D-466D-80A0-36E03AEB6117.1; 
 Tue, 26 Jan 2021 08:10:28 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1dc45c7c14f4.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 26 Jan 2021 08:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R06soLMzKabtIj5ogFfV5nEwaSr4RW0mx60qUD3ljI7FMgnm297tdM9079880w7W4JB9NPnLPDgEfELwt+K1/5sDCHKQ2IlrD5WppOxLT35jyB0/IDrjDlKOTWTI2rqLa2INusRzI1jG3J/0fQiqrcBQqDFTryB5oidSOoIZwdxcQ+7QyqrwnlMyVTlEVt2RB1NShCinNETJwriTXWWweX/qZX17fHCIy0+/azncnDPL7RGzeIpuFNK9qzueIenDShEQuGutifQ4Pnle6ylzusQ/HXRWG7n1XmlIpXu0shIqkrPZGMgHOdkfsqnLyt3Mww99fgvqXwzPMTNIlwRKoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTZPMdR2MVvta7aQ12Zybjj+sxFy0qgLJ/eNd+KHFwo=;
 b=TqCFN1HEjv9KrVghbaAJGPqXC0r2d9nc6p6SvBn1p+3wfWDetUp2LFtpYGk3aqv4Yk51xzRopA0nmVBC6fAbT/TPOKlvgUrnFmk1aKtlDfsEHV9hL2UYnfi+XOw9/04/CrtG4SslVOL+EM5ncZjw3l+GlhtWADReuKfzAAqDagC9TJE70KF1WUko7sE2AilFPT6uP7Q2D0Uemuq58no+Btd8rQ80W6LpbPlnvnWShnewyIpXrTBWK+suX1CSLIu4HrCz5IOIOlKLNopqQ7U0CX3hjYwcEYTNuMXdDVE/KCTYPjTNwJ3eyM0Sc0wlx+GRPBDByFsAfJu0OKg1ekHtgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTZPMdR2MVvta7aQ12Zybjj+sxFy0qgLJ/eNd+KHFwo=;
 b=AwG0uVtlnVTHi0llbiI6KgxxW9/mudAbFNYbeP0Tr2fWM/d9MJeYsrRzCw+i4IBVw4ocr7+kNmm4Kpeqxr3kMvnvu9L0Yiz8hBRjZ2vPY78x/JBywj6MaAuEZxHQLbiANwA2MaLEiphgqwGG5IHh/Ad3HC4aHueRtSOuv6ny+hw=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VI1PR0801MB1678.eurprd08.prod.outlook.com (2603:10a6:800:51::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 08:10:26 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::11f1:cc3d:cb34:b3f1]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::11f1:cc3d:cb34:b3f1%4]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 08:10:26 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Topic: [PATCH] arm64/kvm: correct the error report in
 kvm_handle_guest_abort
Thread-Index: AQHW6yEqdqBYWsMmd0S229FS8rLcnqooiq0AgA+gwQA=
Date: Tue, 26 Jan 2021 08:10:25 +0000
Message-ID: <VE1PR08MB4766C767F3ACB3D774B4EFE8F4BC0@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20210115093028.6504-1-jianyong.wu@arm.com>
 <6f5a2ce458e33f879635f45140293517@kernel.org>
In-Reply-To: <6f5a2ce458e33f879635f45140293517@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 5E2CE815D1FDAF4A9D7369724381B207.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 77e803d1-c142-431c-2789-08d8c1d1daf3
x-ms-traffictypediagnostic: VI1PR0801MB1678:|DBBPR08MB6267:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB62675165D2FA46FB65A2D01BF4BC0@DBBPR08MB6267.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1303;OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: kHXpLJqUQ9AE0JUQQsDoe2573FSazuMMLtD8yQO4agd3i6XNIssNDFTdsH9cfIh9WErS/bNPN+DLjVEM53J4WOsGP/v9z/E4A+XPvxTGnBY5nGZEZQrz2dVS9x6zZ+1rDPDe5CWgRjSFZca69pTWA1nJ1+dvi1a+xYj7J/yksymXML0pMViR38DA5W5j/NQiKdGrb/hxVFfx6vvuT/tD6yPH5FCPG3bebzY4CNsEDiOe8D3FcRLg1O42J9zWCRqT4EY/PJCL6gEWoqojE2rCLIdjk+LMTxQt1rfQPQQDnv8C2VCS71ASpm/vFiASo5XiKo3jJGpLNdfCcGHgNVajntIWUAWYBzZxCWXzHTFuR0yrG3E4bMm1t7qp5nK1p83JF9xJwmEP38rP2nDsyGuBeg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VE1PR08MB4766.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(83380400001)(76116006)(66476007)(71200400001)(5660300002)(33656002)(55016002)(2906002)(316002)(4326008)(66946007)(66446008)(66556008)(64756008)(6916009)(54906003)(478600001)(8676002)(8936002)(9686003)(52536014)(7696005)(26005)(186003)(86362001)(6506007);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Ul/00gbPjCgxXVxNMY+lJn4su9CC9JhVGl3ugMKkNHgADuPraahu4VWfvDCf?=
 =?us-ascii?Q?iVO8Vtbxytdb02NNe/JOTs+xOQgwY9dJqC9hPeNABLmKIH9NWpG58JOg3G8H?=
 =?us-ascii?Q?keNrkDwMW7dC+4NSn5yBoS08DiFlPB/PfOdFq2JDRNjhKY2FZ/mGDDnbYu4E?=
 =?us-ascii?Q?uviRaMAfY/rX/30oVcztZPJFPClBeMRBNCNvzEAO+H8Rkb7LcH+dW7Rwjx16?=
 =?us-ascii?Q?tGDrDAdk+IuZXmwvx0hQ74yUDsxDrRnR3JaLE3w+1uq/rmRL47MLg2YIQjRB?=
 =?us-ascii?Q?WJ1ZiG/ydU/M0wd/yFQRYIbZp5fY+bmsrc63bVnp7LGvXtz98PyGMvGqPlVL?=
 =?us-ascii?Q?mVteT5y+mny44rzD1dpIMFVifY5AcXaShJXCPKxDaid3023NTvMA1okPgxco?=
 =?us-ascii?Q?1bqJOe2KwP8PaU9iU5KXITv23K8DsEriGQrbDYgQ596ooWO9iMV8GAVicR7+?=
 =?us-ascii?Q?bsNblIiGGu+VYNPuOLUVrXyQTnzUxDs++b9jx4lIBeM1FeD7V10PQ3gGaU2+?=
 =?us-ascii?Q?Xh4H/z04OEmy1X9plWP0UOi0TdEE+zQBloK1SF2j3KMs7QCIVdIqOcq2SyJb?=
 =?us-ascii?Q?IN2xpLBIlGQ/Jjy7TCWXX4YGIUOwMErIVHsnFRLK3a8rKIWcx3kBWPnIXgVH?=
 =?us-ascii?Q?vxcFdUPz8ivXWo6KQvVtITFJuxawoDTkN18TLOQgzzSSgyVjZo8uJTp8aKnx?=
 =?us-ascii?Q?Z4az0+IWfjIJfhOrh5DlXxDiDMJvbuYk68L6rwpiH2Z1ovKlB/67AW0ICozO?=
 =?us-ascii?Q?jdZHczXJMbG4osUr0/ydhacpSj85OzLaqIV0M2/iTfOu1RTiVGVzPkFo424a?=
 =?us-ascii?Q?+X0JmY+tCWNXwaBRWsznTQf8eKbLb94EuPpqytnEfxzAwrzjs422PvVkk4pT?=
 =?us-ascii?Q?G8zzcP/xp9c/KThh7Z84QBgbIkGJZM2QICocfEaUSlkdthKUPeLHIJSCcDf1?=
 =?us-ascii?Q?JBQCXTy4gIQ9z8EVtiDVr/Pd/IdEmivhWHccS+NuqM7BtCMROehlSwZUm3ML?=
 =?us-ascii?Q?EIOwT/O2G8NUlXlB9zEzIJnVKypIZK9CJILBlVKywsEM5eNRAGr3tu7sbxLV?=
 =?us-ascii?Q?MaHGV80g?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1678
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 338d99eb-0c54-4820-afe1-08d8c1d1d66b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMEir+oYxjv0r1cg30Cz+ibOuLZ0IBIFMuCr14VEm6IhrocxQyif/xCK7TTpgFw3FYaXFQaJzYLbO2iL1Mw3/xHatlAyMW+bVCrWiKpU/YRJfML5sVsyqe+puR2wX5PpHu0yrlnE3Ko11QnGVhAWy4EVIFHhKAU7Rp6FNze2Q4WLk3qIN0Iszm0KiQjO33vX5Mrr96YdhLd/LNk5x53QTG1hBsx8eDFYtuSThABpgT001KeAPxuRBbl4k3UAFa18wazxu6hw59zg4fj3LyAYV+2T5Dyxo8CGFTAoXsldhkCsVJSbV3OrQYEDVvcQvmcu89ZGOJsurYkxzcKeuh/GnCri1gTPG3f3YinFvRu8uC8irhW74kDpnQz6GVxIUsF18VGAIhn6Fr3ImBkXGmeSLaiWt7QaNPfqnFy12XVXXYqvg7aYNq7iblGbZjeyoyoD9Sf2txGA+gfAAqlAsvXqiQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966006)(8676002)(7696005)(336012)(81166007)(316002)(70586007)(478600001)(2906002)(70206006)(54906003)(4326008)(47076005)(6506007)(26005)(33656002)(86362001)(82310400003)(5660300002)(6862004)(186003)(82740400003)(83380400001)(8936002)(55016002)(9686003)(52536014)(356005);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 08:10:33.8539 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e803d1-c142-431c-2789-08d8c1d1daf3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT040.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6267
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

Hi Marc,

>   		/*
> -		 * Check for a cache maintenance operation. Since we
> -		 * ended-up here, we know it is outside of any memory
> -		 * slot. But we can't find out if that is for a device,
> -		 * or if the guest is just being stupid. The only thing
> -		 * we know for sure is that this range cannot be cached.
> +		 * Check for a cache maintenance operation. Two cases:
>   		 *
> -		 * So let's assume that the guest is just being
> -		 * cautious, and skip the instruction.
> +		 * - It is outside of any memory slot. But we can't
> +		 *   find out if that is for a device, or if the guest
> +		 *   is just being stupid. The only thing we know for
> +		 *   sure is that this range cannot be cached.  So
> +		 *   let's assume that the guest is just being
> +		 *   cautious, and skip the instruction.
> +		 *
> +		 * - Otherwise, clean/invalidate the whole memslot. We
> +		 *   should special-case DC IVAC and inject a
> +		 *   permission fault, but we can't really identify it
> +		 *   in this context.
>   		 */
> -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu))
> {
> +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> +			if (!kvm_is_error_hva(hva)) {
> +				spin_lock(&vcpu->kvm->mmu_lock);
> +				stage2_flush_memslot(vcpu->kvm,
> memslot);

Maybe we should not flush the whole memslot here as every "dc ivac" only work on a range of memory with cache line size. So what about using:
stage2_apply_range_resched(vcpu->kvm, fault_ipa, fault_ipa + cache_line_size(), kvm_pgtable_stage2_flush) instead. It will a bit faster than flush the whole memslot.
Also I test your idea of "unmap after flush" using:
	stage2_apply_range_resched(vcpu->kvm, fault_ipa, fault_ipa + cache_line_size(), kvm_pgtable_stage2_flush);
	stage2_apply_range(vcpu->kvm, fault_ipa, fault_ipa + cache_line_size(), kvm_pgtable_stage2_unmap, true);
then I do "dc ivac" on the rom of 128M twice and got the double time of around 11s. it means that there is no optimization when do the second "dc ivac".
I'm not sure if there is something wrong in my test.

So what about just using " stage2_apply_range_resched(vcpu->kvm, fault_ipa, fault_ipa + cache_line_size(), kvm_pgtable_stage2_flush);" instead of 
" stage2_flush_memslot(vcpu->kvm, memslot);" and let the guest bears the disadvantage of low performance. 

Thanks
Jianyong

> +				spin_unlock(&vcpu->kvm->mmu_lock);
> +			}
> +
>   			kvm_incr_pc(vcpu);
>   			ret = 1;
>   			goto out_unlock;
> 
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
