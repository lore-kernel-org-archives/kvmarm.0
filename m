Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013040.outbound.protection.outlook.com [52.101.83.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A87025B0BF
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.40
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375538; cv=fail; b=LjxJW8qdZK5kL7fS5AcdCP0D3Xx2ymyT3es1VcFFb9beSHwI6AYMQ/9hfS+d9HO6AIMUof5nJ9IkuebqHYF5vtZu92BEyTaz01Ldr2R3tCVpAWqwk45SyqJY49Vm++HcppUNbwgLQdf+rCkTCgxdNvUX7+nEjBXALwshScrK3YE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375538; c=relaxed/simple;
	bh=qUwftLel544pjXTvNUfVs4ddzhIXtd3bXMGKtkmFOAs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O/+yQXGpCjGUqeJGbuk5o0pa+gYf5zQzCPWxymOMLafh8zd6aUEKtHGAKPjLmIq+BTOV6IcwLdlsUfT+LtKb5hhcrESb/Z9DZvvZPziPGE59jQX/6pVo0/Kh/uQaDty938Lw1+sMPcyYJP1bZyFlc7nG+/T98TEoxlMKD8fCP4I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qKDV1pmR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qKDV1pmR; arc=fail smtp.client-ip=52.101.83.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qKDV1pmR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qKDV1pmR"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=N981Fqr6+aS3ZMMmRH2aFa6QNGo3so91vBcQzYD39osTLqdcwo8GaqiOUtqf4Z2aCSXvbP4MJsW3oqB0tUuPNIwGcWGIrTYsqNSuzlPVck032Bm3C5vI/cg6vzVx4sCEcikOpuQiY0eW9zkR4Wql/HKzcXeVkC9a8mw/mxKPbULRU5qHDd5obV3y64lCQZMdFQS/v25X/OLvL9xkXD8oWyN0G1ALE0dfJg376/3FrNfnHQc7Tzn2wJgvBMxt52PnLD68eu56ZaSdgelm7mTSFaD8M/SfIV9LqSm2iHV5ItDuuIrP2s8oBGfApBDuWGzLBSDmeQsWlA6gzq2vH7Yt+Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHl7kJk8RZLPxhVjtel5Yy3JCB97ii0err4OytnIHHU=;
 b=O1Izh4uwn9jCVzBDlmRuMGWLZwfDpwHSuPJpZUBe6K6usR+Y1XvqSZh0uIPJ49ZKHHzwlTeczWmakgdSDCjGMilxmBUOVjF1TrPZxG7WkKzOoMFHzMr6NkbYG8V9K+fOicV+le6VMivzFoj2MG21qq1PVkLQpVijHzQWEj2ymeJuZzKM09KAFbaVQrXjZerchkIYSzlSn0b78HQHfwE/jB0mP44vkXFfUh9BKMjpgjMSy4uZxC99+TupkLiXI/pfkcF4R3tyMJ+0h4syL2kRPgckKHyp5fpdDN7c5NYsoAmP9q9RfB3rKV1gOrrb/x5ZjSkxh/D2LpkueaWryyMZjQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHl7kJk8RZLPxhVjtel5Yy3JCB97ii0err4OytnIHHU=;
 b=qKDV1pmRlvvywFTzfBIbvpQw7qinlb0JJaYonk414NDnQeogIIffAesQ45Qxjgzp30f/y0SaK2aOop+/2WORB9vht5dKcKbdXfV8u7MLf9obddKNbD2TkJLQc3Wz4RtVdFrYK5SBUOoYxyfToocrZmeOFviIB7EY+zOidmSmOOg=
Received: from DU2PR04CA0022.eurprd04.prod.outlook.com (2603:10a6:10:3b::27)
 by VI1PR08MB10123.eurprd08.prod.outlook.com (2603:10a6:800:1c7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 21 May
 2026 14:58:48 +0000
Received: from DB5PEPF00014B9C.eurprd02.prod.outlook.com
 (2603:10a6:10:3b:cafe::78) by DU2PR04CA0022.outlook.office365.com
 (2603:10a6:10:3b::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:58:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9C.mail.protection.outlook.com (10.167.8.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:58:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7gMs38o+apH6waJ/HxkxZR0axWcIPQ3MVCtV6v42zZbBRDqf9ZLYFBgED5Muu69wVsc4coUxso7TjOz3M0nvhLrTC+D2xvkVxQZBhA833HeFkyvkx6N/zK1W5UcVgJLMiq1x7siMKD1/8/jjTnaxwRPYRZ9BOmYkkHAa1MeZbKRZn8roZXaXKY32oEY6dd7hzfzRPDQL1Da52OAacB33WPvhIxPQBwKAQiHRs9HEQeu2PcFCguLsMyQhj6R6azcTM0qI8ZZSsOpZyXPN/hRRJU0dyx16cmSnhcIzAY4+Y4d1InbqwairdFYpmr49Ke8jFukGI/VDZUzTTYk6qWkog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHl7kJk8RZLPxhVjtel5Yy3JCB97ii0err4OytnIHHU=;
 b=lgnCCMJdu7Umgv0mwrM8Yp7rLHCSH4KWypJ9XwVvUbMmo/szYuifmpquWgBazeJ9AspZntt25si5yD0Yxw7GuVb1ygz4/woruvYXDOLl2ng+kaV1Fei8cuK5+vWJ/Ify8eQF+SFZpH38piMi7wyZhwA5YWGpAxSX2mqABec1M6UovTrpoNUlit43FloZXfvKH9LkaNS+eTbD9AiDB0uvcmq+zSMRPW6bU/hCFSSSPLUJ1saR23n1XA/ZWlfMj2lcbuNiQz6wS6eR4PTrkNxPK57LLMeSFNtjbpBYDvpBex8jA6dtopNIfJyv5F5+3aKhqdyviqxXNWC9NUdnTcTMgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHl7kJk8RZLPxhVjtel5Yy3JCB97ii0err4OytnIHHU=;
 b=qKDV1pmRlvvywFTzfBIbvpQw7qinlb0JJaYonk414NDnQeogIIffAesQ45Qxjgzp30f/y0SaK2aOop+/2WORB9vht5dKcKbdXfV8u7MLf9obddKNbD2TkJLQc3Wz4RtVdFrYK5SBUOoYxyfToocrZmeOFviIB7EY+zOidmSmOOg=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by PAVPR08MB9209.eurprd08.prod.outlook.com (2603:10a6:102:30a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Thu, 21 May
 2026 14:57:45 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:57:45 +0000
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
Subject: [PATCH v2 25/39] KVM: arm64: gic-v5: Introduce SPI AP list
Thread-Topic: [PATCH v2 25/39] KVM: arm64: gic-v5: Introduce SPI AP list
Thread-Index: AQHc6TIuX53tam4aUES+L++gddPCgw==
Date: Thu, 21 May 2026 14:57:44 +0000
Message-ID: <20260521144846.1899475-26-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|PAVPR08MB9209:EE_|DB5PEPF00014B9C:EE_|VI1PR08MB10123:EE_
X-MS-Office365-Filtering-Correlation-Id: 78c6e96c-a8ad-4b8b-dc8e-08deb7497688
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|3023799007|38070700021|56012099003|22082099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 VFBkM9MXgtyD4SQAaWwOIopDzcTcj1Pb1gerz1xeg2gTW5jsBsGqxT0pp5Xp8HwXjOC7FAzFLv4ReGXicvpNc6cXpeUQ8/f5sWJYOvZSbHY6464DU3aZc02JdjJh11nPxOiwKZ/7qmMwlldICwODOjZZgUMxKCYRdBElibh00SuF5aNdP8JtVZn0kpVVNoEUlsZQkJPxzMIIjwsip/jgoszQmQbOUNpPwUUHy5kYO8ud34swGGoWxMI/b7TVS1YUQfnMbuXQMEHbE736hSG6ziiD+QAejh+Jfpfl0xBsQPYZXcZwtakkZU2tJfOtb1EY9XVj7zCsSFLDhqv0F91IwLHUaR43jYmgrAfTfwYIZViyx+lKnAPjt86HcPhOdePfd5nu8jJRpDCr96216+wuYfEVDi2zNVPesZGvmaaZkZruXIhTKRdLdbhKl+QU4rviWzdhlfi6Aw8zV2ufkiFsziongIurMsHIqoftMg1fWFkU82vXfbt/pAPIWo7vhICqiYallPNvKlG5sJOV4InZXRsbMNxbhuY0pHDuZoSuZSbIGv8Ene4S8p+qroPggpC0g4xwQG6oC7bmaziv+7jI3Jh35mYCyELi/0XWFF4+SOeBFX7iESQ3NjXW/X30tM5N+I0BV5JD6W2AgACRzEN3+UkL7zeL0V2CHfUm/SKiYrQ/nj2LyKsALc5CgL5QNsE6X2732hLU8bl6W8SCHa+M4MqrPBh74ZDNGIfET7nQkv0raHAcX/xO1JxHAeNsfoHq
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(3023799007)(38070700021)(56012099003)(22082099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 b/JUgEK+nKRonYz1a/QcEx1VziV2sUoW6f75rvRTKgKnuSveX7LHHnkyBASjPedBvDw8YBHy3mqJ5SiptoJ5sZ+GJrV2j1eX9n6F314QeRRw4QiMzOfz3r+MkHyGBR1WZuJGoOIpz+eTX9yuX9UW025TteqL0yUv120XmOedL+bs90Fjp0YfonlNRFh3O7CaO7LJLo91uoq/B7oMV6OUEOx2pKwhF/AK7MAI8ImOqTFzVx0rSPMk0aX6QHqhMXb/RSjp7XlPMmA57ga82R+TY/+iUyyIRwwBdMa+GK3jzkPRxxFITX2idj4N1JHJUcCpugGrBS+BwE1AVbsYy8LV8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9209
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aa3ca2bf-8f9c-474a-acf3-08deb74950cd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|1800799024|36860700016|82310400026|376014|3023799007|56012099003|11063799006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	NLATwx4iy/oKlekvkBrrUxlgenGxJavUzolTNOt2RSRgC4gGljmsU7+7ZEUtbsK/+7tMzdFYtxMv3LyWDMB14TOf0h8L0phF6HgNd07n93NVbY524pLfriSB9Z9AqYy/M2ujPnZ9VTwMDuJD39TESEERMcZDxWqay8ro6OP2L8pFwnYaqTs2KdAxdSXsjNgjiLOlv9ort6n5zuI4hy1uOuzEwjJlcUzo0nEPvsSSXqgQ4PrRf7izgBTfWOtv9vmjCq7gTq1d3tZmOsUXLt9CKXxVYWPAjOjMMcrikqEo5x6mYGCS4b5FJmNUcvfemZy652afGunBw+oajrtKnrsyP642V2mUemNzLI2tKJQEg+gWxrXBD+xz4hhUvUo1iAGCGzuwwSMHv/BUw36CNzV1rdlWN04M094eK4NTL0r6o0kxgPicVGuxGsbUYDc8dihxbFMprLJrUX31iEAGh0Y0uBvP2ItuRgorH3TsChN6Q2M9Ix5krDB6WhxnJAOWt6UWeeXDXBEyfsE7YsTHgzqcJzi+1mTIWPRsPzM2Vj3mwMMW04d+bELjdimqf6EKPXmhWGc+ABnSC866GEV6uxVhbFnmde1xIsTIZxGZ/eZikGY4BdhP35BB2ove2ysZTLOfNRxCkEPpDeQyK87XZlgWP/Nat9KvI9UZ7iRxPIU1FiXnZj5ecfmcrT8CqfSub+rtY0FPnO6gRCh4mrknwoK58x2SGZCldsVdpJW8znxuMaU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(1800799024)(36860700016)(82310400026)(376014)(3023799007)(56012099003)(11063799006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HkkxmIUa/bhBMgv+rLn+rm0nVmc3WkpEVBDCmBO2gCat2IX/GhwPfFN2eRLqh1mHU1/QV5rjJJC9IAecpMow1VygDH96qY0XwVcAPMQSlPZGanZW6bGnAFeo4xCah1BGB6xY34+6DdEh8tfKJI6D1dFh1yH57zdb+4iSi8r9WTH/SDlVH7nWBXmVuIiPfCVC2vkDpIuodMoQiVx7adn/ULWeTTtKODiciDcN/PIXKicBmVMvNjCiTwh60bQzGdpobUJA/zjpExzEcIT4gsiXJVgVZwVDrY+KNw38dCAQSCsaNV60YzuLmUfwXSHd2xivY4RgXfByHlQJzFfUpuet+chwl/2+Hwl5jfnWX6Ra0HuVPZdMH51AE7GaFInQnkvHd2DpHRwcL+ERzxTpfDbM/HAVKMW8j+uHB9igKe4iKdyuFkBhauXJ7aE+IA1BfolV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:58:48.1397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c6e96c-a8ad-4b8b-dc8e-08deb7497688
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10123

As a general rule, GICv5 works a bit differently to previous
generation GICs. When it comes to virtual interrupts, as much as
possible is handled directly by the hardware and requires minimal
software interaction.

So far, the GICv5 support has been limited to PPIs. These are handled
via a set of ICH_PPI_*_EL2 registers, which are used by the hypervisor
to manage the PPI state exposed to the guest. They effectively take
the role of the ICH_LR*_EL2 registers found in earlier GICs, but do so
for EVERY PPI in parallel. For this reason, the GICv5 PPI support
doesn't use AP lists at all - all PPI state is always presented to the
guest.

The lifecycle of a virtual SPI is largely handled by the hardware with
GICv5. GICv5 itself provides a set of system instructions that act
upon the virtual domain. One of these, GIC VDPEND, can be used to make
a specified interrupt pending for a guest. The state of guest
interrupts is tracked by ISTs, which are allocated by the hypervisor
and provided directly by the hardware. The enable state for SPIs and
LPIs is driven directly by the guest (using the GIC CDEN/CDDIS system
instructions). Priority, affinity are also driven by the guest.

All of the above means that it is in theory possible to handle virtual
SPIs from KVM by just executing GIC VDPEND whenever new state is to be
injected into the guest. Of course, reality is a little bit more
complicated.

KVM itself provides an interface to register a notifier on interrupt
deactivation - specifically intended for use with SPIs on Arm-based
systems. This notifier requires KVM to track when an interrupt has
been consumed by the guest, so that the notifier can be called.

SPIs are not per-vcpu - they are effectively global to the VM (even if
they are affine to a specific VCPU, KVM doesn't need to know this
information). Therefore, this change introduces a per-VM AP list
specifically for tracking SPIs for a GICv5 guest. The intent is that
while an SPI is in-flight (pending/active) it remains on this list,
such that KVM knows to track the state of said SPI. Once the interrupt
has been consumed by the guest, it can be popped off the list.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c |  3 +++
 include/kvm/arm_vgic.h            | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index d1c724d0fd0b6..6739c01277866 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -636,6 +636,9 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int =
nr_spis)
 	u64 mmfr0;
 	int ret, i;
=20
+	INIT_LIST_HEAD(&dist->vgic_v5_spi_ap_list_head);
+	raw_spin_lock_init(&dist->vgic_v5_spi_ap_list_lock);
+
 	/*
 	 * We (KVM) allocate an Interrupt State Table (IST) for SPIs. The
 	 * hardware mandates that lower 6 bits of the address are 0. Each ISTE
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 143e75743da86..d4b0e7e3edf26 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -574,6 +574,20 @@ struct vgic_dist {
 	 * GICv5 IRS data. Dynamically allocated due to the size.
 	 */
 	struct vgic_v5_irs	*vgic_v5_irs_data;
+
+	/*
+	 * The GICv5 SPI AP list is global to the VM. This spinlock ensures that
+	 * we don't do anything untoward!
+	 */
+	raw_spinlock_t		vgic_v5_spi_ap_list_lock;
+
+	/*
+	 * List of global (non-private) IRQs that must be tracked because they
+	 * are either Active or Pending (hence the name; AP list). This list
+	 * will only ever contain SPIs. All private IRQs must go into a specific
+	 * vcpu's AP list.
+	 */
+	struct list_head	vgic_v5_spi_ap_list_head;
 };
=20
 struct vgic_v2_cpu_if {
--=20
2.34.1
