Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012018.outbound.protection.outlook.com [52.101.66.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911A1488227
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523143; cv=fail; b=OQZjpQ/tPMgOdns+5jJNYP5wRryrY99SGj4opTqh9YL6GpqGIy2YfmN9NKkvYpX06o/efzyYRpmDIbb62WRYIsihI0IvJCB4uD3Ijhk1rq4Lr8pQCHa/RtcbqDEBPuv/XAdpagWdAHUwwie+EChuQ4qSOKSQG0sEdai9EuXSM2U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523143; c=relaxed/simple;
	bh=OVu1OY/KKrytzQJPdc557oPytU3zxdun1jQIHdmCWgQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RoSTL3HI+DSulD64Whjg0grk4NmWXGliSAUTFmw/a0fyRPZ73Dxh71hkB3hpDfw2AFcr5JdWlQw1xoTydWsArGqUIGeJwlnMBVnirNL0EFwtNnENIcszvp3ww9sIrpqp57qxspnRcbfGCx69ccxl6sQah1VCPOuLmS3zrEELT3E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EfKrGc0O; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EfKrGc0O; arc=fail smtp.client-ip=52.101.66.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EfKrGc0O";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EfKrGc0O"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=skiiQiKWkS5yhDtynMp0456LSLgvE+IPw2LjN1pbyZu5qiC7XvFfME9sihgltsAyb/wmhw2y/8lCMpJpztIqnQdY/K1sGYPEbCnsCHbHl+kUSXLzpoo5E1r5IPXdOb7TXRDn6HVS+I5DmVDgu5R1MeEjd8dwJQJW1as9NWkuPgjFEISrLsoDTAQVdILkaQvj8O6QpIC6aNnJujNXPDjNWV9M5ylnZVX6s+A/08/Dyrbgb2mlh4xtMqQ1aHqTPw3dQnv1X5gndx+elbTeQ2j9gMtY/m0joqTZoh/MO5aY9N9t51Iv1Yb/A2hqAiesXR5tOekLdY+FuAQaptEtc0Kvxg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pexsU4F7Z+iSqd/1qg3kz2LZGppG61cxtH3Y+LSotmI=;
 b=lBINhOhBbX5SMRp+kD9ZzMcTN5lNHA4NTEW7EOJsu1CJ9VVBvholC1QHWYDXME5xowQz0ZP1J8I+8Y8Cm9K6GeCDbQBktvs4xafuWD4IgJdOufglQ4U+XY6C5gIZ4Nvt6ZEhJe1SaJe3pGmqTlh5yf84uu94lNfuCEBc6MxuXiUCCBxgPYw9ulF/Q7A7ukL5pxIb5L7bLPtR63D2gucv0HR1KqD+DW2smlrmo1UCNWxHfOkjH/9Gby4BT89CgJMGusnaz1+LogVt5SRsfGibUD5TUAVgkpkTqXRbZ6j9AkAAvNiqDD1YqSkKqe2+RkVWOognplhI7afFSL7LKMVzLQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pexsU4F7Z+iSqd/1qg3kz2LZGppG61cxtH3Y+LSotmI=;
 b=EfKrGc0OeMVIaxIrAZHMPAlVu52mTnaUlY/DjJft4DxUwOPBu5bIkbK6S+KZ3DGtAunEuifVclUTzRhC2iwxQida1ce1dTKyswT0sFtvbZwhw39hZuxr6OEcGBpfpLirUV9Ai+dZM0T5tndOsofKCw6Wgg8JHJuhyHai+gxa/bo=
Received: from DUZPR01CA0049.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::9) by PA4PR08MB6077.eurprd08.prod.outlook.com
 (2603:10a6:102:e7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:58:47 +0000
Received: from DU2PEPF0001E9C6.eurprd03.prod.outlook.com
 (2603:10a6:10:469:cafe::23) by DUZPR01CA0049.outlook.office365.com
 (2603:10a6:10:469::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:58:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C6.mail.protection.outlook.com (10.167.8.75) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8 via
 Frontend Transport; Fri, 4 Sep 2026 11:58:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y4ZZnXg+7A/LW4RRdMk9bJsXinHQcxM+EmIc2gZLg2N9L9RFdrfXsdGR7mza3rikKUG2XGVhGvyya92Y7HzHTmuK9YsRK1SGPZdPJ1rGwAaiAvBTnZvJdsnET4/fVtBcRNQfaOBwj/8V5q/4GV7ItjTnagWJnC+xVwIq5t9NPvC4uQiY/foHsmN1HrZQsOHMvtHeRN8oDADkuzxUD57DKGFLh5NOglOfngcJht2KBiRy6DSBMJoQF1akFg2azNh3RVOLmblKRF8KCxSvXzk+s07D4LUlOAP9IjZ2yoqthYnZobRO1b4xvGCeQbbxUwjdiovKSEGEZIlXaZGiSm5imw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pexsU4F7Z+iSqd/1qg3kz2LZGppG61cxtH3Y+LSotmI=;
 b=tm2dVXCuOw0qu5D6bbhpNZCGETQh/DooW+t3vJ535FE2v224o1gcwe71t3g1oEpML8C3BzJysTANFzGwv9nOCVgkhaDclNdn47lpkIQJdMyIUI0Kpa9T6g5owQvkI2TORAaxdVCO7u56LFhzJ5Jh+UCuz6msaatxagY4bvbFUz2ZUHE3FlZhV+DtrSpYgzBCEsSIL1HDCmyVlzI4IWRBN91pRrQfU71NcEI2Iqx3Ap8RAzPEvZt3ARTafl9cIjjj+9fv3svB6yXrcMBVhlpqGDGfVol/zx3EsIcIm9ZVRyVNxQN+tiTIpz1W/Uo4xvRL3dLI7etaGzewgKzERfLzkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pexsU4F7Z+iSqd/1qg3kz2LZGppG61cxtH3Y+LSotmI=;
 b=EfKrGc0OeMVIaxIrAZHMPAlVu52mTnaUlY/DjJft4DxUwOPBu5bIkbK6S+KZ3DGtAunEuifVclUTzRhC2iwxQida1ce1dTKyswT0sFtvbZwhw39hZuxr6OEcGBpfpLirUV9Ai+dZM0T5tndOsofKCw6Wgg8JHJuhyHai+gxa/bo=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GV1PR08MB10954.eurprd08.prod.outlook.com (2603:10a6:150:1ee::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:58:11 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:58:11 +0000
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
Subject: [PATCH v6 47/49] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Topic: [PATCH v6 47/49] KVM: selftests: Add VGICv5 LPI delivery tests
Thread-Index: AQHdPGSouQyzqcCIUkyj1fWsz2HUUQ==
Date: Fri, 4 Sep 2026 11:58:10 +0000
Message-ID: <20260904113404.4051341-48-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GV1PR08MB10954:EE_|DU2PEPF0001E9C6:EE_|PA4PR08MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: b61eadb8-72ae-4b06-fadb-08df0a7be0c1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|10067099003|56012099006|11063799006|3023799007|18002099003|6133799003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 dexpFm8cSRNHMgm+tII/nTXlnlW8KSaQJqLNQyxFfSN+arbWR5WwbB31QwwEupP/fGMsqg1HJPJGOFaWpc0LQeHQegl4I9netCQ12/NoGOpEuM7FygUJRYCh4h075t2HI55fo44tkZhCuNsviZep2mbiOkjXPlicEOmoCKjc9rWZZr8rt147fOGGWmfqAe6mKQ70QB9bA7ftYlXvbSJRlosWfbVEovg1gzTUSxGm8Lk/x4573G6XiKp5RUVPyxDH0xxl3mrt2ntMq9Rj59CGmlUEIiBdhuivF3Zn1cHx6PMGM2UfG9LRFV2oCCP1sT9VbXmAIgYpi1484YaRFmuXIGnX8wCm6iYukkmKmMnaSYhIg1OFRr1bFJ3dzkTsU3ssPo41c/boQrpbYgiRwfltfkOXXAbmRLiRGERx+L3FZWE8RasmX1gDe5L/ohltyA7QwWznO45CnfgV0At1msQvoLafZ25qRPA5mVZx2qz5p+jSffqzXoegp9vsYrni2JgycjxE7Butbspm3Ec7j4o1P5XTmbPTySHlkCSr9GpTeO4F44FJVvlq++8Vjl4F5elMDmApMVf6A5p2SxEBWhaZGcqSGTJz7QTTp7G1IuR++Os0rB2VU4PDJA66Y86WGdun6/nTLwXstjeNCpNmMJPZX1evCItHkB/RGd+0PfUZNtRaAox73JsVHfM79vpnc7uT0FbnRIp3pBDRS2xp9mPkteiTdY9znGOQtX2llWBoqt4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(10067099003)(56012099006)(11063799006)(3023799007)(18002099003)(6133799003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Z5NMKIIysFHwkOkyKFwgT4v/uKGvB3t0C0K+7StbictR8FKwTE0uKYZdhog9leWI/yKS7Xd8xGGj9O8+wo2fo0GfwIWX3l6ctfz+c8XIsZJxNGwJe5cWkX0lU6rrJULUfF9qUJYxIB5i97jmMjzR5uMH0Crw5i7i2iO09v0hl/D6XnMBVOiN3qkBZIBw507zCAPGMmP1LVMOE6Q5etmAKypGnkYrzYOoS4yP0L5TA2HGmWjx8FrQSCrgJ/E1u2E+KhzxDzOIQ0NidpFQwLQoLBJwCV1GotmtOLVcNGuFCZo9rXDasJGKiz7C9Pcs8dA0WK9P5MGCOjNwdgPvximrMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10954
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C6.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	efe81ef7-e147-4d22-eae1-08df0a7bcac7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|14060799003|1800799024|35042699022|23010399003|376014|18002099003|22082099003|56012099006|3023799007|10067099003|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
	QNgUV3e/HQtOJ6cangBbkKBbhb5L8g6nOU9DO4rtTMp1ImOgdGWRja9+Z5Hi4Yip5/nLFpLcjpvaLVXVF0ymXc6mmphTr8FkLZfM2CS5I4OJznrFeBMVzkVaP+xhoThHvEFevlu7cEAbPB0tq3g7MfgWTRfXhez4HAIIaXKrzb4n8LqjT2gpPCIT7mO3BwmF4JKjUyOoJbBRZ3NIxScHt7Kh1bKYwanUFY/cOk3Z70QnsuWOZKJ3i4Z8BP5LAA+vfZXE/xsw78e5aGLgUY/gLcJ9tVwrSgfYLjO9eEoKyW1mAkkUUHyzjq+8Fclzfc8AMuvN3eWgTVQWJ39UbhrhckjTcbMl8hYjjBJC5wHm9NKqBvLV5D38jtWf/XmOXDvz8H2vKoUWB7aoyvYxx0z+M+o1Tf0Uoi7JKBrQeNakPVGL43WRdbKlcLNGb6Cpu4k3u1OfEapVV0KQoOPW5iiHghRzI27Xgjzzy0GObWxXnGcM1AZstXgE/CcDZuM7wLU52i9LFiWUL9RXINuZ/wrAV2rBO7xOFVtEOjf4Sqi/9/iUGJpFjUsRSloh4xLod9gmv8qhpn0UGUDBBXimE6GqrUGbcYlwKSGIuzbV7pkIwAhm7aPuKBwxVvIMoUZRCcDXIHCOQdB5iqRipiUwvOCqjqllcE0neRak0sLF40gjGL8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(14060799003)(1800799024)(35042699022)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(3023799007)(10067099003)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7r25wWff8EeDfxhZD99F/+gdyFtLuGv9UcK1UQDZX2FcrYqIwsACVsBf9+mx3eAX2HlI7cshwbxO/jIU70QO/KpA+Sp2x7GYLa/cm9EJd4lZ46U/oVRs7cmO5mv1nCQcGAI0mvjC97ju4iCdt2J2aDX68azTYUlOgO1ZoWpwn0YuOsQxTJZZNsO6gSSAYNjJNWoDjYFbYie32yD8B1vSqQhg/NewlCBbXk4LejuNy/Z6N4ITJ8lZXJ4bHbt2MfCs6GbuZBCSbJfv7Lt9cWUht1w0gnx6o61I2T7vcTgVY0uoV+o5nRhUmFRaErrY89coaL3Qu9QbUWZDqMyYE+0nfUKHItsUq4Znw4fN9J/v+alOKChcnsliXBqTQNaMiOho0/UHWVl57UyNS0rivdwlZmGS2E9WNe1SYRMDUcp2GMHPKh9NFzSp3ZyOgwBZ6i7W
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:58:47.6846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b61eadb8-72ae-4b06-fadb-08df0a7be0c1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C6.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6077

Add a two-VPE VGICv5 LPI delivery test. LPIs depend on an IST whose
base is provided by the guest through IRS_IST_BASER, which causes KVM
to allocate and provide an LPI IST to the hardware. Exercise the
virtual IRS ID registers and IST base configuration path before
checking interrupt delivery.

Back the guest's LPI IST with a dedicated userspace memslot and
identity-map it into the guest at the same IPA and VA. This lets the
guest provide that address to the emulated IRS through IRS_IST_BASER
while the host test still allocates and owns the backing memory.

Have VPE0 enable the IRS, derive a valid linear LPI IST configuration
from the virtual IRS ID registers, provide the IST base through
IRS_IST_BASER, configure one LPI for each VPE, and send an LPI to
VPE1. While the BASER is valid, attempt to change its address and
verify that the write is ignored. VPE1 consumes the first LPI and
replies with a second, which VPE0 consumes before completing the test.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 247 +++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  16 ++
 2 files changed, 261 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index ea3451d850c22..c4c932f4c1d46 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -13,11 +13,17 @@
 #include "vgic.h"
=20
 #define NR_VCPUS		1
+#define VGIC_V5_LPI_NR_VCPUS	2
+#define VGIC_V5_LPI_MEMSLOT	1
 #define VGIC_V5_NR_PRIVATE_IRQS	64
 #define VGIC_V5_DEFAULT_NR_SPIS	32
 #define VGIC_V5_MAX_NR_SPIS	BIT(10)
 #define VGIC_V5_IRS_SIZE		0x20000
 #define VGIC_V5_IRS_WAIT_RETRIES	1000000
+#define VGIC_V5_LPI_IST_BASE_GPA	(GICV5_IRS_CONFIG_BASE_GPA + VGIC_V5_IRS_=
SIZE)
+#define VGIC_V5_LPI_IST_SIZE		0x10000
+#define LPI_TEST_TO_VPE1		0
+#define LPI_TEST_TO_VPE0		1
=20
 static u64 max_phys_size;
=20
@@ -33,6 +39,8 @@ struct vm_gic {
 #define GUEST_CMD_IRQ_DIEOI	11
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
+#define GUEST_CMD_LPI_SENT	14
+#define GUEST_CMD_LPI_REPLIED	15
=20
 static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *spi_ist, size_t spi_s=
ize,
 					       void *lpi_ist, size_t lpi_size)
@@ -47,11 +55,22 @@ static struct kvm_vgic_v5_ist vgic_v5_ist_attr(void *sp=
i_ist, size_t spi_size,
=20
 static u32 spi_line_expected;
 static bool spi_line_level_sensitive;
+static bool lpi_ist_ready;
+
+static u64 gicv5_hwirq(u32 type, u32 intid)
+{
+	return FIELD_PREP(GICV5_HWIRQ_TYPE, type) |
+	       FIELD_PREP(GICV5_HWIRQ_ID, intid);
+}
+
+static u64 gicv5_lpi_hwirq(u32 lpi)
+{
+	return gicv5_hwirq(GICV5_HWIRQ_TYPE_LPI, lpi);
+}
=20
 static u64 gicv5_spi_hwirq(u32 spi)
 {
-	return FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI) |
-	       FIELD_PREP(GICV5_HWIRQ_ID, spi);
+	return gicv5_hwirq(GICV5_HWIRQ_TYPE_SPI, spi);
 }
=20
 static void gicv5_setup_and_enable_hwirq(u64 hwirq, u32 target_vpe)
@@ -73,6 +92,18 @@ static void gicv5_enable_spi(u32 spi, u32 target_vpe)
 	gicv5_setup_and_enable_hwirq(gicv5_spi_hwirq(spi), target_vpe);
 }
=20
+static void gicv5_enable_lpi(u32 lpi, u32 target_vpe)
+{
+	gicv5_setup_and_enable_hwirq(gicv5_lpi_hwirq(lpi), target_vpe);
+}
+
+static void gicv5_send_lpi(u32 lpi)
+{
+	u64 hwirq =3D gicv5_lpi_hwirq(lpi);
+
+	gic_insn(hwirq | GICV5_GIC_CDPEND_PENDING_MASK, CDPEND);
+}
+
 static void gicv5_wait_for_irs_idle(u32 reg, u32 idle)
 {
 	int i;
@@ -102,6 +133,58 @@ static void gicv5_configure_spi(u32 spi, bool level)
 				GICV5_IRS_SPI_STATUSR_IDLE);
 }
=20
+static u32 gicv5_lpi_istsz(u32 idr2, u32 lpi_id_bits)
+{
+	if (!(idr2 & GICV5_IRS_IDR2_ISTMD))
+		return GICV5_IRS_IST_CFGR_ISTSZ_4;
+
+	if (lpi_id_bits >=3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, idr2))
+		return GICV5_IRS_IST_CFGR_ISTSZ_16;
+
+	return GICV5_IRS_IST_CFGR_ISTSZ_8;
+}
+
+static void gicv5_configure_lpi_ist(void)
+{
+	u32 idr2, min_lpi_id_bits, lpi_id_bits, id_bits, istsz;
+	u64 val;
+
+	idr2 =3D readl(GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IDR2);
+	GUEST_ASSERT(idr2 & GICV5_IRS_IDR2_LPI);
+
+	min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, idr2);
+	id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, idr2);
+	/* Default to 32 LPIs, unless the min requirement is higher */
+	lpi_id_bits =3D max(5U, min_lpi_id_bits);
+	GUEST_ASSERT(lpi_id_bits <=3D id_bits);
+
+	istsz =3D gicv5_lpi_istsz(idr2, lpi_id_bits);
+	/*
+	 * We allocate a fixed-size IST buffer on the host to avoid dynamic
+	 * allocation from the guest. Make sure it fits the linear IST described
+	 * by IDR2 before programming IRS_IST_BASER.
+	 */
+	GUEST_ASSERT((BIT_ULL(lpi_id_bits) << (istsz + 2)) <=3D VGIC_V5_LPI_IST_S=
IZE);
+
+	val =3D FIELD_PREP(GICV5_IRS_IST_CFGR_LPI_ID_BITS, lpi_id_bits) |
+	      FIELD_PREP(GICV5_IRS_IST_CFGR_ISTSZ, istsz);
+	writel(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_CFGR);
+
+	val =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
+			 VGIC_V5_LPI_IST_BASE_GPA >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
+	val |=3D GICV5_IRS_IST_BASER_VALID;
+	writeq(val, GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_BASER);
+
+	GUEST_ASSERT_EQ(readl(GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_STATUSR),
+			GICV5_IRS_IST_STATUSR_IDLE);
+
+	/* The address is immutable while the BASER is valid. */
+	writeq(val ^ FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK, 1),
+	       GICV5_IRS_CONFIG_BASE_GVA + GICV5_IRS_IST_BASER);
+	GUEST_ASSERT_EQ(readq(GICV5_IRS_CONFIG_BASE_GVA +
+			      GICV5_IRS_IST_BASER), val);
+}
+
 static void gicv5_enable_irs(void)
 {
 	writel(GICV5_IRS_CR0_IRSEN,
@@ -109,6 +192,12 @@ static void gicv5_enable_irs(void)
 	gicv5_wait_for_irs_idle(GICV5_IRS_CR0, GICV5_IRS_CR0_IDLE);
 }
=20
+static void gicv5_configure_test_lpis(void)
+{
+	gicv5_enable_lpi(LPI_TEST_TO_VPE1, 1);
+	gicv5_enable_lpi(LPI_TEST_TO_VPE0, 0);
+}
+
 static void guest_ppi_irq_handler(struct ex_regs *regs)
 {
 	bool valid;
@@ -209,6 +298,67 @@ static void guest_spi_line_code(void)
 		wfi();
 }
=20
+static void guest_lpi_irq_handler(struct ex_regs *regs)
+{
+	u32 vcpu_id =3D guest_get_vcpuid();
+	u32 expected_lpi =3D vcpu_id ? LPI_TEST_TO_VPE1 : LPI_TEST_TO_VPE0;
+	u64 expected_hwirq =3D gicv5_lpi_hwirq(expected_lpi);
+	u32 hwirq;
+	u64 ia;
+
+	ia =3D gicr_insn(CDIA);
+	if (!GICV5_GICR_CDIA_VALID(ia))
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+	GUEST_ASSERT_EQ(hwirq, expected_hwirq);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	if (vcpu_id) {
+		gicv5_send_lpi(LPI_TEST_TO_VPE0);
+		GUEST_SYNC(GUEST_CMD_LPI_REPLIED);
+		while (1)
+			wfi();
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_lpi_code(void)
+{
+	u32 vcpu_id =3D guest_get_vcpuid();
+
+	local_irq_disable();
+
+	if (!vcpu_id) {
+		gicv5_enable_irs();
+		gicv5_configure_lpi_ist();
+		gicv5_configure_test_lpis();
+		WRITE_ONCE(lpi_ist_ready, true);
+	}
+
+	/* Go bang if we run VCPU1 before VCPU0 */
+	GUEST_ASSERT(READ_ONCE(lpi_ist_ready));
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	if (!vcpu_id) {
+		gicv5_send_lpi(LPI_TEST_TO_VPE1);
+		GUEST_SYNC(GUEST_CMD_LPI_SENT);
+	}
+
+	while (1)
+		wfi();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -279,6 +429,48 @@ static void vgic_v5_spi_line_vm_create(struct vm_gic *=
v,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 }
=20
+static void vgic_v5_lpi_vm_create(struct vm_gic *v,
+				  struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS])
+{
+	unsigned int nr_lpi_ist_pages;
+	u64 attr;
+	int i;
+
+	v->gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v->vm =3D __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_LPI_NR_VCPUS, 0);
+	v->gic_fd =3D kvm_create_device(v->vm, v->gic_dev_type);
+
+	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++) {
+		vcpus[i] =3D vm_vcpu_add(v->vm, i, guest_lpi_code);
+		TEST_ASSERT(vcpus[i], "Failed to create vCPU");
+	}
+
+	vm_init_descriptor_tables(v->vm);
+	vm_install_exception_handler(v->vm, VECTOR_IRQ_CURRENT,
+				     guest_lpi_irq_handler);
+
+	for (i =3D 0; i < VGIC_V5_LPI_NR_VCPUS; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
+	vgic_v5_map_irs(v->vm);
+
+	nr_lpi_ist_pages =3D vm_calc_num_guest_pages(v->vm->mode,
+						   VGIC_V5_LPI_IST_SIZE);
+	vm_userspace_mem_region_add(v->vm, VM_MEM_SRC_ANONYMOUS,
+				    VGIC_V5_LPI_IST_BASE_GPA,
+				    VGIC_V5_LPI_MEMSLOT,
+				    nr_lpi_ist_pages, 0);
+	/* Map the IST at VA =3D=3D IPA so the guest can program the same BASER. =
*/
+	virt_map(v->vm, VGIC_V5_LPI_IST_BASE_GPA,
+		 VGIC_V5_LPI_IST_BASE_GPA, nr_lpi_ist_pages);
+
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+}
+
 static void vgic_v5_run_spi_line_test(u32 nr_spis, u32 expected_spi,
 				      bool level_sensitive,
 				      bool lower_before_run)
@@ -1184,6 +1376,54 @@ static void test_vgic_v5_spis(void)
 	vgic_v5_run_spi_line_test(VGIC_V5_DEFAULT_NR_SPIS, 2, true, false);
 }
=20
+static void test_vgic_v5_lpis(void)
+{
+	struct kvm_vcpu *vcpus[VGIC_V5_LPI_NR_VCPUS];
+	struct ucall uc;
+	struct vm_gic v;
+	int ret;
+
+	lpi_ist_ready =3D false;
+	vgic_v5_lpi_vm_create(&v, vcpus);
+	sync_global_to_guest(v.vm, lpi_ist_ready);
+
+	/* VPE0 programs a linear LPI IST from the virtual IRS ID registers. */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0");
+	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
+		    "GICv5 LPI vCPU0 did not become ready");
+
+	/* VPE1 waits for the shared LPI setup and enables its CPU interface. */
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU1");
+	TEST_ASSERT(get_ucall(vcpus[1], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
+		    "GICv5 LPI vCPU1 did not become ready");
+
+	/* VPE0 sends an LPI to VPE1. */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0 sender");
+	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_LPI_SENT,
+		    "GICv5 LPI vCPU0 did not send LPI");
+
+	/* VPE1 consumes the LPI and replies with another LPI. */
+	ret =3D run_vcpu(vcpus[1]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU1 receiver");
+	TEST_ASSERT(get_ucall(vcpus[1], &uc) =3D=3D UCALL_SYNC &&
+		    uc.args[1] =3D=3D GUEST_CMD_LPI_REPLIED,
+		    "GICv5 LPI vCPU1 did not reply");
+
+	/* VPE0 consumes the reply LPI and ends the test. */
+	ret =3D run_vcpu(vcpus[0]);
+	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0 receiver");
+	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_DONE,
+		    "GICv5 LPI vCPU0 did not complete");
+
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V5).
  */
@@ -1238,6 +1478,9 @@ void run_tests(u32 gic_dev_type)
=20
 	pr_info("Test VGICv5 SPIs\n");
 	test_vgic_v5_spis();
+
+	pr_info("Test VGICv5 LPIs\n");
+	test_vgic_v5_lpis();
 }
=20
 int main(int ac, char **av)
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
index 091d9dbd3c01d..2d455515563e0 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -80,6 +80,14 @@
=20
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
=20
+#define GICV5_IRS_IDR2_ISTMD_SZ	GENMASK(19, 15)
+#define GICV5_IRS_IDR2_ISTMD		BIT(14)
+#define GICV5_IRS_IDR2_IST_L2SZ	GENMASK(13, 11)
+#define GICV5_IRS_IDR2_IST_LEVELS	BIT(10)
+#define GICV5_IRS_IDR2_MIN_LPI_ID_BITS	GENMASK(9, 6)
+#define GICV5_IRS_IDR2_LPI		BIT(5)
+#define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
+
 #define GICV5_IRS_CR0_IDLE		BIT(1)
 #define GICV5_IRS_CR0_IRSEN		BIT(0)
=20
@@ -94,6 +102,13 @@
 #define GICV5_IRS_IST_BASER_ADDR_MASK	GENMASK_ULL(55, 6)
 #define GICV5_IRS_IST_BASER_VALID	BIT_ULL(0)
 #define GICV5_IRS_IST_BASER_ADDR_SHIFT	6ULL
+#define GICV5_IRS_IST_CFGR_STRUCTURE	BIT(16)
+#define GICV5_IRS_IST_CFGR_ISTSZ	GENMASK(8, 7)
+#define GICV5_IRS_IST_CFGR_L2SZ	GENMASK(6, 5)
+#define GICV5_IRS_IST_CFGR_LPI_ID_BITS	GENMASK(4, 0)
+#define GICV5_IRS_IST_CFGR_ISTSZ_4	0b00
+#define GICV5_IRS_IST_CFGR_ISTSZ_8	0b01
+#define GICV5_IRS_IST_CFGR_ISTSZ_16	0b10
=20
 /*
  * Definitions for GICv5 instructions for the Current Domain
@@ -164,6 +179,7 @@
=20
 #define GICV5_HWIRQ_TYPE		GENMASK_ULL(31, 29)
 #define GICV5_HWIRQ_ID			GENMASK_ULL(23, 0)
+#define GICV5_HWIRQ_TYPE_LPI		0x2
 #define GICV5_HWIRQ_TYPE_SPI		0x3
=20
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
--=20
2.34.1
