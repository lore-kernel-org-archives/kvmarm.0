Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838C42DEA8C
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094423; cv=fail; b=mOW6XkZ/Pgd0pyT7HOMXK53BfpWAi1vdkGL/9WtKbQ17lv+7ART9Tv7tP9wtFGkL5HKntDfLnb58Sy1dj+BMu5KhqFVBdhqlj3R4F3l2iS6foTc3mSpHEYLop2wmbm0mhgnEFXSeT83S8Ze4feY9W1c4B7N/cDVY4cvreegsHRo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094423; c=relaxed/simple;
	bh=hEfLHasqBDRuMGjNpWiTfT8MxQvFBGaaHT+T1uk2PG4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=boTiVxyk/VEJu7FaUiTw4JnCba/ep/tXMS0R4aPbAajm8sfV2rIphheI5rMlefL7fjdN+7EYxIehoxBYj0eKT8I7eS4zGYxfCq/cyfni0wM+3XzwSdUMTPUtRfNbKYerHQwACla+q2fKBbD82ByiPP7D5EB05YBoHzuQYGFdl30=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RhHXkgZQ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RhHXkgZQ; arc=fail smtp.client-ip=52.101.66.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RhHXkgZQ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RhHXkgZQ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nmPCsZRBGcgpr7qwoI3JuIds1r5TclkdQ3P95s32ZEJE5tG0QnEfX+BFS4WkjwVox9qkJkYlhfBwSPO2wWeltcmYUhMN/+jE3cYFiEeRNcv9qbtgiEBz8CXAa1c3Sr8kNtUl2Fft0iWNoD9I21QnmMyRndK0s3+nLSO4x9Cj9DDW5NKUjWs+nBevL0dG0B20Xd5QPckl9HaiKPsEFVsxGFO85BCcST06pxeLHCsxI9laG7XOlPYhpCK3KFgcm2QrlLcWSjA45NgF6iRPUVwuy07uirrhfgJvZBZK7qrHtzkuDFiGB+gR+0ruP66vFrdSZMWPD/TiEBkUfF1B+qc41Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=X95vqRumUr9Z4Lx5kbJHL8OdLmzMVjbeFjjdyji7wDIVVRdrxkOW2fuP5nCzreJAnyi5QWtRlz55u459GQOd5ngzqqMw2O/w81akWmVPcApclel2plwmrPO4luHupQeJhUYkZ3h74Bl/pMJ3qQmCGy4v9EArQh1461H9ENoRL1uofKejQ5ZKgdR2Zq+TP1vqwEnTUazJiK/Ixf6Kr0sKf/9r/d26MAooWOb/xFnMboLZKO+9DBntUbOL9zWLHx9jok9YAKZtIkAxTCv1BjwGiciTCsZRVMBO5ZrL9kfqOgO93TQz363Rcy+WHyRU1vDLzil4ubVfG4Gb1GmMSUCVoQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=RhHXkgZQ5fEqpDc5PeP/vzQb9yAkdTmHvKUHHfdab91hgok+FzkXUIEo0DGFqq7rfWLYQeiB6WeuELIDDbP5fkQF47iY7P6Iz/SVmiR8YlFe37wD923J17BNezXuLiXSemzMhKI7+3heE/YiZ9e5RL/OO34yaND8bDURLcWyF9A=
Received: from AS4PR10CA0017.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5d8::7)
 by DBBPR08MB5977.eurprd08.prod.outlook.com (2603:10a6:10:209::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:00:15 +0000
Received: from AMS0EPF000001B4.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d8:cafe::40) by AS4PR10CA0017.outlook.office365.com
 (2603:10a6:20b:5d8::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:00:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B4.mail.protection.outlook.com (10.167.16.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:00:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zMhWBhD/VsiL+eU9THmzKDkxILVnB/7oPPEcEA1wn3VksOluxEMUyqOp3+19i8EtgIHWTNLI5PWm2IqXhO+/HUxYvoa9Ijwi53MzFwon8uehRPQoyAvXgml8NgTFcTNlVFbaLVzTLYy6iH5vamvyuGwc2mgncDlfrS8flULxG162dbvQRk0nnW322ppULdPlFHHWqajvF8CVZ7FrjhveipJcW0LJvoVBI2F1c0R+3LukVN06GvPvU12RcesYaKRofByN0NSpykf3z45uOlGrtsJPkD7GSTrCiFBV9z/2qTBxrqWaTAQU5hlwShPRKff6VbJlOEgRLGovU5hHdBdz+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=AwMuEYQHtn2L+vJ12k90/bmP52TVRW6I1rOyxKimf1CoRxs5HDSjXVJNzLjz553llOPRLLNPlOV2CiwubqH/Ft9LBr0IKjhLWxmIsGmXi1NDlb1DQALQ6tIwltPpEoPC7jz0YFZrfQUbbfaYKIElaWb3rgXP7TGSG6XLr64hlukeTMcxMVVNWmeJ67f/FJmCBedHvxvYbp9WYTDxNZamdxWdNY/Br7EQH6fwl/xI+SUyLxotiU2p+NGSG06DzP7XI+RgppdFgcGgtkpoLX5Ap90RazN+WeDVD055XDG0pdB0YSHOdFZZ4kCWKShg7Gp0Nqt+StoXWQLi9lo6EZZ22Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X21nyzPBOEpQVfQHf98iDDwewvWKmz8TzI0wkeqGt2I=;
 b=RhHXkgZQ5fEqpDc5PeP/vzQb9yAkdTmHvKUHHfdab91hgok+FzkXUIEo0DGFqq7rfWLYQeiB6WeuELIDDbP5fkQF47iY7P6Iz/SVmiR8YlFe37wD923J17BNezXuLiXSemzMhKI7+3heE/YiZ9e5RL/OO34yaND8bDURLcWyF9A=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:59:12 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:59:12 +0000
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
Subject: [PATCH v3 17/40] KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and
 IRS base address
Thread-Topic: [PATCH v3 17/40] KVM: arm64: gic-v5: Introduce struct
 vgic_v5_irs and IRS base address
Thread-Index: AQHdCwTjW0yGzUDrWkK5Gv1yTVheAg==
Date: Fri, 3 Jul 2026 15:59:11 +0000
Message-ID: <20260703154811.3355680-18-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|AMS0EPF000001B4:EE_|DBBPR08MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ac320ba-813a-49e3-dc1c-08ded91c2ba3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 WrBSPqmXBWVayfjqX1GfX5F5AcC1ilw/IJ6gdoTYw7dG7opFvAOaPOphGUSj0hr8/bhjBRUWB9GraTIcLncmRXB08VGQklSP//LdeG3CnW5D3ILGYG+y+tS4KRNKHCaYSa2aRHhiAw+dKsQ0U2c7Gch1kKMUsTAtICYQmDuLns4TaamSnqQvus6rvxfMbkzMjTaHoqis2kluxVyngIrHsePxl40GAuYo+xSs6lnL0BY13BswU7i2YiptM3fYVMp/7e6P6C6i6YaxTHRxcadJxD9xnBVe0ENEBq3cAVRwh5a7CX+JMZbWm1mGkrpwbQZDA6p1dHfoV1bOn6QKQQwvnThEzlyo0iwGPD2pE/IHJmGtTPmw/5Tr6NoVH8XJXUJsM3swFqlqCNehDia6CJla4KEJqIjTlINSZGDCbSNnRhglVCSe1pxHiLvCyql4wJDldibrsYdAR+2TCm8ze/MvsMR5kUMcemzLYxjNDUYDqxfxhRiAjiRMrtk7h0HUFBgejIxsKeB+38BTlr5PI6BQD4NuGWAlMzcApx7rfXfy9Ibpei7Tw/x/GvNXJaRd+Ecm34SY7EJIs03fsLGuyxpJkFAgqKGCPGjgh8OiiPV2qtubg48KAIHNeJCIiBpWMb7wY8Ij3d2lr3+tuHb7B571DMekVRL2RQ77IolthIwpVTIoC3GzYAcKrUPuc1NwaFFeNs6YCJz3lZf9JqOOcyuPYkWQkrlK3j25QIe7s7+u+S0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 GzxelyyJvRLfVqvdIkwevDbIrxaPf6qX1ap+jVpS9Mkl3hZgwRKmSVeAoLHzfEkr/sbH6FrNoiiWz7RSm30OTpvnvaMu/cXrvwsnj89G+EdYc575blUzTOrkihakL+9LDdfLHYG/7h3TCMiVKdW1Ds8bdZ6RL6G6EYCubIx88MtkzOTgDrraB61hzhT0QfOyfWeNEQ/O32V24TR93gbWLmEVTp5AW3nDOhbfRQkJyEDNEGaSy8ZLr0Z/0WGZAFb+119TRAHkmRFSzBDgEDAgTPLthhXSsMUq96o5YLY6c+9MFyY0KuxvMNUZYX4DnOZSs7icaSX7u4lq7g0M6GCcmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B4.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	01f46688-6cc7-4a9e-1edd-08ded91c0632
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|82310400026|23010399003|14060799003|35042699022|18002099003|22082099003|11063799006|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	R01wwOkxwRu7BDQAf0c2P3FnSB6bek43EQfr2IkzVAnzzPEPDE/6U7QQNz0XrS7/+3sWkc/Bi3YSVImDprEfaqlQ1NcAnUdi2/3qB8bI2xMbW7R5oeIXRoiS0PEDmEYERXvgM31mPNsYX/4jeGL3VD2tMnDN3iz6wntUCxpaN3Fxo/L8zAizM32U4FiAaKVI648oPdcFMrAo2Tqafw6vD8Tag5dVVtz60LSLvGg7EL346vCLfZd7AkukxXf/qcNqzr++CZrjInkP6C8Q20EulYxbBsRcb1iQeBGF4Cy9e8weUx4B1IY16TEVo0R4eFWH31u1y83sA2HhB7mDgNYKWYFciiKqRWQRR49dx2dWm3+BjXGC7BRIRa4vsKMmiDB4yww9eUQf1swCuYbAPqXRHw64pT6nr+RC6kYaTypnz0aoegGJG3Kyf9CjRc8s40J7XejRZkIFnV475OlAoI+s99rHCnJJda5h6zfkfj90rDKHMASpcW6welXW6wn1vwKPHVqNJvgaUvEePagN9aAHXPlWXmCzvFhdjv9BecieHtTQ5UR7TqT1A7LmROeeAO8KsxyBJJun0Y73KRvww/eYCYr/VmyQWf4Y6+IJ8ozHw874zpWfvukkA5TcIndEkCJLSwPFHW5lM5mdddxOn9hZ0IcJDANd8xVkmhQ61998WuhDbJmD6hfSuQIMx7LpJ7LT0O4YqsmPAM073gzSYj1VAw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(82310400026)(23010399003)(14060799003)(35042699022)(18002099003)(22082099003)(11063799006)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FhlV0ohMf0pWYJHw2uMj6uVa9S1Fdmg0/Mvz6zyJLICF0KrN0iscvq+xcRl1IVB+5Jioday8jVfZy8bgQ0JwAuO0oHsmOqGfS/HgzMzYbomLUw5NQpeF7IZPHm5oEeL0hk1i6o/eoB+waUvf7BDbzlZGgFatBRE6wwn+rqAhe13FzWqb73/UA5Z/i+sOXetaFpC9cgUPJpeOHdxx7t8+WFoe/mVY/9PWhW70eBLK3TikdmlEEo7Y0NTM4SUHcH7g3NYqYwFkYKMoQVdlzZauV85YYTFoZAtCJxVhvdtmoe1fZnF5oMym3+oITBpXkf1sv+zbjdBN+ojbiIFg4g8qdR8JYDOPtTrlux8mNnaDnIDLbyTUblye3UTFes3dGHg6Fm5srOiPE3FSdBcRrDDJmzrEWC2COZRzDvuPbBEMtIhy19zR5CnultunSLGH8k+v
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:00:14.6745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac320ba-813a-49e3-dc1c-08ded91c2ba3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B4.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5977

In order to properly emulate the operation of the IRS from KVM, we
require storage for the MMIO register state. This change introduces
struct vgic_v5_irs, and adds a pointer to it to the struct vgic_dist.

This new data structure contains the storage for IRS MMIO state that
is required for emulating the MMIO interface in KVM. This provides
persistent storage, and a way to track data across MMIO writes, e.g.,
selecting an SPI and updating the configuration of it is two MMIO
writes.

Note that only a pointer to the data structure is added to struct
vgic_dist as this new structure is very large, and hence it makes
sense to dynamically allocate it and just provide a pointer to
retrieve it in struct vgic_dist.

In addition to adding a structure to store the MMIO state for the IRS,
we add the base address in GPA space to struct vgic_v5_irs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/kvm/arm_vgic.h | 86 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index faecde764fea3..25368c5cda5df 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -409,6 +409,87 @@ struct vgic_v5_vm {
 	bool			vmte_allocated;
 };
=20
+/*** GICv5 ***/
+struct vgic_v5_irs {
+	/* base addresses in guest physical address space: */
+	gpa_t vgic_v5_irs_base;
+
+	struct vgic_io_device iodev;
+	struct kvm_device *dev;
+
+	/* IRS state - used for registers etc */
+	struct {
+		u8 domain;
+		u8 pa_range;
+		bool virt;
+		bool setlpi;
+		bool mec;
+		bool mpam;
+		bool swe;
+		u16 irs_id;
+	} idr0;
+
+	struct {
+		/* PE_CNT is populated from online_vcpus at runtime */
+		u8 priority_bits;
+	} idr1;
+
+	struct {
+		u8 id_bits;
+		u8 min_lpi_id_bits;
+		bool ist_levels;
+		u8 ist_l2sz;
+		bool istmd;
+		u8 istmd_sz;
+	} idr2;
+
+	struct {
+		u32 spi_range;
+	} idr5;
+
+	struct {
+		u32 spi_irs_range;
+	} idr6;
+
+	struct {
+		u32 spi_base;
+	} idr7;
+
+	struct {
+		u8 sh;
+		u8 oc;
+		u8 ic;
+		bool ist_ra;
+		bool ist_wa;
+		bool vmt_ra;
+		bool vpet_ra;
+		bool vmd_ra;
+		bool vmd_wa;
+		bool vped_ra;
+		bool vped_wa;
+	} cr1;
+
+	struct {
+		u32 id;
+	} spi_selr;
+
+	struct {
+		u32 iaffid;
+	} pe_selr;
+
+	struct {
+		u8 lpi_id_bits;
+		u8 l2sz;
+		u8 istsz;
+		bool structure;
+	} ist_cfgr;
+
+	struct {
+		bool valid;
+		u64 addr;
+	} ist_baser;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -486,6 +567,11 @@ struct vgic_dist {
 	 * GICv5 per-VM data.
 	 */
 	struct vgic_v5_vm	gicv5_vm;
+
+	/*
+	 * GICv5 IRS data. Dynamically allocated due to the size.
+	 */
+	struct vgic_v5_irs	*vgic_v5_irs_data;
 };
=20
 struct vgic_v2_cpu_if {
--=20
2.34.1
