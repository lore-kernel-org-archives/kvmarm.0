Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013062.outbound.protection.outlook.com [40.93.196.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2941340BCD1;
	Tue, 22 Sep 2026 18:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102788; cv=fail; b=jrnVitMX59EIKDtI+yovWXbmGk3IAAOnMcPivrOIvyKZ359L6MP+48opLvqus4o1+LDr1IDYNpg0aezbbJVOlopMZgSgv/8lHSAo/lowHu8m8UcZxzqeH1EJIg9V1H6sz5Gy15UsxcIXq0Ln8dUCB3fKAUwjiK+u84JhVwU2j5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102788; c=relaxed/simple;
	bh=N+xfj16cayIxF/qp7sa0gnfzZZqqwC9C8rN3z6Mwqhs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LV7qWHbHNxN+2BnRcY6TeZAG6Ipgzd51iVvAEWNxzYvGuZbYVw16vBCEZvEgobavi0+NLLPhUxKeGr5/h486WZ4wiwfTvAVAcBdxzGn/XjRC9A2rr8oaB6nK6e6TTKqgW2sq0kPdNyfOnEo2SlrzszLkoDknsoh9GfTuYflH5eA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mXCXe5fd; arc=fail smtp.client-ip=40.93.196.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mXCXe5fd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQjKLcpCuAlEoeN2vyRI2CvT112+qQ/1OTm1b0H8FuinDvyYJPvAdoAf5HSiYAzEm5AP0W5fLEVYZ4rP/0s7mYN9sJ2h8lqZrk/F56mKwbwq3rg9ZnREo0NkTXRgL3R8NEf1bHzjJHD8DqPEowGhGcb/gZzYq+9ncGRXu5tNA7IKUYIVop87faTnNbpcxJmSzlml3DHZnqQmuQWv53Eg2bRnTrOBtVRCLY4NLVRgGy9kPVbZ3RXqq0vBjyrp6QBWe29leC/w+nzKanNpTCjFVBF6i+jDX23vSe9Cd8d0rCcFznx4LOR5d5tdXxljajB3Y68cv8FtdwB0v3ZV1Sg4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmXqDnxSrnYvTngLdEs/crWatn8WH9CnuTWJ5gIYNN0=;
 b=e3yBSPmRvFfjFvRdjy5Ft9rCPvhymklSKPejRtthlZwacviNYLJhwqQETfgq3LllRG80HjZFKhS4///5u1cAYblCCq2bo8KtEu2D/dgBU2pN+66tAiDutpAZkTZrU4cRIFnMOfJ8IBxxAai87l6jJpG0wJbt/JZADNhw0lnfX1fbBE2RML9MCBMYofuBZJz/oug5gptwtfvLWfBf4MH6tcfFByCUtPHwIHNp91t2x2qb7ajcp2xaVS1z4gbM7NqO4f147cT9EobjmmxIbTiCQ47xjB+KiODSHvhx6I2myyRO301dP2tXG2EDFcFHU1Zc+Q2aV7Dn6+z2rOdufxxX+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmXqDnxSrnYvTngLdEs/crWatn8WH9CnuTWJ5gIYNN0=;
 b=mXCXe5fdAqgu2lPCxFfSL3St+OPKUzQulzgHJc/9LlOcbPowzaVJn/foPMZ1LK4WnDHlW59+gwbOO5R3Q7cXIpvhJHrUYQ3n3+8kkRzLESo/jaGBuI/GLas9fCyDy14HcCOkc8ZFJ+Cm7Fp6+12mY+6NV8E8fsN2hGORQenA81okfadljyJVXzjGjGfLWXxnzfUcjkK8q4T6t7E/QqXdYNTkLZweX9ZK4i8d/fnhXcdJQd9vyFxI6ZzPHzCBY3EeJCj72PAewfiRzXPAhviD0Iumz9cEbrO/SPE43/GyNShrpNxxcjz+1e4M8fIrGIBUEqa4O6pbdc2coTuXMDHOIA==
Received: from YT4PR01CA0200.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:ad::29)
 by CH3PR12MB8710.namprd12.prod.outlook.com (2603:10b6:610:173::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Tue, 22 Sep
 2026 18:46:05 +0000
Received: from BY1PEPF00026964.namprd05.prod.outlook.com
 (2603:10b6:b01:ad:cafe::13) by YT4PR01CA0200.outlook.office365.com
 (2603:10b6:b01:ad::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Tue,
 22 Sep 2026 18:46:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BY1PEPF00026964.mail.protection.outlook.com (10.167.244.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 18:46:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 11:45:34 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 11:45:34 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 11:45:32 -0700
Date: Tue, 22 Sep 2026 11:45:29 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>,
	<sebastianene@google.com>, <keirf@google.com>
Subject: Re: [PATCH v8 03/25] iommu/arm-smmu-v3: Introduce RangeInval
 encoding helpers
Message-ID: <arLMyd80BJJcthJI@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-4-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260922131259.2975334-4-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF00026964:EE_|CH3PR12MB8710:EE_
X-MS-Office365-Filtering-Correlation-Id: 658f9136-3a6e-450f-d674-08df18d9c1f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|36860700016|82310400026|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yddUDTzC6VDt2vJd4cW1Olj4GEUowWw/LXP2cS7t9lNwAbXQn2WqZ86YNT2LQWceUYWcOxOte3TwQMVlPukxSe/yj+J0Cts9UPCsfmeLPBPQuu0+yHYhwP5C5PzwJC7TudNyNZLkUk3fu8mO/PW+D5kyqHdUACkjhV1Otr9+7AzAWweYup7MocO5vcHLKIeVjSzA2yC7Rb9GXudmLV52gv89lj/B+ohoDqLHARmPIC9FE1PBIh0kDXNUtuobXovMmw9btE2iK+N+jthNZTqHWFejFRpporsZcDa8yAVf39Pl/n2bkA0zkyyFtlTHM+qpqe0x+/D3LF5zFJlrVAaezg6bukpoNfD7U0Z9eUZe2tZ2htoVtFWSr3rEH6L2Zq++sWhYF92xNq0ZiSAZf8oF2TAsshQPk2QUi7kUxTCyU4Ebv5AC59uhjLiyBG3XImDPz3z9yEJurRYC8Fg5rl44aTDtnrlVesFLWQ+NCTL5ZxweuMjnLk/IEO5gfsRJz06mZKxDHap9SMau16HuLRDhinzk1NipswlWgElPGbcNWw0/irIC/1k4pRxqadFkYT9Efy+pDunCSBC8VrIEsipueLBXwif90jAactwCRzHubzcFwHKlhYvqPpyxiwActkVTG0AdOjuA6DEbtTtoLdGtxFJD6FuTSZN5WJAV7T7WKLfa1xxAed2L6Y1VpWw47UlONk9KGWPI94dpD+0kGrAUyA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(36860700016)(82310400026)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tEAgVlDTGjv4bDG7N4YsQAQGOmX893kbsu7AOmj/12GylDqvNawe1s0aaH/VhBxNZhWaqrPJ3f85Fa9XNrRmBxUlLNPtGgYQLLSz4fXaFLXKkIt6FWnHgVmjaRVKQM+lCf69gYQhv5neT/LgH/V7TnPZYCQil+UlKMlWgshUASFmdSo37M8qhE+MjO7YR9kax2Ef3WOaD99zTyjhAeMGnAZZZwc6IXN11PMxLL2Z/0e+hpBrvHk3dFHSGSdRzrAB6rvdbQZCY7toIeq/S3BLW3Kjq4+DAyb/kzC0QHp0NGdD5RbVwzAnwpi++wZI+GkSwBLCkik6Lr4lfD8/Y1l5ZyplEDcjwBkd6jbYPMHrGkyP14x/FUodEz20Hx7CQj7gbrRADmC2yP6smNAkNECb4oeA83MYJXvnbM7+VfqLud2KgO5neP0ZchSX/XoKbKK3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 18:46:04.9416
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 658f9136-3a6e-450f-d674-08df18d9c1f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF00026964.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8710

On Tue, Sep 22, 2026 at 01:12:36PM +0000, Mostafa Saleh wrote:
> +/* Convert page size of 12,14,16 (log2) to 1,2,3 */
> +static inline u8 arm_smmu_tlb_inv_tg_enc(size_t tg)

The prefix "arm_smmu_tlb_" is used by the iommu_flush_ops.

How about arm_smmu_cmd_tlbi_tg_enc?

> +static inline u64 arm_smmu_tlb_inv_addr(unsigned long iova, bool leaf, u8 ttl, u8 tg_enc)
> +{
> +	return FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
> +		FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
> +		FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
> +		(iova & ~GENMASK_U64(11, 0));
> +}

This actually covers entire data1 than just "addr", so maybe
arm_smmu_cmd_tlbi_data1_enc?

> +/*
> + * @num: Number of 2^scale granules, must be >= 1.
> + */

Nit: single-line style

> +static inline u64 arm_smmu_tlb_inv_range_enc(u8 num, u8 scale)
> +{
> +	/* Keep the pre-DS 5-bit truncation when scale > 31 */
> +	return FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
> +		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);

And this could be arm_smmu_cmd_tlbi_data0_enc that takes orig too,
matching with data1_enc().

Nicolin
