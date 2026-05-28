Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011000.outbound.protection.outlook.com [52.101.65.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65742E737A
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779980419; cv=fail; b=LZVgzDKcKLje4zSM6J2y1luPeCdjnV3gjiS6Q2gLfGpI65YwRwoOAkRuMr5mxI/qf4Gx/io1N0KaZD53b4EZ8ScLMztvy2uQ30iBf29gGKLJG51ZD0GRB+Gn/6QxxdbLjPWxEj3zZKWav8opVfNKbhAvPa9eQk03zaqA7F6/CaU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779980419; c=relaxed/simple;
	bh=RWth6dq5GHQyOTwkGLTP1JJSScokfA8IwpZqYm4meQk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IMmIfQPxt29YvIT9DXeQOErDnKz75RuIewnXot+unpw4JO9sh89GfTi4trxqR2SjxNR0HJmk3YFdlLzq093CR21siUlwiIGHAJxhpWXqzxboMFJqwW33W+d7YAh1sIbszyX5S2V3LVvETHm3EA2RgXkHzJkBl+xrjOxHGp+ztLg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BZ1KL81e; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BZ1KL81e; arc=fail smtp.client-ip=52.101.65.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BZ1KL81e";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BZ1KL81e"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wwagCGAFpU8pXo4R2H2gRNE7YIiAiL+cU6B7Q57WC0CuNQIO0OK8p5HmroBh3zehjmU1QsqbuoqaZFCmglDEz7Z/onFYa3tZ+BYzJug93rZeXfwsKTkWbZyWQFHw8eWNBt3jtOLy4xJTu5zdkMuF+IDEGKuC0uHuZmoMHvDWajgnfrB+C8dn+4rkWqQTCPsv3tp6TZqEoFjvdscC47evWmPPWmPaS20Fgx4TMaMldeNZhMn9mvstXEhPe2TX0QII2aKlT36HhUTzD35k5PoWLsMoljSTVI6plY50SsJTl+18uDJWadYYQ+P4/fSsxMqkO3zi4VOKrIJmleM9I4Fcyw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWth6dq5GHQyOTwkGLTP1JJSScokfA8IwpZqYm4meQk=;
 b=WQZrzCDSuowLFBIALsBT9K/n9LxvpwcV6LW9BG6Dzl6EYUE5/5uSSxb6B41POKK8QejLoSSCUKgtpcvWwMVf+r0R/wZ97DPk20nEtnbgoKgBR1F2t1esIVAMrFqOfO1+jgSwUvHAWXnpLvXgYeuL0jnOOVGk44oIKCTAD548MNH9XkwYG5K4N6aorUIQ92fV3jo8xqp//YujZ0P+E+12qsl/MGQcVHg9ctyDzk1H1rYcm3V+QlWkNF0ULHfKkoxxtBQFXAFAObsHO4TVMReQK4paI9CuXw9QHwlPe9ZvMMAeBFIe+4LYe5tgjNS0t2gN2TftgPIOtrVNFqwazALgZw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWth6dq5GHQyOTwkGLTP1JJSScokfA8IwpZqYm4meQk=;
 b=BZ1KL81eMYQeljs47/ps41isD1HJ61ndBpHRLmNpA/Cr2o0MxB6GNu8QGsWDhlTDyaKVenzOKFSrr4MAFszNmbfq8wM7fGwLuXOLzQudfvNhxnzFYIyqlx9hNKW8OF7YNM25j3PtMKfJsg2jxxtZZf2JJnE9/mrcO2D86UbvOkg=
Received: from DUZPR01CA0079.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::16) by VE1PR08MB5773.eurprd08.prod.outlook.com
 (2603:10a6:800:1a9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Thu, 28 May
 2026 15:00:10 +0000
Received: from DB3PEPF0000885C.eurprd02.prod.outlook.com
 (2603:10a6:10:46a:cafe::ae) by DUZPR01CA0079.outlook.office365.com
 (2603:10a6:10:46a::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.13 via Frontend Transport; Thu, 28
 May 2026 15:00:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885C.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.5 via
 Frontend Transport; Thu, 28 May 2026 15:00:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhAipcqMFSUlrtxMdsA6IIWaQ443zLq8lzWdC5tnZVbW7YIKzIWYHRN0Z2e9H/X4385JFt+kKxruP+kJEPFl8mHLv4+zqMv1u7CQWnYB60j2h73M0P1QzrQGvkWPE+XTxKUwb+1B9CARscoVGws8V7BoSKNirRjM1G2oUREcYQHr7qmK3TTa3t5faWPoE5DJzFg+wzgDBwngnsawZrbxKVMOb3b4+qVx8YjZSz/UhfuuyEqscoe1394YROPIWgjvvsDC5kzvEOKrSlPKiCyg9Hyuz7B0v1f8HhYVuZuYExqb+znZEcXfm/01sWkW+Q63E9hNpB3aFOmAtGtRHvGDmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWth6dq5GHQyOTwkGLTP1JJSScokfA8IwpZqYm4meQk=;
 b=tDGCiA6jzLD7ZpbEwor+ezmkDU/6/R2ZQwJ8nYbHoTJBOX/L4It68ManGu8QKuphosWc1ANHXvWz+n34h+Hcwp3Jmm0DkG4gm/jIzUwcTPm9KtlWm8pl+S096wSvB0MTnTMLgld0IA4zJBPV2SWUtyKM3AiTpSeFtJNU+2XnpgpTZWQbsebLTch3zd0IwfN9hTGcDP3RWz0HGEwmeiPhMcsUfLx+25jbZcuX5EjwjaZfXme4AAVV+k8Emf9XnknFRrhdLxngOx1og/Cw4Z1sx4FVPnWbzbiYaP57qJO2fR6wrw7hkEzb4ZCgZf6EcWoEyxmmh4YTUoheScTL7EafTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWth6dq5GHQyOTwkGLTP1JJSScokfA8IwpZqYm4meQk=;
 b=BZ1KL81eMYQeljs47/ps41isD1HJ61ndBpHRLmNpA/Cr2o0MxB6GNu8QGsWDhlTDyaKVenzOKFSrr4MAFszNmbfq8wM7fGwLuXOLzQudfvNhxnzFYIyqlx9hNKW8OF7YNM25j3PtMKfJsg2jxxtZZf2JJnE9/mrcO2D86UbvOkg=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DB9PR08MB9659.eurprd08.prod.outlook.com (2603:10a6:10:45e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Thu, 28 May
 2026 14:59:02 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 14:59:01 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Vladimir Murzin <Vladimir.Murzin@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, nd <nd@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: Re: [PATCH v2 29/39] KVM: arm64: gic-v5: Support SPI injection
Thread-Topic: [PATCH v2 29/39] KVM: arm64: gic-v5: Support SPI injection
Thread-Index: AQHc6TJfvij4giVEkU64zIpTOnoa3LYgWFWAgAM6TgA=
Date: Thu, 28 May 2026 14:59:01 +0000
Message-ID: <07256383018aa8717bd4a221e032be9a8eb536f1.camel@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
	 <20260521144846.1899475-30-sascha.bischoff@arm.com>
	 <b87810db-a221-46c1-abf1-a0444fc8bd02@arm.com>
In-Reply-To: <b87810db-a221-46c1-abf1-a0444fc8bd02@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DB9PR08MB9659:EE_|DB3PEPF0000885C:EE_|VE1PR08MB5773:EE_
X-MS-Office365-Filtering-Correlation-Id: 2800c958-d546-4364-2a85-08debcc9cff3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099006|11063799006|4143699003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Pao+5V9pYsb1E493CnL5aOGeQDuRx3f5B7Bf5hrdzj/PGKxRFxuGmULIGWzRFKFbN0MuGYxh60XtHXVjU4rIKF02oxTIzA2aul8/hiOxbyVTv3aGYYT7/WmlKShxLF3JFXDTV/mP0Vx02aYzpKPX0M/MHgDkbXYvcSAN4E1hIyj/ZkAI+U8U7+8HRsDde3mFn65o8dd4gKgCOFhfoi3KQ7bSxpKLVImCwsNRSWeImCYVYKPcrIrCHPohgwYWGG8w34rLmgdOiPKhLNSp+jfUjsLq4E1sjhnae7P7RvUnFP6V4jdLdohPvfKk3jVDxG4dkv0iVYONWGYXp+K3ZHRlxdAkYBLQrVQnauBH0gEUBRlZzIz3CjLXHJNPqngTo9Hdqpb3CvKJQ1LNBj4xh4/zT8gyfURgqB9aNd/fSum526I8XkWBZHfuQSqc6wnt3SEke5HnFhmFNn4JQlbp3wQkK58hxXz3CWK37t5bRu/+7q5VuG6J6bvJvd7JFtuQWKLK1SdDNIzm1SZgh9VchQXWYF3lucxTXcUxQjqRt2+64fmHxqpbGxwE0vmKwgEi7lyyrxQ3AVx2UUH/ZsgWidcJmlmoNLkuZpihxs/YrPXZ6pF0AvjEeOHy8Wr1s5QhcNLRajV7UmnxbPJ9RxogknHBApgp12nouLe3e025NGAUfyq30sVRjSkpKOtBIFwM36gxPkbCLitjsGdtuq10Yg0GUw5rNogaHtxDbHKhBlVMTO4ZIT+l3n69+h/VeWn5h1Zn
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099006)(11063799006)(4143699003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <D621F8D1A71273429C00502A9E6ADF54@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 aplq5zKtqBuvX50E7P8YHyWk9X6U7HhXDBiZgPSeQQKFEORF3kt8QhiEEMZCWh8Y0GIk2fCcrjLmJEi3lsJL6KzuEZyf38RvSa5/yzxkF/4dRRGxtQnLMECuzbCDlEr48cma349huVfwyViaG3PkM0f2SrDeLo4A2E1Zfhp+CvO3u6xW7ovVc9PexvvMzecpTRrOglh6Pr4JzWvsNSeXuEbvT1pwzoreqfFgmz3WGFlOltD3Wa32IC9Vb915WbHzM+eo7UJnoCcDSq1Z0IG27b25E6lKm4I5RCeQjqSPJnZdL7evFImmijyn1hk37R9GnlGwB6IDIEmD1HNznb8wxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9659
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8279ff7a-628a-444b-f0be-08debcc9a77e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|14060799003|1800799024|82310400026|35042699022|22082099003|18002099003|4143699003|56012099006|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info:
	kCjOy6NaSVpLO6zDLDYVKEDRfAp6kljuZSy5SmacRyYIAOZlFvIrE7Nip6XUCb3DEBiMphW/326RyIMiM2pw6XZ7wHNx2gF2YrIfUsApzHP5Y169s03AQxIE40AaAgWYbmguMtRk55VEFari0WyKlPi8+mtZNb0BwHDB+/qu6LETqnpnTVSfCdwHhuRf5a0uGJ5Jy/jDJxUCrPY5XNevtD2pyT4P1LcD3oLiHLp8jpx6DelJwgDwnuYF8E2vAt8HHYLHrnuk+YzZwud1EdklNcpMLuwHL0yYjef+ZateZsYTCgZ6dfW3Cxdq0gjwHzL7qcnU2EHQ2qbo3MbbeyknjKJ+MEb/qQD1EmU4rQBnATuIPU8T4CyfALUTXv7spB8Y6T5xKlr0+pT+Ex1V+T320Hdo1ux1QsH67aOeccS7zbxQl3hcMbWFYBfpZZkJ68bpjwT3k1KsaW2sfzbQEbG3nYPOfrVGOg5brlqmda2iJz6JZIN5vUMK3tj7Snx2fyP5bU6kDnbop8ajVMox2jO0Rk0jOs5DwEpzZ/+qGJL7rzmBbhj6h1rb1oNLBrI2ougZSfNzx6xxMTE3lZoJZwvRMOLLG+ff7guIWsu3P4FrCl7iQHHSiSfTpINoqvm7eA195qbHcIteQVoJ8hZ4BhMB9PI9L/Q8C9RVIzlOyioyoE9FnhIQo2nWe02oiha25Gx3C2hOaT3Z6Xtstt5k6AlJh1GmVgsiEYEGTI/iT5sZYNc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(14060799003)(1800799024)(82310400026)(35042699022)(22082099003)(18002099003)(4143699003)(56012099006)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LF55BLODZ/p8ERPkPffc98LxgbzjakIjky/I2axg/pqM3WqOMBmhsTgaIXm39o494IcUOqrwHsvaqw2xHjEp9eQllLHby9gajpAJuZ+eqWM/SszFAxzwaWVYp0xDh9u1ry4iR17t0fgjD2k7I2w1/5p2C4XwU1wmo9cDmVv3rc1pSoxWREDtr40rMZxPEWUeM1jggGsYvsjsJ7atDb5bMUmNM60k42B/PJqiiahCcF3m9LfaOuwoes2O70wxD8lImZ2tzfXSEadhcbJU2+MzjSvC7zFlTS1zfHKKzoAqVVNW/enuCY2nff7ZfeMxsDDRf33nHV8tE0w7tSQze5SH5XW+7AVIKCRPbbcetedTG5GTCuESJjjpI5wDfEAiXmFS9B0QM1/aL763aUbvwcknDCH4c63OTcpGtKf1wrQn4AgbrOpNq71dTe6plHZZvtPI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 15:00:09.5406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2800c958-d546-4364-2a85-08debcc9cff3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5773

T24gVHVlLCAyMDI2LTA1LTI2IGF0IDE0OjQxICswMTAwLCBWbGFkaW1pciBNdXJ6aW4gd3JvdGU6
DQo+IEhpIFNhc2NoYSwNCj4gDQo+IE9uIDUvMjEvMjYgMTU6NTksIFNhc2NoYSBCaXNjaG9mZiB3
cm90ZToNCj4gPiDCoAkvKiBTUElzICovDQo+ID4gLQlpZiAoaW50aWQgPj0gVkdJQ19OUl9QUklW
QVRFX0lSUVMgJiYNCj4gPiAtCcKgwqDCoCBpbnRpZCA8IChrdm0tPmFyY2gudmdpYy5ucl9zcGlz
ICsNCj4gPiBWR0lDX05SX1BSSVZBVEVfSVJRUykpIHsNCj4gPiAtCQlpbnRpZCA9IGFycmF5X2lu
ZGV4X25vc3BlYyhpbnRpZCwga3ZtLQ0KPiA+ID5hcmNoLnZnaWMubnJfc3BpcyArIFZHSUNfTlJf
UFJJVkFURV9JUlFTKTsNCj4gPiAtCQlyZXR1cm4gJmt2bS0+YXJjaC52Z2ljLnNwaXNbaW50aWQg
LQ0KPiA+IFZHSUNfTlJfUFJJVkFURV9JUlFTXTsNCj4gPiArCWlmIChfX2lycV9pc19zcGkodHlw
ZSwgaW50aWQpKSB7DQo+ID4gKwkJc3dpdGNoICh0eXBlKSB7DQo+ID4gKwkJY2FzZSBLVk1fREVW
X1RZUEVfQVJNX1ZHSUNfVjU6DQo+ID4gKwkJCWludGlkID0gdmdpY192NV9nZXRfaHdpcnFfaWQo
aW50aWQpOw0KPiA+ICsNCj4gPiArCQkJaWYgKGludGlkID49IGt2bS0+YXJjaC52Z2ljLm5yX3Nw
aXMpDQo+ID4gKwkJCQlyZXR1cm4gTlVMTDsNCj4gPiArDQo+ID4gKwkJCWludGlkID0gYXJyYXlf
aW5kZXhfbm9zcGVjKGludGlkLCBrdm0tDQo+ID4gPmFyY2gudmdpYy5ucl9zcGlzKTsNCj4gPiAr
CQkJcmV0dXJuICZrdm0tPmFyY2gudmdpYy5zcGlzW2ludGlkXTsNCj4gPiArCQlkZWZhdWx0Og0K
PiA+ICsJCQl1MzIgbWF4X2ludGlkID0ga3ZtLT5hcmNoLnZnaWMubnJfc3BpcyArDQo+ID4gVkdJ
Q19OUl9QUklWQVRFX0lSUVM7DQo+ID4gKw0KPiA+ICsJCQlpZiAoaW50aWQgPCBtYXhfaW50aWQp
IHsNCj4gPiArCQkJCWludGlkID0gYXJyYXlfaW5kZXhfbm9zcGVjKGludGlkLA0KPiA+IG1heF9p
bnRpZCk7DQo+ID4gKwkJCQlyZXR1cm4gJmt2bS0+YXJjaC52Z2ljLnNwaXNbaW50aWQNCj4gPiAt
IFZHSUNfTlJfUFJJVkFURV9JUlFTXTsNCj4gPiArCQkJfQ0KPiA+ICsJCX0NCj4gPiDCoAl9DQo+
IA0KPiBKdXN0IHF1aWNrIHVwZGF0ZSB0byBzYXZlIGV2ZXJ5Ym9keSdzIHRpbWUuIFRoYXQgaHVu
ayBjYXVzZXMgbXkgYnVpbGQNCj4gZmFpbCB3aXRoOg0KPiANCj4gYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLmM6IEluIGZ1bmN0aW9uICd2Z2ljX2dldF9pcnEnOg0KPiBhcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMuYzoxMDM6NDogZXJyb3I6IGEgbGFiZWwgY2FuIG9ubHkgYmUgcGFydCBvZg0KPiBh
IHN0YXRlbWVudCBhbmQgYSBkZWNsYXJhdGlvbiBpcyBub3QgYSBzdGF0ZW1lbnQNCj4gwqAgMTAz
IHzCoMKgwqAgdTMyIG1heF9pbnRpZCA9IGt2bS0+YXJjaC52Z2ljLm5yX3NwaXMgKw0KPiBWR0lD
X05SX1BSSVZBVEVfSVJRUzsNCj4gwqDCoMKgwqDCoCB8wqDCoMKgIF5+fg0KPiBtYWtlWzRdOiAq
KiogW3NjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6Mjg5OiBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMu
b10NCj4gRXJyb3IgMQ0KPiBtYWtlWzNdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUuYnVpbGQ6NTQ4
OiBhcmNoL2FybTY0L2t2bV0gRXJyb3IgMg0KPiBtYWtlWzJdOiAqKiogW3NjcmlwdHMvTWFrZWZp
bGUuYnVpbGQ6NTQ4OiBhcmNoL2FybTY0XSBFcnJvciAyDQoNCkhpIFZsYWRpbWlyLA0KDQpUaGFu
a3MgZm9yIGNhdGNoaW5nIHRoYXQgLSBpdCBzZWVtcyB0aGF0IG15IHRvb2xjaGFpbiB3YXMgdG9v
IG1vZGVybiwNCmFuZCB0aGF0IEdDQzw9MTAuNS4wIGhpdHMgdGhpcy4gSSdsbCBtYWtlIGEgcG9p
bnQgb2YgYnVpbGRpbmcgd2l0aCBzb21lDQpvbGRlciB0b29sY2hhaW5zIGhlbmNlZm9ydGguDQoN
Cj4gDQo+IE9idmlvdXMgZml4LXVwIHdvdWxkIGJlIHdyYXAgZGVmYXVsdCBjYXNlIGludG8gY3Vy
bHkgYnJhY2VzLg0KDQpUaGF0J3Mgd2hhdCBJJ3ZlIGdvbmUgYW5kIGRvbmUuDQoNClRoYW5rcyBh
IGxvdCwNClNhc2NoYQ0KDQo+IA0KPiBDaGVlcnMNCj4gVmxhZGltaXINCj4gDQoNCg==
