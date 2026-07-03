Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012062.outbound.protection.outlook.com [52.101.66.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C5828C2A1
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094546; cv=fail; b=DSgS1ENQI3QQF6E8eLWWbia+r4TXcw0ItLSIYJ3+IhIPiNKiBrlGakikeKUpfPleFgbIDrbg1g16W/QY51pA4F9Mdp+Ou7eVsP7siiB391Me3x1U5AslRTN3oWV/YRYtscZsDLQEu0s0BMqRfjmNBqjPS3kNk2wZkn05VWsXjoo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094546; c=relaxed/simple;
	bh=h1+KdVUF5hHzDITrin53b+E/KBI2YiZ5i+V4pTaUlsw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EK3XDmF3+FHfvsqnyASQ/jJ5Sc8q8sYdR/OGKx1IJI3Tat642/KGdmiDHtIW9lOixFU/qKlUFCObVCiRCEiErACauGtMIUyEQJegcyVWVQOKbnGmZO4G6cjiXeu52LEN9tRofmOn2k0po9PNnLzy3XZlJbJE2YhbxPoWE2rlQD0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hOL8Dk9p; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hOL8Dk9p; arc=fail smtp.client-ip=52.101.66.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hOL8Dk9p";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hOL8Dk9p"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AVZRKlFYKVuhXixbXWLi9x8nzImvlA4Wn8vbIZpM/tGTU72FE12RUjplcBsCTJxnd+TNDuT6Y0pqbKdsSWWECipp14q7wfd7WWSxLWllEWemllyQz3TTYIR+IL9i5Ht6kK/cOebHe2cJslWAb4RTooEjZmDOoOZHbdaGMDr2CAe5NGPyE5OYuAC+wBrDUr6Jy33KPFaM9guEye+nW01nCmY4zkd1/CpNj53Btp/U7CwJqbX3kLeB3OiTUbFwdPB+bi4MzCWdTJFugDBthE/YxkJn+TS+KZDu8aCoqwCJZimNs1HrRIAt3UOa09uyiAiWr8Joxr95bz3HJbMqVbkzQA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0Ko6JUCI5bbBrRjzQ3GYLms1KE3fW3bqLk2wpWYnl8=;
 b=DDmWmwIgnoaUpdmKQQEAKVJmJO14lvcj+VaIlQCjLgTczSL/Kg9wlpVfRFj0wzq/ArPCJZCogRZtNFpH1yRD8P6Dv0uyjlZd8/x28iDAbn48f48Xnrq+/JP6RbP95p2pLC1TqIqkOKQyHONRJTDGpaZz1ptzzY6C14c9iRVfnZsVP8KL/rA3bIlUKbLsJfExmghPBs+k3htUqQUj+1Z+uYDBtJvbHBgrVHPe1JDOlsBSr8ZqduD1xPvwxuvUmH9iHUAsPq8qCPqAQzbtFKgYP4tIonRVxZzEcgPrQ3PbuQdEFHtjXu9SK/XAc/YODfl/5xj6IC7ZYJC8TYAPXxFBXg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0Ko6JUCI5bbBrRjzQ3GYLms1KE3fW3bqLk2wpWYnl8=;
 b=hOL8Dk9pVwxCSiA6iPWaCgW78NfYDWgCNzd1yQ1Y5CSzHmnub1NBmdkCT0yJsUj4kLhr9juDB+hNTEi4TioH78Sf6ukb+95hMpECXmeuN594cQoB0azt2V+MGNNqApSXQM7VGTfK3tny1K9inUnGTzgSAJkohEAp8jSBimL4ZII=
Received: from AS9PR06CA0285.eurprd06.prod.outlook.com (2603:10a6:20b:45a::31)
 by AS1PR08MB7451.eurprd08.prod.outlook.com (2603:10a6:20b:4dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:02:16 +0000
Received: from AMS0EPF0000019F.eurprd05.prod.outlook.com
 (2603:10a6:20b:45a:cafe::8f) by AS9PR06CA0285.outlook.office365.com
 (2603:10a6:20b:45a::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:02:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019F.mail.protection.outlook.com (10.167.16.251) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:02:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRfdqJhvNMImmwvKs+2qndRIaPMAAPHDTcDHNsRJKlY3PkmbdKPCXqKHs6JfCENLMhcOkdPi7JjCFZiA0bvZl3N+r36BxTnTNhJneE19QYZ1SyTRKVbazCy6UlYx9mTHPc/oqSWO/Pn6k5GGKHjJAP3dsoDRrM5k1cKkxFBFPbjL62mgf7/DofwrdHnJGLATB/acpVPtLqyuNN/a1ellhVOwOnltITxPU/XsPqi4mmx9Ul0RSeSZ7YwiVzjAGYKmc3hgGU9Kj+qxkAvmAYkK5nZoNBm338aXUENhCmQ9DBOSqjTPSv0uEx5Wr3DILem2ZTgjEDldMl3FiXHBU2Z2FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0Ko6JUCI5bbBrRjzQ3GYLms1KE3fW3bqLk2wpWYnl8=;
 b=jBfk2TGgPshfOm6cO/NSlHKyOmvSPflNhxLqAP9/wlHqJZHsF3n7bfX3MlgyXJHcqV4/4anQZIwGDplr0R8Bs8+h6y+kDQ0eTjJw82c+OMbt24gmFr6NjJfpC70G2M4z4I0rcCPIqj6RAFjr4ArVJv2kg9eWHox7zaHF0XOrWnfF7nvDqmNrApjJZbjziz5Ccq57bq86MMmAIys7blsyDHGsh/am2gXhr3qoQ6flXsppIdVxSXNC8Wir7yKNpIWy5vhfNIi5cBT5PVKzanRSlBaDDdtVNaUysWnIbzGBKULQz831p9gPTHrmij6sp5oXn/mfrQoiDfJbU6uXnZpAug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0Ko6JUCI5bbBrRjzQ3GYLms1KE3fW3bqLk2wpWYnl8=;
 b=hOL8Dk9pVwxCSiA6iPWaCgW78NfYDWgCNzd1yQ1Y5CSzHmnub1NBmdkCT0yJsUj4kLhr9juDB+hNTEi4TioH78Sf6ukb+95hMpECXmeuN594cQoB0azt2V+MGNNqApSXQM7VGTfK3tny1K9inUnGTzgSAJkohEAp8jSBimL4ZII=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:01:14 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:01:14 +0000
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
Subject: [PATCH v3 21/40] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Topic: [PATCH v3 21/40] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Index: AQHdCwUsue4g60bNSkmqtGOqodi1ig==
Date: Fri, 3 Jul 2026 16:01:13 +0000
Message-ID: <20260703154811.3355680-22-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|AMS0EPF0000019F:EE_|AS1PR08MB7451:EE_
X-MS-Office365-Filtering-Correlation-Id: 71859186-453b-475c-3a74-08ded91c746a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 /dOLfv69Smzj13vnfsiV3JY1tKeuNO9ZBra3/d08honITD5P+axzPLfKS2/sGvXpUGW7CPzdYqxaA40PkDRB/XF8jIKd3Y0uY8MwjSrNB6gD2F6qejEJwo8KP5I8Pfr/JGFJ6nsVxrmrRj9ZRW3mJ4FjH2ZGxR4kWruFpqU4sUrJjQj48pQr6oO10211YR/AXR4E1o8H7MKdS8ertxKykb97rdjrldyjQyXyrM3em8kPV78tjZjCJv17qjr2fwqBRaib0gmNaA4pnodjG3NsWdUxvnMEMZ0dN/AwVrvPnC4vG+kAARko0qAohC5EUekOFnAmtyQ0y4c5W1CZ+y2faTCt9UR4z+chDTeM/DHV8jE++wk/hgVcfoHPki0AwYEGegL2bprTkZoVeUeJ72VhQFtGrpK+NxqhK4a4R/BBaiRHmVVVmvAaMLxZu+K11zL502j99dHSmNC+HVKEkGInnVwyzzcHPMrQzekZwPJXa6BKthpgVnLCrL5znJoKJq7QGGKvL8zZcsBM1V5LMyY6Ze9bajo9DAebOab8yCgUf9Sz65ZJMwegFNCwtj0/oCEULqGGmLK7o1Vu7gF09fmK+ll0kq0uMZbs46xbS/6iPBuwPog4fe+bLOKFBGQWv2LsHF/Jha91TYI/PIe3bN7sdyQwMBTfWBMWlHbpramMarUTO0uiwJR9bUvPScDnkg+hWjfOvxwiJj6fd2Rt6RVvhD3Dt1J+GiiPhzzwNbhLdGE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ZTJxlsO3xrkHPP1hhWMJbJ/mOMQNZV35eQc5yF+F7joYB3YsmCd9AJtxbkCZEn4e8pflL3qPAod61DXD3dWwAH6KY8FcRoSI0dyfeXo+xblERQgVjHc+f2EmHpDRI5srvMFto4GBsN4yt8qLij44MNzPY1TFLilTm06eQWVJs7eO+6weFanfaWfEvobo0GGLKkAg8V4egTrM0ji4ZaQorK56mFuJKHlbQStNv29Wz97rOav0N3reXkPjRazSiXTYmbbxVNjqIfO6QfaQ5kyeJSG/WuA3NCKxjPaM0m+LetJXLcPx9P7dxjPbeFOQJkn5wlvJqSbEPIHxo+t1O6mjRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5fd5676a-7e79-42fa-7190-08ded91c4eee
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|14060799003|376014|35042699022|22082099003|18002099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	yIljbKsoms4uoMnTvgaxsOlkAaZxPeVwbPQS0pRNz4tbirkTPxAdO4i0/WtMc5hM4/mV4fMEEM0EYw7Z/xbHExbaTwFMpuAxQdMphvaSSN8es21P9x2hG3TxF05zWcPbFQHZdgoDYN+BNIT2BKoVBblQdncYV2AlZXqzAC7EVEoXrDNakcQhaJehFNW9ZUOjzTt4CTh+1+pyTA/0UT9N9bHfLJ3Uv4pS5WwyZ6/2ESRLFEXb19xcBgmWPn79DnC4J8fuQHbXz6LeIsRk+AISQcB9Pfviia+m2XiNWLF2VSUBgz5v6+G0Do59Myq4931VoswfK4vyecPDrpSeNHXHP7wXfMf2zgZpTxW1XwNLKUwsiW5mLiVX1VURoDlTXfzqPbWSdYYjm20H9XGTgPte2WleXwwgB3G5ALMUnhjWjzgrS4SAR2JKNcTGWenWykkrWebWyDsv4PyStC+a6dPmwWE/w+yl8to2bG1gviFFYbY0z3cQWEiHSsWPi7pLqDAVMTeTSzi78CqJpeLe3Kscq5e/WgDXZUe5MdXm5tR0nHtybgUOKQ7P7HeL6i4H6Rt77/kQaMuu0m4PuG5Api+C32pMpNskktwK28DrR6zipb/nJuZWwp6rpT4ALYWteNFQOaEeE//aPg1Xf3MyIaSgcokstSWasDONtnm6qqsfLNzfI+/0X63RhMKUN7I69/DgZYoR6j7QBv4GJfhdEQiBhA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(14060799003)(376014)(35042699022)(22082099003)(18002099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6+ogWLk2r/b50GMQRqLCA0A7DnTg1XlyRw80uPUAq30iTDf4pbOFos2LzjNjQSOjVilKndbyWyICjjrZ3T9p44mvR9jtGbBkZztU1Od16hhBmSzypbO6udIvbRkiqBvr0MCEtWQkJGlUjUK/tWzNAS/T+H+cXsxjbdAQESAV6iW7oqWJkzT3jxQddg8JUNQOK/Acgl9ELNyQYXRsqLQrCOJbztVYImVO50VBS9+BlSIrpesLLOQOIT1t+uDeJ2GpPePt/6xGVtEH3qgBl2PW8G5k/0y/uJ9m3O06Or7oVxO9VkaTFacnLk5HiQVa2Afta1hDafjmekrWdtayDMDEeNBP1RE4B85PGnR79nRQzvnMvDDuED8++LvX2KtNXEZ+yIIZsN51K2jjF9/QiLa+LSV7QXyPwYpCpWOsJOzMwZvAvWqMIhRN+CzKEeIX3N+6
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:02:16.7685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71859186-453b-475c-3a74-08ded91c746a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7451

A virtual GICv5 needs an emulated IRS in addition to the host IRS
state used to back VMTEs, VPEs, and ISTs. Without this, KVM can only
provide the CPU-local PPI state and cannot expose the IRS-backed SPI
and LPI configuration expected by a GICv5 guest.

Allocate the per-VM emulated IRS state when creating a virtual GICv5,
and initialise it from vgic_v5_init(). If userspace has not provided a
number of SPIs, use the GICv5 default of 32. The IRS init path
allocates the SPI state, initialises the virtual IRS register state,
and creates the backing SPI IST when SPIs are present.

Keep the per-VM IRS object alive for the lifetime of the virtual GICv5.
vgic_v5_teardown() only unwinds resources allocated by vgic_v5_init(), so
failed initialisation can be retried, while kvm_vgic_dist_destroy() frees
the IRS object during final VGIC destruction.

This gives virtual GICv5s the IRS backing required for SPIs and LPIs,
rather than being limited to PPIs, only. Further patches add support for
SPI injection and lifecycle tracking.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 59 +++++++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-v5.c   |  8 ++++-
 2 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 94632fd90b728..aa883507d00d1 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -174,28 +174,48 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 			break;
 	}
=20
-	if (ret) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
-			kfree(vgic_cpu->private_irqs);
-			vgic_cpu->private_irqs =3D NULL;
-		}
-
-		kvm->arch.vgic.vgic_model =3D 0;
-		goto out_unlock;
-	}
+	if (ret)
+		goto out_free_private_irqs;
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
=20
-	/*
-	 * We now know that we have a GICv5. The Arch Timer PPI interrupts may
-	 * have been initialised at this stage, but will have done so assuming
-	 * that we have an older GIC, meaning that the IntIDs won't be
-	 * correct. We init them again, and this time they will be correct.
-	 */
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		/* Allocate a vIRS for GICv5 systems */
+		kvm->arch.vgic.vgic_v5_irs_data =3D kzalloc_obj(struct vgic_v5_irs,
+							      GFP_KERNEL_ACCOUNT);
+		if (!kvm->arch.vgic.vgic_v5_irs_data) {
+			ret =3D -ENOMEM;
+			goto out_free_private_irqs;
+		}
+
+		/*
+		 * Initialization happens later, for now just explicitly
+		 * disable the device and undef its base address.
+		 */
+		kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base =3D VGIC_ADDR_UNDEF;
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
 		kvm_timer_init_vm(kvm);
+	}
+
+	goto out_unlock;
+
+out_free_private_irqs:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
+
+		kfree(vgic_cpu->private_irqs);
+		vgic_cpu->private_irqs =3D NULL;
+	}
+
+	kvm->arch.vgic.vgic_model =3D 0;
=20
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
@@ -467,6 +487,9 @@ int vgic_init(struct kvm *kvm)
 				return ret;
 		}
 	} else {
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_V5_DEFAULT_NR_SPIS;
+
 		ret =3D vgic_v5_init(kvm);
 		if (ret)
 			return ret;
@@ -512,6 +535,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V5:
 		vgic_v5_teardown(kvm);
+		kfree(dist->vgic_v5_irs_data);
+		dist->vgic_v5_irs_data =3D NULL;
 		break;
 	}
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 6e976162ec3c2..2df61426cc714 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -676,7 +676,8 @@ void vgic_v5_teardown(struct kvm *kvm)
=20
 /*
  * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
- * doorbells, allocate VPET and populate for each VPE.
+ * doorbells, allocate VPET and populate for each VPE. Finally, we also in=
it the
+ * vIRS, which means allocating and making the virtual SPI IST valid.
  *
  * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
  * our conduit for communication with the IRS, which means we need to have=
 those
@@ -746,6 +747,11 @@ int vgic_v5_init(struct kvm *kvm)
 			goto err;
 	}
=20
+	/* Init IRS (and alloc SPI IST) */
+	ret =3D kvm_vgic_v5_irs_init(kvm, kvm->arch.vgic.nr_spis);
+	if (ret)
+		goto err;
+
 	return 0;
=20
 err:
--=20
2.34.1
