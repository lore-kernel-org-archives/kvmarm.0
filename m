Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013065.outbound.protection.outlook.com [40.107.162.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570FF43CE4C
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.65
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522987; cv=fail; b=EVhyPgO+1CaRVwzoG2LUsGKRx+OWKHOGDSuKTgDYIU9nES0JtMckZQH7oqlnMefAOxzp8URrh9fu1i2jLM3vd6bvr9TBHNY6WTx0PcTV817hFfz0tW+D+94/nl2IkBn7Nk7fMgknpvbLfPI5RCVGjD1e2tOHvr8miMzaNMZqKdA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522987; c=relaxed/simple;
	bh=ku0lSWMvqaq66phVxh1z8x++/CyQKmX1Y7FX4RydE08=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lc/+Z92tPDMhFe65VC3Ubq4oiVzl+ZOzFcLF4jluLbgGsuozO9WiD+xOSBl2itbEEvCDWpBZPb4hJxNQJDVjHa/O/N2qUdN+cW5Vjb4CdBigI9jVEVRS7HT+a2qq6IIu3+14GSyRIyBfhwPLG0d4/EknluT8yHr2c/9I/o1PTDg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=R2NoIpzI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=R2NoIpzI; arc=fail smtp.client-ip=40.107.162.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="R2NoIpzI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="R2NoIpzI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=q20PyvvSw9XwTqPq1Lcczi4y+GaMn1H+kVnL7/o7pGmQAg87XH/GBbAy2C4uNpYAC9+XqzSVmtuVrxfTUA3iP74fiOZSW1ySq/xlRKK4oHg0e8p3xNJFKoAkr9rXzj2vudh0ruAz3/FYwRhEAiSqHNeIupyJoJOZaYhYytQE23384Q35wPOOkSHMGmT9WWQeMBrvxD6QOPqa8TU0/Ied+CHEI+cj1LeevO+TheB1ttjsNGtZ3L4UTSkosrOzwRW+jj6HO5RAFvjtjdgR6aCU/3PZo7OYS65UsJVoOnGfUQmtR91xoS+d4nRNoFhh6e+bY5q0p7KshguhOj+LRhDzZQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DM4SrYGTT3FjMU5a3MY/RPo0BOUKnrgvpnngtSr3gE=;
 b=Q+KPze2OpOmEfSKxYqP4UyoOq16NXPTkfTjAmhESWuppJsHiJ4W86QJa710HDuV6vouEfKfuFeWlmTzGGENwBqflgQ9mUjKGrwVrabIGBk6yRR24qG3amEc94UIYuD+wbtxO08H53XiBDBObOzg8stcvwXcJuJnq1NVoxVze++1eY4E63KvnYTDvbZY30kQq4Y/gq5M2fayXWmejePRGdHd/wRFr/UXyQBb3Js/amtd/HhwjGcXnUm2NsUM1y0RV/xFMMwitnJ/NVC3tNudUgqk1fHxE2zcaMaw17d0Gpbw+X3eDD6MObKzFh6N9s2TLx560QjgLfrgY9ZpAJuUgqw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DM4SrYGTT3FjMU5a3MY/RPo0BOUKnrgvpnngtSr3gE=;
 b=R2NoIpzIHJ0aGdA60E8dZIUIOMjyfXr7nt0aPLSpklGs+ffVOzq97WHd8EO/eo4EBhxH1pAbJ3UwpclRhKtB0v6nHrST67TkZUKsnlF7ndiZ0UsqOtJ3b9GPxtsrVbeBEIu3n1gMAgYzHJD6rINCpmohmhSFPm5dvjUoQ9DRej0=
Received: from GV3PEPF0001DC34.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::2ea) by GV1PR08MB8619.eurprd08.prod.outlook.com
 (2603:10a6:150:83::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:56:11 +0000
Received: from WA1PEPF00009B3A.eurprd05.prod.outlook.com (2603:10a6:1d8::118)
 by GV3PEPF0001DC34.outlook.office365.com (2603:10a6:158:400::2ea) with
 Microsoft SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id
 15.21.382.12 via Frontend Transport; Fri, 4 Sep 2026 11:56:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 WA1PEPF00009B3A.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:56:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aX+EfyF+mOligBTfk8UcdsWjGlsW6o06FbN64FZutT65wnuVPBHyltxppOsenpEVJAZpOVxZXh9+sbegfLkx24V0OtKt5CUmBpa5b6wplc8B3+2WI5Z3Kjr5QeqIJUHr3Qr0oOUR+CJyHd1BR+gsZxy+L0MZHNaOd0omrddD419nBzq7+9yvm5gn2itXb7+6EyoRF92W2N67qnbMSi05/jRPgkapqyJzoo6nf0uqZ1aDsfXIYn79RC3p8U9N2AvgTtJKPRaT/jwyGjCDYXFoiwT06dLdEIB5FSTCx08wwicutqgFqZxABzRZuAwsyvlgOBk+rK/1xpOXS4GQ6C2CHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DM4SrYGTT3FjMU5a3MY/RPo0BOUKnrgvpnngtSr3gE=;
 b=B/v1LOMM+WKyq46wC7iRL7txVE6HKZ6wzzEL2sij52qx63/a15zYmsATzYSVNtwZLnwCgAiPgEWGItY4VY9X+1Nka95u1BNeWMGIfa/gfbNK2Me4N+wBqCmZR5a9LpeHG5a5nkGdIUV6q/GNGs9GX34pmvQb1C1jTDDPAA48Ys7kCwiERS+XqQx61GRKW2puNgi95LCJRBp/VUcwRGWUHyLHfO3p728Z6zqkjEaNZBeSkw21+nJ1c4Zx2FpdGasb5QBqIsHuFhSx/Y1jlSiYLdNOjyYUnn7QxEJjZHNKX0OK7Ab+bqhYYOHRQ0AvcgngzrB5bEOjS460BqoUEYTygQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DM4SrYGTT3FjMU5a3MY/RPo0BOUKnrgvpnngtSr3gE=;
 b=R2NoIpzIHJ0aGdA60E8dZIUIOMjyfXr7nt0aPLSpklGs+ffVOzq97WHd8EO/eo4EBhxH1pAbJ3UwpclRhKtB0v6nHrST67TkZUKsnlF7ndiZ0UsqOtJ3b9GPxtsrVbeBEIu3n1gMAgYzHJD6rINCpmohmhSFPm5dvjUoQ9DRej0=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AS2PR08MB10207.eurprd08.prod.outlook.com (2603:10a6:20b:647::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:55:37 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:55:37 +0000
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
Subject: [PATCH v6 42/49] KVM: selftests: Add VGICv5 IRS_REGS attribute tests
Thread-Topic: [PATCH v6 42/49] KVM: selftests: Add VGICv5 IRS_REGS attribute
 tests
Thread-Index: AQHdPGRNwCYOGJAQG0iOYZ727Cbm7g==
Date: Fri, 4 Sep 2026 11:55:37 +0000
Message-ID: <20260904113404.4051341-43-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AS2PR08MB10207:EE_|WA1PEPF00009B3A:EE_|GV1PR08MB8619:EE_
X-MS-Office365-Filtering-Correlation-Id: e4a02f3e-c593-4a2d-a15a-08df0a7b8355
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|6133799003|3023799007|22082099003|11063799006|56012099006|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 1MtSx32CFYKFSZepgFmkVdsXJYTXaM9uMRjV8jKPfN2T6Ko+GPqD4B6QSo33Mkosx8kPDRTqEs3+FJoFaSF6AhY/Jy0LYIQgg2/30YBhpTFZV3iXE3ww3FNHAY3kZZlKDzC7i5mwIhYSg1lNOiYssK1rgpr8KCkkomuMR2JgawwNsSnyX5gE+b+Jf3PFBD616LY/ZQWApQiKNLK/GRSnUPwhALJlax5lZHeVR7qIX3b+5jcgd99vCvkvz/HxyEuc8IaYeBfda77GeG9fEM2w1dDbAtMYpZKSLs+XMDtd6dVIyK9O62h7Lyo8jiViIU/JY+VoIBlhMtwtMxVK/NOoe5O5EF8DmVXzBs7DZMpCQDBGmOGrcPDo1jSlk0UdwMMcLczR1klgZOj2lPMl1b3PmUM2uW1Q6jM28NvFO8OrMrQPnZYj4KdRk4/7Pt3RaFXVm3NTqTg7NKWtdVO1gKS+P4tCoAJlVVHOG7I5qN7rvw7zX3v0oAYnpeJfvIiGcZm+7EIaGH1uzyFdFaUFEVma4YNZ1D+1NRA6aDgxzucvQiNt4ersha6YrSkL59VZ8ARhC5qmJd9nS66RmELGIMplwEWX19AfFbeOOvKJFmttv87M2OtEpL7SeGnU1odZzUsvtf2jji+bXOx6ExHaD5XKIWQh0NkznP9yjheHtJNMTtSkhHWOvZQlbOz1lhmvvtAYzu1w7goDIwST7JzVLGg1g0HjwlOMtAAZhscOHpE1d/c=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(6133799003)(3023799007)(22082099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gOdLcHCjteUO/dhx2Ih8c5mZbU9Jysv5OKHe3a+NC5QgMObfE+Ow7GBU5qN977kvu/375mMbcBz3jJxBctOVkitoxbfv8jwNHxN+qln0bNhJVC6r6LL0DpjyTCPGRxTimRIW03KZd+YR4H+jgOhzRzL+lzLO78q3820bwx2DCNE+2YFVxqOqlzpxghvHXO91dr53oVBRegnQXa2DVdKHHKFZDXwXTgS1VEZckNsYJz287SQxYBI/zPlitbkCagvjuQpSDJZGOafIrqf7GKrAA9VA/Y9gQsV+Fa3KVs543AXK7l7P2mtp9e5LVIO+s1zW+ivPVP9qRdy/sIcwB2vilg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10207
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 WA1PEPF00009B3A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	612b660e-fb8d-4906-18ac-08df0a7b6f85
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|23010399003|36860700016|82310400026|35042699022|3023799007|10067099003|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OTdXSONQ6yjg8V5NtDGUUJXC3kTQLKu3KnilddVfPnWhI1O8bhl9XKpA21nGr4VJw+OZ7+RtFEGDy+MQ3LLdwCN0bto3y8JsKFOXV8ZeaZEgwIXsPuWQ+ZloU7OqcSfnK5KnC8CVkoS5qqQqRpJ8FYjRe2J6pQKiBMzXLCNUZNhif7vdTVKxZh/MlUD6UGrwaFyUE9KvkEEmfC8L1Vk0Z0ltRGrpxGBpQMXP1HG46jsQ5yw2Oqum2DSIMfU72kiFKTwWvJcI7PIgYvv+6pM1DhWW6zBACZmM5kAOANOl6pz3EDA/K/C4efoh+bzMk0o+jQSv0b7Kqtr2d8zuLYEcq2uMdYm9P5hU9GVjXAF2lwKtBWPCtdTFdKoKSIoJoU81E8PBLB2t0bhc3LhCn81PK2wiy8sFIMB3azIwLiTskQfucdZQF+eZEEKiASqsJyJn9eUCPHPsg+yLAyg+eK0V1SkSxNvrYjmQdV51/sEY15XpEQyc8OTd6waVRa9Oo4Fl6y+JSgcW3X6UG3Xa4vuabmjNQQodu5sbivF8VzA/lUNSonnJ8kbUyiKFggEbXQY/staqJKCvp+z0S1iMQ3b+IiqZNhsFaB3jh8HgxjEjHHxsKnFe6eAEazsEVU3G9Qs1zvMREDkLGmypaHeFmE9IkYxmXphuhx7PwhFMupgQVL0=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(23010399003)(36860700016)(82310400026)(35042699022)(3023799007)(10067099003)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	snRacFqx8Jz7fl27YEkSWP+smLzeqVo3XVGYywe2kLxBqsHf0bTwev4Pp9z0qpwSGSgyGg+h9NnmjLXzHuPMHuj9A8N1idnpciolxjfa6NPISl8kXizdM/VUb0fCwOMCO0Ujm5iH4AoJI5rtd5vf99kg7CeanC7d0W9+VpSRMQjzayqaQjEi5ECi5+TOVyQtR2i7+8/tCeO0oQeo/oSXLdXKaJTbETRhisugatOkJrFxdYvmkQLnATqsXFkxYAx3hM26FFuQ+WbGm08qzqTmsNnNlZ07e923V1qm8QlYch8KCokdbmQK4MmhTUY8uhlGFOPVBMC39tsK9mdQjMs/P3mFFA1V74YdbLNv0Y2Anv/nhm7rku4NvPnt+fuao5dVxsVXUNT2URFWH3TPlcj7tqMEH+LXASV8enQAhfll6q80iHwhzeaUSAke/gLyN42Q
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:56:10.8501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a02f3e-c593-4a2d-a15a-08df0a7b8355
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	WA1PEPF00009B3A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8619

Add coverage for the VGICv5 IRS_REGS attribute group. Migration needs
a userspace-visible view of the virtual IRS register state, but KVM
must expose only valid registers and reject state that cannot be
restored safely.

Verify that KVM_HAS_DEVICE_ATTR reports the IRS_REGS group before the
IRS base is configured, while register reads and writes are rejected
before VGIC initialisation. Once the VGIC is initialised, verify that
all exposed registers can be read and their values written back.

Check that bad offsets, incorrect alignment, and bad userspace
pointers are rejected. Also check ID register restore validation, idle
status register values, and IRS_IST_BASER restore handling.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 260 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      |  72 +++++
 2 files changed, 332 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index bbcf0b5d2b22e..1166766dc7c97 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -18,6 +18,8 @@
=20
 static u64 max_phys_size;
=20
+#define VGIC_V5_TEST_IST_BASER_GPA	0x10000000ULL
+
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
@@ -110,6 +112,72 @@ static const struct vgic_region_attr gic_v5_irs_region=
 =3D {
 	.alignment =3D GICV5_IRS_ALIGN,
 };
=20
+struct vgic_irs_reg_attr {
+	const char	*name;
+	u64		attr;
+};
+
+#define IRS_REG(r)						\
+	{							\
+		.name		=3D #r,				\
+		.attr		=3D r,				\
+	}
+
+static const struct vgic_irs_reg_attr gic_v5_irs_regs[] =3D {
+	IRS_REG(GICV5_IRS_IDR0),
+	IRS_REG(GICV5_IRS_IDR1),
+	IRS_REG(GICV5_IRS_IDR2),
+	IRS_REG(GICV5_IRS_IDR3),
+	IRS_REG(GICV5_IRS_IDR4),
+	IRS_REG(GICV5_IRS_IDR5),
+	IRS_REG(GICV5_IRS_IDR6),
+	IRS_REG(GICV5_IRS_IDR7),
+	IRS_REG(GICV5_IRS_IIDR),
+	IRS_REG(GICV5_IRS_AIDR),
+	IRS_REG(GICV5_IRS_CR0),
+	IRS_REG(GICV5_IRS_CR1),
+	IRS_REG(GICV5_IRS_SYNCR),
+	IRS_REG(GICV5_IRS_SYNC_STATUSR),
+	IRS_REG(GICV5_IRS_SPI_VMR),
+	IRS_REG(GICV5_IRS_SPI_SELR),
+	IRS_REG(GICV5_IRS_SPI_DOMAINR),
+	IRS_REG(GICV5_IRS_SPI_RESAMPLER),
+	IRS_REG(GICV5_IRS_SPI_CFGR),
+	IRS_REG(GICV5_IRS_SPI_STATUSR),
+	IRS_REG(GICV5_IRS_PE_SELR),
+	IRS_REG(GICV5_IRS_PE_STATUSR),
+	IRS_REG(GICV5_IRS_PE_CR0),
+	IRS_REG(GICV5_IRS_IST_BASER),
+	IRS_REG(GICV5_IRS_IST_CFGR),
+	IRS_REG(GICV5_IRS_IST_STATUSR),
+	IRS_REG(GICV5_IRS_MAP_L2_ISTR),
+	IRS_REG(GICV5_IRS_VMT_BASER),
+	IRS_REG(GICV5_IRS_VMT_CFGR),
+	IRS_REG(GICV5_IRS_VMT_STATUSR),
+	IRS_REG(GICV5_IRS_VPE_SELR),
+	IRS_REG(GICV5_IRS_VPE_DBR),
+	IRS_REG(GICV5_IRS_VPE_HPPIR),
+	IRS_REG(GICV5_IRS_VPE_CR0),
+	IRS_REG(GICV5_IRS_VPE_STATUSR),
+	IRS_REG(GICV5_IRS_VM_DBR),
+	IRS_REG(GICV5_IRS_VM_SELR),
+	IRS_REG(GICV5_IRS_VM_STATUSR),
+	IRS_REG(GICV5_IRS_VMAP_L2_VMTR),
+	IRS_REG(GICV5_IRS_VMAP_VMR),
+	IRS_REG(GICV5_IRS_VMAP_VISTR),
+	IRS_REG(GICV5_IRS_VMAP_L2_VISTR),
+	IRS_REG(GICV5_IRS_VMAP_VPER),
+	IRS_REG(GICV5_IRS_SAVE_VMR),
+	IRS_REG(GICV5_IRS_SAVE_VM_STATUSR),
+	IRS_REG(GICV5_IRS_MEC_IDR),
+	IRS_REG(GICV5_IRS_MEC_MECID_R),
+	IRS_REG(GICV5_IRS_MPAM_IDR),
+	IRS_REG(GICV5_IRS_MPAM_PARTID_R),
+	IRS_REG(GICV5_IRS_SWERR_STATUSR),
+	IRS_REG(GICV5_IRS_SWERR_SYNDROMER0),
+	IRS_REG(GICV5_IRS_SWERR_SYNDROMER1),
+};
+
 static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -271,6 +339,194 @@ static void test_vgic_v5_nr_irqs_attrs(void)
=20
 }
=20
+static void test_vgic_v5_irs_regs_attrs(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 attr, val;
+	int ret, i;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	/* IRS_REGS attributes can be probed before the IRS base is set. */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+			    GICV5_IRS_IDR0);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+			    GICV5_IRS_IDR0);
+
+	/* IRS_REGS are not accessible before the VGIC is initialized. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IRS_REGS get before init");
+
+	val =3D 0;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IRS_REGS set before init");
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Read all supported IRS regs and write the value back. */
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_irs_regs); i++) {
+		attr =3D gic_v5_irs_regs[i].attr;
+		ret =3D __kvm_has_device_attr(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    attr);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS missing %s",
+			    gic_v5_irs_regs[i].name);
+
+		val =3D 0xbad;
+		ret =3D __kvm_device_attr_get(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS get failed for %s",
+			    gic_v5_irs_regs[i].name);
+
+		ret =3D __kvm_device_attr_set(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS set failed for %s",
+			    gic_v5_irs_regs[i].name);
+	}
+
+	/* Check bad offsets */
+	attr =3D 0x10000;
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IRS_REGS accepted bad offse=
t");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IRS_REGS get bad offset");
+
+	/* Check alignment for 32-bit and 64-bit IRS regs. */
+	attr =3D GICV5_IRS_IDR0 + 2;
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unaligne=
d 32-bit attr");
+
+	attr =3D GICV5_IRS_IST_BASER + 4;
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unaligne=
d 64-bit attr");
+
+	/* Check bad user pointers */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IRS_REGS get with bad poin=
ter");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IRS_REGS set with bad poin=
ter");
+
+	/* ID restore validation rejects unsupported values. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR0 failed");
+	val &=3D ~GICV5_IRS_IDR0_INT_DOM;
+	val |=3D FIELD_PREP(GICV5_IRS_IDR0_INT_DOM,
+			  GICV5_IRS_IDR0_INT_DOM_SECURE);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR0=
 domain");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR0 failed");
+	val |=3D GICV5_IRS_IDR0_SETLPI;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unsuppor=
ted IDR0");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR1, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR1 failed");
+	val |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, 0x7);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR1, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR1=
");
+
+	val =3D 0;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR2, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR2=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR5, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR5 failed");
+	val++;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR5, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR5=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR6, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR6 failed");
+	val++;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR6, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR6=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR7, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR7 failed");
+	val++;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR7, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR7=
");
+
+	/* Status registers read as idle through userspace accessors. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_SYNC_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_SYNC_STATUSR_IDLE,
+		    "GICv5 IRS_REGS SYNC_STATUSR is not idle");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_SPI_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_SPI_STATUSR_IDLE,
+		    "GICv5 IRS_REGS SPI_STATUSR is not idle");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_PE_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_PE_STATUSR_IDLE,
+		    "GICv5 IRS_REGS PE_STATUSR is not idle");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_IST_STATUSR_IDLE,
+		    "GICv5 IRS_REGS IST_STATUSR is not idle");
+
+	/*
+	 * Userspace restores IST_BASER without allocating or accessing an IST.
+	 * Supply a synthetic, aligned guest address only to verify the register
+	 * round trip.
+	 */
+	val =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+			 VGIC_V5_TEST_IST_BASER_GPA >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+	val |=3D GICV5_IRS_IST_BASER_VALID;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS failed to restore IST_BASER");
+
+	attr =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &attr);
+	TEST_ASSERT(!ret && attr =3D=3D val, "GICv5 IRS_REGS IST_BASER restore mi=
smatch");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -390,6 +646,10 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 NR_IRQS attrs\n");
 	test_vgic_v5_nr_irqs_attrs();
=20
+	pr_info("Test VGICv5 IRS_REGS attrs\n");
+	test_vgic_v5_irs_regs_attrs();
+
+
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index 41b698b3952f3..0ad6dcc3d510b 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -16,6 +16,78 @@
 #define GICV5_IRS_SIZE			0x20000
 #define GICV5_IRS_ALIGN			0x10000
=20
+/*
+ * IRS register offsets. Keep this selftest copy scoped to the offsets and
+ * fields exercised by the userspace API tests.
+ */
+#define GICV5_IRS_IDR0			0x0000
+#define GICV5_IRS_IDR1			0x0004
+#define GICV5_IRS_IDR2			0x0008
+#define GICV5_IRS_IDR3			0x000c
+#define GICV5_IRS_IDR4			0x0010
+#define GICV5_IRS_IDR5			0x0014
+#define GICV5_IRS_IDR6			0x0018
+#define GICV5_IRS_IDR7			0x001c
+#define GICV5_IRS_IIDR			0x0040
+#define GICV5_IRS_AIDR			0x0044
+#define GICV5_IRS_CR0			0x0080
+#define GICV5_IRS_CR1			0x0084
+#define GICV5_IRS_SYNCR			0x00c0
+#define GICV5_IRS_SYNC_STATUSR		0x00c4
+#define GICV5_IRS_SPI_VMR		0x0100
+#define GICV5_IRS_SPI_SELR		0x0108
+#define GICV5_IRS_SPI_DOMAINR		0x010c
+#define GICV5_IRS_SPI_RESAMPLER		0x0110
+#define GICV5_IRS_SPI_CFGR		0x0114
+#define GICV5_IRS_SPI_STATUSR		0x0118
+#define GICV5_IRS_PE_SELR		0x0140
+#define GICV5_IRS_PE_STATUSR		0x0144
+#define GICV5_IRS_PE_CR0		0x0148
+#define GICV5_IRS_IST_BASER		0x0180
+#define GICV5_IRS_IST_CFGR		0x0190
+#define GICV5_IRS_IST_STATUSR		0x0194
+#define GICV5_IRS_MAP_L2_ISTR		0x01c0
+#define GICV5_IRS_VMT_BASER		0x0200
+#define GICV5_IRS_VMT_CFGR		0x0210
+#define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VPE_SELR		0x0240
+#define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_HPPIR		0x0250
+#define GICV5_IRS_VPE_CR0		0x0258
+#define GICV5_IRS_VPE_STATUSR		0x025c
+#define GICV5_IRS_VM_DBR		0x0280
+#define GICV5_IRS_VM_SELR		0x0288
+#define GICV5_IRS_VM_STATUSR		0x028c
+#define GICV5_IRS_VMAP_L2_VMTR		0x02c0
+#define GICV5_IRS_VMAP_VMR		0x02c8
+#define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_L2_VISTR		0x02d8
+#define GICV5_IRS_VMAP_VPER		0x02e0
+#define GICV5_IRS_SAVE_VMR		0x0300
+#define GICV5_IRS_SAVE_VM_STATUSR	0x0308
+#define GICV5_IRS_MEC_IDR		0x0340
+#define GICV5_IRS_MEC_MECID_R		0x0344
+#define GICV5_IRS_MPAM_IDR		0x0380
+#define GICV5_IRS_MPAM_PARTID_R		0x0384
+#define GICV5_IRS_SWERR_STATUSR		0x03c0
+#define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
+#define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
+
+#define GICV5_IRS_IDR0_SETLPI		BIT(9)
+#define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
+#define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
+
+#define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
+
+#define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
+#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
