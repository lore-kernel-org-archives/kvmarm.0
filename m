Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793912822;
	b=hvmDLaRzuruG1RhTs9molg3qbYd1z2YeiGHO/1QqqKLmdBdtwPmAT+VdCN/esQcHrQ3o
	 oDAPvTaZerAtLzC3NG+UlDS92/Ue1BDIJs3poyEVDRNv9RGQLWJWjFIqnfakkRPr+5uY3
	 jwBUHVWiSWT0hQQGhpbEqkb/JYvu9S2UPhz5hEXLtfzyybQ+x+Xnh1omVaSXuj1qyxV1o
	 F0PeZts0HtQXsOPfCP0HgTjKoH+ta9lX8SRHNxXpFxzv7xbK2bJ88xq41/D0Rc6R5Z0oj
	 VGok+t+eobKXXREWJFguejKKaMzpggT1B3+kV/rsngnWyJlO2/502JVyVVt7xnk+Wcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912822;
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
	bh=P2T6CKmHWpBZfkTNwwS/vpOZJAIEVL/Se4l3mW8T0iY=;
	b=KLy8FYHE+ccosaSB9W6GMSmktkFc8y9mWJaFIEqR4nXJESehIJkxhWAcU2/dSQvZ9V9k
	 Vi3BDCakO2zEkoYdSGnePlnppiAqVrFupUOoeOZ7pBopK6AD9ui5fT6XBkckvX0FIeWnx
	 huDISwwmyJWIwNnnUh4fCpLRkgQO/4M0V6ROTYcwtbF+QryrfoL7250qrd3JfoZhbBe3i
	 8UB9ZK8t0ljzy3uqgBr3YuFufU5z3bLOWx/Txbwh+HMLlZWkv9L/JbxGNUO0+5v/48ssE
	 b/Heu4TTA3EgPln1AOf+Sq+M5qmoq/q1oSTx//IW4uwuRUDf7zPxCVdQ36rt9j1Xe9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lkVsGZuq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.31
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010031.outbound.protection.outlook.com [52.101.61.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA99606A33A;
	Thu,  5 Nov 2026 21:07:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FA99606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lkVsGZuq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEOT3v6ZJGFv3nFn0e1oNjC40nXQMdbb+8cHvyNYu9spgyRDmVT9WeNhS6KHrPX3fVNOLjE8C5BPAC5QZGQfSD3GFGlsDLTbtUeaSRkC3n3F6wTdrMJhtG/yXrXihzcgFjKvzVSe/Q61jMFxy8+tx9X0tNIqh8PnO4XrCRHR/N1g5dOOTz2fTt5vokXnqM+BUUiimDlRGpaOjcBW6RvPkc/cWEp2AtpWQtJDEoCS7rczV6kwvEfRlzaNrhpXVWJO3B+Uk1ByakHHdoUg069VuyUuAlbP2ae7kyG2bmY/r+1VjnwU3F9lVDE3zhe/itA+FELMXj0Toei3wuy157Yq/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2T6CKmHWpBZfkTNwwS/vpOZJAIEVL/Se4l3mW8T0iY=;
 b=uLJifsCl3GSsMt2z+rPByPtZQJdt5jCPqpA/zT6/wMT2rd+ORq7pYW/uSZCQtAnV07eh9S9Sql//AL++uAml9W3mtKCRx+3TyesrQw9NxsZ2e+FSnKPnpqHRlJBYkZExnwJjGJZ08MOBut1ygNQkyoucW806O2nfnTBYiuQNEl9wXCGMgW/kKhFdOR4f34h1zRnxIQ6yYbSg3U5JqS9/UFZ5voUlM3dXfmgRCCNVOi0lxQRsHJwtF8YrPBym6Txtr5BLujXjAaaqQXVzVySz4XQupcOt42XPby2Lbp571a7lBC5syqX32p3S7auVyl1LaH1oMf0Nqb9iVAOlNfdmQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2T6CKmHWpBZfkTNwwS/vpOZJAIEVL/Se4l3mW8T0iY=;
 b=lkVsGZuqzrwkMukCMTuWaL3wQGPeIpCmoma4SYC39pxZFtOdbh+j67y4W/eEytBlEqmc6OIBQoxlvE3apWVe/w9xEVFlywVtNBxIP1QRbljG624Xsl8TgJ1JGEqtuMZRSK1xvvHsOfarqwuGxpssqRZb+xOhSswwyhorHlR+lKrSn9cHau4yrDqW1ZOnFtvkZuZAOtf0i3GZBv+qZXhBrpNnPjBd21jksmbHy5Hj7P37rWdHqgyHkRQPidiW4C+d7ynH1U9XIuvpfmPt3r1Vtnokso9cQCgHLXxAT9UnYgnfkUm/zx57V+IdRAewbw5AOEQizywVoHDPi+3fx/ywpg==
Received: from CH0PR03CA0238.namprd03.prod.outlook.com (2603:10b6:610:e7::33)
 by IA4PR12MB9785.namprd12.prod.outlook.com (2603:10b6:208:55b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 21:06:45 +0000
Received: from IA0PEPF00000042.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::33) by CH0PR03CA0238.outlook.office365.com
 (2603:10b6:610:e7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 21:06:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 IA0PEPF00000042.mail.protection.outlook.com (10.167.249.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:06:45 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:06:26 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:06:26 -0800
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:06:21 -0800
Date: Thu, 5 Nov 2026 13:06:18 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <auzvygiGRTWgJXzF@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-12-smostafa@google.com>
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
In-Reply-To: <20261015200903.2735565-12-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF00000042:EE_|IA4PR12MB9785:EE_
X-MS-Office365-Filtering-Correlation-Id: de21331c-00ea-411a-5487-08df3b80b2fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|1800799024|23010399003|7416014|22082099003|18002099003|6133799003|10067099003|56012099006|4143699003|11063799006|261102123227099003|261026140227099003|261026121527099003|261021121427099003|261028144727099003|261021135927099003|261021123027099003|261009223027099003|261022075727099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	iUPLOmUxuYI7cwu0tpKalLgPaI9Ts1cPImR5KXEEzbUhGN3Sf0OtAisz4xdSwt3GxiN3A65xIye2gz0zndtdx9NDg4txbNboUXpCw+M+K6fnGCa9HTql0SELwTFXg/ajgkn7CxiAT2AfZcWIbLC1slZqjU5XVd7YgGEbhfx1qpfsQqr2Ja74/cxGhOBcSMiOwnAv3uV6X8RNmzBWl+Qx0ao2BnN8Sf7KA5oWdcX1qbL9dAQ2bDcdXxim9rjVzHLjV+GB2PZLN8Pk5DL7m+whjP01UYlpgVMjzfJEIbuBDtPAC0K7CgQohQEfosJBMLmUypG0SFU6knnpxHO+Sguo414zV92GCEB8WZyeh6+JypXuuaiV3ZX14RKU9CievvRQwEHtd0NYsCxXVvKx8lWpQwJjx9bdon4vRTdX5ycrOBW/9E1wKmqEl4fD+bbJeJLO5unaxPynPFNItkwt4HuEm1Bjz7KflbUnCOAira7tsxY6FovfHCHqtEXIWpSAVINXyGym024qN4u5fZOFd7JpVFIgauP0KiAZVYgkdy/IseXpgc6EKM7kY6MnMxzSyUDd+2WVvAFWs+W2oqqbqTTgAFeYMoxhcVvyxqlCxaJ9wd/lCjzgA6I/LHp+yB5z3fniFBwwrOOlZ8xjZxL+5SSZcud9kyq5s8qQraM5hi1XvvPdEVeTLLUVw2e2uzHMdGrhDs7Lw0QvgsgkwFuKj8ZPgA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(1800799024)(23010399003)(7416014)(22082099003)(18002099003)(6133799003)(10067099003)(56012099006)(4143699003)(11063799006)(261102123227099003)(261026140227099003)(261026121527099003)(261021121427099003)(261028144727099003)(261021135927099003)(261021123027099003)(261009223027099003)(261022075727099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NAaA4ymnz/9lMUzS84GJm7W6C4UsOvPayYrLfwLu/ezLpuo1CiF/Z1xJvMA5hCqibH/tn403UNw8v9K08THaiTZp37o9FXS/GAsvEdgC+WHFHNAjJDXT2evhjiC4MfKbGtd8HY038hrA+tKwH5dnPuvpy2T9/Q1NiCXQNDO8fW87wncmW4xtPVD2+4qYDI0Y+1TlX7IIx/EITVPqS7LiRxGbTcSzsAVR6mR3v7vDVgdE1BFLhVXjALPYeAOkbkUCZGzlXLIDrbS3V+hW7T9mZ9/SpDn8zYbi4GpyDwCPKTFXOohfCx2j8Rzo2fxRkW6HySLDRFKcgx84KBOg1a2RBVWaKc0JAZ1/KTmCt7sQj4h/qmqheakXLQYd5sCQHeqrOfzTzBQU8N+RSz6a4RE/9Gy8qoEGGHpdLmJ/x1O9Wm3suxmkxuJS5gEjDsK1k8OS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:06:45.2728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de21331c-00ea-411a-5487-08df3b80b2fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000042.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9785

On Thu, Oct 15, 2026 at 08:08:42PM +0000, Mostafa Saleh wrote:
> +static struct platform_driver smmuv3_nesting_driver;
> +static int __init smmuv3_nesting_probe(struct platform_device *pdev)

Could it use a different naming than "nesting"?

"Nesting" is widely used in iommufd path for nested translation.

Here, it could be smmuv3_pkvm_driver?

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> +/*
> + * Two devices are involved: the aux device bound to this driver, and the
> + * physical platform device bound to the pKVM init driver, which only uses it
> + * for discovery. This driver keeps using the platform device, as it carries
> + * the fwnode the IOMMU core and consumers link to, the DMA configuration and
> + * the IRQs.

It would be nicer to have a diagram or so to show the co-relationship
among different devices and drivers.

I assume the regular arm-smmu-v3 driver is a part of the picture too,
when the pkvm driver binding fails?

> +static struct auxiliary_driver arm_smmu_driver_emu = {
> +	.driver = {
> +		.suppress_bind_attrs = true,
> +	},
> +	.name = "arm-smmu-v3-emu",
> +	.id_table = arm_smmu_aux_table,
> +	.probe = arm_smmu_device_probe_emu,
> +	.remove = arm_smmu_device_remove_emu,
> +	.shutdown = arm_smmu_device_shutdown_emu,
> +};
> +
> +module_auxiliary_driver(arm_smmu_driver_emu);
> +#endif

Nit:
#endif /* CONFIG_ARM_SMMU_V3_PKVM */

Nicolin
