Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059F420E8
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 08:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688544476; x=1720080476;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Cn1WBv4JrMsrgoasE/lasO/n0SnRwlADo/SoWnSzf8M=;
  b=lsZ5SoVwR3idIfCHjkIkIXc3xBayaZeRdhKH6ZwBNO3IMIkSGzj6ScAU
   85fsUvgTQDmoLp4128dcr5VTzt5k51reV67k0nRyEmnAkh3/Qmbdzewhg
   UmP6LrivNtLZyh9jRKRHxgUnFl4gdz39d/lMIF9VTaA1wER4TnTmTFjSk
   vFcFDgMhm4YOF5L8CkLFohIFgYSRrAINd6AUt+GAXZD2Mhp96pHHwO0EN
   QmHBmAOTfUQySQEc7D8WiWn9iQFpu9j2Ilud23Kh5Oeos9II2FanrP7SX
   5Rs5tpuQfWQSIg4CM7X7huAa6LGF+wwTVvlAqEp4V1Q8H7xa7MILu0K2e
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="343610816"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="343610816"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 01:07:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="669323671"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="669323671"
Received: from jialinji-mobl4.ccr.corp.intel.com (HELO localhost) ([10.255.30.200])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 01:07:50 -0700
Date: Wed, 5 Jul 2023 16:07:56 +0800
From: Yu Zhang <yu.c.zhang@linux.intel.com>
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 4/8] KVM: x86/mmu: Migrate to __kvm_follow_pfn
Message-ID: <20230705080756.xv7fm3jxewipunvn@linux.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-5-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-5-stevensd@google.com>
User-Agent: NeoMutt/20171215

On Tue, Jul 04, 2023 at 04:50:49PM +0900, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..e44ab512c3a1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4296,7 +4296,12 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> -	bool async;
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = fault->gfn,
> +		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
> +		.allow_write_mapping = true,
> +	};
>  
>  	/*
>  	 * Retry the page fault if the gfn hit a memslot that is being deleted
> @@ -4325,12 +4330,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			return RET_PF_EMULATE;
>  	}
>  
> -	async = false;
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> -	if (!async)
> -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> +	foll.flags |= FOLL_NOWAIT;
> +	fault->pfn = __kvm_follow_pfn(&foll);
> +
> +	if (!is_error_noslot_pfn(fault->pfn))
> +		goto success;
> +
> +	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
> +		return RET_PF_CONTINUE;

IIUC, FOLL_NOWAIT is set only when we wanna an async fault. So
KVM_PFN_ERR_NEEDS_IO may not be necessary? 

B.R.
Yu
