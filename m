Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013010.outbound.protection.outlook.com [52.101.83.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30A431D38A
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 09:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758619770; cv=fail; b=oYEEKWpFUdQXhWQiYsuBJa7siqHlsai6CHH/kgWptvIND0LcW8tGCAn34hvNsvxSPSzxOKrqm7R24P3rbdvmHpvvphAYzTQGSuqY3tLPDXlBzoam9rhFevYNE/YxPhQu0soCDxP14k9jLpcXFpXFc3gfYd56aL0EmrYzthukYIU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758619770; c=relaxed/simple;
	bh=RjkCHvyKik1K2CT2Ck6WIi3CyUUxXPKoj6xyT2AZJU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rqyRRisfscq7RWh48/mU+N6YKA6sI7VnwV8hGMmf6m3okF7R1RS1QNU+Rf3CA7aZpbdbv6k+/u92W+NVAsgksDDCEYmfkottpPQGefxXRD+KT2DRn57xfymGkuARlP0khfHUfVB3AVj5dugE8uxZNmtfdPMGU+7yfhxHX3Xgn5s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h2TX27c2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h2TX27c2; arc=fail smtp.client-ip=52.101.83.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h2TX27c2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h2TX27c2"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wVqc4SiNe7a4vpudCmKIVlekH7e1s7/O1jvulw+8bXaxh+iJ0DwNh2/ghMcwRTtFGhbKGiKxRJoeZDmYUpk3E/IpdIrUG+fE7akzZCix2Zv/Cf5bPn+Cxs8AfPiRnAyZQEAR304AJPJYJkIPZ7Xb6ef4WmuyDoNDxWnQEgKaV4vD7HEFG5lk/Musg0EJV2yWS1CpZBe0DB0L9XKl/cFaiffRTZIjoFs1oLRog+CRl0yanJB4X/CtPuJ2akaoa1GXBgCY0/3RVVvNRr/Es1uVEe/j1KCxGoBudJhLdd6xCZGoXPzuzxEOfq+lnUJ6xQXN9wo+/xkiFF1a6HHMHrv70A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l746rh/SlgZrcXRfdVEHLOFTwTshdET+RUv9wsIEaRs=;
 b=hrrb/2SlTNIp5Xpw6nADDl6BEsRaKwFo5BtkZG7gzeAgBKW4Ik5l2ohdlmUAjhkXXbc531C5O8P2dNutLOvLd91ed4mNVzBZBw0WwqbTC7biALzlKtfAMqr70KajQQ2P7Z5ddl4+bg+Dz+guAJmjXs8E9658OVr48iTGXWAnfpP7mjzhYsI1lKvvZpZ5aAWhdIPCRHajBUlJfdWLNZRVChU31nUIHxL1UoYzl6UMDhk0TwKW4Yh0K+7AHgHO+35VOtliymsgRz8mqXgXi4oI1KIMIjRaDKOXJ/lPcLgnCqYH2t/MMGWzliiLbabrZ9/NzIzuHpXtedlQcS9YmsyfXg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l746rh/SlgZrcXRfdVEHLOFTwTshdET+RUv9wsIEaRs=;
 b=h2TX27c2xVICTsKzFDt9KyKGApIjI+MWBTwKIUg79erFKri/inlKDK3T9hd6lpTthhRXSYQpLcQ6CaNjKf5UGgoskng/cHvqBq0i9LLNYYsqznSZcujVGf97Mkd6nhSEG4Qhf0ndegAXz5u9U9rU7CMprq4KBFCsS9YHzyxOTes=
Received: from PA7P264CA0092.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:348::17)
 by DB8PR08MB5515.eurprd08.prod.outlook.com (2603:10a6:10:11f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 09:29:20 +0000
Received: from AM4PEPF00025F97.EURPRD83.prod.outlook.com
 (2603:10a6:102:348:cafe::44) by PA7P264CA0092.outlook.office365.com
 (2603:10a6:102:348::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.21 via Frontend Transport; Tue,
 23 Sep 2025 09:29:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F97.mail.protection.outlook.com (10.167.16.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.0 via
 Frontend Transport; Tue, 23 Sep 2025 09:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Spt0QpqGbOzDpFKmxB0wEZMQN12n6GL8l8ZpR4fYeOfCTUIOZMOBkgbVNpxuZ44k659fJy51q0zPVMfVi60i5TBPTGEdqegYPLJNwi8eHBt4f9C/39eHdrioDNDSqYbYRN5sOYYazFAqkCEXxRBglkpONdGGY2STOCoEOZz3vK4JKTipPQsqIUIiKK9Aeadq/rOSKwZj97v4bMBUxcfOzOV3/x4LXSPGVkrwFSK2CM9oHfEoh8nWpW/liSwy6E0U+CFOnT5vtEp8uMIkaLTDYhJMPQh/LPUjz6GzO+cIPlpgK5AaD75FrmeDcHg+9izm6goQZLywXqOSDgQejsfVtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l746rh/SlgZrcXRfdVEHLOFTwTshdET+RUv9wsIEaRs=;
 b=GP7pWLjraFzneXiGVlKLHMbS1i6tQNXwtGQIYl8xBetMGYIvOfWgcLDsiMR4jEvgvZ7J7j/gzlHwCWd3leyFydCzrpQ7sKwMihdRZZSTEItxqRXSWRCQ8tLWJtU5XSo20+5x9ssqHHesSo/v0j/aRvr215mYWB8kJBEemgQhzKw7muGwU+lQ7apQwH9UCz5KeDhKvKwEjcnnLrZ53KAOCXDqC8sYSeD2QAt/uSiKGrbHZkD8nh24ceGqj5wxjrVRSAIfFYa/orofIMS60Nz5lIgN9K+X40MqPwNEUNm3U4++VPHSktg0NKu7tL/3ISa6CafDaP+sfg13ENAaryzvdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l746rh/SlgZrcXRfdVEHLOFTwTshdET+RUv9wsIEaRs=;
 b=h2TX27c2xVICTsKzFDt9KyKGApIjI+MWBTwKIUg79erFKri/inlKDK3T9hd6lpTthhRXSYQpLcQ6CaNjKf5UGgoskng/cHvqBq0i9LLNYYsqznSZcujVGf97Mkd6nhSEG4Qhf0ndegAXz5u9U9rU7CMprq4KBFCsS9YHzyxOTes=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DBBPR08MB6298.eurprd08.prod.outlook.com
 (2603:10a6:10:1f7::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 09:28:48 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 09:28:47 +0000
Date: Tue, 23 Sep 2025 10:28:44 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/5] KVM: arm64: expose FEAT_LSUI to guest
Message-ID: <aNJoTKuQ5MuYZQ0Q@e129823.arm.com>
References: <20250922102244.2068414-1-yeoreum.yun@arm.com>
 <20250922102244.2068414-3-yeoreum.yun@arm.com>
 <aNEkNF8rvb_e9DKd@finisterre.sirena.org.uk>
 <aNFiAZVT+XDCBX4r@e129823.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNFiAZVT+XDCBX4r@e129823.arm.com>
X-ClientProxiedBy: LO4P123CA0590.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::6) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DBBPR08MB6298:EE_|AM4PEPF00025F97:EE_|DB8PR08MB5515:EE_
X-MS-Office365-Filtering-Correlation-Id: 42b21c64-30d7-48e2-6fd7-08ddfa83acd3
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?+FfNbTlnBnwh4rqNPozICmWVbtLcf61HVSVAF2w7ELefw5QKT0WVrMZbeJIH?=
 =?us-ascii?Q?ZoRJ/Q5eWPjAu7nxOtaOwlPeMnUhSIw8Tp+6kEcOFsBLYJ1g0iOdGzTDKT2g?=
 =?us-ascii?Q?l1gw76JlmA4XmyatUb/vIt4+/AMv7/uR+6Q1MzoH8b3gNGYIa64RKVnpQqvq?=
 =?us-ascii?Q?HPzr5VSodS6LIEaEhz2hLXch3IMsR8E3fAL8ef6gmO8gE0zmeFFzxwfncVm4?=
 =?us-ascii?Q?pKS2MMX7BOJ2ZBWxgs+NSZ7tqgyrUpHXf0RUcUppRzulPWCTL5uyjoxd+CUY?=
 =?us-ascii?Q?lFlrHg29GoBetzWjZ+e6SiHjLD8MyrKnrMWEEPvQa94sR3MmYP1EcGL6fDuo?=
 =?us-ascii?Q?4BJt5DMinRTEZ1ONkEvduCHGXim3O+NR3NYireUYH6fBoWdSDqd7INxWL6pb?=
 =?us-ascii?Q?YAc45zM22AxYK8Wh6Szzhd23zwUE27tHTj2wT2ppHL9M3lelsJ8P4tcfIiBw?=
 =?us-ascii?Q?0XLBw7lGxSlGvW8SsJFVE+se6x+K3B8A9OcPk+9iiP8+4c9ux9WJOGzJxEMj?=
 =?us-ascii?Q?B101oKMi0d+qqPzx3xUzF8Jfjx+9IXFGytIbM0uwFXZImhKPlanZJFNG2x4K?=
 =?us-ascii?Q?7iDUvUZqUWeOvfeFvq1CtbchXoCUzkFOIwiyrsiGeMTGlCp2V8e4Dh2WQ9Wy?=
 =?us-ascii?Q?Ji7Bc+QoV8yHnFB8ZwKWmLMz8KqAyGsCsyNkyyuGwy3hyPvUdMdkvz2AqDk1?=
 =?us-ascii?Q?WxkOnL2+4vDlo06u2FRMCLa8/T7LWgGJoSVEkhQ//6kZA/ymUCgj3xT0Tjsn?=
 =?us-ascii?Q?aG+xNizghp3CAVQYYsnNW5iCXcCCaQ6p4XINulO0KdEE1l6eRaalvXT5Wi0p?=
 =?us-ascii?Q?rUV+B02y4XXltEgS/XhDnN0P1WxcmT8MU3ycKpUof1meUXZkI56qqIFgd+eT?=
 =?us-ascii?Q?gEQ2cFRNR0K0MOIhDiT3ma3PTllLe3aaBzREdJRS3X+Bf4if2PePQ1qpJuay?=
 =?us-ascii?Q?2daByG0b/zIdXphui/24Nfi0t0Xy+YsuJ5WQPvlFX7+qZ7EmpPNToOTSSy6p?=
 =?us-ascii?Q?r6wZn3BIH2LlXDVO2wxmzOMbaJUAiFj9ZX6qgbmZoWIHQNGhn7PJqyC5PQ7N?=
 =?us-ascii?Q?KBoM+n88v+bRAli/OjJwcTVVS+fnlhLmCYSUgOi9iBDH4w2ZQtaqcGcGxvv/?=
 =?us-ascii?Q?q+AhMlqMC30Jojbm60gVYkHl4ip7r7dyGtPNPZLx7jJnRg9l+xw3kmHmOkBU?=
 =?us-ascii?Q?18eGWOOAbQQD5IAtDaz2s6j3I238Usralfsv8sVdwhF0lGZKMAIk2l1XNvPp?=
 =?us-ascii?Q?YOZGSGj3PhjpgqJ4Hmu8Wwn+LdRSBtNkZp+VgQeHG/A7J0pnZ947WT52uF+H?=
 =?us-ascii?Q?jqAtEk6lQ3N77FVL34YLGPudr8LXPTDM4Y+LhpZoqyKscjxW9ypGnVkDBv40?=
 =?us-ascii?Q?cNGc4Kwa935AXO8rJRNfHYM7xPgE7vsr5zP8B1xZdwQ6H7H95w=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6298
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0f12f64c-d8d1-46fe-3bcf-08ddfa839905
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|14060799003|82310400026|7416014|376014|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CtBOxrekdlq/9+wWBljOwg0Jep0cgEW6/CzKLdq+hmVmGgJZZYVrr6iTfHkl?=
 =?us-ascii?Q?UuiI9fg57Tni05hiEC5BotogW5r3lw70Lw5KxOffTZhe+20/IUQB6xFDIIIA?=
 =?us-ascii?Q?eG9NL6QYQlopSzqR/WFWrvNVpZ1/Hb8nQ0m0yS79JVBmqpwLwNBc6hx6F65k?=
 =?us-ascii?Q?vjXZmsfndvtw9ReBzb2Qvzvxu7xMbcRcfnI44+YvVCiGHIL1p5mlv7AVm65n?=
 =?us-ascii?Q?smiKIsyvSXaIJ/ERLMe1t0MUAqG9K7j0GKJdSVtEMiHN/TTyqREf2lUqpUSZ?=
 =?us-ascii?Q?4OVjk6wJFfCt+ZEOfAjfA68dBhpTgBbO/+1BIddjH+FXo0BTMlVsCpm7wIPo?=
 =?us-ascii?Q?N+ne6t3kqwf1ampDEVIF1gaDCmJto6WIWwFU1u9ZkSxOWF93tlJae/BoVxEj?=
 =?us-ascii?Q?f1eSUPudg2rNAJdNO+y8N3AfbG5dyyzsUTqcYOfyE4u5vN96fhrPw7td9HAJ?=
 =?us-ascii?Q?ATnuN9Yel1DCxwQsZ6YZ2/jkWUweowHJzk9lolDkfbeLjB7DqazB5dgsbKWc?=
 =?us-ascii?Q?QwFw8ndxrbpwRXL2xLep5VTf+KuAjgEu3AkY0ixwOdws8gG0BwW8pSqwgjZv?=
 =?us-ascii?Q?h8v9ZdEt3tOQ+cI2Nq3X1YwyDrJ8SJfpuyvjj3vOln+AGwigpFgR7koezCdh?=
 =?us-ascii?Q?Tg4w5wL8xp2JUhnTU+kV2boRClYwoioIWu3K2p+AnVjZKR4NjsAhN3Y4AYbO?=
 =?us-ascii?Q?HjB6ZEXdyHlrxDccM5M74HPGNTJQgK7KMV1MghuWX1LQAEudPyG8Fow81Jhu?=
 =?us-ascii?Q?HSHn8VdkEH+igUx7CnA21FqjqlfS267NXOYeK8OOZ84A9P22G6RZ/28PbfoM?=
 =?us-ascii?Q?CFPbfXPL2FB3U4YveJdl6Io39MmVAk2A9osL26GCCmgg1fr66zsOz28mC6zj?=
 =?us-ascii?Q?ahWUrXH6cc+k7h3L1wsL9w4WSowdFR7kR7LEOXZp9YSk/YlegiuVP1d9HVOF?=
 =?us-ascii?Q?0j0mW/RokcmaaFBdbt4IkZa7yqSOp+NOBGvOT7GIIxTa8keu7oyTZkn0dnTA?=
 =?us-ascii?Q?v7IyWHJejSBPLNzeZ+EIpP4nO3yR++iXosMLR+Z/eQbOUGZPu09TJs5/eTWa?=
 =?us-ascii?Q?gO4wNrAQMP6RqQkTEwUKLHZ1utkiula/KZqlMyFO/6aCpt2Wm9k9mYIOMnAx?=
 =?us-ascii?Q?G4mc/+YdzkUxx3EuMCiOrYqcfOGFF4PhbCak6CiEzkzGrr/PrmhlrxImB3Ef?=
 =?us-ascii?Q?N0tyT3OiPyyCe37aSb17huNZJaYgR9IsGwoQERNmTcZ6CeYGHniVtfwhP9N+?=
 =?us-ascii?Q?J1hd96a4oOxs/s4JJuSsFKCAWGX032TMT0/a7okhy0206hekU6Q9BTwam/db?=
 =?us-ascii?Q?XkUICuhSB75KmbNhSSIaznOD1jl5DZ3nQu0+XfWFjLeZmACaYC8nL5OV9rBO?=
 =?us-ascii?Q?dBmTSwPwrF+gqyoaSEVx8Kcx7MbhOjKT/zuZZMGaBqg2nT8zh2a9mvCJokNL?=
 =?us-ascii?Q?YxFLqt9Bh0pYm4W8J6dq6NQGzwsWM4dPiWoVrfmjsNu1AfQX1RXPcCPJoyhY?=
 =?us-ascii?Q?svCiJk5rI7t/dJVgNO8zfnRYtQ9MaumaGTW9AWVv3lvVFSEZbgP90FPC9A?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(14060799003)(82310400026)(7416014)(376014)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 09:29:20.2828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42b21c64-30d7-48e2-6fd7-08ddfa83acd3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5515

> [...]
> > >  	case SYS_ID_AA64ISAR3_EL1:
> > > -		val &= ID_AA64ISAR3_EL1_FPRCVT | ID_AA64ISAR3_EL1_FAMINMAX;
> > > +		val &= ID_AA64ISAR3_EL1_FPRCVT | ID_AA64ISAR3_EL1_FAMINMAX |
> > > +		       ID_AA64ISAR3_EL1_LSUI;
> >
> > This should be added to set_id_regs, but ID_AA64ISAR3_EL1 isn't covered
> > by that yet.  I posted a series for that the other day:
> >
> >    https://lore.kernel.org/r/20250920-kvm-arm64-id-aa64isar3-el1-v1-0-1764c1c1c96d@kernel.org
>
> Thank to let me know missing to add kselftest feature for this.
> I'll add it :)

I mean after merging your patch series.

Thanks.

--
Sincerely,
Yeoreum Yun
