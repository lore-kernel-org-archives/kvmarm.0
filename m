Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1841C2192EF
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 20:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750276821; cv=none; b=JqV/jDANrZM09EQXDglR09s+gz56sgg5r6MToQn0DU+7L/txJi03efSjUz1UdV5tShDTIto0KQs2ei80ny6JX6oRFPIZ3OZ2msHaioMgyPCOAozpEqxlvMBbeqzLXQVyjRroqa9qI0OrjkDkWM8i1bgHkPvGrJQow1YE4GXP0aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750276821; c=relaxed/simple;
	bh=nL6yW4jkRLM9ujb92vCw/h/BiAWER2Zgw78Ihcoel3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOCHtQPD8rA9HZs6hxwlEvNsQdUwaMvKQusxcMBdjme7u4HYMEjVSOdhUFgJhzpSXXXlmfvafrTbFEg/dhMajg9Ao9ILr5h5pDa695ZWdV1oZqw/DVJaj9fNx3LHmq8mAYEUjYR/fJb14JM3PJ42SkpNIJciXatAqYeKu/RfGYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JiYBbEb2; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JiYBbEb2"
Date: Wed, 18 Jun 2025 13:00:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750276815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A+Dm5oYqWDH4EBRKuoUENfY0iH02fdrPbML4KrtAoQ0=;
	b=JiYBbEb2aglrXadwd8672PZMcInYhyXyrnzula6TGfNJSEFIyKtU038Tqyb8BobbBBu9qh
	B5ndenDDZwJjqoM1lUiF8Mw3SOuJf5QdA7kZDOgvvmF34OQGBa5ZKIUxhB0Vj7eMRJ+8Zf
	tXAdy9DLItnEhRcHHn0AGW2v8RxKayI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 03/15] KVM: arm64: x86: Require "struct
 kvm_page_fault" for memory fault exits
Message-ID: <aFMaxi5LDr4HHbMR@linux.dev>
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618042424.330664-4-jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 18, 2025 at 04:24:12AM +0000, James Houghton wrote:
> +#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
> +
> +#define KVM_ASSERT_TYPE_IS(type_t, x)					\
> +do {									\
> +	type_t __maybe_unused tmp;					\
> +									\
> +	BUILD_BUG_ON(!__types_ok(tmp, x) || !__typecheck(tmp, x));	\
> +} while (0)
> +
>  static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> -						 gpa_t gpa, gpa_t size,
> -						 bool is_write, bool is_exec,
> -						 bool is_private)
> +						 struct kvm_page_fault *fault)
>  {
> +	KVM_ASSERT_TYPE_IS(gfn_t, fault->gfn);
> +	KVM_ASSERT_TYPE_IS(bool, fault->exec);
> +	KVM_ASSERT_TYPE_IS(bool, fault->write);
> +	KVM_ASSERT_TYPE_IS(bool, fault->is_private);
> +	KVM_ASSERT_TYPE_IS(struct kvm_memory_slot *, fault->slot);
> +
>  	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> -	vcpu->run->memory_fault.gpa = gpa;
> -	vcpu->run->memory_fault.size = size;
> +	vcpu->run->memory_fault.gpa = fault->gfn << PAGE_SHIFT;
> +	vcpu->run->memory_fault.size = PAGE_SIZE;
>  
>  	/* RWX flags are not (yet) defined or communicated to userspace. */
>  	vcpu->run->memory_fault.flags = 0;
> -	if (is_private)
> +	if (fault->is_private)
>  		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
>  }
> +#endif

This *is not* the right direction of travel for arm64. Stage-2 aborts /
EPT violations / etc. are extremely architecture-specific events.

What I would like to see on arm64 is that for every "KVM_EXIT_MEMORY_FAULT"
we provide as much syndrome information as possible. That could imply
some combination of a sanitised view of ESR_EL2 and, where it is
unambiguous, common fault flags that have shared definitions with x86.
This could incur some minor code duplication, but even then we can share
helpers for the software bits (like userfault).

FEAT_MTE_PERM is a very good example for this. There exists a "Tag"
permission at stage-2 which is unrelated to any of the 'normal'
read/write permissions. There's also the MostlyReadOnly permission from
FEAT_THE which grants write permission to a specific set of instructions.

I don't want to paper over these nuances and will happily maintain an
arm64-specific flavor of "kvm_prepare_memory_fault_exit()"/

Thanks,
Oliver
