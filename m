Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010010.outbound.protection.outlook.com [52.101.84.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C838E3BAD95
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 10:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786357740; cv=fail; b=mIKVsRQB3swsSbLU2jUczk1i+L/GokXpV/iIydpIAA/9pgI9TDd/MKl0bGMnhOGIqy2/T5XTlnb1z8iWJL2ZG+KQNsGgTwQYh/MXxFGz4QY/UbdlOc9+ZmGhNnl90JFlshOcE0qFjQGaB2l73bbrdxCLffk1JegrbWNC1T7lm/Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786357740; c=relaxed/simple;
	bh=BBwgLPZ3FOQ9VI4pdqcKjtXCpLsR2tcTRarZV61oECE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rQXX1+oY7OI15kVM1HHrxmuRfWtELA5Wq+yhXsHPbGOfxEG1hdr8xyDpSCND3GQLxGgQS+lG+POGxIDmA9FcBu2DAjT39Q8u9W1kDGSyQs3Ykt1LzmDq1DqNk2qzwpbHxZj2ZfrAuy+dw5Zz4IYm0YRWMFfmw3jkxhs3NOtK8nk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dNLE8OaS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dNLE8OaS; arc=fail smtp.client-ip=52.101.84.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dNLE8OaS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dNLE8OaS"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qqAJm7qqsnK5npOgjPYEXYqR8ejdsc2H/+dHn6UDaQ1NLMRhT9QlaGjydOG60gEgvl9eWqTUopZp+1rW5bBGZ9NYLg2jZ+el2yLxcfrf4NbGF/705MwkaC38qw3OSb7UH2nDo0C/aOPPL42u7EZm3MJLavwms1DTOkCaJP6HiZBQi+DhRZinmqZ1gSDjxnsJ20tjb3RbxpQ7vhWzWFCtyHqeiMeEv2ITJs7EHTEjU7oz+3VvwaEN81f1q0Iuvjy6JgMDUYIp03KXwlUrCySRZjfIzcChKKejikLNgeHP7mrT3Lu1bNAiUUg1aZO2b1s5U3om01BkF2PA8wksP9Pt5Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zuJ5ahJlzzJWAbPg9psyDjYY9GJXVS4GCLL+eaEID2Q=;
 b=n3/iVB2lZP353tFodMoEPI2QzdQ2qborISBzR+NwExu7H4IEspmPq/j0W40FJZUwJB9G5PycMgKcb4ogEIGXBzu+4niIDzIl2bBr2FbE8Kd7qh+p0Sp6jlN6sJc1EMcV1iAZDkX77/SwVzrwLHf1JrVuoQI/kdfYC2OdZpS3Y0XYFycUEcuMjCK5Ae88C1tGbIXijlzTr71kap8OY+sVcPeUOXGzyWOtQCcC4DjXIMfkBdar67qDQiwLmMQ/IG97MY8YhMtQQvWTbf09YB2x8/e63IVxPbC8EDO+Fpr9Mo6lOP/7fOi8tjdtkmE9gKISBGuS9nYWiuBrYue85Ow6JQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuJ5ahJlzzJWAbPg9psyDjYY9GJXVS4GCLL+eaEID2Q=;
 b=dNLE8OaSbgEpMTi5jeQ6dSFsVrETTn/PAnGig6bsUgPVioh8oF6uEwh6j6B2KMnJf2zA/as63NtTfw+/QsE6F/KFS58PDXVIuJxz/w2tFQYsB1sfcjg4qAMcaQx2lo/KWskeaOX8TgmhptFUCJ37yTb/Y7JvrXog8Ml+p4URj3s=
Received: from PAYP264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11e::13)
 by GV1PR08MB8258.eurprd08.prod.outlook.com (2603:10a6:150:89::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:28:41 +0000
Received: from AM4PEPF00025F97.EURPRD83.prod.outlook.com
 (2603:10a6:102:11e:cafe::a) by PAYP264CA0008.outlook.office365.com
 (2603:10a6:102:11e::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 10:28:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F97.mail.protection.outlook.com (10.167.16.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.1 via
 Frontend Transport; Mon, 10 Aug 2026 10:28:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9XWwDbLpdtC7ZLnrU1CkMqFqF8/NfRpiW+oGwps2D7s1MOG2zV9wChiVdVeCERUCmRZrmGgPbZn01jOqshvvkouZiWyi/jeM4nR5ZB7OzHCef/1SvVU4jM1rzf95FDJsYgMfEmOKe9uCS6XZXWpIQUMhRYDsoX3qG8QPcJ41ws3YNe0IHEIgo2N8OHKFZmHeA0YcTL3CGNBh+9HiL3/anHBNcz16r2ZzdgcNP6m0U802upio8DfpeUvMiNQV9mMz13U/qNDYqclOenkx/tH0Cq6kNZlh2WoQVGOZhaJZY3Mpqk6DXJy8vZByK3biyDToMv/OcjGgkRtu4NMghBmyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zuJ5ahJlzzJWAbPg9psyDjYY9GJXVS4GCLL+eaEID2Q=;
 b=aqAunjsTGcvx0WQiFxZQc7KuVeQLMZHeZlE/1IiksKmrvqXFUqbWbudfOShWoXBqV2NlUvRBhpMRLJI1lst7qCJ0oWCuqFcg1BHwYshNCaavjLTydiwk8qa7OxDXAziy0nc0bfHU+N1t9HDk3/EHpUHk1/r4oGdTW5pqShLb3AWN1XD9ORgB2TFi8B94h1F4Q3PF6ORKkU4wRDm414yBQot4bxa0z5G+HYpOgEnTS43EJWXdXarWN5p73q4h1oSMfN94HGU0EzkZRx8s4IgMw1Q8alE/R5QH9jEaIyzvDGDhlQ6rVuXRQk4zTHXBs/MSKoN/plxrr652I2N8wyj2KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuJ5ahJlzzJWAbPg9psyDjYY9GJXVS4GCLL+eaEID2Q=;
 b=dNLE8OaSbgEpMTi5jeQ6dSFsVrETTn/PAnGig6bsUgPVioh8oF6uEwh6j6B2KMnJf2zA/as63NtTfw+/QsE6F/KFS58PDXVIuJxz/w2tFQYsB1sfcjg4qAMcaQx2lo/KWskeaOX8TgmhptFUCJ37yTb/Y7JvrXog8Ml+p4URj3s=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM9PR08MB6179.eurprd08.prod.outlook.com (2603:10a6:20b:2da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:28:07 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 10:28:07 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: [PATCH 2/5] irqchip/gic-v5: Clear per-CPU IRS data on teardown
Thread-Topic: [PATCH 2/5] irqchip/gic-v5: Clear per-CPU IRS data on teardown
Thread-Index: AQHdKLLvPsM/2AW83keL+Q+aPyfjVg==
Date: Mon, 10 Aug 2026 10:28:07 +0000
Message-ID: <20260810102652.758719-3-sascha.bischoff@arm.com>
References: <20260810102652.758719-1-sascha.bischoff@arm.com>
In-Reply-To: <20260810102652.758719-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM9PR08MB6179:EE_|AM4PEPF00025F97:EE_|GV1PR08MB8258:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c37dde-1235-4645-783f-08def6ca25f8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|22082099003|18002099003|10067099003|56012099006|11063799006|6133799003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 QZhpwkR6uNyYvJnyQoA5D3j7WtzgHHxQOb1NitbRu7vuZVLJZJUaac2PL/+FA6MN8idB5c5rvlz5aPHDdeXk6Z/AsVuiWX1Ryh3Dn5YozNK1RAmRTMGCLh3KAsY8ArFWTayzNmjeNlwHKgTYcg967aoHUAyHKYKFrwK1BXC3vtf9WbqfkJeaAghto4bwSMJX509qnz8ru6tGRcyHrIg8+Wz3i8J379Jb5V9YcuskURa0qfUeoYJvRJgbMVrWzNJzDN4DRoXMCTMlhGq6AuAWMRObbr5CNrhHyYAQlhztYAEA2dMOEcwc8Ie6K6PbYvz+2mj13vDdqvdDxTea1qcqYJAKVOk3MjBBPdUwWXENYSyEeMWhMfRlORCUKmjL/DbiOihh7bXjGSQBfU3/VosrrOcHY7psscPM6zU9pS8qYWwwbdD7ue1zX4XJIpBBkLtSugZYli9pFf75AFoa18ijKpW8ux98zdTuuQ4DKwJM54SYxO7BiVyXKPvH/9ss6ghLbFQ3aTrrTs6ISBdCtzFrRkraHPx3bexvQGadVO34YreKp+zKInPPlZkNT29VRCA4ojr5z79JZI9aHrQdmhDV/pWWMl8soSS+Zihwuwah9hU/+SwUGC/rgB8EO+yz/LhbQziL/HnpwV5nTa09u4zr7V3oMfsCQIweN2dHWUOs5f0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(6133799003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 b/GiRTVYzS2VX+Gzi+ZSNHFfaQkoJ4pkkK4Vg1zRT5QuRo0ZKOBselRquWWf36y/bhu2yXcYw3DlllPrBCt4YhAyVaTDBG2TOHdzY7rwuNdx9O9lJn484b4Y61dfRG33zlDKCPDUNjEkodWvyh7F33GLukWF2IZi/vThZzMp7l1SoenDdCxKpH5FYaStbCNxzxs0EKc0abtg88tCet54LM/O5v4PL5KjuN7NUETY7oCp4hgM1+q+yoAbGJJNhUBI/OLXl34pM+8ecQbOmi+vyXpTQuZKjyIQfItmuJ/t2yecciIccWvwjVvgedqUkoqwHy98HWiYzzWIo8dKj4LisQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6179
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d859081f-5f7f-42c7-1b1b-08def6ca11cf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|14060799003|36860700016|35042699022|13003099007|22082099003|18002099003|56012099006|10067099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	VbmFWiOqqPGlNDb6sV7+fYL+gZNcRLUAVoztePDXdW91cf78PbdEZq6PoqFcRGyDEzp1VlBaWxYv7HvEW+qMAWHEdEvEmV0IqmEfyMU3GhPIPv9paFZbUBQKKFqIOvnO6zDgpBHIZokvhx4OcqcuXztb9oBw7P0MsyP2iaFrnPd5CWDXh6QlAaNL/W6fd7gMD8cyz5jOado8BdwWdNVwB1UlVkifYvP/KUloICWZvb58lhMBe0nIwTmvEn7h9EIVpZz+Hkes2DPbX2eI7jSoALupM0BCernMqqS+P6jdWo/MdOmg4HI6ahNOOCzngIkOJjBTCWFlfRMxHfUy37OV7HgQIB0fFLTQ9bLwzMj/EEVZN1sMtSZPl4pFk8syX44aX5o24wLGztczT+yb5ouOpZDGMNN7igogHQS8HBoOHxMvRhCFSNDa9iZblhlwlY4Mlcd/GCWvddAQxSP30x7pvmmxSsCGJeqeZwqa21y66EEpUx/OMEVeZgestulebYHN5+2F85MiINXo+3ADdgAXRIktzr6Hyw+C6pn8iLMOzTvEBj7X3mjYJJ7lnDx5inHrJhGtfm90RuTSxc0EJqucr4KtS3+emzmq0IaTJ7XduEOSR7Q8P+KVctx5ydv7R94Gpum4AUh0c6n+LPYgrRTh6Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(14060799003)(36860700016)(35042699022)(13003099007)(22082099003)(18002099003)(56012099006)(10067099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yMXbJQ09VrG55lKEREgnH8PYNT5NIPD5pmWG+a+xFE8djAqeJq6wy35/Xrp0MbO4nmZQ21y/APiHsL7scCBUoZA48ZgkGJfNIpLdXHrw3mJwMmYRWD/oCo1iqHbc55pvwnzXrGa30dVSl8npVG6NHpg4P3ygI5Zg/O1whOdzcaU9HAx3OGdggHKdiacmWU+JcVB0MoWnoZdad++TonmgL2TJVhwxvicanOeNH0n0oWyFr+reBESdUhhFlN7/QFX3W5SS8+qO4HfpHxovzMWxNyE891llpurg9sXJfrrbEtDHIML97sFs1c8Mmzr+09BE/TfaVWhVf4T6gbV9gw3iUIx0tSDRYOvtdKofLzz2xDB3mZBlvKNO+hOexnkPqz9pgMsAcNYMconYF3K/Rl9LxRt4Wi5bkUxH0yJ7NFnoY5bFrbTS1yN4wfyj0c8PEEcC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 10:28:41.3167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c37dde-1235-4645-783f-08def6ca25f8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8258

IRS affinity setup publishes an IRS pointer and IAFFID state in the
per-CPU data before the remaining IRS initialization can fail. The
error path then frees the IRS data without clearing that published
state, leaving CPUs associated with freed memory.

On initialization failure and normal IRS teardown, clear the per-CPU
IRS association by removing the stale pointer to irs_data. Also clear
the per-CPU IAFFID state for any CPUs that were tied to the IRS before
it was freed.

Fixes: 5cb1b6dab2de ("irqchip/gic-v5: Add GICv5 IRS/SPI support")
Fixes: 35866efa52fe ("irqchip/gic-v5: Add ACPI IRS probing")
Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischo=
ff@arm.com?part=3D2
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5-irs.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index f3fce0b1e25d9..67940ea9e39b7 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -651,6 +651,19 @@ static int __init gicv5_irs_of_init_affinity(struct de=
vice_node *node,
 	return ret;
 }
=20
+static void __init gicv5_irs_clear_affinity(struct gicv5_irs_chip_data *ir=
s_data)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(per_cpu_irs_data, cpu) =3D=3D irs_data) {
+			per_cpu(cpu_iaffid, cpu).iaffid =3D 0;
+			per_cpu(cpu_iaffid, cpu).valid =3D false;
+			per_cpu(per_cpu_irs_data, cpu) =3D NULL;
+		}
+	}
+}
+
 static void irs_setup_pri_bits(u32 idr1)
 {
 	switch (FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, idr1)) {
@@ -773,6 +786,7 @@ static int __init gicv5_irs_of_init(struct device_node =
*node)
 	return ret;
=20
 out_iomem:
+	gicv5_irs_clear_affinity(irs_data);
 	iounmap(irs_base);
 out_err:
 	kfree(irs_data);
@@ -787,6 +801,7 @@ void __init gicv5_irs_remove(void)
 	gicv5_deinit_lpis();
=20
 	list_for_each_entry_safe(irs_data, tmp_data, &irs_nodes, entry) {
+		gicv5_irs_clear_affinity(irs_data);
 		iounmap(irs_data->irs_base);
 		list_del(&irs_data->entry);
 		kfree(irs_data);
@@ -951,6 +966,7 @@ static int __init gic_acpi_parse_madt_irs(union acpi_su=
btable_headers *header,
 	return 0;
=20
 out_map:
+	gicv5_irs_clear_affinity(irs_data);
 	iounmap(irs_base);
 out_release:
 	release_mem_region(r->start, resource_size(r));
--=20
2.34.1
