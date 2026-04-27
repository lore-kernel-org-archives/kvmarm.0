Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013032.outbound.protection.outlook.com [40.107.162.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE61348883
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306845; cv=fail; b=FCgA0GAC8hfV++IMEIdufC4KE9l0x4KFY4l0Z6mhfNc9f3sJ49xT7WK0V04nAbjM/FNCz1n5CsHyNwZejFHNRza7YmyaKSKLJPVCVMvVFwHmNs0hvJlvwJQLohM7mixfU4/z3b4BG/fcBZRzU17nAAgWKXnZ+ldVDYiUs4fdXUw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306845; c=relaxed/simple;
	bh=LjQn/67OD1BFMOvDyl2AhmX5uF1LsRc0WFF6gywUK78=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SmDG1E5qru1OITxsU9Qx+tlO2tQhkdk/EUQzNcyhRK58Sz0mTQyVjKRpQC6UelwSBMkoA9XVZDxN84kSfoyKHHH41ZnPOjkH5HCVTpKh3mUF/OESz7pSFafmxxmYx0m2je/D0oaHYVJlTKLNRijGDThb358KpUP+nPAYxJbk0es=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=humeKe44; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=humeKe44; arc=fail smtp.client-ip=40.107.162.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="humeKe44";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="humeKe44"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dYGXYn/JyxNSyqdZcXqA4Z+dXXoH86TTMCwuN/VvNCOBnWjNjdoIo1n8bC8J9NWdGfEWcXASpQAPecZTQa0DF8XIIUdd8fN4+IBYgPVRl5Gr05rRennc/0cUoQVWHA3n00MdEQeQFk3tnC+DKiaplXlVW0L4ru4pTmd6bPPBQSupodvbpSRBeH84OkdA7Pe3x7Wgqp2aZW3dzjo+Ya69SpdRFTedf/60WqZHxIAOVUXSVlie3EUSWPKabuxdd/AyzrKLgaplmMmTvJmXxP6G6q5ekkZgFWu2qNA3pX/Twrfuqxcixfcpuc2NvQ4h+AgNi42e4/a2lmJyiKq2Hsmd+w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTxXm6yB0sq4ekuB24zs78U+nEV2xXjcGEybuuqOos4=;
 b=Bw88YtfwE67+EQbwX6p6eb3H/bipAHhnjXb/yqQxc0ezt9gXs1m+ESpWdM1NGeDJb94fu4JdHWkCntDSQmskQg7GwRHrafEVpgydCbSmc+40mZO/3v0PL53hGetMAefdcCrt1EP3TaaCYYN/rbOkZhq85fCL0pCxoIeuUfU7BuJDuypifbGVvX0Xsofyoel1dxIILtxzq4+FxIFcotgUT9RUwd4NJ1iYvYEACwklwih5rOqG/UNig1vE1Xrkk3MX5Xsq1vV8tciqtATChql6JPZhEIrW01zPV7CmYeZADm4zYbj43F9mE7QmDiRZ3P0IWQEnJAEMbi1YilfOx5JK6Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTxXm6yB0sq4ekuB24zs78U+nEV2xXjcGEybuuqOos4=;
 b=humeKe44ucwLeneENVG2yKXnYUaWS7p10a+6PM4Ri35rcAdngKrJnGtp1xY+COK+qIrVq8BdKmqB9AJ7nIwVFIZ3CxErKfUQB/16OkFFxPy7j11w/+aoDhFZqAVPyW8kbZnMWGOqBGnA/VvTvSedHlMSqzBwZ4ykMaobfKqWpNU=
Received: from DUZPR01CA0168.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::24) by PAXPR08MB6736.eurprd08.prod.outlook.com
 (2603:10a6:102:13e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:20:39 +0000
Received: from DB5PEPF00014B94.eurprd02.prod.outlook.com
 (2603:10a6:10:4b3:cafe::1a) by DUZPR01CA0168.outlook.office365.com
 (2603:10a6:10:4b3::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:20:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B94.mail.protection.outlook.com (10.167.8.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:20:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMR4WKhf8uBleCCJ5cjc66MKykmCVOKLo4ED63EfSQ3D+Xpig+Mkv0PXzWD1gQbnJzWw8BNj1STiQyM+T6EsXF3+GLtR07ZeqfJRYymmUL6zEusLUXunumV6qM+zExgjlide0u91CW1v8rmSP14d8LmLqkzeK0ppcPFNZ7lvGcQbDAuJUm4p1TxSg9kYlylqQD9df2Vubbrgguvh/ai9Gns4yCNzPVJdeV1jo5f9uTd7jM27m/+Icx4p9BCY9YGm6wJw2KyYosRNT/eqj60aG61I6gRzsV0IeQq+idSv8CuBHbOBU/Oty3olhDAmQwYOaWGotgvgcWwrilHeqbaWCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTxXm6yB0sq4ekuB24zs78U+nEV2xXjcGEybuuqOos4=;
 b=KTsRO3HxSiGYqjmOqzjaZpPwJIp3w4kNgrEiaKxr592eQggV9divmLfaDMmHPbD56EWE38QElE8SmvEjXSxrvHNU37ujjHRD57B80Wt0MZMLFRm+55079oheP9RHxVrPJ47X+wES9OQAs7jPAt2e7QG7PT7y2KrUxaBtriLf3bA2rMU4ho8R1znriZYV8NEA3rRKyKrmo2Wgysj0dCWLcVsSpl0yJ16cjs1ONkpabk6/FA9DpFStmLNkR1ihpom/8aqysO+fci9H066KpbGiFyyzkmyQYz2rRaBipoQ2VnnVNMppP7DYGQbMmKJzUY4kFIUW4DuvUmGXYipIRxd7QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTxXm6yB0sq4ekuB24zs78U+nEV2xXjcGEybuuqOos4=;
 b=humeKe44ucwLeneENVG2yKXnYUaWS7p10a+6PM4Ri35rcAdngKrJnGtp1xY+COK+qIrVq8BdKmqB9AJ7nIwVFIZ3CxErKfUQB/16OkFFxPy7j11w/+aoDhFZqAVPyW8kbZnMWGOqBGnA/VvTvSedHlMSqzBwZ4ykMaobfKqWpNU=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:19:36 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:19:35 +0000
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
Subject: [PATCH 39/43] KVM: arm64: gic-v5: Plumb in has/set/get_attr for
 sysregs & IRS MMIO regs
Thread-Topic: [PATCH 39/43] KVM: arm64: gic-v5: Plumb in has/set/get_attr for
 sysregs & IRS MMIO regs
Thread-Index: AQHc1mGjT8LlHi4rgECKqf6Do76E/Q==
Date: Mon, 27 Apr 2026 16:19:35 +0000
Message-ID: <20260427160547.3129448-40-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|DB5PEPF00014B94:EE_|PAXPR08MB6736:EE_
X-MS-Office365-Filtering-Correlation-Id: d02b8966-027c-49d8-68ab-08dea478ebc2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18096099003|56012099003|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 84h+0E9eZJgHuIr01nS2XwOYE6vh1eSlBXstJL8rro6NOP+gZ+OCzMQi5dr58334gwYfEHIioHUFkzwDJ3lUqSmSSbtOIld7C3iosSfy6XUjEGEO8HQInjopF7LzfAD2uSB/2YzmmCKJHrwXACjel5i6pTx6kz/THiNq4vc27e0ITU1DViI65y28kjeqC+JustBBFsB4A6uInc9DiWmxxVBUaQwZnV+kPVHnCa4p1yefMJuL3mgoQ/ijP8dRV3ol8TZrLM7P93mp0vTggHJ11ftHfgSFglQR1niSAzBiGdlnG2F1RvvkPt4e/bo0Hgvtn6uEUdEYY24Hj+5mvp6Acz4PadJshH57IIXKAwBbYWB+tqesahQMdwLjFgOH7Fv0i+aFJFiXVY3OOR+B4P3WJ+xTpV5asePFbrSBvDjcsVM1xLJyAYaPIaE6thaFt/iJ1ASc2Z70MK16aANTiMPHcQaKyjfro86/NYzVmwqsaMH0J9kcSJETzIYoQjzaKhVDezlOqZAtn67UlFZHhzoAvZWK/HyU7phJB4RWMUunDARtTYgZQPVPjML/i3PLW/9azT+qXOTAG2HhKGKonoWfu9JEbO5FHoNijjip5sxdTPdWZuVwTXeDzydBOS7dBvY4g+RdDqDrK0cAPgJyPUoU/GkT99RdLgReDVsUnmbpLt/acJ264XLHJHhwau+s05fSGfJH4ke1i877OHcSxRqjzcxJonVes0rmvbrUBMIh0gbmQshSAKXwuPLjKv59V47Cy1ubF2W6S10KiDkUF4LzDL0R5PHzJfKzx7Wk10pxtoE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18096099003)(56012099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Z5Ce81r0RZiFXwkP+vmaJ33Q2TMUs0idSXxiZC9OXRm4KUkFBwyWmbKAGnCX+Pvl1Zm2OlHSBBl/RV7uCY+Kyfu6YFKbt8GvkBNl9RfVW+WAxPVnc5SJcdP76JqwWZaVwsxUApXRwz9fcyUeagkCSmMvFKDP+ytGCvjBE2GWH2y631FfbtTJR196uknW+trSOhs2LCh2LDJ/jP50hnqqHHbLUbYadSO5Fl5WsArZChKKcBsYqYa9eMF3ndkmKNB99v57JhIJE/n2qpXvE3/jMSj0mgelkzRuW8QwZgug2R+L6kSpU50WLqEOSLtZbyfV59StCc74vHZUo2U91EhK3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e43e82a6-e9da-4c63-1f87-08dea478c613
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|14060799003|82310400026|1800799024|376014|18096099003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9BNYVmh/ijjMwqN3akGv1FtIpfus8v7v9cH2M09ES567bvIp0zEeSE9bonjvVD9JflZwwSAWOd5bMVe62ULheoOekKCktu9d7mpQMw3sT3IDvnLgE76lmatj0BOR6PO0mYGzQAb2guFDOQH/dqJKop+BhkH4CckILrbFRP7nW/uGVfY0vfKK2jLOQOcqtkBFHu8F6l9cnpqlcawExPtjthRTZgj4VG9fmt6nYeVcuxHnYlpZX7eev4PC4V1Sm95cGftpO+IgkZsVuwX21B7pT5FDTxgXkJNDghLuZxQsmdD6Y1lfSqmQ3hUthX3tcsR0cg0TaZx/jQaDRbB1mn4TQ3pCw6PlFJbaxoor/VxMKSWESxisPSvMNfQWeAirCxgOSmmEesG/e+XiuBHL6/Kg2N5tbm4P6v31Iq9egq7knPMR++1HVqfOYKpHL+f8KIz4UK1NN5FmL2jIXo6yBM8bDS5KB6XS+uiPtUFEIarwV+T+ntt32y//0LLeDyCdeWEKgduYp1yAbRfKSoQ+5emNUEfWKiEfh05v4DulrwD0gGNcg9gpPn/tWoDYXGYUI7zOeNjUnBR/f3Oc2Lxo1tIFl5864dD3oS3Mk+VVhkbni7nq4B7A/D2yqfTS9lpHE3nBHYfhxO97JmO+Bz5wm4Sq8MdKlUQq8Xbt2LbVNG9BzWlROfw/nr2NaUcq4N5HTrJI0mFaWY98pji4Xy8zOlw6b3GDMVeNDiSSgFiawg5ozeF7csoKxzOutIq+MqKwY3HnBobAvqZ85+NdWKMf7qT64w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(14060799003)(82310400026)(1800799024)(376014)(18096099003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tYtfQ7n+wQzO+y3r1DeUqUwVuWvXOC8fuYBZ121OLq6pSFPSu3bHE7vAf6R7X2XbwM11DTiOAiaVkG5psipCHZBu5l2XMVcpuDsA32u/iBhn7XJ32OJd+ThkrmxUGvO7o8grTiHFIAZ2CXig8f1dgjMIL8DrIQFuIHBoNJm745uDTmM4oohcsBOloE8QhFhO+T+HeuFCGQQ1SBrRuQDfWlQBeHruerYfwSWAIcEb4Y4tJ3kcYhadzkK0NJKnRyd111b0EvET5tOyEdZpYo0i5jo6tQH4QkPa9e1xzUl8VR9PAHL8x9QzNuCH+thQjgbsdmTAHmCwPeReP2R51pRvoXFgcavDY0swra3/OlgDfSnFSYpapyRUp+/Zkt3n/dxDr09Amu24oSigxaBFxyxT9A3jpLH3aFu4jxiBzqfgO7mFUSE/XeRdRU3SiaCgKyXe
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:20:39.0517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d02b8966-027c-49d8-68ab-08dea478ebc2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6736

The support for saving/restoring the GICv5 IRS's MMIO registers has
been added, as has the support for saving/restoring the ISTs. They are
however not yet callable from userspace. This commit changes that, and
actually plumbs these into the userspace API handlers.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 120 ++++++++++++++++++++++++--
 1 file changed, 115 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 944923121e080..2da93fb31769b 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -533,7 +533,7 @@ int vgic_v3_parse_attr(struct kvm_device *dev, struct k=
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
@@ -596,7 +596,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *=
dev,
=20
 	mutex_lock(&dev->kvm->arch.config_lock);
=20
-	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
+	if (!(vgic_initialized(dev->kvm) || v3_reg_allowed_pre_init(attr))) {
 		ret =3D -EBUSY;
 		goto out;
 	}
@@ -788,14 +788,115 @@ int vgic_v5_parse_attr(struct kvm_device *dev,
 	return 0;
 }
=20
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
+	u64 __user *uaddr =3D (u64 __user *)(unsigned long)attr->addr;
+	struct vgic_reg_attr reg_attr;
+	gpa_t addr;
+	struct kvm_vcpu *vcpu;
+	bool uaccess;
+	u64 val;
+	int ret;
+
+	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu =3D reg_attr.vcpu;
+	addr =3D reg_attr.addr;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		/* Sysregs uaccess is performed by the sysreg handling code */
+		uaccess =3D false;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	default:
+		uaccess =3D true;
+	}
+
+	if (uaccess && is_write) {
+		if (get_user(val, uaddr))
+			return -EFAULT;
+	}
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
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		ret =3D vgic_v5_cpu_sysregs_uaccess(vcpu, attr, is_write);
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		/*
+		 * The IRS registers are a mixture of 32-bit and 64-bit
+		 * registers. Internally, we always perform the correctly sized
+		 * access, but the UAPI is defined in such a way that we are
+		 * always provided a __u64 by userspace. When userspace writes,
+		 * the upper 32-bits are ignored for 32-bit accesses, and on a
+		 * read any 32-bit accesses are written back to user memory
+		 * using the full 64-bits.
+		 */
+		ret =3D vgic_v5_irs_attr_regs_access(dev, attr, &val, is_write);
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
+	if (!ret && uaccess && !is_write)
+		ret =3D put_user(val, uaddr);
+
+	return ret;
+}
+
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		return vgic_v5_irs_restore_ists(dev->kvm, attr);
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return -ENXIO;
+		return vgic_v5_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
@@ -820,8 +921,12 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		return vgic_v5_irs_save_ists(dev->kvm, attr);
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return -ENXIO;
+		return vgic_v5_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
@@ -851,8 +956,10 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-		return -ENXIO;
+		return vgic_v5_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
@@ -865,6 +972,9 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		default:
 			return -ENXIO;
 		}
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		return 0;
 	default:
 		return -ENXIO;
 	}
--=20
2.34.1
