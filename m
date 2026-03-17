Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012032.outbound.protection.outlook.com [52.101.66.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB9B3B0AF5
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748219; cv=fail; b=D6lvhRMT5p5seXXopdmrhm27D+GYPXNOp/9sSm1qESfJEid6uNl5nt9M0KOF7O+YFZKawrxADNZreNCYYYZ3LKDNvtn3TdpQ1v2OisOx0utr6CJGHsLpPnEj93l1s6OzFVKiiSfElzjvF3sqyOeI30a42dd7WSnBk+eBo8K19Go=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748219; c=relaxed/simple;
	bh=FhjcDFys+MBoTUiOJtwFNRwOykYQbCc9Q43GGEEY7eU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u6RSSzr1MlNej4GAdS06GND3cKPSAJ87bIErCLgoPXdIQ5vCPh39B3iaqgC0tRnfiIIdnCSUfqbmlycjh0ZOCYB+z7P0bzpXtVss8HDoYLNuWFE8sN49DW+L81WNSay//05sN8/JmW3YIPD3vlro4FimjlkoWmX2HhWuYhBRPBc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UyolyhUW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UyolyhUW; arc=fail smtp.client-ip=52.101.66.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UyolyhUW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UyolyhUW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZaCcLoFVO0eiboDF446RQ0kj+JguVsgc45ClkH0zkA/xp06PaStDxwWUnYnQMYRknx7I3UXXQXWRoEkrMU+TDQvVyNpbCaavZtVcqBcm4vpMTIAKMq66rFrxsio94JlqSBmx7JSuDBd+AJogMTYwWcqAe8wilTOxhqmjEWQfj3FyxvBK9X0taIp3gEJjUTUe1Euf8ebIiKcF6hz43YmhpbQa7mZ6CGVEOsPgLJ97AZsiQPf7pqPzUf2Yv3+S+d3MfzuLhVyYhIurNM6ESnEy522a1cbSm317xaNOITAZa1Wrci2754bMIVletq4ExPOyhed/AvgNx7pLFIRYqby/XQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYyIjXqwo2qJCGUfQPwgid4DHPe3YZJ2o8s0LN5yz1w=;
 b=hBtHJWPoFezVl0kbJoNOnGXykHlwOgt+SGTyt+2t53b4j9pMUBC8lVk3uV99/C5wD0xGPqLGSI7pjaihhYQv0/6wverDn0o9QnVnMJjAGLTtYRmYI9umWbN10ulAuX+OGkFC18OPsUklKsC3hYcJAEQxqL1xd9+ELS/A+PkKhBtd7fAgXaocU7HG/25Hzyv4nga2wcmNT9gruNOltjybnRe7z9zXfuxnGPmKDQ/BJr69ZqNPZkpMs4tEsmMlonaBzwm3PtEowr2hx8ZRO9Y2uSRijHJOllgVY5lSkUMSBP13xOj22O8OOOcoJTurL+ZOuz/0ywe0YyoyHmTojRp7bw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYyIjXqwo2qJCGUfQPwgid4DHPe3YZJ2o8s0LN5yz1w=;
 b=UyolyhUWd5e4E3Hs25QppVYIeD26B5hS+EOFY6kxgKLpFOmP+BJLofwfo9uWlDI2nYK0Ni0a3tfe634w+v0kYxHk+BEFR1LMDbjDgK5jBUMg4Y6bTtYz1wGe7dVWt9y3TjrXpXVjP9sQsIn0gjdx4Yd2BbfDTIrTdnjDScZM89w=
Received: from CWLP265CA0457.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d4::11)
 by DU0PR08MB8953.eurprd08.prod.outlook.com (2603:10a6:10:464::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 11:50:09 +0000
Received: from AM2PEPF0001C711.eurprd05.prod.outlook.com
 (2603:10a6:400:1d4:cafe::a6) by CWLP265CA0457.outlook.office365.com
 (2603:10a6:400:1d4::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:49:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C711.mail.protection.outlook.com (10.167.16.181) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:50:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eGdFUhQIcoebQk5VNrmqArFNxaNrS8dF/7vg45xoUSb4Esi5YWz5EryPQtldjBFg+vBqry3OHHf1c1RijBgpY08qQGGM/tkDrOBsMN9ZJKNZTWGZlEBopNAZbL8/uxcwIt7dl50NLZ9CxTO7Puc1Gv1ADZDEgygLLV4ipG64FrsUuE2HEvmtNTFIIpvRuaO7lq7ABqVu1ucBobsWXM5fJhCqrI8gVx+m4zIdUA0nXSdkLWbHjIcV4WPyhy+XpBcE4U1YikRy6aqMiJ3o7Vu22B1reJfywTukjkoRarjGEf5zH+MuzY2iCmT3TnvVyA3QJm8HJ67pZDNzmbfH9zGDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYyIjXqwo2qJCGUfQPwgid4DHPe3YZJ2o8s0LN5yz1w=;
 b=Nl68zbMOGsaBuB4rhfgqezq8jMJTdhQxGaFPqtunw06xAtODBSC8hVvO7rs6KRTVxyPZwz+YSzHrsZj+aJW3VtOcmIVpFy+z99HkEHZ8BIdB+iG0nELFV91qsWpbI07Bm6iEiTcD4+Wua173kRupBdZREIV8cTuyneY+HDtVFi9gv81fPQFTWMl7OmFHwB6hW2aeP27poIoPnEWeaJndLddhXmo/3JtJEUfLCWMtzK1YoJImryBgoV2W9eTp4t8WdKnFdiQmDD9RMz11uIa44SNUBNodiCTIzuOgbB/CutqmBkRscjXhEW8bbTqWz3CGpHfgQrWNOYD8QPpz+0pBVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYyIjXqwo2qJCGUfQPwgid4DHPe3YZJ2o8s0LN5yz1w=;
 b=UyolyhUWd5e4E3Hs25QppVYIeD26B5hS+EOFY6kxgKLpFOmP+BJLofwfo9uWlDI2nYK0Ni0a3tfe634w+v0kYxHk+BEFR1LMDbjDgK5jBUMg4Y6bTtYz1wGe7dVWt9y3TjrXpXVjP9sQsIn0gjdx4Yd2BbfDTIrTdnjDScZM89w=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:49:02 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:49:02 +0000
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
Subject: [PATCH v6 35/39] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Topic: [PATCH v6 35/39] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Index: AQHctgQMU1XsUkkLfEiCTuaLTwOOFA==
Date: Tue, 17 Mar 2026 11:49:02 +0000
Message-ID: <20260317113949.2548118-36-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|AM2PEPF0001C711:EE_|DU0PR08MB8953:EE_
X-MS-Office365-Filtering-Correlation-Id: ae3af89e-eea6-48a5-abd6-08de841b547a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 YytFaip9SkyZUAAFMQcyjCRK0L0SJ4+uKEgAUz0LXAyonpdl6qN5g4/iRWILsGqzUna5pgY/XBJvF2gNJFzADRVQvDb55LelLDHwsMcoodLWZ8yfAZpRZDGOqbgBxMm1s/IJqO/0YHDYpnxRnkN1AicBmfI4/z7FNs048ktuq11FrL2FU4UStfwNljhbWNfBs2iPoYGPtcnZBn84rp7DqosdAn2OqF8OEs9kH94kHFua5B5S6WLqPayzvW2GwA/gi/33YViruegAE6t+Pve7c1mvlvU1Lb0+u4a4shlOnQOgr+uxUOEr+Q9IsMgQmFI7HKV5EyJryQPYSkP8PVSOUQ1BY8UPmdkM5u2xCblkeQNiHVm/i4nCE5dArAib7QAB9VT/OfTn2/aa4HsWStmnVbsN1iJz3auHhiqn5NCK+GkOmtSEc1oX5EEoPp8pJUVHJQ9n93lVJbdIww0FTY78c6qQMdKjGYT5lrrb9Cz5dKdwIJGKJLQYlKtbi/1K8+DJ5snXaTHmep7sizgZG3y01qRVMPIfBzWCaAZsPuGsVO98g8vy5BtHaWtDbvlTCmk08GEiGak4o3gghrsjLpj7YsDSV+zHTbJikMXLq7RTeiX993FAnxYdjHs4jBYSBx1YoX4Yo5MF26fgMWZIPDbUS39PS3237F6Z9952OBkSKHR/2ytitKh2dlLC8LPXqq5papDDYI7F7AHuJZw8jQwS9hjd5MsYQAn0tJZSRpQzUyb7DWN2FN0aIF3W36CS5aYfoMapgwHts2UeHZ8b71wceO90pEqF84RSWTlO/io9404=
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
 cRr70V2k4iOZbZxJ7i8dZ16TNpLZmcXKVfVoSc7eE7MjwSfl30Bz22Hl/bi3M1b3cRv+qwaFVziX+uZ9Y9gPdhmCVmK4KrtrafGKw15aykuHnfhnVsXySL/yqf8Qk9J+4O8TOKc7KtaPtQQzEA+cgk+Gd9Y0uUIfACKGpsJ3zoLrfUI1kN9WBphOd3JbXKyDRubEX1quJIB6d+3mHGXKRa5nmdie2NnBgSt4N3yaN5/+rZImhXecO3ctzqHlYkVJmRGv8oQgNvpzgEOKwDX30hoLjYwpg6lwdUmize9FP4SmwAcPwSnUbPgEcw5sS/sSriVUFCWA0apRdIs+A49Tqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C711.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	00bee316-e6a3-49f2-1216-08de841b2f38
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|35042699022|1800799024|36860700016|14060799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vYyFqdpyfljdqTfRfotvQHtMUSnixY5puuAyvk1poyrh8mEibERB1crvb9lkyjHaif06k9dl5Dx9bS0gRyxJL7LY4WYTc4WUOtbllk7ctoQ89bzmCbb3KQNjZm1XSkBINeZUfRxTBeKgpD+dEOpW09P4TSC8fZVebn4HuJWF50ytjcRzVlwe7zmqnJ7wfMk+6USbSkeauLWA8I7hQ0WLwVZGOtxX6eavvw9905IIk7B3c9WAfF64O73bUQj6uQpDQBg2HW20qiuzU8BDx8Vfc9Qp1CUZny2iG+AFPFFPpxmo9XlMQx65Y/Kdwile2tp7CpDqB2rUP6KVKkdcXqc13feWAcIyhNSkVUMTtFyyAWbReClKfHbe2PXj5qJ3I49xerLyuP7pR5Bux9kyy1xZ5TqXl7rrBqjepN/8ctgIaEzPY/2P6FGawHzBFpanOqtHKEmmHwZPdcoWUpTLF94WdvhE9mLP/YrEj5kaO3B+3OrorZyGnJBAjX7mV5PMPWqm394jT+7UkjDA6NPO3ys1i9BWMyRyDO74BaTTzOUDYFbVk3uRd6FEschzIx1c1yKu3HbpoWD7XV8LcE+sgUx/mf2+5HoOXdyMLivQSY+6Y0RMUz18H+EIH+vy6E0SCSIPVUPRvbbd0CNlwYbU/GswsAqxCVGD2r4M3NLcr53XKHtmUt+4MflUc9XVE4C4sDT1oGjTfg6759qMP02J1blCXoDnK3BpNQ5eTUd8rOFG66maUdHceiXisD+MN3E7xnItUFvcrgERRC7ZViPdNXqeGw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(35042699022)(1800799024)(36860700016)(14060799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZARuuxDu+TiH5jYzbCzon9Hseg9JTjnBmkj2Tp13+Ow36igfLERx3bGMoS4Usopw4pR67SzCwPtDS43TZOjqJVKDhy3hsuKWXvwgFncAxAsqzb5XtlynRY3RUW6lJHPGqg+t0OymR4ZnazW2pwYY+kQqNrG70qHDq0d1376fVTh36HY9OLSXz6kUhI3HpHRVqWw2JURL0X+mSSiA2VJhWh3+3u3UaSIa/CXLNOYqpdVSK34EMJPGaqy0VJQPI3ababGdQO11a364X39IFYr63Iz6WhzmTygslpU+A0/Kx5fvQ5fYPtQWkXhPzoog90SBdzR4Xp5kvMIQB3jQQjJnYFccix47a9xcbY7jkQDYwrVbPfF9GZ/IxP+ZtV4d9DwD3bj8DLvYrftALducK1o7IgC1FXw2ioU9YIQLmJg39FSLL0XcWsaQcuSFYW8a5/Ln
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:50:04.8550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae3af89e-eea6-48a5-abd6-08de841b547a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C711.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8953

The basic GICv5 PPI support is now complete. Allow probing for a
native GICv5 rather than just the legacy support.

The implementation doesn't support protected VMs with GICv5 at this
time. Therefore, if KVM has protected mode enabled the native GICv5
init is skipped, but legacy VMs are allowed if the hardware supports
it.

At this stage the GICv5 KVM implementation only supports PPIs, and
doesn't interact with the host IRS at all. This means that there is no
need to check how many concurrent VMs or vCPUs per VM are supported by
the IRS - the PPI support only requires the CPUIF. The support is
artificially limited to VGIC_V5_MAX_CPUS, i.e. 512, vCPUs per VM.

With this change it becomes possible to run basic GICv5-based VMs,
provided that they only use PPIs.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 43 ++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 32565bfbd1051..e491ae0e4f56e 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -39,24 +39,13 @@ static void vgic_v5_get_implemented_ppis(void)
=20
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
- * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
- * registers a VGIC_V3 device.
  */
 int vgic_v5_probe(const struct gic_kvm_info *info)
 {
 	u64 ich_vtr_el2;
 	int ret;
=20
-	vgic_v5_get_implemented_ppis();
-
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
-		return -ENODEV;
-
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
-
-	/* We only support v3 compat mode - use vGICv3 limits */
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V3_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -64,6 +53,34 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.has_gicv4 =3D false;
 	kvm_vgic_global_state.has_gicv4_1 =3D false;
=20
+	/*
+	 * GICv5 is currently not supported in Protected mode. Skip the
+	 * registration of GICv5 completely to make sure no guests can create a
+	 * GICv5-based guest.
+	 */
+	if (is_protected_kvm_enabled()) {
+		kvm_info("GICv5-based guests are not supported with pKVM\n");
+		goto skip_v5;
+	}
+
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+
+	vgic_v5_get_implemented_ppis();
+
+	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		kvm_err("Cannot register GICv5 KVM device.\n");
+		goto skip_v5;
+	}
+
+	kvm_info("GCIE system register CPU interface\n");
+
+skip_v5:
+	/* If we don't support the GICv3 compat mode we're done. */
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
+		return 0;
+
+	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
 	ich_vtr_el2 =3D  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
 	kvm_vgic_global_state.ich_vtr_el2 =3D (u32)ich_vtr_el2;
=20
@@ -79,6 +96,10 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return ret;
 	}
=20
+	/* We potentially limit the max VCPUs further than we need to here */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
+						  VGIC_V5_MAX_CPUS);
+
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
=20
--=20
2.34.1
