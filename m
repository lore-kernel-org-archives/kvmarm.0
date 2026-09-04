Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011049.outbound.protection.outlook.com [52.101.70.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8AE47127F
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521944; cv=fail; b=AfYm7/Wm0zD3/Qrnv8xtCgnfxARKJDi/QDVibsChDj+xqgsLpvRl/sg2PhsANYBWn/aDMAqtdhiwlMwI87UuTUC+5sx49hIv+NyaSV5xSysUgTrRn/yZgwOBxS4p6FL8LutpK1PoDtYbC4Zq3lHbmAUliKe7sK8NlultVouWkhM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521944; c=relaxed/simple;
	bh=uLvi1ohvQeD2QAmJsDSjvW58jxkvVByCG1lM/wh4ne0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E3V1rX/nacaSmxWYZ4E10Kps1CNQEKvV5g7wfMcaXns6O5xfkPp13zQ8pTRR4Sx5vh1DG09HP5w8h5yaTZmkjosvJu/v24SCrOVRCeULIe1AN1ZNpUpZio5paKnQf1RLiOyvFcJPoNefpdL8yW3aBAwC0XqzN0Z5Kxf6owLlSkE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SsrylaGh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SsrylaGh; arc=fail smtp.client-ip=52.101.70.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SsrylaGh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SsrylaGh"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nKONmZzrOL9HVHHlhBL+hHScMwQGjhFCEqsFbeR7UgKGeIRzfE2ZBz2JrhYG9bPKPZ/qNiLCfrI9CH5Q0r9687jwE1XagDKBoWFGB9uWU/0F8PaDYhYAWMyhpCRy2ZtckW3tEh7Lx2HKz3hrK0ASgOr2JMVQOk/Q1zVW9YkFWQM8XF1oHlWo1GiIyxFZfrAtWwD16nToje48fGQLtDNOKfAP1kbbG6OE+O+LNphTpts/l0cVfexSOZqz0efCGD40WPzyeyhnod9kIV9/wQ65ERsHsJ4cq1WeXpwSKkc/0fP7rSoS8DbEnCeXF9Xeu+SUUsOg8qcy5lfpBHCcgqP/cQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDawZLzv6o5eVwx0i39DqGD0J4P1d5EoiJI/WWy9mu0=;
 b=xn42r5J04bkAED7jq/ekl/fzet12wae1dkbPQKT+Wo/yP11hxcn62EtDfM4LMw4OqdLI0fRVqfbjOcUh/ByGa8fe7T4V+8x9yYMq4epsjVDJ/Tj0t8AYcX0IOjMLGerscJz0jphD0XU1a+CCjDEcZMMLADM5lHD6u7ouIRCpY2AncOBfq3FkTSngQSZ7tRI1Zb+JXqwDk5d197DlyIMMQBU8h0Dg8uc8pmEz53+fbZ69CgoJXwxdkl0K9OBwtopvsGjTpljlJH9xHVr/zKBcQwr3xf7wevCjURTHPkl+1Y+zfcvoBs2azH9Nyyu5KS6EEgGTaGqsii0fEgidviqhWg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDawZLzv6o5eVwx0i39DqGD0J4P1d5EoiJI/WWy9mu0=;
 b=SsrylaGh4fjgHv0A+WS7hd7NSIBSn03fFNB4PshjFob2D7JnPxLEz0bmMpiKqzVM53x1CExQIDlc3fGrxASAPacdgnxhtZSMrY+YS+PXdEaXPMEJlUSovtHM6KZQ2z89OUYWSHC4gvfq6sE4ZXf1liKhp0Z4FR0V6My9XGdlf3o=
Received: from WA2P291CA0021.POLP291.PROD.OUTLOOK.COM (2603:10a6:1d0:1e::29)
 by AS4PR08MB7629.eurprd08.prod.outlook.com (2603:10a6:20b:4cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:38:55 +0000
Received: from WA1PEPF000099CF.eurprd04.prod.outlook.com
 (2603:10a6:1d0:1e:cafe::22) by WA2P291CA0021.outlook.office365.com
 (2603:10a6:1d0:1e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 11:38:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 WA1PEPF000099CF.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:38:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m2t1h7ZIqn3usmF2EjJz13Vpv7CuRiqW0wIwPclU0WNW8JcHgsrOhDRwajDS9vNLGB0qTxhC6DnCHj0sq56myz9OUi8HzMash3VzQDr3sGvSM4g4L1xBn5GEzpMUYfm+5/2L80lMtaRiQUo31wcNNnomWEso8qi5iqkJfdZ/b6GBYTK9r/IE4q+8Fg8PTX8osKLSOrdFNsNKsGBC/niFJwz5jNEwGCAqKklrYhI0NYWsnNeWn7M/aV9xmlEB8FXTW3eTvCxGyuquKz5iEJRf8DCvjxKS303W0Zgli/Fjxspc++C3fQGr5hwCvORB9G6Z1mfYbVYTUu3W0ZKWqhK5kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDawZLzv6o5eVwx0i39DqGD0J4P1d5EoiJI/WWy9mu0=;
 b=mCsgWp9RJB23hrYmLqvIM5rFOt9UBWflr4yN2+hQ/0wfYU85vD0ia4wUId11GflXaOmyQjw3ozI+JsBsksV4j0xyGHllYYKWWtDGj11rGNyX4m1Rrrr6+ynJWp0PfkjsQawduf2mck7qPDbV5Z0XntdK2nd0xD+KKRIwNTHLlfFvso+57jT0C9khA4DWjsykKxW+viu5NkTffoUOPQP/H3+s6vafvmBPkR8jBHpLkOegBMVQU+8lBqwLwGMPgqz+0O99/vbISOR2Pdi81loN8NDH7T8xQrdIWaGY/E+agp+THimugNmKusMxsymmGv950usio5+iTzoS7k1JQ8h2uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDawZLzv6o5eVwx0i39DqGD0J4P1d5EoiJI/WWy9mu0=;
 b=SsrylaGh4fjgHv0A+WS7hd7NSIBSn03fFNB4PshjFob2D7JnPxLEz0bmMpiKqzVM53x1CExQIDlc3fGrxASAPacdgnxhtZSMrY+YS+PXdEaXPMEJlUSovtHM6KZQ2z89OUYWSHC4gvfq6sE4ZXf1liKhp0Z4FR0V6My9XGdlf3o=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:38:20 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:38:20 +0000
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
Subject: [PATCH v6 08/49] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Topic: [PATCH v6 08/49] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Index: AQHdPGHiALHG2KwKgUO5twoKqfj8lw==
Date: Fri, 4 Sep 2026 11:38:20 +0000
Message-ID: <20260904113404.4051341-9-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|GVXPR08MB10864:EE_|WA1PEPF000099CF:EE_|AS4PR08MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: e03c8d82-0733-4669-a050-08df0a79196d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|10067099003|3023799007|11063799006|22082099003|56012099006|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 o32FtZABY9O1zfcggpyPqCrTq1wlJbxxcXKmKM+Wm6QN6sVsml/wZJt4WkJOsUruQHajBbb3bYIG9PdtFAmEgxwC67B/9vNVVBHS92xei022RvOTZahjNZaDQEimfBXp+Ff3wsyJs0iVCvJYCdRsEJjyK24DY3UDl56LNfm/CA2+bampjHvu2EPKeZ7LpETFGdCc1KrOR2WwkHUDUvDoVZzkwaMvE0Nwz9swZSyoYeL58rCnKN5SsBtnGioqpykKHkCNcULJZnELwjt/0W9/jsHs2dGz/y/8NU9V4nxeDQs1PgBQwqlZLEBIWkHqeDhpTrzenbQcwmp5p1rK38rGlMv4i50/TvY9jwaoqIT/eaF1qgn0eAfOc7OZ8n9N/5xiKGYsghLIsjZYRcaMkGa/GfQXpJ/mg6Q0OhkPNEA5+DPJ4cJvFdSbTuI3Me/0PSoLOofKfZo6qz3G3bVBZ3W+D0ffWHobHZa9JdukPgqKm3vFlO0u34tSBzgWrIIObUsY9/TYG08to093hIv7usVwlgaUASmy17jFOLnYADdHmRrEGRfiWIsM1sP+JWgifL/MeQOQwOKZ+DnTLexqKR5kgGQ43R3wwVihsHEdW11uSRpvhvO0FVKom2IiQri2VyRa0Hwp1/lOx3TKyVjxtfzh39bXDUbwLPiZmrA2Y5XTwDseppJIS5XysUPgmEz4cEsJVVKDJki/008mffGwje4JKjBTB7FAzIBh7ohM8rG4wfk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(3023799007)(11063799006)(22082099003)(56012099006)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 sONd/sn0nMdi1qBD85UooiGxRaf6i2Pwit0v7DFqD48hUH9UKsPX+2SRX4kFQki+ei1pAS5uQGJ2Gj4M1jT6rKNb3CeacOLT79sIsj4OPxK9sPL3RAfi+QvDk7xxEMdu1gSzhrYUunJVJST3f0vVVLzOZUPcsD0ZemhHpAds2qbcfcGfKTZ3UPRVk1gaqwUCJyw89Rl/6SAZ7QoE62seraF5E2pxHMKz2wWozxQJvRJpzReLzQmotuQ/dGihWZp9nEIC9WfmdLhsyav322GScUHvhZc4NvcDpiMUJAH3o3V1qc/9g21ItbE1xZDh4c0cBqwmSySH3uAfCgKL7oba4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 WA1PEPF000099CF.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	600682c9-65ce-481f-f4a8-08df0a79055d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700016|376014|23010399003|1800799024|82310400026|6133799003|10067099003|11063799006|18002099003|22082099003|3023799007|56012099006;
X-Microsoft-Antispam-Message-Info:
	GNanf3Q4bqUCuhCOfPdyOPH9nmjEHmBvnFwIfPc6uHFrg1ll/SEMqLFSR/ff79+qC3pKBdL1+TrqCUOjn5H9h5CsEbDftPYXW8xL0TyuwPuWH8rGCRiVKFk0Rcw6ZM/tWr2gJCK+vv7Kj+Iu1Vdo3Bo2Ho43EEdaPdCFtO6uKD+6nRywJrTfFD/wVmgpIaR58I04oKtNQNz9XhPhgFWjxeqAVflhAlfQODZPsjzrnNR7FOC3CXb0e+/paXjwhe5l6GiW7+whfSLwSTUXU4+lCdyMexdnzYzCLeiqguWMNbr+tfbasL0DR/AZEOD5x6XaXygFbpZ19lR0/81YmaBgtaPVwpTsU6uIwk8MYxuBc5PmM2LAeW3lD9N2LfJulMzE4n/v9cBut9GsrRBJJIj+G+IP6kfXXwHHotjKZLtpuF6prFDMgqYeVMrsy60JID1pAEzGnjhRZVgTACKqfO7mbdibxLUnT5myrIoP3zyEm7E/ndC6igjTFEwGYN7ljr6TPbdtrc0c4msXCtGJgfJjc4aEKIkTwaA/RYrSV+bfmaVwHOMcCGUcCyDfylmXWcScAAK+yBssiyD+ytt+BtyT66v4MUFQZIKwFWaw1DRd/slVnzYrxBTy+/X7t+4tHKYREIVG3PVcJt2er6LwYj4Joa2N8XN6U3A1BTTS8v7d6tY=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700016)(376014)(23010399003)(1800799024)(82310400026)(6133799003)(10067099003)(11063799006)(18002099003)(22082099003)(3023799007)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lIOvGOms/od/90IF/6nFH7vB6zxS2Lad1wKRCNa55kHXxd+OKAxgdRVAOT+qKxmsCCj7SSaTiIOuiF4u1cnJyVySPWg4EGk3qSOUuTtd+vglLPDPZ550pi0jULqsqQfrJGc552759b+VdNXqXsDn+INtVokACVygnhdb42sEAtBkwfnWjwtPJyFcz/dEFqnxETrbBuoghU3tqohOVx+x/MGj3JTR1CpAPqfSd1p9hj6SAu59f7jouNVE5ieZAdSJIcJSZfOl12MwMtA5rTd92i5iahXAjIyPAC9j+a8W9kEiYEHnDbYTBONB7zVC27f0XS4ljeQcVPYiqOFu9fJ2BcqSqBnS956Tkx/iv5WoJiCh3hXcoDtx6nNXATi26ZkWBzCHL5HUOp4xQASeedJK2549plAMq0TzlRRIi5ctky73Dk04GDksenmHg6e6epHC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:38:54.1802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e03c8d82-0733-4669-a050-08df0a79196d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	WA1PEPF000099CF.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7629

VPE doorbells allow the GICv5 hardware to notify KVM when an SPI or
LPI can be signalled to a non-resident VPE. This provides the
mechanism used to wake blocked vcpus once the hardware determines that
the interrupt is eligible to be delivered.

Add support for a per-VM VPE doorbell irq domain. The domain is
created under the GICv5 LPI domain, with one doorbell allocated per
VPE. Store the allocated doorbell base in the VM's GICv5 state so that
later patches can request per-vcpu doorbell IRQs and use them for IRS
commands and wakeups.

Add the per-VPE doorbell state to the GICv5 CPU interface state. The
doorbell IRQ number is populated when the IRQs are requested, and the
db_fired state is used by later patches once doorbell delivery is
wired up.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  24 +++--
 arch/arm64/kvm/vgic/vgic-v5.c      | 142 +++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |   1 +
 include/kvm/arm_vgic.h             |   4 +
 include/linux/irqchip/arm-gic-v5.h |   2 +
 5 files changed, 166 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 4012df6002ea6..052e680b8b60f 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -474,8 +474,12 @@ int vgic_init(struct kvm *kvm)
 		kvm_vgic_vcpu_reset(vcpu);
=20
 	ret =3D kvm_vgic_setup_default_irq_routing(kvm);
-	if (ret)
+	if (ret) {
+		if (vgic_is_v5(kvm))
+			vgic_v5_teardown(kvm);
+
 		return ret;
+	}
=20
 	vgic_debug_init(kvm);
 	dist->initialized =3D true;
@@ -496,16 +500,22 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->nr_spis =3D 0;
 	dist->vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
-	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
+	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		dist->vgic_cpu_base =3D VGIC_ADDR_UNDEF;
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list)
 			vgic_v3_free_redist_region(kvm, rdreg);
 		INIT_LIST_HEAD(&dist->rd_regions);
-	} else {
-		dist->vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	}
=20
-	if (vgic_supports_direct_irqs(kvm))
-		vgic_v4_teardown(kvm);
+		if (vgic_supports_direct_irqs(kvm))
+			vgic_v4_teardown(kvm);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		vgic_v5_teardown(kvm);
+		break;
+	}
=20
 	xa_destroy(&dist->lpi_xa);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index e75a66b3920aa..60bb39421ad08 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -7,6 +7,7 @@
=20
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
+#include <linux/irqdomain.h>
=20
 #include "vgic.h"
=20
@@ -125,6 +126,137 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * This set of irq_chip functions is specific for doorbells.
+ */
+static const struct irq_chip vgic_v5_db_irq_chip =3D {
+	.name =3D "GICv5-DB",
+	.irq_mask =3D irq_chip_mask_parent,
+	.irq_unmask =3D irq_chip_unmask_parent,
+	.irq_eoi =3D irq_chip_eoi_parent,
+	.irq_set_affinity =3D irq_chip_set_affinity_parent,
+	.irq_get_irqchip_state =3D irq_chip_get_parent_state,
+	.irq_set_irqchip_state =3D irq_chip_set_parent_state,
+	.flags =3D IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE |
+		 IRQCHIP_MASK_ON_SUSPEND,
+};
+
+static void vgic_v5_irq_db_domain_free(struct irq_domain *domain,
+				       unsigned int virq, unsigned int nr_irqs)
+{
+	int i;
+
+	for (i =3D 0; i < nr_irqs; i++) {
+		struct irq_data *d =3D irq_domain_get_irq_data(domain, virq + i);
+
+		irq_set_handler(virq + i, NULL);
+		irq_domain_reset_irq_data(d);
+	}
+
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static int vgic_v5_irq_db_domain_alloc(struct irq_domain *domain,
+				       unsigned int virq, unsigned int nr_irqs,
+				       void *arg)
+{
+	const struct irq_chip *chip =3D &vgic_v5_db_irq_chip;
+	struct vgic_v5_vm *vm =3D arg;
+	struct irq_data *irqd;
+	int ret;
+
+	if (!vm) {
+		kvm_err("invalid parameter for doorbell irq allocation\n");
+		return -EINVAL;
+	}
+
+	ret =3D irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, NULL);
+	if (ret)
+		return ret;
+
+	for (int i =3D 0; i < nr_irqs; i++) {
+		irq_domain_set_hwirq_and_chip(domain, virq + i, i, chip,
+					      domain->host_data);
+		irqd =3D irq_desc_get_irq_data(irq_to_desc(virq + i));
+		irqd_set_single_target(irqd);
+	}
+
+	return 0;
+}
+
+static const struct irq_domain_ops vgic_v5_irq_db_domain_ops =3D {
+	.alloc =3D vgic_v5_irq_db_domain_alloc,
+	.free =3D vgic_v5_irq_db_domain_free,
+};
+
+static int vgic_v5_create_per_vm_domain(struct kvm *kvm)
+{
+	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
+	int nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	int id =3D task_pid_nr(current);
+	int ret, db_virq =3D 0;
+
+	if (!gicv5_global_data.lpi_domain) {
+		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
+		return -ENODEV;
+	}
+
+	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);
+	if (!vm->fwnode)
+		return -ENOMEM;
+
+	/*
+	 * KVM per-VM VPE DB domain; child of LPI domain; only ever handles
+	 * doorbells. We know how many doorbells we have, and therefore we
+	 * create a linear domain.
+	 */
+	vm->domain =3D irq_domain_create_hierarchy(gicv5_global_data.lpi_domain,
+						 0, nr_vcpus, vm->fwnode,
+						 &vgic_v5_irq_db_domain_ops, vm);
+	if (!vm->domain) {
+		ret =3D -ENOMEM;
+		goto err;
+	}
+
+	db_virq =3D irq_domain_alloc_irqs(vm->domain, nr_vcpus, NUMA_NO_NODE, vm)=
;
+	if (db_virq <=3D 0) {
+		ret =3D db_virq;
+		goto err;
+	}
+
+	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D db_virq;
+
+	return 0;
+
+err:
+	if (vm->domain)
+		irq_domain_remove(vm->domain);
+	if (vm->fwnode)
+		irq_domain_free_fwnode(vm->fwnode);
+
+	kvm->arch.vgic.gicv5_vm.vpe_db_base =3D 0;
+	vm->domain =3D NULL;
+	vm->fwnode =3D NULL;
+
+	return ret;
+}
+
+static void vgic_v5_teardown_per_vm_domain(struct vgic_v5_vm *vm)
+{
+	if (!vm->domain)
+		return;
+
+	if (vm->vpe_db_base) {
+		irq_domain_free_irqs(vm->vpe_db_base, vm->domain->revmap_size);
+		vm->vpe_db_base =3D 0;
+	}
+
+	irq_domain_remove(vm->domain);
+	irq_domain_free_fwnode(vm->fwnode);
+	vm->domain =3D NULL;
+	vm->fwnode =3D NULL;
+}
+
 void vgic_v5_reset(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -140,10 +272,16 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
 }
=20
+void vgic_v5_teardown(struct kvm *kvm)
+{
+	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long idx;
+	int ret;
=20
 	if (vgic_initialized(kvm))
 		return 0;
@@ -155,6 +293,10 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	ret =3D vgic_v5_create_per_vm_domain(kvm);
+	if (ret)
+		return ret;
+
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b71d486ae5145..42cb205554daa 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -383,6 +383,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
+void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c82aa7c9e3f32..78a442046ebc5 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -379,6 +379,10 @@ struct vgic_v5_vm {
 	 * convenient way to do that).
 	 */
 	DECLARE_BITMAP(vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS);
+
+	struct fwnode_handle	*fwnode;
+	struct irq_domain	*domain;
+	int			vpe_db_base;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 8dc5847a646eb..6ed886c09becb 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -615,6 +615,8 @@ void gicv5_irs_syncr(void);
=20
 /* Embedded in kvm.arch */
 struct gicv5_vpe {
+	int			db;
+	bool			db_fired;
 	bool			resident;
 };
=20
--=20
2.34.1
