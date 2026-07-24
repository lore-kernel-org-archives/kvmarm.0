Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012038.outbound.protection.outlook.com [52.101.66.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A54425898
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890209; cv=fail; b=l7z/f+XQ+sqjQXKQ8sxIQQfclmam4ypFTvWm7ULq0QhUNRbcWeolPpIxV2fkkfEPecq2w4iyXn28jMagcuBi/Q5mweq8JZczMrZsVXcg4p9GYr9YTmL2ZegR0c848N9CiRWDUDvwz9roRmg1hHn/tBTaiyVbDwyCfuMInsXvnEY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890209; c=relaxed/simple;
	bh=f7vW0xr8fEuhMjCkDaELzENRPXq27YhsOTb0m4sG8w8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rYXyFUOUtIeKbuGmH/ZrVK6aH4ZUbndDNX8xx9p0eHEiXmuyhnPMFXuPxkm5eIN/aRvR3wB7p88BA7S3WED8bt/wnNIF/H3DWNglOpi7TobVPV/qb5lXqwgwQR5/MBFARxprNJhxA3PA+rvhq4olopc03pE/z4C8hapi0MmEEkI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GcAkud3Y; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GcAkud3Y; arc=fail smtp.client-ip=52.101.66.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GcAkud3Y";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GcAkud3Y"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=noSEU3R+JR2ieLkzv7doopKrEd+aGgUVLwllaisezGd2LwlLtxulG/6vkPoFD+hkR6O1+jl18KW+GsMmj0wFvERnnnHJFDxVeCupu7uNa9w8vzib1YIqgDgcPKDds2D4LJNiDkjc0f8ESlPYCyAXtZkSqAOs57e+/lFESXGcrm5E5dh5C7DX/gFr9/j4ZWDXGD4si3XaRaLOdLY+ALpK5Vw9RthgdXj0vwmTwn2P5rhIB1CL+mSrcaYQD8uYquGv/y9udhbod20F6fAJ5LLZUlbLz1cNmmJwyPncB01ObcUk7vcZ5yiSPeiWangNWtiBKOImsU7KuQr4Lb8shja8Rg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=rFCOoQHBiD9Po6kiXCWZAShpZg8zxhENIdXlWZwSi7NVkqDjL/efPKyL6hmLo2pLpW+3DteH7pKHns7j3Sb9VvWmfMemUfWjL+qfdRmNWkP2KlxkTY+og5m3Xx1HXQTixEoZ1+3GgGuLD7rV9gsuVrwB+1lLbxQmFL7jcJP33NNrXsg+kVyk/01MHQb5FQHaN6Bh2haKlezai1ZopMnxaJvJqv+VociNE6DWFk+xOW/5bIH8/t3+UaefH1SdvvjBIoHCSjJnG2Ab3neevkLIDq8PhOTP+W/6xiS3DnanC+sL07AO4A5Bg1NZpWEAWGp/j/VK6BaOBx+vbgLv8AvKFw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=GcAkud3YZlcJsfy1pP2KI2UrzfD6O/x/cyqt2sTbxkvc581c//WH74J2oApHKHv+6xNk7L/RrmirgEIylVO6yWTkTNS1OqKp6H5Gj2v15/OXRV453QkAWx2/chVllevfj4BCaD5MZgNbREg1Sq5Wz4MPx3R8jA/XoImM7KGkRxE=
Received: from DU7P195CA0025.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::30)
 by GV2PR08MB8172.eurprd08.prod.outlook.com (2603:10a6:150:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:49:59 +0000
Received: from DU2PEPF00028D12.eurprd03.prod.outlook.com
 (2603:10a6:10:54d:cafe::24) by DU7P195CA0025.outlook.office365.com
 (2603:10a6:10:54d::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:49:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D12.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Fri, 24 Jul 2026 10:49:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NRlZ6kCorUlbdFWAg3bhms3qT12/qqzWTf9tT8DnaKR7Ta8c3iDhEeg0FkkfBLYaTkwE9EI4cgMI3WEpieVCIz/0UaoIZ6cdo6UXxJ1pqCZIklH+DoZXIAArTjuoFoVSLA4TBb26KkNr5Ewq4ap+0FcgBSIHgnbHlGcB7K8qyqX3BjwXfr5tKPvmqkNn0pT2k/oE3uP/6H+6XNAlKucsTcqzRLRk8krFIRaQE4YhuC4FdIe6vsrrOCaqi8CXyP75rDGTz+3JwMuKiSYqDkuNnHjPaHI2h/62Mk4SBs+b5nb02Rle3uOkI5vywe5FbCnHM8v1OfNYpcBPNjM8DZvXbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=oVgqVsfglx4Fmiha+zNTbcL47Fjk7z92xuQF/8YP12OT57AjErwouqTBor69ElhH9Y36m01L0bXLZudsLOI93xcLjfPvROKL3v/5OlLQ7V0msEcVEC0rBjZYkp6f4Mks+MOgwH/Esczs/5TmXaRNHowz+Z6/DS4sSvbzchiWUcQ06XJKplNLs/QmqKVPM4EBeLPKC6n/Te0MVQQwGAOaXI3WlUS1vnXCtNuuKSjBbZVHNcQyFg3qeRdFemrrPJHbvvd4WgH80kMm7pWrV3c8byKXFNGFxjgbDp5ZKBV8s5v2tGVro7yBV1R2FuiaEwEaz3ja8sn76sMmGtUynNLqhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=GcAkud3YZlcJsfy1pP2KI2UrzfD6O/x/cyqt2sTbxkvc581c//WH74J2oApHKHv+6xNk7L/RrmirgEIylVO6yWTkTNS1OqKp6H5Gj2v15/OXRV453QkAWx2/chVllevfj4BCaD5MZgNbREg1Sq5Wz4MPx3R8jA/XoImM7KGkRxE=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:48:56 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:48:56 +0000
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
Subject: [PATCH v4 02/48] irqchip/gic-v5: Provide OF IRS config frame attrs to
 KVM
Thread-Topic: [PATCH v4 02/48] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Index: AQHdG1oGQAGyOIpVJU63p6OTUU3nyw==
Date: Fri, 24 Jul 2026 10:48:56 +0000
Message-ID: <20260724104819.1296803-3-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|PA4PR08MB6127:EE_|DU2PEPF00028D12:EE_|GV2PR08MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 83a7792c-17ef-4b1c-8817-08dee9714e48
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|56012099006|11063799006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 KMdbO9vgkSXsaPJI63AftqDZpY8YowdDWwkGkz7mX9Kz3Ive5GwpOogO01LSTjzECSBjTmeJGkHoxsv/ZsCea7OWNrnkPi59cQdTYlmC+r0KpLgcbgvSaHq2/N08wLdNWHq2J0Sx3l+BccLP5LoSaNcb+IlRBoti3tboXydtudx5rIsN3ABxPNzvZT+YeAJJbbsMenhlAQNDZqB5IBwWRT5mzSFUBaogfGOGSGYv/qb9BT9jt1X2vJbpKB5ImsU2YqvItsoNwX9pd4GjI6Gq1nvOCxwJRBAx3E0aFV5R7D5ud3LLc06ulZTeEx21Y2C2AgNSwGv99dh8j809ngDfZyiOeDa0LzO5JLX2ZfmDnLukLj5MGq+G6Nau+6GbdUW10mVyyq2b+g/QB7so3sXUn8a5zUTPSKn46x0A++bcQWJaFNOgZlAsqVV3CorAK9QIOLx35Xk3IKfpObQCLnrCzWH3kguEZVXbN4LhXZHEj6IA7pE3zI3PsOZUzWozQoI0FELmqZgQw88eDrGs+R5p2kFpi1R525xw7Os0VGM0POEpKf4kDwwKduJzyxtdcUpIm3Ba1YCLUk3YGeKLhqw5jQcFEuCUVcgIFd3edjk6h+YRWwOAMmdMmbOYWAtxBXLFngpj4VctcWHgdgzhAXg3a8+Bui0L8Scdr6+KZeWatgoH9VBVzNxyjGhrMSgyUnxzRGjv6/gqqwZk2i9MmAeM0dh6bobBAsrxrJymi3OtZvE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 OglpS9RgJNLSQ4zNZtvuOEWx3SrLXNhY3rpoBv9Z1cf/x/VwZplL111NaoVMlb6PFaBP9N8UlkzNsvv1ihSnjHt/l6ndsxViGDDO47jEnZ9Mf55beee7kS6J0z6Jj+ApXfRkSZpwZSMRKr/NxaLwWMw40Ya07cS08FmJnVjw7NuIWC2Ms5bQTqHJfCkEzpNBUpKbm0XsMFt4KYqY4ErM27PCwvBLpf1hBGw4vjsZEqNxr0aWQo2Brh0KAovIfuaAmGjNZjsY1gDWt9wsJTAUqBeygYWjxKqNhJ+yPkNQFu2UKxa2ebZ4NuVy/TCObLeRJKnwG0rgZICWOIGs8Gg5QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a2384f72-e0fe-4811-76ab-08dee97128f2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|35042699022|376014|1800799024|14060799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/8YIboJJ36TAW965uZth72dF11akoH8bavQd7/xA6BVLX9axo+VEMaDc7GhxuMlLe+J4ynRs2oEMtjrdoPvDabHwPaNDD88aNHqyjP3Ul1vsXs3x9Px/P9MzivcVUJ1svShu1taM56gC7EtG8/fs3qojmKphlMRNKVzart9ylw5tO4tMQjqkQcgFxHMYzv7C+vKKOlGlCWHe8xTxyq7RFEEXoPt8kDlI7Yo7hJkmLAqh9WHptESUxk11+QuuMaHH4gNHgpV43jz8AmBpkNik1gNy1d/pfq/kQ6FzgVIXe39dE5EGQwCOky61a9sz1ariEAxh8oeGMznfozfqT4y5GobatMvTwGkVUUc8rxG+hpGwRxtxQF84Iowqyc0G3WNgq26od3iqTMcAhP5/sdSAx6UBOMPUV697hmKlje85AQpwLhGdWOqbJP15evT73/ZB1bqR1jNbhHXs67A4RD4qAKwklweB2piMJMVhq/r4G3L5a4BZFeNFjTVmaMPQJspf77DYbRD1tquoIRizGppcbSiUp/9jXH3JiThAA18aab5Fa8PxbMjQuqjwkIP25XeLHjVTWZp+fz3OqoOq7JhHqyZpHSbaXetj0Oy3BpzPYIq83+Y4vYCQ2Rf1a2DOTVbHuFe43EkH3Lm7ZyHt+iUNOVyG7DhBSV6HZyrpwbM6RjOn4mYrfDHRlArx56qN5l7w3rmkWTHVyk5A631BSweH3Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(35042699022)(376014)(1800799024)(14060799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	McV3UitCL/HI6MDjUzFiGiSmMPL0BCGpNI23b1+nucNtWUS2EY+fkEiCu1ClKwBMLIboHyYbHVMYelrTLZKkGkcmQRpe8LS7i1Vp7wO06JQOsBRcx7NiCF4NAMxSjcRZ/OM3VY1riqOBR9vFhfaymcba13txI7xcls21cOMqPjzitK0eEbUlwfL6Cnq2foVVekGqK0VmBZ4nFsjt5Fe6H8HCw/nIbnuEsVUVFK7RgXuNOvBc3N2vBXMRPlO94dpUyfgvi4l3swXBo2Cil79+OzVAxT3FNX3EedVk429AmxKtC5mlWw6jPhnP3Oun+r3Dct38RhKmeCKv56oyv4iE7AdVHWPBEXJjTF+3aFsfpzLQil9gvBBedz1WUNfRlDHEzKYn1TIF9zWONNbE7AH1Pk1Lswqc+YqrrDvZ57jeTqfr5BEXf6WZXu/x0q8uEpmW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:49:58.6161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a7792c-17ef-4b1c-8817-08dee9714e48
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8172

KVM needs to interact with the host IRS in order to, for example, make
VMs or VPEs valid. There are two potential approaches here. Either the
host irqchip driver can provide an interface, or KVM can interact
directly with the host IRS. The latter of these two is chosen as the
set of MMIO registers that KVM needs to interact with is orthogonal to
the set used by the host irqchip driver (with the exception of some of
the read-only IRS_IDRx registers).

Pass KVM a pointer to an IRS config frame - the config frame belonging
to ANY IRS is fine as long as one IRS's config frame is used
consistently - in struct gic_kvm_info. Additionally, include a flag
telling KVM whether the IRS is coherent or non-coherent in order to
make sure that KVM can do the correct cache state management, if
required.

Only OF (Device Tree) is supported with this change. ACPI is not.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5-irs.c      | 7 +++++--
 drivers/irqchip/irq-gic-v5.c          | 5 +++++
 include/linux/irqchip/arm-gic-v5.h    | 3 +++
 include/linux/irqchip/arm-vgic-info.h | 5 +++++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index f3fce0b1e25d9..607e066821b52 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -21,8 +21,6 @@
  */
 #define LPI_ID_BITS_LINEAR		12
=20
-#define IRS_FLAGS_NON_COHERENT		BIT(0)
-
 static DEFINE_PER_CPU_READ_MOSTLY(struct gicv5_irs_chip_data *, per_cpu_ir=
s_data);
 static LIST_HEAD(irs_nodes);
=20
@@ -50,6 +48,11 @@ static void irs_writeq_relaxed(struct gicv5_irs_chip_dat=
a *irs_data,
 	writeq_relaxed(val, irs_data->irs_base + reg_offset);
 }
=20
+struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void)
+{
+	return per_cpu(per_cpu_irs_data, 0);
+}
+
 /*
  * The polling wait (in gicv5_wait_for_op_s_atomic()) on a GIC register
  * provides the memory barriers (through MMIO accessors)
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index c04523a438cee..e7a7aedcfaf78 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1128,6 +1128,8 @@ static struct gic_kvm_info gic_v5_kvm_info __initdata=
;
=20
 static void __init gic_of_setup_kvm_info(struct device_node *node)
 {
+	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
+
 	/*
 	 * If we don't have native GICv5 virtualisation support, then
 	 * we also don't have FEAT_GCIE_LEGACY - the architecture
@@ -1140,6 +1142,9 @@ static void __init gic_of_setup_kvm_info(struct devic=
e_node *node)
=20
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
+	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
+	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLAGS=
_NON_COHERENT);
+
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
 	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index f78787e654f4c..681c5c51207d6 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -330,6 +330,8 @@ struct gicv5_irs_chip_data {
 	raw_spinlock_t		spi_config_lock;
 };
=20
+#define IRS_FLAGS_NON_COHERENT		BIT(0)
+
 static inline int gicv5_wait_for_op_s_atomic(void __iomem *addr, u32 offse=
t,
 					     const char *reg_s, u32 mask,
 					     u32 *val)
@@ -377,6 +379,7 @@ void __init gicv5_free_lpi_domain(void);
=20
 int gicv5_irs_of_probe(struct device_node *parent);
 int gicv5_irs_acpi_probe(void);
+struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void);
 void gicv5_irs_remove(void);
 int gicv5_irs_enable(void);
 void gicv5_irs_its_probe(void);
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/=
arm-vgic-info.h
index 67d9d960273b9..f05370e2debf4 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -38,6 +38,11 @@ struct gic_kvm_info {
 	bool		has_v4_1;
 	/* Deactivation impared, subpar stuff */
 	bool		no_hw_deactivation;
+	/* GICv5 IRS base */
+	struct {
+		void __iomem	*base;
+		bool		non_coherent;
+	}		gicv5_irs;
 };
=20
 #ifdef CONFIG_KVM
--=20
2.34.1
