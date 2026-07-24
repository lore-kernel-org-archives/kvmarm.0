Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011066.outbound.protection.outlook.com [52.101.65.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BBF3F9A15
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890333; cv=fail; b=daEwXCvaPNLY5rT3YW+MvAj2XxUjgP0Xg7qwWLl4DcTGMTFvgdvDwFZTkyPsfs2sk0X1Gv4gwE7tlr2BvzbqKV0Qn90RVX2RkHq2ZVUG/CExkqvsr8B9l0PX0c9y1zLRvUX5m+ITwZGxljTSVzt/4U77s8qIAlQBfC3JsIDwilQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890333; c=relaxed/simple;
	bh=Zz533mokxgq2VacwI5xELdjWcLbLJ5XSRU3oRcn0qTU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fTHceELG3gcSlcFJf1HwCfmZ2WlF872QdtaG2PYywWUPzYP7lsa7tD1G/rW9KiYyv0uxQa/EHA1z9tzmUVdkYS2nvThmjNKXs+gBRJ3nvdXA+OY+93oFFL9eKYtYvdukgxaMenNdacsc85CAgFOpjLarK2uATC3J9S8pylxMYQ8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fYMHIJ0j; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fYMHIJ0j; arc=fail smtp.client-ip=52.101.65.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fYMHIJ0j";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fYMHIJ0j"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BLCzu5LtK+0UIYPoSD37h2ltl70Fl2BU+cdJz7QH1dq1L05WD7AmuLn7yJsvnAYd2pqYLD2pxbgDoM4Ue5cFM78U4qzAbLGvDNntYbBSOn0ApHzos/1OHyilE517cc9dCEtVTTIs9QCo8ddL2OSetiJ3aR246uJWlL91kHy9bavnD/HVmDtuDV5TuPitnXFpxPuxCFoq63Nj1rr73KwfZYVUPqrBwRii+peit7pfk+yANt9vHutZbSW/NSqgpMVCfzPR8xmjT++C/AziTiEXP9w1I8YQqkBbdPY62rxxlZWyeYKIp7wWcyAtkknkk+1EoyCUcS7MAQmMcL8ARgd+bw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJQRbS1tM2UjR1vWYKhXzbhu3WNdYc48bcmS6VWR7vM=;
 b=ggmSNneKZMsKJWCB2SBvUnI6JIX4nwOCEP/tZv4HZJX0oLmC19s4wkqdrOjXYJ+wSEgNB+NAJ6oDd1TDaKt4Dh2CIyJlxmB3oN+u/thywVSdBtSr/O89A9q9iqFq8Af/QGO93qjOBxnssn492cuT2NbD1z9Zs9gk37h8sjAiS2NKjoTTD5y6VTlZ03SToRaFnH5+y+TCqaAXiWVXoaYDrzMcdyAhUAJFokga2gKPixhrOroYOwleorcP3CY5JAPLD/7yB0/KFQdo5W4Wj9fAZNa4lA1GkXFCcQO+feen9NkA758+omk06cHK2NDIk/X8QSPM5l2ep/vZzT2rsWJaZw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJQRbS1tM2UjR1vWYKhXzbhu3WNdYc48bcmS6VWR7vM=;
 b=fYMHIJ0jVGp2woDBgPRf3Lmn7z9wZi66tSYeK1xhnE9RUqGNEQIn1YP5nxFOZYj/2Q6f+LwydoDivT/5Vh8zCloysaoWHdIIyH2kdZ4mVNdRIZs2rS33WnNGgJ/3dKiwVPGFGDQ1maPlwJhUc5noK1tAekdZEUAgy5cTnWE/F4U=
Received: from AS9PR06CA0298.eurprd06.prod.outlook.com (2603:10a6:20b:45a::6)
 by DB5PR08MB9998.eurprd08.prod.outlook.com (2603:10a6:10:489::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:52:03 +0000
Received: from AMS0EPF000001A0.eurprd05.prod.outlook.com
 (2603:10a6:20b:45a:cafe::98) by AS9PR06CA0298.outlook.office365.com
 (2603:10a6:20b:45a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:52:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A0.mail.protection.outlook.com (10.167.16.230) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:52:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s9ICka8b5ZBbu6JOge+mhlP1i4HJkLAmDuHgrGy59pX30Fpuu+B5Pn9vaIQVQ+c7MLXkGuWxNMKN7it8g00d+lbTSKOEGuq8ri1yrJABDP5mta9gxHv/Px+UM+bMQG+OCBsDagMmU2Qv0nCwHcPEpZsK5wQF2root7Muijp3E9tgAiHnqGgMmqhtqaTV5nMyKgkopR0qmWCmzMlTdgd0InRid8aYo7XuFoqtJR1sE4G17MNQNAKij6n57sfnP9vO/g6e0lJSAfg01DOnfWPgnNFGsT21wASjrw8BDV2PJknFsoU8KcBau+RwmkmP7A5SZPbqtyuvjAM3/KUH0TmL2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJQRbS1tM2UjR1vWYKhXzbhu3WNdYc48bcmS6VWR7vM=;
 b=JozZt4rWZ5HUvrQdeE6gw5f25stQspNgEdiTILOg14+LmaMN4RUBiLhfWojOD9hX5ZD7Dl/p/RKo62YLTSgPW48lxZr+k2w2liNj39B0SLeCA0Pv3FXTCHh9JdoOV9P2GlmvNIHj48miQS/Pl7YdOic+w1Mc0tL3PKyuphWz5yIxAPiTppyy5kDnyEEMa5AfGQJKowM/3naApAJ/wgNqJ7LtdUyPFEQL7HqiXicKAy+BiUv+/3dlGkiDdYA8eNd5G1rnqKIPM8PFM2Oxg94ieFT5nGs3q8tYwQPCThgsHTMgiMLQCwgCZ+U5456cFsOLce6r9s4IR8Zan8/ZyXJ+Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJQRbS1tM2UjR1vWYKhXzbhu3WNdYc48bcmS6VWR7vM=;
 b=fYMHIJ0jVGp2woDBgPRf3Lmn7z9wZi66tSYeK1xhnE9RUqGNEQIn1YP5nxFOZYj/2Q6f+LwydoDivT/5Vh8zCloysaoWHdIIyH2kdZ4mVNdRIZs2rS33WnNGgJ/3dKiwVPGFGDQ1maPlwJhUc5noK1tAekdZEUAgy5cTnWE/F4U=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:50:59 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:50:59 +0000
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
Subject: [PATCH v4 10/48] KVM: arm64: gic-v5: Introduce guest IST alloc and
 management
Thread-Topic: [PATCH v4 10/48] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Thread-Index: AQHdG1pP7ycmpHFnI0y4bfkBKKuLtg==
Date: Fri, 24 Jul 2026 10:50:59 +0000
Message-ID: <20260724104819.1296803-11-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|AMS0EPF000001A0:EE_|DB5PR08MB9998:EE_
X-MS-Office365-Filtering-Correlation-Id: 4370aeed-b9a0-4755-de06-08dee9719864
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|11063799006|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 r5Apy2EjSlDurZN/iQKTLr0rDUyVZ5O+xmyxa5zakuDcchbO7tjT5hTu06U18WcyVnA7j34w0WGq226WYzib1v/rKIqpATiPsh1r5UD8wKoFBgt25vOomvWYDTUPA6H15MqztTgzHGXx3o6C4kO5au+uYP3P3tGGcHUHAW4COu4LAp+JgPN02/4pQ8AohuhtfZXucTXB5qacZ5bxyS1WCyqC459zjJDOi2mYNotqNd3jnUiizpwssnvYVj6tCnRMMqdjHtIXaFYowYNE+4JeNH+aBbUPTRZrzV6IaBzu6X6Ule7hC4EEzF5x7dRlFjGI9YvDqSk2j2aDH8+vf9m46ARFaJVLLy3A4r+0RN6ShoyTT3H5faaANoAapyeD9r0ghw6APJ4NtUBbNBQmlVYV5xVHEsOYO6/kOjqIJJZzzyugycDRDbyoQTgIB522ylJwZOJNXRnjdmZlfnkt8tU9jF1GKhbLnP7a05xGq1+GweMNBI9Rr3852iTO2HjncUW7/e9cx6IbFqjmWCbD4NY7wYKp5tAkdujHcXtEg8NhPYUWe8p2K8Hmv7rrj3udx1fHUdDvEdkShLTuWMPKUYiSI++txZcES7FhERY0TtyhjZtE32i3pyRsGW1s6YmJMQ1Kpp73xfflxDqlaL1oosfUojsBLjBO9MK/zzbDnfmJPr81kZPFTV7+qZIUU0kDD0yfQen83ZdOQXlJU93P6Y7RLQDVUVVKy5/BsySJf0N6hBo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XXmVLdowRAYU6T38/klhvnXXdBYNEgLNmdW+CGxZJ40mMb+sakRpf7TNHWUSUAK8OJ8BpcWYqTTHQOFJ3fJEB0429zPhV9pArurG2Y1BFCSGvT+pjKql+5L9sWUVOfkyK9w17WTwJZRI2YrgJTIOEpFFNW0YII2uEzLgay6PtfuSDTezOn2tT+IRgGQaFAkmVmQf/uc5W0J+CCA/J5Epw06l1TAdrPcD2ylzzM/dtMd3v0CL5gdLvWrZFkDtAJ4RqPWpuRCvsotYLZWurlyKMkVjHWDuiQgtixVolJllHuVi31ZCV7ner68VnrU/+ZfdmDxhLqALQizp9sD+0L5HSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A0.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d9d2e778-6aae-4d38-c000-08dee9717278
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|14060799003|23010399003|35042699022|36860700016|11063799006|3023799007|18002099003|22082099003|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	C38YB4swe/pJrN7zdUJPH7EzdpeGFwOwHLrMu3/a5wlhlOqeHYGHrbZaqX/SQco6Ox/06SseNhYvQyeAOOH4WVoxgZ/YMTw4Gzxr9Hoy86YdaRpz5w2wgO0T7ShTMZH3OGflweWVlZyumBMkvM+njw6yTY7z3flx4Js2VpLyKqGhqIlS9/rs+ZhJlBxR05UfRdXZ44rhkIzsLIK4jiT+FpIJb6amztufDL9hJA5Zevb/Zx0uqprsPNQzZCXz//UzXum+e7IDgwMp5lrleWgz6gjpMCAI0PWK8t/JrSwEVYdAdeMCgVYeppdv7IIXCZsko8h+eppNKvDWhXaMfDI08lTboCYIDKbHimoDsq1rFdboGm9t79K7v+lwLigZ4OrLltL67enDLvGlU/oyKhPDz0P2oVhrHKYDhioA6X7ed5ttOYHg/YWM3xxIMbyAJ9Zpj6invqCOJbr2pjW94ZgYh4M4L75ns+IwNoHao6l0DuXqEx1me7iGEdFe8m+U6UYNy1enHh1MmjSrqlKYq+Vk4tX9E1teGCjw/LeIWh30i8Eb/l03ZBZU3ZtzxMoQJc0S9PU+3a04/9jsW6SernLY/XBRUpwaegcEEVR4v9e0AO38oui2mTgj/U6B9sVn0wM4gz16dZFd04b68U9eyjiF2MdrVUm582YTQZs3JN7ydUHGUXv30TTHgVyX+i0ZZ8n4PegWYAEmwD2hbarLE9jewQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(14060799003)(23010399003)(35042699022)(36860700016)(11063799006)(3023799007)(18002099003)(22082099003)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dqa8ADzj+19wJ+isBKQZoMFjjPGuxYk5uwtnAf+MJpVgIa887HcYk6r9f4iFVSSlukoNCfMDXLQot/BdkxifERvjhVJ/mOJFZkt7p7d70P35Si+zsK5WG3/7aNoaaYvEshywF179GSc+DRSc/XI8ZtpG5Rc4BG9p6rj/rVLknbp9pcCjPDU/TfYIURGmOBXvcryjlUOvmyMwxJ4utZ3DLZXf3Axn5WOO8bADRB/nqEWpYAM5HyJCfeJU6NRQ5d6aE84pKAGS9ylF8CHZaFwH1T9aFaPxHPKEaJhU9rNf6oDTzCEBl/aK5uMQwWWk9zWh/lj0AVfz7Ee/f5NMVouQ4WpMLXm7AmKRDA9acB7TJ96/IKUJgYk8LmciTeQ/xE5ciGnzBEbswMLSgMKMw4ltWASGxsGT/GNYETeH/CkSNzrVFtQ+MsUtFjjONY94DPOe
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:52:02.9507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4370aeed-b9a0-4755-de06-08dee9719864
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A0.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB9998

GICv5 guests use Interrupt State Tables (ISTs) to track and manage the
interrupt state for SPIs and LPIs. These ISTs are provided to the host's
IRS via the VMTE.

On a host GICv5 system, SPIs do not require any up-front memory
allocation prior to their use, unlike LPIs which require the OS to
allocate an IST. For a GICv5 guest, the same holds from the guest's
point of view: SPIs should require no explicit memory allocation by the
guest. This means that KVM must provision the memory passed to the IRS
for managing a guest's SPI state.

Allocate the SPI IST before running the guest for the first time. As only
a small number of SPIs are expected, this is always allocated as a linear
IST. The host is responsible for freeing this memory on guest teardown.

For LPIs, the guest provisions memory for its LPI IST. KVM does not pass
that memory directly to the host IRS. Instead, allocate a shadow LPI IST
and pass that to the IRS through the VMTE. The LPI IST may be allocated
as a two-level structure when supported and required by the configured
LPI ID space, as many more LPIs are expected than SPIs. The host frees
this memory on guest teardown.

This commit also extends the doorbell domain to allow the doorbells
themselves to act as a conduit for issuing commands, similar to what
exists for GICv4 support. Effectively, irq_set_vcpu_affinity() becomes
an ioctl-like interface for issuing commands specific to either a VM or
the particular VPE that the doorbell belongs to. Add support for:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE, and hence VM, valid
        VMTE_MAKE_INVALID - Make a single VMTE, and hence VM, invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

None of these commands are plumbed through to the host IRS at this
stage.

There is intentionally no SPI_VIST_MAKE_INVALID command. The SPI IST is
allocated as part of VM creation and is not invalidated while the VM is
live. It is freed when the VM is destroyed, after the VMTE has been made
invalid. The LPI IST, on the other hand, is driven by the guest, which is
free to invalidate and free its LPI IST at any point.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 540 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h |  22 ++
 arch/arm64/kvm/vgic/vgic-v5.c        |   3 +
 include/linux/irqchip/arm-gic-v5.h   |   3 +
 4 files changed, 568 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index 22cd03e0f1963..aa737972f525c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -59,6 +59,14 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VPED_ADDR_SHIFT		3ULL
 #define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
=20
+/*
+ * The LPI and SPI configuration is stored in the 2nd and 3rd 64-bit chunk=
s of
+ * the VMTE (0-based). We call this a section here in an attempt to simpli=
fy the
+ * code.
+ */
+#define GICV5_VMTEL2_LPI_SECTION	2
+#define GICV5_VMTEL2_SPI_SECTION	3
+
 /*
  * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
  * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
@@ -494,6 +502,25 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	return ret;
 }
=20
+/*
+ * The following set of forward declarations makes the code layout a *litt=
le*
+ * clearer as it lets us keep the IST-related code together.
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits,
+				    unsigned int istsz);
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2_split);
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_spi_ist_free(struct kvm *kvm);
+
 /*
  * Release the VMT Entry, freeing up any allocated data structures before
  * zeroing the VMTE.
@@ -520,6 +547,22 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	if (!vmi)
 		goto no_vmi;
=20
+	/* If we have an LPI IST, free it */
+	if (vmi->h_lpi_ist) {
+		ret =3D vgic_v5_lpi_ist_free(kvm);
+		if (ret)
+			return ret;
+	}
+	vmi->h_lpi_ist =3D NULL;
+
+	/* If we have an SPI IST, free it */
+	if (vmi->h_spi_ist) {
+		ret =3D vgic_v5_spi_ist_free(kvm);
+		if (ret)
+			return ret;
+	}
+	vmi->h_spi_ist =3D NULL;
+
 	for (int i =3D 0; i < BIT(vmi->vpe_id_bits); i++)
 		kfree(vmi->vped_ptrs[i]);
 	kfree(vmi->vped_ptrs);
@@ -628,3 +671,500 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
=20
 	return 0;
 }
+
+/*
+ * Assign an already allocated IST to the VM by populating the fields in t=
he
+ * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
+ * if the paths to reach it might be vastly different.
+ */
+static int vgic_v5_vmte_assign_ist(struct kvm *kvm, phys_addr_t ist_base,
+				   bool two_level, unsigned int id_bits,
+				   unsigned int l2sz, unsigned int istsz,
+				   bool spi_ist)
+{
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	enum gicv5_vcpu_cmd cmd;
+	struct vmtl2_entry *vmte;
+	unsigned int section;
+	u64 tmp;
+	int ret;
+
+	/*
+	 * The L2 VMTE comprises four 64-bit "sections", where sections 2 & 3
+	 * describe the LPI and SPI ISTs, respectively. Both the LPI and SPI
+	 * sections have the same layout, and as we are either operating on SPIs
+	 * or LPIs we pick a section of the VMTE to modify up-front.
+	 *
+	 * See the GICv5 EAC0 Specification 11.2.2 for more details about the
+	 * VMTE layout.
+	 */
+	section =3D spi_ist ? GICV5_VMTEL2_SPI_SECTION : GICV5_VMTEL2_LPI_SECTION=
;
+
+	if (ist_base & ~GICV5_VMTEL2E_IST_ADDR) {
+		kvm_err("IST alignment issue! Address: 0x%llx, Mask 0x%llx\n",
+			ist_base, GICV5_VMTEL2E_IST_ADDR);
+		return -EINVAL;
+	}
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* Bail if already allocated */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	if (le64_to_cpu(READ_ONCE(vmte->val[section])) & GICV5_VMTEL2E_IST_VALID)
+		return -EINVAL;
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_IST_L2SZ, l2sz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ADDR,
+			ist_base >> GICV5_VMTEL2E_IST_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ISTSZ, istsz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ID_BITS, id_bits);
+	if (two_level)
+		tmp |=3D GICV5_VMTEL2E_IST_STRUCTURE;
+
+	WRITE_ONCE(vmte->val[section], cpu_to_le64(tmp));
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	/* Finally, mark the entry as valid */
+	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+
+	return ret;
+}
+
+/*
+ * Allocate a Linear IST - always used for SPIs and potentially LPIs.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec.
+ *
+ * NOTE: istsz is the FIELD used by GICv5, not the actual size (or log2() =
of the
+ * size).
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits, unsigned int istsz)
+{
+	const size_t n =3D id_bits + 1 + istsz;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+	u32 l1sz;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	/*
+	 * Allocate the IST. We only have one level, so we just use the L2 ISTE.
+	 */
+	l1sz =3D BIT(n + 1);
+	ist =3D kzalloc(l1sz, GFP_KERNEL_ACCOUNT);
+	if (!ist)
+		return -ENOMEM;
+
+	if (spi_ist) {
+		vmi->h_spi_ist =3D ist;
+	} else {
+		vmi->h_lpi_ist_structure =3D false;
+		vmi->h_lpi_ist =3D ist;
+	}
+
+	vgic_v5_clean_inval(ist, l1sz);
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level IST - LPI, only.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	const u32 l1_size =3D BIT(n + 1);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	ist =3D kzalloc(l1_size, GFP_KERNEL_ACCOUNT);
+	if (!ist)
+		return -ENOMEM;
+
+	vmi->h_lpi_ist_structure =3D true;
+	vmi->h_lpi_ist =3D ist;
+
+	vgic_v5_clean_inval(ist, l1_size);
+
+	return 0;
+}
+
+/*
+ * Allocate ALL of the second level ISTs for a two-level IST - LPI, only.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec. The l2_size calculation is from section 11.2.3 of the same docume=
nt.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+	const size_t l2_size =3D BIT(11 + (2 * l2sz) + 1);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *l2ist;
+	__le64 *l1ist;
+	int index;
+	u64 val;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	l1ist =3D vmi->h_lpi_ist;
+
+	/*
+	 * Allocate the storage for the pointers to the L2 ISTs (used when
+	 * freeing later).
+	 */
+	vmi->h_lpi_l2_ists =3D kzalloc_objs(*vmi->h_lpi_l2_ists, l1_entries,
+					  GFP_KERNEL_ACCOUNT);
+	if (!vmi->h_lpi_l2_ists)
+		return -ENOMEM;
+
+	/* Allocate the L2 IST for each L1 IST entry */
+	for (index =3D 0; index < l1_entries; ++index) {
+		l2ist =3D kzalloc(l2_size, GFP_KERNEL_ACCOUNT);
+		if (!l2ist) {
+			while (--index >=3D 0)
+				kfree(vmi->h_lpi_l2_ists[index]);
+
+			kfree(vmi->h_lpi_l2_ists);
+			vmi->h_lpi_l2_ists =3D NULL;
+
+			return -ENOMEM;
+		}
+
+		/*
+		 * We are not doing on-demand allocation of the L2 ISTs, and are
+		 * instead provisioning the whole IST up front. This means that
+		 * we are able to mark the L2 ISTs as valid in the L1 ISTEs as
+		 * the overall IST is not yet valid.
+		 */
+		val =3D (virt_to_phys(l2ist) & GICV5_ISTL1E_L2_ADDR_MASK) |
+		      GICV5_ISTL1E_VALID;
+		l1ist[index] =3D cpu_to_le64(val);
+
+		vmi->h_lpi_l2_ists[index] =3D l2ist;
+
+		vgic_v5_clean_inval(l2ist, l2_size);
+	}
+
+	/* Handle CMOs for the whole L1 IST in one go */
+	vgic_v5_clean_inval(l1ist, l1_entries * sizeof(*l1ist));
+
+	return 0;
+}
+
+/* Allocate a two-level IST - LPIs, only */
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm, unsigned int i=
d_bits,
+					   unsigned int istsz, unsigned int l2sz)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	int ret;
+
+	/*
+	 * Allocate the L1 IST first, then all of the L2s. Everything
+	 * is preallocated and we do no on-demand IST allocation. This
+	 * is to avoid needing to track if and when the guest is doing
+	 * on-demand IST allocation.
+	 */
+	ret =3D vgic_v5_alloc_l1_ist(kvm, id_bits, istsz, l2sz);
+	if (ret)
+		return ret;
+
+	ret =3D vgic_v5_alloc_l2_ists(kvm, id_bits, istsz, l2sz);
+	if (ret) {
+		/* Free the L1 IST again */
+		vmi =3D xa_load(&vm_info, vm_id);
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D 0;
+
+		return ret;
+	}
+
+	return 0;
+}
+
+static void vgic_v5_free_allocated_lpi_ist(struct vgic_v5_vm_info *vmi,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2sz)
+{
+	if (!vmi->h_lpi_ist_structure) {
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D NULL;
+		return;
+	}
+
+	if (vmi->h_lpi_l2_ists) {
+		const size_t n =3D max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+		const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+		int index;
+
+		for (index =3D 0; index < l1_entries; ++index)
+			kfree(vmi->h_lpi_l2_ists[index]);
+
+		kfree(vmi->h_lpi_l2_ists);
+		vmi->h_lpi_l2_ists =3D NULL;
+	}
+
+	kfree(vmi->h_lpi_ist);
+	vmi->h_lpi_ist =3D NULL;
+}
+
+static void vgic_v5_free_allocated_spi_ist(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return;
+
+	kfree(vmi->h_spi_ist);
+	vmi->h_spi_ist =3D NULL;
+}
+
+/*
+ * Free a Linear IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	struct vgic_v5_vm_info *vmi;
+	int section;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	if (spi) {
+		section =3D GICV5_VMTEL2_SPI_SECTION;
+		vgic_v5_free_allocated_spi_ist(kvm);
+	} else {
+		section =3D GICV5_VMTEL2_LPI_SECTION;
+		vgic_v5_free_allocated_lpi_ist(vmi, 0, 0, 0);
+	}
+
+	/* The VM should be dead here, so we can just zero the VMT section */
+	vmte->val[section] =3D cpu_to_le64(0);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	return 0;
+}
+
+/*
+ * Free a Two-Level IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi)
+{
+	unsigned int id_bits, istsz, l2sz;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	u64 tmp;
+	int section;
+
+	/* We don't create two-level SPI ISTs, so freeing is a bad idea! */
+	if (spi)
+		return -EINVAL;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	section =3D GICV5_VMTEL2_LPI_SECTION;
+
+	if (!vmi->h_lpi_ist_structure)
+		return -EINVAL;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	tmp =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
+
+	id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
+	istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
+	l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
+
+	vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	/* The VM must be dead, so we can just zero the VMT section */
+	vmte->val[section] =3D cpu_to_le64(0);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	return 0;
+}
+
+/* Helper to determine ISTE size based on metadata requirements */
+static unsigned int vgic_v5_ist_istsz(unsigned int id_bits)
+{
+	if (!irs_caps.istmd)
+		return GICV5_IRS_IST_CFGR_ISTSZ_4;
+
+	if (id_bits >=3D irs_caps.istmd_sz)
+		return GICV5_IRS_IST_CFGR_ISTSZ_16;
+
+	return GICV5_IRS_IST_CFGR_ISTSZ_8;
+}
+
+/*
+ * Allocate an IST for SPIs.
+ *
+ * We don't anticipate a large number of SPIs being allocated. Therefore, =
we
+ * always allocate a Linear IST for SPIs. This will need to be revisited s=
hould
+ * that assumption no longer hold.
+ */
+int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned int id_bits)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	phys_addr_t base_addr;
+	unsigned int istsz;
+	int ret;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	istsz =3D vgic_v5_ist_istsz(id_bits);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vmi->h_spi_ist)
+		return -EBUSY;
+
+	ret =3D vgic_v5_alloc_linear_ist(kvm, true, id_bits, istsz);
+	if (ret)
+		return ret;
+	base_addr =3D virt_to_phys(vmi->h_spi_ist);
+
+	ret =3D vgic_v5_vmte_assign_ist(kvm, base_addr, false, id_bits, 0, istsz,
+				      true);
+	if (ret) {
+		vgic_v5_free_allocated_spi_ist(kvm);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Free the IST for SPIs. Should only happen once the VM is dead.
+ */
+static int vgic_v5_spi_ist_free(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	return vgic_v5_linear_ist_free(kvm, true);
+}
+
+/*
+ * Allocate an IST for LPIs.
+ *
+ * Unlike with SPIs, we anticipate that the guest will allocate a relative=
ly
+ * large number of LPIs. Therefore, while we support doing a linear LPI IS=
T, it
+ * is expected that LPI ISTs will be two-level.
+ */
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	unsigned int istsz, l2sz;
+	phys_addr_t phys_addr;
+	bool two_level;
+	int ret;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vmi->h_lpi_ist)
+		return -EBUSY;
+
+	istsz =3D vgic_v5_ist_istsz(id_bits);
+	l2sz =3D gicv5_irs_l2_sz(irs_caps.ist_l2sz);
+
+	/*
+	 * Determine if we want to create a Linear or a Two-Level IST.
+	 *
+	 * A two-level IST is only required when a single L2 IST cannot cover
+	 * the requested ID space. This depends on the L2 IST size selected for
+	 * the IRS, not PAGE_SIZE. Using PAGE_SIZE here would switch to
+	 * two-level too early when the selected L2 IST is larger than a page,
+	 * and the allocation sizing arithmetic would underflow.
+	 */
+	two_level =3D irs_caps.ist_levels &&
+		id_bits > ((10 - istsz) + (2 * l2sz));
+
+	if (!two_level)
+		ret =3D vgic_v5_alloc_linear_ist(kvm, false /* LPIs, not SPIs */,
+					       id_bits, istsz);
+	else
+		ret =3D vgic_v5_alloc_two_level_lpi_ist(kvm, id_bits, istsz,
+						      l2sz);
+
+	if (ret)
+		return ret;
+
+	phys_addr =3D virt_to_phys(vmi->h_lpi_ist);
+	ret =3D vgic_v5_vmte_assign_ist(kvm, phys_addr, two_level, id_bits, l2sz,
+				      istsz, false);
+	if (ret)
+		vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	return ret;
+}
+
+/* Free the LPI IST again */
+int vgic_v5_lpi_ist_free(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	if (!vmi->h_lpi_ist_structure)
+		return vgic_v5_linear_ist_free(kvm, false);
+	else
+		return vgic_v5_two_level_ist_free(kvm, false);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index b763dc3a60e3a..d0b743e8d957a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -25,6 +25,24 @@ struct vgic_v5_vm_info {
 	vpe_entry __iomem	*vpet_base;
 	void __iomem		**vped_ptrs;
 	u8			vpe_id_bits;
+
+	/*
+	 * Both the LPI and SPI ISTs are allocated by the hypervisor. While it
+	 * would be possible to track and access them by iterating over the ISTs
+	 * themselves, it makes more sense to store pointers to the ISTs.
+	 *
+	 * The LPI IST can either be two-level or linear. Hence, we keep track
+	 * of the structure. If it is two-level, we retain pointers to the L1
+	 * IST and to each L2 IST array. If it is linear, we just store the base
+	 * address of the IST array.
+	 *
+	 * The SPI IST is linear, and therefore we just store the base address
+	 * of the SPI IST array.
+	 */
+	bool			h_lpi_ist_structure;
+	__le64			*h_lpi_ist;
+	__le64			**h_lpi_l2_ists;
+	__le64			*h_spi_ist;
 };
=20
 struct vgic_v5_vmt {
@@ -73,4 +91,8 @@ int vgic_v5_vmte_release(struct kvm *kvm);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_free(struct kvm *kvm);
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 995606e0c3a39..7d5a948ab972d 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -161,6 +161,9 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_data=
 *data, void *vcpu_info)
 	case VMT_L2_MAP:
 	case VMTE_MAKE_VALID:
 	case VMTE_MAKE_INVALID:
+	case SPI_VIST_MAKE_VALID:
+	case LPI_VIST_MAKE_VALID:
+	case LPI_VIST_MAKE_INVALID:
 		/* Not yet implemented */
 	default:
 		return -EINVAL;
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 27b13bf2c1e2c..74152d22de070 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -659,6 +659,9 @@ enum gicv5_vcpu_cmd {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
+	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
+	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
 };
=20
 #endif
--=20
2.34.1
