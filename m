Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011056.outbound.protection.outlook.com [52.101.65.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C3442587B
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 11:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890903; cv=fail; b=p5A53Eo2jAHcZdHSTWJsVyPmzgkdHt/ApyjZOiv+R0P0zf2sO0pBA3PJ8wvahHG21IpS8ZcV+wpu1+kcoqKMfMt1eSuF+kVXalKjSQk+WjFmF63ws39tbrxqoi6550Oy3LhGXwfDApWh01cgRDy6poEMh4hRCDa3vZzpHnf4Esc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890903; c=relaxed/simple;
	bh=qadU5gb7DS9be8vI+Jjiw11ZPTbDbs4N78j+aPyS7xM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i9SqYwjYeyK0bmR7+jyU6ZnGoEZXPCyZc7ZL7GcojDMOjjhN0PkIA01bkDJKjZnvCHj+kzdstcymhxYb+Xe6HxbFWRw4CKHmizDpTaP1YnV9L6/B9hqHUjjRwSpJVWAbTvYs4PlHvJUV01gXc86mFdK4c7KN8gED6xVL13uHp3I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Yjn/DsrU; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Yjn/DsrU; arc=fail smtp.client-ip=52.101.65.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Yjn/DsrU";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Yjn/DsrU"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=euyP183gvY6QMgqICc+7GwxiT5c/w5pM88T6Q27E1FZXXmYahuGIOZW+7C1fJwvHZMcInxYJlLePJ3cR9oxT10LAJss5H1kNHC0lzbFmyMuoAWsBkqk6RyCbGpKksNsnzUGb7NMrunQhH6E+otak2th2a75sZn5EUi6sULS9wCywAqm6JmBuWSYwi8kUzqsyGmT4G8wGYvFrnuiMREIESyt+ln1558S1YKSWnkbBVN4/TjAoSXf/W8RxModn8wLnMUnRN9v1QstXoAYNvqAtev+W7VSzDSMwRugUy645TyE36VON/Mo8YqTxosTyyFGxmFsAkU+M0c6manWMJvllDQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWUJUnmRuQVH3vknlwE7JXHXsIy5Q3/SIgjWuHeg17E=;
 b=IUES8FqHO2E4VhkKhidM3Mh3vgHGNne2s/sjCMHtl3I4EqCH76vPME4GwaymcWsfFqJvHzldbRibR09McKVcxMrmD9NyHHPO1pkarG9cJ5c49naUkXSBHcw+i48W1xru6rHOrzjdPdqdBi5VU13H2t3bNEZCs5tHHvP2G2liwg12JAAc0SS0BEpjf0gc7DfUSTkMx24WO8PXTWKqqizqw32Sl81Oxd29ZxL/ELzttAPYrCeHCLV51RzQ43vXABAOZ+AvjWhbLAARGxJAyEp5C5IDDdmOLCS1cVNTrHs8Boj4Q3uZ4SzDZNA+TTFrEqzfSf7TAVgx7kGdr2TYDleJQg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWUJUnmRuQVH3vknlwE7JXHXsIy5Q3/SIgjWuHeg17E=;
 b=Yjn/DsrUWKOAIMppAoia72GQH/aLaXddkMxfNRWi+jAPni/yKKBge4UocPl1aI1JLX9EgYS/df3vRWbMszbhOv67t/CJPfETV2uG8AbzTXGj85iKnXTRBle9pk4tlM5/StnSM2pRU3GEAX9NeSmq/g091lQZOqzVkMgnrj8GR1g=
Received: from AS4P189CA0032.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5dd::18)
 by AMDPR08MB11367.eurprd08.prod.outlook.com (2603:10a6:20b:717::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:01:34 +0000
Received: from AM3PEPF0000A79A.eurprd04.prod.outlook.com
 (2603:10a6:20b:5dd:cafe::47) by AS4P189CA0032.outlook.office365.com
 (2603:10a6:20b:5dd::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:01:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79A.mail.protection.outlook.com (10.167.16.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:01:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1Mwqhprl5eiVqg3NzddnCxcl5H6NdTNSbMSUsRw9WVw7VZdtJsFn79JgeFXBv8nYBDMxlUxyhQd1wg0miyLJgDWyQdg0CaZ5AC7luhNsabVCGBcuyos7Y9MLlNmaSDXsVfXE32huhNWEnT3madKzHcKjaq3ILFAutSwbsKL5sotvHsxjXivHrox74rslPtLNhTamJGkagUDGwwNZeYdgCfOblCtu1AtxwDDWjGQfqOMZcNZgOdFbUhCxcWihfqy6yoJ7eL5SuokVnkz3VujbKJTV7cDkHhQQCTI3MjmFAvbotLZ0fu4VKUjqhbRu9K8hqZk6UGZp+Azu4bzqq+viQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWUJUnmRuQVH3vknlwE7JXHXsIy5Q3/SIgjWuHeg17E=;
 b=ILeZx3CDftf+UjykmInUjUGMREW2mm4ZRjPraUcR8JVZxlqxihC659YHzvr6Yfa3o52YrwO6Rd8TR3QkFKmCG09etVfTfAazHtYP8Wj9JXzK51FURhuNDkqmOV7myGc/R61f3HJV2D3KdU9DsOacGBnMRveR5At/VfQge9q0be2g+0E3qsUIpExoBSbhUddrCj1CHNafm3tBk/AveweC7kxOxFgFUG/0peuaYJqxvqES2F38Qna0LuraOHUL9FO+kSYcxcjElef6LjVb0SlwWdX8RNUBzl62TIgwZoazP+E9uuL57K3Uvtwr/nivflju3zhNyMv3wLKvQQA7OC+mzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWUJUnmRuQVH3vknlwE7JXHXsIy5Q3/SIgjWuHeg17E=;
 b=Yjn/DsrUWKOAIMppAoia72GQH/aLaXddkMxfNRWi+jAPni/yKKBge4UocPl1aI1JLX9EgYS/df3vRWbMszbhOv67t/CJPfETV2uG8AbzTXGj85iKnXTRBle9pk4tlM5/StnSM2pRU3GEAX9NeSmq/g091lQZOqzVkMgnrj8GR1g=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM8PR08MB5571.eurprd08.prod.outlook.com (2603:10a6:20b:1d0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:00:32 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 11:00:31 +0000
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
Subject: [PATCH v4 47/48] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Topic: [PATCH v4 47/48] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Index: AQHdG1ulFmLsDa1l4UqNn7Nr/cwa1w==
Date: Fri, 24 Jul 2026 11:00:31 +0000
Message-ID: <20260724104819.1296803-48-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM8PR08MB5571:EE_|AM3PEPF0000A79A:EE_|AMDPR08MB11367:EE_
X-MS-Office365-Filtering-Correlation-Id: 917ede9d-d9f9-407c-da70-08dee972eccd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|11063799006|3023799007|6133799003|56012099006|18002099003|22082099003|10067099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 xaCidjI8VTf3MX2cPCsq3xZo9MeIvfpxp8IUSJcmToUX6h5pksDyQuhHafIOIaNNKm4gI48dgFod+5uD90FCom0UJNIhHSiSsAHiA8SEa2hTIP9EyGjaCJ5oPskBUsuvBMtYDPOMt1ULEUHGTKnhtuej4A3GMukILy9FO3lJfUsZPlWMZzUk6Nj++etEZg/1CpYpAQ5nfu7ht0tP7yOs5Gx08XjdJB/gFIu5KhMMcgYwDyoQ5YWqiUCoEaY3yh+AZo3H9BUC+9FihZg7/7OuR+cjN+PFzuDzamUKfCYYqh+Y65b75CqMpYulDtQSqF7pIT0v6RsqGA8Nte8cSvzTyofZB4Ri1FBrTcRpjkkkjOrulRuv39gVSaupinPc5eWXa1A8pU26qMsJbk266xKoqYIl2Kq4JzhuDxalwe8uMgfevpIIFioSHSSwR9jyciOTKTk0yq72HgeRhF9m/NsV+pk9trxrWIj2BU17BGaQmdyX00Rkz3plR1fJdqYffu4HA+Tv5KHzjPOMArVmWaC2qXHc8IdTm1Iu5g1GdTrukVugbH/nh239CZVZZSOuTnykMYAIzfMNYIgQxEBnxtg4uVosxAIL32RN+GVWNm3G1JsBTDIdgF05noOHouJyWKZbw7jiUqth98AbvWKHWlkZtEHSiNAcEM/El336xrBACArZXdO26pLT8a+5LntE0/zSTVCYaT7Ump6d4r6Ayh2VELz+FlsKjDJRkCoIRECI1bw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(11063799006)(3023799007)(6133799003)(56012099006)(18002099003)(22082099003)(10067099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 lef3V5oXfxo4FPoXGGFC+s+XO4m+tgEJ65UY+pQIAbuLg+s+oZEOkiRjBISytQtcPV7nQZ1nNnkHrZthMllkkZOiQDSA2B+JmUIZbvR4+jM/S6wA6LRl7+icTqyPXp8TxdqAdxAmNKzevxIYzXIeQszFukiWfv+YmrvECvTxXZpxHZ3p33wJkearqELWJXoLqVN7WtTZPgnhTnXn14egjNEwgNQSAe/z/V7dd9A0vAT7MQcrHa+/mhPAhvkj/eH/naxU1BD7/pomaMt+YLTjzdo5ISN9o2cXSu/vm/8ebKoQrVSgCSdkTtuYSRKyja9wjEIRo3nWo0GwGLPe5sE7ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5571
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a834b99a-4205-44e1-a3ae-08dee972c7af
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|35042699022|14060799003|1800799024|36860700016|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	q19mRt1Tx1/87UoCTKnrofR1U3467bZoAV17u24sVclOFhkI01fmXUTT7sZhrphZn+Dbd0bIuf8ppi1jNdsiQenulNoTvZnkxQ34bLN+eFAO0HyFCEoo6IE/tHm8AevcpN41GR8kab+jMt7DZbvuRf+8t8cAONTlb9MbECEIp1Y9yHIfLQswPPDhgyU7h2cdSqPKN7XKOq8DmxJy1lJnJF6HqCuIVwKi/ZOb/ahT7MI+ztQZLXl1dw8sclGuJuS2362xfx+XOWmQ2JwrO65sOBIoqk/uFy2XO0aROoY1FZx5mXNcBDZ+3WldNi2/25IGqsYN/6QmFgxjqU/cKlNpWWx8BAJMqyYK57Tnish4epjtxlXOWhDb3kL5Vg47wdDwk7Riqf+HAcEVNPzTZP1Pk7KZmgZXhXAkMX+2F6EJjM4eyK7OnZJ+oKhnwJaR35h/Jj9fMRCekeflZCGi8mNcyeL2/BHYs8tN77p9+jglfo6TszeUWA81FCxVnG7VVUL9FrOSAufjregRv/mE8S1PtxBqfKt8qPUhWqGdkpQKmY8viRjxyQOzJzrsW7Y9lrPD7aAxCwtsqfyHxQPU7YDZcJrpRYbar4iQHyZYj63F1P4aT8H4had3fzFgPUYa4fHNZUQwH0bf6wkass9x90t3hNrC6Kc8Bf3s92EZIZyIzPPXydR3BmCrdQkE3axaxhbkkQsyzCtrHuwOfWIR2ZhBRg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(35042699022)(14060799003)(1800799024)(36860700016)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Nrip+P78FH+0jTn0ZZOd5A+009QsGFugC/D93R8YLclqpezXIFAs1xSVXz2JPa975C0ewN7myFyBDhpyR/UaPKZOSLnLbZiW9j5vEflYmM4JmeJkk6IpWU2G56bNXI4mVlU8gfBdkQs79QNjedIgdJhwSEPYJeeGu0msGnlG5VkgkpeAFdY6z+G/FIKcdVJl2t1y0kkBoeQFqwYX6YYRlDpb6yotwTAkunXALl9JRdpJ6kMy75fNwBXtuOGtSNTokvSPhLkl20Bi2/ly4VzNQaYf38WXX1lZIRxmMh/1Bg3ROoSBHNJDPQrcLWxqLTshQFJG9SjfbDSICNYF08yeyFuOlZSJwLHkA1zq6rNGIF2TqbLVt4O5/Wiv/31CFR4TptgBpVS8M4GEZ5SNjps7vLRJMvyGdL/LImmYwbkmAritEjXh0k4r6CDqV3pMLgmn
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:01:34.0608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 917ede9d-d9f9-407c-da70-08dee972eccd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11367

Add a two-VPE VGICv5 LPI delivery test. LPIs depend on an IST whose
base is provided by the guest through IRS_IST_BASER (which triggers
KVM to allocate and provide an LPI IST to the HW), so exercise the
virtual IRS ID registers and IST base configuration path before
checking interrupt delivery.

Back the guest's LPI IST with a dedicated userspace memslot and unity
map it into the guest at the same IPA and VA. This lets the guest
provide that address to the emulated IRS via IRS_IST_BASER while the
host test still allocates and owns the backing memory.

Have VPE0 enable the IRS, derive a valid linear LPI IST configuration
from the virtual IRS ID registers, provide the IST base through
IRS_IST_BASER, configure one LPI for each VPE, and send an LPI to VPE1.
VPE1 consumes it and replies with a second LPI, which VPE0 consumes
before completing the test.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 241 +++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  16 ++
 2 files changed, 255 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index cec994a77c993..d022559005ada 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -13,12 +13,18 @@
 #include "vgic.h"
=20
 #define NR_VCPUS		1
+#define VGIC_V5_LPI_NR_VCPUS	2
+#define VGIC_V5_LPI_MEMSLOT	1
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_V5_MAX_NR_SPIS	BIT(16)
 #define VGIC_V5_TEST_NR_SPIS		64
 #define VGIC_V5_IRS_SIZE		0x20000
 #define VGIC_V5_IRS_WAIT_RETRIES	1000000
+#define VGIC_V5_LPI_IST_BASE_GPA	(GICV5_IRS_CONFIG_BASE_GPA + VGIC_V5_IRS_=
SIZE)
+#define VGIC_V5_LPI_IST_SIZE		0x10000
+#define LPI_TEST_TO_VPE1		0
+#define LPI_TEST_TO_VPE0		1
=20
 static u64 max_phys_size;
=20
@@ -32,6 +38,8 @@ struct vm_gic {
 #define GUEST_CMD_IRQ_DIEOI	11
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
+#define GUEST_CMD_LPI_SENT	14
+#define GUEST_CMD_LPI_REPLIED	15
=20
 static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_s=
ize,
 					       void *lpi_ist, size_t lpi_size)
@@ -46,11 +54,22 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *sp=
i_ist, size_t spi_size,
=20
 static u32 spi_line_expected;
 static bool spi_line_level_sensitive;
+static bool lpi_ist_ready;
+
+static u64 gicv5_hwirq(u32 type, u32 intid)
+{
+	return FIELD_PREP(GICV5_HWIRQ_TYPE, type) |
+	       FIELD_PREP(GICV5_HWIRQ_ID, intid);
+}
+
+static u64 gicv5_lpi_hwirq(u32 lpi)
+{
+	return gicv5_hwirq(GICV5_HWIRQ_TYPE_LPI, lpi);
+}
=20
 static u64 gicv5_spi_hwirq(u32 spi)
 {
-	return FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI) |
-	       FIELD_PREP(GICV5_HWIRQ_ID, spi);
+	return gicv5_hwirq(GICV5_HWIRQ_TYPE_SPI, spi);
 }
=20
 static void gicv5_setup_and_enable_hwirq(u64 hwirq, u32 target_vpe)
@@ -72,6 +91,18 @@ static void gicv5_enable_spi(u32 spi, u32 target_vpe)
 	gicv5_setup_and_enable_hwirq(gicv5_spi_hwirq(spi), target_vpe);
 }
=20
+static void gicv5_enable_lpi(u32 lpi, u32 target_vpe)
+{
+	gicv5_setup_and_enable_hwirq(gicv5_lpi_hwirq(lpi), target_vpe);
+}
+
+static void gicv5_send_lpi(u32 lpi)
+{
+	u64 hwirq =3D gicv5_lpi_hwirq(lpi);
+
+	gic_insn(hwirq | GICV5_GIC_CDPEND_PENDING_MASK, CDPEND);
+}
+
 static void gicv5_wait_for_irs_idle(u32 reg, u32 idle)
 {
 	int i;
@@ -101,6 +132,52 @@ static void gicv5_configure_spi(u32 spi, bool level)
 				GICV5_IRS_SPI_STATUSR_IDLE);
 }
=20
+static u32 gicv5_lpi_istsz(u32 idr2, u32 lpi_id_bits)
+{
+	if (!(idr2 & GICV5_IRS_IDR2_ISTMD))
+		return GICV5_IRS_IST_CFGR_ISTSZ_4;
+
+	if (lpi_id_bits >=3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, idr2))
+		return GICV5_IRS_IST_CFGR_ISTSZ_16;
+
+	return GICV5_IRS_IST_CFGR_ISTSZ_8;
+}
+
+static void gicv5_configure_lpi_ist(void)
+{
+	u32 idr2, min_lpi_id_bits, lpi_id_bits, id_bits, istsz;
+	u64 val;
+
+	idr2 =3D readl(GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IDR2);
+	GUEST_ASSERT(idr2 & GICV5_IRS_IDR2_LPI);
+
+	min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, idr2);
+	id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, idr2);
+	/* Default to 32 LPIs, unless the min requirement is higher */
+	lpi_id_bits =3D max(5U, min_lpi_id_bits);
+	GUEST_ASSERT(lpi_id_bits <=3D id_bits);
+
+	istsz =3D gicv5_lpi_istsz(idr2, lpi_id_bits);
+	/*
+	 * We allocate a fixed-size IST buffer on the host to avoid dynamic
+	 * allocation from the guest. Make sure it fits the linear IST described
+	 * by IDR2 before programming IRS_IST_BASER.
+	 */
+	GUEST_ASSERT((BIT_ULL(lpi_id_bits) << (istsz + 2)) <=3D VGIC_V5_LPI_IST_S=
IZE);
+
+	val =3D FIELD_PREP(GICV5_IRS_IST_CFGR_LPI_ID_BITS, lpi_id_bits) |
+	      FIELD_PREP(GICV5_IRS_IST_CFGR_ISTSZ, istsz);
+	writel(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_CFGR);
+
+	val =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+			 VGIC_V5_LPI_IST_BASE_GPA >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+	val |=3D GICV5_IRS_IST_BASER_VALID;
+	writeq(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_BASER);
+
+	GUEST_ASSERT_EQ(readl(GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_STATUSR),
+			GICV5_IRS_IST_STATUSR_IDLE);
+}
+
 static void gicv5_enable_irs(void)
 {
 	writel(GICV5_IRS_CR0_IRSEN,
@@ -108,6 +185,12 @@ static void gicv5_enable_irs(void)
 	gicv5_wait_for_irs_idle(GICV5_IRS_CR0, GICV5_IRS_CR0_IDLE);
 }
=20
+static void gicv5_configure_test_lpis(void)
+{
+	gicv5_enable_lpi(LPI_TEST_TO_VPE1, 1);
+	gicv5_enable_lpi(LPI_TEST_TO_VPE0, 0);
+}
+
 static void guest_ppi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -207,6 +290,67 @@ static void guest_spi_line_code(void)
 		wfi();
 }
=20
+static void guest_lpi_irq_handler(struct ex_regs *regs)
+{
+	u32 vcpu_id =3D guest_get_vcpuid();
+	u32 expected_lpi =3D vcpu_id ? LPI_TEST_TO_VPE1 : LPI_TEST_TO_VPE0;
+	u64 expected_hwirq =3D gicv5_lpi_hwirq(expected_lpi);
+	u32 hwirq;
+	u64 ia;
+
+	ia =3D gicr_insn(CDIA);
+	if (!GICV5_GICR_CDIA_VALID(ia))
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	if (vcpu_id) {
+		gicv5_send_lpi(LPI_TEST_TO_VPE0);
+		GUEST_SYNC(GUEST_CMD_LPI_REPLIED);
+		while (1)
+			wfi();
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_lpi_code(void)
+{
+	u32 vcpu_id =3D guest_get_vcpuid();
+
+	local_irq_disable();
+
+	if (!vcpu_id) {
+		gicv5_enable_irs();
+		gicv5_configure_lpi_ist();
+		gicv5_configure_test_lpis();
+		WRITE_ONCE(lpi_ist_ready, true);
+	}
+
+	/* Go bang if we run VCPU1 before VCPU0 */
+	GUEST_ASSERT(READ_ONCE(lpi_ist_ready));
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	if (!vcpu_id) {
+		gicv5_send_lpi(LPI_TEST_TO_VPE1);
+		GUEST_SYNC(GUEST_CMD_LPI_SENT);
+	}
+
+	while (1)
+		wfi();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -277,6 +421,48 @@ static void vgic_v5_spi_line_vm_create(struct vm_gic *=
v,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 }
=20
+static void vgic_v5_lpi_vm_create(struct vm_gic *v,
+				  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS])
+{
+	unsigned int nr_lpi_ist_pages;
+	u64 attr;
+	int i;
+
+	v->gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v->vm =3D __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_LPI_NR_VCPUS, 0);
+	v->gic_fd =3D kvm_create_device(v->vm, v->gic_dev_type);
+
+	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++) {
+		vcpus[i] =3D vm_vcpu_add(v->vm, i, guest_lpi_code);
+		TEST_ASSERT(vcpus[i], "Failed to create vCPU");
+	}
+
+	vm_init_descriptor_tables(v->vm);
+	vm_install_exception_handler(v->vm, VECTOR_IRQ_CURRENT,
+				     guest_lpi_irq_handler);
+
+	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	vgic_v5_map_irs(v->vm);
+
+	nr_lpi_ist_pages =3D vm_calc_num_guest_pages(v->vm->mode,
+						   VGIC_V5_LPI_IST_SIZE);
+	vm_userspace_mem_region_add(v->vm, VM_MEM_SRC_ANONYMOUS,
+				    VGIC_V5_LPI_IST_BASE_GPA,
+				    VGIC_V5_LPI_MEMSLOT,
+				    nr_lpi_ist_pages, 0);
+	/* Map the IST at VA =3D=3D IPA so the guest can program the same BASER. =
*/
+	virt_map(v->vm, VGIC_V5_LPI_IST_BASE_GPA,
+		 VGIC_V5_LPI_IST_BASE_GPA, nr_lpi_ist_pages);
+
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+}
+
 static void vgic_v5_run_spi_line_test(u32 nr_spis, u32 expected_spi,
 				      bool level_sensitive,
 				      bool lower_before_run)
@@ -1179,6 +1365,54 @@ static void test_vgic_v5_spis(void)
 	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 2, true, false);
 }
=20
+static void test_vgic_v5_lpis(void)
+{
+	struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS];
+	struct ucall uc;
+	struct vm_gic v;
+	int ret;
+
+	lpi_ist_ready =3D false;
+	vgic_v5_lpi_vm_create(&v, vcpus);
+	sync_global_to_guest(v.vm, lpi_ist_ready);
+
+	/* VPE0 programs a linear LPI IST from the virtual IRS ID registers. */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0");
+	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
+		    "GICv5 LPI vCPU0 did not become ready");
+
+	/* VPE1 observes the IST and enables the LPIs it will receive/send. */
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU1");
+	TEST_ASSERT(get_ucall(vcpus[1], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
+		    "GICv5 LPI vCPU1 did not become ready");
+
+	/* VPE0 sends an LPI to VPE1. */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0 sender");
+	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_LPI_SENT,
+		    "GICv5 LPI vCPU0 did not send LPI");
+
+	/* VPE1 consumes the LPI and replies with another LPI. */
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU1 receiver");
+	TEST_ASSERT(get_ucall(vcpus[1], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_LPI_REPLIED,
+		    "GICv5 LPI vCPU1 did not reply");
+
+	/* VPE0 consumes the reply LPI and ends the test. */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0 receiver");
+	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_DONE,
+		    "GICv5 LPI vCPU0 did not complete");
+
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V5).
  */
@@ -1233,6 +1467,9 @@ void run_tests(u32 gic_dev_type)
=20
 	pr_info("Test VGICv5 SPIs\n");
 	test_vgic_v5_spis();
+
+	pr_info("Test VGICv5 LPIs\n");
+	test_vgic_v5_lpis();
 }
=20
 int main(int ac, char **av)
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index 091d9dbd3c01d..2d455515563e0 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -80,6 +80,14 @@
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
=20
+#define GICV5_IRS_IDR2_ISTMD_SZ	GENMASK(19, 15)
+#define GICV5_IRS_IDR2_ISTMD		BIT(14)
+#define GICV5_IRS_IDR2_IST_L2SZ	GENMASK(13, 11)
+#define GICV5_IRS_IDR2_IST_LEVELS	BIT(10)
+#define GICV5_IRS_IDR2_MIN_LPI_ID_BITS	GENMASK(9, 6)
+#define GICV5_IRS_IDR2_LPI		BIT(5)
+#define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
+
 #define GICV5_IRS_CR0_IDLE		BIT(1)
 #define GICV5_IRS_CR0_IRSEN		BIT(0)
=20
@@ -94,6 +102,13 @@
 #define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
 #define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
 #define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
+#define GICV5_IRS_IST_CFGR_STRUCTURE	BIT(16)
+#define GICV5_IRS_IST_CFGR_ISTSZ	GENMASK(8, 7)
+#define GICV5_IRS_IST_CFGR_L2SZ	GENMASK(6, 5)
+#define GICV5_IRS_IST_CFGR_LPI_ID_BITS	GENMASK(4, 0)
+#define GICV5_IRS_IST_CFGR_ISTSZ_4	0b00
+#define GICV5_IRS_IST_CFGR_ISTSZ_8	0b01
+#define GICV5_IRS_IST_CFGR_ISTSZ_16	0b10
=20
 /*
  * Definitions for GICv5 instructions for the Current Domain
@@ -164,6 +179,7 @@
=20
 #define GICV5_HWIRQ_TYPE		GENMASK_ULL(31, 29)
 #define GICV5_HWIRQ_ID			GENMASK_ULL(23, 0)
+#define GICV5_HWIRQ_TYPE_LPI		0x2
 #define GICV5_HWIRQ_TYPE_SPI		0x3
=20
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
--=20
2.34.1
