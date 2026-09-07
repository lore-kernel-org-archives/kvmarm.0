Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE8E3CB2D0
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 10:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788776598; cv=none; b=St6xsTzEZ8l3FhNODz5Zwk4To/WSW4BOslc1ILBixBorDfqGdQoDd8kWoMqBpJQA51TwPFoCFR5aCV2WqXVu+JCYjqXQzor5hgaO7PKveOf2drSec6FldodZXDludmmRZXbRX3wxzP7tvw/w6kt9/JuV+rmOOLYBpStBowonpQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788776598; c=relaxed/simple;
	bh=GjElOHGjjEP0wkXBEKPTrjP4jR20YlkR3af8X11tn4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YweHPT/titH1OwoYN5EGuUYbk4FYjgyVDEkSxt/tsqTAOZg4C4kwdQwEa7o6+f2LW5qkIPnLvcN5eu/u0HJ9tmUXc57+coo+e1nzBZax7sONBFF8WdO2LDxdlS1pA7Yn+vbrfXq4echog0ugnhb31qgtzsnfAhb4CeRpvFNAAGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=doHqbRv4; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="doHqbRv4"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2055573c8cso409979466b.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 03:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788776595; x=1789381395; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bS1Xhtw50wNcRogCfMLw1Iql2rPD2ohrSvtL4dTfgo8=;
        b=doHqbRv4zhlslzAuoCnPFDA7r2SX1ffK1SwUsxNXpWXtMQSA80dpwcuCfriSqhgwUf
         LwkSAz69CxAlFBLUkoVM2rsnr8QbsNQyptjCcImQvm0OUOOSiDvINQYDwRmflUTbGOTA
         2FII/JKh5oYTahrfSClXVrf6y0RrQj/DWuEO71ByzWWiR0TZwyxHlKksFFgT1km1Z5Eb
         tofO1yuI9Bf16pKhmL8ud67vPhpUhe1AJQweqArCkB72bqFyVeJakUzdYu457uyI+2tw
         1ZtyYIPU84dHpHbEj1a97ecS6leHd6D+GJ6loXBPTsLNgxcD4pbJMDthGTEbgi95LBYy
         TJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788776595; x=1789381395;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bS1Xhtw50wNcRogCfMLw1Iql2rPD2ohrSvtL4dTfgo8=;
        b=VL7iAOWVtMvfot6fwlHUBkdDbY9tzkFgzydonGjjoLMxuYWGo4big2cGB1OzouCaDR
         EW1ne6JcFuzxn7SeyIeQJss+mV91jkv6O1tQjcSE42NZ0ivrO16IGd3O1PfcioSdZaSI
         pKoYLe7d8Eh+FYwfFzCUZU26Ma3U4fG2Y6znUGbp3aG4K4p2nFTmpeilbJ9QFHuWwroE
         Z+924h38E0wTfcMgW1buhy9OPKt7UcEJYlTT2+jkB8k2HHUSluctWNNOo/WHTIzYEKdd
         gLc4xGO/fc7Fsekndqf0Z6SdE6GVXu+cuDlzvQlIVNkRRQcY6psiKOcPDFE1PcPbUV7h
         RN9Q==
X-Gm-Message-State: AFuF++lMxWi8l3ypgzh/VP9k2CLeVrkIYbi47WdIaOHbr1IZFVbvO4PI
	SHeX9Mwg6iG/gUgJg9UziNj7ZSZPwiiyhtibRwS3ffvOtDxC6QOj/mK+hl4slAv+Eg==
X-Gm-Gg: AYBFou3UA6fqZrlik7PZ4LAp9vM2Gx7bv9J2OctC7CJgnwO3Ou5169pV1CW//YtDUhs
	qLPubdY6jSjzjp67uCNdP2K3SDQxtBzNLI/jo5exwgBG+SCojHqieyXZuogjZFiaWiG0UQ3P4O1
	1QRkYna0rebgzgYhBGS5m6wfbJzMphBKSzqzcTuH9pO5dfWYVEo9/vgCCDms3prtDRp0c1sG6Ch
	NTCmU3hJc2baRA3WD8JXm5NnpCFGM00fF6bppf7Qaeh2uWkMtNXWNP11UmKnOdaWZvnQkJDJSGo
	/opgnxNU/wu4+yCbR7zTnuTFDRQvUOy9lj6xMO6WWwSDnSGBBfKWTwsWp8/5HvpdYgsX8h466f0
	pE09UFgUeMDnIP6uZq6KQNYk2Tmr8vnJDEGQnyV8gHBfhUyKxKAQKVGdO4cpUq4gMnxX0xVmgR/
	+T96quolCqPVh/atPSPAJZvP2DVzYHsqEKTog5hR95jWybBnQBlnYu/FWNv65Lh4EUKG3LzUd69
	2PYwdvljY1UcPdIOhrp0WTzDDLfhwIz
X-Received: by 2002:a17:907:d18:b0:c25:4cff:5d01 with SMTP id a640c23a62f3a-c260c9f4a3bmr789619966b.18.1788776594247;
        Mon, 07 Sep 2026 03:23:14 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d036440sm449932666b.5.2026.09.07.03.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 03:23:13 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:23:10 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 18/20] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
Message-ID: <ap6QjjJxysWVYCVM@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-19-vdonnefort@google.com>
 <20260803105411.B6ACE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260803105411.B6ACE1F000E9@smtp.kernel.org>

On Mon, Aug 03, 2026 at 10:54:11AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [Critical] Time-of-Check to Time-of-Use (TOCTOU) race in `__pkvm_pgtable_stage2_split` due to missing MMU notifier retry protocol.
> - [Critical] Using `pin_user_pages()` introduces a `FOLL_PIN` counting bias that causes massive memory leaks during KVM teardown.
> - [High] Memory cgroup accounting bypass when allocating spare `pkvm_mapping` structures.
> - [Medium] Splitting read-only guest mappings is incorrectly forbidden by requiring write access.
> - [Low] `__pkvm_pgtable_stage2_split()` mixes `goto`-based error handling with scope-based `__free(kfree)` cleanup.
> --
> 
> --- Patch [18]: [PATCH 18/20] KVM: arm64: Add PKVM_HYP_REQ_SPLIT ---
> commit eb20478193ba08806cd19923ba4b65163db37c40
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Add PKVM_HYP_REQ_SPLIT
> 
> This commit introduces a new pKVM hypervisor request, PKVM_HYP_REQ_SPLIT,
> enabling the hypervisor to request the host to split stage-2 huge mappings.
> This ensures synchronous splitting of both the guest stage-2 page tables
> and the host's pkvm_mappings red-black tree, preventing concurrent
> teardowns from observing inconsistent page sizes.
> 
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 379bdc2b258a6..089b77cf2f6a9 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> 
> [ ... ]
> 
> > +static int pkvm_mapping_alloc_spares(struct list_head *head, u64 nr_spares)
> > +{
> > +	struct pkvm_mapping *m;
> > +
> > +	while (nr_spares--) {
> > +		m = kzalloc_obj(*m);
> 
> [Severity: High]
> Does this bypass memory cgroup limits?
> 
> This allocation uses kzalloc_obj() which defaults to GFP_KERNEL without
> the __GFP_ACCOUNT flag.
> 
> Because each PMD split allocates 511 structures, a guest could repeatedly
> trigger splits across its memory footprint.
> 
> Can this allow the guest to consume large amounts of uncharged host memory,
> potentially leading to host memory exhaustion?
> 
> > +		if (!m) {
> > +			pkvm_mapping_free_spares(head);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		list_add(&m->list, head);
> > +	}
> > +
> > +	return 0;
> > +}
> 
> [ ... ]
> 
> > +static int __pkvm_pgtable_stage2_split(struct kvm_vcpu *vcpu, phys_addr_t ipa, u64 size)
> > +{
> > +	struct kvm_hyp_memcache *mc = &vcpu->arch.pkvm_memcache;
> > +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +	struct page **pages __free(kfree) = NULL;
> 
> [Severity: Low]
> Is it safe to mix scope-based cleanup with goto error handling in this
> function?
> 
> The pages array is declared with __free(kfree), but the function uses goto
> labels like goto unlock_srcu and goto unlock_mmu for unwinding locks and
> freeing the spares list.
> 
> The kernel cleanup guidelines note that functions should use either
> scope-based cleanup for all resources or goto labels for all resources,
> but not mix them, as it creates confusing ownership semantics.
> 
> > +	struct mm_struct *mm = current->mm;
> > +	struct kvm_memory_slot *memslot;
> 
> [ ... ]
> 
> > +	idx = srcu_read_lock(&kvm->srcu);
> > +	memslot = gfn_to_memslot(kvm, gfn);
> > +	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
> > +	if (kvm_is_error_hva(hva) || !writable) {
> 
> [Severity: Medium]
> Should read-only mappings be allowed to split?
> 
> This explicitly checks that the memslot is writable and fails with -EFAULT
> otherwise. It also passes FOLL_WRITE to pin_user_pages() later on.
> 
> However, splitting a huge page block into smaller PTEs changes the mapping
> granularity without modifying the underlying memory contents.
> 
> Does requiring write access prevent the hypervisor from splitting read-only
> stage-2 block mappings, such as guest ROMs?
> 
> > +		ret = -EFAULT;
> > +		goto unlock_srcu;
> > +	}
> > +
> > +	mmap_read_lock(mm);
> > +	ret = pin_user_pages(hva, nr_pages, FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE, pages);
> 
> [Severity: Critical]
> Does using pin_user_pages() here cause a permanent memory leak during KVM
> teardown?
> 
> Calling pin_user_pages() adds a GUP_PIN_COUNTING_BIAS to the page refcount.
> However, normal KVM stage-2 teardown drops references using standard
> put_page() semantics which only subtracts one from the refcount.
> 
> When the VM is destroyed, will these tail pages retain phantom references
> and be permanently leaked?
> 
> > +	mmap_read_unlock(mm);
> > +	if (ret != nr_pages) {
> > +		if (ret > 0)
> > +			unpin_user_pages(pages, ret);
> > +		ret = -EFAULT;
> > +		goto unlock_srcu;
> > +	}
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, ipa, ipa + size - 1);
> 
> [Severity: Critical]
> Is there a Time-of-Check to Time-of-Use race here since the MMU
> notifier retry protocol is missing?
> 
> The resolution of the HVA to PFNs via pin_user_pages() happens outside
> kvm->mmu_lock. A concurrent host MMU invalidation could unmap the region
> and remove the pkvm_mapping, and a subsequent guest fault could establish
> a new huge page mapping at the same IPA.

This is called on the back of a hypervisor request. This is only for
protected-VM and we do have an existing pin on the huge-page, preventing
any unmap. 

We do not use MMU notifier for protected VMs.

-- 
Vincent

> 
> When this thread acquires kvm->mmu_lock, it finds the new mapping in the
> tree and proceeds to split it using the PFNs derived from the old mapping.
> 
> Without capturing kvm->mmu_invalidate_seq before GUP and checking
> mmu_invalidate_retry() under the lock, can this lead to a refcount
> underflow on the new huge page and a permanent leak of the old pages?
> 
> > +	if (!pkvm_mapping_can_split(mapping)) {
> > +		ret = -EINVAL;
> > +		goto unlock_mmu;
> > +	}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260803100904.3563942-1-vdonnefort@google.com?part=18
