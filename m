Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013002.outbound.protection.outlook.com [52.101.83.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2002C375E
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375752; cv=fail; b=NJyWRE712Tntf4zSm3q82kTkrQScLy0dsSe5/ycONDBhKtxkb46lA8/4F3jSggIsyNyJXP+HxKWVwffhrcU1fm5OVU/3RvHf+On2yo6opPW4Rhnh1wOyHBmNuYkg5b46+D/RuUh+GFJE+n/TbKA3fYRYnIUKq0xFeCAIkoDY0hs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375752; c=relaxed/simple;
	bh=8AZwBZjIlRJyYpqnmDwAaFmz1OKJERdJRtYiywNVvsM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HLc7tI3XcIFVUYV+LUnUbxouDsPU9B/MDqaWj+mWeOLt2f2HYEQND+pkUih6WqDZolG7FKgQMvlILh7e2BFC0TeldQsW09Z9haKysaUp3pCBBdNXCo2RAeZ+/q3WC2LduzlSqbuQ8lamLOVGQ/i01qYipVtIzYf4nRa5PMrMb6o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VMMaQccu; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VMMaQccu; arc=fail smtp.client-ip=52.101.83.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VMMaQccu";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VMMaQccu"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=QZnWpuh3apCqaGeoRCZYd6aArIfNwRMhiFOodMhMBAaTDYzsJLpFLnsQH24JMw8uD5M7Udqx0ifrtD9tOv2HR9gFlcW68Kn7YRnJ+h1ccm3rxp1VkixyZYK+CuDlClfLNqCY+UT/j9rGkEzV1tjEa57dT5tloRupkGM9wCe+5/6uQbPE2ORZh5TP7hzQMqQkICUDrCspIVwIw96OsteXIbiVJltZpCvPHSiU5IIxGRBGcDQdxfXF5wh9QFQLBuJhlvYnmII5CnxouxTqzAFCMRzF5KvxNN2RGWM0HPGTc/02iV7ou1UZv5dCFvYWht0q0D/7tdaJi1KdB3X45iFElA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwFIufjELjgv6Yb1kN9/k+Xu2KQL0Jui7Qrs7Suu15s=;
 b=RDXD0X07hKu4P35xdaLFxyjUh9pkGCoH9naCS3ENDv6jywRORSuhElRwVebdYwAVW0jWc7CovUbNQtwEQbKxbCFW32o3xRXHG7GtrxtlaUqpjG7lPaSUyWm5UVs/KW9puyIi1itct7dmJ/na0ZAyK4v1jrZCF7qQopmChBXfnGMa3uCXjatnGcKsD1HXAsBnbwVT237biUN18VPfZ2q32ygThjF2CRSBHElAUjDSttfS7gIJAWfRGrxfXairFjvYSpZGQ4eZpKJS4mtoWvTjwf4ye6rlL2/A5/b63J1ihUbLwV9JGe7t9sxLc2ijTrRakNPHevO4oFINB4duqREUtg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwFIufjELjgv6Yb1kN9/k+Xu2KQL0Jui7Qrs7Suu15s=;
 b=VMMaQccuQzuWbYB2jk0TCvm5xNTN6laPU4endJcLycveDX4y60LasTm97VMmCwcUXXn3+oXH1Mvy4xv8gEXYPlOOSnkdt0cW/9qK21YtZ1cCiQGtdtOhmP2wDGM5uHdLxOlHJoSN9uRQgbQqRmp8tbNY4S3j4MWd59YQ5sWoDac=
Received: from DU7P190CA0006.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::18)
 by AS8PR08MB9243.eurprd08.prod.outlook.com (2603:10a6:20b:5a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 15:02:16 +0000
Received: from DB1PEPF00039230.eurprd03.prod.outlook.com
 (2603:10a6:10:550:cafe::fe) by DU7P190CA0006.outlook.office365.com
 (2603:10a6:10:550::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 15:02:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039230.mail.protection.outlook.com (10.167.8.103) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.11
 via Frontend Transport; Thu, 21 May 2026 15:02:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jBDTebcHY4m7gt7xG/f7ORzhLQjQ5i3ZhJYDAzBK7M90sVHxnrV93sJa6/wRCYnBc1PVZvN3Pbdvvxn3j4AL3w9s87F3ZFqm9T9Yr9dY+/0ignC11FKjRTcp4GvpYqiela0AaBKepjPQjIOhZwKZxoxEHybYOsCJtrEG41xYXmpgAPXCrkVprjil/XpV1XLDJyUuJEVnC1ihS9zfmqIzMA8dy//U3XQ27C7r+Gi6BRuSa/EKXPMNo7dXTzoTroLq1jAPV1FSLT2d9DBvr0lgRorkaYja6d7j3rBVG7dwKjTLV1WCh1JpCWSTThJWEHa2txrbF7rQVRLDe3cfXmdfIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwFIufjELjgv6Yb1kN9/k+Xu2KQL0Jui7Qrs7Suu15s=;
 b=l5o51uLJ7/UVa626HT76RIleimNBWo3LZVOLq/TLSuZZDhOHf6AZoCFo1ocAwVsOxRfsBCcDHdhwa527uqTOGVc15qLVIiMbbW7DVBAIS4qLiPbfjHE4hpHdkSLtHqT7mXIjg5+nj/2Edj+429Qe/2g/WyS8ZGyvbVFM9AjneYRW7C8+sD5TGoRHrbFT8JepPXBOMUjA8Ru5XoRUTYqkOJB0+HulVZV67dL555xnjRz9hNTY3tlTfyz5Lvm7khz+FXXBCdB5XocpYmbnhYhAuK/Oaj/cmnTuwhSbljtcXZNOj1oi3VecdbUIBlEgrLYSynCnpZuGFchoszSbC8oSnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwFIufjELjgv6Yb1kN9/k+Xu2KQL0Jui7Qrs7Suu15s=;
 b=VMMaQccuQzuWbYB2jk0TCvm5xNTN6laPU4endJcLycveDX4y60LasTm97VMmCwcUXXn3+oXH1Mvy4xv8gEXYPlOOSnkdt0cW/9qK21YtZ1cCiQGtdtOhmP2wDGM5uHdLxOlHJoSN9uRQgbQqRmp8tbNY4S3j4MWd59YQ5sWoDac=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 15:01:12 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 15:01:11 +0000
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
Subject: [PATCH v2 35/39] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Topic: [PATCH v2 35/39] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Index: AQHc6TKptHJwZxTiJU2NCyLXqcAHmA==
Date: Thu, 21 May 2026 15:01:11 +0000
Message-ID: <20260521144846.1899475-36-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|DB1PEPF00039230:EE_|AS8PR08MB9243:EE_
X-MS-Office365-Filtering-Correlation-Id: 52bc60dd-5db5-4b05-de67-08deb749f2a6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|3023799007|5023799004|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 n6R5BQ1l4BjfL6FcyFSTvLiT30ualsXcs73LsjVM6bAZAWbuVATl/KHtGgfg8204OTA4I6/GSJvSKxa8e0jkNu+8Atz+VCryrIc/E/Wit+DXqaajk8mP58fkj3h2EAB5EVOxXK+ci/nBzNnIC9wvT+itjuDLzOCr1h+zVBgKmbsvgVz3qNl8V+5wTXvS3aVKA26qeaSiSSRFd57boSnHt5IvUO8rGK/LWaEg8/6tFNLDreVdNa3+PBwDGNNxkyzR2xqiJSvtHETBeBm35rtmmc4iNcvZxos6u3EhEGvb5sGEPkrZOIFc66Lr+JHokUQaWPYXhraGf5yHjc2VlA3NutC6qPd7UG8cgS1KvWlaVZ+HBF1rTkicexuO3fFDf0kBYm6a3ZtHQPtIb5GmjxY4VhwbtoRDOSzN2Gpnu9prSMpHxotcDF56dzqrfXyoQQ4zh/mYnSpLZwm1riz7qaa6w8lz8fho0Ri2ZgtoFlWtpdj9JtMAv5g1lL/5AOayemH3xlFd5BpYqXsh0tm6Qv1eIXcNLU4+3G8OMDjbZMH3PqQAV3vXMFtvhYuB4e6gpb1oqI/3ns/ij8fHHj9RLMljfbqw8xtMroBPiiX4GIemM72iisb+JXgsPcrN82nr85c5rghc3R7bNRz2KVz97si+UcYlES+vaB1OO5fT0cq3vZipj5IlDnFRQELK58Uf9wwQzp0JLos8ViqRqYSutmsuWL2DeCi0yPp7DPRQI5fGkbAsnEplPniM8UcH0/MKquzj
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(3023799007)(5023799004)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 oxWubzupUDKyxTiySEP/4xFatPZ+eYhkdp6i8W7fOl0ytxusVMGpbiCNsFrr8ALfV2ZaILxzz5K4t2j2u17buoNNGgyitQ6cIjE8fr1peNt5Ay/zqFiHAU1VdtI+RFkiV1iJkkCjSNdjC/tX9u4iemZANb4dy61SPZr+nJ4nyAsBoAQYO5G8YN4ieBpitChKOXkWwTW4Wsf3tA4aN5WTllmiQs2acIsuvgPGNxV0/+aX1T315AP4b4xg5WR5tgTFcF7a/PU26Y0aBc6yfH8pVwJonT2bcqRYLFinMIk5Qby7BmoneQyVot2wopNptPJTUDY+qT6uJ4m8NJGAb5WLWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	56577aea-b1d5-40c9-bf56-08deb749cc23
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|376014|36860700016|1800799024|82310400026|6133799003|5023799004|3023799007|11063799006|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	dQ8YBsUVUt5BLmSd21vBzNQ/CsyfFyaEx1VQ0eWdFL4qdT16m8sj3+S23VMXLLcHTtLd14uBfR/t1EH74voO5wgJMIa5Uog/4jOEo13JwTBojdwqnAiQvlQcCzvip2K7IEqj3qlWbN8MrkOEbftr7rlwwM6xSqjp+Ptxl1L4CTNNQ9nU5wyt/ZGfE/tvTqaOLkU+ZvJ85OKVR+gow7UELrRD22Hqxf7d7nllbXWw70eb5CDNjyY99rbQ19uxxFCO57nAe5eth556YkOnyPzks7xmV94FURBM2Td5hFeDsSEfm2577CHohfKqWsCdHMHAno9myNWl85uOlghVlJXItk7upB96Jw5Bnlij9E+3A35udMSOtPN9jeQs6gISoB4WAZK0xsLzrBMoAWIgDBcxcdLiweLxAnPku12CwGcchMzvrSrgc68Y5tgZeGsuKRrcCaSyn2U9E9ZTuPfYTxCADkBSNquPZ5z/pogeTy4PsAqkWvw3DLjwi0ZxR9z9SVOLwt8hnf+MJSDZlJ+ImtbiSkb48ODTLwKefgEzLmCDSjOsYr/2m5Jtv18Ll1zMNlWX0DzL+Hep+WZjnkVmJ6G4atgSgCVVu8TOsWo9I4o+gVblpNb92xURHCisWGhC1+Ro0xCVBz6d3u4JIH7BevErZUoraQT+gKsa6tg8YEoA8Zm8ri9kIQ8JbU6uc8in7Sc9Bkrd+yY8iQhgosBHeCIRXpy6mA7YiTW7faRX2rv1BRY=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(376014)(36860700016)(1800799024)(82310400026)(6133799003)(5023799004)(3023799007)(11063799006)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Zldz5g4IElOum0Tz1Us4qUt99bke9RrgY/wFxlLMK1trJCkkFJERcEIuxgM/v0DwIuKZ1Gp67tWUYg1LQlGJiKxK2epfgH4ss15H5wURVHC1kObVtA/qa+31lumltY7iRksCuEQFNfgCqiILPElNKnv7Mo0Q+ZGkqbRWOYBS4GVL0nu/4qea1tNpI3BJ9F71Ew4uQyHHdi2rb++DNPZMzZ4HAWDcLvEcYOVCOcQwdpPqL/f1o1aJk1LHi6QDd16g2hOaZluuN6yvOZ+lup8gDAooRDN/1DL4tR2oY4NxDr6XbyQOID2l4Twg2+/jNZvZKCqWAbTnipRsV8WzEo5nTut0nw4nkxfg8ezwnymcMZ7+3tysJ/+O4m4miJ7chKJyau/Iu80sOsZ1Hl4mW5k67P/NqVsg02BABmvUyuCtVvrZV1/NQTaqyHXNrYpYFetJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:02:16.3646
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bc60dd-5db5-4b05-de67-08deb749f2a6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039230.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9243

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
 arch/arm64/kvm/vgic/vgic-v5-tables.c    | 645 ++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h    |  12 +
 arch/arm64/kvm/vgic/vgic-v5.c           | 286 +++++++++++
 arch/arm64/kvm/vgic/vgic.h              |   3 +
 tools/arch/arm64/include/uapi/asm/kvm.h |   1 +
 8 files changed, 981 insertions(+)

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
index b7808555adc82..92f646036439f 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -945,6 +945,26 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int=
 nr_spis)
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
index 2df470d29d64a..b499731aa4ec4 100644
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
@@ -440,6 +490,13 @@ int vgic_v5_vmte_init(struct kvm *kvm)
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
@@ -544,6 +601,9 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	kfree(vmi->vpet_base);
 	kfree(vmi->vmd_base);
=20
+	/* Unlikely, but possible. Avoid leaking the memory. */
+	vgic_v5_drain_pending_irqs(kvm, vmi, false);
+
 	/* If we have an LPI IST, free it */
 	if (vmi->h_lpi_ist) {
 		ret =3D vgic_v5_lpi_ist_free(kvm);
@@ -1112,6 +1172,18 @@ static int vgic_v5_spi_ist_free(struct kvm *kvm)
 	return vgic_v5_linear_ist_free(kvm, true);
 }
=20
+int vgic_v5_lpi_ist_exists(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -ENXIO;
+
+	return !!vmi->h_lpi_ist;
+}
+
 /*
  * Allocate an IST for LPIs.
  *
@@ -1184,3 +1256,576 @@ int vgic_v5_lpi_ist_free(struct kvm *kvm)
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
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
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
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
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
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
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
+		ret =3D vgic_write_guest_lock(kvm, g_entry_addr, &h_iste,
+					    sizeof(h_iste));
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
+			ret =3D vgic_write_guest_lock(kvm, g_entry_addr,
+						    &h_iste, sizeof(h_iste));
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
+	struct vgic_v5_ist_desc ist;
+	gpa_t g_entry_addr;
+	int ret;
+
+	ret =3D vgic_v5_get_lpi_ist_desc(kvm, &ist);
+	if (ret || !ist.present)
+		return ret;
+
+	/* The guest LPI IST is saved through its linear GPA range. */
+	g_entry_addr =3D kvm->arch.vgic.vgic_v5_irs_data->ist_baser.addr;
+
+	if (!ist.vmi->h_lpi_ist_structure)
+		return vgic_v5_save_linear_lpi_ist(kvm, &ist, g_entry_addr);
+
+	return vgic_v5_save_two_level_lpi_ist(kvm, &ist, g_entry_addr);
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
+		ret =3D kvm_read_guest_lock(kvm, g_entry_addr, &h_iste,
+					  sizeof(h_iste));
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
+			ret =3D kvm_read_guest_lock(kvm, g_entry_addr,
+						  &h_iste, sizeof(h_iste));
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
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
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
index 0ca0ae798dda6..ec54208e8825b 100644
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
@@ -95,7 +99,15 @@ int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_spi_ist_allocate(struct kvm *kvm, unsigned int id_bits);
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
index 05fd10030da84..f89028082529a 100644
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
@@ -240,6 +241,17 @@ static int vgic_v5_irs_wait_for_vpe_op(void)
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
@@ -401,6 +413,27 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_i=
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
@@ -1212,6 +1245,46 @@ void vgic_v5_set_spi_ops(struct vgic_irq *irq)
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
@@ -1353,3 +1426,216 @@ void vgic_v5_save_state(struct kvm_vcpu *vcpu)
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
+	if (lpi_ist_allocated) {
+		WARN_ON(vgic_v5_send_command(vcpu, VMTE_MAKE_INVALID));
+		WARN_ON(vgic_v5_lpi_ist_free(kvm));
+	}
+
+	WARN_ON(vgic_v5_send_command(vcpu, VMTE_MAKE_VALID));
+}
+
+int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
)
+{
+	bool lpi_ist_allocated =3D false, vmte_invalid =3D false;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	int ret =3D 0;
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
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
