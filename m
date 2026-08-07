Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013052.outbound.protection.outlook.com [52.101.83.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB743430304
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102483; cv=fail; b=nbSvvux/X44MXgRZJSeCzbyXjK1xDSOREx76AUlB1kTgMfWlkwieo+DOvJIAfVNFS+r21s/I9NofJSWjkRklcU1aiUC9H0G9svJj169F8CYNXrB2x76Dus7gelOXoAlEV1qyYu4NbI6zjosppn1tcPYM/rv9x00psAwvJ98ZORk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102483; c=relaxed/simple;
	bh=Xw0FTi2t2ebjcS9tAxaFAQm2r5oAHSnCYMHDmduptKs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J++7dGdno3mEbv7pdkKqtdKnJHVJrP1RVpaVAS63gESBPR1kAHWiWpC95zMyXO+D72WaWQe6nRhzD5g7bJZzMM5Skh2IO6TEsW3IC3zrIzteYbKv+ownkVTFEjN8H/x6+pQGbOxhgVurSrsOpCJmvcSnT4VOU4pA1Ote/tVdO8s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XinXd0Kc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XinXd0Kc; arc=fail smtp.client-ip=52.101.83.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XinXd0Kc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XinXd0Kc"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NEI1/1I1oD0YWGC4RwVpRWNfgxuY/jXvjM+2BoH3Qanp5mb2C4sOYi6GkHPhSN3mu/2ZTWyFQgjNLEF3ivAwkvCeq+Js9yP7Fsdvvz/KuOtOys1FUZhfI/RnsioZMnf/0cwSvJwWpZyxeQbTlfWj1Egi+FaURbeDC5NI3E5hs9vvEjxztt2TRe9PGvI8sf+y+UpSSNffYca5i3xuOSmBe2a2MhpUX4yD0lS0nGZxHnN8oJOkV3PYJDfzX/H00mSUqZZjGTa7fE1jjZwij1WCzidTjhkjV/Kr/hjdflESuPmMq/hvYlrMqb3QbxrnaGV23LN2kXmAKp7Gn6xHNGc9hA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOdk8A/29wA/bF6ib3LKYEL46Djw+Ge05WSUJmYMeUs=;
 b=xSsa6MlLtibM0qI1i+H31KLVCN/Q3GqqnYrz1ylw9C0kmHXQ/4lkQlY8bFR9bI5MI0lTK5OfJx1Ahm0MPosEHdXiZ9olBVLWPB8ED54MFnXnY4j3bFgRm9oVo/BuEzv3wvrlRXIywtHkGmD6wlV5malVMwxD+jGAHKdnj5jddfyYeO+pL64CbEV5/DMvFfEsPdqeYIgCSgEDYRvUK/cVFsYDfltmD+ToTpJTm8yHwDrypkR/SGTTcLUaMPRvqYmC57KLSPTYouO/wiCE1g00znKC2Bmr/FlAqQb1BdxFJmBp5tNFsXNjedAYDinsEj7bvVdUs7OCaP4oUKQBVtfdMw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOdk8A/29wA/bF6ib3LKYEL46Djw+Ge05WSUJmYMeUs=;
 b=XinXd0KcdO3J7VCZNPBs4xom9pzQy4D5WWeADSM7i66DVA2eTb0eKx/WRNuD+lsDTxF+XYQQVqb5+tudCSROCzJ+NApROYs9BwLvf6e9pmfC/o0WAXKywxL5E7MAwH/wncaddLqqZQ1/DpxbJcjKMtgbaE6wsJltLyu9clcEQQg=
Received: from AS4P192CA0022.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::20)
 by AS8PR08MB6663.eurprd08.prod.outlook.com (2603:10a6:20b:39b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:34:33 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::57) by AS4P192CA0022.outlook.office365.com
 (2603:10a6:20b:5e1::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:34:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:34:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqmcKwPx5QPe81K8QDQhcc5m9cDnQT/Qbt0xhUEPmReTkAF8WCGUgMdcOvWnyGyu/GYI1azc40Zevh76krg1nQ07VZ42cyBiqRq1YC7Jx+6EB5zAtmC7YrMVK9NlT4iuKtJy3cESESU+WYQhLUrH4ABTxbE0J6LT2eiLz7MqZ055fpyW9E6cxDrmw8qcQAH/wqFJtfehhXwQc2qufOCTzdPUZnYv8PbLyWu1zwzoEiXjOB5Y+l0XU/EHv4xzhPSp01bwPRePmLVivX6/bOmyBNJLF4ZJglgPtT3ltUgwccCh/cRGPCowp+xGWHjnaclAZ37yR2DB/XHd7atruhIz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOdk8A/29wA/bF6ib3LKYEL46Djw+Ge05WSUJmYMeUs=;
 b=UdvbC339lD2+cxKnbYH+O3uQ6GyHU1nY0+cxs0wdD32LvoEbvEe53/KPSHNqCOMX6Ya+DRAGuTPrHssCh65dt5jhrudDOehAk8NsmMaoDTzFz8tX2xtO9ZS2TKIPiyNJCdqyx5REwxF4JXw5nDvZ8Tg+4K9hF8lakFTQ9A+fxfyc5Dfx43uU0aKVR33Oh8B1pP1V2Bvp+fxgSZ4OhWhYYtwxdO7USIn9zlBqwOq8UpR286DfT8UMHoB1yyw4ZcyNg/Y7xr0E3PdMXcv7NQ6FRRiAyawzQxhH0nwwzP3/h0iBfz+Ozp+4i60ESPb6Zx4bQRMNnm9i311rXS5cqoF55A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOdk8A/29wA/bF6ib3LKYEL46Djw+Ge05WSUJmYMeUs=;
 b=XinXd0KcdO3J7VCZNPBs4xom9pzQy4D5WWeADSM7i66DVA2eTb0eKx/WRNuD+lsDTxF+XYQQVqb5+tudCSROCzJ+NApROYs9BwLvf6e9pmfC/o0WAXKywxL5E7MAwH/wncaddLqqZQ1/DpxbJcjKMtgbaE6wsJltLyu9clcEQQg=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DBBPR08MB10793.eurprd08.prod.outlook.com (2603:10a6:10:53d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:34:00 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:34:00 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v5 42/49] KVM: selftests: Add VGICv5 IRS_REGS attribute tests
Thread-Topic: [PATCH v5 42/49] KVM: selftests: Add VGICv5 IRS_REGS attribute
 tests
Thread-Index: AQHdJmCjdpfJzq7xTUeqlknPK0qwfw==
Date: Fri, 7 Aug 2026 11:33:59 +0000
Message-ID: <20260807111159.429128-43-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|DBBPR08MB10793:EE_|AM3PEPF0000A791:EE_|AS8PR08MB6663:EE_
X-MS-Office365-Filtering-Correlation-Id: 9afd60d4-1748-4d11-dbb7-08def477da47
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|6133799003|11063799006|10067099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 JwCpKZ/z2ybaeYV01+rP+JHLwf4G87exRl0bsy+RaDIjCyc9ZoneaCpM1yIVzer+WnyWRk88a0ylIg4/HAwkf7/cmm6pNJ1tf0Av7JxQ1IdPrw34mmje6p12xrFDj0meKF1bUkC2Z1aXCDwqf0zbOI/yN/G6QWga9Li3aHxgnq0Z/zA23ZxovTzId/bSInAbnIasO2A6JpeUQD4SA9vVd464f/MtiqXfFYY7/2Jltkbzvzi5e1tOyt+01A2vfW/bQI6Uwhgr0pPedRqGjkY/7sbBFAVKcOHzPS/uGvcUk4yyavjS6LvlUTm2LJv0RD8rGg3JQbFlb1Ut7GPEpy7zx6qtMBI1BvFoIjoK9PCKXJAZsvnL4S4tXT9mv8Gv4JOIjVq7N66Ug0sdhNhayKOQJBWMd3uI9khLyMx9ZSCnlODH0fveKtwDFpHDaI5tUVfcN6DQRdqPcPYTqn+GsWeU6cxTxbiAt9IpQISYmrf5FWIfuPqRYzdDeupqc6ilDh6WdWML7XEkLrtweaKQFd4Smu4iEY0OgB/drT/xZfDYlH97b0EkrlTZLpPflT54gEqHJkshyJIc5cLMdyG5n4SzkkpYggZh07arZttevGfBxgmh6wX1wGG/nvUCPMwUb1mUY7XNC7BL4UvkUqeu4fZ+eC8mxSk02FZS+INbwfKQhGDK2wu2owhxEDNNaruyIjRM5Hcl4gFCZWnE/HqN6HRhivkAH0cOFXtIekDrM1spphA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(6133799003)(11063799006)(10067099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WnHJ+wbs0gwvznE+F53UYc+iAjQwDJPinKr73RGPlafvi4UatXM53s61684uhWSgjYSPE6kW3WgRj5Jin4AYsfXOZfC+hUqLmWTL+7F7Cu/a+umy6/pk3VFVoodFH6kJuGC2epcv9zBxjVe/dpk0e4P21x8skIBCajLtsTWgJmFDP+QhR4aMgvXo/guweq9gok3TItaUAKoV6QCFqrKHu/ll8VGlfqRABWvV+AOK9GI/7D0h3iyoOASHutLxtYMRwJMqKm9Uzty4Ym1AAtqRxUDKZ5C0vuI0xqfoWUTLk+1m7POOckJj7cXBpTBqCZhlM/FU113d6FNix2wFihW/jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10793
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	083275b3-1c1b-4e31-7bcc-08def477c662
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|376014|36860700016|23010399003|14060799003|82310400026|18002099003|22082099003|10067099003|11063799006|56012099006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	ouWiRlyJsz8djAQKHfdIUCewy+KRtbVsmFVlosxASGvYe+nP2L/KTrKnwU+kJNI5fli47NJ5tLln1bZEL8wgnx0m8sT0Co8oOOZxG/0VQU3vydf+S3zyQvzusTFiBA9Sj95O4IDZpK3tPK2Lqn2Urv1yiuadXcG3fUdIaWy7pv4+CZl9d0aGQIQ14zUHWLWX3D+9r32TRB5vT83VYldnaB8ZpcUsZooY7zLeJ6k6UqbYJDzYyxG2SLs2lywNp456sRMRMsZrlFwoi8nHqqSbZB2meWZhcQO/LwZne4QC2Lbvq/Usf6t8Ogcco61fjchhlORUNtQilXmLqhVh1GXaNyusdHQYmvhaKR/cjcNnMM3uXka+7JXX1G9/XKPNnFmV/DM+/vjeyM7kN0NxGbmTFblMIh1V1NF9H0/6pmkdHIzMOLFMATy2hiTMMLXCGGWfrSBpsWziE2uClRPsQl3jIseAoAKvMLhVlWwA0aZIKnZBjE3G3agjPmXkD9yoJrgo9cWx52J4HCK0/VuES+ey9cjJsl09yzETMrAMl8OrRTdiHM7O5b+orOhfIybRgIq6ZdcPWTMVHRTA4Xavu73REArzHXm4QshVtz4PCxMHJ6ImHdAfR8+jYynCoAO1iUDzwSkEsKe27zL9m7AxBc2C90ENZxwnoe9XT47hfzLaFI57e0XvCmWuDeSpc4fo599OWNPE648v+0TMKbOHPJkiCA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(376014)(36860700016)(23010399003)(14060799003)(82310400026)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cqdFsON7Dn3j/FhfsWrxU6/i1Io2cwUbsqpMb16f3DPkdMN0I+ghvDVP8cRmtYpIsMryFUCnrmm5rMZA5VWjcdlq4TW3NAFnQqiyL36sW9U4FKJnhCByoLjqOC+wXuwjwjSikfB9wpOJkhQzvM926WqySWDVQ2Mt5gwDUXnMLtUJh59USL65QYun12PCpdEy65RtPtMmoxv6yU+zh2WjONpCyQ+8Qz+lJYRGC6IYSa/8uVL5h/x590NF3BcALXXodX2BK1onqmxwTN07aotAdqI4DOD5fecv2qqUg0FXVgM83iMZoLhd6fZmYduCoxKhJLLkPfcZl+kcDvPWLJaTB2uNb/rM2sI/mrD8SD7Ui6XK0Z0RllBjSO0lQmFgM9wF+QJ36u8FqYxQxYSJQkHNh3Q+B0KdXoWQOChmsSsJ9l+xFgeSFqsCdR+xq6fY4Mjg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:34:33.2644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9afd60d4-1748-4d11-dbb7-08def477da47
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6663

Add coverage for the VGICv5 IRS_REGS attribute group. Migration needs
a userspace-visible view of the virtual IRS register state, but KVM
must expose only valid registers and reject state that cannot be
restored safely.

Verify that KVM_HAS_DEVICE_ATTR reports the IRS_REGS group before the
IRS base is configured, while register reads and writes are rejected
before VGIC initialisation. Once the VGIC is initialised, verify that
all exposed registers can be read and their values written back.

Check that bad offsets, incorrect alignment, and bad userspace
pointers are rejected. Also check ID register restore validation, idle
status register values, and IRS_IST_BASER restore handling.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 255 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      |  72 +++++
 2 files changed, 327 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index f4c0d2c003bb4..54fa13906990b 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -18,6 +18,8 @@
=20
 static u64 max_phys_size;
=20
+#define VGIC_V5_TEST_IST_BASER_GPA	0x10000000ULL
+
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
@@ -110,6 +112,72 @@ static const struct vgic_region_attr gic_v5_irs_region=
 =3D {
 	.alignment =3D GICV5_IRS_ALIGN,
 };
=20
+struct vgic_irs_reg_attr {
+	const char	*name;
+	u64		attr;
+};
+
+#define IRS_REG(r)						\
+	{							\
+		.name		=3D #r,				\
+		.attr		=3D r,				\
+	}
+
+static const struct vgic_irs_reg_attr gic_v5_irs_regs[] =3D {
+	IRS_REG(GICV5_IRS_IDR0),
+	IRS_REG(GICV5_IRS_IDR1),
+	IRS_REG(GICV5_IRS_IDR2),
+	IRS_REG(GICV5_IRS_IDR3),
+	IRS_REG(GICV5_IRS_IDR4),
+	IRS_REG(GICV5_IRS_IDR5),
+	IRS_REG(GICV5_IRS_IDR6),
+	IRS_REG(GICV5_IRS_IDR7),
+	IRS_REG(GICV5_IRS_IIDR),
+	IRS_REG(GICV5_IRS_AIDR),
+	IRS_REG(GICV5_IRS_CR0),
+	IRS_REG(GICV5_IRS_CR1),
+	IRS_REG(GICV5_IRS_SYNCR),
+	IRS_REG(GICV5_IRS_SYNC_STATUSR),
+	IRS_REG(GICV5_IRS_SPI_VMR),
+	IRS_REG(GICV5_IRS_SPI_SELR),
+	IRS_REG(GICV5_IRS_SPI_DOMAINR),
+	IRS_REG(GICV5_IRS_SPI_RESAMPLER),
+	IRS_REG(GICV5_IRS_SPI_CFGR),
+	IRS_REG(GICV5_IRS_SPI_STATUSR),
+	IRS_REG(GICV5_IRS_PE_SELR),
+	IRS_REG(GICV5_IRS_PE_STATUSR),
+	IRS_REG(GICV5_IRS_PE_CR0),
+	IRS_REG(GICV5_IRS_IST_BASER),
+	IRS_REG(GICV5_IRS_IST_CFGR),
+	IRS_REG(GICV5_IRS_IST_STATUSR),
+	IRS_REG(GICV5_IRS_MAP_L2_ISTR),
+	IRS_REG(GICV5_IRS_VMT_BASER),
+	IRS_REG(GICV5_IRS_VMT_CFGR),
+	IRS_REG(GICV5_IRS_VMT_STATUSR),
+	IRS_REG(GICV5_IRS_VPE_SELR),
+	IRS_REG(GICV5_IRS_VPE_DBR),
+	IRS_REG(GICV5_IRS_VPE_HPPIR),
+	IRS_REG(GICV5_IRS_VPE_CR0),
+	IRS_REG(GICV5_IRS_VPE_STATUSR),
+	IRS_REG(GICV5_IRS_VM_DBR),
+	IRS_REG(GICV5_IRS_VM_SELR),
+	IRS_REG(GICV5_IRS_VM_STATUSR),
+	IRS_REG(GICV5_IRS_VMAP_L2_VMTR),
+	IRS_REG(GICV5_IRS_VMAP_VMR),
+	IRS_REG(GICV5_IRS_VMAP_VISTR),
+	IRS_REG(GICV5_IRS_VMAP_L2_VISTR),
+	IRS_REG(GICV5_IRS_VMAP_VPER),
+	IRS_REG(GICV5_IRS_SAVE_VMR),
+	IRS_REG(GICV5_IRS_SAVE_VM_STATUSR),
+	IRS_REG(GICV5_IRS_MEC_IDR),
+	IRS_REG(GICV5_IRS_MEC_MECID_R),
+	IRS_REG(GICV5_IRS_MPAM_IDR),
+	IRS_REG(GICV5_IRS_MPAM_PARTID_R),
+	IRS_REG(GICV5_IRS_SWERR_STATUSR),
+	IRS_REG(GICV5_IRS_SWERR_SYNDROMER0),
+	IRS_REG(GICV5_IRS_SWERR_SYNDROMER1),
+};
+
 static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -272,6 +340,189 @@ static void test_vgic_v5_nr_irqs_attrs(void)
=20
 }
=20
+static void test_vgic_v5_irs_regs_attrs(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u64 attr, val;
+	int ret, i;
+
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+
+	/* IRS_REGS attributes can be probed before the IRS base is set. */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+			    GICV5_IRS_IDR0);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+			    GICV5_IRS_IDR0);
+
+	/* IRS_REGS are not accessible before the VGIC is initialized. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IRS_REGS get before init");
+
+	val =3D 0;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 IRS_REGS set before init");
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/* Read all supported IRS regs and write the value back. */
+	for (i =3D 0; i < ARRAY_SIZE(gic_v5_irs_regs); i++) {
+		attr =3D gic_v5_irs_regs[i].attr;
+		ret =3D __kvm_has_device_attr(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    attr);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS missing %s",
+			    gic_v5_irs_regs[i].name);
+
+		val =3D 0xbad;
+		ret =3D __kvm_device_attr_get(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS get failed for %s",
+			    gic_v5_irs_regs[i].name);
+
+		ret =3D __kvm_device_attr_set(v.gic_fd,
+					    KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 IRS_REGS set failed for %s",
+			    gic_v5_irs_regs[i].name);
+	}
+
+	/* Check bad offsets */
+	attr =3D 0x10000;
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IRS_REGS accepted bad offse=
t");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno =3D=3D ENXIO, "GICv5 IRS_REGS get bad offset");
+
+	/* Check alignment for 32-bit and 64-bit IRS regs. */
+	attr =3D GICV5_IRS_IDR0 + 2;
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unaligne=
d 32-bit attr");
+
+	attr =3D GICV5_IRS_IST_BASER + 4;
+	ret =3D __kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unaligne=
d 64-bit attr");
+
+	/* Check bad user pointers */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IRS_REGS get with bad poin=
ter");
+
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, NULL);
+	TEST_ASSERT(ret && errno =3D=3D EFAULT, "GICv5 IRS_REGS set with bad poin=
ter");
+
+	/* ID restore validation rejects unsupported values. */
+	val =3D FIELD_PREP(GICV5_IRS_IDR0_INT_DOM, GICV5_IRS_IDR0_INT_DOM_SECURE)=
;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR0=
 domain");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR0 failed");
+	val |=3D GICV5_IRS_IDR0_SETLPI;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR0, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unsuppor=
ted IDR0");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR1, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR1 failed");
+	val |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, 0x7);
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR1, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR1=
");
+
+	val =3D 0;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR2, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR2=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR5, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR5 failed");
+	val++;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR5, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR5=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR6, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR6 failed");
+	val++;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR6, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR6=
");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR7, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR7 failed");
+	val++;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IDR7, &val);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad IDR7=
");
+
+	/* Status registers read as idle through userspace accessors. */
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_SYNC_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_SYNC_STATUSR_IDLE,
+		    "GICv5 IRS_REGS SYNC_STATUSR is not idle");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_SPI_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_SPI_STATUSR_IDLE,
+		    "GICv5 IRS_REGS SPI_STATUSR is not idle");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_PE_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_PE_STATUSR_IDLE,
+		    "GICv5 IRS_REGS PE_STATUSR is not idle");
+
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_STATUSR, &val);
+	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_IST_STATUSR_IDLE,
+		    "GICv5 IRS_REGS IST_STATUSR is not idle");
+
+	/*
+	 * Userspace restores IST_BASER without allocating or accessing an IST.
+	 * Supply a synthetic, aligned guest address only to verify the register
+	 * round trip.
+	 */
+	val =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+			 VGIC_V5_TEST_IST_BASER_GPA >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+	val |=3D GICV5_IRS_IST_BASER_VALID;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &val);
+	TEST_ASSERT(!ret, "GICv5 IRS_REGS failed to restore IST_BASER");
+
+	attr =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
+				    GICV5_IRS_IST_BASER, &attr);
+	TEST_ASSERT(!ret && attr =3D=3D val, "GICv5 IRS_REGS IST_BASER restore mi=
smatch");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ppis(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -391,6 +642,10 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 NR_IRQS attrs\n");
 	test_vgic_v5_nr_irqs_attrs();
=20
+	pr_info("Test VGICv5 IRS_REGS attrs\n");
+	test_vgic_v5_irs_regs_attrs();
+
+
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index 41b698b3952f3..0ad6dcc3d510b 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -16,6 +16,78 @@
 #define GICV5_IRS_SIZE			0x20000
 #define GICV5_IRS_ALIGN			0x10000
=20
+/*
+ * IRS register offsets. Keep this selftest copy scoped to the offsets and
+ * fields exercised by the userspace API tests.
+ */
+#define GICV5_IRS_IDR0			0x0000
+#define GICV5_IRS_IDR1			0x0004
+#define GICV5_IRS_IDR2			0x0008
+#define GICV5_IRS_IDR3			0x000c
+#define GICV5_IRS_IDR4			0x0010
+#define GICV5_IRS_IDR5			0x0014
+#define GICV5_IRS_IDR6			0x0018
+#define GICV5_IRS_IDR7			0x001c
+#define GICV5_IRS_IIDR			0x0040
+#define GICV5_IRS_AIDR			0x0044
+#define GICV5_IRS_CR0			0x0080
+#define GICV5_IRS_CR1			0x0084
+#define GICV5_IRS_SYNCR			0x00c0
+#define GICV5_IRS_SYNC_STATUSR		0x00c4
+#define GICV5_IRS_SPI_VMR		0x0100
+#define GICV5_IRS_SPI_SELR		0x0108
+#define GICV5_IRS_SPI_DOMAINR		0x010c
+#define GICV5_IRS_SPI_RESAMPLER		0x0110
+#define GICV5_IRS_SPI_CFGR		0x0114
+#define GICV5_IRS_SPI_STATUSR		0x0118
+#define GICV5_IRS_PE_SELR		0x0140
+#define GICV5_IRS_PE_STATUSR		0x0144
+#define GICV5_IRS_PE_CR0		0x0148
+#define GICV5_IRS_IST_BASER		0x0180
+#define GICV5_IRS_IST_CFGR		0x0190
+#define GICV5_IRS_IST_STATUSR		0x0194
+#define GICV5_IRS_MAP_L2_ISTR		0x01c0
+#define GICV5_IRS_VMT_BASER		0x0200
+#define GICV5_IRS_VMT_CFGR		0x0210
+#define GICV5_IRS_VMT_STATUSR		0x0214
+#define GICV5_IRS_VPE_SELR		0x0240
+#define GICV5_IRS_VPE_DBR		0x0248
+#define GICV5_IRS_VPE_HPPIR		0x0250
+#define GICV5_IRS_VPE_CR0		0x0258
+#define GICV5_IRS_VPE_STATUSR		0x025c
+#define GICV5_IRS_VM_DBR		0x0280
+#define GICV5_IRS_VM_SELR		0x0288
+#define GICV5_IRS_VM_STATUSR		0x028c
+#define GICV5_IRS_VMAP_L2_VMTR		0x02c0
+#define GICV5_IRS_VMAP_VMR		0x02c8
+#define GICV5_IRS_VMAP_VISTR		0x02d0
+#define GICV5_IRS_VMAP_L2_VISTR		0x02d8
+#define GICV5_IRS_VMAP_VPER		0x02e0
+#define GICV5_IRS_SAVE_VMR		0x0300
+#define GICV5_IRS_SAVE_VM_STATUSR	0x0308
+#define GICV5_IRS_MEC_IDR		0x0340
+#define GICV5_IRS_MEC_MECID_R		0x0344
+#define GICV5_IRS_MPAM_IDR		0x0380
+#define GICV5_IRS_MPAM_PARTID_R		0x0384
+#define GICV5_IRS_SWERR_STATUSR		0x03c0
+#define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
+#define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
+
+#define GICV5_IRS_IDR0_SETLPI		BIT(9)
+#define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
+#define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
+
+#define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
+
+#define GICV5_IRS_SYNC_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_SPI_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_PE_STATUSR_IDLE	BIT(0)
+#define GICV5_IRS_IST_STATUSR_IDLE	BIT(0)
+
+#define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
+#define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
+#define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
+
 /*
  * Definitions for GICv5 instructions for the Current Domain
  */
--=20
2.34.1
