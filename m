Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011031.outbound.protection.outlook.com [52.101.70.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7EF473C76
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102701; cv=fail; b=W1GaRX1u9j4I8NQSSRnhUFj6ZdmAOZsJ7v977ZXQgCTNLoaoOjlRLbAUacoZbQOa/zfOjtUslCV0nrvBJ8NtkWkGT5uc3i/AggNT8aAtg/4bmuQaxXgGHTBfgqTu9KtCuqD9mL2YtnKj5L3EoxxRNm1hQzyqgzl2trtmqsjhYLs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102701; c=relaxed/simple;
	bh=Y2YFunqlr/+DupW5CYKSrt2zN7+9h3zociKREJXF5Uo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r8dWzN2M5qmN/sJeT+LKG+elNpSsbeM1ZGAxmsH0IaMk+jdDF6+sXcZYZ9QIlM0Rvl9p1LAD78ntwmVm3PZaOCY1XKKdhh/hOND+L6eCUMRE0Mp7wnCvMxs1JCT8sDRBosjSi4/brfer3P/3pOsmzc8Tz1Nf4DP6zdm1vKV/i5k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pLF4h5wy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pLF4h5wy; arc=fail smtp.client-ip=52.101.70.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pLF4h5wy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pLF4h5wy"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Ua00H7XArSTAatEomP1TcgpwNG3WIXRDsxXMXkWyk6CFXDawJzztwn37KLOvHZ3zOP2tnB5hbdDarMgmRKEfE0Da4oMmHegV3Pf0j/kwwNeRd2E5b+v+D6Jd/wOY3eY2jfgvo50pKblGUoZJJGef0AIZZ9jjA9lQagANN6OjyxN7MleWb6aFNqvHA0oTY3I+h71r/Sz3F+H2npKUdxfFYWCUlKS7LVeo1+Th9JjU+azC9LI7iTb1qiyguPeiuvWM+D51Klajg4mNrmK5Cd2ZEkicmol3ajp2zrIP9B3Ed+LVtZdrQamKBKZr4+sDQLaKhY91/paL2Quhm3NvgXpiLg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PYrn++4ZGz8SAkOG89FiZew+ePaIfX+p0dc84R+TzQ=;
 b=JezKKTXwTrm9lmKYFxlb67qPdFD3x8JuSK/n5699NgMH34dMtuWSavRxVSyuAB8gX68ghy5sl5A09P1cv4VPClT2wNSYWqaDP/xQzWRQDVQcYaY0mn2T8akZs5cngTTb/pwcoMoFUwzqVXIMdYq2XxGcOHEWXVYAsjxS4AFWP/tbWIXPNA5onkMPz4hdJOkmwLDHey5F6L1t+gIJsOltE69hUpCfqKXac+b3mW+0Qi+uo0pOAvTN97pAVeaq6Yg4LC2VgWxXAv8+i6I0/HAyccpuqUY9ggniMlv0vn0ikIbQPhciTiU+nM1LCanN8dKymjVWLWEuapOMdQQyyiUdlQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PYrn++4ZGz8SAkOG89FiZew+ePaIfX+p0dc84R+TzQ=;
 b=pLF4h5wykevfSRGsHaX/mcgh0pzXOJUvS4KqJUMsICocunvHPOPE4y7EU/6xNUze15nKve+2LRS7Ka0LG0KJqxxH50+gCNiijMbMxAbg3VtDp8cbS93w3mBlqWh1tuOxC34Km//nCSWGLiA3Gperz8tSwyqKSXvIv3QvNnXMVJU=
Received: from AS4P191CA0016.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::11)
 by DB4PR08MB9312.eurprd08.prod.outlook.com (2603:10a6:10:3f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:38:07 +0000
Received: from DB5PEPF00014B8C.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::63) by AS4P191CA0016.outlook.office365.com
 (2603:10a6:20b:5d9::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:38:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8C.mail.protection.outlook.com (10.167.8.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:38:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W8/xK1P49gQWONCNop5fEmm7LflbRF5cwZ/b9mMSuLOQv9t0mo0Q72J9/Soy7ZBqLxM9UKMy7NDtzdkIBobdsdwZV9fqFz3N45SQ04btdgUD58XqM9NEXGsdcRJmV1vTnYdVdfLiYEuv4jCG1H5H81doCvIuWvhBgh9OZjco2MgXHSQbMPJwrCu4FCRCHIRjPFyGE4lj6s+OUWiwdFW19niwP2mfpy7sc0/zmWWp2UAcJY8LZJS689ajx63kOpl/U+0rrcF1j1kPHFCL12GdSHs/BmbK9yIOymO4Dkj7ybBKjlo2cA+I1KVccjYIrMSsdidqDXL0VwLIbBLCxCyOnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PYrn++4ZGz8SAkOG89FiZew+ePaIfX+p0dc84R+TzQ=;
 b=ogk+/G6RV3xKRHeqTCy+kYWEDhgnVOTHlb9dU9gta4ELur+i26BNy0wFvOdA52iij+0Mf8ZdoQdbaV17jeP6kIspBys9eGAiAzY77MxK5erbsaa/MD7EVGbikPJ4YqSGrdi04YJamnAAafKg4POKAfr2xBMR5xJtZPS3EcaQn1UAg7KOrqC36H87wpG+Sh0YEF6CB8xfcDAJd6+xB3X4U+YxYL2ItsVIUZnku4m1auMUski/WWawuIUXMlFDhAsxZSyYLCJXkKYxvImZzPwESZtQU7Ad45SxNWOoQQ6qQb2GDVzE8xqjjP6ejdZ3lkC689QpG2hMKWfXQ0mR78HbFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PYrn++4ZGz8SAkOG89FiZew+ePaIfX+p0dc84R+TzQ=;
 b=pLF4h5wykevfSRGsHaX/mcgh0pzXOJUvS4KqJUMsICocunvHPOPE4y7EU/6xNUze15nKve+2LRS7Ka0LG0KJqxxH50+gCNiijMbMxAbg3VtDp8cbS93w3mBlqWh1tuOxC34Km//nCSWGLiA3Gperz8tSwyqKSXvIv3QvNnXMVJU=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DBBPR08MB10793.eurprd08.prod.outlook.com (2603:10a6:10:53d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:37:34 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:37:33 +0000
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
Subject: [PATCH v5 49/49] KVM: selftests: Add VGICv5 sparse vCPU IDs test
Thread-Topic: [PATCH v5 49/49] KVM: selftests: Add VGICv5 sparse vCPU IDs test
Thread-Index: AQHdJmEjhOX8KfScjk6WDNanV30n5w==
Date: Fri, 7 Aug 2026 11:37:33 +0000
Message-ID: <20260807111159.429128-50-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DBBPR08MB10793:EE_|DB5PEPF00014B8C:EE_|DB4PR08MB9312:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ef35747-c50b-4aa5-a1de-08def47859c1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|6133799003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 T7HhZU9GPePVSSI6N4R1P4sckKBa1iwARNs5d10JmoP4dITE8nU47niGL2Xgo8vSyoSSiQmEckjc0YNgR8r5P9lFn6QLTzezk2kCpb0zwTYnC4edJ+qg+2xO0MewB7WvHMOtX0XvNikF30CF188mNad717USLHOGXlY+wHhb7ddoA1hX8/UoeyEHY/CCNN+utCerLK56LGMdEQVHz01zC/9054tOAe03fNIHWiI+C1/t5cjBSGamL9pvl+ncPiM+LS+8OlZCswq/7Jjq1w+RFOjph/l05GQkPhcKJ6TsMgS0qbPgMEkoNN1YRVPc/PCQgSg9z4sA0lbKLWXD+XWuKytDIo3ACTZOmUwfRH/Tr1Ath+HgmGKKPcgeUKYpJO8T2hUtdoJpJEAmXAorEZ+UQAqwqLGncf8bamQBU558bdT/IkpeRDH5F4GIioW/oWLvsLgGHHScAYhcFSsYG0vEAiti6AOdghdDhAWas3bavthPMC6opGARTQYHzKFsENMF843Oa+QdJuW82UBMlr3ETHUjJyumaPd29JWKh6iRjKm9KhN0U0jHemdDnpKGnYhRNUbb855x3oB6jHeWEToJhcT8BpHCv95cFFMKiUhi9Jh2ZgsK1lWt2R9+ZIvCNA0TphNWaCp52fuGGGwHxhVQrUU6dRUJClyzHA8h68lUsntx3oEzNKloaKNapaSVgnmGpUXHfeeyP7Ckg+3BX/dHhuk9h0aRtRUjz0o7ss7MSEo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(6133799003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WVAYybvsYSVTvAI50Ac3TA62xvXghEsPOg7fhUA7FHwFQt3PuG/oBJrD3XKPDZwRi2TrLIB7N7dkc317Bx/pMDphXKnPw5JgpK/Ki9jqVPZfUcccxYDsrNhfnV/x0YGRa7eJJvwsRiMp7Y/qY+JDEQdsY5Q26we4K2KA19qXCGZxmQIEypmZVhffsVOdID2AY4kEyYSpEg/udLLS/8gLM5FRywVvx7GrBpreE4xSGKI3n/ImAe3LaxhzdXLnSa+N+Avb00430kU/F7x9RHt6vf11RDze9p/kG0ppHex8ZdNx0DMHXZT367gh6T7mPa4WoC7K+i2dhAdMebEV5t3+Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10793
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aeed0c18-39f3-43ce-a991-08def47845e2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|376014|35042699022|36860700016|23010399003|18002099003|22082099003|11063799006|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	8byLc7c03MCvkrfgIHDnXxhHmXMUGKs4JQNx72Vv4CwiAvxac4e1evN7cd0dnOOPKx4huSAcxlBqSz4jHz3Zn6RI5sesQ87c77MFRSZcE18scQCS9x+QHnwPcTx4Efc24pheqwcpgDxDSL/KuIX0EJEW/n9cl+xR5Rx24LNlWm6zRC+pKSZkcmp3m2oq8Y+yk8Jm7ZDoGyjBYImaBr0VyULM6OVp7Zfmflg/3Enx5zPrIAeB3FfHqwoHqFaWz/Sc6gDWSO2UukQv1ui+HtWhR3b1ssxZU2HpoESGNXo8fZ4Zy4DUj6omb84IxlHveENeq3ckHK8sKdnQ1Wm1cAFCByz6aYvr4IwAAbOcVFO7hYqnX2By2UasWq+wZjyTrT54wDeO921y8Aq7jONzQ7CO5gqXZ+uctULgTrEagSlJa1prhz7rw75aKoM+ufR1bvLJi8ZrVPtyTejgNtnZO9opMMjTjBid0gcvTAwjaXdCDUVJrjHtSU7+44n649k9JpggufGnLRPs8pq+hpld1rBeGD7aBBUnuLb5006NdzLp99qGQkFX4P44vk/SLtIIDW0WZ5pFqrQAkyaIsiG9nYd7PIGE3ieZX31rITinXEch7hJmFmKpuSUmK5+iPV7BW1jNYTY0uQ+bbXMQhfUMpOqy5JmN66x0Em2Qgea8OMRQRJR44pozxDFhSwhDQbv5bEXu6aWrpCeajDb1aiHtA8/SwA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(376014)(35042699022)(36860700016)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OAd2vac2/Z9R69FkeHQAVX5ukFL/SHDNgeiucd4JJl90ZjOVIvPWnBhsCi2b1KfMEtqnHYDCSwoNTE5a0Cv3AgdFzVPJFBEBWUTU8hJ8PyNTKhUWPLzu2Uzk9VisZtF7LFcZUl4eFX5fIyizzhE0JvV04aTbE9vBosPpPpayM+XPMaIk6UIsLg8BG4Z8dZg3oRZIHM3rxEia9K5G8dnP+6nEs7izBaSupP070ZzK4pX3vgG/u2aeKO5WqC4MKHmrHJ5EX7HSYM7v0SosxOlgV0XVMrYlGytgLKAaPRpYyIvZ2kxZSErDFVThVxSQMYFhsozSyh97lxXJpYttthV1Sm1wcfHeJKSrL+aYCYb6Gpx4f0HF7WYfMYYV1W26vPDx9doBsxREVvZmHftE/ocgeO769Oyx+M4g52f4goxWNAlpa5PppPCYMtKgGrTmSvri
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:38:07.1324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef35747-c50b-4aa5-a1de-08def47859c1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9312

GICv5 uses the userspace-provided vCPU ID as the VPE ID. This must
work when vCPU IDs are sparse and differ from the dense internal vCPU
index.

Add a test that creates vCPUs with IDs 17 and 3, verifies that a vCPU
with ID 512 is rejected after a GICv5 has been created, and runs both
vCPUs to check that ICC_IAFFIDR_EL1 reports the correct VPE IDs on
each.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 70 +++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 47e147bc14b87..3eef2d2da595f 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -14,6 +14,10 @@
=20
 #define NR_VCPUS		1
 #define VGIC_V5_LPI_NR_VCPUS	2
+#define VGIC_V5_SPARSE_NR_VCPUS	2
+#define VGIC_V5_SPARSE_VCPU0_ID	17
+#define VGIC_V5_SPARSE_VCPU1_ID	3
+#define VGIC_V5_SPARSE_TOO_BIG_ID	512
 #define VGIC_V5_LPI_MEMSLOT	1
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
@@ -297,6 +301,13 @@ static void guest_code(void)
 		cpu_relax();
 }
=20
+static void guest_iaffid_code(void)
+{
+	GUEST_SYNC(FIELD_GET(ICC_IAFFIDR_EL1_IAFFID,
+				     read_sysreg_s(SYS_ICC_IAFFIDR_EL1)));
+	GUEST_DONE();
+}
+
 static void guest_spi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -1508,6 +1519,62 @@ static void test_vgic_v5_cpu_sysreg_attrs(void)
 	vm_gic_destroy(&v);
 }
=20
+static void test_vgic_v5_sparse_vcpu_ids(void)
+{
+	struct kvm_vcpu *vcpus[VGIC_V5_SPARSE_NR_VCPUS];
+	const u32 vcpu_ids[VGIC_V5_SPARSE_NR_VCPUS] =3D {
+		VGIC_V5_SPARSE_VCPU0_ID,
+		VGIC_V5_SPARSE_VCPU1_ID,
+	};
+	int ret, i;
+	struct ucall uc;
+	struct vm_gic v;
+	u64 attr;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_SPARSE_NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+
+	/*
+	 * A GICv5 VM cannot create a vCPU outside the VPE ID range. We've
+	 * already created a GICv5, so it should reject VCPU creation.
+	 */
+	ret =3D __vm_ioctl(v.vm, KVM_CREATE_VCPU,
+			 (void *)(unsigned long)VGIC_V5_SPARSE_TOO_BIG_ID);
+	TEST_ASSERT(ret < 0 && errno =3D=3D EINVAL,
+		    "GICv5 accepted vCPU ID %u", VGIC_V5_SPARSE_TOO_BIG_ID);
+
+	/* Now, create two vCPUs with legal, albeit sparse, IDs */
+	for (i =3D 0; i < ARRAY_SIZE(vcpus); i++) {
+		vcpus[i] =3D vm_vcpu_add(v.vm, vcpu_ids[i], guest_iaffid_code);
+		TEST_ASSERT(vcpus[i], "Failed to create vCPU %u", vcpu_ids[i]);
+	}
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	vgic_v5_map_irs(v.vm);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Check both are runnable, and read back their correct IAFFIDs */
+	for (i =3D 0; i < ARRAY_SIZE(vcpus); i++) {
+		/* IAFFID is the VPE ID and must match the userspace vCPU ID. */
+		ret =3D run_vcpu(vcpus[i]);
+		TEST_ASSERT(!ret, "Failed to run GICv5 vCPU %u", vcpu_ids[i]);
+		TEST_ASSERT(get_ucall(vcpus[i], &uc) =3D=3D UCALL_SYNC &&
+			    uc.args[1] =3D=3D vcpu_ids[i],
+			    "GICv5 vCPU %u IAFFID mismatch", vcpu_ids[i]);
+
+		ret =3D run_vcpu(vcpus[i]);
+		TEST_ASSERT(!ret, "Failed to complete GICv5 vCPU %u", vcpu_ids[i]);
+		TEST_ASSERT(get_ucall(vcpus[i], NULL) =3D=3D UCALL_DONE,
+			    "GICv5 vCPU %u did not complete", vcpu_ids[i]);
+	}
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -1952,6 +2019,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 CPU sysreg attrs\n");
 	test_vgic_v5_cpu_sysreg_attrs();
=20
+	pr_info("Test VGICv5 sparse vCPU IDs\n");
+	test_vgic_v5_sparse_vcpu_ids();
+
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
=20
--=20
2.34.1
