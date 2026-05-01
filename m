Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013017.outbound.protection.outlook.com [52.101.83.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9522E3D891F
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777654537; cv=fail; b=CKHfMW+sc0GUmZMnQ3PtHRjYnrwGyYECWhGAwan2IA29NO28kxqbyOOT3hVutTwECwi6oJH6ElmvKieS4blK4Toz9ES22UJxTQvIQecpO21fp5C9LzuMzdjak56r7JJn/soXJ8BYJgUW3Atbgdu52si3akNEvIYbGyxB0s1qjLA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777654537; c=relaxed/simple;
	bh=lKlxvYi/T+zGbqbPfTz9dmXVfDC3ysQk3aTW9Wp4RdY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H5rcvw8xsWnx/xHbK76BZ6YGd2zdDLoRIkrVp5H+Oi/0oMmNxogX3itllZW0Ghm7YLA9aCezuyHPPBdPQlWCZINXZPUqZvUVrYaRswBSicLIF5Q0AAhyYOfS53qqFthm5biFEXSQqpyIVXgI2KYMYGFQipvarkTY6CJrs1jjo40=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HH9FVc9p; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HH9FVc9p; arc=fail smtp.client-ip=52.101.83.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HH9FVc9p";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HH9FVc9p"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FM5bBsmPX6fYUElGHOocy4EiiUqSvYPlWo4jtM/jFid6sQdBtCfvJ66vI+/s7gn289UjpfaJaV2cAqYALLVcurIDnbHfMPc3z+dhbVUvJoTvNkxhGaIp81bVtLDiFHxeRbbTMg61YNIdeYYthpw9Sbw9XmwkhNGYztQl8DFrhLmKaG7PMYde6M6gLlMYzlqQuHP7HHP/i5BLwNdPcZDvumKFfF3p46yjYlrOHV2cAriEZmeUSnwf/cFLIy4mTuYZqdjFHeb4fZg5joUAsTtzWtWanusLsiNm74j+5YZJCMjhb0sDBdcoaozgeUqqOOvSwN7bBja55LXs+LQ9qrIW9Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lKlxvYi/T+zGbqbPfTz9dmXVfDC3ysQk3aTW9Wp4RdY=;
 b=hVz68CfyQqo8s/hWkJ9pLU0aN04r5ZOXFl5gKt1Aukb86y5I4UGMkw9BdkXis6Q2GNXTGwyGYz7w2yySA9K/zm8/WTagT2c4ynu37XFI167mnWGsT5xJDoky5xV8FLr1egSQJx/Xi5WZjFbJQ8lyHk6vaPHkZLnR/oh+V+9VXt/wgoJEZzRpQiOr1Jgf8CFVzaWrIn1Be1e/qyGN3Od3b0N92fQY10sKLwLkM0H8PQCcd9wtEi9HkBqYfJ1iLLh+6mzldjLqgwA1MYQUzQOWSVpdB+d0UD6cxJfwdvolrWrcS47jdoCrmkL7HjnjHZ/QnLbFJQxQJJ9ZqwMVz01olg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKlxvYi/T+zGbqbPfTz9dmXVfDC3ysQk3aTW9Wp4RdY=;
 b=HH9FVc9p6dYA5uURi6CNPPo8tDqEvSca2JaWIH4xVIVgyxS5fVuGtXOW1O0IsLMOMpqZISfA+t19zVnHEbYA1ObVoyL3KQSSXCl3dLgDpxclWUgStnlnnn2rBDQKEdeJrMsiQJH6trFCAKfl+iIH8Pff+lAofCI1ul4Kq5Mbt3E=
Received: from DUZPR01CA0054.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::10) by AM9PR08MB6164.eurprd08.prod.outlook.com
 (2603:10a6:20b:287::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Fri, 1 May
 2026 16:55:25 +0000
Received: from DU6PEPF00009524.eurprd02.prod.outlook.com
 (2603:10a6:10:469:cafe::34) by DUZPR01CA0054.outlook.office365.com
 (2603:10a6:10:469::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.23 via Frontend Transport; Fri,
 1 May 2026 16:55:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009524.mail.protection.outlook.com (10.167.8.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9 via
 Frontend Transport; Fri, 1 May 2026 16:55:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QR+NNfjLlb/qdpAIM6cEz5oRJPY54qhb2Pp/i43yzX+VEc1mLO+Pgv0OcW7GmJOOZw+XI6vXTKzmxVaIx4+bgkhJofg5v/Q6bwjJyEcfNOjlVHp8GT16jMnIdlOclt5r6sVA4CDe6OivGsScVb/n+qhXbcA3TlYzel2SOzVsRqt91PaKHjt/tj6tNlnGkD4ZvOuhsH0c3wgqHJgUKg25HYBBlslkwqyEw4z5QPk5pDCaJybVu+MUoOi1qzNelLroNZmNYEEHa0I5Fb9JmZ5E8EsoUjSlBXyST8oyOA3R8rmuYUxQvy6ms7lhfwbM/53dP8OHGG885Yv7QCXkzDVURQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lKlxvYi/T+zGbqbPfTz9dmXVfDC3ysQk3aTW9Wp4RdY=;
 b=tkeS5gVaVoC7Dp3HkrDRnfp7lwm89fecFDknAFhP0I7IeZz43krzCG7v1/wdep+Qn5iNrRaGUJLIm4Nv9Na7p3LnWxTWtGEuVTK7hJn8lFUIrZ8TJ2AqhzCIxfooEW1H3tIgpm4Xw+0tkavSq/YXk1+5RGa+vJgpMKVZjZwCmj21m1XqrN8/ctxi6X+iSBQiOi6C8hHSdZGodUBjimGdR1feL43DPqW+tGejy+hm9VmKfWYrDrHwJueIUYTipkfKyg+tIpFWEQOtOkOYC6y3hsUag/8LasP9YJb/z8Fjad+qY9TjyzibzQ/RtsHpFEUNN89VFF+yd3S2wEFWhZExYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKlxvYi/T+zGbqbPfTz9dmXVfDC3ysQk3aTW9Wp4RdY=;
 b=HH9FVc9p6dYA5uURi6CNPPo8tDqEvSca2JaWIH4xVIVgyxS5fVuGtXOW1O0IsLMOMpqZISfA+t19zVnHEbYA1ObVoyL3KQSSXCl3dLgDpxclWUgStnlnnn2rBDQKEdeJrMsiQJH6trFCAKfl+iIH8Pff+lAofCI1ul4Kq5Mbt3E=
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com (2603:10a6:20b:47::18)
 by DB3PR08MB8841.eurprd08.prod.outlook.com (2603:10a6:10:43c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Fri, 1 May
 2026 16:54:21 +0000
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7]) by AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7%5]) with mapi id 15.20.9870.016; Fri, 1 May 2026
 16:54:21 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 06/43] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Topic: [PATCH 06/43] KVM: arm64: gic-v5: Add VPE doorbell domain
Thread-Index: AQHc1mAHvLGt4diYL0WUbJCxjAtCTLX0rs6AgAS6wAA=
Date: Fri, 1 May 2026 16:54:21 +0000
Message-ID: <f16f006c6270a5a719ffc183532d957645338706.camel@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
	 <20260427160547.3129448-7-sascha.bischoff@arm.com>
	 <86o6j3yr56.wl-maz@kernel.org>
In-Reply-To: <86o6j3yr56.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM6PR08MB3399:EE_|DB3PR08MB8841:EE_|DU6PEPF00009524:EE_|AM9PR08MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: bc29a739-6624-45ec-6b31-08dea7a27099
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 AfykDlhzgskLOCh6k+LDiPuvyIRspe+aj4IY4ht6frvIMe+F4W8t3IydhCk7Mmp5JZlyJY87QnrtEXJP0K1fsbQxehyG1NQnqsTjuUxUMRp/U3zQ1vhmx+jDIkpN3dn0yg6H0beG26xd2sfhewZQTSSxYutCpT5J/MmMLoi5wVxK9/0NOCm98G/p39bkjBaTT/tZQ1U/tWYDw+zfMM4dMJ7UX473pbcrw+GJFdE0yxU+Ky23j+tAm2R0NELcv2pP4F994N/IdwZPbyjp1zYWF97MpI9P2iyNUJw0PfdW+M7kymmlOaU3jGHarLf1/kh9cBuQlmO9lo87YR7l74RQJ2NkYnvIA1tX4rRNKPRCamEsf+78XZ2yfm3C25fPJ44jh4CtuLQazmIY2j49o7YX72ThLUXs51NjRfZnYxsTDsVl4KCAMKEzgVObuyRlWjRddlNbF9+CTLXv2+nFQ1QZJavGwEvJcYDCRp5DQ06VYVDQjYRu1vNpwJg0jm1PtS9H+6DzsGugbGErKB6/P7dcbFiOl3yuefl5JPqoFgaNCJwA7LHEzqrTWmgo5Zn61mFR5RIYwgpxlWPR6tAdymJvWPM8A5z5aW/7tPbbuTIvrKb72LPU49ZKDVND1V5Uk0g+zBgmJkKuH3O1TMvgIy+9HYuifxI/8KMAUW+agY+D5PFDGhpHxXXBjeZl7SJ3iFTLXaMVOFaHA8fh2TJWPRRj2YK9u9XipnMQnpw/iueeqh36r3wmC8BhS+ygzzM2rY0M
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3399.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE22EA1EE2DBCF4AA50B4601AFFA7906@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 R5aa0fyKGOxeeMewP//iH6VnJSybKz/iRq0Z6SqFpo+diM5bwt1zqW34cbP3Cr+YGbuBBz7w1baZaY3iVa+3joZe5AdR2vBy0QYaazh2JvL2NmqFipDrah7uhBycjy1RQaZxRWMJaoky/P/lNS2icWh+x4qh0iHY5E96RMWw1rdlghw16qzLW4kz0zeO96Pd3LtRyc8zdBllBcJT2ikH+Vm22lVtvDPnK7dARQHcgNDc7GIY6NbFLvMX19NyxwbVaAnGMyuUifwGB6WNFByLLnPOAe4TMsU4Ur6uX4REIpw4K+FnokMVclp3FX7kWK2BA5tKEhk10dLPekvog+MQSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8841
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c7968aba-37a6-43fc-49d5-08dea7a24ac7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|376014|35042699022|82310400026|1800799024|22082099003|18002099003|56012099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Gf7yA8E67/PDl2y3W0nLw/slTojcyUw74NYYL3vEA6/Eiqlekn63WiNxnlMHScQfhjZVXxJ5a/FKXqUIqhuEB+OowRyNEdODqL2T3uER73EDi3s7HyoqWQpJ+2Kiv8m4sZJf3P/FgBgHup03qhFqNnO0FiaUNf9PdTaajsgnd1jDALug5nv+WQTlugnA7TTnlN7YayVoRM6NgxX4hni2zXjGSzr9WwSbiwe3OccPEMELhpN36/O4W8Q9nkxMAZuszkEBpovzEC1g+ABXviUz4Qt6jO9du9RimzwYsbU7RTYwUM8lzZo543gSmWWUPS4LAZwEM2ZJRZFB1pKojp12EIp5klaU5JlRm0E0kikd/+1oROziHViwwxoHy5OPVUNZGRYhLKXcsZEE3Ch8qsr/6q9RWyxJfqD1Qgasla53Fg7qSGF9bV+6OV+M3RGxODky5OwP/3T6GL82veI+hL2qkf+0vSAnpWLjgNnUbaV/WPrJQpzhpACYVchXgd+fHah/7WcApa6miCdrNy1yQ+4Qb9IDlfhaU9q9L5TTkCJGHz8eHdcVxtFgfMi2IPZElNupw8rywzDm36BU1VOoydL6P1rpauD5nlgtEcBP4ZmeouclDgY4TUVreM8hVPAz6KQmiDn+ht/Jxw7YEgKhRRqWgtrzkiXdvn5fvz51koMarEANSOOLrpGxnKpm90eNOD0ujgjCphJhIU+B8Oev6EWK/eb1u+l/oFGAgOBGxCp/g/5TxoEitXOpt87nSUPK/eVK
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(376014)(35042699022)(82310400026)(1800799024)(22082099003)(18002099003)(56012099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	F13Sw8y4w2GoqYq8bac5gOYa2wA0nEriOIM2/0ukmYRrkPzOvzE0kxyenvNzbLkb9szfMoMQH/GGOyX9IUlHCyA8cXcMRHYGaRZA9WVmvwj+NYvweB1dQRpxqHrmVa/ovkici65xEjuZ6dHtqc5UARcgDAueJJSvQCZkOfnnFQsTa8JeoFSmXsh+kecBgDsbBxS+EmRaVIb5911YrokfWsxpJMFeXSlxnwSN16nzXCP8eNgeRn9nxRle1dcvcmQu1UKJEdOh8nqLTb7YlXSaQs0YJmK4MYIsakMIhc82IwePfsOAAmgYgK+WWqqjpwa7/fZJmI9d5wVcgWdT0mJS+XnT04+frPtCebz0pc67IJQMff9sFHNb+YjrfmgBSIKj43HEZd2G/+pT8k95bQrpRovm0782do/uMGY2MS6XIm2aDofYvd58SJWBrjq5SC9m
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 16:55:24.7704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc29a739-6624-45ec-6b31-08dea7a27099
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6164

T24gVHVlLCAyMDI2LTA0LTI4IGF0IDE3OjQwICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIE1vbiwgMjcgQXByIDIwMjYgMTc6MDg6MDUgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEdJQ3Y1IHN1cHBvcnRz
IHR3byB0eXBlcyBvZiBkb29yYmVsbCAtIFZQRSBkb29yYmVsbHMgYW5kIFZNDQo+ID4gZG9vcmJl
bGxzLiBJbiBLVk0gd2Ugb25seSBzdXBwb3J0IFRhcmdldGVkIGludGVycnVwdHMsIGFuZCBkbyBu
b3QNCj4gPiBzdXBwb3J0IDFvZk4gdGFyZ2V0IHNlbGVjdGlvbi4gVGhpcyBtZWFucyB0aGF0IHdl
IG9ubHkgaW1wbGVtZW50DQo+ID4gVlBFDQo+ID4gZG9vcmJlbGxzLiBUaGVzZSBkb29yYmVsbHMg
YXJlIGltcGxlbWVudGVkIGFzIGhvc3QgTFBJcyB3aGljaCBhcmUNCj4gPiBnZW5lcmF0ZWQgd2hl
biBhIG5vbi1yZXNpZGVudCBWUEUgaGFzIGEgcGVuZGluZyBpbnRlcnJ1cHQgb2YNCj4gPiBzdWZm
aWNpZW50IHByaW9yaXR5IGFuZCB0aGUgZG9vcmJlbGwgaGFzIGJlZW4gcmVxdWVzdGVkIGFzIHBh
cnQgb2YNCj4gPiBtYWtpbmcgdGhlIFZQRSBub24tcmVzaWRlbnQuDQo+IA0KPiBUaGlzIGlzIG1v
c3RseSBhIHJlcGVhdCBvZiB0aGUgYXJjaGl0ZWN0dXJlIHNwZWMuIEkgZG9uJ3QgdGhpbmsgd2UN
Cj4gbmVlZCB0byBwYXJhcGhyYXNlIGl0Lg0KDQpEcm9wcGVkLg0KDQo+IA0KPiA+IA0KPiA+IFZQ
RSBkb29yYmVsbHMgYWxsb3cgS1ZNIHRvIHdha2UgVlBFcyAoc28sIHZjcHVzKSBhcyBzb29uIGFz
IHRoZQ0KPiA+IGhhcmR3YXJlIGRldGVybWluZXMgdGhhdCBzdWZmaWNpZW50IGNvbmRpdGlvbnMg
Zm9yIHRoZSBpbnRlcnJ1cHQgdG8NCj4gPiBiZQ0KPiA+IHNpZ25hbGxlZCBoYXZlIGJlZW4gbWV0
LiBUaGlzIHNpbXBsaWZpZXMgdGhlIHdha2UtdXAgcGF0aCBmb3IgdmNwdXMNCj4gPiB3aXRoIEdJ
Q3Y1IGZvciBMUElzIGFuZCBTUElzLiBOT1RFOiBQUEkgcGVuZGluZyBzdGF0ZSBtdXN0IHN0aWxs
IGJlDQo+ID4gY2hlY2tlZCBleHBsaWNpdGx5IGFzIHRoZSBJUlMgbmV2ZXIgc2VlcyB0aGVtLg0K
PiANCj4gRHJvcCB0aGUgbm90ZSwgaXQgc2VydmVzIG5vIHB1cnBvc2UgaGVyZS4NCg0KRG9uZS4N
Cg0KPiANCj4gPiANCj4gPiBUaGlzIGNoYW5nZSBpbnRyb2R1Y2VzIHN1cHBvcnQgZm9yIHRoZSB2
Z2ljX3Y1IGRvb3JiZWxsIGRvbWFpbi4gT25lDQo+ID4gZG9vcmJlbGwgZG9tYWluIGlzIGNyZWF0
ZWQgcGVyIEdJQ3Y1IFZNLCBhbmQgYWxsIFZQRXMgaGF2ZSB0aGVpcg0KPiA+IG93bg0KPiA+IGRv
b3JiZWxsIHdpdGhpbiB0aGlzIGRvbWFpbi4gV2hlbiB0aGUgZG9vcmJlbGwgZmlyZXMsIHRoaXMg
aXMNCj4gPiB0cmFja2VkDQo+ID4gKGluIGdpY3Y1X3ZwZS5kYl9maXJlZCkgYW5kIHRoZSBjb3Jy
ZXNwb25kaW5nIHZjcHUgaXMga2lja2VkLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2No
YSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jwqDCoMKgIHzCoMKgIDUgKy0NCj4gPiDCoGFyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jwqDCoMKgwqDCoCB8IDE0Mw0KPiA+ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuaMKgwqDC
oMKgwqDCoMKgwqAgfMKgwqAgMSArDQo+ID4gwqBpbmNsdWRlL2t2bS9hcm1fdmdpYy5owqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDYgKysNCj4gPiDCoGluY2x1ZGUvbGludXgvaXJxY2hp
cC9hcm0tZ2ljLXY1LmggfMKgwqAgMiArDQo+ID4gwqA1IGZpbGVzIGNoYW5nZWQsIDE1NiBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1p
bml0LmMNCj4gPiBpbmRleCA5MDcwNTc4ODFiMjZhLi45ODQ5MDhhMjcxYzhkIDEwMDY0NA0KPiA+
IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMNCj4gPiArKysgYi9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jDQo+ID4gQEAgLTUwMCw4ICs1MDAsMTEgQEAgc3RhdGlj
IHZvaWQga3ZtX3ZnaWNfZGlzdF9kZXN0cm95KHN0cnVjdCBrdm0NCj4gPiAqa3ZtKQ0KPiA+IMKg
CQlkaXN0LT52Z2ljX2NwdV9iYXNlID0gVkdJQ19BRERSX1VOREVGOw0KPiA+IMKgCX0NCj4gPiDC
oA0KPiA+IC0JaWYgKHZnaWNfc3VwcG9ydHNfZGlyZWN0X2lycXMoa3ZtKSkNCj4gPiArCWlmIChk
aXN0LT52Z2ljX21vZGVsID09IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMyAmJg0KPiA+ICsJwqDC
oMKgIHZnaWNfc3VwcG9ydHNfZGlyZWN0X2lycXMoa3ZtKSkNCj4gPiDCoAkJdmdpY192NF90ZWFy
ZG93bihrdm0pOw0KPiA+ICsJZWxzZSBpZiAoZGlzdC0+dmdpY19tb2RlbCA9PSBLVk1fREVWX1RZ
UEVfQVJNX1ZHSUNfVjUpDQo+ID4gKwkJdmdpY192NV90ZWFyZG93bihrdm0pOw0KPiANCj4gbml0
OiBzd2l0Y2gvY2FzZSBpbnN0ZWFkPw0KDQpBY2suIERvbmUuDQoNCj4gDQo+ID4gDQo+ID4gwqAJ
eGFfZGVzdHJveSgmZGlzdC0+bHBpX3hhKTsNCj4gPiDCoH0NCj4gPiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy12NS5jDQo+ID4gaW5kZXggZmQzZDYyOTlhMmJhYS4uNGUwZDUyYjMwOTYyOCAxMDA2NDQNCj4g
PiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+ICsrKyBiL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gQEAgLTcsNiArNyw3IEBADQo+ID4gwqANCj4gPiDC
oCNpbmNsdWRlIDxsaW51eC9iaXRvcHMuaD4NCj4gPiDCoCNpbmNsdWRlIDxsaW51eC9pcnFjaGlw
L2FybS12Z2ljLWluZm8uaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L2lycWRvbWFpbi5oPg0KPiA+
IMKgDQo+ID4gwqAjaW5jbHVkZSAidmdpYy5oIg0KPiA+IMKgI2luY2x1ZGUgInZnaWMtdjUtdGFi
bGVzLmgiDQo+ID4gQEAgLTE2Miw2ICsxNjMsMTM4IEBAIGludCB2Z2ljX3Y1X3Byb2JlKGNvbnN0
IHN0cnVjdCBnaWNfa3ZtX2luZm8NCj4gPiAqaW5mbykNCj4gPiDCoAlyZXR1cm4gMDsNCj4gPiDC
oH0NCj4gPiDCoA0KPiA+ICsvKg0KPiA+ICsgKiBUaGlzIHNldCBvZiBpcnFfY2hpcCBmdW5jdGlv
bnMgaXMgc3BlY2lmaWMgZm9yIGRvb3JiZWxscy4NCj4gPiArICovDQo+ID4gK3N0YXRpYyBzdHJ1
Y3QgaXJxX2NoaXAgdmdpY192NV9kYl9pcnFfY2hpcCA9IHsNCj4gDQo+IGNvbnN0Pw0KDQpPb3Bz
LCB5ZXMuIERvbmUhDQoNCj4gDQo+ID4gKwkubmFtZSA9ICJHSUN2NS1EQiIsDQo+ID4gKwkuaXJx
X21hc2sgPSBpcnFfY2hpcF9tYXNrX3BhcmVudCwNCj4gPiArCS5pcnFfdW5tYXNrID0gaXJxX2No
aXBfdW5tYXNrX3BhcmVudCwNCj4gPiArCS5pcnFfZW9pID0gaXJxX2NoaXBfZW9pX3BhcmVudCwN
Cj4gPiArCS5pcnFfc2V0X2FmZmluaXR5ID0gaXJxX2NoaXBfc2V0X2FmZmluaXR5X3BhcmVudCwN
Cj4gPiArCS5pcnFfZ2V0X2lycWNoaXBfc3RhdGUgPSBpcnFfY2hpcF9nZXRfcGFyZW50X3N0YXRl
LA0KPiA+ICsJLmlycV9zZXRfaXJxY2hpcF9zdGF0ZSA9IGlycV9jaGlwX3NldF9wYXJlbnRfc3Rh
dGUsDQo+ID4gKwkuZmxhZ3MgPSBJUlFDSElQX1NFVF9UWVBFX01BU0tFRCB8IElSUUNISVBfU0tJ
UF9TRVRfV0FLRSB8DQo+ID4gKwkJIElSUUNISVBfTUFTS19PTl9TVVNQRU5ELA0KPiA+ICt9Ow0K
PiA+ICsNCj4gPiArc3RhdGljIGludCB2Z2ljX3Y1X2lycV9kYl9kb21haW5fbWFwKHN0cnVjdCBp
cnFfZG9tYWluICpkLA0KPiA+IHVuc2lnbmVkIGludCB2aXJxLA0KPiA+ICsJCQkJwqDCoMKgwqAg
dTE2IHZwZV9pZCkNCj4gPiArew0KPiA+ICsJaW50IHJldDsNCj4gPiArCXUzMiBscGk7DQo+ID4g
KwlpcnFfaHdfbnVtYmVyX3QgaHdpcnE7DQo+ID4gKwlzdHJ1Y3QgaXJxX2NoaXAgKmNoaXAgPSAm
dmdpY192NV9kYl9pcnFfY2hpcDsNCj4gPiArCXN0cnVjdCBpcnFfZGF0YSAqaXJxZCA9DQo+ID4g
aXJxX2Rlc2NfZ2V0X2lycV9kYXRhKGlycV90b19kZXNjKHZpcnEpKTsNCj4gPiArDQo+ID4gKwkv
Kg0KPiA+ICsJICogRm9yIHRoZSBEQiBkb21haW4sIHdlIGRvbid0IHVzZSB0aGUgc2FtZSBod2ly
cSBhcyBmb3INCj4gPiBMUElzLg0KPiA+ICsJICovDQo+ID4gKwlod2lycSA9IHZwZV9pZDsNCj4g
PiArDQo+ID4gKwlyZXQgPSBnaWN2NV9hbGxvY19scGkoKTsNCj4gDQo+IE5BSy4gQWxsb2NhdGlu
ZyBMUElzIGlzIHRoZSB0YXNrIG9mIHRoZSB1bmRlcmx5aW5nIGRvbWFpbiB0aGF0DQo+IG1hbmFn
ZXMNCj4gTFBJcywgYW5kIGFic29sdXRlbHkgbm90IHRoZSB2Z2ljIGNvZGUuDQoNClllYWgsIHRo
YXQncyByYXRoZXIgd29ua3khIEFsYXMgdGhhdCBpcyAoaG9wZWZ1bGx5IHNvb24gd2FzIC0gc2Vl
DQpiZWxvdykgaG93IHRoZSBvdGhlciBkb21haW5zIHVzaW5nIHRoZSBHSUN2NSBMUEkgZG9tYWlu
IHdvcmsgdG9kYXkuDQoNCj4gDQo+ID4gKwlpZiAocmV0IDwgMCkNCj4gPiArCQlyZXR1cm4gcmV0
Ow0KPiA+ICsJbHBpID0gcmV0Ow0KPiA+ICsNCj4gPiArCXJldCA9IGlycV9kb21haW5fYWxsb2Nf
aXJxc19wYXJlbnQoZCwgdmlycSwgMSwgJmxwaSk7DQo+IA0KPiBXaHk/IEknZCBleHBlY3QgdG8g
c2VlIGFuIGlycV9kb21haW5fYWxsb2NfaXJxcygpIGZvciB0aGUgd2hvbGUgVk0sDQo+IGFuZCBi
ZSBkb25lIHdpdGggaXQuDQo+IA0KPiBUaGUgd2hvbGUgYWxsb2NhdGlvbi9mcmVlaW5nIG9mIExQ
SXMgaXMgdXBzaWRlIGRvd24uIFlvdSByZWFsbHkNCj4gc2hvdWxkDQo+IG5vdCBoYXZlIHRvIGRv
IHRoaXMsIGFuZCBJJ2Qgc3Ryb25nbHkgc3VnZ2VzdCB5b3UgYWxpZ24gdGhlIHdheSB0aGUNCj4g
ZG9vcmJlbGwgZG9tYWluIGlzIGNvbnN0cnVjdGVkIHdpdGggdGhlIHdheSBHSUN2NCBkb2VzIGl0
Lg0KDQpGb2xsb3dpbmcgb3VyIG9mZmxpbmUgZGlzY3Vzc2lvbiBhcm91bmQgdGhlIExQSSB3YWNr
aW5lc3MsIEkndmUgcG9zdGVkDQphIHNtYWxsIHNlcmllcyB0byBmaXggdGhlIHVuZGVybHlpbmcg
Y2F1c2Ugb2YgdGhpcyBtZXNzIC0gdGhlIGZhY3QgdGhhdA0KdGhlIExQSSBhbGxvY2F0aW9uIGZv
ciBHSUN2NSB3YXMgbm90IG93bmVkIGJ5IHRoZSBMUEkgZG9tYWluLCBidXQNCnJhdGhlciB3YXMg
bWFuYWdlZCBieSBvdGhlciBkb21haW5zIGluIHRoZSBoaWVyYXJjaHkgKElQSSAmIElUUydzIE1T
SQ0KZG9tYWlucykuDQoNClRoaXMgc2VyaWVzIGlzIGhlcmU6DQpodHRwczovL2xvcmUua2VybmVs
Lm9yZy9hbGwvMjAyNjA0MzAxNTMzNTIuMzY1NDMyNS0xLXNhc2NoYS5iaXNjaG9mZkBhcm0uY29t
Lw0KDQpCYXNlZCBvbiB0aGVzZSBjaGFuZ2VzLCBJJ3ZlIHJlLXdvcmtlZCB0aGlzIHRvIGRvIHdo
YXQgeW91IHN1Z2dlc3RlZCwNCmFuZCBub3cgYWxsb2MgdGhlIGRvbWFpbiBhbmQgYWxsIERCIHZp
cnFzIGluIG9uZSBnby4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+
IAlNLg0KPiANCg0K
