Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013015.outbound.protection.outlook.com [52.101.83.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51E433EC
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095005; cv=fail; b=IKDjwIfcDYZJfsIciM/ME/8gPUoMuVgz91XnbthmfqIn5Pad/YRxswWRPq2vJv017mBhVO6cM7XGM91xuzq6pyB1eGcGlgpMVHMIrTAHdAVzcrnr6/pywU7mGuHWf4B/M+rl5EmWt3ptBCwgh0X9m02TsZhJ0ifc3OA3cRdBtaQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095005; c=relaxed/simple;
	bh=bSDurkH6qM0IOCvwsmbNQg/P+QkvSy6rQT93Fjz5OHw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M0R+VinFJ47g62ymTiLw1wuBAtposOmU6JnkPlUPckFmR1kCXo1k2hU7rFA4sndfVpSAIwGP0SYwNhM+M/mTSCXUL1NQWqDhMPyNTqtlGSNmecFcsAeq38qmMXQA/6khT5X4gTDTtQJTz6yl2+ME+IDf77AOlI2js5KAnW27H68=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VBfT2pAQ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VBfT2pAQ; arc=fail smtp.client-ip=52.101.83.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VBfT2pAQ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VBfT2pAQ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yTZzoxu5elicKEmrP/Zdha7JKY0WG3eCPn8JOrpHJt1gau+14PedTPMaQT1DVgb4AcQ2+1NylbYpdbHjscJhkltFz+8Qkvj/DjZQBZHv2627ZOmrhmK0A1jCSIUtEv0jd3ycCWFa1ylMEJUbAtqBPOg9Oz5FWvRYpa/8Obb7LAVM4Z7ie3SzG+zlQucc02vK87lL4+50rEiX2ZRq07Cfzfx5ebuoTZwNyWuZXJt1X5s2hwjhbkOsKba2X8YTfobVb5iIYoiWIn20xKWW26qZ809Hcou5wzTlcGOC8PRmWDrtcPFcgn87jRrVbkaBZL8yRkwgpEYVqIZGG+t3tRp8RQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NrIwRL9ivnOQ8PxDVqDaVjOGNVO//DEgSas9qLMqGU=;
 b=Le78COBETquZhOUuu5dPxUu0eCaXbR36mBWuZHYslrFF3Rj1xQYy1bpnGu530aTvJmI5vNGk3h66pT40kJsyzheQNkEs8NhXFf015OJVZGwnLeNQlSyYrdHpjD+evr6klFZKKlbhk55jnpz5cFQM3kg66RJQRvJTkyWqzAA3xLGvbTG+AuWGoPe1X9AHmpnEf+q5i9MURjYA2hGPsRV7UYj2b3LBMwuPXEYufsrxQIH6jJea04C7C0SZvVtUKqX2u0qYNAYpwKGvjchA9rPtXOFzLMPglM8w4tq8YBLw9IPvzIcczFSddBWRLpSGnsrXpKov7odGwwXmLZgZJM5Ktw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NrIwRL9ivnOQ8PxDVqDaVjOGNVO//DEgSas9qLMqGU=;
 b=VBfT2pAQzpc3rokNXyFNs9gI4cg/F2An6UBkJzcdxdE8Nomu+cQvY0s5ASGFsbVJzCTUdgYI26FZwjw0Ax0mMFsiM7/yw1Cc9GnqCQ+/SrQMueu3IVF6uXraLXys+QyBdc+ZKDpvwmY84yr2XyGHPRDQQin5r68d63OOmBj69vI=
Received: from DUZPR01CA0166.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::9) by PA4PR08MB6253.eurprd08.prod.outlook.com
 (2603:10a6:102:e4::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:09:55 +0000
Received: from DU2PEPF00028D04.eurprd03.prod.outlook.com
 (2603:10a6:10:4b3:cafe::23) by DUZPR01CA0166.outlook.office365.com
 (2603:10a6:10:4b3::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:09:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D04.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:09:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzIc9S5FvBLnPSJVZQcxr/RCQIpmgTCzLqpQds/vmKvJOBgKZ+R79AExu8UaOh2Rpr265uIoAXXdSEYlmJ7bxztUAetxgKabgqn8szKxIq3KE1AHLvwsPH3gsN2Ng0ZMZS0/Zrr9WUMZRkm3NgSfekHIDOBJQnwlth4wGvhc+tktM0nk8oALdU+N5m+KKcnMMHZ5A28lwk3JigV/nEFE/YkDEYumfmhm8RsjNXiWmLHIJzrIFbUgFLYHPDUSLDKwH2Lqhp5AW/zTb/oT33kOALQjeuK70G6vndKFuDdIJZZMBAr2kYa0F1uD69vGc6INxIa8Q3+4Zc4R1FGC1PubNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NrIwRL9ivnOQ8PxDVqDaVjOGNVO//DEgSas9qLMqGU=;
 b=WcGZmE79bLu52H8qSHj+abYIqQ8PBcxrIvXHEwRjHdJnxnO+FzN1nOYeBlkqA2hPUf4JNSb41YGb17LGiJh/uDhZSo7lVkQgngMwtzdYmQwr2Bkxdjyhtr2LKn+Aoy1QJCaNqmwARF9DZIhxr5TGahOAYHeBmgxGG7SbH2syGM1GDAbAb9vTdkSMcFaMRb8ov3+2f7bzqovAQXJY/cYqewhzNKGBD+T5dFtkN5FyRu/zircIh6lvsBwGrn18Lb0YcDWUH4neKLpxJOBwKgrK59GkmdHUD/Kj7W5cT8ffq038HYXmfTrmNoUnidN44TYR7KMrov+zALGW73AfZwkzww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NrIwRL9ivnOQ8PxDVqDaVjOGNVO//DEgSas9qLMqGU=;
 b=VBfT2pAQzpc3rokNXyFNs9gI4cg/F2An6UBkJzcdxdE8Nomu+cQvY0s5ASGFsbVJzCTUdgYI26FZwjw0Ax0mMFsiM7/yw1Cc9GnqCQ+/SrQMueu3IVF6uXraLXys+QyBdc+ZKDpvwmY84yr2XyGHPRDQQin5r68d63OOmBj69vI=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:08:52 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:08:52 +0000
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
Subject: [PATCH v3 36/40] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Topic: [PATCH v3 36/40] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Index: AQHdCwY9RuzT3CHCBEOJ2vP6xGx16A==
Date: Fri, 3 Jul 2026 16:08:52 +0000
Message-ID: <20260703154811.3355680-37-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|DU2PEPF00028D04:EE_|PA4PR08MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: a1a754b7-6517-4049-08c7-08ded91d8596
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|3023799007|18002099003|22082099003|6133799003|56012099006|5023799004|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 6B/D5+zKDO89MKS5WnlAmwvhsIEvWa8yXrGWzK6ZUDsfJzQtdX0jgMXL4RWtaJAUrc9q38/QzSvBWHq6BEAJW+TiJYK13sj3obWzfPERvUJcsvi60sRiIqGLA0uC0XyX0GNgAQvjJpfeN2U/ZTNur+rz5TMH3rYNE8T2APGYBe4XFWIahY7NMTQEBDvl6sZfO6RkTBrfG/5E/xTAIEP3syIZ71x9qKM9vN8MMikK2G7R0/IeLl62Z+ESZyXnww2T5c6UMWzUB7hrQy9pjxPprbR4fok7R9IeI59TXUn7TfZyXpTlyR7zCoL9U3oXNAOOSIk6GLr61FhKKV+rsbbDeYS9jkVUqfa8qppfX6ryAs/OMazM5EOSx7a6AsVA3JEFGeABJqBE7csaYuJt3N3dG2vTMwilgVSNJehWz48SUo7jSFbCBlOBfeglaG8+e0GSBLklRXisH9byCeNDC4bjB2Xq5X5LUoDUE+JskN+b52pvM2UTVSY/LQO/D8O8FIW4QXfIFqBur1sa+nCNZIFY4mo09VYKehc50QLtnDmIy03FNlz9JwIXPWyGj2asx9QIBQ1mstzV9xXjwgsQBZmpT7OFlPJK7K0jxwzeI7PKAl7W98hpJQLzBTCzC4+c/UYfIp/j8AGnwUNqOSeTtd/DgrpobQGqXX8ejm/yPvBOW+5E7QMQU1WG064Jw4GZG+7kQhKqwW+J+2P8JItEx4RsdeLU9mUDD226641RfPKg7Yc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(3023799007)(18002099003)(22082099003)(6133799003)(56012099006)(5023799004)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 bsygLzKzP2ilI/tdtRYiwje8uT/W1Wh1cftWIzsnFICxH6PkWAV6vVmhkWzrLMPcWRy482RCuOnCl7wOt8Ogmrb+0VlXjjq1PjLS+J+C3CMi7gnRY7E2eJsd9zJ0+HywPQeJFGNFe9WbffpyniElDCbxwED35CiJ0UyXYyDkpdtLaDuoQWcbeNTKIQ8sOOM9ATbT+tVIs5OwwqNBUbod3Sg6fCICuGTzNfeFmBWZYhXukyZGkPAG8/9aOyN66dRqr/ifdHDy4rB1RkodNcyGW5rXG+zMGUxw+rTU//5aQb7S08IHvu/33cHPSkSVx8dDPIyc77zglNXJJ3AZoHKYtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D04.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	840bc3ae-ee99-453f-4fce-08ded91d603d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|35042699022|82310400026|23010399003|14060799003|376014|22082099003|18002099003|3023799007|6133799003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	VlcigG+eouRausOwpsHx7RkfZ5/uX4euFvOmEJe/PNM6z4IwtdaJbPYrmsnVdNjnmxIxYlDOPR3kTrZo6qkM8/dB5t+WUOnoV8Ezc3VulGxVly80Fp+acThxmWZcDdg0koHGjkYpGeucEjrUjxeMy4yChtcygE8PIInXm4wP0W6mferVyciliMH6emXPWGgmWpi4pqaJYl73q9aCKCpsO5bTQfOSJ/OXlwdVCZFatoGrGlzppqtw6tiqvnnV/88eZ6ZiyA1WKwml9dLP5ywN1R2hHuzzcmizm91fOdTlaBHYMv3YF+LxT/qtcGGN7v5YsbUuuCmeNi1uM+6PAmHykW14gfWDxjzlzOpY42+IVu7Iz5xPxotULGbobRxdchhOsDljuNeqzjMj55h1LL0a76xaBXi/AM6jG3gWK1HouWA5EEkrQafdO0UwEMMaiPydnYHnf9fy+fanyNHOLBH0JF+B9EDKhdgki7Nu/X6+HL4A5JH9GiCkWkjKt54O/bgLRuqdnUJnhX52ausroJfmRvfn5glt79r/PafmzBBgXdyBSsIAhMKw0NXI+gynKvkm8wFhtmnOaMKsPjRBgCcwj2gmdgCDxRxSGROnsSTbBDbyNxLL/aY1N2/0JMBd3+mSwSNUvyRUSPAA0waqUd1ejvFBteyhzQKml+bMjZdIbgvVuYa8V1Pv23emjDufHs9KZ0VLMvnEVdMqzUDntHzThw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(35042699022)(82310400026)(23010399003)(14060799003)(376014)(22082099003)(18002099003)(3023799007)(6133799003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3vp7q/v4bzoHmm9ogEup4EcJwHUpJTImtuHbBrwhL5FdCQsbinVl2kLRC0jJkB3EhFxBNQE0jRhHWI5E8ZXiaLTgoJnvuGSdzNKOaYvAhq5Ktib8S8vvKV119pxHbNT6N05FlyIMU5hnjwQi1tYqLkF5orLBgDRxfrXyca+2ixTxZXr/qKt9sJY/Jvp508qq1N+znUbZEC7HCtX7EMtiMo1LBQGThN19Do4vodFxCLVKKfE1LI8kfDCAoktAYeXamDF88x7lDnV748Uuf7pSOBsJwVqUFMfQCkEUvl7tTR+poHMgK+99CaPADyx+RexeYEXR9binoA8/ROtqXGQ5DfS6FDwG+I8RpgTFaljSWX05Ljd/pc2drJdU4F+LB43e8oBxDDacTTIhoeMq5zgCSrna2Gi+vl/UMDXNZdsz3pF+QpCBmLSagqP+4z45krIs
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:09:55.0564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a754b7-6517-4049-08c7-08ded91d8596
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D04.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6253

When running a GICv5 VM, there are up to two ISTs that must be saved
or restored when migrating a VM.

The SPI IST is allocated by the hypervisor, as the guest presumes the
memory for the SPI state is allocated by the hardware. The LPI IST, on
the other hand, is allocated by the guest in the event that it wishes
to use LPIs. We shadow the guest's LPI IST in KVM, and therefore the
guest's memory is never directly used by the GICv5 hardware. Hence, in
both cases, the in-use ISTs are allocated by the hypervisor.

As there is no guest-allocated memory for the SPI IST, the state of
this must be saved by the VMM. Therefore, the VMM must provide a
memory buffer large enough to store/restore the SPI IST (32-bits per
SPI).

The LPI IST, if present, is stored into guest memory as the guest has
already allocated storage under the assumption that it would be used
by the GIC. Each IST Entry is written back to guest memory (skipping
metadata sections) on a save, or restored from guest memory on a
restore. The guest is only allowed to create a linear IST, so there's
a sufficiently large region of memory that is contiguous in GPA space.

On a save, the VM itself is quiesced using IRS_SAVE_VMR - this ensures
that the hardware has written all interrupt state back to the
ISTs. Following the save operation, the IRS_SAVE_VM_STATUSR is checked
to ensure that the guest has remained quiescent. In the event that it
has not, an error is propagated back to the VMM such that it can retry
the save.

On restore, the VM is first made invalid - it is not allowed to write
to any of the tables while they are valid - and then the SPI and LPI
ISTs are restored (if required) before making the VM valid again. As
part of restoring the ISTs, any pending interrupts are tracked, and
IST pending state is cleared. Once the VM is made valid, these valid
interrupts are made pending again via the GIC VDPEND system
instruction.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       |   1 +
 arch/arm64/kvm/vgic/vgic-irs-v5.c       |  20 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c   |  13 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c    | 657 ++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h    |  12 +
 arch/arm64/kvm/vgic/vgic-v5.c           | 298 +++++++++++
 arch/arm64/kvm/vgic/vgic.h              |   3 +
 tools/arch/arm64/include/uapi/asm/kvm.h |   1 +
 8 files changed, 1005 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 710a0d267347d..1b9bbeab18a4e 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -423,6 +423,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 17be776b4a2b9..8f8a83a32bfa0 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -1027,6 +1027,26 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned i=
nt nr_spis)
 	return 0;
 }
=20
+int vgic_v5_irs_lpi_ist_id_bits(struct kvm *kvm, unsigned int *id_bits)
+{
+	struct vgic_v5_irs *irs =3D kvm->arch.vgic.vgic_v5_irs_data;
+
+	if (WARN_ON_ONCE(!irs))
+		return -ENXIO;
+
+	if (!irs->ist_baser.valid)
+		return 0;
+
+	if (!vgic_v5_ist_cfgr_valid(irs)) {
+		kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
+		return -EINVAL;
+	}
+
+	*id_bits =3D irs->ist_cfgr.lpi_id_bits;
+
+	return 1;
+}
+
 int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr)
 {
 	const struct vgic_register_region *region;
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index cab3d6db070ac..afea89b99411f 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -902,6 +902,11 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		if (attr->attr)
+			return -ENXIO;
+
+		return vgic_v5_irs_restore_ists(dev->kvm, attr);
 	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
 		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
@@ -930,6 +935,11 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		if (attr->attr)
+			return -ENXIO;
+
+		return vgic_v5_irs_save_ists(dev->kvm, attr);
 	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
 		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
@@ -979,6 +989,9 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		default:
 			return -ENXIO;
 		}
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		return attr->attr ? -ENXIO : 0;
 	default:
 		return -ENXIO;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index a3f817b82c44c..8ac48f6f587ff 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -59,6 +59,20 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VPED_ADDR_SHIFT		3ULL
 #define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
=20
+/* L2 Interrupt State Table Entry */
+#define GICV5_ISTL2E_PENDING		BIT(0)
+#define GICV5_ISTL2E_ACTIVE		BIT(1)
+#define GICV5_ISTL2E_HM			BIT(2)
+#define GICV5_ISTL2E_ENABLE		BIT(3)
+#define GICV5_ISTL2E_IRM		BIT(4)
+#define GICV5_ISTL2E_HWU		GENMASK(10, 9)
+#define GICV5_ISTL2E_PRIORITY		GENMASK(15, 11)
+#define GICV5_ISTL2E_IAFFID		GENMASK(31, 16)
+
+#define GICV5_ISTE_SIZE(istsz)		BIT((istsz) + 2)
+#define GICV5_LINEAR_IST_SIZE(id_bits, istsz)	\
+	(BIT(id_bits) * GICV5_ISTE_SIZE(istsz))
+
 /*
  * The LPI and SPI configuration is stored in the 2nd and 3rd 64-bit chunk=
s of
  * the VMTE (0-based). We call this a section here in an attempt to simpli=
fy the
@@ -67,6 +81,26 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VMTEL2_LPI_SECTION	2
 #define GICV5_VMTEL2_SPI_SECTION	3
=20
+struct vgic_v5_ist_desc {
+	struct vgic_v5_vm_info	*vmi;
+	void			*base;
+	unsigned int		id_bits;
+	unsigned int		istsz;
+	unsigned int		l2sz;
+	size_t			iste_size;
+	bool			present;
+};
+
+struct vgic_v5_two_level_ist_shape {
+	size_t	l1_entries;
+	size_t	l2_entries;
+};
+
+struct vgic_v5_pending_irq {
+	u32			irq;
+	struct list_head	next;
+};
+
 static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
 				    unsigned int id_bits,
 				    unsigned int istsz);
@@ -100,6 +134,22 @@ static void vgic_v5_clean_inval(void *va, size_t size)
 		dcache_clean_inval_poc(base, base + size);
 }
=20
+static void vgic_v5_drain_pending_irqs(struct kvm *kvm,
+				       struct vgic_v5_vm_info *vmi,
+				       bool reinject)
+{
+	struct vgic_v5_pending_irq *pirq, *tmp;
+
+	list_for_each_entry_safe(pirq, tmp, &vmi->pending_irqs, next) {
+		if (reinject)
+			kvm_call_hyp(__vgic_v5_vdpend, pirq->irq, true,
+				     vgic_v5_vm_id(kvm));
+
+		list_del(&pirq->next);
+		kfree(pirq);
+	}
+}
+
 /*
  * Create a linear VM Table. Directly using the number of entries supplied=
 as
  * the size of an L2 VMTE (32 bytes) guarantees that our allocation is ali=
gned per
@@ -446,6 +496,13 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	if (ret)
 		goto out_fail;
=20
+	/*
+	 * If we are restoring the state of a guest, we need to re-inject any
+	 * IRQs that were pending when the state of the guest was originally
+	 * saved. We use the pending_irqs list for this.
+	 */
+	INIT_LIST_HEAD(&vmi->pending_irqs);
+
 	/* Allocate and assign the VM Descriptor, if required. */
 	if (vmt_info->vmd_size !=3D 0) {
 		vmd =3D kzalloc(vmt_info->vmd_size, GFP_KERNEL);
@@ -550,6 +607,9 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	kfree(vmi->vpet_base);
 	kfree(vmi->vmd_base);
=20
+	/* Unlikely, but possible. Avoid leaking the memory. */
+	vgic_v5_drain_pending_irqs(kvm, vmi, false);
+
 	/* If we have an LPI IST, free it */
 	if (vmi->h_lpi_ist) {
 		ret =3D vgic_v5_lpi_ist_free(kvm);
@@ -1120,6 +1180,18 @@ static int vgic_v5_spi_ist_free(struct kvm *kvm)
 	return vgic_v5_linear_ist_free(kvm, true);
 }
=20
+int vgic_v5_lpi_ist_exists(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	return !!vmi->h_lpi_ist;
+}
+
 /*
  * Allocate an IST for LPIs.
  *
@@ -1196,3 +1268,588 @@ int vgic_v5_lpi_ist_free(struct kvm *kvm)
 	else
 		return vgic_v5_two_level_ist_free(kvm, false);
 }
+
+static struct vgic_v5_two_level_ist_shape
+vgic_v5_two_level_ist_shape(const struct vgic_v5_ist_desc *ist)
+{
+	struct vgic_v5_two_level_ist_shape shape;
+	size_t l2bits, n;
+
+	l2bits =3D (10 - ist->istsz) + (2 * ist->l2sz);
+	n =3D max(2, ist->id_bits - l2bits + 3 - 1);
+
+	shape.l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+	shape.l2_entries =3D BIT(l2bits);
+
+	return shape;
+}
+
+static int vgic_v5_read_vm_ist_desc(struct kvm *kvm, unsigned int section,
+				    struct vgic_v5_ist_desc *ist)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	u64 vmte_ist_section;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	vmte_ist_section =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
+
+	ist->id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, vmte_ist_section);
+	ist->istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, vmte_ist_section);
+	ist->l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, vmte_ist_section);
+	ist->iste_size =3D GICV5_ISTE_SIZE(ist->istsz);
+
+	return vmte_ist_section & GICV5_VMTEL2E_IST_VALID;
+}
+
+static int vgic_v5_get_spi_ist_desc(struct kvm *kvm, bool userspace_buf,
+				    struct vgic_v5_ist_desc *ist)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	int ret;
+
+	memset(ist, 0, sizeof(*ist));
+
+	ist->vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!ist->vmi))
+		return -ENXIO;
+
+	ret =3D vgic_v5_read_vm_ist_desc(kvm, GICV5_VMTEL2_SPI_SECTION, ist);
+	if (ret < 0)
+		return ret;
+
+	ist->base =3D ist->vmi->h_spi_ist;
+
+	/* We don't have SPIs, but userspace is trying to save/restore them. */
+	if (!ist->base && userspace_buf)
+		return -ENOENT;
+
+	/* We have SPIs but userspace isn't trying to save/restore them. */
+	if (ist->base && !userspace_buf)
+		return -EINVAL;
+
+	/* No SPIs and no userspace buffer: nothing to do. */
+	if (!ist->base && !userspace_buf)
+		return 0;
+
+	ist->present =3D true;
+	return 0;
+}
+
+static int vgic_v5_get_lpi_ist_desc(struct kvm *kvm,
+				    struct vgic_v5_ist_desc *ist)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	bool guest_valid, host_valid;
+	int ret;
+
+	memset(ist, 0, sizeof(*ist));
+
+	ist->vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!ist->vmi))
+		return -ENXIO;
+
+	ret =3D vgic_v5_read_vm_ist_desc(kvm, GICV5_VMTEL2_LPI_SECTION, ist);
+	if (ret < 0)
+		return ret;
+
+	host_valid =3D ret;
+	guest_valid =3D kvm->arch.vgic.vgic_v5_irs_data->ist_baser.valid;
+	ist->base =3D ist->vmi->h_lpi_ist;
+
+	/* If there is no IST to save/restore, return without error. */
+	if (!guest_valid && !host_valid && !ist->base)
+		return 0;
+
+	/* Mismatched combination of valid state */
+	if (!guest_valid || !host_valid || !ist->base)
+		return -ENXIO;
+
+	if (ist->vmi->h_lpi_ist_structure && !ist->vmi->h_lpi_l2_ists)
+		return -ENXIO;
+
+	ist->present =3D true;
+	return 0;
+}
+
+/*
+ * Save the SPI IST to userspace-provided memory.
+ *
+ * Only the architected 32-bit ISTE state is exposed to userspace. Host
+ * metadata is skipped when striding through the linear host SPI IST.
+ */
+int vgic_v5_save_spi_ist(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	u32 __user *uaddr =3D (u32 __user *)(unsigned long)attr->addr;
+	struct vgic_v5_ist_desc ist;
+	__le32 h_iste;
+	int ret;
+
+	ret =3D vgic_v5_get_spi_ist_desc(kvm, !!attr->addr, &ist);
+	if (ret || !ist.present)
+		return ret;
+
+	vgic_v5_clean_inval(ist.base,
+			    GICV5_LINEAR_IST_SIZE(ist.id_bits, ist.istsz));
+
+	/* The host SPI IST is always linear. */
+	for (unsigned int i =3D 0; i < kvm->arch.vgic.nr_spis; ++i) {
+		/*
+		 * Only the low 32 bits are saved. Any host metadata after the
+		 * architected ISTE is skipped by the host ISTE stride.
+		 */
+		__le32 *h_iste_addr =3D ist.base + i * ist.iste_size;
+
+		h_iste =3D READ_ONCE(*h_iste_addr);
+		ret =3D put_user(h_iste, uaddr);
+		if (ret)
+			return ret;
+
+		uaddr++;
+	}
+
+	return 0;
+}
+
+/*
+ * Save a Linear host LPI IST to guest memory.
+ *
+ * Only the architected 32-bit ISTE state is stored. Host metadata is skip=
ped
+ * when striding through the host's LPI IST.
+ *
+ * The guest's LPI IST is always Linear.
+ */
+static int vgic_v5_save_linear_lpi_ist(struct kvm *kvm,
+				       const struct vgic_v5_ist_desc *ist,
+				       gpa_t g_entry_addr)
+{
+	size_t h_l2_index, h_l2_entries;
+	__le32 h_iste;
+	int ret;
+
+	h_l2_entries =3D BIT(ist->id_bits);
+
+	vgic_v5_clean_inval(ist->base,
+			    GICV5_LINEAR_IST_SIZE(ist->id_bits, ist->istsz));
+
+	for (h_l2_index =3D 0; h_l2_index < h_l2_entries; h_l2_index++) {
+		__le32 *h_iste_addr =3D ist->base + h_l2_index * ist->iste_size;
+
+		h_iste =3D *h_iste_addr;
+		ret =3D kvm_write_guest(kvm, g_entry_addr, &h_iste,
+				      sizeof(h_iste));
+		if (ret)
+			return ret;
+
+		g_entry_addr +=3D sizeof(h_iste);
+	}
+
+	return 0;
+}
+
+/*
+ * Save a Two-level host LPI IST to guest memory.
+ *
+ * Only the architected 32-bit ISTE state is stored. Host metadata is skip=
ped
+ * when striding through the host's IST.
+ *
+ * The guest's LPI IST is always Linear.
+ */
+static int vgic_v5_save_two_level_lpi_ist(struct kvm *kvm,
+					  const struct vgic_v5_ist_desc *ist,
+					  gpa_t g_entry_addr)
+{
+	struct vgic_v5_two_level_ist_shape shape;
+	size_t h_l1_index, h_l2_index;
+	void *h_l2_ist_base;
+	__le32 h_iste;
+	int ret;
+
+	shape =3D vgic_v5_two_level_ist_shape(ist);
+
+	vgic_v5_clean_inval(ist->base,
+			    shape.l1_entries * sizeof(*ist->vmi->h_lpi_ist));
+
+	for (h_l1_index =3D 0; h_l1_index < shape.l1_entries; h_l1_index++) {
+		u64 l1_iste;
+
+		/*
+		 * Host L2 ISTs are preallocated. Any invalid L1 entry means the
+		 * host IST state is inconsistent.
+		 */
+		l1_iste =3D le64_to_cpu(READ_ONCE(ist->vmi->h_lpi_ist[h_l1_index]));
+		if (!FIELD_GET(GICV5_ISTL1E_VALID, l1_iste))
+			return -ENXIO;
+
+		h_l2_ist_base =3D ist->vmi->h_lpi_l2_ists[h_l1_index];
+		if (!h_l2_ist_base)
+			return -ENXIO;
+
+		vgic_v5_clean_inval(h_l2_ist_base,
+				    shape.l2_entries * ist->iste_size);
+
+		for (h_l2_index =3D 0; h_l2_index < shape.l2_entries; h_l2_index++) {
+			h_iste =3D *(__le32 *)(h_l2_ist_base +
+					     h_l2_index * ist->iste_size);
+
+			ret =3D kvm_write_guest(kvm, g_entry_addr, &h_iste,
+					      sizeof(h_iste));
+			if (ret)
+				return ret;
+
+			g_entry_addr +=3D sizeof(__le32);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Save the LPI IST to guest memory
+ *
+ * The guest LPI IST is exposed as a linear GPA range. The host LPI IST ma=
y be
+ * linear or two-level, so host iteration depends on the allocated host sh=
ape.
+ *
+ * Only the architected 32-bit ISTE state is saved. Host metadata is rebui=
lt on
+ * restore.
+ */
+int vgic_v5_save_lpi_ist(struct kvm *kvm)
+{
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct vgic_v5_ist_desc ist;
+	gpa_t g_entry_addr;
+	int ret;
+
+	lockdep_assert(srcu_read_lock_held(&kvm->srcu));
+
+	ret =3D vgic_v5_get_lpi_ist_desc(kvm, &ist);
+	if (ret || !ist.present)
+		return ret;
+
+	/* The guest LPI IST is saved through its linear GPA range. */
+	g_entry_addr =3D kvm->arch.vgic.vgic_v5_irs_data->ist_baser.addr;
+
+	/* Allow dirty tracking without a running vCPU while saving tables. */
+	dist->table_write_in_progress =3D true;
+	if (!ist.vmi->h_lpi_ist_structure)
+		ret =3D vgic_v5_save_linear_lpi_ist(kvm, &ist, g_entry_addr);
+	else
+		ret =3D vgic_v5_save_two_level_lpi_ist(kvm, &ist, g_entry_addr);
+	dist->table_write_in_progress =3D false;
+
+	return ret;
+}
+
+/*
+ * Track any SPIs and LPIs that were marked as pending at the point where =
the
+ * IST was restored.
+ *
+ * Restored pending state is cleared from the host IST and replayed with V=
DPEND
+ * before the VM first runs.
+ */
+static int vgic_v5_track_pending_irq(struct list_head *pending_irqs, u32 i=
ntid,
+				     u32 type)
+{
+	struct vgic_v5_pending_irq *pirq;
+
+	pirq =3D kzalloc_obj(*pirq, GFP_KERNEL);
+	if (!pirq)
+		return -ENOMEM;
+
+	/* Encode the interrupt as a GICv5 IntID. */
+	pirq->irq =3D FIELD_PREP(GICV5_HWIRQ_TYPE, type) |
+		    FIELD_PREP(GICV5_HWIRQ_ID, intid);
+
+	INIT_LIST_HEAD(&pirq->next);
+	list_add_tail(&pirq->next, pending_irqs);
+
+	return 0;
+}
+
+/*
+ * Process and sanitise each restored ISTE.
+ *
+ * HWU is for hardware use and must not survive migration. Pending state i=
s
+ * tracked, cleared from the ISTE, and replayed before the VM first runs.
+ */
+static int vgic_v5_process_iste(__le32 *iste, struct list_head *pending_ir=
qs,
+				u32 intid, u32 type)
+{
+	u32 iste_data =3D le32_to_cpu(READ_ONCE(*iste));
+	int ret;
+
+	/* Pending state is replayed later with VDPEND. */
+	if (iste_data & GICV5_ISTL2E_PENDING) {
+		ret =3D vgic_v5_track_pending_irq(pending_irqs, intid, type);
+		if (ret)
+			return ret;
+	}
+
+	iste_data &=3D ~GICV5_ISTL2E_PENDING;
+	iste_data &=3D ~GICV5_ISTL2E_HWU;
+
+	WRITE_ONCE(*iste, cpu_to_le32(iste_data));
+
+	return 0;
+}
+
+/*
+ * As part of restoring SPIs, sync back their handling modes to KVM. This =
is
+ * handled via the IRS's MMIO interface during normal operation, but we ne=
ed to
+ * do this explicitly on restore.
+ */
+static void vgic_v5_restore_spi_config(struct kvm *kvm, __le32 iste, u32 s=
pi)
+{
+	struct vgic_irq *irq;
+
+	irq =3D vgic_get_irq(kvm, vgic_v5_make_spi(spi));
+	if (WARN_ON_ONCE(!irq))
+		return;
+
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+		if (le32_to_cpu(iste) & GICV5_ISTL2E_HM)
+			irq->config =3D VGIC_CONFIG_LEVEL;
+		else
+			irq->config =3D VGIC_CONFIG_EDGE;
+	}
+
+	vgic_put_irq(kvm, irq);
+}
+
+/*
+ * Restore the SPI IST from userspace-provided buffer to the host-allocate=
d IST.
+ *
+ * Userspace supplies the architected 32-bit SPI ISTEs, only.
+ */
+int vgic_v5_restore_spi_ist(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	u32 __user *uaddr =3D (u32 __user *)(unsigned long)attr->addr;
+	struct vgic_v5_ist_desc ist;
+	__le32 h_iste;
+	int ret;
+
+	ret =3D vgic_v5_get_spi_ist_desc(kvm, !!attr->addr, &ist);
+	if (ret || !ist.present)
+		return ret;
+
+	/*
+	 * The saved SPI IST is linear and contains only architected 32-bit
+	 * ISTEs. The host ISTE stride skips host metadata sections.
+	 */
+	for (unsigned int i =3D 0; i < kvm->arch.vgic.nr_spis; i++) {
+		void *h_iste_addr =3D ist.base + i * ist.iste_size;
+
+		ret =3D get_user(h_iste, uaddr);
+		if (ret)
+			return ret;
+
+		/*
+		 * Sanitise the IST, clearing HWU & pending fields. Pending
+		 * state is later replayed via GIC VDPEND.
+		 */
+		ret =3D vgic_v5_process_iste(&h_iste, &ist.vmi->pending_irqs,
+					   i, GICV5_HWIRQ_TYPE_SPI);
+		if (ret)
+			return ret;
+
+		/* Update KVM's SPI level/edge tracking to match the ISTE */
+		vgic_v5_restore_spi_config(kvm, h_iste, i);
+
+		/*
+		 * Zero the full ISTE (incl metadata), and write back the
+		 * non-metadata region, only.
+		 */
+		memset(h_iste_addr, 0, ist.iste_size);
+		WRITE_ONCE(*(__le32 *)h_iste_addr, h_iste);
+		vgic_v5_clean_inval(h_iste_addr, ist.iste_size);
+
+		uaddr++;
+	}
+
+	return 0;
+}
+
+/*
+ * Restore the LPI IST from guest memory to the Linear host-allocated LPI =
IST.
+ *
+ * The guest LPI IST is restored from a linear GPA range.
+ *
+ * Only the lower 32-bits of each ISTE are restored.
+ */
+static int vgic_v5_restore_linear_lpi_ist(struct kvm *kvm,
+					  const struct vgic_v5_ist_desc *ist,
+					  gpa_t g_entry_addr)
+{
+	size_t h_l2_index, h_l2_entries;
+	__le32 h_iste;
+	int ret;
+
+	h_l2_entries =3D BIT(ist->id_bits);
+
+	for (h_l2_index =3D 0; h_l2_index < h_l2_entries; h_l2_index++) {
+		void *h_iste_addr =3D ist->base + h_l2_index * ist->iste_size;
+
+		ret =3D kvm_read_guest(kvm, g_entry_addr, &h_iste,
+				     sizeof(h_iste));
+		if (ret)
+			return ret;
+
+		/*
+		 * Sanitise the IST, clearing HWU & pending fields. Pending
+		 * state is later replayed via GIC VDPEND.
+		 */
+		ret =3D vgic_v5_process_iste(&h_iste, &ist->vmi->pending_irqs,
+					   h_l2_index, GICV5_HWIRQ_TYPE_LPI);
+		if (ret)
+			return ret;
+
+		/*
+		 * Zero the full ISTE (incl metadata), and write back the
+		 * non-metadata region, only.
+		 */
+		memset(h_iste_addr, 0, ist->iste_size);
+		WRITE_ONCE(*(__le32 *)h_iste_addr, h_iste);
+		vgic_v5_clean_inval(h_iste_addr, ist->iste_size);
+
+		g_entry_addr +=3D sizeof(h_iste);
+	}
+
+	return 0;
+}
+
+/*
+ * Restore the LPI IST from guest memory to the Two-level host-allocated L=
PI
+ * IST.
+ *
+ * The guest LPI IST is restored from a linear GPA range.
+ *
+ * Only the lower 32-bits of each ISTE are restored.
+ */
+static int vgic_v5_restore_two_level_lpi_ist(struct kvm *kvm,
+					     const struct vgic_v5_ist_desc *ist,
+					     gpa_t g_entry_addr)
+{
+	struct vgic_v5_two_level_ist_shape shape;
+	size_t h_l1_index, h_l2_index;
+	void *h_l2_ist_base;
+	__le32 h_iste;
+	int ret;
+
+	shape =3D vgic_v5_two_level_ist_shape(ist);
+
+	vgic_v5_clean_inval(ist->vmi->h_lpi_ist,
+			    shape.l1_entries * sizeof(*ist->vmi->h_lpi_ist));
+
+	for (h_l1_index =3D 0; h_l1_index < shape.l1_entries; ++h_l1_index) {
+		u64 l1_iste;
+
+		/*
+		 * Host L2 ISTs are preallocated. Any invalid L1 entry means the
+		 * host IST state is inconsistent.
+		 */
+		l1_iste =3D le64_to_cpu(READ_ONCE(ist->vmi->h_lpi_ist[h_l1_index]));
+		if (!FIELD_GET(GICV5_ISTL1E_VALID, l1_iste))
+			return -ENXIO;
+
+		h_l2_ist_base =3D ist->vmi->h_lpi_l2_ists[h_l1_index];
+		if (!h_l2_ist_base)
+			return -ENXIO;
+
+		for (h_l2_index =3D 0; h_l2_index < shape.l2_entries; h_l2_index++) {
+			void *h_iste_addr =3D h_l2_ist_base +
+					    h_l2_index * ist->iste_size;
+
+			ret =3D kvm_read_guest(kvm, g_entry_addr, &h_iste,
+					     sizeof(h_iste));
+			if (ret)
+				return ret;
+
+			/*
+			 * Sanitise the IST, clearing HWU & pending
+			 * fields. Pending state is later replayed via GIC
+			 * VDPEND.
+			 */
+			ret =3D vgic_v5_process_iste(&h_iste, &ist->vmi->pending_irqs,
+						   h_l1_index * shape.l2_entries + h_l2_index,
+						   GICV5_HWIRQ_TYPE_LPI);
+			if (ret)
+				return ret;
+
+			/*
+			 * Zero the full ISTE (incl metadata), and write back
+			 * the non-metadata region, only.
+			 */
+			memset(h_iste_addr, 0, ist->iste_size);
+			WRITE_ONCE(*(__le32 *)h_iste_addr, h_iste);
+			vgic_v5_clean_inval(h_iste_addr, ist->iste_size);
+
+			g_entry_addr +=3D sizeof(h_iste);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Restore the LPI IST from guest memory to the host-allocated LPI IST.
+ *
+ * The guest LPI IST is restored from a linear GPA range. The host LPI IST=
 may
+ * be linear or two-level, so host iteration depends on the allocated host
+ * shape.
+ */
+int vgic_v5_restore_lpi_ist(struct kvm *kvm)
+{
+	struct vgic_v5_ist_desc ist;
+	gpa_t g_entry_addr;
+	int ret;
+
+	lockdep_assert(srcu_read_lock_held(&kvm->srcu));
+
+	ret =3D vgic_v5_get_lpi_ist_desc(kvm, &ist);
+	if (ret || !ist.present)
+		return ret;
+
+	/* The guest LPI IST is restored through its linear GPA range. */
+	g_entry_addr =3D kvm->arch.vgic.vgic_v5_irs_data->ist_baser.addr;
+
+	if (!ist.vmi->h_lpi_ist_structure)
+		return vgic_v5_restore_linear_lpi_ist(kvm, &ist, g_entry_addr);
+
+	return vgic_v5_restore_two_level_lpi_ist(kvm, &ist, g_entry_addr);
+}
+
+/*
+ * Process the pending IRQs removing them from the list and optionally inj=
ecting
+ * them.
+ */
+static int vgic_v5_process_pending_irqs(struct kvm *kvm, bool inject)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	vgic_v5_drain_pending_irqs(kvm, vmi, inject);
+
+	return 0;
+}
+
+/* Replay pending state that was cleared while restoring guest IST state. =
*/
+int vgic_v5_restore_pending_irqs(struct kvm *kvm)
+{
+	return vgic_v5_process_pending_irqs(kvm, true);
+}
+
+/* Drop pending state collected by a failed IST restore. */
+void vgic_v5_discard_pending_irqs(struct kvm *kvm)
+{
+	vgic_v5_process_pending_irqs(kvm, false);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index bc2fc5cb2c8d9..8da12088c8423 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -8,6 +8,7 @@
=20
 #include <linux/idr.h>
 #include <linux/irqchip/arm-gic-v5.h>
+#include <linux/list.h>
=20
 /* Level 1 Virtual Machine Table Entry */
 typedef __le64 vmtl1_entry;
@@ -43,6 +44,9 @@ struct vgic_v5_vm_info {
 	__le64			*h_lpi_ist;
 	__le64			**h_lpi_l2_ists;
 	__le64			*h_spi_ist;
+
+	/* Tracking of pending interrupts as part of IST restore */
+	struct list_head	pending_irqs;
 };
=20
 struct vgic_v5_vmt {
@@ -94,7 +98,15 @@ int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_exists(struct kvm *kvm);
 int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
 int vgic_v5_lpi_ist_free(struct kvm *kvm);
=20
+int vgic_v5_save_spi_ist(struct kvm *kvm, struct kvm_device_attr *attr);
+int vgic_v5_save_lpi_ist(struct kvm *kvm);
+int vgic_v5_restore_spi_ist(struct kvm *kvm, struct kvm_device_attr *attr)=
;
+int vgic_v5_restore_lpi_ist(struct kvm *kvm);
+int vgic_v5_restore_pending_irqs(struct kvm *kvm);
+void vgic_v5_discard_pending_irqs(struct kvm *kvm);
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 058cedfc2bf4c..f923eec7ee14d 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -8,6 +8,7 @@
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
 #include <linux/irqdomain.h>
+#include <linux/kvm_host.h>
=20
 #include "vgic.h"
 #include "vgic-v5-tables.h"
@@ -244,6 +245,17 @@ static int vgic_v5_irs_wait_for_vpe_op(void)
 					NULL);
 }
=20
+/*
+ * Wait for a write to IRS_SAVE_VMR to complete.
+ */
+static int vgic_v5_irs_wait_for_save_vm_op(u32 *statusr)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_SAVE_VM_STATUSR,
+					GICV5_IRS_SAVE_VM_STATUSR_IDLE,
+					statusr);
+}
+
 static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
 {
 	int ret;
@@ -405,6 +417,27 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_i=
d,
 	return 0;
 }
=20
+static int vgic_v5_irs_save_vm_op(u16 vm_id, bool save, u32 *statusr)
+{
+	u64 save_vmr;
+	int ret;
+
+	save_vmr =3D FIELD_PREP(GICV5_IRS_SAVE_VMR_VM_ID, vm_id);
+	save_vmr |=3D GICV5_IRS_SAVE_VMR_Q;
+	save_vmr |=3D FIELD_PREP(GICV5_IRS_SAVE_VMR_S, save);
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
+
+	/* Make sure that we are idle to begin with. */
+	ret =3D vgic_v5_irs_wait_for_save_vm_op(NULL);
+	if (ret)
+		return ret;
+
+	irs_writeq_relaxed(save_vmr, GICV5_IRS_SAVE_VMR);
+
+	return vgic_v5_irs_wait_for_save_vm_op(statusr);
+}
+
 static irqreturn_t db_handler(int irq, void *data)
 {
 	struct kvm_vcpu *vcpu =3D data;
@@ -1227,6 +1260,46 @@ void vgic_v5_set_spi_ops(struct vgic_irq *irq)
 	irq->ops =3D &vgic_v5_spi_irq_ops;
 }
=20
+/*
+ * Rebuild the global SPI AP list after restoring the IST. Pending state i=
s
+ * replayed directly to the IRS, so read the restored hardware state back =
before
+ * deciding whether an SPI must be tracked by KVM.
+ */
+static void vgic_v5_restore_spi_ap_list(struct kvm *kvm)
+{
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+
+	for (unsigned int i =3D 0; i < dist->nr_spis; i++) {
+		struct vgic_irq *irq =3D vgic_get_irq(kvm, vgic_v5_make_spi(i));
+		unsigned long flags;
+		bool pending;
+		u64 icsr;
+
+		if (WARN_ON_ONCE(!irq))
+			continue;
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+		icsr =3D kvm_call_hyp_ret(__vgic_v5_vdrcfg, irq->intid);
+		irq->active =3D !!FIELD_GET(ICC_ICSR_EL1_Active, icsr);
+		pending =3D !!FIELD_GET(ICC_ICSR_EL1_Pending, icsr);
+
+		if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+			irq->pending_latch =3D pending;
+
+		if (irq->config =3D=3D VGIC_CONFIG_LEVEL &&
+		    !(pending || irq->active))
+			irq->pending_latch =3D false;
+
+		if (irq->active || pending)
+			vgic_v5_spi_queue_irq_unlock(kvm, irq, flags);
+		else
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+		vgic_put_irq(kvm, irq);
+	}
+}
+
 /* Set the pending state for GICv5 SPIs and LPIs */
 void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
@@ -1368,3 +1441,228 @@ void vgic_v5_save_state(struct kvm_vcpu *vcpu)
 	__vgic_v5_save_ppi_state(cpu_if);
 	dsb(sy);
 }
+
+static int vgic_v5_irs_status_is_quiesced(u32 statusr)
+{
+	if (statusr & GICV5_IRS_SAVE_VM_STATUSR_Q)
+		return 0;
+
+	return -EBUSY;
+}
+
+static int vgic_v5_irs_is_quiesced(u16 vm_id)
+{
+	u32 statusr;
+	int ret;
+
+	ret =3D vgic_v5_irs_save_vm_op(vm_id, false, &statusr);
+	if (ret)
+		return ret;
+
+	return vgic_v5_irs_status_is_quiesced(statusr);
+}
+
+int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret =3D 0;
+	int srcu_idx;
+	u32 statusr;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	srcu_idx =3D srcu_read_lock(&kvm->srcu);
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (!vgic_initialized(kvm)) {
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	ret =3D vgic_v5_irs_save_vm_op(vm_id, true, &statusr);
+	if (ret) {
+		kvm_err("Failed to save GICv5 IRS VM state: %d\n", ret);
+		goto out_unlock;
+	}
+
+	ret =3D vgic_v5_irs_status_is_quiesced(statusr);
+	if (ret)
+		goto out_unlock;
+
+	/* Save the SPI IST to the userspace buffer. */
+	ret =3D vgic_v5_save_spi_ist(kvm, attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_irs_is_quiesced(vm_id);
+	if (ret)
+		goto out_unlock;
+
+	/* Save the LPI IST to guest memory. */
+	ret =3D vgic_v5_save_lpi_ist(kvm);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_irs_is_quiesced(vm_id);
+	if (ret)
+		goto out_unlock;
+
+out_unlock:
+	mutex_unlock(&kvm->arch.config_lock);
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
+
+static int vgic_v5_restore_lpi_ist_alloc(struct kvm *kvm, bool *allocated)
+{
+	unsigned int id_bits;
+	int ret;
+
+	*allocated =3D false;
+
+	ret =3D vgic_v5_irs_lpi_ist_id_bits(kvm, &id_bits);
+	if (ret <=3D 0)
+		return ret;
+
+	ret =3D vgic_v5_lpi_ist_alloc(kvm, id_bits);
+	if (ret)
+		return ret;
+
+	*allocated =3D true;
+
+	return 0;
+}
+
+/*
+ * Clean up the LPI IST if we allocated it, and restore the VMTE to the
+ * original, valid state.
+ */
+static void vgic_v5_restore_cleanup(struct kvm *kvm,
+				    struct kvm_vcpu *vcpu,
+				    bool lpi_ist_allocated)
+{
+	/*
+	 * We are on the restore failure path, so we do a best-effort
+	 * cleanup. These commands might fail, but at this stage this is the
+	 * best we can realistically do.
+	 */
+	if (lpi_ist_allocated) {
+		vgic_v5_send_command(vcpu, VMTE_MAKE_INVALID);
+		vgic_v5_lpi_ist_free(kvm);
+	}
+
+	vgic_v5_send_command(vcpu, VMTE_MAKE_VALID);
+}
+
+int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
)
+{
+	bool lpi_ist_allocated =3D false, vmte_invalid =3D false;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	int srcu_idx;
+	int ret =3D 0;
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	srcu_idx =3D srcu_read_lock(&kvm->srcu);
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (!vgic_initialized(kvm)) {
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	if (kvm_vm_has_ran_once(kvm)) {
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	ret =3D vgic_v5_lpi_ist_exists(kvm);
+	if (ret) {
+		if (ret > 0)
+			ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	/*
+	 * If the guest has previously allocated an IST (which we check based on
+	 * the IRS_IST_BASER), extract the number of LPI ID bits from the
+	 * IRS_IST_CFGR. Else, do nothing.
+	 *
+	 * We do this before making the VMTE invalid as we rely on
+	 * IRS_VMAP_VISTR to mark the IST as valid in the VMTE. This can only
+	 * happen while the VMTE is valid.
+	 */
+	ret =3D vgic_v5_restore_lpi_ist_alloc(kvm, &lpi_ist_allocated);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Host ISTs are updated while the VMTE is invalid, so the GIC cannot
+	 * observe partially restored state.
+	 */
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+	if (ret) {
+		/*
+		 * If invalidation fails, the restore cannot safely update host
+		 * IST state.
+		 */
+		goto out_unlock;
+	}
+	vmte_invalid =3D true;
+
+	/* Restore the SPI IST from the userspace buffer. */
+	ret =3D vgic_v5_restore_spi_ist(kvm, attr);
+	if (ret)
+		goto out_unlock;
+
+	/* Restore the LPI IST from guest memory. */
+	if (lpi_ist_allocated) {
+		ret =3D vgic_v5_restore_lpi_ist(kvm);
+		if (ret)
+			goto out_unlock;
+	}
+
+	/* And make the VM Valid again */
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		goto out_unlock;
+	vmte_invalid =3D false;
+
+	/*
+	 * As part of restoring the ISTs, and previously pending interrupts have
+	 * been tracked and made non-pending. Now that the ISTs have been
+	 * restored, and the VM is valid again, restore the pending interrupts.
+	 */
+	ret =3D vgic_v5_restore_pending_irqs(kvm);
+	if (ret)
+		goto out_unlock;
+
+	vgic_v5_restore_spi_ap_list(kvm);
+
+out_unlock:
+	if (ret && (vmte_invalid || lpi_ist_allocated)) {
+		vgic_v5_discard_pending_irqs(kvm);
+		vgic_v5_restore_cleanup(kvm, vcpu0, lpi_ist_allocated);
+	}
+
+	mutex_unlock(&kvm->arch.config_lock);
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index e05b4a5c2e49b..9c140a54e840e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -384,11 +384,14 @@ void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcr);
 void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
 int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
+int vgic_v5_irs_lpi_ist_id_bits(struct kvm *kvm, unsigned int *id_bits);
=20
 int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr);
+int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
);
 int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
 				 u64 *reg, bool is_write);
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 710a0d267347d..1b9bbeab18a4e 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -423,6 +423,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
--=20
2.34.1
