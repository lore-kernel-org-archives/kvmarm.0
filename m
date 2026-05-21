Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012012.outbound.protection.outlook.com [52.101.66.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199D41A6831
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.12
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375288; cv=fail; b=J/rzmye4f+LpUq5VJa/dQpfGX/rX9kbTUsY64RWujE5wOQIaTtYqJHwhzkRZNdKchPDfWkxcpl+gkM2i9JHStJHduNwHinb3Hci8uQhrZehwM5z9RxgS34dn4TjNBFl0GmbVPXKTkAMkVW9ax0PF08cwlAJKSCALvU9uBsTlzKg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375288; c=relaxed/simple;
	bh=lF9nogfSZvACGm/HOfLXfhDSNjEzluSetWontEjOcEA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ciphyon+aIphPn64fY+L6pFCF/SpD4qdT533VzpGH5U9dgLTH8+sRjhABEldwi/6jiEKcKigpGQyWcbUFBfhtWBGCdbpmBMy7QdNHAj+XF5qZUw01qnqVgiA72ca94esDHo4QxSa+P0gd8wMFODWCPVbIc0gzlB15LYudg7rm7c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZAPy8Qqe; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZAPy8Qqe; arc=fail smtp.client-ip=52.101.66.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZAPy8Qqe";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZAPy8Qqe"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Phy1f6b3qW6edru+ZnKp5FUW+GOswRPSXSxFsQU0jLXUqU7kBkBKbv3Rukc75m/AY3RALSW3sw1+kWghDbgg7HCIkhrPvKqQJRHCIUOMujAfDC6MEYAEyMkm7/O0ZUOCBcfriX0X3G5JwooXiyDXLBQF1Ty65tYkjRN+1SC4BqkCEEt1XZTx3leNnvAzysD1sufbbhrMju5PKoDuJ2GICyRqJsUPneJSKPdy2gbMYUkh3hd7kOfLotxANSs8lT4DCidzea1fSD9XjCM8SwRAF9W575zZt62+iapVF0RI0OEhJhmNqvxEmo7teo7GuSux1WimO2zcW13F5Po76y646A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2ubGgZd5sC/5snAfCAu9CvdpYUHRPcO2pJXaaPmDT0=;
 b=WB7bPTfAOj+p3Vu3ihkfx2eziXQ6w1RYDMv8qx7PKNI+5hoqGhaUK/J7sWryvYm9M0MyIcfGBXr4lQG6mA1O4McYf6NIcOk3+hSgz3Vzd3o/y6upkQmq31FpA0msl4Ll6Xl/vwzBT82MWX1xIHIkJLvU4DNA4/yThJYAq9HzkW2jYXFs9g4H3/KAd3qRKX9aMAfGRmATElpfDNaxR5wppkloqA25kLKOkiiHz+BCSm8T7hzyrK4SlurfU/WCjYOG2wxHeoSUs2cTRWasapDabhUJIqjF/Olp3HEH5gXMen2jXYS4ZKxTyJ+xhN996dY5Xwv+JeQVzIKRxIYY27oh+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2ubGgZd5sC/5snAfCAu9CvdpYUHRPcO2pJXaaPmDT0=;
 b=ZAPy8QqeInZyxFulEpuoFEJWeoTkF788Q2ehVjAUCDjsW1gqQAlAVCNJHKR0EsfRQV/GGH/6EKuLR04oKp/N7qcw1I2RYV9G7SRz0FM0JE0HJqxL+Ye1mBAtUxoqddLB2OMzatYihL0FKglDtkGywjkfe3H7oEnEFPa7BMi9EZ4=
Received: from AS9PR05CA0279.eurprd05.prod.outlook.com (2603:10a6:20b:492::11)
 by AM8PR08MB5570.eurprd08.prod.outlook.com (2603:10a6:20b:1d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Thu, 21 May
 2026 14:54:39 +0000
Received: from AM1PEPF000252DA.eurprd07.prod.outlook.com
 (2603:10a6:20b:492:cafe::7) by AS9PR05CA0279.outlook.office365.com
 (2603:10a6:20b:492::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:54:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DA.mail.protection.outlook.com (10.167.16.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:54:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=faCS307sths2CqSPQctEnXVHSJQuDjIk1rOV/00TNgGo8ojUsXyHno3/QkwwxtFIG7vPd9e2j5BYgRKb0ZVf82VDbv+BouG4RGvzhVIGI6GR9LURCuN09Ay5hMr2fMmztrFAri9hxCHg25H5xujt+mG2w5tHByNf5T7yjHJ9y4WssbFLrfK1ApGcRxweZiRbCk5fsIfxs/65k3eis77Mih6Ynub1BrmkL38BU2ITsZqu1Zte4wvF9UaT4ZmMRwI0aEeQySns8WZ3xlzLq5MpkuY4rnIyaFtMQri6D3WF9ag775WpkKhRjybjdLpr6GXeLklykCBYldkFr5i45AETrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2ubGgZd5sC/5snAfCAu9CvdpYUHRPcO2pJXaaPmDT0=;
 b=JleEBQ8ZBYewl0Ujz3b+zsVg3EivoxzUvcJ+4Y8LZK7VgB3g5twiNLMZGTh3chuQxYD+GXmijZxxIJu1IZxsPVC+uKyCGpuDz9oz+JbRlSfHZ2zE4POJmKZpddGLWmKNViK0OcK0tdmq/bBQViY6ucS44z3p5Fbfm9Sd154mMftruqueRT9OTca2AVfEHqTKAdShK5TRfKIw9DMGIyWRwNlYeK1D4hEFgiQzQFD646ill2Su+dER0JXSlAlNPsQuRGQ0R3ezvmmujxTcX6BVFAOkFOGd8rPBhftm5cm8M4Lt+3FuISXALI4MYsaaOaPqKC9SwyTqKDEctKW1jHQf3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2ubGgZd5sC/5snAfCAu9CvdpYUHRPcO2pJXaaPmDT0=;
 b=ZAPy8QqeInZyxFulEpuoFEJWeoTkF788Q2ehVjAUCDjsW1gqQAlAVCNJHKR0EsfRQV/GGH/6EKuLR04oKp/N7qcw1I2RYV9G7SRz0FM0JE0HJqxL+Ye1mBAtUxoqddLB2OMzatYihL0FKglDtkGywjkfe3H7oEnEFPa7BMi9EZ4=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by PAVPR08MB9209.eurprd08.prod.outlook.com (2603:10a6:102:30a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Thu, 21 May
 2026 14:53:35 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:53:35 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 13/39] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Topic: [PATCH v2 13/39] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Index: AQHc6TGZiBzcAcK4eEa6OLukkWofXA==
Date: Thu, 21 May 2026 14:53:35 +0000
Message-ID: <20260521144846.1899475-14-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|PAVPR08MB9209:EE_|AM1PEPF000252DA:EE_|AM8PR08MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 2401e1d2-a981-4c01-4899-08deb748e22f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|3023799007|38070700021|56012099003|22082099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 XVIN/FYH1TX0Kir/u1MTbSTjJD561PbJjHKDORsvwVaRNqFUY+wOABWmxeDCU+U9CgEEje8TVRLbUtRTPXL0frt0jiaJpJTAs/43imv4D2I8DlalOKYxvc++zlRpHMXb43FJueVWc902V0c72mQe/WaMZ9AizI6QQ6hoS19m+oZvlS/ZKS73lin4QRfuqaedz7PXKmh/yjJcxruGOZ6P9v1Ih9Qz5dTiayoq8MlN/ArcJLq3+41YOmXyYzDH/bVpffZwGiNqG/HUvtPToL6R4WkkH1yQpxEQ9dbRu+68X5JHhtHb6r0eAJQCpFt7aKfTXrLt3NQzeXfMXcKGgFG2TpsNE40HKqPbg38i3+aEzp5koSKQtpJHNcwFAhWK2ghhx5wVXrzqJWNzVd/lJO/wsE7UAfujTgcdN1q/T0eQ3uJkjAoe6kxidpJF2Ou0dlJeYpo+8j6upfLbl0MSyy6gJRafolAaf+YVH4HdwD9n90v332xZhJHRCQYWXjv1YTi2H4ma79P75d2XweGEAJ/wlFhWDNvK6CsM2Lvysg6ISuU0m16qijSuGX5xS+6fkUCQHza0ETKuyhGceDLFcvXhATy9w/T3FfPfztIY0b7q1juapcxO9ZprL5iF0vktPppnK4m3wH+gk0FlRtp7YQF2gJu5DePhDOvb8mkx2dOFcjdIK7TzRPfHUHicSMzG/Bet/inqWbCTjZ/SMKYIYEDeGYo6melutMT3uvCbqNgZHPuJkJSrVIDLcuVFT9nuHpLx
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(3023799007)(38070700021)(56012099003)(22082099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 dcKKsnUg+RfTvXqrZ/Os3FtvxlOck15YPrg7PwQoyn1wQRViNfFMETXjyPQUnU2phTLResYfO4DNFO4/U69dAS5nEd6VVzUcWB/bH/i5bggqYZtleqpVyDZSFN+1uP2Clyr/O3x4SbV3XupbsrPMXUurW6TE0tKdQULEHlZHsVUDXYCQKclATmTZ1sbg7CFTGUp0I1T56M9/S44qTaamL6mdWHcnXtuLbxOZ1xn7es+zG9P9DJAEX3gaxwKPthHJ/9OY2Ls31WDyAEZsQMnMi1lWzhxzHgaQ1Sqsp2veCN8pbQGeLPZdsATxkKD+TMP34nxxP/mgh/4PlhNAtjc3Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9209
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DA.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b1d03a86-7d51-4b4d-1f4b-08deb748bc3b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|36860700016|376014|1800799024|35042699022|3023799007|56012099003|22082099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	mNOyP/7w9lhEhlFBN/q1udxZXzX0mmUK9/ADgz4qGdqOoJGQ1y8wXoL6C8uJXM7b+1pflcv7vzfd+4wRWS1mpOvCTXNSaAa+SWC2N79dT0eWUy63SsRG4h3qmvN6Obg90JlSqlGsBWe11EZQOZKFI7Wj0bffzgrdeyzwsZECW+3IDr8Dm4eDL6SbCog7NZKTUjCqkGvNEQAKWRC9RKxb6NCafof+S7ylchXHv67HYo+a1vdfHt4gI6lxArhDGIIaaO7HKtT2qCorctiQs2F8tNVuV2Z/wurIz75fIQAYGiDSEwAxBJ98yqR3xpVLzX/KwP5iPBTIRFQHggki3U1bx9mESdOiIDX6m1YCQxKstnLMkQkxmINB/sjBhE0pf37i3uQVenWg/MMUbHlL0s0yelnQMn47F18F/22VT1S7Ko+wY6eHRn0S305/ZNYD/ifpmfUpROdzM+50wVNzCd5jcEO/rCJDXiYROY9CxbxDaVOvfelb9Ho4a6GaBLBk4l3A/Vwz7o64/9dEz2wTz9xcRYc0EXuN1o0kTO/qanmnBhys5kicv9x+6Iv7fAn5vCUUouDUZmVWcRTV7PlJzo8BXojUcQBOD5wcgBRzAYMVDb8gxVHrTKjw5qQjxeXr1eqixB/iS0s2GLpBnBx9AS0z1xeRzN9rHW9Uj1fFWvHVqdPwEBWmRSuUjSavgXzDcK/J9aif18yPKPpn/Xg0mx38X8LT3sQhslR1r5Y6P3lawdg=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(36860700016)(376014)(1800799024)(35042699022)(3023799007)(56012099003)(22082099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iYztVYoRUHDW9c8fy+gdosCI1VhAAggTp79BDylJ+YQJ3a7JKbEmeF2b6eP8ZEiIrbSt0+qcdrOJxAwTV4ai3p/tsODel2L+JZEXnxZG33ONUfK4OF3RQHEpaVILVByQDxjF8DQa4BzkjAv5uZeXp6G12JFFs1uwbesUeAsHz0jQLeLfBo1/yMNKbGXXS5VelXaadWO/e5N/f70Hlu+QMCW41oemjUke+q8uvsI6EPkoKN/XTQCxlsagSly+AkdAyPtJo7jyWxfUrhwRkm+au/9neZOlpHRpBoIC/mABEFrI2LvcxcL/shRxgY226N3IugYBTDvL+XnNjfBi5PcgNOhKaPBFz6Y5T3TYDeFBxByLk9K7DI7lWe+JaFbqkVIXZrVQNMWPVGsRGQE5+DtPqB+anJ7BSztelkWnx6o7+OUPaq2qRSQ9a0nTVMfP7ROW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:54:39.2428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2401e1d2-a981-4c01-4899-08deb748e22f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DA.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5570

Introduce interfaces to make VPEs valid, and to configure them, via
the host's IRS. As with the other valid bits in the GICv5 VM tables,
VPEs cannot be made valid directly, and instead are made valid via an
IRS MMIO Op.

Additionally, some of the VPE configuration takes place via the IRS
MMIO interface too (via the IRS_VPE_CR0, IRS_VPE_DBR). VPE doorbells
are, for example, configured via this interface.

The existing VPE-doorbell-based commands are extended with:

        VPE_MAKE_VALID - Make the VPE valid in the VPET

Note: There is no VPE_MAKE_INVALID as VPEs are only made invalid on
teardown, at which point the whole VMTE is marked as invalid. Hence,
it is not required.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c      | 84 ++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v5.h |  1 +
 2 files changed, 85 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 909cef5f31afa..6a312c24d0b31 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -228,6 +228,18 @@ static int vgic_v5_irs_wait_for_vm_op(void)
 					NULL);
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VPE_SELR, IRS_VPE_DBR,
+ * IRS_VPE_CR0.
+ */
+static int vgic_v5_irs_wait_for_vpe_op(void)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_VPE_STATUSR,
+					GICV5_IRS_VPE_STATUSR_IDLE,
+					NULL);
+}
+
 static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
 {
 	int ret;
@@ -328,10 +340,73 @@ static int vgic_v5_irs_set_vist_invalid(u16 vm_id, bo=
ol spi_ist)
 	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
 }
=20
+static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_id,
+				  irq_hw_number_t db_hwirq)
+{
+	u64 vmap_vper, dbr, selr;
+	u32 statusr, cr0;
+	int ret;
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	/* Mark the VPE as valid */
+	vmap_vper =3D FIELD_PREP(GICV5_IRS_VMAP_VPER_VPE_ID, vpe_id) |
+		    FIELD_PREP(GICV5_IRS_VMAP_VPER_VM_ID, vm_id) |
+		    GICV5_IRS_VMAP_VPER_M;
+	irs_writeq_relaxed(vmap_vper, GICV5_IRS_VMAP_VPER);
+
+	/* Wait for the VPE to be marked valid in the VPET */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
+	       GICV5_IRS_VPE_SELR_S;
+	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (!FIELD_GET(GICV5_IRS_VPE_STATUSR_V, statusr))
+		return -EINVAL;
+
+	/* Set targeted only routing (disable 1ofN vPE selection) */
+	cr0 =3D GICV5_IRS_VPE_CR0_DPS;
+	irs_writel_relaxed(cr0, GICV5_IRS_VPE_CR0);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	/*
+	 * The VPE has not yet run. Therefore, make sure that all interrupts
+	 * will generate a doorbell.
+	 */
+	dbr =3D FIELD_PREP(GICV5_IRS_VPE_DBR_INTID, db_hwirq) |
+	      GICV5_IRS_VPE_DBR_DBV;
+	irs_writeq_relaxed(dbr, GICV5_IRS_VPE_DBR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
+	/* Our VPE ID is the index within the doorbell domain */
+	u16 vpe_id =3D data->hwirq;
=20
 	switch (*cmd) {
 	case VMT_L2_MAP:
@@ -340,6 +415,15 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_dat=
a *data, void *vcpu_info)
 		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
 		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
+	case VPE_MAKE_VALID:
+		/*
+		 * We need the actual LPI ID which lives in the top-most parent
+		 * domain. This hwirq won't include the type (LPI) but that's
+		 * not required for the IRS_VPE_DBR.
+		 */
+		while (data->parent_data)
+			data =3D data->parent_data;
+		return vgic_v5_irs_set_up_vpe(vm->vm_id, vpe_id, data->hwirq);
 	case SPI_VIST_MAKE_VALID:
 		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index ef649faeeb0ff..4cf85859f3a31 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -623,6 +623,7 @@ enum gicv5_vcpu_cmd {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	VPE_MAKE_VALID,		/* No corresponding invalid */
 	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
 	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
 	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
--=20
2.34.1
