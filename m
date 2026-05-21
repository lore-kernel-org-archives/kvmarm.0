Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011064.outbound.protection.outlook.com [52.101.70.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDE03F54AE
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779372798; cv=fail; b=Rxk+i8zp4rdxG2GkEAPVNYDMQgVFgQdJBy9evQPFU92VrL5OoGTXM4LjvIl1JJUsTWto08hpm04Xie6qMMSm/Oi2ahW4U3nhb4/7HioWEm4zy/OeQ/Fs2DXB7zxf6dc6adnMBKZPyIZBEhEbxk/JrSlX9g6vZq1ADOOJBZe1Nlg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779372798; c=relaxed/simple;
	bh=Ag35GShp9ghnMvcMW/B4vvmlLOuBrUDGwFhUfLZfjpI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RMFZ4BLZuI8nk17jnMhHrvqlq+KIFeN0CBCX2BpnFOk1+0PEiQv9JSAk3GgUPNnRLgJR498k3Wdjn2lH/i1vJOJGL5tqQxEbWq+/b1lF6C+DQ414Pz8wc55BGOZGoliIE6KyQKcPui3WKF2siGtFeD1LzFPq05q35G3nTq4B3mA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EF70ItsL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EF70ItsL; arc=fail smtp.client-ip=52.101.70.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EF70ItsL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EF70ItsL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=vHLN6r6gMYm79f5OP1cZIZGJej/H1YenYGk3541+cwDEyTdHZVXAvVwwo+yFcnmDGe/eowiMTs91m1R0kEVs539jWzVezhf1wJ5aOzsfpspBCJvPRZyOQgEy6d6GbALYInFA/ejR+j45528ZOsFdxKvvOvcAlNx7/kd07QHOq26gNribOW61FUUfP8Viy1XyToN9DpyA7MhmVY7rKSluFl0qdQXVt3f85/p4aD7ZDWe3DJIL3OlmKfTtsmQW/e+sSH46NGwwinBkJeS52W2IYcshu2bEYranWZRNnRbgr+4c8L2Jxqi5aYqU283hnmJapocChlpbf+b77k8y35Fi/g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ag35GShp9ghnMvcMW/B4vvmlLOuBrUDGwFhUfLZfjpI=;
 b=gzJtDci7LSKcCc9UqVX5Ks3jKLtEckMb108cz4D+lJ+CkgrV6vY8sOO++I2qcp0U27mJxRuTGG0o6O6jRn2oOvR/xNt/y1RyGTQNDR4K1d7mzH8d5WghPwzHVa6lPZdoXIpIGNVqKePC1q2o57txe6chYZNofwOUrNtNsurqVSk/9t/pFft2g8A/4EEM8MTFM6kxE/+R4NEQdXmtNYFEVvU0oASjWL9+zW8fXY1skUHBMlSMtnxOgIF2GAXSvJMXUD7EZN2BbXAIbyspPUjX5OGUMQ+8lw1JDLrz3OEOahNuYBPz9x78BfeMsnU7i3E4LIjqFG7o2c2qW0zQhJ3XWg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ag35GShp9ghnMvcMW/B4vvmlLOuBrUDGwFhUfLZfjpI=;
 b=EF70ItsLybg8BRyH7GnI6Ax/c5j8Dof8Hd4f9oromwuEHF9H7a+qFdaxT74bNyLmubIOuuWzGKJG4l52hsHiS8jEWWzxOhN6XMqx7dWpeJzq3fPhDv/Sd6bmwyjM0VMUgXNLl7x9vKo7V4QQhs3tIdWTo5oveXZQvI0OkoS7gic=
Received: from CWLP123CA0268.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1d5::14)
 by AS2PR08MB10295.eurprd08.prod.outlook.com (2603:10a6:20b:647::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.22; Thu, 21 May
 2026 14:13:13 +0000
Received: from AM3PEPF00009B9B.eurprd04.prod.outlook.com
 (2603:10a6:400:1d5:cafe::4) by CWLP123CA0268.outlook.office365.com
 (2603:10a6:400:1d5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:13:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9B.mail.protection.outlook.com (10.167.16.20) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:13:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsT7u5zt9gWlpIg6GE6bw/arf/nMpQhloIywsNy1jxjdpPEt4os3qY/eyNWYBW8qiQOZXg8ictQcR15mSLKMiH110pDR3hJhyZw5qbB+eV/NZC34NozPT8q0rmBtIVbwPnf95flxhyJLaH5jEB8fI/60siUiQwxMPf0mKutJ6WjvS9eLemp6heee5T2F5rW8zjuINPBi155dcfPPtRGNGELeVkbWxnlkxyzaKY0Ouc9+UHaNbHkSdN8pCBJAXM6/3oFhkCxKclOBZT+2oBrJoWscKs7RWOy1NSPW0VJFLDMMbcE+OIJIaAaQ1Zss3xswNX4F1EXxLOSgS/SIrTUr5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ag35GShp9ghnMvcMW/B4vvmlLOuBrUDGwFhUfLZfjpI=;
 b=MguRKhPClvGvlMoCDvP8rI4NL5BixLxDphhtivQ5NMqx3tZi1fzw4fAUw8LLdGHlCmEr9Yd472iLD50np3+m//OYA8Z7ZqXDNPPyBLz3ceVprT9gAh9Gm7Tdzgjqyd7O4gEATakVjXGBeyQL1hGWEUOPBId3/MwDf9pEUEQ5hBzw3iJRugBzsgOYdg9N7rWb5A4kUjFu88EHm5OmsVkTa10c1fvThi1aXq/S55+Cu2zDH7cGhU1iRdsVnQPSXs+tvssAe+FpRcAGYX18iFIfEfnOli8spPeo1VJQyoElHjNXsOpIMB/z4hHhCc7LtS8F9adLRxAZ5ZyEG0bNNiWN2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ag35GShp9ghnMvcMW/B4vvmlLOuBrUDGwFhUfLZfjpI=;
 b=EF70ItsLybg8BRyH7GnI6Ax/c5j8Dof8Hd4f9oromwuEHF9H7a+qFdaxT74bNyLmubIOuuWzGKJG4l52hsHiS8jEWWzxOhN6XMqx7dWpeJzq3fPhDv/Sd6bmwyjM0VMUgXNLl7x9vKo7V4QQhs3tIdWTo5oveXZQvI0OkoS7gic=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by AM9PR08MB6068.eurprd08.prod.outlook.com (2603:10a6:20b:2dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:12:10 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:12:10 +0000
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
Subject: Re: [PATCH 36/43] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Topic: [PATCH 36/43] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Index: AQHc1mF2IJ7eOwIpNE6S7FNigW8wBrX5iziAgB8fpIA=
Date: Thu, 21 May 2026 14:12:10 +0000
Message-ID: <f388ca09b304fd283211136837154f457a49ebfe.camel@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
	 <20260427160547.3129448-37-sascha.bischoff@arm.com>
	 <187900ec-4585-42d9-946c-e6de3111552d@arm.com>
In-Reply-To: <187900ec-4585-42d9-946c-e6de3111552d@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|AM9PR08MB6068:EE_|AM3PEPF00009B9B:EE_|AS2PR08MB10295:EE_
X-MS-Office365-Filtering-Correlation-Id: cf1ff752-a001-40f2-c43b-08deb743180c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|22082099003|56012099003|38070700021|11063799006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 ksZwjKZNktPGHZ31gScTy+S/BaZFPMltE+C3HzXz6aaXPYupt72Vgo4Lu4NRHmSsfUg9Nk2YxgofKKPUsDoeM1K+Dqt+kIuQLZK5xy1oh8nT06sPde8mEsVv/wwArYSjIK0i66LFxSJyTQbXyekK0yze8fYdxgWGuCejRYHPq4/0+Mb/ZP8iM1EhYLffz+9xu/SnBM3j0IXWDT3aQZNAWYr9p+XbwE+cgtZr+ZXHR/cDgSTj1k68/w3jg34MQxpRspMzKx4MrLZeDueFwJpjHrXipWwUYRljQaOvtMF+Bui0ovWQNJUL7RQqeBhUBQi79suwsIh2tF/04zabqWdiVX9dMuNC5PXQDKkFlL+M3qnHpGzEKso3lykNy25tkRHcbSbrg3FTaeDm9ClcoE+ZOgHS0Y+mHGD/lKNPi/VxlA1PXRVQJFz81hUXUfsLp0cC0wDlKlcYQGysa8rUCLBE48nD84zA92sxyL6AOQKf2S4OlMF+qzVovuIPzzlSFtTa7yMD4qnWf4rJ3MO8mjdfaNTt2WwjEPV+jpTvuF5iNJQGD8+M2PbPvZuwvQqTtfT1NSRlOpO+XmgD6F2GtWBFbqSZBWalQjRLm1kgABUn93CH0H1C/aidSs73ZTdafzIKGUPFCb/XbqKC/LniEzuCWaa8GCktWTMTNa99vyXjcb4Stlx3Jv1ATZ1DrKT6rdXkaWV3IDBlB4pHEEWADMYGVUPfYgi5sCMeZnWOvJJ4L2vx1j3GcResn6wHzjQ1U3hb
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4105956FEA77DA4C9FEBFA76FC28A87C@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 BU3m4aJHH9xrBJkF0DOQB98krmbH6EKRawSjrtoxCx5XhEV/qg5hx3FHua8Hcw+OV2GnUe0ENg45sewPhR8/z2hiCDo9ZjCsTa2oe0XXYuYaIyIumueHpBTc3K9uDFpbhEi0HVbe2RG31lhsS6JxlJDehVv/wHDgPSxEmUlrrQbRVFPBuGD1HDQ9lkzcsA7n0yDALdhZp6eLjPVyuSrLdt+Uyho4nXC819cmjbOK1k+sfhXX6+YV3K+1FCGMDj6U/FFQUIeVrSTZM1qjKJWEeAb2VaVSy7ZpcZZgjid3Xww7a2WaCCZKyKalGvj5mmgsep42tdo2dNgkil1zip198Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6068
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fcedf21d-c0ec-4970-9c94-08deb742f2ce
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|35042699022|14060799003|82310400026|36860700016|22082099003|56012099003|18002099003|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	DxsTH9cUXQDt+fGei757TZ+2NTdyn5oNOp9UM3FErGzjjPx2JxOp4jp+d3s8pcl9R+4IPRyIixBpmZquCNvnTU9kyc8eGNJyssqrur/TTSDSOuWEAwLN1udSzF896RBz+kTJKsm8MJU5keW5r1gk4Ar/b/4tUP8kMwdKOvc7fSl8ra0oppf7RyNpZTQka1603+7pK4bU9FHoeV64c2yYJ7KJrRLIF7Gr4TLKrzntTaSxIkZhpWmesu/GUwnSfBhJ7cPSjmuYjsGFl74ULpdh0/H8P1z41v0rp7uUd9IrUT8bHXG3OrDEYOQAYCAnOQymktdmVL35DHO9aqcxuERKgElOEumhN6fnWq3TgHE+5paMj+KObt6VY1XeErwORm+Y5qwPv5SA8yqXFBrfKxw+j1Oijk3GkcLl//IHrgbEGY8x7qrQngFdx/m2Q4/fL1RZ1Gh0xTdslOJ8uKostBN1FwA+RfR3OLiyFBUhR/INO2FGLZ4z1J2NowrlAlghljGUFtzVrSr2A8UNKO0VN7YssSeOYA07UrMYUCmAc06l1gSozwqFSpIXsk1tVNydhCi1M5e0hBkPtMxkVo8BJ9FO4Lnid0eH+sMRTgHZQ7ZxkkM67bSX9qs/F/q8sidaEL8Qz7tDxjYlsAfS5hLKtxDx9E7Yb1xcD8RHHA9nOrITEP0zsuPjHFU3gn3v4gtIb7JfgZlxfQIElyD0TS33IpvCaEojYGWuVkKEbxoKQI0m5CE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(35042699022)(14060799003)(82310400026)(36860700016)(22082099003)(56012099003)(18002099003)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0pi3qhMDNVJto+icXYWQgaKI5EUuJ6eQBfcrkBlzuhxjsd3it0Ti9TzBpa5pnAJU5NlD/IxJMp7GTC2KyYUnvEEZ2D+/Iv0G1Fu2iKe0deqkbC/tKH2GKFvNlsS5/N2+MqvDUcyDex/g2+bb/EqBZHEOs/c8+SbjdZbgV7S/sp3Fx5U7YN4hk0OUSZEWE01btlzULyfvXlNPHjQ2j3ceD5rvc7bq8fb4hiVctA8YGoNzg+4BJ5CBM7Wsi7BUWsvadH7ISHYqxb8IZGKSYIneHuDYTgTN+krPjcdmFkggT+AHISyr+1F0UsigOygqVSGXS6CXTfe4O+BqyrCTOSZK/nB7rYyVfwXsmCbBKTIGMPBE2Q/QxuXTTBaffecoKxvXbg1ldGmI38Rci1gmd42ITi00jhpByvD4KLAu0h5+5BgCD5vug5KVyFwL8zfpRUpM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:13:12.6501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf1ff752-a001-40f2-c43b-08deb743180c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10295

T24gRnJpLCAyMDI2LTA1LTAxIGF0IDE5OjU0ICswMTAwLCBWbGFkaW1pciBNdXJ6aW4gd3JvdGU6
DQo+IEhpIFNhc2NoYSwNCg0KSGkgVmxhZGltaXIsDQoNCj4gDQo+IE9uIDQvMjcvMjYgMTc6MTgs
IFNhc2NoYSBCaXNjaG9mZiB3cm90ZToNCj4gPiArIHRtcCA9IGxlNjRfdG9fY3B1KFJFQURfT05D
RSh2bXRlLT52YWxbM10pKTsNCj4gPiArIGhvc3RfaWRfYml0cyA9IEZJRUxEX0dFVChHSUNWNV9W
TVRFTDJFX0lTVF9JRF9CSVRTLCB0bXApOw0KPiA+ICsgaG9zdF9pc3RzeiA9IEZJRUxEX0dFVChH
SUNWNV9WTVRFTDJFX0lTVF9JU1RTWiwgdG1wKTsNCj4gPiArIGhvc3RfbDJzeiA9IEZJRUxEX0dF
VChHSUNWNV9WTVRFTDJFX0lTVF9MMlNaLCB0bXApOw0KPiA+ICsNCj4gPiArIC8qIFdlIGFsd2F5
cyB1c2UgYSBMaW5lYXIgU1BJIElTVCBvbiB0aGUgaG9zdCAqLw0KPiA+ICsgZm9yIChpbnQgaSA9
IDA7IGkgPCBCSVQoaG9zdF9pZF9iaXRzKTsgKytpKSB7DQo+IA0KPiBJSVVDIGhlcmUgd2UgaXRl
cmF0ZSBvdmVyIGhvc3QncyBTUElzIGFuZCBzYXZlIHRoZW0gaW50byBidWZmZXINCj4gcHJvdmlk
ZWQNCj4gYnkgdGhlIHVzZXIuIE9uZSB0aGluZyBJIG5vdGljZWQgaXMgdGhhdCBpZiB1c2VyIHNl
dCBudW1iZXIgb2YgU1BJcw0KPiB2aWENCj4gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfTlJfSVJRUyBi
ZWxsb3cgMTYsIHNheSAxIChidHcsIGl0IHNlZW1zIHRoZXJlIGlzDQo+IG5vDQo+IHdheSB0byBz
ZXQgU1BJcyB0byAwLi4uKSwgaXQgd291bGQgYmUgcm91bmRlZCB1cCB0byAxNiBpbiANCj4ga3Zt
X3ZnaWNfdjVfaXJzX2luaXQoKS4gU28gZnJvbSB1c2VyIHBlcnNwZWN0aXZlIGl0IG5lZWRzIHRv
IHNhdmUNCj4ganVzdA0KPiBzaW5nbGUgU1BJLCB0aHVzIGl0IGNvdWxkIHByb3ZpZGUgYnVmZmVy
IGp1c3QgZm9yIHRoYXQgc2luZ2xlIGVudHJ5Lg0KPiBXaXRoIHN1Y2gNCj4gc2V0dXAgd2UgY2Fu
IGVuZCB1cCBjb3JydXB0aW5nIHVzZXIncyBtZW1vcnkuIFdlIGNhbiBhcmd1ZSB0aGF0IGl0IGlz
DQo+IHVzZXIncw0KPiBwcm9ibGVtLi4uIHBlcmhhcHMgd2UgbmVlZCB0byBzcGVsbCBleHBsaWNp
dGx5IHJlcXVpcmVtZW50cyBmb3IgdGhlDQo+IGJ1ZmZlciBvcg0KPiBwcm92aWRlIGludGVyZmFj
ZSB0byB0aGUgdXNlciB0byBxdWVyeSByZXF1aXJlZCBzaXplIG9yIHJlc3BlY3QNCj4gbnJfc3Bp
cyBzZXQNCj4gYnkgdXNlciBvciBzb21lIGNvbWJpbmF0aW9ucyBvZiBhbGwgOikNCg0KSSd2ZSBn
b25lIGFuZCBoYXZlIHRpZ2h0ZW5lZCB0aGUgcmVxdWlyZW1lbnRzIGZvciBTUElzIChhbmQgYWN0
dWFsbHkNCm1hdGNoIHdoYXQgR0lDdjMgZG9lcyBoZXJlKS4NCg0KRm9yIEdJQ3YzLCB0aGUgZGVm
YXVsdCBudW1iZXIgb2YgU1BJcyBpcyAzMiwgYW5kIHRoZSBzbWFsbGVzdCBudW1iZXIgb2YNCklS
UXMgdGhhdCBjYW4gYmUgc3BlY2lmaWVkIHZpYSBLVk1fREVWX0FSTV9WR0lDX0dSUF9OUl9JUlFT
IGlzIDY0ICgxNg0KU0dJcywgMTYgUFBJcywgYW5kIDMyIFNQSXMpIC0gdGhlcmUncyBubyB3YXkg
dG8gc3BlY2lmeSAwIFNQSXMuIFRoZQ0KbnVtYmVyIG9mIFNQSXMgbXVzdCBiZSBhIG11bHRpcGxl
IG9mIDMyLg0KDQpJJ3ZlIGdvbmUgYW5kIG1pbWlja2VkIHRoaXMgZm9yIEdJQ3Y1LiBJJ3ZlIHJl
bW92ZWQgdGhlIGFiaWxpdHkgdG8gc2V0DQowIFNQSXMsIG1ha2luZyAzMiB0aGUgbmV3IG1pbmlt
dW0uIFRoZSBpbnRlcmZhY2Ugbm93IGFsc28gbWFuZGF0ZXMgdGhhdA0Kd2UgbmVlZCBhIG11bHRp
cGxlIG9mIDMyIFNQSXMuDQoNCk92ZXJhbGwgdGhpcyBtZWFucyB0aGF0IHRoZSBpbnRlcmZhY2Ug
d29ya3MganVzdCBsaWtlIHRoZSBHSUN2MyBvbmUNCihleGNlcHQgdGhhdCBpdCBkb2Vzbid0IGFs
c28gY29udmV5IHRoZSBwcml2YXRlIElSUXMpLCBhbmQgdGhhdCB3ZSB3aWxsDQpuZXZlciBiZSBh
dCByaXNrIG9mIFNQSSBJU1QgYWxpZ25tZW50IGlzc3VlcyAod2hpY2ggZWZmZWN0aXZlbHkgbWFu
ZGF0ZQ0KYXQgbGVhc3QgMTYgU1BJcyB3aGVuIG5vIG1ldGFkYXRhIGlzIHJlcXVpcmVkKS4gVGhp
cyBkb2VzLCBvZiBjb3Vyc2UsDQptZWFuIHRoYXQgdGhlIFNQSSBJU1QgbXVzdCBBTFdBWVMgYmUg
c2F2ZWQvcmVzdG9yZWQsIGJ1dCBpZiBhbnl0aGluZw0KdGhhdCdzIGNsZWFyZXIuIFNpemUtd2lz
ZSwgaXQgaXMgYWx3YXlzIDMyIGlmIG5vdGhpbmcgd2FzIHNwZWNpZmllZCwgb3INCml0IGV4YWN0
bHkgbWF0Y2hlcyB3aGF0IHVzZXJzcGFjZSAoc3VjY2Vzc2Z1bGx5KSBjb252ZXllZCB0byBLVk0u
DQoNCj4gDQo+IENoZWVycw0KPiBWbGFkaW1pcg0KDQpUaGFuayB5b3UgZm9yIHBvaW50aW5nIHRo
YXQgb3V0LiBJdCB3YXMgZGVmaW5pdGVseSBub3Qgc2FuZSBiZWZvcmUuDQoNClNhc2NoYQ0KDQo=
