Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011033.outbound.protection.outlook.com [52.101.65.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC023AFB11;
	Mon,  8 Jun 2026 09:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780911784; cv=fail; b=IFI90ja4IZX94pfgl1IBOqt6G7fTVcMRlMuMMywSbF6PKzaSKyjWVaVK/QObbuylXFlFR0pTVOzjpgtq4lNKfDFMQ8RVmepZ8cpkckgja8BpESZa/mykt8glvk75KE8oh9YVOSdNSMZcUZ7FmUlI2RUzxzAsAMBVPb95nHuw4po=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780911784; c=relaxed/simple;
	bh=JyWXfcAh1GE65se3x7HflZ6ewdWvhKPJGg/9WO8chZA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hpdfdaP0ZaCFdHOvZQMNAqopYNBYuftTmooKljZIj3TVQhPCU8WT9L9Cy5x+lnpLbJa0IRQXnmm+1kHJn9tjouj1kTkGKDHvSTxi2Iz1HhU9zlc7hIaSuds1QdukdpCjJ1403oFvn+EI4BGb2ftTBo9XJ5r8mow0jt2fzFhWwW4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Foayqdja; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Foayqdja; arc=fail smtp.client-ip=52.101.65.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Foayqdja";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Foayqdja"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JtxCcByXIHEk6ioI1wDMPvYgaI7TIi+UIL574XPXl10e70tIy0oVHp2I+DzJhW1eyJuwH22AiBur77uYAiPmyETvML+rinvlq4eNKF1LRT9SBSGhKhQI72H36wLbQhBYpH8dqRA7OR09X1GTdV5Nm3Q/OCRVwjgmkwgOfE+gwDqiSPpc3Ic1ZW8RK8Jnci0rGzklAJ9008RL6jkV/QluVoidJPInyKZu1Ak3fiZXLymmG9MTBAQeHQVpYwnm8zOazUZypTqdTm35H+RllBbiXfq7sn5P3zw2hbvNkEqEJN8LaVC72E7H9rN4LHoE/oNiiuQ8LIwdJZebxknvbwvnNA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCNBeIBkpn6UT4+PIgk+xjWkTbjyGczmH4YzzZub104=;
 b=c6dq6DOz2aoODHVmfcek7wUCjiHY8I3zuobQfRMYl5Ru/I8u9uXhoKmggw0tmBlRRPq0g8SX6pYbrVxmjYdIvsE6bdJPqsri5/DwYbSCx/UVn80eOoHnmfHSoCNqjRCSmg7vDOaNDf+AugJ2AwLBrO9KEe4WRg6eBiqRIMp023BYBWGks6f8H3jhRlioguzOPANDzFUL4Vb07QYQ4tNCv3Cn+Gm0+eS0cI1UpeFUGZVrYDKkWz9gJjWlG0PDgcg4DvzMOVZOhaoTQGHRzmMbf6TMiA+myegHmiS1/x2E9CtqlJsCgo94uzmXlaMdNghEyCUUhgEogS0UhOeV93f7cg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCNBeIBkpn6UT4+PIgk+xjWkTbjyGczmH4YzzZub104=;
 b=Foayqdja0X/CZw/kVm/a4w8xEBRTT/J7muFxf/eJQZ530lL2MODsdKQqRuUZmllHEFkuy+1URJr9M3OlSJrCeORR7WrMoRvGUTsNIFyWv0v5Qq4/jMJth+YTQo9W0EJk/3NU6LK5JCFl5UUCJcfmip0EWO/RYxmxpVOrHJ5PCvg=
Received: from CWLP265CA0419.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1b6::14)
 by DU2PR08MB10132.eurprd08.prod.outlook.com (2603:10a6:10:49a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 09:42:53 +0000
Received: from AMS0EPF000001AC.eurprd05.prod.outlook.com
 (2603:10a6:400:1b6:cafe::d) by CWLP265CA0419.outlook.office365.com
 (2603:10a6:400:1b6::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.12 via Frontend Transport; Mon, 8
 Jun 2026 09:42:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AC.mail.protection.outlook.com (10.167.16.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.7
 via Frontend Transport; Mon, 8 Jun 2026 09:42:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5s++dTbnqk5gabcqqFSM6xbNrn7CNEidPfjMbndA4eP0GnpeUMDaSi/uNePHms/7Y3F2+IKj0EJl4WPxwX2zZjj0U/jM8IvC8kW2CpQ82SUV+/3/H6jB5z7BQ4A5eBLg9q/wIhQ3YktRgeD2ekM2RompRNzJvpLR99MLvXK9mj0OaQlMKDkYK9f9jCAtM1426L0SSVcTlAYEfJI0D3CiTet1Yh2hd2EY7noi3RBgL+V66zy14jNjIbJNUS/Cq8Ntpi58w4u9gSIi3nLH3Kq29dU4V5dWygUvXeWh4dz9IRaafYCI4VJwRi2EaifbO4WaqG+0hGl06zsRg+Gb6cLBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCNBeIBkpn6UT4+PIgk+xjWkTbjyGczmH4YzzZub104=;
 b=OVERTzP/ggUe2Jce1VZmN734iZbQVHjKQrE9PptF6PkaBD8qp6AeAr/x+VK09Hwk6lRF79gwP70lKetQHdpLLi2HKhskN42I6qM877GOiLDDlikv6YWKkkYm163hMs0O1587tgFpWLNdI717wMetg7oBjNxm6XB4OK8C+HaSsC2mxsKpqVw9dhp4vWI8bUpbB2YAfvMI3Iq2luX2maOW1G42MSG7dAZ9//GdLQdC1lgPwlQ0V+XszweAd+h+/0fTf8hEuc66gry7wDpYeLa92DJ9ETy0KXvLXM3Ex650wU80DagLmjOztoo92bNZNjibKEph5+boDJ8M1OipuG9ZLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCNBeIBkpn6UT4+PIgk+xjWkTbjyGczmH4YzzZub104=;
 b=Foayqdja0X/CZw/kVm/a4w8xEBRTT/J7muFxf/eJQZ530lL2MODsdKQqRuUZmllHEFkuy+1URJr9M3OlSJrCeORR7WrMoRvGUTsNIFyWv0v5Qq4/jMJth+YTQo9W0EJk/3NU6LK5JCFl5UUCJcfmip0EWO/RYxmxpVOrHJ5PCvg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by DB9PR08MB8458.eurprd08.prod.outlook.com (2603:10a6:10:3d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 09:41:48 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 09:41:48 +0000
Message-ID: <ad45c64c-18ab-4d42-9813-0ac1704bb127@arm.com>
Date: Mon, 8 Jun 2026 10:41:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 26/44] arm64: RMI: Allow populating initial contents
To: Steven Price <steven.price@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-27-steven.price@arm.com>
 <ea4be6c5-9506-4253-80c5-c76c9ac3b77d@redhat.com>
 <0c71b4b8-ad0b-4a24-9f4a-180b2aaacdb6@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <0c71b4b8-ad0b-4a24-9f4a-180b2aaacdb6@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0288.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:370::14) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|DB9PR08MB8458:EE_|AMS0EPF000001AC:EE_|DU2PR08MB10132:EE_
X-MS-Office365-Filtering-Correlation-Id: 813b16d4-c25e-49b0-f04a-08dec5424f9a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|6133799003|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 R1+lzmWhSdu9LZuW4sq+nmx/WI7ylvd2fAwc0Z4RCEAByY5iWm+RlzqaSUHrJZL0UqEzOosdxsn2xTZamhP5Y20xW1kO0XxZ2rSckWYgsEhTG9OXZhriqbh6R7wJ9bGNdczndMLMnOcHZjsval/ZIa3Bz14fqtdxAxn7eZcp1YOXXXj6FBA8rGrKsarDGUaqM80x9QKqKFt2nP37cDBlTwy1zd0rNyTIoZmrH02P0FEF1CBvR1bVg/kRm2Z7ogjlY4QadN15rNBDVcifxoyBWppQleDw3CkvGFBjzPYVnQY34jfTFTjsEglN/n7LENaBatPmSg80TwWzsRFgeP8122eNhZOnW1hsJ0fijMRC3ZpMHbGDihltDHlFJ6Nms4YROe4mSJ76EW4rUzeUd8j13Tpqgwg7Njh7getAmLY3zXofGjOtAQoBW5l/cMbc8mya6UeFUVF/uArSxEdCEA/PKpcZWTSEeThqlKc1HO9mYe6HU6P+r1+CDQX2R9Gzo17PohZAboEQgJgvsC4xeBsIO9aU4dvXzlCz78l18X+sU8j9oNXSKsX1nxO8ABCn8zj1IKlRxA316IhOzB2Ih25KaSjkrk3YorW6pcdZRpzQViWcdfvvs+1inmEhVi6Ycb+tA56JcGTNc/5APJGgbhKlbCJlkHRUjdO0A/OKHtyxAoZ70RQggq2QtN4hcjcwzTcC
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 jbJlIWq7Tti1HMTFP39HDYS6ESYREthIZMUwsK5mRAcZZyHmsx5rYlSz0ty+zxr70W4mcNJX3iJgML7Y+ltu4C2hGazhg+9gB49+28wX0v64bG+6HujEoLmUFh9JQ1o0XYXc9eJFCcFx26GEwGOUAPGqXuYnrXU95zRxRjl4djZyTZfbQOxVfgBE7wHsAtdeDxZhcAOx5kJSuYDqjGBX9pQw9piRJnQC7xYf+XoTHMfU8sA/LEFtrdwF5rh+wdt4FPng9HnmuxfguZnWe8GSBNeyH2odvAGlIohw5N43jPvVuxThUcNCjHkE2vZwt11t4B4kBlc4VgYu89S5sgmHmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8458
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	11c9c916-76af-4196-dcc8-08dec5422968
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|82310400026|376014|7416014|1800799024|14060799003|18002099003|22082099003|6133799003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	3WCqOnCLr9cjhUQ83RCcZPKkQsxp05YmpR03CKrg8Zf9MoEhvgAPSlw8fxZfvoTM85VlO5FbQM25I3v43rt+UK9b5F9O8truVgA1n/DwiCat4j4g4fZHJt2LwBAlK9TuXwGFRjjQShhTEsmBoX1vY7Xacu8q55NRrpQ97+ezaW1mNCut1GQLFi4bbZbxVQyUp/aW1NzkJ9+E1YS1lpNeb1hkaTtTnRswmBKoDMepOL8Mw3JQPFAUPjJATKgjoeoZYJFn+oeBJr8UbwbiEUDyi0WvM5rd37b7OGafKb/nuAoXPnN0F4wVqgnRge8hMb8vywNqXOQm1U2HN4AUg8u/C+Vtd6Ta1SY8cOEphHjrtbDeC/XsPid35V6OnchiDYqDkPuWlkyrycmMpw0PvoW7mdAAkJCRiE4hJRGQFKOS1a56kkAcqylt35YnOSsmNpYhHnHXB0KVYyAu2RZw59q7KmnwhTBe7SnkN4BcjCC8MYLmA3PuZQiHcqk/FFbkqgnPz5lJJVrCHtPXNkGMPT1CaEGzchAp/bJ+RY/vXtRS+tpKL5BdK/tZmTMSs0y8LNFvDcVk54D1tb6+hH5lLvTBq4ardQ9J0c0XpZbeSxQnBpzD6Um2M06whRpg4wc0CDRwSNalfajdgNMIraLoJqLdh06LanXKQa8KXIeCJHuBcLocZcPfun6lBxAw77LG7wTJ7dLhVmlqUq4sPAAldLuGmiDf/PO0gDBCWh9kHPji/FE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(82310400026)(376014)(7416014)(1800799024)(14060799003)(18002099003)(22082099003)(6133799003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UEK1iCP2nr+/C2ZYltC1CCi7LUYCqK3OWdaOGG24uIR10400bLEb9Bwh6BBN75eWKF5QprwN8ZiiqpHc/ciYF2N/LWIkBFu9y7j6zhxXNEZoXbthp0WE6FXo+Fd54F6QjgGPSI7Vq4TQQtVMqruScu+Add2ZWd/okfjxx1RZGMUVMdsj3Bu0mH/sr9PzqC1LYU8QgQzYw9Bb3xUnA/ydZOQYTxqDaUqodnafoflDb4wvAQMGghYdCW6+v7DN+VJsPlVB6LNLepmwb9DUlQ4s0Vme5qF7UH6NWCeBsOLBi5ZW8m1c6PMj017RuiFoTAutcz3ETSfiqDWVBWMoULApI3v1BjmrmvsXsWtIiQkEl9JyJfhilC/Xs1Y4j2x+L4Zaz5j7nOSNHpIqI3br7P/SZqGputBwruKo0Ev/BcQB7P4WF+ild0tHpSQSt+UkaTCe
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 09:42:52.4388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 813b16d4-c25e-49b0-f04a-08dec5424f9a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10132

On 08/06/2026 10:36, Steven Price wrote:
> On 28/05/2026 06:30, Gavin Shan wrote:
>> Hi Steve,
>>
>> On 5/13/26 11:17 PM, Steven Price wrote:
>>> The VMM needs to populate the realm with some data before starting (e.g.
>>> a kernel and initrd). This is measured by the RMM and used as part of
>>> the attestation later on.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>

...

>>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>>> index a89873a5eb77..209087bcf399 100644
>>> --- a/arch/arm64/kvm/rmi.c
>>> +++ b/arch/arm64/kvm/rmi.c
>>> @@ -486,6 +486,75 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>>> unsigned long start,
>>>            realm_unmap_private_range(kvm, start, end, may_block);
>>>    }
>>>    +static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
>>> +                   kvm_pfn_t dst_pfn, kvm_pfn_t src_pfn,
>>> +                   unsigned long flags)
>>> +{
>>> +    struct realm *realm = &kvm->arch.realm;
>>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>>> +    phys_addr_t dst_phys, src_phys;
>>> +    int ret;
>>> +
>>> +    dst_phys = __pfn_to_phys(dst_pfn);
>>> +    src_phys = __pfn_to_phys(src_pfn);
>>> +
>>> +    if (rmi_delegate_page(dst_phys))
>>> +        return -ENXIO;
>>> +
>>> +    ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
>>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>>> +        /* Create missing RTTs and retry */
>>> +        int level = RMI_RETURN_INDEX(ret);
>>> +
>>> +        KVM_BUG_ON(level == KVM_PGTABLE_LAST_LEVEL, kvm);
>>
>>          KVM_BUG_ON(level >= KVM_PGTABLE_LAST_LEVEL, kvm);
> 
> Ack.
> 

Thinking more about this, I guess a buggy VMM can trigger this
by populating twice ? (level == KVM_PGTABLE_LAST_LEVEL). So, we should
return the error back, than warning here and suppressing the error ?


Suzuki
