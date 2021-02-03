Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,RAND_MKTG_HEADER,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96327C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 02:40:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD99664F68
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 02:40:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD99664F68
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A2B84B1C1;
	Tue,  2 Feb 2021 21:40:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GopzO8BP0nFq; Tue,  2 Feb 2021 21:40:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D4D94B1A3;
	Tue,  2 Feb 2021 21:40:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32CD84B19E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 21:40:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HHGkqTYsHc9o for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 21:40:16 -0500 (EST)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CDD94B17D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 21:40:16 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFXjXYSRV14adE+oYnZbSzhxfG+NY7OflPnHaFFtaxc=;
 b=Iib6CzUu+qwOcidHBSuyJptr35Z30WByIEc/KxsNoc4eT3TCNB0mlzuQxnwDkMnllyXIVNislWkObKYlaJ0AuHCfkCSC6IWaJyCVdAeYQNPqWpXP7nBucDtTHDCJWfP1lsSZCSYES+4EvG7C2G+BwksRxh2TK3SrFuY+yX4uIyc=
Received: from AM6PR10CA0102.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::43)
 by DB6PR0801MB2022.eurprd08.prod.outlook.com (2603:10a6:4:76::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 3 Feb
 2021 02:40:11 +0000
Received: from VE1EUR03FT037.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8c:cafe::8d) by AM6PR10CA0102.outlook.office365.com
 (2603:10a6:209:8c::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend
 Transport; Wed, 3 Feb 2021 02:40:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT037.mail.protection.outlook.com (10.152.19.70) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11 via Frontend Transport; Wed, 3 Feb 2021 02:40:10 +0000
Received: ("Tessian outbound f362b81824dc:v71");
 Wed, 03 Feb 2021 02:40:10 +0000
X-CR-MTA-TID: 64aa7808
Received: from e9c949aab3cb.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 708CDFBA-E84B-4EF0-8105-47DA71E5DCC5.1; 
 Wed, 03 Feb 2021 02:40:05 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id e9c949aab3cb.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Wed, 03 Feb 2021 02:40:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C578B3lmOr/oJAOVLZng2rVOr7ctzZOR/b2LKNJ2C3GVZj+5ePlKEoQBmjUZN0oLEoN+aLm7pKVfKUdbYDVPlSXviVPBM9L1rPmbH3Ku6jeiUB2b672UAhgZnhEPkhVnhVzRTb6c3v5Nmz88eFermmn12dbpTabmqHzk3q6Orru7bcNL2XgSFtbiI0sMoc11fZCMG24pC8/89SzllkZk7Hp0ZewF6zQfv9lhg1HxAIVBFWgGwxMVS7iydDquCP8JfFvQ0aSMOUKfn7wwF1GIXLWqSME7S61u+aRxn7dKXxPae2be8W/fp3e6G4fwmmlxaDUVTy+S+UYjkyskuk4pgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFXjXYSRV14adE+oYnZbSzhxfG+NY7OflPnHaFFtaxc=;
 b=RGY2NukUpOESSTLs+t/Hlv9WSsK2sRPZI1mJCLuYBVQy0AvqjnI6DzI+wKbbzfv+lMjv9HfVwc3uyo/8hvQpJFOLkcd67Wua5KcET1NKBi0zu9ntF8rKT450qZqs+wPJXd4MrhV0sFfVP9B2XsGq+FMEcShuScT7AACJ8v95hknyR6l3RTnRx7qChMxkNIryTmZEvRrTLqJGDnMsIr3fl6xtcZsIXFPI5TvRPiIewYmLcl4qVBMnHunhBlPb/hP1M7p9sQGX3nVCnwShicdRZA/9MQlBHnL8x++yBk4AqKV9eyKfQuKr5mlwmG0SPHQoa+hc0z2MyYszrBoHe7GngA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFXjXYSRV14adE+oYnZbSzhxfG+NY7OflPnHaFFtaxc=;
 b=Iib6CzUu+qwOcidHBSuyJptr35Z30WByIEc/KxsNoc4eT3TCNB0mlzuQxnwDkMnllyXIVNislWkObKYlaJ0AuHCfkCSC6IWaJyCVdAeYQNPqWpXP7nBucDtTHDCJWfP1lsSZCSYES+4EvG7C2G+BwksRxh2TK3SrFuY+yX4uIyc=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VE1PR08MB5565.eurprd08.prod.outlook.com (2603:10a6:800:1b2::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Wed, 3 Feb
 2021 02:40:01 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::11f1:cc3d:cb34:b3f1]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::11f1:cc3d:cb34:b3f1%4]) with mapi id 15.20.3805.025; Wed, 3 Feb 2021
 02:40:01 +0000
From: Jianyong Wu <Jianyong.Wu@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v16 0/9] Enable ptp_kvm for arm/arm64
Thread-Topic: [PATCH v16 0/9] Enable ptp_kvm for arm/arm64
Thread-Index: AQHWzfH314IeOXkaQU2t29Ihl+nLg6pFP8OAgADJuSA=
Date: Wed, 3 Feb 2021 02:40:01 +0000
Message-ID: <VE1PR08MB476648FCDC79E7F95DB59A62F4B49@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
 <74108ee1d0021acbdd7aed5b467e5432@kernel.org>
In-Reply-To: <74108ee1d0021acbdd7aed5b467e5432@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: F514C0412FDEFC4D8D0AB230B7525247.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a3af9c07-f745-46da-491e-08d8c7ed06c8
x-ms-traffictypediagnostic: VE1PR08MB5565:|DB6PR0801MB2022:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0801MB20228441244600E8DA2CB365F4B49@DB6PR0801MB2022.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:3044;OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: nTeXv/roHtoakdr2GCykFW+JG9zX1Eu6/ENAmChRWimcUpVJL8BwzS+mVBWZtix8N/6s/5ZlI4cxfLnzJwIC6z42ihfq3eyXcO4/3F9j0FS7kEC3sGoDrUNoOjq1NVKdSAOes8gdNeicBOX3y0NgeL6XXAgNDF25tv8txFNlPjpHGdke3KMhnOCISY70T76MKYRKm7Bq4bncGAkm9Yjo6fn6W5zcQZxFn+Nc9BJjhUrdSiJXi4594rX7RWlxmSrYSpod8O0sU9mUd/8TjQvFDwMLPFei/wDnr3tMDJvOJ/iyI5AFc4rkCbxk/E/EWkcjgLleQX55iTPnLsbppXW8qlyFBVYM8KeJmBuqLEuLbS73EzUXIMdKdHhu2BeAs3zBIH2/ZJsy/ozcaiGmwtO9JunkfgXLQNNmM1mjPGqYXCs+QEa03FdBnxcs+prM6RCMbpvF/bQuCd3F3iW6LGWCXqEmMORsh08PDGZAAQwaP4hhxfFoMMnmTengsNH/Vd6ZuXkwzeQR2yHtQJFV49JIyUw/ZStUp4QpB8NxMonLl8ExpwYIZxP2zzn0jb2WTldjbT9dowYnhyVrgMyQ/WEkjIUBRGAQOYxJdRZi5QwB8n8=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VE1PR08MB4766.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(53546011)(6506007)(54906003)(76116006)(4326008)(83380400001)(26005)(64756008)(66476007)(66946007)(66556008)(66446008)(186003)(6916009)(71200400001)(7416002)(8676002)(55016002)(33656002)(52536014)(966005)(478600001)(7696005)(316002)(8936002)(9686003)(86362001)(5660300002)(2906002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7cybA3YAwUHUPHp70lLb2bdwE7FCEqzxy39Sr89Rb2bLZmr2v9BNJPDoD9b1?=
 =?us-ascii?Q?y/oDz7vS7sJXAkOzr4PtolnEDs5pB625uZu6haPFmAPp0cDwYbVrZRkZg2TW?=
 =?us-ascii?Q?cNau3JLcCis6We/rAP8gebqToBHFb4G47B3kotWnHqI3hmqX9BYdx3JtAg3p?=
 =?us-ascii?Q?VGWGCuvJPu094NJushVnyd746fj8Sl44o8UcYETFhQ6Z1jMDGi0Ft7gqvwoS?=
 =?us-ascii?Q?pIrswJJBpClS/Fa84Uikb4WheeWKfawRbod2FMAhxb5hc/5YBKn25AAajsnq?=
 =?us-ascii?Q?AQokGmm0bluWT1FMOLKMjzNOj4Fo8Fbc59/ARX4jAPQ4UYZ3+frzLA6RBSfQ?=
 =?us-ascii?Q?LBy6MLKgYX+3jQfYGAGDmSCGS45dtLFW6j/Gh8ysjudTMjJYHibKsBF6pI54?=
 =?us-ascii?Q?DUBelSoqbiPYKyIToHPVfvb09yPx/3Mco8BSX5fdIVIAxslmt1EB2IliY27g?=
 =?us-ascii?Q?ZtU2lJgBCUJQhLeJzBAGspNJr5mJlYu2d/WWYzkGm/VNiAU3DL3D9au8LXJH?=
 =?us-ascii?Q?5L7giFrzPJwoP325Wd6vhaNsTIwR1LWBWIskVW4MInJyAemPnIIp5S9JEUqw?=
 =?us-ascii?Q?mNOB14KhB9Vz1nR2mgls7q5gK8wAmWkGu2rDBlEgeYAUrY1Kx3nzilbMNXc/?=
 =?us-ascii?Q?JdWxuxnG9oGvCiwPUK7NfvQp/Hyef/19LyBrFS0OnTRxMImHK+3KXX1xKOyi?=
 =?us-ascii?Q?pU9nC43vnXOmvgi5aeuVJdGMG3Jc6cQLyGI3ZL7VBKIEcLLDDdhVuNb0K9PW?=
 =?us-ascii?Q?3eXq70oeYmm2GfDnSZV9wnTkrdVH0CxornNCrmHO1EbV0qb1f2KHXH6Llp8h?=
 =?us-ascii?Q?dCaXlvJ3NYUIcQFieWZ2hUB+dfdXvHETChCvbMk6oXP5SExgaqBx0LJzXUCU?=
 =?us-ascii?Q?Otoai45QPve/MX8EgzQpcHUNZqQ2JmGFOUGOvmeOLKJKxaYdM2o6uQmORj5c?=
 =?us-ascii?Q?djimzE1Ge5WwvfMwP7UTC7ZtuLf5KlTKZ+C0qC2x6NxClgHHVinMvmBOEQ3u?=
 =?us-ascii?Q?N0hzxMW6j8p62DRe+LTw0J5/x8vCPdHtolMVoNQ+wSP3EDES2y1QgXofiLYd?=
 =?us-ascii?Q?FMe0Ffq3?=
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5565
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT037.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0bfcdbed-253d-4a6a-7265-08d8c7ed0177
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RAxfqQ5R7wlivpfWYv4NDJOUGRIge98sZ3sGzuAu+DEA1/M9BMO290ddiNO1/PWpr8nJ0asl4CrlsFJ8GFzNNWVa1aVeeD+wS8Z35WxZfl7YN4A5e2Az4jNr+ccoILTCGTeRXGRwO3qDa32432y3SOXEjRccnFgpE0wnAA4snvg13FIPt4TQ2HPOOBQhche36c+6rVCzPIwSfPIbI/W1H8Ob7aWxcr5VhEv6N5llXXzbbrneSNBcGqDGIiqsXnpWnJqb/o9RJpI3j/6wK8eh7kYxwMQdckPnD2bpOmfCXk18wStPrq4T6AxDcMD9L0QMLCjMTPS4gXInhkNzBugOswJLzslQJXkHuvi4/yt9xwfbdnYZmqyHaWpjcY5JL8iJlL5/CgZpLhli0KgHRGYq/dUsbCuNA/It3ZxuYWMAkB3XtKuICq6mOIkcZyZbesd/LyhtDnwkyjLP+Vpp2RmQmAcIEEqcKAqoILCzxgGfsIT73Tvhvis0WwZ3fz/2W3CG2afDDSd5O2pAzzlQzUYeLBojKPUSNL0OCGSWalU1qP8X6O0M8wx5xcJ8bpDw+qTVdZYIK5dUZ4gUgtdpgv51Ukb18SDueIvTnNDiEkYB9TMLfpQ+CJUUfnE1JkwF3CAz5R6/xh+MCbTuZ3UJLM69yOpiMcGWefwK4G3S/+4gf8sObIX/z2ET7tD6QCnupjSdY+LDN26C7q++EWJyxlSpHbpc34UOD5HKRbiwqhsfoWA=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(5660300002)(54906003)(70586007)(81166007)(33656002)(36860700001)(82740400003)(316002)(52536014)(86362001)(966005)(336012)(70206006)(478600001)(7696005)(6862004)(82310400003)(186003)(8676002)(6506007)(4326008)(55016002)(47076005)(26005)(83380400001)(53546011)(8936002)(356005)(2906002)(9686003);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 02:40:10.6571 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3af9c07-f745-46da-491e-08d8c7ed06c8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT037.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB2022
Cc: Justin He <Justin.He@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Steven Price <Steven.Price@arm.com>, Andre Przywara <Andre.Przywara@arm.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, nd <nd@arm.com>,
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

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Tuesday, February 2, 2021 10:15 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; richardcochran@gmail.com; Mark
> Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Andre Przywara <Andre.Przywara@arm.com>;
> Steven Price <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v16 0/9] Enable ptp_kvm for arm/arm64
> 
> On 2020-12-09 06:09, Jianyong Wu wrote:
> > Currently, we offen use ntp (sync time with remote network clock) to
> > sync time in VM. But the precision of ntp is subject to network delay
> > so it's difficult to sync time in a high precision.
> >
> > kvm virtual ptp clock (ptp_kvm) offers another way to sync time in VM,
> > as the remote clock locates in the host instead of remote network
> > clock.
> > It targets to sync time between guest and host in virtualization
> > environment and in this way, we can keep the time of all the VMs
> > running in the same host in sync. In general, the delay of
> > communication between host and guest is quiet small, so ptp_kvm can
> > offer time sync precision up to in order of nanosecond. Please keep in
> > mind that ptp_kvm just limits itself to be a channel which transmit
> > the remote clock from host to guest and leaves the time sync jobs to
> > an application, eg.
> > chrony,
> > in usersapce in VM.
> >
> > How ptp_kvm works:
> > After ptp_kvm initialized, there will be a new device node under /dev
> > called ptp%d. A guest userspace service, like chrony, can use this
> > device to get host walltime, sometimes also counter cycle, which
> > depends on the service it calls. Then this guest userspace service can
> > use those data to do the time sync for guest.
> > here is a rough sketch to show how kvm ptp clock works.
> >
> > |----------------------------|
> > |--------------------------|
> > |       guest userspace      |              |          host
> > |
> > |ioctl -> /dev/ptp%d         |              |
> > |
> > |       ^   |                |              |
> > |
> > |----------------------------|              |
> > |
> > |       |   | guest kernel   |              |
> > |
> > |       |   V      (get host walltime/counter cycle)
> > |
> > |      ptp_kvm -> hypercall - - - - - - - - - - ->hypercall service
> > |
> > |                         <- - - - - - - - - - - -
> > |
> > |----------------------------|
> > |--------------------------|
> >
> > 1. time sync service in guest userspace call ptp device through
> > /dev/ptp%d.
> > 2. ptp_kvm module in guest receives this request then invoke hypercall
> > to route into host kernel to request host walltime/counter cycle.
> > 3. ptp_kvm hypercall service in host response to the request and send
> > data back.
> > 4. ptp (not ptp_kvm) in guest copy the data to userspace.
> >
> > This ptp_kvm implementation focuses itself to step 2 and 3 and step 2
> > works in guest comparing step 3 works in host kernel.
> 
> FWIW, and in order to speed up the review, I've posted a reworked
> version[0] of this series with changes that address the comments I had for on
> v16.
> 

Great!!!
Good news for me, thanks Marc.

Thanks
Jianyong

> Thanks,
> 
>          M.
> 
> [0] https://lore.kernel.org/r/20210202141204.3134855-1-maz@kernel.org
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
