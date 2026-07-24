Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011010.outbound.protection.outlook.com [52.101.70.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FAC429009
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890674; cv=fail; b=DMcR2aI7JP8Vh1f6QoIVv9JCfCrZ97oAvIO/KUQU6hHomSqGEVXbTdQGhansez4PU7kqpGTeQqMF35Wd2mkFEzahMTVoChznSNskJmfuxYYYGcgDAYwLmiHH5V4zbI/QkOMaJbRTWHg7Q7snR9bJyElQZhhMUZvHLEAjsMA/IPI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890674; c=relaxed/simple;
	bh=CAr31Bu+L6nzGeSGmt8z53zex6WsBnK3RfXjkK015b8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tbBvguZipliM2neyMmlOlYlcUAzvTgfGcu8tJjce8vVKdhus0oX+QC9lge9NzkBNbekb6rvOVMZ7MWiB99YfZIMBJaRWLMT/PrXDpdKWReCLkrdqOcR1thcFRaPYYf2AkzgB9DqMBf16PSUivKxHJ+l19wNbWEWpK3SFnDK7d+Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jgyuGvSY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jgyuGvSY; arc=fail smtp.client-ip=52.101.70.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jgyuGvSY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jgyuGvSY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=R3ijtwrBg0vbKXLtPNbKLPD8Af5iE3G2Bp9QwJgwdzB59ynqJEpJ4zQRf7AWJW8aKHB3WfOfRTPOifZLmuWmEXVcuWdaZMLCtYwYp8jMuc2NsdayJLbvnjaObq9W4GY7rMa5xrIr4a5Jbyd02RyD/zABfXmacC3HbFV2C9GWvJfHI41d5l1072jhONbJHv+KdHTdUicRj8NPobT5ykslZu2pLL9/LrZH+IxiHLHLXpT7H+siZcZwuM1KSUH1JF/1Q4g+z6Zcp+G8nYK1Dmajg4duuKEzXeTwcW2q2E2eFEjMypDrH6fqIZPFrj9ca/XA/g6XpzTklTlXNMQjjwzzbg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j92Rn0K/kFPgluUhFsygfrNLtfaaes0D+BjDLH8EHR0=;
 b=qKL5Si8h0vnw3h4XSr1Cyi0q/7lZcLaOqJZFnqVf+6+zEEWLiJ78pkDWz4boV6i5zNoI7K99qKYNtgnoSAt79D+nOPqlP8KiBl13nysQt7I0wIg300T91rujZbS+0cWWMB87+WGdk3HKH2u8ruCqPp8vbzHXhkm8/xBRjfkGtDoElqT11kStOa8C4yi86PoCVp7zTqIJi486CAYrx1O4ew8na+1FKdpM07Bh3/14s2Nw8CtYvsD3dUohM3Xga0jXh2hqkIBZbley5D1+LfwKPTRhLDqXjmSlM7uRzEmiW8aCNzaMc4c3vBuE8PYe/lXmR4m9AVbM9fNPZbDSw+MzLQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j92Rn0K/kFPgluUhFsygfrNLtfaaes0D+BjDLH8EHR0=;
 b=jgyuGvSYPkHIAW7++ApSnk+ysKGWKTovt+ULEPV3WO083fb9LWyHigZ+IRHDkHwZHlH01nWljoyVfT54qtqGx6TSx5TCS6bjZLbzo9UiiPmuvON67PH4mT3HsR9NA1PQphOVsqnTtk8fIyzpRTn0RE7Cz+uDLfI6P2AFY4flEZg=
Received: from AS8P250CA0004.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:330::9)
 by AM8PR08MB6498.eurprd08.prod.outlook.com (2603:10a6:20b:364::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:57:43 +0000
Received: from AM3PEPF0000A79B.eurprd04.prod.outlook.com
 (2603:10a6:20b:330:cafe::3b) by AS8P250CA0004.outlook.office365.com
 (2603:10a6:20b:330::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:57:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79B.mail.protection.outlook.com (10.167.16.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:57:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FGgc7wlWMM6Hhz4wbopJKyB28bKtYkgGuzdXrUZu567d1QjR2M5yB39UfmiEc5kSFNKSJZJJh/eepaD2ViUakCWJYmWzk8nAdGy1A+0Uo4FWfGK8vxD5le0pmrqF1FgrlnNJBqyGt03qyISUJZrkPdLTk026X7qT0ykIVQck8ibnqXEDvw2hS+W14joLH1QR5n11umDdlQ7v8btSxKRjpp+Kt/N2k6u2vkoKFd4eBB2QxLDcul4NArAPoH0Mxw6qCpkBXJ7RxNE2IX/QNB8JTC2mPLC47kb9weKXG7p69U7WCBqwPXMj9IpVEc5IgYDemwrhPJHbFwlEfNNAqf/36A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j92Rn0K/kFPgluUhFsygfrNLtfaaes0D+BjDLH8EHR0=;
 b=kQ0BjMcn5kfTMxhNpKtWK0mZXIQVcv1nQ6HSm/cFhjOfJOvTzdehptxabyRP1wBjvI0wCsIW5lZ7RnL8UhO/fB0BMyJyGOcsrEvanA4J/1yFY04fUlDXzcROqHyegSfewf0uHfrSKGowaKam9pTOPKiF8OmCVSym7OTvcP5pERd6mxJAqgyYkKtiybvSWTjd8MkM3RHTz9wY0HW0aU+76ovwCaeVoO8hJxkaFPONLEuEsHty5l6u468MtSPnCP1E7WUTA5qD8oYuKVLkbSmKNFgokbn/EGt11yZRd5wNE3DtnWhn+OuCZ3uW/VXhz4Gp+OzCqUJV4iQQPO9AAJRAUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j92Rn0K/kFPgluUhFsygfrNLtfaaes0D+BjDLH8EHR0=;
 b=jgyuGvSYPkHIAW7++ApSnk+ysKGWKTovt+ULEPV3WO083fb9LWyHigZ+IRHDkHwZHlH01nWljoyVfT54qtqGx6TSx5TCS6bjZLbzo9UiiPmuvON67PH4mT3HsR9NA1PQphOVsqnTtk8fIyzpRTn0RE7Cz+uDLfI6P2AFY4flEZg=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7769.eurprd08.prod.outlook.com (2603:10a6:10:395::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:56:39 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:56:39 +0000
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
Subject: [PATCH v4 32/48] KVM: arm64: gic-v5: Handle userspace accesses to IRS
 MMIO region
Thread-Topic: [PATCH v4 32/48] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Thread-Index: AQHdG1saCJvLbaHg20qHU528QFxbuA==
Date: Fri, 24 Jul 2026 10:56:39 +0000
Message-ID: <20260724104819.1296803-33-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DB9PR08MB7769:EE_|AM3PEPF0000A79B:EE_|AM8PR08MB6498:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dd599ec-d6bc-4cfd-05f1-08dee9726363
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|5023799004|56012099006|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 Jb6Di84YI9Hc47ygOIGaDJWCHmsX23inVEmCDizTLlZ/DvIyCX8sPkTS7suVpJW/ulkSa7VlAmRH3Ybr5hW+xSGD7y+1ds2kkLOCJOvrE7eBplzxDSqhvQsY9oA8OwvKvB5qmvon782+QWrVkp79QfFZoLFptL1Pt98nLOEkHVQP+bu4fgeUxvEIoMZPkngD9Yebl1yJe1R7fenOn3vp/fliz1OF1VMP0Rw3MngVhxsDKH9+zvUY+DScarBK208pQLzLkzRYCag7hgXyLZvBvc4i+Cs4u632NXRPI7PenYaHU15wlVnpj6lCzrh+8rgKE7rd8uOV4K+u7hYMEoN+LGh4HeNzM7GhCwWvFir+KTaY7QdWp50EVsYUfwxNtic509Dw6I5wlTzrfHR0zIRKy+QgpzlTgVgs1NBYPD/6V6q4UWLE7wq2kW8CbRLAGHy3N0tjqxwkXtNlQM8bMDNGzvwMl4FeEFTUnYfngRy5NdjhhgEm8YaA2VGmMTx/BJgwwfcOF1Sl8cXm7wON/WN6AOtUFAhZMR9wAdAfpPu7+7pByo93hrZUUBvqvA3nuH16CsvRwJ8rJW5Fh0mln8AUwsv2oA39zgRdjSGWHFSZCJrL3oGbQBIxumovShNOManeV7wBQCTFrn0nS3I4FvUqjooK6fsXZPvP1iuX+GTS240qq/OzFHq1jrRKHHzzbpzpfGkI1/Pzgv2MXwd9GlsrJKm+iwLsyUAQp64G06iSucg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(5023799004)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XN4B5cxgAVeqAZyAgmIMpMjAb70sGus/m5qPFjsz/chXQvrnuPTmNz8uA+rNBmsGQeECHUIOW2thhzS7W9tIB1M0CWxVLIsVgppwTjRimPGue6bK0adDEOil6BMGAIGXf8NM+oh6s4rvRZ1FdhxX/mOz7iLruadndSylFGaO/Ufr7vammvNyzVJ6NWs34oneMiLXwKtj5xhNq4hY3j82xIdyhdO0D2Q56G+WXoF+bk/uTOhAz5L6ny0wZExpxsBibzz5S9oY+5CSga7opfhdb06zK41NswGEX9N/0PpI1Qs2Ih+JDFFwBZqSXzHKZ1HZY1YipkCAovsAxCKESSXTRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7769
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7437149e-56c3-4636-ac8d-08dee9723d2d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|35042699022|23010399003|30052699003|36860700016|376014|56012099006|5023799004|11063799006|10067099003|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3QKMlU6ipx75JEwQVoiAudV4oGsSHFFf8JcvZJnsPefwc6h/kfGHcrW7D+6NI5FtBsi6ZeRSFKnntuBKpbl0RsoDnf1gBl0Y680dla61YKBUaP0hmgv0+zVNDa/6OvU96P9gscKXu6QlQMZm9IJvfflFhhsy+FK35UKdRmJzh7RyP0gyGK2MaRIbxRW+lXmDYslBmO25PwscYcPn7AAOTNh0aTUdD/8HoGIhyvMS5IXS2kODFrUTX8Obflc0t4B8FHuO2P1ZVqOpccxTjJI/TEakGzCgqXJXrWhRT9nklTAZzu1/CAo7ufUv6gOTDMprXVXwC2YdymThsippfvMxQijA3jB5CElLUi95UeWEnvd6W2LJFvEppz92fOBFdkZCFSigq/nkLiCEf8Itrfcr73XmxPD3T5ljEUDBUNEUvjwNNlK/zOjrT7jtbYWWaLh4z5RaXcLgLCYFBmXh3uRpanD94tFbWzFairD9Jz6LCvFbXS53gsDNsRjtMV24/TWtnJNBlvkZLW6x8bGqK6k2rVb8kJO6/rtlmRBfUGgscHX4BWw5G0v2BL9K81vdgWyRBfIXtzX68pTvqEjHMg+pJLLtyvdQCHBlSrZhKPwmDwpWc/47Znw7Do3qRN6UC0M43nQ5Mu7yyGZNqJy15+tyvZQdwj4ZoJAOTOkPOM77/sf0egRQm5mNcxIT8KH/3HPisZuB5HZXrVKQ4xadvdBz5g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(35042699022)(23010399003)(30052699003)(36860700016)(376014)(56012099006)(5023799004)(11063799006)(10067099003)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	D9HS+6FoKePaXO+PAHt0OjyT8yUaZBPm0hUaZfvodDh5N0qYosUReRTArXzfA98i4iPY5GupdLsG4JsBph2A3TY2ftg0KQmatU+wVLxx5MlMsPSrTuxnkw3y3vy3UD8eYgToPW5L72/IAaISD7rfSC73m6W8bHN8DI/5DrwSA+zeaYL764rVLd8BCZg0JGtBHdrqrKw4VAig6PkFEYd7ds6bxMTywHX+mn9vuaeRfCmcQ8dXUPC0TH53aK6T/8hqHiVb8u1UwKdAuxlql78E7HgTnf9jmPIjnmzNL54bnTHMYAL+qYDv3ilyHz3YHVKTo/tejEdaKwrJJOJRSAtVZ9Eu/HVZ9mWdDjMN9Z+TBB/NmETnNGjNdTQfSVaHbhNfBYMsYWIrHY8SudOpGr09oJ5wsHeiPdUcn0hdgS6R788EjadQ+lWSQEAKXAEWo6LP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:57:43.5138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd599ec-d6bc-4cfd-05f1-08dee9726363
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6498

As part of saving and restoring state of a GICv5-based system,
userspace is required to save/restore the IRS MMIO registers. These
include important information such as guest IST configuration, and in
general KVM needs to present consistent state to the guest.

Provide accessors to read and write the IRS MMIO state. This is
modelled on what is already done for the GICv3 ITS as the idea is
broadly the same.

Where possible, the existing access mechanisms are used, but for some
registers the access is handled a bit differently as they have wider
effects. For example, some writes need to be sanitised to make sure
that the hardware is capable (IST capabilities presented to the guest,
for example). Similar things apply to the SPI config where we block
userspace from setting anything that doesn't match what has been set
already.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       |   1 +
 arch/arm64/kvm/vgic/vgic-irs-v5.c       | 433 +++++++++++++++++++-----
 arch/arm64/kvm/vgic/vgic-kvm-device.c   |  55 ++-
 arch/arm64/kvm/vgic/vgic.h              |   4 +
 tools/arch/arm64/include/uapi/asm/kvm.h |   1 +
 5 files changed, 408 insertions(+), 86 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index d1b2ca317f586..710a0d267347d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 7a068e7db250e..57d504181feff 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -389,12 +389,58 @@ static unsigned long vgic_v5_mmio_read_irs_ist(struct=
 kvm_vcpu *vcpu,
 	return value;
 }
=20
+static void vgic_v5_update_irs_ist_baser(struct vgic_v5_irs *irs,
+					 unsigned long val)
+{
+	irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+		<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+}
+
+static int vgic_v5_write_irs_ist_baser(struct kvm_vcpu *vcpu, unsigned lon=
g val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
+	bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	int rc;
+
+	/* Valid -> Invalid */
+	if (irs->ist_baser.valid && !valid) {
+		/* Make the LPI IST invalid and then ... */
+		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);
+		if (rc)
+			return rc;
+
+		vgic_v5_update_irs_ist_baser(irs, val);
+
+		/*
+		 * ... reflect that in the emulated BASER before freeing the
+		 * host IST. If the free fails, the guest-visible valid bit
+		 * still matches the hardware state.
+		 */
+		return vgic_v5_lpi_ist_free(vcpu->kvm);
+	} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+		if (!vgic_v5_ist_cfgr_valid(irs)) {
+			pr_debug_ratelimited("Guest programmed invalid IRS_IST_CFGR\n");
+			return -EINVAL;
+		}
+
+		rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits);
+		if (rc)
+			return rc;
+	}
+
+	/* Now that we've handled the edges, update the valid bit and addr */
+	vgic_v5_update_irs_ist_baser(irs, val);
+
+	return 0;
+}
+
 static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
 				       unsigned int len, unsigned long val)
 {
 	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
 	const size_t offset =3D addr & (SZ_64K - 1);
-	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
=20
 	switch (offset) {
 	case GICV5_IRS_IST_CFGR:
@@ -409,84 +455,217 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vc=
pu *vcpu, gpa_t addr,
 		}
 		return;
 	case GICV5_IRS_IST_BASER: {
-		bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
-
 		guard(mutex)(&vcpu->kvm->arch.config_lock);
+		vgic_v5_write_irs_ist_baser(vcpu, val);
+		return;
+	}
+	default:
+		return;
+	}
+}
=20
-		/* Valid -> Invalid */
-		if (irs->ist_baser.valid && !valid) {
-			/* Make the LPI IST invalid and then ... */
-			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
-				break;
+static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu =
*vcpu,
+							  gpa_t addr,
+							  unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
=20
-			/*
-			 * ... free the host IST if we successfully marked the
-			 * IST as invalid. Frankly, if we failed to make the
-			 * guest's IST as invalid, we're cooked because it means
-			 * that the IRS may still be using the memory that we
-			 * want to free. Hence, we leave it allocated and skip
-			 * the clearing of valid bit in the baser.
-			 */
-			if (vgic_v5_lpi_ist_free(vcpu->kvm))
-				break;
-		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
-			if (!vgic_v5_ist_cfgr_valid(irs)) {
-				kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
-				break;
-			}
-
-			if (vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits))
-				break;
-		}
+	switch (offset) {
+	case GICV5_IRS_SYNC_STATUSR:
+		return GICV5_IRS_SYNC_STATUSR_IDLE;
+	case GICV5_IRS_SPI_STATUSR:
+		return GICV5_IRS_SPI_STATUSR_IDLE;
+	case GICV5_IRS_PE_STATUSR:
+		return GICV5_IRS_PE_STATUSR_IDLE;
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	default:
+		return 0;
+	}
+}
=20
-		/* Now that we've handled the edges, update the valid bit and addr */
-		irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
-		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
-			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vcpu *vcpu, gpa_t add=
r,
+					  unsigned int len, unsigned long val)
+{
+	struct vgic_dist *vgic =3D &vcpu->kvm->arch.vgic;
+	struct vgic_v5_irs *irs_data =3D vgic->vgic_v5_irs_data;
+	size_t offset =3D addr & (SZ_64K - 1);
=20
-		return;
+	/*
+	 * The following registers are ONLY settable via uaccesses. The guest
+	 * cannot write them!
+	 */
+
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		if (FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val) !=3D
+		    GICV5_IRS_IDR0_INT_DOM_NON_SECURE)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR0_VIRT) ||
+		    (val & GICV5_IRS_IDR0_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_VIRT_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_SETLPI) ||
+		    (val & GICV5_IRS_IDR0_MEC) ||
+		    (val & GICV5_IRS_IDR0_MPAM) ||
+		    (val & GICV5_IRS_IDR0_SWE))
+			return -EINVAL;
+
+		irs_data->idr0.domain =3D FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val);
+		irs_data->idr0.pa_range =3D FIELD_GET(GICV5_IRS_IDR0_PA_RANGE, val);
+		irs_data->idr0.virt =3D !!(val & GICV5_IRS_IDR0_VIRT);
+		irs_data->idr0.setlpi =3D !!(val & GICV5_IRS_IDR0_SETLPI);
+		irs_data->idr0.mec =3D !!(val & GICV5_IRS_IDR0_MEC);
+		irs_data->idr0.mpam =3D !!(val & GICV5_IRS_IDR0_MPAM);
+		irs_data->idr0.swe =3D !!(val & GICV5_IRS_IDR0_SWE);
+		irs_data->idr0.irs_id =3D FIELD_GET(GICV5_IRS_IDR0_IRSID, val);
+		break;
+	case GICV5_IRS_IDR1: {
+		unsigned int iaffid_bits, priority_bits;
+		u8 vpe_id_bits;
+
+		/* Ignore writes to PE_CNT as this is populated from num vcpus */
+		iaffid_bits =3D FIELD_GET(GICV5_IRS_IDR1_IAFFID_BITS, val);
+		priority_bits =3D FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, val);
+
+		/* IAFFID_BITS is derived from the VMTE and encoded as N - 1. */
+		vpe_id_bits =3D vgic_v5_vmte_vpe_id_bits(vcpu);
+		if (iaffid_bits !=3D vpe_id_bits - 1)
+			return -EINVAL;
+
+		if (priority_bits > gicv5_global_data.irs_pri_bits - 1)
+			return -EINVAL;
+
+		irs_data->idr1.priority_bits =3D priority_bits;
+		break;
 	}
+	case GICV5_IRS_IDR2:
+		/* We always support LPIs */
+		if (!(val & GICV5_IRS_IDR2_LPI))
+			return -EINVAL;
+
+		/* We only support LPIs with linear, non-metadata guest ISTs */
+		if (val & GICV5_IRS_IDR2_IST_LEVELS)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR2_ISTMD) ||
+		    FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val))
+			return -EINVAL;
+
+		/* We can't present more bits than we have support for in HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val) > irs_caps.ist_id_bits)
+			return -EINVAL;
+
+		/* Min LPI ID bits must be greater than or equal to the HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) <
+		    irs_caps.min_lpi_id_bits)
+			return -EINVAL;
+
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) >
+		    FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val))
+			return -EINVAL;
+
+		irs_data->idr2.istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val);
+		irs_data->idr2.istmd =3D !!(val & GICV5_IRS_IDR2_ISTMD);
+		irs_data->idr2.ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, val);
+		irs_data->idr2.ist_levels =3D !!(val & GICV5_IRS_IDR2_IST_LEVELS);
+		irs_data->idr2.min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_B=
ITS, val);
+		irs_data->idr2.id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val);
+		break;
+	case GICV5_IRS_IDR5:
+		if (FIELD_GET(GICV5_IRS_IDR5_SPI_RANGE, val) !=3D irs_data->idr5.spi_ran=
ge)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR6:
+		if (FIELD_GET(GICV5_IRS_IDR6_SPI_IRS_RANGE, val) !=3D irs_data->idr6.spi=
_irs_range)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR7:
+		if (FIELD_GET(GICV5_IRS_IDR7_SPI_BASE, val) !=3D irs_data->idr7.spi_base=
)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IST_BASER:
+		vgic_v5_update_irs_ist_baser(irs_data, val);
+		break;
+	case GICV5_IRS_IST_CFGR:
+		irs_data->ist_cfgr.lpi_id_bits =3D FIELD_GET(GICV5_IRS_IST_CFGR_LPI_ID_B=
ITS, val);
+		irs_data->ist_cfgr.l2sz =3D FIELD_GET(GICV5_IRS_IST_CFGR_L2SZ, val);
+		irs_data->ist_cfgr.istsz =3D FIELD_GET(GICV5_IRS_IST_CFGR_ISTSZ, val);
+		irs_data->ist_cfgr.structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
+		break;
+	case GICV5_IRS_CR0:
+		vgic->enabled =3D !!(val & GICV5_IRS_CR0_IRSEN);
+		break;
+	case GICV5_IRS_SPI_CFGR:
+		break;
+	case GICV5_IRS_IIDR:
+		fallthrough;
+	case GICV5_IRS_AIDR:
+		break;
 	default:
-		return;
+		return -EINVAL;
 	}
+
+	return 0;
 }
=20
 static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
 	/*
 	 * This is the IRS_CONFIG_FRAME.
 	 */
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_v5_mmio_write_irs_misc, 4,
-				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_CR0,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_v5_mmio_write_irs_misc, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR1, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SYNC_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit),
@@ -494,35 +673,50 @@ static const struct vgic_register_region vgic_v5_irs_=
registers[] =3D {
 				  vgic_v5_mmio_write_irs_spi, 4,
 				  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
-				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_CFGR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_v5_mmio_write_irs_spi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_STATUSR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR,
+				  vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_PE_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
-				  vgic_v5_mmio_write_irs_ist, 8,
-				  VGIC_ACCESS_64bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
-				  vgic_v5_mmio_write_irs_ist, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
-				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_BASER,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_v5_mmio_write_irs_ist, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 8,
+					  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_CFGR,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_v5_mmio_write_irs_ist, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_STATUSR,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
=20
@@ -755,3 +949,90 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int=
 nr_spis)
=20
 	return 0;
 }
+
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr)
+{
+	const struct vgic_register_region *region;
+	struct vgic_reg_attr reg_attr;
+	struct kvm_vcpu *vcpu;
+	gpa_t addr, offset;
+	int ret, align;
+
+	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu =3D reg_attr.vcpu;
+	addr =3D reg_attr.addr;
+
+	if (attr->group =3D=3D KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS)
+		return vgic_v5_has_cpu_sysregs_attr(vcpu, attr);
+
+	offset =3D attr->attr;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	if (offset & align)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Access the IRS MMIO Regs. Relevant locks have been taken by the calling=
 code.
+ */
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write)
+{
+	const struct vgic_register_region *region;
+	gpa_t addr, offset;
+	unsigned int len;
+	int align, ret =3D 0;
+
+	offset =3D attr->attr;
+
+	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_=
base))
+		return -ENXIO;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	/*
+	 * Although the spec supports upper/lower 32-bit accesses to
+	 * 64-bit IRS registers, the userspace ABI requires 64-bit
+	 * accesses to all 64-bit wide registers. We therefore only
+	 * support 32-bit accesses to 32-bit-wide registers.
+	 */
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	len =3D region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (offset & align)
+		return -EINVAL;
+
+	addr =3D dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base + offset;
+
+	if (is_write) {
+		if (region->uaccess_write)
+			ret =3D region->uaccess_write(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len, *reg);
+		else
+			region->write(kvm_get_vcpu(dev->kvm, 0), addr, len, *reg);
+	} else {
+		if (region->uaccess_read)
+			*reg =3D region->uaccess_read(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len);
+		else
+			*reg =3D region->read(kvm_get_vcpu(dev->kvm, 0), addr, len);
+	}
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 599ab4efc1db5..f1f1fcb08161f 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -786,6 +786,9 @@ int vgic_v5_parse_attr(struct kvm_device *dev, struct k=
vm_device_attr *attr,
 		mpidr_reg =3D VGIC_TO_MPIDR(vgic_mpidr);
 		reg_attr->vcpu =3D kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		reg_attr->vcpu =3D kvm_get_vcpu(dev->kvm, 0);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -831,8 +834,11 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 				    struct kvm_device_attr *attr,
 				    bool is_write)
 {
+	u64 __user *uaddr =3D (u64 __user *)(unsigned long)attr->addr;
 	struct vgic_reg_attr reg_attr;
 	struct kvm_vcpu *vcpu;
+	bool uaccess;
+	u64 val;
 	int ret;
=20
 	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
@@ -841,6 +847,22 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
=20
 	vcpu =3D reg_attr.vcpu;
=20
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		/* Sysregs uaccess is performed by the sysreg handling code */
+		uaccess =3D false;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	default:
+		uaccess =3D true;
+	}
+
+	if (uaccess && is_write) {
+		if (get_user(val, uaddr))
+			return -EFAULT;
+	}
+
 	mutex_lock(&dev->kvm->lock);
=20
 	if (kvm_trylock_all_vcpus(dev->kvm)) {
@@ -864,6 +886,18 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		ret =3D vgic_v5_cpu_sysregs_uaccess(vcpu, attr, is_write);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		/*
+		 * The IRS registers are a mixture of 32-bit and 64-bit
+		 * registers. Internally, we always perform the correctly sized
+		 * access, but the UAPI is defined in such a way that we are
+		 * always provided a __u64 by userspace. When userspace writes,
+		 * the upper 32-bits are ignored for 32-bit accesses, and on a
+		 * read any 32-bit accesses are written back to user memory
+		 * using the full 64-bits.
+		 */
+		ret =3D vgic_v5_irs_attr_regs_access(dev, attr, &val, is_write);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
@@ -874,6 +908,9 @@ static int vgic_v5_attr_regs_access(struct kvm_device *=
dev,
 	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
=20
+	if (!ret && uaccess && !is_write)
+		ret =3D put_user(val, uaddr);
+
 	return ret;
 }
=20
@@ -883,6 +920,8 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -909,6 +948,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -940,16 +981,10 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		return -ENXIO;
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		struct vgic_reg_attr reg_attr;
-		int ret;
-
-		ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
-		if (ret)
-			return ret;
-
-		return vgic_v5_has_cpu_sysregs_attr(reg_attr.vcpu, attr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v5_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4f9ded224d613..7536e9a13086e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -389,6 +389,10 @@ int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write);
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index d1b2ca317f586..710a0d267347d 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
--=20
2.34.1
