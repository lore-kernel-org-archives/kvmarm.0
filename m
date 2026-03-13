Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011012.outbound.protection.outlook.com [52.101.70.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0B61F131A
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 10:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.12
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773398496; cv=fail; b=ZBT3lwksU48eFn1Rt1GzHVCD7EZFudAZZH864kvy1rePH+xujAN99YIIcPY86W6FWpuFZ7l4NQFeIbs6fo2nEebqfCGplFb5YL9Nc4r5gPKSFdAmhuV6STc/DfDh5QgQ56VagyPmQtbbt7wULnC0FuuKbWgv3jrl7jcaaaImS7I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773398496; c=relaxed/simple;
	bh=E/ijpCSl4lk1+Cs3LPP9dEIfPUe2xnR4HqlGEwD1ttI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=REZp3NZO5j4wXg1w5OzcdlFpzN+dIr0UMgWft7NQeYWSBxvEJmRF8apacv2e2WYzDtWhjSnCx7b6LRbyKMIVGzQZwEIlenCSN97xar1+vTdnKB7csEUn3YXo+mbkq/QDOWPlemsiw5tPjPC+tyeG75UA4JSYr6b8YvskAm2EyYI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BFEhGUhV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BFEhGUhV; arc=fail smtp.client-ip=52.101.70.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BFEhGUhV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BFEhGUhV"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yYXZ20dpd8GESil+7n029KCXxzwP8yEOOZnVpUmb1nyOjnccMC+8vLzki61wKF+Sy0E1XNp3epVF+RSs1Q755WP/yqD1fqShodXmO1OsqEMjp5dpWHVIpfnyRCaq9TbWVekA/6QHrIVb2PgWTqQLPHkk1NV44FYHtG/iCthTrMXbrr0EM+VOrg69ALFPE4qFAFgJ2leEwL/YO/jC12DpHeLhuEOmTJskJUiDNnexMv8FO46nCMeWXH2zC1Cl3gP5EI0oz9WGmVCRsj8M9jNNBbgkbGYH5L9AFprU/B0cBQttEOSLnKLPxin7o7qFMt5R+hnNUj+V1Fya6bi83aAFzQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ww4UIO/UCfoN4KwSSpnVTJQMs6tdNoNxaWdbuj78LzM=;
 b=MEtlTcxMAaSwnvcLJo9O4TATo6PnNayiwIPtcKD6EVDXwYGcekpqKYKouO95b/JobmAcjCm11bC1oJOtK75M3d6BCgkdfh1WxSDYlzZpniroYBRzJR0utghhi4R6BVjvi11eXqV+sjmPt0dz/A5Rk5YfTGA3ynkICtqfHmd09NvrHW1g5VaDG4rIJVfIsOz6gcrKXKEpnjHqbZ6Sm77qbCc0QDm2h7/CdBLBR4Pb9FghA0d4KlLvGQbDrw7g5idVD3wvZypF0PA5aEqsC59r45E4dlZPr8lSgAjxLk+nWDRfxvuhIHZ32SoedefMgkYX0dPnROjM5U/0naLXvnTyug==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ww4UIO/UCfoN4KwSSpnVTJQMs6tdNoNxaWdbuj78LzM=;
 b=BFEhGUhVtoQYjxd7udzq2r76DZKc8BVXNMuWsPqFwn95gpdd+M0GDIzZR/dIDHTZKDTMr7+ajzHoQzV5ul7038iv5dyCcGUAP1Gaunwcu4pYJKqwEbchN50DPNijomr5Mj0PpnamrMFT7zpP70VcC6NMUXaTVQiVR3SSRWeuQSA=
Received: from DB9PR02CA0027.eurprd02.prod.outlook.com (2603:10a6:10:1d9::32)
 by VE1PR08MB5728.eurprd08.prod.outlook.com (2603:10a6:800:1a0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Fri, 13 Mar
 2026 10:41:26 +0000
Received: from DB1PEPF000509F1.eurprd03.prod.outlook.com
 (2603:10a6:10:1d9:cafe::19) by DB9PR02CA0027.outlook.office365.com
 (2603:10a6:10:1d9::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.29 via Frontend Transport; Fri,
 13 Mar 2026 10:41:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F1.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Fri, 13 Mar 2026 10:41:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DmWpBFGBj361aIyf//ZpLp9CDFErvlsr3wXXDRqU4dd5cMmcJa6sAoYMgC/07yAPmEtFTQBhTYcxReHWGgZF939XqgvyrOZvsdB90ny0+9kOrR8usU82dUoATgwpLvysu4ZlHSuugpBfLmQLVcrpK8JjHJoTCRhTq3qoak7cUVWJBphT6ww3OKRD5YTUY5sC4hyEyf74Pw2PU9hmicD8Jo4NvVO6tFFZ/WVBnQfRpjI945R7cwlyDyhqjQTnzlzxitG8pSFk0kc/SM9lB2hfAkgoU1BSEvIUl5s94WBCrQ1GoLfYhubWUseYO5pTV5VUL0tyajQE0+SiGs8DUE/u3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ww4UIO/UCfoN4KwSSpnVTJQMs6tdNoNxaWdbuj78LzM=;
 b=BIZs9mo/fAv5mxwtUu2OZ2YkSmbo+aDXkeY8+0cmVyMxQ0PUXVDY4sVc/2DV2yRrUeK+a1YMuT6t0T/bfF9EDemmB0mEYfSAjD1eDEzIf8HBmccpDDdlTkusu+s24WfVqGqKuK+oqJDLiraYi8/6PnY7Smc37uBl2tVALZqJsTXf/mLAh0Hq0onJcFjAC//O3sQhpjq59AXqe4pM/h5quWNA5QV1XPHbztOlqOOA08DPLaqItyFclvZZJ/ZPSC+SgVqWb7cifdR30jqV8fzEhoBHs2BETjdIIKw8oyw7V5lM6szkdWpVdLeX0OaYJzWgtk77m3HsqJ+v2InLqqENig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ww4UIO/UCfoN4KwSSpnVTJQMs6tdNoNxaWdbuj78LzM=;
 b=BFEhGUhVtoQYjxd7udzq2r76DZKc8BVXNMuWsPqFwn95gpdd+M0GDIzZR/dIDHTZKDTMr7+ajzHoQzV5ul7038iv5dyCcGUAP1Gaunwcu4pYJKqwEbchN50DPNijomr5Mj0PpnamrMFT7zpP70VcC6NMUXaTVQiVR3SSRWeuQSA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by PAWPR08MB9542.eurprd08.prod.outlook.com (2603:10a6:102:2ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Fri, 13 Mar
 2026 10:40:19 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9700.010; Fri, 13 Mar 2026
 10:40:19 +0000
Message-ID: <b16e0403-ae6c-4763-8e76-71250f27d2de@arm.com>
Date: Fri, 13 Mar 2026 10:40:18 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/14] KVM: arm64: Donate MMIO to the hypervisor
To: Sebastian Ene <sebastianene@google.com>, alexandru.elisei@arm.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com,
 kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
 perlarsen@google.com, qperret@google.com, rananta@google.com,
 smostafa@google.com, tabba@google.com, tglx@kernel.org,
 vdonnefort@google.com, bgrzesik@google.com, will@kernel.org,
 yuzenghui@huawei.com
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-2-sebastianene@google.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260310124933.830025-2-sebastianene@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0144.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:377::12) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|PAWPR08MB9542:EE_|DB1PEPF000509F1:EE_|VE1PR08MB5728:EE_
X-MS-Office365-Filtering-Correlation-Id: b0fde794-dd25-4b44-35d3-08de80ed13d4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 prpx+5sPzsCTKaJO/G9XtvVNbW5uqmeAv29sl2X5ChpAWwW2ARumIrsgjnEOwVPwSIOm4ZqXc0pso26UzXRCW7IB1QjIVlVEq0f1Hnv/X0cZpkB2XjkJXz9x10omFIeeLLF72Ex627Vy3PSh9tGfNUC5WwIyo2JVN/I3ERzMfLJWmHtBvUiKQhf6Z4uOIEX/15LNHw2kscou06/pEoAaQghl5FdSu1u/0pCAJaLEFqJz1+VB3QVNQtBJFgee+O7pCQpmmN+i3cEhSFC+zANkPqSjOsOvXN1yf8yomjhuZHQ1+Hs4Di7zzuZ06zKMNY+b68KkHZsEHrJ90zKyG4buSt7ygMB1JnU3NBAxVm5UimamO+lzCKepugbrr3EHiUDdbWSWQc5BwfHvSXgseA+pe3y4/Dio6I6YiHCBG3BvLPMfrqdu/n3/FwmfTUMzcMJZAvNicHVb6/navkSjwBY59zvWc0aMliaxG2nKYBatOzXJyFW5hMbmJ6yRb+fTbsylunMshbB8tR+DZqS5BTPdgt40AWWg8KhMIjGb2JT9pU3Mq40FLElkUJ7aojIO8GNl8pnyxzLXFlP80mmBEZFxpEvk3nefxqnK7X0X9Ulshqs40nEsEXwQvYZtnfCSYLLK/TR4zrisDNYLcbquJoknv/y3oT53xynS/Es584wzyhigZdKqI6vUZupfXnMGenZUrHU8M7pERMDAr3iDrPaxwQRdFr6diWEe6bE/AU2xZQQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 twTHPx/3To/EytBZCjIDB2bU7yK/0UcHFT1W0sEcgZXr4IEyUlPv6fVs1kDUrcDiOgooZiMUhXV+0Dlfl5tf6P0cf15wPea65XSWDl9c53si8baUw867pi5/bIMTCeBngd9oLI6DcrXrbj3HPsfxWgQpxCy7rrg6wOhmlltjloR+8ofIfT1roKg3fdEY/ekZtTGwqnUAmBCX/0qA80X+9Kk3KDcDbeXqm+GVJ+afzw5TeDZL2Bvy47l413WX1zqJfF3YVbcyXq7dm1IUOVUA0Y/rnVr7PEd+dec/BRSxlpOn265iCBpK8JHyMJsQiDwfHz91UBiow1LCTmyrRSTLJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9542
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ad7ed0a6-ea3b-4c01-c116-08de80ecec38
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|7416014|376014|35042699022|36860700016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PK2Zdi61/fIkAq6cHqdFWOar57a1qu/wiKBjGZxb6xZhZx3JfawdxLLgA1UP7ss6ICuOYvMbYDszEUZh1e2EWw8pOVI7fnNqe6h+JklNZEJQmHYXzZqRR2pVgVhnRqyBvr8iwl7atS0/588jzp/t1sM5DSnepReoCJrxeZFPmaZefADGi8UrSqZpiUBKr/rMcDRVWD2ytimiJO9M4XvK5XiE2zmTsoDpyeFtXKohAS4kpLyJbAb16la//Cp9/UU7nxhfLl6CrimGfoPJ8jA044iFjWCi+XbcEMLO4itAvJNH5SfGBCBvId5bl0XycQftOwPPaW8EJHvgsVQ3vbB06wftHotGkkWwR9j9ZYWtRX7lIeMUWFWV5wrYbTuxNX+om1iqjnBw8KvCNmjc9DXRSUIYyc+I6KQnsfDrQm4zQPa48ALrk7RixI5JgvjKSJxfNTmuXO0osFLaHXdA/ZKY8SNzXxqgXvlFOOOcIADYRztgEsp4ndXUAPhL33qNtjaoSYjNEpZDFJAtVmQzveydj4wVm6nzRGoTm005hEPlbsQJEVu+j3p2jQIYt1cD75Wk0W/ewzn8DKFeYrLJ/icS4bnO5tYZZOVQ5vK6Eu0T680i9l7NvLtogKL+p2N6bmnzRf68mS83JAs4r2lBmn05SC6RRY5vRj/g8aqKuuQpLwT24FVlQLPTIxq12DQFXaS7xTjQBUwXioiHNprSKe4Yv09OnlqgcdT953uMEIhs0wY1iJTBNP5E9jCRl3GwqQBY3JSOz6aokc+zAK23gk2R7A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(7416014)(376014)(35042699022)(36860700016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LInZe9dg+h2cRR4XljGXMGYvCffaB6EJErEJm+RnleRKuKuT5GgZbkdDGQRGmoNTa0RhNRgQwvZwY21XA64kW3HKFuc5zM4NM/LmS9LXjP8fQonH1YjTCojN6MIoiLZ/VnOD42lg88ZhX4YX9wSVqxeOBDcdqgRs1a82h0aYrRTqu6AdPrjAY7Zt+jFHeCVnKitLRxZVjxxkzPAmjCX5ysGKSY0jeNIAAWNyN4S8QRKlh9sJjQ87LWmjoaNIstbsUvowI4i8ERJ4RGZeSjNQGmjm9DvUn2/mGnWw13oudlW0ZxjOjP3AdNyFTV9nWTH4sN/CjsdRoNwrXrlsXRekBb2Fxd2bTuXwKEHAxJuj6ZNNS5ozeT/cBe+v9eQSuzswN881O879Fmvap97Umm8sdC2mUPJ8IhfCKx7zuIkr2na/QmoDC6KCWwEeIHq5txU1
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 10:41:26.0485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0fde794-dd25-4b44-35d3-08de80ed13d4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5728

On 10/03/2026 12:49, Sebastian Ene wrote:
> From: Mostafa Saleh <smostafa@google.com>
> 
> Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> drivers can use that to protect the MMIO of IOMMU.
> The initial attempt to implement this was to have a new flag to
> "___pkvm_host_donate_hyp" to accept MMIO. However that had many problems,
> it was quite intrusive for host/hyp to check/set page state to make it
> aware of MMIO and to encode the state in the page table in that case.
> Which is called in paths that can be sensitive to performance (FFA, VMs..)
> 
> As donating MMIO is very rare, and we don’t need to encode the full
> state, it’s reasonable to have a separate function to do this.
> It will init the host s2 page table with an invalid leaf with the owner ID
> to prevent the host from mapping the page on faults.
> 
> Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> stage-2 PTEs, as this can be triggered from recycle logic under memory
> pressure. There is no code relying on this, as all ownership changes is
> done via kvm_pgtable_stage2_set_owner()
> 
> For error path in IOMMU drivers, add a function to donate MMIO back
> from hyp to host.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

nit: Your Signed-off-by: is missing. Even if you haven't made any
changes, when you are sending something, you need your S-o-B.

Suzuki

