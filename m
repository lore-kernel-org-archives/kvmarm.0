Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013000.outbound.protection.outlook.com [52.101.83.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219F5368D71
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733599; cv=fail; b=mdPGc2fMtcOqu56rJ5prmOpGPdKoLUK/6sBFhQu57mwcHDVkih+EFrIjqfJLvT7JrYXNxaMewbspItcE2WkHDRh7W/xtCBw0Orlg76uLe4V8V7jlfX95nntASO5YxP+Nd+f2hLMu7M3Ya55HAqPcp2lyBPALQEovZn/FBzASMoQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733599; c=relaxed/simple;
	bh=9qp9J6RyAT0+SloJ5CjVM5ZALwbTaBkDGVN34ZiLfAw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CBYuFoOZl5xydedlhNtAPW3Gix/HatSvkUkv2l5WSTMyCbcoy66fF5t88vM6QO4QrqlIays4onVfC60lY+paMw8KmmC5SgsBxf1nhig532vFiXaB/IC0Y7f+wGqOCtJnW04NdPUZnJwdkFF/ClIvgSUzGdsQnmEoXDqMG+vB4k8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZY2BELHL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZY2BELHL; arc=fail smtp.client-ip=52.101.83.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZY2BELHL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZY2BELHL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SNgc09p37orPabTIFHIq+Tyxf5sH7ZM5hgZ1xfCllJjAEv6UN0K5iitaSJ7qT+PF8Yyjihhpd0pBVDO237npUZ6DoSkKfs+6HJcQXU2R6rbb0fPjleC8EUv1sAApu9KXt8D2BTTJL7iTtVhIM1ZnGRlUAyrd+V420gQSSwn+v+/cmB5/bUbrSMbdu7LWjosQaihr64gsm4j0ZXqCOtC+Vusuw4sqCEQCBba/OugI7FzQSJEH/wWBis/smJdKgIYy+Sy74JnmWMmObFglwGPsowUdJ9MPgT1d8UiLAncgO3BmcOdRHJ3gqcJxnzksi1ofY66IOYTvFbh3TMX3hglYXw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qp9J6RyAT0+SloJ5CjVM5ZALwbTaBkDGVN34ZiLfAw=;
 b=jAzD8epMRezk0nawfITkcBxfDUnpux2PkOLc9Tbv7DvUArhNPQFXm8ETsmqxfaV+un6yebBp6zV8f0ApBsxDygaZezwaRehNlkSw0cvAgrhr07fQav2TnCkiDw97eHfPlSKU5OYjd7HHR6uOyxHkAOx+75ouAxlUr94tjrnNhkCBsp9boF8B5JWNoDR6uqTlDIGBIUih8ZUydYMwFCtlvDwDMcTPXt0D1RV5wTNUaW0inufErdbHUY29SG9a0DVNK83aneY7gKTvWx8LVDEVHrJ+f5aozic7FoA009BEJ4Fs3Wl8ZkGw24wFsOatLlwxFmdnIO7fWknRbehQ2O6CUQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qp9J6RyAT0+SloJ5CjVM5ZALwbTaBkDGVN34ZiLfAw=;
 b=ZY2BELHLUtwJtsRl22o38y09/XTH5wcnvstpNMBxawKg88g5vEdabmmrQDDGftmwqDzeUXHRE2QsDMjqdnHKZP5vzPEjAVhopsIG8Gok6oKGvS3F94LsZOqci2oiItiIymD0GGoqzHVwgva0beVlVwr7QhILkHr1I74K4Wye0jU=
Received: from AS4P191CA0020.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::8)
 by DU5PR08MB10774.eurprd08.prod.outlook.com (2603:10a6:10:529::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 15:19:48 +0000
Received: from AMS1EPF00000094.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::ad) by AS4P191CA0020.outlook.office365.com
 (2603:10a6:20b:5d9::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Wed,
 22 Jul 2026 15:19:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000094.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Wed, 22 Jul 2026 15:19:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vH3Aryy0UOjZaDD2HAxAyOt95mwy0HXxpWLBRff2lzKqawc92q2lpapZUnem25D6Vs+t77MqO1+qx7r6WeHJ38cKk0ZhZgId8Zlda881nG6/CktAFx9Q0JWzSxTE2heI4ByjrECEMRBMujpscH9P7aKV8esNoYYkw8tvtMqHkzgcUKtSkbxATH6QM3aUeUUhvdeorqXAhH9M/Zl3y/GJ/JvHtjiA+Gm7f6W/q+bRvYFiXSbidLsN9aaGFmsedqMS2Eu2lPzUY/UU/PogBcfBxRvK/bnXtleYHKhfxsCTMVsN3dmbbJwvN1VtFyGwE9PIvcgA7lbskhpn4yZAwFALvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qp9J6RyAT0+SloJ5CjVM5ZALwbTaBkDGVN34ZiLfAw=;
 b=SCi0K1nbkeZB7LvhNe76q7MWxyrhV9Plop8mYi+wjuKvOItLNpTDJ4BaV8slCnB0Ft45bh0jsODmlIOqSTFg6hi1ufjM/7LVKoi2YLkX2++dB3p5wyHF/SFsZAY3d64wHsFYiX5cD5Vim7fGniQslFqe08nzzR/+Xuyv4O+SV9Nuz/pmZZMjXKCXKgDHmxmYl1eRPqHzJ0pPEYW/ZJtc2+ZqQp5LaD8YIaPKfnRvfoNewCax5Ymo5udbCU0YHeLuuVh2RGs5gPNu3mEypnwC6zvz7kmPkJpEZISVJRoHLWS9Oa+SmIO5OB15sSSLLij4eBF84rJz7Tn7uw7XXp9RLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qp9J6RyAT0+SloJ5CjVM5ZALwbTaBkDGVN34ZiLfAw=;
 b=ZY2BELHLUtwJtsRl22o38y09/XTH5wcnvstpNMBxawKg88g5vEdabmmrQDDGftmwqDzeUXHRE2QsDMjqdnHKZP5vzPEjAVhopsIG8Gok6oKGvS3F94LsZOqci2oiItiIymD0GGoqzHVwgva0beVlVwr7QhILkHr1I74K4Wye0jU=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM0PR08MB11755.eurprd08.prod.outlook.com (2603:10a6:20b:743::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 15:18:44 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 15:18:44 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 36/40] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Topic: [PATCH v3 36/40] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Index: AQHdCwY9RuzT3CHCBEOJ2vP6xGx16LZ4OOMAgAGL1IA=
Date: Wed, 22 Jul 2026 15:18:44 +0000
Message-ID: <71dc44828b55c848ca7bc842cb13b34681617ac7.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-37-sascha.bischoff@arm.com>
	 <CA+EHjTybDSAgr44jXNFnssnYq_vVeuZ+1qORS8f4dtQgMzOZ5A@mail.gmail.com>
In-Reply-To:
 <CA+EHjTybDSAgr44jXNFnssnYq_vVeuZ+1qORS8f4dtQgMzOZ5A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM0PR08MB11755:EE_|AMS1EPF00000094:EE_|DU5PR08MB10774:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fca3a69-6d57-4bc9-22b7-08dee804aa37
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|38070700021|7136999003|56012099006|10067099003|4143699003|5023799004|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 2TTrLUfCU6GFoKnB6EULjqN+GaV/3SxazdYrgU3IwuUQ1IPDbdQLhlSmWKMGLQCOl9WlStA/xL+t+YpFUN3U9v2oASTq8RXvNNm1b76G8qKazA8x5i8e7zcDJzyrJTZ7y0pCgTEH2jDfUEI+ou5LXnkxhvKhWcOjpgTrmT1J68wQa7zn7UwojPI3wuk8qBVjLLpbU8XZspgiDSx6GZpZh2dxIEfF4SpUZr4yDS7dxSnwhZ+Ke271zm8zQJ72JDuPS+dHnNTf0Cg+BVTV9xtewpADP7QdpHdxIojeYN9Txpct3JHOWcdt8I7HyyRBoTxdPdtLGdlNFTXW/1+/Y9RGk+f1uaD/D5SPesc49LPS8fhcT5G9x3l3w93EbutZPfW4Zjf0jcdpbFR4zMbAHHQQcmgqrLGbpA2u6pwIBdpSRlHVG2nsnvr5ODwx9Amz9nCLN34s0xIv079sZv3WXwUcm0AKKJr963ISzZt7ZkD4QqC4JiXCAVycVeq5wO8Il6GaxOznUZD3ck6sftltk6z0eHrcAV8PFNBvWYiTo2BLqLsWkSNkgPf4ifmdKE7Tw0zIYwjUX0aIw4rwkH7hm8xzRo3bHG6xeoAKzPEc4mHfNgbAtUTs9W+5s6GKwfW2vD/6CWpXiLBU6TNIeITYpw5xoR3AbHNZ9g9rzsKpgeB1DM9Q7wi4zyueCpCGFvNPe+nMlCXV6hiyfwpj9yxSNprvRFY6y6LkAfrsf96zHWhSJDw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(38070700021)(7136999003)(56012099006)(10067099003)(4143699003)(5023799004)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB042E72264A82468D6D9BA852B45B28@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 sq65djVis+9YFUx8fT144redF6Kuk67E5D06kykGeZMugQtVR45OgGAnPuUXCISTPqChG+OCQqNkTbksBDqXiP/7L4uozKKr3HOqHPUNdFOZ7JMUGnY0Oy8ALxwp4bKXf6cn0eR93Y3QiPEAP2u7IHqDmZOvjNHgC4jF5bxfnDK9pEH0hsYWV1i2goKzfjdxwa1eVhXQhwFm3fSzGQyXf3vwB+zAPJRxdUbwT8Y2mQXZCDKtr4i3TUqS868Y+VfEu//rws1GsiIRKsDxX5iQgOg6p2vPKRTr1JmpmR715fEAsXJB6SXFR34jD3CgN9+fR6WOXQnpSGR8Zw4UUNfaSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB11755
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	836a85e7-a91f-4455-eb6b-08dee8048502
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|35042699022|14060799003|82310400026|376014|23010399003|5023799004|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003|3023799007|7136999003;
X-Microsoft-Antispam-Message-Info:
	4YfFkj2F2cnAaJHW8LPzVPH8/ZBoiQw6zfLcajZFLynF/nY08rkpNdkrkqN976Ph2uzaZ9Pl6CduI1fslDtWvRb6Z1ibW6WTmvFPZiYlcMGrzx0owXiRBRodXnY6CwrbGFv1lTwPDts7Sl8xbL0aBjKEX/TWAy3N9eJnw6x94E/pJQru9hloVRHfanK9dumWwbvzrkn41u24fRc67O57ICiA5CJcKyfUOBG1QZ78ouhTrHDYbAUnqENk/oO6WxwgKOmy4UqHbCUoNqjl36Sqj9gl+70c8AEcYwKt58WUjJ6IhKM81nrVBouJNBsOj3W9ZBNLa4xjLQztegD8PT3yTOCiZioX2HUru5Dzvj1OI9+r+Mh5CzykdQpip6352GvPrNJGjJRvvoPGPNv/zD18906GU9TPY5xFuooNQiT1Cjp0e1Vy6TEZP7zOE68DEdtd+lw3Bw/qQe/LNCENGViTW+hFgpnwGXoptAr1MC8ATkWYBWXae9XKlNYEPlR1aFdHJjBJBeut2QtEibgU2XBfQ996hHZeXtpuUYRQPG4wUdebj8EQ1ghBvbVZKh+895tIdAZnslzKns2D9K5aVdcxXF5Hi13K+3nHBTmkqDMAP6Nuy/gp0s48HcwVPVcBYHr3BeJo4/CMl1jm6sdD+ahLbJWDvgebU2VzQ2AK7P+HRXRQVJh8ShGzYCZn3/OZadYbaHfS920kyFyILzghdE62Ug==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(35042699022)(14060799003)(82310400026)(376014)(23010399003)(5023799004)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003)(3023799007)(7136999003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cukrfoCggy39G/6+WdnAkl8qH3yKrOofCG01Oi3H23hsmhNdETn6fL36JzYmZfzdt/pOe0aFRim4HuaToAq3qe/bIK1COICSTrjVK36pouyiKLqGNvJatzr57qI7UybFzWbRP7/pmOVarbJ+IDJyq9H6BS6cQUFPQ9c/5iGNuUkK3HSvTiMKeeG/dBk7wfO7oFhc3sDUhjPQB9tbAt+e+wQFKRNcgubtLOfMIDXfTkZbbt607TuOsnJE5gf578pIHhX1bHzeyGQDq2i3VpPq7pc5vk7MSZPUioS1r3jtCHQg3cxhR8jD4Q0is1gykRVKD3qj59TETui4xrsuXT/Fy7f5FEfPp3LQ/KX8zI8n8+yXBoWTEdpONHSiHT1dVaU8kaK/UQRPh3zcnZ8nqAks4/EuSz61wMrrKnH05F74iMgkO0Js2byQ7Z9kcHOc4twp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 15:19:46.5405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fca3a69-6d57-4bc9-22b7-08dee804aa37
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10774

T24gVHVlLCAyMDI2LTA3LTIxIGF0IDE2OjQyICswMTAwLCBGdWFkIFRhYmJhIHdyb3RlOg0KPiBI
aSBTYXNjaGEsDQo+IA0KPiBUd28gdGhpbmdzIGFib3V0IHRoZSBuZXcgS1ZNX0RFVl9BUk1fVkdJ
Q19HUlBfSVNUIGludGVyZmFjZS4gQm90aCBhcmUNCj4gYWJvdXQgdGhlIHVzZXJzcGFjZSBBQkkg
cmF0aGVyIHRoYW4gdGhlIG1lY2hhbmlzbS4NCj4gDQo+IC4uLg0KPiANCj4gPiAraW50IHZnaWNf
djVfc2F2ZV9zcGlfaXN0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9kZXZpY2VfYXR0cg0K
PiA+ICphdHRyKQ0KPiA+ICt7DQo+ID4gK8KgwqDCoCB1MzIgX191c2VyICp1YWRkciA9ICh1MzIg
X191c2VyICopKHVuc2lnbmVkIGxvbmcpYXR0ci0+YWRkcjsNCj4gLi4uDQo+ID4gK8KgwqDCoCBm
b3IgKHVuc2lnbmVkIGludCBpID0gMDsgaSA8IGt2bS0+YXJjaC52Z2ljLm5yX3NwaXM7ICsraSkg
ew0KPiAuLi4NCj4gPiArwqDCoMKgwqDCoMKgwqAgX19sZTMyICpoX2lzdGVfYWRkciA9IGlzdC5i
YXNlICsgaSAqIGlzdC5pc3RlX3NpemU7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoCBoX2lz
dGUgPSBSRUFEX09OQ0UoKmhfaXN0ZV9hZGRyKTsNCj4gPiArwqDCoMKgwqDCoMKgwqAgcmV0ID0g
cHV0X3VzZXIoaF9pc3RlLCB1YWRkcik7DQo+ID4gK8KgwqDCoMKgwqDCoMKgIGlmIChyZXQpDQo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gK8KgwqDC
oMKgwqDCoMKgIHVhZGRyKys7DQo+ID4gK8KgwqDCoCB9DQo+IA0KPiBUaGUga2VybmVsIHdyaXRl
cyBucl9zcGlzICogNCBieXRlcyBpbnRvIGF0dHItPmFkZHIsIGJ1dCBzdHJ1Y3QNCj4ga3ZtX2Rl
dmljZV9hdHRyIGhhcyBubyBsZW5ndGggZmllbGQsIHNvIHVzZXJzcGFjZSBoYXMgbm8gd2F5IHRv
DQo+IGRlY2xhcmUgaG93IGxhcmdlIGl0cyBidWZmZXIgaXMgYW5kIHRoZSBrZXJuZWwgaGFzIG5v
IHdheSB0byBjaGVjaw0KPiBpdC4NCj4gVGhlIHNpemUgaXMgaW1wbGllZCBieSBucl9zcGlzLCB3
aGljaCB1c2Vyc3BhY2Ugc2V0IGVhcmxpZXIgdGhyb3VnaA0KPiBLVk1fREVWX0FSTV9WR0lDX0dS
UF9OUl9JUlFTLCBvciBuZXZlciBzZXQsIGluIHdoaWNoIGNhc2UgaXQNCj4gZGVmYXVsdGVkDQo+
IHRvIDMyLg0KPiANCj4gcHV0X3VzZXIoKSBoYXMgbm8gaWRlYSBob3cgbGFyZ2UgdGhlIGNhbGxl
cidzIGJ1ZmZlciBpcy4gSXQgb25seQ0KPiBmYWlscw0KPiBpZiB0aGUgYWRkcmVzcyBpdHNlbGYg
aXMgbm90IHdyaXRhYmxlLCBzbyB3cml0ZXMgcGFzdCB0aGUgZW5kIG9mIGENCj4gc2hvcnQgYnVm
ZmVyIGxhbmQgaW4gd2hhdGV2ZXIgaGFwcGVucyB0byBiZSBuZXh0LCB3aXRoIG5vIGVycm9yDQo+
IHJlcG9ydGVkLiBUaGUgZG9jdW1lbnRhdGlvbiBzdGF0ZXMgdGhlIHJlcXVpcmVkIHNpemUsIGJ1
dCBub3RoaW5nDQo+IGVuZm9yY2VzIGl0Lg0KPiANCj4gSXQgaXMgYWxzbyB0aGUgb25seSB2YXJp
YWJsZSBsZW5ndGggYnVmZmVyIGluIHRoZSBWR0lDdjUgaW50ZXJmYWNlLg0KPiBHUlBfSVJTX1JF
R1MgaXMgYSBfX3U2NCwgVVNFUlNQQUNFX1BQSVMgaXMgYSBfX3U2NFsyXSwgR1JQX05SX0lSUVMg
aXMNCj4gYSBfX3UzMiwgYW5kIG5vbmUgb2YgdGhvc2UgY2FuIGJlIGdvdCB3cm9uZy4NCj4gDQo+
IGt2bV9kZXZpY2VfYXR0ciBpdHNlbGYgaXMgZml4ZWQsIHNvIG5vIGxlbmd0aCBjYW4gYmUgYWRk
ZWQgdGhlcmUuDQo+IENoYW5naW5nIHdoYXQgYWRkciBwb2ludHMgYXQgaXMgc3RpbGwgcG9zc2li
bGUgd2hpbGUgdGhpcyBpcw0KPiB1bm1lcmdlZCwNCj4gYnV0IHdvdWxkIG5vdCBiZSBhZnRlcndh
cmRzLiBXb3VsZCBpdCBtYWtlIHNlbnNlIGZvciBhZGRyIHRvIHBvaW50IGF0DQo+IGEgc21hbGwg
c3RydWN0dXJlIGNhcnJ5aW5nIGFuIGV4cGxpY2l0IHNpemUsIHNvIHRoYXQgdGhlIGtlcm5lbCBj
YW4NCj4gcmVqZWN0IGEgbWlzbWF0Y2g/DQoNCkhpIEZ1YWQsDQoNCkkgdGhpbmsgdGhhdCB0aGlz
IGlzIGEgZ3JlYXQgaWRlYS4gSXQgbWFrZXMgYSBsb3QgbW9yZSBzZW5zZSB0aGFuDQpibGluZGx5
IHRydXN0aW5nIHRoYXQgdGhlIFZNTSBoYXMgZG9uZSB0aGUgY29ycmVjdCB0aGluZy4gV2l0aCB0
aGlzLA0KS1ZNIGNhbiB2YWxpZGF0ZSB0aGF0IHRoZSBWTU0gYXQgbGVhc3QgY2xhaW1zIHRvIGhh
dmUgZG9uZSB3aGF0IHdlJ2QNCmV4cGVjdC4NCg0KSSBndWVzcyB5b3UgaGFkIHNvbWV0aGluZyBs
aWtlIHRoaXMgaW4gbWluZD8NCg0KICAgIHN0cnVjdCBrdm1fdmdpY192NV9pc3Qgew0KICAgICAg
ICBfX3U2NCBzcGlfaXN0X2FkZHI7DQogICAgICAgIF9fdTY0IHNwaV9pc3Rfc2l6ZTsNCiAgICB9
Ow0KDQpXaGljaCB0aGVuIG1lYW5zIHRoYXQgd2UgY2FuIGRvOg0KDQogICAgc3RydWN0IGt2bV92
Z2ljX3Y1X2lzdCBpc3RfYXR0cjsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQog
ICAgc2l6ZV90IGV4cGVjdGVkID0ga3ZtLT5hcmNoLnZnaWMubnJfc3BpcyAqIHNpemVvZihfX3Uz
Mik7ICAgICAgICAgDQoNCiAgICBpZiAoY29weV9mcm9tX3VzZXIoJmlzdF9hdHRyLCB1YWRkciwg
c2l6ZW9mKGlzdF9hdHRyKSkpICAgICAgICAgICANCiAgICAgICAgcmV0dXJuIC1FRkFVTFQ7DQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IA0KICAgIGlmIChpc3RfYXR0ci5zcGlfaXN0X3NpemUgIT0gZXhwZWN0ZWQpDQogICAgICAgIHJl
dHVybiAtRUlOVkFMOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgDQoNCiAgICBpZiAoIWlzdF9hdHRyLnNwaV9pc3RfYWRkcikgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQoNCj4gDQo+IFRo
ZSBzZWNvbmQgcG9pbnQgaXMgdGhlIExQSSBJU1QgZ29pbmcgaW50byBndWVzdCBtZW1vcnkuIEkg
dW5kZXJzdGFuZA0KPiBmcm9tIHRoZSBjb21taXQgbWVzc2FnZSB0aGF0IHRoZSBzaGFkb3dpbmcg
aXMgZGVsaWJlcmF0ZSBhbmQgdGhhdCB0aGUNCj4gZ3Vlc3QgaGFzIGFscmVhZHkgYWxsb2NhdGVk
IHRoZSBzdG9yYWdlLCBzbyB0aGlzIGlzIGFib3V0IHRoZQ0KPiBpbnRlcmZhY2UgcmF0aGVyIHRo
YW4gdGhhdCBkZWNpc2lvbi4NCj4gDQo+IFNhdmluZyB0aGUgSVNUcyBpcyBhIEtWTV9HRVRfREVW
SUNFX0FUVFIsIGFuZCBpdCB3cml0ZXMgaW50byBndWVzdA0KPiBtZW1vcnkuIFNldmVyYWwgb2Yg
dGhlIGRvY3VtZW50ZWQgb3JkZXJpbmcgY29uc3RyYWludHMgYXJlIGVuZm9yY2VkLA0KPiB3aXRo
IC1FQlVTWSB3aGVuIHRoZSBWR0lDIGlzIG5vdCBpbml0aWFsaXNlZCBvciB3aGVuIGEgcmVzdG9y
ZSBpcw0KPiBhdHRlbXB0ZWQgYWZ0ZXIgdGhlIFZNIGhhcyBydW4uIFRoaXMgb25lIGNhbm5vdCBi
ZSwgYmVjYXVzZSBpdCBpcw0KPiBhYm91dCB3aGVuIHRoZSBWTU0gc2VyaWFsaXNlcyBndWVzdCBt
ZW1vcnk6DQo+IA0KPiA+IFRoZXNlIHR3byBzdGVwcyBtYXkgYmUgcGVyZm9ybWVkIGluIGVpdGhl
ciBvcmRlci4gSG93ZXZlciwgdGhlDQo+ID4gZ3Vlc3QgbWVtb3J5DQo+ID4gbXVzdCBiZSBzZXJp
YWxpc2VkIGFmdGVyIHRoZSBJU1RzIGhhdmUgYmVlbiBzYXZlZCwgYXMgc2F2aW5nIHRoZQ0KPiA+
IExQSSBJU1Qgd3JpdGVzDQo+ID4gdGhlIElTVCBzdGF0ZSBiYWNrIGludG8gZ3Vlc3QgbWVtb3J5
Lg0KPiANCj4gQSBWTU0gdGhhdCBzbmFwc2hvdHMgZ3Vlc3QgbWVtb3J5IGJlZm9yZSBzYXZpbmcg
dGhlIElTVHMgZ2V0cyBubw0KPiBlcnJvciwgYW5kIHRoZSBJU1QgY29udGVudHMgc2ltcGx5IG5l
dmVyIHJlYWNoIHRoZSBkZXN0aW5hdGlvbi4gTGl2ZQ0KPiBtaWdyYXRpb24gbG9va3MgZmluZSB0
byBtZSwgc2luY2Uga3ZtX3dyaXRlX2d1ZXN0KCkgbWFya3MgdGhlIHBhZ2VzDQo+IGRpcnR5IGFu
ZCBhIGxhdGVyIHBhc3MgcGlja3MgdGhlbSB1cCwgYnV0IGEgc3RvcCBhbmQgY29weSBzYXZlIGRv
bmUNCj4gaW4NCj4gdGhlIG5hdHVyYWwgb3JkZXIgd291bGQgbG9zZSB0aGVtIHNpbGVudGx5Lg0K
DQpZZWFoLCB0aGVzZSBzb3J0cyBvZiBpc3N1ZXMgYXJlIGV4YWN0bHkgdGhlIGNvbmNlcm4gd2l0
aCB0aGUgY3VycmVudA0KQVBJLg0KDQo+IA0KPiBXYXMgYSB1c2Vyc3BhY2UgYnVmZmVyIGNvbnNp
ZGVyZWQgZm9yIHRoZSBMUEkgSVNUIGFzIHdlbGwsIHRoZSB3YXkNCj4gdGhlIFNQSSBJU1QgYWxy
ZWFkeSB3b3Jrcz8NCg0KV2hlbiBJIG9yaWdpbmFsbHkgZGVzaWduZWQgdGhpcyBBUEksIEkgd2Fz
IGtlZW4gdG8gcmUtdXNlIHRoZSBndWVzdA0KbWVtb3J5IGhlcmUgc28gaGFkIHF1aWNrbHkgZGlz
bWlzc2VkIHRoaXMgYXBwcm9hY2guIEhvd2V2ZXIsIGxvb2tpbmcgYXQNCml0IGFnYWluIG5vdywg
SSB0aGluayBpdCBtYWtlcyBhIGxvdCBvZiBzZW5zZSwgZXNwZWNpYWxseSBhcyB3ZSBhcmUNCmxp
bWl0aW5nIHRoZSBndWVzdCB0byAxNi1iaXRzIG9mIElEIHNwYWNlIC0gdGhpcyB3YXNuJ3QgdGhl
IGNhc2UNCm9yaWdpbmFsbHkgd2hpY2ggYWxsb3dlZCB0aGUgc2l6ZSBvZiB0aGUgSVNUcyB0byBi
YWxsb29uIHNpZ25pZmljYW50bHksDQphbmQgaGVuY2UgaXQgbWFkZSBtb3JlIHNlbnNlIHRvIHJl
LXVzZSB0aGUgZ3Vlc3QncyBtZW1vcnkuDQoNCj4gVGhhdCB3b3VsZCByZW1vdmUgdGhlIG9yZGVy
aW5nIHJlcXVpcmVtZW50DQo+IGVudGlyZWx5LCBhbmQgYnkgbXkgcmVhZGluZyB0aGUgd29yc3Qg
Y2FzZSBpcyA2NTUzNiBlbnRyaWVzIGF0IDMyDQo+IGJpdHMsIHNvIDI1NiBLaUIsIGdpdmVuIHRo
ZSAxNiBiaXQgY2xhbXAgb24gdGhlIGd1ZXN0J3MgTFBJIElEIGJpdHMuDQoNCkkgYW0gYWN0dWFs
bHkgaW4gZmF2b3VyIG9mIHRoaXMgYXBwcm9hY2guIEl0IHJlbW92ZXMgdGhlIGFzeW1tZXRyeQ0K
YmV0d2VlbiB0aGUgTFBJIGFuZCBTUEkgSVNUcyBvbiB0aGUgc2F2ZS9yZXN0b3JlIHBhdGgsIGFu
ZCBhdm9pZHMgdGhlDQpleHBsaWNpdCBpdGVyYXRpb24gb3ZlciBndWVzdCBtZW1vcnkgdG8gc2F2
ZSBvciByZXN0b3JlIHRoZSBMUEkgSVNULg0KDQpXaXRoIHRoaXMsIHRoZSBwcm9wb3NlZCBzdHJ1
Y3Qgd291bGQgYmVjb21lIHRoZSBmb2xsb3dpbmcuDQoNCiAgICBzdHJ1Y3Qga3ZtX3ZnaWNfdjVf
aXN0IHsNCiAgICAgICAgX191NjQgc3BpX2lzdF9hZGRyOw0KICAgICAgICBfX3U2NCBzcGlfaXN0
X3NpemU7DQogICAgICAgIF9fdTY0IGxwaV9pc3RfYWRkcjsNCiAgICAgICAgX191NjQgbHBpX2lz
dF9zaXplOw0KICAgIH07DQoNClRoZSBWTU0gd291bGQgbmVlZCB0byByZWFkIHRoZSBndWVzdCdz
IElSU19JU1RfQ0ZHUiBhbmQgSVNUX0lTVF9CQVNFUg0KdG8gZGV0ZXJtaW5lIGlmIHRoZSBndWVz
dCBpcyB1c2luZyBMUElzIG9yIG5vdCwgYW5kIGhvdyBtYW55IGl0IG5lZWRzDQp0byBwcm92aWRl
IHN0b3JhZ2UgZm9yLiBJZiBubyBMUElzIGFyZSBpbiB1c2UsIHRoZW4gYWxsb3cNCmxwaV9pc3Rf
YWRkci9scGlfaXN0X3NpemUgdG8gYmUgMCwgYnV0IG90aGVyd2lzZSB0aGUgc2l6ZSBtdXN0IG1h
dGNoLg0KDQpEb2VzIHRoaXMgYWxpZ24gd2l0aCB3aGF0IHlvdSBoYWQgaW4gbWluZD8NCg0KPiAN
Cj4gQ2hlZXJzLA0KPiAvZnVhZA0KDQpUaGFua3MsDQpTYXNjaGENCg==
