Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF51361DC1;
	Wed, 23 Sep 2026 01:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127857; cv=fail; b=EfR1/pbxfhx6U6epAPxv6sD/ARX/M/ZgQNYokmvvaBArcAUvKuvTrl01E9ImU51jJnZNtoap9KpT9zi/uoCS+YiPfAx7L51BBFsM7QyQgaaUL9CGrYjstW5yDgQRiCFB8H4wWBBI7SUhBPTb55TS8soo+Sfiyjk7ck8+DIvLefY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127857; c=relaxed/simple;
	bh=UDQ3dOaIP59EemEwmOgdHXVsAium4IbvLuxGbrhJpyk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WumzBl1G3U8nL3Z6DmAnkHsTKvg6p2pWBWYq0gt4UCxzeETNa1FKZggi2oX1n2k3Ma6sBrdt7g2Z7lnjNaeGRO9E39EYgVG3wkirpVRHzkAPQsJ5QoVrKme8LfeVWMyyGGj+xqqcjeLJycqUxGcW3O/Ehi94aTOfM6bCkIi0NJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y8EDy6Zm; arc=fail smtp.client-ip=40.93.196.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y8EDy6Zm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eNxEAKUF+qs/EFA3O6pab4Aidn9lZlT8pQb5XB1ZEr8/8Yu8gxvQ5vjd5xk7TacR+5o4S5sdPTcnUIPYcUCguAx03Tnuv33CHMX2Pv+vUe6q0viLFzWG6Q6ANfYKVQTsDpC/wLVvhEOoZWxiWg2lgXNbsVpTnpwq7oMZjHa1BmDO6cfRRsr1OVfUEUgYI310eRnOxMCkHoA8xfP7+Sr4hdo05Jx3lQE7Z+pwr7D7IYiedNEL9XJUuzxMTsWLONl0YVPEn1UCLJA0X/cJYEFjKOdZR1Ow+aIpwhMH8idnRYpNY3suOofmrImO9C4Nj4osVCPaAijO2qzqTWqudSP51A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Is5Y7xQvXusv2X0tOqmIGIfFzngvRwa9qztt8LO/A4I=;
 b=U4OyEcpk9Xra79x9PYLfWdng037oJYyUf47X0jPHmrEGXB202JjA0mX1Yd8QiCKjUKEXoMCDIRo+7mlt05r7Okx2ujS/UiJA/y8GPpNyRdaH/mFl9VOf0w3rfJGZ+weLBpargV6Az/SAvYq3XwJirBLqI9laPUHjlRGMnP2hMgh9Q8qTJWi3VcLxpos69soBpho5HDbYK8LHiFjmsMq9boAelW4lxPvdzBcUPw6oxraYt9CLBF8rTCSMEZKBVpoCmsffeQB21M4HEAeeb0cKpjY/C62VPTsZGYLo3/CT0zGwoaF0ZIof+I+4kG/WqPPBMmE4dy6i1xtDL53lyFVdlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Is5Y7xQvXusv2X0tOqmIGIfFzngvRwa9qztt8LO/A4I=;
 b=Y8EDy6ZmCt5KdRmVdRZRK+KOk2WGcH5eqdVA1UxW3lBlr1KCbTM2NjLKfLVUTbltrGm34gcFX8EIsQxRLRab76JnMR7qDEbsun1+ic0mcnFcN5edVM8N3OB0pVaka8zT4zVmu1RkRK8fSnzibXobtqc7kOphaSkQDuNtetR421ol79ncnyM1rpRpuqwfAjNrJoQWWDbRLqvaShLgzJtCwM8X8s5PdjXuai+Kck1fLH76yE12tXt60V3kdqiQ3Qybwggfuf7ZeqjftXOBJqxH8upEXcg358SwwJ0/hajq3NEcyTL41/53Yc/0dy2UgUlkUDnIsHcaigwpyAPQi0lihw==
Received: from CH0PR03CA0225.namprd03.prod.outlook.com (2603:10b6:610:e7::20)
 by DM4PR12MB8500.namprd12.prod.outlook.com (2603:10b6:8:190::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Wed, 23 Sep
 2026 01:44:08 +0000
Received: from CH3PEPF00000009.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::6c) by CH0PR03CA0225.outlook.office365.com
 (2603:10b6:610:e7::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.14 via Frontend Transport; Wed,
 23 Sep 2026 01:44:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000009.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Wed, 23 Sep 2026 01:44:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 18:43:48 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 18:43:48 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 18:43:46 -0700
Date: Tue, 22 Sep 2026 18:43:44 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>,
	<sebastianene@google.com>, <keirf@google.com>
Subject: Re: [PATCH v8 12/25] iommu/arm-smmu-v3-kvm: Probe SMMU HW
Message-ID: <arMu0An215TY3tM9@nvidia.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-13-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260922131259.2975334-13-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000009:EE_|DM4PR12MB8500:EE_
X-MS-Office365-Filtering-Correlation-Id: b18d4476-eefe-47b8-b0c7-08df1914290e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|23010399003|36860700016|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	bLpoFioSzEXnlBjYoEFBavRuEv2uFEqPUaIBZ126OrWybIyiin2rXlLGhCyO0lx6EBzFDWRHLnGHLP4cCqEF5szWzeTZjOsyq8PFfUpI4ffjdKB8bGl/qoLqMbS1Ag71y+rtanBqu1PThzXKchbE6QMue67hKuriKuEevlsiDU06N92+pofmQUFRAzTDJ+tDkkUVzu37BaD/mEfGrT1tNYQ8CxJqbZhs8gRC4K5cC9uhSiLwBFK70uO1cX1/AiQr2caMDYd2nEY+ZfEHeZva75XPVBsKTcG5vMKLwSE/X+t9DLvo/OW5HLXdwnEUtFnxu1QQXz0O4mUxsExLEFQpSeB2aR+kNkf6h6ESlIh6hWyexBc2zgEdgkUZGaY/nyt4kLcL/fOdp/HqHDlzJwkasfYaVY5j4M+Lmk0uDa9R8qUjVc4ZVD3e6oULfx4ZTmIWftKJMlGEOUAyENTC9sdq1+3RpMSziR1/QklqJcIaDeJTwIo6waqFCKW8iP416B1mNnP2z0R4Wgv+49H1GWxdzN7N0qm5ZiZWlTUT2ygolfFHitqyQGGxXAVk+5izgph0o7yX1Ma1ZWdQeGYdwjI8ekndlGzDmIyHwwYpG5Sr3U/XuX5anxU0rssL/N7TLWXH1bW8SHVxT6k307J4ECMgQxeslVn5e874gWClPBHW366/brz9IGb91n5kq+lfOa7bO3+Gky3c8bQ0kI2bjC83tg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(23010399003)(36860700016)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Pc2ov8xyjg68MpM7otGHjZ9atakZAdYAxtr5mmmp3pj7t/b2X4b6SY7+Wcq1QaMUchai4vtd8xiG1x1zMT3Byj8Lun5psOJKD+eYuIM3QBHbOlsOBpVeIXSTMUKKJU/NB45nTBuiq0haiesWXzWnonue3odiCItEUePo4wqEmsZdgRRNQtaRiVWnwhKWewEYPLBJ7imqcLKkalOI2UM5WcaJnDy+UxqEj0DvlYrqCsRrJ2c/wNvM5oFBzT8ESF8sKBYoKmMQArBxFxgMeCMrQOPfYfseN0cfcfSiltcMj7S5evqAlYE/xRFgjL1KnBNXTItKH2uHeWCXCjdIzSKDEJ7D0jlh6BsMtVjaQSHCf6c1SYFBNKImXx1U1xS426FpkG00TNmF8WtEXyRpLaFskAYIwIik1YgvfcqCJEwKlMqG7Z8GJYrQ2lkNh5q4AZn+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 01:44:08.7001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b18d4476-eefe-47b8-b0c7-08df1914290e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000009.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8500

On Tue, Sep 22, 2026 at 01:12:45PM +0000, Mostafa Saleh wrote:
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> @@ -11,6 +11,9 @@
>   *
>   * Other members are filled and used at runtime by the SMMU driver.
>   * @base		Virtual address of SMMU registers
> + * @oas			PA size
> + * @pgsize_bitmap	Supported page sizes
> + * @sid_bits		Max number of SID bits supported
>   */

Some of them belongs to one of the prior patches.

And, if we are going to list them all, could we do in kdoc style?

> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> @@ -29,6 +29,47 @@ static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
>  	smmu->base = NULL;
>  }
>  
> +/*
> + * Mini-probe and validation for the hypervisor.
> + */
> +static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	u32 reg;
> +
> +	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
> +		return -EINVAL;

Does this need to check IDR0.COHACC? If not, an inline note that
explains why?

> +
> +	reg = arm_smmu_idr0_probe(smmu);
> +
> +	if (!(FIELD_GET(IDR0_TTF, reg) & IDR0_TTF_AARCH64))
> +		return -ENXIO;
> +
> +	if (!(smmu->features & (ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE)))
> +		return -ENXIO;
> +
> +	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
> +	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL))
> +		return -EINVAL;
> +
> +	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
> +	/* Follows the kernel logic */
> +	if (smmu->sid_bits <= STRTAB_SPLIT)
> +		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;

The IDR1 reg guard and sid_bits can be shared with the main driver.

Maybe add an arm_smmu_device_idr1_probe()?

> +
> +	arm_smmu_idr3_probe(smmu);
> +
> +	arm_smmu_idr5_probe(smmu);
> +	if (!smmu->oas)
> +		smmu->oas = 48;

The truncation can be shared with the main driver too?

> @@ -43,8 +84,14 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
>  		return ret;
>  
>  	smmu->base = (void __iomem *)haddr;
> +	ret = smmu_probe(smmu);
> +	if (ret)
> +		goto out_ret;
>  
>  	return 0;
> +out_ret:
> +	smmu_deinit_device(smmu);

Nit: out_deinit

Nicolin
