Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_HTML_MOSTLY,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA572C4D2C5
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 20:58:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7D32246A9
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 20:58:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="61mD0YYk";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="BatdZK57"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7D32246A9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2CAF4AC7E;
	Fri, 13 Dec 2019 09:23:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AbE0B7SQTOgk; Fri, 13 Dec 2019 09:22:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B37084A800;
	Fri, 13 Dec 2019 09:22:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 832CA4A542
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 09:05:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w1mHGan1O-5S for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 09:05:31 -0500 (EST)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60073.outbound.protection.outlook.com [40.107.6.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAE8E4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 09:05:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCgSyq6zkqOa1+/8U3dkGgA4TNJpZKnOO4BFN8gkUfs=;
 b=61mD0YYkhMvVk4CIpv4wMT7qLtMqS/352qiupibnBeBrlnbkY2+RcWouei8zV098r0VROOWDewYBX6H8whlxzYxpJpaHeeTd56ZLIFAi679HwVemx3U17mWlwXOcj1Zvsrdd4XmmPjSu2/IyCCSDQ3IAeilTGV1KjjDEtJXmtWo=
Received: from VI1PR08CA0177.eurprd08.prod.outlook.com (2603:10a6:800:d1::31)
 by DB8PR08MB5339.eurprd08.prod.outlook.com (2603:10a6:10:114::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.15; Fri, 13 Dec
 2019 14:05:28 +0000
Received: from VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::200) by VI1PR08CA0177.outlook.office365.com
 (2603:10a6:800:d1::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.17 via Frontend
 Transport; Fri, 13 Dec 2019 14:05:28 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=none
 action=none header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT015.mail.protection.outlook.com (10.152.18.176) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18 via Frontend Transport; Fri, 13 Dec 2019 14:05:26 +0000
Received: ("Tessian outbound 28955e0c1ca8:v40");
 Fri, 13 Dec 2019 14:05:26 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5874ab28589acb69
X-CR-MTA-TID: 64aa7808
Received: from 5d07c6cabf0b.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 599E3578-FC8A-4D48-BC1E-813372449B50.1; 
 Fri, 13 Dec 2019 14:05:20 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 5d07c6cabf0b.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 13 Dec 2019 14:05:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MT6zc0SM1KCVceRIKvhxJx59/6gXcAZE5R5AZkWWxn+SZ/YA+nfguATLHStsUMeX7vsLz8rh8hJZVMPrWrP3rjgua6VrkWpTxVeBFrRgNmFzN1YG6QlZcJDswMlLbwdcAcSf0W8qSLGjMhiVFOAxfqJy+EG7RHW2Y2x+4uFvkbh7n/OHYpxGicgACSrb2S4/nMVFltsmEcvQ5JnblWL7p+UO9GSuEUyItL7ykpozE1jEeJauq4W/v18qw66b2YBi7sKHVEx4ofI3Xt3PZrOIfTZ3PkhBUMUlfmFXBQs4Dxt3W5uUDoCz/BGPHFBbzUViAM9+ByYh1Mv8BW87uNu9vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6Ia9uTF+spafHxlKsJL5And3E9bS5I5N8Hnt0DxSCE=;
 b=nllKncKyKJyab4jDSa/u7TvQNiF7E4rYsRCq3O5hb4eGLJ8Qb/utJ9yOqVig99rF2F+P9AzS8WJD5IzsThWntYN+EyIujGj77EUq/P3guKWvuoD6aZsPFssF5J0clkLacqNzMYJQBc3jkR2D50iGzEs0X1TrR4Cye6EPMeIuqUOP7SaUtt4cQ91urWb5thk5cCfQrQQKQwdKW7IJ+Kf5xzWcEq5P4B6rOPruS9qrRE+Z7TMm2JHf0R7OUDydUFibS+R2TzbmwwtKmqdHTBU//KMahL4xBV7OqmBsJzpPssktK5eOZ94toMcjlVrbnkV45BwnLs5+LRpk6SyWiiS7BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6Ia9uTF+spafHxlKsJL5And3E9bS5I5N8Hnt0DxSCE=;
 b=BatdZK57fU5sftLLkAhi+xFFyyWHdoMtPw+E+/hxlrrzgxWfz9MRDc4WdVjiOLgRj4ABKimWFUFTJ+qo/qYSAHtHteA31IV/mYoe0lLzGcGq0XiGrPNxpa8npcciOlEiw0Ss1s9qbDEUT5Uz7igS1OBm1HDBZQyKhTv1rinr/e4=
Received: from DB6PR0801MB2071.eurprd08.prod.outlook.com (10.168.87.14) by
 DB6PR0801MB1685.eurprd08.prod.outlook.com (10.169.225.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Fri, 13 Dec 2019 14:05:19 +0000
Received: from DB6PR0801MB2071.eurprd08.prod.outlook.com
 ([fe80::12f:f607:a0a1:b512]) by DB6PR0801MB2071.eurprd08.prod.outlook.com
 ([fe80::12f:f607:a0a1:b512%11]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 14:05:19 +0000
From: Djordje Kovacevic <Djordje.Kovacevic@arm.com>
To: Christoffer Dall <Christoffer.Dall@arm.com>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Only sign-extend MMIO up to register width
Thread-Topic: [PATCH] KVM: arm64: Only sign-extend MMIO up to register width
Thread-Index: AQHVsSWIPku1DdWJGU+2i8P9Cv0ZSae32U+AgAAMbYCAADETFg==
Date: Fri, 13 Dec 2019 14:05:19 +0000
Message-ID: <DB6PR0801MB2071AF38F38A2FACBBFCE978F4540@DB6PR0801MB2071.eurprd08.prod.outlook.com>
References: <20191212195055.5541-1-christoffer.dall@arm.com>
 <92df358b3261598b587f95a2aa4d9bc5@www.loen.fr>,
 <20191213105647.GH28840@e113682-lin.lund.arm.com>
In-Reply-To: <20191213105647.GH28840@e113682-lin.lund.arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Djordje.Kovacevic@arm.com; 
x-originating-ip: [217.140.106.49]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 045b829e-71a7-48f6-16bf-08d77fd58125
X-MS-TrafficTypeDiagnostic: DB6PR0801MB1685:|DB6PR0801MB1685:|DB8PR08MB5339:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB5339040848D02F20AF1F4159F4540@DB8PR08MB5339.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 0250B840C1
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;
 SFS:(10009020)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(189003)(199004)(51444003)(52314003)(71200400001)(2906002)(7696005)(52536014)(86362001)(6506007)(81156014)(186003)(81166006)(5660300002)(26005)(4326008)(55016002)(8676002)(9686003)(54906003)(110136005)(478600001)(19627405001)(4001150100001)(76116006)(53546011)(66476007)(316002)(8936002)(66446008)(64756008)(66556008)(33656002)(66946007);
 DIR:OUT; SFP:1101; SCL:1; SRVR:DB6PR0801MB1685;
 H:DB6PR0801MB2071.eurprd08.prod.outlook.com; FPR:; SPF:None; LANG:en;
 PTR:InfoNoRecords; MX:1; A:1; 
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Wf1JHgDwyaE44GRxNOnbtzO6VvMg+BrTv2G9JV1foq+8XF0F9ApwZS8OKRrvt83dbIh3RriV+um4TpXbmooXF6JVtoUYax2t2uLuzg2AoJsT01e7XKYNbq65Y+u7hVSVAuVWes7xZBMO1p1p8HgLyeYn9jt2qG6qSE+xU6MjHv9nm1RsjmUepwqsnQud5+5KATJrz0ukn1f1k7m0lHedxl0uhWpwFbyPDbklTvxLmOqsjX6Bzv+6H9cmw8qC1RR4Qwh7Uex0zNskMI7zmuNn0j9lQdFOMjoG+XpihuuSTuBIG1hvqAcRCSj60F3lDztInhfQbVQ8/jSkYr4DCsE4Dd7GrA115ncRagpbONyqOHtNBoy3uO+z8zadX1qkZ37olyLS0JomKue5WSc7CWvlC9HDCPZnQL4cEhuYjsUqYvGcyASDUAMxtsRlmqfCqEqy+ljt/GaMbUjUAfdG2q8f4denK0o5JHy7b3zY5E4IZyAAJXLFAZgGZ44KrsvIaYNSPKlyswUlk7hgORYoF8gZTA==
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1685
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Djordje.Kovacevic@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123; IPV:CAL; SCL:-1; CTRY:IE;
 EFV:NLI; SFV:NSPM;
 SFS:(10009020)(4636009)(136003)(39860400002)(396003)(376002)(346002)(199004)(189003)(40434004)(52314003)(51444003)(19627405001)(26826003)(8676002)(6506007)(30864003)(186003)(81166006)(81156014)(53546011)(26005)(4326008)(478600001)(4001150100001)(2906002)(9686003)(7696005)(55016002)(336012)(316002)(8936002)(70206006)(33656002)(356004)(52536014)(76130400001)(86362001)(70586007)(110136005)(54906003)(36906005)(5660300002)(63350400001);
 DIR:OUT; SFP:1101; SCL:1; SRVR:DB8PR08MB5339;
 H:64aa7808-outbound-1.mta.getcheckrecipient.com; FPR:; SPF:TempError; LANG:en;
 PTR:ErrorRetry; A:1; MX:1; 
X-MS-Office365-Filtering-Correlation-Id-Prvs: adfc7f39-237f-4232-e69b-08d77fd57ce4
X-Forefront-PRVS: 0250B840C1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M1dv+lgRIIxMn0/pJjGjkcsCd7P4Gux/LZ/Hj5nK9Idccq1gY/lUslmd4ituWQ0+DdR8m/qh1G6IS2pxb9QfNujIpScoH4lCMf9khJOpujeQ0IGlL0bTEub5WDl6JdqXsCOxqi7szq6zq9oO7FemR+BSfCPojD1kViTzLcxsoAe3p+GJV8H0OJ6Itm5XjKMrRFdtcS792OllBjFCC7NrxWCZqR9LHQEdNgOUzKqC+njgnV2fXye/WFhMxMtFHC1g1LWOtjB9YmIBxGk5HWaM1/k/eszOC/ujAoR/Nf1b8KuEfeiqGMQWJ94hmYV1sLNPwqf73ty0vysIgcoPOkqMgDD7cVKundIT7Cuq3K2Zr3dX0OURsaVnI0WhVi58qtJNRCoOjbp9Xinccoldn5Vbb/qxQ+X5CVfM+DvxHiKOPWWbORFkrvSgKV0BmfcuskG7w35Pq+eDQFfivO+K5qbkkWG5gqzFz3wB7TdMOIJZwIsdIn3sa5PXlxRlxh+uBZ+kjXm20InUjvvLA4S6tTLZhhy1ZKTtJk8MBK1N+I4hr88=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2019 14:05:26.6006 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 045b829e-71a7-48f6-16bf-08d77fd58125
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5339
X-Mailman-Approved-At: Fri, 13 Dec 2019 09:22:56 -0500
Cc: Alexander Shirshikov <Alexander.Shirshikov@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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
Content-Type: multipart/mixed; boundary="===============7412713004294335913=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============7412713004294335913==
Content-Language: en-GB
Content-Type: multipart/alternative;
	boundary="_000_DB6PR0801MB2071AF38F38A2FACBBFCE978F4540DB6PR0801MB2071_"

--_000_DB6PR0801MB2071AF38F38A2FACBBFCE978F4540DB6PR0801MB2071_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Christoffer,
I have run some test payload to get the exact behavior of all nine LDR[S][W=
|H|B] [Xt|Wt] instructions. Here it is:

 # instruction       sas  sse  sf   Xt contents
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 1 LDR    Xt, ...     3    0    1   b[63:0] =3D MEM[63:0]
 2 LDR    Wt, ...     2    0    0   b[63:32]=3D'0..0' b[31:0] =3D MEM[31:0]
 3 LDRH   Wt, ...     1    0    0   b[63:16]=3D'0..0' b[15:0] =3D MEM[15:0]
 4 LDRB   Wt, ...     0    0    0   b[63:8] =3D'0..0' b[7:0]  =3D MEM[7:0]

 5 LDRSW  Xt, ...     2    1    1   b[63:32] =3D MEM[31] b[31:0] =3D MEM[31=
:0]
 6 LDRSH  Xt, ...     1    1    1   b[63:16] =3D MEM[15] b[15:0] =3D MEM[15=
:0]
 7 LDRSH  Wt, ...     1    1    0   b[63:32] =3D '0..0' b[31:16] =3D MEM[15=
] b[15:0] =3D MEM[15:0]
 8 LDRSB  Xt, ...     0    1    1   b[63:8] =3D MEM[7] b[7:0] =3D MEM[7:0]
 9 LDRSB  Wt, ...     0    1    0   b[63:32] =3D '0..0' b[31:8] =3D MEM[7] =
b[7:0] =3D MEM[7:0]

Any surprises?

DjK

________________________________
From: Christoffer Dall <christoffer.dall@arm.com>
Sent: 13 December 2019 10:56
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu <kvmarm@lists.cs.columbia.edu>; linux-arm-=
kernel@lists.infradead.org <linux-arm-kernel@lists.infradead.org>; Djordje =
Kovacevic <Djordje.Kovacevic@arm.com>; James Morse <James.Morse@arm.com>; J=
ulien Thierry <julien.thierry.kdev@gmail.com>; Suzuki Poulose <Suzuki.Poulo=
se@arm.com>
Subject: Re: [PATCH] KVM: arm64: Only sign-extend MMIO up to register width

On Fri, Dec 13, 2019 at 10:12:19AM +0000, Marc Zyngier wrote:
> On 2019-12-12 19:50, Christoffer Dall wrote:
> > On AArch64 you can do a sign-extended load to either a 32-bit or 64-bit
> > register, and we should only sign extend the register up to the width o=
f
> > the register as specified in the operation (by using the 32-bit Wn or
> > 64-bit Xn register specifier).
>
> Nice catch. It's only been there for... Oh wait! ;-)
>
> >
> > As it turns out, the architecture provides this decoding information in
> > the SF ("Sixty-Four" -- how cute...) bit.
> >
> > Let's take advantage of this with the usual 32-bit/64-bit header file
> > dance and do the right thing on AArch64 hosts.
> >
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>
> Cc: stable?
>

Yes, good idea.

> > ---
> >  arch/arm/include/asm/kvm_emulate.h   | 5 +++++
> >  arch/arm/include/asm/kvm_mmio.h      | 2 ++
> >  arch/arm64/include/asm/kvm_emulate.h | 5 +++++
> >  arch/arm64/include/asm/kvm_mmio.h    | 6 ++----
> >  virt/kvm/arm/mmio.c                  | 8 +++++++-
> >  5 files changed, 21 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm/include/asm/kvm_emulate.h
> > b/arch/arm/include/asm/kvm_emulate.h
> > index 9b118516d2db..fe55d8737a11 100644
> > --- a/arch/arm/include/asm/kvm_emulate.h
> > +++ b/arch/arm/include/asm/kvm_emulate.h
> > @@ -182,6 +182,11 @@ static inline bool kvm_vcpu_dabt_issext(struct
> > kvm_vcpu *vcpu)
> >      return kvm_vcpu_get_hsr(vcpu) & HSR_SSE;
> >  }
> >
> > +static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
> > +{
> > +   return false;
> > +}
> > +
> >  static inline int kvm_vcpu_dabt_get_rd(struct kvm_vcpu *vcpu)
> >  {
> >      return (kvm_vcpu_get_hsr(vcpu) & HSR_SRT_MASK) >> HSR_SRT_SHIFT;
> > diff --git a/arch/arm/include/asm/kvm_mmio.h
> > b/arch/arm/include/asm/kvm_mmio.h
> > index 7c0eddb0adb2..32fbf82e3ebc 100644
> > --- a/arch/arm/include/asm/kvm_mmio.h
> > +++ b/arch/arm/include/asm/kvm_mmio.h
> > @@ -14,6 +14,8 @@
> >  struct kvm_decode {
> >      unsigned long rt;
> >      bool sign_extend;
> > +   /* Not used on 32-bit arm */
> > +   bool sixty_four;
> >  };
> >
> >  void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long
> > data);
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h
> > b/arch/arm64/include/asm/kvm_emulate.h
> > index 5efe5ca8fecf..f407b6bdad2e 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -283,6 +283,11 @@ static inline bool kvm_vcpu_dabt_issext(const
> > struct kvm_vcpu *vcpu)
> >      return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SSE);
> >  }
> >
> > +static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
> > +{
> > +   return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SF);
> > +}
> > +
> >  static inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
> >  {
> >      return (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SRT_MASK) >>
> > ESR_ELx_SRT_SHIFT;
> > diff --git a/arch/arm64/include/asm/kvm_mmio.h
> > b/arch/arm64/include/asm/kvm_mmio.h
> > index 02b5c48fd467..b204501a0c39 100644
> > --- a/arch/arm64/include/asm/kvm_mmio.h
> > +++ b/arch/arm64/include/asm/kvm_mmio.h
> > @@ -10,13 +10,11 @@
> >  #include <linux/kvm_host.h>
> >  #include <asm/kvm_arm.h>
> >
> > -/*
> > - * This is annoying. The mmio code requires this, even if we don't
> > - * need any decoding. To be fixed.
> > - */
> >  struct kvm_decode {
> >      unsigned long rt;
> >      bool sign_extend;
> > +   /* Witdth of the register accessed by the faulting instruction is
> > 64-bits */
> > +   bool sixty_four;
> >  };
> >
> >  void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long
> > data);
> > diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> > index 70d3b449692c..e62454b2e529 100644
> > --- a/virt/kvm/arm/mmio.c
> > +++ b/virt/kvm/arm/mmio.c
> > @@ -83,7 +83,7 @@ unsigned long kvm_mmio_read_buf(const void *buf,
> > unsigned int len)
> >  int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  {
> >      unsigned long data;
> > -   unsigned int len;
> > +   unsigned int len, regsize;
>
> Unused variable?
>

Ah, yes, whoops.  Guess which unstaged change I still have in my tree...

> >      int mask;
> >
> >      /* Detect an already handled MMIO return */
> > @@ -105,6 +105,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu,
> > struct kvm_run *run)
> >                      data =3D (data ^ mask) - mask;
> >              }
> >
> > +           if (!vcpu->arch.mmio_decode.sixty_four)
> > +                   data =3D data & 0xffffffff;
> > +
> >              trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_ad=
dr,
> >                             &data);
> >              data =3D vcpu_data_host_to_guest(vcpu, data, len);
> > @@ -125,6 +128,7 @@ static int decode_hsr(struct kvm_vcpu *vcpu, bool
> > *is_write, int *len)
> >      unsigned long rt;
> >      int access_size;
> >      bool sign_extend;
> > +   bool sixty_four;
> >
> >      if (kvm_vcpu_dabt_iss1tw(vcpu)) {
> >              /* page table accesses IO mem: tell guest to fix its TTBR =
*/
> > @@ -138,11 +142,13 @@ static int decode_hsr(struct kvm_vcpu *vcpu,
> > bool *is_write, int *len)
> >
> >      *is_write =3D kvm_vcpu_dabt_iswrite(vcpu);
> >      sign_extend =3D kvm_vcpu_dabt_issext(vcpu);
> > +   sixty_four =3D kvm_vcpu_dabt_issf(vcpu);
> >      rt =3D kvm_vcpu_dabt_get_rd(vcpu);
> >
> >      *len =3D access_size;
> >      vcpu->arch.mmio_decode.sign_extend =3D sign_extend;
> >      vcpu->arch.mmio_decode.rt =3D rt;
> > +   vcpu->arch.mmio_decode.sixty_four =3D sixty_four;
> >
> >      return 0;
> >  }
>
> I can't remember why we keep this mmio_decode structure as part of
> the vcpu. It isn't like it is going to change anytime soon (userspace
> cannot change the saved ESR_EL2)...

I think that was just an uninformed design decision on my part and it
could be reworked to operate on the ESR_EL2 directly or just take the
information from userspace (which we already rely on for read vs.
write).

>
> Anyway, your patch is in keeping with the current shape of the code.
> If you're OK with, it, I'll apply it with the above nits addressed.
>

Absolutely, I decided not to rework the mmio_decode stuff, and leave
that for some later day.


Thanks!

    Christoffer
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

--_000_DB6PR0801MB2071AF38F38A2FACBBFCE978F4540DB6PR0801MB2071_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Hi Christoffer, <br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
I have run some test payload to get the exact behavior of all nine LDR[S][W=
|H|B] [Xt|Wt] instructions. Here it is:</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;# instruct=
ion &nbsp; &nbsp; &nbsp; sas &nbsp;sse &nbsp;sf &nbsp; Xt contents</span><s=
pan><br>
</span>
<div><span style=3D"font-family: Consolas, Courier, monospace;">=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</span><b=
r>
</div>
<div><span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;1 LDR=
 &nbsp; &nbsp;Xt, ... &nbsp; &nbsp; 3 &nbsp; &nbsp;0 &nbsp; &nbsp;1 &nbsp; =
b[63:0] =3D MEM[63:0]</span><br>
</div>
<div><span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;2 LDR=
 &nbsp; &nbsp;Wt, ... &nbsp; &nbsp; 2 &nbsp; &nbsp;0 &nbsp; &nbsp;0 &nbsp; =
b[63:32]=3D'0..0' b[31:0] =3D MEM[31:0]</span><br>
</div>
<div><span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;3 LDR=
H &nbsp; Wt, ... &nbsp; &nbsp; 1 &nbsp; &nbsp;0 &nbsp; &nbsp;0 &nbsp; b[63:=
16]=3D'0..0' b[15:0] =3D MEM[15:0]</span><br>
</div>
<div><span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;4 LDR=
B &nbsp; Wt, ... &nbsp; &nbsp; 0 &nbsp; &nbsp;0 &nbsp; &nbsp;0 &nbsp; b[63:=
8] =3D'0..0' b[7:0] &nbsp;=3D MEM[7:0]</span><br>
</div>
<div><br>
</div>
<div><span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;5 LDR=
SW &nbsp;Xt, ...&nbsp; &nbsp;&nbsp; 2 &nbsp; &nbsp;1 &nbsp; &nbsp;1 &nbsp; =
b[63:32] =3D MEM[31] b[31:0] =3D MEM[31:0]</span><br>
</div>
<div><span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;6 LDR=
SH &nbsp;Xt, ...&nbsp; &nbsp;&nbsp; 1 &nbsp; &nbsp;1 &nbsp; &nbsp;1 &nbsp; =
b[63:16] =3D MEM[15] b[15:0] =3D MEM[15:0]</span><br>
</div>
<div><span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;7 LDR=
SH &nbsp;Wt, ...&nbsp; &nbsp;&nbsp; 1 &nbsp; &nbsp;1 &nbsp; &nbsp;0 &nbsp; =
b[63:32] =3D '0..0' b[31:16] =3D MEM[15] b[15:0] =3D MEM[15:0]</span><br>
</div>
<div><span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;8 LDR=
SB &nbsp;Xt, ...&nbsp; &nbsp;&nbsp; 0 &nbsp; &nbsp;1 &nbsp; &nbsp;1 &nbsp; =
b[63:8] =3D MEM[7] b[7:0] =3D MEM[7:0]</span><br>
</div>
<span style=3D"font-family: Consolas, Courier, monospace;">&nbsp;9 LDRSB &n=
bsp;Wt, ...&nbsp; &nbsp;&nbsp; 0 &nbsp; &nbsp;1 &nbsp; &nbsp;0 &nbsp; b[63:=
32] =3D '0..0' b[31:8] =3D MEM[7] b[7:0] =3D MEM[7:0]</span><br>
</div>
<div id=3D"appendonsend"></div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0)">
Any surprises?<br>
</div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0)">
DjK</div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0)">
<br>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font style=3D"font-size:11pt" face=
=3D"Calibri, sans-serif" color=3D"#000000"><b>From:</b> Christoffer Dall &l=
t;christoffer.dall@arm.com&gt;<br>
<b>Sent:</b> 13 December 2019 10:56<br>
<b>To:</b> Marc Zyngier &lt;maz@kernel.org&gt;<br>
<b>Cc:</b> kvmarm@lists.cs.columbia.edu &lt;kvmarm@lists.cs.columbia.edu&gt=
;; linux-arm-kernel@lists.infradead.org &lt;linux-arm-kernel@lists.infradea=
d.org&gt;; Djordje Kovacevic &lt;Djordje.Kovacevic@arm.com&gt;; James Morse=
 &lt;James.Morse@arm.com&gt;; Julien Thierry &lt;julien.thierry.kdev@gmail.=
com&gt;;
 Suzuki Poulose &lt;Suzuki.Poulose@arm.com&gt;<br>
<b>Subject:</b> Re: [PATCH] KVM: arm64: Only sign-extend MMIO up to registe=
r width</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt"=
>
<div class=3D"PlainText">On Fri, Dec 13, 2019 at 10:12:19AM &#43;0000, Marc=
 Zyngier wrote:<br>
&gt; On 2019-12-12 19:50, Christoffer Dall wrote:<br>
&gt; &gt; On AArch64 you can do a sign-extended load to either a 32-bit or =
64-bit<br>
&gt; &gt; register, and we should only sign extend the register up to the w=
idth of<br>
&gt; &gt; the register as specified in the operation (by using the 32-bit W=
n or<br>
&gt; &gt; 64-bit Xn register specifier).<br>
&gt; <br>
&gt; Nice catch. It's only been there for... Oh wait! ;-)<br>
&gt; <br>
&gt; &gt; <br>
&gt; &gt; As it turns out, the architecture provides this decoding informat=
ion in<br>
&gt; &gt; the SF (&quot;Sixty-Four&quot; -- how cute...) bit.<br>
&gt; &gt; <br>
&gt; &gt; Let's take advantage of this with the usual 32-bit/64-bit header =
file<br>
&gt; &gt; dance and do the right thing on AArch64 hosts.<br>
&gt; &gt; <br>
&gt; &gt; Signed-off-by: Christoffer Dall &lt;christoffer.dall@arm.com&gt;<=
br>
&gt; <br>
&gt; Cc: stable?<br>
&gt; <br>
<br>
Yes, good idea.<br>
<br>
&gt; &gt; ---<br>
&gt; &gt;&nbsp; arch/arm/include/asm/kvm_emulate.h&nbsp;&nbsp; | 5 &#43;&#4=
3;&#43;&#43;&#43;<br>
&gt; &gt;&nbsp; arch/arm/include/asm/kvm_mmio.h&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; | 2 &#43;&#43;<br>
&gt; &gt;&nbsp; arch/arm64/include/asm/kvm_emulate.h | 5 &#43;&#43;&#43;&#4=
3;&#43;<br>
&gt; &gt;&nbsp; arch/arm64/include/asm/kvm_mmio.h&nbsp;&nbsp;&nbsp; | 6 &#4=
3;&#43;----<br>
&gt; &gt;&nbsp; virt/kvm/arm/mmio.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 8 &#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;-<br>
&gt; &gt;&nbsp; 5 files changed, 21 insertions(&#43;), 5 deletions(-)<br>
&gt; &gt; <br>
&gt; &gt; diff --git a/arch/arm/include/asm/kvm_emulate.h<br>
&gt; &gt; b/arch/arm/include/asm/kvm_emulate.h<br>
&gt; &gt; index 9b118516d2db..fe55d8737a11 100644<br>
&gt; &gt; --- a/arch/arm/include/asm/kvm_emulate.h<br>
&gt; &gt; &#43;&#43;&#43; b/arch/arm/include/asm/kvm_emulate.h<br>
&gt; &gt; @@ -182,6 &#43;182,11 @@ static inline bool kvm_vcpu_dabt_issext(=
struct<br>
&gt; &gt; kvm_vcpu *vcpu)<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return kvm_vcpu_get_hsr(vcpu) &amp;=
 HSR_SSE;<br>
&gt; &gt;&nbsp; }<br>
&gt; &gt; <br>
&gt; &gt; &#43;static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu =
*vcpu)<br>
&gt; &gt; &#43;{<br>
&gt; &gt; &#43;&nbsp;&nbsp; return false;<br>
&gt; &gt; &#43;}<br>
&gt; &gt; &#43;<br>
&gt; &gt;&nbsp; static inline int kvm_vcpu_dabt_get_rd(struct kvm_vcpu *vcp=
u)<br>
&gt; &gt;&nbsp; {<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return (kvm_vcpu_get_hsr(vcpu) &amp=
; HSR_SRT_MASK) &gt;&gt; HSR_SRT_SHIFT;<br>
&gt; &gt; diff --git a/arch/arm/include/asm/kvm_mmio.h<br>
&gt; &gt; b/arch/arm/include/asm/kvm_mmio.h<br>
&gt; &gt; index 7c0eddb0adb2..32fbf82e3ebc 100644<br>
&gt; &gt; --- a/arch/arm/include/asm/kvm_mmio.h<br>
&gt; &gt; &#43;&#43;&#43; b/arch/arm/include/asm/kvm_mmio.h<br>
&gt; &gt; @@ -14,6 &#43;14,8 @@<br>
&gt; &gt;&nbsp; struct kvm_decode {<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long rt;<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bool sign_extend;<br>
&gt; &gt; &#43;&nbsp;&nbsp; /* Not used on 32-bit arm */<br>
&gt; &gt; &#43;&nbsp;&nbsp; bool sixty_four;<br>
&gt; &gt;&nbsp; };<br>
&gt; &gt; <br>
&gt; &gt;&nbsp; void kvm_mmio_write_buf(void *buf, unsigned int len, unsign=
ed long<br>
&gt; &gt; data);<br>
&gt; &gt; diff --git a/arch/arm64/include/asm/kvm_emulate.h<br>
&gt; &gt; b/arch/arm64/include/asm/kvm_emulate.h<br>
&gt; &gt; index 5efe5ca8fecf..f407b6bdad2e 100644<br>
&gt; &gt; --- a/arch/arm64/include/asm/kvm_emulate.h<br>
&gt; &gt; &#43;&#43;&#43; b/arch/arm64/include/asm/kvm_emulate.h<br>
&gt; &gt; @@ -283,6 &#43;283,11 @@ static inline bool kvm_vcpu_dabt_issext(=
const<br>
&gt; &gt; struct kvm_vcpu *vcpu)<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return !!(kvm_vcpu_get_hsr(vcpu) &a=
mp; ESR_ELx_SSE);<br>
&gt; &gt;&nbsp; }<br>
&gt; &gt; <br>
&gt; &gt; &#43;static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu =
*vcpu)<br>
&gt; &gt; &#43;{<br>
&gt; &gt; &#43;&nbsp;&nbsp; return !!(kvm_vcpu_get_hsr(vcpu) &amp; ESR_ELx_=
SF);<br>
&gt; &gt; &#43;}<br>
&gt; &gt; &#43;<br>
&gt; &gt;&nbsp; static inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcp=
u *vcpu)<br>
&gt; &gt;&nbsp; {<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return (kvm_vcpu_get_hsr(vcpu) &amp=
; ESR_ELx_SRT_MASK) &gt;&gt;<br>
&gt; &gt; ESR_ELx_SRT_SHIFT;<br>
&gt; &gt; diff --git a/arch/arm64/include/asm/kvm_mmio.h<br>
&gt; &gt; b/arch/arm64/include/asm/kvm_mmio.h<br>
&gt; &gt; index 02b5c48fd467..b204501a0c39 100644<br>
&gt; &gt; --- a/arch/arm64/include/asm/kvm_mmio.h<br>
&gt; &gt; &#43;&#43;&#43; b/arch/arm64/include/asm/kvm_mmio.h<br>
&gt; &gt; @@ -10,13 &#43;10,11 @@<br>
&gt; &gt;&nbsp; #include &lt;linux/kvm_host.h&gt;<br>
&gt; &gt;&nbsp; #include &lt;asm/kvm_arm.h&gt;<br>
&gt; &gt; <br>
&gt; &gt; -/*<br>
&gt; &gt; - * This is annoying. The mmio code requires this, even if we don=
't<br>
&gt; &gt; - * need any decoding. To be fixed.<br>
&gt; &gt; - */<br>
&gt; &gt;&nbsp; struct kvm_decode {<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long rt;<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bool sign_extend;<br>
&gt; &gt; &#43;&nbsp;&nbsp; /* Witdth of the register accessed by the fault=
ing instruction is<br>
&gt; &gt; 64-bits */<br>
&gt; &gt; &#43;&nbsp;&nbsp; bool sixty_four;<br>
&gt; &gt;&nbsp; };<br>
&gt; &gt; <br>
&gt; &gt;&nbsp; void kvm_mmio_write_buf(void *buf, unsigned int len, unsign=
ed long<br>
&gt; &gt; data);<br>
&gt; &gt; diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c<br>
&gt; &gt; index 70d3b449692c..e62454b2e529 100644<br>
&gt; &gt; --- a/virt/kvm/arm/mmio.c<br>
&gt; &gt; &#43;&#43;&#43; b/virt/kvm/arm/mmio.c<br>
&gt; &gt; @@ -83,7 &#43;83,7 @@ unsigned long kvm_mmio_read_buf(const void =
*buf,<br>
&gt; &gt; unsigned int len)<br>
&gt; &gt;&nbsp; int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kv=
m_run *run)<br>
&gt; &gt;&nbsp; {<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long data;<br>
&gt; &gt; -&nbsp;&nbsp; unsigned int len;<br>
&gt; &gt; &#43;&nbsp;&nbsp; unsigned int len, regsize;<br>
&gt; <br>
&gt; Unused variable?<br>
&gt; <br>
<br>
Ah, yes, whoops.&nbsp; Guess which unstaged change I still have in my tree.=
..<br>
<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int mask;<br>
&gt; &gt; <br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Detect an already handled MMIO r=
eturn */<br>
&gt; &gt; @@ -105,6 &#43;105,9 @@ int kvm_handle_mmio_return(struct kvm_vcp=
u *vcpu,<br>
&gt; &gt; struct kvm_run *run)<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; data =3D (data=
 ^ mask) - mask;<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; }<br>
&gt; &gt; <br>
&gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 if (!vcpu-&gt;arch.mmio_decode.sixty_four)<br>
&gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; data =3D data &amp; 0xffff=
ffff;<br>
&gt; &gt; &#43;<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run-&gt;mmio.phys_add=
r,<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;data);<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; data =3D vcpu_data_host_to_guest(vcpu, data, len);<br>
&gt; &gt; @@ -125,6 &#43;128,7 @@ static int decode_hsr(struct kvm_vcpu *vc=
pu, bool<br>
&gt; &gt; *is_write, int *len)<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long rt;<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int access_size;<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bool sign_extend;<br>
&gt; &gt; &#43;&nbsp;&nbsp; bool sixty_four;<br>
&gt; &gt; <br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (kvm_vcpu_dabt_iss1tw(vcpu)) {<b=
r>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; /* page table accesses IO mem: tell guest to fix its TTBR */<b=
r>
&gt; &gt; @@ -138,11 &#43;142,13 @@ static int decode_hsr(struct kvm_vcpu *=
vcpu,<br>
&gt; &gt; bool *is_write, int *len)<br>
&gt; &gt; <br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *is_write =3D kvm_vcpu_dabt_iswrite=
(vcpu);<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sign_extend =3D kvm_vcpu_dabt_issex=
t(vcpu);<br>
&gt; &gt; &#43;&nbsp;&nbsp; sixty_four =3D kvm_vcpu_dabt_issf(vcpu);<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rt =3D kvm_vcpu_dabt_get_rd(vcpu);<=
br>
&gt; &gt; <br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *len =3D access_size;<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vcpu-&gt;arch.mmio_decode.sign_exte=
nd =3D sign_extend;<br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vcpu-&gt;arch.mmio_decode.rt =3D rt=
;<br>
&gt; &gt; &#43;&nbsp;&nbsp; vcpu-&gt;arch.mmio_decode.sixty_four =3D sixty_=
four;<br>
&gt; &gt; <br>
&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<br>
&gt; &gt;&nbsp; }<br>
&gt; <br>
&gt; I can't remember why we keep this mmio_decode structure as part of<br>
&gt; the vcpu. It isn't like it is going to change anytime soon (userspace<=
br>
&gt; cannot change the saved ESR_EL2)...<br>
<br>
I think that was just an uninformed design decision on my part and it<br>
could be reworked to operate on the ESR_EL2 directly or just take the<br>
information from userspace (which we already rely on for read vs.<br>
write).<br>
<br>
&gt; <br>
&gt; Anyway, your patch is in keeping with the current shape of the code.<b=
r>
&gt; If you're OK with, it, I'll apply it with the above nits addressed.<br=
>
&gt; <br>
<br>
Absolutely, I decided not to rework the mmio_decode stuff, and leave<br>
that for some later day.<br>
<br>
<br>
Thanks!<br>
<br>
&nbsp;&nbsp;&nbsp; Christoffer<br>
</div>
</span></font></div>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose,
 or store or copy the information in any medium. Thank you.
</body>
</html>

--_000_DB6PR0801MB2071AF38F38A2FACBBFCE978F4540DB6PR0801MB2071_--

--===============7412713004294335913==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7412713004294335913==--
