Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013058.outbound.protection.outlook.com [40.107.159.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F9F288C2F
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375078; cv=fail; b=fQucqy2mkPyr/kzgjrl3K5jIbhAI3mCBDHQ54ieZk9O6vdHZRWXBYfK9yzr5n76qmX3gu6ykUUsHnw4sxwMjZRkXfGPdIMmkww2qjOW0YL7zJSGzV4vs1ceNHqKL+EJM2asefDkg7m9LbmzEQBNFQxjkG2UzNSO4lhC5hqmSjNQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375078; c=relaxed/simple;
	bh=mjgdCLNkS+aQvq981wPRo8xA76L1v+iwp8tGncgQXZQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F1K/PF52L7+jWOyZ183OU3VNaS36bTZ7fwzh3zY3aMRg5nh2DqGrIPNHo3mgTqAfUgdfejs8DlEPkJ/aLlTyx1PZoLEzDMD7OJk2dBrvcewgG7di6NGSIKrMTlP/vYBqYV/xNjG3R6b2+Oo9Du8/mgXExYH+mwZKekkAQem/0II=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iwB9vo+q; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iwB9vo+q; arc=fail smtp.client-ip=40.107.159.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iwB9vo+q";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iwB9vo+q"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=QDHrfoUgVhiid4i3nQ0Nu7pywelh5cg6/+0aKcLraYbMZNSQHib2hNMp01MD+cyqGMxPFUSFVF994EIVh+ihy/jbKrJCA+v/w8gSI3XNm6CJ5lLUYdDfHjCN+aOFo5C8kSAFhj0VcDptHdUi5WRDKHtwyTyAPkuWu+0v3++gl2T2Wr3im2ne+/CIXon1T43XbdBREQlKrUrQ3LOByhSZ+6JRnN1uOwa6Y1NrjtalkMuWOZrO8cxhEBVwaksglo3PieEnbExTYHYKYDFfgRQ76PxqE0sJhUlYazGH49RQCmm7pZ8T2WrQpesj/UxeF55ShMVIAZZ4FaqEjaYPirvLQA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P276vH9IhV6eqGw57KQrozCC8pa7ytTRfPoSq3+fe5Y=;
 b=EawjU0G5pnccwqxH2ii4+vMn9UB+BRUPUX0HGmBV2TDMi7SPQu8g/2ITJLiRIp5rRJd8swRmBIus1MPEiqztPOmt71MN4h0BjfvD6EdKfOZ8mWk9Uu8RGb5OgmiTIBWHBhfrhpKuFrQ8ncufUBwfnwVquUgmYf3+UlSn3OitwkHIRwKEaeYWvWnH774EVNeqYCOyE/SvxQENeezUoSkHDIYkoWmurW/UOT8aeyqkRNgI8HO1Zy9gIOe4Q0C4jB27qGJEw3G0hqGwz2fWpozQq3pDRl+BiGDr3aCYLhqUIjC15ZmPIv7Hpj8FgES8uj2aZ/TDDeAYqYruj36gLcI/Fw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P276vH9IhV6eqGw57KQrozCC8pa7ytTRfPoSq3+fe5Y=;
 b=iwB9vo+qUKhrM9ZhzB9zyCLytBO6DZ2bdCEPjLMs6knWxoCO6+PgynsJW+NfKzQQqsksqsKa1GIlL2XhU9Jq1pq0iE8Dpu5tcGiEpqUmU8sqIHaSSiQsj1Ed24TNntjY0zdU7Tb/YIAqvflIGoCe5g6Tc5UVW247nIJpBKGwRmc=
Received: from CWLP123CA0088.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:5b::28)
 by AM0PR08MB5410.eurprd08.prod.outlook.com (2603:10a6:208:182::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:51:12 +0000
Received: from AM1PEPF000252DB.eurprd07.prod.outlook.com
 (2603:10a6:401:5b:cafe::c8) by CWLP123CA0088.outlook.office365.com
 (2603:10a6:401:5b::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:51:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DB.mail.protection.outlook.com (10.167.16.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:51:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UhNS6pvoZIN0omaHr3ToX3LQ8Wand2Kz7fpLv00bNnH1wgJJbOYhbKtim6RU5O1OzMw5c+xbXkwGwjgbFpqasOrTfb0o5K+lE/Ao7Hma3neNoP5+gDPI345IwHicOC2V5uanKftnLW9vTXsrhie8S6kVo/JQL+cWfcJ8zdJ405APe1xoC7hbcwAdA6bm+LSY6Z9vPpIFEgUCJSkHbv6kexzEYRVoni3Yo89Pq/98DPxS9NR+RQFsbcb5GP+um2llbCZrixBfZm24lzR5EVM4XzVvVvwrKOyFnICzPHLwxaofVhUJ7lOpEbjNVegRu56DSDTRXSLkpRhxAJHalwU4Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P276vH9IhV6eqGw57KQrozCC8pa7ytTRfPoSq3+fe5Y=;
 b=Y7sKP8ffoFx19gdMgtNx4JLP6fta8GXUZKZ11Hl24aUG8NgcFumOu8TJGnkiMs3uJDdbve8Lsar2ewAofSCHH9VgQ9pQ+ZuiRkRwnhobWcol+9VK+FHsw7Ez5mOcC9VV5Gea/z8wv1lp1n+7LDycZFhZFHWPpPT2xylmU7rBwc2gOc2k3IMYLIf75LYyAAgAcS9OcwL/8jJLI1FWhDyomA+oH4xWR73mxiA4jNErYH3JZpP6uxuW1j/fCTw8qk9NqekubI2YkY1pXl3Lx1n19fge+2ZyCaoM3F4cUjlhOe/ifPQzemGtMAgEWQJtGmXsbLAAQ8mJ4UfIRQ4mzJljbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P276vH9IhV6eqGw57KQrozCC8pa7ytTRfPoSq3+fe5Y=;
 b=iwB9vo+qUKhrM9ZhzB9zyCLytBO6DZ2bdCEPjLMs6knWxoCO6+PgynsJW+NfKzQQqsksqsKa1GIlL2XhU9Jq1pq0iE8Dpu5tcGiEpqUmU8sqIHaSSiQsj1Ed24TNntjY0zdU7Tb/YIAqvflIGoCe5g6Tc5UVW247nIJpBKGwRmc=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:50:09 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:50:09 +0000
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
Subject: [PATCH v2 03/39] irqchip/gic-v5: Setup gic_kvm_info on ACPI hosts
Thread-Topic: [PATCH v2 03/39] irqchip/gic-v5: Setup gic_kvm_info on ACPI
 hosts
Thread-Index: AQHc6TEe+iYHG8M0IEiAkiOjZsvauQ==
Date: Thu, 21 May 2026 14:50:09 +0000
Message-ID: <20260521144846.1899475-4-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|AM1PEPF000252DB:EE_|AM0PR08MB5410:EE_
X-MS-Office365-Filtering-Correlation-Id: 53fbf55e-f67e-418b-bb42-08deb74866a5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|3023799007|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 MDlXjNvXaaqt+VELFp+D3QEJBUcps7UHhgcrfBJqmwWVnem5+R4rJxij2aFScRRDgI8hOoUoNpbd8XxWbaNFdfO9ikphl8zLWEZEqzQY0i48aKeqYRaQE/hPv7w83NuXGSmC2jFy2xsGCvgrp/jiw4j24XVzF5KZKAvSMjIUGclmAtVJ4TKuOYigp0/+eh2g15/vWdJLKluMT0Xn7+jQOiggl8KM8628E9jJTG/kr36qBnlEXE4MSMCqC13Q36ftIER8N03HDZ1oTXEVL6dF/js+mdXOhBoonIJ55Rua/c156Z1lKn+vi5MoGg0uLfCcBaNAWTNeUYm6mFjrGvFakG1+7wDrTAAMMAaOzYEh5lMGqcclLr3+k5a07lBdWOCNv//vp2JL8fF08JusLTgc5a/XBqs286CgvvmQiRTsFi5isih5F4d1sGJSzuA2A1G+xKjdocALcw4PUaDRMqjNqVMv9mjoAvffkiMAPumirN1Fik14eN18smk2jofnQbGiAaXxHO0V0npztrF0ral3mYDDUgOcLWQjCm9uvz8oGZXu8aa7NDodklLmLao42IsSL0E2nSEI46oLoOyIoHdXsDTsi5JZx1rirR/6CGDiebehfVCAiN9e+tFBZMrqb5AuklImm8x0jqz8IoIEBIqLU9F9DbA9mODkcnm5BhGER7zxFa7raaLW6qpPnVQpWVUtncxftrfj4mZYiyKLkbm/RJHVyxuSYG2L1RxBs8TaCj8Wyl03DVTPvqdvNlnRo9f7
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(3023799007)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 JbwcQViE3RnyExyvHc4kWNyxW5aeTimUzORf8gGhCVaU1iaV7rl4Fn2AmEbfjT6B6buiLkVsOsr2qLh0Cb3IXUrP2NxKJBTmdVndOiRG/IbtqP3jzl6+YiGKCTsMB01lFCo/sRIP93BREtST4Z+h58C9K/ZG+ecUijBE6Jamc3rJPwgcRaSYnVYoxYz39G33IOJbsRjby2O0RmO4lnXZeSNT4g6iCgAtBNrCLpKop1lVaYH3A/+9HQ5emOcTQvGT5IZRo12hinbq8D4IUOc0Yydsbs6VBQFDBnqHDMgq2PcFVG/WARAbfOfaJaWP1cB0LPijxw1BvHnW0W9Rrkz5LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b8e74ca8-d830-4127-8763-08deb7484153
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|36860700016|82310400026|376014|18002099003|56012099003|22082099003|3023799007|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	gq3PNdadeqXnI19/3XRiz83dJ6QJTOxp4Bgt8jnKgqGotit5G6nZ6h85V6ERIS37XUT5m/tdbDv/g2O52d5U5l6LywrFaMbrj0K589IxRPNqGf/o+HOCPTubReM6U1tDvV5F8DzqxcPNx9yk5UTAUeYY7/krkrXe6nP5nPv4ywFT6CnAHSN/AztTgQdUfz2RUW7ujkcQg4XZAgNPUeVtMIBEeFmewiFIAevT7V1GFBeStOhlJgn3sweZ5gFdrsrR5e4zDX3KvHN+6KlWFEMg4yHurO1ad5AyGObx7GjSdOYcpRR1CwSSVYpD1sQDZy8SX+muG8LdOxvoToB9qLvZA9ONWIutWJCZnl8HGVpecYlpbqh7rIzF1pkhLlbkXTOWGMbmN7Yb84RKefUMGWky6HJc88fNIk7dHJ9rW3pN41bQYHCSiVqggSmeA8BlZagGiZUa1akYJleOy1LUdMG7BhWZ6cdhkJQlk8AXtwtBay6Itrnrqubv+uhLrHaPHKkJ54Y0fJ1pwhn2ijdhnEkhpTLkJiYmvgxQ6qQONJbXiKVcfBLtOwNvNX8C9CUTZwR/xwJyygyR7QiGthU3K1UiPN+k/Gj5HLx0jlCgWJYjVtd6yPemspLuvx7wzWGZVhjMfSXrhq7fcRKwcII/lKWmfIvaAJxRMWfVmuSHSnm67u6IV8T80lkFBRSTj00zLTbN0oP3HyoUU5eD9Atg3GWbYRVSeOg/zIKvFBhP2KR4KDU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(36860700016)(82310400026)(376014)(18002099003)(56012099003)(22082099003)(3023799007)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QU+QpKGh20NgXrlyy6AhN8O06m4s+ZRMAm2lQIWq2trfeJ6GDFRj8nQWqVEhmf5SIVxmJFMc7yMtybrI8F4yfA/a58KJKuy/KNz4LJTu5u5qLod0s1Z+IKTioPWdm9ixBSZPBFcQK5MVJiXY5OL+k3hW7AcMora5uTQyVRNVyqojsLV+PtEZjZA+7elCo1E2RFpjTeaPqXKXPMrYVL8vhxfJ5A+Vp2R349Slr3CqLi6CVcRWPwn67Ashwv54z8h3nsbafwMAVfhvuLHnj6mhai7nsq9JJztHl2gKPrUIlKJerIcC4B+jFntUekMo/SjVm0j/YeFCacBc4E0JKgPUyc5sTcIxYQc+HePJtjejiy1Pb2VWi+VigqoN4jokAKDFoVPNcgvKDx5XsMGNOIzXpPqQq0Z00jAfwc7S3RICgIPkMeTIAdbO0pqOPbF3KHHZ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:51:11.9834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53fbf55e-f67e-418b-bb42-08deb74866a5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5410

Device-tree based GICv5 probing already passes the IRS details and
maintenance interrupt to KVM, but the ACPI path only initialises the
irqchip and installs the ACPI IRQ model. As a result, KVM never sees
the GICv5 host information required to probe the vGIC on ACPI systems.

Add the ACPI equivalent of the DT KVM setup. Parse the MADT GICC
entries for the maintenance interrupt, require all relevant entries to
agree, register the interrupt as a GICv5 PPI-encoded GSI, and pass the
resulting IRQ together with the IRS base and coherency information to
KVM. Native GICv5 does not require a maintenance interrupt unless the
legacy GICv3-compatible CPU interface is present, so preserve the
existing no-maintenance-IRQ handling for that case.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 103 +++++++++++++++++++++++++++++++++--
 1 file changed, 98 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 707deabbf2f63..ccd1ec69a6ab2 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1126,7 +1126,7 @@ static void gicv5_set_cpuif_idbits(void)
 #ifdef CONFIG_KVM
 static struct gic_kvm_info gic_v5_kvm_info __initdata;
=20
-static void __init gic_of_setup_kvm_info(struct device_node *node)
+static void __init gic_setup_kvm_info(unsigned int maint_irq)
 {
 	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
=20
@@ -1140,13 +1140,14 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 		return;
 	}
=20
-	gic_v5_kvm_info.type =3D GIC_V5;
+	if (WARN_ON(!irs_data))
+		return;
=20
+	gic_v5_kvm_info.type =3D GIC_V5;
 	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
 	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLAGS=
_NON_COHERENT);
-
-	/* GIC Virtual CPU interface maintenance interrupt */
-	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
+	gic_v5_kvm_info.maint_irq =3D maint_irq;
+	gic_v5_kvm_info.no_maint_irq_mask =3D false;
=20
 	/*
 	 * We require an MI if we have legacy support, but don't, otherwise.
@@ -1162,10 +1163,101 @@ static void __init gic_of_setup_kvm_info(struct de=
vice_node *node)
=20
 	vgic_set_kvm_info(&gic_v5_kvm_info);
 }
+
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+	/* GIC Virtual CPU interface maintenance interrupt */
+	gic_setup_kvm_info(irq_of_parse_and_map(node, 0));
+}
+
+#ifdef CONFIG_ACPI
+struct gicv5_acpi_kvm_info {
+	u32 maint_irq;
+	int maint_irq_mode;
+};
+
+static struct gicv5_acpi_kvm_info acpi_v5_kvm_info __initdata;
+
+static int __init gic_acpi_parse_virt_madt_gicc(union acpi_subtable_header=
s *header,
+						const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *gicc =3D
+		(struct acpi_madt_generic_interrupt *)header;
+	static int first_madt =3D true;
+	int maint_irq_mode;
+
+	if (!(gicc->flags &
+	      (ACPI_MADT_ENABLED | ACPI_MADT_GICC_ONLINE_CAPABLE)))
+		return 0;
+
+	maint_irq_mode =3D (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
+			 ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
+
+	if (first_madt) {
+		first_madt =3D false;
+
+		acpi_v5_kvm_info.maint_irq =3D gicc->vgic_interrupt;
+		acpi_v5_kvm_info.maint_irq_mode =3D maint_irq_mode;
+		return 0;
+	}
+
+	/* The maintenance interrupt must be the same for every GICC entry. */
+	if (acpi_v5_kvm_info.maint_irq !=3D gicc->vgic_interrupt ||
+	    acpi_v5_kvm_info.maint_irq_mode !=3D maint_irq_mode)
+		return -EINVAL;
+
+	return 0;
+}
+
+static bool __init gic_acpi_collect_virt_info(void)
+{
+	int count;
+
+	acpi_v5_kvm_info.maint_irq =3D 0;
+	acpi_v5_kvm_info.maint_irq_mode =3D 0;
+
+	count =3D acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				      gic_acpi_parse_virt_madt_gicc, 0);
+
+	return count > 0;
+}
+
+static void __init gic_acpi_setup_kvm_info(void)
+{
+	unsigned int maint_irq =3D 0;
+	int irq;
+
+	if (!gic_acpi_collect_virt_info()) {
+		pr_warn("Unable to get hardware information used for virtualization\n");
+		return;
+	}
+
+	if (acpi_v5_kvm_info.maint_irq) {
+		u32 gsi =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI) |
+			  FIELD_PREP(GICV5_HWIRQ_ID, acpi_v5_kvm_info.maint_irq);
+
+		irq =3D acpi_register_gsi(NULL, gsi,
+					acpi_v5_kvm_info.maint_irq_mode,
+					ACPI_ACTIVE_HIGH);
+		if (irq <=3D 0)
+			return;
+
+		maint_irq =3D irq;
+	}
+
+	gic_setup_kvm_info(maint_irq);
+}
+#endif
 #else
 static inline void __init gic_of_setup_kvm_info(struct device_node *node)
 {
 }
+
+#ifdef CONFIG_ACPI
+static inline void __init gic_acpi_setup_kvm_info(void)
+{
+}
+#endif
 #endif // CONFIG_KVM
=20
 static int __init gicv5_init_common(struct fwnode_handle *parent_domain)
@@ -1264,6 +1356,7 @@ static int __init gic_acpi_init(union acpi_subtable_h=
eaders *header, const unsig
 		goto out_irs;
=20
 	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC_V5, gic_v5_get_gsi_domain_id);
+	gic_acpi_setup_kvm_info();
=20
 	return 0;
=20
--=20
2.34.1
