Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010060.outbound.protection.outlook.com [52.101.69.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21CF2B2D7;
	Fri,  4 Sep 2026 09:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512672; cv=fail; b=fUQ2kjzyuD8f/+XJYIUBGFHvQZmLAxqSK9ovbOnepEfYr5ZI+O1cHt5BRR505ddJf1YW3sAPodJwAcgLmbga7FL9cXxq8iX3ASwAHxZ1HFXoaacxpsoILRuFo5UIYuEUy9DTbFuSm24gI0NqQI9KZQ8MHPO0oz3bniUYS4qIPmA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512672; c=relaxed/simple;
	bh=VfuaNxNG2uI60QLLwQF4l7tyqP7G7LoTfE90Udke9lg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gaw7KzRXWGQkNIYdCS/zd990wYk2Q609A8yHY+ifjjsOVEAra3+A/U0LCY9rLagQzpNAvwlMiMPM0h9QYmde7CTGe1P3oL9GWOnJKdxaZJM6sCxSBD1YUjGad52LkSWEfgpSOxGuuEwqp4k5087yE6xWKmWnaiFBKSQtNCb+8PQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UKxmkgtn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UKxmkgtn; arc=fail smtp.client-ip=52.101.69.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UKxmkgtn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UKxmkgtn"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=au/PviJMrTSS91iTNOWd2T/HE+YaGkhG8F4lrIKln+zRc8faGRofz434mSMSOy1ph0rWqNLX406TATKxRLPlPpspHBkNGFCKuGy3n0FGMhB0czlTRqAcqAbtCKzOhEhYjZdIGlfpa5odyigci9aQysM6ogcNvYd/Oo6L1zdKT+SqM3DKtOX3WDELFjRg2uRrcLE6Ax3GdJzQM0Uyzsx/Sc1Xqwsv9dhHT0Dd/3FAhdCPh5QkKlMwBHxYIEtRYxowphLAfVKtpEnFT5Usz7uKR7mU4YW588tChisVjErZXUyK+XySvtlUsxZAUlRnTWoP6B96PdhItRgZYGqudaLVdA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfuaNxNG2uI60QLLwQF4l7tyqP7G7LoTfE90Udke9lg=;
 b=eTsCfMdg7s2DUcpniHdnqliV5Eqk04K0urFDdS2zodkdfe+wlL4IKhURkjj2YYnFuFT2Qscfq9axkZjkvTcndJsC0B56/jo3KCJmkhpXkKVijN0HKZtADg8FAvmHTxe324ED+q8qSx7fSx4UvA5J2EQpJisrH6Z9/uurLeg/za7z63lEKgvzLe8HsxtHRqN99/5vVoos67d+F8rSzOYkScFsvZL9Q4AM3R4OllPKejVc1RnKrcrxjAI2w5TR3upzV41HHwU+urIQ5u1jTftYM0csMLh6dqjfI7xmFIwz7dOFj9OBN2lp65YPZV9OADplogLwheLIwfN0agcm1Hpj5Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfuaNxNG2uI60QLLwQF4l7tyqP7G7LoTfE90Udke9lg=;
 b=UKxmkgtndpHFTGR0tHS1MSXw6DxSDdfvvTafYaS4pXXAfk9TgEX2UTChufhvR/8wi9jZSj8o0v/MGWHZvfPFBuKFc7xD/Yrmhg42xLhHkFEKmzbTFYq6KwWdZAUoqLQBkIplidjGhCGWRwkoRry96MzfFY7X7f1x8XO2Uk9q0MA=
Received: from DB9PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:10:1da::29)
 by GV2PR08MB11899.eurprd08.prod.outlook.com (2603:10a6:150:343::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:04:23 +0000
Received: from DB1PEPF000509F9.eurprd02.prod.outlook.com
 (2603:10a6:10:1da:cafe::69) by DB9PR05CA0024.outlook.office365.com
 (2603:10a6:10:1da::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 09:04:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F9.mail.protection.outlook.com (10.167.242.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 09:04:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mcBaUHJGa5vv7mYlT3KH9CZM4SjuQGzFIgBHhWL0aSnsZpFZ95v+XFt2jK2nWL5s/fSGRGWg05OIIwJ3IukEwu84jkAiMDgIKNUfQzH9fJm3Z0L6oR5AXdsmqjOP5k4E76+K3jFQ7sN8a/tQ/L+vjDoGIgIsLRyZpLRy+ZAN2PL0KrYne85Y0m9IDDnyrXi3AUTExQYtUfRFD0hxTVULktM0MBeNGsFVVmE/lbAa3sHdwun739AwZpmbljn7Rw56lmeTgrW9H4tLHuvDXTR4fgerRms4iRmcRsDuX6cx+9iqfcHKLVDIlIqW3X06LRAwcO84X0p1lTU39G30fDdKIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfuaNxNG2uI60QLLwQF4l7tyqP7G7LoTfE90Udke9lg=;
 b=Y2ZMlTzsKwACnX0fNvHPcR8h86OLFm4+yFqUkX+D20v+Z1HgxXFmQyWdW2cMwo7lR02jK8mHr5aIVD+388aPbmpz23KLeJAomaMZGHbl+EIIWmSEJ6EUaXXfFtlDdvYAT9Wz4gMhj0wR2gIeDX5gru1yUOveewuVzXN3AD4gMlj3sbK659FpfzlA4AZdrjMVk6vNIACAyyt+3VZaRCnMLZT1JWrGzh1i9JYFjwT6O4pejAwHPWW/HzKYSuyGLaYQuIr3G+mBmN7AHFMFbzr8sgesH3i1YXZGrUQ2w1K9TU+faROqpja517wqWJ6krDpj3IN3+PvlMLteqWYdsfx2aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfuaNxNG2uI60QLLwQF4l7tyqP7G7LoTfE90Udke9lg=;
 b=UKxmkgtndpHFTGR0tHS1MSXw6DxSDdfvvTafYaS4pXXAfk9TgEX2UTChufhvR/8wi9jZSj8o0v/MGWHZvfPFBuKFc7xD/Yrmhg42xLhHkFEKmzbTFYq6KwWdZAUoqLQBkIplidjGhCGWRwkoRry96MzfFY7X7f1x8XO2Uk9q0MA=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI0PR08MB10629.eurprd08.prod.outlook.com (2603:10a6:800:20b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:03:48 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 09:03:48 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 24/49] KVM: arm64: selftests: Update vGICv5 selftest to
 set IRS address
Thread-Topic: [PATCH v5 24/49] KVM: arm64: selftests: Update vGICv5 selftest
 to set IRS address
Thread-Index: AQHdJl9bI5CcPYzil02d3zJ5lxXw8raSr00AgCuciQA=
Date: Fri, 4 Sep 2026 09:03:47 +0000
Message-ID: <16e23b87d597370c35c1c50d6938cb14fb25a2d1.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-25-sascha.bischoff@arm.com>
	 <20260807150421.261E51F00A3E@smtp.kernel.org>
In-Reply-To: <20260807150421.261E51F00A3E@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|VI0PR08MB10629:EE_|DB1PEPF000509F9:EE_|GV2PR08MB11899:EE_
X-MS-Office365-Filtering-Correlation-Id: c31684fd-8e27-46be-8c03-08df0a6383af
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|38070700021|11063799006|56012099006|10067099003|4143699003|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 LFAlko+cdq/7Z8emP/1a+mK835GPZj1ak5luEMplVrLHSU8ajF0PiOLa09wNroiRvRXwlqoBdQolQ3idXlF/gSoExBBBFmkmtLrxuSJp6mVrv5AUf+8e2BmKWj0iYOtWKEvNP3yUJRGhGAKMpyzY2hWBjtw/TAZPqFGoPVR0gNZXIDKswuLjv/VoI2GaygLuJ813gNlExqh1vHrSI/K86qpF+H2JITlkh77lE/icK+Foa5Rq4UngFJ4XtC2V5fqvSXs1QwTpHsdLdfRPvIvEtyAIMcGAohBTpQavWTbbtiLuY6PuMpkU5T43q0IRgQUPcwu/aCj6e9xWc/3Ffi4/8K00e0xD+r973LnZk5B2sQijMur+juHeMS4++erLno+UcyEp2ihMWMpjOwjKnLSYwPNO52p7s6zJvsc7tKxuIh3lbNwiD1YJwzWioQnEjJmWM5tmkifD/8U7ffRGkv2LX9SMcHc4zzL4Zp2BmYgCJVNfBDKSsq1vGeeIIfvKLz94HQ3ObY+KS0kGqV2oVD0W38/b1cy6uMsHg2HsyvJdnr9VW9djxfueLeL45AogVWCjIift08xDaopyHqdIFZ/YJcX4XzcHujlNNOEVw6K/5KjVcimi5mfeLqJgoGvRToq4k8UBwMHw//9k0k571TKK4Fa+bbWI+4RJTH6JgdrTHO86Hyfn0kfS5D9dxnmrkIqMY2QK2tgqEmhW5WBo+MfxgxLD0AXzmq5XiuGb/lx0+Q4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(38070700021)(11063799006)(56012099006)(10067099003)(4143699003)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <31F34447DE5F5F43AAEC219B7468F2E2@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 yTUzwaGwTLFgkuOXFbvstVf8NQh3cHmn6MxbJsqey1irvRm3ugL5Y2sPkeN9gWJmcmQ2M/82hiVciiEySoWfdW8DlxW5zMDCOxSn2cW5RjZKJKCoCePO6+iN9lmFqcg6iuSOTxHUCw4DAw5s06HFPL1HJoYvl3uriAgUcxpDzLHmAraC/QX6xgt6tMvuNDYJ9vLRTYV/gi1rhhfJAn2WFuGNVJSy7nLbbZoiCkPC/2TkxedzCksb08o5bYU/hQJ8XTgbhcxTI20t/Kzhayo4klkrZ8WUizlAEQDKKttstkRE0PPezbtl0xdQU3Q78DM32MwTxPBENNGV6w+osbh1Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10629
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6a7093cb-5144-467c-92fa-08df0a636e62
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|35042699022|82310400026|36860700016|14060799003|376014|1800799024|6133799003|18002099003|22082099003|56012099006|3023799007|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	MgLpwk1CwoGwxJkM8MFguzZybwMODvIvpy3o8+qRJdate1uXN/bugq/ykIqHPUHo3sd+ZA1TKqFJAgaEu1W1mOX1x6kwCgLcqYxAXx0gzIrNNQC9MbhWwhWmCasNS39NtwScPzEElAP85D/0We0Zs/HjKKxy25hITUOzp1RIX1p/J0u20LugMwCqa9DXQPj2xwatrPXGRvO3y1QXQPoToc3NKF2mpE53GkiezfhniPfszLm91F9Pz4YDx23KhT5lrTQuLdPUXc2NMy1rSVyMJRx5EF/UAcOXgN25/diHBqCHb/XfzsAJcTg0fD7Yq5TytZXX9/P1iAhlqpe7NQhz4BX1dzV6m3dXLk0gloQWgprLEWQug8S+eKvOdsplhdzAOpHXd7rzWYtr/CxETAMpLPQCyb8rOV88WX6qGF8m9CH81z4Lu2o06YVd4xFiJsKQMm89+GvnNONFI9pfHPk3SABWeys5OMIA9MCf0EU5tCHQa6gx1rrWgl4Vu4qdEshAoThQwzOImu2PihUhKLymSpegNuIHvnN3r0Nb53mMqQsAKpAEd+6WtJwHEpzzFeqkQIRgOpvEYfd6B/GMK6z0X2DHd+VAS3are68id6NNqcpiOYASRYDb3MuNM/aiGPB5IFgcHrhz7UFm5X+RNc33XxRQzJlJjCtzjAfwcIJiiKs=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(35042699022)(82310400026)(36860700016)(14060799003)(376014)(1800799024)(6133799003)(18002099003)(22082099003)(56012099006)(3023799007)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5wEzvF6IQ0m5Er/s5uAXbkc1m3ss4T7xHmkHWG2kX0S/NRwlHw9SyxFiRUlfixBK+C+IkalQ+4GD15q81IuFDlKhszG8UmdXqnagWlMRmye2HSqMdSYFDf5idAzms0vyJwa4PfU6Suwr95HrO19RtVVXqXxbecOzofeCltVpZXNqXdqN0WO2L3+IczfhtQBWxol6v/g6asp5QO4G7FFx+ANYq2faHZGpBm7ZfSYE3xQ40mQOrSaFhnvzpAG/g9RYXPLohQTwZS/ioCa9zhkwOmnQtaXjVFaQ4pOYMP7Vqm7KwGdEOTbxm0xTx7t7YenideDTaPFBhUlcr96ZkN3AUQuZt5ZUG4WWrbAmDzvBEqW/3yFUPlFja6HUASQU9zQVYjLwL+KqlCdY2+b5hSubCI8pNe/6y++dLANXuSU15EFOrD02y2KzckwfnxGF0AQs
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 09:04:23.6245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c31684fd-8e27-46be-8c03-08df0a6383af
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F9.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11899

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE1OjA0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBUaGUgc2VsZnRlc3QgdW5jb25kaXRpb25hbGx5IHNldHMgdGhlIG5ld2x5IGludHJvZHVj
ZWQNCj4gYEtWTV9WR0lDX1Y1X0FERFJfVFlQRV9JUlNgIGRldmljZSBhdHRyaWJ1dGUsIHdoaWNo
IHdpbGwgYXNzZXJ0IGFuZA0KPiBmYWlsIG9uIG9sZGVyIGtlcm5lbHMgdGhhdCBzdXBwb3J0IEdJ
Q3Y1IGJ1dCBsYWNrIHRoaXMgbmV3IFVBUEkuDQo+IC0tDQo+IA0KPiAtLS0gUGF0Y2ggWzI0XTog
W1BBVENIIHY1IDI0LzQ5XSBLVk06IGFybTY0OiBzZWxmdGVzdHM6IFVwZGF0ZSB2R0lDdjUNCj4g
c2VsZnRlc3QgdG8gc2V0IElSUyBhZGRyZXNzIC0tLQ0KPiBjb21taXQgZWEyNmM1YzE2OTc1M2Q4
ZWU3OTM2MjY1ZGQzZGQ1Njg2NGE5NjgxNw0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2Fz
Y2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLVk06IGFybTY0OiBzZWxmdGVzdHM6IFVwZGF0
ZSB2R0lDdjUgc2VsZnRlc3QgdG8gc2V0IElSUyBhZGRyZXNzDQo+IA0KPiBUaGlzIGNvbW1pdCB1
cGRhdGVzIHRoZSB2R0lDdjUgc2VsZnRlc3QgdG8gY29uZmlndXJlIHRoZSBJUlMgYWRkcmVzcw0K
PiBiZWZvcmUgaW5pdGlhbGl6aW5nIHRoZSBWR0lDLiBTZXR0aW5nIHRoaXMgYWRkcmVzcyBpcyBu
b3cgbWFuZGF0b3J5DQo+IGZvcg0KPiBydW5uaW5nIGEgR0lDdjUgVk0sIGFzIHJlc291cmNlcyBj
YW5ub3QgYmUgbWFwcGVkIHdpdGhvdXQgaXQuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYXJtNjQvdmdpY192NS5jDQo+ID4gYi90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9rdm0vYXJtNjQvdmdpY192NS5jDQo+ID4gLS0tIGEvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiA+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2t2bS9hcm02NC92Z2ljX3Y1LmMNCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gQEAgLTEx
Niw2ICsxMTcsMTEgQEAgc3RhdGljIHZvaWQgdGVzdF92Z2ljX3Y1X3BwaXModTMyDQo+ID4gZ2lj
X2Rldl90eXBlKQ0KPiA+IMKgCWZvciAoaSA9IDA7IGkgPCBOUl9WQ1BVUzsgaSsrKQ0KPiA+IMKg
CQl2Y3B1X2luaXRfZGVzY3JpcHRvcl90YWJsZXModmNwdXNbaV0pOw0KPiA+IMKgDQo+ID4gKwkv
KiBTZXQgdGhlIGFkZHJlc3Mgb2YgdGhlIElSUyBiZWZvcmUgaW5pdGlhbGlzaW5nIHRoZSBHSUMN
Cj4gPiAqLw0KPiA+ICsJYXR0ciA9IEdJQ1Y1X0lSU19DT05GSUdfQkFTRV9HUEE7DQo+ID4gKwlr
dm1fZGV2aWNlX2F0dHJfc2V0KHYuZ2ljX2ZkLCBLVk1fREVWX0FSTV9WR0lDX0dSUF9BRERSLA0K
PiA+ICsJCQnCoMKgwqAgS1ZNX1ZHSUNfVjVfQUREUl9UWVBFX0lSUywgJmF0dHIpOw0KPiANCj4g
W1NldmVyaXR5OiBNZWRpdW1dDQo+IFdpbGwgdGhpcyBjYXVzZSB0aGUgc2VsZnRlc3QgdG8gZmFp
bCB3aGVuIHJ1biBhZ2FpbnN0IG9sZGVyIGtlcm5lbHMNCj4gdGhhdA0KPiBzdXBwb3J0IEdJQ3Y1
IGJ1dCBsYWNrIHRoZSBuZXcgS1ZNX1ZHSUNfVjVfQUREUl9UWVBFX0lSUyBhdHRyaWJ1dGU/DQoN
Clllcy4gVGhhdCdzIHRvIGJlIGV4cGVjdGVkLiBXaXRoIG9sZGVyIGtlcm5lbHMsIHRoaXMgVUFQ
SSBkaWRuJ3QgZXhpc3QuDQpXaXRoIG5ldyBvbmVzLCBpdCBpcyBtYW5kYXRvcnkuIFdlIGNhbid0
IGhhdmUgYSBtZWFuaW5nZnVsIFZNIHdpdGgNCkdJQ3Y1IHRoYXQgZG9lc24ndCBoYXZlIGFuIElS
Uy4gVGhlIElSUyBpcyByZXF1aXJlZCBzdWNoIHRoYXQgd2UgaGF2ZQ0Kc3VwcG9ydCBmb3IgbW9y
ZSB0aGFuIG9uZSB2Q1BVLCBTUElzLCBhbmQgTFBJcy4gVGhlcmVmb3JlLCB3ZSBtYW5kYXRlDQpp
dCBoZW5jZWZvcnRoLg0KDQo+IA0KPiBCZWNhdXNlIGt2bV9kZXZpY2VfYXR0cl9zZXQoKSBhc3Nl
cnRzIG9uIGZhaWx1cmUsIHJ1bm5pbmcgdGhpcyB0ZXN0DQo+IGFnYWluc3QNCj4gYW4gb2xkZXIg
a2VybmVsIG1pZ2h0IGFib3J0IHRoZSB0ZXN0IHN1aXRlIGVudGlyZWx5IHJhdGhlciB0aGFuDQo+
IGdyYWNlZnVsbHkNCj4gc2tpcHBpbmcgaXQuDQo+IA0KPiBTaG91bGQgdGhpcyBjb2RlIHVzZSBf
X2t2bV9oYXNfZGV2aWNlX2F0dHIoKSB0byBjaGVjayBmb3IgdGhlDQo+IHByZXNlbmNlIG9mDQo+
IEtWTV9WR0lDX1Y1X0FERFJfVFlQRV9JUlMgYmVmb3JlIHNldHRpbmcgaXQsIG9yIGdyYWNlZnVs
bHkgaGFuZGxlIHRoZQ0KPiBlcnJvcg0KPiBpZiBpdCBpcyBtaXNzaW5nPw0KPiANCj4gPiDCoAlr
dm1fZGV2aWNlX2F0dHJfc2V0KHYuZ2ljX2ZkLCBLVk1fREVWX0FSTV9WR0lDX0dSUF9DVFJMLA0K
PiA+IMKgCQkJwqDCoMKgIEtWTV9ERVZfQVJNX1ZHSUNfQ1RSTF9JTklULCBOVUxMKTsNCj4gDQoN
CldlIGRvbid0IHdhbnQgdG8gYWxsb3cgaXQgdG8gYmUgb21pdHRlZCBvbmNlIHRoaXMgc2VyaWVz
IGlzIG1lcmdlZCwgc28NCnRoaXMgaXMgaW50ZW50aW9uYWwuDQoNClRoYW5rcywNClNhc2NoYQ0K
