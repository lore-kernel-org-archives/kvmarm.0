Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011044.outbound.protection.outlook.com [40.107.130.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94033D9029
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521827; cv=fail; b=HkB1x5zzztTDTlA2OV9huOtPiKiz2eUnfe0jLJwP0c4uhfXO2gO2SdchgW+Hz6wKCr+u7NUu2UP72RBXtlF/mt9ib+/cJoszVhwE8B5jD42g05tZWprU/h0IBkC24KhRjd9Bd+j+tiFNlYKRiMJJyLY9tRp7ZuPHsaSkGejOvO8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521827; c=relaxed/simple;
	bh=Cc5YNExIz1QfPDHRcnJxyM8UKFypJy9mnWipQf5zdxQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZiT9iq+id0pWy1+HQ1o63bxKPdNlfjTTJDQ8iHpPMq1YrSXJhGQeZZrpa39WyL/fEnA5jxfUGGstyt5tjhY+lIj23ba/HQzc7wNIzFoPxENRKTkzm09GC2WFDMbXrCQ+R9LC/pfi/TgiLxmL8aEkpeOBU8sfEOP6d0n8l/yOAD0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Hp7ib/6e; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Hp7ib/6e; arc=fail smtp.client-ip=40.107.130.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Hp7ib/6e";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Hp7ib/6e"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cqEk89m2FUJS/OSusgLvkpRGL4xq/I6KHvRW28Pg41nVKoPfdE48f9BU/fZatOvJ88FXcM5MCpKR8yXjYnfqMDFffAYWIsXyKbzXtxqD5Bq4Kge4TlzdY8ck1+FMMmKx39ux17y5fAkk9m+oaBirIQkvCo01r7b+oE1RoyAazcFGdl3dsQiWawC7W5eEOjtu9JCO5zJnxQJ4cxX8V/r4oRdq7of2t1rGqxjmfDq+DYO8CaSIlgGSFG6ANkGXgEg5wVzNWFMTbMYEh4FDjrF3tMdNn+cQHMBAPgaZN0RlH9nnUgZ2zJzfBGNHKXJgPFIWqsq/kHlnbpJaKCHy1SIkUg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIFQF9a5G87BQNZj00Ox7mBcLxs5QvUl0fGhOOf2AIc=;
 b=HZ7tfeUy4niZ7B9Bhdc3lcMG5o6mYwUt9/VPdjw0RPWTmBmYh7LE1jet9jxvE05iDIuA6NRKuxL/i5Wmf24eH1OzZqJ2Jmk6tdJblFFjNj7PrlUtnr7UCRSQ1hRzIkvuM8GykU5yYeAiIOIb+myR3NjPLuHRiwlQstt3wKqgyAfuSJP0iw9JsW4cOsSQHe3LvG+m5sYxRSXIRxoWZ0f/9Vxk0COh+dEhfRwB7Dh/oW29ZHLPtsEVTU6fT+gOclSe4ALfZzxoUtPUYu4EWz99ZDADsqvVMHM/Ix7P7+kFbldJDc2o8Hh5t7OAFGn0bjQx/8KoMtiZ87UBH1vxlGOWkA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIFQF9a5G87BQNZj00Ox7mBcLxs5QvUl0fGhOOf2AIc=;
 b=Hp7ib/6eQJ76IHNHS3ilMsWM3iTKmsI+y0itm91exmIw3dkpqGhKBqc+XLLXYBYtq+1hS2fwUHapBz0ikg2SqljhgwsZjDcyoKrMj0rnuvonTFHE+amGuW505UXIpy6DxDqFteRHdP/g8qwhRMOT9iWgnUlv4enU9leeRFc0Qo8=
Received: from AS4P191CA0011.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::9)
 by PAVPR08MB9457.eurprd08.prod.outlook.com (2603:10a6:102:319::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:36:55 +0000
Received: from DB3PEPF0000885C.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::1) by AS4P191CA0011.outlook.office365.com
 (2603:10a6:20b:5d5::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:36:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885C.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:36:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDrNoUd4zHRCsNmLUzh0TmD382XsujCzEqgvzbxO/YjjmBbgckD6c7NaY1bFF17Jkyefi9ikKtl28jOvYxCILzmToDLb9wPsVYv1/noOvGtBQl3zHCNfgjtyiZk6o6oZZdcM4cusbKpSA66MpuqJkoxLSdGKa5iASGRuUVZ3aGF3hyZUfS0WC6hQud53isU00niB3+8sNq5lBJvAY/Fim/ZimFcD3QDo5a0ZH2kWCYqMXvSGrfp4tyPKWuUamP34v/ejXck3H3N4rCleQulQA2kOyCNRrmrzuDYHKgTrGnnno+OC45LnaVvBQhFT2esTbAEz50B5inbmVqsncMgilA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIFQF9a5G87BQNZj00Ox7mBcLxs5QvUl0fGhOOf2AIc=;
 b=LLruLN+g9ZE6H4dQD7svkwXIbJS34Itgz3Ab7mq6JazTRMFT023xLMt976rVM1vENRjY+75+lsqHgiDoEROaAmUDlb0tcDHMswuHwVaKisvc15pEi3NxMwJ4HmiVnYd3DeNJOvIa0r9rdXL0XISNwf/2NKpG73jGIcev7RDV3MObLeJPjHDVK4MbMz+WrZmIj6kjWr9mKudX4ohNxc8p4Ql3uKyGMfxOyQzHhGBq5C+9kY9YVGaKlwsdN0eS10LrgeGEz9HEdiFP8kRTbKElokuvPlu95FpAVWV72HmRp0jEEENeNCBrS//nD4W0SVdONwTdmQbBKGK/CbRz3g7L6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIFQF9a5G87BQNZj00Ox7mBcLxs5QvUl0fGhOOf2AIc=;
 b=Hp7ib/6eQJ76IHNHS3ilMsWM3iTKmsI+y0itm91exmIw3dkpqGhKBqc+XLLXYBYtq+1hS2fwUHapBz0ikg2SqljhgwsZjDcyoKrMj0rnuvonTFHE+amGuW505UXIpy6DxDqFteRHdP/g8qwhRMOT9iWgnUlv4enU9leeRFc0Qo8=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI1PR08MB5504.eurprd08.prod.outlook.com (2603:10a6:803:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:36:19 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:36:19 +0000
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
Subject: [PATCH v6 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Topic: [PATCH v6 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Thread-Index: AQHdPGGaKRFdj+jhoUagR3mV+bN5KQ==
Date: Fri, 4 Sep 2026 11:36:18 +0000
Message-ID: <20260904113404.4051341-5-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|VI1PR08MB5504:EE_|DB3PEPF0000885C:EE_|PAVPR08MB9457:EE_
X-MS-Office365-Filtering-Correlation-Id: cbfd9a6b-b95c-43ac-766d-08df0a78d222
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|6133799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 hYNNN6AvnwZSr/+TnFgbGotjx0njD+Tl/7A2qajIcH068Rnq9G4OurLAYHAEsmBeBFS7hSh2OFisVZD87TZaExEjlmsV5ZV0EYf9bGfX0rWkpNOqDpjypV3I4WqExQGGybjfgUrleU4K1ooluZ9gxCaXNeYQuzsJ4NI8xC1vYtszSg+652plw13ZP5CCMh6ZhQKNskyoPKr5nQC2Ag+zNgImjupUmioKINVrb1Oye45Zmn8f7zAW0Redu83Au5EoVqAEYyhPAbQ+K//BhZM29cV3DugpSS9dTwsmF/1StIs1qqlj6iRA3kdN8kU5RFh+TczQBWFWITwnQmAU0w+EvQ93Gzhbu2hbmTAhl2c0dy4NYXv6pQtBM+8rp0EZKuTuRc6kIA1cdjNbgHktPyTxpnpr+n4YaqQd2Kn6TgtvuUgxAAJELaAs1yRcyKsHlFPsedllA/8rTShwGKwGDhzBvzkNiKO1fYcS2uwt6/dADS61wmBm1RBmfrks6X/I8z+2bRrzgCpGhQcVVXt6gL58p4WlNx5bpugMu6JRS5YCzdWNXct/k77juJfRuql2nTkZ0Mv0ZoikDDRnBauolWkHDQx93Kfky8vbbl4tW8maC/ohq/Gis6jNHipPYLPE3N1uNdnd5T6MANSoSY8eBkbCU4Zfa/xaQEDRu0j0Zm+YfMqkG0pehanf9xoPmRs85Y7TE2n+eThVw6WAb4EmDuIx4rA/L4rjzZDdTf6YeGa96Hw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Vz51tqdytYZm+1ZH1XoCkQgOrscPsnL/nh8x1dPDVBvNQ3DIFu0YSzIzfjO0qMPXvEgYjv4NzHdsaGmgkOd8rwnMGYq+R/3xpSAX1WUJSOlI0305aQO4RHtbkxDhgef55SkLiGaOZ+30NedkpgSOy1mP0fJTedDnTt4HUyrTuqC3PyVfvrboD8bY+K/cIZ1RXU+5kVAmWxfz1A1lcUIbvGl2DgiqDCAX1CLJRkwbF3KQ9Iw4rwJZF6TEIiXf/W6BAMsXx2ZRZO1VQbeNiDJN2RRsIXpuyc69GrIecfHqbf606K7lL8b1PiU5rxmfPRVp7sYAvk6bT2APeN4Znterbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5504
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1596505e-599b-4638-f6f6-08df0a78bccd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|36860700016|376014|1800799024|14060799003|23010399003|10067099003|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QRMoP/J7z5I938Kr8la+1A+/S1h6anRW1i1fir7Z8hNhfU0ngf/Zr+e6pl4ke6kBIcHoybtQX4eIgMpDorIS5b2LjIr1m0Y4HWLmm10pSfx90Lll/LDR3LD5i2a9Rdj+KmU1GUM8Sg2SoI/fsW0z4EiRxtSjDnRGZTzey+Yn97Ug9kFOIPaAba7hlak1XcjsKzuI6pefeLmwk5n4dT0M2eOj3YdCmu4W3oeKejsE2DWwJbYo/PWM+2wvxChbQeAn3dfgHJguwrARuPcdgAAbiGDFlbf45S6LuYl1tEjwqCHzyWdNDG8DIkwJnMzdwVhV3BCCGNpzuyBxVhW/ohJ1XymoeOhgK37ruumaGPDg5oA2SI5plaio08QNf9YeI5XiwWXYhXUsS3QxHtbnRbvtyYPKuQI27Pi0Nx6fA3dogyiZEZCNQcxMZnVhQLj4CChYH4L2mFn2QmjjvCG7wlUGn6t9xOx9497jWjYo09JM637IzAHbwN8cs4HoWxl0oJKx1NWO/d6iApb1/zJ5zJAr1Dhu1Mti6Ec9rtQ6x1L2ZbejOuBz2WAW9adG5oG4wkzPFCxnoVAGCw14VI02H9Sk1236JgNm6H5t0RnFLN/e+SoA7DHirMljnwHOT2BkBujvSZGUj2abgpDueM22xM6BgX4pmqXVYAMIsOyEfdndiYk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(36860700016)(376014)(1800799024)(14060799003)(23010399003)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GRsRdDcQ89fIMGtty6lx7SUeEtsh0mgOm3yl5hHGShO2xSz7s9Vb3V6fptyw/tv8VEpx4WYLaBkHz2x5SZ3/87s1PUbPEShqnR7LW2B9qKCWSEgUkIEl/WtJcAfK7AZhj7bSAbhWpxpxSvEacwKfRdpg/dlAKExxoRGWy6vXyMhgvj61xL1Izm4atUOkxLgYABsPcR4o4wQTHjj4+i5Yn0MbBFPVuzAHYBr6Bj9mT4DwgXR8Kz6rBBXTARnU9TkTKztdGE9zNcai3fh9thlUjREFgB7yG53IK1HJ65qwTkY8REu3RB3TztQ60AG21pqfNbPqodjUW8aB6q4hXehB41kLDhFOawSEoTRPraLRyUUOl7sDLPl3neGgHfyySGEMUeox2Zi5AMdtMnoDa84VBiUXF/ocjvviWekA0MIj80pQdMFdSgRykKIMyCrtj4vq
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:36:54.6597
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbfd9a6b-b95c-43ac-766d-08df0a78d222
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9457

Complete the set of defined IRS MMIO registers in the GICv5 header
file. Up until now, the set of defined IRS MMIO registers has been
driven by code requirements. However, in order to properly emulate the
IRS MMIO interface in KVM, the full set of IRS MMIO registers needs to
be added.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/linux/irqchip/arm-gic-v5.h | 239 +++++++++++++++++++++++++++--
 1 file changed, 230 insertions(+), 9 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 59a5875854319..8dc5847a646eb 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -63,20 +63,34 @@
 #define GICV5_OUTER_SHARE		0b10
 #define GICV5_INNER_SHARE		0b11
=20
+#define GICV5_AIDR_COMPONENT_IRS	0b00
+#define GICV5_AIDR_COMPONENT_ITS	0b01
+#define GICV5_AIDR_COMPONENT_IWB	0b10
+
+#define GICV5_AIDR_ARCH_MAJ_REV_V5	0
+#define GICV5_AIDR_ARCH_MIN_REV_V0	0
+
 /*
  * IRS registers and tables structures
  */
 #define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
+#define GICV5_IRS_IDR3			0x000c
+#define GICV5_IRS_IDR4			0x0010
 #define GICV5_IRS_IDR5			0x0014
 #define GICV5_IRS_IDR6			0x0018
 #define GICV5_IRS_IDR7			0x001c
+#define GICV5_IRS_IIDR			0x0040
+#define GICV5_IRS_AIDR			0x0044
 #define GICV5_IRS_CR0			0x0080
 #define GICV5_IRS_CR1			0x0084
 #define GICV5_IRS_SYNCR			0x00c0
 #define GICV5_IRS_SYNC_STATUSR		0x00c4
+#define GICV5_IRS_SPI_VMR		0x0100
 #define GICV5_IRS_SPI_SELR		0x0108
+#define GICV5_IRS_SPI_DOMAINR		0x010c
+#define GICV5_IRS_SPI_RESAMPLER		0x0110
 #define GICV5_IRS_SPI_CFGR		0x0114
 #define GICV5_IRS_SPI_STATUSR		0x0118
 #define GICV5_IRS_PE_SELR		0x0140
@@ -86,11 +100,51 @@
 #define GICV5_IRS_IST_CFGR		0x0190
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
-
+#define GICV5_IRS_VMT_BASER		0x0200
+#define GICV5_IRS_VMT_CFGR		0x0210
+#define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VPE_SELR		0x0240
+#define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_HPPIR		0x0250
+#define GICV5_IRS_VPE_CR0		0x0258
+#define GICV5_IRS_VPE_STATUSR		0x025c
+#define GICV5_IRS_VM_DBR		0x0280
+#define GICV5_IRS_VM_SELR		0x0288
+#define GICV5_IRS_VM_STATUSR		0x028c
+#define GICV5_IRS_VMAP_L2_VMTR		0x02c0
+#define GICV5_IRS_VMAP_VMR		0x02c8
+#define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_L2_VISTR		0x02d8
+#define GICV5_IRS_VMAP_VPER		0x02e0
+#define GICV5_IRS_SAVE_VMR		0x0300
+#define GICV5_IRS_SAVE_VM_STATUSR	0x0308
+#define GICV5_IRS_MEC_IDR		0x0340
+#define GICV5_IRS_MEC_MECID_R		0x0344
+#define GICV5_IRS_MPAM_IDR		0x0380
+#define GICV5_IRS_MPAM_PARTID_R		0x0384
+#define GICV5_IRS_SWERR_STATUSR		0x03c0
+#define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
+#define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
+
+#define GICV5_IRS_IDR0_IRSID		GENMASK(31, 16)
+#define GICV5_IRS_IDR0_SWE		BIT(12)
+#define GICV5_IRS_IDR0_MPAM		BIT(11)
+#define GICV5_IRS_IDR0_MEC		BIT(10)
+#define GICV5_IRS_IDR0_SETLPI		BIT(9)
+#define GICV5_IRS_IDR0_VIRT_ONE_N	BIT(8)
+#define GICV5_IRS_IDR0_ONE_N		BIT(7)
 #define GICV5_IRS_IDR0_VIRT		BIT(6)
+#define GICV5_IRS_IDR0_PA_RANGE		GENMASK(5, 2)
+#define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
+
+#define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
+#define GICV5_IRS_IDR0_INT_DOM_NON_SECURE	0b01
+#define GICV5_IRS_IDR0_INT_DOM_EL3		0b10
+#define GICV5_IRS_IDR0_INT_DOM_REALM		0b11
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
+#define GICV5_IRS_IDR1_PE_CNT		GENMASK(15, 0)
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS_1BITS	0b000
 #define GICV5_IRS_IDR1_PRIORITY_BITS_2BITS	0b001
@@ -106,13 +160,30 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+
+#define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
+#define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
+#define GICV5_IRS_IDR3_VMD_SZ		GENMASK(4, 1)
+#define GICV5_IRS_IDR3_VMD		BIT(0)
+
+#define GICV5_IRS_IDR4_VPE_ID_BITS	GENMASK(9, 6)
+#define GICV5_IRS_IDR4_VPED_SZ		GENMASK(5, 0)
+
 #define GICV5_IRS_IDR5_SPI_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR6_SPI_IRS_RANGE	GENMASK(24, 0)
 #define GICV5_IRS_IDR7_SPI_BASE		GENMASK(23, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IIDR_PRODUCT_ID	GENMASK(31, 20)
+#define GICV5_IRS_IIDR_VARIANT		GENMASK(19, 16)
+#define GICV5_IRS_IIDR_REVISION		GENMASK(15, 12)
+#define GICV5_IRS_IIDR_IMPLEMENTER	GENMASK(11, 0)
+
+#define GICV5_IRS_AIDR_COMPONENT	GENMASK(11, 8)
+#define GICV5_IRS_AIDR_ARCHMAJORREV	GENMASK(7, 4)
+#define GICV5_IRS_AIDR_ARCHMINORREV	GENMASK(3, 0)
=20
 #define GICV5_IRS_CR0_IDLE		BIT(1)
 #define GICV5_IRS_CR0_IRSEN		BIT(0)
@@ -135,21 +206,39 @@
=20
 #define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
=20
-#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
-#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SPI_VMR_VIRT		BIT_ULL(63)
+#define GICV5_IRS_SPI_VMR_VM_ID		GENMASK_ULL(15, 0)
=20
 #define GICV5_IRS_SPI_SELR_ID		GENMASK(23, 0)
=20
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN	GENMASK(1, 0)
+
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_SECURE	0b00
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE	0b01
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_EL3	0b10
+#define GICV5_IRS_SPI_DOMAINR_DOMAIN_REALM	0b11
+
+#define GICV5_IRS_SPI_RESAMPLER_ID	GENMASK(23, 0)
+
 #define GICV5_IRS_SPI_CFGR_TM		BIT(0)
=20
+#define GICV5_IRS_SPI_CFGR_TM_EDGE	0b0
+#define GICV5_IRS_SPI_CFGR_TM_LEVEL	0b1
+
+#define GICV5_IRS_SPI_STATUSR_V		BIT(1)
+#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+
 #define GICV5_IRS_PE_SELR_IAFFID	GENMASK(15, 0)
=20
+#define GICV5_IRS_PE_STATUSR_ONLINE	BIT(2)
 #define GICV5_IRS_PE_STATUSR_V		BIT(1)
 #define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_PE_CR0_DPS		BIT(0)
=20
-#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
+#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
=20
 #define GICV5_IRS_IST_CFGR_STRUCTURE	BIT(16)
 #define GICV5_IRS_IST_CFGR_ISTSZ	GENMASK(8, 7)
@@ -167,15 +256,111 @@
 #define GICV5_IRS_IST_CFGR_L2SZ_16K	0b01
 #define GICV5_IRS_IST_CFGR_L2SZ_64K	0b10
=20
-#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
-#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
=20
 #define GICV5_IRS_MAP_L2_ISTR_ID	GENMASK(23, 0)
=20
+#define GICV5_IRS_VMT_BASER_ADDR	GENMASK_ULL(55, 3)
+#define GICV5_IRS_VMT_BASER_ADDR_SHIFT	3ULL
+#define GICV5_IRS_VMT_BASER_VALID	BIT_ULL(0)
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL	0b1
+#define GICV5_IRS_VMT_CFGR_STRUCTURE_LINEAR	0b0
+
+#define GICV5_IRS_VMT_CFGR_STRUCTURE	BIT(16)
+#define GICV5_IRS_VMT_CFGR_VM_ID_BITS	GENMASK(4, 0)
+
+#define GICV5_IRS_VMT_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VPE_SELR_S		BIT_ULL(63)
+#define GICV5_IRS_VPE_SELR_VPE_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VPE_SELR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VPE_DBR_DBV		BIT_ULL(63)
+#define GICV5_IRS_VPE_DBR_REQ_DB	BIT_ULL(62)
+#define GICV5_IRS_VPE_DBR_DBPM		GENMASK_ULL(36, 32)
+#define GICV5_IRS_VPE_DBR_INTID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_HPPIR_HPPIV	BIT_ULL(32)
+#define GICV5_IRS_VPE_HPPIR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VPE_HPPIR_ID		GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VPE_CR0_DPS		BIT(0)
+
+#define GICV5_IRS_VPE_STATUSR_V		BIT(1)
+#define GICV5_IRS_VPE_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VM_DBR_EN		BIT_ULL(63)
+#define GICV5_IRS_VM_DBR_VPE_ID		GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VM_SELR_VM_ID		GENMASK(15, 0)
+
+#define GICV5_IRS_VM_STATUSR_V		BIT(1)
+#define GICV5_IRS_VM_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_VMAP_L2_VMTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VMTR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VMR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VMR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VMR_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_VMAP_VISTR_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VISTR_U		BIT_ULL(62)
+#define GICV5_IRS_VMAP_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VISTR_TYPE	GENMASK_ULL(31, 29)
+
+#define GICV5_IRS_VMAP_L2_VISTR_M	BIT_ULL(63)
+#define GICV5_IRS_VMAP_L2_VISTR_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_L2_VISTR_TYPE	GENMASK_ULL(31, 29)
+#define GICV5_IRS_VMAP_L2_VISTR_ID	GENMASK_ULL(23, 0)
+
+#define GICV5_IRS_VMAP_VPER_M		BIT_ULL(63)
+#define GICV5_IRS_VMAP_VPER_VM_ID	GENMASK_ULL(47, 32)
+#define GICV5_IRS_VMAP_VPER_VPE_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SAVE_VMR_VM_ID	GENMASK_ULL(15, 0)
+#define GICV5_IRS_SAVE_VMR_Q		BIT_ULL(62)
+#define GICV5_IRS_SAVE_VMR_S		BIT_ULL(63)
+
+#define GICV5_IRS_SAVE_VM_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SAVE_VM_STATUSR_Q	BIT(1)
+
+#define GICV5_IRS_MEC_IDR_MECIDSIZE	GENMASK(3, 0)
+
+#define GICV5_IRS_MEC_MECID_R_MECID	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_IDR_HAS_MPAM_SP	BIT(24)
+#define GICV5_IRS_MPAM_IDR_PMG_MAX	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_IDR_PARTID_MAX	GENMASK(15, 0)
+
+#define GICV5_IRS_MPAM_PARTID_R_IDLE	BIT(31)
+#define GICV5_IRS_MPAM_PARTID_R_MPAM_SP	GENMASK(25, 24)
+#define GICV5_IRS_MPAM_PARTID_R_PMG	GENMASK(23, 16)
+#define GICV5_IRS_MPAM_PARTID_R_PARTID	GENMASK(15, 0)
+
+#define GICV5_IRS_SWERR_STATUSR_IMP_EC	GENMASK_ULL(31, 24)
+#define GICV5_IRS_SWERR_STATUSR_EC	GENMASK_ULL(23, 16)
+#define GICV5_IRS_SWERR_STATUSR_OF	BIT_ULL(3)
+#define GICV5_IRS_SWERR_STATUSR_S1V	BIT_ULL(2)
+#define GICV5_IRS_SWERR_STATUSR_S0V	BIT_ULL(1)
+#define GICV5_IRS_SWERR_STATUSR_V	BIT_ULL(0)
+
+#define GICV5_IRS_SWERR_SYNDROMER0_VIRTUAL	BIT_ULL(63)
+#define GICV5_IRS_SWERR_SYNDROMER0_TYPE		GENMASK_ULL(62, 60)
+#define GICV5_IRS_SWERR_SYNDROMER0_ID		GENMASK_ULL(55, 32)
+#define GICV5_IRS_SWERR_SYNDROMER0_VM_ID	GENMASK_ULL(15, 0)
+
+#define GICV5_IRS_SWERR_SYNDROMER1_ADDR	GENMASK_ULL(55, 3)
+
 #define GICV5_ISTL1E_VALID		BIT_ULL(0)
+#define GICV5_IRS_ISTL1E_SIZE		8UL
=20
 #define GICV5_ISTL1E_L2_ADDR_MASK	GENMASK_ULL(55, 12)
=20
+#define GICV5_IRS_SETLPIR		0x0000
+#define GICV5_IRS_SETLPIR_ID		GENMASK(23, 0)
+
 /*
  * ITS registers and tables structures
  */
@@ -297,6 +482,42 @@
 #define GICV5_GSI_IWB_FRAME_ID			GENMASK(28, 16)
 #define GICV5_GSI_IWB_WIRE			GENMASK(15, 0)
=20
+/*
+ * CoreSight identification registers - ordered by increasing offset.
+ */
+#define GICV5_CORESIGHT_DEVARCH		0xffbc
+#define GICV5_CORESIGHT_PIDR4		0xffd0
+#define GICV5_CORESIGHT_PIDR5		0xffd4
+#define GICV5_CORESIGHT_PIDR6		0xffd8
+#define GICV5_CORESIGHT_PIDR7		0xffdc
+#define GICV5_CORESIGHT_PIDR0		0xffe0
+#define GICV5_CORESIGHT_PIDR1		0xffe4
+#define GICV5_CORESIGHT_PIDR2		0xffe8
+#define GICV5_CORESIGHT_PIDR3		0xffec
+#define GICV5_CORESIGHT_CIDR0		0xfff0
+#define GICV5_CORESIGHT_CIDR1		0xfff4
+#define GICV5_CORESIGHT_CIDR2		0xfff8
+#define GICV5_CORESIGHT_CIDR3		0xfffc
+
+#define GICV5_CORESIGHT_DEVARCH_VAL			\
+	(FIELD_PREP(GENMASK(31, 21), 0x23b) |		\
+	 BIT(20) |					\
+	 0x5a19)
+
+#define GICV5_CORESIGHT_PIDR4_JEP106_CONT	0x04
+#define GICV5_CORESIGHT_PIDR5_RES0		0x00
+#define GICV5_CORESIGHT_PIDR6_RES0		0x00
+#define GICV5_CORESIGHT_PIDR7_RES0		0x00
+#define GICV5_CORESIGHT_PIDR0_PART_0		0x4b
+#define GICV5_CORESIGHT_PIDR1_DES_0_PART_1	0xb0
+#define GICV5_CORESIGHT_PIDR2_DES_1		0x0b
+#define GICV5_CORESIGHT_PIDR3_REVAND_CMOD	0x00
+
+#define GICV5_CORESIGHT_CIDR0_VAL		0x0d
+#define GICV5_CORESIGHT_CIDR1_VAL		0xf0
+#define GICV5_CORESIGHT_CIDR2_VAL		0x05
+#define GICV5_CORESIGHT_CIDR3_VAL		0xb1
+
 /*
  * Global Data structures and functions
  */
--=20
2.34.1
