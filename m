Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011031.outbound.protection.outlook.com [40.107.130.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC52D23A6
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783093967; cv=fail; b=a8kfJ7wnk9JzPBabVuc3WTGDtOGjEi/ejs6BFy0GTZAQCyIbQjcCp8fTDjFVKpiPRdgaHgPK33gNPPq9Zn1+/rVkAoCmWvu/KQGvsnTcr9v1nlI4hLypdLZTbPhOhh7XSGdYHXqeMgbi/ERu8do4aOSzrZTS5vpSebV18sDHvOM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783093967; c=relaxed/simple;
	bh=f7vW0xr8fEuhMjCkDaELzENRPXq27YhsOTb0m4sG8w8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mdQfIASGcvjllLjK4RMO24Ay+z2RPYGgrBxdB8MA97I3QoNUhkMjtiq6oqPYTrGBu1yGPXJGGds3qGXcqI8vK+hD622n4pUbNskROMW4C3DSHSr+Ol94T4h7bboXQd8onTNPAnWzJ1YQy2i+0BazMMgcBXhxZ9g9mIz6NsszciY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=exD/zZLO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=exD/zZLO; arc=fail smtp.client-ip=40.107.130.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="exD/zZLO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="exD/zZLO"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=mvpem10fhOjufxcBfJKqJBZhTQKWT7Bv1YDJs9pnU9kIQtCpvFt8E2O+LkXldlb3PziHeqo9e0nZqw9HZ8HjXqA8A/r7ZxmQFb2qPNyV2mUY56lCm9dLPajMOsd/pPkPBHRNgGIlf0uV0YSm7mMbVxdMy66ImFHZ/PU9mGoEj4EaipUdfis5E7p0dWsFgOH+Cq03Y/u8MAbz0uLikDkPWmeB3HfdjlBUJiCgGfoHW9KPqBzL3Ebd8epvEgoT5/WQrirg/5Av6byKeqvamCRhI25tuOEXmtwd0dVlNC8aavj4qGW4+YpvG544A0aY48c69JV7xrRNMylzwFL6iBOg0A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=pUFA58UTxEaeoe+fed7EW5cHO35EA/Y8tBiUmWTvpyzbRVY1X4kqEmLJoTlKCyH5J5pBtieSmB4YXP68htKSq4ZSSwqK3RvOamdxZ20yfavb0Kyg4ZOMVejr/LgDPwyLtDFq9kMZH1Ih10mDU8PXhwDAjEx38MuY7HLR3M7xf/qIsDE+C4vcCmVdPXCxXalp6qL8XhFbkC5dxnDmc+w6sJYXlqRC+Ir6qpqQSzzw5XW/zpyZGGClMY1CYqf8PLpeii+1+4BRcNQ4ujeC1OdT0H7GS3b25m0RgRJIlnOVBoOunSLOSRQK7t2U3zz0NFIEsfnAEh9jXoFnqCd/dkeh3A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=exD/zZLOTaKDYx92A7RzCqLnWsxODGFfJWayZvG+LIVCchJHCU3rJVRWhcFGqwXVP3bJLABAWDH8R2EbCM8fhxcr66ZsD2U4iQdHey+SEbK9GAZ+DOyI3SSqcacjntukD9xRYjxBEDoa2b0SrhO1mHpg8piLs0EwURjOXVUdW8o=
Received: from DUZPR01CA0158.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::17) by AS4PR08MB7805.eurprd08.prod.outlook.com
 (2603:10a6:20b:518::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 3 Jul 2026
 15:52:40 +0000
Received: from DB1PEPF000509EB.eurprd03.prod.outlook.com
 (2603:10a6:10:4bd:cafe::1b) by DUZPR01CA0158.outlook.office365.com
 (2603:10a6:10:4bd::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:52:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EB.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:52:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sW4xCFQBbhv2/jDvUAMPs66Pljcj5ETfzYWldUV37VfEMLPSfDBleCTi3KC6FM/nufJhGaVK0eiEGjpH7bbYrPSBMUcgpH0F65IUXuyxTV2wQbPdlzArojmSxnZffEla1KjnJjxjVa1XgJLosv957r31l71L1LB4C/+grqJ+5msxzUjdWLjFdsxnrSiUJ21yT9fxGgaLzTTgXbMokLTpcxcmWBpYJrxa0+a0P8Yu+tYCTODGd9md+CsVGBvcswfO8UC7iUM6zucFo4pqk6YAhxcbSmUlSuL7ViUyc0KVWAMfKbbfrUSl5hb3hKCoVQNqKL3dJlPloTV7IiC9miwWXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=vFTCnplfhx8IKhJsCDaWz5BVs4Euqn5AE2ZgroUAd/b3jhSn6AOHry+VygMi91tVSP+YoGXw68Yikup/n19cZi4eCNM/xY9Xc7qcldGjuV0UPSEbeFglssnAo14j1W3INad4ByzUVChlNdsk7Rndx85FTLg68WUzGqofUNFIydsOdMt9DCH1nSi/3O8SW1jFywqbHlr5azwUPBXb9bwMC9PlrJrb2UmCMuKZgbCkuS7+otFTr1SWDoOGjViJjvNjW9AFP5c5OKhV8b4dSOKN7jCMu74ePNmJQmLi43GrzPMoz6sekOAOMkTOZkpnRGsB1FDaXi6+KltXT0CcVZqW9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=exD/zZLOTaKDYx92A7RzCqLnWsxODGFfJWayZvG+LIVCchJHCU3rJVRWhcFGqwXVP3bJLABAWDH8R2EbCM8fhxcr66ZsD2U4iQdHey+SEbK9GAZ+DOyI3SSqcacjntukD9xRYjxBEDoa2b0SrhO1mHpg8piLs0EwURjOXVUdW8o=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:51:34 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:51:34 +0000
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
Subject: [PATCH v3 02/40] irqchip/gic-v5: Provide OF IRS config frame attrs to
 KVM
Thread-Topic: [PATCH v3 02/40] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Index: AQHdCwPSLq3RWHtf/EuaIRHep+J9WA==
Date: Fri, 3 Jul 2026 15:51:33 +0000
Message-ID: <20260703154811.3355680-3-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|DB1PEPF000509EB:EE_|AS4PR08MB7805:EE_
X-MS-Office365-Filtering-Correlation-Id: e64d4392-8120-41da-0084-08ded91b1b55
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 chLviGJbFusVXuboS0u0cARAzQ/ZlN1n4R18TVJ2+UNIiw7VtJGnno1uK2PVKV8sEMamT5ur6SGHKM+7Bz1IB7pg+giriMEjqhUnblNjhZ7NMhtbUFsNhUlZJAnIsVG/C8uhn0EUMcF8xbB00B56BUsF8o4luY1FBCJS9O7Q0tI18c2xpUwDKhEvThFasbfRXsA7J67mytsSiBhU7z5PlOrw0bR6RYucT4Yrw4pk45D5EhrE8xEy47uZxQdaRIRVBV+SMHT4ZlNMWmNnBE/fuoQZAQAbB4P/Z2/+ZNneT6/JZsc75qgfCvZHoDrhxKfF/qe3EknzD95sguU3XfClHupgqy041m9Gi8LmPGQQzKp0i6cfK8ILLNRASevGrj9eJ71znwB3VryBBae8bbn7oiXCcl5SuYx3DESuG9VCxrXy611JmDDRopEEaHllqz4cgtiIaguey8GTbsLpPG37L5FqGel2DlN7ICfit+JV+oh4upib4FszKF+Zbl/kfhhMhkv+MeljfZqpibmHNanN5AfVr4T9bqeSlgjscrPgCOwyt9eSKaOHDIe1B5Yt5rmlrKo5bieIe7mf+TfRzadoJ47Yz243SFVc+dZWoUztl54meibqjHza5mZEzpKTP8l5xk46IAGOcrsSWFuQCloTbzcRz38hzTYlUt5knaxcLHBXMisxr8gvyZE4uYmvEXVIKL4+pUojNn4us95RaQRNbwo14dwJxU9ui29l/VmJWY8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 G38o9MPN2AlaWFToH+pWgfpFZ7kr5qdwfbQid9C6eTEyVwHjEdPUgXwgS8cmTLE9/1DpqNaW7FYGX3J2hmzNbSe3/R/0/qeBsxTipctY2z8VklQywSxQdFRZ2AD0acrTj23p1IedZXUVaCpgGRJmozfvPjL+zVGgiOjwg0d21DOEf1P3NNAMNVwKu0Ks1XIAc5WDanPcNEFtUkfa0r0njZzzl2qoUJmXENkGj9MC/BMOtDR2jEi6kWj+OSxR2D/l3H6HTApwiBfpqrmi6QhZ/8/0taZEuxN/DzcYbKKaYEKIiw82nT7LuIVshpnBdgY1QIU9sqoZouyMvNJ6NXoDRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aea6e384-9700-4690-0efe-08ded91af53e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|35042699022|14060799003|36860700016|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	aToI6F/qCImKc3OHqw3zBnuebA/tsBFDRt1oZAB58CntQezCMf9gN3b1U0q3Qg3P7h4UUMpmJ7NkN/tZadtBv+Hrqn6lf2iIMfHFsZbB9GjZHgW0AEwgFlxPIsvXa20NNYyLJe38ZB69mGcptFa+f4iunTT2BQTz50/Kp2lHCmbpickWjsFAdVjxIp6lpPeMtqtCDjQT8V2BCzsPj6bC5BB8QhbUIni1gZbJGh98AtId+7I3okNw7UjSBqnC8ZjcYiR3Fm0uzMUEO/ROg9+hn6PeBAjfyBomtxdtbrzaxivD81sc+rlkHjs5DDtnbfzhOxlv+ne92WlH5Aioj5Cx5Ha32gYfqhYmPOSQlwD3MDWGnTLzo/7XJeGKQqMAqhuOgdZSgYFSE03Pu0n0edoOv1JsqSKeN1DvwJip5kc0R4tOZrUomB7iMAIqBFQMFgRIt1QeBxX05EiZj+8KRKo16+WFnltaSBvTdbEESDMp9Zv/r9sPiAyZmgiJ/O7Vjk8FU1p6nqtOUFUD+LVy71ZHecBvMf9TPU6qURI0EeIWlBMMGJeL2cSJo+kEn4j6npWCubZs/h9fcCR+Apip6eqpOt5Kj7U8aJTqPyFeNye4cyFx9woXRLKW2sbw25/2TSoIkGB3B18hJ6ZGdV7SGPvmeHVAoiNKIr5mXp7u/Mbggk89wiGZpqXFd3xpUbv4krq5JwRT1/VtUal1/2OpdtFvMQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(35042699022)(14060799003)(36860700016)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uEC9hfhDCuLiTP5hKQQm0LJZpDPGWhAGFoZTPnTniuJ5NhtXDpnZX0LZHclLfI8rf0SC3D/BKrb6A8VxoH5yvzQiF0kew5mpyDMkEY1KHtuyPTz0Nksove5fQLEN3K01R+HV7Gu2wghZcR0G1G3NOruk5z5I0QRF8Ir4bZcy494H7SHbp/iq0yOyY52guO7tjKMgNIMcLdjxjfypOcO++yrPz6G64p5YB8ihSOrK+Vw0cVQh9vBwg/OZqt/CU1eFbfcYNkWX85gpx+GJgKevcqLCaepp1E7MebPSlTarHoMMHadAYZqzOCsneD5v9n3kwBYWNOlhs6rdT6O5MqlA8TwVANoB2dtyPCi7zeiA2PFazAZ4IO6D5h/fIObkINDe5k+ErW/Gx5IPKzkkAyxh+JQ/yDBKAZy3WH2MwG/99GESAOT+Q5VapGq5Zcm1Ookb
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:52:37.8104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e64d4392-8120-41da-0084-08ded91b1b55
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7805

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
