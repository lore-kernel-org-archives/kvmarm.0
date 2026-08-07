Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010035.outbound.protection.outlook.com [52.101.69.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269A83F5BFD
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101716; cv=fail; b=nI8gm8hRejZCopdhoRz48gvzNu77UkWBSw4ZrAZy64z+K4R1icVZdeaL3FrvxT6p2vtJbcfqye2g443gmcm/H4uIgUMwlMfqfqac58+42yR9IiivLnNHs6kt+LaIkkM0aeyXRdyAnaFi14klyoDo2gNHuE4vGtFIwRwrGjFhHS0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101716; c=relaxed/simple;
	bh=AyNjpnC0ShO13lqj24EhzGwll8rIRDiLi7NpA5BJhHE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=neDHCIRS+OEJIUEKwe1XdqvnuieFNsT1JUOvoT6ez8qpHrQnReJo9h24b2/JtCQY4HjZv6L6rl0ImcEut2bcS1nmMPAm8Qp0v85HQ5eu8IExlkflUj6WCv25BMUJozOF5+8U28wJ2YR2bctwMC/cJIn3RQ9U9yWNYX4JMs23BnU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eQqYJUyR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eQqYJUyR; arc=fail smtp.client-ip=52.101.69.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eQqYJUyR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eQqYJUyR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ydV8NJbcm/vPqWPQWNEIvCCFbPHbe5uvQhbGo9Js3S5HNcO0qLn5bbAqp7Ibwg++RcpuMoJEKA33ZEGYrKWtl66z9HoPRBAfcJ1rqxmvpR610afJIeKpsr6aE1NT7M5XS2zK/CpJ9qVC2GuwFvjWKAk0ZAnS1hsBcxr71XPnnahclsxAMdOolJu5xzCYAtEfWvNd06APxjaxhG3en+SAJTVsHX3wPV0UX/jZvGEzBfdM9pv5qAhvoAGsmv9VtpXAgN4Oc1GfQRNXXrK+o0S7lpU7if5g1cqR/y6yZtZxOExGGJqXurSHy+8gVbPBr5yt7D+UgvdtO6UYmhHJ7pbKzg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWVttSg/zYzUFzhkfvOQ1XgcxGLvFFAjxsXLhSJSSoU=;
 b=NZznVz209DoEAr3amnCv8hr1pNqr5/35fDXo5XpEjiaB+KblQ/BAx2OCDS5Ikt9BQwMK5JVPWdn0udv8lFc4keQr8Dtsp2wZ5OCedr6h1YELcfr3nHh6oXuU8klPvaVemq4fMETwQRNdqdol1+SI2SqGmgNfVn1a2IzE5jDEjJevAHHs/fcBK57HOv2k6icpr12N4llNFS9oKPoNUc1/QIdQV0qmdUeKvUzMh/obPobaKr8CtFrBaQQEC3QaPiD8tcPDiIXLi2D/PMBBjRrRkiS3+0KBVSEiKopu4dH5oMP57HpOQZyXObw/MKTgnghBSAvTH82bi7vZMDRbaxeDDA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWVttSg/zYzUFzhkfvOQ1XgcxGLvFFAjxsXLhSJSSoU=;
 b=eQqYJUyR4CsREIDW7Vb4q/m1/K/kbka9jAsI8W/ahxvMzHOFpWV6mm3m/C0GlEee9DNWxxlJegKulxUsNiqAOPSqeTbD4xDEqyO8xNVdIH+A44yNPcTTouydchmMWDJsAO8zozpuwqfRACECaSSS8s0tdO0JcgSCbbhNBXJ4hJM=
Received: from DB8PR04CA0023.eurprd04.prod.outlook.com (2603:10a6:10:110::33)
 by GVXPR08MB7845.eurprd08.prod.outlook.com (2603:10a6:150:1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:21:49 +0000
Received: from DB5PEPF00014B90.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::8) by DB8PR04CA0023.outlook.office365.com
 (2603:10a6:10:110::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:21:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B90.mail.protection.outlook.com (10.167.8.228) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:21:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XgeMLO5Evm6FDGomZL6Ap45pCFk5dNERuwKKVAqmkLbjbbfrTtWY7NH91HTx238GNCiS/GkPv2TBqulkLy6BGm2UnAuLa+rQdnj8gwl0zLBqkpgJKjPBwEd89HlUm5MqqSTSGifQtFkEoYen3gQMFA8v2MVZwM6NWUY4a2MrwgoGqnRzNmGlCKnBCTUwo2LOP4iE9f1JRdDsQR3V88IfYIRoDKR8PuR2MlFAU3GafkfUz6ndTfWVN0AblxUf378+Rjt9yUxdJyVYqcrEHs1mIZoavvwzL5sJATcrhrf47Ju3mPX/ln8z+xwr5sLNufm6vjeHZ6K47GcXbd7wTDyujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWVttSg/zYzUFzhkfvOQ1XgcxGLvFFAjxsXLhSJSSoU=;
 b=HyKFx3EozOUxunZLaAxi3t31eJW2jweQ5hZJ+tGkjq/4bSWU3Ki6X94gpwrOAmsQVovG9vp5vVLVrip6aAtY7DIy0wzsgwe+zFV2k2VNz52aFWrBygAbWPH78TuzAugr7V8l0pbqKd0gKucfokHe3Ykk+yX8Cg5nJjTzL5VbdRsD8oYu3YtHzlqd4RP/iRTAmdcU/KafHy1ElAvyQq1RaQEmhUFy9/s3/dkm65FTLCwXxMAZhO60Wkr6zhuL248AaVQKYJgAU4gLxF4drBNyMIzGqsFtEI6k5S+1Pw+ldOGKR9K0DPGr6XAW325NhGgRjXd8P6wdCUtKVDsIZbHcHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWVttSg/zYzUFzhkfvOQ1XgcxGLvFFAjxsXLhSJSSoU=;
 b=eQqYJUyR4CsREIDW7Vb4q/m1/K/kbka9jAsI8W/ahxvMzHOFpWV6mm3m/C0GlEee9DNWxxlJegKulxUsNiqAOPSqeTbD4xDEqyO8xNVdIH+A44yNPcTTouydchmMWDJsAO8zozpuwqfRACECaSSS8s0tdO0JcgSCbbhNBXJ4hJM=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB8725.eurprd08.prod.outlook.com (2603:10a6:150:b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:21:15 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:21:15 +0000
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
Subject: [PATCH v5 17/49] KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and
 IRS base address
Thread-Topic: [PATCH v5 17/49] KVM: arm64: gic-v5: Introduce struct
 vgic_v5_irs and IRS base address
Thread-Index: AQHdJl7c60MXLa467kK0WTyLrLt+Cg==
Date: Fri, 7 Aug 2026 11:21:15 +0000
Message-ID: <20260807111159.429128-18-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|GV2PR08MB8725:EE_|DB5PEPF00014B90:EE_|GVXPR08MB7845:EE_
X-MS-Office365-Filtering-Correlation-Id: 57362b34-6173-4fad-38bf-08def4761288
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 pN7olJK8aYZLNxW6x7assZ3ZQ1stX4Cf3eEuiTyYFAderEvvLGFKv5IPtuvx1rcvIUjBru7II+Xv7MxcTOsvaBPD6GOmNgXII1naOcuAum3urdySz/FMWiZrVV0115q++bq8WymFrHL1du+OxSyoCO1jMDOkexI5g4FR8Fjmg/Jk5TmPQS6L5EGq60L0kTNKJbXAA5Lt4M03ICSatQcE64AmQnFQi8Ff4C4m2lM7cKl4u99jFD/6inLDMfrPvf/Xc7EhJ5qboWnwAHMXQ/3Fc4s5/QetIcyVUgB0/d5eVz7h9MzUXaojHhzuji5lUFj53cbDjr40cWh1WA0BIstzTmN/vnRX/cWpHDnVAcSg/7S1AhHM5HCEjtl0QtEMY1NhxopSOMZouN3/h99mTAwoTkQmZbGR5MTlFTz4a5vK+vLGRN0FmmsIf+8nW5LKLXwfcIXcnvlAPfbCwB9mQzPuCSP6ehy+1f1nnFO6WIFBBDVpZyYE45vVi+i9R+VaLkWnXzzZLdr8mEWlfh3QkzIV4Pxl34V2Z3T2e6Ky7anrxPkvLSF/uG6RGxRZimfuMhRG2CYU+ccKO4uRDsndB8vGGaYTfUOqPLjuJFi29zamp9jhKJdJBrCt1fvYXuPAnigs2E211N5eZRjt1mCKeJmoXULTn+nO3aEtgvXC+6vbs1qRM6nkRbKNsxhZVxjioAHi2gGkqoStw0F5PNLwVI4rW/AB//2D+UV7MKQgR3iXrdk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 d9F33eJqcufonJFM5iktk1BKuMUG7zdHBAO/fIEyDN4bg7kgWL/xqOAO57aiX7rdm1aqfBKgLdSNWX5bgxJ1X3Kiv+5Tm2gEnJzHNUkUIwOGyWQb4+whvmOwgvG/4CkrsjDHQdrsDZYJFLFZ4YrbHYIB6bIXEKVDLshr6sAO+dIONofBBZuk7C4fpZT6n5noZotgEcDM53TlIi4CfxL80pHyhpDbLf1Ngh2aRtcIiencRRtoq9TQeW4sL3RhyxQDbj0Zo5ZkM6GOzN/wlTO/BKxotF6lw1mvlQPNPNhuRvCevCByKMYpZG744Q7RvTiUq7MjRW9xUay9tPz11Oq2/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	60b99eec-a598-41fa-9dc4-08def475feb1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|1800799024|36860700016|35042699022|376014|23010399003|18002099003|22082099003|11063799006|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	p0lhT1PENhmSBjV5FquA2lzd4zcIKVmmzXvwUSlJrMy+RRlgxPrCmkdChed3QaPw1swRqGQpKQ847AAqsVqZYnfWmL8VFMhjq48ra8yyFbOfceOd4oAi6yUVVzm+Tc/CT5LkTnJ78PJ7FVZENREYlgBaBTvoHuH+/3Aws9nvqXO/iAsOtW9RWhM7X9vZKAoy0788CecCgnNt9yThEKjXBL136XqPoWrnHQjVzvm0yEKkcJbuETYVgz3TA1kmHnIoq+IGqwDP6Kgml57IM7s/wArMRikI61bm4PQE50Zn42jIVsdhn71NNciFgVBfbm0MuE2v6DibZNzpVj1Z58fWy8sEaNQ6btS+t9QXbCycSYIxUZFJAO2IWZaln952gdIWOQo9BEaRzJ0uU4vwycMUYGP3QP87JbZZt7B29aEIKaath8h8BF0a2H74o7yQIJNE5Mx/O+m+t3d35k+/Q5ImwNaFj+VEc97qHzwtXMVDDY1aez02SssmD8YoigSsNhOzUnMmQODQQhjYtA7qTI3iAAahvcG91TQaApzFVDG99v5+dQAsK0ui1pP8jmKHCzIfZ0rCMDbu55tiI7ZuYkLTopsl0oIOyL1QUPPRiAvhSKphn41UosK4DSqiQbSmezkN5HethXisGpWqLt8w/LQS/CrTT8IJDM9ji/lGF2R6l51p0zPMjfQb/cMbX0iLEs2hdKXOuHUdC3tqNWd2CstIsQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(1800799024)(36860700016)(35042699022)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gGTJeOHUi4a70fkpFIVSbN5/daPoTue6Hjs7vMmJFH0YGpLfAhpsqek2IJhm+/pJtMZLpYssfVbQF4wam6dtvpLwlyN5PpWbGjBZKCbX9xr7x2ZhcZ+cZ2TwpNQlzzUVs671evo8UTEh9pG8kDViXJ6jzMF4Kf3FgyMSAOEv0n+AWwDWHvcc4SJ9OMY7+nqKnIQYkVPqMmYm2nwOyZiqQ3GiO3TNL4xqabygH5eyRWz6Q9ujq06gKVrUcg+wSQv+O2UY+f31eClIWvBsFOwycpYWaqX5ByLNUwDLy2kFoSG5yhDMm7iCYd2uj6cr67SUXHxAKt0rvHNBheToAgwnheAxXfSxVC7xtlwh2DBa9tqrih9ko4QqVY3hnmC4VdGbet9owZLvCVLIcADOa4CZrygUNHj+CCSYOnRbwbRjP3/nWRJVwgw6l3js48pQrooA
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:21:48.6452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57362b34-6173-4fad-38bf-08def4761288
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7845

In order to properly emulate the operation of the IRS from KVM, we
require storage for the MMIO register state. This change introduces
struct vgic_v5_irs, and adds a pointer to it to the struct vgic_dist.

This new data structure contains the storage for IRS MMIO state that
is required for emulating the MMIO interface in KVM. This provides
persistent storage, and a way to track data across MMIO writes, e.g.,
selecting an SPI and updating the configuration of it is two MMIO
writes.

Note that only a pointer to the data structure is added to struct
vgic_dist as this new structure is very large, and hence it makes
sense to dynamically allocate it and just provide a pointer to
retrieve it in struct vgic_dist.

In addition to adding a structure to store the MMIO state for the IRS,
we add the base address in GPA space to struct vgic_v5_irs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/kvm/arm_vgic.h | 86 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9d509cb90ab22..9c5e789978cc1 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -398,6 +398,87 @@ struct vgic_v5_vm {
 	bool			vmte_allocated;
 };
=20
+/*** GICv5 ***/
+struct vgic_v5_irs {
+	/* base addresses in guest physical address space: */
+	gpa_t vgic_v5_irs_base;
+
+	struct vgic_io_device iodev;
+	struct kvm_device *dev;
+
+	/* IRS state - used for registers etc */
+	struct {
+		u8 domain;
+		u8 pa_range;
+		bool virt;
+		bool setlpi;
+		bool mec;
+		bool mpam;
+		bool swe;
+		u16 irs_id;
+	} idr0;
+
+	struct {
+		/* PE_CNT is populated from online_vcpus at runtime */
+		u8 priority_bits;
+	} idr1;
+
+	struct {
+		u8 id_bits;
+		u8 min_lpi_id_bits;
+		bool ist_levels;
+		u8 ist_l2sz;
+		bool istmd;
+		u8 istmd_sz;
+	} idr2;
+
+	struct {
+		u32 spi_range;
+	} idr5;
+
+	struct {
+		u32 spi_irs_range;
+	} idr6;
+
+	struct {
+		u32 spi_base;
+	} idr7;
+
+	struct {
+		u8 sh;
+		u8 oc;
+		u8 ic;
+		bool ist_ra;
+		bool ist_wa;
+		bool vmt_ra;
+		bool vpet_ra;
+		bool vmd_ra;
+		bool vmd_wa;
+		bool vped_ra;
+		bool vped_wa;
+	} cr1;
+
+	struct {
+		u32 id;
+	} spi_selr;
+
+	struct {
+		u32 iaffid;
+	} pe_selr;
+
+	struct {
+		u8 lpi_id_bits;
+		u8 l2sz;
+		u8 istsz;
+		bool structure;
+	} ist_cfgr;
+
+	struct {
+		bool valid;
+		u64 addr;
+	} ist_baser;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -475,6 +556,11 @@ struct vgic_dist {
 	 * GICv5 per-VM data.
 	 */
 	struct vgic_v5_vm	gicv5_vm;
+
+	/*
+	 * GICv5 IRS data. Dynamically allocated due to the size.
+	 */
+	struct vgic_v5_irs	*vgic_v5_irs_data;
 };
=20
 struct vgic_v2_cpu_if {
--=20
2.34.1
