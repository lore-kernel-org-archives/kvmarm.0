Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011057.outbound.protection.outlook.com [52.101.65.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC4242FCB7
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 11:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890855; cv=fail; b=GVxl6tvcvgE6IH25vbz/Ufmyl6fpMWlfthNUczQhB9lr/7QMJtsT5/7smDR4kV8tT/lnfEJJArHhRUf5DCwKX/nzbWbUWs77UQYzVfA7whY96QxOrvrV69FpdbKyOvipfBF1uM9BKw/Up5hpVR9+ir//o6RlRMSpibwhqjytwes=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890855; c=relaxed/simple;
	bh=Nmu1bAJB7x8IvdUSCntqpf+GRyVXS1qD0mOcfiR9JIs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OSw7MQC6ujEwbqMvfDuRXZH0ObkYoQFApirHEYkHSHcsG1u6D7FiCAb9OczxEBF+gLX5PmN8KQAOqXvYm4JRX+cHXLudSEpfB3JR3fZMrKWKcYgoBPBjgHEUrtqs+HKIfK6vsA0vdOgHRR0srQbZ6j77m0iiGaCayU80l0P07io=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gSOned4Z; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gSOned4Z; arc=fail smtp.client-ip=52.101.65.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gSOned4Z";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gSOned4Z"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ukYrDit1f5zBB2kO/OjznVV2lpfVDc+KnS4+QasLXGGWr+mn9Dl8SiYGSh27q6EZFuEYsUrmv2FqduCs5MrCUq4Z8D6jMwk+mOoyjvOUuy0Xi1ccTjF726joSFhGD309XTvC1S4iSdX/kDkOJmp8dJJVkpET26CeEuoidwji9r/Y6avTsQGcLoQVtyfa09weuaiDkmHPq/HUeD7d9Feag1cjqSc2eZWTDojUW9S10IGVlB9IZzQCdIJ+XclcA2UD11j0ZZd2+ORzvQ9dbnVnD7EBu0zQAMi9fHQ/G6nX23Vuwtu6lsJ/xZ11DrsIlYViH6Wa/uPY07kFJPxMDe9iOQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nBwaZ670kmL8ABuZziuquZh+FR/JeXUtGMJLhfD51A=;
 b=hDHYEY4/SlemmqhqzpqjInimraY7YvHWx06jJwREM9MnCqGGBR01bXPoW3Tnzdw9oMfBdssUJMSq+Bh5X2hVl01fs9febu6cUCWt1ffqBgT2/4usuZvVsEGtkA5wHCe61+I9YTg9sUA/63Jcl+VVYNMNM83PDwQDCwckYSU0PDDTc8OlfTxeL5EslJ31tZkSQxZfD5xhKtvUzdMLfFvvxsfZb7+yq91PFth6ABfFgzfoo/GXOk8+K+LiLH2G6geOKXBkeWOiZ4pS+eo3J8nbNVA++aRG1NMcFK7TEhfIa5s5l28yXdinhS3b5mtmw5O8NdFHjsKIOwp0odNirbU0Zg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nBwaZ670kmL8ABuZziuquZh+FR/JeXUtGMJLhfD51A=;
 b=gSOned4ZPYqS2Vdpj5QZ0jWTpijrzg45yjdBjRlLuwaUsi2qFi/9gemCWD6K/fAASZBLfFl5Me/6zXr+0+PN5TaHlOWjqqMBgj3zamTObTmywCfY3QOa12STB7xtUGUai3UlQZpAdu/WNfymY5xCyZiqWXA+IXUn8p8u9DKp/Qw=
Received: from AS4P191CA0036.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:657::18)
 by AS2PR08MB8949.eurprd08.prod.outlook.com (2603:10a6:20b:5f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:00:49 +0000
Received: from AMS1EPF00000041.eurprd04.prod.outlook.com
 (2603:10a6:20b:657:cafe::90) by AS4P191CA0036.outlook.office365.com
 (2603:10a6:20b:657::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:00:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000041.mail.protection.outlook.com (10.167.16.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:00:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tW1pKjZE/wVigbpFuE+NvG/X0itKXtyOC+J7tlzUAj0AgSI/rj/WuMEtYruMXaWQssK9PGlsxs9Ga+u0/pLpneU5F2R2TN42J/AZCvnJ42H35E7odxr771Rvgl7wLjDPUld6Lpes7YcTJDtLfXw8HMYm/U35RK3p2dXhwyFv/0ChcneoAHBSN5Y1xQf0ubIN9ndWapj3OeqRx9DXTFlfU2NWl3NiOkk010wtn3Oa3v4C94xG9D6kmNCYtZVj83rnTRL4BmrZnZgMFWEEGl9/We0bRR7puMkHm1+Jp4FycjnObi76Qv4WkYSr0RkE4gJWn1bN+ma9HYy/Tfk0BQ9xbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nBwaZ670kmL8ABuZziuquZh+FR/JeXUtGMJLhfD51A=;
 b=VCt636fPn12i/Mn0JSQFmusF91MWfM68xyBJAw0IQiap/P3gPQG1f1xpJOMHgV/39/C/h9S7pRl/KjQCaebzlftB5ZgILH0FpILz0Sd276yHlGv16XleeEYBRxxI2X4etJHZRBLTqqNoJxYsTe6dP89YKdHAh5QWYLRscu0SLPKBNYnDcm9NHF0cShNg9qF5jEDkSXu/QVM6joyVDO8OiHPkpcNifrmuGf7o0YeyKeBLpnuhRGLgfqBW/t6ZBnXdmVJs1IrhR6MT4qU/Bkp0Gu0OvEllN8SAgkX+OzFFlqyR/IJ8xI5BPk/VFVial9nU09Dv+iPikc4TK6/yzerR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nBwaZ670kmL8ABuZziuquZh+FR/JeXUtGMJLhfD51A=;
 b=gSOned4ZPYqS2Vdpj5QZ0jWTpijrzg45yjdBjRlLuwaUsi2qFi/9gemCWD6K/fAASZBLfFl5Me/6zXr+0+PN5TaHlOWjqqMBgj3zamTObTmywCfY3QOa12STB7xtUGUai3UlQZpAdu/WNfymY5xCyZiqWXA+IXUn8p8u9DKp/Qw=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:59:45 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:59:45 +0000
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
Subject: [PATCH v4 44/48] KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
Thread-Topic: [PATCH v4 44/48] KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
Thread-Index: AQHdG1uJExzXXE+E80WB0IP2GEg+aA==
Date: Fri, 24 Jul 2026 10:59:45 +0000
Message-ID: <20260724104819.1296803-45-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|AMS1EPF00000041:EE_|AS2PR08MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: e714fd1e-29fb-47f8-28bc-08dee972d1c6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 J7T+G/gHVjhfQZphCZhj93zKc2jMdrTNfJHYr5H50vlzf7yq41alV14ZKEXAZzjKf7BGEBOIoSv2dA7njltR+IFxgu0k1UQAW/XVokv7gxx33aksKM6DqkzZabeZvlcSIcfG3kJmBEF1oxelAFxADs8W8jEAJzGPj7GPbsSGPu1oEV7peFmlYyryUV3VC3PelSxrWZf+OKkmkM36kkRaq5Wk4ug8qyUCJoqERXtsVU74Dlq4DT73xieoeHMHkKPOJBgKWHnihTj9vTqkKc/6KlziJvkvoCIGgBO0hPtc3Zuwmm98gUDfiLlQfD6hXvOf6f34x7zbxH/TJdOoRS17wLPyh5TIvHNwh1m2vZFqErhw7HfQLCHeFsq1jPmggg8OZP1k2w6i1yXBt5HD13HqxIQogtdldfohn2a2d2ZQXa1HpQOTj/RYcu13Ya7kxqufG4iothgXV1xD1As416c3b4V/u9VBvT14R8Rs1OfCoSM12Pudtdpneho3x+NDO4YS/aP5gi7k+QedPcToVI/McN8n7goa829TSnAie1qh7I8z0DDz8HCrOlKd6ndEU3Lsv/W1l1gWjeZH1OV/WjKhYX6NxEcQVVqCASvHGuu86cOYX22iJX7kr6o1AXPBqDx/0NNiM0ZceD9vUawHEVDcuK6AdUZsfrM7aZ/hlOtBibq6bFaqaAF/zfSku+botZPe6vSrLy7tRVW347H9rvB7p1l/4sy903WeE4j7kgnjRB0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 rKJu/0R96B7FBre7zxHQ/i246hYQEg9VsNIA0fNC6KNY+i+9oKbkWfX/PUb/wvpNLQ+xMexcl8Ui1TCHm092jLWgwrv7qQV2EPvgcCwZnFP/Qgl3dWvPqYaaXhKYWhkPh6qaZuHwHzKeubxDTy7tudWGiVIjhWINkQAU2gdhrMAB2VzigxsO+S7nYTIJCs9GnzrAXfduuVqEcz5bSciro6MPpMpesq/J8p3pOMTuThgaBJad6NiXtveYdYO6hd0qhotKKQGvSA7BeK6QeF89f2tMJD0LUpckdEVKivXMA+pQWXfvUUml9SzwQ5GtNvnWXHne8lF+ZrFqVF9zyLqbGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000041.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7fd0463b-9059-4e18-48e5-08dee972ac1d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|376014|23010399003|82310400026|1800799024|36860700016|6133799003|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	vRkm1H8r+IJUKzTfZi5z8J479rQd4IplCV1PQpDOjbvGfiYSObb5x4WdXmlSv3DQqqOdkKxj/HsRvEtF4CKUrkhzTFlRTkb5gaK3vCP5xhmtsTakkztETtbr8UrTkThVF/HkFxohHnZzX+PPA1CZ7XfMv/Cq75n8HZzFNbjJK0sxESj1NYnD8jR0oBo9F7SS6CVNfzXgW28gCq//hz0stAeXZUbj/PXCrAyIrnSPcoTnDx226ffxxVwuuqUVHw/fjplrQHGEV8f/0ZyCMy5nCnVPYMMoFEkzeGbwTF1hJhSaSN+Gktddo3QH6pwJI8ik8BOdNECvjL3tjitIMVxmFw0XfFt+XVgVSUPc36HI3wCm7kWzW3MPA3fGB74W0grveK6T+MDGeHrE3rwVtKHvp8VJlhWumMLQ7EhlIBPpxrTEBYtcUO3rtz+al351/JV2Ismo4K5kn7w/f/LSBvN8zGBkBn78wvybLMKW+bgXlVed07GLaQM2cIPHzy0oedusajqvXDOINJZ2WEj7cxruVbc2+XXL8/HOyerr7DVn7d63x1wouDc4CmwQdCSXGQFAMq8XUsMCXy68nDQhY6Nu4QWiu42TmGNjipWzACxg9Yq58UBXTuVgAPJx5/AsdXKhBOb+XBjJWvp1vyi5OFzSFClXgjfBIjw2BqJ/T6plF+6cELClZrKo1Jr86IsMEy1tmqi2OcVRqXfv6I67Ab296w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(376014)(23010399003)(82310400026)(1800799024)(36860700016)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YzSHRu2Qn4sp4W3A2lsp3TJxspcd2A+dmL1BEzMb5sx+P+xCd0LPLGwAdIJ2tA5yRwyrS3P217ZSbeJllMj3G6gskYpkS/JyQgnqjg1YZhDNhrjuq7jNUDitRdttQqxwbQ15v0nLr+hqf7+xzKdcG4pbfqIIwE868n4TJyjHK0fVi0dJuugj705N8IzrNHh0yYYN/yXd/zZoki4Iio/orM3GHEvZqQ962IIWM3M4v0Ana3HR/bit07odjUCJJ85hAruqdGxqhsb/as4TTd1agjLz9Ir+MjcU6JiCzPtP73s7wfm4SpOviXRjqzTPbxs2WgRkrg7Vo8fZ4oKzqwHv+ygTIHK9YolmaCSDkl0CyoWZKqbQAan8A2NxjEZEOf2ibgkGT0AzH5Iu8Hh2akYF41eg0H9hdIgZ79u+VYQrYAZOi1brOTeAwm+qOycsv0+g
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:00:48.7218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e714fd1e-29fb-47f8-28bc-08dee972d1c6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000041.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8949

Add coverage for the VGICv5 USERSPACE_PPIS control attribute. VGICv5
only allows userspace to drive PPIs that KVM explicitly advertises, so
the selftest should verify the discovery path and the corresponding
KVM_IRQ_LINE rejection cases.

Verify that KVM reports the control attribute and that the returned
bitmap contains SW_PPI. Also check that the upper 64 bits are zero, as
KVM only exposes architected PPIs (the lower 64 entries). Finally,
verify that writes, bad userspace pointers, PPIs outside the
advertised bitmap, and the first out-of-range PPI number are rejected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 70 +++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index f756dcab26278..fe56484583d4b 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -13,6 +13,7 @@
 #include "vgic.h"
=20
 #define NR_VCPUS		1
+#define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_V5_MAX_NR_SPIS	BIT(16)
=20
@@ -108,6 +109,17 @@ static void vm_gic_destroy(struct vm_gic *v)
 	kvm_vm_free(v->vm);
 }
=20
+static u32 vgic_v5_irq_line_payload(u32 type, u32 num)
+{
+	return (type << KVM_ARM_IRQ_TYPE_SHIFT) |
+	       FIELD_PREP(KVM_ARM_IRQ_NUM_MASK, num);
+}
+
+static int __vgic_v5_irq_line(struct kvm_vm *vm, u32 type, u32 num, int le=
vel)
+{
+	return _kvm_irq_line(vm, vgic_v5_irq_line_payload(type, num), level);
+}
+
 struct vgic_region_attr {
 	u64 attr;
 	u64 size;
@@ -649,6 +661,47 @@ static void test_vgic_v5_ist_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_userspace_ppis_attrs(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 user_ppis[2];
+	int ret;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT);
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_USERSPACE_PPIS);
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	user_ppis[0] =3D 0;
+	user_ppis[1] =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, user_ppis);
+	TEST_ASSERT(!ret, "GICv5 USERSPACE_PPIS get failed");
+	TEST_ASSERT(user_ppis[0] & BIT(GICV5_ARCH_PPI_SW_PPI),
+		    "GICv5 USERSPACE_PPIS does not expose SW_PPI");
+	TEST_ASSERT(!user_ppis[1], "GICv5 USERSPACE_PPIS upper word is not zero")=
;
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, user_ppis);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 USERSPACE_PPIS set accepted=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_VGIC_USERSPACE_PPIS, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 USERSPACE_PPIS get with ba=
d pointer");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -688,6 +741,20 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	TEST_ASSERT(user_ppis[0] & BIT(GICV5_ARCH_PPI_SW_PPI),
 		"SW_PPI is not drivable by userspace");
=20
+	/* PPIs not explicitly exposed to userspace must be rejected. */
+	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		if (user_ppis[i / 64] & BIT_ULL(i % 64))
+			continue;
+
+		ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_PPI, i, 1);
+		TEST_ASSERT(ret && errno =3D=3D EINVAL,
+			    "GICv5 accepted non-userspace PPI %d", i);
+	}
+
+	ret =3D __vgic_v5_irq_line(v.vm, KVM_ARM_IRQ_TYPE_PPI,
+				 VGIC_V5_NR_PRIVATE_IRQS, 1);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 accepted out-of-range PPI"=
);
+
 	while (1) {
 		ret =3D run_vcpu(vcpus[0]);
 		if (ret)
@@ -774,6 +841,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 IST attrs\n");
 	test_vgic_v5_ist_attrs();
=20
+	pr_info("Test VGICv5 userspace PPI attrs\n");
+	test_vgic_v5_userspace_ppis_attrs();
+
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
