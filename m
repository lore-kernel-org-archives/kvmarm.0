Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011044.outbound.protection.outlook.com [52.101.70.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B466433859A
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306711; cv=fail; b=uBSoNDCMcqryS5Of8qODbEh9YEQyGQgIVdz+J9V1tmt+C7P7iJelqjZxvsxXrTo0MUfE0SQfnP8XClAhptEnGxlLeZizz+8jikHw1SJHjifKdnyY/1zhMbQMrhsKmWwsyI6wllDapcpeysOv2Eq+uLEJdjcXbqWMXjwW8TVjQ+w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306711; c=relaxed/simple;
	bh=DsaoKPpN/Zx6z9+HzrV+VjPgGytS7Czp36yYdT6affQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hWDVgfyvBn9DGKrUyL6IPa8CDgtblRelBGMaGGj7LCbYSN9oB6YQjsYBovskIiqV+WY4vo0xLF96BLTckPHPSINJTimcY6BA46f+j9LELB+a2IsOD4qAhhFZe0UcPl1l01SfN/VDbKNOw5cRFCOv7RGc6mV8ulReo9ze4Dff6/c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kNEvSNwC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kNEvSNwC; arc=fail smtp.client-ip=52.101.70.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kNEvSNwC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kNEvSNwC"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NaJ/K7+WGZt3Vo7ihjGOhD7I0I1k1CXLMyDMKwELGc1xE4pH8ii4+AE2GlK4wQCJvJLp0KOTLWJPwOg/efk7Yjdn7twsu2NT4g45PtkMdQ08dCnlsOVI6+8tjNhhAB9qWRO6Khbat2qzWc0bAQi9nBMN4H7C9GWtImm4aLtRiDGd6mA4MFF/tMp7FaOSnEyrYYf7pvNUIjnbDhB7oG0bbJ22hr0h6bGT1UOsQYw8548ggXhwnsTd/dgtO6GJCCjbKSVg7DrlokZlcXFGq7lUwCIDDsCrm6gEkon6wdy9RLCCemCRpP7OJSbM1X/drQ6vNqKgD5AopPZDu5VdeVcM9Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTILmSqHruFHcUTwB3eynSyh+AWpKC6k7+Rc2Xrhpq8=;
 b=tQQnFgzV7KCyyGpmbebc+UTMCfepO5dsp3jMq1GBpK9d4jKFzer7znYxMo2orqB7N1lNlowh1xl06IBlbFQ35F2xyPZ7b4N/VspKysPfESG0f6+4q0ol/TZdzyQ0qwcV6aTqf1aFYV30kG2O0iM07xaRsTaL36f5Ih0NAwoDHmIwXF3lAnQQTT35ojPNP+GDqPmtOSeh2C9zpxvlGuIu58jaUxvMQWtGxAMeiirYJ+IHVCx4VjW5HuyHwlxHMsJLP4s5UttWUSlTEqYyl3V6brevwTy2C2Xaj/WcUi6S6I1HArkTxmZ2yQSNbdLfoQY8eApdpFn3eygQkPIx5DAkZg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTILmSqHruFHcUTwB3eynSyh+AWpKC6k7+Rc2Xrhpq8=;
 b=kNEvSNwCBE+4Gt74RPEW6GdrmLuYjurkXnY65phmHRGwceodcqfxC9GqQ0UJ0bSOPvbRj3hI9A+zqTOklklasLVcFCN27d+bwZfLyDTZ8sNyDGRoAXWXroPP8hFPXvdzN4ZWj+ECeJJ3fG/u/PZTO+IdIxnSR5HoKXxftwJQbT8=
Received: from CW1P123CA0004.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:293::15)
 by AS2PR08MB9199.eurprd08.prod.outlook.com (2603:10a6:20b:578::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:18:24 +0000
Received: from AMS0EPF00000194.eurprd05.prod.outlook.com
 (2603:10a6:400:293:cafe::14) by CW1P123CA0004.outlook.office365.com
 (2603:10a6:400:293::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.52 via Frontend Transport; Mon,
 27 Apr 2026 16:18:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000194.mail.protection.outlook.com (10.167.16.214) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:18:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWmX959TvVxuTNM5PHvsm0mREd6iXtzzcb38w7ZNExoxk2U6nfPK/UIDqyFjdFpbcSGrCb1AibrAAnBJ/GZE6g1/AGokww9NaSMO59BuwtvW4l9sdtZ1ltMJQrDdjJBIvGKMdVG+hrzH/j1Lv7CMorPqfsBD185s8606RCEfDQIZeTG5M6+CRnTkFn+7RmqtGljlsQsvPlrBxCaYnYkdNWL9uWG2iYNednRIrqReStXGoJzf76aPXzzsAPoE9J3FLfGC49lsxiNN+0LZyvsD764ZNawhBIAsqHACduNJY9+iDnHoCdOXnF5MY2rFezusS0ZzrfZqm69RgZZuhP2M3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTILmSqHruFHcUTwB3eynSyh+AWpKC6k7+Rc2Xrhpq8=;
 b=jQJnCizRI/cihuIgCfGcP814OLnF92B9zhaJMIQghS50z0Im96OeA8boexBGeOCc/jlm1grRIPoKsnqAbTIHfQGwHpeWW8aqDnPOvjYKKk6rdpQaAAH/+0qW3aaekgK93qfQPxvw2rx7Qb6z3bA5LtbysATqgE5L/ZG0dtqgrmoReQPbpG9dHKkEdWXBYNyfmzr3fGydpXQF4cDVq/WpsIKhO12W1V1Cgp4SKmefhbJ3SpWdnwHfKnd4KjvOvvqYVC3c8ibNWoZoWlPIguZ/Xw893JI4RixLksFdfF7lCuKbkxHbg8J5/64VdQ54LQoKg3DRgymaPpbFmmWQC9RgyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTILmSqHruFHcUTwB3eynSyh+AWpKC6k7+Rc2Xrhpq8=;
 b=kNEvSNwCBE+4Gt74RPEW6GdrmLuYjurkXnY65phmHRGwceodcqfxC9GqQ0UJ0bSOPvbRj3hI9A+zqTOklklasLVcFCN27d+bwZfLyDTZ8sNyDGRoAXWXroPP8hFPXvdzN4ZWj+ECeJJ3fG/u/PZTO+IdIxnSR5HoKXxftwJQbT8=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by AS2PR08MB9919.eurprd08.prod.outlook.com (2603:10a6:20b:545::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:17:18 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:17:18 +0000
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
Subject: [PATCH 33/43] KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
Thread-Topic: [PATCH 33/43] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Thread-Index: AQHc1mFRu6wTCL4UHkGVpp0z0Q2X7g==
Date: Mon, 27 Apr 2026 16:17:18 +0000
Message-ID: <20260427160547.3129448-34-sascha.bischoff@arm.com>
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
	VI1PR08MB3408:EE_|AS2PR08MB9919:EE_|AMS0EPF00000194:EE_|AS2PR08MB9199:EE_
X-MS-Office365-Filtering-Correlation-Id: 46156de2-686b-4d14-3f65-08dea4789b3e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 kksKOxTJYF+N3pbkYsIpzxQWg8Y8bqfRspzB7MuRZqAlyOPutXmKvSgw5FGyXVbsA4nJPkr7/3jLWRupU8OSjMmot0U+LQgLL833xeQvlIx9H7NAN6lZlAlllzpiV57MJ1ltpyzf5siqEda04vv7GA3Ox3abyZ1pbUlGI0+AFBbjh62QJj3rn/l5jF/CDC4nzHaodIXCcHcOB7unj2t7Kvxh+8G8nX/fbAQ8qU2UNLE7TPdDrXtUOg7Lnf7j3SfbQdq1xkVNki82Og3EbSiyrVD9HULOCVQ/R6Iiz2hwZsaiAghoDvRvAYJk8mbzow6EdeM+BVyOD3RE5aH/Z+Mq525W9sjU1bbd+8q50+Pe3zzYUBEK2mgApk1hMauUARgP9LRzn//71QY2qnJ0ng7ASP+XqAd25BiwqAAPyPTPeMpSDCQPtmPiv4OP8cT0BZtGvfS4G5y9Xh6O82tdpOucToOk+Sk9WayGHGCIi7YnoyjHHPEVQ0r/7g4AwousMWkwGS4FcZolU3+4kQxARLLi9c3l1o7vYkEde9Jg+fac8cstBau6y8FMM1m+vsd3F80iNOs88d8WeBqbhMIsQF/YeUUetqGgDxT7pSRQzpgFXVxmZQVGdxeHVrB29DUEpz7FwZJLtSVWyN2yk4aoI7N/N2bffNU0qKLOvKpkHMrCfIWZSc9VeYJA0WduvVcltJyyf0mADx7ne81vdcVf+qRVFMQdU4Ckrkxu5YQqIxoQfdNwA1W5so6w/9gUYZyF/4uV66MxFJIVVoxv4iSCOP5BjbtWVCzEH64zFugHnNyWZb8=
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
 LjdENxixauTMyFX4jI+u246dTME4RdN4S9YKUeScJt8ehhDSv5sffKDEeaporTTmJ4TLUNcIAlBpG3FoDmM64zSKRuQKSuflDRelUw+1rcGHtuJWkgEuyk2tfV4Zw4528uSozwoJp/+GPrd7cCd/EG4Rm5ryLxi0ayHcFFTKaKK8my4LGusrsUXVQUiczO2bmk8N1+2BImnxLq1lRssd4GstnBcogOPZUlV+Py2P3740gI+yFUoBMqfWz3KwP/g10J79BGYNpZoSdT0QbSx+FtAKU8AvfssmNFC7k7j2htCGWP3RvixzPgmIJv4Ia2GXoN6uBAwZPZyttVEnJSDj4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9919
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	94ff47a7-1e75-46bf-ae2c-08dea478744b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|35042699022|376014|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	wRbTAfgNH/a2LK71nbntMcR1UGJH8MwJCZ+slpXG9CTJwyBuIdQBKCokQMowIkAn1sd0x9WvvVXHGMT/JsmYvekru8D3uYXRu+WoWK6T4NudHYW4h4STwK3DP13ggomF4loyMiIETbljAk/zVyh35wPZlG1wlEfy4vogGb2vO5Xm/BS+WwVJtgdYXQI78K5i777k25UT9BBT8d5bRACy2nP/oU0X2Ue+8Ts50eeH3Jyp7k6AyJjggDdN9JyvasJpmsQknzc9s+mMC2nr8B1tL6ZESdrGbnT1XOV4eBLd/IJCsgPmvbnh7qOsljPDalrx23W6ugX6SBxGQ9cCGiPcyL9kWS9dKno21oD2PQ46C2PKh2c1JZUh4Jv6nPBBW+IGEvc+OOLAbNg9iJVZBrWLw64vU2Vdcf/mM9aqKxk7P0/jEI53lHU6s26aOiQhJ129wz+hVOxNdd2CHLgpj9AmrxxFzCCLbVC3EC7UNNxhCmOBNqfjgWONgj8ypv/buo5ZpQPDrDHI9Q5wjCuVcTJ9Ho6JMUtj6FpqZgq21E2Xb5v7a5PW+zIp6AJkM7bFxwDTNBBvfqPbTPZRqT7HW9Vd8l/dCXtTB9b7USoBFHS3nw3OlhwFATDpY07eikWjM0fq7nqbDnoPhzOPR5lGmKej7gX47TE64bWq5iuFHJNmeyZECf5QCYhRjZSzdGl9jfCAcAGwnOSkKFLSgod1WvAygyWRe1s7caapBjXkdZyeFjIii5Ye/cPIRW1mMSR7MYJXMgdJrKzFK3HnBqrFcXZXFw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(35042699022)(376014)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vl6SPLzmkMWTlmKx0bs8Tr+DrzYwLd+/LvhOK0irjxCNMRozvGXlZ/Nk34LGdzoiz5G3SF8OZ+RysiMbvMa56gpood8GGrW9pA0tWsbBFxJK5TitN/ThStFFWixv+fgb2TYoLU9XY/wdketIGbQEnXh733obj33ZHZ6aZuHqH1Eh3sFLxTBvQ5+F7uQUe+I4b2gmhx0mv65VodpmVOu/SjHO5B5gFkq8WiHyxseEbmqQie/vIVU//gFfIsBVH8OiTWzQLNOwOXejyLHAE9RG6GnAgE+tSTDDZhawuWrqq/yz0HR2FI3uSOV+deXQNQBSCU627fv1fBNT/9W2xLHiQayQAsoCZKYIKFebLBVjQIIswDdTyPfNdkFAA2jmSl57II+QDRCa7UOCZMV2WXsmZf82cnWvG7AV/HRHM+AuEo6xPbXmpxk0BQVzrGA7D9ua
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:18:23.9723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46156de2-686b-4d14-3f65-08dea4789b3e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9199

Now that there is support for GICv5 SPIs in KVM, update
vgic_irqfd_set_irq() to handle GICv5 SPIs. This allows their state to
be injected via that interface.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-ir=
qfd.c
index b9b86e3a6c862..3b9ebd8e367be 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -9,6 +9,8 @@
 #include <kvm/arm_vgic.h>
 #include "vgic.h"
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 /*
  * vgic_irqfd_set_irq: inject the IRQ corresponding to the
  * irqchip routing entry
@@ -19,7 +21,12 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_rout=
ing_entry *e,
 			struct kvm *kvm, int irq_source_id,
 			int level, bool line_status)
 {
-	unsigned int spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+	unsigned int spi_id;
+
+	if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		spi_id =3D vgic_v5_make_spi(e->irqchip.pin & GICV5_HWIRQ_ID);
+	else
+		spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
=20
 	if (!vgic_valid_spi(kvm, spi_id))
 		return -EINVAL;
@@ -39,6 +46,8 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
+	unsigned int nr_pins =3D vgic_is_v5(kvm) ? kvm->arch.vgic.nr_spis :
+						 KVM_IRQCHIP_NUM_PINS;
 	int r =3D -EINVAL;
=20
 	switch (ue->type) {
@@ -46,7 +55,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->set =3D vgic_irqfd_set_irq;
 		e->irqchip.irqchip =3D ue->u.irqchip.irqchip;
 		e->irqchip.pin =3D ue->u.irqchip.pin;
-		if ((e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS) ||
+		if ((e->irqchip.pin >=3D nr_pins) ||
 		    (e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS))
 			goto out;
 		break;
--=20
2.34.1
