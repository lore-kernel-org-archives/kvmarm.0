Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013062.outbound.protection.outlook.com [52.101.72.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4461035F60E
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 15:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786461090; cv=fail; b=ThwVVFfN3dDUBkOfGZXdcqiokCyA3gvoX7J4Y03RYqgiS1tfyRWyjsSbmiAjev7LRkfzGP7SxkRzn1/6HoR9wy8WADrJU1Qapj64Q9gwIUKZmYwmtU6UZUrSUsBSthhuX2gQcUoSIjJqqb2S2YZrQUM+Hnr2lc8a84b5F0gVzgE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786461090; c=relaxed/simple;
	bh=g0oBEVQewzJY4/qJOHyqIKfekHY5siimyPlXEPoVwWI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hUSP5tzTI40OuAwmFhM9fuAvTEXKx4C+mWWOsAFSNk1mkkYcxjweMg6o648hQ2HeWcvE1NIvUzTSMv6LRqMHeZ6CbTw8sN+gdLxzgrYqANLbWhBoCzbBgMI6hGa0vMX6U3XjeDwAhrVBIPlVZAxtk0KEC/ba+K3AGOG9XdRbSno=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sK4+pyOD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sK4+pyOD; arc=fail smtp.client-ip=52.101.72.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sK4+pyOD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sK4+pyOD"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=edVmVlhnXWt3WrwTTv6FBTr8q295AHHzT0oMTpp4emc7fbnx1Tcvgr5kDNIZ+VSIaQl6mOr6a+Bf/Jw9cV3YcyphDReRWiqkrgpi7Y7L7Aa9NwVEJGk5Onj9VzNm9ek4iSilP2mvYw+mk+jk9KtCWo19ydofgLE0KF5ELQdS4ueB2QJC3hJkQf3wsmwRx+I3qkq1lD/SeJEesICd0iOVmJR5avBr0eqZ8XSNlrDVWVuJ+dE0KZykpvxY8+VQnAhgg7/ak0A2KWDaIrTB/0scvylatFOAXfOfbSijxXEc0BxikjCw63AandufKylILH+192WXbQaL9VfSmE5z+Km0KQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0oBEVQewzJY4/qJOHyqIKfekHY5siimyPlXEPoVwWI=;
 b=RGEW7HGbUglNkn2kweuPf8oll+0TLdjMrLQhkpdTcl+cizIyUQbRpCEbwO0SX6Ee19ktqSomvJHUYRWIvVPwDmZeN2/qTFqJqZolUIqTZe3YIPGNQRARht+JOURhI9wBE5zAh9ZD/3GObQiQijzix6MstPK0DPDwE0hgpO+CmiGDhh1f3SJC5fzCI/ClYRj4S8ZLoyMjE9eAJM5IdKeqdh3++OIFXi8khZv5ysl7vRvMhSjqS5eZVXO2HIdeUaBaQqxJxHPdU/+woGOSTqp/vegLRYfF/be1rJGidjnyxCozjf4zgBqK+rmOvBjhfhfq+z87G5dmMUm/VwWS/03ljA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0oBEVQewzJY4/qJOHyqIKfekHY5siimyPlXEPoVwWI=;
 b=sK4+pyODOui0dtaBi9AWIXe8pN34dqV5HJvDNdsLrhG9SCkPIpauz47E0rltUaXRTXf5YcEH6mQSAvoybsoAdy7505RmIwe40/FadmXYO0TTrkTFKWr46X5/TldahV+J0mRggn2Zpn+9CxwO/iyKpyTKLClAMLYMVwNYumZRk14=
Received: from DU2PR04CA0264.eurprd04.prod.outlook.com (2603:10a6:10:28e::29)
 by GVXPR08MB11422.eurprd08.prod.outlook.com (2603:10a6:150:2e4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 15:11:20 +0000
Received: from DB1PEPF000509EA.eurprd03.prod.outlook.com
 (2603:10a6:10:28e:cafe::60) by DU2PR04CA0264.outlook.office365.com
 (2603:10a6:10:28e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Tue,
 11 Aug 2026 15:11:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EA.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Tue, 11 Aug 2026 15:11:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q6QXWKwNgvIt+O32S0toSUTjD5+2CCuiiUl72MlDyb6lSUelgpIUUE/HttV9nFa/npqKnhyK2Ol53ORWUxEBUyafyjPi6wmPkv23eBnTx+HUE2odV/IluE0b6nT3lOs+b/mJN9ldgsi1mPoIqR16uTzcK2RRjhMyr0cCX2w5lrTNjQJfLViJnarfj23rS4IQuRqhOhHIYD1PF+pM7C+JhYCcf8v55g+AcsecwRv6H0FLLtTYS3t+QVPYpHsaKaOpTf8vg298e6Znge5avnXxhgxazhMeJoVyZX/cECdXevEoE+4Xw5s6YL68ZzxkdXtcUYawQCRW97OX8SWxWQeMDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0oBEVQewzJY4/qJOHyqIKfekHY5siimyPlXEPoVwWI=;
 b=FUE+f1uOR0nerAXPOat6n+wyqgiU3nxc5PboMGY4WxDXhnpNR+DllDoJd18wUwCLozbiYsytvMCtpuLKM3IC5VGl4nj+JjaKbcquyQDNhHdbkvYRU/aLsqio7uX26jKPLTbiy80rQXhaYHR8MuHnS6nXF8y6m6FUS4/WiUjOHkfVI904xv1NvFO9OlFBNQrzI/zuKJ3V3BnAah/whUv0bW3phUPWI3kTzfzYs524iLc5iFxIN/iXy+HH7SVQqAQ9bybS1Y1xZQRSfmh73cApdjIDTiie8iBn+7ifzXe7p4SIPGqTppKrqUPIY0FkBQiGzFvN0Fs28KxZWTT9ErP59A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0oBEVQewzJY4/qJOHyqIKfekHY5siimyPlXEPoVwWI=;
 b=sK4+pyODOui0dtaBi9AWIXe8pN34dqV5HJvDNdsLrhG9SCkPIpauz47E0rltUaXRTXf5YcEH6mQSAvoybsoAdy7505RmIwe40/FadmXYO0TTrkTFKWr46X5/TldahV+J0mRggn2Zpn+9CxwO/iyKpyTKLClAMLYMVwNYumZRk14=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM7PR08MB5413.eurprd08.prod.outlook.com (2603:10a6:20b:10a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 15:10:47 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%6]) with mapi id 15.21.0315.008; Tue, 11 Aug 2026
 15:10:47 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: [PATCH v2 2/4] KVM: arm64: vgic: Prevent speculative SPI array
 underflow
Thread-Topic: [PATCH v2 2/4] KVM: arm64: vgic: Prevent speculative SPI array
 underflow
Thread-Index: AQHdKaOW5EQ5YJgugUaHLZjmh/wAZA==
Date: Tue, 11 Aug 2026 15:10:47 +0000
Message-ID: <20260811150941.941295-3-sascha.bischoff@arm.com>
References: <20260811150941.941295-1-sascha.bischoff@arm.com>
In-Reply-To: <20260811150941.941295-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM7PR08MB5413:EE_|DB1PEPF000509EA:EE_|GVXPR08MB11422:EE_
X-MS-Office365-Filtering-Correlation-Id: bb4d37f7-f6e7-46ab-4331-08def7bacc68
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|56012099006|11063799006|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 R7kxCo5pfnGE5lS+j22gyPgtzt/WkVNuUFG4k37XupxUXQLTVc6VscCP7yUlSOLPsPIc5k5Ybg5iborwZ1Po0cr45fVJyfGjvpkzI3T0CelWRJTCuu0psVdrPNCGM0ur6ttf4LK4Rw1Z6jHXeaymTV5C2+RZxi56C6w5FHaSonQNnsk5uH4Oo6m2zqdXCLfPCIzfgchuBZ/mPHbC/GmrhipP31288YaEsV0hR/KbbM0T/Hbajc5gGAQ/8vWPqsArKW6oHc3NUDOiEmEAMBjfTdM9M2jXSDV27f5+X5o08qwMfy3pkkCy2BUNIZ4j7e3/JtR5Zrk7xC2bJ4hna7WSAMJWoewolqkcFK9s8T3Za1eKNBmtcIRkI2vzwyyL09YSa4Vr8HC1DqPfkK1OqgM0unyvycuVvKy83rEnp9NmsttBv0rFe2NfZtT3Xo9YEz4+/kNgqDGyT6uiADHGBda52uGCIy6PUQiEx8WguZ7e0n05HpE32kNAIILPP3NUjYYz8SktryNuLmZRd4ygdDDpYJIR6jDDXmIjVtMVFoMkfhyeyOqGpqBlSmCIKS/vH7QXE+YDrrsMSM0GZry5pXbLRW47N5+K1Gi9PtS3F1MylobsYWzfTVq59GkGhYPebKxUGR9xvPs7/k4SrclXvzI5HBixybbZNeRV/Ha+qqyor0A=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 m0hJZsAI1ULk+44J1MzUlGSj5MYN2mLjieyeahBP16B+gqTzDzzVY0ZGenoUArlv2WkY6QwZ0RDau6SBBOwtalDfrqommZIMx1uvIY9IU88nmY53ESZ/H7iAYlEPoCV4H2XEGAQ+a156ss3PSSDeVYz8Nd9lYfJI5HxzoIwWv0eYthaA1m9CrBupMwiDb6jyS5Z3EfxQrs6Y2qm+t44Heh/ZhuqhZM8uM8G+48KsO5zjkzkmC+rS/SWG5iQesZbiRdmsR9tjnQLuN2H1/+mPvImj+zcz6kntYWH+w2M9brGfERUDMr27SpZZHNEA4dBGAL+hyG5D6WOfHhfy9SF5fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5413
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EA.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9221b134-c809-4801-6a07-08def7bab93b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|23010399003|36860700016|14060799003|376014|1800799024|82310400026|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YvZy1kuBLM9nvSbMKiy56xkS7T4uWjmAtNcm/huG6RjSsnaISjl/un4g1YJ8TjbYDiFBqUp+DSfVMI8gFLmRts3jdCO+gzG8DaSDlQ/bjYM1Sea97HkoaNbWwwU6VXhILlRu49c9OijlllSGQX/vwnaUDUnlzLyvoV8Uftct20I7ZEGhXNQC7e3fusLS9C+Sw/XYoK3Uj5al0KQdck+af2rAzr1nB4KlvV/MIsQDP93+SeeR+TsDcbBZuQaRe2WqmuZLCPuRlJ/UN6Tz7IcjTSmln39wHSHLSvqQs2IacZt0YSBt0K8uzgDKnG0guxDn3Gd6YG+5Xk3OBK5oJ7LkZYtb8JvGeFvP+VYz7+h1zxFkkQo4diavDO/GCpD2tvObjlOBrtShrk9T13cT5rp53dP8QsfBF450whzOJ0whrb82VeV/0jXtHAHiuZsqwnIQVwjrMnqpD/cm4+p7yjdo/1BrvSPuE+eGGEhZNF7Qo/ZxDm9ilbaKLW0TeJBbGG/rYjrIxHCkYk9ZtYHgK5YI7VgaQyqXfnkyHiuHCQrha5DNNuB5t4LefwditOIZ+laB/jfAOVrNvgBKJPzmPOMSAczIQCI+k/zzcT5/rkpwvIcEFlwY7W7mif/LbL82D13C8q3iixSI3n4sWBMk/6Jl6g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(23010399003)(36860700016)(14060799003)(376014)(1800799024)(82310400026)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cZ3VF/TQS0bNTwrFvdp9yWAUhCKWUhSsKytUvcPnAcDn547Hy7sAvZA5UnGo+TQwQU08SaVBsztPmNVschND77J25untbdO+JVdY1mC779VXC61nk3KezD85hicm5d/cKR8QyeWU4V7AV0oUL6QE6//ZF2JymAsQKD9wedaEx5AoK9BMEl5e22N5XX6uItw+0yPdbIl/zAewMnk/1gYVp748dDJ16lpxL5DHIAWhCq6RBcbqp/uMwRoDErHLSDhajJJFXdhny04gWx6XK7CtV7Q3lU/PfeKCuVWY+B+1wrTAJKeFh0O5/qNAHh0TzK7MGuzAq1/2Hsbiy7y56e/F2nVWy/LlgZLEz8lUAprhna25MfEGd6CIeMGdvdk2II6tDanet2+A3ovX87wR26az9RbRifpaYGDLcSClhATTWbJI7cYutB803kWSsE4w4w7x
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 15:11:19.7524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb4d37f7-f6e7-46ab-4331-08def7bacc68
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EA.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11422

Rm9yIGEgbm9uLUdJQ3Y1IFZNLCBTUEkgaW50ZXJydXB0IElEcyBpbmNsdWRlIHRoZSBwcml2YXRl
LWludGVycnVwdA0Kb2Zmc2V0LCB3aGlsZSBLVk0ncyBTUEkgYXJyYXkgaXMgaW5kZXhlZCBmcm9t
IHplcm8uIFRoZSBsb29rdXAgYXBwbGllcw0KYXJyYXlfaW5kZXhfbm9zcGVjKCkgdG8gdGhlIGFi
c29sdXRlIGludGVycnVwdCBJRCBhbmQgc3VidHJhY3RzIHRoZQ0KcHJpdmF0ZS1pbnRlcnJ1cHQg
b2Zmc2V0IGFmdGVyd2FyZHMuDQoNCk9uIGEgc3BlY3VsYXRpdmUgYnlwYXNzIG9mIHRoZSByYW5n
ZSBjaGVjayBmb3IgYW4gaW50ZXJydXB0IElEIGJlbG93DQp0aGUgcHJpdmF0ZSByYW5nZSwgdGhl
IGNsYW1wIHByZXNlcnZlcyB0aGUgc21hbGwgYWJzb2x1dGUgdmFsdWUgYW5kDQp0aGUgc3VidHJh
Y3Rpb24gdW5kZXJmbG93cyB0byBhbiBvdXQtb2YtYm91bmRzIFNQSSBhcnJheSBpbmRleC4NCg0K
Q29udmVydCB0aGUgaW50ZXJydXB0IElEIHRvIGEgemVyby1iYXNlZCBpbmRleCBpbnRvIHRoZSBT
UEkgYXJyYXkNCmJlZm9yZSBhcHBseWluZyBhcnJheV9pbmRleF9ub3NwZWMoKS4gVGhpcyB3YXks
IHdlIGVuc3VyZSB0aGF0IHdlDQpjbGFtcCB0byBhIHJlYWNoYWJsZSBTUEkgSUQsIHJhdGhlciB0
aGFuIGFuIG91dC1vZi1yYW5nZSBTUEkgaW5kZXguDQoNCkZpeGVzOiA0MWI4NzU5OWM3NDMgKCJL
Vk06IGFybS9hcm02NDogdmdpYzogZml4IHBvc3NpYmxlIHNwZWN0cmUtdjEgaW4gdmdpY19nZXRf
aXJxKCkiKQ0KTGluazogaHR0cHM6Ly9zYXNoaWtvLmRldi8jL3BhdGNoc2V0LzIwMjYwNzI0MTA0
ODE5LjEyOTY4MDMtMS1zYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT9wYXJ0PTI3DQpTaWduZWQtb2Zm
LWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KLS0tDQogYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLmMgfCA1ICsrKy0tDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy5jIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCmluZGV4IDc0YmFjZTEw
YTIyZWQuLjM1MmQ1MmJkNjMxNWMgMTAwNjQ0DQotLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMuYw0KKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCkBAIC05Myw4ICs5Myw5IEBA
IHN0cnVjdCB2Z2ljX2lycSAqdmdpY19nZXRfaXJxKHN0cnVjdCBrdm0gKmt2bSwgdTMyIGludGlk
KQ0KIAkvKiBTUElzICovDQogCWlmIChpbnRpZCA+PSBWR0lDX05SX1BSSVZBVEVfSVJRUyAmJg0K
IAkgICAgaW50aWQgPCAoa3ZtLT5hcmNoLnZnaWMubnJfc3BpcyArIFZHSUNfTlJfUFJJVkFURV9J
UlFTKSkgew0KLQkJaW50aWQgPSBhcnJheV9pbmRleF9ub3NwZWMoaW50aWQsIGt2bS0+YXJjaC52
Z2ljLm5yX3NwaXMgKyBWR0lDX05SX1BSSVZBVEVfSVJRUyk7DQotCQlyZXR1cm4gJmt2bS0+YXJj
aC52Z2ljLnNwaXNbaW50aWQgLSBWR0lDX05SX1BSSVZBVEVfSVJRU107DQorCQlpbnRpZCAtPSBW
R0lDX05SX1BSSVZBVEVfSVJRUzsNCisJCWludGlkID0gYXJyYXlfaW5kZXhfbm9zcGVjKGludGlk
LCBrdm0tPmFyY2gudmdpYy5ucl9zcGlzKTsNCisJCXJldHVybiAma3ZtLT5hcmNoLnZnaWMuc3Bp
c1tpbnRpZF07DQogCX0NCiANCiAJLyogTFBJcyAqLw0KLS0gDQoyLjM0LjENCg==
