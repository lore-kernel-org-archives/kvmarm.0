Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010039.outbound.protection.outlook.com [52.101.69.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF723431E3
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375436; cv=fail; b=q5nKFYBFsmeRY5mPo0jXYHcBOAZ1qCb7GauZ5LDD2HbnPIBK5kmYqZfnPMh/vT8wrnVbQfPCTMgEH8u/dMV5nBP8RHaCLEE37Fw9ruayV6KR2LzqUghnXGX8tnYOs25/wcPdt/+OUmSMhKSYe72bzIItArKkqZmgoGI/x38uQVk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375436; c=relaxed/simple;
	bh=9jUs33nNBEuq5qRb97rqMQk37/UgGjBzy0BqNo/k6QQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jMW40IZ2n5iBLE5gs5T05dXXkJh0AzUuOmrO+vYCNh6SYbX4vGC5BSERsPWOmDH/qrHAN/yDz5ORHBNp4SS/9wslhGom9XSKxCK3vEHuBBm78r6U5hXGooKmo3Z5WDtYgMU02s2qbzZKb4BpIjf0o+yTdD+fLZuHbDQcxprpzvA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bG1whXLU; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bG1whXLU; arc=fail smtp.client-ip=52.101.69.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bG1whXLU";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bG1whXLU"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=NA77vgQLftnw4YLYwexyPe4H842NY9BFmuLmTRSFOcGPstkruWSBVwD1/5++PSJs5LwXHDEfZ653nXdfkAOUAEMGqNrbV1f/yPaPf5+l1G82XXVxpZVbv2pM0FR5ucwvRUd5ycu7aFOTu7TC1dj3dhM81KY0Q3tvxEF1l0dOflcFo8QXSjK6h49ik/fr0+NPvnKVfXOB4/P4Ln+pXRc869MzSqvFjK6l/3Wo+YMKq5syQkHM9h7oTrtF2tslGB7UPK92Fb/RXqJu29GEQ2wkZSXSAhVNaPmsn91lXPUDpnSFysynZl3iWgDzPx8yAnThknS3Ig1KAgy0CsCnnO90ew==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dxwi69EMDZyZOEwsMfzDYvEwYXtp+A/CRiwT1F4VuH8=;
 b=QZ6narBCDAicRkQ85OnFWASQ6D4XBa62yLqF4Zu08kxICYYNAwLNQAJpcnpqkc/e49TGJfZsR/rguRYFBBOTKT8oSiofngH623QFhjEXudw1yKvFPqNKnhwu4YPB4ItjzgSpvb7Ew7T9NFENM+7ezHw+lShj46IBQuXdA5zApum4bz1bqFIJ5+r9YyBJ9zqR4TD+jx1JBsXXZI1tJFutGqGY0P4g65k/OVk9SQEmDIswbv+S8LE7geVoOVEDDWrakKAJIgVAtLoSKocCypCj8UlCMKHBv5SwCGpANu7LS8X/tCtQ/InphK2dqFr5i1XKIq4IFpXCZzKee9Y6Eo57fQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dxwi69EMDZyZOEwsMfzDYvEwYXtp+A/CRiwT1F4VuH8=;
 b=bG1whXLUfSVhJForzgNZeZpvKYBQQP1pGNZI0LiZ4RELjoGriJEtCExm2Bm3eLc9YA+dggAHdKt7/qehoW/bXpDnv9A3UMzCX4OSwo8E8OYiwFBlDaR+g93kbLHg0vykS/lR2bw3RbV+n6vdvgle6YFCJsqyMYrbAhCNE6iqzig=
Received: from AS9PR05CA0209.eurprd05.prod.outlook.com (2603:10a6:20b:495::18)
 by GV1PR08MB7347.eurprd08.prod.outlook.com (2603:10a6:150:22::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:57:03 +0000
Received: from AMS0EPF00000198.eurprd05.prod.outlook.com
 (2603:10a6:20b:495:cafe::5d) by AS9PR05CA0209.outlook.office365.com
 (2603:10a6:20b:495::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:57:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000198.mail.protection.outlook.com (10.167.16.244) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:57:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CQYPFlAte3BVZ1sz0ASgjrQ3CRbDR/Bogs2l1PglkMNBT2EQboNYNqO5vLcVXTF6QwGmjm6Jy6u4HeMoFTnbHlyNg3OhDfaQIwjDRNrQ95YkK6hpsB/DO1Vbo9gstpovsB/VSq+nQ0S6N3AJw8SGUQ0T7ujOATMJhQ+14CKqiL4gulqJSq6r0/8ycF9fZ5diG44J0T8McsDorKcTcL4/7S7DBSVGYKv++Oel/n5G7hTVDUWRpTjKRvZf1/cmhnmALeVICesVkHxwHLGv+4dJEvDAFbrfz6jfxbrpsJS7t9PcVWixYVBz5Gqrc+23ffZlsU2k42XVEteMO0+mrLPfBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dxwi69EMDZyZOEwsMfzDYvEwYXtp+A/CRiwT1F4VuH8=;
 b=NL93FHdnl1FtM0ZmLm0NYd8naVSBs2U4721QwX0sMHU3SsoeYuU1eAIzk4Jt6dQ4bx5fstiOf1d8TGSEyk5KoCMn/w32QSFbJ3jIykYF/rOhbScFRkWszZ0cPtNt3Nn1CbSm3GoVkpSiHSBE/7Y3HVG/fCMuLhaWeLIp8hI8GLHdGgeaL9Ap8xoHf8dgYpMUMFHrpBedBKP7MjpoqPB3bIuUXrM4h1oGznRhjc+izlInNTIFsZ14nbxpF1i7cwHJsgEH7oqThxPWKNv8+pbaHuhXaEw8vM2lzsN00Sb0PwxDRhiCcVmBYvDV4cRnP5F5QULNAgJP2omNvsSoE9bZtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dxwi69EMDZyZOEwsMfzDYvEwYXtp+A/CRiwT1F4VuH8=;
 b=bG1whXLUfSVhJForzgNZeZpvKYBQQP1pGNZI0LiZ4RELjoGriJEtCExm2Bm3eLc9YA+dggAHdKt7/qehoW/bXpDnv9A3UMzCX4OSwo8E8OYiwFBlDaR+g93kbLHg0vykS/lR2bw3RbV+n6vdvgle6YFCJsqyMYrbAhCNE6iqzig=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DB9PR08MB11461.eurprd08.prod.outlook.com (2603:10a6:10:608::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:56:00 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:56:00 +0000
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
Subject: [PATCH v2 20/39] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO
 emulation
Thread-Topic: [PATCH v2 20/39] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Thread-Index: AQHc6THvxuzBkv/eHkqx1Ui6MPv9BQ==
Date: Thu, 21 May 2026 14:55:59 +0000
Message-ID: <20260521144846.1899475-21-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DB9PR08MB11461:EE_|AMS0EPF00000198:EE_|GV1PR08MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: f4c0c49c-0d8e-4caf-4121-08deb749379b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 wYw1mcqrnRyMQEvIR89S/BskQLuOXPHiuW0x1QtxrE588Lgr0YhIwhILjpUYvD775trJbFGI8yvwj9zp+9yXPKHGNVVP0kS0gOxO5SATaxc3ilkrEAi5r3HSpt5EtedyLeTXvmOa9RDA5iYSLt6U3VxVd42V1iyJhh3BqHsdxIWznXIH5z5WeaofUUXQxX53o/jCmQYvM8wuRY8/7Wjr492vkLoTzllJbAmPXcwpgEoLH9l2AhyZkbmGOTdwHJ/6bxPVRfwg9+mYCVzcT0e+V+yX1hJ3i6jzw0u3GgGe1cS4Ry0/HrAhRlTl3UgmNXAy9BDXiPFHr1KAWu9iabY5CT13yKf3fSvZ5GPCD7j9VUpJxKEtLc4xosjtpR9h56NROTHAIQBZ3qNSuYYq3wXX0rBfyrio30IblA4nCb9eFuaKVmn9CJV87XmY2bg2xpmPrdB8HIldVKcYMBgiUQzWXAWT3ttygDQzn5zXjXzmEzcpznd2cqyd8YULftkJg+CC8L1Df7zbw1p3z98tyIATiqeAJ3i6n0mNS3fR/Px1EKcpGKtzi+/sAYQpAQyIKrI5lyJHQTOlTMpqgJ8CxsrShMGkja+EeDH9iyfqcJro1DXJaZbBwP/P/oVVUFSUuahlF2k/Z3tfdRyIuDjlT5bGX/PMm8E9kXIG0NtIZM2S+39rXubRlvXb+/U9Vd+mEgKtcr6RYcQzmCrwQqtdOKmGGM/yp7vAHH37dxx35K85NtLMRlin7lKrWWei/6ywwReg
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 UhKhj7Xn9sZ46feJHG+5lwnmQR+4KE8jdm+1wqq2mw0SdFspBC2ouAbN5+eRVeOXg/yNn0oBHIQkx990abfYewtvHw0San/RuIOSnKJQHj82PqcIAaqXPk9M5eLfidVuHF9cYY385JR45e50FJHxficxc9ISdc80XuYy8G8p1WCT7Q3E43sOTYJuHzpGjJZ5hry2mjbZ3nOp6u1yyXarDArdgXDRP6mom+57NDRT3TyqV4zvCb8V6qyGxjKcuRKJJtdNSycIXGnHXK0loBDesRMXIdav7WW7FJEfck8FHdU9tJzI1I4mdaUlJ2+VoxA4rF9LFKKH5CjULol/fy7k2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11461
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000198.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d004cd29-26c7-4bdb-91b9-08deb7491241
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|35042699022|14060799003|1800799024|5023799004|56012099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	jfX23INNeKIxd7zFsRTxhvFcR+rIzyXeHEQnGs0r8mnFvIQ6anKmLCn8ZycRd1e7yh5AEVJz3gEr/9rnTkhrtNGOUHbGnldq4/7lD+Nw6w8gqncv5wUury+DUR9vLt3L2XPo6mK+93N+wmRd/CSGnJxBkm26CFFgK0j6Fwt3hrX0rZEMJmHuec7GblmptZ2n4h+JbuRvO9Y2UqPywDArEg8FdF7CHXA7aPcv1138ExdfzOKYoX/Ar0NvjiJc08Y37WNdfiB5JXWDPmUHdCo951zdtgL4/wt2euR+j1aAGu+jb4bExYRvEJOaR3svjkCzARFtU7NQikCqARMrAz95f92pOo76qFZG70KEstWHmPSswuhGrFRLjflmowaceFPEKWvalgKQuGiili6fc6kSSeUCFAKtBixZcrSILHjB8rcD7qBIQFizO/QDHI2tWfmZMZZgWkyO16I2Fn1ibnukrqQz2cO733i/3ktkqzIo69HoajcHmIWru7NUayIJrhlo4aFJ0hwdyBBK/iUOgFePmqxJ7dwUCIkEuyDFuo+F0OyXrBMKVoKK9v811WIgMIS2KGoI0FcC51CjuPNjUY9JzJy5UkJ+k2r98DPLw1qGBjshgNd74VEF9+VLO8ZwlD+pqUXMaN0oJgy95Yc15t7s047j+6v+1H/BlflHYgvHzbKoXSFvOEjDO6B7CuvRQBNXLDC8LnuV0NiOjuBsrFD3/M/2KUuFqZy65T5HvPr840o=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(35042699022)(14060799003)(1800799024)(5023799004)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	E1Sk0KLcbo4vucjgL9/SU3ioMhnmjsqEAsxvI9ME+67yf41tuq8kCrR4vLpLFrnnRtkbSIaBzBYGeDxqAaR+oLzrKYWRlhph1PeoOxh0LgQwuW5/SwUky2CqVpmTUfjb8vZrTMN7rNplBXpTHSwxxhuUmPrtdV9Lzl/jiTElw6OHF/VminOnTMxFhqTL6eLsUU2YopCe7VJJ0bk/5bGFj6duMpmCYkPVsvqY8bfwwPev5yiOBchnSYlO0Oue5pRlBfIO5hJNusWB2j4Pv+PeKffVNoVeIl0617dUdjny8/P6uXHgQ51l90/DylnAbPZcoRQ+W52yvsVwf9YhTdnAiZkuz9jGPx8UHgYjkf3IUy/KQOJIu1HHrJb/zyzL0xcJEKKxuG0ft8yqEj0iUK+XO8XpOhqNIhfQSHjs9w3t/nUYRTGW46jmBclqy2OoFswN
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:57:02.5430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c0c49c-0d8e-4caf-4121-08deb749379b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000198.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7347

In order to properly support GICv5-based VMs in KVM, we need to
emulate the CONFIG_FRAME for a virtual IRS. This emulation needs to
handle all guest accesses to the MMIO region, and mimic the behaviour
of a real IRS.

Introduce an IODEV for the GICv5 IRS, and an associated init function
that sets up the SPIs and initial state for the IRS. The MMIO
emulation provides support for the guest to query the IRS_IDx
registers, manipulate SPIs, configure ISTs, and so forth.

The emulation tracks selector state across MMIO accesses. For example,
a guest writes IRS_PE_SELR to select a PE by IAFFID. This is the VPE
ID for a VM, but the guest does not know this. If the guest reads
IRS_PE_STATUSR, KVM checks whether that IAFFID selects a valid VPE and
sets the V bit accordingly. IRS_PE_CR0 is accepted as write-ignored,
because KVM does not support 1-of-N routing.

The same selector/status register model is exposed for SPIs too.

When it comes to the LPI IST this also requires KVM to perform actions
on behalf of the guest. When the emulated IRS_IST_BASER is written,
KVM re-allocates the IST on the host, matching the guest's
configuration (from the emulated IRS_IST_CFGR) where appropriate. This
is then provided to the physical IRS via the VMTE. As far as the guest
is concerned, the IST it allocated is being used by the hardware, but
in reality the host IST is used instead.

This change provides the IRS IODEV as a whole, but this is not plumbed
into the rest of KVM yet.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c    | 757 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.c |  16 +
 arch/arm64/kvm/vgic/vgic-v5-tables.h |   1 +
 arch/arm64/kvm/vgic/vgic.h           |   2 +
 include/kvm/arm_vgic.h               |   1 +
 6 files changed, 778 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 431de9b145ca1..92dda57c08766 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
new file mode 100644
index 0000000000000..d1c724d0fd0b6
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -0,0 +1,757 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 ARM Limited, All Rights Reserved.
+ */
+#include <linux/bitops.h>
+#include <linux/bsearch.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/arm_arch_timer.h>
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+#include "vgic-v5-tables.h"
+
+#define irs_caps kvm_vgic_global_state.vgic_v5_irs_caps
+
+static struct vgic_dist *vgic_v5_get_vgic(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->kvm->arch.vgic;
+}
+
+static struct vgic_v5_irs *vgic_v5_get_irs(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vgic.vgic_v5_irs_data;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_misc(struct kvm_vcpu *vcpu,
+						gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct kvm_vcpu *target_vcpu;
+	u8 vpe_id_bits;
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		value =3D FIELD_PREP(GICV5_IRS_IDR0_INT_DOM, irs->idr0.domain);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_PA_RANGE, irs->idr0.pa_range);
+		if (irs->idr0.virt)
+			value |=3D GICV5_IRS_IDR0_VIRT;
+		if (irs->idr0.setlpi)
+			value |=3D GICV5_IRS_IDR0_SETLPI;
+		if (irs->idr0.mec)
+			value |=3D GICV5_IRS_IDR0_MEC;
+		if (irs->idr0.mpam)
+			value |=3D GICV5_IRS_IDR0_MPAM;
+		if (irs->idr0.swe)
+			value |=3D GICV5_IRS_IDR0_SWE;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR0_IRSID, irs->idr0.irs_id);
+		break;
+	case GICV5_IRS_IDR1:
+		value =3D FIELD_PREP(GICV5_IRS_IDR1_PE_CNT,
+				   atomic_read(&vcpu->kvm->online_vcpus));
+		/*
+		 * IRS_IDR1 encodes IAFFID_BITS as N - 1. The VMTE stores the
+		 * actual number of bits used for VPE IDs.
+		 */
+		vpe_id_bits =3D vgic_v5_vmte_vpe_id_bits(vcpu);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_IAFFID_BITS, vpe_id_bits - 1);
+		value |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, irs->idr1.priority_b=
its);
+		break;
+	case GICV5_IRS_IDR2:
+		value =3D FIELD_PREP(GICV5_IRS_IDR2_ISTMD_SZ, irs->idr2.istmd_sz);
+		if (irs->idr2.istmd)
+			value |=3D GICV5_IRS_IDR2_ISTMD;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_IST_L2SZ, irs->idr2.ist_l2sz);
+		if (irs->idr2.ist_levels)
+			value |=3D GICV5_IRS_IDR2_IST_LEVELS;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, irs->idr2.min_lpi_=
id_bits);
+		value |=3D GICV5_IRS_IDR2_LPI;
+		value |=3D FIELD_PREP(GICV5_IRS_IDR2_ID_BITS, irs->idr2.id_bits);
+		break;
+	case GICV5_IRS_IDR5:
+		value =3D FIELD_PREP(GICV5_IRS_IDR5_SPI_RANGE, irs->idr5.spi_range);
+		break;
+	case GICV5_IRS_IDR6:
+		value =3D FIELD_PREP(GICV5_IRS_IDR6_SPI_IRS_RANGE, irs->idr6.spi_irs_ran=
ge);
+		break;
+	case GICV5_IRS_IDR7:
+		value =3D FIELD_PREP(GICV5_IRS_IDR7_SPI_BASE, irs->idr7.spi_base);
+		break;
+	case GICV5_IRS_IIDR:
+		/* Revision, Variant, ProductID are implementation defined */
+		value =3D FIELD_PREP(GICV5_IRS_IIDR_PRODUCT_ID, PRODUCT_ID_KVM);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_VARIANT, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_REVISION, 0);
+		value |=3D FIELD_PREP(GICV5_IRS_IIDR_IMPLEMENTER, IMPLEMENTER_ARM);
+		break;
+	case GICV5_IRS_AIDR:
+		value =3D FIELD_PREP(GICV5_IRS_AIDR_COMPONENT,
+				   GICV5_AIDR_COMPONENT_IRS);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMAJORREV,
+				    GICV5_AIDR_ARCH_MAJ_REV_V5);
+		value |=3D FIELD_PREP(GICV5_IRS_AIDR_ARCHMINORREV,
+				    GICV5_AIDR_ARCH_MIN_REV_V0);
+		break;
+	case GICV5_IRS_CR0:
+		/*
+		 * The IRS is ALWAYS idle as we handle things instantaneously
+		 * from a guest's viewpoint.
+		 */
+		value =3D GICV5_IRS_CR0_IDLE;
+		if (vcpu->kvm->arch.vgic.enabled)
+			value |=3D GICV5_IRS_CR0_IRSEN;
+		break;
+	case GICV5_IRS_CR1:
+		if (irs->cr1.vped_wa)
+			value |=3D GICV5_IRS_CR1_VPED_WA;
+		if (irs->cr1.vped_ra)
+			value |=3D GICV5_IRS_CR1_VPED_RA;
+		if (irs->cr1.vmd_wa)
+			value |=3D GICV5_IRS_CR1_VMD_WA;
+		if (irs->cr1.vmd_ra)
+			value |=3D GICV5_IRS_CR1_VMD_RA;
+		if (irs->cr1.vpet_ra)
+			value |=3D GICV5_IRS_CR1_VPET_RA;
+		if (irs->cr1.vmt_ra)
+			value |=3D GICV5_IRS_CR1_VMT_RA;
+		if (irs->cr1.ist_wa)
+			value |=3D GICV5_IRS_CR1_IST_WA;
+		if (irs->cr1.ist_ra)
+			value |=3D GICV5_IRS_CR1_IST_RA;
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_IC, irs->cr1.ic);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_OC, irs->cr1.oc);
+		value |=3D FIELD_PREP(GICV5_IRS_CR1_SH, irs->cr1.sh);
+		break;
+	case GICV5_IRS_SYNC_STATUSR:
+		value =3D GICV5_IRS_SYNC_STATUSR_IDLE;
+		break;
+	case GICV5_IRS_PE_SELR:
+		value =3D FIELD_PREP(GICV5_IRS_PE_SELR_IAFFID, irs->pe_selr.iaffid);
+		break;
+	case GICV5_IRS_PE_STATUSR:
+		/* We assume that the PE is Online if present. Always IDLE too */
+		value =3D GICV5_IRS_PE_STATUSR_IDLE;
+
+		/* Set ONLINE and V if IAFFID selects a present PE */
+		if (kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid)) {
+			value |=3D GICV5_IRS_PE_STATUSR_ONLINE;
+			value |=3D GICV5_IRS_PE_STATUSR_V;
+		}
+		break;
+	case GICV5_IRS_PE_CR0:
+		/*
+		 * Make sure that we are doing something reasonable first.
+		 * Remember, the IAFFID is the same as the VPE_ID
+		 */
+		target_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, irs->pe_selr.iaffid);
+		if (!target_vcpu) {
+			kvm_err("Guest programmed invalid IAFFID (0x%x) into the IRS_PE_SELR\n"=
,
+				irs->pe_selr.iaffid);
+			break;
+		}
+
+		value =3D GICV5_IRS_PE_CR0_DPS;
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_misc(struct kvm_vcpu *vcpu, gpa_t addr,
+					unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	struct vgic_dist *vgic =3D vgic_v5_get_vgic(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+
+	switch (offset) {
+	case GICV5_IRS_CR0:
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+		/*
+		 * We need to make sure that the IRS coming online (or
+		 * going offline) is visible to all vCPUs, even if
+		 * they are currently resident. Halt all of the vCPUs
+		 * now, and resume once we've done the update.
+		 */
+		kvm_arm_halt_guest(vcpu->kvm);
+
+		vgic->enabled =3D !!(val & GICV5_IRS_CR0_IRSEN);
+
+		kvm_arm_resume_guest(vcpu->kvm);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+		return;
+	case GICV5_IRS_CR1:
+		irs->cr1.sh =3D FIELD_GET(GICV5_IRS_CR1_SH, val);
+		irs->cr1.oc =3D FIELD_GET(GICV5_IRS_CR1_OC, val);
+		irs->cr1.ic =3D FIELD_GET(GICV5_IRS_CR1_IC, val);
+		irs->cr1.ist_ra =3D !!(val & GICV5_IRS_CR1_IST_RA);
+		irs->cr1.ist_wa =3D !!(val & GICV5_IRS_CR1_IST_WA);
+		irs->cr1.vmt_ra =3D !!(val & GICV5_IRS_CR1_VMT_RA);
+		irs->cr1.vpet_ra =3D !!(val & GICV5_IRS_CR1_VPET_RA);
+		irs->cr1.vmd_ra =3D !!(val & GICV5_IRS_CR1_VMD_RA);
+		irs->cr1.vmd_wa =3D !!(val & GICV5_IRS_CR1_VMD_WA);
+		irs->cr1.vped_ra =3D !!(val & GICV5_IRS_CR1_VPED_RA);
+		irs->cr1.vped_wa =3D !!(val & GICV5_IRS_CR1_VPED_WA);
+		return;
+	case GICV5_IRS_PE_SELR:
+		irs->pe_selr.iaffid =3D FIELD_GET(GICV5_IRS_PE_SELR_IAFFID, val);
+		return;
+	case GICV5_IRS_PE_CR0:
+		/*
+		 * We actually have nothing to do here as we don't support
+		 * 1-of-N routing. The only thing that the guest can correctly
+		 * write here is 0x1. However, there's no way to fault if it
+		 * writes something else. This is effectively a WI in our case,
+		 * but we keep it here for the purposes of documenting it.
+		 */
+		return;
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_is_spi_selr_valid(struct vgic_v5_irs *irs)
+{
+	/* Invalid - we don't have any SPIs at all */
+	if (irs->idr5.spi_range =3D=3D 0)
+		return false;
+
+	/* Invalid - we don't have any on this IRS */
+	if (irs->idr6.spi_irs_range =3D=3D 0)
+		return false;
+
+	/* Invalid - ID is less than min */
+	if (irs->spi_selr.id < irs->idr7.spi_base)
+		return false;
+
+	/* Invalid - ID is greater than max */
+	if (irs->spi_selr.id >=3D
+	    (irs->idr7.spi_base + irs->idr6.spi_irs_range))
+		return false;
+
+	return true;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_spi(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct vgic_irq *irq;
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		/* Return whatever was last written */
+		value =3D FIELD_PREP(GICV5_IRS_SPI_SELR_ID, irs->spi_selr.id);
+		break;
+	case GICV5_IRS_SPI_STATUSR:
+		/* We assume that we can always claim to be idle */
+		value =3D GICV5_IRS_SPI_STATUSR_IDLE;
+		if (vgic_v5_is_spi_selr_valid(irs))
+			value |=3D GICV5_IRS_SPI_STATUSR_V;
+		break;
+	case GICV5_IRS_SPI_DOMAINR:
+		value =3D FIELD_PREP(GICV5_IRS_SPI_DOMAINR_DOMAIN,
+				   GICV5_IRS_SPI_DOMAINR_DOMAIN_NON_SECURE);
+		break;
+	case GICV5_IRS_SPI_CFGR:
+		if (!vgic_v5_is_spi_selr_valid(irs)) {
+			/* Fault with IRS_SPI_SELR; return 0*/
+			value =3D 0;
+			break;
+		}
+
+		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(irs->spi_selr.id));
+		if (!irq) {
+			kvm_err("Guest trying to access SPI not backed by KVM\n");
+			value =3D 0;
+			break;
+		}
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+				value =3D GICV5_IRS_SPI_CFGR_TM;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_spi(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	struct vgic_irq *irq;
+
+	switch (offset) {
+	case GICV5_IRS_SPI_SELR:
+		irs->spi_selr.id =3D FIELD_GET(GICV5_IRS_SPI_SELR_ID, val);
+		return;
+	case GICV5_IRS_SPI_CFGR:
+		if (!vgic_v5_is_spi_selr_valid(irs))
+			return;
+
+		/*
+		 * Find KVM's representation of the interrupt - we need to make
+		 * sure that KVM's view agrees with the guest's, else interrupt
+		 * injection won't work properly for level-triggered interrupts
+		 * (we fail to handle the clearing of the pending state if KVM
+		 * thinks that the interrupt is edge-triggered, which is the
+		 * default.)
+		 */
+		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(irs->spi_selr.id));
+		if (!irq)
+			return;
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (val & GICV5_IRS_SPI_CFGR_TM)
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			else
+				irq->config =3D VGIC_CONFIG_EDGE;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		return;
+	default:
+		return;
+	}
+}
+
+static bool vgic_v5_ist_cfgr_valid(struct vgic_v5_irs *irs)
+{
+	unsigned int expected_istsz;
+
+	if (irs->ist_cfgr.lpi_id_bits < irs->idr2.min_lpi_id_bits ||
+	    irs->ist_cfgr.lpi_id_bits > irs->idr2.id_bits)
+		return false;
+
+	if (!irs->idr2.istmd)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_4;
+	else if (irs->ist_cfgr.lpi_id_bits >=3D irs->idr2.istmd_sz)
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_16;
+	else
+		expected_istsz =3D GICV5_IRS_IST_CFGR_ISTSZ_8;
+
+	if (irs->ist_cfgr.istsz !=3D expected_istsz)
+		return false;
+
+	if (irs->ist_cfgr.structure && !irs->idr2.ist_levels)
+		return false;
+
+	if (!irs->ist_cfgr.structure)
+		return true;
+
+	return irs->ist_cfgr.l2sz =3D=3D irs->idr2.ist_l2sz;
+}
+
+static unsigned long vgic_v5_mmio_read_irs_ist(struct kvm_vcpu *vcpu,
+					       gpa_t addr, unsigned int len)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	u64 value =3D 0;
+
+	switch (offset) {
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	case GICV5_IRS_IST_CFGR:
+		if (irs->ist_cfgr.structure)
+			value |=3D GICV5_IRS_IST_CFGR_STRUCTURE;
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_ISTSZ, irs->ist_cfgr.istsz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_L2SZ, irs->ist_cfgr.l2sz);
+		value |=3D FIELD_PREP(GICV5_IRS_IST_CFGR_LPI_ID_BITS, irs->ist_cfgr.lpi_=
id_bits);
+		break;
+	case GICV5_IRS_IST_BASER:
+		value =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+				   irs->ist_baser.addr >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+		if (irs->ist_baser.valid)
+			value |=3D GICV5_IRS_IST_BASER_VALID;
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
+				       unsigned int len, unsigned long val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	const size_t offset =3D addr & (SZ_64K - 1);
+	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
+
+	switch (offset) {
+	case GICV5_IRS_IST_CFGR:
+		irs->ist_cfgr.lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_BITS, =
val);
+		irs->ist_cfgr.l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
+		irs->ist_cfgr.istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
+		irs->ist_cfgr.structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
+		return;
+	case GICV5_IRS_IST_BASER: {
+		bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+
+		guard(mutex)(&vcpu->kvm->arch.config_lock);
+
+		/* Valid -> Invalid */
+		if (irs->ist_baser.valid && !valid) {
+			/* Make the LPI IST invalid and then ... */
+			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
+				break;
+
+			/*
+			 * ... free the host IST if we successfully marked the
+			 * IST as invalid. Frankly, if we failed to make the
+			 * guest's IST as invalid, we're cooked because it means
+			 * that the IRS may still be using the memory that we
+			 * want to free. Hence, we leave it allocated and skip
+			 * the clearing of valid bit in the baser.
+			 */
+			if (vgic_v5_lpi_ist_free(vcpu->kvm))
+				break;
+		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+			if (!vgic_v5_ist_cfgr_valid(irs)) {
+				kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
+				break;
+			}
+
+			if (vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits))
+				break;
+		}
+
+		/* Now that we've handled the edges, update the valid bit and addr */
+		irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+
+		return;
+	}
+	default:
+		return;
+	}
+}
+
+static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
+	/*
+	 * This is the IRS_CONFIG_FRAME.
+	 */
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR1, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_SELR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
+				  vgic_v5_mmio_write_irs_spi, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
+				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
+				  vgic_v5_mmio_read_irs_misc,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
+				  vgic_v5_mmio_write_irs_misc, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
+				  vgic_v5_mmio_write_irs_ist, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
+				  vgic_v5_mmio_write_irs_ist, 4,
+				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
+				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
+				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/*
+	 * The following registers are only for running VMs. They are not yet
+	 * supported as we don't currently support nested, so expose them as
+	 * read-as-zero/write-ignored.
+	 */
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_BASER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_CFGR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMT_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_SELR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_DBR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_HPPIR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_CR0, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VPE_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_DBR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_SELR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VM_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_L2_VMTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_L2_VISTR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_VMAP_VPER, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SAVE_VMR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SAVE_VM_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+
+	/* MEC, MPAM, SWERR - all unimplemented */
+
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MEC_IDR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MEC_MECID_R, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MPAM_IDR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MPAM_PARTID_R, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_STATUSR, vgic_mmio_read_raz,
+				  vgic_mmio_write_wi, 8, VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER0,
+				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER1,
+				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+				  VGIC_ACCESS_64bit),
+};
+
+unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev)
+{
+	dev->regions =3D vgic_v5_irs_registers;
+	dev->nr_regions =3D ARRAY_SIZE(vgic_v5_irs_registers);
+
+	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
+
+	/* We represent both of the IRS frames back to back, so this is 128K */
+	return KVM_VGIC_V5_IRS_SIZE;
+}
+
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address)
+{
+	struct vgic_io_device *io_device =3D &kvm->arch.vgic.vgic_v5_irs_data->io=
dev;
+	unsigned int len;
+
+	/*
+	 * Design choice: Force MMIO region to be 64k aligned. Simplifies
+	 * pulling out registers.
+	 */
+	if (!IS_ALIGNED(irs_base_address, SZ_64K)) {
+		kvm_err("IRS Base address is not aligned to 64k\n");
+		return -EINVAL;
+	}
+
+	len =3D vgic_v5_init_irs_iodev(io_device);
+
+	io_device->base_addr =3D irs_base_address;
+	io_device->iodev_type =3D IODEV_GICV5_IRS;
+	io_device->redist_vcpu =3D NULL;
+
+	return kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, irs_base_address, len,
+				       &io_device->dev);
+}
+
+/**
+ * kvm_vgic_v5_irs_init: initialize the IRS data structures
+ * @kvm: kvm struct pointer
+ * @nr_spis: number of spis, frozen by caller
+ */
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis)
+{
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct vgic_v5_irs *irs =3D dist->vgic_v5_irs_data;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	size_t nr_spi_bits;
+	u64 mmfr0;
+	int ret, i;
+
+	/*
+	 * We (KVM) allocate an Interrupt State Table (IST) for SPIs. The
+	 * hardware mandates that lower 6 bits of the address are 0. Each ISTE
+	 * is 4 bytes in size (or larger if metadata storage is required), so 16
+	 * entries would be enough for alignment. Keep the minimum at 32 SPIs to
+	 * match KVM's vGICv3 minimum and the VGICv5 device API.
+	 */
+	if (nr_spis && nr_spis < VGIC_V5_DEFAULT_NR_SPIS)
+		nr_spis =3D VGIC_V5_DEFAULT_NR_SPIS;
+
+	if (nr_spis) {
+		dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq),
+				     GFP_KERNEL_ACCOUNT);
+		if (!dist->spis)
+			return -ENOMEM;
+
+		/*
+		 * In the following code we do not take the irq struct lock since
+		 * no other action on irq structs can happen while the VGIC is
+		 * not initialized yet.
+		 */
+		for (i =3D 0; i < nr_spis; i++) {
+			struct vgic_irq *irq =3D &dist->spis[i];
+
+			irq->intid =3D vgic_v5_make_spi(i);
+			INIT_LIST_HEAD(&irq->ap_list);
+			raw_spin_lock_init(&irq->irq_lock);
+			irq->vcpu =3D NULL;
+			irq->target_vcpu =3D vcpu0;
+			refcount_set(&irq->refcount, 0);
+			/*
+			 * The guest controls the enable state, and again it is
+			 * directly handled by the hardware. From our point of
+			 * view it is always enabled.
+			 */
+			irq->enabled =3D 1;
+		}
+
+		nr_spi_bits =3D fls(roundup_pow_of_two(nr_spis)) - 1;
+
+		ret =3D vgic_v5_spi_ist_allocate(kvm, nr_spi_bits);
+		if (ret) {
+			kfree(dist->spis);
+			dist->spis =3D NULL;
+			return ret;
+		}
+	}
+
+	/* Set sane initial state for the IRS MMIO registers */
+
+	irs->idr0.domain =3D GICV5_IRS_IDR0_INT_DOM_NON_SECURE;
+
+	mmfr0 =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	irs->idr0.pa_range =3D cpuid_feature_extract_unsigned_field(mmfr0,
+								  ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	irs->idr0.virt =3D 0;
+	irs->idr0.setlpi =3D 0;
+	irs->idr0.mec =3D 0;
+	irs->idr0.mpam =3D 0;
+	irs->idr0.swe =3D 0;
+	irs->idr0.irs_id =3D 0;
+
+	irs->idr1.priority_bits =3D gicv5_global_data.irs_pri_bits - 1;
+
+	/*
+	 * Support 16-bits of ID space for the IRS. This should be sufficient
+	 * for most applications, and the CPUIF is guaranteed to have at least
+	 * 16-bits of ID space support (we actually present 16-bits there, even
+	 * if the hardware supports more). Warn if the hardware doesn't support
+	 * 16 bits, and use the smaller value. YMMV!
+	 *
+	 * As for the minimum number of ID bits, we match the hardware's
+	 * capability.
+	 */
+	if (irs_caps.ist_id_bits < 16)
+		pr_warn("Host IRS supports fewer than 16 ID bits for ISTs (%u)\n",
+			irs_caps.ist_id_bits);
+
+	irs->idr2.id_bits =3D min(16, irs_caps.ist_id_bits);
+	irs->idr2.min_lpi_id_bits =3D irs_caps.min_lpi_id_bits;
+
+	/* Only allow the guest to create Linear ISTs - simplifies Save/Restore *=
/
+	irs->idr2.ist_levels =3D 0;
+	irs->idr2.ist_l2sz =3D GICV5_IRS_IST_CFGR_L2SZ_4K;
+	irs->idr2.istmd =3D 0;
+	irs->idr2.istmd_sz =3D 0;
+
+	/* We have a single IRS, only. All SPIs reside here! */
+	irs->idr5.spi_range =3D nr_spis;
+	irs->idr6.spi_irs_range =3D nr_spis;
+	irs->idr7.spi_base =3D 0;
+
+	irs->cr1.sh =3D 0;
+	irs->cr1.oc =3D 0;
+	irs->cr1.ic =3D 0;
+	irs->cr1.ist_ra =3D 0;
+	irs->cr1.ist_wa =3D 0;
+	irs->cr1.vmt_ra =3D 0;
+	irs->cr1.vpet_ra =3D 0;
+	irs->cr1.vmd_ra =3D 0;
+	irs->cr1.vmd_wa =3D 0;
+	irs->cr1.vped_ra =3D 0;
+	irs->cr1.vped_wa =3D 0;
+
+	irs->spi_selr.id =3D -1;
+
+	irs->pe_selr.iaffid =3D -1;
+
+	irs->ist_cfgr.lpi_id_bits =3D 0;
+	irs->ist_cfgr.l2sz =3D 0;
+	irs->ist_cfgr.istsz =3D 0;
+	irs->ist_cfgr.structure =3D 0;
+
+	irs->ist_baser.valid =3D 0;
+	irs->ist_baser.addr =3D 0;
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index 5c87c6c27087a..2df470d29d64a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -576,6 +576,22 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	return 0;
 }
=20
+/*
+ * Provide a way for the IRS MMIO emulation to correctly populate the numb=
er of
+ * IAFFID bits (which correspond to our vpe_id_bits.
+ */
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu)
+{
+	u16 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return 0;
+
+	return vmi->vpe_id_bits;
+}
+
 /*
  * Allocate a VPE descriptor and provide it to the hardware via the VPE Ta=
ble.
  */
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index acd862b8806d1..0ca0ae798dda6 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -90,6 +90,7 @@ void vgic_v5_release_vm_id(struct kvm *kvm);
=20
 int vgic_v5_vmte_init(struct kvm *kvm);
 int vgic_v5_vmte_release(struct kvm *kvm);
+u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f2f5fdc3211d7..282278e4a6c19 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
+int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis);
 void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
@@ -378,6 +379,7 @@ void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgi=
c_vmcr *vmcr);
 void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
+int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4d930a2651213..143e75743da86 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -40,6 +40,7 @@
  * in KVM for now. At a future stage, this can be bumped up to 128, if req=
uired.
  */
 #define VGIC_V5_NR_PRIVATE_IRQS	64
+#define VGIC_V5_DEFAULT_NR_SPIS	32
=20
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
--=20
2.34.1
