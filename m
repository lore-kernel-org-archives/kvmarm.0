Received: from out-11.mta1.migadu.com (out-11.mta1.migadu.com [95.215.58.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28971105
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 00:53:11 +0000 (UTC)
Date: Thu, 30 Mar 2023 00:53:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680137589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u129OKoERAusr1NcAeNxizNI/fvdAMSKczWd0d3woXA=;
	b=wgi8ze+4zyW4qXl5dkwHr7dgFhgMpyWcpSuhdRy1cLNy8ZfdJgYLxWHAL6obzqTQvtrGeA
	uwwf/fsHapyKjPPJa/AQV4ilwXvLvSVaIGdcOXpMllTRLWci+cP66IoWvGixTD/q0Xdy7m
	3ZEzzgoIB8WDFdYOtDq7qCLIGTbFxBc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
	Ricardo Koller <ricarkol@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/7] KVM: arm64: Implement
 kvm_arch_flush_remote_tlbs_range()
Message-ID: <ZCTdcJLxWBRXItSM@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-5-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206172340.2639971-5-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 06, 2023 at 05:23:37PM +0000, Raghavendra Rao Ananta wrote:
> Implement kvm_arch_flush_remote_tlbs_range() for arm64,
> such that it can utilize the TLBI range based instructions
> if supported.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/mmu.c              | 15 +++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index dee530d75b957..211fab0c1de74 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1002,6 +1002,9 @@ struct kvm *kvm_arch_alloc_vm(void);
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>  
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
> +
>  static inline bool kvm_vm_is_protected(struct kvm *kvm)
>  {
>  	return false;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e98910a8d0af6..409cb187f4911 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -91,6 +91,21 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>  	return 0;
>  }
>  
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
> +{
> +	phys_addr_t start, end;
> +
> +	if (!system_supports_tlb_range())
> +		return -EOPNOTSUPP;

There's multiple layers of fallback throughout this series, as it would
appear that deep in __kvm_tlb_flush_range() you're blasting the whole
VMID if either the range is too large or the feature isn't supported.

Is it possible to just normalize on a single spot to gate the use of
range-based invalidations? I have a slight preference for doing it deep
in the handler, as it keeps the upper layers of code a bit more
readable.

> +	start = start_gfn << PAGE_SHIFT;
> +	end = (start_gfn + pages) << PAGE_SHIFT;
> +
> +	kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, &kvm->arch.mmu,
> +			start, end, KVM_PGTABLE_MAX_LEVELS - 1, 0);
> +	return 0;
> +}
> +
>  static bool kvm_is_device_pfn(unsigned long pfn)
>  {
>  	return !pfn_is_map_memory(pfn);
> -- 
> 2.39.1.519.gcb327c4b5f-goog
> 
> 

-- 
Thanks,
Oliver
