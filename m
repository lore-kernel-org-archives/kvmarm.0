Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013069.outbound.protection.outlook.com [40.107.159.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B016C483833
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.69
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523168; cv=fail; b=OcgUgu+OLbAB9HSfiUIDjPuMGGfn58IX2aLp0xEHq/8wI+ig4jNCWYGSOLvAouvnqKFd/jJHz0VZ9P50XBzomIo2V6pKlEh1/H/0dG6mNNbLk5VVXwC9wzMo3URAf/5l4Xs1ssByGfgfTlW24Peof7aFcATJG1qbw4aTW8uDTBk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523168; c=relaxed/simple;
	bh=ZVsmWs/Kml4w0QfcRT7qdjE/y3AGqBBwovv8dG3dzt8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sphSrCJ7UaHvzPsLePb3RYKGYMJI1dcRtewAhA/MM4K5Lq7SiH7N9RAO2DNJSG1aLXg5mPORGSo31TS52d/Yhz6x8OeRfMbqIzzyDGwDMyY060M490Oyi2wmIC/ArC9PaUxwe2hCACnzsEHaDKYOlSX9XE94RwkqnbrwNbxvISQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JttWPoBt; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JttWPoBt; arc=fail smtp.client-ip=40.107.159.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JttWPoBt";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JttWPoBt"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=v49yHIvwY6PhzrcgI6SxRPHbM3OTFeqgY9mintsfWfhBDkP3aWcv3gsMBslqyxPY+vIfxRSvp11jSyp0ruKYWoZ5cPwsodW967UWelqqbLqD3h64IQNEdHh8ManAtprZzGFDZWEfWXuJK0HDQky21ps3ZFLCSTvJmMGSQOy4vw6Z+nNfudCYGNgENFuHOU5kpoMnlWuLQGejefM7lxp2Fhw7eFcReyGSFJPcADoPdha47n1tjfOa2iWiWFET5wG1YPu0JPZv0gR1pW9NjDPA1FLvBA4v8YIZEChLchefgcRN+zj/8CLfEr3l/e07/ylBqPGS9YEJbSZdLzN6nPEKdQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wy+rzdVLTHIFYS0nJ3zExKo5FPjI0sYTMUA1osO64tI=;
 b=sEw45pcrd6NE9bppgsxzPYy/0HiQv5lTaAGS7+fffKpsmkPao4rnB1k5D3e14JL3vGO5tQcDYpqnEfI7n/8nbg3mBSu5bRHtzfa7pjGCtZyZjCwBGE/6AgMRYcdrmiAC1gZw4S36v4bbfH0m2ntNa/B9zVE7ikjbEFIowA78mq0/A/wf/smYu3OXCKVSYsTi38qsBjB2/Qu/9rV1ExpBBjvfHEspki7yRwqvpQg9HyQWJTBkrzDf2CSnLsVWqCBSyr5PXjl1arZEYm1tsrhUyvUQ2ppMhTAhYEZcjpjtCJh3jY1pgu3BVUbUMk61sOCH3kBKIsPmazCfcnV++jQUWw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wy+rzdVLTHIFYS0nJ3zExKo5FPjI0sYTMUA1osO64tI=;
 b=JttWPoBtxWEIMR4tt6iGrXWBq9dbg4mgsnBov+dkIcm1YfAE2dfNbEmXXtsbrGo/hvbDUih2VKwl3JtuCiCIg3zO8RrDKLHxNcENCcUO6E6RByaPl6C3qswqsLuHagZpc/Fkrt2eYUIgp6sxwoRgh91cyZh95qvK8epS9bjUhQw=
Received: from PA7P264CA0411.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:39b::6)
 by DB9PR08MB7697.eurprd08.prod.outlook.com (2603:10a6:10:390::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:59:15 +0000
Received: from MI3PEPF00008481.eurprd02.prod.outlook.com
 (2603:10a6:102:39b:cafe::65) by PA7P264CA0411.outlook.office365.com
 (2603:10a6:102:39b::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:59:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008481.mail.protection.outlook.com (10.167.240.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:59:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WcQIH/vHi2+2jeYwaCnt9Bktw0MlgOrhSJn7VxPYD3/OxAirRzHWRQw90TRW4gsGo/zksVPdM7bkY6eIJUGPQ+6pVyta1ARWkFPQbwQFsoNtgI4QWjV1iJoYii6itBFnSXChBHftVmZpjBeq/u2+E+/1X1/LFTXyq/79pHiCIPEjGAl018LdPhSvk6MIVzA9t35okvLRFXbqx98X8TiWAtYZXnFqAO6gUs/HshaO9/FcVqETpoJwkk8RlJk599Ljy1qM7Px9BdBDxA2NqRP61O+H4WPtx4zWSA13E+HRnOXXDRQ6mNBAi73O/k40gE4kduPE34Y793h+sb+tAidOkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wy+rzdVLTHIFYS0nJ3zExKo5FPjI0sYTMUA1osO64tI=;
 b=f94quibliivpKCtcxPogeeE4EsONuyTx84W0oY5dPUNJcYW+7A1TR2VF8oyeYP4QitqIS/bGd5pTEsK8dRwxU5B+riJB0n/RrJ6wGL4fIU8tmndxQobjIRD7UiSO94ve7mJOXJWjv6ommdAsDa80mbUEV+b+1XbvyILMi65IzXgyttKzLgkRk+/zhzQWL4jmQWZJP3k363OTWH23XGQdoQEkh5rqV33Wf8IiTN8dk6ISDBDFpGDDSI+CUcxCncf5Q06Ge0b3FTwGt1T+YCtLz3gtobnbLc01/jbVESXeqlQwlHOlNe4DAwaLxtdNPu3SLrGzAsdb5PsyX9KRLVMK6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wy+rzdVLTHIFYS0nJ3zExKo5FPjI0sYTMUA1osO64tI=;
 b=JttWPoBtxWEIMR4tt6iGrXWBq9dbg4mgsnBov+dkIcm1YfAE2dfNbEmXXtsbrGo/hvbDUih2VKwl3JtuCiCIg3zO8RrDKLHxNcENCcUO6E6RByaPl6C3qswqsLuHagZpc/Fkrt2eYUIgp6sxwoRgh91cyZh95qvK8epS9bjUhQw=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GV1PR08MB10954.eurprd08.prod.outlook.com (2603:10a6:150:1ee::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:58:41 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:58:41 +0000
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
Subject: [PATCH v6 48/49] KVM: selftests: Add VGICv5 IST save/restore coverage
Thread-Topic: [PATCH v6 48/49] KVM: selftests: Add VGICv5 IST save/restore
 coverage
Thread-Index: AQHdPGS6SEWcc9LP8UKhzFwI1FuzNQ==
Date: Fri, 4 Sep 2026 11:58:41 +0000
Message-ID: <20260904113404.4051341-49-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|GV1PR08MB10954:EE_|MI3PEPF00008481:EE_|DB9PR08MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: a5b7ad22-0d12-42dd-c07f-08df0a7bf107
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|10067099003|56012099006|5023799004|11063799006|18002099003|6133799003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 sLY/sAdH4K+08Eh5XKRBnRVnubuc8flmZS1GiVxpcKnuvY8okLoHnj11hKgLqMN0P006jJpdwTyqNMAVE+ZWew8opWZdpk3/T2L/tf7maUtgqN2BzjO+7k34EIqGu+w6vF9Mai2XhR+esiU416+lTUd4aiXMw1rvBmBlwawjhjvDjAF7frTTjJyz1XgU5kGqj5o1Ne49Pnci3oHVNm2LwKqGRXVjPGWRTmyxJXkeLIMu5TEnioBSCO3bUpKtyt4kYSv6NMKLdQgMcV8tEx87tacGl/CxCWZAF5HhW+cJJHUFa+SRzg1K7JVgR6MfUMGm0l33HS8At/MOFZ6tiYBFol2DePnUsuyXTTW3aWqeKVlrufbDHf5AoZo2mnWvz3Pmv/soururXvycEdWrD9dikkeuji2lPGZcWy6Xz+W7Uj/Hf8WWRVwh6cMD7FXCIZGzpgZEBT7uusAXIE+HeZksg6hzIsTZIOqZn2XsW3HuYXbN41AcNVTA2dS+1lFlmBuatykbXQFFUjcmt98DQaZWqgp3vlJuUqyH/+pMWbJp+T3wzVOey+qbPSjWZdqphu/HWvnLvO0NNzLtJXQ4yf8wC1kGeoKrQ0iJ5Mgsf9lDZj7YECS8x9rqyiVyC1DAF1eaFG6sIysVnJjyQPj+ryDXr8t/mE6D+rZLqgGVSxp/jr6zBbQP2J1qN6EYGVJbE3RjLDgTCNL9tGvHX5MAh2XSIF7kF9vvWdVrLuDpKM2KWmw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(10067099003)(56012099006)(5023799004)(11063799006)(18002099003)(6133799003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Drkb17CQdF8Eur1lE2uvDAGBUXTsniyFrreX30+JXdpz8ALsxIN0BplmTVjfjM6jxjNTXsE9feuy67Jkxz0rh8Ew4j2yDXA5T59kSGcrY0q9kaC9/RmE3WdyhJV8vU3q2k6NU+1ybMiQKgSVB8WZtY6ADIkKK2+O/25qZlyROo55mZOB897G8pGTIYeafq605CQW0wBST7xp9vyHGRwC01Ed7aICQcIirbUbYZd/badLeytHo3950G8HnOeuSTdndHgQGqxbhwPYTBE4b4lPDXaKzYoJY9potmSlPvFR+Zczmzr/+qzwUvCHJj6pKWK1a7llrspt8Djk8W8dhA2Ybg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10954
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008481.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e84e324f-bfc7-426e-21e9-08df0a7bdcee
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|14060799003|36860700016|1800799024|82310400026|35042699022|5023799004|56012099006|10067099003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ov6h/BfxiYdCEgoyyhVulI1B54I+MNP5Ww8wjzfWUmDWfYDEGSZv1AaGqc00XubN63St5nJLWBePzN+MUNsbfCf0kU7YdL/eflMfxW/jDGoqJuCp55Uc+ft5j/fz7TEa5H4qoE0BfjDKDYWAZavvsAs4G/K+n7N+R3PPhmfHztFF0GieVJ6jyEmaj/UKvom2XtMdRy00XXUSUAwQUx121H56bQcCd6SbE7VESU63ojnLzZFnTT+6KHnOQJmhtvT9fNeWWz6CmXvtdPLWpK3dE1eiMmBaWJbZ7de+d21nv4yL5zntMRVPZGMwbcQxtqh0hnzEXzHP6G59Nj2lawnYysJXMKNdIAUwmxwGr8WaqW5LL2zIiV2hc2EkU7PuE6A6C38b8cJGyE5gnsU+f2ynNJGLi078O7nMQmZCqCtdicuZbxrBzMbBVkW2lIRgnozzOel1XTOv5HCgmi8kr7odETksiJZez4sMNspKX1Pwd+EtLHWpK9iTtyc9BzYMhfA4E1/MJjf1Z/FlTEhhVM8x01WKQEA3Fm8UIMXi3txTpBp5pRiznrLpfivdylP7O+f/vo6m7/G8NrIAu3wsZU6p5MZh3yyX2vBS7nZ+cXVRAUH7vQB7apz5xhU9Tg5Z7N+LoP7PWlfTRnDzJV/tQDJnLkYCSlDAF/KdBYqEeVvRLBQ=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(14060799003)(36860700016)(1800799024)(82310400026)(35042699022)(5023799004)(56012099006)(10067099003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QO+5NxbZEvbc9BWLsh4yDd9ZHzXiB0ON3vgyLjNQKgkbJPIWr3tZu16pp7Zj1nvFBoVp3j5UBhWvEViPeyruRvoZY7sEVtkEDDDlThawRqAneSpzKUf85xJtmSQx8qYprIqaiDM/BaMA+TnqQAbSTYB1ZKwQztrWq63nHDbfF3cXqWvqFlBGwKl5VGK64t8GElbY/xlKGzTXBpS+hHUAi6Sh4Orj6R1bOlKjLVSSMfA/5VlwQv37A1uWI3aA8TIRHdgsu8mLfvARz3Yw1kmz+ZaRkdHpNBqFLg91fsj5DPEtla68MhzTJA0NyABeFSW/01ZNuI3kmONiGKWjDyXBws5LwQGIOMGBhnOWCWH5yJOhQZ7XP2CZcyKAkEGf+RNYBZ+tO3Y8IqAr0+PZ3mvHu9y4kGbuxMIHT6Azh9z3WEzB4ntbhff3OVDbsFenOp6Q
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:59:14.9144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b7ad22-0d12-42dd-c07f-08df0a7bf107
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008481.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7697

Add end-to-end VGICv5 IST save/restore coverage. The earlier IST
attribute test checks only API rejection cases; this test verifies
that interrupt state saved from the ISTs can be restored into a fresh
VM before first run and then consumed by the guest.

Build a source VM that configures SPI and LPI enable, priority, and
affinity state from the guest. Inject selected SPIs from userspace,
save the IRS register state, and save both the SPI and LPI IST images
through KVM_DEV_ARM_VGIC_GRP_IST using userspace-provided buffers.

Create a restore VM and verify that IST restore is rejected before the
IRS state has been restored. Restore the IRS registers, validate bad
or missing LPI storage, and restore the saved SPI and LPI IST images.

Before the host LPI IST is allocated, verify that userspace can change
or invalidate IRS_IST_BASER. Once the IST images have been restored
and the host LPI IST exists, verify that matching IRS_IST_BASER and
IRS_IST_CFGR values can be replayed, while changing either register or
clearing IRS_IST_BASER.Valid is rejected.

Before running any destination vCPU, save the ISTs again and compare
the re-saved buffers against the original saved buffers so that
dropped serialised state fails independently of interrupt delivery.

Finally, run the restored guest and check pending and enabled SPI and
LPI state across two VPEs, priority ordering through ICC_PCR_EL1,
delivery of an interrupt that was pending but disabled at save time,
and affinity for interrupts injected after restore.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 506 +++++++++++++++++++-
 1 file changed, 501 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index c4c932f4c1d46..6caac6cf7c62a 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -24,6 +24,14 @@
 #define VGIC_V5_LPI_IST_SIZE		0x10000
 #define LPI_TEST_TO_VPE1		0
 #define LPI_TEST_TO_VPE0		1
+#define RESTORE_TEST_LPI_PENDING		0
+#define RESTORE_TEST_LPI_ENABLED		1
+#define RESTORE_TEST_SPI_PRIO_HIGH		0
+#define RESTORE_TEST_SPI_PRIO_LOW		1
+#define RESTORE_TEST_SPI_PENDING_DISABLED	2
+#define RESTORE_TEST_SPI_ENABLED		3
+#define VGIC_V5_IST_PRIO_HIGH		0x08
+#define VGIC_V5_IST_PRIO_LOW		0x10
=20
 static u64 max_phys_size;
=20
@@ -41,6 +49,9 @@ struct vm_gic {
 #define GUEST_CMD_IS_READY	13
 #define GUEST_CMD_LPI_SENT	14
 #define GUEST_CMD_LPI_REPLIED	15
+#define GUEST_CMD_IST_SOURCE_READY	16
+#define GUEST_CMD_IST_SPI_INJECT_READY	17
+#define GUEST_CMD_IST_LPI_INJECT_READY	18
=20
 static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_s=
ize,
 					       void *lpi_ist, size_t lpi_size)
@@ -56,6 +67,7 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_=
ist, size_t spi_size,
 static u32 spi_line_expected;
 static bool spi_line_level_sensitive;
 static bool lpi_ist_ready;
+static u32 ist_restore_irq_count[VGIC_V5_LPI_NR_VCPUS];
=20
 static u64 gicv5_hwirq(u32 type, u32 intid)
 {
@@ -87,6 +99,27 @@ static void gicv5_setup_and_enable_hwirq(u64 hwirq, u32 =
target_vpe)
 	gic_insn(hwirq, CDEN);
 }
=20
+static void gicv5_set_hwirq_priority(u64 hwirq, u32 priority)
+{
+	u64 val;
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDPRI_PRIORITY_MASK, priority);
+	gic_insn(val, CDPRI);
+}
+
+static void gicv5_set_hwirq_affinity(u64 hwirq, u32 target_vpe)
+{
+	u64 val;
+
+	val =3D hwirq | FIELD_PREP(GICV5_GIC_CDAFF_IAFFID_MASK, target_vpe);
+	gic_insn(val, CDAFF);
+}
+
+static void gicv5_enable_hwirq(u64 hwirq)
+{
+	gic_insn(hwirq, CDEN);
+}
+
 static void gicv5_enable_spi(u32 spi, u32 target_vpe)
 {
 	gicv5_setup_and_enable_hwirq(gicv5_spi_hwirq(spi), target_vpe);
@@ -198,6 +231,15 @@ static void gicv5_configure_test_lpis(void)
 	gicv5_enable_lpi(LPI_TEST_TO_VPE0, 0);
 }
=20
+static void gicv5_set_pcr(u32 priority)
+{
+	u64 pcr;
+
+	pcr =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY, priority);
+	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);
+	isb();
+}
+
 static void guest_ppi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -329,6 +371,11 @@ static void guest_lpi_irq_handler(struct ex_regs *regs=
)
 	GUEST_DONE();
 }
=20
+static void guest_unexpected_irq_handler(struct ex_regs *regs)
+{
+	GUEST_FAIL("Unexpected IRQ");
+}
+
 static void guest_lpi_code(void)
 {
 	u32 vcpu_id =3D guest_get_vcpuid();
@@ -359,6 +406,165 @@ static void guest_lpi_code(void)
 		wfi();
 }
=20
+static void restore_test_setup_hwirq(u64 hwirq, u32 target_vpe,
+				     u32 priority, bool enable)
+{
+	gicv5_set_hwirq_priority(hwirq, priority);
+	gicv5_set_hwirq_affinity(hwirq, target_vpe);
+
+	if (enable)
+		gicv5_enable_hwirq(hwirq);
+}
+
+/*
+ * The source VM configures SPI and LPI state for the IST save/restore tes=
t.
+ * It leaves interrupts disabled, allowing userspace to save the state bef=
ore
+ * the restore VM enables interrupts and checks delivery.
+ */
+static void guest_ist_source_code(void)
+{
+	local_irq_disable();
+
+	gicv5_enable_irs();
+	gicv5_configure_lpi_ist();
+
+	restore_test_setup_hwirq(gicv5_lpi_hwirq(RESTORE_TEST_LPI_PENDING),
+				 1, VGIC_V5_IST_PRIO_HIGH, true);
+	restore_test_setup_hwirq(gicv5_lpi_hwirq(RESTORE_TEST_LPI_ENABLED),
+				 1, VGIC_V5_IST_PRIO_HIGH, true);
+	restore_test_setup_hwirq(gicv5_spi_hwirq(RESTORE_TEST_SPI_PRIO_HIGH),
+				 0, VGIC_V5_IST_PRIO_HIGH, true);
+	restore_test_setup_hwirq(gicv5_spi_hwirq(RESTORE_TEST_SPI_PRIO_LOW),
+				 0, VGIC_V5_IST_PRIO_LOW, true);
+	restore_test_setup_hwirq(gicv5_spi_hwirq(RESTORE_TEST_SPI_ENABLED),
+				 0, VGIC_V5_IST_PRIO_HIGH, true);
+	restore_test_setup_hwirq(gicv5_spi_hwirq(RESTORE_TEST_SPI_PENDING_DISABLE=
D),
+				 0, VGIC_V5_IST_PRIO_HIGH, false);
+
+	gicv5_send_lpi(RESTORE_TEST_LPI_PENDING);
+
+	GUEST_SYNC(GUEST_CMD_IST_SOURCE_READY);
+
+	while (1)
+		wfi();
+}
+
+/*
+ * This is the restore VM for the IST save/restore test. The IRS regs and =
ISTs
+ * have been restored before this code runs. Based on which VPE is running=
, a
+ * different set of interrupts is expected. We check that we get what we
+ * expected before terminating the test.
+ *
+ * The expected interrupts for VPE0 are:
+ * - High-priority SPI, pending and enabled before save.
+ * - Low-priority SPI, pending and enabled before save. This is only deliv=
ered
+ *   after the guest lowers the masked priority via ICC_PCR_EL1.
+ * - SPI that was pending but disabled before save. This is only delivered
+ *   after the guest enables it after restore.
+ * - SPI that was enabled but not pending before save. Userspace injects t=
his
+ *   after restore to check that the enable state and affinity were restor=
ed.
+ *
+ * The expected interrupts for VPE1 are:
+ * - LPI that was pending and enabled before save.
+ * - LPI that was enabled but not pending before save. The guest injects t=
his
+ *   after restore to check that the enable state and affinity were restor=
ed.
+ */
+static void guest_ist_restore_irq_handler(struct ex_regs *regs)
+{
+	u32 vcpu_id =3D guest_get_vcpuid();
+	u32 count =3D ist_restore_irq_count[vcpu_id];
+	u64 hwirq, expected_hwirq =3D 0;
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
+
+	if (!vcpu_id) {
+		switch (count) {
+		case 0:
+			expected_hwirq =3D gicv5_spi_hwirq(RESTORE_TEST_SPI_PRIO_HIGH);
+			break;
+		case 1:
+			expected_hwirq =3D gicv5_spi_hwirq(RESTORE_TEST_SPI_PRIO_LOW);
+			break;
+		case 2:
+			expected_hwirq =3D gicv5_spi_hwirq(RESTORE_TEST_SPI_PENDING_DISABLED);
+			break;
+		case 3:
+			expected_hwirq =3D gicv5_spi_hwirq(RESTORE_TEST_SPI_ENABLED);
+			break;
+		default:
+			GUEST_FAIL("Unexpected VPE0 IST restore interrupt");
+		}
+	} else {
+		switch (count) {
+		case 0:
+			expected_hwirq =3D gicv5_lpi_hwirq(RESTORE_TEST_LPI_PENDING);
+			break;
+		case 1:
+			expected_hwirq =3D gicv5_lpi_hwirq(RESTORE_TEST_LPI_ENABLED);
+			break;
+		default:
+			GUEST_FAIL("Unexpected VPE1 IST restore interrupt");
+		}
+	}
+
+	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+	ist_restore_irq_count[vcpu_id]++;
+
+	if (!vcpu_id) {
+		switch (count) {
+		case 0:
+			gicv5_set_pcr(VGIC_V5_IST_PRIO_LOW);
+			break;
+		case 1:
+			gicv5_enable_hwirq(
+				gicv5_spi_hwirq(RESTORE_TEST_SPI_PENDING_DISABLED));
+			break;
+		case 2:
+			GUEST_SYNC(GUEST_CMD_IST_SPI_INJECT_READY);
+			break;
+		case 3:
+			GUEST_DONE();
+		}
+	} else {
+		switch (count) {
+		case 0:
+			gicv5_send_lpi(RESTORE_TEST_LPI_ENABLED);
+			GUEST_SYNC(GUEST_CMD_IST_LPI_INJECT_READY);
+			break;
+		case 1:
+			GUEST_DONE();
+		}
+	}
+}
+
+static void guest_ist_restore_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+
+	if (!guest_get_vcpuid())
+		gicv5_set_pcr(VGIC_V5_IST_PRIO_HIGH);
+
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	local_irq_enable();
+
+	while (1)
+		wfi();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -429,8 +635,10 @@ static void vgic_v5_spi_line_vm_create(struct vm_gic *=
v,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 }
=20
-static void vgic_v5_lpi_vm_create(struct vm_gic *v,
-				  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS])
+static void vgic_v5_lpi_ist_vm_create(struct vm_gic *v,
+				      struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS],
+				      void (*guest_code)(void),
+				      void (*irq_handler)(struct ex_regs *))
 {
 	unsigned int nr_lpi_ist_pages;
 	u64 attr;
@@ -441,13 +649,13 @@ static void vgic_v5_lpi_vm_create(struct vm_gic *v,
 	v->gic_fd =3D kvm_create_device(v->vm, v->gic_dev_type);
=20
 	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++) {
-		vcpus[i] =3D vm_vcpu_add(v->vm, i, guest_lpi_code);
+		vcpus[i] =3D vm_vcpu_add(v->vm, i, guest_code);
 		TEST_ASSERT(vcpus[i], "Failed to create vCPU");
 	}
=20
 	vm_init_descriptor_tables(v->vm);
 	vm_install_exception_handler(v->vm, VECTOR_IRQ_CURRENT,
-				     guest_lpi_irq_handler);
+				     irq_handler);
=20
 	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
@@ -463,7 +671,10 @@ static void vgic_v5_lpi_vm_create(struct vm_gic *v,
 				    VGIC_V5_LPI_IST_BASE_GPA,
 				    VGIC_V5_LPI_MEMSLOT,
 				    nr_lpi_ist_pages, 0);
-	/* Map the IST at VA =3D=3D IPA so the guest can program the same BASER. =
*/
+	/*
+	 * Map the IST at VA =3D=3D IPA so the guest can program the same BASER
+	 * address.
+	 */
 	virt_map(v->vm, VGIC_V5_LPI_IST_BASE_GPA,
 		 VGIC_V5_LPI_IST_BASE_GPA, nr_lpi_ist_pages);
=20
@@ -471,6 +682,21 @@ static void vgic_v5_lpi_vm_create(struct vm_gic *v,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 }
=20
+static void vgic_v5_lpi_vm_create(struct vm_gic *v,
+				  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS])
+{
+	vgic_v5_lpi_ist_vm_create(v, vcpus, guest_lpi_code,
+				  guest_lpi_irq_handler);
+}
+
+static void vgic_v5_ist_restore_vm_create(struct vm_gic *v,
+					  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS],
+					  void (*guest_code)(void),
+					  void (*irq_handler)(struct ex_regs *))
+{
+	vgic_v5_lpi_ist_vm_create(v, vcpus, guest_code, irq_handler);
+}
+
 static void vgic_v5_run_spi_line_test(u32 nr_spis, u32 expected_spi,
 				      bool level_sensitive,
 				      bool lower_before_run)
@@ -522,6 +748,15 @@ static void vgic_v5_run_spi_line_test(u32 nr_spis, u32=
 expected_spi,
 	vm_gic_destroy(&v);
 }
=20
+static void vgic_v5_expect_sync(struct kvm_vcpu *vcpu, u64 cmd,
+				const char *msg)
+{
+	struct ucall uc;
+
+	TEST_ASSERT(get_ucall(vcpu, &uc) =3D=3D UCALL_SYNC && uc.args[1] =3D=3D c=
md,
+		    "%s", msg);
+}
+
 struct vgic_region_attr {
 	u64 attr;
 	u64 size;
@@ -647,6 +882,52 @@ static const struct vgic_sysreg_attr gic_v5_cpu_sysreg=
s[] =3D {
 	SR(SYS_ICC_PCR_EL1),
 };
=20
+static void vgic_v5_save_irs_regs(struct vm_gic *v, u64 *regs)
+{
+	int ret, i;
+
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_irs_regs); i++) {
+		ret =3D __kvm_device_attr_get(v->gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    gic_v5_irs_regs[i].attr,
+					    &regs[i]);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS save failed for %s",
+			    gic_v5_irs_regs[i].name);
+	}
+}
+
+static void vgic_v5_restore_irs_regs(struct vm_gic *v, u64 *regs)
+{
+	int ret, i;
+
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_irs_regs); i++) {
+		ret =3D __kvm_device_attr_set(v->gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    gic_v5_irs_regs[i].attr,
+					    &regs[i]);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS restore failed for %s",
+			    gic_v5_irs_regs[i].name);
+	}
+}
+
+static u64 vgic_v5_saved_irs_reg(u64 *regs, u64 attr)
+{
+	for (int i =3D 0; i < ARRAY_SIZE(gic_v5_irs_regs); i++) {
+		if (gic_v5_irs_regs[i].attr =3D=3D attr)
+			return regs[i];
+	}
+
+	TEST_FAIL("GICv5 IRS register 0x%lx was not saved", attr);
+}
+
+static size_t vgic_v5_lpi_ist_state_size(u64 *irs_regs)
+{
+	u64 cfgr =3D vgic_v5_saved_irs_reg(irs_regs, GICV5_IRS_IST_CFGR);
+	u32 lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_BITS, cfgr);
+
+	return BIT(lpi_id_bits) * sizeof(__u32);
+}
+
 static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -1424,6 +1705,218 @@ static void test_vgic_v5_lpis(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_ist_save_restore(void)
+{
+	static u32 lpi_ist[VGIC_V5_LPI_IST_SIZE / sizeof(u32)];
+	static u32 lpi_ist_resave[VGIC_V5_LPI_IST_SIZE / sizeof(u32)];
+	static u32 spi_ist[VGIC_V5_DEFAULT_NR_SPIS];
+	static u32 spi_ist_resave[VGIC_V5_DEFAULT_NR_SPIS];
+	static u64 irs_regs[ARRAY_SIZE(gic_v5_irs_regs)];
+	struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS];
+	struct kvm_vgic_v5_ist ist_attr;
+	struct vm_gic src, dst;
+	u64 ist_baser, bad_ist_baser;
+	u64 ist_cfgr, bad_ist_cfgr;
+	size_t lpi_ist_size;
+	int ret;
+
+	memset(ist_restore_irq_count, 0, sizeof(ist_restore_irq_count));
+
+	vgic_v5_ist_restore_vm_create(&src, vcpus, guest_ist_source_code,
+				      guest_unexpected_irq_handler);
+
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 IST save source VM");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_IST_SOURCE_READY,
+			    "GICv5 IST source guest did not become ready");
+
+	/*
+	 * The guest configured enable/priority/affinity state. Make selected
+	 * SPIs pending from userspace so the SPI IST save path sees them.
+	 */
+	vgic_v5_spi_line(src.vm, RESTORE_TEST_SPI_PRIO_HIGH, 1);
+	vgic_v5_spi_line(src.vm, RESTORE_TEST_SPI_PRIO_LOW, 1);
+	vgic_v5_spi_line(src.vm, RESTORE_TEST_SPI_PENDING_DISABLED, 1);
+
+	vgic_v5_save_irs_regs(&src, irs_regs);
+	lpi_ist_size =3D vgic_v5_lpi_ist_state_size(irs_regs);
+
+	/*
+	 * VCPU0 has configured the initial state. KVM must reject missing or
+	 * incorrectly sized LPI storage before accepting the complete IST image.
+	 */
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_get(src.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST save accepted missing =
LPI buffer");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size - sizeof(__u32));
+	ret =3D __kvm_device_attr_get(src.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST save accepted bad LPI =
size");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size);
+	ret =3D __kvm_device_attr_get(src.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(!ret, "GICv5 IST save failed");
+
+	vm_gic_destroy(&src);
+
+	/* Create the guest that we are restoring state into */
+	memset(ist_restore_irq_count, 0, sizeof(ist_restore_irq_count));
+	vgic_v5_ist_restore_vm_create(&dst, vcpus, guest_ist_restore_code,
+				      guest_ist_restore_irq_handler);
+	sync_global_to_guest(dst.vm, ist_restore_irq_count);
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size);
+	ret =3D __kvm_device_attr_set(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST restore before IRS sta=
te");
+
+	vgic_v5_restore_irs_regs(&dst, irs_regs);
+
+	/* BASER remains mutable until the host LPI IST has been allocated. */
+	ist_baser =3D vgic_v5_saved_irs_reg(irs_regs, GICV5_IRS_IST_BASER);
+	bad_ist_baser =3D ist_baser ^
+			 FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK, 1);
+	ret =3D __kvm_device_attr_set(dst.gic_fd,
+				    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &bad_ist_baser);
+	TEST_ASSERT(!ret, "GICv5 rejected changed unallocated IST_BASER");
+
+	bad_ist_baser =3D ist_baser & ~GICV5_IRS_IST_BASER_VALID;
+	ret =3D __kvm_device_attr_set(dst.gic_fd,
+				    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &bad_ist_baser);
+	TEST_ASSERT(!ret, "GICv5 rejected invalidated unallocated IST_BASER");
+
+	ret =3D __kvm_device_attr_set(dst.gic_fd,
+				    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &ist_baser);
+	TEST_ASSERT(!ret, "GICv5 failed to restore IST_BASER");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), NULL, 0);
+	ret =3D __kvm_device_attr_set(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST restore accepted missi=
ng LPI buffer");
+
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size - sizeof(__u32));
+	ret =3D __kvm_device_attr_set(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IST restore accepted bad L=
PI size");
+
+	/* Restore the VMM-owned SPI and LPI IST images. */
+	ist_attr =3D vgic_v5_ist_attr(spi_ist, sizeof(spi_ist), lpi_ist,
+					 lpi_ist_size);
+	ret =3D __kvm_device_attr_set(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(!ret, "GICv5 IST restore failed");
+
+	/* A live IST makes BASER and the guest-visible configuration immutable. =
*/
+	ret =3D __kvm_device_attr_set(dst.gic_fd,
+				    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &ist_baser);
+	TEST_ASSERT(!ret, "GICv5 rejected unchanged live IST_BASER");
+
+	bad_ist_baser =3D ist_baser ^
+			 FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK, 1);
+	ret =3D __kvm_device_attr_set(dst.gic_fd,
+				    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &bad_ist_baser);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL,
+		    "GICv5 accepted changed live IST_BASER");
+
+	bad_ist_baser =3D ist_baser & ~GICV5_IRS_IST_BASER_VALID;
+	ret =3D __kvm_device_attr_set(dst.gic_fd,
+				    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &bad_ist_baser);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL,
+		    "GICv5 accepted invalidated live IST_BASER");
+
+	ist_cfgr =3D vgic_v5_saved_irs_reg(irs_regs, GICV5_IRS_IST_CFGR);
+	ret =3D __kvm_device_attr_set(dst.gic_fd,
+				    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_CFGR, &ist_cfgr);
+	TEST_ASSERT(!ret, "GICv5 rejected unchanged live IST_CFGR");
+
+	bad_ist_cfgr =3D ist_cfgr ^
+			FIELD_PREP(GICV5_IRS_IST_CFGR_LPI_ID_BITS, 1);
+	ret =3D __kvm_device_attr_set(dst.gic_fd,
+				    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_CFGR, &bad_ist_cfgr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL,
+		    "GICv5 accepted changed live IST_CFGR");
+
+	/*
+	 * Re-save the restored IST image before the destination VM runs, so a
+	 * dropped serialized field fails independently of later interrupt
+	 * delivery.
+	 */
+	ist_attr =3D vgic_v5_ist_attr(spi_ist_resave, sizeof(spi_ist_resave),
+				     lpi_ist_resave, lpi_ist_size);
+	ret =3D __kvm_device_attr_get(dst.gic_fd, KVM_DEV_ARM_VGIC_GRP_IST,
+				    0, &ist_attr);
+	TEST_ASSERT(!ret, "GICv5 IST re-save failed");
+	TEST_ASSERT(!memcmp(spi_ist, spi_ist_resave, sizeof(spi_ist)),
+		    "GICv5 SPI IST state changed across restore");
+	TEST_ASSERT(!memcmp(lpi_ist, lpi_ist_resave, lpi_ist_size),
+		    "GICv5 LPI IST state changed across restore");
+
+	/*
+	 * At this stage, the guest's IST state should match what was saved. Run
+	 * each vcpu once to let it enable interrupts, etc.
+	 */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 IST restore vCPU0");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_IS_READY,
+			    "GICv5 IST restore vCPU0 did not become ready");
+
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 IST restore vCPU1");
+	vgic_v5_expect_sync(vcpus[1], GUEST_CMD_IS_READY,
+			    "GICv5 IST restore vCPU1 did not become ready");
+
+	/*
+	 * VPE0 consumes two pending SPIs in restored priority order, then
+	 * enables a restored pending-but-disabled SPI.
+	 */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to consume restored GICv5 SPIs");
+	vgic_v5_expect_sync(vcpus[0], GUEST_CMD_IST_SPI_INJECT_READY,
+			    "GICv5 IST restore vCPU0 did not consume restored SPIs");
+
+	/*
+	 * This SPI was enabled before save, but not pending.  Inject it after
+	 * restore to prove enable, priority and affinity were restored.
+	 */
+	vgic_v5_spi_line(dst.vm, RESTORE_TEST_SPI_ENABLED, 1);
+
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to consume post-restore GICv5 SPI");
+	TEST_ASSERT(get_ucall(vcpus[0], NULL) =3D=3D UCALL_DONE,
+		    "GICv5 IST restore vCPU0 did not complete");
+
+	/*
+	 * VPE1 consumes a restored pending LPI, then pends another LPI that
+	 * was enabled before save but not pending.
+	 */
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to consume restored GICv5 LPI");
+	vgic_v5_expect_sync(vcpus[1], GUEST_CMD_IST_LPI_INJECT_READY,
+			    "GICv5 IST restore vCPU1 did not consume restored LPI");
+
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to consume post-restore GICv5 LPI");
+	TEST_ASSERT(get_ucall(vcpus[1], NULL) =3D=3D UCALL_DONE,
+		    "GICv5 IST restore vCPU1 did not complete");
+
+	vm_gic_destroy(&dst);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V5).
  */
@@ -1481,6 +1974,9 @@ void run_tests(u32 gic_dev_type)
=20
 	pr_info("Test VGICv5 LPIs\n");
 	test_vgic_v5_lpis();
+
+	pr_info("Test VGICv5 IST save/restore\n");
+	test_vgic_v5_ist_save_restore();
 }
=20
 int main(int ac, char **av)
--=20
2.34.1
