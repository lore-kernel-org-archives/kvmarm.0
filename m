Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011015.outbound.protection.outlook.com [40.107.130.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD47224234
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306871; cv=fail; b=rdtNMrnHn4qba7Vsq2HenBf5xy+uXzgudHonoaQ5Bph26sqMjPlyN57dz2l2cgv0gSFsqW2K3LXRZmdOPbwPFHIyPlzfij4jpwawUNeiRtX3KtIrcDDXXRtJMwYtidGvECfumNGK//b2UlpR/VZCCt9iSED3qnvbsSIrOni3Fhc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306871; c=relaxed/simple;
	bh=VGFAQk6C3/0rC4qvVoEE10ttSRQL8LWvwRKlV9OO/2I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tuSBSk4f7SPDP3JGY+YilmdGNuIyaRV/8DkMQ5XpQgA9nDgrimeWZAkVdhn5JFUGYGlrFeCFi8jo2iuJ6SLt77CB6DT3nFrGZRF2TP1/Z7Lv5DhWjkW6tGE4X3zl6sGDzXHtImKt1AXXlC4LAFzZgClg2PYCBpolalvhtw6uS5E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OKVdt+u3; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OKVdt+u3; arc=fail smtp.client-ip=40.107.130.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OKVdt+u3";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OKVdt+u3"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TvwAb5vavRqCYMETEXPv8aDwCH89qRyEO163NXDYiqBbBalWVpL/dYeNDN3HNbduj9yOyCitzTsVzXWnRn4mWYActv1m1qk774AYhcOjh2JFvkWv2VSUQ8/89OZwSjpv+r4Jf48TC9JIfPCcSeXpuqXTb+p5Eoyx3ZJQiS1VurBjjqDWlDqUvzExt1IBNkuuE/m8qGy4mIWqwEnKfnJ3iyeZms2xLNUVFG/FCcuJY62cWShuZzz20zs5lKVZQF0tjysyRw2D8X60sPvU85sapIvCJrDbCrhDQXTie+44L6U1r4Rle173UoumTz/vP7FMtBf64N4J+23IlKgRoXFPaw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGHPV0a2C76o5hD7J2VKFQ5GlDQEQm/kvaq3bskI0OM=;
 b=KpNrnTLBGeqUpi7Bw0NfT3plKXUR+G6VeSsXbgvP4GnHwieZcNzMei3xM0atPwW347cenPubOwt3jOo27UH3zyGxns5Bafex3zuMMKnzZj2SXdReCTlJYTiV21knzO2/aFn5VdxhDAcs1+qXUBljfs+SkZja7ytVNWIYChisB27v7cwnYQjWN5+knXdUegsGGU9/tu/hRarYPHJV0ycHD+cUhX1V5x7r1/PgoLKyLzhAbtR29m5Qu59XeLm9SbsOAbEKNCxjS13qNnOuehbJjbxb1NDvTaTtR2srjJoW4nAtfxc5TqtsIJxxnS9TMG7fz+XwFt0zErnfkiD40oPIhw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGHPV0a2C76o5hD7J2VKFQ5GlDQEQm/kvaq3bskI0OM=;
 b=OKVdt+u3AbXyAUTgdG6ZVDAp27Eo51HQetaXGa6W6dFBWSk7Io+/pgvLdqXPnbUVWCC1kuqvlwQSqx3AO/snhxbKy9NDCiFZaJkyv3SrkTAmiPP1ZHciCpxfLdeYkCHk4pX43OOmUm+JGatIUVx21nwWQF8NU6rOEsz4De3rfRc=
Received: from DB8P191CA0027.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::37)
 by DU0PR08MB7786.eurprd08.prod.outlook.com (2603:10a6:10:3b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:21:04 +0000
Received: from DB1PEPF000509F0.eurprd03.prod.outlook.com
 (2603:10a6:10:130:cafe::fd) by DB8P191CA0027.outlook.office365.com
 (2603:10a6:10:130::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:21:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F0.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48
 via Frontend Transport; Mon, 27 Apr 2026 16:21:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hASkt1X9obVTlUEhsm27l1EXEYgY2E3DhcGfNlqGMIDN3gkpqylOBJI3F3WlS7bBusYJ0jBWPf6E0gNLNysrt3fro9ioWXi9/fKbNR1vZ/gdTJjB3ILJyTzdLceSAl4aN5wbir31miQod/Ct3rF/JBXUo/J1/C7K88DSNzw41G7s2bkxNnulZkHaZaPhIlvSWPKHh6aswlP02H73EOVALmxzap/2my7QU8kfA5ULsdh47zeEVLplXAIJCL/w/THX0e96C2kRiI3oiYehiIVA92KwAkDSEDJA5ZBUM3pz34WXka9yoNfk/6WH42u0HOmd4Ebq/2ap9ejhoZuHCAZwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGHPV0a2C76o5hD7J2VKFQ5GlDQEQm/kvaq3bskI0OM=;
 b=gcXFahfcCWBRL8ZF9blETLjs/xPYkJ2nylHo9bDILrsefriPLFK/51NhPsaq6GsFRrapMkoFQWz/hzWyNDtmlj4jobADRcz2eoKYhu8622B1sJcc9P4qNuBBizPCl5Xuf8YnAD7HRoVOdotXpnMOrQrLsl61D86g08KdrTsdOKVbai3+QQebK7RUyqf5y/w1zDiHsZKPwcCDNqtMnIypnyEnZfhNK7RjoebIAgDlhpTMOQI/eHkm4jAMjsYFgRDwS1E2pRWPEG+bVkYoD7kPjr6bC1LMfl87i4M2kHRRDLLeYFAzVyaVrHherXIwB+hiNnU1lSZqnDj4633NW13BjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGHPV0a2C76o5hD7J2VKFQ5GlDQEQm/kvaq3bskI0OM=;
 b=OKVdt+u3AbXyAUTgdG6ZVDAp27Eo51HQetaXGa6W6dFBWSk7Io+/pgvLdqXPnbUVWCC1kuqvlwQSqx3AO/snhxbKy9NDCiFZaJkyv3SrkTAmiPP1ZHciCpxfLdeYkCHk4pX43OOmUm+JGatIUVx21nwWQF8NU6rOEsz4De3rfRc=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by DB8PR08MB5307.eurprd08.prod.outlook.com (2603:10a6:10:114::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:19:56 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:19:56 +0000
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
Subject: [PATCH 40/43] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Topic: [PATCH 40/43] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Index: AQHc1mGvzPQ6pOTibUK3wPu3/3jpyA==
Date: Mon, 27 Apr 2026 16:19:56 +0000
Message-ID: <20260427160547.3129448-41-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|DB8PR08MB5307:EE_|DB1PEPF000509F0:EE_|DU0PR08MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: 016e76dd-b75c-4c3d-0194-08dea478fa78
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 lYpyU/O/6abozGfCIbFabaZgCESGE4YrGRxjKIcaIIjsGoQn9QQn/XnGmeMbftxj37TXRLGba1T4FHLBxcN6edencacsQOVPK/55yjUZUuFxsY5UAm7AVtI6WgbxfEDRcbLyKFH7FiprGMHgYaI9zARyN+Vclk8aRpJcepbSDEt/J91oOB9mHRbUVj/4r2lxi+/yKg+xHsU3cbhFy4lDWFLdva5449HxEwWBqqzz+QYQXAGnYEds3oTfGFol4EcxNmoa2Sh3W2y8c0XZ9+j3zcYJ7eqv4YqcOrT2I7aDyEehrfOB7o0Hhau0NjYK1afRvoop+PtXg5Gy9mpDmYSjX7o6AGty1pUlAyCtjIR6BIknl/QRelVtJNC1LpmkpBMJH/pSwo5oEIAGBg02Ih51b3+xAYKwdcb2PXobnbqB2krWoGmnd7GNsDylbkhY0+dSknoqSbdAV90GQhAquXzbCtye+cLG1iAAer0qGmtFBYmMwa5wEP9gAH4SQO5hLKV7+220vNbTQSrhZU2BjZmh/xHsGyigAT2YG4biG1u/U97ofHXsuyS3OFp2zkCpjf1c+7nIyA7ElPvlARlVTBz0SYVFLfyngG2fWfNw0TXp81GInnx3+hsWvgYsPxDamH0j/CeasIZsISZoU7tE4WAgdh3uQjvhKwSiMYEVINs+kVxMkfULwo9yxvorN5+QFOKhN6/6qP9GFmqb2zkv0KM04e9wr9qhxAOPzx+LdiF/JDp47cv/AIv+Wzyjej6jNMS6aJgVVeQ86YW/fsK3wSDQ7EQlatKxsGI03I8XvaPciQo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 TP0wtp1EKeI1dcE18+U81j2gvBoBUPgCNXQTwr7o/9014Jt31TrrffKBKi45DXvpXKoRDookL/exphZmUOixrlfxMVLSOu06I7LQ4VXbIpw2AF7cuvMtrgbgRYzp2QoYkxXGb5tkJkq82d5zxKo2YtuwBillKEj2Xqtg9HLMbdzKWnf1ANrO925efNJfNHl0xDKyBqNTOsql476MY62loh2D1XCRnTRSe9vNnKN8o5ksiax39ZdOfAz6O4nK8Bx4DhvwrLIQCHuxRZnu1ac4TjUrLrp4Gn6B5YBqCTLMiBGvYmgBHkXshlMemgpXuGektItAns/hyZJqL0kE/YA7Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5307
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	66cd439e-fd1f-44a4-4b61-08dea478d246
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|14060799003|376014|35042699022|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZR4p2sEzY90/GcbW3ZFnb3yERCd8aHXCgCVlYqIWP9zTQNEaOe+wACoF2V7RQ2m58BMC0XjLYVPIqDJ2mXVAy8666Jc3c7T0JMYkU7O+FmW0tKcIc1v8zIyNNKSwTDUNraLb5U9rXo7hr2K/HKZDvMYqQiWTtf6tN1AKYvvJkzNL0M84ZBxfdoGtc4wMD1OTIb/BjDYLwIKJDnSz2YRH1e/F/S5W/oAR/zQ8k9UkpfFPj2LYGOWVDicMIbtDWTt3Ry7dfIz+IxnCveTG5eWrqqKM1iAdUh342PYa+Ct50YqrMjeNJ6FwWTrZMgj6Wtvg+0Wqb6WKg0le+TQEkFe0aRJJcPOVdCUN6RmE8yJsnkj6Ut77+w/LIBVbgoGeNKgAxMqkN5lA0zApw0lh2XCqj3kkJzgW0wMzIpSK+gXfBCfnqTlbeHUZQtsLei06wkh7FqDY49AND8l0MkdZw2QW8+2uZ4aG6idLM0xIomBMFBsq//BrdcID9Wx5HM49rBQ4F2AqNJmCTIr4Mgow2oHbI6kfctUoJvVaK3rkMQsbl5Grr66Yv3VJcm0qaVMQKZpuIfABAeQRHH8X4G0anR3tnJuzasJWRhM4Fqae2IwnWBrxS4GRvSAdcij/Sk4oa3l4MOuIBG66k96OTDl9C/+oE96KKNRTS6SqYtWSA6J+JwzTrPKTw9+QEpqwe457Zhn/5pLawtAKNmNbSwCjXtFU2fcozc2PZAVYB/4eGdluLDl6y+4UMUD+zSkBRs/XSCM604oJ3zKSUS3CVESj35CQVw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(14060799003)(376014)(35042699022)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f0Y016nZ98F2A3xXcfOuBnotP/eYOrFNitXLwDQtJfKnbgV5MDw7dz58jz4NLkLkoeggIYYnteUPXywym2GbNnNpCWdj4KvWcd7U9ieyXirQc9MwXwyIBkJXY5h7SX9zSPGzgiZT/Rs8SKfDgVg5AqYIjDy7LSLnGAVXrTy/7GjEE+VMKtaBWZgtm25soefyR8u1h3TAjwZGy8SPjUSqryLDd29uhdzPeWKcZiliTG5gE+bzbtw0Z9SC+h4+nasixHs3qjDeV6B9WXI4CVnRQYr0KbPZVvbTBKqNDg96wYSYZ1O++ygMvH3UQv3rlu3Aa5Weu3pfikl6sZooNtedxDUU2NqAmvVmIYe0XMEnhFb27lEsYvEfbpyHe/uh9XwPzUv0P9Bwz1qHeUq1EUJ8u2iG/Ah7RSARR6rQIxRmqOsE+Eny7D5RKFJ8H1DvBEYN
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:21:03.7361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 016e76dd-b75c-4c3d-0194-08dea478fa78
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7786

The virtual GICv5 adopts the same mechanism as GICv3 for userspace
read and writes of the system registers, albeit operating on a
different set of registers, of course.

Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for GICv5 in the VGICv5
documentation, explicitly calling out the registers it operates
on. The main body of documentation has been directly copied from the
VGICv3 documentation as it has identical operation.

One key thing to note is that for two sets of GICv5 registers - those
pertaining to Active and Pending state - the operation of the
interface is different to how the actual registers operate. Both of
these registers have C and S variants (to set and clear bits) in
hardware. However for this interface, we ONLY implement the S variant,
AND treat it as a raw write. This simplifies the act of reading or
writing the state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 2417eba01830c..46ede907f2b32 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -64,3 +64,69 @@ Groups:
     -EFAULT  Invalid guest ram access
     -EBUSY   One or more VCPUS are running
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
+   Attributes:
+
+    The attr field of kvm_device_attr encodes two values::
+
+      bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
+      values:   |         mpidr         |      RES     |    instr    |
+
+    The mpidr field encodes the CPU ID based on the affinity information i=
n the
+    architecture defined MPIDR, and the field is encoded as follows::
+
+      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
+
+    The instr field encodes the system register to access based on the fie=
lds
+    defined in the A64 instruction set encoding for system register access
+    (RES means the bits are reserved for future use and should be zero)::
+
+      | 15 ... 14 | 13 ... 11 | 10 ... 7 | 6 ... 3 | 2 ... 0 |
+      |   Op 0    |    Op1    |    CRn   |   CRm   |   Op2   |
+
+    All system regs accessed through this API are (rw, 64-bit) and
+    kvm_device_attr.addr points to a __u64 value.
+
+    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS accesses the CPU interface registers =
for the
+    CPU specified by the mpidr field.
+
+    The available registers are:
+
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+    ICC_ICSR_EL1
+    ICC_PPI_ENABLER0_EL1
+    ICC_PPI_ENABLER1_EL1
+    ICC_PPI_SACTIVER0_EL1   ICC_PPI_CACTIVER0_EL1 is not supported. Writes=
 to
+                            ICC_PPI_SACTIVER0_EL1 are treated as RAW write=
s of
+			    the underlying state.
+    ICC_PPI_SACTIVER1_EL1   ICC_PPI_CACTIVER1_EL1 is not supported. Writes=
 to
+                            ICC_PPI_SACTIVER1_EL1 are treated as RAW write=
s of
+			    the underlying state.
+    ICC_PPI_SPENDR0_EL1     ICC_PPI_CPENDR0_EL1 is not supported. Writes t=
o
+                            ICC_PPI_SPENDR0_EL1 are treated as RAW writes =
of
+			    the underlying state.
+    ICC_PPI_SPENDR1_EL1     ICC_PPI_CPENDR1_EL1 is not supported. Writes t=
o
+                            ICC_PPI_SPENDR1_EL1 are treated as RAW writes =
of
+			    the underlying state.
+    ICC_PPI_PRIORITYR0_EL1
+    ICC_PPI_PRIORITYR1_EL1
+    ICC_PPI_PRIORITYR2_EL1
+    ICC_PPI_PRIORITYR3_EL1
+    ICC_PPI_PRIORITYR4_EL1
+    ICC_PPI_PRIORITYR5_EL1
+    ICC_PPI_PRIORITYR6_EL1
+    ICC_PPI_PRIORITYR7_EL1
+    ICC_PPI_PRIORITYR8_EL1
+    ICC_PPI_PRIORITYR9_EL1
+    ICC_PPI_PRIORITYR10_EL1
+    ICC_PPI_PRIORITYR11_EL1
+    ICC_PPI_PRIORITYR12_EL1
+    ICC_PPI_PRIORITYR13_EL1
+    ICC_PPI_PRIORITYR14_EL1
+    ICC_PPI_PRIORITYR15_EL1
+    ICC_APR_EL1
+    ICC_CR0_EL1
+    ICC_PCR_EL1
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
--=20
2.34.1
