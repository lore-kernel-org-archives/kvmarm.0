Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013020.outbound.protection.outlook.com [52.101.72.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09F142AF81
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102149; cv=fail; b=G7saaXYsrQlGwwsz17yTmp+6SQwJ2NjCCcARCvfQib0uugOKdVrfS57OWPpyzAnyp3uQ++q4Q4e0o1ju27wTQg3Jlj+rfjUHw2NYiX3rZf2IhUI5xXBZa/QcO50Gce9yxPEwPFAClwv6R3RkMGXMf5bOkJ0ih+digFGSe9GyGlg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102149; c=relaxed/simple;
	bh=zfj+V9j6AYA9MWhLgGoC42LMA2/CLs1/KWpuJgGK07I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RviPc0/7zFej+PtwzPRijtD2ZcQsT/4xGDz4uKAXs7/ZevwqgsqSucx7x9kxboGf9aoM3/yN52q72P+A72xXfxCu2oVGgHRvani0pInGLo7OV8MUsstELAkTp1Uiay7xtI+K2yYgMbSzqtwIFJSwBO08hLtzSSIofJmmR650kiE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DKSZ/fir; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DKSZ/fir; arc=fail smtp.client-ip=52.101.72.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DKSZ/fir";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DKSZ/fir"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=s4//+110K/5oJZrMIf7vV9ov4zqhDUdYDV/75/XGNjL4Q2VvT9pVW73ULv42H+cz31uyyTmj8ghxzSy76oCRmYDQ5G9sNJ+m3g3PozHu7ZAbAki0Xs5n3XFUi2fQwEYC+SIJl2YSecet4fCVYfKeIyWNdr4VSC7uboLQjWKdpxeX47tJkQaQm/Tjbi1e+GE7r1LNFkov4f0XQ8kZRYKo4GnGI1OX6kTIJYqKhyW/hgpASyp6IvGkJuv6LcnjSaYuS1aPY0790coHROtA5wvxiKkSc7FgSDCeydkYXWveo36klxvtlXlPbckEpTdq8BgaCidXudRPjTGhmLwpyhOmPA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnnH080w2I2vBgj3IzNit1OFBDMDGm782xPGbVlxzGQ=;
 b=EmqWmxzIF79lHM9quiGAa1cFWOXoe74gDPaS5jgcJr1XlHheRlmXv2uo6/jwrZeC2GI2ahrhSsLMtAzUb71J00Yd0/s0BTSmbKxY2brVp3rtoZIzwLK+umO+MyJTLetTfuh6KRBD6RxsQP+F8Tk8AgSBLLR9Wq1zfnq0L8g9ueP+Y/w9z2XWObv42PWHwH3/k0mO1sn198vvyxHnnpbvf2RM8QctTFNDqvAeoQ7ivEbVqnCita+l6dMFRqDlCaKXI7xPO8ldcddtLpn6t6JVfgYEp+7wzdE1LY7KVL85/7oT/71IiD2iSyVNFD4U9yt2uy9BDdlUDJxb/uwJbt0rqA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnnH080w2I2vBgj3IzNit1OFBDMDGm782xPGbVlxzGQ=;
 b=DKSZ/firhl7Jd+ayeGcfoCC2TQQesriPmYgDne4MRh4KuYMRden/ZdW5g8j0vT4ZW5aaM+m39Os1o6IcBCSRSPCf4886/qq4QGYE0N1tMSxaEVX+nZtXC+2iu12q6UMdQxzfdAjBh7pU92v+Dz70vxy2W21bCq4aZSj3BIQpf9k=
Received: from AS4P190CA0035.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d1::11)
 by GVXPR08MB10476.eurprd08.prod.outlook.com (2603:10a6:150:155::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:28:57 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:20b:5d1:cafe::30) by AS4P190CA0035.outlook.office365.com
 (2603:10a6:20b:5d1::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 11:28:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6 via
 Frontend Transport; Fri, 7 Aug 2026 11:28:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w69P01zgFt6tbsvEN+/C1e23/NS9Tkuvj8yZFz8LWKy+1c6bTnLYw8fJn5SXxYV+Gee9D8m6pPg5/Ql3vWokT0sU939ixbrM+vQ6dpbEMsPLC/EX8VvtmkQqhUHifVIHb/ev6U2uALHDL389qdIePsmipT/TaJrJunYTDQFWoRMJd6P9XQh4xJipT73/1YY/HTItEB1Bia9Pfx6hnHGHPIf15n44R3RY5XxgJgjk2CLNTCUlAWMnwYFq+a/QNI50UB1bV2kay84ClMsjCKpRL7LybAkyTUyMNfI7vu505UP8t6Se8FLeof9SSTI6AjEGNTPb3Uc9hBRMgxNna9fWtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnnH080w2I2vBgj3IzNit1OFBDMDGm782xPGbVlxzGQ=;
 b=UT1WMM+CVUU2oB3XvX3NBhQB5wMjEgPepco/yWyff31usdHiTvlsB2guFUc/GRVeMwGrH7/h1VkUxTXx1oRNspqkL9qKBEGmhGU1uMhMjSmsQHTCLUMkUBX/70OrXViXQAx9+oaoi2587UXdylvk4c6zzyWeNmJgz/fp6WbBC52p0jlR+3bApIYV4jXZ3YV9Ag1nkT9+MOjyuQvQZfgxHTD31KGSWG9zfR727+uUueb2OWG5009HXFySEJDFHkk/v1wQi+JK8dRMduX9AbWHxr7A22B2FytzH7TlT6HOdqdycCVPu+CnIi1mjHifka89nDZ4j7pVe9Lh9f+vQRBGYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnnH080w2I2vBgj3IzNit1OFBDMDGm782xPGbVlxzGQ=;
 b=DKSZ/firhl7Jd+ayeGcfoCC2TQQesriPmYgDne4MRh4KuYMRden/ZdW5g8j0vT4ZW5aaM+m39Os1o6IcBCSRSPCf4886/qq4QGYE0N1tMSxaEVX+nZtXC+2iu12q6UMdQxzfdAjBh7pU92v+Dz70vxy2W21bCq4aZSj3BIQpf9k=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by AS8PR08MB7308.eurprd08.prod.outlook.com (2603:10a6:20b:443::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:28:23 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:28:23 +0000
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
Subject: [PATCH v5 31/49] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace
 accessors
Thread-Topic: [PATCH v5 31/49] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Thread-Index: AQHdJl/bwdOcLhb+eE6D0uzpcavykg==
Date: Fri, 7 Aug 2026 11:28:23 +0000
Message-ID: <20260807111159.429128-32-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|AS8PR08MB7308:EE_|DU6PEPF00009523:EE_|GVXPR08MB10476:EE_
X-MS-Office365-Filtering-Correlation-Id: 96292f99-4471-4211-008b-08def47711bb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|56012099006|5023799004|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 /m5+zUHVImzPy6g4zqav8/MMUABw0Rvch/JH993IBzxWiDChpM/vsIO0GOS6y5Cy75KjJWmm++GCmpJGrQrKLDtwhAUttGJ4CdAjhyi0qY8xn7QokJfnZ8DEKWA7Gi9bg+qscMttvwKWjVkKthdARavhmT1CdAh9Ad4MyiOowg+VwiwLPqi989xJeQ+BUDNKhy9iU9sAOQ2/Rw+QblHB0SqJeRSPeZto25QpI012JzKpLQmRpIhq9u2l7DW5vasRBX9T5n/gaQyPeB/6WA1qwEhdrojFx7ApxHNRDvz4WgS4T6KRJk14Vb0FlDXbwGDL77FjnmIjc95NkUJa67cAvJnVkyLD1LFr7QrWUjMofIlvSdONwKvJLKSwV/VApCmv4v60i51Bf6xzh/M7LU7nafDWbaPWlllgZ36v9+59dOtcHZcSaWoy/DJZcpT4nMzInjP1yJKT0rFTnDJYbEEqNYEwExHOCgitlJM72FNAgyS9q0aCxx5oHncazU7tlq28QExjhgzbIDeo8EWd51NP8+T+vgHm2POsEz++e/LqS9Q/ZDwN6umXG5sRiLCmlcewv4OSnMGTN/vqoq9TdntFJQLuuzwSYYRK8ftSW3oN4HXlTMpf7qbuKPuyaXyqRitr6dLlqYFV6rIqvaPpt4Gd70B4GEkR34jUyWna+b+8Vdd5oOJgjVuiuMkW6Bx7KylPEjlWP7MQ0xtAD2yCaNbd5tz3+25/dQYrtmVJg7o2LhQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 R5mdXD3wpI3cF5ymCf22g+QNoVZy3Yb+AhBJEfRwWDvfEKge7vMeanQG+xE+bOsVWy0Geas4W9RAvjVaJUMi1QNnVcUX+ar9HumOfd8SdR0qbCe5E3le5T+VigpyXsKyzFOElztrRHHrotbresAttJvL8JtZR1OJPFU7SPU0dqcx5mvzpdX9QmRsEDHwdD4+Q9qy+bE3KsPCN9TseDO+yQiQ6IQkCXAt/WWc9XMelSopLJNH7Jo1AwHcsnwoTiBoGIOh3+XgBlIzCbkBTAWVpwBeE0ceMDr/B8CAQn8ZoNOd/f6AqTxcGvAMgnUWl+yPxStmAsb+5mkcVsUWKYNmxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2e247544-7e4b-4ce9-cc1b-08def476fdcf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|36860700016|376014|23010399003|14060799003|82310400026|56012099006|18002099003|22082099003|3023799007|6133799003|10067099003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	vKcSGhUObcCbiik7gckVor3LjrvFqjT4l68nEf2R6Hd3ory1/LyDQBfVbybzTIilrapT/jQE4dJ20TAPTAxflqZz1dmiPrfIP5WwzK7yqWu1vHE7ovNAUWXpyRWlCZPZG6WLjHM7md2yescpObkkLEzj+BhL7FnW0Lvj66gAPSswkjR6AzevK3Vz4ICmObwIDQWypWB+9qYezwiU0N0IgQOdRFqi4XhaK28SCr9n/CP53ckyC3I1lEpVIoGB8ANBn8a27VUAppS+rl0f2AWHPr+xMVtuReGUOlcC9ht+LAq4/0wOpyMvyxNvUNzwX8Mfe7WUQPt4WGjn8unCZ8ONitZNqz/9TMStfn+u0wdlgX7fuzt94S38E+O1K6AClfiiqwv3hsxQ0y8SV59dPvwt3YYc6fKOy4G17wMLnYrHIwpWogcyid8MT6qnu7vBT/+UBl46RZNaXSd22WxXw2Mieh1DClJpUCtptZ+dC4ai9igMxVbeZ4PLlX60vOQrnoiZKl1BRlaK6rd/C5RLHGdJyjAryC3+AmX40FSVXPBf0m1ktI2B6j16fSyK9+OfLGL6EMTsjoXCFpFbDP1Hhyge0yyJhUzGTLDesM6E+L6RRPxn2O/cQXfd/eHyP1AMyUDgvf+a548KLJsUS/f4DV9an4uor/NiNGaIutz27Prq1Lujeddb5CdBNQCyF34tX+vWAx/xwWYsgt+xNOSItWvgNQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(36860700016)(376014)(23010399003)(14060799003)(82310400026)(56012099006)(18002099003)(22082099003)(3023799007)(6133799003)(10067099003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LQGezzzQfmukmqZPTYV9B1sJkZ3oiQ+3bkW5bByewcRe2alDdcxXG7vrQCS1KsrUxrrE4VwOYh97ZBexj7j8SzDLFYU+KtUfb69niJJjUAs0gs9Z37fmVBjzB4QKtPW/ywpB2QW8AuUGM8TjcP3lVOF4b1OehkyvtA0UDGhc61nU6qENB/TvaYX6R5Vvx3/QGaLc5CyzNDROOGHkM1I3eskF9nrnzEM0nr4wl/GJm/rbYi+whKtvukshuyAL5r/tmQstyOQNmYCuNqVAEzFDIry7zisDI0gi7NzfuxfEnMN/zbPHWeviQh/jnR/yIx/ucs2Auk/Hy22I+E9KhPLXhCRxm5Kr0hkxEjL0iigTupGIVrffB+pASG2i9ww83IZohUav/5ZfSbapehueiDN6R6Wm3MlaKktB8+1XcawSPx3xKRgDSgWfO8DzLTgUIMhQ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:28:56.7799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96292f99-4471-4211-008b-08def47711bb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10476

Now that KVM is able to run meaningful VMs with GICv5, it is important
to be able to save and restore the GICv5 state in order to support VM
migration.

Add functions to handle userspace reads and writes of the GICv5 EL1
system registers. Some architected register values are reconstructed
from KVM's internal representation rather than stored as raw register
state. For example, ICC_CR0_EL1.En and ICC_PCR_EL1.Priority are backed
by fields in the saved virtual VMCR, while the PPI Enable, Active, and
Pending registers are assembled from per-interrupt vgic_irq state.
Userspace writes are translated back into the corresponding internal
representation.

Wire the accessors into KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for the GICv5
device, reusing the existing GICv3 CPU sysreg UAPI encoding. Require
the VGIC to be initialised before accessing the register state.

Allow userspace to read the state after a vCPU has run, but reject
writes once any vCPU has run. This ensures that userspace restores the
GICv5 CPU interface state before KVM finalises it for guest execution.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile               |   3 +-
 arch/arm64/kvm/sys_regs.c             |   6 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c      | 519 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 124 +++++-
 arch/arm64/kvm/vgic/vgic.h            |   7 +
 5 files changed, 651 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 92dda57c08766..7aaeeb84e788e 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,8 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o \
+	 vgic-sys-reg-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5d5c579d45790..ba5918413f164 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5827,7 +5827,7 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
=20
 int __init kvm_sys_reg_table_init(void)
 {
-	const struct sys_reg_desc *gicv3_regs;
+	const struct sys_reg_desc *gicv3_regs, *gicv5_regs;
 	bool valid =3D true;
 	unsigned int i, sz;
 	int ret =3D 0;
@@ -5840,8 +5840,12 @@ int __init kvm_sys_reg_table_init(void)
 	valid &=3D check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), fal=
se);
 	valid &=3D check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs),=
 false);
=20
+	/* The GICv3 system registers... */
 	gicv3_regs =3D vgic_v3_get_sysreg_table(&sz);
 	valid &=3D check_sysreg_table(gicv3_regs, sz, false);
+	/* ...and the GICv5 system registers. */
+	gicv5_regs =3D vgic_v5_get_sysreg_table(&sz);
+	valid &=3D check_sysreg_table(gicv5_regs, sz, false);
=20
 	if (!valid)
 		return -EINVAL;
diff --git a/arch/arm64/kvm/vgic-sys-reg-v5.c b/arch/arm64/kvm/vgic-sys-reg=
-v5.c
new file mode 100644
index 0000000000000..6b255eacbf60d
--- /dev/null
+++ b/arch/arm64/kvm/vgic-sys-reg-v5.c
@@ -0,0 +1,519 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+/*
+ * VGICv5 system registers handling functions for AArch64 mode
+ */
+
+#include <linux/irqchip/arm-gic-v5.h>
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/wordpart.h>
+
+#include <asm/kvm_emulate.h>
+
+#include "vgic/vgic.h"
+#include "sys_regs.h"
+
+#define ICC_PPI_PRIORITYR_PRIORITY_MASK		REPEAT_BYTE(0x1f)
+
+static int set_gic_apr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/* The upper 32 bits are RES0 */
+	cpu_if->vgic_apr =3D val & ~ICC_APR_EL1_RES0;
+
+	return 0;
+}
+
+static int get_gic_apr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	*val =3D cpu_if->vgic_apr;
+
+	return 0;
+}
+
+static int set_gic_cr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * We only support setting the ICC_CR0_EL1.En bit, which is actually
+	 * stored in the VMCR.
+	 */
+	FIELD_MODIFY(FEAT_GCIE_ICH_VMCR_EL2_EN, &cpu_if->vgic_vmcr,
+		     FIELD_GET(ICC_CR0_EL1_EN, val));
+
+	return 0;
+}
+
+static int get_gic_cr0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * PID only applies if EL3 is present. Same applies to IPPT. Hence,
+	 * those fields are always presented as 0.
+	 *
+	 * We always present the link as connected and idle:
+	 *     (LINK =3D 1, LINK_IDLE =3D 1).
+	 */
+	*val =3D FIELD_PREP(ICC_CR0_EL1_EN,
+			  FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, cpu_if->vgic_vmcr));
+	*val |=3D ICC_CR0_EL1_LINK_MASK;
+	*val |=3D ICC_CR0_EL1_LINK_IDLE_MASK;
+
+	return 0;
+}
+
+static int set_gic_pcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/* Set the VPMR field in the VMCR */
+	FIELD_MODIFY(FEAT_GCIE_ICH_VMCR_EL2_VPMR, &cpu_if->vgic_vmcr,
+		     FIELD_GET(ICC_PCR_EL1_PRIORITY, val));
+
+	return 0;
+}
+
+static int get_gic_pcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
+		       u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	*val =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY,
+			  FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmcr));
+
+	return 0;
+}
+
+static int set_gic_icsr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
+			u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	cpu_if->vgic_icsr =3D val & ~ICC_ICSR_EL1_RES0;
+
+	return 0;
+}
+
+static int get_gic_icsr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
+			u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	*val =3D cpu_if->vgic_icsr;
+
+	return 0;
+}
+
+/*
+ * Helper macro to iterate over a range of PPIs and execute some code (to =
either
+ * extract or set the vgic_irq state). This is used when `get`-ing the PPI
+ * ENABLER, ACTIVER, PENDR and when setting the PRIORITYR state.
+ *
+ * vcpu: Pointer to struct kvm_vcpu (to which these PPIs belong)
+ * r: The register index. 0 or 1 for all except PRIORITYR (which is 0-15)
+ * nr: The number of PPIs iterated over. 64 for all but PRIORITYR (which i=
s 8)
+ * code: The code snippet to execute for each vgic_irq
+ */
+#define for_ppi_state(vcpu, r, nr, code)				\
+	do {								\
+		struct kvm_vcpu *__vcpu =3D (vcpu);			\
+		int __r =3D (r);						\
+		int __nr =3D (nr);					\
+									\
+		for (int i =3D 0; i < __nr; i++) {			\
+			u32 id =3D vgic_v5_make_ppi(__r * __nr + i);	\
+			struct vgic_irq *irq;				\
+									\
+			irq =3D vgic_get_vcpu_irq(__vcpu, id);		\
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) { \
+				code;					\
+			}						\
+			vgic_put_irq(__vcpu->kvm, irq);			\
+		}							\
+	} while (0)
+
+static int set_gic_ppi_enabler(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i, start, end, reg =3D r->Op2 % 2;
+
+	/*
+	 * If we're only handling architected PPIs and the guest writes to the
+	 * enable for the non-architected PPIs, we just return as there's
+	 * nothing to do at all. We don't even allocate the storage for them in
+	 * this case.
+	 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
+		return 0;
+
+	/*
+	 * Merge the raw guest write into our bitmap at an offset of either 0 or
+	 * 64.
+	 *
+	 * Note that there is *NO* masking applied - the enable state is written
+	 * unfiltered. The assumption is that userspace uses this interface to
+	 * set initial state before the guest runs, and then the exposed PPI
+	 * mask is applied later, when vgic_v5_finalize_ppi_state() runs on
+	 * first entry to each vCPU. If userspace chooses to set the enabler
+	 * state later, it is fully capable of breaking the illusion we provided
+	 * to the guest by exposing register state (and PPIs) to the guest that
+	 * were not initially exposed. Good luck!
+	 */
+	bitmap_write(cpu_if->vgic_ppi_enabler, val, 64 * reg, 64);
+
+	/*
+	 * Sync the change in enable states to the vgic_irqs for the written
+	 * register slice.
+	 */
+	start =3D reg * 64;
+	end =3D min(start + 64, VGIC_V5_NR_PRIVATE_IRQS);
+	for (i =3D start; i < end; i++) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
+static int get_gic_ppi_enabler(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 *val)
+{
+	unsigned long enabler =3D 0;
+	int reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/* Iterate over each struct vgic_irq to build the ENABLER value. */
+	for_ppi_state(vcpu, reg, 64, __assign_bit(i % 64, &enabler, irq->enabled)=
);
+
+	*val =3D enabler;
+
+	return 0;
+}
+
+static int set_gic_ppi_activer(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int i, start, end, reg =3D r->Op2 % 2;
+
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
+		return 0;
+
+	/*
+	 * Store the raw guest write. The exposed PPI mask is applied later,
+	 * when vgic_v5_finalize_ppi_state() runs on first entry to each
+	 * vCPU. See comment on set_gic_ppi_enabler() for details.
+	 */
+	bitmap_write(cpu_if->vgic_ppi_activer, val, 64 * reg, 64);
+
+	start =3D reg * 64;
+	end =3D min(start + 64, VGIC_V5_NR_PRIVATE_IRQS);
+	for (i =3D start; i < end; i++) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
+static int get_gic_ppi_activer(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *r, u64 *val)
+{
+	unsigned long activer =3D 0;
+	int reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/* Iterate over each struct vgic_irq to build the ACTIVER value. */
+	for_ppi_state(vcpu, reg, 64, __assign_bit(i % 64, &activer, irq->active))=
;
+
+	*val =3D activer;
+
+	return 0;
+}
+
+static int set_gic_ppi_pendr(struct kvm_vcpu *vcpu,
+			     const struct sys_reg_desc *r, u64 val)
+{
+	int i, start, end, reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1)
+		return 0;
+
+	/*
+	 * Update each struct vgic_irq with the pending state, treating Level
+	 * and Edge interrupts differently. The exposed PPI mask is applied
+	 * later, when vgic_v5_finalize_ppi_state() runs on first entry to each
+	 * vCPU. See comment on set_gic_ppi_enabler() for details.
+	 */
+	start =3D reg * 64;
+	end =3D min(start + 64, VGIC_V5_NR_PRIVATE_IRQS);
+	for (i =3D start; i < end; i++) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			bool level =3D !!(val & BIT_ULL(i - start));
+
+			if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+				irq->line_level =3D level;
+			else
+				irq->pending_latch =3D level;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	/*
+	 * The pending state is generated from the vgic_irqs on each guest
+	 * entry. Therefore, we don't store the raw value written anywhere in
+	 * the case of userspace PPI_PENDRx_EL1 writes.
+	 */
+
+	return 0;
+}
+
+static int get_gic_ppi_pendr(struct kvm_vcpu *vcpu,
+			     const struct sys_reg_desc *r, u64 *val)
+{
+	unsigned long pendr =3D 0;
+	int reg =3D r->Op2 % 2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg =3D=3D 1) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/* Iterate over each struct vgic_irq to build the PENDR value. */
+	for_ppi_state(vcpu, reg, 64, {
+		if (irq_is_pending(irq))
+			__assign_bit(i % 64, &pendr, 1);
+	});
+
+	*val =3D pendr;
+
+	return 0;
+}
+
+static int set_gic_ppi_priorityr(struct kvm_vcpu *vcpu,
+				 const struct sys_reg_desc *r, u64 val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int reg =3D ((r->CRm & 0x1) << 3) + r->Op2;
+
+	/* If we only support architected PPIs, return */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg > 7)
+		return 0;
+
+	val &=3D ICC_PPI_PRIORITYR_PRIORITY_MASK;
+
+	/*
+	 * Although priorities are not regularly synced back to the vgic_irq
+	 * state, they are explicitly synced back here. This is to ensure that
+	 * any pending PPIs are evaluated correctly when first running the guest
+	 * after setting the state.
+	 */
+	for_ppi_state(vcpu, reg, 8,
+		      irq->priority =3D (u8)(val >> (8 * i));
+		);
+
+	/*
+	 * Update the state that will be written to the ICH_PPI_PRIORITYRx_EL2
+	 * on next guest entry.
+	 */
+	cpu_if->vgic_ppi_priorityr[reg] =3D val;
+
+	return 0;
+}
+
+static int get_gic_ppi_priorityr(struct kvm_vcpu *vcpu,
+				 const struct sys_reg_desc *r, u64 *val)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	int reg =3D ((r->CRm & 0x1) << 3) + r->Op2;
+
+	/* If we only support architected PPIs, return 0 */
+	if (VGIC_V5_NR_PRIVATE_IRQS =3D=3D 64 && reg > 7) {
+		*val =3D 0;
+		return 0;
+	}
+
+	/*
+	 * The priorities are only synced back to the vgic_irq state when the
+	 * vcpu is entering WFI (KVM only needs to know the priorities when
+	 * evaluating if there are pending PPI interrupts for a vcpu). The raw
+	 * register ICH_PPI_PRIORITYRx_EL1 state is simply saved and restored
+	 * blindly. This state is just returned as it contains the most recent
+	 * priorities written by the guest.
+	 */
+	*val =3D cpu_if->vgic_ppi_priorityr[reg];
+
+	return 0;
+}
+
+/*
+ * The following registers are NOT supported:
+ *
+ * - ICC_HAPR_EL1
+ *	The value of this is directly generated by the GICv5 hardware based on
+ *	the ICC_APR_EL1 when the guest is running.
+ * - ICC_IAFFIDR_EL1
+ *	The IAFFID for a GICv5 VPE is the same as the VPE ID, which is the inde=
x
+ *	into the in-memory VPE Table. This is not configurable, and instead we
+ *	rely on userspace recreating the VPEs in the same order prior to
+ *	restoring guest state.
+ * - ICC_PPI_CACTIVER<n>_EL1
+ *	Only raw state writes are supported via the S(et) variant.
+ * - ICC_PPI_CPENDR<n>_EL1
+ *	Only raw state writes are supported via the S(et) variant.
+ */
+static const struct sys_reg_desc gic_v5_icc_reg_descs[] =3D {
+	{ SYS_DESC(SYS_ICC_ICSR_EL1),
+	  .set_user =3D set_gic_icsr, .get_user =3D get_gic_icsr, },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1),
+	  .set_user =3D set_gic_ppi_enabler, .get_user =3D get_gic_ppi_enabler, }=
,
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1),
+	  .set_user =3D set_gic_ppi_enabler, .get_user =3D get_gic_ppi_enabler, }=
,
+	/*
+	 * Only ICC_SACTIVER<n>_EL1 is exposed to the guest. This is treated as
+	 * a *RAW* write of register state for writes.
+	 */
+	{ SYS_DESC(SYS_ICC_PPI_SACTIVER0_EL1),
+	  .set_user =3D set_gic_ppi_activer, .get_user =3D get_gic_ppi_activer, }=
,
+	{ SYS_DESC(SYS_ICC_PPI_SACTIVER1_EL1),
+	  .set_user =3D set_gic_ppi_activer, .get_user =3D get_gic_ppi_activer, }=
,
+	/*
+	 * Only ICC_SPENDR<n>_EL1 is exposed to the guest. This is treated as
+	 * a *RAW* write of register state for writes.
+	 */
+	{ SYS_DESC(SYS_ICC_PPI_SPENDR0_EL1),
+	  .set_user =3D set_gic_ppi_pendr, .get_user =3D get_gic_ppi_pendr, },
+	{ SYS_DESC(SYS_ICC_PPI_SPENDR1_EL1),
+	  .set_user =3D set_gic_ppi_pendr, .get_user =3D get_gic_ppi_pendr, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR0_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR1_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR2_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR3_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR4_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR5_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR6_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR7_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR8_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR9_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR10_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR11_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR12_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR13_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR14_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR15_EL1),
+	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priority=
r, },
+	{ SYS_DESC(SYS_ICC_APR_EL1),
+	  .set_user =3D set_gic_apr, .get_user =3D get_gic_apr, },
+	{ SYS_DESC(SYS_ICC_CR0_EL1),
+	  .set_user =3D set_gic_cr0, .get_user =3D get_gic_cr0, },
+	{ SYS_DESC(SYS_ICC_PCR_EL1),
+	  .set_user =3D set_gic_pcr, .get_user =3D get_gic_pcr, },
+};
+
+const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz)
+{
+	*sz =3D ARRAY_SIZE(gic_v5_icc_reg_descs);
+	return gic_v5_icc_reg_descs;
+}
+
+static u64 attr_to_id(u64 attr)
+{
+	return ARM64_SYS_REG(FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP0_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP1_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRN_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRM_MASK, attr),
+			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP2_MASK, attr));
+}
+
+int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr)
+{
+	const struct sys_reg_desc *r;
+
+	r =3D get_reg_by_id(attr_to_id(attr->attr), gic_v5_icc_reg_descs,
+			  ARRAY_SIZE(gic_v5_icc_reg_descs));
+
+	if (r && !sysreg_hidden(vcpu, r))
+		return 0;
+
+	return -ENXIO;
+}
+
+int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr,
+				bool is_write)
+{
+	struct kvm_one_reg reg =3D {
+		.id	=3D attr_to_id(attr->attr),
+		.addr	=3D attr->addr,
+	};
+
+	if (is_write)
+		return kvm_sys_reg_set_user(vcpu, &reg, gic_v5_icc_reg_descs,
+					    ARRAY_SIZE(gic_v5_icc_reg_descs));
+	else
+		return kvm_sys_reg_get_user(vcpu, &reg, gic_v5_icc_reg_descs,
+					    ARRAY_SIZE(gic_v5_icc_reg_descs));
+}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 8c2c6886af4e3..599ab4efc1db5 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -542,7 +542,7 @@ int vgic_v3_parse_attr(struct kvm_device *dev, struct k=
vm_device_attr *attr,
  * Allow access to certain ID-like registers prior to VGIC initialization,
  * thereby allowing the VMM to provision the features / sizing of the VGIC=
.
  */
-static bool reg_allowed_pre_init(struct kvm_device_attr *attr)
+static bool v3_reg_allowed_pre_init(struct kvm_device_attr *attr)
 {
 	if (attr->group !=3D KVM_DEV_ARM_VGIC_GRP_DIST_REGS)
 		return false;
@@ -605,7 +605,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *=
dev,
=20
 	mutex_lock(&dev->kvm->arch.config_lock);
=20
-	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
+	if (!(vgic_initialized(dev->kvm) || v3_reg_allowed_pre_init(attr))) {
 		ret =3D -EBUSY;
 		goto out;
 	}
@@ -773,6 +773,110 @@ static int vgic_v5_get_userspace_ppis(struct kvm_devi=
ce *dev,
 	return ret;
 }
=20
+int vgic_v5_parse_attr(struct kvm_device *dev, struct kvm_device_attr *att=
r,
+		       struct vgic_reg_attr *reg_attr)
+{
+	unsigned long vgic_mpidr, mpidr_reg;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		vgic_mpidr =3D (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
+			KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
+
+		mpidr_reg =3D VGIC_TO_MPIDR(vgic_mpidr);
+		reg_attr->vcpu =3D kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!reg_attr->vcpu)
+		return -EINVAL;
+
+	reg_attr->addr =3D attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+
+	return 0;
+}
+
+/*
+ * Some registers can potentially be read before the core GIC & IRS has be=
en
+ * initialised. Right now, everything is required to be post-init.
+ */
+static bool v5_reg_allowed_pre_init(struct kvm_device_attr *attr)
+{
+	return false;
+}
+
+static bool vgic_v5_vm_has_run_once(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu_has_run_once(vcpu))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * vgic_v5_attr_regs_access - allows user space to access VGIC v5 state
+ *
+ * @dev:      kvm device handle
+ * @attr:     kvm device attribute
+ * @is_write: true if userspace is writing a register
+ */
+static int vgic_v5_attr_regs_access(struct kvm_device *dev,
+				    struct kvm_device_attr *attr,
+				    bool is_write)
+{
+	struct vgic_reg_attr reg_attr;
+	struct kvm_vcpu *vcpu;
+	int ret;
+
+	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu =3D reg_attr.vcpu;
+
+	mutex_lock(&dev->kvm->lock);
+
+	if (kvm_trylock_all_vcpus(dev->kvm)) {
+		mutex_unlock(&dev->kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&dev->kvm->arch.config_lock);
+
+	if (!(vgic_initialized(dev->kvm) || v5_reg_allowed_pre_init(attr))) {
+		ret =3D -EBUSY;
+		goto out;
+	}
+
+	if (is_write && vgic_v5_vm_has_run_once(dev->kvm)) {
+		ret =3D -EBUSY;
+		goto out;
+	}
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		ret =3D vgic_v5_cpu_sysregs_uaccess(vcpu, attr, is_write);
+		break;
+	default:
+		ret =3D -EINVAL;
+		break;
+	}
+
+out:
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(dev->kvm);
+	mutex_unlock(&dev->kvm->lock);
+
+	return ret;
+}
+
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -780,7 +884,7 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return -ENXIO;
+		return vgic_v5_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
@@ -806,7 +910,7 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return -ENXIO;
+		return vgic_v5_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
@@ -836,8 +940,16 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		return -ENXIO;
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
+		struct vgic_reg_attr reg_attr;
+		int ret;
+
+		ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+		if (ret)
+			return ret;
+
+		return vgic_v5_has_cpu_sysregs_attr(reg_attr.vcpu, attr);
+	}
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 107737c77e4d5..4f9ded224d613 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -252,6 +252,8 @@ struct ap_list_summary {
 #define irqs_active_outside_lrs(s)		\
 	((s)->nr_act &&	irqs_outside_lrs(s))
=20
+int vgic_v5_parse_attr(struct kvm_device *dev, struct kvm_device_attr *att=
r,
+		       struct vgic_reg_attr *reg_attr);
 int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *att=
r,
 		       struct vgic_reg_attr *reg_attr);
 int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *att=
r,
@@ -383,6 +385,11 @@ void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
 int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
=20
+int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
+				struct kvm_device_attr *attr, bool is_write);
+int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
+const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
=20
--=20
2.34.1
