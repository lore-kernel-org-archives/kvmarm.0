Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A471B2E5B2F
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 13:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753276966; cv=none; b=IrITPgm0BXeJ8Y7c8VCH5Z+uPkBACjnr3vZ40Q71vu6FzBIGKw3Rc9oaPCz+8dfCyuCRmD83n9uGoDaLq5nRuAQUgLswAXJxK8s2XZjbWfPKjh8sxOoD+VzU0t+uUdvPHUpsimd6QWv2Mm3oQK7IxK5RGRklT04pZlrfBRhgkX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753276966; c=relaxed/simple;
	bh=lZwfTjcBodcwPNMmYFfMC7xLDkXH128h6IWYxQF0jWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=smKfFSZJOO7AiYDc88A5PG3LxBu8b6J3JbLvEdg3Z/VWV1P8egPB4gtigiAz6TWCEO3oScSAMEgrBUUSur9y5MHPEF+Tw5H7i0CJoWtauHqHrmg17CkXMTJCHYT9wDLmwudOqtXIt/P1AbZbLkAahKQF3K/MhA4FE/SOECXI65A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cmtskja3; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cmtskja3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753276965; x=1784812965;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lZwfTjcBodcwPNMmYFfMC7xLDkXH128h6IWYxQF0jWM=;
  b=cmtskja3mUPlsknGj9CJXeejIiq6HWn5m/rMtuGHJgsnKAWLVi0SCqvI
   H3oYsiPRXCwwg8Nebx0Izz/NHKPjNyEQeyGusst6YyvQe8kw9UTfsuc7w
   z1iw8ZS0FXRCxzdg9bgRePshHbHL/V1i1T3PVgLmS8o9mEXuWS8JO3ySN
   N+Fnrapo4tUvsDr4+EIT8Fg+aiwoBZ0pbmpvZe/UDO2OaWYz4p1vnTG+Y
   jnyFJ+wqaaNId3sJ8l1cyxjRaD+isshpSiJ/kxiR9+p2dTwKlmq1lrcG7
   4seaiNe5xi+kt4iLZkMq3f+h1wkX3rv2ay29P21D1EDr583BeYAx8cTz+
   w==;
X-CSE-ConnectionGUID: Z7etUMBbTZShAu+WSDyEHA==
X-CSE-MsgGUID: P5oR7A30Q/KqwbAp7n5Jrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55263693"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55263693"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:22:43 -0700
X-CSE-ConnectionGUID: 7nYSh/4eTv2bYoGNAVW/Bw==
X-CSE-MsgGUID: zU8D2+MbRPm4bAv5IqzQBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159528654"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:22:29 -0700
Message-ID: <3f337306-e79f-4ac7-bb86-60b88b262e88@intel.com>
Date: Wed, 23 Jul 2025 21:22:25 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 04/22] KVM: x86: Select TDX's KVM_GENERIC_xxx
 dependencies iff CONFIG_KVM_INTEL_TDX=y
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
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-5-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-5-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
> from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
> KVM.  There is no need to enable KVM's private memory support just because
> the core kernel's INTEL_TDX_HOST is enabled.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/Kconfig | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 402ba00fdf45..13ab7265b505 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -95,8 +95,6 @@ config KVM_SW_PROTECTED_VM
>   config KVM_INTEL
>   	tristate "KVM for Intel (and compatible) processors support"
>   	depends on KVM && IA32_FEAT_CTL
> -	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> -	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
>   	help
>   	  Provides support for KVM on processors equipped with Intel's VT
>   	  extensions, a.k.a. Virtual Machine Extensions (VMX).
> @@ -135,6 +133,8 @@ config KVM_INTEL_TDX
>   	bool "Intel Trust Domain Extensions (TDX) support"
>   	default y
>   	depends on INTEL_TDX_HOST
> +	select KVM_GENERIC_PRIVATE_MEM
> +	select KVM_GENERIC_MEMORY_ATTRIBUTES

I had a similar patch internally, while my version doesn't select 
KVM_GENERIC_MEMORY_ATTRIBUTES here since it's selected by 
KVM_GENERIC_PRIVATE_MEM.

Anyway, next patch clean it up as well.

>   	help
>   	  Provides support for launching Intel Trust Domain Extensions (TDX)
>   	  confidential VMs on Intel processors.

