Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012050.outbound.protection.outlook.com [52.101.66.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232FC426419
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890457; cv=fail; b=PnkOF/kyxm/yAudmvz60qEgCbFgtY600U74Bz6UI0A8yieDjvUyWKrY4ntWqS4san/UoHIQssGXwvmX/6UZBMUyH1CWAWSv9XrQwpMdZ9P0/kIoI+A95TKWPsH8BjUd6eyvx+Otn+vyIwV8LDjzXEYhxu2kQM/p4UtzF8x9/xZ8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890457; c=relaxed/simple;
	bh=5bQ16C3mYUqq3TyZmvrYuZ2jh6Fjz12177R8P1om80U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hQT+6Panf6NhPMEdjfZBOyBlACmgFai/BaBw37L0yScxRqrTGApKHtAFD3qCJu75k7oiP4Gb7MvSGcP/QTC5ViQZ9S7NNZW0+M76ibYdeUL1oNDe6nOj9+HYKXOdehv+FXW9YGxMYdwJzPYrjtJw6QBIv96Kw15h0rj/TbExq3s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L6wf8dZd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L6wf8dZd; arc=fail smtp.client-ip=52.101.66.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L6wf8dZd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L6wf8dZd"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QqdKFpdPUXslIMH6LpApjdBoUdrdIG5Fr+ZET4ev3+E6/GmOREmoVvZ7oOP5rcLpQc2FDtH3gql0LTsxVrl5XRLaR5SeFXMNbh6AGP/0daa3odmJ1Ng2S4CD+4KYJ8wtvWomx3vb6yXtZkmQCVMJyDVW3pvruye+S7uvT1Rl+q92Ls5aLgMuhfkM0TGayeGRHHy46LvMOMLFdz6/Yr3WMWF1CriLxJkbzbKUU3t7M/R0QOVb5WpsdrNT91Wp9b77ssGRZotH4StmupUb3A4jcyf1+L42qt6sz4S04x5/KwtitbyDwU1VOerZ5GVMg5ssR3McAxsPwSXCLic9PQk9VQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6JGLvD9UQ4moaQWuc3E9Lr4qsKrEi84oCm6RUyH27g=;
 b=fV22iImJOz/7LDnEKct85wI6QJGC/HLCrYzBOIL15UCGnhwe8dftgZyd3fd7z2GdjrDDI9eVfQKISq2owLRU91d1fqMulP9YbFZr6KU+/vLqkbjKKib04Ga2S8j/kGPv+VrkkIa9KaF1VJ9Lzm333VJ9darZOQ9f+I/JGVfx7+mQv5ljdhU0QWnzSqnUgIlrNwoDnkA4Ds/q5XcrCA8WkCQcM2zuzwed4Qg/m54CsQsxAHrvNzDcPylZ6Lt5XGWSWmZ37PiyfRMXRfUuqIGvFySkjxXJtSVjoQ1962BGXKGqs/bxilc2FL2d5gVgxFCT2dl6RmVN5gxIty/2Ej78gQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6JGLvD9UQ4moaQWuc3E9Lr4qsKrEi84oCm6RUyH27g=;
 b=L6wf8dZdg5Tn0D6RweKn2JfEqkyczcASRs4zFtif4Zrjc7yfYav2/SLc2LVOY8Kvj2WACB8BO3Kp+ypw4yOy0+5dgIXx1IQYQd7xIE2tCr3i7M6V+5VNCgiazx8BShk2fYd2YnUWs5II/j3A7DPxVmaygsEUeVdQykCK+t7kGI0=
Received: from DUZPR01CA0251.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::23) by AS2PR08MB9270.eurprd08.prod.outlook.com
 (2603:10a6:20b:59d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:54:08 +0000
Received: from DB5PEPF00014B9B.eurprd02.prod.outlook.com
 (2603:10a6:10:4b5:cafe::4) by DUZPR01CA0251.outlook.office365.com
 (2603:10a6:10:4b5::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:54:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9B.mail.protection.outlook.com (10.167.8.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4UJaK83R6qbTxWxbRfOI+RIUyE+ctl6VAaOmwxEgxWw/BJKMduJgEaKyotGwe6vl3SOWhaHeneX5MqTBKyUIdhSD5x+yLBc9dTZ3usBgiT8A0Np20ZvlLbbXODRO75uP8pYJ9AwcxfMyLl6zE06ZVNRBMaZYHWkqeTk9H0Liy62xhENeh+UDmfZSCVLRV7VfDa+EWHcC8HH/onQGKEsfdgWoBtJSftUry9DuzLosgo5S6zdcgx/GdQK8SWZTsbeuJ8GC9DbFdu+YKhdVu25zwsW6yQmc6A3k1saIJi+oP3XqFXA7QRkdcW2rAit9Y2cjEDQRlrtd/ukwBG9+oXSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6JGLvD9UQ4moaQWuc3E9Lr4qsKrEi84oCm6RUyH27g=;
 b=w1yU2ym5OaU2WUlO/mlARJi0zvMUBgbhpeyYtr9xTgcl8yHqbk20nCNEbVsWguYJtEG76dum0ZqorvsX3gJZFIEfOc7R9CaHufgomD2aKinCmPeVsSW1kwZ22zj5qdApJRfOjxtXR/cq+wkjYZVw5RPJg9fdLqgQ1U8neMcs0bb+VlMGtDL2WGV/n1yu44NKsclvMz4mEwuccXDeoIzx7Z+1qsEgac8K+M5uobzOJNRXMHmHcOzeIqHP3sZfZ02URa9DPg8/3ejle0pZ1dEuxjSuTY+bm1svUGrE0h2c+wB/JHuYh76fUUUasg2UED4vPuP3/M0MjXtcETPhbtedsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6JGLvD9UQ4moaQWuc3E9Lr4qsKrEi84oCm6RUyH27g=;
 b=L6wf8dZdg5Tn0D6RweKn2JfEqkyczcASRs4zFtif4Zrjc7yfYav2/SLc2LVOY8Kvj2WACB8BO3Kp+ypw4yOy0+5dgIXx1IQYQd7xIE2tCr3i7M6V+5VNCgiazx8BShk2fYd2YnUWs5II/j3A7DPxVmaygsEUeVdQykCK+t7kGI0=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:53:03 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:53:02 +0000
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
Subject: [PATCH v4 18/48] KVM: arm64: gic-v5: Add IRS IODEV support to MMIO
 handlers
Thread-Topic: [PATCH v4 18/48] KVM: arm64: gic-v5: Add IRS IODEV support to
 MMIO handlers
Thread-Index: AQHdG1qZbPiW542MMUeq19kx9Zw2RA==
Date: Fri, 24 Jul 2026 10:53:02 +0000
Message-ID: <20260724104819.1296803-19-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|DB5PEPF00014B9B:EE_|AS2PR08MB9270:EE_
X-MS-Office365-Filtering-Correlation-Id: d897b440-8620-4544-3abf-08dee971e2c2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 0p+SitleYcuGkpKnimcec3QRmSxyExhKmMa3Mhj2iUlyCHcp5uELKHWIMt4J0Zg7uIcL9hnX6Vv8qyFThuQZ7SBHJyZUmZRNz7qTnjewtAs7DFCeTRN2z2EKGvH+FMALU5Wrzm0cR9LZ3CJzaPd4gs/MO2Okg0nYCm+HPGZ9CbF1RMUsc+kj6Qoyra2dMMpxIuuWk2c/XKCvH6s2beqW9wMWTW110N8tuBEw7WJTTYoPS2GlFy7WDIPZwjI1Zm0A7RC8N2SUey7t3VKPCXVWI8QY80VL4xd149FS6t4CDNAUMTubCHNX9gqZxRqwokrdLJEvFu8HVZrflQuBaBksp0FL7C3RG/oZamV6m/VQx6PEgXJLfEjKF600MIP2UoKYE9LjL+5Q/d0g7IiuQqLGI74kFcTFjrsU5rRwPmnyv8yb+xT4gjDvZwJh6corMAF0rNSTbH7lj72vLvVCZPEnCIcsExuXCPLmPKcbgRmuPsYYrg147faiNJWChSSiUeC/gZcPmJbytBYl3g9Ubi6kGf4N2A6MeYi0rq3mviCLjymcMGgVuQoqwyYlTQagZNY6Mt55zNLjcb28tmr2l0MzwJ+oFFleLU9Y+KENVaAgb/hlHgwJ9OZnZI+Uf7bMzYpQf2XC3/RDm3euIObXMM6p3O9RYgbaYjQ14E1k/7G9oAX3ExekTPr5c0J2IArfpXNNidXvrEPdi+9k33mLGftgQ58PrZIMBx2mQrnJOWPMDNc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 crA7TmuaBFV5fqpAq2e/7+9iP2DOolqF5gBsuX4qHL9vOWiT2l34P68z1zHtA6iwg1C2Vki3dX9Cpke0CXpQ0isXQXoNuW6T5QA4toooe8SMJtRXLPyZPYITEZPxnVyHgbwYAxp1b80P8xSGGmS9xzpOn+bDDVyCaJ+DP0g4gT6J4vfEwUqDPnvoIZuewzg0WzeNv0M/IojYpmatVnoo8WF2oadJRFazLXBYfVId6x1lmIwrm5rjyn3iHFhSI08dgkXMdqbp2c67hWUvNdkD8Oc+WlyfoUmZtR70Dc1mzxavbuw/Uu6lTVURnS8ARbBMIHG76WvLlYqBZINPqN61mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	792c6702-a07a-49d9-3e6b-08dee971bc1b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|35042699022|376014|82310400026|23010399003|14060799003|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	23VifTQgZd7KxtiiaX0tD4AYed4R88jnq4bnecw+LRjybxvxzaV3uvDX5PwBYDhoUjdlgUgqL/hyLrMfbgVc3M0awWb2Jv55vRSZAdn19WSE/dkb8mzjGAXXVgaFAMtFsYN4haDiLJpxpHtkUl9a1lmAsY1vTU5NmaMaqz2YGpj6NAnPMyCgoV4KpZMHAPplLeCJ9B19UjYP4Q4m3giCmZaDAHZ95GrYBUTeCJgbc0Ee37ylFKVVda4AlYPFXp72Re7JeRdX8CY4zfOpDT1qxxVwBJxVbp44Q7OKL7x5DnZy1xK63zeUff2xmCWHJstuG1yLbM37otiWXPyRhoI7D54jX5b94IoGjDfGuHCjIKEkRJmgjpsVeE6lNG25W7oQi5D+8KiTz9dglQYn4OeWpn+aFyPFbt2110sD+BQqN00TIPYQx5ZFr1wJSA0vy9aJ9gbqJ6npuvgah1aLwx013/eXAdybIZr9CB8IdcfMeC7PxsiB+VyuXE8oa8O/AHb+XRiJB6EtuiDan4VcawFZbm1Ig/fa5oor7RNOlWyigFNf67rqXvFwJejxhlhxGw1wRgDnhe6wqAx1xGhH3vh55HMdRQzbZjlxHryEKEkc0+MaRAGEXajK83/cPbJWm1+5LJcwxQBFiu5panVK7FFpEaYlLJCZyDJ9T8JYMwakoabEP90dknJLvmunvuQ8GKBH/XdGFYqBQ941Neiv6+6/mA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(35042699022)(376014)(82310400026)(23010399003)(14060799003)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IZYWE55EZmZ8PeSnEd2oudTFtkrCG8jH1DP/jbKvyhYesU5X9mCk7K+F+np6LoeyPbHFmlqViRr1Ch4qTq02/J8oQKj+neLNwEWq1svhudHJzF4kULAVmkkgNXG1xuzZgG4JdR1eqmI5e8Wtr0DCC1v4YxxpYVvLnDlZxljrh+4yCCq+xLwjnUggKjc9odDN0iZfczi2thx4pZ1ApJRL8CXoKE9hI+XAx9AbRs/ceYPQYk0e134sPRY4Zw6aibWPL3crHVJdiKQmclSYloi95ZkZ3yieP27fYIwrruT8QfUwOgCFDX84StCQ3CPRPLJa2c2u+7ul9bYKrp22bNBTyQZ+Zvw1LcAPcKbz0PCcgtH7tohK/Ej3sDeYR/EIDO+hvZ+iY3v1MxyFgpITAHJVZ6ylfG+ZVlf1zgqhh+VUkp7FmBwwoiNznHqB1nmfnhU1
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:54:07.6735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d897b440-8620-4544-3abf-08dee971e2c2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9270

In order to support proper VMs (that support more than just PPIs) for
GICv5, it is important to emulate the GICv5 IRS too. The IRS includes
an MMIO interface which is used to interact with and configure the
IRS.

As part of providing the emulated IRS MMIO interface in KVM, extend
enum iodev_type to include a GICv5 IRS device, and extend the MMIO
code to handle reads and writes to that type of IO device. This will
allow the creation of a GICv5 IRS IO Device in KVM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 6 ++++++
 arch/arm64/kvm/vgic/vgic-mmio.h | 2 ++
 include/kvm/arm_vgic.h          | 3 ++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index 74d76dec97304..fddb9da0403d5 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1065,6 +1065,9 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, =
struct kvm_io_device *dev,
 	case IODEV_ITS:
 		data =3D region->its_read(vcpu->kvm, iodev->its, addr, len);
 		break;
+	case IODEV_GICV5_IRS:
+		data =3D region->read(vcpu, addr, len);
+		break;
 	}
=20
 	vgic_data_host_to_mmio_bus(val, len, data);
@@ -1095,6 +1098,9 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu,=
 struct kvm_io_device *dev,
 	case IODEV_ITS:
 		region->its_write(vcpu->kvm, iodev->its, addr, len, data);
 		break;
+	case IODEV_GICV5_IRS:
+		region->write(vcpu, addr, len, data);
+		break;
 	}
=20
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmi=
o.h
index 50dc80220b0f3..38ed730d68ac3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -217,6 +217,8 @@ unsigned int vgic_v2_init_cpuif_iodev(struct vgic_io_de=
vice *dev);
=20
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
=20
+unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev);
+
 u64 vgic_sanitise_outer_cacheability(u64 reg);
 u64 vgic_sanitise_inner_cacheability(u64 reg);
 u64 vgic_sanitise_shareability(u64 reg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 25368c5cda5df..4d930a2651213 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -323,7 +323,8 @@ enum iodev_type {
 	IODEV_CPUIF,
 	IODEV_DIST,
 	IODEV_REDIST,
-	IODEV_ITS
+	IODEV_ITS,
+	IODEV_GICV5_IRS
 };
=20
 struct vgic_io_device {
--=20
2.34.1
