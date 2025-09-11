Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013068.outbound.protection.outlook.com [52.101.83.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545AE31CA6D
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 16:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757607602; cv=fail; b=c86D9ei9u0W4Jl2Ts9pP5O/3KddiLmlD/n81bs4z+FpabSOacQrlnDwvQhSGl59I1MHJnH94hNKqKZ/DwcvCIAWaS1raB0uy8gQtVRk61DLTxXQXGzYudbklM6yHd6vkm1gHaeCH0nYUQ7dMJNVdk1oH6SPSfkAZb7OI2vLoxBM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757607602; c=relaxed/simple;
	bh=Qa3CgpfWy98RfrssguPIcWUN1rK5O/cL7QLud46by1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IENJggNlRt/W92/i0hGyavAddUS/tKDHh/he7FQBIaq207aCc5sflvoNrJmnzeq131cIYHJsbQq8BALD3ybfNyZcTCq5UZQWPBtpuoQ0/7Tume1EqFj0WP98CQf1rhdaHTocXvm0JP8UEvUPjP58dkg9nredbd3ykzEamTwdrrA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a6EmW6Bs; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a6EmW6Bs; arc=fail smtp.client-ip=52.101.83.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a6EmW6Bs";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a6EmW6Bs"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gN+sO9E9MOVngSDDS8eDXqsxL9cHDY5xJ7YOntIMIAA0HKCwRUZctIFtY/uqptODYblPNjV35hybgyKwempYH3cKw/oXx/2CqM2Ixmdns4gfg98dBNc3/wx0VxAgAy8JcvfuwfvQxTAwn6LYYDoUvmBUlfmxwcLCbqjt0nJdJ6tlDUfeBF4uWHjuAZ5sygl03JB6JsJJkzhns79z6bynUhc3cD6Msstq6ZR9BdrLxqPDNKUd8dCeFdAwGP3g7sZI1KhS2WCtbPXieXFELUln6GjRczlogJEzsqQU/uBi9tdpuiqukr+F5AEpinK+sWvbKNORmQvZJ6AhILaNuND+bQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDL34Kc8htAv72no2c4SP01icCSdyq1UtyEZS35iPd0=;
 b=HRUiV+Raz61iXvETd6D/JQCa5R2zPZKwShPl28mUZbKarE353S1u1ednXnL7/JIvnlF1PbgyYF3j6u6O4pbUiO5DT/ByhKJtb7TS287kW44A7nZTyCPclW2PHEE0E5eh3TNyLyVd6xMQOPJzTRGfJ0YUAeQ3wIC3l8w3vbU86jbIX+0dLucPkPlKL0sZ05m/SexZpW7H2NP6wFlvT5q5dptHdNWlgwTNVHBNE9+thyH8qf7z7ohKAV4+LK4rgN7qufY2dx5kPQROvrKGhTUEBidgj8aPS2gJY2jgzfQQpkIsXvqZEWpQHigbpqO+BLBQkqNG+SmsLq3inREfoiqqPA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDL34Kc8htAv72no2c4SP01icCSdyq1UtyEZS35iPd0=;
 b=a6EmW6Bs6VndRZtuZ6yOPTOceoxq2wuxknKDCyIZPfPLUtiYfk5ZblSHu7AMp31LABPA4DjTKv4NxXvOzvIWkxZKVRMMiA9xX3ygQ0J3sROMii6AK+YiuzaIWLO7jbdQMeRZ49DWmEJ7vHDI4OdqKB63pdr0tTi7dHOo0ceiEV8=
Received: from DB9PR06CA0012.eurprd06.prod.outlook.com (2603:10a6:10:1db::17)
 by PAXPR08MB7550.eurprd08.prod.outlook.com (2603:10a6:102:24d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:19:49 +0000
Received: from DU6PEPF0000A7DD.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::74) by DB9PR06CA0012.outlook.office365.com
 (2603:10a6:10:1db::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.17 via Frontend Transport; Thu,
 11 Sep 2025 16:19:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7DD.mail.protection.outlook.com (10.167.8.37) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13 via
 Frontend Transport; Thu, 11 Sep 2025 16:19:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yQQ8TsWu3LLS6vi85C9Cwz17i8ehMHZFHSDHoYMExvNFr2JmnqNTG4ZMi3ekUeMzAJylCs9AxSkzmbxeQncMw2FNzsNO3rnVIBeU0Y9nuByPrt9mpbUVtYebQRJdDLtLcRpQCWyzzrd5MHRqKA8dNV4AOSL8zTUVkeJGFvU8XXxfVMkd6+g8lnzVEsKh436KTIazL+Ym5d8mITPcrvDtiFAHDik3wPpp/xubVfRwv8GeA5W6RpUkJdFFCs6LTAnGgzGK32D9ZGGmzuozhosL4hYrNJq+B3j3BHH9Y0NTC6PCNtELll30z7449FHv3ZGlVMRuzK/PexwffP/SivSoKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDL34Kc8htAv72no2c4SP01icCSdyq1UtyEZS35iPd0=;
 b=QttEaQZPgoP899d1QGwnON+7qenX2qOHZaeaoxAL0ko+Y6xAJ6gWzGPy/2gRCfMTsy91Tcv+CPFGo9BG5uqg8eaueoaMlfmrncXzAj3CFPo/eutKHW8/KNOmQlX2phYY7rLOIWy1IH01BYrrTG/78PQ8xDGQmx/ITFKpNNMRZk/8r8EOi5WkDzPMs1ovpwy4/UIB0q3qNMr5qDEM0y2kBhmlw35jc58jU/61HdF9BP5fKGoUxCkyPJMnTMZ8QKm8q65W4OjtgkEXu/94fgGHeVcU77LocygoslxAuj22HR41q1vX7uEcp+hrZy+9QYR+875m7JoNZVPdO9wq3UWclA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDL34Kc8htAv72no2c4SP01icCSdyq1UtyEZS35iPd0=;
 b=a6EmW6Bs6VndRZtuZ6yOPTOceoxq2wuxknKDCyIZPfPLUtiYfk5ZblSHu7AMp31LABPA4DjTKv4NxXvOzvIWkxZKVRMMiA9xX3ygQ0J3sROMii6AK+YiuzaIWLO7jbdQMeRZ49DWmEJ7vHDI4OdqKB63pdr0tTi7dHOo0ceiEV8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DBBPR08MB10699.eurprd08.prod.outlook.com
 (2603:10a6:10:52f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:19:15 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:19:14 +0000
Date: Thu, 11 Sep 2025 17:19:11 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 RESEND 5/6] arm64: futex: small optimisation for
 __llsc_futex_atomic_set()
Message-ID: <aML2fwGfeubY6HgA@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-6-yeoreum.yun@arm.com>
 <aMLqsez5y9R6FIdJ@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMLqsez5y9R6FIdJ@willie-the-truck>
X-ClientProxiedBy: LO2P265CA0490.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::15) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DBBPR08MB10699:EE_|DU6PEPF0000A7DD:EE_|PAXPR08MB7550:EE_
X-MS-Office365-Filtering-Correlation-Id: dca9a745-077b-46f7-c51f-08ddf14f076d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?+KCo1PDcPMA7aNx/2IfLiHMtQ7u3ptPKVIdtMUkOQ7rscEXQZy5zOOPaI4w6?=
 =?us-ascii?Q?XFuDSXevQ4ho4EES7p4FFtnHtvEUoWGQQeoRF79YzUHZIIjL/9IpiqGS13BE?=
 =?us-ascii?Q?AZFb2KF0B3h8mdpdjnwgx3pTuPHPFm3cqVD6sb+T+qOosZiJtvyzliwxvWBH?=
 =?us-ascii?Q?wPluwMrkdf+0arZhFTQzcI/lfttOHdVjbFA9rq0Yep0wLT9n9kxznvELGRaC?=
 =?us-ascii?Q?MUJJDQxysXAKk/VyH0mDrl3LeCbK0Tu7xUQZGClrWdMxuKk96f8kd876IJxh?=
 =?us-ascii?Q?1Fj/zKyruAHDpL4+Z2bHLj04upzgVlzUu087miOn6arxhm6A8E6ZjZloDVh3?=
 =?us-ascii?Q?lNdHo31mV1/BLOPVSLq0hxu41hLANTnC2ZZodBCZkryGaCYR8f8Jkk6fqn5D?=
 =?us-ascii?Q?eraiCahpEVR/SeWArMSGu5Kke1JQxM/lJbBFfGfZsh0iwlA9p7m0jdIuI4Oy?=
 =?us-ascii?Q?3Hq9y8sZCqSSqZauRHe6Zu+0qaEBmzbGlRktUEIfa/4jwXKSj72DwXKKqJ1o?=
 =?us-ascii?Q?ya+or/j9NFtHobJLkFcnXiL+71kTBMLmgcxBTj7zKAg8hh0jyhuqBcmHQDIa?=
 =?us-ascii?Q?2z7ReJC0M8qQVi7RDiqwIv417/CVYvXTFvAJJvobpG1EQxxfkqWPwsyT9m4t?=
 =?us-ascii?Q?3SpC8r/he2Xr/K98ny3542eeBGmrG3gHtbW9jW51/LTnCa8q4KEEGG7CutbU?=
 =?us-ascii?Q?i6pO/UXW+x0IkW4ccOLkkxTVAmRLLqOqM9iqpoj9Jx2f9QLU5PFa6sk8aAck?=
 =?us-ascii?Q?yOMv/LURwNQZfQ194hhWT9U15/3Ui3q2IVIdxBTtEpUdbvfi3AzxuCHj0Orc?=
 =?us-ascii?Q?hBTffxRE4UfU5Qxu2reNatIgR2Oo3Zit3MG/mNyy+tnxLMTI/fjtcI7A72BP?=
 =?us-ascii?Q?ZRn6/ViBD48ZH+tzNVvQWFT0kwv8tNkkgXgOHTgCyBGS7hVIsDXvZJT2sL3R?=
 =?us-ascii?Q?qCkUDJh9KJSQw9vBLLyaLbym1+w/ThW7eL3URJEc6iKyxr1sQNjyhuasTI2x?=
 =?us-ascii?Q?fjIxsqJEVcLNihjPwSswo0umBK7g/MWG9Dy0Q73b2eb4HPLPViFoXW3w0EFn?=
 =?us-ascii?Q?3+6afohGaTWdV/5A5SFAfOzuxw9tc9cUGZPEGZS1e0cDv+yvVf+UVpXfvhzo?=
 =?us-ascii?Q?3ld+qDIGTwh8jxjjASkLNwL8RpLJ0WPK0U1ZWQit/xX8vM3m+rK98e328rfr?=
 =?us-ascii?Q?6kvwDfAI3mTO4WepA1MjnWkc1Ti1VW3Ci+rvkOtX6RJ0/v5AjP2BXT3a4T1U?=
 =?us-ascii?Q?L87cCfRkOAdkIgvnY6eNpH6Gkq2pe12zYOLJS2AAorhvBWNLqCkiM4Bi1K7B?=
 =?us-ascii?Q?+g/zPeDGMZn/YcRtfSydshYPJ+/LEvnvlrwlraXTZLSsjBSreNN+QUnt4raR?=
 =?us-ascii?Q?bBhp4JXwisLuf8SHlXRWDCFsxJPRo4QOK5Yf+hRu4DIauAHm3BZ/yEPDgSV+?=
 =?us-ascii?Q?jJ1ocTZpUUM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10699
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7DD.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	faa48aba-6dd9-4b9b-8b81-08ddf14ef2f3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|82310400026|14060799003|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oYqKP41+H6F+onNGDpvTVMVAML9nUq6JXkeiWJiAHpTYcesTvDKCSDWO/PrY?=
 =?us-ascii?Q?kbFnES9ninYySQm36so5OBSs7p+P7uZjyuQyXet7t+xOV+OAQxmhA4X1e5N8?=
 =?us-ascii?Q?wx/OFR8haiBHASq8L0Yyd/lBcLLlymoV3Oas45z3duPDquvFewxpGuolBIa+?=
 =?us-ascii?Q?eiyR5JCIJWZSK+HzVo18Z/vxeCIEDJKlcCXtaUspSCM2iKIEw902GNUh8lae?=
 =?us-ascii?Q?pw2nRx/PVB55FsLTas47QLCo14nFynF/o3b29Gy766AZONmNyILmJcp/ExCT?=
 =?us-ascii?Q?OrSm3ZmYiFETALjkD1g56HwgnaPdhxNnjI3/xoajF1k7gdKZns6a83wU3s31?=
 =?us-ascii?Q?PfA1Fd1+Q8MLVfwSuOz9hyO32kufMTXy8IGM93vqgY807xyOTccb2H9fe48Y?=
 =?us-ascii?Q?6+IinQt3oQiMiJkunpcy7sKiVn3plG03b89UnCY2gW3i4KKPa0srwJrekMLk?=
 =?us-ascii?Q?C6nZH4P+jZMW0wdseeIVKHd3YT2bJk+2UjhGae8+zDkjLDPaJlUptfP/fY5K?=
 =?us-ascii?Q?H6hNLmIsGzv9TjLWd8ZF/Vr1d7fJFO4Qd/43JdCLpcUr03ioeH/FehcgM9hs?=
 =?us-ascii?Q?2ibwkFJl2GD4Vfw5UNTTVKbK2jitapQ6Aj/1prR/BYBf4pxAvIyWSnRA9gqb?=
 =?us-ascii?Q?OtU04VTJNEh6ptZln2fPy/URij7xvMqjHsZRrZ4mke9OlD+Nn/sUE9Bcn89V?=
 =?us-ascii?Q?URAIt6tkUSgMF4/3mG/yQUJrKFew2/fZwPEFc+L6D27B0h+dTdxKZnu8GTkO?=
 =?us-ascii?Q?g096hC7kRagomAZFsn8yyGWvcXgoYZPim9lvB8Cj3i1mmYt3tFIhRtFqe0Id?=
 =?us-ascii?Q?xYt9KX2gafGFzkzZpZFcIPwiKbNarECfsYAT7EeYCNCpF7Jd0F8qrc2opcr8?=
 =?us-ascii?Q?BdAwNRXd1mZYrpgyZlF1xu5nyPgB4pK1qFwlLLlVRyJFVi68yh/xzEWQ6Wkb?=
 =?us-ascii?Q?DfR93qlkt3ybdtF1ZxDH/6TTnpN8zKD8ofU67MY+j0UU1G+PFkxNTNLBgyHz?=
 =?us-ascii?Q?8SUliaenLwbS2Xtq3CNm8IDPLS64LA9ax3fd8YuyI1AHkg4X/WFRj9xoIeMm?=
 =?us-ascii?Q?71Ja3JK8gKvIVE/F3aZ0KWRXidB++OQW+YNSfMqXcuDFuhFu/LzDOL29g4VQ?=
 =?us-ascii?Q?CNYKeUc4UtOuet1ifFvf0K3PNNmdGRcVkrr07wdZrD5yuVqUFKN+b7uwQ7Mm?=
 =?us-ascii?Q?xDXsP42SxE8K8mQHbL4dBDhILne4UeFF2xWBJmLxIr5Vn7Bd6A+1ua9kbhvb?=
 =?us-ascii?Q?hsZ2DKb839E4lZee+efIj6ArIInhpR2GNR2RYwakt9aSpH/ATy69X3mb4qlE?=
 =?us-ascii?Q?9JcrGBMwXySA25ynIUDGbnK6zTabdW4RIadc+NMvzZozy0PKuV1/g1GTpuwE?=
 =?us-ascii?Q?7SDmyjgHrl1GThAQHweU/LmCzW0ps2DBItkmm4Uz4e7u3WPYKcam4AsyvXBn?=
 =?us-ascii?Q?wBCGkc6iVPHkXqQyiJoSlJgOl3FQUOaN34hr3TPqXF1M7iw4vS7+sWR4ffDf?=
 =?us-ascii?Q?DG1pBtndd8/GfwKVrP2TC0+zFbNlg9pxkwi8?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(82310400026)(14060799003)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:19:48.4784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dca9a745-077b-46f7-c51f-08ddf14f076d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7DD.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7550

Hi Will,

[...]

> >  arch/arm64/include/asm/futex.h | 43 ++++++++++++++++++++++++++++------
> >  1 file changed, 36 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > index ab7003cb4724..22a6301a9f3d 100644
> > --- a/arch/arm64/include/asm/futex.h
> > +++ b/arch/arm64/include/asm/futex.h
> > @@ -13,7 +13,7 @@
> >
> >  #define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
> >
> > -#define LLSC_FUTEX_ATOMIC_OP(op, insn)					\
> > +#define LLSC_FUTEX_ATOMIC_OP(op, asm_op)				\
> >  static __always_inline int						\
> >  __llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> >  {									\
> > @@ -24,7 +24,7 @@ __llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> >  	asm volatile("// __llsc_futex_atomic_" #op "\n"			\
> >  "	prfm	pstl1strm, %2\n"					\
> >  "1:	ldxr	%w1, %2\n"						\
> > -	insn "\n"							\
> > +"	" #asm_op "	%w3, %w1, %w5\n"				\
> >  "2:	stlxr	%w0, %w3, %2\n"						\
> >  "	cbz	%w0, 3f\n"						\
> >  "	sub	%w4, %w4, %w0\n"					\
> > @@ -46,11 +46,40 @@ __llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> >  	return ret;							\
> >  }
> >
> > -LLSC_FUTEX_ATOMIC_OP(add, "add	%w3, %w1, %w5")
> > -LLSC_FUTEX_ATOMIC_OP(or, "orr	%w3, %w1, %w5")
> > -LLSC_FUTEX_ATOMIC_OP(and, "and	%w3, %w1, %w5")
> > -LLSC_FUTEX_ATOMIC_OP(eor, "eor	%w3, %w1, %w5")
> > -LLSC_FUTEX_ATOMIC_OP(set, "mov	%w3, %w5")
> > +LLSC_FUTEX_ATOMIC_OP(add, add)
> > +LLSC_FUTEX_ATOMIC_OP(or, orr)
> > +LLSC_FUTEX_ATOMIC_OP(and, and)
> > +LLSC_FUTEX_ATOMIC_OP(eor, eor)
> > +
> > +static __always_inline int
> > +__llsc_futex_atomic_set(int oparg, u32 __user *uaddr, int *oval)
> > +{
> > +	unsigned int loops = LLSC_MAX_LOOPS;
> > +	int ret, oldval;
> > +
> > +	uaccess_enable_privileged();
> > +	asm volatile("//__llsc_futex_xchg\n"
> > +"	prfm	pstl1strm, %2\n"
> > +"1:	ldxr	%w1, %2\n"
> > +"2:	stlxr	%w0, %w4, %2\n"
> > +"	cbz	%w3, 3f\n"
> > +"	sub	%w3, %w3, %w0\n"
> > +"	cbnz	%w3, 1b\n"
> > +"	mov	%w0, %w5\n"
> > +"3:\n"
> > +"	dmb	ish\n"
> > +	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
> > +	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
> > +	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "+r" (loops)
> > +	: "r" (oparg), "Ir" (-EAGAIN)
> > +	: "memory");
> > +	uaccess_disable_privileged();
> > +
> > +	if (!ret)
> > +		*oval = oldval;
>
> Hmm, I'm really not sure this is worthwhile. I doubt the "optimisation"
> actually does anything and adding a whole new block of asm just for the
> SET case isn't much of an improvement on the maintainability side, either.

TBH, I had the same question, but I thought this code seems to modify
freqenetly, I decide even a small optimisation -- reduce one instruction
only.

But I don't have strong opinion for this patch.
If it's not good for maintainability perspective,
This patch can be dropped.

Thanks!

--
Sincerely,
Yeoreum Yun
