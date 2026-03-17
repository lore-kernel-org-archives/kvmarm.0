Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013041.outbound.protection.outlook.com [52.101.72.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF22EACE
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747967; cv=fail; b=CopBeiU9OW1Ch2xRuulw18KGIS40d/5AsPDu47ROEjLN/zo9t9JCPia/c8X7AnPWaqSAkBlF8/GKt5cQVxFVPpru9iUkv1UBuhPlkla9Gvm2bxkt+517p4Z2OTlZPJRdxQQsdFOzE2lfE4QPWB12kXV8rvxjjCCT5pQ3/c7Bh+M=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747967; c=relaxed/simple;
	bh=T3bhuC9SRQ3cKsk9BHeqTyySpkZxD2I3xCWsrqAQXfQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dt+sMmYwF8AS3xbJoPC6aWinOMAOqNOk2xSDEvHq/EZRVaLQROU1mSvPaHacHoVrWEEFE34+HqiaXK+OVChZz0Ir2oGD8c6aLdwFHVH2wSV05h6VDDaKCVQ1t4Xf12+iQk4cXEaa6sVT1Jcd8ymOb9s4sgp7TjKvNqWTqLcuvDg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XZ70qBS2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XZ70qBS2; arc=fail smtp.client-ip=52.101.72.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XZ70qBS2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XZ70qBS2"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rhr34gNgNlDt7inUdfqqfOYAEjHMTnb4MY2V/GGfdIXGRhmD4w+RLiCnn2CQJcQO8KKD4slbQ3pBTopVg9zHlgtz8TOtmsn/es0ssSMdasP9Jewf7zRzxIalKkMOVhcP1U5lizFhQIMLQdQjPY7lpMpNj/wANgK5GPLK8ABpNvNNBrF+khS9E8/eD8JZzIdJOGgWTvbvcgBtUiKFjbJ2ifHIUOgACitwDGpY0ji5aW8ItbZYlbdtrAVyhJQb2liSooOYZqs/iMuZFGwV2TRjCSmTH0mtiREEJ3G5fzbCe6Nr6fXKvEgyvPV1K0knFgS3IfD4Pj67Se5u7mPIE/nj5A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xH59tZ2s+bZH8Tn1+IN65SDWzl+XgSnPeIwrrZeoo1U=;
 b=D9LlOW2z4crlZvUQ/xxNqj5rVIxAgy//cw8Tcd7L2VYcNf7g6YuaOZOaar200xQbXCeXaFg2LPBEZ1mBtg1FLQkT1p+nIyqX0K5PumeBvwDSfo4RYmd84ZWpG035AMMefZHY7xQ4HNssjaMUZECFUv7DzXTgWGnNVsvn8NTAOYyDZbVFu9QkM0+88vjxfWSJk4xB5RCQebV/gpth3KionfFpkY4FGnNCPSmGBdJeb5L7Inn2mcwiqGV/CYmoUg9dEzq3Bnwa0osaTjZ5Of24i3XjH5QmzXPXrXiJUJ/IP2a3FAkNzEqgjwtyk19MiGRwXZezi4vAHFLaoMilLLeBkA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xH59tZ2s+bZH8Tn1+IN65SDWzl+XgSnPeIwrrZeoo1U=;
 b=XZ70qBS2IU8AJTw4a4BU6PulIgd6HMdSDuPEsQyF+J0vk3QmhGEticwTLN8XaaLwqobJlP5pxfj4S39VW40z4kOzeVcrCBYq5eLdh68FTCKwAKt4Hpnr0RSzLcEShbZefR4+M5NEda3y9EmOz4qPByxdxwktIhVo5brRI2mWwVw=
Received: from DUZPR01CA0087.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::18) by VI1PR08MB5439.eurprd08.prod.outlook.com
 (2603:10a6:803:13b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.27; Tue, 17 Mar
 2026 11:46:01 +0000
Received: from DB1PEPF000509FA.eurprd03.prod.outlook.com
 (2603:10a6:10:46a:cafe::d) by DUZPR01CA0087.outlook.office365.com
 (2603:10a6:10:46a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:45:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FA.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Tue, 17 Mar 2026 11:45:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zGYAs6LH7ANE6P+FRsiRz34cG6UyZqou53idyz0Q7qOzpd6luhONG8RP6ntgyE1Y6rgAW/6gLf37/KxXsZPcdq7DNseJPc4P/4JvG1OBwFTflgeschAFBbCJRFdTfMSBSXJ+nkho/DiPf/pMRAWbU6rUW3+VGlAyqU4Ip93ZrUGFapu488jLY7D/NmHsgsuVDEqlR2X6X5b5XyI8LoU9xRSvMqiVa+8B32vVMNw2wLIJyJ+Qv9Bdn1PUei6RZRI14gEXC9JZeAz8O2U7633GFixpR3EkOEt1NAEnJaru0riqw1IAgp67v6QGbvO/Vo50CRDMVNshbjbgp3Um9JohEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xH59tZ2s+bZH8Tn1+IN65SDWzl+XgSnPeIwrrZeoo1U=;
 b=WYleKla0rJk5idHbHINwvISHNY2/8zXcX5IJehBzjkUYf6Yk2wksqZmqGvpCOt3HDmEPvOt/mkCirm5G5fvotASbKXJekovIIhlRyBf8r/mRf4BOdd0uqzQL3fmOcmwrLypvJYCeMhmbwGjg4CQI2B4Tp7CRciRRiqagmRsFJdpHsPo12ip+7MRkBoD8/2iOSieE340Cgo5v/s8ybojyM6lgKui2Pae2XT98AyUOXGKm8ij/hwz7xbDc9u3T2sLj9PaINiH0r7yiGZxKctWPVbHSr+PiqnDCJENVQyPrzA5u9KlquJfsfiypouMtkY6c6NIq+STZmJaD/MBzWvhNeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xH59tZ2s+bZH8Tn1+IN65SDWzl+XgSnPeIwrrZeoo1U=;
 b=XZ70qBS2IU8AJTw4a4BU6PulIgd6HMdSDuPEsQyF+J0vk3QmhGEticwTLN8XaaLwqobJlP5pxfj4S39VW40z4kOzeVcrCBYq5eLdh68FTCKwAKt4Hpnr0RSzLcEShbZefR4+M5NEda3y9EmOz4qPByxdxwktIhVo5brRI2mWwVw=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA6PR08MB10417.eurprd08.prod.outlook.com (2603:10a6:102:3cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:44:55 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:44:55 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v6 19/39] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Topic: [PATCH v6 19/39] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Index: AQHctgN5AlkAt3mpbkWVXDlYxX9LXg==
Date: Tue, 17 Mar 2026 11:44:55 +0000
Message-ID: <20260317113949.2548118-20-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA6PR08MB10417:EE_|DB1PEPF000509FA:EE_|VI1PR08MB5439:EE_
X-MS-Office365-Filtering-Correlation-Id: df9633cc-7c4c-472c-a083-08de841ac26e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 pmjGfd++tsf8Dw1z/Mu5rcxI3n/th97S4tLNYuQc444Xt6qfuDMG+Y5xOO40hxbbvCmZH6Tbki2r4k9se88AKoBv96iHQSM+4njiqCrmvSXBUHaVUQpBQGsa8VQR6JcbCp+cR9S37FdNgr+cpBNV0ZWiHPJA7NULLkY7F+YajvNE5RRuvqTO/pt/WRqZ8slWuCQY3+1kbMeO6BB6yhB9+AJyYIWNm/B3MW08pJVeg+vld9q44s8OlZfRshMntyb4lZN1evUot3eLJjTorGWqJOYdychhZaJgrQVnSjPohGxXP4GaP/WxQo8WWt6OSIcX70w9/MAUYJq8SgCl3BALlF7lPDsCCVYg7fonA7I7Pfs9YX90YQKMcZwxo9/AEJTlbvDQk5Wx+AFXOanIbbVdtk6nja/GvgTHP7pR1KBrEyUjTz4qRuThTe4ddb6Pyt5mKKw//nMoP31J2uvOJPDSHC1Zfk+aX4wuu9EBNvLhCCKXqcH5U+k/jJzeeDpXH6C5OcFp8YXGFqbOC2s0nDIbpwCrAMuLollUcl5LItzgYm8Ia/qtKH9MrjiwAsfj7Hw7xl1UXihgOS1dZKSQQq3UqPfUlA8A7IEToNWShUF9y7aYMlhWHfDoNWRqhm906mxTjqKgQJLht04lGUOUPkMyNL6HFwbbu2aU4IsejLjYocXPrS4EXaxRLz6jN+JY8UYo7wOk2E8qOPcTtj0pHgKz4Ap8b6p51ns19iYfIKn49ceR596eapsrB3Vcay1wQA9MPgqB5jeLN2izy5ZWMXpocABl2Y3Gvvd7B+FV5pGsIjA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 c/H2EIf3cHWCxcvHTAai78ezhsE0yqalo1XiFyCxD7Yri71nSunBqq4CfozhtmdrJH92lOczlObkgnjFNB3sXnJgunAktGs0+gpyatw3CCVvj37ZLkAwuBjhgwN6fq5ssQ/p76PNgqbYoUcw2Kbu3ew94HkGVk0SfzY/B2VkZVzmgtP43Bi49Use45RcIhppzBn4GBbUij9vnZcFtqogkZQqfidJnsQmM07eU6v0T5YzWRCmNWU5pWHFtkw24C1ex7NWk2hYef1FXQ4xQKN1O6DWvkn4rkLRUopgKa9z2TskyH0HMBVnSyDmCTPFpNWDyqHJIDARdereplGjliqmHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10417
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FA.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6af10c1c-176d-4cbd-80e6-08de841a9bed
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|35042699022|14060799003|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	asEeqhee4tEc6mfJ+6MSrGim1STPQtlmo1JfDBwdKMmoP2UYqZD+wuxLPw5qrzU5nVLdT+p2lZThiuRHXCMoXlfmLUhyTJNpZ3j7TMhjPyzv0nboRJsfGTqhBEUK3r3m+BAfNs2IobHAHuT392PAmNQpl1SaE3G5aDaCS2/BIVoxFWnTiaD5Qd2D0MEY56B3aFSA1fLzWIBJJvy7FjxTKjfqFU12+CpjdmYt5eHLL4RDYrVnhqjVEao7BkZLMSUaRTgg8DDgRcNmNRGS3t2PvQ4IXm3XDzgEalxsZiQvIE/cEQTqsQVDo8tlDMl0A7cXvp9TtIvviHK/B7JIPRUgbSgnenBGl4zxBg7vUE1bTXdizIvdaVkaF2qiari2KsdwQ0m8j6oITcnLJ0SAQThy/+QbW1FYHs+lQwuOzKeocgsZ99+onuUWTfq1GGarpWcsVO4QG6eldDGgIRyuaYOJNmPbGo/C60ymSPKCqqPU3tGW0gaz0Scxr5K+Y2oYu2phq1IfS0rzC72nZnHla81J9Z1faYPLWsjbgBb/w8eEQgxErIL/PWtvcJMbC04n7aeoF09XlKoQOE4kM7ZHchQqt0Y2IShSiqAHFAkd4hIfCFHwboRzs9zAvdYxEKjp/6/vdIui3+EEz0dzRX72Cda6/7EJD+zk+W0F5RV9QLktWIRXimc9Dkj2kiIojtrKtVWiC+9Y9i554jqpBkQt9Rbp78AFOEpkRgTFvJDZNy8U5z1yeSSS0V8xSHYq65kBiW3RgMGQ5zbsm3eOCa4uDt2csA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(35042699022)(14060799003)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CfY1xA793D//LhjiSQVjhwuxDeaa8GassjEJ4V88Fw/G0Au05ttdTlVLw4v1dbkFOmzy7c0BXV2Qn4VqcCiMog+XtJIbkiJZ8wgd7Cnu9LvMWdM7I3//oK+v7OMwuiEZeEqjUqxXaOZxuJGg7GUjXqkQOphg6rBYsV343ayywfv3/P+Rid+uv1fXRohWzvcnAnHCwH4ClSMobC+t3EiJ4BiwC2EuTHEQmrhf/3Tyud7GkOXnMJ5HL3WxDsW8uHDwiwOJ54ZNVqf6TUeY7m3Ut4FbX5YmuNY+ojplrwUsuBlmpJAsqA7/fQtBzC4o8TkzRBOCpL3+H1chr3HKmMCmcF2GXfabc2j/kqpErdihuB5l4K3m3Qq+hBVkuuw9Fj8Q+vnyH8HC6Ou4WR4b77qYrI4EiVq87nn70v9IZdpQ+PuBC3zLnMaOxzP6JYfJRMpk
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:45:59.8159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df9633cc-7c4c-472c-a083-08de841ac26e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FA.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5439

This change introduces interrupt injection for PPIs for GICv5-based
guests.

The lifecycle of PPIs is largely managed by the hardware for a GICv5
system. The hypervisor injects pending state into the guest by using
the ICH_PPI_PENDRx_EL2 registers. These are used by the hardware to
pick a Highest Priority Pending Interrupt (HPPI) for the guest based
on the enable state of each individual interrupt. The enable state and
priority for each interrupt are provided by the guest itself (through
writes to the PPI registers).

When Direct Virtual Interrupt (DVI) is set for a particular PPI, the
hypervisor is even able to skip the injection of the pending state
altogether - it all happens in hardware.

The result of the above is that no AP lists are required for GICv5,
unlike for older GICs. Instead, for PPIs the ICH_PPI_* registers
fulfil the same purpose for all 128 PPIs. Hence, as long as the
ICH_PPI_* registers are populated prior to guest entry, and merged
back into the KVM shadow state on exit, the PPI state is preserved,
and interrupts can be injected.

When injecting the state of a PPI the state is merged into the
PPI-specific vgic_irq structure. The PPIs are made pending via the
ICH_PPI_PENDRx_EL2 registers, the value of which is generated from the
vgic_irq structures for each PPI exposed on guest entry. The
queue_irq_unlock() irq_op is required to kick the vCPU to ensure that
it seems the new state. The result is that no AP lists are used for
private interrupts on GICv5.

Prior to entering the guest, vgic_v5_flush_ppi_state() is called from
kvm_vgic_flush_hwstate(). This generates the pending state to inject
into the guest, and snapshots it (twice - an entry and an exit copy)
in order to track any changes. These changes can come from a guest
consuming an interrupt or from a guest making an Edge-triggered
interrupt pending.

When returning from running a guest, the guest's PPI state is merged
back into KVM's vgic_irq state in vgic_v5_merge_ppi_state() from
kvm_vgic_sync_hwstate(). The Enable and Active state is synced back for
all PPIs, and the pending state is synced back for Edge PPIs (Level is
driven directly by the devices generating said levels). The incoming
pending state from the guest is merged with KVM's shadow state to
avoid losing any incoming interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 143 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |  41 ++++++++--
 arch/arm64/kvm/vgic/vgic.h    |  25 +++---
 3 files changed, 194 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 07f416fbc4bc8..e080fce61dc35 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -122,6 +122,149 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	return 0;
 }
=20
+/*
+ * For GICv5, the PPIs are mostly directly managed by the hardware. We (th=
e
+ * hypervisor) handle the pending, active, enable state save/restore, but =
don't
+ * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
+ * state, unlock, and return.
+ */
+static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct kvm_vcpu *vcpu;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON_ONCE(!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		goto out_unlock_fail;
+
+	vcpu =3D irq->target_vcpu;
+	if (WARN_ON_ONCE(!vcpu))
+		goto out_unlock_fail;
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* Directly kick the target VCPU to make sure it sees the IRQ */
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return true;
+
+out_unlock_fail:
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	return false;
+}
+
+static struct irq_ops vgic_v5_ppi_irq_ops =3D {
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq))
+		return;
+
+	guard(raw_spinlock_irqsave)(&irq->irq_lock);
+
+	if (!WARN_ON(irq->ops))
+		irq->ops =3D &vgic_v5_ppi_irq_ops;
+}
+
+/*
+ * Detect any PPIs state changes, and propagate the state with KVM's
+ * shadow structures.
+ */
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	DECLARE_BITMAP(changed_active, VGIC_V5_NR_PRIVATE_IRQS);
+	DECLARE_BITMAP(changed_pending, VGIC_V5_NR_PRIVATE_IRQS);
+	DECLARE_BITMAP(changed_bits, VGIC_V5_NR_PRIVATE_IRQS);
+	unsigned long *activer, *pendr_entry, *pendr;
+	int i;
+
+	activer =3D host_data_ptr(vgic_v5_ppi_state)->activer_exit;
+	pendr_entry =3D host_data_ptr(vgic_v5_ppi_state)->pendr_entry;
+	pendr =3D host_data_ptr(vgic_v5_ppi_state)->pendr_exit;
+
+	bitmap_xor(changed_active, cpu_if->vgic_ppi_activer, activer,
+		   VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_xor(changed_pending, pendr_entry, pendr,
+		   VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_or(changed_bits, changed_active, changed_pending,
+		  VGIC_V5_NR_PRIVATE_IRQS);
+
+	for_each_set_bit (i, changed_bits, VGIC_V5_NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			irq->active =3D test_bit(i, activer);
+
+			/* This is an OR to avoid losing incoming edges! */
+			if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+				irq->pending_latch |=3D test_bit(i, pendr);
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	/*
+	 * Re-inject the exit state as entry state next time!
+	 *
+	 * Note that the write of the Enable state is trapped, and hence there
+	 * is nothing to explcitly sync back here as we already have the latest
+	 * copy by definition.
+	 */
+	bitmap_copy(cpu_if->vgic_ppi_activer, activer, VGIC_V5_NR_PRIVATE_IRQS);
+}
+
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
+{
+	DECLARE_BITMAP(pendr, VGIC_V5_NR_PRIVATE_IRQS);
+	int i;
+
+	/*
+	 * Time to enter the guest - we first need to build the guest's
+	 * ICC_PPI_PENDRx_EL1, however.
+	 */
+	bitmap_zero(pendr, VGIC_V5_NR_PRIVATE_IRQS);
+	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
+			 VGIC_V5_NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			__assign_bit(i, pendr, irq_is_pending(irq));
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	/*
+	 * Copy the shadow state to the pending reg that will be written to the
+	 * ICH_PPI_PENDRx_EL2 regs. While the guest is running we track any
+	 * incoming changes to the pending state in the vgic_irq structures. The
+	 * incoming changes are merged with the outgoing changes on the return
+	 * path.
+	 */
+	bitmap_copy(host_data_ptr(vgic_v5_ppi_state)->pendr_entry, pendr,
+		    VGIC_V5_NR_PRIVATE_IRQS);
+
+	/*
+	 * Make sure that we can correctly detect "edges" in the PPI
+	 * state. There's a path where we never actually enter the guest, and
+	 * failure to do this risks losing pending state
+	 */
+	bitmap_copy(host_data_ptr(vgic_v5_ppi_state)->pendr_exit, pendr,
+		    VGIC_V5_NR_PRIVATE_IRQS);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index f3677535200ff..3b148d3d4875e 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -105,6 +105,18 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vc=
pu, u32 intid)
 	if (WARN_ON(!vcpu))
 		return NULL;
=20
+	if (vgic_is_v5(vcpu->kvm)) {
+		u32 int_num, hwirq_id;
+
+		if (!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, intid))
+			return NULL;
+
+		hwirq_id =3D FIELD_GET(GICV5_HWIRQ_ID, intid);
+		int_num =3D array_index_nospec(hwirq_id, VGIC_V5_NR_PRIVATE_IRQS);
+
+		return &vcpu->arch.vgic_cpu.private_irqs[int_num];
+	}
+
 	/* SGIs and PPIs */
 	if (intid < VGIC_NR_PRIVATE_IRQS) {
 		intid =3D array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
@@ -841,8 +853,13 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		vgic_release_deleted_lpis(vcpu->kvm);
 }
=20
-static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
+static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(vcpu->kvm)) {
+		vgic_v5_fold_ppi_state(vcpu);
+		return;
+	}
+
 	if (!*host_data_ptr(last_lr_irq))
 		return;
=20
@@ -1057,8 +1074,10 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
=20
-	vgic_fold_lr_state(vcpu);
-	vgic_prune_ap_list(vcpu);
+	vgic_fold_state(vcpu);
+
+	if (!vgic_is_v5(vcpu->kvm))
+		vgic_prune_ap_list(vcpu);
 }
=20
 /* Sync interrupts that were deactivated through a DIR trap */
@@ -1091,6 +1110,17 @@ static inline void vgic_restore_state(struct kvm_vcp=
u *vcpu)
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
=20
+static void vgic_flush_state(struct kvm_vcpu *vcpu)
+{
+	if (vgic_is_v5(vcpu->kvm)) {
+		vgic_v5_flush_ppi_state(vcpu);
+		return;
+	}
+
+	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
+		vgic_flush_lr_state(vcpu);
+}
+
 /* Flush our emulation state into the GIC hardware before entering the gue=
st. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -1127,13 +1157,12 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
=20
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
=20
-	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
-		vgic_flush_lr_state(vcpu);
+	vgic_flush_state(vcpu);
=20
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
=20
-	if (vgic_supports_direct_irqs(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm) && kvm_vgic_global_state.has_gic=
v4)
 		vgic_v4_commit(vcpu);
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index cc487a69d0389..ef4e3fb7159dd 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,9 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
@@ -432,15 +435,6 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
=20
-bool system_supports_direct_sgis(void);
-bool vgic_supports_direct_msis(struct kvm *kvm);
-bool vgic_supports_direct_sgis(struct kvm *kvm);
-
-static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
-{
-	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
-}
-
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
@@ -481,6 +475,19 @@ static inline bool vgic_host_has_gicv5(void)
 	return kvm_vgic_global_state.type =3D=3D VGIC_V5;
 }
=20
+bool system_supports_direct_sgis(void);
+bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	/* GICv5 always supports direct IRQs */
+	if (vgic_is_v5(kvm))
+		return true;
+
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
--=20
2.34.1
