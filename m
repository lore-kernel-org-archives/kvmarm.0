Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011039.outbound.protection.outlook.com [52.101.65.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59613E3D86
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935983; cv=fail; b=SQR+jQoPs8XsH0aDEdJNuWifETS1qO5pU7aOT5sp8i/Pq6NUgFGESwulRbaRQwFQbkkZxRMpsYjjXblsf7OxLDF5yXAnibnzHHKj7rGV+O3tnilXH16cQYdp5rJV822YKWfo8z14F7gCaXi80fenkj7DyWFHJy28Wtw3WjbScoo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935983; c=relaxed/simple;
	bh=8+M8WULq8f3gu0ziHrvllhJJxoG+HZqYtKV6aN2xPBo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d+oN4r/L0Bh5G5aSH1Bj+nnJWfjZvA5yRX4b+OCn/iMUbRj7X1u5c2QIRHOw7eOshF8FgWUomiBi3+gxpWRLTp8Sw2T6Dcx21ZVvzm98FsgENULy5u4Ni28fI0Hn7JW1YudlG01kGKgW5AdQsvamPmVsrrP5trPGXpjCoNxoclw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xx4LdtCg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xx4LdtCg; arc=fail smtp.client-ip=52.101.65.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xx4LdtCg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xx4LdtCg"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RZ6IYr4IvDBsz4WTvREc06OgHr2NFgy4Ma8BOgu9F7O8FcIyaudXSiHLqRfecXL6v7tMTO2usdVa3/eK7bUNgkc2XEAk8ezkO4T5z4hc0irJ1MUnBVPhWk7tqOtTT/dI6fc55Qsv/3JQrCo/FnFshFszoJV513o5R47JW1wSYF1BB7O9pBYYpQoPdje2VjQMAOwv0dCUNailc3OfFVxIwRq1OENO258o7bLvYXJL6u6KcW0TkilB118M5gNRtyAafdBAIShOIBElP6QZTm4hJsjV+R+NYop7RZNBEVjs2bhso6cXWlu1J9uj1V3UuTsCe2YvOxnlOp5bq8oY08f0Lg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNZQwwJZtSV9/AKfdFKcYghQDdPUsFda8kH06VCDtvM=;
 b=R7twNELYI8OGi5iYl1BtfCItFRLZPlq319YFqzmaM6IJc6XkozVmsLQ0FR9z2ww7xoX2xzAGP0QtMcHHc0p5hpE/bNJPmVaODdm9vaxtbOSCN9XJRi+uMP2PvV0JP6qIkz7+aSpg3OU5ketQfS8d41/XyfW5WZlzB252i1b0K0fZGVpWIDSr8W85v1ZwuGleQnggAgJeRin59H3O2GpvZGsbs9BOA18qZ0eRK/NLFQj/6cxb4YBOIPgps+zxL1Lb5POEiEQ5mky1I/YrCuqXy9wrjz1t3OJS7/gqsRx2OI9eDf2U1glZ9AzqbE4MrOekyLtwlcCE5snRKydQ9oYUUw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNZQwwJZtSV9/AKfdFKcYghQDdPUsFda8kH06VCDtvM=;
 b=Xx4LdtCgU32HE+mLxiLUkpsjSnYhcyFoq6yJWR5atlFPY8Y42Dcl9JWhnBQ0VjjGD9XkW0flMUNbkwjvvsgPJpfDQWhntEDt4gfLbu13TCvkW0QwlXibLRnSrrZ88GplMXzBCtTdAgDYNqjv7l/ZDD8sKeQX2HrPmKbICk4Is40=
Received: from DU2P251CA0023.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::35)
 by AS2PR08MB10154.eurprd08.prod.outlook.com (2603:10a6:20b:62e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:59:36 +0000
Received: from DU2PEPF00028D0F.eurprd03.prod.outlook.com
 (2603:10a6:10:230:cafe::dd) by DU2P251CA0023.outlook.office365.com
 (2603:10a6:10:230::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:59:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0F.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:59:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BfBg6mX6Q8gvPqK5tR7HEobY6zlWA2Jf2bbUMtfzxlb8sHS35JBgeLxJ8/1S8mEKTcZlrLKz/9OxTYWj/zwnHAWiqbUVcYnRM+QUhtp4zK3rDwAbOOjo7QZuLm+lQrIMXxNdOar1rWZSWitPmgvPcd3o/C0WCuUX1zrQLmN5EfaufH/AdZbuDnqVCbvK8owA1f1vaJXn2LFk6os0jaT60jEx/OaRpFwraMC+n6hD94a7pARnPkqBhcQSXAI9XIvZSWTg+rXlW8Pedm2iWYX1cqC7ZiTyibXHrASTUX+k5LJ/8k3HW4CH4Z7KKFOrcSZDviPq0p+M98iAPyHrwunkyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNZQwwJZtSV9/AKfdFKcYghQDdPUsFda8kH06VCDtvM=;
 b=YWjmNkfJqYHKqx3KoUSEYdkaU6s5kz25F6DeYCv7aAEKWNKoJaIGYz8Y+WBZAKpyUn4JPfQ1YgVC2pAa77PWNm5CS8X1bTIwE1cJzTEX7gO8nTE5YTbxdWDfC1bPFabo4EP5VFbu87OvWH1cyUXT99zqhwnBvSZPrnNZneeOURvyKfm50QDltSGL02HgdDYl7SlHBxxowZq18ACdKwq0DYaLhta2es6so15oC6a3ezdiCS5e036VZFiiZOaeJIMbRzeI+D72tpOjcGSB5cByebREcPlwCAc+E6TyfRVjVlF8rf3rD4ovDv5Jn7LkR1GNWsiqkz7R4rY6zA62HLJXvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNZQwwJZtSV9/AKfdFKcYghQDdPUsFda8kH06VCDtvM=;
 b=Xx4LdtCgU32HE+mLxiLUkpsjSnYhcyFoq6yJWR5atlFPY8Y42Dcl9JWhnBQ0VjjGD9XkW0flMUNbkwjvvsgPJpfDQWhntEDt4gfLbu13TCvkW0QwlXibLRnSrrZ88GplMXzBCtTdAgDYNqjv7l/ZDD8sKeQX2HrPmKbICk4Is40=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB9414.eurprd08.prod.outlook.com (2603:10a6:20b:596::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Thu, 19 Mar
 2026 15:58:33 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:58:33 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 34/41] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5
 guests
Thread-Topic: [PATCH v7 34/41] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV
 GICv5 guests
Thread-Index: AQHct7k8Cmfarf88Ok6dmX1Kz4zD4A==
Date: Thu, 19 Mar 2026 15:58:33 +0000
Message-ID: <20260319154937.3619520-35-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AS2PR08MB9414:EE_|DU2PEPF00028D0F:EE_|AS2PR08MB10154:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d347822-a203-45fa-5d05-08de85d084a1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Q9S3hGEJJVubL+rBSF2ZayaB9SWITDgKlWAdeqZOcI5cAIqqh2aNksP1p/YTENGVPU3i/AwS2P8GtMwNWNIxoM1f5aFfhZ7Qfb2jwRHyKR0rK8dK9GJ9wYmeAJd91ud2XE/zVX/mfDR1eMJlnb1vuzG1YTeHFewrvJamRB7xcfmRD1gSu094asMGl6WqV9Hgd3UDTq5yUBHBFwt3sd5CjuAIctle0u1Zh/uQvS64C4PzvMdlvPw/Oe7y0fcIVGascljvUU1ehWTnK2qeYwDM8ajb8nE8Wx3EnICOCLkx0GNmxgccYLfK5xIamWXW1KDSmhYOhvl8MSSLa//oyVEwjbexvE8c9c/bnYHx01FaLGJlMXVth1jZ+xT2A2lO2X3R0LVxkTGgd1l0iPab/NymMUWI8J5cQWLV4c5N0UB6xKitOVrCfJxpKwh5UsvQOkenYotHPDLmIBwLQf26cS+VBQ6wQsmmujafqQZv8wdC4XnYdg5SteHe5R+5csuLqDqD+Vx+8P9i/sjKb+OyCMzz3ifKTCKqK1BMpEbBW60tL66zKFIYpOdxCT3wqngYPiyNUKGU5EbqKqs4SFtrq5Ij/ZByTqvI1MIy2F7SQIuA1DpN2YNwUtRxvjGChun9/BzNrI7d+If0QKKyQUUAH4lGVagj0d8TngaNlGCi8kW5H9sMrYsTPnMDJ279sxGW34OMP1ZQ9+9Nc5FElBRA7KZMO4n15wRUr75PqMHGvBrzxTfyiZ/dg5a6fkoP7S0xExwdpiYptcyvor8ot/b4NX9wcE7J8tYRU5rGqNrbZ/Vw0aU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Fux7pIgZ3Hukp5+nU4P23/Nr6zlcNCf6raqw5UIeEQIgCg6wsAmV/JfQ278gCps8nbMmFcyaqkrVOywlH7zYigQR5UT4uNusql+Oi7TTVfo11r43GAcpFlqPJSlDNKfwO2GpyZkfLLReuXNsAYxHNQmOyhytnZCjgAeaWP3NL74S/xC1g4PJSBe4Qqz/yTfDSnjZnOchuD1a4Ge5NvTlcViYtp4DBQNPgXIzcMF3RK5pkGhVZsR8K5krUgDXlNDHs3+Fdr+j8Stfn4Xek3JB/kGi0U6n0wuH7lCgfc0sbNC4beEfm0HOFjuyQUqr+B2jAWApZ3/MaTCAyZVezD+vvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9414
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	740aa093-89ec-4a39-2429-08de85d05f4b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|35042699022|36860700016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ItxHw8ys6x3zHw6WVx9xZiYlEpwtx2gomBjrqXW3GIP2Ufjs/sT/sB7na0zb265nlCwWJo42R2R5JJeHwDwIuvhnJ73b9TcrmX/q1vuS18csmZIG+Q4F1stmdFYaxkz1+pTItOzzvsIUCjYtvjIlHQ/NT/nCWMOPDTO+5EvsxDRYv63Q3QNLOD18hNcYVw3c+CojOxTLcbXJ7Ys5GXX5r9ZtcRHZ2AjGSv9wgChWedUzSnYAyX+1b8dSRiyWhSxT4ylYKwU1ngBmpumybV90hAct5IZAx+CQp8eynhhD3iqGP+KhcbYX8DoqGsfphVfrRXEmvcaJN781NjiCdgeKRGsh6ZuhteYxrZQMKwFOUC9nLJE6nLTaltI3xiEZxOpDPZODt9kraPIpzX1RJghqFP0Rv9d/INw2+aIWi8snd99YlFnmxJRygvsgu+poNtLJkCcS+oeLBjhcbaAZ/DhVpnOs58EcSvMPt3aInHJCNs0aeXu3xRT5OTKB08nFDaL0a/fefqwngFulUPTnP0ALnkRMd9GGf5gGmTEvVyvYa/KROzHLRYILsTkQxbe436dYa6cQ2xV2/EwTqoj2zlRTKbU0c5HG4zYtCqdlPKWiS1rNTDeRXm65lj73V+3jMCD0ovs/9bGcVTZxjBkfBixxHpL9uwYbcUYQCXcoMvtYKYtc1PYt7Jm8BwXAPijhuTlffSFj02mW1CpB/MysEOcgZksg/tO0XLSBudtVnAECEblcU4n1TCSmlaEjbdSTyeSfUAS/KHpd8QEoaIcYBhbQ/A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(35042699022)(36860700016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	11bMGeeCHR8Vtoaoz6EaXqFVPexgH8dreknCCX+RdRrOxMnrd8OzdbPoGqFn7xQb37CmxDZXXdskqsVbD9r8KneMj54bWToSVfWlzY/HzO7psWw3D0GtLu7e3E6omm1eEq9wII/IePj45hyIy+mpEQmqLlgWXw6X4i0Rms9cxbcpqPXlhilVy364FMUzgzz6OeCRIBFww40+IJi2ZeI6+jmgzsZRiuxnuTK1s1cbMJD0hdeyu6sIOo55Jpz3SlgTA6tgTJHKRpto95gd+ThraPwY9vvg6tzwUDwLX96m+VaaNrDJVICOeFGyxsXJqQDsvwjyUrIt7jHRfDFVeBguRoTbTiD9/jztBuSd2dMSc+HO+pUaxThU7FfM30v07UlpSrsYbrkjip8ryGilhdt/viC/cg2oWerET87v0DZXO6i6nh+QqjujoG3t51rSxu8W
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:59:35.6925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d347822-a203-45fa-5d05-08de85d084a1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10154

Currently, NV guests are not supported with GICv5. Therefore, make
sure that FEAT_GCIE is always hidden from such guests.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 2c43097248b21..efd5d21c7ac75 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1558,6 +1558,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 va=
l)
 			 ID_AA64PFR1_EL1_MTE);
 		break;
=20
+	case SYS_ID_AA64PFR2_EL1:
+		/* GICv5 is not yet supported for NV */
+		val &=3D ~ID_AA64PFR2_EL1_GCIE;
+		break;
+
 	case SYS_ID_AA64MMFR0_EL1:
 		/* Hide ExS, Secure Memory */
 		val &=3D ~(ID_AA64MMFR0_EL1_EXS		|
--=20
2.34.1
