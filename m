Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012056.outbound.protection.outlook.com [52.101.66.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE8E3112C0
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375407; cv=fail; b=c2KJT/8O1/KEFjLx7IMY1RE6EM/CIj0RBSgYnOIr6/Z41vHeUUjruBmJEpOE5D7u9DHYnCcHVaNDWK1w3gOyIzIB8v/3qM3Q1Qkh6+Safh59LOpQ5dq6HeKFpKTUDlljllhYW0RKrtmJBGHpVVh1tF+epOGB3cnZN331sQHD810=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375407; c=relaxed/simple;
	bh=cgLTExn/0dTE2MV3XP573SDzRp1xA9leFLgiPJ05S6Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p52voqddCrnS22eo1jjp9bH0TBa86zieSlyBQf7wFagPPMv4E+/S8TQtpNaLmLFgSVBNZqMkqddV49rURtaiQDQealA+WpOp90gpCVhQD5pvpmwIwFaqqsqG84botVXCsL54pXRG4Xkf62sb12QsNeFNlzSsKyZHchSQ8KS/iac=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WmTmsVTr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WmTmsVTr; arc=fail smtp.client-ip=52.101.66.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WmTmsVTr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WmTmsVTr"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=Ty2Ro/Sr49JaZSZV3fTvn0zdWiqIjrW/M8nyLu7Jqbt2YqFHo/LBwYZqTCDZnf1pZs0MD9Xo+9x509wkFDwpbIR3nyP9heuG+XlCKKvqXN0IWt9UWz3e0ChSkVAYanKSJQipIm/XAoFmLS7wofryvMP5XklsKa2KPSG2b4o/6dAVsD+YXI73+eJk7QwWUeexEEIhMkwuN1AtOjEegzuZBeFMzXx16cyHCiBAljK+wkaZnDX/CFxpHmM5xCXHSLlLhRoXfXkGiCl3NZ0wYft4w/VraMDe19Miw7O239Vyy0Zvk25CLLcq3ET9u+if1qWygj9yzuBfGuI7KnG2bfNWvg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=jab83TaK4XE9PoMU8+2tH+L8DjoDZ3zJliXI4EtwRuWmgZxe11RhnmD1KRFjc/OfjG4N8Es7fJV40O6mI2ahBRh8OMuHKkvwZUH7XEWUk1LkIgweHIUIbDWlsKvfssJKwsqlWb5JY0n6D8ijSwzH/zYdjtsCrRZ2hLVMNeDVZJdAqReDv+vrACuala4UDbCt+6CLjc7EpBRKNilzhvbXZfNL2cuRzUdNkGXnQ+NLZim/+6IICrI7vhbd1+ZfOPgRHZsbEWuQNV3mw/RY8HXfTuZ1OOXGeDjQ7uMJKbppUoMv6SvWc8QUtXeYCgKPyjQMdOjqxXt9B0pTa3TrOLdBJg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=WmTmsVTrq86vd4AFarKPlCq8sQI9leyzwZCBFgTsmFBVQyyF4zGfZE3LhTIPzYEFPg735PCksNf6Z80h0Bj5s/AZE0X9ESYcD3sKDTdcFV1yo1hYQ75tkaj74OGkp7tShbizKwiMPZbYHwEvEQMOnB6++pgFOO2R8Z01x4TwKtk=
Received: from DUZPR01CA0215.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b4::9) by DB4PR08MB8173.eurprd08.prod.outlook.com
 (2603:10a6:10:383::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:56:41 +0000
Received: from DB1PEPF000509E2.eurprd03.prod.outlook.com
 (2603:10a6:10:4b4:cafe::1c) by DUZPR01CA0215.outlook.office365.com
 (2603:10a6:10:4b4::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:56:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E2.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.11
 via Frontend Transport; Thu, 21 May 2026 14:56:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9/YKmoLV9WhOZ2m829ODz/XYOziuV407NPF+VTafS0sBGwh0CuJmyNQckdEIDrzdp8yTVhLGw9UJDNOSuLqNd5wP0K2wlHe4tHI4HOATQoNWPllr/qErRCP8i7vAvKJT3Iri0rlGX68prcRm/XLPqDaFTRVKko5T9gxtDLMF0sohUtxlGmnimUcebKoGpv/vQjZtWlxpET/wSOIfmLDFHHq/lnScrtWtBLFjiuLTzYyEAU6lhaYGMRWqizV6pwMLe2cdGYP0vqJXO8HHVuEgHEuwWgZ5JsaBeefqjh9pgBb9r6C8Tli6L7ys4l4RxtRPdAhFGQuQb5xC5znZysL7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=ZAUMHHv6ILByVewBnihwocnPcl67arO9HHiBJJsavdljeuCcbWDX8tbvwlU51MHa8+L/BIcE99kGJk2V2O7KJ3tRipx1kfvlvehlcnVhu9itzXmd6Y+zl3nOg6C8JyjOtJJbfC3YFX7xguUBnkDZDp5tU/BAjH+jMCN04pFet0coXBnKlm6uMiYBK8ZitfzmirzvzAq0uujAzWktpmczFAAV/K76c9o8HQzmOxj+b4lmKW9n6t2Y3mQwQPJpAFUFo/a7bOs5wmM5q0MHumpC3h9FdBZzm3rNEprs/ICYxl2bpvHNNCSBkV2OKisdLhlOXBtN0vfWT06iNDe/AL2JgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmWbwSu1taDmixq/EgXIRwL12LNFUjMssL/NHJHTkvY=;
 b=WmTmsVTrq86vd4AFarKPlCq8sQI9leyzwZCBFgTsmFBVQyyF4zGfZE3LhTIPzYEFPg735PCksNf6Z80h0Bj5s/AZE0X9ESYcD3sKDTdcFV1yo1hYQ75tkaj74OGkp7tShbizKwiMPZbYHwEvEQMOnB6++pgFOO2R8Z01x4TwKtk=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DB9PR08MB11461.eurprd08.prod.outlook.com (2603:10a6:10:608::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:55:39 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:55:39 +0000
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
Subject: [PATCH v2 19/39] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to
 UAPI
Thread-Topic: [PATCH v2 19/39] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Thread-Index: AQHc6THjFGmWQbZkZUKyoQWWd4vwyA==
Date: Thu, 21 May 2026 14:55:39 +0000
Message-ID: <20260521144846.1899475-20-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|DB9PR08MB11461:EE_|DB1PEPF000509E2:EE_|DB4PR08MB8173:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a9b4fe8-8794-499e-1770-08deb7492aff
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 gXdu3Y5TK4+RAvOwVZ6AH3yDZa6SkMlNXgOiICDEdIbyaWXBU5ZdLQ3reyj1083As7Cp73NHPKw9HTiLEo/0T96QOwWoRMi7sD7b0b5qhkU7YRVPQ5bU2dxEVPUB/8alCBClwauAp60bibgCg4nbP6X2hTuGMqg46I2Jeh/ZnnuD3uFBArilocLghNfrnxtWmbhbooGt1tVjRjK0gZsvpiMa59xKlGJqwca2LrYzdl5ccyvV+njJ7z0E1LrZflGXrp6VCKqLGb5jMUMpvGNXXfpbUeHS096jo1O4vxKvdl/hNnGJfWYd4rBdLhkat9mvGhf2SGfj7CzIQs4WGTMH4gLioxe9Xctc5D6Ns1t/pOiS+kAIMgGFooQ646HFG9wtlFIU1Ca4soxjKwQU6PiipEtE4nGx6s9IYZpn/tSkW89P7bLTDAZdRS80Ca6B2ysYVvAwrreR/xYEDhO5Xe9UhCDefhv6QPy2SPqxga7MBoS4XAEBhUiNq+Zqbf5/9ovf+nZIo28uMB1Jqnx2jNKHLbLhofDbcAL3p27rHMTfjryDMDzSEUIk0fh6D/D1wZQxJC8N8gnH0VDYjjzCT43EXfN2MCW7jrspT9fKXkIU+Y1fLYkn7bDOEHs2fUtU2NS2niv7Rroo5f2DR4xgjVkzBSQgnDVEAZzKoXIhsf3nOyIy0Kxv2H4hFl429OCKZVQrbHPvRyDdoUv2q9wRRHAjPbEdawqh2tKsnAZXBZ4CgVfBpPstRMn/2SJvUIRQ2MtB
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 nrbLnIRrfGoot3Kk0LWqnjKfej9PeO35twadZ5m9LcV+8KR713v9PoUgiQ4Ukmm3qhtkxicFpbR6Mue5JOXZqpSTh4boiOe6RpjUATXPzDaz30dasBsB3zSlib0OfkFYl0nwTqeRuQaz4ZioaVbD7hpEXSAgqhuqRpMX3wclc5BgOqVvLn3BqWNhVWgf/vIm6yFJ7mZ6Etiu5UMSq0RG2eYruPfzRpNPfzsMQ8Hb24EtGrWbou6CBMHqiC35UZDpTKIEP1EawlFV+vDMGRhIS2iFtkz6kfeS2PsdsZzU04B6xHCyKdU5XNlcrB+JS3TkdiUeLyrGj5JWOt2LodpoWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11461
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6b5d6b11-2671-4842-2b1f-08deb74905f3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|14060799003|82310400026|35042699022|18002099003|56012099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	YZePgNnW1+zJRu0gIMYC/Epq0NJb9nYaD5RYIiRAaVZ2PLdLBJdvMc4kMak47ZCREP+5oXkEmgZlBT5SYZRlBNRy3+EqyTgeGsWNAYWXjXqMFAZXmz4uXcQSRReMflsv6sE3yxCGXF42ZfHQ1kA8EXyM4m6yp1n28Yazv7dgZmwy62vGPb15Rf/pE5GJCl3Cbi9TuguJSFC0Udxx9q313+hFIgsoPOORtmVY33WnC7iEO1ywFc8DJg0J1vUEkNQgkySq2Vxe0DAcpC4jo51apsfjeDHv3MsvQbCnNDZn5dCo+0XJx9gCmZeyDVPWHvMeBPnhP4yv2f8UDPMWw4iekaCm/fyRB/r1oHSEPTOEUfPi14tXLXZ2bz8y9ax1ocj1h2sb91UKgqnKZH6xyjxwA8lNJNQqnOoLNG1Sw8K2bPaQ6V2gPoMffBbLluFYa72Utc65ampVtCQBDuG+IUeTrcIoxQynJMgS0x5ks671yD+IBhzRduIOhOgGU+DjTEnD7/IWdtlSVDNAEo7bGeiJZNbf1AYjfZhN39ho7Lr0gCaWbOYWU2jkWqNWhiJCirjTsXVAx+1X7OC0BrsMm0ALpB1jduZbqU6lE/qTtt0bVwpGMz0wsAMoO3MKEdQTJ6ubwEHIh71ejl+jTTbpicoNK0OxXqgcuHNcQuBNdY7TQN3HQIaMvGb2QcNXdJXTscTM/vmsaf3TAF1b3g0GEolPf/KSUmeEU8Dl/fqxisoYbWI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(14060799003)(82310400026)(35042699022)(18002099003)(56012099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	w5UxlQGRMEKDHsVFyLAPYYfHvhjIxgsEwzrIVMzTsTWthyQ/d3Nza9wMKY5ttIC2/rdpOoNkWio9dwpcKwPIkRjadu9NMtOq+00ns9sUXU/UeutQU49Doxqh/59Clp0VeVS+JuSV1ciR3yOo97TGzGV+KQV4vPtAscDu+fiERk1ck6P0GC8ZBGoBL3/NdG7lKbjcxZ+VGPvGcuojGFn2LkLcja5seW7maob5NktS7XUCsZwejN3hfM2jlP9h1uKnyf2c29ioVQlhRJLIEjVtXXO0U1RiVH8jLWqMAH6jpCJTsK0JzFXu1xoCQ8DgBCW2aqS3JlHzarBySW50QFSLsbFhhDmt7dXYiWPHouGXTR6BGwQVQXSAOpEqvisLlhMuUpYwt8HNNupHkInuDZJ2OSORUOUier2Ho4iUzFAgJh3wEtv4jqSLkZo8fyKokRy0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:56:41.4057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9b4fe8-8794-499e-1770-08deb7492aff
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8173

Define the UAPI address type used by userspace to describe the
location of the emulated IRS in guest physical address space, together
with the size reserved for that region.

As per the GICv5 specification, the IRS has one CONFIG_FRAME and
optionally one SETLPI_FRAME per interrupt domain. Within a KVM VM we
are only concerned with one interrupt domain. Each of these frames is
64kB in size, so reserve 2x64kB of contiguous memory in the GPA space
for a GICv5 IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       | 5 +++++
 tools/arch/arm64/include/uapi/asm/kvm.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
--=20
2.34.1
