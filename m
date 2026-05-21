Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013023.outbound.protection.outlook.com [40.107.159.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB98B3043B2
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 15:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.23
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375763; cv=fail; b=s97p0zogbqJnxinlYJhlDNED9FJJkD+nLk20fjzfMwdeyj26hWLGybJ0VU5HN35XfPuz8+FyoXtHwpY3NmTFs+JmR3VHPyGvVdyxpXBL8B9T7we3reCZk7zPr5NX8NcuhAlxXB3xrq/m0xEax8B/NNhRoeCcjbqe1rCbJL4nVx4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375763; c=relaxed/simple;
	bh=9Pe6Wf0dQDzHpSnSvUjXpP7evrDDU268jkYvIYubAg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fbR7wRdlOOscs+72zJTUYEdtvr09Fti4J2v3wCcD1MlakADVhW4bON46GtmRfnUkZ7LxWsZNMaC3FHqcUrHDRZ3vCGQsfG9gWYOcSvndauoNbYpVOANQKnkSAGMZMFmRcmrzw8JFExv1T4XkNPv3mxewFgx0oQzQGnNiPXEEY5M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GAUUsoy1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GAUUsoy1; arc=fail smtp.client-ip=40.107.159.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GAUUsoy1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GAUUsoy1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=ZqBruIfmr7xr2chvc7zZOtT+t39AeRXqv8QYX2AKD9Rx2hwvIKL1qN7K2yf/FcFG6eospD9Br2Cmle8dtwJU05BjgC2lkmmcOdxZrj4p+0qmzWkiIzozvsvd7W7H0yg1pai+OtxTDXoWLjL2zBdYUzs6DNi048bmMw1850c8exqSvxtxTSH+R0/AFdlj+FxZQHe2ULxdFXkwAdOW7aM7qICX2EjvqHBNdXDVztbD9cTyhhjrFeJ6QmnCmRcwVaJnMXVDE9Wn6ecIbvUSONTJTh+9pwhcKWrxb2s/Vz44BP1ZyK12PWWjNYQ4YCKJFLoB4HPPQdkX8IvwsY5zYcE/7Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kniNsroNUZvoE7CJQ2Ui85bywor+LkVOSFyY1CFGM08=;
 b=rTj83oG5l2VFZJzNQHkm6apIhVVN5pATfKOTzHdtRviGVdPBfgPu+yCUnDVHxCpD4p9NNGSV2Jw7I8TL+Tg5mVS+JtOA1iocMfKHSGj72cmbTcAoZtf+VccDlxlpkml8LtITNr6TCgRHfSPmdhsrCRx3kKmTCCKq6nY2B/1gldlK9lozVHs3CVMkN1s+SgmG8J+5sTyCdA45cl3eNWWw9tNY4vKp+KxO9QcyZKYwL7ZeIEJNIaq/xBFZ95e3Yd409uHgFSJIti/5uwezzFARDx2tbttIPH63AgNhGTWgcwkTdQVTf4fOivScL2GUy9jYIBLlGSfJN+oEArqvOs196w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kniNsroNUZvoE7CJQ2Ui85bywor+LkVOSFyY1CFGM08=;
 b=GAUUsoy1Gsltx/eJj1qBIx/famy6dK7VN6MrIEzzMMTHGnTbYAoLvncNawkvv9iV/TtS7vQXnxnkXeNETBMFmlrHfkhXEyjimbtlE8VJ0jrQVKQM2Sc8HOWR2hOQQpUwTjJn80f8mU3o5GovDv6GesbWYm5GWwmPx2PpTriXGwk=
Received: from CWLP123CA0139.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:87::31)
 by AS2PR08MB9668.eurprd08.prod.outlook.com (2603:10a6:20b:604::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 15:02:36 +0000
Received: from AM4PEPF00027A5D.eurprd04.prod.outlook.com
 (2603:10a6:401:87:cafe::2e) by CWLP123CA0139.outlook.office365.com
 (2603:10a6:401:87::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 15:02:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A5D.mail.protection.outlook.com (10.167.16.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 15:02:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gAic0U+eOncKhCama3joHDNysdCiqcgES2DQPuZ01cokW6kP4vriGWAhcN0ggRpHNhq9yCDDURZVkiOAlAqJNDmMeSrULeHOxtVkf2ix8JyUbfOtwZndEWuYsVjnSf9nwpg6y89JFF1P70658IL6QmKPx1FvkW1P9ImqPOlnFgNAn41wML0dH2TcNygl7vZ+n/LpUJITzxT/RSCeVHagwWEeq2K18HEOhsF4DwICBUoRjQzZ+XadIl3A+tctyRV2FSoTsNfG8CpyvRwJKkUlTf+Bvv2kyqUMsT1YUgdqLjPIhbE4aBMyndvun5N5TmvxGhP8fxcaXIcpe2RiiEGuww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kniNsroNUZvoE7CJQ2Ui85bywor+LkVOSFyY1CFGM08=;
 b=Kwr8qG3SuJukLz/lgz2m5tGyQFeNCbUSsbxNP9L5TsvNLiFHLRRgqNp7pA6YxolT/NYwd1Xlw5kPrBAQoUFyyqQzzUy4F6mCWzO0X+di3FipW6I0hk++9+NbcBw0FyOSIAZPq8nFOVc5l/GLBmv1Rbx7Em3x7vA4doHcpJUsBVwi2sdDzIzuaQ6MQzkGwHvmwiu95Zc3J69nU4S/nreRCHymVWKLTz4IeRBhJpVXx0BqDunfYb03kl5HmU6HQkuMelEICKZzTIgDrOOyIPixhCXbz54IYydFE8AUlfJxzIJ2XQz8g2FD9YB/8ZYdWowLl+o1wadjaj+IM4QK5IvhSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kniNsroNUZvoE7CJQ2Ui85bywor+LkVOSFyY1CFGM08=;
 b=GAUUsoy1Gsltx/eJj1qBIx/famy6dK7VN6MrIEzzMMTHGnTbYAoLvncNawkvv9iV/TtS7vQXnxnkXeNETBMFmlrHfkhXEyjimbtlE8VJ0jrQVKQM2Sc8HOWR2hOQQpUwTjJn80f8mU3o5GovDv6GesbWYm5GWwmPx2PpTriXGwk=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DBBPR08MB6204.eurprd08.prod.outlook.com (2603:10a6:10:1f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 15:01:32 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 15:01:32 +0000
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
Subject: [PATCH v2 36/39] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Topic: [PATCH v2 36/39] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Index: AQHc6TK156iyzCJJpEGEwfjHuedEaQ==
Date: Thu, 21 May 2026 15:01:32 +0000
Message-ID: <20260521144846.1899475-37-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|DBBPR08MB6204:EE_|AM4PEPF00027A5D:EE_|AS2PR08MB9668:EE_
X-MS-Office365-Filtering-Correlation-Id: e723877f-91a8-40f7-f0f3-08deb749fe42
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003|38070700021|3023799007|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 NayhqHjuUwPA0ppPDUgWa0SA1lEyFlsr681SKQi0FdQkw0VZqs2dGDTx7j4s5bI0fntTvx52wU0qOvLkmDmRtbdwMyIfwCJhSmSUDmsXbu8eeOUuc0llf7wVJ4mw2gpZ6q3r2Ulv9hLyzjjOQRBqLdEZb7kovl4ZRe6eKBM7U7pnlAA73rw/ZuMuD1dffCqA59Ljii7SLzUqDJzHVhHfWjqdL2PuhIxxNZ840/rVd1K8/bdItqbjq8JW6SjLn+4xwnNdTgbxALxLQVSoqHVBkl0pTB0Q9+HKF7gOjZpk5HKFbuwFDmBTNtlRd9WRVoaaO8Q6/tGu6TQYqsqzGXKtxCz7ZPguk+u2HlvAchRtX797N6N/BbC6oQ4k1DUwkq9gBe5+iFJcfHEaccI8V5mYpoQH7gDM9KnZ2xhkrFrlQ59Tuwu78DnKbUG5hBIS4zw82ACCZJcd21LmBKAvjVGijtBlzIj34fGebGcJSxf+/Ob/Rh7hr4r39XeNxwHadbjDaZtGqDQCreZ5+NBXvq0j80ZuQjz6QO8ZWQcg54c3zpCVY61JsSLm8qt/g/Gp9EoeJvw8Or8AVzUQj+z+EXZSxpU29vZT9F5xCGHEIi7sGlKs4o2v0SzCDa1DtrzQSQITFWNxfSoHOnEiAlDC7ei6npRGNOwQpA2Uds7+I5+0rovltQjC7UPbAn6H4kyjEhTi4RnJUUOqT+KU+4jzlCc5lGYxHdTSx2DZ8F0jjY4BsfrbRY3mGUxqVIGv39c9/8Bu
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003)(38070700021)(3023799007)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 chWR3zS3JCFo46PGt7d657ApgSXDCd3SIBDcwlaJ1p/7UP1z3xouNa+DMpBtsUvfScRNUi5VhjfRZ5wIAPWCeDmvg4GaDn+ArbtjQIlkM/EQV5xOhc5dLxK3kIzNh5IBLcsacHu4hHw5nKTXiVsFHevSTek6lQTOyGTzZVFDqPoLdHQhRXDF5Ij+XuUyoVxnyp/H5cLEkONuS9BNJLMB4S5CMB6XLkesDaGKrxMj7fx7O/covv31dT9GnKZG/D+1+N++Ny8gaTwQxj1yAMBw0LBRDvkv52jhWpXgVYb+RFgAZNy77PNhTC7fkrMYBef8ZJk47MC47/lm3dH0SABBjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6204
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	54de4875-b2c4-4807-c4af-08deb749d891
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|35042699022|14060799003|376014|36860700016|56012099003|22082099003|18002099003|3023799007|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	IEHcyhnonQ8EnTFlLBZHlTqIxHrW+O/RefMjMVJQaU24VBfVfv3T6LvxUhbduYq3v/5xfWllas9PH/eQp53B/OsnHAjuktGr8nqzkXtmEg3qRdgXsfhglMA+WxqdZjPEZcey32+OlxpY4PQppL0MZw93oHu/GiLoDdE5V1n0J506CI3EFcs4sQtkYpJv7d2uWJEYQGB0ZzDMjpPwNgWjW9eT3bk829qUQ/7fD+6LopwPX2t1O7X6cR5bpY6HYYlu0G0hnPogh8gMvyXe1QftmS6BZa7++MLnyJRHqA6XY/5wr0tdstUE4Rzx4PecnegyUbVcSBF3e5uJKkkLkbr6sOWIz/kU6AjhqtlIhNUfTRqhre6VKvrpvNUZSksHGq/2uEr7cgLAON70Z8YM2Vgef77WXcuY0Kfs8fNjGUXfSfB2dhopLTrqmGverIYd9kDty5VvD+9yBcwZBdcCqyQjCmqcMBUMrJRDv4HOJb2lvjv83kk3dvqYlRlxntCtml34Fq6a/pBelDrJ8IC+0N43sZUCtwOfFgEso5HH+kcttt0Ok9ldaRDbl8e6FyLJBi6O6ExLKasVqTNJM63adti8JsaZVySoDx1/J4L4iA4uDmfFtoS+/80Q9YwpfPopZYkV/EsKoFuy/pAWFL/Ysc/aUsDZUCEmou7aC9ZOBHXlXusH5gz40Ftrrkp6os12+K8TT1P7MbXn1JIeCwDjR2nsyi51F272h4iv5m8vb1l6lJk=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(35042699022)(14060799003)(376014)(36860700016)(56012099003)(22082099003)(18002099003)(3023799007)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4fiWSUaDxQHHu4xhoxLmq2SHlth1IAjArt+LFmWqP0mPE/ap4ey1wMFQbFoT0TAfwHHVKrDZLwA7wYaU2aXal2R3PKE54cd3YCL7Iwz/CJbK/iqTys9GRiYiMPm/qq83Zd7NohNQbmUZZLCWjA7CPfu0fbv2fIsGFEKMl+uE3XX+PF8+O0maimh46x6+ydxeeRTcjbmdGaV+Ij0mydvrv5svveVEL9wVRpPxiiCLtfVsa4ZEUWrlA9mi+cTpE+34khleG8p9xSA8g7DRXglIl0zAHWm8K6Lg6+XaE2ozFBa8wF4yZChzDN9fNY4nbV+kIPlwUwaenb0WpZjRqrYc/4wKi0V6BUEUhlVblOkN35iAjbA9XxMl1VkzVTBfvVdHvxafd3Bv0jFHsTF/vFl8+Ie9yASMkav5jb+oBDDqz3t8L2xpsAPiR8a/FnVj3SV+
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 15:02:35.8527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e723877f-91a8-40f7-f0f3-08deb749fe42
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9668

The virtual GICv5 adopts the same mechanism as GICv3 for userspace
read and writes of the system registers, albeit operating on a
different set of registers, of course.

Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for GICv5 in the VGICv5
documentation, explicitly calling out the registers it operates
on. The main body of documentation has been directly copied from the
VGICv3 documentation as it has identical operation.

One key thing to note is that for two sets of GICv5 registers - those
pertaining to Active and Pending state - the operation of the
interface is different to how the actual registers operate. Both of
these registers have C and S variants (to set and clear bits) in
hardware. However for this interface, we ONLY implement the S variant,
AND treat it as a raw write. This simplifies the act of reading or
writing the state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 5c6323d82f784..e2045b09f27d0 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -75,3 +75,69 @@ Groups:
     -EFAULT  Invalid guest ram access
     -EBUSY   One or more VCPUS are running
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
+   Attributes:
+
+    The attr field of kvm_device_attr encodes two values::
+
+      bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
+      values:   |         mpidr         |      RES     |    instr    |
+
+    The mpidr field encodes the CPU ID based on the affinity information i=
n the
+    architecture defined MPIDR, and the field is encoded as follows::
+
+      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
+
+    The instr field encodes the system register to access based on the fie=
lds
+    defined in the A64 instruction set encoding for system register access
+    (RES means the bits are reserved for future use and should be zero)::
+
+      | 15 ... 14 | 13 ... 11 | 10 ... 7 | 6 ... 3 | 2 ... 0 |
+      |   Op 0    |    Op1    |    CRn   |   CRm   |   Op2   |
+
+    All system regs accessed through this API are (rw, 64-bit) and
+    kvm_device_attr.addr points to a __u64 value.
+
+    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS accesses the CPU interface registers =
for the
+    CPU specified by the mpidr field.
+
+    The available registers are:
+
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+    ICC_ICSR_EL1
+    ICC_PPI_ENABLER0_EL1
+    ICC_PPI_ENABLER1_EL1
+    ICC_PPI_SACTIVER0_EL1    ICC_PPI_CACTIVER0_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER0_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SACTIVER1_EL1    ICC_PPI_CACTIVER1_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER1_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SPENDR0_EL1      ICC_PPI_CPENDR0_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR0_EL1 are treated as RAW writes=
 of
+                             the underlying state.
+    ICC_PPI_SPENDR1_EL1      ICC_PPI_CPENDR1_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR1_EL1 are treated as RAW writes=
 of
+                             the underlying state.
+    ICC_PPI_PRIORITYR0_EL1
+    ICC_PPI_PRIORITYR1_EL1
+    ICC_PPI_PRIORITYR2_EL1
+    ICC_PPI_PRIORITYR3_EL1
+    ICC_PPI_PRIORITYR4_EL1
+    ICC_PPI_PRIORITYR5_EL1
+    ICC_PPI_PRIORITYR6_EL1
+    ICC_PPI_PRIORITYR7_EL1
+    ICC_PPI_PRIORITYR8_EL1
+    ICC_PPI_PRIORITYR9_EL1
+    ICC_PPI_PRIORITYR10_EL1
+    ICC_PPI_PRIORITYR11_EL1
+    ICC_PPI_PRIORITYR12_EL1
+    ICC_PPI_PRIORITYR13_EL1
+    ICC_PPI_PRIORITYR14_EL1
+    ICC_PPI_PRIORITYR15_EL1
+    ICC_APR_EL1
+    ICC_CR0_EL1
+    ICC_PCR_EL1
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
--=20
2.34.1
