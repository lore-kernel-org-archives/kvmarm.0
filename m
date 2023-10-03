Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDFC29415
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 16:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696352093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKz6JlccCVdwAjHFNSIJ5aqOB7SHuX73H5DKrk7P0eA=;
	b=Gc9Kw2gXfcy/HKWZ4PjQCCUqzkLNY3pHA/iiYYwjWE1Re928VkM1lrIRmQyJ4g1BI1Ooor
	XRMB5YXm/y1diuxd+Le7VH1ovoXjjnEvWYceZ4+fBlKp38obZOvXXWpYr3lHwSPgdxdimj
	OKIzd9DHbYs42YSUo8F5FUt6L9iHVgY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-N5Fbc2p_Nz220Ht2JUvIEw-1; Tue, 03 Oct 2023 12:54:52 -0400
X-MC-Unique: N5Fbc2p_Nz220Ht2JUvIEw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3172a94b274so923323f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Oct 2023 09:54:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696352091; x=1696956891;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UKz6JlccCVdwAjHFNSIJ5aqOB7SHuX73H5DKrk7P0eA=;
        b=hfYxs2O3AwkIofHHdvfXIpvSx31TGBTLjudbuEwrttxTCBDHNCrf+I89AbC9s3Y5n9
         vSSN6dcXQLtfTvlddpuPoGEExrkiGoFCqsUt8gDh0PEMpxB1Z3k2XvK82JxfxMEFjdpe
         lfNKIsFzSdjj/rAU8NfCn/PZeY5/a11P+UHUiS8b5lye7CWJnDqhVeHh7YmAgmNlJntV
         ElvM2c/nJV/T4/zN0lRoLY4lyP6spN02VEaQFCwqih+QI6o4mlDb99G2aW7KhtAxBKWC
         GSaHy0H+mM4L7kBSdO5bU2b+Ad3rYMVo6c2wt5nJfZnMCEQg8YtoM42Ln/DL18jkLIRK
         k4rQ==
X-Gm-Message-State: AOJu0YweNgfRUwh19hf9DlwlBAa/mu9Pj95peqgmMQayK8JcTx2l7xWM
	cuwGB+91RKkB5t0dURpG1uiwIkR+auOZ2b8RJidWBU+grN2psX+t2m9hcIk1HNa0ITlNJqy8GEl
	sZ2E6czwAwH6la2xe
X-Received: by 2002:a5d:46cc:0:b0:31f:8999:c409 with SMTP id g12-20020a5d46cc000000b0031f8999c409mr12798726wrs.66.1696352091213;
        Tue, 03 Oct 2023 09:54:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEw8GrseodyMNQjRvXwM2R7y7QiATyOCHeguCOnxlPwguiOvboAnAcudNz+gmFlWejG4+qew==
X-Received: by 2002:a5d:46cc:0:b0:31f:8999:c409 with SMTP id g12-20020a5d46cc000000b0031f8999c409mr12798708wrs.66.1696352090912;
        Tue, 03 Oct 2023 09:54:50 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id c6-20020a5d4cc6000000b00325c7295450sm1977795wrt.3.2023.10.03.09.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:54:50 -0700 (PDT)
Message-ID: <fe832be36d46a946431567cbc315766fbdc772b1.camel@redhat.com>
Subject: Re: [PATCH v9 5/6] KVM: x86: Migrate to __kvm_follow_pfn
From: Maxim Levitsky <mlevitsk@redhat.com>
To: David Stevens <stevensd@chromium.org>, Sean Christopherson
	 <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata
	 <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 03 Oct 2023 19:54:48 +0300
In-Reply-To: <20230911021637.1941096-6-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
	 <20230911021637.1941096-6-stevensd@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

У пн, 2023-09-11 у 11:16 +0900, David Stevens пише:
> From: David Stevens <stevensd@chromium.org>
> 
> Migrate functions which need access to is_refcounted_page to
> __kvm_follow_pfn. The functions which need this are __kvm_faultin_pfn
> and reexecute_instruction. The former requires replacing the async
> in/out parameter with FOLL_NOWAIT parameter and the KVM_PFN_ERR_NEEDS_IO
> return value. Handling non-refcounted pages is complicated, so it will
> be done in a followup. The latter is a straightforward refactor.
> 
> APIC related callers do not need to migrate because KVM controls the
> memslot, so it will always be regular memory. Prefetch related callers
> do not need to be migrated because atomic gfn_to_pfn calls can never
> make it to hva_to_pfn_remapped.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 43 ++++++++++++++++++++++++++++++++----------
>  arch/x86/kvm/x86.c     | 12 ++++++++++--
>  2 files changed, 43 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e1d011c67cc6..e1eca26215e2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4254,7 +4254,14 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> -	bool async;
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = fault->gfn,
> +		.flags = fault->write ? FOLL_WRITE : 0,
> +		.try_map_writable = true,
> +		.guarded_by_mmu_notifier = true,
> +		.allow_non_refcounted_struct_page = false,
> +	};
>  
>  	/*
>  	 * Retry the page fault if the gfn hit a memslot that is being deleted
> @@ -4283,12 +4290,20 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
Unrelated but I can't say I like the 'is_error_noslot_pfn()' name, 
I wish it was called something like is_valid_pfn().

> +
> +	/*
> +	 * If __kvm_follow_pfn() failed because I/O is needed to fault in the
> +	 * page, then either set up an asynchronous #PF to do the I/O, or if
> +	 * doing an async #PF isn't possible, retry __kvm_follow_pfn() with
> +	 * I/O allowed. All other failures are fatal, i.e. retrying won't help.
> +	 */
> +	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
> +		return RET_PF_CONTINUE;
>  
>  	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
>  		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
> @@ -4306,9 +4321,17 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	 * to wait for IO.  Note, gup always bails if it is unable to quickly
>  	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
>  	 */
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> +	foll.flags |= FOLL_INTERRUPTIBLE;
> +	foll.flags &= ~FOLL_NOWAIT;
> +	fault->pfn = __kvm_follow_pfn(&foll);
> +
> +	if (!is_error_noslot_pfn(fault->pfn))
> +		goto success;
> +
> +	return RET_PF_CONTINUE;
> +success:
> +	fault->hva = foll.hva;
> +	fault->map_writable = foll.writable;
>  	return RET_PF_CONTINUE;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6c9c81e82e65..2011a7e47296 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8556,6 +8556,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  {
>  	gpa_t gpa = cr2_or_gpa;
>  	kvm_pfn_t pfn;
> +	struct kvm_follow_pfn foll;
>  
>  	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
>  		return false;
> @@ -8585,7 +8586,13 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	 * retry instruction -> write #PF -> emulation fail -> retry
>  	 * instruction -> ...
>  	 */
> -	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
> +	foll = (struct kvm_follow_pfn) {
> +		.slot = gfn_to_memslot(vcpu->kvm, gpa_to_gfn(gpa)),
> +		.gfn = gpa_to_gfn(gpa),
> +		.flags = FOLL_WRITE,
> +		.allow_non_refcounted_struct_page = true,
> +	};
> +	pfn = __kvm_follow_pfn(&foll);
>  
>  	/*
>  	 * If the instruction failed on the error pfn, it can not be fixed,
> @@ -8594,7 +8601,8 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	if (is_error_noslot_pfn(pfn))
>  		return false;
>  
> -	kvm_release_pfn_clean(pfn);
> +	if (foll.is_refcounted_page)
> +		kvm_release_page_clean(pfn_to_page(pfn));
>  
>  	/* The instructions are well-emulated on direct mmu. */
>  	if (vcpu->arch.mmu->root_role.direct) {


Overall looks good, I might have missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky




