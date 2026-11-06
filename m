Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793930402;
	b=aZ7AlVtLcREe8x6zreGMjptvaqKU/s4Qlo00lFVkD6h7dM7mfOIKhgTgOhsRKjMHlOd8
	 J7XPZH5BKGguT/bmhrv4CZEeW01OVuj6QYPsA3xOGjUDsmj05QJw4lP+fpiK5xfQOs+hb
	 KK/7bxYWV+bVBebTRkILSLggL46eHQW2FbGTPuiwZQIBOMB/PQNQi/4W7IHNYsKyHcVxO
	 svRpfrlOEl9RYxsEudxzw2jC+4YlejoAQEqfiUBWY7MHvmEbic8QS6xY/hepV3PLAHpAJ
	 SxMA3uHeaxQbkph0wvS4mpyEkgVBIl611U3mGoizWl8QUmAA0UltH0NqgDZ60qWOHRg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793930402;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=pBCmbB56HG0OQbXafOMe6N5v2lO3ZaxDV6W3RM014PU=;
	b=AfXYbkXeutDWrV05lAW+UeZi90wztB2OXK1xEeRzN4hDI7gsX5VFbXU/5gP+95scGYAH
	 edM3h3yxc5rWYGbVUeeOan+KULR59kYxmPZ36weOEUtBrkwJyhtzb3jm3cbz+biZTBIb7
	 zU3dYg1ndrKrYgoQHI9P96TaRy0ZJ4ZPpDTIEI66N1JzcLVdD3YxuhyvZ5vyRVD8wAGin
	 FamjMgCdaqzpYRtUnsoyHujaYG4mgyQf7v+OfWIBspQQGTiShoc5RM72qu27w0c/N0PzB
	 0/1ahDbUKQsKNnlO6RiBYfC+rY9/RXo0rrHc5TtqVcQIne9ojJHqtc9s+Z6CjNUi4Aw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nnsbshMM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.48
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013048.outbound.protection.outlook.com [40.93.196.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6F5606A326;
	Fri,  6 Nov 2026 02:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D6F5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nnsbshMM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CILnP3EH/Rold47Qkq87NoqiTjl5oKS8KvNe61EkIRXzphHCBXBTYC81FoAwaSrV2PTBlIuj0M9SJ6a/rX98wUv7J6X5TkmE4YN5dKFAnP9MZd5TdL6a+gvfSODTPBw/MqpGUnrNlVoaKX9i5hgMbRGQ3LbKoLQzGGMv9NEa/r+4lpUgpCPxjCJDOfwJ0YSsGnLsEQQ/laydgNSStzWowe2Qo6M/zDC+QoHuxbqzfIAcbzwx/VKaLQ2PSVfRHSuJORKeSZvvcz/U1GVkIg/DfJNz+D/B3kMdpijQhFnBAUerqu1/b9yh0XPWhrzDYoUTj4rKcktbcheV7PO/e4iVXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBCmbB56HG0OQbXafOMe6N5v2lO3ZaxDV6W3RM014PU=;
 b=p1rhqHGp6bD7yDpBTl9lrpsHwftDv0hqffXcxVnOvyYCto2sAaajZ8KP/Z7vqybKkj8RiIq3TSw+O5Bc6u9p/lS87xoaL1vBjHDKEofTmz3kAjA8pIF4KU6hF96+GQ8KCZA05GxAv39W2xMPQwFNl6H9zyH9rj86fpFYZ37yuIeFIQYEMCxWLmsvD8RFeYtiwSdJZFEE+sdt2RSu88BRwkjII8G6Cc2oNg9dKXQ/Yblw5SgExOUVy35s5qS/2vC0Wnblxgrnu/3HnkaerbRoaEKPyvSdvJqkJTAs0Iw+9VWd/dK/IGrWAu5O3jq9izvP8T80gx0z/B6yb9rnciM8ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBCmbB56HG0OQbXafOMe6N5v2lO3ZaxDV6W3RM014PU=;
 b=nnsbshMMXmpzPiK1KjMuLSmy95wgn5h80l5dNPGmmJyZLWwNXjn50OJhcAA9GaFJoZly73LmgTOW7EwnWS1fQdSdwek04VD43LOvxJKGefjUmr+0pwRbRJYiuyk7RgLvUkEuXt7191ZO7DjggiGZyqDrSIbe91sO0dudVvS6gMyr+KYCBxThCQJLYB+FuiJvYPEzVm4aqsxXoY2MbKDSMUkYMwl/3/uTGFyDF8IJ5RrYvHeccx6qSP4pU4gR6wkPQhmgkzj28PfCszz7vQzQrkGJNR+VT/bOvT4iYFkNRtNUWkskoHS6ZUFa2VI1wthVg5S1JuSmIaxjWEgac24ZYg==
Received: from SJ0PR13CA0171.namprd13.prod.outlook.com (2603:10b6:a03:2c7::26)
 by DS7PR12MB5888.namprd12.prod.outlook.com (2603:10b6:8:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Fri, 6 Nov
 2026 01:59:51 +0000
Received: from BY1PEPF000264B2.namprd02.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::8c) by SJ0PR13CA0171.outlook.office365.com
 (2603:10b6:a03:2c7::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4 via Frontend Transport; Fri, 6
 Nov 2026 01:59:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BY1PEPF000264B2.mail.protection.outlook.com (10.167.242.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 6 Nov 2026 01:59:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 17:59:39 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 17:59:39 -0800
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 17:59:35 -0800
Date: Thu, 5 Nov 2026 17:59:33 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 14/25] iommu/arm-smmu-v3-kvm: Shadow the command queue
Message-ID: <au00hT6fsY10WJ9J@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-15-smostafa@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261015200903.2735565-15-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF000264B2:EE_|DS7PR12MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: 18169622-b214-410a-0a8f-08df3ba9a53a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|23010399003|1800799024|22082099003|10067099003|18002099003|261102123227099003|3023799007|4143699003|261021121427099003|11063799006|56012099006|261021135927099003|261009223027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	0DKOMzd5W9ne+P/P3dDLqmQ8NQW1+S+iI6e23VnjhCK5Epd++bNUlrShuPxaPBRszKRdxyOxAzLhV4dcruvVh252tJXtInqASOuAptYbHTx7S6KuEnIR1sRWefmdYcJAe6b04P0wGbqxfPpme3/4xCuaDbikub4LSYTRWEsw9I6LUQdG4lookVO0HwqhCwD2i3fChDiqwZun1MnT4hAYw3sHcnwzQYh1XlncQXiIJ1JzRfeuP3mHsqD2f4DI7zhUokEy0SkgWBiAudnQmY/UAwWRLzxLtGtxDVaCN9Pqvzy4R8bWZ6LhnwLoeDHcyklKlr1LUE6V44XhKSuxRC6wlbRumUamB3oY+8QkbQzb3+GEvLUb56mgwtFdUNszRWYWbNYKFzzLe9bw4gSCJpbZVi7rgmlbXFSvaUjU/GHDhdyyviXb0GYSMCtx2KiOcDZgHL6HAFquu4ZPYoMx+7jNe7qNl2JXNQGHXN4VEF3EpU4V56GwaTh9dmz7OB+DPnlwkSGvlX4x1Xjxtf9AF2n8lWYZykzYHH8FSRf68IVy8y2h7Ov9eYLTV0grDHPNZhj85P5AdOyMMY3YTK/1jh/r7goUNcie+bq5d4cZfPcjday78hb2i2TpERIt7OSoSlPqFlDkv+SfNKyI7qWACL2UZ5wz8SAuyQPsw9CNpEaUQnH4rUBV0og0hcNgWepeCSVzfk4CWWQGKzfh3o+cpcBFEQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(23010399003)(1800799024)(22082099003)(10067099003)(18002099003)(261102123227099003)(3023799007)(4143699003)(261021121427099003)(11063799006)(56012099006)(261021135927099003)(261009223027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HYCwlIpzowj5y40dbC+O5SUgnP5H94Ub8uASDRdhSOssukAVmErKRAt1iJX8ZEGjEz1E1i0XqRbToQd0mC6bCw+w5uNLsrhClrhM+g28Gr/RhaMnU7zx8XweFVy3ratQEH/uusFT6HESfaGIzkne03smw96/gHPZoIW90kyUgOfc1aHCS5BWkUf15GiKojASYTBro2T5HHOJDGRQs6YouKObJAQ/ZU1enAteGE8y9mNGYpxY3kLPG/b1FOcSRb+RDZPhptptsBP7veZtM6srFCAvrMAXaABD+OEwjQkQdYj0fFiHzCFwr9mwpNs1GdgSC2qQeBiZ/hi6Ueno+fHqe1LCXxupisbelijCo8KV2JotxUFnBFNBogX8EIdq0AuczTSLWl4BVo9zonXCWkTgFCi52EY8L4e0eCX/peIumcEh6BNSCnkhyhdur4OVNsmo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 01:59:51.7232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18169622-b214-410a-0a8f-08df3ba9a53a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF000264B2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5888

One more thing:

On Thu, Oct 15, 2026 at 08:08:45PM +0000, Mostafa Saleh wrote:
> +/*
> + * The kernel part of the driver allocates and zeroes the shadow cmdq. Take
> + * ownership of it and program it into the hardware.
> + */
> +static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	size_t cmdq_nr_pages;
> +	int ret;
> +
> +	smmu->cmdq.llq.max_n_shift = min(smmu->cmdq.llq.max_n_shift, smmu->cmdq_max_shift);

Given this is the cmdq used to run commands eventually..

> +static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	u32 shift = smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
> +
> +	smmu->cmdq_host.llq.max_n_shift = min(shift, smmu->cmdq_max_shift);

.. should this be min(shift, smmu->cmdq.llq.max_n_shift)?

Otherwise, a buggy guest SW might setup a larger queue and number
of commands?

Nicolin
