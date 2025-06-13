Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407772853E0
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 22:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749852523; cv=none; b=Rd86ctxdri3Yl7VTfPWOHYHGusfUEcSplbagK2zfK7+GI8FsdyxhThEt97fmF8Bm8VcZBLtXAyOSLBjhPa3nRlsViZJWQWnnvouBn54CXIdsJP/7xU3RCRoZS446hwsaAoy1V3gGlT1yzxvwwWwzRfz2V1G58Lz++nhNfBI7Lhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749852523; c=relaxed/simple;
	bh=fkr4HJOJpy9exfwJGhkn9TQt7LDzat+z9jZTC9JW58k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aF9sKTFwWF2m4EFsrZUt8HMTAknVSxkRwUjBmDAfUfh3iat1UDHqshsVpWWsKHpEHZWbORXA1VncMvXba2TvxBwBGJQU7M1B4PdG+9Uq+iPr6jcJ/SL01vVDSRroQ4JcLXNNs74Hi54ZbVsvVda/ESiGcLTE7+ybiu2ks6bQWyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ppTlxlWa; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ppTlxlWa"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2eeff19115so3167054a12.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 15:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749852521; x=1750457321; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wb4jmnBC8sBuVz3+2UsGpTIRs7ejQyw5kumAZcoTVsA=;
        b=ppTlxlWayVAGb/tNbOGnfT8kZXEwpYP0gpuuHYG9w9mx94viZyoc54LGmhQjMYRjXB
         hKtF1Zqs1U1dn3NEXhT1k34P8E7yB6Xa903Nbwy3zzQieVEfIDGahAT+fp8O79cXx45E
         3Imou7if6W/VUmn7wPRHWTEk1r1lxhJbCXBxlBTJ9A0Gszn2HumF2VKWCO+TBZQDRMQw
         qUwTk4kTAj6LAEdxN/LYzGMgffIRQbaoVSC2sHYcvuWzWFbs33hQcceznalNMZU84/1s
         KboTD+UfNDiQFZ20J7KtQdEZ3sxwe59Ke/xyd3KZ23ywqCMcsuFe9AeAgHdcz028vZlR
         TpUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749852521; x=1750457321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wb4jmnBC8sBuVz3+2UsGpTIRs7ejQyw5kumAZcoTVsA=;
        b=JMvg6EUNx4Xg4uvf3nFNkYiwMwl2PEzZMVGTJybDfdccmyr38sfZ3sHTzm6L9x/ift
         QyMvmuwzzr0DKwIasnJYCpx3UNmLcD3yPzvfYD6Ga+aRG8R6fKfk7LMi7aJPiAdhyxEH
         YdImH5/CCh05evFBcbVrKBGXAwjXlze8mWDFfvUSICu3qNwsXxUeNlXGsQkN9lI/1R+F
         HZXTIYR+sdtE0Y8JWbPV1BHuq80aQdYmqDECfGLLf3lZ1Va+b+SAIXC0XyM7cAdNNOVv
         HK3ZNuj4TNbMo3neEv4Pzm9srGdyuFQERqdJ331cZsMRK543ghVfPFkLI0sLNoUe1H44
         +k+g==
X-Forwarded-Encrypted: i=1; AJvYcCUjmy1L+ipobDeXQRWZamGt7wKkPdidLloiQhhHyTmx6gvnCln9C28a4A688nDSJZlgmnRuJEs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUyBKEUL2qVYwwkp/RIyElJD2L9+QECFl11tDPh0QE/qOURS0g
	CkVQWb86JBnuDSMRC6xWVDPK0WV6EtKxn86cpoB10b7LnscqDH7Yx6H1zGpVS1FgZC1cYK+L06n
	/x+A6aQ==
X-Google-Smtp-Source: AGHT+IGdSPExuUA1/ibuJO19NsPM4/rKLVlAf2LsB0b+mN/T6vNzkkutRovkAexiqJtYBe7+n13vgpVYIl8=
X-Received: from pfm6.prod.google.com ([2002:a05:6a00:726:b0:746:19fc:f077])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7316:b0:21f:8817:f695
 with SMTP id adf61e73a8af0-21fbd5590a9mr1355927637.25.1749852521334; Fri, 13
 Jun 2025 15:08:41 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:08:39 -0700
In-Reply-To: <20250611133330.1514028-11-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-11-tabba@google.com>
Message-ID: <aEyhHgwQXW4zbx-k@google.com>
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 11, 2025, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> For memslots backed by guest_memfd with shared mem support, the KVM MMU
> must always fault in pages from guest_memfd, and not from the host
> userspace_addr. Update the fault handler to do so.

And with a KVM_MEMSLOT_GUEST_MEMFD_ONLY flag, this becomes super obvious.

> This patch also refactors related function names for accuracy:

This patch.  And phrase changelogs as commands.

> kvm_mem_is_private() returns true only when the current private/shared
> state (in the CoCo sense) of the memory is private, and returns false if
> the current state is shared explicitly or impicitly, e.g., belongs to a
> non-CoCo VM.

Again, state changes as commands.  For the above, it's not obvious if you're
talking about the existing code versus the state of things after "this patch".


> kvm_mmu_faultin_pfn_gmem() is updated to indicate that it can be used to
> fault in not just private memory, but more generally, from guest_memfd.

> +static inline u8 kvm_max_level_for_order(int order)

Do not use "inline" for functions that are visible only to the local compilation
unit.  "inline" is just a hint, and modern compilers are smart enough to inline
functions when appropriate without a hint.

A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZC@google.com

> +static inline int kvm_gmem_max_mapping_level(const struct kvm_memory_slot *slot,
> +					     gfn_t gfn, int max_level)
> +{
> +	int max_order;
>  
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;

This is dead code, the one and only caller has *just* checked for this condition.
>  
> -	host_level = host_pfn_mapping_level(kvm, gfn, slot);
> -	return min(host_level, max_level);
> +	max_order = kvm_gmem_mapping_order(slot, gfn);
> +	return min(max_level, kvm_max_level_for_order(max_order));
>  }

...

> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> +static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,

This is comically verbose.  C ain't Java.  And having two separate helpers makes
it *really* hard to (a) even see there are TWO helpers in the first place, and
(b) understand how they differ.

Gah, and not your bug, but completely ignoring the RMP in kvm_mmu_max_mapping_level()
is wrong.  It "works" because guest_memfd doesn't (yet) support dirty logging,
no one enables the NX hugepage mitigation on AMD hosts.

We could plumb in the pfn and private info, but I don't really see the point,
at least not at this time.

> +					    struct kvm_page_fault *fault,
> +					    int order)
>  {
> -	u8 req_max_level;
> +	u8 max_level = fault->max_level;
>  
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +	max_level = min(kvm_max_level_for_order(order), max_level);
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> -	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
> -	if (req_max_level)
> -		max_level = min(max_level, req_max_level);
> +	if (fault->is_private) {
> +		u8 level = kvm_x86_call(private_max_mapping_level)(kvm, fault->pfn);

Hmm, so the interesting thing here is that (IIRC) the RMP restrictions aren't
just on the private pages, they also apply to the HYPERVISOR/SHARED pages.  (Don't
quote me on that).

Regardless, I'm leaning toward dropping the "private" part, and making SNP deal
with the intricacies of the RMP:

	/* Some VM types have additional restrictions, e.g. SNP's RMP. */
	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
	if (req_max_level)
		max_level = min(max_level, req_max_level);

Then we can get to something like:

static int kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
				      struct kvm_page_fault *fault)
{
	int max_level, req_max_level;

	max_level = kvm_max_level_for_order(order);
	if (max_level == PG_LEVEL_4K)
		return PG_LEVEL_4K;

	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
	if (req_max_level)
		max_level = min(max_level, req_max_level);

	return max_level;
}

int kvm_mmu_max_mapping_level(struct kvm *kvm,
			      const struct kvm_memory_slot *slot, gfn_t gfn)
{
	int max_level;

	max_level = kvm_lpage_info_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM);
	if (max_level == PG_LEVEL_4K)
		return PG_LEVEL_4K;

	/* TODO: Comment goes here about KVM not supporting this path (yet). */
	if (kvm_mem_is_private(kvm, gfn))
		return PG_LEVEL_4K;

	if (kvm_is_memslot_gmem_only(slot)) {
		int order = kvm_gmem_mapping_order(slot, gfn);

		return min(max_level, kvm_gmem_max_mapping_level(kvm, order, NULL));
	}

	return min(max_level, host_pfn_mapping_level(kvm, gfn, slot));
}

static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
				    struct kvm_page_fault *fault)
{
	struct kvm *kvm = vcpu->kvm;
	int order, r;

	if (!kvm_slot_has_gmem(fault->slot)) {
		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
		return -EFAULT;
	}

	r = kvm_gmem_get_pfn(kvm, fault->slot, fault->gfn, &fault->pfn,
			     &fault->refcounted_page, &order);
	if (r) {
		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
		return r;
	}

	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
	fault->max_level = kvm_gmem_max_mapping_level(kvm, order, fault);

	return RET_PF_CONTINUE;
}

int sev_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault)
{
	int level, rc;
	bool assigned;

	if (!sev_snp_guest(kvm))
		return 0;

	if (WARN_ON_ONCE(!fault) || !fault->is_private)
		return 0;

	rc = snp_lookup_rmpentry(fault->pfn, &assigned, &level);
	if (rc || !assigned)
		return PG_LEVEL_4K;

	return level;
}
> +/*
> + * Returns true if the given gfn's private/shared status (in the CoCo sense) is
> + * private.
> + *
> + * A return value of false indicates that the gfn is explicitly or implicitly
> + * shared (i.e., non-CoCo VMs).
> + */
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> -	return IS_ENABLED(CONFIG_KVM_GMEM) &&
> -	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +	struct kvm_memory_slot *slot;
> +
> +	if (!IS_ENABLED(CONFIG_KVM_GMEM))
> +		return false;
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
> +		/*
> +		 * Without in-place conversion support, if a guest_memfd memslot
> +		 * supports shared memory, then all the slot's memory is
> +		 * considered not private, i.e., implicitly shared.
> +		 */
> +		return false;

Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually exclusive with
mappable guest_memfd.  You need to do that no matter what.  Then you don't need
to sprinkle special case code all over the place.

> +	}
> +
> +	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  }
>  #else
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> -- 
> 2.50.0.rc0.642.g800a2b2222-goog
> 
