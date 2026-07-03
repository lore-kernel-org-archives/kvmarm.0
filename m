Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010024.outbound.protection.outlook.com [52.101.84.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA7C2E03F1
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095094; cv=fail; b=nVM/z49WvqFl8bFlwCQsKm3HqBlmqA7/CxriNP8HVLBZHC2Zx7lnD0tDzC7sOruOi7WYKO3XqhVYWAds8tXkF4eE2jfPpgK0IypyACqBM18wduHVMRM+3Sz5DT9vs0S3izm1hU6RNw5AX4k9hkOhySB84/3azlkfy3xkl088Fp4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095094; c=relaxed/simple;
	bh=VkhdOipL2FxH6MFlsVB3UR6E3dnGs7GFLrbJIBk1OW4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mgNkadnGxXYM9WJY87ar/m1YmWKqyB7lSYjV5EgfWf7ty4NhHyth0Vg+uOLcggQQVO0OaH/a7r/DmM0u+0GPKMrVOgjbjhnzOThRiw04V5vvJO8j2Qy2YjWoBXNNgkFgfhG1mnc0Wa3Hi0hZDOVqJJAuIfPJ+hNkkX/PV0SGAvs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UaH1xOBY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UaH1xOBY; arc=fail smtp.client-ip=52.101.84.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UaH1xOBY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UaH1xOBY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=EmD106qCBV6BdB+9ErBWjkRVe0zvFC3cOhBI6y+DjzAN1C4UUuMcp7GbX6H/amSzel6/S1oOrvv6//lrmPnpY4W5SwV8f2EG98v5LksBoRlEqndjvAq3KaV3uLCr03fk/b45LyMud0b2tfDG6KhcS9LmC+fGSy8Bs+ScuzmmnKosMzRAdJd8XmpelOIomEwGdaJiuWLiFOsOFQt3cpGTuy3yD3dG4aa0dm2NF6wp4LDeEUofvIJ54mzDhzt4LHraAxYLOLd16tCjpcBdd3EKt5bhJ7CZ9bwPn813c14ZMMn7Gnnh4NlW3NybH6kWpZ4NpL82JuYOIEfIFS4Vz4j0Og==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg9lVVIQlEMZC+NQSG8JRN9X37yvzMHEdNr6VRsONpk=;
 b=rtDmvszOvFKs1iCq+3w35KPE+qYCna21PDlnl51dW/o4z0szeS9HFSP0FKy7AVPVfL22G2niVcwTlZ2AhUvFx5gjwUzMaOTMYEwzB7Z2BmAEwRu9g1kTj0sTlxE/aVHn2Ob7146qRP6HzLzqV2fBDRDeKeUZ3vghMe1n5lNJpFOKZcacXyJ6UU+YR8djRX8ESoP84R8mq1e26C/CylPl2eZvH1fdlFQwvwZXSviaRRf8ed2hMRiH61L3xv16EsrmlXHU7tNqi04REFK8tkbjPrmSB0jjBbwNUP0SdEcABOrP1iuVtEv89miSA91FIbvnbMVNCyBn+8QnMnjLGVcXUA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mg9lVVIQlEMZC+NQSG8JRN9X37yvzMHEdNr6VRsONpk=;
 b=UaH1xOBYCCZNpglU5QYF3lziJ8VV8P3FiQHYXrK6Umf4t7wv1UeS+t+sz2dqcmAfMaayr3rBlJlvRV7sdct58qdtvZ1m4bYzQBxSMLZwpGrZSGkyrlxmyl81sqbAPK8IBQQ2rUKnMYUiC5vyppnFPMR50CQYtDg8FNi6ZVqhKcE=
Received: from DB9PR06CA0026.eurprd06.prod.outlook.com (2603:10a6:10:1db::31)
 by AS2PR08MB8504.eurprd08.prod.outlook.com (2603:10a6:20b:55f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 16:11:27 +0000
Received: from DB1PEPF000509FB.eurprd03.prod.outlook.com
 (2603:10a6:10:1db:cafe::17) by DB9PR06CA0026.outlook.office365.com
 (2603:10a6:10:1db::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:11:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FB.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:11:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EHj6RTlpuafgmEgZys1RoGp6/WjqKEtbn92AcavIcLZiPz7p8xAvEGk2wZS7yMf7deLfeFGtal6pEJQClnuDtICw1q2yslvIBlsqMgIdlBoyqJBMJdXREoeInO7O2Ce/cnDf10G4QbGA3boFH0/U1D2YP/Wxp9m/t5/kMySOrErNbf8S5p/0aayx249qcjLWrDLVzNWWMUf5DQ9WeSSHnDHjZaqwIN1rHIFoH3SKFtMBBL5x5/hKw+DtnfvDiDSwYQ5btnv7XhOrgjKn8stUjhJdiH7WzfypiIQhuMHGTn3yQCPY9GPZPNr/Z8f7Oegt6pVmsz+65JA9Kd46qNmEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg9lVVIQlEMZC+NQSG8JRN9X37yvzMHEdNr6VRsONpk=;
 b=TqttPS4PPYjX3oKDfMKdrk3eQNDw9mKHLT3PgDIfSjwqe3apFOtoC/eUhbjNXhFSgFRwaWy5TEm01I/r7sYtPPixz6Cmf0LbA+66xfp4hXetDXrCw2jh2t7IW9KsJi8wZk1uNewyOQ2FgTNh22qTpzdg0Fuj0f9E/Grp6FGeBuRGbT7w7JB3V9xKISjuXztO8MQe7iLqP6OHxOQasBfNcsl90RTmEGh4CEsqk6LgHD8Ui/RFyxxG+/XZdiEq6sy+gpAMGszyUMBPrIQRBWz8AyyhSXDo85AUCBf+WMuOJB6imTY2cuTnzms1E6n8Z5+iM08KbCUj6UYAB/NP9A+/TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mg9lVVIQlEMZC+NQSG8JRN9X37yvzMHEdNr6VRsONpk=;
 b=UaH1xOBYCCZNpglU5QYF3lziJ8VV8P3FiQHYXrK6Umf4t7wv1UeS+t+sz2dqcmAfMaayr3rBlJlvRV7sdct58qdtvZ1m4bYzQBxSMLZwpGrZSGkyrlxmyl81sqbAPK8IBQQ2rUKnMYUiC5vyppnFPMR50CQYtDg8FNi6ZVqhKcE=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB8840.eurprd08.prod.outlook.com (2603:10a6:102:339::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 16:10:24 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:10:24 +0000
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
Subject: [PATCH v3 39/40] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Topic: [PATCH v3 39/40] Documentation: KVM: Add docs for
 KVM_DEV_ARM_VGIC_GRP_IST
Thread-Index: AQHdCwZ0H0cuDsc9Vkm37DH8s88BVw==
Date: Fri, 3 Jul 2026 16:10:23 +0000
Message-ID: <20260703154811.3355680-40-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|PAWPR08MB8840:EE_|DB1PEPF000509FB:EE_|AS2PR08MB8504:EE_
X-MS-Office365-Filtering-Correlation-Id: 1835e48c-c058-4d4c-4620-08ded91dbc53
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|18002099003|22082099003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 nsyynEdfUJRYmE5yp9fV8y0sWtDaiK+Alp+vmSg2CLLY7udXIx039UUsDtb7qCiWoHVqIUq4UG/qg9kHDXGQ0doCdMuUg+LCJM0HKplTKxyBD9QFNBeTUQcEJGuKBpiaQ6BrbvN89BFffYYqTXk8eKrp/+xqwsvPrp2eUFVznxyH1li/LzYYASmgEdyl6ccw+giY8UhMWHmiNHs90RSGyKJQ+l4aLjAg0fffZbwamzVgQzGYwJTrvvVNkADRzhDxXMY6RGrazKwOtCRP6fYqZX2P8SpcwU3lIjURmeyH1A86BLuFnM1vGQ4U9ARIhTNymE/FvoQpaT+AE4jX4jXLOATE6nDRlqwneIYfJMmXS2VCCXlsUm+5eJ4pxvW3qP3taRSUxdklfnNUBKgmGf6i6zgue6v4Q093yyfFuVS/tGLZVk5l8CH/92g3Ceu/V4e2bzIBc9bAI4eNva6zpAQJTZA9d2aR2mbluPdrJEZk7hF4BnNQX+CaZddMvOOxSMOjM6Aa3/MrYla3y3FG/YWMO/HP+fBe6UYh+TAOnxYEP8GpjdJXM9UiM4w/PKOJOCPh7wKkqp1sh28xAAJkXX6MBTH9lczIQ0or+OmwR70HHxhLGcWVjSLh7S8elQDq2Ikp39AytIuuQ9V0Od12rNNWUW2Z1sLmTfiNKmvri5zcIT09yiyn6NexnyvlrPzfLGRlQqwwgUo/XyFQ/eUc+Nsc0CGKhA7Gzjq05icCMHhXI6Q=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(18002099003)(22082099003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 hpeeLtvlOwnfWsoEBbm1oA33JsrG1njqButO2y6FxAvKFIt9IztHywfD4DclNBd//S5ZQV9KIDLqypyxMAYyJXVvHGHcUC2vxqqQvTKrxyt2C8zlhX1yRPgYlGFuWiu4u1s136MZcqXZqwsXAYHCDnZQJwOe+4kA2AFeVLnCATAL3CMZPeZHK/wgg7pi74kOZ+skxBk8mEcaFiUPsnepn+aVx2nMV9wKbF2/9snp5dHBci7Xc/gZ5SXooffzUHQWaR1RoWF7OdbkGSVvD4LUt90AmN6NOt/F8lrTFMRC947W8Lq7uabaVdtAlwqgUsrvBfIW/c5JYQaLHIzF7Hz7lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8840
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	81acc905-c315-4fd8-6dc3-08ded91d96ce
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|376014|14060799003|82310400026|1800799024|23010399003|22082099003|18002099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	mGV6giqPEw3AAGBIgS1wNWYmmwZMDQk8oFmtJrHsxSJ2+sss8EfUypdmYBYfb1041QDdA3DtvllqwmrCiSAnphTD5fffKJMFrKhYHlZmgCtfIfy14ngFyEdn1WlxEVF0nI1z5MR2kQtzFfsreHd5b59A+efbvMM3HhlBHHRicu01zt5JtnUngF9pSsFSAF1yPTKyLHTG2AtF61z3PR4ocvrVnJX8tWBWcJjdupt2iIjWx/cAsKu6VVt18ihnQB9SBZ/raYdeHwp5fmQCyzH8FRPvfGLxd0gM94wUBG+EK2KX0avi19zvAjIk26PX7msTqe8IzKpgh7PD/+9/BzGIQx4LZJ7u/QI2MIEQqBSa7uEDC6OsP49Al6nyGTEwvRs848Ln/PD4rur1RO4qi3VKkmIzi2tv3Kv9+HKSCYzUwbJO2KAG8mgrdtZLsMWrzT20puRUadwPg1YyovoAUCD6gg0jgwDO1rqzFySG1NNVBJD7KqnnpIF5+3ivlk+eB6ua/7YRavMS5V7Pw0yqy95F+BFP/L/DKLq44yRe/atW1MTd2oX5xYW73B01qm2UFA4zsrn9MBC2qNZmVXWWgrjmNIKv0BE4s5cTc3T+1p5ahHmOuwZaifBantXG2oAcBZptfNpci/rtBu+D0MUf3loLkZqr8U07wxagC6nNT+xLFbKvwfNSOUCpRpi7aW1rjWQFjZAsBMHG5Yc0YtEftBXxNQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(376014)(14060799003)(82310400026)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xN0Jnuc4AKRaQ+jI0DFgtraLDUdhMLXchpBpCKJP1Vlhu4/F3Y7qYw5H08H43YRhML7ech6h6hBi/SkrTvIKr6JsMZaSQ1vkFkFE/udNBRgadQedRdcmOFPrFhEsG2yUm03wVC5kMwmxcasjsB6RXjGsMgnWqoWh5lDgWQfJ3EJHGscKGcDI1sBkjpwnRF9xkLB9c0SM6DvfcUBvc/NBTV53duA4HQHPO/L1IXE7J+tFZCEspRZwKEQLfM/snrB7BC14nz0zzonmdz+GU4x7NIM9XGMs3/cwOaLKiK3DRwktIJ37fmSbG1UkqLTbD7KrnXX2XEhM1fowF7L0GSc/+kVuDOCUKODpo0cDThURunyqj4zEVsJFI5dLLgewUmR3khFETC6YaJRne+SPpVKyKQIBtgZB+tQp8JnMh8FAHCJ8AroY+w/fBJPkSNxsZJi8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:11:26.9061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1835e48c-c058-4d4c-4620-08ded91dbc53
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8504

Document the IST save/restore userspace interface for the VGICv5
device, KVM_DEV_ARM_VGIC_GRP_IST.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 217a1ecfbdc5f..0ee0fe9308fc9 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -177,3 +177,58 @@ Groups:
              64-bit aligned for 64-bit registers
     -EBUSY   VGIC is not initialized, or one or more VCPUs are running
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_IST
+    Attributes:
+      This interface is used to either save the state of the IRS's Interru=
pt
+      State Tables (ISTs), or to restore them. A get operation saves IST s=
tate,
+      and a set operation restores IST state. kvm_device_attr.attr is rese=
rved
+      and must be zero.
+
+      The VGIC must be initialized before using this interface. Restore mu=
st be
+      performed before the VM has run. For restore, userspace must have al=
ready
+      restored the IRS state and guest memory needed to describe and back =
any
+      guest LPI IST.
+
+      Saving first asks the IRS to save and quiesce the VM so that interru=
pt
+      state has been written back to the ISTs. KVM checks that the VM rema=
ins
+      quiesced while copying out the SPI and LPI IST state.
+
+      The LPI IST is written to or read from guest-allocated memory. KVM a=
ssumes
+      that the guest has provisioned a linear virtual IST through IRS_IST_=
CFGR
+      and IRS_IST_BASER, and uses that guest memory as the LPI IST migrati=
on
+      storage. If the guest has not enabled an LPI IST, there is no LPI IS=
T
+      state to save or restore.
+
+      The SPI IST has no guest-owned backing memory, so userspace must pro=
vide a
+      buffer through kvm_device_attr.addr for both get and set operations.=
 The
+      buffer contains one little-endian 32-bit IST entry per exposed SPI, =
in SPI
+      number order. Its size is:
+
+        nr_spis * sizeof(__u32)
+
+      where nr_spis is the value returned by KVM_DEV_ARM_VGIC_GRP_NR_IRQS =
for
+      the VGICv5 device. For VGICv5 this value is the number of SPIs, not =
the
+      total number of interrupts. Since VGICv5 currently exposes at least =
32
+      SPIs, kvm_device_attr.addr must be non-zero.
+
+    Errors:
+
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+      -EBUSY       One or more VCPUs are running, the VGIC is not initiali=
zed,
+                   restore was requested after the VM has run, an LPI IST
+                   already exists, or the save operation completed but the=
 VM
+                   did not remain quiesced
+      -EINVAL      A userspace SPI IST buffer was not supplied when one is
+                   required, or an internal VM table operation rejected th=
e VM
+                   state
+      -ENOENT      A userspace SPI IST buffer was supplied, but there is n=
o SPI
+                   IST to serialise/unserialise
+      -EFAULT      Invalid user pointer for attr->addr, or the guest memor=
y
+                   backing the LPI IST could not be accessed
+      -ENXIO       Required per-VM VGICv5/IST backing state is missing or
+                   inconsistent
+      -ENOMEM      Restoring IST state failed while allocating the host LP=
I IST
+                   or tracking pending interrupts
+      -ETIMEDOUT   An IRS save/VM operation timed out
+      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
