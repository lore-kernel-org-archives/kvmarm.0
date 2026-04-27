Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012021.outbound.protection.outlook.com [52.101.66.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBEC352F85
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.21
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306795; cv=fail; b=UEqPMsN6LfP5slLv5e0b1kBeCSIh5Bi5L1/7rmQ+tCs9RbvickAksGLSYW4v3rk2W3xBmnhT1mHBn6h35DHnyzmYBz2g4Ko1PK7tXHjIQJypP9p9dquB8OnRJf7lHpD3JA9J1a8WtcV7MnZyw/g2P8QHLfNVdK0tvN410A66r+Y=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306795; c=relaxed/simple;
	bh=YSR2bhH4tm2p6f/Uq8bJhIacCSXUef9ozKO09xuDvpM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cx1fPz/2EcWrST5jedxvKeVpB2dK/NyHk/uMfLzslqdiZkKFnuz4CQN6MLXpQ6d3UC3wtIe66Tm6RdXoT2czEqG6183OahrHhbNG7akP6IT0fpNBRUdZSyytxTWTavSXihy955EJkBlOLOyFcZhDwV9dw5zt9AwDh7aQGx+xxcw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DQqr2Hw4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DQqr2Hw4; arc=fail smtp.client-ip=52.101.66.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DQqr2Hw4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DQqr2Hw4"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=o6Wcj87VdZKL6nDzNlh+Q28aY9yExByKCvvvqWSCjh5jL2J0m2RwRrMQHwUpkEGBmgN/I8XFs/N3fRWRPZ2XH/c/mQkXErbp272x9grVmCXUaGdS4iOqzLYUWykxqWiM8F6i7FWv8Nl1ZGKmwBQFG0w7Sq2ecYwNi0NLOoRpPx2nrjzREz6g7vGt+3uLXFrb1wcNtz1zLRZxN9U82WWxVz8/5nZF1TlEwn7+GlEwbnk8T9nc/3n12Ew4I3f3IBSJ8lh6Fux6nqDLgW6qT1uz7wv3NxPzpwFvuzA+deIRmjO5PAKDeIJHwRwfhPKLSG+hm8jM4iRJ44ou/iDCsRe3PQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BS//HlXjtJ0V2OiuR+988RmxrnCSqtZJWmW4Q37JRmM=;
 b=xh1juLMiV4l8xJEDj9xGTcpUAokIJmWVACUPsJjz7Q9nUexFlPN1zOcuLm+lFyO7m38eGpD+fzHsUaq0uKwMmcOkNhsftoxuQFWy8gMegvmAZ6P5j4oyirRlM+pBle0XGaK4nqvewoGUAC7k6X+PYiMETyuW0R+aooO0itlCtGCgtW035t91n53+IJFEAXojpeRKtCNHVbehiqMuUXIB+LKYTy+5i8PmeL7gxC9vYhO8Tq0zCXTryQF7jw+t/hNGWCwNrYe3f/+k8ILPxE9wNaxLs2AkQwNOLYTv5S9SWgUTFHA+w+jYGGWZkc2a6MwZ7Zstv1dpF8TAv1UbMgSY4A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BS//HlXjtJ0V2OiuR+988RmxrnCSqtZJWmW4Q37JRmM=;
 b=DQqr2Hw4qCGOVY4s7SFd6pGRjOd8XoE5yUEMiqHgOsOVubcM2K7EKpf0VrgiJhk5Zft1OppJxaxgoB+padRB6QsEChyv+x5YVcWIMFXLQriFREfnkBpK9QzoweXuOb5mnw9COs3fEgXQfe9+Voooc0YQbDbt0h5gpH+Wun/armQ=
Received: from CWLP265CA0423.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d7::9)
 by DBBPR08MB6233.eurprd08.prod.outlook.com (2603:10a6:10:204::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:19:44 +0000
Received: from AM1PEPF000252DD.eurprd07.prod.outlook.com
 (2603:10a6:400:1d7:cafe::6d) by CWLP265CA0423.outlook.office365.com
 (2603:10a6:400:1d7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.25 via Frontend Transport; Mon,
 27 Apr 2026 16:19:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DD.mail.protection.outlook.com (10.167.16.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:19:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GnDJCElXWLu4IB1FgmEGCCKU+OBA0s8PqOJtP9aVZr4PjXt9OvzrUpgA54Sa9GJash8VqlAAB5i1UsuDnfHpjM2AUEkweOaIhLAWU0jkbhZf2eD83QVrVmIMVZfQdJQcM+B3N8RsknpYdunWqTD2+XLU5zSyvRttcYdf78BPy3gDuy9hXOAqx36YE+476euPDBLkBcXsT1JkFksXcfJBiMYqJ8bM2ZS/oY+lNm4StabCV1U3OIBq9HguS73QR6pdEUtZJ+tWdxFXUPwFiBcjFKvbanbwgmJBWc6qomcQKGdvTTwkXkH6ONDVXIJ+Vb7uAZethzcgK5riiMHt0mWg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BS//HlXjtJ0V2OiuR+988RmxrnCSqtZJWmW4Q37JRmM=;
 b=tTZjt2t+fF1rfw49ujGkF+RmPjNFo2qgDvUri5FaMYP2LH25UZLLWTVY0cu1E5ZAKfXMebedZ9629MLkdw1m7AnVG2IhIh8wXveu9qLWA1DmmGwthtcQm2QgO7cSZEg6cIVcbnjzSP4H3aAEb9+mZSwx51nEsqV+yroeXpjT3cv9udadVDvu0WUaNVnJZxbWNkUgLuRdlYHNE0WtdLtXegqCshkRirU1XQwr6DAGNjWZ7IyB6dGJs3CXti58aK20LM/roPivPKPJ/9qLtq2xW18jOJWytaGKFr0wNrIHGM/PA6Z/lzsceP4/ljsicjIPTG/4xB0z5enw8I+D3TmFig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BS//HlXjtJ0V2OiuR+988RmxrnCSqtZJWmW4Q37JRmM=;
 b=DQqr2Hw4qCGOVY4s7SFd6pGRjOd8XoE5yUEMiqHgOsOVubcM2K7EKpf0VrgiJhk5Zft1OppJxaxgoB+padRB6QsEChyv+x5YVcWIMFXLQriFREfnkBpK9QzoweXuOb5mnw9COs3fEgXQfe9+Voooc0YQbDbt0h5gpH+Wun/armQ=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:18:41 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:18:40 +0000
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
Subject: [PATCH 37/43] KVM: arm64: gic-v5: Handle userspace accesses to IRS
 MMIO region
Thread-Topic: [PATCH 37/43] KVM: arm64: gic-v5: Handle userspace accesses to
 IRS MMIO region
Thread-Index: AQHc1mGC444xfIuLJUm14w9Xqv03OA==
Date: Mon, 27 Apr 2026 16:18:40 +0000
Message-ID: <20260427160547.3129448-38-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|AM1PEPF000252DD:EE_|DBBPR08MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 548029ac-f4eb-4bc4-835a-08dea478cb38
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 ShqrcV2Y+tOBwaVVXIAzRN5wfY9/x5GUp4dErT4T8eZUag7pyXUbbm+iw+fZB815MtOstRu050Q9cAbx1BoJJTQTCEBEF3Vg5oMZvEesy6u+61k9LmX07rJJKvOQmx63Z92apToCLNZK3v8jT6DZ5eUiy6XcNo9w7Ap9n2aUuDCAHOFsE2/3II+w5prNLGbo+cXVZ8n34pPxUtIsMQdX0Lo7GOwhXKmWNqxWkiEaeml07EELhAsLklxu/NceTvH/lXfTxx89KKbx392mPUrxHKIR/8+ErfA71VbR39cQRcWvX8bVd7siar/Vaw38fBFqA6Y/Nj2QqYREHdk4Z2hkQ594AJqx43xJvYFjHLGxETTtQQdPlGl1M3YqED/HdJk1wpyasNiTcPlYQZAvAI+t8brtBZpkCzFFnXATUveBZBiyERx2b/e9AAAWtfLbGYcgSBCp3FTwj+3nDoutsrygBxavha/tN2na33bISslepJTSBlzcas2zMmf5cqb4jFe/IXmIKQI67w9X4zkDMszn0dnPgx9RAq0sezFCqRr09Fy5Fxc0lTGaQLHzmIyn8aU4HkjxVG/xfcuGGUFzj2HLIohjTpchgvCGH5xjmQ9h9QsnM8FMeaKaWfE9n/bHmgHhDnmRO4+/DWl//VkplCRoUTIwY2iYSiOj5AjRxt82KrS+b0RygbRR8W9CKtsxjt5X0maS92du4/vzmoD2IbGp5Rb+9mEvDeqqFOvxBTJja0kHTjfxaCk3EX4MUeBNg8KbUuzKGZTyoSlvA6+Uoexcpuzf6zDwbohVW0F86tBOGtw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 kCHa2jvIJVUMXpUzqudoVUUX7MZotkgWIx8VeI28xFmyFXMozB1NgWX/B5G3kkCE7SBqgmkq6KUmFtwTpNOBaW13n+JDkC9gdHJ7voT0KbuSs7AkAoIhYwwiLPT44yDfoo3iJa+uiHKprFhlj3f7Bn9dl7Hjf+vnE33pwcFa/ZDWpWRMRrkQ13jOsRANO5FKlC+Tcfmg4c42qRbvrfV4J9sWE/0HdjdycmRoYgxZdcHDO6ROQkXobyXJCs46KFWKgWoXZTgpgeV8w4J1SVifJMN9ZdscXUyke17J0UGDeugDNbSHT7Gz3g4z0x9bLz6eP33booo1QTRBLJPcy80uIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DD.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	792039d5-12cf-42e7-e886-08dea478a53e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|30052699003|35042699022|14060799003|36860700016|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	c6OgTG8LzGG+l93sbAVipCoJOIIAWhhqXE6uZTeiUennFumhdKikZEctN7PxoZtxWW9QP5/ijPSefRy+h4VdTsDxJp5jMd6lQPti138Jl/XDIgCMbBOx2VhNQGL6f1EoNa2/TEfUmlCIBC+6TtowM4ftE3PiHs6VHY/U+K5jgHCt2Nmgc2GZnlvzb+88lVGDvK4jTUxc22wUp9t93/o9JqS24LoYWJZRSVvBJiq3K+R2Yk3V6tesWIubvCjz9bjKDbmtN7RuzEmt5kWnoRJsjIXL6FMyyzTUvCswPdClBD3poPFMlthxyOT+/iwVMaWqiumtWmj9TkzIIN626VdF/kJpC5GyK3XVvdApv9ZlA2UlWkyGbQ9IQDMKGoDSecQ8pZHR6N+2ysi3xlAMDvL0DEhS2zenekZcFbdv7pFtqv8OP9DiDpa5Multp+SlXpN1X3uUMV3a92JVv7dqKldMC2mCgVN+M+NsJJMvSJjRXZK3YVDT4P3zgaSgvQd4IbPKFap84URLc2dQDdzZemckk6o68EIorW7x+GFhSuqeCIez6faCMx86Ynlz4IraTJV0jQimqCQlLIxQ5QxQDKHC9O8mQlOfKtzt+9HrzJM5W5BqLJeQ/kkVDwn9Rzg6RTyMGNnzCi0mlPK4c3TPkK9jtcEqHnq2kxyB1imVdGyraWKSoYnIHziDnNoHjAjpOk9uQc0Rxery2Z+GuSFuw8CkWgokJFjgJ/bjNsgeqv3lMxK4CLfIs4GJnkBlxJz4C+w3PwIhD/giyTtdTDdABhoDhQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(30052699003)(35042699022)(14060799003)(36860700016)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/theirCohrYDwXnHLKgk/Bduzmd/YNtbcs6lOwLtRLcOELmZ0yprTCCwlDqahcUsAf/7VSgXgtimp6ruXxc0+yxlsmCLf3Wl9B8msY71CauyhKx7W/v5vS/78YwGjHRqla6Dyhr0i0/Wdn3v2ZbYj0VPQdVOKOKANpk8KMDTurp46Pp+jA8qZbgzLAdDKlsY3bHaksKElP3ZWB0FLVqAEE2TL/JyBbgFIdo2Yzbl/JHlau4koi4ZClm2a8Lh2vKmxMadCt9mAvRC/aoRQF0MpS5C8mlQOzA517GYYfcXp2PDH+EfHegSA8MF3afxUKbcicJKaDXWixgcQ1z2TVo+Tk+Z38YGdQRVEn5Y5Ot9f3KSz5ytn1DR9+7kxPH1mmg5O5pd3B59QAr7yYlEvT3c0o5Zs8vK5qNFnBxsXKsS9cFWE7wlHV+3eB8bOfxZqXci
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:19:44.4673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 548029ac-f4eb-4bc4-835a-08dea478cb38
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DD.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6233

As part of saving and restoring state of a GICv5-based system,
userspace is required to save/restore the IRS MMIO registers. These
include important information such as guest IST configuration, and in
general KVM needs to present consistent state to the guest.

Provide accessors to read and write the IRS MMIO state. This is
modelled on what is already done for the GICv3 ITS as the idea is
broadly the same.

Where possible, the existing access mechanisms are used, but for some
registers the access is handled a bit differently as they have wider
effects. For example, some writes need to be sanitised to make sure
that the hardware is capable (IST capabilities presented to the guest,
for example). Similar things apply to the SPI config where we block
userspace from setting anything that doesn't match what has been set
already.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c     | 494 +++++++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  24 ++
 arch/arm64/kvm/vgic/vgic.h            |   6 +
 3 files changed, 401 insertions(+), 123 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 3a2539bf99d0d..761878fc956de 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -26,15 +26,58 @@ static struct vgic_v5_irs *vgic_v5_get_irs(struct kvm_v=
cpu *vcpu)
 	return vcpu->kvm->arch.vgic.vgic_v5_irs_data;
 }
=20
+static int vgic_v5_read_irs_pe_cr0(struct kvm_vcpu *vcpu, u64 *val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	struct gicv5_cmd_info cmd_info;
+	struct kvm_vcpu *target_vcpu;
+	int rc;
+
+	target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid);
+	if (!target_vcpu)
+		return -EINVAL;
+
+	/*
+	 * Read the corresponding IRS_VPE_CR0. We do so via the doorbell for the
+	 * specific vcpu we have in the PE_SELR.
+	 */
+	cmd_info.cmd_type =3D VPE_CR0_READ;
+	rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(target_vcpu), &cmd_info);
+	if (rc)
+		return rc;
+
+	*val =3D cmd_info.data;
+	return 0;
+}
+
+static int vgic_v5_write_irs_pe_cr0(struct kvm_vcpu *vcpu, unsigned long v=
al)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	struct gicv5_cmd_info cmd_info;
+	struct kvm_vcpu *target_vcpu;
+	int rc;
+
+	target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid);
+	if (!target_vcpu)
+		return -EINVAL;
+
+	/*
+	 * Write the corresponding IRS_VPE_CR0. We do so via the doorbell for
+	 * the specific vcpu we have in the PE_SELR.
+	 */
+	cmd_info.cmd_type =3D VPE_CR0_WRITE;
+	cmd_info.data =3D val;
+	rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(target_vcpu), &cmd_info);
+
+	return rc;
+}
+
 static unsigned long vgic_v5_mmio_read_irs_misc(struct kvm_vcpu *vcpu,
 						gpa_t addr, unsigned int len)
 {
 	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
 	const size_t offset =3D addr & (SZ_64K - 1);
-	struct gicv5_cmd_info cmd_info;
-	struct kvm_vcpu *target_vcpu;
 	u64 value =3D 0;
-	int rc;
=20
 	switch (offset) {
 	case GICV5_IRS_IDR0:
@@ -127,32 +170,8 @@ static unsigned long vgic_v5_mmio_read_irs_misc(struct=
 kvm_vcpu *vcpu,
 		}
 		break;
 	case GICV5_IRS_PE_CR0:
-		/*
-		 * Make sure that we are doing something reasonable first.
-		 * Remember, the IAFFID is the same as the VPE_ID
-		 */
-		target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid);
-		if (!target_vcpu) {
-			kvm_err("Guest programmed invalid IAFFID (0x%x) into the IRS_PE_SELR\n"=
,
-				irs->pe_selr.iaffid);
-			break;
-		}
-
-		mutex_lock(&vcpu->kvm->arch.config_lock);
-
-		/*
-		 * Read the corresponding IRS_VPE_CR0. We do so via the doorbell
-		 * for the specific vcpu we have in the PE_SELR.
-		 */
-		cmd_info.cmd_type =3D VPE_CR0_READ;
-		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(target_vcpu), &cmd_info);
-		if (rc)
-			kvm_err("Could not read VPE_CR0 in IRS: %d\n", rc);
-		else
-			value =3D cmd_info.data;
-
-		mutex_unlock(&vcpu->kvm->arch.config_lock);
-
+		scoped_guard(mutex, &vcpu->kvm->arch.config_lock)
+			WARN_ON_ONCE(vgic_v5_read_irs_pe_cr0(vcpu, &value));
 		break;
 	default:
 		return 0;
@@ -167,9 +186,6 @@ static void vgic_v5_mmio_write_irs_misc(struct kvm_vcpu=
 *vcpu, gpa_t addr,
 	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
 	struct vgic_dist *vgic =3D vgic_v5_get_vgic(vcpu);
 	const size_t offset =3D addr & (SZ_64K - 1);
-	struct gicv5_cmd_info cmd_info;
-	struct kvm_vcpu *target_vcpu;
-	int rc;
=20
 	switch (offset) {
 	case GICV5_IRS_CR0:
@@ -216,27 +232,8 @@ static void vgic_v5_mmio_write_irs_misc(struct kvm_vcp=
u *vcpu, gpa_t addr,
 		irs->pe_selr.iaffid =3D FIELD_GET(GICV5_IRS_PE_SELR_IAFFID, val);
 		return;
 	case GICV5_IRS_PE_CR0:
-		/*
-		 * Make sure that we are doing something reasonable first.
-		 * Remember, the IAFFID is the same as the VPE_ID.
-		 */
-		target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid);
-		if (!target_vcpu)
-			return;
-
-		mutex_lock(&vcpu->kvm->arch.config_lock);
-
-		/*
-		 * Write the corresponding IRS_VPE_CR0. We do so via the
-		 * doorbell for the specific vcpu we have in the PE_SELR.
-		 */
-		cmd_info.cmd_type =3D VPE_CR0_WRITE;
-		cmd_info.data =3D val;
-		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(target_vcpu), &cmd_info);
-		if (rc)
-			kvm_err("Could not update VPE_CR0 in IRS: %d\n", rc);
-
-		mutex_unlock(&vcpu->kvm->arch.config_lock);
+		scoped_guard(mutex, &vcpu->kvm->arch.config_lock)
+			WARN_ON_ONCE(vgic_v5_write_irs_pe_cr0(vcpu, val));
 		return;
 	default:
 		return;
@@ -411,13 +408,56 @@ static unsigned long vgic_v5_mmio_read_irs_ist(struct=
 kvm_vcpu *vcpu,
 	return value;
 }
=20
+static int vgic_v5_write_irs_ist_baser(struct kvm_vcpu *vcpu, unsigned lon=
g val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	struct gicv5_cmd_info cmd_info;
+	bool valid =3D FIELD_GET(GICV5_IRS_IST_BASER_VALID, val);
+	int rc;
+
+	/* Valid -> Invalid */
+	if (irs->ist_baser.valid && !valid) {
+		/* Make the LPI IST invalid and then ... */
+		cmd_info.cmd_type =3D LPI_VIST_MAKE_INVALID;
+		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd_info);
+		if (rc)
+			return rc;
+
+		/*
+		 * ... free the host IST if we successfully marked the
+		 * IST as invalid. Frankly, if we failed to make the
+		 * guest's IST as invalid, we're cooked because it means
+		 * that the IRS may still be using the memory that we
+		 * want to free. Hence, we leave it allocated and skip
+		 * the clearing of valid bit in the baser.
+		 */
+		rc =3D vgic_v5_lpi_ist_free(vcpu->kvm);
+		if (rc)
+			return rc;
+	} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+		if (!vgic_v5_ist_cfgr_valid(irs)) {
+			kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
+			return -EINVAL;
+		}
+
+		rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits);
+		if (rc)
+			return rc;
+	}
+
+	/* Now that we've handled the edges, update the valid bit and addr */
+	irs->ist_baser.valid =3D FIELD_GET(GICV5_IRS_IST_BASER_VALID, val);
+	irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+		<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+
+	return 0;
+}
+
 static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
 				       unsigned int len, unsigned long val)
 {
 	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
 	const size_t offset =3D addr & (SZ_64K - 1);
-	struct gicv5_cmd_info cmd_info;
-	int rc;
=20
 	switch (offset) {
 	case GICV5_IRS_IST_CFGR:
@@ -427,77 +467,191 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vc=
pu *vcpu, gpa_t addr,
 		irs->ist_cfgr.structure =3D FIELD_GET(GICV5_IRS_IST_CFGR_STRUCTURE, val)=
;
 		return;
 	case GICV5_IRS_IST_BASER: {
-		bool valid =3D FIELD_GET(GICV5_IRS_IST_BASER_VALID, val);
-
 		guard(mutex)(&vcpu->kvm->arch.config_lock);
+		if (WARN_ON_ONCE(vgic_v5_write_irs_ist_baser(vcpu, val)))
+			break;
+		return;
+	}
+	default:
+		return;
+	}
+}
=20
-		/* Valid -> Invalid */
-		if (irs->ist_baser.valid && !valid) {
-			/* Make the LPI IST invalid and then ... */
-			cmd_info.cmd_type =3D LPI_VIST_MAKE_INVALID;
-			rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd_info);
-			if (WARN_ON_ONCE(rc))
-				break;
+static unsigned long vgic_v5_mmio_uaccess_read_irs(struct kvm_vcpu *vcpu,
+						   gpa_t addr, unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
+	u64 val =3D 0;
=20
-			/*
-			 * ... free the host IST if we successfully marked the
-			 * IST as invalid. Frankly, if we failed to make the
-			 * guest's IST as invalid, we're cooked because it means
-			 * that the IRS may still be using the memory that we
-			 * want to free. Hence, we leave it allocated and skip
-			 * the clearing of valid bit in the baser.
-			 */
-			rc =3D vgic_v5_lpi_ist_free(vcpu->kvm);
-			if (WARN_ON_ONCE(rc))
-				break;
-		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
-			if (!vgic_v5_ist_cfgr_valid(irs)) {
-				kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
-				break;
-			}
-
-			rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm,
-						   irs->ist_cfgr.lpi_id_bits);
-			if (WARN_ON_ONCE(rc))
-				break;
-		}
+	switch (offset) {
+	case GICV5_IRS_PE_CR0:
+		/* Read without trying to take the config_lock again */
+		if (vgic_v5_read_irs_pe_cr0(vcpu, &val))
+			return 0;
+		return val;
+	default:
+		return 0;
+	}
+}
=20
-		/* Now that we've handled the edges, update the valid bit and addr */
-		irs->ist_baser.valid =3D FIELD_GET(GICV5_IRS_IST_BASER_VALID, val);
-		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
-			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vcpu *vcpu, gpa_t add=
r,
+					  unsigned int len, unsigned long val)
+{
+	struct vgic_dist *vgic =3D &vcpu->kvm->arch.vgic;
+	struct vgic_v5_irs *irs_data =3D vgic->vgic_v5_irs_data;
+	size_t offset =3D addr & (SZ_64K - 1);
=20
-		return;
-	}
+	/*
+	 * The following registers are ONLY settable via uaccesses. The guest
+	 * cannot write them!
+	 */
+
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		if (FIELD_GET(GICV5_IRS_IDR0_DOM, val) !=3D
+		    GICV5_IRS_IDR0_DOMAIN_NON_SECURE)
+			return -EINVAL;
+
+		if (FIELD_GET(GICV5_IRS_IDR0_VIRT, val) ||
+		    FIELD_GET(GICV5_IRS_IDR0_ONEOFN, val) ||
+		    FIELD_GET(GICV5_IRS_IDR0_VIRT1OFN, val) ||
+		    FIELD_GET(GICV5_IRS_IDR0_SETLPI, val) ||
+		    FIELD_GET(GICV5_IRS_IDR0_MEC, val) ||
+		    FIELD_GET(GICV5_IRS_IDR0_MPAM, val) ||
+		    FIELD_GET(GICV5_IRS_IDR0_SWE, val))
+			return -EINVAL;
+
+		irs_data->idr0.domain =3D FIELD_GET(GICV5_IRS_IDR0_DOM, val);
+		irs_data->idr0.pa_range =3D FIELD_GET(GICV5_IRS_IDR0_PA_RANGE, val);
+		irs_data->idr0.virt =3D FIELD_GET(GICV5_IRS_IDR0_VIRT, val);
+		irs_data->idr0.one_of_n =3D FIELD_GET(GICV5_IRS_IDR0_ONEOFN, val);
+		irs_data->idr0.virt_one_of_n =3D FIELD_GET(GICV5_IRS_IDR0_VIRT1OFN, val)=
;
+		irs_data->idr0.setlpi =3D FIELD_GET(GICV5_IRS_IDR0_SETLPI, val);
+		irs_data->idr0.mec =3D FIELD_GET(GICV5_IRS_IDR0_MEC, val);
+		irs_data->idr0.mpam =3D FIELD_GET(GICV5_IRS_IDR0_MPAM, val);
+		irs_data->idr0.swe =3D FIELD_GET(GICV5_IRS_IDR0_SWE, val);
+		irs_data->idr0.irs_id =3D FIELD_GET(GICV5_IRS_IDR0_IRSID, val);
+		break;
+	case GICV5_IRS_IDR1:
+		/* Ignore writes to PE_CNT as this is populated from num vcpus */
+
+		/*
+		 * The number of IAFFID bits supported. If userspace tries to
+		 * set something more than what we support, reject the write.
+		 */
+		if (FIELD_GET(GICV5_IRS_IDR1_IAFFID_BITS, val) > vgic_v5_vmte_vpe_id_bit=
s(vcpu))
+			return -EINVAL;
+
+		if (FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, val) > 0b100)
+			return -EINVAL;
+
+		irs_data->idr1.priority_bits =3D FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS,=
 val);
+		break;
+	case GICV5_IRS_IDR2:
+		/* We always support LPIs */
+		if (!FIELD_GET(GICV5_IRS_IDR2_LPI, val))
+			return -EINVAL;
+
+		/* We only support LPIs with linear, non-metadata guest ISTs */
+		if (FIELD_GET(GICV5_IRS_IDR2_IST_LEVELS, val))
+			return -EINVAL;
+
+		if (FIELD_GET(GICV5_IRS_IDR2_ISTMD, val) ||
+		    FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val))
+			return -EINVAL;
+
+		/* We can't present more bits than we have support for in HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val) > vgic_v5_host_caps()->ist_id=
_bits)
+			return -EINVAL;
+
+		/* Min LPI ID bits must be greater than or equal to the HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) <
+		    vgic_v5_host_caps()->min_lpi_id_bits)
+			return -EINVAL;
+
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) >
+		    FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val))
+			return -EINVAL;
+
+		irs_data->idr2.istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val);
+		irs_data->idr2.istmd =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD, val);
+		irs_data->idr2.ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, val);
+		irs_data->idr2.ist_levels =3D FIELD_GET(GICV5_IRS_IDR2_IST_LEVELS, val);
+		irs_data->idr2.min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_B=
ITS, val);
+		irs_data->idr2.id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val);
+		break;
+	case GICV5_IRS_IDR5:
+		if (FIELD_GET(GICV5_IRS_IDR5_SPI_RANGE, val) !=3D irs_data->idr5.spi_ran=
ge)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR6:
+		if (FIELD_GET(GICV5_IRS_IDR6_SPI_IRS_RANGE, val) !=3D irs_data->idr6.spi=
_irs_range)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR7:
+		if (FIELD_GET(GICV5_IRS_IDR7_SPI_BASE, val) !=3D irs_data->idr7.spi_base=
)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IST_BASER:
+		return vgic_v5_write_irs_ist_baser(vcpu, val);
+	case GICV5_IRS_SPI_CFGR:
+		fallthrough;
+	case GICV5_IRS_PE_SELR:
+		fallthrough;
+	case GICV5_IRS_IIDR:
+		fallthrough;
+	case GICV5_IRS_AIDR:
+		break;
+	case GICV5_IRS_PE_CR0:
+		/* Write without trying to take the config_lock again */
+		return vgic_v5_write_irs_pe_cr0(vcpu, val);
 	default:
-		return;
+		return -EINVAL;
 	}
+
+	return 0;
 }
=20
 static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
 	/*
 	 * This is the IRS_CONFIG_FRAME.
 	 */
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
@@ -516,30 +670,34 @@ static const struct vgic_register_region vgic_v5_irs_=
registers[] =3D {
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_SELR, vgic_v5_mmio_read_irs_spi,
 				  vgic_v5_mmio_write_irs_spi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(
-		GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_spi,
-		vgic_v5_mmio_write_irs_spi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_CFGR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_v5_mmio_write_irs_spi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
 				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
 				  4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
-				  vgic_v5_mmio_write_irs_misc, 4,
-				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(
+		GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+		vgic_v5_mmio_write_irs_misc, NULL,
+		vgic_v5_mmio_uaccess_write_irs, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
 				  vgic_v5_mmio_read_irs_misc,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_v5_mmio_write_irs_misc, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(
+	REGISTER_DESC_WITH_LENGTH_UACCESS(
+		GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
+		vgic_v5_mmio_write_irs_misc, vgic_v5_mmio_uaccess_read_irs,
+		vgic_v5_mmio_uaccess_write_irs, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(
 		GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
-		vgic_v5_mmio_write_irs_ist, 8, VGIC_ACCESS_64bit),
+		vgic_v5_mmio_write_irs_ist, NULL,
+		vgic_v5_mmio_uaccess_write_irs, 8, VGIC_ACCESS_64bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
 				  vgic_v5_mmio_write_irs_ist, 4,
 				  VGIC_ACCESS_32bit),
@@ -825,3 +983,93 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int=
 nr_spis)
=20
 	return 0;
 }
+
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr)
+{
+	const struct vgic_register_region *region;
+	struct vgic_reg_attr reg_attr;
+	struct kvm_vcpu *vcpu;
+	gpa_t addr, offset;
+	int ret, align;
+
+	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu =3D reg_attr.vcpu;
+	addr =3D reg_attr.addr;
+
+	if (attr->group =3D=3D KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS)
+		return vgic_v5_has_cpu_sysregs_attr(vcpu, attr);
+
+	offset =3D attr->attr;
+
+	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_=
base))
+		return -ENXIO;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	if (offset & align)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Access the IRS MMIO Regs. Relevant locks have been taken by the calling=
 code.
+ */
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write)
+{
+	const struct vgic_register_region *region;
+	gpa_t addr, offset;
+	unsigned int len;
+	int align, ret =3D 0;
+
+	offset =3D attr->attr;
+
+	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_=
base))
+		return -ENXIO;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	/*
+	 * Although the spec supports upper/lower 32-bit accesses to
+	 * 64-bit IRS registers, the userspace ABI requires 64-bit
+	 * accesses to all 64-bit wide registers. We therefore only
+	 * support 32-bit accesses to 32-bit-wide registers.
+	 */
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	len =3D region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (offset & align)
+		return -EINVAL;
+
+	addr =3D dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base + offset;
+
+	if (is_write) {
+		if (region->uaccess_write)
+			ret =3D region->uaccess_write(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len, *reg);
+		else
+			region->write(kvm_get_vcpu(dev->kvm, 0), addr, len, *reg);
+	} else {
+		if (region->uaccess_read)
+			*reg =3D region->uaccess_read(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len);
+		else
+			*reg =3D region->read(kvm_get_vcpu(dev->kvm, 0), addr, len);
+	}
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index fd3b9cfbc2660..944923121e080 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -764,6 +764,30 @@ static int vgic_v5_get_userspace_ppis(struct kvm_devic=
e *dev,
 	return ret;
 }
=20
+int vgic_v5_parse_attr(struct kvm_device *dev,
+			struct kvm_device_attr *attr,
+			struct vgic_reg_attr *reg_attr)
+{
+	unsigned long vgic_mpidr, mpidr_reg;
+
+	if (attr->group =3D=3D KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS) {
+		vgic_mpidr =3D (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
+			KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
+
+		mpidr_reg =3D VGIC_TO_MPIDR(vgic_mpidr);
+		reg_attr->vcpu =3D kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
+	} else {
+		reg_attr->vcpu =3D kvm_get_vcpu(dev->kvm, 0);
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
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 35eb048b5a0f7..736b538b40461 100644
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
@@ -389,6 +391,10 @@ int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu=
, struct kvm_device_attr *
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
 int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr);
 int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
);
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write);
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
--=20
2.34.1
