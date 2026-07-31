Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011069.outbound.protection.outlook.com [52.101.70.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F46531F9B4
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.69
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785482766; cv=fail; b=NLzbClVNu65bEXAq5wdqpjn7vdkBnq2CZiyhQ9Dgg5tiJp9lmWBPQUzLudpvWOaQnQT0gVAlDX8fAghhmvtaK5sCZFtnpTSnNLqa8eK0rrKJRW/Fgv0stFTfNK7l6VWd4WeKBUTFNGNbb05D01FpP+dEP7ylQpzNXlcqkeALWa8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785482766; c=relaxed/simple;
	bh=t1a+xmdkNgMIBIrdQp0Zhr4WEivIsSZj6ExiFfbamYo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VoQk+9MgSzbtjy1DnJqT0rPlqfSnj0KrO6RuWcDLXDx1NyQmUOBs36A4771V1nzYcheL8YfHeXF3MS4GTDvRXldFz6g36a+09pOmOiAxlz6VkP9mqBoiXVN6jxrWiBzkQXZl+iZ4alIrQo74ELgRNMts7nR9sqlPlmNZKZ1TOwM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=II20xgmW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=II20xgmW; arc=fail smtp.client-ip=52.101.70.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="II20xgmW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="II20xgmW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NBc3u8bOPnV8nIV7pDT9nyPl3QHFppFp+9Klbf63B8GbsQsffNTXUUC5baJ8WBewyPmn0xFQMVSwX754WnWehtfnugiboekcqUwgerjsewBgkVyhBx6s2acKWbDQNOChFFGe7OMVX9jo7fg6Tv5//+i3TRFDEWMO0oQH2pfCUuRGbNRgqwb/ITHmCPYk1K4jDfyQRwVhEmVJI/9SwGPYZHNSxh43tPM+Vnok0AE6Ij6POPClzy8Pi2jweflp8NhgEeUTs8etlBGl4O3nArpZxhkNWVLDqBSHiIk9N4isnK4KWmraJbALWlYGlAA1BsllmoGDXN+m195b8eQ0FRQMBg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1a+xmdkNgMIBIrdQp0Zhr4WEivIsSZj6ExiFfbamYo=;
 b=ZLEt3O7eN+LkB/KE0BV3kG+8uEonCjTdaf2T0jiuBotfr2lqmc8Ot6MI9zapIDH0mehZryvpnBdO/r9gRll3BgLd4Lrwmobw0KpVu+X9rJnpj4UPYtpuSB4DTsshM9oms2S0dIqLMu1wiUQIX+CNUxCpO1wKtSCXPmBXQ1kvAzYHX81xPp2rsq134kGmE1DQitpIwrY8sdanfeXFKJ5KjMfnT4UEYmMV0oQALZy1HJn2ylCcEqxFmiKxHiEGhHEU9n3vdykZPgkTUbjQqqJ4RnTwe/poQEPhpeJRVkNYa7ipadl4ypQG2Xv8iUQqlC8fDjVSJM6cpFkhee5VklvvTA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1a+xmdkNgMIBIrdQp0Zhr4WEivIsSZj6ExiFfbamYo=;
 b=II20xgmWsSXZORWzs2cECIkGRV5Nm5S4Heq9SSwxAvE0x2+V0JPekVEbEfCk+C6ppQnruXPtvD3WJtB8VhKIIHIQLz7VpGIKxlnwKADo4gBVMLNeTsWQunVnoMeyaw5Qi/56vaTrlgNSIT1xph0xIaew64BEtwQrixNzjqj6zns=
Received: from AS9PR07CA0003.eurprd07.prod.outlook.com (2603:10a6:20b:46c::16)
 by DU0PR08MB8162.eurprd08.prod.outlook.com (2603:10a6:10:3ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 07:25:57 +0000
Received: from AMS1EPF00000048.eurprd04.prod.outlook.com
 (2603:10a6:20b:46c:cafe::32) by AS9PR07CA0003.outlook.office365.com
 (2603:10a6:20b:46c::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8 via Frontend Transport; Fri, 31
 Jul 2026 07:25:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000048.mail.protection.outlook.com (10.167.16.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 07:25:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I0VPH2aC5EEnddlyLBJ7JeA2FJG/w17T/2jIJxNMNbbzBG3vtsNpARQg4wLnohJt+cyUpiFQ8sZOUCWdoGpfgAER0rMhJ2lz4zpUlDBsNPGFcqxxlpgSWrPCA0J750Si1mdVxYQFlzz6Xcpm5ufMMC2Pc20FWOfyRVZVqRlnM7PkkTD0k1CKqgFwWU/kAm/Uueeo4GFeJtSSCL90f4sfrLwO1tTVKROsBbPKZrgOADko3Bb/MxNJLeBHm/QvC8S9nYhYr7vMNRnFhi3wAanDVhKTTsrYYMjhIKAv+kEme2ASDMw6c+0wCmCUWDvHErN47X80Q5inQR8VgzL30SqaZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1a+xmdkNgMIBIrdQp0Zhr4WEivIsSZj6ExiFfbamYo=;
 b=CO8SBf6l7uBaecabjOXlXcyDBbvkrC8TI9IS+z6AhM31CiY492qaU3DSWMwmVfCiqoxUFfIxGMuQP0uo3EZrNbbcB4P4HZLhcyH4bTkA88CV+/ANrC35LcrmbkFIv6lbB0qBiQVZsFRe6KD6X7NumrVZTbzA4QXAccT/Q1galeYu6nxhb2R93xV+cBzdkVDwadEZdj5uD1zPw1pDlF32U9EjpGPHg3BFIkhrMRq8J/Yr5gBmr5ZUJQ05ki6p9rzk52BYCEfNFLMUpDQxOtiEHQy3/mDvg9zI0EteMMdweeI9f/U0QDdHXQX5m55enJJDWMUyB0OtGVyZvnR4xQ/GWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1a+xmdkNgMIBIrdQp0Zhr4WEivIsSZj6ExiFfbamYo=;
 b=II20xgmWsSXZORWzs2cECIkGRV5Nm5S4Heq9SSwxAvE0x2+V0JPekVEbEfCk+C6ppQnruXPtvD3WJtB8VhKIIHIQLz7VpGIKxlnwKADo4gBVMLNeTsWQunVnoMeyaw5Qi/56vaTrlgNSIT1xph0xIaew64BEtwQrixNzjqj6zns=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by VI0PR08MB11267.eurprd08.prod.outlook.com (2603:10a6:800:31e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 07:24:52 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 07:24:52 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v4 07/48] KVM: arm64: gic-v5: Extract host IRS caps from
 IRS config frame
Thread-Topic: [PATCH v4 07/48] KVM: arm64: gic-v5: Extract host IRS caps from
 IRS config frame
Thread-Index: AQHdG1o0qOow5djU00KduraRpDffM7Z+DTMAgAk3coA=
Date: Fri, 31 Jul 2026 07:24:52 +0000
Message-ID: <e5b9e1ace51c0a266601e8ceb5d7e40f6a145d21.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-8-sascha.bischoff@arm.com>
	 <87zezfpd2z.wl-maz@kernel.org>
In-Reply-To: <87zezfpd2z.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|VI0PR08MB11267:EE_|AMS1EPF00000048:EE_|DU0PR08MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: 7909e406-7ef6-4c45-0aa3-08deeed4f6a2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|4143699003|38070700021|10067099003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 4LebyFvps5ji7YBkTiA2I1r7h+8KNuF19w6PuVzXKA/gPER3NwoEKXzMiujQvTWnnYLS2qTbSulfQpMjNLyeB2HV+3egqnXu0F4LcktsSqSLAmwO6KSv2h/amc8nmzOju60XwJIDmGtp5kyvFY3KqVbSKr54Z45ChD99v9UlB5pwG6DeBQwCb50e1sz5o5T/jbDC8PNWjzoPJwc04+0xe8rZhUSh8Czh+tXwPu7izWF8rvt5l8yFTWQU2Aaxqq+Tax1RIzBPs8QSNlTR/wM/pNlqgg6NiBd5Cu1YK+uZnyEaXAYkx2CjYL//8Tzn0eOaUUjHTpRwgSOZ0pv2M8iRETBxO7y5Kolm96oY8A2nFiofdZu/f7fM9N6X2KnnXJfrKeun0VI2tevmB6rxYbKWqISEw0ku+XDjOlqSlKMzwhZQR09D3ABGJyO9bADCbJ5uanGXe6dmhzcTqcdHWKQ6S8Pl//pjD/FgzijnbpgI8jjte3DWjfzrKUSJkJg7Vn91yHy7I2SVVFlNcqpowN4ZsDrPj45eharT4nyWD/C2T44f3eZf9Y8RFgYkhkAX6aUAYA7a9eFNGERJV/YfMC9iX6mfdYaWA/7EJhGMSqbsBR0ZmgNxaQIWulD8NCCV64m57JgOjOydvehGpXSYKUlq6vMzAiIJVr14MXri74gp4KBA1CY7Y9YBa0ZzNVWJ/463D1JkAXjJN2DPwC+CtDaQU4yIUVYeX/tKbraYEevWZYY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(4143699003)(38070700021)(10067099003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E218BFF277A1C4F9C61B7C5AF45F9A3@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MW2UUmPHQ89I6ijwXSwjUYQET/Ecb8tYV4e62pg3VHC5iqWCrYpNl6Z03S3LBUWmH8QjIRxMjEbRxWSbkVa4Zxcnwlt9AZr4ELQKrHglm894mOkThEMwosWA76q+2IZKMKkVs2yk1Ql0CmScTQfoKhLPg0oK1kw5C1f8KygmgYcVwxqoQlHicpg9L+hGaAaK5DLiRWmHYkkhX/VQZpqs+K/gDtWuoN+sW3r4/UG3niFxPBVa33O1LiVjBbProar2cwc9w2EEyts5KuQ1jo9LEJRk9b725ISvdRbH83NRtRHCA4KFlqb8DVk2/jH5lliSa3rqsMKW55XU7T+QTltyPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11267
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8ca02547-2d99-4bd7-89ab-08deeed4cff1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|376014|82310400026|14060799003|35042699022|6133799003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7mkKhZDQsEDnek/kcuNniqG0NK/aRwMmqIqU2QJt4uwCcE9motM9jA8/uUr8uKese/qPdOvv1UcQtpTWaxrMCtPgBzHIIcSKc+rM2ioR/J8Znqm7b5+c0EU5q83GnahkyMxIVqlhpi3pbyuiwMqHzu0HLu2zy+1CqfCCmLflPi1l8O05t1RaI9C5L4gOa5v+hUfRpDE3rPvdfy3/YId/dz/xNWHq/eqkldl8nPbFqkiJkzxZD5m/ugF/iPJFAB1l+ikNcwwjLplk0UP8Ol0JULKQWqWLveR3GYJU+VloRAvftsnC3GfHBzWEDkCPGqK3VP4Ulc3bf8NSWTx6LMmSKp2ZhkQj9b0ADiF3bArVSFtYUWw66DIq4aeEgyp3W+N0FoqukeooxgLLuuqFIaemZhAg/8PAAeAJzDYtu2N8t4U6a40zigxKIELAGXYZiB1PDbSoCEgg3Eda3UUaktgc1xgmrS0opDzJlM/w7jXVZZxzNGww02Zo5vAvOHQuTnq2UUAiqVszNPrXwYzqVB1gO/bSu+Qi2pf1LknLoTW+f7T/9AMURBCgC3dD91LwDW2Snr3w/441fVYbyXWRF02hmLlHT3qaMMwh3dIMLKvY767vvk8SGmtBUw1YsIG963L6zRRJ5ypbti1RLLYBnXwyzKo+RZ9X1+r3y3FHIhxdWofNM2CLOWi40sdaUogsnox2B7PBgcWTnYTeiLzvArXudw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(376014)(82310400026)(14060799003)(35042699022)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dYHDA2nnFXsE/2Vus+4WsWLtDJM2haHOM7I84lmwa2z4ZECJFQt0iCVowNe8U+XZXNc/5JIBQt8xERT82XnZypF2EWRJv08pEMWfUd125VRhFC5z6wgDohxd4m0h26O0cZqr3fXUyiE37D+itc7Lug6Wn1zm7zhIG+bBod1dvh+bp1bJsIoUroIgkndx7e1gemA88pucm/5pLcBuZ8EXO7G52mcOvPbOkst4QB3RGZSyM/gXdOfpbdTtfyRoCKXbNtPg1YT8144+myX7w6Al9OLtun83G//OUMia3o95TB6BWNr1NJS5NxK99NOW25hFLkm1GrlpxN4XZuebz8DKYIbSdSg8p4mFuCmyNmi9c/4KgpfiauM/lpJb4wvbbfE27EMzZXDTfTZkCKCyytfnlljkRP7Zeh2w4k5Zug06y77xG34fbzjrep44PXOWAhyv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 07:25:57.0401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7909e406-7ef6-4c45-0aa3-08deeed4f6a2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8162

T24gU2F0LCAyMDI2LTA3LTI1IGF0IDExOjQwICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMjQgSnVsIDIwMjYgMTE6NTA6MTMgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFRoZSBob3N0IGlycWNo
aXAgZHJpdmVyIHByb3ZpZGVzIEtWTSB3aXRoIGEgcG9pbnRlciB0byBhbiBJUlMncw0KPiA+IGNv
bmZpZw0KPiA+IGZyYW1lLCB3aGljaCBhbGxvd3MgS1ZNIHRvIGRpcmVjdGx5IGludGVyYWN0IHdp
dGggdGhlIGhvc3QncyBJUlMuDQo+ID4gVGhlDQo+ID4gTU1JTyByZWdpc3RlcnMgaW4gdGhlIGNv
bmZpZyBmcmFtZSBhcmUgdXNlZCB0byBjb25maWd1cmUgVk1zIChpbg0KPiA+IGFkZGl0aW9uIHRv
IHRoZW0gYmVpbmcgdXNlZCBieSB0aGUgaG9zdCkuIFRoZSBJUlMncyBjb25maWcgZnJhbWUNCj4g
PiBhbHNvDQo+ID4gaW5jbHVkZXMgYSBzZXQgb2YgSUQgcmVnaXN0ZXJzIHdoaWNoIGRlc2NyaWJl
IHRoZSBjYXBhYmlsaXRpZXMgdGhhdA0KPiA+IHRoZSBJUlMgaGFzLg0KPiA+IA0KPiA+IFN0YXNo
IHRoZSBwb2ludGVyIHRvIHRoZSBjb25maWcgZnJhbWUsIGFuZCBleHRyYWN0IHRoZSBWTQ0KPiA+
IGNhcGFiaWxpdGllcw0KPiA+IChmcm9tIElSU19JRFIzICYgSVJTX0lEUjQpLCBhcyB3ZWxsIGFz
IHRoZSBJU1QNCj4gPiBjYXBhYmlsaXRpZXMvcmVxdWlyZW1lbnRzIChJUlNfSURSMikgZnJvbSB0
aGUgSVJTLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hh
LmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtdjUuYyB8IDQ2DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4g
PiDCoGluY2x1ZGUva3ZtL2FybV92Z2ljLmjCoMKgwqDCoMKgwqDCoCB8IDI2ICsrKysrKysrKysr
KysrKysrKysrDQo+ID4gwqAyIGZpbGVzIGNoYW5nZWQsIDcwIGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IGluZGV4IGQ0
Nzg5ZmYzZTc0MDIuLjNmN2IxMzIxMTAxMTQgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY1LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUu
Yw0KPiA+IEBAIC0xMSw2ICsxMSw3IEBADQo+ID4gwqAjaW5jbHVkZSAidmdpYy5oIg0KPiA+IMKg
DQo+ID4gwqAjZGVmaW5lIHBwaV9jYXBzCWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS52Z2ljX3Y1X3Bw
aV9jYXBzDQo+ID4gKyNkZWZpbmUgaXJzX2NhcHMJa3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLnZnaWNf
djVfaXJzX2NhcHMNCj4gPiDCoA0KPiA+IMKgLyoNCj4gPiDCoCAqIE5vdCBhbGwgUFBJcyBhcmUg
Z3VhcmFudGVlZCB0byBiZSBpbXBsZW1lbnRlZCBmb3IgR0lDdjUuDQo+ID4gRGV0ZXJlcm1pbmUg
d2hpY2gNCj4gPiBAQCAtMzQsNiArMzUsNDUgQEAgc3RhdGljIHZvaWQgdmdpY192NV9nZXRfaW1w
bGVtZW50ZWRfcHBpcyh2b2lkKQ0KPiA+IMKgCV9fYXNzaWduX2JpdChHSUNWNV9BUkNIX1BQSV9Q
TVVJUlEsDQo+ID4gcHBpX2NhcHMuaW1wbF9wcGlfbWFzaywgc3lzdGVtX3N1cHBvcnRzX3BtdXYz
KCkpOw0KPiA+IMKgfQ0KPiA+IMKgDQo+ID4gK3N0YXRpYyB1MzIgaXJzX3JlYWRsX3JlbGF4ZWQo
Y29uc3QgdTMyIHJlZ19vZmZzZXQpDQo+ID4gK3sNCj4gPiArCXJldHVybiByZWFkbF9yZWxheGVk
KGlyc19jYXBzLmlyc19iYXNlICsgcmVnX29mZnNldCk7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0
YXRpYyB2b2lkIHZnaWNfdjVfaXJzX2V4dHJhY3Rfdm1fY2Fwcyhjb25zdCBzdHJ1Y3QgZ2ljX2t2
bV9pbmZvDQo+ID4gKmluZm8pDQo+ID4gK3sNCj4gPiArCXU2NCBpZHI7DQo+ID4gKw0KPiA+ICsJ
aXJzX2NhcHMuaXJzX2Jhc2UgPSBpbmZvLT5naWN2NV9pcnMuYmFzZTsNCj4gPiArCWlyc19jYXBz
Lm5vbl9jb2hlcmVudCA9IGluZm8tPmdpY3Y1X2lycy5ub25fY29oZXJlbnQ7DQo+ID4gKw0KPiA+
ICsJaWRyID0gaXJzX3JlYWRsX3JlbGF4ZWQoR0lDVjVfSVJTX0lEUjIpOw0KPiA+ICsNCj4gPiAr
CS8qIFdlIHNraXAgdGhlIExQSSBmaWVsZCBhcyBpdCBvbmx5IGFwcGxpZXMgdG8gcGh5c2ljYWwN
Cj4gPiBMUElzICovDQo+ID4gKwlpcnNfY2Fwcy5pc3RfaWRfYml0cyA9IEZJRUxEX0dFVChHSUNW
NV9JUlNfSURSMl9JRF9CSVRTLA0KPiA+IGlkcik7DQo+ID4gKwlpcnNfY2Fwcy5taW5fbHBpX2lk
X2JpdHMgPQ0KPiA+IEZJRUxEX0dFVChHSUNWNV9JUlNfSURSMl9NSU5fTFBJX0lEX0JJVFMsIGlk
cik7DQo+ID4gKwlpcnNfY2Fwcy5pc3RfbGV2ZWxzID0gKGlkciAmIEdJQ1Y1X0lSU19JRFIyX0lT
VF9MRVZFTFMpOw0KPiA+ICsJaXJzX2NhcHMuaXN0X2wyc3ogPSBGSUVMRF9HRVQoR0lDVjVfSVJT
X0lEUjJfSVNUX0wyU1osDQo+ID4gaWRyKTsNCj4gPiArCWlyc19jYXBzLmlzdG1kID0gKGlkciAm
IEdJQ1Y1X0lSU19JRFIyX0lTVE1EKTsNCj4gPiArCWlyc19jYXBzLmlzdG1kX3N6ID0gRklFTERf
R0VUKEdJQ1Y1X0lSU19JRFIyX0lTVE1EX1NaLA0KPiA+IGlkcik7DQo+ID4gKw0KPiA+ICsJaWRy
ID0gaXJzX3JlYWRsX3JlbGF4ZWQoR0lDVjVfSVJTX0lEUjMpOw0KPiA+ICsNCj4gPiArCWlyc19j
YXBzLm1heF92bXMgPQ0KPiA+IEJJVChGSUVMRF9HRVQoR0lDVjVfSVJTX0lEUjNfVk1fSURfQklU
UywgaWRyKSk7DQo+ID4gKwlpcnNfY2Fwcy50d29fbGV2ZWxfdm10X3N1cHBvcnQgPSAoaWRyICYN
Cj4gPiBHSUNWNV9JUlNfSURSM19WTVRfTEVWRUxTKTsNCj4gPiArDQo+ID4gKwlpZiAoaWRyICYg
R0lDVjVfSVJTX0lEUjNfVk1EKQ0KPiA+ICsJCWlyc19jYXBzLnZtZF9zaXplID0NCj4gPiBCSVQo
RklFTERfR0VUKEdJQ1Y1X0lSU19JRFIzX1ZNRF9TWiwgaWRyKSk7DQo+ID4gKwllbHNlDQo+ID4g
KwkJaXJzX2NhcHMudm1kX3NpemUgPSAwOw0KPiA+ICsNCj4gPiArCWlkciA9IGlyc19yZWFkbF9y
ZWxheGVkKEdJQ1Y1X0lSU19JRFI0KTsNCj4gPiArDQo+ID4gKwlpcnNfY2Fwcy52cGVkX3NpemUg
PSBCSVQoRklFTERfR0VUKEdJQ1Y1X0lSU19JRFI0X1ZQRURfU1osDQo+ID4gaWRyKSk7DQo+ID4g
KwkvKiBGaWVsZCBzdG9yZXMgVlBFX0lEX0JJVFMgLSAxICovDQo+ID4gKwlpcnNfY2Fwcy5tYXhf
dnBlcyA9DQo+ID4gQklUKEZJRUxEX0dFVChHSUNWNV9JUlNfSURSNF9WUEVfSURfQklUUywgaWRy
KSArIDEpOw0KPiANCj4gTm90IGEgYmlnIGRlYWwsIGJ1dCBJJ20gYSBiaXQgb3ZlciB0aGlzIHNw
bGl0IG9mIElEIHJlZ3MgaW4NCj4gaW5kaXZpZHVhbA0KPiBmaWVsZHMuIEl0IGxvb2tzIGFwcGVh
bGluZyBhdCBmaXJzdCwgYnV0IGVuZHMtdXAgYmVpbmcgcHJvYmxlbWF0aWMuDQo+IA0KPiBUaGUg
cmVhc29uIGZvciB0aGlzIGlzIHRoYXQgRUwyIGRvZXNuJ3QgbWFwIGt2bV92Z2ljX2dsb2JhbF9z
dGF0ZSwNCj4gd2hpY2ggd2lsbCBldmVudHVhbGx5IGZvcmNlIHBLVk0gdG8gZWl0aGVyIGR1cGxp
Y2F0ZSB0aGUgc3RydWN0dXJlLA0KPiBvcg0KPiBhY2Nlc3MgdGhlIElEIHJlZyBkaXJlY3RseSAo
dGhlIGxhdHRlciByZXN1bHRpbmcgaW4gdHJhcHMgdW5kZXIgTlYpLg0KPiANCj4gTXkgcHJlZmVy
ZW5jZSB3b3VsZCBiZSB0byBvbmx5IGNhY2hlIHRoZSByYXcgSUQgcmVnIHZhbHVlcywgYW5kIGhh
dmUNCj4gaW5saW5lIGFjY2Vzc29ycyBmb3IgdGhlIGluZGl2aWR1YWwgZmllbGRzLiBPbmNlIHRo
aXMgaXMgaW4gcGxhY2UsIHdlDQo+IGNhbiBwYXRjaCB0aGUgSUQgcmVnIHZhbHVlcyBpbiB0aGUg
Y29kZSBkaXJlY3RseSwgSUNIX1ZUUl9FTDItc3R5bGUuDQoNCkdpdmVuIHRoYXQgSSBuZWVkIHRv
IHBvc3QgYSB2NSBpbiBlaXRoZXIgY2FzZSwgSSd2ZSBnb25lIGFoZWFkIGFuZCBtYWRlDQp0aGlz
IGNoYW5nZS4gV2Ugbm93IGNhY2hlIHRoZSB2YWx1ZXMgb2YgSURSMi8zLzQgaW4NCmt2bV92Z2lj
X2dsb2JhbF9zdGF0ZSBhbmQgaGF2ZSBhIHNldCBvZiBoZWxwZXJzIHRvIGV4dHJhY3QgdGhlaXIg
dmFsdWVzDQphdCB0aGUgcG9pbnRzIHdoZXJlIHdlIG5lZWQgdGhlbS4NCg0KPiANCj4gQW55d2F5
LCBzb21ldGhpbmcgdG8gdGhpbmsgYWJvdXQuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiAJTS4NCj4g
DQpUaGFua3MsDQpTYXNjaGENCg==
