Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2049.outbound.protection.outlook.com [40.107.101.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B0D25CC73
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 12:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749471849; cv=fail; b=F0hiV4ZMQj9rErJgJ7jnOeH0r7U9cavRrcLpueRJr9AUm/K+YRZX7v/gs3Z4OHABtFW1iCZccig9TgGfvwuuay0jaSKtaKHhlAS/cq4TsBdKTNaIlTHewWoKw9DVswYliHEmfb/2WlYDrzzCXhZm6d6Y6I8HfTCrh2IwWiT65nA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749471849; c=relaxed/simple;
	bh=ebF6FSXo5Qe5T2Cepn0csZMlG2+30aB65SBaT9quNmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=coZJB72RNSr4zIR+UAKu/iGkh35rKToLgjokAbU/B7IuvV35rckVPn2I1NfrgXVJWQoZNAscKK2BcMHCZysVez5BhlELrO17EAiiGmUo7Gc4UMCl+KFbz+z33mJA7cUJi/J3eQS+GIUNchrbarEQpFLD8Qc0r5CuLHFiAoQ4QNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VjBuTEEV; arc=fail smtp.client-ip=40.107.101.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VjBuTEEV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IEvhf5Fx7zRPhtQvlWd/pBHHx/BvRgN5r6R5ozwJ8qZ7tk4ffAL7jS/0H0krwRDEDRF037Bo7FNxjs5bJmnRgXXMlhwCUz0VbQwsfzfxw6XrjqDf0h2DYa9sXqLgVrDPIAcGE9gzUkJlokFAC+8nmaSWBLxTaRPCM8r6mgTFqvArtjrXpmiR+kOTvY/CuitfzS72YOOp5Gr0QFLGe4QLPk7PrNIiCxp1NQU/o/90JINQfyuVbjJ+TDQNL7x6hyFrNC47/nJ+p2USgK+v/coUXW0Zszc+KbC0P9ZcYwt1cgw43QHiI9P3/MsFjKR/VzAnQDJTdFd0Yc7ork/OI48eTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjH2OSgESsqnUXB0H7Llg+i/6McMDnu1NDXmqgRHGs8=;
 b=i3jogQZaZGACJ6QaMTG6KnlqtEMQqqOuzguYuENTlmIFQWUmn7lfXE6kNOIGJIcgmxFzdP9eyOd5EY1m5wYMevOa+bmowZihjDr4P+39Tv8K74uTLmJxz6Uuf10Xi4Z4IQH0JbMzAKCc3v3xB6/HxLxa5igQDhF5xv0eECsifYSTz7RBayBWM4d0SSH5o6MuRu1kezeAlC2KdZ0J7NV3C6cUfexxaSeYBTevZKWxPAWDvYA4W2pzWcTLK0XB/rM8OYEDm1Rfahj1qdN4ebarfz4DP0K69fenFsr6lSATEXP9rH3NUE88BIsHIn2+UYZvR8nOvWesa2albfZMRT6avw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjH2OSgESsqnUXB0H7Llg+i/6McMDnu1NDXmqgRHGs8=;
 b=VjBuTEEV/DAueUWYA0xbHUI3hlmh95+mKd1wvQaug1MBWSLuE9c0rEEcCqOOCldzyj90vcCLukL2w5aqiUpgAGLVroQoIJnhNjx469RVlxSSNroUbQOfPVUGvuckkUas7kSbX44qLEiab7lScKlziMROYMIv1OvLssL2as2RUJKBC4yVtjmr8jLtG7Tj/ThGYKhoTzMjiH4wAS7HyHYThEwCIhgMOBBbOGSuWfcQcc+R+uXRW/AZ+LDxGrywA9vBlC5Np69f1saWmNmQYnU3LZ7qKShjN0VYpuMTCBhqxvNJ0tNCU/MhYJUZmU4adEPXDjSiCrCmz0oOq4wDldYlUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BN3PR12MB9593.namprd12.prod.outlook.com (2603:10b6:408:2cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 12:24:04 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 12:24:04 +0000
Date: Mon, 9 Jun 2025 09:24:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	kjaju@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	ddutile@redhat.com, tabba@google.com, qperret@google.com,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
Subject: Re: [PATCH v6 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Message-ID: <20250609122402.GM19710@nvidia.com>
References: <20250524013943.2832-1-ankita@nvidia.com>
 <20250524013943.2832-2-ankita@nvidia.com>
 <aEMvbIu530nCqwhG@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEMvbIu530nCqwhG@google.com>
X-ClientProxiedBy: YT3PR01CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BN3PR12MB9593:EE_
X-MS-Office365-Filtering-Correlation-Id: 21feaaac-b51d-472a-8ba4-08dda7508589
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dvT3JWCpZfw7lkyYiLISeymiVVDDEqzpsrEGetf8rPoy8ZxKbxOBx6sh8EC2?=
 =?us-ascii?Q?tVjiPGDO4oKJGIzx8N5l0mw9L2VVTazothk7n9zeI8TS3GmDDecl94Csk5gz?=
 =?us-ascii?Q?tmZdvTRgCt1NuN9aeGEndYTRLlBQhkmcp8MULxQe8wvue531u4eEk0JYkMg4?=
 =?us-ascii?Q?ftt1w9GPtZGTlCJjwrn7s2FAIfPio6B3CJiHluLK61PXMlJnbj1ZVVohdBE/?=
 =?us-ascii?Q?jmOem5Qf2e2cIaT0HvVyvmbgTfRNgx/jGD/6CA2ngXUAk+NXnh/ONPrxNAPS?=
 =?us-ascii?Q?tC6Wb+NegjhhGsEnjAS+U9n+hJTv5n6fCY3/63KPIVx3W7rNpJHAmXpEltFI?=
 =?us-ascii?Q?3lhpp1bjYGJ7GuthRz4a0mC2Dcw6eWDk3SjaMzNemH5fZ8kOy8MXscb2u0Kc?=
 =?us-ascii?Q?67ty8NtmxGxE/zJpRLHS7z3Am6h4N52aI4urDwDjOIxHkxzK4wwKYoiVsjuj?=
 =?us-ascii?Q?qkevfvuxUw3+SF4//t4Gatc1nikClA+ZpKshGAzfGeoLqQ+XQHajQmtFc+C+?=
 =?us-ascii?Q?HYk4nDlwAeuLCX0rJEhntEPG0ZMmtNGfpKHTeU5I1yto7FZXTXrquDkehGGz?=
 =?us-ascii?Q?JiWbReUrhn5M7twGSRh1PMM5rBEcc8GlG1VGmzkbV5S181aO/x4VWaUCSfbg?=
 =?us-ascii?Q?aqKJ/vEkCXN3zRapMRZH3ExxOZfHLKJ+dKu39Dtf2TU5gAJPcvDbHdYqw0Yu?=
 =?us-ascii?Q?cAdJrkLwN0ULvcJc0kfEUIwcMhCSGgXTf4j60MXl6nBWEUPph8nE3bJ3wlUG?=
 =?us-ascii?Q?KJkQPCxX16F3jNjZ+Ldg8M0a8zYv15sbG56nsFHzjGrbbLAcoIP/ODdXdfKK?=
 =?us-ascii?Q?PdMEvAgpUR05o2D8U6isjTac9ab22c5Me80PZWeNuT8+wfvh0ROL7O6qiLNC?=
 =?us-ascii?Q?Ufmz1aMrpYCkXdKShLVvE/05udvcNYBJKQuHa5WooVGD/VOe5o7uQPVAXy2+?=
 =?us-ascii?Q?hkucCg2h+E9HPvn+5q1u13MPkoGdPF7x5fGZRLf//Ral7IwqiZTMhgVSVhpf?=
 =?us-ascii?Q?TbirR3muwWGxOi+FwRQrH1ez6T+wmwx+q3AdvDOwCOsYgYxfjomwcee0LtpG?=
 =?us-ascii?Q?ODsAMjlGtRLkz0rCgfLKvYN1T4M/qp/BiQfIL4qoQ1v8EQkRpsP2sji3ISSg?=
 =?us-ascii?Q?vzWnT1j3/eRhDPPlCb39Mqw0JBh50+qKcdhUOYLPdXpt7uU/bGSG2t6bVWvn?=
 =?us-ascii?Q?XC0R08xg4Ryodfe8P95cVLBjEJBwxmdZUocQtF05TMeW10408CbovYszQbP1?=
 =?us-ascii?Q?y0GHXyZLG20w+EvGq8t8FeIyKkTy9rxEWHIxGJ7hjISBYCg97HHjxDJt2hW4?=
 =?us-ascii?Q?4yVNkmqnkJ5mH/PsblFZN5MOpw2zPLQPeVwrViNcW0LCNm+ZxO/MNnkuhouu?=
 =?us-ascii?Q?rB8F0OH44TdFylk1Y14LfIMUaJmVFLs/N1bcXcAHGMgSRFWrGNGEAQQVS1o2?=
 =?us-ascii?Q?HW3mtCgkSi8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8JPHjGhqk/IwZzcQMPdCVywpMv73UQh33R6taZ2nBw94rZ4ZdTAyA3rvWhSb?=
 =?us-ascii?Q?3X5c/nfC3vZ3n0taN/XmvbquIn5E8RdfpK4bLUpCwsiafMms974g00jYQMlF?=
 =?us-ascii?Q?ZhY/iI/mxQyw7Qg0qJnTfeWzoqOgMqlUMG98Je5h2yoqwltoU3Rm9vd+TI/r?=
 =?us-ascii?Q?ARzDQGahjjtQk/Cb1GCI/jNtNxU34GyzNR5pwNjZBMLNUV321K3tE6eFksz7?=
 =?us-ascii?Q?lKQsfuDA0u5tbx5m80TYdb4PuWRBdDTKZGqE1F6y0vrDFZHh8Tp801b//aFb?=
 =?us-ascii?Q?FC+D9p1pP4HVokQap7IyafR1kNb+BFwAiDsGm7JuKV9FAKdVFlP9u5AdXfgz?=
 =?us-ascii?Q?pZO6r9BDdsNS0pEoBaz1umjgX4Hgwj9M+p3FJwh0tEjxFcKkRiRmfAlbmlnn?=
 =?us-ascii?Q?PBaURbaX2nIIuuwyhu4XGPeE4W3TLrD9h8cNNyikr+64p87gYt18ALXnGj/r?=
 =?us-ascii?Q?HicbACUtU6gqpWxGYPAAxxe+0oVaNJWvErPI5+zjrh4YqPcZmD+v2+hrmiCg?=
 =?us-ascii?Q?MqBPP0WYObCw9yC6dAYuKW0ewBv2lxb0f98Ck8knEinZG4T0S9FuoFO+3Z6A?=
 =?us-ascii?Q?FsZYCPeLWNdsX9Myt3IgirCiHgy2uqCRXDNe2LHP5W1dW+i4oa95z6DwB/oy?=
 =?us-ascii?Q?YjxHtin+ofB2PyaiGn2xK/Y8qAz3xF5pdh/LDe+K8AZAVPn3eUv2I9sNrS70?=
 =?us-ascii?Q?rAjeBPeQaOydZkSl0HTUAS0OhhGRZlmH0kSlzyWFFaVUk4xyrNywtICE7pXk?=
 =?us-ascii?Q?zBbMo+P1sqFp3dkjMbj44QSKPgLrQjm1raA/GIoyoSy3sJ1iJmQEJ2Sx9owW?=
 =?us-ascii?Q?jHii8fnWsZ+g+312W3i2cLPnV/O6UL3/fIxFyoO2VewHQLMoKy3aBQlCp6qa?=
 =?us-ascii?Q?mXKa9+ilc/qUg15EM58XxmcCQU90sb149WQF9J6M7FxqokMot9L31aXdrfvv?=
 =?us-ascii?Q?8Tax0Au144XELI4WxYq6gjqdYrO1LNrWxkRvOLEyOyBNadYqsS+QjbErp9Pf?=
 =?us-ascii?Q?HjwjPcdWQyZe2E0o1qBdP8UWART5TsLHUfSaffZoMg2EHh2n1DcHIhlVYsYQ?=
 =?us-ascii?Q?UDCCgCUVvcyVONo59xm6DjZIMNWG34f8ngBCg/krdHoknQuLX7FDyGkz7XyD?=
 =?us-ascii?Q?GWqoCpoDWjCprIfa7mpPjYxBsU+xD6CMygOqESkgS4vyO1Ij0yQM68GjTng/?=
 =?us-ascii?Q?sTqAVEjGXgu5+mFmL9/ETKfpzFB2vtGx/T2re0FWO6mOABPNIp/5MrTUL1b+?=
 =?us-ascii?Q?/TN6/gdcdV54qdwBo5xwpcfB+bx9b1xP+7FiwlXsPx4CdIgOn/QdtvOWnM4h?=
 =?us-ascii?Q?AU2x/I6aq/Sn9qyBli0qQcMNfg71nglwjV4fykVF2rrntX0TVraD7pPj2bmR?=
 =?us-ascii?Q?h9pKL1fw7HEnJ9cAd5+voVZ6LFtIM4WiN+HOGFceympRWmgN0/ucL8E3Xpv3?=
 =?us-ascii?Q?WS13wQEUJrnFKkZK3JgqYln6ul9I6ik9jQrvI6JU8UMSOx0nkm0rGQuPYb3n?=
 =?us-ascii?Q?dwOZ0zxA4GJN3jZK5jCx9Ji/WyYupAGjoUiiSiV51a9pEWKBS1uXPBqwM8/z?=
 =?us-ascii?Q?n6yrxvN7ovFHk0h5IEU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21feaaac-b51d-472a-8ba4-08dda7508589
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 12:24:04.0224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eemd32IaHMSKg9bRyJtivsj+9tyOhouP8t4HtSD2ZlJEPyQJ0MhpnVvIAxEQtBkG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9593

On Fri, Jun 06, 2025 at 11:11:56AM -0700, Sean Christopherson wrote:
> > @@ -1612,6 +1624,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  
> >  	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> >  
> > +	if ((vma->vm_flags & VM_PFNMAP) &&
> > +	    !mapping_type_noncacheable(vma->vm_page_prot))
> 
> I don't think this is correct, and there's a very real chance this will break
> existing setups.  PFNMAP memory isn't strictly device memory, and IIUC, KVM
> force DEVICE/NORMAL_NC based on kvm_is_device_pfn(), not based on VM_PFNMAP.

kvm_is_device_pfn() effecitvely means KVM can't use CMOs on that
PFN. It doesn't really mean anything more..

PFNMAP says the same thing, or at least from a mm perspective we don't
want drivers taking PFNMAP memory and then trying to guess if there
are struct pages/KVAs for it. PFNMAP memory is supposed to be fully
opaque.

Though that confusion seems to be a separate issue from this patch.

> 	if (kvm_is_device_pfn(pfn)) {
> 		/*
> 		 * If the page was identified as device early by looking at
> 		 * the VMA flags, vma_pagesize is already representing the
> 		 * largest quantity we can map.  If instead it was mapped
> 		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
> 		 * and must not be upgraded.
> 		 *
> 		 * In both cases, we don't let transparent_hugepage_adjust()
> 		 * change things at the last minute.
> 		 */
> 		device = true;

"device" here is sort of a mis-nomer, it is really just trying to
setup the S2 so that CMOs are not going go to be done.

Calling it 'disable_cmo' would sure make this code clearer..

> @@ -1639,6 +1653,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 return -EFAULT;
>  
>         if (kvm_is_device_pfn(pfn)) {
> +               if (is_vma_cacheable)
> +                       return -EINVAL;
> +

eg

if (!kvm_can_use_cmo_pfn(pfn)) {
               if (is_vma_cacheable)
                       return -EINVAL;

>                  * If the page was identified as device early by looking at
>                  * the VMA flags, vma_pagesize is already representing the
> @@ -1722,6 +1739,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 prot |= KVM_PGTABLE_PROT_X;
>  
>         if (device) {
> +               if (is_vma_cacheable) {
> +                       ret = -EINVAL;
> +                       goto out;
> +               }

if (disable_cmo) {
               if (is_vma_cacheable)
                       return -EINVAL;

Makes alot more sense, right? If KVM can't do CMOs then it should not
attempt to use memory mapped into the VMA as cachable.

>                 if (vfio_allow_any_uc)
>                         prot |= KVM_PGTABLE_PROT_NORMAL_NC;
>                 else
> 

Regardless, this seems good for this patch at least.

Jason
