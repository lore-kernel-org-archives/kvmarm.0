Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012010.outbound.protection.outlook.com [52.101.66.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5C93A6B65;
	Thu, 16 Apr 2026 11:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776337529; cv=fail; b=Q9vz9tPCYPe42jx3UT9aSJ3VBHIu9UW2f4UwU/OA1FvY500DeadicDgPcZHwgIEqB/ETgPIG9uh4mfmlJi976P2Addof65sTvtXjGI7wCud08h3xGECArcDHSVXlFp6YWUHLp0tcrs1SeJZTSHu3D3Ul/dxawHXNcAqIJpdJkUA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776337529; c=relaxed/simple;
	bh=Cvf3Zvav4RJ6xWUjYNYsQGu7sYXq3KddEaT7dJKDeUA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n7ccXC5UVikCyUh1zgGtAeLkpdL6IvyuysVrAM9ONOZdw/CUubUjwekcP7M1Q4Bu3FwHqsti4G95lSh39VSbN9ndIXRpWflMt9tR9kpu5mvMt8j6nHSeW1X3V+o9RiErnZPUqExGKbtPc3lL2OmLO8GoX8U5WNszYFqhxlmBcZw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mj/DqdkI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mj/DqdkI; arc=fail smtp.client-ip=52.101.66.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mj/DqdkI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mj/DqdkI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AJ2keNtg2ma6L10znLeh142BOsrTQ1s0ILTLoLRZUB9D47qk4ZV/4d/NJU4BpT9130ZQ9DRGHodacxGrTB2STskWhy8socEfXHTMRJWPubWKjIm8e/aGtbZKdkglhyYdlc6iLv5ldlkd43nnCNlKpWiqet36iHYa4vU04ZDmYh0A8rH+1IMCAc9HwkpY18oxQqGNiN2bqLgbyBofPJV6hZ/qwzle1t+7a+swLz7NAPYc4fWnTq86AsMp6kIJhzN0wG541uAMUk1DAWvi/YO5hpVwHUeT6+kVZ8VcSlAmJ3kp6/onyJXYJ+3tEbp3OzhEelirDwx93Ixl87c6JZmCVQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALG5GnLmGfFfoegwIP3Lw9ViLOeABCJz4O4Uy8fA0X4=;
 b=WqPzs7h09LDDE2jDsvD++52MAjaVc2cgZbl2z03BVF2t2jYQ5xOytrl4qMxxzEKCGKZetmARNGwVylvrxTr44UEQLpFIhNhCpLCpiutdm5WV3DsOq/QA+bDwBTUyCpOUAgArPj/zE24t9wJBCPhV3ejDlWiQ4ZwJKwF45miBZcA3G0N5sCYH8TjPH1xwIpzG2xBXjoCFyHnhkQMzfHt+6tSgPjygWV+92vfzjVi6sHmx3RGQI4UDuAIR1SMMt5DmigvByiLT68MIyVn6sUAqWqdoOrZxbzz9KhhiGclCnajTuskntiSvYgETy9b0bZevizS3XmQmEI/ENxQxq1Sl9g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALG5GnLmGfFfoegwIP3Lw9ViLOeABCJz4O4Uy8fA0X4=;
 b=mj/DqdkIOpSRGdCA/x3ZXKqYedn5+WzP8Fz6svrX7fSuxJLn3OG6oJv+hzVeapqXyYv5h4CPRULjcTJ5S04uA6fJp5tIkDgAPQKumMxt8ustPWed2bmWk7BE886xRA7767WiOll9tzRSj+yB3BCgE/PDbHj6nzsWpGBfFwSVuRQ=
Received: from CWLP265CA0489.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18a::10)
 by AS8PR08MB9219.eurprd08.prod.outlook.com (2603:10a6:20b:5a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Thu, 16 Apr
 2026 11:05:22 +0000
Received: from AM3PEPF0000A794.eurprd04.prod.outlook.com
 (2603:10a6:400:18a:cafe::96) by CWLP265CA0489.outlook.office365.com
 (2603:10a6:400:18a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.52 via Frontend Transport; Thu,
 16 Apr 2026 11:05:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A794.mail.protection.outlook.com (10.167.16.123) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.17
 via Frontend Transport; Thu, 16 Apr 2026 11:05:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qM6eypYijrx0+mmpugRkdj3cNLtFHFsau3/yD6TytOQIoDpHm9JjdfVf+v17xEPNQQTMBlWn0eAYkbiKctG+inapVC6pFGsTKqafdglXD6Rw1MLSoSlEdcxp1etVoL6iXC/nIgjUSxGMyb5wh1oR9g6aWPmP0Quj313Vbc3J/TWAtxkHtxHOAlnDfoc2oO1/hVHD/uQFcVbmTaXRSO5ASX4w71prtQCaYauHvmZYbTwbZ8OC/gd5n2RVy+na9HWB4yYD8g0PRFGX59cNuX5wxpBopl/XWBlQy5OCRMsV46qSdB51kqSX7Ap1ut+sFe2kiN/+VA4gdjmMgv46WEdXHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALG5GnLmGfFfoegwIP3Lw9ViLOeABCJz4O4Uy8fA0X4=;
 b=qBtYNzjPRVMmiTr479s1oaHfdoMyQpkgvFqYarFaJVR9DY3vfWvdu6Pwd9y7DPu+S3Au4kFsdSRhRWjJEcWNl8yb0VtyMhf/8VwztiSlOwpbgN1sqIXgc7VMJvcNenyY+J+TP3QcZDHGw3oEeR7sRTenjCZ4KNhFv1/Pg+gM/GFS6aKd/5bdg/TgQ2f+hEOK1B6pWDKViVDCtfocTs2NZIejwqxDwC55SKis2WUgLXXiTsnKfsRvwEh0eV1cwScKxibIkWqM+R3TS6IgjfHJJoL/+e3oV+eywTYxdjD5ixZ2JI1eh1yE9B0qt5uxqGiUli6Qi/TUUj6K/20qhoEXTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALG5GnLmGfFfoegwIP3Lw9ViLOeABCJz4O4Uy8fA0X4=;
 b=mj/DqdkIOpSRGdCA/x3ZXKqYedn5+WzP8Fz6svrX7fSuxJLn3OG6oJv+hzVeapqXyYv5h4CPRULjcTJ5S04uA6fJp5tIkDgAPQKumMxt8ustPWed2bmWk7BE886xRA7767WiOll9tzRSj+yB3BCgE/PDbHj6nzsWpGBfFwSVuRQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by DB9PR08MB8409.eurprd08.prod.outlook.com (2603:10a6:10:3d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 11:04:17 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9818.023; Thu, 16 Apr 2026
 11:04:17 +0000
Message-ID: <97d26e6e-b565-447f-95eb-2ece0755fe57@arm.com>
Date: Thu, 16 Apr 2026 12:04:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: Alper Gun <alpergun@google.com>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <CABpDEukEO4Y_fg8fv5Nr1_Pw_qOK=2UmioXk=WyPEzoEprPcGA@mail.gmail.com>
 <d661a24c-6619-4734-96bd-075d3416e809@arm.com>
 <CABpDEumAVf02uOS5Bj07EDyuU=z9FV-iocQU1j7gFM5z0BeV_w@mail.gmail.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CABpDEumAVf02uOS5Bj07EDyuU=z9FV-iocQU1j7gFM5z0BeV_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0325.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::14) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|DB9PR08MB8409:EE_|AM3PEPF0000A794:EE_|AS8PR08MB9219:EE_
X-MS-Office365-Filtering-Correlation-Id: d53ed203-c4c1-44b6-4417-08de9ba80d2f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|18096099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 0TLkXGZOyQRWM9QcKjXzbDZgB+SmzO8VMuMQWKShl1N3KDHoIOWM1/0IwMtLrjv6yXSdHT0vsPfQRba0/VX1DLiKeNjMdMmgdIOw5RlojSwHXCZqNykK+21U1WWHmlvYqZ2uMQkPhwlhT0FxH9dK0d3ayu6rck2GoURmqp065RuV8VJxucR46W2w8NoSjXmZDf6yB3Znj/BRf8QPwGywXJCVRk27Lq1gFvV0OnJKZVz9bDEMO0hdKdzo31o5pU0osm/L19+Veot70L2FdCNt13YCVIYcgtEXbSNTsuafbvVI4GJ1nhzN4avbEcKd8kEoNVMFVcpk8xAdQ0WY3X6ahH/OQyXsYDoFeVjpRhSIhEG8QCOjMzVZpYPpXjJ8sJIn2ZWdjHLP0S06lq4VzgzbdhXnaEA5nGXWcDN3o9IM7QjFOVrTi4Rhf5MZAV6Mn+B9+HI8S38DznFQ/fbsbm5ibFN49axuI4fvVaNsxMIOrJmdMK9qVj5/JYs7QHfpaxk621GSI/aRGLRgw8Ft85P6XzJLMMuArYiCDUk/a91Xl0Go9TnFMW0aZ5rPIYVfTBV6glCxSBAXTGqw0bJ1Ab5xmcQWClv+lrsxnfASO8NP0a3QSGa2CJ3FNo+GC+/8XsBVhbw+nnVHjOO8jXWpRsqO1ogjcnzywKlLZHxTQVMz3A44OXk02YNy40l7VBxndGfoNMnAk1JSqEmgn7B7IxaS5yGHVXJsYX+j0H2xVxLJy6zHYPfNKnfujp8iQvG0QbJu
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(18096099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 In0Rz5Ny0paMZOZ84inQDZBrLdtki4BRe7EkYvW7XwCZyPEak+U1LPN/6hr0F0XoSq+n86qtBuYg2QFIKtM7Tv4165jL0U47Wa+MyTJmKjqCqOzQ35hAGkuj4tc2GO5GGmGCd2kqhxF1Ie914N4tgs1k7c6N8AjfGbuMz3I61q07LDKzH1CVs8zmW2jh8P1ic+S+4RVKw3jVTzi22gsy1XPiiBiyL6E5A5BTO4xaretwpxSQNApEqcdgmgQAnLPyfXSptpOt1xh57HsTF3VtLXjCc3mpKx7QxZOsyPrALhU8EjeSB40pXydt/z7MjLM3mqcQXCTxC9e58MpWCqLy/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8409
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ea74d898-3c5d-4218-f98c-08de9ba7e74e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|7416014|376014|36860700016|14060799003|82310400026|18002099003|56012099003|18096099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	auSCbfsp7fgbSXi7WJEmTvSMLZh/oVV4XVH3tkl8aA0B15PY3Efn9GxhC087WV2M6JXbOUoQtvCOt0Uq4puIXzeTtt4yu49uZoFmHekoRG2S8SBrQZ8JTUHyIJRQ95fBD+2dK+7Wh2BCJTdGLIID/A51gvD6l3f0vVB27BzEEcXT8V8WhrRnjFxYDoRCo9Go3izDEC4zRKVWpUFl96+K3N36VbDo5hwcIqXbhADn8+ggNJ1l3LlNhzRiVxwn3jEGksf1HPWEk7m4jbvFiaAO4qqTdJEolMn4uZ2WmEvGOep3EzZKx8carXqwIAIh2jT4zIAGNM/bAKsfTKjk13sTwcw57hmsf1OGqaDO3OphrjpLt+XG7ERFpVVsJZ8sk2lz3bf9fMf8qZP8yeOu1SWjkIvs67geMaRSwbINgNnhEkdKPDTEaYisvOSCzkrwAYpedaNbH/YVj5byKH+eanCuCwAZ1c2V/cwsK7pc/RGLc0a3qJtfUWaKYHqmORjQuwTVipOgSqq9i/AaXaxKuHdquQ157DgsXhincSPlOUoG9rqkMVu1QBsUpEWteuHzwHGxwvRkXMiaGNiMg3Idbdrd5pVxTBHigkD3CEQmmPsD/eM24ufyV5cWnwzcCmCxodFIljh545j26Nwc29reL0szuX52sweFHJS33/tls/KFVRUdcCNmwxNaivQHj0uHuZ3zNzbFICifn5UTGyP9tqrO/9fFO7xoZ2Zdj67OK/AVLvdTeltnvtgnVf+jmDUT9hQyYhwPVIs7pzqDD+o3kIyikw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(7416014)(376014)(36860700016)(14060799003)(82310400026)(18002099003)(56012099003)(18096099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KA1Lp9bgheddSDSPU6by8gzlXVTxl47xp6iU8anlAJacPsUWTTIopqa4CVlgH4r+cj2oRLXwSZd8rS0lAFOTkRk9Vkz2BKjeKLKliu957x9TFqzRhgGSCdvQYGzTNOKF3nCaWYAPy57L8UgmQxQ9z15zCsMeTEpTOqyxhnslfTxyWxoQ3NGUMxPGkvIDgE4FVIMTjG1h+2LJp+mJbWLODmsAJCX8e2y0cOCPsWSPaGlaqBSgv7QRM++UEw/BJucU2H5p2LwME0PczGklX1yNfAz+KRwf28ix1EpcGcL288gwMus6dL0EfIEwLyOVNrAsiJaOiRaJPTMffyMhcjrKN+x4TQ2uBuKz/VMSQ4kpPjIKIut8Yg94Cm2a0gXz4/ZsmMtGqn5Osm8K7kbwWWNO9a/h09KlIoiMOXAN2S4KQKgWoYghBqk+KZieKE+rg7t4
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 11:05:21.0108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d53ed203-c4c1-44b6-4417-08de9ba80d2f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9219

On 16/04/2026 00:27, Alper Gun wrote:
> On Wed, Apr 15, 2026 at 4:01 AM Steven Price <steven.price@arm.com> wrote:
>>
>> On 14/04/2026 22:40, Alper Gun wrote:
>>> On Wed, Mar 18, 2026 at 8:54 AM Steven Price <steven.price@arm.com> wrote:
>>>>
>>>> This series adds support for running protected VMs using KVM under the
>>>> Arm Confidential Compute Architecture (CCA).
>>>>
>>>> New major version number! This now targets RMM v2.0-bet0[1]. And unlike
>>>> for Linux this represents a significant change.
>>>>
>>>> RMM v2.0 brings with it the ability to configure the RMM to have the
>>>> same page size as the host (so no more RMM_PAGE_SIZE and dealing with
>>>> granules being different from host pages). It also introduces range
>>>> based APIs for many operations which should be more efficient and
>>>> simplifies the code in places.
>>>>
>>>> The handling of the GIC has changed, so the system registers are used to
>>>> pass the GIC state rather than memory. This means fewer changes to the
>>>> KVM code as it looks much like a normal VM in this respect.
>>>>
>>>> And of course the new uAPI introduced in the previous v12 posting is
>>>> retained so that also remains simplified compared to earlier postings.
>>>>
>>>> The RMM support for v2.0 is still early and so this series includes a
>>>> few hacks to ease the integration. Of note are that there are some RMM
>>>> v1.0 SMCs added to paper over areas where the RMM implementation isn't
>>>> quite ready for v2.0, and "SROs" (see below) are deferred to the final
>>>> patch in the series.
>>>>
>>>> The PMU in RMM v2.0 requires more handling on the RMM-side (and
>>>> therefore simplifies the implementation on Linux), but this isn't quite
>>>> ready yet. The Linux side is implemented (but untested).
>>>>
>>>> PSCI still requires the VMM to provide the "target" REC for operations
>>>> that affect another vCPU. This is likely to change in a future version
>>>> of the specification. There's also a desire to force PSCI to be handled
>>>> in the VMM for realm guests - this isn't implemented yet as I'm waiting
>>>> for the dust to settle on the RMM interface first.
>>>>
>>>> Stateful RMI Operations
>>>> -----------------------
>>>>
>>>> The RMM v2.0 spec brings a new concept of Stateful RMI Operations (SROs)
>>>> which allow the RMM to complete an operation over several SMC calls and
>>>> requesting/returning memory to the host. This has the benefit of
>>>> allowing interrupts to be handled in the middle of an operation (by
>>>> returning to the host to handle the interrupt without completing the
>>>> operation) and enables the RMM to dynamically allocate memory for
>>>> internal tracking purposes. One example of this is RMI_REC_CREATE no
>>>> longer needs "auxiliary granules" provided upfront but can request the
>>>> memory needed during the RMI_REC_CREATE operation.
>>>>
>>>> There are a fairly large number of operations that are defined as SROs
>>>> in the specification, but current both Linux and RMM only have support
>>>> for RMI_REC_CREATE and RMI_REC_DESTROY. There a number of TODOs/FIXMEs
>>>> in the code where support is missing.
>>>>
>>>> Given the early stage support for this, the SRO handling is all confined
>>>> to the final patch. This patch can be dropped to return to a pre-SRO
>>>> state (albeit a mixture of RMM v1.0 and v2.0 APIs) for testing purposes.
>>>>
>>>> A future posting will reorder the series to move the generic SRO support
>>>> to an early patch and will implement the proper support for this in all
>>>> RMI SMCs.
>>>>
>>>> One aspect of SROs which is not yet well captured is that in some
>>>> circumstances the Linux kernel will need to call an SRO call in a
>>>> context where memory allocation is restricted (e.g. because a spinlock
>>>> is held). In this case the intention is that the SRO will be cancelled,
>>>> the spinlock dropped so the memory allocation can be completed, and then
>>>> the SRO restarted (obviously after rechecking the state that the
>>>> spinlock was protecting). For this reason the code stores the memory
>>>> allocations within a struct rmi_sro_state object - see the final patch
>>>> for more details.
>>>>
>>>> This series is based on v7.0-rc1. It is also available as a git
>>>> repository:
>>>>
>>>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v13
>>>>
>>>>
>>>
>>> Hi Steven,
>>>
>>> I have a question regarding host kexec and kdump scenarios, and
>>> whether there is any plan to make them work in this initial series.
>>>
>>> Intel TDX and AMD SEV-SNP both have a firmware shutdown command that
>>> is invoked during the kexec or panic code paths to safely bypass
>>> hardware memory protections and boot into the new kernel. As far as
>>> I know, there is no similar global teardown command available for
>>> the RMM.
>>
>> Correct, the RMM specification as it stands doesn't provide a mechanism
>> for the host to do this. The host would have to identify all the realm
>> guests in the system: specifically the address of the RDs (Realm
>> Descriptors) and RECs (Realm Execution Contexts). It needs this to tear
>> down the guests and be able to undelegate the memory.
>>
>> It's an interesting point and I'll raise the idea of a "firmware
>> shutdown command" to make this more possible.
>>
>>> What is the roadmap for supporting both general kexec and
>>> more specifically kdump (panic) scenarios with CCA?
>>
>> I don't have a roadmap I'm afraid for these. kexec in theory would be
>> possible with KVM gracefully terminating all realms. For kdump/panic
>> that sort of graceful shutdown isn't really appropriate (or likely to
>> succeed).
>>
> 
> Thanks Steven for the clarification.
> 
> For us, kdump is highly critical as it is our primary diagnostic tool
> for host crashes. Without it, monitoring and debugging at fleet scale
> would become unmanageable.
> 
> To confirm my understanding of the current architecture: if a host
> panics while no Realms are actively running (and therefore no pages
> are currently in the delegated state), the standard kdump extraction
> should work perfectly fine without any modifications, correct?

This may not be true. We could have pages donated to RMM for GPT,
Tracking etc. So, unless Linux keeps track of them, it may be
unsafe for a crash kernel to access them.

> 
> Regarding the KVM tracking structures (RDs, RECs, RTTs, etc.) when VMs
> are running, perhaps we could use `vmcoreinfo` to export the physical
> addresses of these delegated pages. This would allow tools like

Thinking of this, do we really need to ? We could access the pages from
"vmcore" read and handle the GPFs for such accesses and give out 0s
for the Granules. Anyways, we can't get access to the data on those
pages that are still in Realm PAS.

> `makedumpfile` to explicitly filter them out. I assume these pages must
> remain hardware-locked while the VMs are active.



> 
> Long-term, having an architectural shutdown command - similar to the
> TDH.SYS.DISABLE command in Intel TDX - would be incredibly useful. It
> would allow the kdump kernel to safely bypass these hardware security
> checks, especially when extracting host-side KVM state.

For kexec, may be we could do this. Alternatively we could try to
reclaim everything back, (GPTs, Tracking) before kexec-reboot.

> 
> As for the protected realm memory, I assume that is an easier problem.
> We naturally want to exclude guest pages from a host dump regardless
> of whether they are Realm pages or not. However, accidental touches
> are still fatal.
> 
>> There is also some RMM configuration which cannot be repeated (see
>> RMI_RMM_CONFIG_SET) - which implies that the kexec kernel must be
>> similar to the first kernel (i.e. same page size).

That is true, the page sizes must match. RMM spec is updated to probe 
the state of the RMM and detect if it can do the CONFIG_SET

Suzuki

>>
>> Thanks,
>> Steve

