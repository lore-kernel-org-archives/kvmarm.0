Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010042.outbound.protection.outlook.com [52.101.84.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDEC4B66DC
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 14:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445583; cv=fail; b=OILOykmj1yhFKwpOqSRwcY3g0+jgzV6bECB9NSDdKXujoLEGp541ST5aJYBU1GZv4Ml5S91P7zYDSM/juk7osSttHSzzLmr5EaqtVpGJAUqNI0FZJphAh/kTKfyHiFjPqvxbT7p8qRVBTK+1duAZ83JPV9eX0GMn6rJVZF5Z86E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445583; c=relaxed/simple;
	bh=o22U1bC6om9/0T/jSt/D2/05k0gr8s1dtIR2AvAIDlU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BUpUEgmj2fiD5bzpW8wP5N2vZRU82UtwIkj9WwN6JLgfhLTHkZYxGgzPvm/8dUYxgjDWXyZkjx3c9BbZ3xvPe4vpFE5SKvkcgUKoxhmVtx/lIdRKAW44Tu6sOc4WQ5m+1X9ZzFgkL0/X0XVKN2Kv32daH97O9v0ZeJvdpARxJXQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mVyfOPHX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mVyfOPHX; arc=fail smtp.client-ip=52.101.84.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mVyfOPHX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mVyfOPHX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ezza3QsFhq1LPD2Q49YFCycG14zquXHWfMwyxSQv7Yp2Ns5JD0O1gYalKX/Skj/NMsiuZA04hIeKZFDeL0FV8DgBvpb/tjRKChddSjFbXjrcLCA4ArjJFSXRpnzbfpw5WvBA8qqCezFnNuPWsNzC2KJhK3Hfl+9lo6k/ne0KxeDpkbpIMC7fs21O+X6zZPoethIoVX6QWJ8c4e+3prOk8X67jRpJh1uTteGiGEw8AwlZ9axRxl0Wx1cIWNj+W+17CvOnfqKveGDmOE1lmpchFkTbgdJ7UWKLUIDwLUDn9crTlXbHIuC1tdBEksf4k4XCX4wTUTZDd2eEcIUNXxD60w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o22U1bC6om9/0T/jSt/D2/05k0gr8s1dtIR2AvAIDlU=;
 b=y+DcYNP9+zEkLhaJDYVeCNHNmFULcE+eutNXDfF67/4zopdEUwkt/q5zhAAVda61nWNyLedms6L/iRcOm5phlV2UmxxHMwNo7LZZVbSvuYlSOyaJ2GGdjDcLKT/umDRZuHKn7yen/v0paKHCbF6uPWcP6e7hI3JfhhMAWmDeJc8+7NwPYBk9AJNaLTxVCh1P57uBMhivPNYGwH/eNFy/cVXChdoyhUO2ypzCo7EDngjzdcm70Tue/IRQxwN18aumkgXgNqywb1VPLGl+ByT1mdhKwbCzKXaB4HFkxZccoykz23ytzoWxJCkUTOC1RjC4sJsv9P+pFLhByNN9s4UzLw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o22U1bC6om9/0T/jSt/D2/05k0gr8s1dtIR2AvAIDlU=;
 b=mVyfOPHX3rchTAweSUV2CScTuNFU2S3XtEWcDpsVs7mJ5EfeJwTSmRncY0kVXu/7m6tK9MzorsGxtVmhZqx5oyefQrmG7yky/qYGYvFI32ctbaaitytixU6UIIeoWcLR924MFxGTqMkBy9haVIPstg54lwOEzYuwY6yevOu2nSQ=
Received: from DUZPR01CA0074.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::20) by GV1PR08MB8499.eurprd08.prod.outlook.com
 (2603:10a6:150:83::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 14:26:04 +0000
Received: from DB1PEPF000509EB.eurprd03.prod.outlook.com
 (2603:10a6:10:3c2:cafe::a7) by DUZPR01CA0074.outlook.office365.com
 (2603:10a6:10:3c2::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Thu, 3
 Sep 2026 14:26:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509EB.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Thu, 3 Sep 2026 14:26:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SReFf0bDbyzHrfm+5hKlOohwdG0K//SOAe6K/9RExfFTUC4sW9M4b2lrwpSs0Cm7A4exTJdRvyJAPhUM5bfNzvdYmu2qjYsnThoMfqSW8goUoyam0Bn6Cl2VbaopvOhkEvKesOvDTzZrwpFAu/DLi0Zk2qUDLZtAPZB4NuHlDweSh2oeLaAenKn1PjtFeMAcARdHjguCl3nvSiog8aEQSrOrjzaA5cQgxqXl8hSH/R8sc7044Gup8tA4Qf2UDVX31qxWli1Z9G6w2V3O9pcNcaYrg7a6tpQJDGzF2j5OgbIszsufciEQHGSHHAwea+9OJxhWaRrD3rnMQ+I1F2Ev5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o22U1bC6om9/0T/jSt/D2/05k0gr8s1dtIR2AvAIDlU=;
 b=hhaCeVadcRp08wjm3SNwY71dEIS/tatdLj7PZOys9nZVjdc1TI9ANWScrJYCN08jps0h8nm8SCokjIAhmGALh2Eta9PIM8GQYQz4No8RYs/gqw8rHe75dIcoZ2ZGPolvf2hspU0x6fez3k6gRq+ppXgqypYmMfcI6yNTmos8kKBolNmTArLwQZLmqc6v0FmsmYPcLCzJZtpOnYGgpRLS7hVKbuqpRRtAymFLcxhfn3WJBe0Uz1lmMoProocYDN1OslahwDZrgg0r7fDbIujdYH5zkpLnalxWC9AZCIokiVFYvoiO6NbcWXktZqD6i4fdFJlkFu7Gtq9byrNv/nLUPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o22U1bC6om9/0T/jSt/D2/05k0gr8s1dtIR2AvAIDlU=;
 b=mVyfOPHX3rchTAweSUV2CScTuNFU2S3XtEWcDpsVs7mJ5EfeJwTSmRncY0kVXu/7m6tK9MzorsGxtVmhZqx5oyefQrmG7yky/qYGYvFI32ctbaaitytixU6UIIeoWcLR924MFxGTqMkBy9haVIPstg54lwOEzYuwY6yevOu2nSQ=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AM8PR08MB5844.eurprd08.prod.outlook.com (2603:10a6:20b:1d1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 14:25:31 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 14:25:30 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "lpieralisi@kernel.org" <lpieralisi@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v5 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Topic: [PATCH v5 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Index: AQHdJl3dOdPEmMuWIEihuIlxfsIsfbaSmQIAgCp6ZYA=
Date: Thu, 3 Sep 2026 14:25:30 +0000
Message-ID: <eba5b5f5b0185c47e880bccabcf1bcef2de0b5dd.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-4-sascha.bischoff@arm.com>
	 <anXhPp9QUH_rOn2X@red-moon>
In-Reply-To: <anXhPp9QUH_rOn2X@red-moon>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AM8PR08MB5844:EE_|DB1PEPF000509EB:EE_|GV1PR08MB8499:EE_
X-MS-Office365-Filtering-Correlation-Id: 758cf26e-f987-45d8-141a-08df09c748a2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|38070700021|6133799003|3023799007|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 ll/QL7ADlvRHc+Phb5DPOeSVhRQhYpEczJwZH8oP9So1l9N1h6+cmEk8f8UE5Mxgs09AtxXEcUByJbJw+QGkEP4NHBSBETMywON8LLqSb7cPOXtu1lXHsUYHvsTTWg83buXOLltlXFx6FIMGHRAh2d4+Z3+zSkKt+SxK4DqOv2UL3KkdUlMWN3/OiV14W4OmHbZ5Ws/8GDTB5UFLtRcq67xHjN1Wk/i3b0LQIbOFqH6NB8QDx9Z+3XCKdIw2Nz1+BMiCHNJNRKAwpRZ4xxXQn5WgJ8M+8eg4jj5tyiWWEs+Fh7oMW3HFC+fpk+6XEBy4VLcGyNShOqENh7L9P2/kSRpseYA+1yx91Xrv0a7mrvYEw8UeGhLYdlhUegJgdzK1d23HVxD3oq7NGXb544tTNYpY6swfUG5hswz1T/QO3c0HqQBR5RLL9XIH4ibF9rg+yXp/kLEsyCtfj5zNEQVUTX/A5obFy9xNeUnND12EOca0sP6AAH4IfAf1C3easWWVrUwC3nhD5LMvrVUdYfYN/ZkOrob+VvaCKpAszeJumZtdiP527hvdlF3qnVVGsbwBp31/biqX5gqF2dBT9ttTQuy4jYiN9TsUMP5j+tr28cH+ZDDvDK/l2UV9YONLTO6by3Bfy1fubElqnvN2sTunS0SMJv0jhhrCjJMq5tDr0OMH7TZ2pthqvwivLLQl1SnUeukfKpaC8azTifeqr1MmmZIdLTiTtJh9THYIFAu4lnI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(38070700021)(6133799003)(3023799007)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <F673DC7ABF0C78419012A284BB41D73B@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Ze1RMGPyAebbHej9oO4GNrRe4kvYFQIqfy2VqUzOfYNjBxwyrPB8nzFFt+vvsatVFYDZC8HqvSWmP8IW1KBsX1Hhtca6BcgwmMYeEiTaAG1qf2Ly8bHULyd9/CqmR2Lb5vmYH5Nr9ptKQYVdgCet9ObBqylnx9FjwrJmLB3IEGWkW/shYr6MHl+0cHxC9kob+0J17GeyHJuYKK/hREINi+xN4kZJ+6TnZ3USzCwzw8TNjIzuBq/dAPGnW2SxNclpYBD5aTyF2ESMT0K02Xz9WMW2lcwM+vNT/LQEesXBee+AXLy64qNDK13dCqs/54vtRC8jFvBNZWn0s5uNe4B7NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5844
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2a15c827-ce9b-49ba-fcf3-08df09c7353b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|36860700016|82310400026|23010399003|35042699022|376014|10067099003|6133799003|3023799007|22082099003|18002099003|11063799006|56012099006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	+ossScxZF/iN7hPfzwX6RDqDxR9PmLzXLo00CsaiIz54LKDt8L4teKRvH3DXXcTFYMuIR85fSx0y8wUCngLpVUUizUKyV+UXqdmtu7gV/qVZQft3qLoAwVs5C4f0gbQDTg6mBrTMVGgzAGliiTDPbqKk0Aens/unaril0inXxBxULlhh59nXFVOwHa8UOq6HjOILPde6Pjo8luoFcp+exzO8I2x+oibI3Vln9cLCkqB9Nw4lu5aA9W0wNS3AQJlNA7ztDQOoqPN6V+HMCsBSBsT0pe76SarjjVp3g9VncPWcX2nawSAQJa+jYJ6ekUCHcznsMYOkqhyAQVXRlDz/1qCdaJoCizX+s0iQaR/jnrQNEHcosOIKiFReQPAYq4x2n43tTXXwceWqtJB0GKJ4c65ALZfJQ7Ctnl5BFfBpkoZAq0YZlpKU55/GEzbGK325cHGNzJdv/7XoKLEy13+2SMEHxIm2Y1dN7KPu6jruM4/oYJz57+gDfjrxN8BXAO/IpWIZMAUEywB6TKonIIu3mK7UfR3fK/P2/uBb5OYL5HD76qH5ihUl2rkT5xwh3mcOsNUnbM2qcl1JocQaOF1+UODNu1soiyzRQhLvolNk3Enstpy8EI6uq+sCaanb86xp5K8jqT0viThu92UbvQRnqa/tBKVm4QWYhxar15uYHRY=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(36860700016)(82310400026)(23010399003)(35042699022)(376014)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ddCfxLKkCxTnX0SIAkURocBPCe95i5vAja0d51HF2VPg85qtsgWDjAykypIyDFLk+T4p0uZR5OJ+i4JH9eyVCrn2O50FGYbOS6UppUdlhgRcsngf+BVB0fjUKJjOZ7SKOJRZ4ZuQDQeCbMJmyp07jWJCVni1+d/DAVeW6DpXDTSVYtYKWTiC9DJGXpm6xKrFoCo060mvqOG+rWoq3N+EaoK/kOr/ICgNupIN9c4giJGcLBzYz10ZeXL1m804CUow1HeG+wVDf/P4HFiNVcCsqoPqc7kCXIOUsfr9nifhgxpFdvXJAwgZfXLBEGMl2xU+/mYjgdZEQJY5QabgaVAp6kcyu/jbHiEWV+H+jPywa2YbFpyo6of4K5ZZCgCWfL+CqktBOQFRyzzPsbae8RhbeA+spdnMhjhF9ItlQSv+S/P46QqYSEkcySTr+KWfykOT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 14:26:03.0533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 758cf26e-f987-45d8-141a-08df09c748a2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509EB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8499

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE1OjQ0ICswMjAwLCBMb3JlbnpvIFBpZXJhbGlzaSB3cm90
ZToNCj4gT24gRnJpLCBBdWcgMDcsIDIwMjYgYXQgMTE6MTQ6MDdBTSArMDAwMCwgU2FzY2hhIEJp
c2Nob2ZmIHdyb3RlOg0KPiA+IERldmljZS10cmVlIGJhc2VkIEdJQ3Y1IHByb2JpbmcgYWxyZWFk
eSBwYXNzZXMgdGhlIElSUyBkZXRhaWxzIGFuZA0KPiA+IG1haW50ZW5hbmNlIGludGVycnVwdCB0
byBLVk0sIGJ1dCB0aGUgQUNQSSBwYXRoIG9ubHkgaW5pdGlhbGlzZXMNCj4gPiB0aGUNCj4gPiBp
cnFjaGlwIGFuZCBpbnN0YWxscyB0aGUgQUNQSSBJUlEgbW9kZWwuIEFzIGEgcmVzdWx0LCBLVk0g
bmV2ZXINCj4gPiBzZWVzDQo+ID4gdGhlIEdJQ3Y1IGhvc3QgaW5mb3JtYXRpb24gcmVxdWlyZWQg
dG8gcHJvYmUgdGhlIHZHSUMgb24gQUNQSQ0KPiA+IHN5c3RlbXMuDQo+ID4gDQo+ID4gQWRkIHRo
ZSBBQ1BJIGVxdWl2YWxlbnQgb2YgdGhlIERUIEtWTSBzZXR1cC4gUGFyc2UgdGhlIE1BRFQgR0lD
Qw0KPiA+IGVudHJpZXMgZm9yIHRoZSBtYWludGVuYW5jZSBpbnRlcnJ1cHQsIHJldGFpbmluZyB0
aGUgdmFsdWUgZnJvbSB0aGUNCj4gPiBmaXJzdCByZWxldmFudCBlbnRyeSBhbmQgd2FybmluZyBp
ZiBsYXRlciBlbnRyaWVzIGRpc2FncmVlLiBXYXJuIGlmDQo+ID4gZmlybXdhcmUgZGVzY3JpYmVz
IHRoZSBpbnRlcnJ1cHQgYXMgZWRnZS10cmlnZ2VyZWQsIGJ1dCByZWdpc3RlciBpdA0KPiA+IGFz
DQo+ID4gYSBsZXZlbC1zZW5zaXRpdmUsIGFjdGl2ZS1oaWdoIEdTSS4gUGFzcyB0aGUgcmVzdWx0
aW5nIElSUSB0b2dldGhlcg0KPiA+IHdpdGggdGhlIElSUyBiYXNlIGFuZCBjb2hlcmVuY3kgaW5m
b3JtYXRpb24gdG8gS1ZNLg0KPiA+IA0KPiA+IE5hdGl2ZSBHSUN2NSBkb2VzIG5vdCByZXF1aXJl
IGEgbWFpbnRlbmFuY2UgaW50ZXJydXB0IHVubGVzcyB0aGUNCj4gPiBsZWdhY3kgR0lDdjMtY29t
cGF0aWJsZSBDUFUgaW50ZXJmYWNlIGlzIHByZXNlbnQsIHNvIHByZXNlcnZlIHRoZQ0KPiA+IGV4
aXN0aW5nIG5vLW1haW50ZW5hbmNlLUlSUSBoYW5kbGluZyBmb3IgdGhhdCBjYXNlLg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5j
b20+DQo+ID4gLS0tDQo+ID4gwqBkcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jIHwgOTUNCj4g
PiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gPiDCoDEgZmlsZSBjaGFu
Z2VkLCA5MSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gSnVzdCBhIGJ1bmNo
IG9mIG5pdHMgYmVsb3cuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJx
LWdpYy12NS5jIGIvZHJpdmVycy9pcnFjaGlwL2lycS0NCj4gPiBnaWMtdjUuYw0KPiA+IGluZGV4
IGU3YTdhZWRjZmFmNzguLjViOGVhODU1MWQ4MzIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9p
cnFjaGlwL2lycS1naWMtdjUuYw0KPiA+ICsrKyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1
LmMNCj4gPiBAQCAtMTEyNiw3ICsxMTI2LDcgQEAgc3RhdGljIHZvaWQgZ2ljdjVfc2V0X2NwdWlm
X2lkYml0cyh2b2lkKQ0KPiA+IMKgI2lmZGVmIENPTkZJR19LVk0NCj4gPiDCoHN0YXRpYyBzdHJ1
Y3QgZ2ljX2t2bV9pbmZvIGdpY192NV9rdm1faW5mbyBfX2luaXRkYXRhOw0KPiA+IMKgDQo+ID4g
LXN0YXRpYyB2b2lkIF9faW5pdCBnaWNfb2Zfc2V0dXBfa3ZtX2luZm8oc3RydWN0IGRldmljZV9u
b2RlICpub2RlKQ0KPiA+ICtzdGF0aWMgdm9pZCBfX2luaXQgZ2ljX3NldHVwX2t2bV9pbmZvKHVu
c2lnbmVkIGludCBtYWludF9pcnEpDQo+ID4gwqB7DQo+ID4gwqAJc3RydWN0IGdpY3Y1X2lyc19j
aGlwX2RhdGEgKmlyc19kYXRhID0NCj4gPiBnaWN2NV9pcnNfZ2V0X2NoaXBfZGF0YSgpOw0KPiA+
IMKgDQo+ID4gQEAgLTExMzcsMTcgKzExMzcsMTkgQEAgc3RhdGljIHZvaWQgX19pbml0DQo+ID4g
Z2ljX29mX3NldHVwX2t2bV9pbmZvKHN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSkNCj4gPiDCoAkg
Ki8NCj4gPiDCoAlpZiAoIWdpY3Y1X2dsb2JhbF9kYXRhLnZpcnRfY2FwYWJsZSkgew0KPiA+IMKg
CQlwcl9pbmZvKCJHSUMgaW1wbGVtZW50YXRpb24gaXMgbm90IHZpcnR1YWxpemF0aW9uDQo+ID4g
Y2FwYWJsZVxuIik7DQo+ID4gLQkJcmV0dXJuOw0KPiA+ICsJCWdvdG8gb3V0X2Rpc3Bvc2VfbWFp
bnRfaXJxOw0KPiANCj4gSXNuJ3QgaXQgY2xlYW5lciB0byBkaXNwb3NlIHRoZSBtYXBwaW5nIGlu
IHRoZSBjYWxsZXIgKGJ5IHJldHVybmluZw0KPiBhbg0KPiBlcnJvciB2YWx1ZSkgcmF0aGVyIHRo
YW4gaGVyZSA/DQo+IA0KPiBJIGFwcHJlY2lhdGUgdGhpcyBrZWVwcyB0aGUgSVJRIG1hcHBpbmcg
ZGlzcG9zYWwgaW4gb25lIHBsYWNlIGJ1dCBpdA0KPiBkZWNvdXBsZXMgdGhlIGFsbG9jYXRpb24g
ZnJvbSB0aGUgZmFpbHVyZSBwYXRoLg0KDQpUaGF0J3MgYSBnb29kIHBvaW50LiBJJ3ZlIG1vdmVk
IHRoZSBkaXNwb3NhbCB0byB0aGUgY2FsbGVycy4NCg0KPiANCj4gPiDCoAl9DQo+ID4gwqANCj4g
PiAtCWdpY192NV9rdm1faW5mby50eXBlID0gR0lDX1Y1Ow0KPiA+ICsJaWYgKFdBUk5fT04oIWly
c19kYXRhKSkNCj4gPiArCQlnb3RvIG91dF9kaXNwb3NlX21haW50X2lycTsNCj4gPiDCoA0KPiA+
ICsJZ2ljX3Y1X2t2bV9pbmZvLnR5cGUgPSBHSUNfVjU7DQo+ID4gwqAJZ2ljX3Y1X2t2bV9pbmZv
LmdpY3Y1X2lycy5iYXNlID0gaXJzX2RhdGEtPmlyc19iYXNlOw0KPiA+IMKgCWdpY192NV9rdm1f
aW5mby5naWN2NV9pcnMubm9uX2NvaGVyZW50ID0gISEoaXJzX2RhdGEtDQo+ID4gPmZsYWdzICYg
SVJTX0ZMQUdTX05PTl9DT0hFUkVOVCk7DQo+ID4gwqANCj4gPiDCoAkvKiBHSUMgVmlydHVhbCBD
UFUgaW50ZXJmYWNlIG1haW50ZW5hbmNlIGludGVycnVwdCAqLw0KPiA+IMKgCWdpY192NV9rdm1f
aW5mby5ub19tYWludF9pcnFfbWFzayA9IGZhbHNlOw0KPiA+IC0JZ2ljX3Y1X2t2bV9pbmZvLm1h
aW50X2lycSA9IGlycV9vZl9wYXJzZV9hbmRfbWFwKG5vZGUsIDApOw0KPiA+ICsJZ2ljX3Y1X2t2
bV9pbmZvLm1haW50X2lycSA9IG1haW50X2lycTsNCj4gPiDCoA0KPiA+IMKgCS8qDQo+ID4gwqAJ
ICogV2UgcmVxdWlyZSBhbiBNSSBpZiB3ZSBoYXZlIGxlZ2FjeSBzdXBwb3J0LCBidXQgZG9uJ3Qs
DQo+ID4gb3RoZXJ3aXNlLg0KPiA+IEBAIC0xMTYyLDExICsxMTY0LDk1IEBAIHN0YXRpYyB2b2lk
IF9faW5pdA0KPiA+IGdpY19vZl9zZXR1cF9rdm1faW5mbyhzdHJ1Y3QgZGV2aWNlX25vZGUgKm5v
ZGUpDQo+ID4gwqAJCWdpY192NV9rdm1faW5mby5ub19tYWludF9pcnFfbWFzayA9IHRydWU7DQo+
ID4gwqANCj4gPiDCoAl2Z2ljX3NldF9rdm1faW5mbygmZ2ljX3Y1X2t2bV9pbmZvKTsNCj4gPiAr
CXJldHVybjsNCj4gPiArDQo+ID4gK291dF9kaXNwb3NlX21haW50X2lycToNCj4gPiArCWlycV9k
aXNwb3NlX21hcHBpbmcobWFpbnRfaXJxKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIHZv
aWQgX19pbml0IGdpY19vZl9zZXR1cF9rdm1faW5mbyhzdHJ1Y3QgZGV2aWNlX25vZGUgKm5vZGUp
DQo+ID4gK3sNCj4gPiArCS8qIEdJQyBWaXJ0dWFsIENQVSBpbnRlcmZhY2UgbWFpbnRlbmFuY2Ug
aW50ZXJydXB0ICovDQo+ID4gKwlnaWNfc2V0dXBfa3ZtX2luZm8oaXJxX29mX3BhcnNlX2FuZF9t
YXAobm9kZSwgMCkpOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICsjaWZkZWYgQ09ORklHX0FDUEkNCj4g
PiArc3RydWN0IGdpY3Y1X2FjcGlfa3ZtX2luZm8gew0KPiA+ICsJdTMyIG1haW50X2lycTsNCj4g
PiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgZ2ljdjVfYWNwaV9rdm1faW5mbyBhY3Bp
X3Y1X2t2bV9pbmZvIF9faW5pdGRhdGE7DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IF9faW5pdCBn
aWNfYWNwaV9wYXJzZV92aXJ0X21hZHRfZ2ljYyh1bmlvbg0KPiA+IGFjcGlfc3VidGFibGVfaGVh
ZGVycyAqaGVhZGVyLA0KPiA+ICsJCQkJCQljb25zdCB1bnNpZ25lZA0KPiA+IGxvbmcgZW5kKQ0K
PiA+ICt7DQo+ID4gKwlzdHJ1Y3QgYWNwaV9tYWR0X2dlbmVyaWNfaW50ZXJydXB0ICpnaWNjID0N
Cj4gPiArCQkoc3RydWN0IGFjcGlfbWFkdF9nZW5lcmljX2ludGVycnVwdCAqKWhlYWRlcjsNCj4g
PiArCXN0YXRpYyBpbnQgZmlyc3RfbWFkdCA9IHRydWU7DQo+ID4gKw0KPiA+ICsJaWYgKCEoZ2lj
Yy0+ZmxhZ3MgJg0KPiA+ICsJwqDCoMKgwqDCoCAoQUNQSV9NQURUX0VOQUJMRUQgfA0KPiA+IEFD
UElfTUFEVF9HSUNDX09OTElORV9DQVBBQkxFKSkpDQo+ID4gKwkJcmV0dXJuIDA7DQo+IA0KPiBU
aGlzIHdvdWxkIGNvdW50IGFzIGEgdmFsaWQgcGFyc2VkIGVudHJ5IGV2ZW4gdGhvdWdoIHlvdSBk
b24ndA0KPiByZXRyaWV2ZSB0aGUNCj4gbWFpbnRhbmFuY2UgaW50ZXJydXB0IG51bWJlciwgbW9y
ZSBiZWxvdy4NCj4gDQo+ID4gKw0KPiA+ICsJaWYgKGdpY2MtPmZsYWdzICYgQUNQSV9NQURUX1ZH
SUNfSVJRX01PREUpDQo+ID4gKwkJcHJfd2Fybl9vbmNlKEZXX0JVRyAiTUkgd3JvbmdseSBhZHZl
cnRpc2VkIGFzDQo+ID4gRWRnZS10cmlnZ2VyZWRcbiIpOw0KPiA+ICsNCj4gPiArCWlmIChmaXJz
dF9tYWR0KSB7DQo+ID4gKwkJZmlyc3RfbWFkdCA9IGZhbHNlOw0KPiA+ICsNCj4gPiArCQlhY3Bp
X3Y1X2t2bV9pbmZvLm1haW50X2lycSA9IGdpY2MtPnZnaWNfaW50ZXJydXB0Ow0KPiA+ICsJCXJl
dHVybiAwOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWlmIChhY3BpX3Y1X2t2bV9pbmZvLm1haW50
X2lycSAhPSBnaWNjLT52Z2ljX2ludGVycnVwdCkNCj4gPiArCQlwcl93YXJuX29uY2UoRldfQlVH
ICJNSSBub3QgdGhlIHNhbWUgb24gYWxsDQo+ID4gQ1BVc1xuIik7DQo+ID4gKw0KPiA+ICsJcmV0
dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBib29sIF9faW5pdCBnaWNfYWNwaV9j
b2xsZWN0X3ZpcnRfaW5mbyh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlpbnQgY291bnQ7DQo+ID4gKw0K
PiA+ICsJY291bnQgPQ0KPiA+IGFjcGlfdGFibGVfcGFyc2VfbWFkdChBQ1BJX01BRFRfVFlQRV9H
RU5FUklDX0lOVEVSUlVQVCwNCj4gPiArCQkJCcKgwqDCoMKgwqANCj4gPiBnaWNfYWNwaV9wYXJz
ZV92aXJ0X21hZHRfZ2ljYywgMCk7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIGNvdW50ID4gMDsNCj4g
PiDCoH0NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIF9faW5pdCBnaWNfYWNwaV9zZXR1cF9rdm1f
aW5mbyh2b2lkKQ0KPiA+ICt7DQo+ID4gKwl1bnNpZ25lZCBpbnQgbWFpbnRfaXJxID0gMDsNCj4g
PiArCWludCBpcnE7DQo+ID4gKw0KPiA+ICsJaWYgKCFnaWNfYWNwaV9jb2xsZWN0X3ZpcnRfaW5m
bygpKSB7DQo+ID4gKwkJcHJfd2FybigiVW5hYmxlIHRvIGdldCBoYXJkd2FyZSBpbmZvcm1hdGlv
biB1c2VkDQo+ID4gZm9yIHZpcnR1YWxpemF0aW9uXG4iKTsNCj4gPiArCQlyZXR1cm47DQo+ID4g
Kwl9DQo+IA0KPiBOaXQ6IGdpY19hY3BpX2NvbGxlY3RfdmlydF9pbmZvKCkgbWlnaHQgcmV0dXJu
IHRydWUgYW5kIHlvdSBzdGlsbA0KPiBkb24ndCBnZXQNCj4gdGhlIGluZm8geW91IG5lZWQuIE5v
dywgYXQgbGVhc3Qgb25lIEdJQ0MgZW50cnkgc2hvdWxkIGJlIGVuYWJsZWQgYW5kDQo+IG9ubGlu
ZQ0KPiBjYXBhYmxlICh3ZSBhcmUgYm9vdGluZyBvbiBhIGNvcmUgYWZ0ZXIgYWxsIGJ1dCBuZXZl
ciBvdmVyZXN0aW1hdGUNCj4gQUNQSSB0YWJsZXMgOikpDQo+IHNvIHRoaXMgaXMgdGhlb3J5IGJ1
dCBJIHRob3VnaHQgSSB3b3VsZCBtZW50aW9uIGl0Lg0KDQpJJ3ZlIGFkZGVkIGFuIGV4cGxpY2l0
IHZhbGlkIGZsYWcsIHdoaWNoIGlzIHNldCB0cnVlIHdoZW4gYW4gZW5hYmxlZA0KKG9yIG9ubGlu
ZV9jYXBhYmxlKSBHSUNDIGVudHJ5IGlzIGFjdHVhbGx5IHByb2Nlc3NlZC4gSSd2ZSBtYWRlDQpn
aWNfYWNwaV9jb2xsZWN0X3ZpcnRfaW5mbygpIHJldHVybiB0aGF0IGZsYWcgZGlyZWN0bHkgc28g
bm93IGENCmRpc2FibGVkIGVudHJ5IGNhbid0IGZhbHNlbHkgcmV0dXJuIHN1Y2Nlc3MuDQoNCj4g
DQo+ID4gKw0KPiA+ICsJaWYgKGFjcGlfdjVfa3ZtX2luZm8ubWFpbnRfaXJxKSB7DQo+ID4gKwkJ
aXJxID0gYWNwaV9yZWdpc3Rlcl9nc2koTlVMTCwNCj4gPiBhY3BpX3Y1X2t2bV9pbmZvLm1haW50
X2lycSwNCj4gPiArCQkJCQlBQ1BJX0xFVkVMX1NFTlNJVElWRSwNCj4gPiArCQkJCQlBQ1BJX0FD
VElWRV9ISUdIKTsNCj4gPiArCQlpZiAoaXJxID4gMCkNCj4gPiArCQkJbWFpbnRfaXJxID0gaXJx
Ow0KPiA+ICsJCWVsc2UNCj4gPiArCQkJcHJfd2FybigiRmFpbGVkIHRvIHJlZ2lzdGVyIEdTSSBm
b3IgR0lDdjUNCj4gPiBtYWludGVuYW5jZSBJUlFcbiIpOw0KPiANCj4gQW5vdGhlciBuaXQ6IGRv
IHdlIHJlYWxseSBuZWVkIHRoZSBtYWludF9pcnEgdmFyaWFibGUgPw0KDQpObywgSSd2ZSByZW1v
dmVkIGl0Lg0KDQo+IA0KPiBUaGFua3MsDQo+IExvcmVuem8NCg0KVGhhbmtzLA0KU2FzY2hhDQoN
Cj4gDQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJZ2ljX3NldHVwX2t2bV9pbmZvKG1haW50X2lycSk7
DQo+ID4gK30NCj4gPiArI2VuZGlmIC8vIENPTkZJR19BQ1BJDQo+ID4gwqAjZWxzZQ0KPiA+IMKg
c3RhdGljIGlubGluZSB2b2lkIF9faW5pdCBnaWNfb2Zfc2V0dXBfa3ZtX2luZm8oc3RydWN0IGRl
dmljZV9ub2RlDQo+ID4gKm5vZGUpDQo+ID4gwqB7DQo+ID4gwqB9DQo+ID4gKw0KPiA+ICsjaWZk
ZWYgQ09ORklHX0FDUEkNCj4gPiArc3RhdGljIGlubGluZSB2b2lkIF9faW5pdCBnaWNfYWNwaV9z
ZXR1cF9rdm1faW5mbyh2b2lkKQ0KPiA+ICt7DQo+ID4gK30NCj4gPiArI2VuZGlmDQo+ID4gwqAj
ZW5kaWYgLy8gQ09ORklHX0tWTQ0KPiA+IMKgDQo+ID4gwqBzdGF0aWMgaW50IF9faW5pdCBnaWN2
NV9pbml0X2NvbW1vbihzdHJ1Y3QgZndub2RlX2hhbmRsZQ0KPiA+ICpwYXJlbnRfZG9tYWluKQ0K
PiA+IEBAIC0xMjY1LDYgKzEzNTEsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBnaWNfYWNwaV9pbml0
KHVuaW9uDQo+ID4gYWNwaV9zdWJ0YWJsZV9oZWFkZXJzICpoZWFkZXIsIGNvbnN0IHVuc2lnDQo+
ID4gwqAJCWdvdG8gb3V0X2lyczsNCj4gPiDCoA0KPiA+IMKgCWFjcGlfc2V0X2lycV9tb2RlbChB
Q1BJX0lSUV9NT0RFTF9HSUNfVjUsDQo+ID4gZ2ljX3Y1X2dldF9nc2lfZG9tYWluX2lkKTsNCj4g
PiArCWdpY19hY3BpX3NldHVwX2t2bV9pbmZvKCk7DQo+ID4gwqANCj4gPiDCoAlyZXR1cm4gMDsN
Cj4gPiDCoA0KPiA+IC0tIA0KPiA+IDIuMzQuMQ0KDQo=
