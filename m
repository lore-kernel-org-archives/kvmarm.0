Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6798397338;
	Mon, 31 Aug 2026 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788199746; cv=fail; b=i5CfUtakap9B17r0p9ulju26tWUIA1yEqeYvJ/LG5m1pHudhJFMWORs/j1DV+p5yh0B4TzAhylL2Qc3BrKgsrn8LSrsnPSykIi8Kqz61lniYsFaGK9bYBezGNWZXtY8DUim972IGKNZf1Hmf12UrnOfYV2h2wXy8KB5qKHuJ23s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788199746; c=relaxed/simple;
	bh=IKxeD6vawmeaI1pRFgU1tzsKhxj7sJJIh3w4+Wb0OZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pDc3hpMCNX5vxEXncYYKCIFSzwFi2xRv5QpZdrcWqgHO280cdjYoFAa3LPHRkivE9u3ejijkczKCePwLLPfFoIb9bGXQOuajrBxBWrBJpg9X5qDwKI+TO+ShOGENOOONYwjooM+PNDiidKvSOknSa+JU+1BCN/X0i1N6ZQjPxNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HtNv5lr2; arc=fail smtp.client-ip=52.101.61.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HtNv5lr2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rlrHUgBogfJzSEHrcTG4RklTszrFyxucelL9nwRSvTJXrGGczOsK+8WmNPfLEzmF76Y3v7/kMtUy9i48WgxAb5Oup21taOdFloy5p4F1g+GCKN66yUJYFoBQMZyIaHA0CB99ERv01+2xGFs6cQbpQDhatyukIKmJiiRgIBODdUVuhS0l9kwzaj1OZ3oBagdpASBmeOG6p0oLmBjgVJq43E+L3xsG775Atwjas5hh+JGiP+bkB57kW10CYMPeKuY++EwRHRfq3/qewIhWh65yyoHfhWTflLZq0G4xdpJ56zmkcojIx8faPyd3xPbnZW2y2iS0rq0Lc0JKJPQKyEXKRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwmsfnBGvzxikmHxcv36N4OKKwjIBYxwXO5MlSjP09s=;
 b=dbxkkhF3nlZKJEuFB+zfhk2QkIuc1LOpt9R77YKtuVhoMtOsVQlLRUI0lUVyOPE9U67EY9zd1WC65eB+U7dXh11lqydhFic9juWtC8Z6cDG7hn1MCm6h8Hu151ajUflkGO6QH8EE89dfK0VfKVnVO44n46R6yelZN2qt7Bs5xO2nWcJx9629eAKF3psYowHsk9DCh7fITl43mFfyJ2GpTt31o2ODSOMVff9Lf/g3soZdqksEo3oZ7svLstXV8F0WO/5HCJtACBSAsO7GnjCqLq3HT7RcHj9hZzoEdKOMA+0INtWg00LdbgRm3F5SGXFtcBT8bi+kx30h74G/EwLIFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwmsfnBGvzxikmHxcv36N4OKKwjIBYxwXO5MlSjP09s=;
 b=HtNv5lr2rG0XYWc3iCfPxM8nf1yNNzS9c4cho4KdaSq+5AEJ4hPRsaOZBXnvLZRfGZmPTaevQro8ECxLr3t1oNH1USsKYjwRjTmLV1DI1MfRKM/y14EyJNBoVDNuh7BOh1t2me1+VQ5k4sqwVbg0gWOM/TVY/0RkCKAdClM8SaO57cFnqTaqftV4ZeeoKuAIWw/py3m8Y+CwN/Hm549YXDpQtzMVvZ/draY97oUVscquMbU9He2q8MoGv+jBnfP8fO1/3xZSDecGwvcHSK0Ty2kmKJS8FDeyrR/kWsWR3nxunDRR97BOzHSb0s55NIorw4v+wt3UmecLu42bvrOGKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY8PR12MB7659.namprd12.prod.outlook.com (2603:10b6:930:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 18:08:56 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 18:08:56 +0000
Date: Mon, 31 Aug 2026 15:08:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 00/16] coco/TSM: Implement host-side support for
 Arm CCA TDISP setup
Message-ID: <20260831180855.GA2171358@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427085344.941627-1-aneesh.kumar@kernel.org>
X-ClientProxiedBy: BN9PR03CA0170.namprd03.prod.outlook.com
 (2603:10b6:408:f4::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY8PR12MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: e42002be-b715-4a92-6c28-08df078aec20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006|3023799007|11063799006|10067099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	Rm6a0GT4DFeRUQuNQfe2ca/z+SB8+5z7gNAPHtvsXAdlYxtNAdiicsuKV/Sm0RsZ2a7r8XWXkuQCfKDQGGP9aHslQw2iLv7BeR5v7K9GLAA48+Kx6J9KaDmPhlLdpr498Jkf5DHDpOBphIrnxH9IFnWX/YmsVSWm7WMwKhsLE3AqbqPe6jZfsLUvuwaVWrel6qeVsnLc7POpPeLL7df+57FeT2P9MnlVT4BkgTBKorxL60tg/4eejtlQCHqaYOciwrPx8S4pQoB59MNqW2M5bnYaOPTprgyO5X5NXsNzyKn5gLLxLWE//PplKyWVQtDXSfSQZEKAE0scd7qWkSC1OfgB5mHx2BaNquaUSOjkxyPd3uabcBdXNF1XI+c5HTNISLBGG1KFLB2dCXj1U27G2F2xHyPcFFRi16GQ9DERAkO6K5YPDMOOngBdxdfhmSW5xNJWwNx4+DBe0XWyTWgdE04hR61/i76NOd/+EFnzM+TTsyx175+3TlxGZRp+gKdGY9FOMh8CxUgqIvnxON+hBDclkCUnDs/KATfKAw9g0dCCIizEIv0nSs2rXU62G9Fcfi6HZbA7BWkB6sY/ZIH6qmlLiU+t6/VP35RRqNWOJCQq3N7RukS5UoMhcQhv0iwzBKlOnMUVMNkVAMnWd5IIEUhcGNClqYqq9kZ5dWVg0y0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006)(3023799007)(11063799006)(10067099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C1IlO1YmlhSRstoPzOcUCAGW56JoyNqLjeiD+cGfduu6kqBKIuuAqcWuhj7s?=
 =?us-ascii?Q?3sKm7EGr9p73kC45c5Vf+PhjZ60hK59vurxFkLAUSQK2TKCP0cSdQpcTmFTE?=
 =?us-ascii?Q?8eDpMZLsK9/J6v68Fhv+JX6KT3e1z7VZifMWWX4khk8BcRwwWo6jOha5aKwH?=
 =?us-ascii?Q?kOIS4Fdc/wz/+ZcBOpYRzZC9bZpZg9alASk1UINK6bNpNb/1IF5wd1/T24qy?=
 =?us-ascii?Q?WQe4FqgDFK1dQox6y+QCzkd4Gi4KSTKvWStSm6T6KcB13WosW8mYnfY+McVO?=
 =?us-ascii?Q?uERjSBGm1+t39e+1j0kYKXryLiyv4g1cL7ylielGM2zp+L9B+V1H1A0pIGfQ?=
 =?us-ascii?Q?pILuJ7V4zdCyp9Jl/H3wxET5ub0iynSFnxdB7Y2+oQwBeofdEpFWeim+lt63?=
 =?us-ascii?Q?fKG6T9pBrtK6j9PNoRL61nXUa0AU1vw7A0UiK70I63s81jgJ+YH4OkQO9HVF?=
 =?us-ascii?Q?BkIdYxbqjyihIGSd0RflHR9+boUSbos0FIycxSJxWaW/N74atMZhQrRmfVyM?=
 =?us-ascii?Q?m37oU/AMV30a+4BwjKm8sh9YcxSK+LkEqZUGoARfl0SOH1HsTk+QrDnJ+ssA?=
 =?us-ascii?Q?3yHtruHSt43cL/1aY3SSc5M2KC4B9dUitFMYv2OlHHNFjo1n9fBrkk1nfOir?=
 =?us-ascii?Q?+B04qULqSoPpEl7l3xjwWxieu1iyKg22MSOvXM0LgfApTB70JQwBs7FbbsmX?=
 =?us-ascii?Q?Cw4c+Vj/WfmeEwZt+F9w5C/oD3umORtgmlIx9yXKEni3OjsTZAosBR8Ep56R?=
 =?us-ascii?Q?EWhwfa9pywNySh943ANvXWoAUMGFTfSbMD/OCKlLX5rjycOIS5jxXTAhgmhO?=
 =?us-ascii?Q?fQ+0ZnbshyYByazMTnokzeHRglwUpQRAfkelqfl5I+q6YUMaX9h9A2LmZJMV?=
 =?us-ascii?Q?IQkwrhJGsM7L6kRkmGY7PCpZfrMIUSSuY00VhHpuqpZkyTbEETPKS1Hqx3ur?=
 =?us-ascii?Q?nVcFK+ABlAzKdjrNaTJhTyoevS5KUCaFie1ckyqxnYt75UccgJyTNAJYjThb?=
 =?us-ascii?Q?k5LvpBzi9sK7Hp6W86DSC0XVlPcLWiBZNcdATA7X30oAJvKIplJd9MgBqeEp?=
 =?us-ascii?Q?NoA4PecUDcejYSMA1jc0r1cnK/rIz2OzJOm/CBEFF/5bOilQU1oMEN3UaJCo?=
 =?us-ascii?Q?9jsws6X2sePxKcSuB1eZrPgvkV6/0gkE4ccw/kQm62wo9999BRAeiYV+D+Gl?=
 =?us-ascii?Q?7Vow9x78YFyE8qvxc2Ti0NxrKjxENqwI8OMKnfJzDolDOGtrucHFVijWcqQM?=
 =?us-ascii?Q?XCT3X0qpLe+TlrSjmLW6KEPV0obHeI++LjAl7nBRhRPTXPRjcFNjWZz/cLB+?=
 =?us-ascii?Q?UtB3q7FEUfzSDD+mNIB4TM42YYFP+dYgBjzv5eXoRzeJK+fpciIqdo4EhdFx?=
 =?us-ascii?Q?dUR3DJHPKtTir2erCoY4ujFZb4ix56ZTvEyaXqEYPtUeFz9x+SKjij/Fg4h6?=
 =?us-ascii?Q?geN3B5nyYxZOxkRZ9Js45FTEEtxHHdz9zQSmEl8O/i79YrsSU/mAkPnLPT3A?=
 =?us-ascii?Q?z0+0uILfcEpXjqHIgxFx+xXn/mEoYwmfplA2gVDvlJnwAqDBg4bFsrbfSSn+?=
 =?us-ascii?Q?+EgBdWAlIO30NNchB33H5w9xK9/a8X6dncZEh3QVkv6aZRCAXy5dAleH0POk?=
 =?us-ascii?Q?g2Z7PumomYSMqit2Kq0cQUE1GIYKD6x7IjLBTuDIEyY5cU+GBhRmVbcJRGxx?=
 =?us-ascii?Q?5fGhrgbQhj83ahXKG6WQU3Cnvoh8s+DtLhpcKK7ReUX5RFEH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e42002be-b715-4a92-6c28-08df078aec20
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 18:08:56.0996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8TpoBgHyPXn16ahQHCMXfbefBGi0arM8Cb35oM+JwdcXfVMVU7baI30mPFY7A7j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7659

On Mon, Apr 27, 2026 at 02:23:28PM +0530, Aneesh Kumar K.V (Arm) wrote:
> 
> This patch series implements the host-side changes needed for end-to-end
> Arm CCA TDISP setup. It adds the RMI/RHI plumbing required to create and
> manage Realm vdev objects, service device-attestation object requests, and
> complete the KVM/RMM flows needed for device run-time transitions.

So this is enough for the realm to see a physical PCI device inside it
without any vSMMU inside the realm?

It is really weird to see a viommu for a case where there is no
viommu..

It doesn't do anything except manage memory for the RMM..

It feels wrong that the arm-cca-guest module is calling
RMI_PDEV_CREATE and RMI_VDEV_CREATE while the viommu is allocating STE
memory for the PDEV. That doesn't make alot of sense? The STE is
needed before VDEV_CREATE, right? So why not place it there in the
flow?

If that's changed then the only thing the viommu does is manage the
PSMMU, which again, seems like something VDEV_CREATE needs, so why is
a viommu involved at all?

The smmu driver involvment would be much smaller if it was only the
interrupt routing and some helper to return the psmmu addr for a
struct device that the arm-cc-guest module can call to manage the
psmmu?

But I'm also sitting here scratching my head a bit, did the tsm_ops
design go the wrong way? Should we have run more of that through a
viommu instead of tsm_ops? Bind is sort of an illogical operation
without a viommu, even if it is a nop viommu.

I suppose it depends what it looks like when a real vsmmu is
created.. That probably needs a special viommu object, and do we get
into order problems if the lifecylce becomes split to tsm and viommu?

> RHI v1.0 BET1 specification [5].
> 
> At a high level, the series adds support for:
> - host-side vdev communication and lifecycle management
> - host handling of RHI DA object read/size requests
> - host-side fetching and caching of interface reports and measurements
> - KVM handling of vdev request/complete exits
> - KVM handling of map/validation exits and teardown on granule destroy
> - vdev transition to TDISP RUN state
> - enabling DA in Realm create parameters
> 
> The series builds upon the TSM framework patches posted at [2] and depends on
> the KVM CCA patchset [3]. A git repository containing all related changes is
> available at [4]. kvmtool repo is at [6]

It looks like it also needs the series that adds bind to iommufd too

Jason
