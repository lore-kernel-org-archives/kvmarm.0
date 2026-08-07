Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011052.outbound.protection.outlook.com [52.101.65.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3463137C92A
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101378; cv=fail; b=KNzlW4hFGJMOtQ15vnwWg+0bVwPiTytxPq3CoTgPmEuoteJfx907QRkzkF0M1HcO1Dm0zysuD75cPnVvnMADzqifN619oreukYq3eycQ6a/nEB7eChrU4mlI+PDTG0u42RCYQsDZVYTi9cyl3wAe/mWekskZA9qlupi7V6Pg3Ig=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101378; c=relaxed/simple;
	bh=e7/yiqZZwJxNWZd/ehhvAwZMkP0HeZKeVsiSjmdD0l8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OGWVAWE+xv6JpmCxXNV4EkPr3NMYSO9hFxWqwoH4pK5+43uTuqfZw367PW/qLm69kNHVddElslFueZQ29WbsIe/Pk9nd7q686BSUG2NLWjFmDNThQRktHKAl74NLVCqWPce7h+yREf7Q3jpc07IUxJ5hokoIoIWqsqwGC/oAvcM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g0OQeMRY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g0OQeMRY; arc=fail smtp.client-ip=52.101.65.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g0OQeMRY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g0OQeMRY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NoJ7wSwLQhjYevEqCEo1APm5ufhqU1nTO4zgdcoWJhHLE+X2L6sxtEM0gVtDyz9Rv/MMpuklm6A0DqyZNtP1ORW+9x+oUOgCLkNohMsgqPlboIjE7CvBbvMT29QaNixR89LiZ2NvozazdKuXO/b5bce7UyIqtC9noZP8j/QYxXnaZ4Ct4Sbas8BvBUQ7pH2yOQrBNxT8u4zELXG4eVPfSqxopiuo5Ew4zIUqYUCJOSndfQBDE6F6FI3/cj7LlxHg1xH2rUhQEGqTTR2Q5KVVYnxcjYuGfc7ViOOjzIw6a2D1q8BNznwj2BJK7nZmDeW7jBKLIVDNAylUDPyBneWX9g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNa7++zZDitY0cHHVxFQayIQ9RtWk6eR4KxnRyZaTmU=;
 b=Ep1ra7gUSpWf90EfNmbDHY0wQZtGyE6ok53scwCuYBi+k3qEXGh87vIW0V8kK4+Y5l7/T8sHvRpnwX5OCQk0FgN8WPFTcC2UZOU1McWmJ15pRdXlbubhQztv2oj0Mxyvsm5YG7JbLv9cOjtMxTlepZ+fdddmuLjK1T//NWKGsEMui8fOhPbl8GNI6Fp9XxrucJP7jKpm+oHQF/N1Od+h/Q16s+qaxC30/Jf/5GRMf26DWg+CuvnMCIPCH/GJhGmpElSrMjyTpuhJlDH1V9B7nb+BHCV8ACnRtLB1WIPgMPZ/Oo2XdhA6yAU61eo+QhV8ieRwpUPtJm2Eb1FDVz+mCQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNa7++zZDitY0cHHVxFQayIQ9RtWk6eR4KxnRyZaTmU=;
 b=g0OQeMRYeDItOuqTbWTLLWQDa24NDEM87F5jVRomHAlCm8GiRP5lpR85UgtT9oqrH77uE6u5oNJYytJtk33z9xaxry+H2EZrL7jBw/EeFpnDcbCDL59mCJBsCN+MMWePj8BMht2cp3t6bqNmoAq19jJo8POOhnuCggbCMCvn9C4=
Received: from AS4P190CA0021.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::6)
 by AS1PR08MB7452.eurprd08.prod.outlook.com (2603:10a6:20b:4dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Fri, 7 Aug
 2026 11:16:11 +0000
Received: from AMS1EPF0000004D.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::50) by AS4P190CA0021.outlook.office365.com
 (2603:10a6:20b:5d0::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:16:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004D.mail.protection.outlook.com (10.167.16.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:16:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KDsSpiR1kgmqAjEWcPVQcXwOKQn7oUXtYEna4bJQW0SpRRss+mx5qDAJUrHl9ENsnTj2pXOgeXUEhxUpaRbTviN9X+0AvZNLA0u/zHxWkRZJKYJ1ZVkacbET8RzK0H1/qnM66KlqvFl0KS2uBQGHBI9BVfOIDsLGxQ2F3xTnCoHV+QEqqjGZLvRpZygJJ9/mVNR4U3kjCUcMQqfpWbWdaOWDuOZ19hatdRSeEDG6J2X0A042vZw8B2sE59R0LyQPwNwjQkhu5Mw2u6Yyn+9nM1DHtLijpa7pWotN3Ch+NjFlO0CNZRS54szurbJxM32TZW3lSIdm35piTVMnQ1OT9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNa7++zZDitY0cHHVxFQayIQ9RtWk6eR4KxnRyZaTmU=;
 b=Oo4RgjGw8YuIbq0R26izI0xbni07Qxzn9iVN17kSphLv6xpktMzJ/6fX2wwEJOaCQvsyMacL0/jpRYlP0xhFaS1nTwCJ5RV5yo5OdUnLhQ88tq8tiKYqc5VFbUBszyGQkEfrGavp9m+xG5wd/I1kGJcR0e4V6yIGHJ3j/2rFwcC0o7+oM+XHQRbJI4YUqKXKbLw5obmbrGTErp8Tpi/2iOJXYR0FXsQGHeTTEKfxfkZc04YOtWBVFpiwJSMg+fpSWS48Qvj/u1GzQyeAvXtoskiHxsAxbxcYt4F8nwhLGBbN0p/2HtvyAdJvo/d2njNtG6LQ2dbclj2+MH37wh80tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNa7++zZDitY0cHHVxFQayIQ9RtWk6eR4KxnRyZaTmU=;
 b=g0OQeMRYeDItOuqTbWTLLWQDa24NDEM87F5jVRomHAlCm8GiRP5lpR85UgtT9oqrH77uE6u5oNJYytJtk33z9xaxry+H2EZrL7jBw/EeFpnDcbCDL59mCJBsCN+MMWePj8BMht2cp3t6bqNmoAq19jJo8POOhnuCggbCMCvn9C4=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB8PR08MB5356.eurprd08.prod.outlook.com (2603:10a6:10:f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:15:39 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:15:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v5 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Topic: [PATCH v5 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Index: AQHdJl4T1Lfjl0jqBESpkNM6iSoXng==
Date: Fri, 7 Aug 2026 11:15:39 +0000
Message-ID: <20260807111159.429128-7-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|DB8PR08MB5356:EE_|AMS1EPF0000004D:EE_|AS1PR08MB7452:EE_
X-MS-Office365-Filtering-Correlation-Id: b6ce20e4-7da1-4c2b-8083-08def47549ae
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|11063799006|10067099003|6133799003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 QFN5h+CuAsfIPwwPkKuPuoT+0nmYt4W2q78tkkz4vxLP5pzwe0MuCTDV1cPJYX706LzN/mQtmZrurnmstt1qIF+jSy1VLDGhVVeEPKSqv6hW0FwNipuFMSe0Cm9hhfmKzeAzdhDVWFpCcemNWA/GJ65egyOZUJuZObMNZU229RUHJMK3ruIZRScfklJo+vFpt0rSEyCS37OJQ9y/PjosDQwMMCQR45VEbX8M7pJIdKugEu52PCYxBl2QooLyr8eFJFbK+WYQP/EUhcaAZxDRG3L9bf+ug+JofpYVG6fwoTIJNap1znYXOyemf7ztl4gWObsCtIWme2k7D2wPw8SFoqxVt1gecH2OSWsHa78wzS0QKVtxMIsdbs+aMbwJWPcYJ2AVGJXCfzJ5YIX87tyQ8N6A9xKr2vCRk2X5sDE8vylNG2lLnADOgAnLJ+HaAmsye7DDAwTzx2RKY4Roa4+AMdL9ZkiwJsf3n0sxifxWA0SwUe8icXARRfNWbdKz99X5VDZwReFt13dX3ACPTU828B9pkI5jVqQB5QfQnnComyWDX1lq2jFUQBeLfFV/d0Qha47idxdDW+n9ym8jqt6P82OD6e74e/V2DObFpBQORkB9Va9mOD5uJOSmVszLXZF/IF9MNogiH2kvS0TEt7f2OXfJzpQtP1GCGimuW37oee+8RJOe0JFoBNFSV+7oeBPf1dmuc+wEP4bTIAOanAkMmBU1XtvWK/gFgFV7qwyhPfo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(10067099003)(6133799003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 AS1chJpwIJm4pf+usTHIjb8RkZOUTrW67RWjBfiFFqGk+KU+l16VSPeaCe0IrY3R5/dKCWRRtBKyWavCKD28wxRKjVILdhjx1o/aWBpoBuwZ50QN0+raO97GNUZPhPt6D8Ve6t6Et0VWHfJBn5Jz1uk0Hc+dteQ7L5D+W9w3/JQXAM+xvggV9aJrdM+00lqH7LswxnqgwrnfWWZ5ehWkAKeCQxxtfkUfxedEmdK6S9SIXRHVbUP1CbrWOd+ZL8OTLL3k1/c4BeTvefzkISrT6DlOUKpkdMVT1D/gPnB9e2ow0d2cVsDmSwrFRf1K1Rlx5y2Yt4PgG8oo4RI4u2FIMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5356
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	62676dd3-e290-4f3b-dbfc-08def475365f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|35042699022|23010399003|1800799024|82310400026|14060799003|18002099003|22082099003|56012099006|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	OHsNAqec6WI9lszW04Kig7g8cwcmaPsAdaIyJMtMatWJI4ClhBhE04VvAw/rpd7GFFBlIs8keLk8Me22uuHZCjajkWMMdzQXlog8shHNDVVALpUSgrlDbSYCRPmBP7nkxzonFjYiFrjTckhO94+cH0XeKFPHweVnTWGo6HpUpIZMlzpLj+lLRwbI2QXTwUnzxSTrt7Z87kOaoLc1MfObjGdbvFNE4wluhWVXLN4sP4Y9yU/YA4/Dmi2BoRyr96S4X95+IrCI3QIJgIT5v+A1ZzLPJ+2vTDHe1sNm2PJnu7B+uT0Rs1IjQvhrKbenuvvV4Y6C5AU1i4o4ZnAilKvvMr+AtKtK3En5wQ77i8iOh/+UbDlSYu4BQ6IAzXdPAii/uFe0aZGnd9Ae8E4rSwU78Bai+EwjJgDufQcvtsBy05fEykXL7DM3Vo6ftSaHlEXQfUz+MCqOQ5RWMwYVkeMTzN9R5oXMBPXD/q/P/Ia3vwbl2CYGNTHP3DwLomHohJZPIVXYklLzy+l6hAH140qzv2ITLGOW4+HRQYgMUVev/gMBXMke6psPulLvnWMpqLj0mOPEu3ypuAYD29vSxbqfK9x5DKZvvNnRumDTccJp5LkioAGnnevfIoWQ8ARLD5kq9E8rczO2Acs4nqDv7+sHWA1Oym+WkLn54l/S8KnE5jAC0k7uqnGKvVruNI8s2wItGHtk6Eizim04pziZSJR1vQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(35042699022)(23010399003)(1800799024)(82310400026)(14060799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aEz81fHmSvFoF3no9R1cA2UUULdtfNKlVD0Bp72M1eLXlc8sB/cah4q4B0pc7L77giA9Z9EBzvC/n4F3MOLSl+ATQ1hDkyvWj+XW0TPiYPmBG/IUXHWtAca7H1wdWIBegBY5BM6WEe88w756URfaXlRoqnGF5MAGBBjZcKEGLK6v+d/LccvsGLvzmtz4Ta4RbIalp+Ve+0979XVWhND8ZgPfVqPBv2lGMB7w8pHA70xyH2J+Yqou1wwlzFI1BWqTlOCYsQ15gCRMM4AD2erWgUWl2kaaT/TE4krvzHTZZ51hVgBFdGcuY6uhHtXdxtxURUaqalOI2AdMYVceCgosDpMcfTH8D70bbYXi4sTg4kuSnczoItqO5ClULJXPH/tm0rZkLRJSwEaqLzWVOyrciyNtlaWlvBANBAxWfQi5w6kbCeoV+cT02MlBm9PRjlxS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:16:11.6769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ce20e4-7da1-4c2b-8083-08def47549ae
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7452

These fields have been added to the architecture since this register
was added to the generator, and were hence missing.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7cb61aca3797f..03f5e1755a633 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3736,7 +3736,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
 Field	37:32	IPPT
-Res0	31:1
+Res0	31:3
+Field	2	LINK_IDLE
+Field	1	LINK
 Field	0	EN
 EndSysreg
=20
--=20
2.34.1
