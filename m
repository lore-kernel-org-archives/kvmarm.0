Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011053.outbound.protection.outlook.com [52.101.65.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12BE1F4634
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375308; cv=fail; b=fRu5bYOLnQS9mc5wM7L/rvPEeBvnAp7CBN2rRy2nUrmR64cggKRLiMUdecXBTyTyhW5UmVwW6c3berHOlRxG4sBgcbkLM3SKOocoUrrA3lSwdABrqCX1MA2XMEFUuBje3AxeriTEShC0wSwG7NsYnldIRkYh5req9TshZQVyB3Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375308; c=relaxed/simple;
	bh=WG3qiV7RN/sZZOnjKDFPnpDFnPJF1rJ9YENr2x4/rg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mv/VLiFEJF/mah6xYKk3MBAfk+ZkmUwgrV0pdaqv5SKeCNlOMr/grivr+v6eZUaM2jIwBLy5KQ0N32Z0qBmp4Hu3+qwXPn3CLfE1t1/g+oxNAmaE81NsruQAneljTeHj5QvwhO5TQJ+IhKvUSe0JPlDGvJTR8a/EvksyH9puWQk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bCM+7kPM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bCM+7kPM; arc=fail smtp.client-ip=52.101.65.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bCM+7kPM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bCM+7kPM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=jwo6O+swcnnb9hBCnjqEUUC/xnIedoI61vbcTeBBs39OKUm/ayFtNYGaGoVuVt3wTUCnua/8vKY2XzQTrOMD/DPvNoNj/aW5K7peppI7TTq0z4Z00xH4OfHjqi+HeRgDuAvEMfThNsNpFZ7wkUHu/VPKNpnlg1+xl4oaxAavw+uJITdXTH+sEiLlQuSuPq8Mjy1VDn48+TDb/evMo2a28pKmIu353PFTFRqRbTUGXbeINdM5i/C/Ym9z6Bu9gRyCbO+Bk3BE3Dhy06F8C/TZgIyCz37hY8VBDq7GfDntL6d1PonItnmiC9bmGnN85xSRwNYuBYZtOEW+Q/4jX+ZjzQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3toS+XQdLu/CYIj8T0Um39xTo7oRHPRD9BWWIF84Uo=;
 b=SdiWYD9WJo9HSLcIHVNIP74NYa970GjzN9YoG0domZk1TS+0o52fpuul+AGU6j9mMFVevekvupqOlcGhuF+iuzCAUajeZC2avudDotPywxILZU7FImYQP1WZPl0aartKeKwvu8uB0hviWWtQVaJZvXqFDxR/0WmyDixARD/d6P/rwQr0t2YKhwZ/U+tdE4mcee8vVvcWkHBgfPPaoHY153d10Jh4+ZclgkJd7XW30msNcKQav8L+4vQCpeCA9vIvUaOodvwq6EqGmQOQ1qzT6JnnJNAUxAfiHMLcV2V28i6NRE2MWb2fb5YIK2i1ufBJIONy5fMKHx8/85p81ZDmKQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3toS+XQdLu/CYIj8T0Um39xTo7oRHPRD9BWWIF84Uo=;
 b=bCM+7kPMia74agsC4w9eraNNFJRU7AnxfsB/fMNDDvZHVxb7431iO+YCuJBXU9Far8Jeu3NLdgMv3SNHYP7MBXGuD6B+dAIzsa8pcY8K28MAa3wT+8LGOwMtg1j3x3JoE5ZsqVpczCSmYMvczCAggdfZNSQrqNbbo/dwG/J/E4A=
Received: from DUZPR01CA0130.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::25) by DU4PR08MB11809.eurprd08.prod.outlook.com
 (2603:10a6:10:642::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:55:00 +0000
Received: from DB5PEPF00014B96.eurprd02.prod.outlook.com
 (2603:10a6:10:4bc:cafe::59) by DUZPR01CA0130.outlook.office365.com
 (2603:10a6:10:4bc::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:55:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B96.mail.protection.outlook.com (10.167.8.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:55:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XVq+TM02unpcYxLdKZQfNJUroYOW6/yB0rMWJ1wEgu37oLhrXH9UorSGqbWGvQzBrhZDK9HpoLiLuiRG2WEgJWUNMKSzQNbmbhbglMhx+1FmLIuQlGaHvkBZxcIhaqI49GW5sV8SqbhD4mfbIaCZMq628cvGcKL7h2n3s/HX0xcvXABqO8MQ9hce9ihhuwodxx2K02mIPcU5D/dldBThatO6htsnHRQDmHdMoq0++b75/hI0Ba94uw09uM6ygHrMZuUl5M6Umbqv9W/RPik7QU/p7uOl7193/U3W3de9QbvoJNwJavyombWTYrN4XGcFD/RpvaRmO6kahjjA4HUmvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3toS+XQdLu/CYIj8T0Um39xTo7oRHPRD9BWWIF84Uo=;
 b=hxhbiUCIdpMb87QoKYNJBqTzw74gK2oqfhdrJC2GvOdaUGi5jKI0EJngo0B2Sun/ME9TEOffvDOdxHquc5oVc0kZXxuiQJZ99Il1VUg241Kvp6HIebhJM2ohkHIBlCXccXKzQR4NNwCgs3+2Vsxu5meYVLjJ7ilhXbd49kWVtzVMuZu+Oo+3yR1GYw1AsB49wL0n2j24bniaDWPuOmE76uiVLDWOIBgbtrQmAkBlGZbnIK77X7/dOP3I14dQM8VuO/rvjMJxYbWkQ+orp4IFH2ChfJRvX9i92dLWOh8GPe2dQGdPjF/uTTVcB4FVoP5FM//1PcNKjcpqtCPKZdjCSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3toS+XQdLu/CYIj8T0Um39xTo7oRHPRD9BWWIF84Uo=;
 b=bCM+7kPMia74agsC4w9eraNNFJRU7AnxfsB/fMNDDvZHVxb7431iO+YCuJBXU9Far8Jeu3NLdgMv3SNHYP7MBXGuD6B+dAIzsa8pcY8K28MAa3wT+8LGOwMtg1j3x3JoE5ZsqVpczCSmYMvczCAggdfZNSQrqNbbo/dwG/J/E4A=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DB9PR08MB11461.eurprd08.prod.outlook.com (2603:10a6:10:608::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:53:57 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:53:56 +0000
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
Subject: [PATCH v2 14/39] KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
Thread-Topic: [PATCH v2 14/39] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Index: AQHc6TGmgCa3gRCJyE+8GnWYugEWRQ==
Date: Thu, 21 May 2026 14:53:56 +0000
Message-ID: <20260521144846.1899475-15-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|DB9PR08MB11461:EE_|DB5PEPF00014B96:EE_|DU4PR08MB11809:EE_
X-MS-Office365-Filtering-Correlation-Id: fcccd933-5a0a-42ab-4521-08deb748eea3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003|3023799007|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 jzFnIvLBaRHmtrJiKFHwx16uWq2u0l6wZE04ORAyDuT0ftrvN8PPUEX2kJ6fpkW9Z4Zq6UuOvehwWYYHo+2MKie3zZQauiEVDOOTMHHk2nBjqMBz9f02lc6Wu6HOIfZPuOtkbqOzobONuv5aK3WUqUY4NcKTZr0rOJfQsFyi19pd8pAoCpkxegfSYswiz7tFgwC9GE9WTJzWPdKhplHETVQj89luqwNc+6ceqANS9SkJsQ7HX5jiBXrbCbCoV/RtbCvxTRVCKmQs+CgKpgqj1SwvNUOJHV3BkBTMEoZA4+XhVVg0nKISSCv9zwqbNlo+PhQJr47yNYgw4qhm8kyXukl3fXKSpsVgzCirkyiXaa23Q1ZF3aN9kxzFoGXIgHP5o80IeVgE1gQfGrS5AX1NipwOMRXHAd2Yesvwa/izlJdl01L5wp7pJVEWzCErHMxl9pkX892dqv9kzIkJQ3rtbgu4wpcBJTkQCs2/XE3P84j17hO3H/QlKomxiRDhyEXnRNBwc9TdQvgKJGouXhefiAQX7VVJwnlUrw8l12le2cRBPmDKD9cJY7XQUec7o5kgTPuv9f/wMIlOSWgSMuEYZXcFCQpyllCZiDX8e3RRjWKSvp8EcBOLEr0bqqmNTOGmhJswq+vvBrKWp2tIL0zNa/dgjk7GM+7bNzKgZ7PsbDXu67KyBWT0TbitwM2GCwdXPH0ISzjQkJRnaiGubTrUY/aQB6W4DLdpvtw/zVNrJ0fFwe7qD6c47xhzwnGBqKrV
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003)(3023799007)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Hv3fu6Ok29FpuQW/B6586xlsATCQyf72QokvF6jJeuXr+Op5u1/h+ZyHzAPAkpUA+KMvE0KdH9iJmjZGW+Q5dKakeafozSIIjCv5/kPMtj6LvLl2FukulHzFjRtjasS/5K2Kl3eBcG/kszTgBpAnVGSgpfU6SJbQRsdrKs6EZ1FuAeZzzhkmD9Z1e/EDgMthQGBbtiJaGOYr26HitJQVIvw+wkLrM8BOG81sSD4f5V8gBwsMkoTzEiFn0HQRV6wYh1LqWDxDKDpGruSQziQLXcMdx1zYwJhhkI7hgeD9PKyUqROWub9+mE3Y64Uj+v231dRfnzxhXFNt2Bi4qStjyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11461
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2fcad8fd-e7e9-4b1f-4105-08deb748c88f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700016|376014|82310400026|1800799024|6133799003|3023799007|5023799004|11063799006|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	O7/7TVW7Hzk4M8bjPwgdX/UxkoHLOHmVqGpHd0A4offVT4jCuk69Ca4OFDoN8AVhOuLSNE7fTZkz7MLRpiG9YdFtsyyzBcbSk2sPH6T6MTUpLVHatVuL/BbBcBY5evH9hIbybzN3EVuCCPwh2m/iDb1WyZtgCO9lip6FG3luvBzjBkFOn5QSRbDXwbfcqyMitP7wb2hWQbnP7t2ZRptl08d9a81udh4OZtPFtxl/Xb6BKkLqDbwvSOejN6RXP62FjuYcSgsXzdM/WOX64Jfib1IWIoCcIHvTN/7iGFWAkFKhH2OVgCgtAMxm7YVpUsOwPN7N5oNftzeuRSVr+0BTqqh1q31cCTNI0gZJ5wgT0CXY8vr6RwRXtdtpNjtf1na1TYOKHsPMAeOTczk+SJlA+RgiuPpRBwXivPUkRo3L78zD0VswVHPcM+4+rrAn8zX2ZZM0/jKft1KB1H1DUoYNlKa0qIc7vhX6dKziiJO1CzoI5ppXzQYdzqeaFQN+zzJt25lOS4cm6OCpbJy3IFUBhROnlItiuJTP3tlcQJLZSlWjH/G9iMJfTauUEGlwBaYkqWKPe5RlrE9jkI4rx0kRRNsKNybiWCuPm4FTlRQinCoau3QwlnYKNqXtQEHIkmO62Bz7OdmD1or1k4rGh3omBwv9UVN/w9x9xHU17nKPAXeZ30mN1ONXtzZyjYvmMgeMkQKKNzvXLDZUhlRhmwhE+4PnsbPV6AsXoZgjiPvCIv8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700016)(376014)(82310400026)(1800799024)(6133799003)(3023799007)(5023799004)(11063799006)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5DNlOuXgS2tZ2lSo3reN81GABBj29iIEE4N3Gf/gBCQLXsq7IM/JcJt4ES8ihqekIfbn4L8C2FQ+2C5qJMX3P1O8hqHWgZqQhZpcAULshNYdGMqA/7Eox/DqkCTKldU2GYdhA2s7RK2aO5IfQJFFIWFot9hs186pUh9zDHzn1B07M9oC6GK+lzTkk8c/STlgLmiI1dXESghg34P97aJzh9flfBLkUlWJ9Qh7KTSg8d/Ca0Yid7W1FpOFBqtQtIf5b4FpZZ0VUy0xydaRRfYqZG/2btUJSZg+Yz9acKyKGYo2diwuFIun1ghj59cOS2EVWHS+iiuDouqdF7LqoMfmQxdLicGTIuA/vHeFbumGzYGKvHUHlxQxyEaFM3sEPyR1J18/3Tvyl99+OcgUL/CS7kYu6Btg406axsgnQ/iDZjfqj+Ci9aDq9wLTcg2qRCKc
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:55:00.1155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcccd933-5a0a-42ab-4521-08deb748eea3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11809

A GICv5 VM needs a VM table entry before it can use SPIs and LPIs,
which are backed by the host IRS. The VM table itself is created at
probe time, but each VM still needs to claim and populate one VMTE
before it can use those interrupts.

Allocate a VM ID during vgic_v5_init(). The VM ID is also the index
into the VM table, so allocating it selects the VMTE slot that will be
used for the lifetime of the VM.

Create a per-VM VPE doorbell irq domain, allocate one doorbell
interrupt per vcpu, request the interrupts, and keep the doorbell IRQ
number in the vcpu's GICv5 state. The doorbell handler itself marks
the VPE doorbell as fired, raises KVM_REQ_IRQ_PENDING, and kicks the
target vcpu so that KVM can re-evaluate pending interrupt state.

With the VM ID and doorbells in place, initialise the VMTE backing
state, including the VM descriptor and VPE table. The doorbells have
to exist before making the VMTE valid, as they provide the IRQ-side
conduit used by the IRS commands. Make the VMTE valid via the IRS,
then allocate the VPE state for each vcpu.

Add vgic_v5_teardown() to unwind the state in the reverse order. Make
the VMTE invalid, free the VPE state, release the VMTE backing state,
free the doorbell IRQs and irq domain, and finally release the VM ID
so that the VMTE slot can be reused by a later VM.

On init failure, call the same teardown path so that partially created
state is unwound consistently.

As part of resetting VCPUs mark them as valid in the VM VPE
Table. This informs the IRS that a specific VPE may be made resident,
and without this the IRS will treat the VPE as invalid.

Also introduce a wrapper around the VPE doorbells -
vgic_v5_send_command(). This takes a struct kvm_vcpu pointer, and the
command to run, and triggers the function bound to the command via
that vcpu's doorbell. This is a convenience function to simplify the
code.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 154 +++++++++++++++++++++++++++++++---
 1 file changed, 144 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 6a312c24d0b31..08f2411c0a134 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -401,6 +401,23 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_i=
d,
 	return 0;
 }
=20
+static irqreturn_t db_handler(int irq, void *data)
+{
+	struct kvm_vcpu *vcpu =3D data;
+
+	WRITE_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired, true);
+
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return IRQ_HANDLED;
+}
+
+static int vgic_v5_send_command(struct kvm_vcpu *vcpu, enum gicv5_vcpu_cmd=
 cmd)
+{
+	return irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
@@ -575,33 +592,101 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	 * CPUIF (but potentially fewer in the IRS).
 	 */
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+
+	/* Make the VPE valid in the VPET */
+	if (WARN_ON(vgic_v5_send_command(vcpu, VPE_MAKE_VALID)))
+		return;
+}
+
+static void vgic_v5_free_doorbells(struct kvm *kvm, unsigned int nr_dbs)
+{
+	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int db;
+
+	for (i =3D 0; i < nr_dbs; i++) {
+		vcpu =3D kvm_get_vcpu(kvm, i);
+		db =3D vgic_v5_vpe_db(vcpu);
+		if (!db)
+			continue;
+
+		free_irq(db, vcpu);
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D 0;
+	}
+
+	if (vm->vpe_db_base) {
+		irq_domain_free_irqs(vm->vpe_db_base,
+				     atomic_read(&kvm->online_vcpus));
+		vm->vpe_db_base =3D 0;
+	}
 }
=20
 void vgic_v5_teardown(struct kvm *kvm)
 {
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	unsigned long i;
+	int rc;
+
+	/*
+	 * If the VM's ID isn't valid, then we either failed init very early or
+	 * we've been called a second time. Nothing to do here in either case.
+	 */
+	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return;
+
+	if (kvm->arch.vgic.gicv5_vm.vmte_allocated) {
+		/* Make the VM invalid  */
+		vcpu0 =3D kvm_get_vcpu(kvm, 0);
+		rc =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+		if (rc)
+			kvm_err("could not make VMTE invalid\n");
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (vgic_v5_vmte_free_vpe(vcpu))
+				kvm_err("Failed to free VPE\n");
+		}
+
+		if (vgic_v5_vmte_release(kvm))
+			kvm_err("Failed to release VM 0x%x\n", dist->gicv5_vm.vm_id);
+	}
+
+	vgic_v5_free_doorbells(kvm, atomic_read(&kvm->online_vcpus));
+
 	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+
+	vgic_v5_release_vm_id(kvm);
 }
=20
+/*
+ * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
+ * doorbells, allocate VPET and populate for each VPE.
+ *
+ * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
+ * our conduit for communication with the IRS, which means we need to have=
 those
+ * before making the VMTE valid.
+ *
+ * On failure, we clean up in the teardown path (vgic_v5_teardown()).
+ */
 int vgic_v5_init(struct kvm *kvm)
 {
-	struct kvm_vcpu *vcpu;
-	unsigned long idx;
-	int ret;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	int nr_vcpus, ret =3D 0;
+	unsigned int db_virq;
+	unsigned long i;
=20
-	if (vgic_initialized(kvm))
-		return 0;
+	nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	if (nr_vcpus =3D=3D 0)
+		return -ENODEV;
=20
-	kvm_for_each_vcpu(idx, vcpu, kvm) {
+	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu_has_nv(vcpu)) {
 			kvm_err("Nested GICv5 VMs are currently unsupported\n");
 			return -EINVAL;
 		}
 	}
=20
-	ret =3D vgic_v5_create_per_vm_domain(kvm);
-	if (ret)
-		return ret;
-
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
@@ -610,7 +695,56 @@ int vgic_v5_init(struct kvm *kvm)
 		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
=20
+	ret =3D vgic_v5_allocate_vm_id(kvm);
+	if (ret)
+		return ret;
+
+	ret =3D vgic_v5_create_per_vm_domain(kvm);
+	if (ret)
+		goto err;
+
+	db_virq =3D kvm->arch.vgic.gicv5_vm.vpe_db_base;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D request_irq(db_virq + i, db_handler, 0, "vcpu", vcpu);
+		if (ret)
+			goto err;
+
+		/* Stash it with the VCPU for easy retrieval */
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D db_virq + i;
+	}
+
+	/* Populate VMTE (with VPET and VM descriptor) */
+	ret =3D vgic_v5_vmte_init(kvm);
+	if (ret)
+		goto err;
+
+	/* We pick the first vcpu to make the VMTE valid - any would do */
+	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		goto err;
+
+	/* Loop over all VPEs, allocate/populate their data structures */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D vgic_v5_vmte_alloc_vpe(vcpu);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
+
+err:
+	/*
+	 * Explicitly tear everything down on failure. The teardown function is
+	 * written to handle any partial state we might have, so we don't need
+	 * to do any clean-up first. Teardown will be called a second time on VM
+	 * destruction, but that's fine - it is better to leave things in a
+	 * clean state now, and doubly so because userspace could actually go
+	 * and retry init.
+	 */
+	vgic_v5_teardown(kvm);
+
+	return ret;
 }
=20
 int vgic_v5_map_resources(struct kvm *kvm)
--=20
2.34.1
