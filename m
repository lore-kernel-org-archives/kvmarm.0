Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BB529AB02;
	Wed,  2 Sep 2026 00:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788308530; cv=fail; b=SNNHKnhus1DwbEuXQiNdcE+ryTDJb2c2Qf0Ph1HqWU9zxEv6V2BdWES3DD2emW4YmzZj8teR1G88W2zdTjTdiWUp9Me9oQWz6HDrCGNd2FtAmcDtrp5iNVkIRd9lQYLWesnFCRdprix1YWuRO+GG+u0XqcyF6JQNRUi/bo35hpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788308530; c=relaxed/simple;
	bh=nIyWSCXSugazvjbYjRO5ivtVtsPX66rHnVw6kK3Qj4Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iIF7vFRyPfoVe5Ln6eiYJvV6svEBv+a0HVNXqn/7u2NUfigN5P4Ma7XR0n23lr3QJMSTHT3k3vV6D5kZp+g0lAZ/RvEJpdG0l5CzwoJJsS54WKOi1gKN39HEBl2r4+q0TpwTONmNo9kaGSr01G0y1+1cvX/E8BqGoDD6X9YwwHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NTaZmBOZ; arc=fail smtp.client-ip=52.101.53.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NTaZmBOZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1/q4qp9LD/zwgJecauSYs4xAnoMOqla1jt8i3MLN1FmcpADCzg91XyuFbv590KZ2k5AsipzN63rDELRiMWSc9XIcD1E0ugjSsxjNF8jkYkmvp+Ro6gDMNAaJMtBpjfpmjaMoRp5CQaWlliujy4T7poyTFE+8NMCE1/WUY5RF/yLjetgaD8DfLCpA7fLML6t+IU0jdx3MpUjdArxh5bvMuq+snUxBqmHcx/0JXOSWvn90DWoAeNrXnzyxfo12ZDsJNLwxfoDmgt2eFxsMMhwpZa7p9l9mnZBGB1VZ+RAZpTrAdv2hK5FVSY+uz3tLdz/80FykXZeo0ClCRYhZ+c9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jMvwE5g3ALVvJ4jSDfLCZVvwbR1h06wEfsXWvNrdmM=;
 b=iHrl9DgtVU7lxBtZdp/7gB8zg/XD6zxOckC4Wl9Z2ne8v0DxaQOBeY00XZjM/ObkLUJLyYTpYJ7TLPj/PmI/MGpEgt7YvUGSPJ9qX7LHbNpZngDPoq6HnFspLGAAcEhSGZ1eypDwc2n7qnWFSmEC5PxRE5RQtyuh3U+7ko5rGg1w/TRhWi0JL56QdcYypzLsrhmT5aGL3rNgQO8w25Tm8o+YtBYNi8xXdIf2CDDEgDLeiYYOYjDN3f2uzxJSH163nghOF6IX0173a0pZ+tHac+qDyqZ8FbMmGDSt379HPApSjSwvcVRseB7KpdBnumAiKVgE6MWHH+Tx1O2LxcFwLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jMvwE5g3ALVvJ4jSDfLCZVvwbR1h06wEfsXWvNrdmM=;
 b=NTaZmBOZBfy24HrEVAR0b6PsRC0TDBe6802slG1hooBUVqBmwpZkahE9EtAfVBsGHIWq0q5QDEM7dtxwB1LQlnu0lkgEdb0GKB/o34MTEWGjox2e73RWlcW+60sjFiWtcAOttuzIAg8zt1DKKB6lH7lCyK1HtBWF8Wn6BSsWBNtxalM+pSlvl+AIMTSZomD/SiVmUWypkdOsQ+I9Qcv9KQuC/d6+nuUo3bbRzkk1023/dnZlLsHf5Gqc9Qgd8Berr0sQWFsmtNMN5Va6fXuY6h0tNe2uWJmZjcdYN/h3JbEPWghgU5ZVjVzGNf5NYORFgNCmyuapV82w7zfMVgKixw==
Received: from CH2PR04CA0022.namprd04.prod.outlook.com (2603:10b6:610:52::32)
 by CY8PR12MB7244.namprd12.prod.outlook.com (2603:10b6:930:57::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Wed, 2 Sep
 2026 00:22:04 +0000
Received: from BL02EPF00021F6B.namprd02.prod.outlook.com
 (2603:10b6:610:52:cafe::65) by CH2PR04CA0022.outlook.office365.com
 (2603:10b6:610:52::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.13 via Frontend Transport; Wed, 2
 Sep 2026 00:22:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF00021F6B.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 00:22:03 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 1 Sep
 2026 17:21:43 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 1 Sep 2026 17:21:42 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46 via Frontend
 Transport; Tue, 1 Sep 2026 17:21:41 -0700
Date: Tue, 1 Sep 2026 17:21:39 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Aneesh Kumar K.V <aneesh.kumar@kernel.org>, <linux-coco@lists.linux.dev>,
	<kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Alexey Kardashevskiy <aik@amd.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, Pranjal Shrivastava <praan@google.com>, "Robin
 Murphy" <robin.murphy@arm.com>, Samuel Ortiz <sameo@rivosinc.com>, "Steven
 Price" <steven.price@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	"Will Deacon" <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <apdsEz7ipT3ABd6K@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <apcHoHKGoI7WNFXp@nvidia.com>
 <20260901174230.GA2847102@ziepe.ca>
 <apcitkpASOREamQs@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <apcitkpASOREamQs@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6B:EE_|CY8PR12MB7244:EE_
X-MS-Office365-Filtering-Correlation-Id: 634f601d-89ee-4319-3299-08df088836cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|82310400026|23010399003|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Ee+s44j+mQo+a7Nvk+Ew4aIV3isD+Jrk+5Zw+ls9H6ZJVkcj6ZplHp5/LIk1AVubUCTNcZlClGa/rTKDeAZELusBoELwkH4BTIlIfo2MIowYdf8P+NxMFUMQOyLPf73z7NZp18geOpmxQgWfb8u+c9L+1k4/BA3LoyoW+1P4fSDaLWEetXvwCwdRvwY2AqvwlwiZgEcXe1Vi0cMyHp6f8tqSrmy1BRG/q/6o40lvAMsdM8Dolm5ekj84y0d4AOH2CSiZ6hkKBb+qFjPggkNb2Ys+hy86ODfmVeonxSO3UZzbjZ4EgxB/Qe3CJU30s6FzXrKTk2nsrBcR8jB7Aqt6nwtlu7xGXRPf9dyOqI7IOyuHkFkc+kQZ4LKtjtS5+6Lb5lVmpDw1P+alnkl2/KAVHuIHbO2LzeoD+koA/fj0OchD2HDx4bzOuzJDBiJkvkTUTeF6awpOis7A98qLdB1U3E6gslqerFVrZm2SRqfMVNkfqIfcjN85dgg6TBZ/PuTRk9BE9kdB17fjSmz1uYBP/RxDhsA6VyMIva6/jgeYIbjsc1QwWwwIwRCBadUNpTKJektpcc/5Ve0DgAx/emBuzUQJDEmaz1p0atWA7pmIgVHvA4wQAimLMgriqctHpWEX1PUNwIZxLoJGOp/RxBefz27HUmrcIR6iKTEqJb62PKQDmzGeP9AqUsOUVWJSWLwWPAwcLs5L+OP2xz3hwQ/pGA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(82310400026)(23010399003)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uHVlPydCjn/f2Gw40iHis/iGTwSS8eyMH7fcL2rK2e/WknzD3cOT4C1QEfuxXw+izpOUfeMg0Y68nwU0nKW8V5z2M0DxM7bKe+CSuslnKDHf04fO4rzyfeJUkFCsqxTqyLSCdjXvcn5OW8q5clY1HPujs5BgYoFRdi0v2OD5oziftu+xAIcg0QzTU5Mf5g5jI3ryOu7w7GSgE1czxlg22jpxMJxcBsThKUM06IUiqArTEh4hu3kqAX9F+Ry9RTGK4vBsEEZNALTs/wq4M4JVWdQ2yiQJKaAqgNbuqp6CsNSinDquTxqPpV4ZrA7LcoNRQ3YaGUapGS1FYHniECEufbBo1VRg6FCrmdMLXuW9EqSqCGgHjK4EdPiW20unFyiMk1jpQCUKGeUIF9dTMN6KnWawb5ixSEz41RL4J5UQaQWNafmZdbWgr9PtY1+n/mM3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 00:22:03.6180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 634f601d-89ee-4319-3299-08df088836cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7244

On Tue, Sep 01, 2026 at 12:12:22PM -0700, Nicolin Chen wrote:
> On Tue, Sep 01, 2026 at 02:42:30PM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 01, 2026 at 10:13:04AM -0700, Nicolin Chen wrote:
> > Is there anything more than RMI_VSMMU_CREATE needed from a RMM
> > perspective? What about that dpt/ats stuff?
> 
> DPT is a bit hacky currently..
> 
> Prior to RMM v2.0 ABI, DPT was allocated statically in RMM; there
> was no RMI command for DPT allocations.
> 
> Now, with RMM v2.0 ABI, DPT can be managed via RMIs. I am making
> it follow GPT at this point, similar to the static idea. But, in
> the long run, I will think of decoupling, but I haven't looked at
> that closely.

Did a quick check. It's clear.

DPT is a system-wise global thing, not per SMMU or per realm. Each
table or entry is indexed by part of 48-bit in PA corresponding to
to a protected IPA. One thing that is related to a realm is a VMID
in the leaf entry. So, it should unlikely be coupling with VSMMU.

The other stuff is to map VSMMU's MMIO region in its IPA space but
it should be a part of the VSMMU-CREATE package.

Nicolin
