Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9BB17BD6
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 04:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752638943; cv=none; b=VHOL33m0bzL2zQKSZj5PL3Eg5WmjBdtFjRH9OLHcUxxwuKooW5Fq67j5PNB41g4SxjXpNg/vMg+oG4xTc3K/EelpPEIlGT9wADX2ku5iBpnswsYpJOZBRMsmZ5OJaZdkDdHSMgnPiXPvkMWe4CNlHRBuEByI0xG83Z8G2+vjdxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752638943; c=relaxed/simple;
	bh=HgzFa1xmLCqd7SiqxwPlH23pvguIpjfNfvSPSfglfnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fiwAvHI2Y79NIFuRlJACEKSbP3DGZ0NXVP2nDyeD7y8SG8nX2RaEFBDbhYVIqT+QfEC5XLHa68CGiq9GJYVXRRlF9VN9GC7UCDpdnKwIgqiU3mC+G8nGxRIn6dtx8qbEVGnLuNd+MEng2D4n0EsrhrYNAOLIfPIi4jhpeNZorxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gMysBm6I; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gMysBm6I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752638942; x=1784174942;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HgzFa1xmLCqd7SiqxwPlH23pvguIpjfNfvSPSfglfnc=;
  b=gMysBm6IHb8D/65gtp1133bFxmLgUy0j0OIWemvsKJgs6cV+8jVmtOJc
   nKLJrdqUnnnq56ximyl0oiLodxNWNPOjAlmXPN/Hm8/1Hom2/i7rR4ZWf
   OZYo05uZkxIvvY9d0QglcR5xp7rkCi3cXHsETn81x0WSnBW5sjmeAA7ks
   QUdiQHPG3yjv6E1YahhJbAdVaYCLrEt63Xz4uq0vqifOW6qBuu/UH0Kv0
   0C7Y7IS6k2ETQv4QFzy4Gg+yqk7nzybGFinghGti9f1PbNxno7TnnUd9r
   03DDSDt4pDvwALD7vTkYAhv/eCoFWoZ4tFAa0ZRFABTiwOxxztiC3sXmE
   g==;
X-CSE-ConnectionGUID: C8Dr+v0eSv+XuSAW0qEg+w==
X-CSE-MsgGUID: zR7sbmIOTXipgu+WZhKr0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="55023476"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="55023476"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 21:09:00 -0700
X-CSE-ConnectionGUID: AzIyrgphT4iDuvN4WCqAHQ==
X-CSE-MsgGUID: qhm7N5zmQuuzHyzKWfIQMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="162938430"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 21:08:45 -0700
Message-ID: <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com>
Date: Wed, 16 Jul 2025 12:08:42 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-3-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250715093350.2584932-3-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> The original name was vague regarding its functionality. This Kconfig
> option specifically enables and gates the kvm_gmem_populate() function,
> which is responsible for populating a GPA range with guest data.

Well, I disagree.

The config KVM_GENERIC_PRIVATE_MEM was introduced by commit 89ea60c2c7b5 
("KVM: x86: Add support for "protected VMs" that can utilize private 
memory"), which is a convenient config for vm types that requires 
private memory support, e.g., SNP, TDX, and KVM_X86_SW_PROTECTED_VM.

It was commit e4ee54479273 ("KVM: guest_memfd: let kvm_gmem_populate() 
operate only on private gfns") that started to use 
CONFIG_KVM_GENERIC_PRIVATE_MEM gates kvm_gmem_populate() function. But 
CONFIG_KVM_GENERIC_PRIVATE_MEM is not for kvm_gmem_populate() only.

If using CONFIG_KVM_GENERIC_PRIVATE_MEM to gate kvm_gmem_populate() is 
vague and confusing, we can introduce KVM_GENERIC_GMEM_POPULATE to gate 
kvm_gmem_populate() and select KVM_GENERIC_GMEM_POPULATE under 
CONFIG_KVM_GENERIC_PRIVATE_MEM.

Directly replace CONFIG_KVM_GENERIC_PRIVATE_MEM with 
KVM_GENERIC_GMEM_POPULATE doesn't look correct to me.

> The new name, KVM_GENERIC_GMEM_POPULATE, describes the purpose of the
> option: to enable generic guest_memfd population mechanisms. This
> improves clarity for developers and ensures the name accurately reflects
> the functionality it controls, especially as guest_memfd support expands
> beyond purely "private" memory scenarios.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/kvm/Kconfig     | 6 +++---
>   include/linux/kvm_host.h | 2 +-
>   virt/kvm/Kconfig         | 2 +-
>   virt/kvm/guest_memfd.c   | 2 +-
>   4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2eeffcec5382..df1fdbb4024b 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -46,7 +46,7 @@ config KVM_X86
>   	select HAVE_KVM_PM_NOTIFIER if PM
>   	select KVM_GENERIC_HARDWARE_ENABLING
>   	select KVM_GENERIC_PRE_FAULT_MEMORY
> -	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
> +	select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
>   	select KVM_WERROR if WERROR
>   
>   config KVM
> @@ -95,7 +95,7 @@ config KVM_SW_PROTECTED_VM
>   config KVM_INTEL
>   	tristate "KVM for Intel (and compatible) processors support"
>   	depends on KVM && IA32_FEAT_CTL
> -	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> +	select KVM_GENERIC_GMEM_POPULATE if INTEL_TDX_HOST
>   	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
>   	help
>   	  Provides support for KVM on processors equipped with Intel's VT
> @@ -157,7 +157,7 @@ config KVM_AMD_SEV
>   	depends on KVM_AMD && X86_64
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select ARCH_HAS_CC_PLATFORM
> -	select KVM_GENERIC_PRIVATE_MEM
> +	select KVM_GENERIC_GMEM_POPULATE
>   	select HAVE_KVM_ARCH_GMEM_PREPARE
>   	select HAVE_KVM_ARCH_GMEM_INVALIDATE
>   	help
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 755b09dcafce..359baaae5e9f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2556,7 +2556,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
>   #endif
>   
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
>   /**
>    * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
>    *
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 49df4e32bff7..559c93ad90be 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -116,7 +116,7 @@ config KVM_GMEM
>          select XARRAY_MULTI
>          bool
>   
> -config KVM_GENERIC_PRIVATE_MEM
> +config KVM_GENERIC_GMEM_POPULATE
>          select KVM_GENERIC_MEMORY_ATTRIBUTES
>          select KVM_GMEM
>          bool
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b2aa6bf24d3a..befea51bbc75 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -638,7 +638,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   }
>   EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>   
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
>   long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>   		       kvm_gmem_populate_cb post_populate, void *opaque)
>   {

