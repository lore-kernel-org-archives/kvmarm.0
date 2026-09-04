Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013068.outbound.protection.outlook.com [40.107.162.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FBB4734C1
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523018; cv=fail; b=jSUc1DRhAVdqYyzwpR0Y0bdwV7zSxm+9ImEV8fu7ljeKiH7jrQ/5NhMz1WbI3NQrzZfV15EVMU1heGR6HjuSz/KRSb27TI0gs9M/WAwy4urCB8GoXw5GxWuNoWRKH4d7SvWCqusp1q8rL3DfVPqaoZXjUrLOFzKLX1QiGRgS9aQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523018; c=relaxed/simple;
	bh=t3Yibu+ZS4ew1XkdVXQGZE0anWZI5qpxralF1l3d3WM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KUE2dXvLBfUhxR0C0iylCm+Hpl4klkqBvYTH1E5sNjxcNJ5VgW0+5DPqi3CzssD39R+GNXsaQVOb1LvOmekQViZMHfSJ80iqu4NovArNDq3Dy+DOtD6tEt6k9m5CeW1sOQEtfuGyr17Nn6ZWJr2eaGlgA468xGE4Tmz3pCQNDKQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X7VxPi/P; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X7VxPi/P; arc=fail smtp.client-ip=40.107.162.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X7VxPi/P";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X7VxPi/P"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aaYZcdH8ILm3n6LxltZCP3kHiqWj/+mQYNJWaVH+AurX6uMRZ/ds+kPGTMUCvbJF493USQ6Gu/Hlkn8Y3QpWkmVrcqK1DVJEbl76/RlxYiWyXXeaRDf99+tX4Fbg3sg/UDxYCm4aWqExHBOFT5BjXYpStFtt8ZTxlOIt/WmpOb0OgkHtW1X6JiSc2wQeGZIOhLSRW28exC7jhKREY+2mxsE9mvl3hgksmpvsEUwJ8hOHg2y8KXXo4nwOoV6c/1/z32spohIF8j0BSnO/e22jvpT1abRe2HbxfIXlp3dagVFD35V7B4AyXucVLUsUi7/ORNxcYbzLqK2t5S/5y1x5dg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmdmevIXm/7mffxgGo316uC3Nh9SSZQqQrxWwIUvqO0=;
 b=E22/Qun23Z//Ed/ie73pTLzurapS6TdOlo0ge4gnhuYEonSlxtC/lzptIFMnLAj8sRTTC2qGdtbJQKVmDujrpTKKOT/M0K8r1IKuUMusvEmwQ9NLIdVbR9ptSUA8je88lbjqOZotNKEhhbe8dp6abktFcAEwIxyLQm6gfRAFOsBxGaQhqmXMpaReQOULsDeu7vLCvKKdRTvh+j6TvjJMVADs2XtVJ+MhRX1FxKvkWvBujYKCICPeVySsBSSHKS7Dqy9pLsO+jVB+a9wgjZVILMSpsmz+hieggoQFvDKvkFPPehk4bocrqUDMxC2Ww89m3OKqAC8KBRclqcHLU9fTrw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmdmevIXm/7mffxgGo316uC3Nh9SSZQqQrxWwIUvqO0=;
 b=X7VxPi/PBcZoqGkvFRGkPj9LPXVsbwiuOOiqG+/2x02qi5Dz+W2sCTUTRXVNpKg2cXr+zVhQzXPQyYURizI7e3nu5nmmAppof1VkM9RA8ewTfvjCMtENWftjGg5/oEynVBnSzwz+qoSPkh7wcpC6EI4EsrMOEz6YjDyBDcGZ0A4=
Received: from AS9PR06CA0768.eurprd06.prod.outlook.com (2603:10a6:20b:484::23)
 by AS8PR08MB8246.eurprd08.prod.outlook.com (2603:10a6:20b:524::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:56:42 +0000
Received: from AM3PEPF00009BA2.eurprd04.prod.outlook.com
 (2603:10a6:20b:484:cafe::a3) by AS9PR06CA0768.outlook.office365.com
 (2603:10a6:20b:484::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:56:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA2.mail.protection.outlook.com (10.167.16.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:56:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fu6771KxHxjLH9rmN3QywFm/8wS1n6nia7Tx7R2VwsFjHENflNX/xaAzOQRU0wAIv0qipsj2oFUlAmquO7Q+FlGWKc9lzYtvmft+efUio4slnFHrk8blyZ9zQg7beZS0enJ6qcJn+kHUOZ5mULx/yZY5RRLPwoA7bXnc+HdDud0aszBUiHpGOKlK9nVqyAe5G9rWtdn2H5cF8COzROpOKzRfRAjrmFDx8NqtsBHDAnFCrPc/nNptjqs1DXoTY4vzqU5WJc62qtnGbCN1YmH7BaRQNGIf8UWK2QzxUGal3LwASDtDoE7RBRiX5PcUZoEgC90W2VQLudsBL8NNzLNK/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmdmevIXm/7mffxgGo316uC3Nh9SSZQqQrxWwIUvqO0=;
 b=klxu6M33TTJfIO6GaoyIeLZii0txDsWoYP3iOo1BLZTLg1e8LEjLVV7TNrJQVjF6P6vQIZByO4WjHJjuPMM6EBKM/N4YTcWxU7QJDCZ41sZLuWJEyuJAKDopzqMkFQGds+zYASRLsSt4+H/jcQ751Xn5OOHyjEhBIhUD8z4YrI7xuSD+emvCRKeAcs4yak4XvdS0CqCE+ITAc+1W/KhmOUHG9DJfp8GzJA3ZR+3097zKd4Cob9uwzQ6SSZX9nLajMTFAjpoOOC0zNxAWE4mR3hEh/oZPGS0AEVDG7/JXcjDHHtq0p6U9xw6jPqO0p2MrpmFqrGsVtiXIKyshtTAcmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmdmevIXm/7mffxgGo316uC3Nh9SSZQqQrxWwIUvqO0=;
 b=X7VxPi/PBcZoqGkvFRGkPj9LPXVsbwiuOOiqG+/2x02qi5Dz+W2sCTUTRXVNpKg2cXr+zVhQzXPQyYURizI7e3nu5nmmAppof1VkM9RA8ewTfvjCMtENWftjGg5/oEynVBnSzwz+qoSPkh7wcpC6EI4EsrMOEz6YjDyBDcGZ0A4=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:56:08 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:56:08 +0000
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
Subject: [PATCH v6 43/49] KVM: selftests: Add VGICv5 IST attribute tests
Thread-Topic: [PATCH v6 43/49] KVM: selftests: Add VGICv5 IST attribute tests
Thread-Index: AQHdPGRfvG7zPEFrxU+VUhsmxMV+HQ==
Date: Fri, 4 Sep 2026 11:56:08 +0000
Message-ID: <20260904113404.4051341-44-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|AM3PEPF00009BA2:EE_|AS8PR08MB8246:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b70b4ad-8c33-45f9-96d1-08df0a7b950c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 3xXVCrv5Cu41Zb83ZRDTFCb4JFZ5JhfmqiJwMRTdM8MikYy/c8Vk10E6Kgmyk1/KWpbHi9UNceK4q6/JHTGf4stl5pxwTvG0+bWlEOKjzDRTwfrMEW3SqEWoz6NzxxA0HloUV17l+H5pEnddgyOhNTU52IkeqDciLcsaD+hG98Ducq5/3+EZpAUeO+9jRsn5exi0LQ4OkzXZncPKBhbSeeP65Rvs6LFmRHNmdU02cn003IRukyB/Q7oQYYZkAOW5e/XpfEeCzoyJltWGlTt4MpGlrSjZ5eQ2sOLD8XvUkIdhMSE3FLsuzDznuO827IXyQmwlkDnRNwrp/pXTo8vM345JShSbymliimdzP5uIPlJU8BiivJPbKsWN+Va4XQE3vDIXa3EuYgv7a2S2WHlUJXw2QYbBzBmUAThQ8vCOpb4sHrJuc1KFh5jSc7i1O6wH/KxkuKQOJh4DeKoN8kFZWLYs1eOaArKzrNud6WeiyYfP6sXbfx4UBBswyminTAvFMBKZs9yngtvtGZAh1KtT3soFijy2VB1BLrdzywH7hnwLF5VK1CRUMIRpH2/FMA9IBNJ922T8X72Uv/q8YNdvqa1VmH+DTZ804+n98QA8Uitl/GXrQcBorFNqZw2X1RF9lLaAGT3COkbWC1M8ANZWKEaqZL32ZL1Bat2g5gpZacyh9iYr+WwrdA8qanS/8AnFk1+YuPDP2UKZcZg8JYxIQvEO8N+bAYsOt4Cuckc7nhQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WypGllx2IWyh/xWkTpi7SyMavBsbDQ8RIY0zaM91keYnhW+O4Ui58fGLQcJxBDKYh6D9oHq2GqcpTYnWREn8PW1af0UrMfMNCrESFirjAbPL7HKiTDZdA4gk2XKQHxID4DyrIKkqOQ0oburuLbkWmE+QSUm71r1KcC6LUTwv1dpsKnykmDjzZ+YvOQZC5GxmO5d8WWF7J66+sjwz7kvYkoNZI1u16U6l7PhkSliChV9+Mqd0VBmaYFzpgOfBdGkPawaSA6qmBOBvv7fylfYtXF0epb6oJVCBU3ZrD2sCUYKmandofNJi7rfXAu0F+kVSSczPYwyoqTSg/68/zy6w7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e19e5af2-fb62-4060-8b3e-08df0a7b81a3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700016|23010399003|376014|1800799024|82310400026|10067099003|11063799006|56012099006|22082099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IkqsQcn5A4mhIAwp1O7/QDm07N3ymWCDnIeo4qNjF8As1GLPCWeQ5/vu+9MGyU4OCBOzNkJt808DApAuyoz07imPF1Syq6hwQ2KNWuyuHQt/GgcGZmhWfh85Jhyv/dJwjkN4rOpvJMs8ob1KV9jQ7wGVqVxJon/z/GNbg5IpY+1m3IlB05JkwrbUznD2NDafSzldmT5/ZAloF3TxSvzUOHduM5H06m8Iuoc+i8Pl4oqmK+JQec+8GR/Joo+c6/CQiALA5tqQvnGyHGgcOVuWthdiy7YIRqhR8lYnp1KGgxpa6bx3hDPKjSt7W/FMhu/VawIZT9TRTp6lJNwLxCkubXHnSCWbKIfTxhZJpX5C8O+Vp15LzhvRmuJrfNetZ9t4HxNQTqAkJD+bO/HL96lYdnWT+WCJEfX0C9Kz1Rl3//ElkwjJFJq7rFTwzxFa7Yf7ApBtwP8NXeBj20mXjqRx1xndt3uPNWXgYhNpZmeoAgkQl6XM/98npoGK0P7CaEXDxKRZf4lutMXQxYVipimrUsVOwymz4Sy4vTHjQ9mWQSDNqI5b0KbaMP95fDGTqVAHaKUsPg9Gm+yyN96HOdeWwLuxcAdiS0zD9HjpMNEbj9eLfSkom4rdgT/EQm7VWE88VwyeAe/kG+QYp4FiF4Mn9r/wxCdaRj5gkUZ9hxiNCyw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VEezp7BKnGXHEyHjlWN44fsDTznAS0k61sqpLk3/8yOjq1mFbZiJse7Gh5dYUy6Yk+digmxZh4ohLbunczAyzcoq72wjvAArTXwxnouJV6WREHIqb0R/RERFP1uujvjNAsHyPYavbqq8ihqTB5rRz07e5ZQMb3cubaa1IPZDXolSonL6Xxp852tzMfG3bXZ3zlsn9xF135Nnnv8TKTHENX+5Pvpn72EfrfnCZ4ijWBYqAKwwA7fEQfEXp+9Uc4FkAUrd4sw4d57sWhfB2VIQtxPEg1iBvugDlPtINM63BwAH4U5VGDVaqzoPYcth+hmFmgRyNEn4TdCamUVAIUS8WhoqCNfbY3IHTar6lHUi8ekSSJ0MhXSiOsuu9ImMUAW1dwJLVdEz8HTCMJ+QxgQiR32lXbRvucL7zjP7SUec1qxO82RrLmDYemX7u9bItLrP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:56:40.6819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b70b4ad-8c33-45f9-96d1-08df0a7b950c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA2.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8246

Add API coverage for the VGICv5 IST attribute group. This does not
test that IST save/restore preserves interrupt state; it only checks
the attribute plumbing and the cases KVM must reject before the
end-to-end restore path can rely on the interface.

Verify that KVM reports the IST attribute group, rejects unknown
attributes, rejects save/restore before initialization, rejects bad
userspace pointers, and rejects IST restore after the VM has run.

Also cover the userspace IST descriptor validation: a VM with SPIs
must provide a SPI IST buffer of the expected size, and LPI storage
must not be supplied when no LPI IST is configured.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 131 ++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 1166766dc7c97..a50775da43457 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -31,6 +31,17 @@ struct vm_gic {
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
=20
+static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_s=
ize,
+					       void *lpi_ist, size_t lpi_size)
+{
+	return (struct kvm_vgic_v5_ist) {
+		.spi_ist_addr =3D (uintptr_t)spi_ist,
+		.spi_ist_size =3D spi_size,
+		.lpi_ist_addr =3D (uintptr_t)lpi_ist,
+		.lpi_ist_size =3D lpi_size,
+	};
+}
+
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -527,6 +538,123 @@ static void test_vgic_v5_irs_regs_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_ist_attrs(void)
+{
+	struct kvm_vgic_v5_ist ist_attr;
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u32 spi_ist[VGIC_V5_DEFAULT_NR_SPIS];
+	u64 attr;
+	int ret;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST, 0);
+
+	/* Check non-existing attribute */
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST, 1);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IST accepted bad attr");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    1, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IST get accepted bad attr")=
;
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    1, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IST set accepted bad attr")=
;
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
+	/* IST save/restore is not accessible before the VGIC is initialized. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IST get before init");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IST set before init");
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* A VM with SPIs must provide a userspace IST descriptor. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted NULL desc=
riptor");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST set accepted NULL desc=
riptor");
+
+	/* Check bad userspace IST descriptors. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, (void *)1);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IST get with bad descripto=
r");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, (void *)1);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IST set with bad descripto=
r");
+
+	/* Check missing and incorrectly sized SPI IST buffers. */
+	ist_attr =3D vgic_v5_ist_attr(NULL, 0, NULL, 0);
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted missing S=
PI buffer");
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST set accepted missing S=
PI buffer");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist) - sizeof(__u32),
+					 NULL, 0);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST set accepted bad SPI s=
ize");
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted bad SPI s=
ize");
+
+	/* LPI storage must be absent when no LPI IST is configured. */
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), spi_ist,
+					 sizeof(__u32));
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST get accepted unexpecte=
d LPI buffer");
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST set accepted unexpecte=
d LPI buffer");
+
+	vm_gic_destroy(&v);
+
+	/* IST restore is rejected after the VM has run. */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, guest_code);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	ret =3D run_vcpu(vcpu);
+	TEST_ASSERT(!ret, "Failed to run GICv5 VM before IST restore test");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IST restore after run");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -649,6 +777,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 IRS_REGS attrs\n");
 	test_vgic_v5_irs_regs_attrs();
=20
+	pr_info("Test VGICv5 IST attrs\n");
+	test_vgic_v5_ist_attrs();
+
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
