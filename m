Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011034.outbound.protection.outlook.com [52.101.70.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8FF282F3F
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783093905; cv=fail; b=V1B3Yn9fpCBGM5gPZEQbE1ZfxYXKuxGoMCAKpCG8UnVDnqM6AFvAAJXT00wL9BhfgHszhKtbMR1divJjkfe922LiKDhLprfY0n8P8H2SJRHKOZImWm/mhrjhiyoGqartKGBmuJe5+U6FlbI1Ozp7/MjT8VKTmgE4eVImq481WBU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783093905; c=relaxed/simple;
	bh=qJsLRDeEc6F7m9/zZC2hkaHiamUWLOInzHOP38cKLOQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mo1hd/9EAksWuTM2PK9h/aPrxomwUwPvvYlcPHdc5277THvgz9JIfh8ZFH9Lj++FM52Iu7iDB6U4g2vk/zCznd0sN/1UpWc17WALT59vVxKEmQbITvlWBsUG1vB6F21sEqbNVprQuPQbujEIlaHHdBXH5onZXvM7N1RFYdtLg/s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f/Shgvpt; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f/Shgvpt; arc=fail smtp.client-ip=52.101.70.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f/Shgvpt";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f/Shgvpt"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Kvz5PZZS8nc4jS16TIEydfhP5vNkfy4Oz+8Nc4xi+0j/UphgMyPfPHh+qeT3NWmut5WzMgBVu7s0BeisYMU1phPS63WqKiTpoEimLkGcdzUTC9heXUVebWgQ3Lx/U8eJTvNtc1WTfICWrNEjjUpf/g4dG1NhE7m0sNHyPF+7XTQy0hUFJ3+deb+dcszZmdZXc0E9Og6aLyS5CM35ieFpqW8EgmW056Kcu4QvZzaUupVwsR00s2zIbWz5XcqW7fkLMZDx5JSwgdXNybAmABpdEIZONOgxMA07JVk1LwIstVtNiAIByII+dzPfKhr47X+OxWqJqt8sgqsltwvjMgNOPw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwoIgnAPQvqBmn6oSRvkceOij0lCh0G5U7JmWpHCPR0=;
 b=sZJHPRUFUNNO9/Cch/IgQUJQbtYciYGkObOafu4AKt/JxmQ8vDZAmqpEcXz7ranyeKrp2A9We/ie76dhA1xgILSuWRxvosafNCsI0Q+kTbAQBspDjjjBwEWqIfc7WqTKtEqhIgOmsHSePGqKRslaRjIr9xeCfCSvbramhiRU8i13KRVA+FzCdCEPLupA0YmEpv7kKzCkI1VdzUn7pPeNh0yhn8c6ZAreya+yeheHUQ7OR/yxC0KQMyIse5Uj7rXf5T9sJ4O82DB82rEQQTaj32KlVpq81zWtjrvgYQSHy/2BWvKmUmppd4Js8+wB7/XUwmAJ7r9WtKf7zIQIAr8Ktw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwoIgnAPQvqBmn6oSRvkceOij0lCh0G5U7JmWpHCPR0=;
 b=f/Shgvptj8XAQHIfYuvpIIKu6+mqJFN85YcobS75IYSF6UPn4p3oNz8XCiT6YfwdvlUP61AtlfSDWzOJ8nw2qCg3zlt1nft0IXc5moHamPhDDZ0Ck7s3Fd8NWMmrLamqnFKqWg+ToMbI52nq+2fBxihxO30z4lHU6ZZD+Li+fvs=
Received: from DU2PR04CA0053.eurprd04.prod.outlook.com (2603:10a6:10:234::28)
 by FRZPR08MB11875.eurprd08.prod.outlook.com (2603:10a6:d10:1cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 15:51:37 +0000
Received: from DB5PEPF00014B88.eurprd02.prod.outlook.com
 (2603:10a6:10:234:cafe::4d) by DU2PR04CA0053.outlook.office365.com
 (2603:10a6:10:234::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:51:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B88.mail.protection.outlook.com (10.167.8.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:51:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7WKn6juBgViiJ1Lf5eM/db4HlL/sKnOFdG7378MJ85EkodQoFeyeVN4fq1uTJdEQu91t2Zatv/i9DD6d7Uk9KXktJii2wjtaq+PJvQnuc6eruA4IAP4pzLznH4r35BnSFLbZfDkKmkuLgosTc+LJqk6NIMACO6K3J1YirA0IKwfOO7slZq8MxJIXoPTwAH1VL30nZ7jHKmh+C1YOTa7ucnzgi8mibKjs2/SSOb+gcG8KEZc8iJ04bVgIstmuB+nL6vXYsNz076OZIzatsvjf4wi/N4J8YQdm0gDrwP7poiI98fJ4/ZwfYO3R4fgskTRbWVLkQbj8/Co+l63snC6yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwoIgnAPQvqBmn6oSRvkceOij0lCh0G5U7JmWpHCPR0=;
 b=emIysS3B/L2ep1z8LK8iXZ75FYxfP5HDeSLCBaSe3Fg4Z3E9+VGY8b3+kfp4z1KZZe764cyY1Vjsqu72VZlahZKJkg8S1CkXBLfoZkl3fS0+rlnlMh98vxFSnQMXWSjr6QiKbGgoy9vey67XQzC+1d1+Yl8TNTTvEnDMVkVqZ4ZRHyOLef7a8ybGCjdCPCRaePtO7gaMk1yHFPl/oPQpbNKJLfD3/NxnoaU6gGlH9WhlDMvfIEragzeCB8gxDQ5be7Ezq38v7tOvsb+gAqYVXtd2PKpdrXTuR3Y0I/IcpcEFrJLIByxrQpjRWiMFXlF6p7Qad1DpzlnCRzIwhXfx5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwoIgnAPQvqBmn6oSRvkceOij0lCh0G5U7JmWpHCPR0=;
 b=f/Shgvptj8XAQHIfYuvpIIKu6+mqJFN85YcobS75IYSF6UPn4p3oNz8XCiT6YfwdvlUP61AtlfSDWzOJ8nw2qCg3zlt1nft0IXc5moHamPhDDZ0Ck7s3Fd8NWMmrLamqnFKqWg+ToMbI52nq+2fBxihxO30z4lHU6ZZD+Li+fvs=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by MI3PR08MB12005.eurprd08.prod.outlook.com (2603:10a6:290:80::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 15:50:33 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:50:33 +0000
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
Subject: [PATCH v3 00/40] KVM: arm64: Add GICv5 IRS support
Thread-Topic: [PATCH v3 00/40] KVM: arm64: Add GICv5 IRS support
Thread-Index: AQHdCwOuQETNEl5vJkqADrzEoOm3sQ==
Date: Fri, 3 Jul 2026 15:50:32 +0000
Message-ID: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|MI3PR08MB12005:EE_|DB5PEPF00014B88:EE_|FRZPR08MB11875:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dbfb17e-1122-40bd-8b09-08ded91af76d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|18002099003|38070700021|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 eNR7bq1YS69w5Rom+q4y7dUk1WbIm6XGEoksTC6vjR/wL7Oha8GPTW2k3vJZnZw4qE9hRUjxC39HRDVL2m74Ch3ZePIiQq1DM5vebH83Pf+zUZghnE8Qh2LHR8zOf6PPQvfbSWywKSnJc258zSqMN/MqHsJ5p8mHPLb57YY2oWg84cCJrYJbg+z3WQLBULmWFQUArRPXjSEfWO7YGnrThHtfdbBIzIJD6RFZZllPC7i5xCuW8LzO3iauRtx7fy/n8klgupq6QTj7VlYJNkcdVDvZm6EXFQspZ8r1MlS9PVwhfZyxjGTh/4fDYVxY8atRyJPGLiDjtNWYSa/yXAsrGM3Of+5xdJ4gOMad3v8VFvN+qK3WvNUuJPZj6BsOWBBtu7mzqzHZTfDldFNPh7tz0m8q3vkXljki9KX19VvN2QykMVMyQhxQY6WDGHtuum/vOihiZPXgEpsMsldEn7BuzS3qmF5rPeVsu1+TOEYK22flDDMxsDkzhW4dc9HqvfM0F4+bz7jJn4D4hGcWm0mwep7+EHSw609xBjxxu5LwBOPNvoUeWoUiUDLTZJ0OeM3dlQyu+tKsH9ldZY0ZaFPFj5mzn5d0i6FI3UnAH2COqPlwkmJ3vWI4JH8ZZMZZsf4Ql5XeQ9BYGK9dTBl/mlMavSR8alsuV+IjF1EXjkjdoM9rl4fO0PYy6T7qXs/PWQL7h/mqPNYOMpQFDeV24FpCN6MfqjsKIbDYMLigNqcXPPI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(18002099003)(38070700021)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 l3kMfMgkfXMQvYafzyaJm1rVq/mV0Klp/CzZBYiX2Rv4zq0XzSrlDQV+aSJQwzySTlrS2yLfcEsi6EE8P9HKbN1D3fuokirbGS4whmg0pf+ul0spYCejqQGSKN9nvk1427g/ihExPch3WNQJ1mVWS2tsXc8qNWKouR48iMsZUQM4EPQOit37XQF1M0TiL+7gn5QycsgrmuTcR5qheYFHdh/DLcWX0pZw32tAfw5Hq1WB7x/X756LGRTF8j2sry4qbsJ3pERbf4/w2l6RneIt0Qinc1tMpufod7FKQNdpdvpS8wTCvCpShPo73feKDh5VcYYj/dmKg3mrhhRW67eASw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI3PR08MB12005
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	46fe3cfc-c53e-449d-6160-08ded91ad0de
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|82310400026|36860700016|1800799024|14060799003|35042699022|18002099003|56012099006|11063799006|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Us45qwbYnz/gYVdHQf2020znz29AePRDufrqGP1U81ldbD8xMkT/AnSzj439razAqClSxqERICWTvhii5sTVv7w6LGSHCzd5oKEBF10+z3fixmIpO5QhbsXa4qfvi0J3Bpvrx6BDDzN1SDmxU6mdG3jKlQkRXUTy8oAx/nH1WF0t64A+LNi/yUJD5Y1PeR6Vmg85ZMGjFa+ykUUthzsT2Sy5ccQQT34GQsq5tGAWCp4rerkY2Mp6UoXDo9DfSXik/OLiKeSw4rLnTmb6S+uW7FlhYNmdIQeKskFWviLjdsrvvklR3jkxI3u8EP0OvWGe/QyDy8tyHfTk5vhxYMHOEteq59APLvDZa8n03OiNX0oM9SabwbCTaHga3KSeys7mm5LY5leRrVgRpdTOKNg+bwrIC9gpxHlM03MLH4eHDvsQZUhBtrERVY3a60MH8fo8Z+UFDwX4sY/762bIN2LTtAnc8LrLzQ5ViSk20bMi/5f0SI28r3VilaoVicy9degJpiIM4qTRg6aLaRedxkgob243YdSVe+av9Z0Pw+MqUHIsPDtDh9IELRC6HOgbp6vXXLSEa4xPAe2Fz/5SD3fqtelnvr1GYf8VX1Zz6WEhXW4S1RlCplPuHVLTD8h4VgPa8b9efPLESj0vjfbh9CsykmMR8sw1qirrPtoBe6PwOhO1sla1zzPW/HYAi9bBf+r0QZHJ9d54GiTBROo4VRkbpA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(82310400026)(36860700016)(1800799024)(14060799003)(35042699022)(18002099003)(56012099006)(11063799006)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NsJxJoJ4SFNRpXgur/bhtdAOWKNbB6prcvXZembSRVAwBjRwXTuT9nu5Su49DpREYzlXNT50VIV5W8gfdSolcpRcKz8vphKAk0Vq02hcQbGG1L7uPe9Umke6M+4BX2SljKNXq7Lwb6OSCaDB+gLxmpFuLjxsaoo8VjWyFBIGlWzRXZSp2UkTgOQhENO3BEaEEKVrBev+s45uiVgBY9v3g72M3J8LaUbMiPkP6jnjTTcUtJdSGT+DpxVN1Pa9x+d+GAnt2NVEGY8mE/pjwHT6OkKuf8LwiD/XWc1HnkYDYC60S+K1jNcP+raE9A58G7l9ll0gOvm7LH7O9OhW4AF3iiYi5FaHt5U4zksZC6w584sVLGmqGCXzVN08J9tCrb2hOn1GpHv9pLzfpImqWngBu52BG2p1pWmdHYpd6UKanbL4+7yu5pKmqu9MjjKiO/J9
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:51:37.5620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbfb17e-1122-40bd-8b09-08ded91af76d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11875

Hi all,

This series builds on the initial vGICv5 support [1] and adds support
for the GICv5 IRS, as described by the GICv5 (EAC0) specification [2].
With this, a GICv5 guest is no longer restricted to PPIs, and can make
use of SPIs and LPIs as well.

With SPIs and LPIs available, this series makes it possible to boot a
full Linux guest on the Arm FVP model [3], using the setup described
in Lorenzo's GICv5 Linux software enablement guide [4]. In addition,
GICv5 IPIs are typically implemented as LPIs, so LPI support is what
makes guests with more than one vCPU possible.

The corresponding kvmtool changes are available separately [5]. With
these changes, `--irqchip=3Dgicv5` works now. The `--irqchip=3Dgicv5-its`
configuration does not work with this series, as ITS/MSI support is
not included here.

The IRS is created as part of the vgic-v5 device, and is not a
separate KVM device. This is because implementing the CPU interface
alone would limit a guest to a single vCPU and PPIs only. Hence, the
IRS is bundled into the VGIC, much like the distributor for GICv3.

The series adds the host-side plumbing needed for KVM to interact with
the physical IRS, including VM and VPE table management, VPE
residency, and VPE doorbells. It also adds an emulated IRS MMIO
interface for the guest, together with the UAPI needed for userspace
to configure the IRS address and to save/restore the IRS and IST
state.

The main pieces are:

* Host IRS capability discovery and configuration frame plumbing.

* Allocation and management of the GICv5 VM table, VPE table, VMTEs,
  VPEs, and guest IST backing storage.

* VPE residency and doorbell handling, allowing the IRS to select SPIs
  and LPIs for resident VPEs and wake non-resident VPEs when required.

* Emulation of the GICv5 IRS MMIO CONFIG_FRAME for guests.
  Virtualisation, MPAM, MEC, SWERR are not supported and are RAZ/WI.

* SPI injection support using GIC VDPEND, together with tracking of
  in-flight SPIs so that deactivation notifiers can still be handled.

* Save/restore support for GICv5 EL1 system registers, IRS MMIO state,
  and guest ISTs.

* Documentation for the new VGICv5 IRS userspace interfaces and the
  required save/restore ordering.

Please pay close attention to the save/restore interface and ordering,
in particular to make sure that no guest state has been omitted.

LPIs are explicitly driven by the guest through the IRS/IST state. This
series does not add direct LPI injection support, and does not add MSI
support. It also does not add GICv5 ITS emulation.

These changes are based on v7.2-rc1. I've pushed the full set of changes
to a branch at [6].

Changes since v2 [8]:

* Added emulation for the IRS CoreSight identification registers.

* Tightened ACPI GICv5 KVM setup, including maintenance IRQ handling
  and cleanup on setup failures.

* Hardened VM/VPE table handling, including invalid VM ID checks,
  vcpu_idx based VPE IDs, and less noisy error paths.

* Accounted guest IST backing allocations with GFP_KERNEL_ACCOUNT.

* Made VMTE/VMT teardown paths avoid reusing state that could not be
  safely invalidated or released.

* Improved IST save/restore memory accesses by adding SRCU protection
  for LPI IST save.

Thanks for taking the time to look at these changes. Apologies for the
size of the series, but this is a rather hard set to disentangle and
review separately!

Thanks,
Sascha

[1] https://lore.kernel.org/all/20260319154937.3619520-1-sascha.bischoff@ar=
m.com/
[2] https://developer.arm.com/documentation/aes0070/latest
[3] https://developer.arm.com/documentation/108086/latest
[4] https://linaro.atlassian.net/wiki/x/CQAF-wY
[5] https://lore.kernel.org/all/20260116182606.61856-1-sascha.bischoff@arm.=
com/
[6] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_kvm_irs_support_=
v3
[7] https://lore.kernel.org/all/20260427160547.3129448-1-sascha.bischoff@ar=
m.com/
[8] https://lore.kernel.org/all/20260521144846.1899475-1-sascha.bischoff@ar=
m.com/

Sascha Bischoff (40):
  irqchip/gic-v5: Allow KVM setup without a maintenance IRQ
  irqchip/gic-v5: Provide OF IRS config frame attrs to KVM
  irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
  KVM: arm64: gic-v5: Define remaining IRS MMIO registers
  arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG encodings
  arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
  KVM: arm64: gic-v5: Extract host IRS caps from IRS config frame
  KVM: arm64: gic-v5: Add VPE doorbell domain
  KVM: arm64: gic-v5: Create and manage VM and VPE tables
  KVM: arm64: gic-v5: Introduce guest IST alloc and management
  KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
  KVM: arm64: gic-v5: Keep GICv5 vCPU limit model-specific
  KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
  KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
  KVM: arm64: gic-v5: Add resident/non-resident hyp calls
  KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
  KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base address
  KVM: arm64: gic-v5: Add IRS IODEV support to MMIO handlers
  KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
  KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
  KVM: arm64: gic-v5: Initialise per-VM IRS state
  KVM: arm64: gic-v5: Register the IRS IODEV
  KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
  KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
  KVM: arm64: gic-v5: Introduce SPI AP list
  KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG hyp calls
  KVM: arm64: gic-v5: Track SPI state for in-flight SPIs
  KVM: arm64: gic: Introduce set_pending_state() to irq_op
  KVM: arm64: gic-v5: Support SPI injection
  Documentation: KVM: Extend VGICv5 docs for KVM_VGIC_V5_ADDR_TYPE_IRS
  KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
  KVM: arm64: gic-v5: Mask per-vcpu PPI state in
    vgic_v5_finalize_ppi_state()
  KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors
  KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
  KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
  KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
  Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for
    VGICv5
  Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
  Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
  Documentation: KVM: Add the VGICv5 IRS save/restore sequences

 .../virt/kvm/devices/arm-vgic-v5.rst          |  237 ++-
 arch/arm64/include/asm/kvm_asm.h              |    4 +
 arch/arm64/include/asm/kvm_hyp.h              |    4 +
 arch/arm64/include/asm/sysreg.h               |   18 +-
 arch/arm64/include/uapi/asm/kvm.h             |    7 +
 arch/arm64/kvm/Makefile                       |    3 +-
 arch/arm64/kvm/arm.c                          |    2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   34 +
 arch/arm64/kvm/hyp/vgic-v5-sr.c               |   55 +
 arch/arm64/kvm/sys_regs.c                     |    6 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c              |  519 +++++
 arch/arm64/kvm/vgic/vgic-init.c               |  111 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c              |   17 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c             | 1138 ++++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  252 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |    6 +
 arch/arm64/kvm/vgic/vgic-mmio.h               |    2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c          | 1855 +++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h          |  112 +
 arch/arm64/kvm/vgic/vgic-v5.c                 | 1220 ++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    |   39 +-
 arch/arm64/kvm/vgic/vgic.h                    |   21 +-
 arch/arm64/tools/sysreg                       |    4 +-
 drivers/irqchip/irq-gic-v5-irs.c              |   19 +-
 drivers/irqchip/irq-gic-v5.c                  |  117 +-
 include/kvm/arm_vgic.h                        |  165 +-
 include/linux/irqchip/arm-gic-v5.h            |  256 ++-
 include/linux/irqchip/arm-vgic-info.h         |    5 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |    7 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   |    6 +
 .../selftests/kvm/include/arm64/gic_v5.h      |    3 +
 31 files changed, 6093 insertions(+), 151 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

--=20
2.34.1
