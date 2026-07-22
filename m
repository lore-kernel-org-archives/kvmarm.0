Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012037.outbound.protection.outlook.com [52.101.66.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1646934E766
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784732405; cv=fail; b=LbMLZ3E24EE74wszBuFRAWEjG7rf0gCK5vrT/yXxNkGKTCXqyQ1i+6yY5pppaC7oP/6PzZNVThYrQ8wvq0D7NPvg5J8rhPMOrbxiHmiixQ6AGIWaDWW36+cxAEUKAL3swVcIVfvUrOYcswOIh2rbwyj8QX0kZcoKNU5LxPXY1C4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784732405; c=relaxed/simple;
	bh=0s6MM8ZZAmcqQis4G1cgov1vMEXxKtZuTp43m44GxsM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a4ac+eJAGciI4j8RgGGXxNUbrwY2W92K6pw7J9UvwtLlBJkEQqZjX+oV/Sbutx10mrG3fBpHNhbG1Hc9+TU29QVcPXRafrWaIxEAxFJLIpfPXwPj7EX0jVWux1OgmY3XbWRFYTwgjQj9uBc2ypfcXZJSGA6JmEtAg1mtYAL3mGs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TYAPjmmh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TYAPjmmh; arc=fail smtp.client-ip=52.101.66.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TYAPjmmh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TYAPjmmh"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ALscdVbdMB3fxofhyiQ1UBMyb1RXFCbTpDdc1cUO//kkkZitiXDA1b/DhaKDlMWYbw7KFYoP37MUZAwDxXCtJYtciEMWbU8kuU+UJKi6COjfh/Fz+5JBtOVIhaKlAIc/x9sTBccMH2oUIOoJJcl4jiD51KaooEMZjQlEcuTh2Gq1OEKburZpBs/0L9HGf1z0CYzPVYaZUoXbqsVm9mnL7Dm7oS76Ax0kLjBX2bItCFaPBMY5ePPdDU1NR9PAWI8OnmcnIJeJAibunVw37EMmlItxjqQGkweTEkYftY1Q5PG5gGLrzzJLAxukxYYoYwC8pN1Q7T+CtcLRrbVhXYN5Ng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0s6MM8ZZAmcqQis4G1cgov1vMEXxKtZuTp43m44GxsM=;
 b=x3IMsWyfB6LyyNDekG3GwUKbwPooj05nXldWcbAa/25rKE6UwozKK67qKkegMrnB8rHOo2ECxzL5VHIMSvltHhXWcOMTNeQAFFbU3hxyt1WcwHCf8GbL+j4Z5/sRWok8W1OBDUsBss/sQ8psRNfVjLEOUtNFnrZiKmeEtLc1LvboJc6MRlZwBnJiGeEsKUJazBK3X9Y3KIpRT0DGZ+G8gaOQkGPDGOPdV8wNgZhElNOROmz4eXmOmlDiI+bvtULclwIIkABDvCEY5vnN5tdJ5j3e5NoxeTRMidPq77eZy0wDULZCDR6gyi4tdjgEeR3UD81TVqDwHfwYvMF4vpu9dw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0s6MM8ZZAmcqQis4G1cgov1vMEXxKtZuTp43m44GxsM=;
 b=TYAPjmmhgDf3T0a3tFaOT2K/ZSkSKl3FEY27Am6uXDGlPjravP6umrIR15GTzPaRVvslQBR2kfbRKh4EvEuye49B37Ery4t0wTSfNyu0EZMazHF9EOOKiO2yVHrqOcOn/k85N9ir6m/3IawzrAN3edFygV+L9Ln2ifMENkkpROk=
Received: from DU7P190CA0020.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::34)
 by DB4PR08MB8007.eurprd08.prod.outlook.com (2603:10a6:10:38d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 14:59:55 +0000
Received: from DB5PEPF00014B89.eurprd02.prod.outlook.com
 (2603:10a6:10:550:cafe::62) by DU7P190CA0020.outlook.office365.com
 (2603:10a6:10:550::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Wed,
 22 Jul 2026 14:59:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B89.mail.protection.outlook.com (10.167.8.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Wed, 22 Jul 2026 14:59:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QYH7J0yALceQLa2XMcuiYVNRPJBc002KYttyD71aK6AiwVzavhR/XKvxffvNdz2JJRmuEjGxmsbTDoebdcciPVlj0pelc89/+BI1hd31gFOe/xNJ61kLPJS3oWzh50jLA3OWMRHYzSdcRZsr5niUGPFF3ogWliI1dzKWhY41sNjv7C5neoqJ5htT7o+C/75zHuiGMb1WesWMwiNNJJKsyNrkdGfpjexeyStTn8DgW6cSuAuwxB9vzTPRLN2/SzicbXQnvC7v+cfjvnJrgZIgReL0014uZk85b4hy3h1T8SMaZBi0ywK7bhLJtiWJtn94MY0/EQMHGjigGz2ZzRnkDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0s6MM8ZZAmcqQis4G1cgov1vMEXxKtZuTp43m44GxsM=;
 b=EHLLxeLq7xg5n8hBReM8rG04lgA9M7MKclye1Ad3GkbHqXIrDDcMugBCfqEcW9jHBMkxUtQF1IRkdgDR97XLZDX/zqMFcsnLdYwthW2Cpg4uS1CghGyRepaW4k5mxl1YoL4ElMlREaa9JoO0z2Y3tKx2UJ5atVx21ayBCSBvbZHaGhO26ld4fz9wXANEeuXIe4Tp/eZRDe7D1PHPQI/E2E7R10NJO8oZmBxHcLLlaIzkFrhYuBX/al9yHAk4pk+E2JSjw0zsDyrISjXqUI7TTdX0Y1AcxeYsSHkDgVyBFFbNFYQwdPg/SzIVExlsazyNTqaOmut9xr9MVMRnNRfzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0s6MM8ZZAmcqQis4G1cgov1vMEXxKtZuTp43m44GxsM=;
 b=TYAPjmmhgDf3T0a3tFaOT2K/ZSkSKl3FEY27Am6uXDGlPjravP6umrIR15GTzPaRVvslQBR2kfbRKh4EvEuye49B37Ery4t0wTSfNyu0EZMazHF9EOOKiO2yVHrqOcOn/k85N9ir6m/3IawzrAN3edFygV+L9Ln2ifMENkkpROk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DBBPR08MB10481.eurprd08.prod.outlook.com (2603:10a6:10:539::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 14:58:49 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 14:58:49 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 33/40] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Thread-Topic: [PATCH v3 33/40] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Thread-Index: AQHdCwYGJr5BV1iDGUW65VmkIzWZ4LZ4JZgAgAGZjwA=
Date: Wed, 22 Jul 2026 14:58:49 +0000
Message-ID: <3909cd0da85b1d365127abd2b6baa9bf2ec91d6a.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-34-sascha.bischoff@arm.com>
	 <CA+EHjTzwC3urfr2FZZsd-2QmMrqKj-65X-FW4VTcfR8V4LdT_A@mail.gmail.com>
In-Reply-To:
 <CA+EHjTzwC3urfr2FZZsd-2QmMrqKj-65X-FW4VTcfR8V4LdT_A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DBBPR08MB10481:EE_|DB5PEPF00014B89:EE_|DB4PR08MB8007:EE_
X-MS-Office365-Filtering-Correlation-Id: 1460f80c-9409-4d2a-2918-08dee801e40c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|18002099003|38070700021|11063799006|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 KiG8fW73BT1O16wUG9bpDfjVEV1qOsgykL76KtHwbV3GCnZXSXQjoZO4oJnai/RfFPeImvstCzEVYU+KP0/A1X4HmA1H9s3V9KDJvIa4n24MEltPTvhy1HGwxKmIjcKiNKeewxLme43f3x5Hnen9TbfagEldobY3rH/X3bclp2lsWm25lQOYyUKPcVuObFzs0qtTxiE6np8dMqaSZA+a7Ztu1vKksHslen1A3MT85ZOjWFBUXhb8x8iuCdHxwB8GCzZndSIKCbEc6esK3rMxoLiduA0+hDfZ8emTj4BF8ljdKiiVx99tH6U/3Ht6/aLwfX0cHRRcP+pmwHgJkeC/6rr6aPBLuDQX9T77BoB0OK5mrbhcg0VMuZXNzF34dtdAcBYwfzIT+YFRLoeTGWK/0k/tWLwa45loTW2Fz+4th2kYzI6DNWaKRHDFSJ/GVhD2pSK6nQ2e3bjle3O4gEadT+aA1k46gRHUqC2KGWCQtEJv0h3HVrKD62kHcJ4iQSzQhfitG9JdoRP0C2ra7nuL1N7vtCSPhiqqs50iyfih8MF+23KN8Q6u/YzvO0fo10dGO+pP/xjE71AsodNNLnMZBvCMu/tGMrWCAeCo6UgxsKTguv97ZWPM7AJgAFVKLxk1HVXqY/W+LUjjG7wphBxQnZ2PVOW/UXOjah+j5uuKrzuYO6jwpeosBBcSUbBo1+KB/XrfKbPIc9mQXe5GFityxQmB+2j59avss1tft/iUb3Q=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(18002099003)(38070700021)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CE31A54B1CC1A4DB1763D81A408E32F@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 QCdYWJ2qPPL9GM6ys+gQchanjyUV8pXMdFi4fUQj9SNJW3uvLTbwJPppCgM6iCdUJgDTrIAfGj10oQLK6jeEGn9Oz+UglQeXTq9d9kn2eIRnB8FksSUUczzFFKgzqMXaXi8fnPyFbuL3HVjflKSdtPT48PItcnVXvQtFZJS30HBRPMPnVIpZWT+bEYJQsjRuzoS095ryGPQQXN1Hi9FMn8WV6gZ0cnZIn5Z+J1IyaqrZa0vv61NmCQ2VE1pS7ToJ8ajXiPbaykNjOcOKkMrX5BE+b3ZbSnxGDl13NitR92I9xw6SG0GkPqTX2s16UOu9W0Eb5X5Jox4GYLpbfgCv3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10481
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0824a634-9bbf-40ed-0876-08dee801bce5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700016|35042699022|82310400026|23010399003|14060799003|4143699003|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	EK7aVpB9wO3sRcYwK2WRZBpQ5VGyzhrIbI/sRq7jb0+zaSwC9TAer7xucvLc78BOFmzo1uyIYrT7nAYrz9C3HlTB46pi39MwZfieEHa7TUKouONyFcCWVkc26xpbYPs7woaU+2eC/OvUoEi6O+z9ZUCEsaoqNlR0D8Rrcf4Af9W5aorCpPpE2swIozazBGewuI7MohhzoH1GAz/KFlaDitlx8ksIzzu0JMGjf+7GOPu0X60jSkRii80zCOdthD/pIB2TWHYjRqnG3Tw3Oxq9DwFftectVV1Q598fDBgj7u/Pirz7hhWvHk/zgQeeky6TXPRcrwJQMjzA4TQcbu1mq3DgS/NkCeXcUux0HN6aPCB88zoWcs7TQQYUKZnA56cnIi5FQLflwqRcFze2bsy5QKctEjg2OMsA9hB/NU2MailhzdsWVQTUx8vXDk4MRv+Y45XG5PfoNIZCnwnIuxj7E2Xx9XtcbWs5iUwXdnGxFV3adahQEAObN8uYlNs2zpOg6L+mdbX7T3S45H79k13igzZNd5AwyZPCWY38fX+HBwJF6IxFE37bEANi3dOaVp6QS25h5Q+D2MWN/4ntTwxBRwOpu/sXhm2HEtX98p7lydDbwN81ApbvPGuy7M35rupDP39imzA67IijsUw4nPUkQCUwNY2qY19pOs0/xd6x/ujXLWVMovX/BBzlx8+koi+RERbtdO81xY7dmf4cIVcmlQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700016)(35042699022)(82310400026)(23010399003)(14060799003)(4143699003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3IAlsmNc66vH4oh03teUWXwwhK2yehzVHzqL4G62MY2mwS1Tvc8bs5soRCzbgvhDo/FlkV5UVeSUdY+JowKIcqRWxTdJ1fIMwsP+4r/FSmeWeYGB+xn0zMmxLNTaZL7PTOxdzfoaTF8uMtLCWUi4mSiYIndRYL/qSX4xjLtKggSPjFfMLAE+TMG9kdNDnorIN7ID/eb1H4Au534PHrGf9qhjeMRXIjgD3Iv46yeJdz+LWJOlDGNSTD3YDG4G96c+a0YpOSwy8z43YLZvRq7eUoQfD2KiaJrLuwsEiUGD/M9WRQXlm0m4/5gHOgUWxOyliokZCdIno4+wNg6cUZAoXDre04DIjfR7AnVjTFNyJCJd5tTj6hneqVaNI9ZR8pPBMyKFahr4APEIhS/WCU7q0oUVyItwA/xZcWZtAzgNr5rCRZQ5hgqiw4cBWiea9VMq
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 14:59:55.0348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1460f80c-9409-4d2a-2918-08dee801e40c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8007

T24gVHVlLCAyMDI2LTA3LTIxIGF0IDE1OjMyICswMTAwLCBGdWFkIFRhYmJhIHdyb3RlOg0KPiBI
aSBTYXNjaGEsDQo+IA0KPiBJIGZvdW5kIHRoaXMgb25lIGhhcmRlciB0byBmb2xsb3cgdGhhbiBJ
IGV4cGVjdGVkLCBhbmQgSSB0aGluayB3aGF0DQo+IG1ha2VzIGl0IGhhcmQgdG8gcmVhZCBpcyBh
bHNvIHdoYXQgbWFrZXMgdGhlIHR3byB0aGluZ3MgYmVsb3cgZ28NCj4gd3JvbmcuIEEgUFBJIGlz
IG51bWJlcmVkIHR3byBkaWZmZXJlbnQgd2F5cyBoZXJlLCBieSBpdHMgcG9zaXRpb24NCj4gd2l0
aGluIHRoZSByZWdpc3RlciBhbmQgYnkgaXRzIGFic29sdXRlIGluZGV4LCBhbmQgd2hpY2ggb2Yg
dGhlIHR3byBhDQo+IGdpdmVuIGxpbmUgbmVlZHMgaXMgbm90IG9idmlvdXMgZnJvbSB0aGUgbGlu
ZSBpdHNlbGYuDQo+IA0KPiBUd28gdGhpbmdzIGluIHNldF9naWNfcHBpX2VuYWJsZXIoKSwgc2V0
X2dpY19wcGlfYWN0aXZlcigpIGFuZA0KPiBzZXRfZ2ljX3BwaV9wZW5kcigpLCBib3RoIGxhdGVu
dCB3aGlsZSBWR0lDX1Y1X05SX1BSSVZBVEVfSVJRUyBpcyA2NC4NCj4gDQo+IFRoZSBmaXJzdCBp
cyB0aGUgbG9vcCBib3VuZHMuIEFsbCB0aHJlZSB3YWxrOg0KPiANCj4gPiArIHN0YXJ0ID0gVkdJ
Q19WNV9OUl9QUklWQVRFX0lSUVMgKiByZWc7DQo+ID4gKyBlbmQgPSBzdGFydCArIFZHSUNfVjVf
TlJfUFJJVkFURV9JUlFTOw0KPiA+ICsgZm9yIChpID0gc3RhcnQ7IGkgPCBlbmQ7IGkrKykgew0K
PiANCj4gYnV0IGVhY2ggcmVnaXN0ZXIgY292ZXJzIDY0IFBQSXMsIHNvIHRoZSBzbGljZSBiZWlu
ZyBoYW5kbGVkIGlzIDY0ICoNCj4gcmVnIHRvIDY0ICogcmVnICsgNjMuIEluIHNldF9naWNfcHBp
X2VuYWJsZXIoKSBhbmQNCj4gc2V0X2dpY19wcGlfYWN0aXZlcigpIHRoYXQgaXMgZXhwbGljaXQg
anVzdCBhYm92ZSB0aGUgbG9vcCwgZm9yDQo+IGV4YW1wbGU6DQo+IA0KPiA+ICsgYml0bWFwX3dy
aXRlKGNwdV9pZi0+dmdpY19wcGlfZW5hYmxlciwgdmFsLCA2NCAqIHJlZywgNjQpOw0KPiANCj4g
V2l0aCBWR0lDX1Y1X05SX1BSSVZBVEVfSVJRUyBhdCAxMjggYW5kIHJlZyBhdCAxLCB0aGUgbG9v
cCB3b3VsZCBydW4NCj4gZnJvbSAxMjggdG8gMjU1LCBzbyB0aGUgdGVzdF9iaXQoKSBpbnNpZGUg
aXQgd291bGQgcmVhZCBwYXN0IHRoZSBlbmQNCj4gb2YgYSBiaXRtYXAgdGhhdCBpcyBWR0lDX1Y1
X05SX1BSSVZBVEVfSVJRUyBiaXRzIHdpZGUuIFRoZSBhYnNvbHV0ZQ0KPiBpbmRleGluZyB0aGVy
ZSBpcyB3aGF0IHRoZSBiaXRtYXAgd2FudHMsIGl0IGlzIHRoZSBib3VuZHMgdGhhdCBkbyBub3QN
Cj4gbWF0Y2ggdGhlIDY0LXdpZGUgc2xpY2UuDQoNCkhpIEZ1YWQsDQoNCkkgd2FzIGNsZWFybHkg
aGF2aW5nIGEgbW9tZW50IGhlcmUuIEkgc3VzcGVjdCB0aGF0IEkgdHJpZWQgdG8gcmVtb3ZlIGFz
DQptYW55ICJtYWdpYyBjb25zdGFudHMiIGFzIHBvc3NpYmxlLCBhbmQgaGFkIGEgYml0IG9mIGEg
YnJhaW4gZmFydCBoZXJlDQphbmQgcGx1Z2dlZCBpbiBWR0lDX1Y1X05SX1BSSVZBVEVfSVJRUyB3
aGljaCBpcyBvYnZpb3VzbHkgbm90IHRoZQ0KbnVtYmVyIG9mIGJpdHMgaW4gYSBQUEkgcmVnaXN0
ZXIuIFRoYW5rcyBmb3Igc3BvdHRpbmcgaXQhDQoNCldoaWxlIGl0IHNob3VsZCBiZSA2NCwgaXQg
Y2VydGFpbmx5IHNob3VsZCBuZXZlciBiZSB0aWVkIHRvIHRoYXQNCmNvbnN0YW50ISBJJ3ZlIG5v
dCBzcG90dGVkIGl0IGFzIEkgbGltaXRlZCBQUElzIHRvIGp1c3QgdGhlIGFyY2hpdGVjdGVkDQpv
bmVzLCBhbmQgdGhvc2UgdGhvc2UgaXQganVzdCBzbyBoYXBwZW5zIHRvIHdvcmsuDQoNCj4gDQo+
IFRoZSBzZWNvbmQgaXMgb25seSBpbiBzZXRfZ2ljX3BwaV9wZW5kcigpOg0KPiANCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBib29sIGxldmVsID0gISEodmFsICYgQklUX1VMTChpKSk7DQo+
IA0KPiBIZXJlIGkgaXMgdGhlIGFic29sdXRlIFBQSSBudW1iZXIsIGJ1dCB2YWwgaXMgYSB1NjQg
d2hpY2hldmVyDQo+IHJlZ2lzdGVyDQo+IGlzIGJlaW5nIGhhbmRsZWQsIHNvIGl0cyBiaXRzIGFy
ZSBhbHdheXMgbnVtYmVyZWQgMCB0byA2My4gV2l0aCByZWcNCj4gYXQNCj4gMSB0aGlzIHdvdWxk
IGJlIEJJVF9VTEwoNjQpIGFuZCB1cC4NCg0KQWdhaW4sIHRoYW5rcyBmb3Igc3BvdHRpbmcgdGhp
cyBvbmUuIFRoYXQgc2hvdWxkIGhhdmUgYmVlbiBCSVRfVUxMKGkgLQ0Kc3RhcnQpIHRvIG1ha2Ug
c3VyZSB0aGF0IGl0IGlzIHdpdGhpbiB0aGUgcmVxdWlyZWQgNjQtYml0cyAodW5kZXIgdGhlDQph
c3N1bXB0aW9uIHRoYXQgdGhlIGFib3ZlIGlzc3VlIGlzIGFsc28gYWRkcmVzc2VkKS4NCg0KPiAN
Cj4gSSBhcHByZWNpYXRlIG5vbmUgb2YgdGhpcyBpcyByZWFjaGFibGUgdG9kYXkuIEFsbCB0aHJl
ZSBzdGFydCB3aXRoDQo+IA0KPiA+ICvCoMKgwqAgaWYgKFZHSUNfVjVfTlJfUFJJVkFURV9JUlFT
ID09IDY0ICYmIHJlZyA9PSAxKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsNCj4gDQo+
IHNvIHJlZyBpcyBhbHdheXMgMCBhbmQgdGhlIHR3byBudW1iZXJpbmdzIGNvaW5jaWRlLiBCdXQg
dGhlIGd1YXJkDQo+IHJlYWRzIGFzIHRob3VnaCB0aGUgbm9uLTY0IGNhc2UgaXMgbWVhbnQgdG8g
d29yaywgYW5kIGFzIGZhciBhcyBJIGNhbg0KPiB0ZWxsIGl0IHdvdWxkIG5vdC4gV291bGQgaXQg
bWFrZSBzZW5zZSB0byBkZXJpdmUgdGhlIGJvdW5kcyBmcm9tIHRoZQ0KPiByZWdpc3RlciB3aWR0
aCByYXRoZXIgdGhhbiBmcm9tIFZHSUNfVjVfTlJfUFJJVkFURV9JUlFTLCBzbyB0aGF0IHRoZQ0K
PiBsb29wIGFuZCB0aGUgZGF0YSBhbHdheXMgZGVzY3JpYmUgdGhlIHNhbWUgc2xpY2U/DQoNCkFi
c29sdXRlbHkuIEFzIEkgc2FpZCBhYm92ZSwgSSd2ZSB3cm9uZ2x5IG9wdGltaXNlZCB0aGlzIGlu
dG8gYSBidWcuDQpJJ3ZlIG1hZGUgdGhpcyBjaGFuZ2UsIGFuZCBoYXZlIGhvcGVmdWxseSBmaXhl
ZCBteSBkdW1iIGJ1Z3MhDQoNCj4gDQo+IENoZWVycywNCj4gL2Z1YWQNCg0KVGhhbmtzIGEgbG90
LA0KU2FzY2hhDQo=
