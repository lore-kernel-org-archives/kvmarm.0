Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989AE1BE85D
	for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 21:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723843366; cv=none; b=VZ12e5i47FBM744xoPfx1YGU2pRmm4yCiZ3dQXTVDpRkI4psnsAjUFJy/Wvf6Q3wXVIMfkjsZE/8fJ1SMg3FyuoUrkDbSNaMrsiSMgqfOHPjlVy9HO4O/7BN+k4ne24zKUwmBKgGuJv044mBUSLfUT35e/fRpHtAPWJaj1qEbjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723843366; c=relaxed/simple;
	bh=sWA1R4Z+hjjLgkZaegTM4CTQgixl0MSxWNpQ2OfSHSk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZnIQEdFVyuuqyi5SQF70wercXMUEbISDpG/L3eeQsIjkPDCnUD+eWE99iiqDa6I4Vzu0odMZzzasX/g3JUsJkQdmwv1KdLg6Z8+OXyftVL/xBnafu/PcsoxscKahb7CI75bacdDs7Qjn0jrJaiJ76s9mNGMc0bTQmZV4HLQAQeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zk6DGiSA; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zk6DGiSA"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-713d4a9a3ffso375879b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 14:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723843364; x=1724448164; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o9uTxs0mkniTI3GS8tRBaRROslovtMgDYxgP4WPwRKU=;
        b=zk6DGiSAQhfQtObHcPW+FTSnCdLGikkt8UCWOqBT2t18eORb01RNXGEt3BwahdGx17
         Vdm9qCdUlKT54fIBANxf5eUxGvP5eIwAJ1J83lgsYChLZ3XJvbh6ZK2xkevAm7tTPSdF
         gYJLsSOx9lQHmEw8Is6RNKtkkmI38L4w2b8noOtRsbm/Ajzjm3U85/JRR6zByKFGVDxX
         OqJ0Q/BiaG30UeHSHas580XSdLAqk2q93WLVtUhMjOeWB5DCrlY5RMQzAUFbp1n+6TS+
         DmaZG/iH2zBW0wCyQAM3UzP4oLy574YkPEKJmvc87kBdMzHKHUp5MjAkT8ub2Z/YWwos
         aiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723843364; x=1724448164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o9uTxs0mkniTI3GS8tRBaRROslovtMgDYxgP4WPwRKU=;
        b=t72fxPdeumeuGCyWf1qo/2PVh587O3yJQ2hSdg6mP2QREyEjW3xFMGZZ5WaUalcFkR
         XeeMNQpfdZmTW+zTXvLsHLgxnzZm65HjSEQdoGGIKIT7juwpYtWGZAQkBmFEukh6Iuox
         FP/otRFLaeZfZ0P7FXGfTQ5C2+5Gguhj0K8X6KUMzG/JHVoOCxKA4w6kKAyjlISnkNx5
         IlZUJLus1JLDNdjozTUhBBDN5B+EG2IvmMTWjKBjZFiKpiCVfM6arW783+BebUgRu3pJ
         zuWKN/DPMgNOeTI5Ivv8un0Ire7Y6NHLTeLcPmtpHYjZV4gGeCUmctbGwmfMnMUHccaf
         JzIA==
X-Forwarded-Encrypted: i=1; AJvYcCXEhoGJBoL2yC23UK5dzWurgcbhrhLsUam/AjOLofSSJYkCbFoRa6GZuOWd1j7v0+oywY3MojGAhYaFYbYtgMLiq2bbmhTb
X-Gm-Message-State: AOJu0Yy1+49YtGyV3FtOA3OxOOwLsiwYynNSDvV1YF/o6MtSKST4f47e
	reqxsRIm0P002/1xPy6d/lLUDPOX19fPztZ/tl6kjg57VGS2W+mq4x+xBAO5NQc5IqWN8oyRiwT
	wWA==
X-Google-Smtp-Source: AGHT+IHDYed5uLkrjadTM1HkBjUKX+hpJJsh/EyZ8evcAdTKPd0muQAu8d9inIi0f9HwyVQ2JOWLPGX7nk0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:91cb:b0:710:4e4c:a4ad with SMTP id
 d2e1a72fcca58-71276c8a229mr65569b3a.0.1723843363684; Fri, 16 Aug 2024
 14:22:43 -0700 (PDT)
Date: Fri, 16 Aug 2024 14:22:42 -0700
In-Reply-To: <20240809205158.1340255-4-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com> <20240809205158.1340255-4-amoorthy@google.com>
Message-ID: <Zr_DIuWBRuaQIYmX@google.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Perform memory fault exits when
 stage-2 handler EFAULTs
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 09, 2024, Anish Moorthy wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6981b1bc0946..c97199d1feac 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1448,6 +1448,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	if (fault_is_perm && !write_fault && !exec_fault) {
>  		kvm_err("Unexpected L2 read permission error\n");
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,

In this case, KVM has the fault granule, can't we just use that instead of
reporting '0'?

> +					      write_fault, exec_fault, false);
>  		return -EFAULT;
>  	}
>  
> @@ -1473,6 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (unlikely(!vma)) {
>  		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
>  		mmap_read_unlock(current->mm);
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, 0,

Why can't KVM use the minimum possible page (granule?) size.  It's _always_ legal
for KVM to map at a smaller granularity than the primary MMU, thus it's always
accurate to report KVM's minimum size.

In fact, I would argue that it's inaccurate to report anything larger, because
there's no way for KVM to know if the badness extends to an entire hugepage.
E.g. even in the MTE case below, reporting the vma _page size_ is weird.  IIUC,
the problem exists with the entire vma, not some random (huge)page in the vma.

> +					      write_fault, exec_fault, false);
>  		return -EFAULT;
>  	}
>  
> @@ -1568,8 +1572,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		kvm_send_hwpoison_signal(hva, vma_shift);
>  		return 0;
>  	}
> -	if (is_error_noslot_pfn(pfn))
> +	if (is_error_noslot_pfn(pfn)) {
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
> +					      write_fault, exec_fault, false);
>  		return -EFAULT;

Shouldn't this be:

	if (KVM_BUG_ON(is_error_noslot_pfn(pfn), vcpu->kvm))
		return -EIO;

Emulated MMIO is suppposed to be handled in kvm_handle_guest_abort():

	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {o
		...

		/*
		 * The IPA is reported as [MAX:12], so we need to
		 * complement it with the bottom 12 bits from the
		 * faulting VA. This is always 12 bits, irrespective
		 * of the page size.
		 */
		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
		ret = io_mem_abort(vcpu, ipa);
		goto out_unlock;
	}

And the memslot itself is stable, e.g. it can't disappear, and it can't have its
flags toggled.  KVM specifically does all modifications to memslots on unreachable
structures so that a memslot cannot change once it has been retrieved from the
memslots tree. 
	/*
	 * Mark the current slot INVALID.  As with all memslot modifications,
	 * this must be done on an unreachable slot to avoid modifying the
	 * current slot in the active tree.
	 */
	kvm_copy_memslot(invalid_slot, old);
	invalid_slot->flags |= KVM_MEMSLOT_INVALID;
	kvm_replace_memslot(kvm, old, invalid_slot);

And if KVM were indeed re-retrieving the memslot from kvm->memslots, then the
appropriate behavior would be

	if (is_error_noslot_pfn(pfn))
		return -EAGAIN;

so that KVM retries the fault.  It's perfectly legal to delete a memslot at any
time, with the rather large caveat that if bad things happen to the guest, it's
userspace responsibility to deal with the fallout.
