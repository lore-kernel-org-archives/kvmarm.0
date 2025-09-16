Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013035.outbound.protection.outlook.com [40.107.159.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F95C315D22
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758029300; cv=fail; b=W7JqCa21Cwp6n73I480P/x/v8zYZCKcJk/rFMvnANCNCZl+XWMEogCcqSAljwSYDKQ+l/rRMKGOr1OtQH9Xs+7RmT5JClHpbxNC321Zx+Gye5P/5OgElT7V/YZlYi5goGFSLy9myYfnpmM5SGA0Y38Aa9/M3yAg2FIBVLmXTRPo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758029300; c=relaxed/simple;
	bh=w6rL54GW+ekXRhvwombxVPqm7nlpPz8RBS0HIQmsfC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uw8AiD+cyRMkRS3QWjgnZ4V+1c0oc7pc3X+/pZ20blZVcl+3KvlLnz0/gHkFxgGLanpvY0OOv3sO19XdUVw2GtvbRyC2TZdAfCIkGmqBMnRVxxo2c5NlwlMKvQhMSyHaJR8xCkDIFJmHj94kPZ2pZ1El4i81lcyMvNFTxkMMkKA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PB8gzhda; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PB8gzhda; arc=fail smtp.client-ip=40.107.159.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PB8gzhda";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PB8gzhda"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wwks8YM+Qcr9U/vnUheUAgKpJpu2gNyaRE6APrx9ulLkaZglUXIGofviat2wQgZujT6v8jS7p7zWY7YpxUmXkxOEtADUy4O9oGwngiK2mQBioXSMPfUE2ZCOL7HQeB6o7NGH8YzI92+lDJ41a7pBIkzPLfDcXwBZJjNM0ZaHLTLLvQqda266MrxktkbR62x184Sw6SWp0QAmaGbjvDjceqgKUCLJ6osbYQNvvSofXTnOZr1IdbPp2lEL+UeudpNer2ADv9QWGfBhs9oQPRV7yty9IueE8ffCSZIeRyqBjB5QAc5FD88F/Z226X7G5sWcM2eQcIMGLTZZ4ZNEbQbnsw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZt3hI4VOvlQ03rSjNZNPAAUc9qL4H4olvrYMf3uW9I=;
 b=t0P7BAU7DGki7JhSqBU+Z7phnl8v1+pBiGvqSj/fubqiDZ1jgh2JaqA1MsTORSIWu0NZaH7mBDwQg+Y5sCzuUW4T5vhKzYJYDgdLncutBAPyEq0xRGm3iaMwweyPh9GvkviZHSPLg6BBmDKQii2xH0JGQlkzIKZvMjmm/LVi5OJdRG8g7F1w6PNUvbvwct0nzUnCoK1shWxg2c8myhrS4QJlC17fjMHyhS0My/y+cBZPsPZBZfdJ0cBm5jWJk1dZh+r8jj9fNNdae28IsAyL4KaH7RjiaiHf1aB36fGEcoSJ/5RBEvtVX2b3HZwIthfOsuMslBF8Pt6WAkXC9zst4w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZt3hI4VOvlQ03rSjNZNPAAUc9qL4H4olvrYMf3uW9I=;
 b=PB8gzhda/izEhlvD6F2EGLpWEl/3gHbkFrxk4hu5dK0WxK8Dfez1No40ZBa8o+SsBRX8vcS8nHq4ydNeH9ZQ4Z4bmIn5x5MP5z2exB3H3n7KxEMuykqNjf0hftpU53+GBfMR5vMKRBGZJprV87NKkNAFuVEFFfmpbDsEZGux/Xo=
Received: from DB8PR06CA0059.eurprd06.prod.outlook.com (2603:10a6:10:120::33)
 by DU2PR08MB10086.eurprd08.prod.outlook.com (2603:10a6:10:46e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Tue, 16 Sep
 2025 13:28:14 +0000
Received: from DB1PEPF00050A00.eurprd03.prod.outlook.com
 (2603:10a6:10:120:cafe::92) by DB8PR06CA0059.outlook.office365.com
 (2603:10a6:10:120::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Tue,
 16 Sep 2025 13:28:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A00.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Tue, 16 Sep 2025 13:28:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gs+sT/JB3YEGGFGihDBeUPSSFbH7hl17LAfZOZJlRmfXoCuV2R9odMOoRCPXqknGKkoksOk3eJfPPC1Xw/2LBuRLzd34F2Z/BSJ+wAk58DUfb1y4e+n/Gad+AbhGaaF5OaZz06n1aiYPaWISIi8f/VAuPLxIlbTGmHXkquUGfYp49iXyn0ITsHvfcSQI9HlO7xZeYW2uLk1Z2x9/kFCNaOan5cTyVzZSMVfesJ0tbLHsrgeysYKSLOd09MbLUy/kXHyjhl4xikQh7BbyVUWyOuB4dVtWwsDBOyka+1KepH4RaPkgR9CKTWZjw17eZprH/gmUGHwKMJPKHzlQRDlAvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZt3hI4VOvlQ03rSjNZNPAAUc9qL4H4olvrYMf3uW9I=;
 b=OVVP6xATxv43+dH+MSPpJBLEm2ElZA2iKtI50bh1B2d/UrNYwcG76WYzI+MjKXnqdGCEl4whJUbg7vsVkvNcpjp3c+ytTtrmtnXmrlBXWdAhlqr6FteyzxFjk1iz77HQfnYUN+DPFq4yucwEYV4ALXLQxpOejSUrr9jv6eRr3mhtYIb4aO+z7B4MO+W4sfZkb/bq4Cq5Fdn0cD+s1Ez8+AP3WgaZjCTtauEIo9H0JtRdqd6IcMC8OtKx3zYdoghNu9Jh3dZAP0lDQhmHvEpJYVILv8hlJcEtkHsn36XGPUr9BybLp8DDrPXq+VHY48NMuQsz3S8nuHeKc+mWlBEq5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZt3hI4VOvlQ03rSjNZNPAAUc9qL4H4olvrYMf3uW9I=;
 b=PB8gzhda/izEhlvD6F2EGLpWEl/3gHbkFrxk4hu5dK0WxK8Dfez1No40ZBa8o+SsBRX8vcS8nHq4ydNeH9ZQ4Z4bmIn5x5MP5z2exB3H3n7KxEMuykqNjf0hftpU53+GBfMR5vMKRBGZJprV87NKkNAFuVEFFfmpbDsEZGux/Xo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS1PR08MB7401.eurprd08.prod.outlook.com
 (2603:10a6:20b:4c7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Tue, 16 Sep
 2025 13:27:41 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 13:27:40 +0000
Date: Tue, 16 Sep 2025 14:27:37 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMllyaObyciHEEFX@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
 <aMk1qxS3htyaTgEQ@e129823.arm.com>
 <aMlcf5oUNZU65u_I@J2N7QTR9R3.cambridge.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMlcf5oUNZU65u_I@J2N7QTR9R3.cambridge.arm.com>
X-ClientProxiedBy: LO2P123CA0075.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::8) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS1PR08MB7401:EE_|DB1PEPF00050A00:EE_|DU2PR08MB10086:EE_
X-MS-Office365-Filtering-Correlation-Id: 04142778-bd39-41d6-fb19-08ddf524e3bc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?l0oKp6Ai3vkYC9Z8e+UJY7w42/p0Zl7yCfR0W7T5Nq0xUwIEX144Sls2pvLG?=
 =?us-ascii?Q?nInZno32x8sV0Bd7XsgHRIkrYQIUKj0M18gRSF7OUAkdQeoXKh7X66/vzkjE?=
 =?us-ascii?Q?ocdAP/gIk7JTZ7Acnm6G5+uXTpKcBQ+H8qT209jeFJFXxto9y4V/GaAxTt/I?=
 =?us-ascii?Q?ZZVhlCc7TNY+x11P4IvMSw/Uq29Qah/pJlxdU8uGb/wKE5AAKTplbBGG+y8H?=
 =?us-ascii?Q?0ysffjGBH9+NjL79glnAsR2nWDRlQr70xhRyp3bOmva1k231lUjURsuHWo7R?=
 =?us-ascii?Q?frm7kefE1nNU8NoqzgBuUoEqD/8rKqO26YvLhSPoz8JeJ9S79q7BGeOVbQHg?=
 =?us-ascii?Q?niQGWW6Cef7pPGXFz5vMaOPOScWfUusbpQ5JhuKflj0/omUSqCWFm45OH6cA?=
 =?us-ascii?Q?PEsoy1jVFxxexYjMn2/zA5O0OUBUdGQCyfRIpZ3SFPLRQP9lobNtgqsw8r2J?=
 =?us-ascii?Q?aBu9Ualxem6bH82S/7VswDGsH85F/fmObOCd72FMlOdciX/x3gK2uChhmJ4j?=
 =?us-ascii?Q?dFvE8jk2S2+p5VnXuw7y00zWfPfQFHiPFB8hteLYNw9p1Mk4bZoFUjp+cGMi?=
 =?us-ascii?Q?EKJMhvrGVV0i7oIJhvkP9swp36idQek7QyNnKmhXxFWGMZQEqX9qdCfwFrck?=
 =?us-ascii?Q?CsAek5IQ1ly5/9e2U+br/z4wnhVAFIa8CKmQOpBUuN4YngC/vUbXx8n1vRYH?=
 =?us-ascii?Q?29WIOIKV2uA2Fc0iYcT8GhF6Wb3MkDfbwlHwrhvw9oWTNsIgQK0XCo1E5W5Q?=
 =?us-ascii?Q?S0ZXCRzQE+aIy9s4Sn63k35iD9xWudsUhTYW8+myJmQRUa8UrfYInCDaEquZ?=
 =?us-ascii?Q?Exe9teO7C6DfCnN+AZZfNBXnpnworY5UuExpySw29jfAR3skbSCEoxokzx+K?=
 =?us-ascii?Q?PgsO8NiHTIyCz2y5pTDXkPAEuJ1s5GwXq2/d2PKREWimGqWyVnjJntwzx32J?=
 =?us-ascii?Q?fFYQjSRm1hK8ir7BUNQ1vO+DtDqXEuoBBDzWdLZfDPjOSO8q4/bfp0VkdtUE?=
 =?us-ascii?Q?nnTQoZG87WRoC3+nnSZLvLzthv3S2cnO6K0fvNi837uPJCfDJWsP5ZuZQcdh?=
 =?us-ascii?Q?lvaNJ/7oOslmbSP3GomfkABwBSc1aC65rvk8oeF/wNiksKqVeJx6W0wS/Lgv?=
 =?us-ascii?Q?+cOlZDAvycWLMLhDwYQvnWgFzIviATRsNCwfwxsAWNmAsQ8r8n4KFOyWsQEc?=
 =?us-ascii?Q?tTZtFeAM6Ikpe0Syid/lThiENLplOWLioGu0uBRDuT4UiIUTKSZo7nh+BPTb?=
 =?us-ascii?Q?MqE8FD3gqQPVlhMh+waANASFdX6K7EB1ziIRw6yUwxOC3w9f+5I5Snqw6GCv?=
 =?us-ascii?Q?balHNmgdkQUVO9lEyUbduZ1MyB9GxdA5tdKG9U9aGKsimBiapwUlnEg9MaQS?=
 =?us-ascii?Q?oYJHjxpmA+Gt0Do8SlRu6hMuWuKLoej5lxs8GrbFgNXfu1W/IK+V6vLa7ly6?=
 =?us-ascii?Q?FU3TSNC7OU0=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7401
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8dd23f1c-8891-40ba-ceb2-08ddf524cf82
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|35042699022|14060799003|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RwdVVIgDKd0HeQ1HRPpi4GHZyUAfZyBjo086gUI8agcm+p1okOAwjBI1J9k+?=
 =?us-ascii?Q?9iA0/AxJYWPg/VyN70C9lPoaSJ9mmUmj5AN54AgXyGmENIBgS2e7LKCRaEme?=
 =?us-ascii?Q?NDzqESzbpI0qPV6k8b4rckVk+bG79qbss3jzDUTFnDbBM/noFrii6GNefQAP?=
 =?us-ascii?Q?fRv8ssOHik2GrCkw+pWMRVeKHT9s+NYEx9s/I7cB7qjvgveBvuLbvl4DBdwY?=
 =?us-ascii?Q?j5cvMSgs7c/YOuQSn66DCmdupGjdCe+8HKtlcPO/28zw1DRWyNv8MXojbH6w?=
 =?us-ascii?Q?9s2LCy3wfZ5q/jJPUmyYYs/V4LxuYTf4O90po/hysoWQ/lRYJG0ohAYJswJQ?=
 =?us-ascii?Q?xCTIQ9DUklpKc9mflCIvsw2LYfGwswQyPgjzxoqwLnJ7cTCA2Sdr0RnmSxN7?=
 =?us-ascii?Q?x8K2ttJR/kgz2JNVEDPjqUUNhoMo5YdccC77v0oimvlGKJUuQW7ronHXhBq0?=
 =?us-ascii?Q?YdSQQHCKCUrdIvnba70gjRRRoeYOwR3N9Dbh4ps8P8MX/k61qD0/MZ4i7YQT?=
 =?us-ascii?Q?EfH+7HmDSM0A3AYO0Anrl4C8uvez1doCMzPvrrCvPEn4LokTrahb36Gs5qW+?=
 =?us-ascii?Q?7KApq50FEmgn55L7+Bc7bExKjFFTTPjzDVzcejVrlLPBfkSY6n9JJ2sGyL3g?=
 =?us-ascii?Q?gPNwSRrI3T7gUO7nHMbkubcge4oJbeW9hL7jixiqPVa0IX5MADFTRj7E8mNM?=
 =?us-ascii?Q?+vBYCHbJ3w0xqHpGVrBp18EEi//xLw3PxlFIAJFIYkW8bvLDBiVdLWIJd/TG?=
 =?us-ascii?Q?CCko589YKIZSGFbpZPxOQoekQbXmmQQRa6Dv6AJURX7dD3jfoTCzZ0+kXY6H?=
 =?us-ascii?Q?u09kJi6IVzd2ymfZYKhViWKW1wJXpeYD8ZUpd8wN5hPXRIIZ3LGsIQq/QaM1?=
 =?us-ascii?Q?bxaPiI/PHy6X5gHXaEFkIqpxXSLbD6EDEydnINHGtf6jCn6ihWeuM/07+BrF?=
 =?us-ascii?Q?E/xqMKzqINOUcQxCmDI2fuFfa/x4S7LjEyhF4pJxIczMZnKpPCb3+2ChjNCI?=
 =?us-ascii?Q?i2MgQNaxwPYzjM/Le1Szmc1Lm6/xto96WERs/hGBiQqmqRBr3/pAmPC1mFD0?=
 =?us-ascii?Q?nCubc3aqusSNbdPCmqEQKaJkt8SP64X6gmdyA7ydHUt+BaCNSaxvnZAlZI6L?=
 =?us-ascii?Q?SVVSH+7gm6pfuYFNdEELX7M61JYti5e5pRIvxE9d1GVaBbcOPt6j0pcipvTf?=
 =?us-ascii?Q?kikhUjSSnbLf0knopOg8Quq6bCUOugPj+5ZJedrKcYbWj00PUSveLPJCOvZQ?=
 =?us-ascii?Q?IzyJ8rPcnGO73GRxXbQYxJUuXMCSqvlhJOUMGYCid7pLzzA4oB34k0FfJibW?=
 =?us-ascii?Q?XwFDnRjDdpmeyeMFA4GhnJV4qBdjug6Pr7OeNn4/Iq/jXMyv3OoRa1oSuEy/?=
 =?us-ascii?Q?IlPE1ZC0uMKWyap0hus3ryUZDzI+7RkLycb62KVI6Hl/m0RBouic96w2FAY1?=
 =?us-ascii?Q?kE480MqKNAvmyvgB8z+kDtOEOmiInHJuQx5GFo3yTOsKI3rjqyjHxECsaTcS?=
 =?us-ascii?Q?geWERvcNrnt0ljgSA3zAM3UWGperEnixNOx9?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(35042699022)(14060799003)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 13:28:14.3791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04142778-bd39-41d6-fb19-08ddf524e3bc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10086

Hi Mark,

[...]
> > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > index 1d6d9f856ac5..0aeda7ced2c0 100644
> > --- a/arch/arm64/include/asm/futex.h
> > +++ b/arch/arm64/include/asm/futex.h
> > @@ -126,6 +126,60 @@ LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
> >  LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
> >  LSUI_FUTEX_ATOMIC_OP(set, swpt, al)
> >
> > +
> > +#define LSUI_CMPXCHG_HELPER(suffix, start_bit)                                 \
> > +static __always_inline int                                                     \
> > +__lsui_cmpxchg_helper_##suffix(u64 __user *uaddr, u32 oldval, u32 newval)      \
> > +{                                                                              \
> > +       int ret = 0;                                                            \
> > +       u64 oval, nval, tmp;                                                    \
> > +                                                                               \
> > +       asm volatile("//__lsui_cmpxchg_helper_" #suffix "\n"                    \
> > +       __LSUI_PREAMBLE                                                         \
> > +"      prfm    pstl1strm, %2\n"                                                \
> > +"1:    ldtr    %x1, %2\n"                                                      \
> > +"      mov     %x3, %x1\n"                                                     \
> > +"      bfi     %x1, %x5, #" #start_bit ", #32\n"                               \
> > +"      bfi     %x3, %x6, #" #start_bit ", #32\n"                               \
> > +"      mov     %x4, %x1\n"                                                     \
> > +"2:    caslt   %x1, %x3, %2\n"                                                 \
> > +"      sub     %x1, %x1, %x4\n"                                                \
> > +"      cbz     %x1, 3f\n"                                                      \
> > +"      mov     %w0, %w7\n"                                                     \
> > +"3:\n"                                                                         \
> > +"      dmb     ish\n"                                                          \
> > +"4:\n"                                                                         \
> > +       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)                                   \
> > +       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)                                   \
> > +       : "+r" (ret), "=&r" (oval), "+Q" (*uaddr), "=&r" (nval), "=&r" (tmp)    \
> > +       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)                            \
> > +       : "memory");                                                            \
> > +                                                                               \
> > +       return ret;                                                             \
> > +}
> > +
> > +LSUI_CMPXCHG_HELPER(lo, 0)
> > +LSUI_CMPXCHG_HELPER(hi, 32)
> > +
> > +static __always_inline int
> > +__lsui_cmpxchg_helper(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > +{
> > +       int ret;
> > +       unsigned long uaddr_al;
> > +
> > +       uaddr_al = ALIGN_DOWN((unsigned long)uaddr, sizeof(u64));
> > +
> > +       if (uaddr_al != (unsigned long)uaddr)
> > +               ret = __lsui_cmpxchg_helper_hi((u64 __user *)uaddr_al, oldval, newval);
> > +       else
> > +               ret = __lsui_cmpxchg_helper_lo((u64 __user *)uaddr_al, oldval, newval);
> > +
> > +       if (!ret)
> > +               *oval = oldval;
> > +
> > +       return ret;
> > +}
>
> I think Will expects that you do more of this in C, e.g. have a basic
> user cmpxchg on a 64-bit type, e.g.
>
> /*
>  * NOTE: *oldp is NOT updated if a fault is taken.
>  */
> static __always_inline int
> user_cmpxchg64_release(u64 __usr *addr, u64 *oldp, u64 new)
> {
> 	int err = 0;
>
> 	asm volatile(
> 	__LSUI_PREAMBLE
> 	"1:	caslt	%x[old], %x[new], %[addr]\n"
> 	"2:\n"
> 	_ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
> 	: [addr] "+Q" (addr),
> 	  [old] "+r" (*oldp)
> 	: [new] "r" (new)
> 	: "memory"
> 	);
>
> 	return err;
> }
>
> That should be the *only* assembly you need to implement.
>
> Atop that, have a wrapper that uses get_user() and that helper above to
> implement the 32-bit user cmpxchg, with all the bit manipulation in C:

Thanks for your suggestion. But small question.
I think it's enough to use usafe_get_user() instead of get_user() in here
since when FEAT_LSUI enabled, it doeesn't need to call
uaccess_ttbr0_enable()/disable().

or Am I missing something?

>
> /*
>  * NOTE: *oldp is NOT updated if a fault is taken.
>  */
> static int user_cmpxchg32_release(u32 __user *addr, u32 *oldp, u32 new)
> {
> 	u64 __user *addr64 = PTR_ALIGN_DOWN(addr, sizeof(u64));
> 	u64 old64, new64;
> 	int ret;
>
> 	if (get_user(old64, uaddr64))
> 		return -EFAULT;
>
> 	/*
> 	 * TODO: merge '*oldp' into 'old64', and 'new' into 'new64',
> 	 * taking into account endianness and alignment
> 	 */
>
> 	ret = user_cmpxchg64_release(uaddr64, &old64, new64);
> 	if (ret)
> 		return ret;
>
> 	/*
> 	 * TODO: extract '*oldp' from 'old64', taking into account
> 	 * endianness and alignment.
> 	 */

I think extraction doesn't need since futext_cmpxchg op passes the
"oldval" argument which fetched and passed already.
So when it success, it seems enough to return the passed arguments.
But, I'm not sure which is better whether dividing the cmpxchg64 and
cmpxchge32 interface or make one helper -- user_cmpxchg_release
(__lsui_cmpxchg_helper).

[...]

Thanks.

--
Sincerely,
Yeoreum Yun
