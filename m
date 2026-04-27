Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013049.outbound.protection.outlook.com [52.101.72.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCC136404E
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306544; cv=fail; b=hTrC78bZeRK0mcvVN5/b/NXfXRc6trPsiGsh8CIbbYDidEhSpm3GD59ljkpf4T6FELZCUgHdqSHcJvmamFhJM8ajtPsx6V2XerJaPgPjpP153DW86LK8QOuER0gJvY9lhdfAJe3lLZJ8n7mwzmReHtWEIEJDdpQs9zdHjFjTZp8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306544; c=relaxed/simple;
	bh=+siA+kNCwLt/5uANLGVyvtjLe6XG07cddMDIV+Gk0qw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Xzkfkak6SFIfaJst4GPygpMiNkO6g46Cx6vY6HIU5PYQhiXDqPGPVUksR/0eq4JIPt+9JhpoKH+h1x42pnRLm2k77RBvUQmrBzgtRZjdQuTJ3T9Jsu9D0OuLrzg9K5ooNC6dkmRpAO+JyPlJgQLUlAS91ivbCmEgJNubMqg4yFA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=n3QdRqKx; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=n3QdRqKx; arc=fail smtp.client-ip=52.101.72.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="n3QdRqKx";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="n3QdRqKx"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Gy/YsiQ7SQeRnIRJf8JA+3gJdgAcDNKkOlecJSDYY4mAuf0C9HfxaVzqqk6lbhBNJXgv5dbinveDmV2UKegVjJo9JOJmrDrdUyxspFl/UiFXEUsrFqQ19dOi4STA0hs2t+UL1oC3zRjRE4eFO9NM3vgHrOfLl90uBDReFPW/5W2Gv2NEPDPLgKSaCykSFOA7VRyHbVdmcb5Cp7Xzl7Q5hHXg0aR9yRS3VfYvMCViqa0Jc9GK5AnzbeAARRH/ihDfk6PgbjW5GSAnJT2sGUGW29/d0pb6NDB8+4qqd1PCdIpA1qVqTX4waRTCqVw37c03w9WhfbQs1eN7/cJUmVFBrg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uA0KUv7MfJchcDtqZPV/FM6l291QLU55vs5e5wVjhgg=;
 b=krbTfO+GTohzV8lBp1QzXnVl5/H5O5Lps6NGYVXrnaW5u9PMnHOLrYSoWaQDuGWaY32MCAcdRK99aA6tQqea4/s64/7SOySTp/ZWOMkr6+l4k1ghCi4HDHStIKCbMBKMsC4hyZIvC60LEyFuLTlcvyPcUK5+DNd2NR10OTjS34hYI5UY4c3eIwU/vPzD1lQ35XcXGHQvN0RlOpM38WzH9/xNnjhk2EofLR42mSB+2HoxFD/vZly8gvS3OGS41prhKEx7Fp6XZu7SDGze4g3eQLRBOxyCHFD6QrYCN+xfVK0bRRtjYHVofX7efuT2IrLug1YzDTFgtlzHEJhMHsLIwQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uA0KUv7MfJchcDtqZPV/FM6l291QLU55vs5e5wVjhgg=;
 b=n3QdRqKxq6IrLkhZ7fe+FCN3qLy8rEhreGAOOJzoCDn4zWyXNFI+XuyxYs8DEhihGiTOaKj2B6K7Zse8As1LK6VIqGmasa34YvL1AGPhgUNOlOjCukFU1NMlNCY4/mAoO2vzaTqt64zIDKBQ4HZWc1khi9oIrTMlFEMaIHn4+qI=
Received: from AM6P191CA0079.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::20)
 by AS8PR08MB7944.eurprd08.prod.outlook.com (2603:10a6:20b:541::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:15:37 +0000
Received: from AM3PEPF0000A78F.eurprd04.prod.outlook.com
 (2603:10a6:209:8a:cafe::58) by AM6P191CA0079.outlook.office365.com
 (2603:10a6:209:8a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:15:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78F.mail.protection.outlook.com (10.167.16.118) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:15:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=flCpH4rVPzarEsxHIazgnzhSVKGap5ezeTfpSrdZxxL/MPLsuJcpFT3RFjE5kEHeFxYf1ONlDhIGSywGp/0s6m5JmMtvvEK673mVzWR0MXzj33DaCh/IJjiOoO0sqiQbrZ2ywCKsn8H2OaQgYhS3njShLtlnA1b/yRyBaFLME66HbGT5lBQKVwKPanECdLTpEXitpOMEk9fcc2o8EHOlxcqx7YEBrsnfDkAMLzx9Qjuw4ydhCfUKQX7vl794ZDOrDyIxd9n1O6hIZycEF84pLcAR7889v2UcZyAVNw/+G0woJeG0PelYYFrjWGi2P0xpYAVycMTe8puYaa85CUDQjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uA0KUv7MfJchcDtqZPV/FM6l291QLU55vs5e5wVjhgg=;
 b=HFzMvofa5qompyNQdwQW3bkDjBFZnjp7yfy7IbgdkZKpuvamKwJtWSEbyqCYKKHW4sk4SiIS39jR/zKyLBsskeJPH9R1sy9Vwy+Jd1NoLD2k8l+HwQ4rKKN5EAgtf11q2CU9b8KoW+Gc2ebshNpEq0IynDYoWDky9ZeH80RrJhA92Ag5H3CEedzSfrf2d92Li3NKrbDW+sReFRL0LSUxq6Q48Wt3yBrn2gs+AkFcGGoWTZbPXxNQwlKdjafojZm0S4CqSlqJgoz7p4tAMwOF0fE8k96RfpcUY5NQa7Nh0+NAZWevOn0K48bK53RbtsuoTg/D6aAbmGovP4g5RUDh6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uA0KUv7MfJchcDtqZPV/FM6l291QLU55vs5e5wVjhgg=;
 b=n3QdRqKxq6IrLkhZ7fe+FCN3qLy8rEhreGAOOJzoCDn4zWyXNFI+XuyxYs8DEhihGiTOaKj2B6K7Zse8As1LK6VIqGmasa34YvL1AGPhgUNOlOjCukFU1NMlNCY4/mAoO2vzaTqt64zIDKBQ4HZWc1khi9oIrTMlFEMaIHn4+qI=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:14:34 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:14:34 +0000
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
Subject: [PATCH 25/43] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Topic: [PATCH 25/43] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Index: AQHc1mDwwpvOmqdM6EekZ9hjkTAi6Q==
Date: Mon, 27 Apr 2026 16:14:34 +0000
Message-ID: <20260427160547.3129448-26-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|AM3PEPF0000A78F:EE_|AS8PR08MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 77281b31-91be-4b07-7294-08dea47837fd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 zR6ignfXvlS/PVYsumuFn48Hy9oMDnuXGiK8mdDGODSGPozXpz6Q6jWA4NCnk0Mut07KzNh7XcRjjtgeCSNKw4hd4+S0NPScsK+SIpbiX+HqdBv2g4uYc5hrrNwyO44isbLIqIMYDcjc473jMyo0bzOlJ1dT6E6GGt6SGI5X6XwRTYjOwIVFavkYZbHJieEiTteS3MsIZhgm/rusKL1LK2w+y9tZkdD58s6WTwgdwwNmzZMzTBgSwj/bpEwauu320+XxrvW01GyDHFM5Wa+eRnOdRcfpzNQGJFjiY/T7kS9Mj3QwlfVsN7Ddxgrrj5KXS0SMPRl0dyaUBwZbcglwd/zpG4Em1RrQtB7VCZHKOhKloK/n1fq09ut4fM+s/X0zKtRo/qSqxoJXBidOyWuQHSV+kR2NbeEzQyNfqcbQCBgrDhOq6zmCue14veifmRAOI/r1XDlh1f1bUO/AGxhb3/uWTetgVeXxYWn94w/NBsI4sYfQDa9KDBiSdGdesNkxgWhhYPrYp08WAlUzGz4vcvcdt+wDCINAPJcXG1yIGhQGufKSLlvjTNTBvjX//p+nSTvw6V2RZGTV6gc2ONbDURUKSKk7tMm/IHJ16OvwLZZRGjD1X3NNX2c9O5hokwV2dYVOAifUgiCqRNUP5oCBjhBMnsNwrO8ErZhyKS7AdHIQCgfD1NTLe5Nz8i7tLP+5vV6TtY4y+HyAwY72yJIEwqy1Bdh6Up6oHl5vXUlGi9pStUrnaebiHyII+u8XIjM9LXXnqWihbMhE0LNMse97NIytmIR4DMS3xq4sizZoiR8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 tMFjvxJAlY2XRxxGM+s/GV0MW3viqPb8oxlqw5bWyPCPtjUccpGqqj+9XFewqQ3ClOeU3aL+mWw39d8xVqmr5HpBWmvda5nYtBI/WMoznw/AGGTjg+jBIwE/7rpZxVrUbxx95lOImLsjAVCMaa+pRQlW1ErWcYcIO+l2Nn7cMu7BPf+vN070u8qZG+6e5CEbtRYNN708SGEcQPig1cT9lAhTQelzCtk2bRYsbLAU7RBnuVzks2lenyAliqlplqgHx3Gr48MZh6Pxggxabrhz8kVgTC+1JkEWwcxh+cd7ZKOfZ+7+H5HxKKrv3SLFhuuPwZcgysWc3gFociCnvB7Mzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	25b67c7f-8226-4918-b03a-08dea4781293
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700016|82310400026|14060799003|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7m9dniLc+SSXrKCAEZJdZY+0GykagDjAzM0oVYWbL9HEK5nF5Vr56VDYTin7Jpu9aTS6Ex+jPuu/ygKezp1GI6Wl/QyI/h4zzvkUaiMBYkFPT7mEdoW/3nZmFWW2sA6/tD8Djfltof4airn94JMVXOOuizeB2cRxgxwiuQgr/ZCmYFQWWX1J5ZIipjPLUJnUL5ACn9Pd4PWhv0kitNMECC8EjDws2ZRrPWqtij70oN0W+6YPZQlo0MPMVw9QeER8dR+BopHXv8gj6qaUgACtR5BZW3Zu2nB1UjXXZjAzs79Lr822CH0NVCJiWPe/0drm6S6RzMxkJkqPWDZgxiIPwS7BUeqjTC6LlFOlkyfnNOvVHUDoq2KF2t+mDgmlWi+/25HyBHqtNQ8iZ+2SrFnlE946vddZYxyZkysY/784Af0xi4V7KGDh0GIwuldftItj4FxVn4lCDaTvY0u/vewEn0xlOMo1FcFO2k/GluYCBoMHhBo/F/Qu1Bxu7urjoyC7x9p+R5J7kzY9ul22bgo/7vE2OdJBlz3IC4dFe5R8WiMScQ7eBC9YALRUbwv+64/piKkPa/rWOEk75FQIai3GNocSb5Jq4mZRQya+BUUSG68Cb5kFuQGBsg49y/z55dgoK3HRyZCx03zLBXWcWA6is/gwzCBrFeEWOu8NPDCKNcuu/sRPyNj71uLH8QYeTEkXoDeKh1V4l486gA7bz2Ec6jxOUklehpBvHS3DHEyPDd1AY6mR0OmYlF75L8+AIIPVoSkp4/evHVnQK0X6EBngZA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700016)(82310400026)(14060799003)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DhCBq7tAGYaXswy8gsi9/jq9lt3pGGL7hXu9bS8FzbU/HnmhquLOxidcDI4WoCk7/znKNYXf4ZP3PAzIDG0BSxnjrlyQdcR02lXHq0O7L2DylSPka1HFfWi+yRmjthkvH+pJc7PcU62tBKhJGikIGINcA7RsFJuMTkpOfUOxENTYbJ6MqOHwEIsd9hGy7pPXoYPaV9z+K9CLNEd6tdsjzhan07WHtuG+8IXSw1yy/DnWaEMsVr+D1b1UF5Sb/r3L5R2Frh7Oin72jiLps/XYdjbOGR+HJD/Nbl+1RTN88PWw4PbMJHwOtEWDUw/mmQV8vXRxKRfvtlIUG/9VZ5OE5QMbzoz2P3pLuGVHFp1hNjsRxvkncVoT7MGE3WxtRbxGm9dxUPHLhSwVMhOjHBTmDn85ZoII7zHcgLeKuT9LMl/L90K7Mh+dmmw4hn3LnJp8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:15:37.4537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77281b31-91be-4b07-7294-08dea47837fd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7944

Now that we have an emulated IRS, it needs to be registered, which
ensures that guest accesses to the MMIO regions handled by the device
are handled appropriately in KVM. Therefore, as part of
vgic_map_resources, the GICv5 IRS IODEV is registered. If the address
for the IRS is not provided, bail out reporting an error - this is not
a supported config.

As part of this change, expose setting the address of the emulated IRS
via KVM_VGIC_V5_ADDR_TYPE_IRS to userspace, as well as setting the
number of SPIs handled by the emulated GICv5 implementation.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c       | 23 ++++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 97 ++++++++++++++++++---------
 2 files changed, 87 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index cea8e963ade66..865d6b125c2b2 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -192,6 +192,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 			goto out_unlock;
 		}
=20
+		/*
+		 * Initialization happens later, for now just explicitly
+		 * disable the device and undef its base address.
+		 */
+		kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base =3D VGIC_ADDR_UNDEF;
=20
 		/*
 		 * We now know that we have a GICv5. The Arch Timer PPI
@@ -638,7 +643,6 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
-	bool needs_dist =3D true;
 	enum vgic_type type;
 	gpa_t dist_base;
 	int ret =3D 0;
@@ -663,13 +667,12 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	} else {
 		ret =3D vgic_v5_map_resources(kvm);
 		type =3D VGIC_V5;
-		needs_dist =3D false;
 	}
=20
 	if (ret)
 		goto out;
=20
-	if (needs_dist) {
+	if (type !=3D VGIC_V5) {
 		dist_base =3D dist->vgic_dist_base;
 		mutex_unlock(&kvm->arch.config_lock);
=20
@@ -680,6 +683,20 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 		}
 	} else {
 		mutex_unlock(&kvm->arch.config_lock);
+
+		if (IS_VGIC_ADDR_UNDEF(
+			    dist->vgic_v5_irs_data->vgic_v5_irs_base)) {
+			kvm_err("No IRS address provided\n");
+			ret =3D -ENXIO;
+			goto out_slots;
+		}
+
+		ret =3D vgic_v5_register_irs_iodev(
+			kvm, dist->vgic_v5_irs_data->vgic_v5_irs_base);
+		if (ret) {
+			kvm_err("Unable to register VGIC IRS MMIO regions\n");
+			goto out_slots;
+		}
 	}
=20
 	smp_store_release(&dist->ready, true);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 90be99443df3b..fd3b9cfbc2660 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -181,6 +181,14 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_d=
evice_attr *attr, bool wri
 		addr |=3D (u64)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
 		goto out;
 	}
+	case KVM_VGIC_V5_ADDR_TYPE_IRS:
+		r =3D vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V5);
+		if (r)
+			break;
+		addr_ptr =3D &vgic->vgic_v5_irs_data->vgic_v5_irs_base;
+		alignment =3D SZ_64K;
+		size =3D KVM_VGIC_V5_IRS_SIZE;
+		break;
 	default:
 		r =3D -ENODEV;
 	}
@@ -224,31 +232,39 @@ static int vgic_set_common_attr(struct kvm_device *de=
v,
 		if (get_user(val, uaddr))
 			return -EFAULT;
=20
-		/*
-		 * We require:
-		 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
-		 * - at most 1024 interrupts
-		 * - a multiple of 32 interrupts
-		 */
-		if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
-		    val > VGIC_MAX_RESERVED ||
-		    (val & 31))
-			return -EINVAL;
+		if (!vgic_is_v5(dev->kvm)) {
+			/*
+			 * We require:
+			 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
+			 * - at most 1024 interrupts
+			 * - a multiple of 32 interrupts
+			 */
+			if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
+			    val > VGIC_MAX_RESERVED || (val & 31))
+				return -EINVAL;
=20
-		mutex_lock(&dev->kvm->arch.config_lock);
+			mutex_lock(&dev->kvm->arch.config_lock);
=20
-		/*
-		 * Either userspace has already configured NR_IRQS or
-		 * the vgic has already been initialized and vgic_init()
-		 * supplied a default amount of SPIs.
-		 */
-		if (dev->kvm->arch.vgic.nr_spis)
-			ret =3D -EBUSY;
-		else
-			dev->kvm->arch.vgic.nr_spis =3D
-				val - VGIC_NR_PRIVATE_IRQS;
+			/*
+			 * Either userspace has already configured NR_IRQS or
+			 * the vgic has already been initialized and vgic_init()
+			 * supplied a default amount of SPIs.
+			 */
+			if (dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D
+					val - VGIC_NR_PRIVATE_IRQS;
=20
-		mutex_unlock(&dev->kvm->arch.config_lock);
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		} else {
+			mutex_lock(&dev->kvm->arch.config_lock);
+			if (vgic_initialized(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D val;
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		}
=20
 		return ret;
 	}
@@ -299,9 +315,14 @@ static int vgic_get_common_attr(struct kvm_device *dev=
,
 		return (r =3D=3D -ENODEV) ? -ENXIO : r;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr =3D (u32 __user *)(long)attr->addr;
-
-		r =3D put_user(dev->kvm->arch.vgic.nr_spis +
-			     VGIC_NR_PRIVATE_IRQS, uaddr);
+		/* Older GICs */
+		if (!vgic_is_v5(dev->kvm)) {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis +
+					     VGIC_NR_PRIVATE_IRQS,
+				     uaddr);
+		} else {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis, uaddr);
+		}
 		break;
 	}
 	}
@@ -748,21 +769,25 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_set_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
=20
+	return vgic_set_common_attr(dev, attr);
 }
=20
 static int vgic_v5_get_attr(struct kvm_device *dev,
@@ -770,21 +795,26 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_get_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
+
+	return vgic_get_common_attr(dev, attr);
 }
=20
 static int vgic_v5_has_attr(struct kvm_device *dev,
@@ -792,15 +822,22 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_V5_ADDR_TYPE_IRS:
+			return 0;
+		}
+		return -ENXIO;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return 0;
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 		default:
 			return -ENXIO;
 		}
--=20
2.34.1
