Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013036.outbound.protection.outlook.com [52.101.83.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514C714A4CC
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 17:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544236; cv=fail; b=aXersNAn8GHEtVRHkM9TdW6WuzgQz5dHT2/1P+siVi6gcLD3YcYZkxJp5hnSBV9o4illgqTGv1YfU3VISUJC4EL6zecYjYgicMLdsig/uPEsIWtffbKVBQo0ujlostThbPsW8y4UUY0g+Pl8gVQkx/ncipc+SfZku4JEXRrpKAI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544236; c=relaxed/simple;
	bh=AVXrHG0zb53WL2j0FjjDigV4fInRew4wVORGSKrCkcA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ddSV1VmUleueilGkfSQFKoOT5d6VMaDNAa5OAVrG1NJAtTxDohapgBIzny/2oifWJtDuv8COpgFnqLRr+UUXwJfwNscgzRV1W4knpg3esqGb9+H1ltmVMRyIZMl+aNyrAc81TvIrirN7wLR+XZ9H0RQbVi0BJ19pFIXdidCpL1M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ipHgp5cD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ipHgp5cD; arc=fail smtp.client-ip=52.101.83.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ipHgp5cD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ipHgp5cD"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=if5+T+WDWTfZ2aBSsZfvdWrygKyjPcmkXB3+oZR87z8mX22pRPhsKClNPQaMGp1/MomdimeRI839I2Ffh6tPZ6iwbmwMpYskYt9qy/bhU2HZm2hH5U5mp9+nzTenidRKfWLu5+wbElcKsJO8qGyab+R0IGCY00kR075H02I+pKwSAOuN8mNzHgtx3oc2qIruRXXOQI+MxyJWCkCidM/XtPA4xi8+5R2OoXZs1YlI6QjlqWPrETtAX3o7cOZRemGFEJLEJ0A7Gcm7KOODrJkjl8JWAHFGt/xZeI97XzhxEwh6VMZFHtY0CmiM7pZmPR36ch6dT1ucpBWPMwpTIb/ixw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Au9qBZSrPRP2TCzcQEmbtWXMpirGXIvPss+5U++NW5s=;
 b=wXkV+gZWkIm7JWTKJhVj94By2FKSsWlcZBWAByAweJBZ+dqgVAk/Q3lANDvO8bgPg1CyxkhxLBLtugGGVPA9x9ua9smWUgHG/as3X62NSGMhuy7IeYHe1K5n1Ko8b3ttDYJdk30SMihVaeVkCsKutw3ozineVcBUtncpVgriFGm/Ek4OK/u3+E05k4zip3YvAV8y8ECkM1KTa6tESd44I43oNbHcoEIbyOJz2w/2uPcGQVvkfoVtNYAcq5JiHWB3QPvdmH65NmmhOt3SQKWylmz5kaBo3uq5Go/aovW7bqp4X8s98AyUQy5vq8m+aINTdBp8YQw0AXVXkg7Lu7CEwQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Au9qBZSrPRP2TCzcQEmbtWXMpirGXIvPss+5U++NW5s=;
 b=ipHgp5cD5YN5ygyDxzUiMT9vFA2KOZwDTpWHA3MJL1W8QBfl0rSAEw7YaHjZXd9oWO+sMW2GHY324pSnakm3xpaVplzzkbSC+FUSWzepHgcP1ZGzy3xx0F0AockqYQQjgJxHRsyxeESdIpIBykwnO2SQyqFR+u0XbW6z+4f10j0=
Received: from DU6P191CA0004.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::21)
 by AM7PR08MB5381.eurprd08.prod.outlook.com (2603:10a6:20b:105::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 17:50:29 +0000
Received: from DB1PEPF00050A00.eurprd03.prod.outlook.com
 (2603:10a6:10:540:cafe::3d) by DU6P191CA0004.outlook.office365.com
 (2603:10a6:10:540::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 17:50:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A00.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 17:50:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvqqPED8N4VIpiJJLhyC6hibQxMf1Xa5RP5smx6yzokXEQCFRrdnHfkSAYvVCPJUK6R6nPr0Gatbhw+1f5dipuQ6tiintXE1a2WELdG/ne35GTN5KkwnAUbIgWO05mrl/IJ4W+PkmFpPuO6WRZ3OJTIhvtQVutrHj0aEILhrhoU4gjGtR/O3be6/zshd7t1/dikGYxz69y1RfaLS58g5JZgwMFWJfJURIqXpk3TzAHg95aYCBc3HnI3AixQAoSQg463I/5WuQ8VUmQc8TTnyUvnHkzDqn58P/KgXTNAbuMl0Dgy7CQgD/PoOemodQbZkhmw+lRfd5nsF6HO/aIn+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Au9qBZSrPRP2TCzcQEmbtWXMpirGXIvPss+5U++NW5s=;
 b=oZmJp+Zn8VcPPeQivWOg6oZYuDBm5CESOfHkgwu9lSbXXMbI5NrwcO012boo0w59ARBysVTwZ/RI0vECseZ8titjHc4p4sFlG96B3tO6KAZiGHWnt2CF7XaMdozW8tMmCvjyJ/HL2ew2wDaYsj00REkuuhu3okgtxXQ/dZnrtqm15MSjOv1xS6lL0c3AZN4IS7Elxfl/6VsEnUmHZYnAyygbwhqb5Aa2+oDi8gNDsQu2wGWg1I0ABbYfLTEANvR4zq/XzXXgzfBlt9bHAdnzpYUiO9nlMF03ZTq74l8BW4Bh5MttwfKxZ8srym48qFIfjRUWc+aLq1h/WjhPZwORLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Au9qBZSrPRP2TCzcQEmbtWXMpirGXIvPss+5U++NW5s=;
 b=ipHgp5cD5YN5ygyDxzUiMT9vFA2KOZwDTpWHA3MJL1W8QBfl0rSAEw7YaHjZXd9oWO+sMW2GHY324pSnakm3xpaVplzzkbSC+FUSWzepHgcP1ZGzy3xx0F0AockqYQQjgJxHRsyxeESdIpIBykwnO2SQyqFR+u0XbW6z+4f10j0=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS1PR08MB7633.eurprd08.prod.outlook.com (2603:10a6:20b:475::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 17:49:56 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 17:49:56 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: nd <nd@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "maz@kernel.org"
	<maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 2/2] arm64: tools: Fix GIC CDEOI instruction encoding
Thread-Topic: [PATCH 2/2] arm64: tools: Fix GIC CDEOI instruction encoding
Thread-Index: AQHdPJXMBL9BacxRjUytKyltfwcvSg==
Date: Fri, 4 Sep 2026 17:49:56 +0000
Message-ID: <20260904174855.76185-3-sascha.bischoff@arm.com>
References: <20260904174855.76185-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904174855.76185-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS1PR08MB7633:EE_|DB1PEPF00050A00:EE_|AM7PR08MB5381:EE_
X-MS-Office365-Filtering-Correlation-Id: a0490b39-06b4-479a-ab2e-08df0aad0205
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|10067099003|22082099003|56012099006|11063799006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 Z2VsFk5yy87RPgyqIuJlkVZf4WiWLChwPlBCVj3CuvsCwWJmhGoZ3HCyP3QJQs/8Z+1R7WBILyJPBjTLBxYM2PSaSSowSzqeA+jX/gEym4HPl/nMH+tMFZ8NbrLn2uEFFqejguN6V/MvWMbAfkEnO7QJ4h5/FZhF/U8B2AamtnsarlC3Xm82YQJLiUW1GhkX6SddMv2c+Ozn8bK5gsls52XBDG3FVPUIOg+mUs2ytkrGCSt4cWeTrdIrO18fMyXwf9MBiNL9EkJHdtupIDZf/5t8du/6UqZPHmalMoYp8E7XcxLOqP098fopaqPikQbYkJTjeuXcfQRzXXzoHYLIzAevfgy8SOrqyp6aPT4heEVgogzhKlSLc3KBe/VxfsAaQK5oAusAN//SnHcs/2pWyxumumkZRe1XR8CdddBAv40nIHu6vIAthmtFLp/FTVMvJcdcvFY7Z5K9JY/dFnp5ld+qz6Sr33KqeWtZjXGvtLuCeAfi8bjSC+83B3uFRIf0lY8/z6qPnghAnYCK8mpEst2k0PHFd2YqAN9065LqR9vs91rpx4xtsPX4rkpQ0vhwahfiduU3gTT7i0HSeoeDFYyGan+Z+VPgXOT/cJsa23atl5ikunifbByrGVMmZAKtVj6G2BD4vG4wF49Ya2z0KySvgkaZAGXcLqRCRcmziLZW0eEu05VKJBpuIR2uHEYJgq1csAh6HnKb4tlDyC1bz9ES+VKf0/AhzZufK7CdOCw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(10067099003)(22082099003)(56012099006)(11063799006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 KEplQrO9apY/aD+cOht4L++cSEK0OqLgZnlZg1mKVwfFHLgvfU7HnU5PSlfWD+FIIcbLNhsw1iQ6wVTTedRS6m0Wm9DSyAes053jnwyE6v0lQVp/3rp7oMSYSirKk+LtT9Rah87Xo1gXSiN6sBjDZd8LfB5PhPvvIJwUNM2eluGiVsNAFv2KXKSn8USwuqnD6A49Irh2XAZfPCMife/uwzZ4TWvx/VIo3UJrbbelyQai7+7fmML6thHwzBHgHCKZlTHrKYi+VXSWhIP0LKX8wMEfdluJhbXQ+89eTUhj/OO0JCk5QRR0FmGybMwnXuY2782hfpuZMZgm9vvfQsYEew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7633
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	998cd1b0-758b-488e-f0f5-08df0aacee8e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|35042699022|36860700016|1800799024|82310400026|14060799003|11063799006|10067099003|6133799003|22082099003|18002099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	cbAa8pyNzVHgIUGAYL+CaNBI1j+mn1Ltw+XeZ4wqYExTyU1A6tbrgXP1UteIBDAIaS5Gdvg5Ieg7+XifYNWa5K2YuLV98FFaePn8Whu1X92a6SMY+1O1oR4bo59cIMVgT32P1PRqXmEu/7VgR+HY1s8sE91hH+17TSNUjvHV2yI4yfvAof2TL9PSe1YcscAVh+C+TLEt7Ac8FxWSiyYjGP6tNpYn0GZaBxZ33Xj83XPQUdzOGAQUxKnhYE0wKAViTmsRYAYa0QDnmqwzkUePqESzxco3dxAki+nZxZWRnzBCV+DQNNC+o06ae48r+2bdnl2JsqnOhFwlp/Y46gebEQ7oO8Hdj6Igsmd//H9FGBBP7Qw4e8V1Ai/vzumt416BD4oazuJTR8gqu1Ufq13zLbj22//Zlsi/yZm+CH8V+7hq02F2nPi8lbGRHsGgPHlBh399tDwSzWp2hStGvonH/9WpCqtsJaeyXZZuAJW1kaT17kHY60xrMbaSrWwai1H2EJtyCa1qOOeEf5DQwQBe1ur1N6QWN9DVV9hPRc9HexKxUXbXtbVVBN7OY7qfKsBNu/Y4ENuuPknklF7gb1cC3fe7aUHdwVm8ssm5YcV+OgevHsc+IHPRwHSjgfbY2sRcdu6NjGaqCsCSTfVgYxtxHfazKUT4k89JdP0WdvDLQWY=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(35042699022)(36860700016)(1800799024)(82310400026)(14060799003)(11063799006)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iEaO9RB/BQZRoARvyj4KBrusvHWC6I/6aJ46JgLATvWY57OA0ldmGJthKcIN6/XjIFLRm2OzRtSYwH3zxmM3ubPRDSOoXa3yMRz2C1y89GTEA4IwVTND/6Snugz071ZlbwNAIVswrpxqdmvNB95fG17vlaVKib+c+oPmXA+ONgv4wmBeGLPJTlgLGghvASe0hqgO5ILlHMxwy6o3V/cTml9/sA1HVwUbv1eTcrJiKS07T+P4W8cyP4cGYg3b+AeweWRyAnHiXJRgsJ45KU3db01c93gXViE8isfQVWjo5QEwfk/IebV+rSPPlC6RhzApSeatuM/cCA60gv004WAeghsgzhsKZHvygX1OZ3OUBWj3oXLnQhDsCk4UKXEm+ODhGa9uIBP40ueDhDbderBPZH45yEeuJ6aVervgjX62xW6NdXxKDn+BHZ8QSTJbyi+n
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 17:50:28.8418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0490b39-06b4-479a-ab2e-08df0aad0205
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5381

The tools copy of write_sysreg_s() relies on the "rZ" constraint with
the "%x0" modifier to select XZR for a constant zero. LLVM does not
understand this combination and can select another general-purpose
register instead.

The GICv5 PPI selftest emits CDEOI through the tools copy. Its Rt field
must select XZR, so using another register results in unpredictable
behaviour.

Mirror the kernel implementation so that a constant zero selects XZR
regardless of the optimisation level.

Fixes: 0a9f38bf612b ("KVM: arm64: selftests: Introduce a minimal GICv5 PPI =
selftest")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260807173928.3F6731F000E9@smtp.kernel.org
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/arch/arm64/include/asm/sysreg.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/inclu=
de/asm/sysreg.h
index f75efe98e9df3..342790d13f788 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -1152,10 +1152,19 @@
 	__val;								\
 })
=20
+/*
+ * The "Z" constraint combined with the "%x0" template should be enough
+ * to force XZR generation if (v) is a constant 0 value but LLVM does not
+ * yet understand that modifier/constraint combo so a conditional is requi=
red
+ * to nudge the compiler into using XZR as a source for a 0 constant value=
.
+ */
 #define write_sysreg_s(v, r) do {					\
 	u64 __val =3D (u64)(v);						\
 	u32 __maybe_unused __check_r =3D (u32)(r);			\
-	asm volatile(__msr_s(r, "%x0") : : "rZ" (__val));		\
+	if (__builtin_constant_p(v) && (u64)(v) =3D=3D 0)			\
+		asm volatile(__msr_s(r, "xzr"));			\
+	else								\
+		asm volatile(__msr_s(r, "%x0") : : "r" (__val));	\
 } while (0)
=20
 /*
--=20
2.34.1
