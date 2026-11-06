Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793995025;
	b=K1LC+QbHhcBVg3lAyxu9Y/vqDBYoyCjF/tPBcpBfega0muh5eMw4e7SDvEENh+fvjefP
	 ft8OI4Ums12VnT3CS+yZhVLlbDqRQLgircPDIaUCqX/bB+dDZp7a0CgXn0vGFeqefQDsU
	 gffd5IAnM1dG9qHmwBwqZCmc8+ix4ux0PX3ysTnh1iNL7YB++wkKnsL4xHRxZHOLXusbA
	 UXOWkrDzTPupPTqwv+jgPQXNNXvSD/Tqv8gn4EmBfs/vGYAvjex+dX5WoKz5ja2B79Dff
	 w81blm9VWAJhogTk+Uweu8NpjaGWmhCWnhvBsS3789KNHXx141wog17KDXyqf6c+xmg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793995025;
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
	bh=U35EW0rSQqovkhDvCT99KqBJ/0CFSW02gIsNnYH55/I=;
	b=P1HcC9VSlJsEmoyIDtXEmCyRiJ6NVB3Nsx/CpWbtqjX+zzQJQu8PruQuDUSbmmhA8HH5
	 dnLllYSwplLsmjBAcaEuT3ijvC1UGc2e7BCDrnrU2M6V4ZC+aby5ogLf/70VivHpMCkQH
	 lO7eXW3yt53P+QcXdSCc1oE3zk6l1l+LASlEpsNdSHuhPzUQp+j/6PyKXOubjOfrwbl0N
	 5F6iYrif8tbk6E13rW5g20cPfFCZ3XrW1VHdegX2l/edWT4xJL579ygrdWiHNuvhwESqX
	 M/PimRfwudTrbaARnei361HUIEN6pNDoGiSEATrXKXc7PMEnURBanv8epOJZjrkQ1AA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R4jv5pRl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.23
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012023.outbound.protection.outlook.com [52.101.43.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79765606A32C;
	Fri,  6 Nov 2026 19:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79765606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R4jv5pRl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ikXVkU4pelTiyCuvVzIon9Zc+dasTt/tzaOAaNTchA2P2gXCPTYPUbZC8pga/eHv+DJ5gHVt3dmzdqKAFGl8fqlGlTR6qJvYsmg07sBtAd6TGQCsQRE4ijKVeXEshiqytUbosghCE1hMe819HeEfCnlYU4BnR2Hzx3mc3eScWBpOPMZi74jDYDQJi3gXHaHBAJjF0kcmIZ1Y8QpUaDc9t8neR6JjMRfw/vuUOZGnwDn57SjfCQft/CoTeg6in4Vrey5yq02ONSp12MzKlHmu4/kp3Of6l+lUbpsX1DV1Z7t01Worhwba97hpGmECtD7BnCOLiBrF0s118jGbcc3MVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U35EW0rSQqovkhDvCT99KqBJ/0CFSW02gIsNnYH55/I=;
 b=C0WugisHQj/FsEnZX/1N3Om0ookOy+enKELzIcHeJ/99PlMyxVc09ewJ3C5F6+rx5V0nrQPXQ7i4XTclT0e4PdMoQqe+0ozoyZfHYsz+TUHQ+xQWSZSI6ylF4KeGvYm+AzGBZ6Tw/laHD86u8LATdJEcnYN9I0tSrW71nZYg5FTNpZqPSHnjLVkiyzimy7YYQR/XenogbKTlHrBqZYMJ0GsTFTDnSaYmx+uaXVZtdKGpe2i3n4iD4U/BS+2Qmh8P6HxWmH3D2ZIplud+ymjhqZX5ktqFrYIl9Og4mK+dpDSlPC+FV3ZnePLexbGguwZ6ilokq2IWtrIFvIgzl/Bo2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U35EW0rSQqovkhDvCT99KqBJ/0CFSW02gIsNnYH55/I=;
 b=R4jv5pRl7/XB6Vpmi9P0w0YtQvjukTnpIk3bkJfEgSrhBayPzmSFZ9XD84HIeEic0KmSJ8ihAMkgQpBcjmJchnKztdYDwuAKnfDzftJSLRE9IzhsRyVO8XBaBdCPrhcbymqarjK/Ei3fjD5wh6eW9Sv0UJuRN7kJOrTwWJoOWEnm2UnSoGJHYcst7MvrTEAJQP+R44pn4Otk5EnIpwdqiVzLNJcCPEgIna7ZbnMLuz7hgT+Ct09pHHXvB29msX7a/zJZubPgLoezObnxYZ6gn0CDMsOKzKO1/orPc7YhabiKuRJLDxhTR7snwh/F3d/+2mmws4C5HlSsJozzxpCblA==
Received: from MN0PR04CA0010.namprd04.prod.outlook.com (2603:10b6:208:52d::25)
 by LV3PR12MB9329.namprd12.prod.outlook.com (2603:10b6:408:21c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 19:56:59 +0000
Received: from BN7PEPF000000A4.namprd05.prod.outlook.com
 (2603:10b6:208:52d:cafe::2b) by MN0PR04CA0010.outlook.office365.com
 (2603:10b6:208:52d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Fri, 6
 Nov 2026 19:56:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN7PEPF000000A4.mail.protection.outlook.com (10.167.245.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 6 Nov 2026 19:56:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Fri, 6 Nov
 2026 11:56:40 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 6 Nov 2026 11:56:40 -0800
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Fri, 6 Nov 2026 11:56:36 -0800
Date: Fri, 6 Nov 2026 11:56:34 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<joro@8bytes.org>, <jgg@ziepe.ca>, <mark.rutland@arm.com>,
	<qperret@google.com>, <tabba@google.com>, <vdonnefort@google.com>
Subject: Re: [PATCH v9 13/25] iommu/arm-smmu-v3-kvm: Add MMIO emulation
Message-ID: <au4w8nvPQ3xv7igC@nvidia.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-14-smostafa@google.com>
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
In-Reply-To: <20261015200903.2735565-14-smostafa@google.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A4:EE_|LV3PR12MB9329:EE_
X-MS-Office365-Filtering-Correlation-Id: 88b9b6ab-1ac1-4e33-2489-08df3c401e57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|82310400026|36860700016|11063799006|4143699003|56012099006|261021135927099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NGd7ColiLtfxhddNNHNF/GgIuJNvkw/2e/y+JAO6xK/eODaLa0qfahYBNxhIkn9teuq804SnnjP0QC24kPjbznTAnDdgc4VrceNn5VFTF/a6WAZy4Ilq7aCiN60cIAP54wkHI92elF0J/3nRDsHv1fdeSYK4/fFEpakfpPaU1e2nOOdY7BBd4qUVMSO++IAbnW8SXprXlwwsfxLZO36e6MCzEW0aa8ymLDohR8o1N4h4VcJr/xRDTQOQnlMRNE2MbVVTCQ5UFc3H1ZPXZGfHs/CEfBzRE1xPABVG6Ke0Fw+ozkPzuGtImK6eZCW32F7HfjbhIPnUWyDgt9NUMgT9/tRckygznuOnGiKVECVQkYawNvZaNTWaX7VGgEFVRzNA/XdCcm/9e7PfWRKsjfPwLHtpWRYCuAQ9NUrEPQ6KSEoxr+IaYDOE0vPNxvgEcmUSSPfs8F1KKJpMsL51NYTRjWYyrVVdnWD4kgEDtgvPrRDIUS5w7qgugVmSJkEtcnVir53fixZFWKKXIu6ziDRhlFhcZPwihqif1m5QszV5V45UmjhaQNJHA4VsoRWebi2xVkExWEW06AIb/ffDXynWWzOr83+Z4dNu7+VL3Q+Wk5nsNk1NEKtKfQ9RxUKPp1T/epDwUeAvzCZdkMXopbXZZo1RYhrPaEDLpxchjK80TLd0C0vGI0Rk7khrLfzhmod+XkKdVqIzOxm9RpsNeGWTbg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(82310400026)(36860700016)(11063799006)(4143699003)(56012099006)(261021135927099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KNa9lc+h20sWwkDhVsfyLKMPR+JMOzkw8tmiaFELwOEls32zM1uVneXgn9DNctdkHYp9f+xzY/JqO4tua2CiuNZzbHSFUzkqMt3HthGrOz1uSI0rD0qalTyX3/LxBv77Jm5ZqdC7q9cIWTfJCFHkfqRlCbpSTeZrUjliL5t3RNB9vStnz7WGWKd5LuKgs/bBhs5dUWzJ0nUmdU907cBSHKy/4wGTQZ4NWicSUL1s02D5gUs2JlSTMjMjWmm/Ut28KvZKkjDvAXJIfOZAMVqhulHFaf1RaVDBQpdda3bj3ZkeRx+bF0pjapgTSY19jXQwp/Z9bSXeQqynGeUFBpvMns8l9mFFdq9kbWnGHFwZVCqYDc40IjekQpFoPGBVxQjYIW3KI14FRcCuFGi6+5P/vBNxTqIT9tGt7QtEZXrZwimyhJYE5Hiq2FJeluAAVIKn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 19:56:59.2655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b9b6ab-1ac1-4e33-2489-08df3c401e57
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9329

On Thu, Oct 15, 2026 at 08:08:44PM +0000, Mostafa Saleh wrote:
> +static bool smmu_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
> +{
> +	struct hyp_arm_smmu_v3_device *smmu;
> +	bool ret;
> +
> +	for_each_smmu(smmu) {
> +		if (addr < smmu->mmio_addr || addr >= smmu->mmio_addr + smmu->mmio_size)
> +			continue;
> +		hyp_spin_lock(&smmu->lock);
> +		ret = smmu_dabt_device(smmu, regs, esr, addr - smmu->mmio_addr);

Going through the followup patches, I found this smmu_dabt_device
gets really too big. Perhaps it can be bisect to read and write at
least? Something like:

static bool smmu_mmio_handler(smmu, regs, esr, off)
{
        /* decode ESR: len, rd, xzr; width check */
        if (is_write)
                return smmu_mmio_write_handler(smmu, off, len, val);
        val = smmu_mmio_read_handler(smmu, off, len);
        if (!is_xzr)
                regs->regs[rd] = val;
        return true;
}

Nicolin
