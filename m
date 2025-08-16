Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013014.outbound.protection.outlook.com [40.107.159.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9F31A704B
	for <kvmarm@lists.linux.dev>; Sat, 16 Aug 2025 14:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755356315; cv=fail; b=M7aaFEW1jUxQnMaAU1Abb6QLlpPY1jGz4xhCyyRFAyulaUdJcCqbF/0w7jFDQCegHrgfSBTZb3FAGXAM3C7J8W5HNqAAcovLChAjYQ7ULY08mut7JbcGd0/o4bCWcQcaFBZO52qZOUsFdcdJOXta7pHNBZdC0JsWkXjggU7nymk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755356315; c=relaxed/simple;
	bh=prMsx9aNbFCuhHfS9nx0W6oEOQKiNlb5eD6FdEw5oqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tWQh+6yI9HKe6inG1ncBeNYaDhefbmfpR3gnCq+WqEcUzrVSsxvhgw1K6i03etAudLmG0GQvNc7yydeeKrDbpY+FJo6+mxCaOb3casONYKUWmK1ayOsKsNKp5W7jsTDxSryFU3q4bgkuwn3QRBg6SpPTrxbM4Sw9DDV5qPTJG6Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hVrlFLVS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hVrlFLVS; arc=fail smtp.client-ip=40.107.159.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hVrlFLVS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hVrlFLVS"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PL337IyZ4Er3QVmKWG7M8hl8dGUjXIuoETJgsC+xubG9RA9k7EVwBYn2yp7JoQOTuu9wjyoNjBrxpW/OnN/4ICj98WstAio5hebSMKOws+UcLWwuBtesvzsRjvaozBICrNg1kFqpAzvZn3q1poua7hDrM9JFDzudZmit+5H/0PhHR1iOhFYRq9pfJ8/uTOndPsr3V6sYgJwAqi/5eKKjAu5hk1kT795Zr3StAnjFKODVh/iALgizKc78T71qzHkvk88c+TF0xgbBlrvh7nYTxhH4R1dShpJaJW3EITqhJLBpFPgmF6rzfX1U4JNh+uCkxfoATPgnJim31H0HgfhYGg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Gbp56H+4A0o7KVUcnEd8u3FWbzq/W0ao2bzCL43cyc=;
 b=Rh/n25e91oLVnZ1ZVtdYjiSOcbDA3J4f/fbCrWCTk8QOLxbZGputwsc/WDiomA1f3qMKAmQI3RSvOKUdIYlyjv8XhVLEQlpzOBOL73XqgLGadqK3ufVYOAUGMnf/q5dkLzo2ibXitEEix8N02tGvb9MULjgufvWHAL7fp20JpAAebOtyBid6pQGXkEjh6EQ2BPj5inD9hijcZJI1SozydETg8n2EtOwWe9LFg//NVem0NQCKEPYdPtGZm352Xx1JfcMRuoodkTahkViESqc5k5YNkbdGqjT8Hzy4cNkh6bSYY/JAq+cgx+ydZlvS8xmc4HfMUn5zniakGtv+q+7sxA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Gbp56H+4A0o7KVUcnEd8u3FWbzq/W0ao2bzCL43cyc=;
 b=hVrlFLVSzg56BQU4UPHPf4a/p7c6PwcHYAwREFy81GMjKc7R90IejcV9RCQSRvQGmyEhxSk47AjL4MAuVubpDsl0hzfVVrzUDxCqZEsfE57xpLsUbPnNRU5pXAQyaKQTqxrTQGqviMFDlFOJDiGkdhZk5PbD8LFR5fEMY1xB2a0=
Received: from DUZPR01CA0269.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b9::18) by DB9PR08MB6713.eurprd08.prod.outlook.com
 (2603:10a6:10:2aa::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.21; Sat, 16 Aug
 2025 14:58:27 +0000
Received: from DB1PEPF000509F0.eurprd03.prod.outlook.com
 (2603:10a6:10:4b9:cafe::87) by DUZPR01CA0269.outlook.office365.com
 (2603:10a6:10:4b9::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Sat,
 16 Aug 2025 14:58:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F0.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.8
 via Frontend Transport; Sat, 16 Aug 2025 14:58:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqukrIiehhSFb+0HhPQVbcdItbgWxTFWBqTLz5aO4E1yed4HBzarFxPTsw8gHhgd4wL5gOHLUSzQiAa5ChSghOCKUQrsnA+uqsWwG7OupQZPk6WT+y5x7n7L/HoWDUhtDlgogtZIpcVL9Q+Y3IClyFBx+OHlbePxNpJGk0H+dA9HntwmHdyvHnA5s9cVX8xlxdaQVyGdBsNezY8XntygeKXxD22qf/d49xB4w9meCJuINMYJq+AFpFpShgekZoU7lkl9U/CPoUyZU/LVoTpE70hXuYHh0HT095NDh1Bt03fBQb0dpIWPwcqRJTJD8vz0Pp08ot6Q6AMLnz+Qkxp1EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Gbp56H+4A0o7KVUcnEd8u3FWbzq/W0ao2bzCL43cyc=;
 b=mKmhWvhV/4TA01LGVd57jWG8OJnVaXXmFAg2wQN8Yt1fmskiD0hp/ZZENfl4JJimkRp0TzsN9hnqSQ/Cj/E1A1YOQknbgqBbRvY9R0DXHGby4tQyFAZP2CQBXLQZvMxBupnTjlR5q0HqcU9wdeM24A7eDCDM6vB+FJRgzpApFDWADm6KI65xF9LPXiGks0V0AJ0tGFIlmg/5Eb93k2E8p8N1aK0RSFVTz71yr+sbSDD4MYBe43omHO9nF+hI3iSbnAj7KbJYzeiUQ4dWJeA73bM+idaYNMJqM+BmcOjn56I5gkjxipyHbu2CvzsC+JooFJ0JlHVNr8WjqcaHyb5s9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Gbp56H+4A0o7KVUcnEd8u3FWbzq/W0ao2bzCL43cyc=;
 b=hVrlFLVSzg56BQU4UPHPf4a/p7c6PwcHYAwREFy81GMjKc7R90IejcV9RCQSRvQGmyEhxSk47AjL4MAuVubpDsl0hzfVVrzUDxCqZEsfE57xpLsUbPnNRU5pXAQyaKQTqxrTQGqviMFDlFOJDiGkdhZk5PbD8LFR5fEMY1xB2a0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB3PR08MB9085.eurprd08.prod.outlook.com
 (2603:10a6:10:43b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Sat, 16 Aug
 2025 14:57:52 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9031.019; Sat, 16 Aug 2025
 14:57:52 +0000
Date: Sat, 16 Aug 2025 15:57:49 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aKCcbQWioNfG1MMQ@e129823.arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-6-yeoreum.yun@arm.com>
 <aJ9oIes7LLF3Nsp1@arm.com>
 <aKB55rPj1Qe8G+zF@e129823.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKB55rPj1Qe8G+zF@e129823.arm.com>
X-ClientProxiedBy: LO0P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::20) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB3PR08MB9085:EE_|DB1PEPF000509F0:EE_|DB9PR08MB6713:EE_
X-MS-Office365-Filtering-Correlation-Id: ab33c64d-e86d-496e-e7ce-08dddcd55ade
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?l6q/mbdo7wTU+KEc6aDNZLhbzl7iQA470PNE3QIjQviU6/61CZX8tZsTkhsP?=
 =?us-ascii?Q?Ype5fvn9zoBD7NmeTLLFHTgv2+A1myPRbuZyJBmfyVgENI89EKh3KMXCMqYE?=
 =?us-ascii?Q?W6P7FOX4lCWxG+iUJlc5+hjk+z37ia5IZTVYqyPWfMUWv5VB9peYW0CHNOVw?=
 =?us-ascii?Q?Y2l4wySuSX8itwRwUfHbEnI4RKVHwMmBa6HXTKf6Ns5nHt87KhARlBnYT3kJ?=
 =?us-ascii?Q?FvPdMjhMejMQ1h5wzEGdS1vUidRsAsSn67Ktt3dUg2y8hL2uzp1Dpy58Ql5z?=
 =?us-ascii?Q?WSkoQnpDTFuG/ICWjY4EigAI8zRMUZx4ZUih3V27xB57KZpuHIlFKgGS9rKa?=
 =?us-ascii?Q?DkjyPSD1gbzhiS9Kv//+gpgbIOxjQEcts5eVSz5hsfw7LaRTNOKmGDjk1fh2?=
 =?us-ascii?Q?tURcjeQo05nkUZuHEIVuZYfVLtX7e2B+ph2XzX9Q8G9dK/+BaVcah9CQdyfy?=
 =?us-ascii?Q?FazvtL0e9Gkkimhzm5QmtdKT/wNFhMkxAgVeIz/UXF2iorwWkOmGIj+8loKT?=
 =?us-ascii?Q?Bm3TYQTjpdjiSaE0wjswgP1SLzjSU4BC7C8t640x3Hk9ky1pEF8l7ZEslfLn?=
 =?us-ascii?Q?bByUwmPX8zrCwg0Sy+S1meACEvlgmng//Lzr08Da0hM8JlXyovTy+pCjCRSb?=
 =?us-ascii?Q?YzEs/PYhpTWJpDGZ2H6vHI8/G2PbSDN9vg/kfQcM2LoPlSGrX5o1Ox7ODXiC?=
 =?us-ascii?Q?skTV728bBGl2SUhfBVThbEslKJbf3dnR+gVG7+O0/hLbLSbDNHWFDDhifVEO?=
 =?us-ascii?Q?BEkpVvFnne2/xvhckdQpc6bY9b5tRfoMLla3NliAaAPxgJM+NoXkfssep7JU?=
 =?us-ascii?Q?k8zJZXd/RexXD2e5x5DP72lpbdaUqJHENn24Nq7jR5PsPeTSO61FwTpacBiI?=
 =?us-ascii?Q?TeYn3BqymJcIu21smnoHXglvbTwLZwcioBzGm+PAoxyVs0hqD9njv5JyO/Qe?=
 =?us-ascii?Q?PFtwxmflvnwdd/kKLEzzEZRVQJnIOYFctUPC78ZDJPiYovRSw2SZXgtUSj1a?=
 =?us-ascii?Q?mwHLhLmEgPH1oTTjPQei9XGZhHSHie5XVeY+RXEkD0Rb8B+Yuy2ZrXGcrdiD?=
 =?us-ascii?Q?musK8JTqtDnmo1Lo4DwOWVR18+sSIW8270PQThTrkRtyy6AnKdRJ/7bqj7B/?=
 =?us-ascii?Q?42gmQ65JUGCRTUzKojA76ZBKAFa5OUGduZvfGnzrCPw4cO3oM6U5QZFZVqd3?=
 =?us-ascii?Q?SkpkcouRej8q81RXBk4piTnhOFGiUTaVwd3jomEh+Lf1oKXeGoOQMlQC1Bsx?=
 =?us-ascii?Q?lzAZyHizgn8oHv13hiPSs55qvPHUmT0lM/l7+EbayP4lE8zxqHd9Zv1W30TH?=
 =?us-ascii?Q?ZTcjed2kSwldD/kb2aMOGHfHCNPVjRr8GwP/LHHVoLi5Ej1hpzqk2vaIuNeE?=
 =?us-ascii?Q?0Phcz+onk5JOUgxZi9uvo9NSxVuJhieIIz9t0UWtuVuUCjSjEB5SF1Uw40V9?=
 =?us-ascii?Q?41GuMSx7Suw=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9085
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b96cc220-3548-4f8f-f2bc-08dddcd54638
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TaHUDqFtSA29VmEkf65t046p8uuSLizSx96+v04zwml9e3Bd2OsfPbEY5Qnx?=
 =?us-ascii?Q?JZMMXuPllu91jH2Gr8Lf75HowI2f7f548yK8APBoeaTm9CJT2tzAQOo7TRzB?=
 =?us-ascii?Q?IB2mua6VqMAfZZWXhnqpU+Dc9IP9O3KCVwyE8Txe/yKCvXiPq6zNlQMR4nJN?=
 =?us-ascii?Q?+LGpOCskYuuD69qCzH/xYCo9L5D91d6f2GzKPfL/te7t9tL531Dbl+yyDTWt?=
 =?us-ascii?Q?Mp/+KxIsIrQqzffgpwj4VH8Vj4pmbWPgq8vX6x6xGd5rkM5dhS/dbPLVhHnf?=
 =?us-ascii?Q?ncUw48O7Lh6m/ILVzyBR64EnbX9wYcAhaBCdcVdwDt/nN4qiDr0NhGbvCUIr?=
 =?us-ascii?Q?aGEAQ110RcVgyJezWiX8zcSxcQnIPXTFypw2Kh7YCkGU2kbWwukC88ob8R4T?=
 =?us-ascii?Q?uCAodNnzYIZ3wXBtY+eJs3AMV0mbpjD27EtUAthQcjoKrf8ePp214+TDyC/u?=
 =?us-ascii?Q?8vctw9WHsfwKQuGmMC9kIyX3itgWVpetBiKKmgGO8/QpZzVp2vzLHLxEznwC?=
 =?us-ascii?Q?Z/NR1ei1l8Y+Txj7kx9KajUoQh1qpGi183LIC01aHUQ37F9UzAv0JOBbex5U?=
 =?us-ascii?Q?3k2wcJy7WJrhpovrVsUi43pO4iBCLaN2RW0PUrn3gxj/K0cE4IX9JxS4o85Y?=
 =?us-ascii?Q?iyWOtw08B4ZgqV1Tm5W1ydNkHgssmSUEJn6Pw+02qc2qAk8Uw+A6hL4SwMUr?=
 =?us-ascii?Q?f67srIqo1esBPn+DuWhgo6sn8IWuX3Yh7yF1mPc07MdIpXIXaHixei3ag1+T?=
 =?us-ascii?Q?FP0+xeICO77t6LdhvW7VkwPtFwM5dmjVsxtksR/JFbw5HsxJYFBIeAVqYLXk?=
 =?us-ascii?Q?LhzA07B2LQBqaQk0m1pdFdYISLcKDGasR++U/9UYGRQ0ie8YjV2wQSP8pED/?=
 =?us-ascii?Q?J+5hs2pApp9CqSgOSgN/ZrWFjLELyjB09S2AyL2e0+ge+TWOEzflRUtWTZat?=
 =?us-ascii?Q?lWaulu0Cn/Vm+pNvU5rA3Ueb95qczU/ylrb+bp6SuU1qbLjbKMH+o3Z2v7Ws?=
 =?us-ascii?Q?RsQjnKnNO4HWJr5lWGq0RyiueK+u7Aq9Deq1GirxVj/BaQUIL6KSv9nGbNh7?=
 =?us-ascii?Q?69mUeRRc1Ww813c+JsvaMug5Bqd273V1VcJWUU6Zpzjivtw2Paiq8DFkZV2D?=
 =?us-ascii?Q?YP3PLnb4lU4GQ+OSEcNqD26upqieYSHZG1wGe/X7xK3PueMGE8MzN+tHz4gD?=
 =?us-ascii?Q?fR2+8YOQPvkMlBpVszE04MSeIj0hptYMeET6vU8+yWL2oSGqIuSAEP6vTiBq?=
 =?us-ascii?Q?1rQcGC0VgbBZxANM9btuKi+69MesI+EUfxG+U4BmVyMQ25LwkAQaEI+Dnkcd?=
 =?us-ascii?Q?KsBmkSxo85ZN3GfeDEU5cVwwFVPZKIRKaJP+Rt8rT2/A+eF5eYP/a0rcuk4o?=
 =?us-ascii?Q?mJimJlnXbtmS3arV0ouuox97I6tN8miSogKZdg8Fxz0BWT8z5C6T8z9OKhxt?=
 =?us-ascii?Q?2VbU6pdDOZ0vIoWbyMT92Z7pchkIDDW7pX4TkvqbS82UNA9/p0J3ea5untKE?=
 =?us-ascii?Q?eIdf3X6F4EQtBJCKHnCw/J+LuPZko8P2sHAf?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 14:58:26.6202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab33c64d-e86d-496e-e7ce-08dddcd55ade
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6713

Hi Catalin,

[...]
> > > +#ifdef CONFIG_AS_HAS_LSUI
> > > +
> > > +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > > +
> > > +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
> > > +static __always_inline int						\
> > > +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > > +{									\
> > > +	int ret = 0;							\
> > > +	int val;							\
> > > +									\
> > > +	mte_enable_tco();						\
> >
>
> > The reason uaccess_disable_privileged() sets the MTE TCO (tag check
> > override) is because the user and the kernel may have different settings
> > for tag checking. If we use the user instructions provided by FEAT_LSUI,
> > we leave the MTE checking as is.
> >
> > The same comment for all the other functions here.
>
> You're right. Thanks for catching this :)

But one bikeshedding question.
why we need to care about the different settings for tag checking when
we use uaccess_disable_privileged()?

IIUC, the reason we uses to uaccess_disaable_privileged() to access
user memory with copy_from/to_user() and etc.
But, although tag check fault happens in kernel side,
It seems to be handled by fixup code if user address is wrong.

Am I missing something?

> --
> Sincerely,
> Yeoreum Yun
>

--
Sincerely,
Yeoreum Yun
