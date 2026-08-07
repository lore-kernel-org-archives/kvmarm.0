Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013062.outbound.protection.outlook.com [52.101.83.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFAE470EA7
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102331; cv=fail; b=KbEFb9uMrV5fz5cblSbxA/ftF5c0u/kZdqU6H6LrPvF3J2mb83VLNvnw8VZe/ZXY7FshigVv5Xp5cQq0z4kas+M+l/UO8CAzMS5tNkTBDqrjOkWdCWn2awxArT7Lnq+AZ5cHWpoPqjnxGmowsOv3MZsD7Pm2noKXe5tojzJWW2w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102331; c=relaxed/simple;
	bh=JltHQTsRnz6HPzbkYtNQ0G74h4fGN0azWhPTgY+7Z9s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JUEz5QGaNmH4IipKvwsdidkgg1AQ3/QJsvDSR90G58gdrkeBclZB+qyxOcFFYmrPhcxQAd1xxSxACtD8cIMlOvjzVu5Dl/hbQhTFVf8PxdxtdoLZZbfhDFIYgelPFdXhebqvGq8eumRjtHUhm5oqHN+zQHctroKS93IpyasVOmM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Jt8qhbg9; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Jt8qhbg9; arc=fail smtp.client-ip=52.101.83.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Jt8qhbg9";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Jt8qhbg9"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Ef/rWPFCDmpxMY3lOu4xKFgDcJ6meOCrzcFlRiQy/7iu7H85rSojPsIXNDcG1HYWQst2jUk9Ubv6UznN4O8fVNjrwIyvioxmCEpRKMDJdIxq+7WhrjsusdqkJWKVpyqkQuc98fn2u6/mKHm6Y9U3IbEPbx3AwMLxuNXD/qzUY1nM2Jvl8en01ps12H2wuAt15WHXqW+TBiM6dpn+n4oMF7IG5TS+SspIe8lYCjyuptzx8TRh9j5/4OXaoFueT6cJ8CIRewubH3UKh+wNjzuNrXpoF/tkkFZ12ZsaII7jtguhrrV/H6r3Sega12JRYiOWrg34J1M6gtoftDeMdeFv1A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+27jgll1V/vh0RzLGcaZ6MEIIdwGaRJRTd8ce816mY=;
 b=IR5GitYVq4fsbi/qDwrwCEqRT1uNTN020Ni+Szvp2nPYyJlNGfC2aJ5gn8g2I4Onx8HX8QzDsXwrfxddJNmkfezQdBSErIzIuLOpZPH71oxvclLZ6q9ALUcIexuBHuwm4aOYuBB9TjVCExziIrd6HgH08rMkWcg1Qresh1ZKXVUP4P+qxIVCnw/g2qOcIp/+jnIeYWhmQpJx5U1BQiI9VBxsFT7hWi0jC3g6j6CKEC7L/YAq1TiuhF/vBuX3FPUc2aQ3sORBlk+sF8opLnQRyN2GFvIPZpyS19jWM1GhSGjutrAnKXyt6gRSdhMcWKx7zswkZbzqo6CAnNg/+rx+BA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+27jgll1V/vh0RzLGcaZ6MEIIdwGaRJRTd8ce816mY=;
 b=Jt8qhbg9qrpjl4J8lAJYCKG3kLg1T3c5QqHkkAVVfRKKvqfMoTvsffqyzl5X9fsvMybZ19G2tGKplhA/qOFaVYjl57Z89DZEPdzIO9rDNsYyhuv1TuMUZbGPJLaYhUujqFDfQNOvuvCnHG/aDJ8AR+h9jZ54Bbta2973ogtf1lQ=
Received: from DU7P190CA0005.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::22)
 by MRWPR08MB11708.eurprd08.prod.outlook.com (2603:10a6:501:94::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:32:04 +0000
Received: from DB3PEPF0000885B.eurprd02.prod.outlook.com
 (2603:10a6:10:550:cafe::59) by DU7P190CA0005.outlook.office365.com
 (2603:10a6:10:550::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:32:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885B.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:32:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykXZLJpWHiwCY/ioy0kD9ztJnYmUW9/klRy7Mp8rA9zavqUg/8/Z02envmghLFRHC+05HGWg9BMzevTauH7mTR5aPpAjx8LZkEHfUM3PFLSvSCv02raaDYNguE3CW4Ppmj9kH2ADORTmQ6ELcJegUadJkfE9xRwfzsmo6BYqBRyOVHOq8iI2IwK4j4rD7Zh9M6x0g6mt8jpbtC4ZnI7lEqdLPfVEVDfMVSgbqGjqdXoQPOU6r1CYTPYRsbg8SeWTYeKyytFuWaPFboQF0CtKbeR/fgtRO7yy1QfmcttNbxhs2vYqi05oIDzC7mYNEocBNTMfSde3rh9IpUuwFPUjzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+27jgll1V/vh0RzLGcaZ6MEIIdwGaRJRTd8ce816mY=;
 b=XdirVSovtWHsg6eC82h7P45dzzsj6t5QyqQKV/X0NfkikZVRuM7DYCSaUJUCif4Zj5IRkdttZKSx+M4DdHQx4O0MrTN4g2gL+gcOL8jNVTdLZ7tuTj1aVt8n0ARraRm6hPXlzSQApjY5TNJZ06tFtMFIUa5MZpgLQ7N0rA+aBheGr3EFlIm2BGY5d45NFlSSYQu6roywl47BODlD9QrS0jmTDug5516vRdcZ6dK9o2xRL9WrMd3I/5w6Zd0qEKbmPa4mrSTYLgd1f6UTpY9Bn/DOcXNc0ShdnQ+CO/5rwAS3cFcmufmyZu+bxDXzm0+DgisLSn/7L6mAsUXDr01U3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+27jgll1V/vh0RzLGcaZ6MEIIdwGaRJRTd8ce816mY=;
 b=Jt8qhbg9qrpjl4J8lAJYCKG3kLg1T3c5QqHkkAVVfRKKvqfMoTvsffqyzl5X9fsvMybZ19G2tGKplhA/qOFaVYjl57Z89DZEPdzIO9rDNsYyhuv1TuMUZbGPJLaYhUujqFDfQNOvuvCnHG/aDJ8AR+h9jZ54Bbta2973ogtf1lQ=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:30:56 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:30:56 +0000
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
Subject: [PATCH v5 36/49] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Topic: [PATCH v5 36/49] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Index: AQHdJmA2P2LZ7dRr4kuSI5fmQV+HNg==
Date: Fri, 7 Aug 2026 11:30:56 +0000
Message-ID: <20260807111159.429128-37-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|AS8PR08MB7308:EE_|DB3PEPF0000885B:EE_|MRWPR08MB11708:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0bf5a4-91e2-468f-3a15-08def47781a0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 pSVggYfmZuQ/qesU9h4RYQ1rJrXmbmQrW41cghsA8GcloEH1Ualy8rjUz1fSrY1fFCT2FHyBT5FAOk6bGc3ABsW6dkNBs8DcO93062rXwlCxeYZDUJNRkv+iM6xc14+Q0cggMH7LHuwQ9/ZI5IECaybcUDyF1UJEJauKktp9kUEmkX2cgfHQCiXg3MGW6iA/0zs+UBsxkd0EuHdmvYpAVuYbBd21YrA8J7pB6ZO8oraFDq/8ojyxjbkjR+neMAp2gk7RcHlYCxEgp4YcjzT9M2kZtI8QOwt5442JgPKE2uAdIN0ye0KkW3il+4fdGSN1gImGjQDWmOXlV5xhnpYA7SRW5VTFp8+IIC7JaTEQRGbUACWmv2D9hu+K1WENbxVgq80fKe0BaX2SQpyrFJHd1uKuUsHK1Hx4Fe6BmX5mwcbmg5tGrVmkh/TE8ATm4txkVPin4OLgTC/kw6blR35MoXveGSxsZpOD7J6lx3wfkb/6JFQKueq9suXOTFvqeHl2lfqcoocwMiE/qHX+8oXReGhOFTu/rOz8dv7xC4JdklsA5nAY5/Zqm8+PZA7iPo833rawmW3ggoyDSaMjTIKxSSnu7r80e39BuNdq6Z7T1LaaLYs4kC5qKsym5ItnDe/fyHVJgQElqpiUpq7STKKLAAqm3aqPOUz6PtvwdhcEQOsKJtFFtLACA6xNS38tSkKb0BGlepvqj49Wpe99CTvieyYDZ9zsocjOx8hw7MTH2GU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 OXKRgZ80rQLGOnuQAQZzDUYXtWzbK1gMlENXYEcNmJL9lSkoVEtTFk3byP2kQ84HkXRip5VLdKZjw3o+dACNIDo7hBfnJoFMpDPus9BWfGLSETe9KnKbnqZoo8Mt6g0zhmdUzadN++xSm1qNfO+iGL4HdyJPmQC5m1TvU2S63jdCAVsNOPZzgZyMWY7sEyifFCdOfVb7x8UJ0qw/xOqFtUfrHMPPyuT8f/VPRC8or8MBSshSsdbnLqF/TV+Odaq582Sohu6PNNW8pIZ299FOFEyF7Z7DZBLiw5WYZrbnEu9ORytcIt1hvq1vpoyt+ngq7HlAYSsK5kbkSj4SwxGLlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cc58ba56-d03c-4f6a-1096-08def47758f6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|35042699022|14060799003|376014|82310400026|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	StEe1XcXtNSmippRd5xmpJulpBhf3WbuEW8lB9GM4nJ5SlY07oqlNnEyo767Xp9Qx17nmc+SdfOia5X4Kp1srOY0mYTZEwOp/yJgGsUfBoo0WldZVKFA8BzQwzv0haKtBciuXi/VqbWUVLgf0dEHVW4OUv0LFY2F60amW+F175/KIZ8LJWLczm+0KykzomBJOzYeBx+8ElgN98dKr6UAJXdlqJ7fIw0zHEIcv1F5efaPMcyw/iiXu4t/lsMqxWJ/3O6bKcUA2SWz8UcGanywYUB1sCctQX5pxmGdHVmAwcQ4gdCNWji2CCVW8rM+IXerqyGZHLlybuWOcD6/tLUlxYXrMmTJJZGj9N/a7uYU8tJe2Pbn5kRHj2G8GgJXWtuFCcU4SaJ45C/iX4UBFLyzYT7NcE+atQJHVMezOPTxf1TxDeWUBZkLKl2MnCOTtf0qCOLsEXx7omh3ftC3OEnBec3BD9ifQTXSNUtlzzLtYMUSrksmfJHqHHzI3JSXPlINOet4ediP8w1/ekIV5qloF1Y/LLY8Je0bSqRGrugbDCy4YYLbzOBY5YB5o/QA3kMapSqn3d7crXnnp1Rto5WDo7nBB84iJS8n2X/xxGnJawKZ0A/It8fkYQ1nWbhrp6UuE8kFmz6O3Aa+o5StWtrWnE+K/FCZbB6ngBDzlv43f3NxY4QAyUB45KsWmeMxt6p6m2ML9xIIEhSyOQ1rlLb1aA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(35042699022)(14060799003)(376014)(82310400026)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	71++91K1YNpnq27MUSch80GM5EpF/ZnT5VMMjsJdD5ZbcF2FCtu9q8S/615GJZpTZO0MulveuQfyfqX6tCKc0atgWmcx2UyCzkADsNd7E/vh6mhJOVCMjXcL806TVYMUISvxeUF6pnrf8xhSz3XLIRLwmk8DxepdhRzTRcnOSH1BKKlhUtcbFvLlVVEvCXPJmKqNLQvkzDbIsx8JJ1MOv0798NO96JqtBVRv59YVHY+7XAonKW3zy44S3iYPhgCdrKqhrjXOHBNoZSuDgfn30iLcFgnge5waLjVSWGbIOCRHQFHNb99ayvFUWItyAXvbNvmqq4Sagw/grug3i0AhoMsIFsBgH3GdHimnauwzbArQXM1pFdqG/+oTP93ct//3F4CXJobtruyjbPGugAvLasjp0tVDMglT+D776ULaMzKZZNc3jh1moYEWkAwgWgf3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:32:04.5167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0bf5a4-91e2-468f-3a15-08def47781a0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11708

The virtual GICv5 adopts the same mechanism as GICv3 for userspace
reads and writes of the system registers, albeit operating on a
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
 .../virt/kvm/devices/arm-vgic-v5.rst          | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index c782ea4d4609c..7e41d6699538f 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -75,3 +75,77 @@ Groups:
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
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+    ICC_ICSR_EL1
+    ICC_PPI_ENABLER0_EL1
+    ICC_PPI_ENABLER1_EL1
+    ICC_PPI_SACTIVER0_EL1    ICC_PPI_CACTIVER0_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER0_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SACTIVER1_EL1    ICC_PPI_CACTIVER1_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER1_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SPENDR0_EL1      ICC_PPI_CPENDR0_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR0_EL1 are treated as RAW writes=
 of
+                             the underlying state.
+    ICC_PPI_SPENDR1_EL1      ICC_PPI_CPENDR1_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR1_EL1 are treated as RAW writes=
 of
+                             the underlying state.
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
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   Getting or setting this register is not supported
+    -EBUSY   VCPU is running, or write attempted after a VCPU has run
+    -EINVAL  Invalid mpidr or register value supplied
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
