Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011029.outbound.protection.outlook.com [52.101.65.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB87B366050
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.29
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748089; cv=fail; b=bTY58jnvngZTdGltIOvBQWIYmwAH97sGTMefg5/9t8yroofieVgmgvXfQuocLCgC38QyJqLTpyEPENvONRDA9+Aa+IWLt/YT9g6grE5qoesQeIXZWq2LOhu39A0RSaFXRuRt6a/JtnOlco2DCmMkibL6psT/K1EmtPUtfQ+uG6w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748089; c=relaxed/simple;
	bh=gVWN0P5olmzZ8WHSdomc4AGl4EGvjxUqWK8Y7jQ+qBY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hgeparemkfv+O8/XIS7ILUqqZbiOaVKQikiuoEejQDQhue6Hj9YJ3mvBvQqQ4JnfDUp/BhlM9ntDa2awxDhMNkvtFZwN5Xki/4aGuSkGOUduc4I3yROAkRmkzbWiefLOr9tWI5qwD5Zm/mrVcFIYlCB5jUyrfnWuhlDEu6moBe0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IAWNt3Ct; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IAWNt3Ct; arc=fail smtp.client-ip=52.101.65.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IAWNt3Ct";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IAWNt3Ct"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jTqiFFUNxBPTes/KwgqnbA3n2llc3OFFcOY8EkvaVxNKrXBxPVTfPyQr8rROZis7SYQjdoWvtCKFlb1IJHYrSs7aH8LSo8eKAXaJ+QBim8J2GtdPTQZWHbps641g9vmqzItQnKUpVMVcFnKyeGbaCcWyZcG0TmP5oAGF+LbgCrhj6vVmPBpAAmIo3m8IayZhWx0p4NSsaD0g2+4B4S2Q16tWRsNpS2WZDFZaB6pQs1y8k8508j5Ed+eWx8y/rXAk7NQm+U0yON4vP6SRuyV3oizKhk50hXHRBzYy82cPEG/6ZL1SzBttZh87clc1uU6RwYFNiJIueHaz7Ar1MQAxzw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pms97kXlpV/pxGjMNgAMjQmbLNe+jMRNXdA4qClWQOI=;
 b=sP2tQ/HRhBB1vT/g+FTn532MwWD5Prelrr4BrCd3Gwsg4YL2F0N3TsyfxA0ubihi5DJWiZHeeRZdiiuXaL6n43d1NY9sji7QQdmWGktaqSL4NsT31tJhBUaQTdl038vVPKb52HDjiH/pXurit15DKINhZMBkge2pElwvTshELorBbXUysYJEyKAgBKqR1NPP061+bR2Y9kWOLREfz94pb90knbrqFTOMacDs8DYzRdaE7kpzV78eoSrOEN1xDjmPCu6riJ+Q6kCUHZMlkmBOwIScM4X6QvGd5vQTL/fJpCzMwk6YY25TXdiEI/H1EYZ3d2drG6M1l4+n2KrQ2FO93w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pms97kXlpV/pxGjMNgAMjQmbLNe+jMRNXdA4qClWQOI=;
 b=IAWNt3CtNYKEcvL0b4rnhqAqCfPsn1BylTXUhjurogf8OUUjCdheDKoe/FQqUx3jDDlTBHOkD6g5gIzc0dN/qCXMwp6cok8P9lplRbgeWEbiX+UXxYNL8mQ1ET+IQyCe3iqV1UsVdpQg8maQdJN0jm8WWF5PqfLR/4ofYIlVQFA=
Received: from DB9PR02CA0022.eurprd02.prod.outlook.com (2603:10a6:10:1d9::27)
 by PAWPR08MB9758.eurprd08.prod.outlook.com (2603:10a6:102:2e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Tue, 17 Mar
 2026 11:48:01 +0000
Received: from DU6PEPF0000A7E3.eurprd02.prod.outlook.com
 (2603:10a6:10:1d9:cafe::5d) by DB9PR02CA0022.outlook.office365.com
 (2603:10a6:10:1d9::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Tue,
 17 Mar 2026 11:47:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E3.mail.protection.outlook.com (10.167.8.41) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17 via
 Frontend Transport; Tue, 17 Mar 2026 11:48:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q6Jt65+P7lMo6L1O4I4t29pC1+C12gs9dCRvVdC/mNs1cnWl1JnC7J2wI9yyPinV2DMYl4EaZD7OPmdPvnFVS7R1rpesVKoXEQdxCO+Gxl9jVzTLE03s7SffcLZZNS4x0iuvIxbv8xyuscg2Tt4QohnPINm1p1h1bNacb5b0vnYLJgBNPi7Y2WtRopFGDOAOuuviZoLym00Koa3O4CfPwJibpx4Iflua6eiAL/EuyTl2YiSKN91GE5Gva2eKTHoZqDa3aOrNHwjGUzo6n2ZTYW/5z8tTtUA20Qj1XUG3DvFubvno2YbMYiCY9Tkf/VFC9wx1NCM26o3VdXiAHBXCKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pms97kXlpV/pxGjMNgAMjQmbLNe+jMRNXdA4qClWQOI=;
 b=O4uMtIp2e1yWkg0oN5TFYdlJmNv2vwvtM7/A7ts65NWrwIg5k2X2jn7diXji+7RkhO/mz9nJ36SKbinK9H07udGDJlsyGUYy940YtF8dKWlIPKjBfMHg7imrNAZNsXN2SyILyHBGWbwYumuTfSNGC+exhIs7LQLgcLzWxKNA+Q1BV5D4JvPWrTVCsFt+XEVrP8tZpIzfV4AjQTnx9sjVYUtWLg8FMnG+3g6Sj33z0RfTZ2WTU4f/s2Exm9eEfCzrjQfgR3KiNOX18zz6gW+yCRDsWZfksgNUqWjmDXmC4oYZAXyOgBgsWcdJ7X0AjsUuEtkqfkmEHpJmCmZPURFVMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pms97kXlpV/pxGjMNgAMjQmbLNe+jMRNXdA4qClWQOI=;
 b=IAWNt3CtNYKEcvL0b4rnhqAqCfPsn1BylTXUhjurogf8OUUjCdheDKoe/FQqUx3jDDlTBHOkD6g5gIzc0dN/qCXMwp6cok8P9lplRbgeWEbiX+UXxYNL8mQ1ET+IQyCe3iqV1UsVdpQg8maQdJN0jm8WWF5PqfLR/4ofYIlVQFA=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:46:58 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:46:58 +0000
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
Subject: [PATCH v6 27/39] KVM: arm64: gic-v5: Create and initialise vgic_v5
Thread-Topic: [PATCH v6 27/39] KVM: arm64: gic-v5: Create and initialise
 vgic_v5
Thread-Index: AQHctgPDVExah3YDDUCBeHw69qhZ+A==
Date: Tue, 17 Mar 2026 11:46:58 +0000
Message-ID: <20260317113949.2548118-28-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|DU6PEPF0000A7E3:EE_|PAWPR08MB9758:EE_
X-MS-Office365-Filtering-Correlation-Id: 7feaa806-64eb-4689-4574-08de841b0adf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 To0tOlqHkFL4XyjTtW5QD1eGbRdsyg+mvecmmOtQu5k8HgBTG82bZTkkhYt0mEud3hUPWTNI+2uSZIwrjWMBBGRZbqXndWCdsI2YmPJvbi4NO1SYnJrECncWJhqfjFg0AZNMadKgqnWKvRKETNPKPjPylOK6MSvJkhuw7CEisADrBJhfweEkgjaf7V/AYPIIJoI6EQb8/WbXh+w0ZNfvhpqdDzEbvzyCdP7C1zfvV3eSIEW8K4eWbUrSyksT3jtR2t/YDv1k4T1ikPNBzQ3Bxvg3v09PYRAiigE6YPdnIudGpiD61vFVSrWowwRmaJNlypJZ+3u/2a9PwHC4M/CtVZibs7jU/zj96h6s8RFYhCutlr8hYzQY0znngE/7zzu1ptJooDRyiOUqb12fXC1VE8w/WY437+VKnsXO+3RqTqkVQg+WBj9G0Z6f4D0EbKuMa3x8DXMRzcdu0bjc1F1c3x1IaKaqFLCAYJq5tp9ud5QA1OFXFgkOYj3nVLEYtU+nJscEEEcSjGTv65SchD+Owa4VJBXPwC5QGtitrJLGLYc9jBUIBBpcNs2VtvZTnajmHEbpvxgOBx8YwegbZ9OtgtVdYprYQyOIAAgwJ4ufWT1iszjHDyyZN3SI6hluD+fYdUqSbaeknOaPp3uXl25QV2neVIHapuvGsIO11niDQxQzlK37nBBrvgOGZJL/ueya0+j+ERYUWxIC05Z4MyWR2CS2llD22E1K89rCXW7WKUoMhB+40HeXck66Z4rNnmrVBp+4mgRbDzV8L/fDgJcIqkbCcCzmewK2zAwvpbaWmjU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 fBa/swfkbDW8WnyZmfNSQcsWH3qFgf0j9z9M8QJ7d7VNgFSJqJbSTzEFWirmm120gef3hdGDOZip29lyMTNFfAyMnOVMr7csazyXSEEAJPCFQ5tRfrWbsp8HL2QNxbqXo0PrJIUeT3+0l0niInxig5mNpM9RbNMc+/ordD4y2LLAaroMX/XAhyCrNHmHqEQ95k1sd7JMtXJR8cps7fsE0U662/hL5DoGKb5ArUsjw/wDGwxzgj2l38ogehkpNmK4zPnKb+SJGLmSCbiWIgAavl07BINoIjjR/Z8P82vvdjdBzNSaO+1g7iGJ83yUno3ZUqbZsXUsl9C1ztjeAZi+5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e2fe1b84-9247-4423-fe57-08de841ae584
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|1800799024|82310400026|36860700016|14060799003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BJYBOKiyAV5LEGYUuQDYq8SX0AysvSto0ud11KbilE2dGlXwGm/Iovumpc5jAfvcEy+eGbQvCd0gby5Wqg4g2BOvT7yN0DTwurJfOA2tV9CECflLhTzAVAy0Rgr6jBE9r9/vXgZemmzfttTdDtkBnPUjVe4YIaZUhN89PEX5x/LVhzO4RMdLrqnYY/lS6tPv1eJ57wcCohuLAx+CS6Yflw42BX2qf2MxFvhHHQRFJj3bl5iEafoQElQywYUCGV8pihA5i97hsGueqhy7YhcD9rDzibW78y3WK7JyZC9ZrwTWFYg0sha+qERUsQFkM8PlLHlI9gnCNsGR2ogmCyGaXH9IxoF2fIGRUY/XW5UxYM910fTad99gVJwbwivGAOhU5wByeHoL1iY6ae59s4Nz+ZTGb8WfGi+AA0zFycChG7FivmljmqkVi3dclpYzHVClKOFYp8ybslSy7pGC3zeGqwyEHNKlNN6HnUCbL0vwpViAZtGuuzknkDm5VZKTDx2tAbyidieNjlfO/Yht14mPK82ygXoVsUPOPVmoORSaH3v0v+vSikMqugpLDu0aQ22w2gctF1dRIPON6/Bs2/zKHknemRasNW4ND9TXounYrUc+ggXTh6KO9/0w1LYPowROGhCMAYx0DXQEnlJ86/RPjU2Fd2TwiolW7zcIvkAUEfVEzJiKpjNnMLGp99klDQvFNe4yeoDB3r4Un04Kr6LJQOF1tQyLJlnvtAEJUovN1Rn6kFFN8xknq8s05cJzX/OCZdO5IJB4Lubw9onqm+88mw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(1800799024)(82310400026)(36860700016)(14060799003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	thnW2HlPqIcuLZIY9x9YYkXU9L1TDDlqf61WisYOQt6Z1PFhD1n5E+cXZrZiifT8PWqsJ66Sh5mdAq58SZe6M2mQRIB8OqW2YlpHFn0+AQdXp20YF0y1pNGbEge5ldHrb7af6SbrJ9WSBSy8hNSsy+5+gjf8ne1d39AcEIKDc/7gyf5uszlsM96rxOIExIxMEqKZNtsct9CM486kWZQUgjJlJ1aUSajN43z9NV/ZGyYY3wSu5F7Mv+WW7+SEDZOJ8niolNWM2CaeOQ3EMC+XjsikGisPQYooGfCsJprrq8aIEM1myMkarUPTS584dyReX9CuHIWgaDCv8PsVWvNDTDBZkMpnKdx1FswZh+sgU+MIUHIaeyjMLvJX2z3NO3pmzbcwSm5v0xJ1qNUElGG6c0i6x0qZay/Qpj5ICu1cX9Le+/0pTpnVwY34b3BVqd42
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:48:01.3410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7feaa806-64eb-4689-4574-08de841b0adf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9758

Update kvm_vgic_create to create a vgic_v5 device. When creating a
vgic, FEAT_GCIE in the ID_AA64PFR2 is only exposed to vgic_v5-based
guests, and is hidden otherwise. GIC in ~ID_AA64PFR0_EL1 is never
exposed for a vgic_v5 guest.

When initialising a vgic_v5, skip kvm_vgic_dist_init as GICv5 doesn't
support one. The current vgic_v5 implementation only supports PPIs, so
no SPIs are initialised either.

The current vgic_v5 support doesn't extend to nested guests. Therefore,
the init of vgic_v5 for a nested guest is failed in vgic_v5_init.

As the current vgic_v5 doesn't require any resources to be mapped,
vgic_v5_map_resources is simply used to check that the vgic has indeed
been initialised. Again, this will change as more GICv5 support is
merged in.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 54 +++++++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic-v5.c   | 26 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  2 ++
 include/kvm/arm_vgic.h          |  1 +
 4 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index f8d7d5a895e79..13d085bf01a97 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -66,7 +66,7 @@ static int vgic_allocate_private_irqs_locked(struct kvm_v=
cpu *vcpu, u32 type);
  * or through the generic KVM_CREATE_DEVICE API ioctl.
  * irqchip_in_kernel() tells you if this function succeeded or not.
  * @kvm: kvm struct pointer
- * @type: KVM_DEV_TYPE_ARM_VGIC_V[23]
+ * @type: KVM_DEV_TYPE_ARM_VGIC_V[235]
  */
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
@@ -131,8 +131,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
+				     kvm_vgic_global_state.max_gic_vcpus);
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
@@ -425,22 +428,28 @@ int vgic_init(struct kvm *kvm)
 	if (kvm->created_vcpus !=3D atomic_read(&kvm->online_vcpus))
 		return -EBUSY;
=20
-	/* freeze the number of spis */
-	if (!dist->nr_spis)
-		dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
+	if (!vgic_is_v5(kvm)) {
+		/* freeze the number of spis */
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
=20
-	ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
-	if (ret)
-		goto out;
+		ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
+		if (ret)
+			return ret;
=20
-	/*
-	 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
-	 * vLPIs) is supported.
-	 */
-	if (vgic_supports_direct_irqs(kvm)) {
-		ret =3D vgic_v4_init(kvm);
+		/*
+		 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
+		 * vLPIs) is supported.
+		 */
+		if (vgic_supports_direct_irqs(kvm)) {
+			ret =3D vgic_v4_init(kvm);
+			if (ret)
+				return ret;
+		}
+	} else {
+		ret =3D vgic_v5_init(kvm);
 		if (ret)
-			goto out;
+			return ret;
 	}
=20
 	kvm_for_each_vcpu(idx, vcpu, kvm)
@@ -448,12 +457,12 @@ int vgic_init(struct kvm *kvm)
=20
 	ret =3D kvm_vgic_setup_default_irq_routing(kvm);
 	if (ret)
-		goto out;
+		return ret;
=20
 	vgic_debug_init(kvm);
 	dist->initialized =3D true;
-out:
-	return ret;
+
+	return 0;
 }
=20
 static void kvm_vgic_dist_destroy(struct kvm *kvm)
@@ -597,6 +606,7 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	bool needs_dist =3D true;
 	enum vgic_type type;
 	gpa_t dist_base;
 	int ret =3D 0;
@@ -615,12 +625,16 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		ret =3D vgic_v2_map_resources(kvm);
 		type =3D VGIC_V2;
-	} else {
+	} else if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		ret =3D vgic_v3_map_resources(kvm);
 		type =3D VGIC_V3;
+	} else {
+		ret =3D vgic_v5_map_resources(kvm);
+		type =3D VGIC_V5;
+		needs_dist =3D false;
 	}
=20
-	if (ret)
+	if (ret || !needs_dist)
 		goto out;
=20
 	dist_base =3D dist->vgic_dist_base;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 602a970118496..0482282d59830 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -87,6 +87,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_init(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long idx;
+
+	if (vgic_initialized(kvm))
+		return 0;
+
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		if (vcpu_has_nv(vcpu)) {
+			kvm_err("Nested GICv5 VMs are currently unsupported\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int vgic_v5_map_resources(struct kvm *kvm)
+{
+	if (!vgic_initialized(kvm))
+		return -EBUSY;
+
+	return 0;
+}
+
 int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu0;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 3a9e610eefb00..9f1ddf9f4016c 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,8 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+int vgic_v5_init(struct kvm *kvm);
+int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a28cf765f3eb5..a5ddccf7ef3b0 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -21,6 +21,7 @@
 #include <linux/irqchip/arm-gic-v4.h>
 #include <linux/irqchip/arm-gic-v5.h>
=20
+#define VGIC_V5_MAX_CPUS	512
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
 #define VGIC_NR_IRQS_LEGACY     256
--=20
2.34.1
