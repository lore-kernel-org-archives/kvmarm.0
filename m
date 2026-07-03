Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013020.outbound.protection.outlook.com [40.107.162.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCA927F017
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094821; cv=fail; b=GTfes/fXmpxTkhGCRSLa/40Qtbpze6xtUangROp9099oqVZB/G9WJgO5pSGDKB9BsNroYWhQxLA2aM5SXwSBMfcjkFgz35XQJWAS/dz2IRcx+XOrMpzpT3Xvu/bcQOiwQQ9+1V2YW3BmAB4mpxq/HS63B7IAhr2NVps981wpTNM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094821; c=relaxed/simple;
	bh=8+A+TC7MrwXMpddgNQQthV0UrBPjsqGpxnwsfxivzjg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o8ejtGQDL5Af6EPeOTxzBlka/6McbpyeX2p/RL5a6PmdKk1u/lmwWAcfU75zmhaeHYXPj/suG4Guny5e7zQvPcgYyM8A2BHTBdWD0h0k9XpuERTI16GZxdc2x2/B5tWe36QUCdIIToZQ5sPYVfj1fShymimneblPqLvbr4PK06Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qGiQZ1L2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qGiQZ1L2; arc=fail smtp.client-ip=40.107.162.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qGiQZ1L2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qGiQZ1L2"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=npU7WMs5ZNIx+utgU0LslEWk9tVywZtbjCCORfRpTb1cXr5zHMAJPjWMnj8GewpGzypjWS5+DMxeAqjk9NXWBlljOFQIDuFYJ2sbyRH6hXfAnY5uoo8rKyPHwNGejqcku+C/FDlBXHfoZHjAF4BgKE1KYdK5WQv8OCzZ1ardg6afkyrzX4J3hPOARKtst8Iu044ffcQSOnrgbgTj3dHJqz7JaONBVbWau0RBs6Rg14IOZoCs5GPopMETGVd2p5EudHEebRjqHKf+36jYpwH/UTeXaBg/tTTP/bGFsmsehtfV5eqN7VCCp5wjKQA0WOrKWuctSh3T3B1tZu1MH2G6dQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kf1Yme0z97IL/I9juDufayoR8hsiCslk0j3/BdCBogw=;
 b=E4jyYY95CUi/Ac39vN2F/fNqbU1g1txtHao5SxQHtsbXuPT1Pz6AOCuy4WPjXJ/QgZ/AgpjpH0QMXAUWbAPVClByo57dk55ox5BWY7xwb9aopcAoM1fzTQihzmPYOioCIOMi9ZqvcDYSfUJdxMs3y4ilXaeBKrxDlT41DKS049f4RqPgYsP7Qm+SEhCqzqa9DV6I8ZkOPh/12AFT+rcFp545ebmWg8wHyvWMl5nK/+LdLfOu3sllh7ppAlMFHwcAeEpLn4n6QB7PueDqZJKYMJ723rU63TxgjW4a7kfgbFdZAh2W9KqXSDxOSfRSs6VNd2HH5GNNGczYailvYIIBtQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kf1Yme0z97IL/I9juDufayoR8hsiCslk0j3/BdCBogw=;
 b=qGiQZ1L2avxkUEJxgFsD+6J8xhaE3WIG7TRTJcjbMxYy6a4YMSwBCfiJ6ZTDamCMCc7JaajuqC3Sq9BbKi/RQeFsstVeOUC4MNwGF2LEjhb4lQj2hRvpCrHimf2hFu78aTRIpklhuEMdsex00dVmbly1hYdDh0XUuocpB3+z4sg=
Received: from AM0PR02CA0122.eurprd02.prod.outlook.com (2603:10a6:20b:28c::19)
 by DU0PR08MB9605.eurprd08.prod.outlook.com (2603:10a6:10:44b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 16:06:51 +0000
Received: from AMS0EPF000001B6.eurprd05.prod.outlook.com
 (2603:10a6:20b:28c:cafe::53) by AM0PR02CA0122.outlook.office365.com
 (2603:10a6:20b:28c::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.18 via Frontend Transport; Fri, 3
 Jul 2026 16:06:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B6.mail.protection.outlook.com (10.167.16.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:06:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZpLv/6m9Rk0s76gcpArDGU6cOeXUz8mIyEzjx0hIgHtCqXoxjFtHFVk6LNP4AoaHWVku2q6EJ7ditf26e9ChCjeHCS+Y5XX1y7sODOAXnEYTC+eMfKLVVFrtXi7Xrifdnk/8jdc89N1fxuQ6VtrRVv5cGPwLJlHtJE8bBQMarSHlIeQyVcbrANCBKyZxU2XtAZ0pOPrU8RRyENl2T0xO5Zt/wxdAnhfJPE5hsJ64GIOjhNe7WxaWOVkgHkVLvhgalxnJOeZsdK6oGmJPPFlk1Uc/xbNi7SE+O3cQU9Y4pI2dwPkY4IYmx6NcG2L5nxMxKiFx1qjdfigiCMGMrgfh9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kf1Yme0z97IL/I9juDufayoR8hsiCslk0j3/BdCBogw=;
 b=BFcS1XFpBFQF3ASFdaigXfKp084Al6FYoenoAafD2RfxRXAf8TAzQXR/lCUYAYc5g3MGQCa0OzQY8X3f5Tst/Ospm1r6l+QvorIf4jThrLz6/aq7vtWdZQbB3cWu+F2n+G97GiF4HSXBf75wWWpeU36+vdG/6VYKIiLxTi/hjfj3WHLuoXClysQ8L2MkE47oNQ2tjDGuoB4EoS0fwAMrBo89xe0/x5bW5FxPWRvBFNcpA/cWkZZm8TosQXV6V/NNUA5etgd2ak35825aEKZZuo8rsvv+zsC34POkgwHugw6x0U5z8rJP6o4Tx7oaP+bCl4G0Dv2Hlk9BAB+EGqRKWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kf1Yme0z97IL/I9juDufayoR8hsiCslk0j3/BdCBogw=;
 b=qGiQZ1L2avxkUEJxgFsD+6J8xhaE3WIG7TRTJcjbMxYy6a4YMSwBCfiJ6ZTDamCMCc7JaajuqC3Sq9BbKi/RQeFsstVeOUC4MNwGF2LEjhb4lQj2hRvpCrHimf2hFu78aTRIpklhuEMdsex00dVmbly1hYdDh0XUuocpB3+z4sg=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:05:48 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:05:48 +0000
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
Subject: [PATCH v3 30/40] Documentation: KVM: Extend VGICv5 docs for
 KVM_VGIC_V5_ADDR_TYPE_IRS
Thread-Topic: [PATCH v3 30/40] Documentation: KVM: Extend VGICv5 docs for
 KVM_VGIC_V5_ADDR_TYPE_IRS
Thread-Index: AQHdCwXQrf9JFcJS5kaawpGuGjiecg==
Date: Fri, 3 Jul 2026 16:05:48 +0000
Message-ID: <20260703154811.3355680-31-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|AMS0EPF000001B6:EE_|DU0PR08MB9605:EE_
X-MS-Office365-Filtering-Correlation-Id: db4a6468-a630-465b-4e28-08ded91d17cf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|18002099003|22082099003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 l7GiHKIU4LDXRBUE9tJYiBs4KJn0rlzQGNpE8pVD5rQIGBC9ggKecVQcPyGhlBWzzfV1tk7TAk5hIZj/V8SSOfWg5+Of0UiH0D9/jrWTM3DYgLZfM+JWt1ryix88MgFUxI5dYE0Gr/saYTeNG074ovwf7RFMsTFCvTmDJxPlDKNwJD2L967+qJrpOnYDpCPwGlZlqRntsOI2qMHxDWPV5vqmAa/zK00rHzU51XcSWJusfyNcmGE42sgk+aVRVXKw0S0Ytq5qTkIOUWHVX199TNNWNP1czOcoXhLWY/kJZeFSYRqLuz0dp9ALachDWWP2rxOcteGWwPyoLooB1ESY5BOm6fFSmpFHvm9PJNSL1sKEFbtTgK27l0CXasHYYjtas0QFgFXqXst9r7FfbrWPbVQnjFtomqf5P2jNmvXw/wXtnQP2rTT0pwSf6qHogMxtxla3aHWXFi4yqyyni5ZoPx0/cji4fx86iehZfM55j4JE6OAJpc+jqzOnvvTWM1ujfFugBgk/iS9ydprqVgObqAQVBJZDd0R6XSm90qp7iV2t0nemKqnUTddXCuOm1rT+6hVKAF1VqEe49qUEOTdfcPuW7hb+kAmk3W9TKIpuyvlllOH7dWp3z+2qEowI20l+45Nm/y1SjbG9mWLEiGeFe/daYB1k1wkkO7LgeHXOKbFz1ja2kBgMfEif7ql05NVUbkwJTR6o7+ZeuhuTrRzhYF1IxxU9FkG9ewUEhbfTlN8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 kx2atzZcv8JuHCX0pShZvNWQr/cRx2RujutJG8ORc48Tj8VEHzZb361oQqu5xFS47oSpNDhy3tWD8XVaLVWNyAe1N5qC0WaUHwvd4CQYH6AE8DVGSnKgXhACqZIq79ktfi/3enGbFziCvlHBKuak8pqBULJP9d9Idc7g0J8xsucV5FaEmPWaS+BxQ398RPnBeUcqexGu74BpqfOq/BJZAkUb9S/zy7JmTIYNZVFyrjP4uG+aBl1a5CYlmymHEfmHT1RWOCQLg+auv6SSvmurjRI9y+EU21EcIOT//R4u1dfEgcg7lc9YH3x/cxunesSF++yD2F23RwwtXR1+D29uCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7fe3c932-01d6-4710-59e0-08ded91cf2a9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|82310400026|35042699022|36860700016|1800799024|30052699003|376014|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	PLZSAXIz3n1Qts7x83ilnNlgyATtd5XFb8QPWY7jxcuLTP2sHjnNaECeTKZetjzRKZjxukbjPb6Ksz6+x0TidhkuxL5XeoxBP6d6SsyrCstaEkNGY3/w+E0OlY8WdzFjdTt+CLsIe728ifSSfyVpwh2mKIOwHl/6AUMtNW+EDxacASfHnT3Q2tfDHgcwUBRwz6xk3XloX5pZ3FduX+8oYM7qshgsMM7FuNZ2K7zN8ophVwlAIcOsve4ggAJe/mMMzvwyrrZIovyX0B/1h8SNBD2fGVw9sZ9pyuXlO7ozAPGno3bvPXFFdBEvxCkVNWsFEh6nxKPFqKECc0/jE80wnCcezYlMCilLbmiMC/OexinkcgN8Fh+22VhzdYum1BBCnQndEPdVzEhbmMxueZsXLmrTF0q1EsmwC1Z6/pN6kFRbViYk8AUy8DQFSt4KOSUMRFET7El+isw20q9377R0PY0VRPRHzXnFe2xquGiAiBkPR+4i0gMym+nt58aVkLrv425tSyRYoMrfpb3Ofa6P1E98lXxDMLKswVPQeVDhwGO1mZGfq9Czjs5/9MAKa27DRg1+24jPJgHzCuogobhpDCNhfrQ0/BSI8nDM7MwbPd+a5usc910OhClahcU2GvZKH0kM31LohxRQ3jWw6cdv6d4kCwWKRIETtoywGIMPOxIjM0gCez+eahjmJf8fVg9SkgHGa/I1wySy2DO/hMNFFg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(82310400026)(35042699022)(36860700016)(1800799024)(30052699003)(376014)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jV9+9WL313zfr+mWv1oRVVDMczu+tOqXBBnTWMvO8PYzSrrbNTcsJE+fJOHJR0tBFiO+JIoDlIatDF+qJrBDD+8DokkbbKO97WKknEsMw6OuVr8/U7L3eyh2T76/cJn2ni51nfQyne1M3HLgkUFmw9+rrxKwmm84lwkXrj7U33Uj7BeS9x0+xX0Al9rT5ccxRao8VMbQFbmoe9/Pkf1NZv+LoNlq1hEV1Qr9s/HnQXMnK9uGiNqNIi+2w/32pTZ9f3CIHf5gHqk3BIVAUkkGbp3/GzfS4WFzNikdzNMI7QYXe3U5Dvrhbs9YgSUG2ewJJ556SJMUxcDlR21H+mpgCqxm5sjsQwdnQKnNUZv9m+3xXgzvS1PGRT4auPE1RU38foysWOFImJdyoBjla4aMRzz6IGIWZe+zZrJt8gjqE2yHva+8eA9eREMQEXNrczDK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:06:50.8979
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db4a6468-a630-465b-4e28-08ded91d17cf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9605

Now that it is possible and required to set the address of the GICv5
IRS in GPA space, update the documentation accordingly. This region
must be 64KByte-aligned, and covers a total range of 128KBytes.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 35 ++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 70b9162755c7e..5c6323d82f784 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -12,12 +12,39 @@ Only one VGIC instance may be instantiated through this=
 API.  The created VGIC
 will act as the VM interrupt controller, requiring emulated user-space dev=
ices
 to inject interrupts to the VGIC instead of directly to CPUs.
=20
-Creating a guest GICv5 device requires a GICv5 host.  The current VGICv5 d=
evice
-only supports PPI interrupts.  These can either be injected from emulated
-in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
-ioctl.
+Creating a guest GICv5 device requires a GICv5 host.  The VGICv5 device su=
pports
+PPI, SPI, and LPI interrupts.  The PPI and SPI interrupts can either be in=
jected
+from emulated in-kernel devices (such as the Arch Timer, or PMU), or via t=
he
+KVM_IRQ_LINE ioctl.  LPIs are not externally injected, but are handled in
+hardware via the LPI IST.  Their pending state is driven directly by the g=
uest.
=20
 Groups:
+  KVM_DEV_ARM_VGIC_GRP_ADDR
+   Attributes:
+
+    KVM_VGIC_V5_ADDR_TYPE_IRS (rw, 64-bit)
+      Base address in the guest physical address space of the GICv5 IRS
+      (Interrupt Routing Service) register mappings. Only valid for
+      KVM_DEV_TYPE_ARM_VGIC_V5.  This address needs to be 64K aligned and =
the
+      region covers 128 KByte - the IRS has a CONFIG_FRAME and a SETLPI_FR=
AME,
+      each of which is 64 KBytes in size.
+
+      Setting the address of the IRS in GPA space is mandatory before VGIC
+      resources are mapped, as the IRS is responsible for handling SPIs an=
d
+      LPIs. Failure to set the IRS address before the first vCPU run resul=
ts in
+      an error.
+
+  KVM_DEV_ARM_VGIC_GRP_NR_IRQS
+   Attributes:
+
+    A value describing the number of SPIs for this GIC instance. This is
+    GICv5-specific: unlike GICv2/v3, the value does not include SGIs or PP=
Is.
+    The value ranges from 32 to the maximum value reported by
+    GICV5_IRS_IDR5.SPI_RANGE, in increments of 32. If userspace does not s=
et
+    this attribute, KVM uses 32 SPIs by default.
+
+    kvm_device_attr.addr points to a __u32 value.
+
   KVM_DEV_ARM_VGIC_GRP_CTRL
    Attributes:
=20
--=20
2.34.1
