Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013010.outbound.protection.outlook.com [52.101.83.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75382312831
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375456; cv=fail; b=cuFyeEAbCJMLzawRc5RXl0jUpDx6LWUQguLygiclvCS/G/gasademz9ZcZhaPhF/v4hKVM8Y+KOSZJiHxL3pPU78xVXaDiugZMxBubKVmTbCsKlCQg8sqXJlpGArJg1AdW576JeDeBiUBB4FrkbMeVLUyfC4fU5QiJXmaaY7+9o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375456; c=relaxed/simple;
	bh=MlXSMAGvJr/BQ3wAAcezR2ndn5hsND4gGN6+0f0kdh8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LFHR1s9ekw54cXkxQ+In+5UrBEA4R4juqzbqOMI2vMo7q2z7XGGTXreCDGnhr2xk9acBbJRsAZioxXBxsXbhp9mJ5pGUGeZtjTMwvruiQsYGt2BUed8X7oNRBH+GYCGSySVwVWaxIHeB6W7PhV7fbl4IyWJgBOfL0T3ItxIcmn4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ab4sDXgh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ab4sDXgh; arc=fail smtp.client-ip=52.101.83.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ab4sDXgh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ab4sDXgh"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=Lilqbhd0daWTVIBTUCkxuKXis/NBxiRv2FFWtOoxQOBK1OmSIUZWR7SBkKlgsyugFMOJT0CL7UNSZL1nwzQJaXdeu/iDsTec0Z2ydmFMLXUfClpKOTjogVruBD9RlwkhEKtPQ8P7WTGIxawHsqHjBaOhODuZsLa5HolZ+/hxIRvpg4nmLen3yDCqrRt3P+P8UotNrRIteuC9C81TK9bh5DgmGCKpOowKgnUh9efLdEdphnAIcAwd5exDJp06IHs85odWkGQRL1K/kWgQ0RWVC67UNZsX9NTlc9bvozb8/xf18TziC6St+j1LV+geQx/cCSs9c492KEO82Huk5R51pQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZOegyqI4l4ayKk4z1c+ZpKe34P/BQY2fTrMHlD7jD4=;
 b=LMqE15bZpM0h8ClFwv5+qWlr360bhd4VKMxcDdJofNAY19VyA4qvdYLe/bqAsrtNU57hOU+tHP7IuVWxqK2Nm0AvCxHUBlZ4G5wxbVDUFD0S4Be+FDDtUoxZTslEBSKk1JcPt7zgguQKxbAQKo2eLjzwhlkDDC9EDW8Rjk3E5c6aCpKElCrog72e5tC/NAiAKOLw7g5IucRygCrXbSzKvxhHb3mBcPZLS3bsiqFp4FPYrKwy/aDeZtQ8v/zRpQL1CZH8GxqcQklfMJDLa64sQilxlPVi+Dgw1TnPAsp7cN0NcciS9YvFCBZzz5b6PDD4wMnPgvRTBKm6yfZp5t46+g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZOegyqI4l4ayKk4z1c+ZpKe34P/BQY2fTrMHlD7jD4=;
 b=ab4sDXgh9/4++3/BLYI+ABNElD5KE4/UllPlSNQKjoOc8cKKmtLxd4VYsOrD5K+0kKO4uwFpMDZbHGHNDeM7rYc5/pGjnjazMvUpJbRNIeS8iEotcAK0leccatPyvHCJRzppwirKkTb9zsUA4cibxS7UdxcCOeilmcxuem+EYUc=
Received: from DB8PR06CA0064.eurprd06.prod.outlook.com (2603:10a6:10:120::38)
 by DB4PR08MB9190.eurprd08.prod.outlook.com (2603:10a6:10:3fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:57:25 +0000
Received: from DU6PEPF0000B621.eurprd02.prod.outlook.com
 (2603:10a6:10:120:cafe::63) by DB8PR06CA0064.outlook.office365.com
 (2603:10a6:10:120::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:57:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B621.mail.protection.outlook.com (10.167.8.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:57:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bP1lP9QTM4EQXIQmw8v5icukPNKfKevEtpepxg5TebGOAdGN3OXeDAgJV3tBvo9HURgZnrEfCwuRwASkQFmi9nzwCO3OH+s36SjtD874JeUf1dzUppsfhy9pE9hx8DVdaAPeZ0B2+/Y4Ehuu1CzsTdScP7MR9rg0VZS4T6o5h4tO/v1DBkakzEj/TC3p67y9unqX/YZ1J18Juz2eMMUCPr2DCfcP+brEDPSpsTDrjWToM8Dtd1334oiRW+7udKYoScObukYdahQu0yi8rHA1k31IsveNolqtcM/0obv3pozkACg9kPKeUSSOL2IimqvcN9HC3e6dtDmYb/rDTimSqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZOegyqI4l4ayKk4z1c+ZpKe34P/BQY2fTrMHlD7jD4=;
 b=ehZgGY0AZqveOiAmFAQx9q0LifzN/18kw4O6UCPi4SucfSEKfZcWqkCv0XayPk7TZJxdN/0m6CIGNl2yF5M6I2sOelhM9Q6r78fZ9OBmMJK+JeVpvK+SRTBs3B60Yjm6Tg4EAttxCKHqfEKOFsWEJYqW0pUAsuxwLYvLDXgzZGIhdCeDiy6RHClUyhSUpM6AUqqd2YlZTZE9mgZibmPxHZVskTtuJn6iYLkoRmiAIJvhOSJVfy3ji7+2gzxWJBuF88iTkgjzD0/n9d6zfv5WmG3huJI6sEpx0yaqDJ9NwYt9VwXBqjdhZQRfdf06yvvp8o5MpDlGHnnMYYl99ylDEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZOegyqI4l4ayKk4z1c+ZpKe34P/BQY2fTrMHlD7jD4=;
 b=ab4sDXgh9/4++3/BLYI+ABNElD5KE4/UllPlSNQKjoOc8cKKmtLxd4VYsOrD5K+0kKO4uwFpMDZbHGHNDeM7rYc5/pGjnjazMvUpJbRNIeS8iEotcAK0leccatPyvHCJRzppwirKkTb9zsUA4cibxS7UdxcCOeilmcxuem+EYUc=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DB9PR08MB11461.eurprd08.prod.outlook.com (2603:10a6:10:608::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:56:21 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:56:20 +0000
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
Subject: [PATCH v2 21/39] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Topic: [PATCH v2 21/39] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Index: AQHc6TH81HoyGkGCsE6BaJWg0YuzXw==
Date: Thu, 21 May 2026 14:56:20 +0000
Message-ID: <20260521144846.1899475-22-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|DB9PR08MB11461:EE_|DU6PEPF0000B621:EE_|DB4PR08MB9190:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e81ec40-b776-47f7-83bc-08deb7494512
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 lMvcjvjm6+NmdjiXkJgxaerPwyECppaMiymf4cw94aKD76+f/DW3e9SL1GJqJXfNSPHHAR8iZWB4wh7iw2eM5WRmxcnLzVvzBQMO1wqXnJHxcppdXc6s5cd84c20ZATXSAKIo+t5vLklQ8Tzil1FjDhn1jNOHbqOslKONnG4UE9lHaC3fbUtWgJfM0OsAyE6R4sxpvWCVnPAPXGUmBIr0GNZzEJQ3mc5wQKEctwoJ7X6SAdGoH2cNDZCSfCIietZA7Wh0RLmhaRaptF9Oqmv2fnxyGsRjwuFVtVSaeCUM+Z92f6+qTjssnsEdh1+2TYG1kq9dfi4Me432A1hnhdsNXgfeGQ6NYp1J0qRxpGRdktAIlHXeB6tXIq/JA0+QWK1T2FjzM70/IosMbfzGn9na2Eo04BcHHGheDmBm9A2FTC7BhaFkYSrfe6DXYtskydM12E/oIOzllZuw2JMkX6wwTUL6SOGJJ6LRRO6StB4bmbPJVGZIlUth/rxGS4UVdzLfXMJuAvkhEWRmdE1hhzN3JneQSNVKXg/ZVYHCZmVsGwAqyDvuFg1pIt9i62iUdkuM1Pm2dwWvpUU2gJEgVi/I2ADjJvfJFPiPvCCYVr51qud50Y5XpsG1W4tObG64bYtheSWOs9m1gKfM8fgZq2ZbGy3HxDQTaJv/8jDQ86LLhgxFsIaj3R/5BGbtM0Q6K+HfSLCYJWE5ZVRMXEA0HV+3JmJOldn+/xf6aVdLpmZVZO0iUm2S8bI2FitnZAT2bok
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 shes0jaf8nayFXodjHYbkrrOfGECaTjW5r8g+w8EBt+xVAnEZ5rAyHzwTrQKmmhvZCvYUgyBF+sdiM0xGc7pOePYd96zcF5A4bmxAMv0jumlkQeZRisSTwhWogvQ/OTkIqZQinqHt2X+S8Fs/Csuk5pQ9qRaDPJyICgOKOvWoh0uE37OjtCLyYsgmvVQBtpdxd0gOo8fsQrhyRUu5l9R/arNWZeK5wTNfAUukHBxrlOr5k9toyGNtbBv6Qp7R4Ticim0dKOOT5jz1ZY11oJ/vUsAm38jNMuhKUCEGd9UOyAHUH7PNUsWa21qpR6MZomGXND7ZkrK5NNTKHhkGtyj7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11461
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e3a6dfcb-5a53-4b6a-bc09-08deb7491e8c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|1800799024|376014|82310400026|35042699022|6133799003|18002099003|22082099003|56012099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	OLu4ir48limxg9xlomRNQSAvJnL5NyDfXH3rGL1X6HLqtROAyEqEGNRBPbeAiPbAnKpYfRj0RAHWJO9dUv8kX0jB4ZbN+VmqjpwOaPkJFXe4Bx0o9zBuIjLt4TVQKjiE0cnt7XtCJA8NwDjfTMqB5fquYBmF3kXZ+bKuJppZmCPaPhM89QlHH8NjzJX8Tq41UnCX/efrrGTyHOGZh5aLdydhzsetbvRmYS/svBTjyoNMHonG7vOlhU0yNc7Wt77G/FdWnYxOMTPTzqMHEU69MaM7xnU/7tnGAH1xgSMkMxcRdK9RFDrCx13ieWHqWE7noCYV0yynZAC+L/uPoL7SPMuQrQlChgv5MmYMluaczN5eRuohYsJIUuFrLZD9owHauHpDqQhJC6br0JPZlZbklbKMlQWIToSheAVMusl4K4SI/B+g7u6R+epKueM9qieO0+ywem+xcg16/kgQ9g1etA0iaN1qwIjeIIKfw03hc1tCYAWMUcKnJ+Z5TyobXqlJdN12h/9kwlQPWQJzYaEB2IaqVicUqa896ejf/EH7HOvnQOuLZ5t/E1Ce64Sf7OIAUHCL5B4fBsz/xooKzeYXuUiT4XeiUDTW59VjiLgv2PaMQtHPnZr+V/t2ysqTpt79V3vA7QNYARNt7gwCdaiifjzb3wy25ATLX2ZD/IWwIaLS9lwjP6gdHjxpyFzlAooOF3Uiud6B4loZ71CM8JgQmyfhUp9uEkQrCGm6z2knihQ=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(1800799024)(376014)(82310400026)(35042699022)(6133799003)(18002099003)(22082099003)(56012099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BbJdFERTQCOE+fcjQ8M5tg2N+2PJXS0aLO0gzz8JQgX9S46W7ZR8kjNFSNQ6dxAy5dYsaAihtHDgxPzGks+FQTNl8v6ywOIQMS15ojLdzrtWmvLAxJJ1G84r/8d+b0JCz8HaieBnzzHHBEnxlW/3z17g4BZbspMly7giVA6CymxrDaIJnyZYwgOZUOnntmXeV42Znyk9ANLkS2C3hHgVr6K9IOi/5Naxy0ZxXY8Bp9YZZgsoOVtvCXEwOjonYWp9rnB+7NUMJtp8ZAq9hJ0d7x7frTWGQK05qQSOsBnFMQMAAnZgbgG8zDHeoThZWB03PGg0ECHMrmKyvtbTuFea9ER9mhxu4vZ4qeDBvZEKI8+WE6bS4+4n74KXM2AAiLYS6IzX0cLAqSt7/XgsA5+PLCbRTmHx7pHdIPAqJ3SIrg8cAlAKflNu05G1zSxY5hUu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:57:25.1448
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e81ec40-b776-47f7-83bc-08deb7494512
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B621.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9190

A virtual GICv5 needs an emulated IRS in addition to the host IRS
state used to back VMTEs, VPEs, and ISTs. Without this, KVM can only
provide the CPU-local PPI state and cannot expose the IRS-backed SPI
and LPI configuration expected by a GICv5 guest.

Allocate the per-VM emulated IRS state when creating a virtual GICv5,
and initialise it from vgic_v5_init(). If userspace has not provided a
number of SPIs, use the GICv5 default of 32. The IRS init path
allocates the SPI state, initialises the virtual IRS register state,
and creates the backing SPI IST when SPIs are present.

Keep the per-VM IRS object alive for the lifetime of the virtual GICv5.
vgic_v5_teardown() only unwinds resources allocated by vgic_v5_init(), so
failed initialisation can be retried, while kvm_vgic_dist_destroy() frees
the IRS object during final VGIC destruction.

This gives virtual GICv5s the IRS backing required for SPIs and LPIs,
rather than being limited to PPIs, only. Further patches add support for
SPI injection and lifecycle tracking.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 59 +++++++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-v5.c   |  8 ++++-
 2 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 94632fd90b728..aa883507d00d1 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -174,28 +174,48 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 			break;
 	}
=20
-	if (ret) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
-			kfree(vgic_cpu->private_irqs);
-			vgic_cpu->private_irqs =3D NULL;
-		}
-
-		kvm->arch.vgic.vgic_model =3D 0;
-		goto out_unlock;
-	}
+	if (ret)
+		goto out_free_private_irqs;
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
=20
-	/*
-	 * We now know that we have a GICv5. The Arch Timer PPI interrupts may
-	 * have been initialised at this stage, but will have done so assuming
-	 * that we have an older GIC, meaning that the IntIDs won't be
-	 * correct. We init them again, and this time they will be correct.
-	 */
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		/* Allocate a vIRS for GICv5 systems */
+		kvm->arch.vgic.vgic_v5_irs_data =3D kzalloc_obj(struct vgic_v5_irs,
+							      GFP_KERNEL_ACCOUNT);
+		if (!kvm->arch.vgic.vgic_v5_irs_data) {
+			ret =3D -ENOMEM;
+			goto out_free_private_irqs;
+		}
+
+		/*
+		 * Initialization happens later, for now just explicitly
+		 * disable the device and undef its base address.
+		 */
+		kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base =3D VGIC_ADDR_UNDEF;
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
 		kvm_timer_init_vm(kvm);
+	}
+
+	goto out_unlock;
+
+out_free_private_irqs:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
+
+		kfree(vgic_cpu->private_irqs);
+		vgic_cpu->private_irqs =3D NULL;
+	}
+
+	kvm->arch.vgic.vgic_model =3D 0;
=20
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
@@ -467,6 +487,9 @@ int vgic_init(struct kvm *kvm)
 				return ret;
 		}
 	} else {
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_V5_DEFAULT_NR_SPIS;
+
 		ret =3D vgic_v5_init(kvm);
 		if (ret)
 			return ret;
@@ -512,6 +535,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V5:
 		vgic_v5_teardown(kvm);
+		kfree(dist->vgic_v5_irs_data);
+		dist->vgic_v5_irs_data =3D NULL;
 		break;
 	}
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index b966495901cc4..f481191d72eae 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -661,7 +661,8 @@ void vgic_v5_teardown(struct kvm *kvm)
=20
 /*
  * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
- * doorbells, allocate VPET and populate for each VPE.
+ * doorbells, allocate VPET and populate for each VPE. Finally, we also in=
it the
+ * vIRS, which means allocating and making the virtual SPI IST valid.
  *
  * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
  * our conduit for communication with the IRS, which means we need to have=
 those
@@ -731,6 +732,11 @@ int vgic_v5_init(struct kvm *kvm)
 			goto err;
 	}
=20
+	/* Init IRS (and alloc SPI IST) */
+	ret =3D kvm_vgic_v5_irs_init(kvm, kvm->arch.vgic.nr_spis);
+	if (ret)
+		goto err;
+
 	return 0;
=20
 err:
--=20
2.34.1
