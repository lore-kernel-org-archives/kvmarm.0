Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011021.outbound.protection.outlook.com [40.107.130.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F83434F27F
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.21
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306444; cv=fail; b=q8Ebk41PD6J0xdECsLhijQ8WZUTBI7cDx+2NB8WntpZH2dORnZZ+I/tdOw/E7hgqj8MTyYn1C0vy1GRCPOVOekhXMAgGbI/oltrlm/QxZMg2ZbPhnQ+L7vorZEkq+OiZ1Q8BRe0U8hxQtO1Uf1Ie06VhfC+wHcaeNJv+yUXCgzU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306444; c=relaxed/simple;
	bh=Okoad9iAcC/U3os6tacdHOr+Kx6/qU9Fkq14NFAqoH8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ktmf2Quf64bIFhxSC/Tg1PFEySHpgPHnh90LUjZACesAu2Q9clxUTv/TdOMbLo5LYoyxKiFzsMxVtr6as/6X83/tetFNJKR8FYXIsXVooLytZwlrAvrC5qKJMJH+g3Cx6vRHsU9uDOuPndvNl2Tla6enT9mtY829b//EewUhOyw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SPQvyirS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SPQvyirS; arc=fail smtp.client-ip=40.107.130.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SPQvyirS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SPQvyirS"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=He/OXjx+YsUybnQX74pEBByKnsKDNWs6wGxftETTk1wg0caHNT9zczoKT6rWd4UAfRqOwxHMqMbIEmP8vDna07qxjSWpVDeVJgEh/OBBZhH2S5qVTbF4PSYULTeJpWmu+ob7vparPP5lT049nkrQORXCgQBH4EP/nHwes+p+WEGNRYXJCNUe9TwaDNaYPfAkqvH6W7t8QAzSGqJCObQLFxTmfnmEUUy+XN0Wq6oXevlYJ+CUOaP48Ohuud/73HZh0U0yz+B93o19BXCPxLGttJgmp4sJP/FijTjWPjyYoZkMJg45X9PfTbsNBh4cmZXkbdtj64J6IHOvDshZ7R8bUg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9gRB4RWsVoU2K1JJkwVvSKLGQSgpWnyZZvpu+cSgGg=;
 b=ce9BSJM0HZFbz7BJ0qi81ngbg6RpTJQaF681P/qhHdXrCoajAIyTKmRyTK9n7nu0xFVarP2aoAgvc+qYIo0f9hG8P+a1v2DyDwQA4AQudh/63Q4ERN7WgJgc30s655SaYamW3qR5DdSK4vYrVPKRebQo9XhQhmRY41hlq7E2nCFWM/+iXhPPIcGdAKs/iZu1BvAhEVy6g9jmHGw931e8Tsmy6rZui06Lf24t3ogDxzR255VHns6AqyUF2yIyaScc6GeXh4IP8JyzXFVzIBd3/iYKO0wNNM1PRsvdkitPoeHavMAZfW6mRLsAkDo8YnDkSPC3LI+ZOqgyYEP69Lx5kg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9gRB4RWsVoU2K1JJkwVvSKLGQSgpWnyZZvpu+cSgGg=;
 b=SPQvyirSDCdMX0hFZEn8TPULUjTvBDX0YqqOdWu62VlHp8MlkVru31cLhlqJmAW6C960Xzd8SWIEXVGBXUbzd60OiOeq9wgVfzuz1aiMhE1Ub+91JaAhe47MdORiAGEYc64Ji04ivDyZlFSt6y4FcUfb2I7cZs37f84QuF8GlYs=
Received: from CWLP123CA0180.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19b::17)
 by DU0PR08MB9824.eurprd08.prod.outlook.com (2603:10a6:10:443::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.33; Mon, 27 Apr
 2026 16:13:55 +0000
Received: from AMS0EPF0000019D.eurprd05.prod.outlook.com
 (2603:10a6:400:19b:cafe::50) by CWLP123CA0180.outlook.office365.com
 (2603:10a6:400:19b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:13:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019D.mail.protection.outlook.com (10.167.16.249) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:13:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SgiLrDDbfAcMRW5tUEVxW/CqMrNr1xpTW6q+b3QHy9DMfnlkrcOVxdihd82OEo9NfGX8vdTmcZBxSwtLSbCpXLWUVv1r3a9bSYjrag42zX5kMbzRa1nhiVAajDuc4cAYg6YcwMogPnEqD3i3DsDVMdQgKu2sfEz2/Xk9zR8gsVPFs1WwtrVJE7kFaBKUwOuvTqW7TEp4NCEV7dp5TefYJI0d4qRt52WpsTfPpgBlpbxg8ovE7APRPRhVHYh0r6X9NsujJLO5qIq4WuCZMLZH01/DCZ7uQSM2c26QK9V2a9Fu06AnfVYTreUmjzK+TyLOQhMH0jVqHiysIs+FJ8XZSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9gRB4RWsVoU2K1JJkwVvSKLGQSgpWnyZZvpu+cSgGg=;
 b=bnyiVeRdcgVOCTe6NQ+jdvMfhqd/HkgVA7S/7cXyZTqyXuknhSi0PTpN0/BzNcuzonDbOC99sJ8No5xWq/Gy0x5lLjmHfeFZuK0fop6DzTbbrJhIM0r270ZvCfyNWePDcM8z4glvyh2m6BIpeQZa7X0wg0wuObCPha2KRghnuZwvz/BqbWh4jwsjN2LoJvWjBaWKKdHlFP8mmYfaHiHk6nf26sOYOTny5raB4+st3qE0LX7pC69K1mtTwsIRQQpF2MWmi5FyyCV3X7Vb45ra5DQ94ZLXLPWVr8AK+8UyyRoMIIIOwO5MCzyHMdjSFelsgWJoU66pnOT+i28s3QmYag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9gRB4RWsVoU2K1JJkwVvSKLGQSgpWnyZZvpu+cSgGg=;
 b=SPQvyirSDCdMX0hFZEn8TPULUjTvBDX0YqqOdWu62VlHp8MlkVru31cLhlqJmAW6C960Xzd8SWIEXVGBXUbzd60OiOeq9wgVfzuz1aiMhE1Ub+91JaAhe47MdORiAGEYc64Ji04ivDyZlFSt6y4FcUfb2I7cZs37f84QuF8GlYs=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:12:52 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:12:52 +0000
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
Subject: [PATCH 20/43] KVM: arm64: gic-v5: Add IRS IODEV to iodev_types and
 generic MMIO handlers
Thread-Topic: [PATCH 20/43] KVM: arm64: gic-v5: Add IRS IODEV to iodev_types
 and generic MMIO handlers
Thread-Index: AQHc1mCzF46s6tq880OssqG2Sm+4UQ==
Date: Mon, 27 Apr 2026 16:12:52 +0000
Message-ID: <20260427160547.3129448-21-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|AMS0EPF0000019D:EE_|DU0PR08MB9824:EE_
X-MS-Office365-Filtering-Correlation-Id: 230749cc-cf2b-4ab9-f3dd-08dea477fb08
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 VTWX96Z6aqyPpM6qmorkusxrV8FrONZkcw9XzC+ptBXIL5xZ6VBOqUKHSXsy89DmFOB8gxXNNzA4Ocutc0M02YqX7eAvxApdzF3fuGg99I59B+3jCnWTKdUJanRvhRudiCyWAX83bKmsa5pfp06q172zEIVsrUR3NbpfCQlKWSi21i3klrNnObapeQQpIUyeCJJg10svc40JH1VK883JYCVF3vO+6flrAgXywmjhUJ6u7EazCo+TVMqj2xoFNYyXKh/TYyhvTM3mp5m8gXgXIIb48HrfgrLrqZpnxawWbi4Cofa4ynVnEuNa2EGWEjx8mPYawJ5IHovmcAy1e7Mo0qPGKqzppKTkht6gda1XSQ8hsoyw9kFlpLXLElqiBXGj2b9xOrMPAU6eQognjZeadbxBQbyvkzb9ddFSLISSudvJTMdEg9xY5uwCa8Z5tGdw2HT6pD3t/X+7Umgrin/IzmDIlSyM/NBZSrXV9air9J/uoS1y2GdVYSuCU5/UZA3jc0+393Jog68wLltJ5k0vjFnjpmdw+Ka0ACtZUKBFi1W4by8/cLAZ00ZUpHUreLuxjS9Y141ca7bvQgDXzoRNqHLzr+NFXWjEYDqzjJ6uHIeFO9cgGoWsqh/iTWYL3DBcAQnSfw3iobDBoTen3x8g5gHOQnh9ZP9uhxVs9hwqBPQL4IgBW4hm27AByVuTheKYJRr9V2t+76UqrobiXE0ux8OupzlxmwLzZBH+e7MnzYjOb5wUBMEP+Fi7AvP7LH4S1LU6angq2ZB+IlCQnHcqmcq+eaTdQIttjWN2HfF5DrE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 L/XsGquLDFPn03/9p8qkbD4JMVJevB0Ln4yabQIDUyEjYnTLY43IRbHmTZSzXjbqft6q8B0pWWcpJ1SpHhZ/pG9BlmR3viHdFv5hb4JxVckwHj4UjWSqvLQF+A7wMM+0hyqoyBk9qdyLdFo/8Jb4YoFMSSNWs3CV9CQOxXrHT2VGCxJKq62LxkFYznO6aiejlZgL4Ied4bzqw7mTORKelN10368V8h7XiC9W7cK8NubJMiTp2L5Ukm0/rCIBSW0GDZl4DjpUsR40oGgH7a8qebFzEZa8r+X33ueByb7ThqCMydUY8mjJUfJK6fuvakzBBdjFM0whu9QlAd5i1qUd2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e0994491-8bb1-418e-0399-08dea477d597
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|36860700016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vNtGSfCeniakwp18/+98dNCy1ZFqGR0h6x75xYqgmXUMH6dDIFDrniy5CYEMIjMbz1a0MO6y1qmT5kvkqInl6LMpLquQlDAGQjVcfNtoO2ytxwKvgzA9S36j2YwXWE29clCFz0e6DStlKByqaoKSeGjzRHuVe8a8z2TQZCiO+xInV+sTygvgR3Kq1u13PDHobjF6ZqxvznKNJRFGa4pcTxvfNYZLjDoGvhdDv6kUYsdy28flnVkzPMMu5BG40bej2vP47P/FpRo0kGcyWDBcNJJB/TKxyan+MvZzeY4iL84XplcRtd0ErL7bCWwGD+FgV7okBGI0ka2QcEyHOJgPND4w6BcIaAaVpwZsk1gAGF2yy8nEQ0ZcEZaVKmntLIrqP25nNiy/huTGnbMvVdibCjH6qKUxOwZfY0g5/+OonTE4PwXFkvWvfOKAdhyrkS2QkARqKXmuQqrX9MGNQWavmMvn4+4bUu4JqbxhKX+jL+he3oYCLPYBWN5ksxG64pYiVhyejrXgiuhQvhTN/bnNCnosSF8XeVC0lOLnQtC2XrqcSqKp9EubwE8gD+/8cPnSeqXGq2sccuvKzthU2k9vd8HEc++YStuPDDwNvwiog4wfZjqvQNfZbDAp1UFsD+xukc4QENjp1D1ma/K+/Sg4sUK/jWRgaQJEge77KsXYUL0Pywwb5onwYg2oVo0fhAfvYhjeM9kv/qWLXtwsdKc4k0HLlH7/xqGzyH+IJBsSSqg12D3uXDMLzh2HFyeaOKvtbbWsCnemO853FgWA8NPP6w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(36860700016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ag08OdCOVbhYl49E4DAL6ZMkd6Pc1iM/foumOxOEOP+HVzvJmemDOkKhylpYLYdUrYXPyhty9KydMoMtXJ3i1SWmoONQ9O1uG9aR3B6cRO1Aif8CgI6N3Ozrs0hFTxZLiNthOK9/LxNRvjB7IKpjbbvvzN+DT6z40C8SAmLvLS7B8XjDxOEAoh7GF62SWkoYGweZy/l//UXxUTceIbREINzQaXNur/q/3lLLmd5W+iAguQw9JND8Z7XJhADTuWOgKEeBa/d0HiIlrUG2XbQn37evJpA9/8E4N4zuDXJI3GN3vhyUzH/NrQ4Nz7JNjciTiXv5BbQEoB71gbx7d6V+SmkLCXM13aWwSQjKKGSV2b16xMK0CSOYxqUk31s8k6SB8EyzMac6o16/qeUmtbysiaMWW6wZ0dOpWnzppnilgUg0hO79H1eI5XcPBnYW25Ta
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:13:55.1954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 230749cc-cf2b-4ab9-f3dd-08dea477fb08
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9824

In order to support proper VMs (that support more than just PPIs) for
GICv5, it is important to emulate the GICv5 IRS too. The IRS includes
an MMIO interface which is used to interact with and configure the
IRS.

As part of providing the emulated IRS MMIO interface in KVM, extend
the iodev_types enum to include a GICV5_IRS, and extend the MMIO code
to handle reads and writes to that type of IO device. This will allow
the creation of a GICv5 IRS IO Device in KVM.

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
index d8f416f1f46a1..f8ecd19acc06d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -290,7 +290,8 @@ enum iodev_type {
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
