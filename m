Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013018.outbound.protection.outlook.com [52.101.83.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711AF37B3F1;
	Thu, 26 Mar 2026 11:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774524243; cv=fail; b=kHrAgLj5NSRidUVzfa2QJLjgbTeMCjoiHVrBgyXY2k22UqgadR43OJBEi6STk+5k+Vwh1e5ltKC2roZCYhKz/Nxqc3LJ0QCjtTsjSijhvMksAR6/8eASKbuDqgsxRu1M2OxjmFp1cjkz28BrgYs4Ly+DYVA0pdEtYuRLapU8vmw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774524243; c=relaxed/simple;
	bh=jRm8q3QS2T6kHeKLDynOMdNzscOBpZUVZ9WhGlGXUYc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jrsS+xsvbMy+ovWFRCn4aO2Pq3SF4WKano30CX9DGn90QdtBXELpHjSlCVgI7h7rmNP3focB/9Vk/QVYaJyTmnUnQkCdavJayd2+3N1tL6+NpDKRVfvfFdZQXzSN1imEgQR+Wm/k5mHfB7/PTrCWOrfQKpPR+JNg+QRv0XAE7k4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZxjleHK0; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZxjleHK0; arc=fail smtp.client-ip=52.101.83.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZxjleHK0";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZxjleHK0"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BMqDpkBQl9UeEQeXLQfFD115JU17yr6tnet4KfSQpzyz/SGo5MD4LYZ0iCTCWAwt1vclR1in6fgbTps2POALTAW7Bcbc461lGVkIXF50bHjRmZhsAbvIFHGcmi8J907nvFkjUF8UneDUL9O3+0T61kSuu97seuwJWHPOMbvdX7Sg9aiTIozodLPXQek4fUrGMrTxLWtCP6vinV3z0HNryUUKbGbQ9axVbfT43qb3UE6g0zp8MjDCm9ZuHQ266Forq8kfGMOWdcEr7UTHdKHH875etUTbHPXvdlj+C1S68HzsKbHUXtq8rC4uyZ3CXezDE2i116LnB0WaBkiOipy33g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4goXpKaIIUQbzMtnbG+Nl5wjlHr+DycvPz/1fM9qKI=;
 b=dFgy0xTWmUrBoqNojwKBPXIYaeOmEWdgMJKt5l8hUwGjs72VcIgIv7qdmhpaNDQsuojh1epp0IykKbe/kiJiHRiKXWrJFArtMf/qWZPiT/YArkCkwiPI/8zguNe63mHwW2Oalv2wzd7QCzS4R4SDHkK7nTqbABS+WH/B0ZBuqBmVC4nScGpRr2mYPXZXqy826yGHkKlibOF0Cuno0ZM4b4zVkixdLXtLjTD3QvdExUzVdBAmS2C6qW7zNcs6Fpu70iNH/7JM2gvVddnrDgWhdaRZ5kRInHQ1FVcJLCWYoV0TzsrCqbqRXOAVY2z+lw41LEJd6I+1juLCVdhSeI21lg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4goXpKaIIUQbzMtnbG+Nl5wjlHr+DycvPz/1fM9qKI=;
 b=ZxjleHK0GdZpG/NvbH5c7ueF+wYSV0pCG/fIDpIGVMdjmLOfwkvRW/h0GEmHHklsH0r3Ts4ioOjnAwwRCgM1Q84C64PDgGQJRKnKlF5flUXWM65bLV2+eoNw4PwYwZYY0cCrberHDH+qpkKWhU4DItxcN3LJokbtWRi3MrEzxmM=
Received: from DUZPR01CA0043.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::6) by AS8PR08MB6245.eurprd08.prod.outlook.com
 (2603:10a6:20b:293::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.22; Thu, 26 Mar
 2026 11:23:54 +0000
Received: from DU6PEPF0000B61D.eurprd02.prod.outlook.com
 (2603:10a6:10:468:cafe::ff) by DUZPR01CA0043.outlook.office365.com
 (2603:10a6:10:468::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.33 via Frontend Transport; Thu,
 26 Mar 2026 11:23:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61D.mail.protection.outlook.com (10.167.8.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Thu, 26 Mar 2026 11:23:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/Pextz2e9zZzh0t3PbDr28lP9WdgmSYDxzpzBhUA0KheZVw81Pg5s2w4JldE4rUmrhJOPeqX3h6gBn82w4v56sPY/QKxfaGflQQayQY7269EVTbPAay6lmQjX4RZYxTm+AASf/JC61treBsCGuIx+sCxK/6mORLF83yU9fMZSX/La43VTcz4UdLY7hUL3245EZR0xQXNWD9/VM3ebDjz4QMrV4PrUoOzNaggQiDUTIb5tJQ2k6TXyUCbFqF4S7pBFJHGuOlEtl9oFa26LxJxoSRPwaUthM+M1foPb6zoTaGyZWotuJSnXF7npd830O0zn/IJbV6fE7W5ZJgW3W9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4goXpKaIIUQbzMtnbG+Nl5wjlHr+DycvPz/1fM9qKI=;
 b=coIIePOSogIaLttVJF9c2PRdexK44uJqCXEh1p5ikh53DMxgjPSfpVKbY+y50xJn/cT3Nlj0uo/WHO7Cf01ryoJ8gIb/m1maKyrttjU8LRxiplLftL9DrmkT5sHGAT93ya1r03LVP/8F4kfVFCYVdE73EvtelAXR7UZtj710JGrkQM1a6g0YvHxKJnyC8J8R4Xmq4fqJ1Lma6FAik7XxEwFHJO307BlZNiiOtXFEQKDeW7F0yq0LET6a3jI8SQBkJDWiDVT3yNmTe9QK8qG9jXgIVMVowcw4fjmNMa7Ed3YRvoSxmTvfUmhiGNLgDns0l6+HJBOWEOFD/6MWlX6o7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4goXpKaIIUQbzMtnbG+Nl5wjlHr+DycvPz/1fM9qKI=;
 b=ZxjleHK0GdZpG/NvbH5c7ueF+wYSV0pCG/fIDpIGVMdjmLOfwkvRW/h0GEmHHklsH0r3Ts4ioOjnAwwRCgM1Q84C64PDgGQJRKnKlF5flUXWM65bLV2+eoNw4PwYwZYY0cCrberHDH+qpkKWhU4DItxcN3LJokbtWRi3MrEzxmM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by PR3PR08MB5721.eurprd08.prod.outlook.com (2603:10a6:102:84::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.22; Thu, 26 Mar
 2026 11:22:51 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9745.020; Thu, 26 Mar 2026
 11:22:51 +0000
Message-ID: <44109e80-b46f-404c-bc69-d019c923faac@arm.com>
Date: Thu, 26 Mar 2026 11:22:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <abyAbPIkDn2bGZwd@p14s> <37bc1222-6fc7-48f0-94d3-6eaac420aa55@arm.com>
 <0b7121e7-3c74-4303-a200-01d2b7c535ce@redhat.com>
 <9247d9ea-64b4-4e8e-81f8-3c8e00750acf@arm.com>
 <807b844c-32f6-4094-8c24-15d7eb1d3638@redhat.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <807b844c-32f6-4094-8c24-15d7eb1d3638@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0206.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::18) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|PR3PR08MB5721:EE_|DU6PEPF0000B61D:EE_|AS8PR08MB6245:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f874516-0da8-4977-5d23-08de8b2a29b6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 U4EctnKs43HpF2zJVCwbnD43nz9Df3sSEbjLnogVi9z8Zogj5/dkAbxRmOdDLFx6hvGoAndnb7zJOGhaIMTFFvIQndsmLHUNArXdM0OYnoD8c+TZgO8jUFmp1Mn7GFSqhcq6g2xuXaQQDea+FgTYpHB0w9McIHv4vbhsqLx1OedN7A28QvetKgEsAzpHkXKQ8qjmS6ZOPbx2tywP3iaySSIT3Qx80oCSCN/K1+eWy9UOEbRggM5NaVToRw722E1+dkvnQvqOmvCvX+A1ZkpfDKu31PUkUwNdv/NeRcATtAgZKJJHUkgng4huRvQgHnWIcmHZARvhu/B6N43sCBOzSVhbza9EVhqv9i13ftFEKYEoySD1cWMzoWbBve657RTQ/9ouTzN3ewm7EyLhWnJqnKtOQKI76qvpBucDh3KSBjcYgKyWl0/6Uj8jgikqV1EnKM7g/26CT50RHIPa+lf06NnmnvMCxZl4tGAXUng26NDGCGMTl0yap8aJ0Kn1v+vVGDdU/j/giJvmRLkczMAln6kqImT7BDOZ+DGOSnwQKQKw2eUt7Lzq4WC4ZhJ23MoqARHOPKMWzII/cFod5T8qkS45AXpIXbGPNMIkwqPRcRsREMBmYtRhQiX4u+12q35JWKn4k362jWvl5naflVkfcBfm9ixBDI8+xbkWo1aq5JEXR0Upy9JwQjPc+Wy8GMLY
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 CyC2ZdbaFM5FLxYpMeQgDMcdrL6EPw7247e+Nrs8W9xAe+afb8qQnREwhSdXugYEM8i3SaDU2oTPi+QBYlMqMx8i1ElWD+j8ckT0Aa6k0NOE9UrYJZ2VxPvnstLExnlzfe23XtNbsGzEhyK2SVE59HE39ItF4EIW1gLkd+RpU+BDTk1eQm6U7WATtRPiKGlZtfwXQi3F9y2tZ0p2LYe84104AI1MVkjdbwU4uGTz9xyemdfjqyNvWYisJZehUSSkEtqQ1ZMg1xYtGclvKBuYOCcMjlUF1SBWwgBqnOObNPGQQwkcfIASTLI6JxC8CpvOvVEYCx4gneKOWltpRB56Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5721
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aa8cb4d9-3b4e-4111-a20d-08de8b2a044d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|7416014|82310400026|14060799003|35042699022|13003099007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	HuXbfu238pbRsZKymYy/U8Dcj+nlr4B6ccHXWds6/NnQ+dIBHrL5uibCRtOrft/RkZECYLMjML+LGqJwA/Y8Pk8reZMlEBe3lgdMPgV2yMLbcKW5kpTIzrsuihY5dFIQxGMN6Rpficb7/VOs3J1YSRCDTL002A0mF/oB+JD0S0zCNUXm2s+J6ulr4WgupgVdXuMkZFojKj0hdo1GEg+iapLjjhGR2KlelwdnkvaB9/fCUhm32wBWNZ22IXDyhmPkT8HsP3AyoN2bnlzOyH9yTrasddkMtB9TgbiIxWtXq0oaNFvCd+8IIZAfDeqYYO4v5PhYAlL2cKKaY949Ns9ekT2Udr4FEQKP0z0to+Ilvqt2WSwlTo8XpRR2TK5UdnftAn/OXWsiOCfS38SzeUywcMczT+EQVr9Tl5a09vkO9gRs1Qj6g2HP8JrOWa+y774Qpkfpr+fApr3xBmO9KPdd3XEXnYvwir+9zJs5d8XdXLZ8+uVfV2SM4C5B9UuvSyLa/ZJCfyJs0nDmLeCLbvMC6oqMIoIWJxhlOnrCyB+G+EYK3bLvRzMzABy5zALELp5LlwcTTAYzedgk/nhdiygX72o8ASDeeoA0CEguB7m95HAdvIJVsZDzEVuh4NWO9Lf00qSbwjEjIL0SUXmEnzJkA3yHbDKGje5P52fHv/s1EIZZtUKGl6GWC885fDV0PkBxMlKXeJuaQl5A6NuuPsTK0lnfqBFBhuJRWb7F/14gcYM=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(7416014)(82310400026)(14060799003)(35042699022)(13003099007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dz5bM374N9QsvK+R/d6ibpHP9YuGX11izh9xH3vRaX5ggvQ6cH6dcWn+03EAH/KWsX4yrEnz9lxQKPaacea+vLWMs91Q9lyqmJ/J7/wbM8ZCNUB7Mb/9Hj2mh+tP+njGjSqCOkOhcmR1U5lOwH19qdowS8RhQw9rBq8uj35x8+NwpYcPzxcekrHvLZRwqiDTfzjVjXhkebOR9XHFPzOv5uY7HMjhsl6FF2mn3I/YVO9ywyblgKbuzJssMrlfSgZgiCCfLXTsIiTs7ho4ry29MdFAw6mSZzmvARIJgV6Z0fCLTvJvkisQZ6P3v0Rz+0JXII1T3toTB+fRgibaGjv++ezt8wk3gFCaSw65II7e7xB9ZN5d4sVX1dMsuZ72PFHI4taCbSMviJUGFbwmqFhRjogT40Jxb4F8UUwiy8ihhY/o1oXSo4GTgpw2DCzRWIUR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 11:23:53.6737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f874516-0da8-4977-5d23-08de8b2a29b6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6245

Hi Gavin,

On 26/03/2026 00:48, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 3/25/26 8:16 PM, Suzuki K Poulose wrote:
>> On 25/03/2026 06:37, Gavin Shan wrote:
>>> On 3/21/26 2:45 AM, Steven Price wrote:
> 
> [...]
> 
>>>
>>> In upstream TF-A repository [1], I don't see the config option 
>>> 'RMM_V1_COMPAT'.
>>> would it be something else?
>>>
>>> [1] git@github.com:ARM-software/arm-trusted-firmware.git    (branch: 
>>> master)
>>>
>>
>> suzuki@ewhatever:trusted-firmware-a$ git grep RMM_V1_COMPAT
>> Makefile:       RMM_V1_COMPAT \
>> Makefile:       RMM_V1_COMPAT \
>> docs/getting_started/build-options.rst:-  ``RMM_V1_COMPAT``: Boolean 
>> flag to enable support for RMM v1.x compatibility
>> include/services/rmmd_svc.h:#if RMM_V1_COMPAT
>> include/services/rmmd_svc.h:#endif /* RMM_V1_COMPAT */
>> make_helpers/defaults.mk:RMM_V1_COMPAT                  := 1
>> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
>> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
>> services/std_svc/rmmd/rmmd_main.c:#if !RMM_V1_COMPAT
>> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
>> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
>> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
>> services/std_svc/rmmd/rmmd_rmm_lfa.c:#if RMM_V1_COMPAT
>> services/std_svc/rmmd/rmmd_rmm_lfa.c:#if RMM_V1_COMPAT
>> services/std_svc/rmmd/rmmd_rmm_lfa.c:#if RMM_V1_COMPAT
>> services/std_svc/rmmd/rmmd_rmm_lfa.c:#if RMM_V1_COMPAT
>> suzuki@ewhatever:trusted-firmware-a$ git log --oneline -1
>> 8dae0862c (HEAD, origin/master, origin/integration, origin/HEAD) Merge 
>> changes from topic "qti_lemans_evk" into integration
>> suzuki@ewhatever:trusted-firmware-a$ git remote get-url origin
>> https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git
>>
> 
> Thanks for the details. It turned out that I used the wrong TF-A 
> repository. In
> the proposed repository, I'm able to see the option 'RMM_V1_COMPAT' and 
> the EL3-RMM
> interface compatible issue disappears. However, there are more issues 
> popped up.
> 
> I build everything manually where the host is emulated by QEMU instead 
> of shrinkwrap
> and FVP model. It's used to work well before. Maybe it's time to switch 
> to shinkwrap
> and FVP model since device assignment (DA) isn't supported by an 
> emulated host
> by QEMU and shrinkwrap and FVP model seems the only option. I need to 
> learn how
> to do that later.

Thanks for the update. Yes, QEMU TF-RMM support is in progress, @Mathieu 
Poirier is looking into it

> 
> There are two issues I can see with the following combinations. Details 
> are provided
> like below.
> 
>      QEMU:      https://git.qemu.org/git/ 
> qemu.git                            (branch: stable-9.2)
>      TF-RMM:    https://git.trustedfirmware.org/TF-RMM/tf- 
> rmm.git            (branch: topics/rmm-v2.0-poc)
>      EDK2:      git@github.com:tianocore/ 
> edk2.git                            (tag:    edk2-stable202411)
>      TF-A:      https://git.trustedfirmware.org/TF-A/trusted-firmware- 
> a.git  (branch: master)
>      HOST:      https://git.gitlab.arm.com/linux-arm/linux- 
> cca.git           (branch: cca-host/v13)
>      BUILDROOT: https://github.com/buildroot/ 
> buildroot                       (branch: master)
>      KVMTOOL:   https://gitlab.arm.com/linux-arm/kvmtool- 
> cca                 (branch: cca/v11)
>      GUEST:     https://github.com/torvalds/ 
> linux.git                        (branch: master)
> 
> (1) The emulated host is started by the following command lines.
> 
>      sudo /home/gshan/sandbox/cca/host/qemu/build/qemu-system- 
> aarch64                  \
>      -M virt,virtualization=on,secure=on,gic- 
> version=3,acpi=off                        \
>      -cpu max,x-rme=on -m 8G -smp 
> 8                                                    \
>      -serial mon:stdio -monitor none -nographic - 
> nodefaults                            \
>      -bios /home/gshan/sandbox/cca/host/tf-a/ 
> flash.bin                                 \
>      -kernel /home/gshan/sandbox/cca/host/linux/arch/arm64/boot/ 
> Image                  \
>      -initrd /home/gshan/sandbox/cca/host/buildroot/output/images/ 
> rootfs.cpio.xz       \
>      -device pcie-root- 
> port,bus=pcie.0,chassis=1,id=pcie.1                             \
>      -device pcie-root- 
> port,bus=pcie.0,chassis=2,id=pcie.2                             \
>      -device pcie-root- 
> port,bus=pcie.0,chassis=3,id=pcie.3                             \
>      -device pcie-root- 
> port,bus=pcie.0,chassis=4,id=pcie.4                             \
>      -device virtio-9p- 
> device,fsdev=shr0,mount_tag=shr0                                \
>      -fsdev local,security_model=none,path=/home/gshan/sandbox/cca/ 
> guest,id=shr0       \
>      -netdev tap,id=tap1,script=/etc/qemu-ifup-gshan,downscript=/etc/ 
> qemu-ifdown-gshan \
>      -device virtio-net-pci,bus=pcie.2,netdev=tap1,mac=b8:3f:d2:1d:3e:f1
> 
> (2) Issue-1: TF-RMM complains about the root complex list is invalid. 
> This error is
>      raised in TF-RMM::setup_root_complex_list() where the error code is 
> still set to
>      0 (SUCCESS) in this failing case. The TF-RMM initialization is 
> terminated early,
>      but TF-A still thinks the initialization has been completely done.
> 
>      INFO:    BL31: Initializing RMM
>      INFO:    RMM init start.
>      RMM EL3 compat memory reservation enabled.
>      Dynamic VA pool base address: 0xc0000000
>      Reserved 20 pages. Remaining: 3615 pages
>      Reserve mem: 20 pages at PA: 0x401f2000 (alignment 0x1000)
>      Static Low VA initialized. xlat tables allocated: 20 used: 7
>      Reserved 514 pages. Remaining: 3101 pages
>      Reserve mem: 514 pages at PA: 0x40206000 (alignment 0x1000)
>      Dynamic Low VA initialized. xlat tables allocated: 514 used: 514
>      Invalid: Root Complex list                                         
> <<<<< ERROR
>      INFO:    RMM init end.
> 
> (3) Issue-2: The host kernel gets stuck in rmi_check_version() where 
> SMC_RMI_VERSION
>      is issued to TF-A, but it can't be forwarded to TF-RMM because its 
> initialization
>      isn't completely done (issue-1).
> 
>      [   37.438253] Unpacking initramfs...
>      [   37.563460] kvm [1]: nv: 570 coarse grained trap handlers
>      [   37.581139] kvm [1]: nv: 664 fine grained trap handlers
>      <... system becomes stuck here ...>
> 
> So my workaround is to skip fetching root complex list from the EL3-RMM 
> manifest data
> in TF-RMM::setup_root_complex_list() since it's not provided for the 
> qemu platform by

^^ This may have to do with the RMM<->TF-A Manifest changes


> TF-A. With this workaround, the host can boot up into shell prompt and 
> the guest can
> be started by kvmtool.
> 
>      host$ uname -r
>      7.0.0-rc1-gavin-gd62aa44b2590
>      host$ lkvm run --realm -c 2 -m 256                   \
>            -k /mnt/linux/arch/arm64/boot/Image            \
>            -i /mnt/buildroot/output/images/rootfs.cpio.xz
>            -p earlycon=uart,mmio,0x101000000
>      Info: # lkvm run -k /mnt/linux/arch/arm64/boot/Image -m 256 -c 2 -- 
> name guest-163
>      Info: Enabling Guest memfd for confidential guest
>      Warning: The maximum recommended amount of VCPUs is 1
>      [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]
>      [    0.000000] Linux version 7.0.0-rc2-gavin-g0031c06807cf 
> (gshan@nvidia-grace-hopper-01.khw.eng.bos2.dc.redhat.com) (gcc (GCC) 
> 14.3.1 20251022 (Red Hat 14.3.1-4), GNU ld version 2.41-64.el10) #2 SMP 
> PREEMPT Wed Mar 25 20:28:05 EDT 2026
>      [    0.000000] KASLR enabled
>           :
>      [  267.578060] Freeing initrd memory: 4728K
>      [  267.921865] Warning: unable to open an initial console.
>      [  270.327960] Freeing unused kernel memory: 1792K
>      [  270.669368] Run /init as init process
> 

Cool, thanks!

Suzuki

> Thanks,
> Gavin
> 

