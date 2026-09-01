Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011028.outbound.protection.outlook.com [52.101.57.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74350389106;
	Tue,  1 Sep 2026 13:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788268087; cv=fail; b=W85HjHnYTQ5ImjgelFpDr68cubv5jy9YmKO0At9NzgmlLF2BynspptWPKTmhhBTLi3EEG4U0EuYNuzlpazEe7PJ9YAETfdtRjtRvv7AhbcS/u2OEsIG3vYmabN+CJL8E0rG25afXMPn9YrFupdy3mQPAn4btFbQD6j1oXNFncak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788268087; c=relaxed/simple;
	bh=JxxO+mtpU3tFsAABXrKrRbxTulQSaFofwkwRYhN4qTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nVM6pLMyusVlpz6zOA7V4JqTYH8hdvMHoyuB9c7r1jED95o+4bmbunKc3vu1cTj5PNJnL38OXg8lBaFU53JKIbYhnTpSPNyWNX/arHTpymBS9crj4EP6rO2CGUW51L02dNLxwnhbJHAFn826zyEJLVOrQJsYspb2j50/feJQi3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BbzQhd9X; arc=fail smtp.client-ip=52.101.57.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BbzQhd9X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U1QdYQIIJPtwZmH3iKRuFdLqox9nYnYHf5Yi5sk2Uwbgln71xQlQbBgclvMwBkVxWqxkrQPMaL/FVGPyQDjDiqSmA4oEuq0SthofW0zolAMbPQT2aERsJy7JG4kE9/ruL/dcIx+HyzB7WZNxJVVpYCVCIZr4Fc6gBi90aZGXzHTCZx/IWEfPxwB6BBgbIoCa1Lo92QPKOfYOZPuNrRTkhaz6VEQ/6RfCV5TUfhWdDA786vgTIJtumoYIn+ZiZ7tFxS2rWaFntsIGfsHbfdKywhPb5T6gUgkg7C65INh3CqGOv/DgOjUrUsjsMSz/X6BISoCmQ3iFSj+I5Ly4j/M0sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLv5J+zaKgX2+9oTiEGdUDDck5Vysi88oHfFzxFGDpw=;
 b=ZoLKB1E/J8DWb7x3yOrRvf4SBIdnptnPkBRBauheANNUi8Oj90XklK5lQQi9uC2kbOr0E0KYgVHxcNDDmJMkxojbf9dKLcGbeh1mErtBWXWZErORzJvAmDmf4nPgd/x66W5po5MSWISzu2bklIDTrvaSK1MM7DuDjQNuy52EZ6uLtCTKAYZMSaIh5dtl+ZQXRz6cFOcSShOTa9dyX+cymIrsULuZEH5JN2jGRUVnAu4Z8FhP8dNH1FsqIaIYzzT6bfsyg7gnItKkQLf2UFFr83mSpq9qyEnDwL3rM/WGG6lLdl8tcEY7CyJLPI+sSthkIljFNAmyZddKJHnv0Ig7RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLv5J+zaKgX2+9oTiEGdUDDck5Vysi88oHfFzxFGDpw=;
 b=BbzQhd9X3rm9kDlHD0zDxvQWuBjR0X2OY2A9fSC58GyvdleowEqvaPYnYbkK3jwuZrDalMNQjC8fXfEBFCPJiL7n56oHaR1uVu+QHVvfJpYGRX1xdflu5fyONdjQdVtk72W0uGEr3Iv2bN+bgydn7eMq/o1c33J6P+8jpuHiELZBMIOA0qjMLUYky9LQfolI4zm+akSkEg9UhsyaKbT7qKeeVD2+1Zj5CaPibo5BjBn/YnhfPtCGzz/sSC4uH8Im7Rr6Zz7TFthMwpmrxONOR+6B1nfedzPJkewYrEHeNC0KnNv5VBF+SievNEKgpjR5r2zLXO8VRKo3UGx8qAAboA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB6422.namprd12.prod.outlook.com (2603:10b6:8:b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 13:07:52 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 13:07:52 +0000
Date: Tue, 1 Sep 2026 10:07:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
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
Message-ID: <20260901130749.GH4157646@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260831180855.GA2171358@nvidia.com>
 <yq5aa4q1nnto.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aa4q1nnto.fsf@kernel.org>
X-ClientProxiedBy: BN1PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:408:e0::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB6422:EE_
X-MS-Office365-Filtering-Correlation-Id: c7f4d060-6c52-48c8-c178-08df082a07bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YyWzU+oV1koF0RULoX5/0MbC3mvh7wysmmHkL+VqWcolArBqYvqoK8IT0rAl+VM2Ck4W48bJPGfKq2B5FJqZQ3uwslyajy+IDu+KefppcQQZh8WcTeS+5XJd1etS/8fJ0VVSoY2FG3crI/QtaRcjUoC+63os4g5Ntaz56RQ5ORLdVKEMmHE6YC2gXRyHaKBHDlLr1B74PAjKVO2ZqZCKvJ7y7qFZrG9wijxRwVaJ6NKA3J+gz0bfr0Nor8r3kub1Fl2gelPBCeeeBI8O4BCPeBeMsjWqlvJru5JUwMty9t4RnSk/vnbmVRm/qYHD9NDZeSiyOsQLtuDeH+0cQT3OhSHpc4nga8gVQSD+Xh6K6u12B1iBB4uC/We9rFC3LET/14+ZlPh4/FCVgmD4ULeNf7wP09dNkqjpFKOkQY7YZXD5ixmigEJ+Tr/JUknFcyWVrnfmr8AkrOnZx735tPJdl5bXbDPrO0YhE/4FMpOkWG+paEJTFYN41ewh9PfthjWLs4pc4oIpa/mb2oB3anmqR8UW6BFq5LemLJnNtUirWHUfMVEK4/cjwTXyij8fevoPMdAWFnvzP1PVL4s2ZIET/n6PEg4r/hl1Z4nOymXAxBSVksVt0yYBlDoqiaRv1po8kg6+O7GVct0NtQutKW1zE4VTs/qGxKxycjNxP0k36ns=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UbWS06WW0i8RIfKNm3SjcbUHF/IsZWLG+qjEW0rh/VKiNwWsfU8laqFao44G?=
 =?us-ascii?Q?vorHBA3cpsdZoEW2Dt+NWPOxkquuvweIr5QK9d1gVDEwcbAtErJzU+RM7qpP?=
 =?us-ascii?Q?eulxOvIov6aR9aMy9bCHLCpysB8gDwTVBnoJISCkrbvylsPBMyQ8Fm+ggcWg?=
 =?us-ascii?Q?cVHhFNDVMiDZBnt2Elts4D1aNXv1RIaJSZlLR7I6FpnqlDBxYDiGOuldfjcW?=
 =?us-ascii?Q?QwZ+ZjOhLqGloDEBY7HN60jI8jjC7LjQLAsP3XiqAET2zK4XnD4F7qJLOFHX?=
 =?us-ascii?Q?9CJTzgf00wrAditE0LtEPkoauQpxZR69ibqw9Ihv2YYf0bw8UQoASxLIsuit?=
 =?us-ascii?Q?0pGCoG35OoZaME0n6oqkSFGAD9dcKCq/bxOW9fn7BEKjpY3hLiWq6LSvQjur?=
 =?us-ascii?Q?WCj4+TQY/HTTDjTtDYrAJvAJvDcFYCMKeRjb+SFIAEzu0lvGjaeAa2C8qBB/?=
 =?us-ascii?Q?ult6yJaDVTj1YrMjRIs6jayg8QSg5IkWAXCWx9h4gzxl2HciKSzk4e2d+uMx?=
 =?us-ascii?Q?8K0qQw8kDJHSO0vc5t9rhG8S/oiNxaPdegJYL689xBOqKlyqW0G/ywBarvzX?=
 =?us-ascii?Q?UMUvRRWlOojjaEteHfub2gRyCLpXq3ZVkVoBwPKhPd5ZiLOR+IigddKbuHyv?=
 =?us-ascii?Q?Xpu/m+iMPzP0ex4YYN9+1fVY9AuHKXRhpr2SV6UPWwpqOq5aJ68XXfgoVjE9?=
 =?us-ascii?Q?hgWErPyjqLtBbAKu7u42W8fRex7692CrygTsEYrsZTVZTruMMfwZreTH2sFN?=
 =?us-ascii?Q?r107hye8yOYEaJhanfxvuneO4cxAHBDWMwJmZI27hX3zbuv/I5P9EGK2gC98?=
 =?us-ascii?Q?osx9ploNC9ITqVVZorzvF6XxwS/omiTfewJ911kpdHqUxcbUEtpRv457o5Ux?=
 =?us-ascii?Q?MdRhdzT7nbSMAmlsoIjJF10iNLf+W79E6HA18JIvBJmVrNXATDqTb5kM9dWO?=
 =?us-ascii?Q?eBvXGoWZb4MEpfGSef0sdaPPBSBZawcuyUZH3czxpjjiC3cKlaLgwpzDnczF?=
 =?us-ascii?Q?2tpp1HTfsxzAITiorMtPZp/8e11J5XQ+LNUD2OPljKdXhKbykE4RXpUXWK5z?=
 =?us-ascii?Q?N0842AMcDzAV/4TX4oZlEl0CnyH9IqhN5/FmuzL32cdMUN539YxOj2Bh323/?=
 =?us-ascii?Q?s3ZPn/2C9gn63x47SZj0QniHI/gJ9jHRQraDPwdpZClEy4u/2x6qxJjGo6IB?=
 =?us-ascii?Q?OJEH+7zYMx867rTlPCE1yfIq64rAFeARt6SnBOUn+VSIgQdMDtpj57pkEM+w?=
 =?us-ascii?Q?/HoX8yZ8vf+FjayIuTjJBUYrRQJgbyQftSWsqfdJnuyb65hUQTRyO/N42JW6?=
 =?us-ascii?Q?zE5V6rgWwbLTR8ZxdO9aHywbbqnKyNEqUzQDKpGJ6kEocaxJRYHIyVRR52Uz?=
 =?us-ascii?Q?6w7CFq1J0Hj3qVwDQcE10F1TxxHsya9pY32Qd7KFdKrJwEOlJeTdhHKd4Z8H?=
 =?us-ascii?Q?954QcPI1JYaakxwc2UPJ7H0pv4p3yORIB4XPcWL+bIH4g2FvFItPsFButWKO?=
 =?us-ascii?Q?KbnRhcc7lxnLD7WZX5NQtuYFfUwvp//d8yadqZOhpH8rq7UfNbRIeIv8BcG5?=
 =?us-ascii?Q?UMgf2vw1zJc9Iy816YWxmJjyJoju1qb0EKLtS55pH8Udv56T4NzqKn0Qg4Ad?=
 =?us-ascii?Q?TRveFHUtqGd0bx5mXLE2r4gTcqv/Pe+SHsKmyQlqsulTUGjPDK7zkhSo7Kaj?=
 =?us-ascii?Q?RBh144Ir6UICiapX5GMyf/LM6kjpxb+EqgA3QrfmOxrMPsiO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f4d060-6c52-48c8-c178-08df082a07bc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 13:07:52.3152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmxHJrSpCY/v+hfN1WTHcYcBo4Wt2MLEg51F5BI4QB5m1qfcdvjG+Ry9CrF6Vdm6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6422

On Tue, Sep 01, 2026 at 06:14:19PM +0530, Aneesh Kumar K.V wrote:
> > It is really weird to see a viommu for a case where there is no
> > viommu..
> 
> We ended up with a viommu despite having no stage-1 SMMU or vSMMU
> because it held the KVM reference needed by item (3) above [1]. With the
> recent changes in that series [2], we now inherit the KVM details from
> VFIO through iommufd_device_bind. I can possibly look at using the idev
> for this instead.

Okay, that's a good reason, but the whole thing just doesn't seem
split right. There is code in arm-cca-guest and code in the viommu
that are all working on the same thing. I don't think it makes logical
sense split like this.

The viommu should be creating the vdev at the logical point in its
flow, when the it creates its vdevice. It shouldn't be disjoint and
separated.

> > It doesn't do anything except manage memory for the RMM..
> >
> > It feels wrong that the arm-cca-guest module is calling
> > RMI_PDEV_CREATE and RMI_VDEV_CREATE while the viommu is allocating STE
> > memory for the PDEV. That doesn't make alot of sense? The STE is
> > needed before VDEV_CREATE, right? So why not place it there in the
> > flow?
> >
> > If that's changed then the only thing the viommu does is manage the
> > PSMMU, which again, seems like something VDEV_CREATE needs, so why is
> > a viommu involved at all?
>
> We do not have a separate vdev-create operation; instead, we have
> tsm_bind. The required iommufd objects (idev/viommu) are set up before
> tsm_bind.

You end up with *two* "vdev creation" operations, one through the new
bind iommufd call and another through the actual vdevice create
iommufd call, and they go do different modules. That seems like a
messy flow.

If we are commited to a viommu then lets use the viommu for everything
and have less code in arm-cca-guest. Get rid of bind as a tsm
operation. Have the smmu driver do it when it creates the vdevice.

You can't call RMI_VDEV_CREATE outside the viommu anyhow as the
vdev_id comes from the iommufd vdevice object's vsid.

This is probably going to work better long term anyhow as we can
construct the vsmmu with exactly the same API surface, and a non-vsmmu
case is really just some special variation of the viommu object that
doesn't create do a RMI_VSMMU_CREATE.

Also, is it really OK to setup the psmmu after creating the pdev? RMM
spec explicitly says that order is allowed? It is a litle bit counter
intuitive.

Jason
