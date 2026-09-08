Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D81552938
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788879393; cv=none; b=SiuSKFfQl8eoEoP8MspaQ8fRI6ZirnG7n9SMonLi36g85WoK3Cjs5BXO+wl1UaF49fATxr3fTKdHMXpiK7zZshFv9NB+ZSsb22YXyUEotdkYOEUV2Dh86vxvUGIFDgLVstGqk7RTaogaqKLr8QvxIhFru+gD7QksdH7z1O5Guw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788879393; c=relaxed/simple;
	bh=o3j8gsak151UtxIp4nOhl5fbHJfOldIJo7hs4nC0ZZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDGmNsjAR3KGFdwy+PL0NcWQplsE6jSH0hfk1gRlsdE1sq/TP/fIp+GTu/jGmoXO8KwkAUH+JtZU++h4dDK2Q22ZnbD6mvRiJQvWwRgoXGYP2ZAvJHN9yTAuZBAlhYnu56XzY4CX5LoAUz2rPN39VdpooknGEfTLfxcvXOCt4U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iGgX0knX; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iGgX0knX"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso50960265e9.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 07:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788879385; x=1789484185; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uSaDyXNNPLHKZbj3b8+laIVszUdNsLcjgEBe5WQFgWo=;
        b=iGgX0knXi5yfgWw3hnFpyuMVHDypgykvhkcgJ7O19PCCxSmQTKeOF5ljkZcGa3HFDb
         w4ImW7Lo7idetDCWGZKaaO8k94IBwi4fIwIslZJvwmTlEQ0MJ9rxj6PFQg9A5X5BMFEL
         QGJbDGd12eR9mf+gJJUiuMQl9KqQTECPydYttTyB/CfjUr3DShV/hgeMBk/fvxGotOmp
         N1G56MGK73KBJ3DhKItG9JVLyu/PzOSTuA/wg4kk4Rlnhk4L5ztNDu+isB2Y5M3AYQXc
         Hrv+qYqw9C0xHbXaJyr6ODyLDUHIBTDbq5dqZhZm30kNhA68ncBVNQ2mRhzzQN1uveN9
         pvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788879385; x=1789484185;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uSaDyXNNPLHKZbj3b8+laIVszUdNsLcjgEBe5WQFgWo=;
        b=sWWwdI/ghWL7ALWLVLBhti1WyshNaZqrDzSW6w9mLP8Kd+lVHopwp5W1tL5/vCKN9V
         XIOF52lyjOTv4/6tRRQ7RJwWcuBGmVi85jAuSyK8Krn8L8wY3v1x3agv6BhXiMeGeA1S
         07VJ1TY1R3S5c7Ism38hajERbuz3BrG7crhRXnnPD9JH7uvzNaP11HDBw/jEzMicXGLf
         Nu/ZrAQISm63TBLtuTyOEiR/Vp4Urnjk3t+kQIBK4FB6nCtaLXC9r941mPRdO+18xYWL
         omg8mKHwxjRiIVtr63C5O/7fmbgOio0nRVIl2rFpKVYSKCmux8Rt2Bz2YVTvNXbF40UK
         Mc9w==
X-Forwarded-Encrypted: i=1; AKwUvByA0q/8g2IEROLhpoGYjLBKpGxBLwnkHY9g17vKhY2ThiHHt7tHycdHVvd/bXUeCQAQDNTWBWE=@lists.linux.dev
X-Gm-Message-State: AFuF++mroljd/9I/nrmoRmXgxq2sJqC3L4648QAOAIIX3L7BQibB566K
	jK8Z9qD4zbJhPrFvI72iO4mpijZxBrh1IF7Ehyc7wRFjnKe+dNdExT/Whp+xBumQ7A==
X-Gm-Gg: AYBFou0VU+RB8bXKVO2eQFfBcyrezleC4308DCosYhOJZDaQSzV5q5/uTvVoWi1q4Dm
	4wis4LpmVFk/rtJ14tNLll3ynq0c3rTxDA4DKtpV4NF2VN47VQWCTYLrkax1EBHLIAJLHAPCRqP
	kBDYyi4xdCSd9Pb5uFvccDQrxYeodQklDhe5b5c7I2UC8GKdcMyBW+dA+RSWIgE2CyHAdZEaMwT
	eOD9ISgGQ1xqXqYArF/NavTsn9EJ5WshB4ekDPnxt2O2fPtGsh/8HEk0qBOPkxV743qOEg63wRR
	X9g5h5zYVZ7hHmhy8YSjeGDyB7jWBt2zTCqZPkZrIOX7vmbGGbrZdI/KuU0Y9f5JJVCgcUzHvq5
	tRygl3XxtofbogIlxxQIcb6zr8hoSqZ9joi+0NDTE44XHeScvZd6HBGl/qxWYaemkAhomXXmrtO
	d7p74kOdY/g8NTnKVPnZpmrYWZ5aXSb/JoYrZ5TBnl6gJzy0fj6SjqtGUFyTEIEoo8TZPR7ATPr
	Raj1Sfos8eGWEu2ZFCutWLxn0VnWtz0
X-Received: by 2002:a05:600c:154f:b0:49c:fc6e:8cb5 with SMTP id 5b1f17b1804b1-49cfc6e8ee3mr300453305e9.25.1788879383965;
        Tue, 08 Sep 2026 07:56:23 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf7703cc7sm399626395e9.4.2026.09.08.07.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 07:56:23 -0700 (PDT)
Date: Tue, 8 Sep 2026 15:56:20 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 18/20] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
Message-ID: <aqAiFGL4gm_j2HSv@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-19-vdonnefort@google.com>
 <b55i2bcuqp2wgadrj5a6nuc3t4o7ordrlcugxhhjw37k6hrlks@2h7ulmokholz>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b55i2bcuqp2wgadrj5a6nuc3t4o7ordrlcugxhhjw37k6hrlks@2h7ulmokholz>

[...]

> > +static void pkvm_mapping_split(struct pkvm_mapping *mapping, struct kvm_pgtable *pgt,
> > +			       struct list_head *spares)
> > +{
> > +	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +	u64 nr_pages = mapping->nr_pages - 1;
> > +	gfn_t gfn = mapping->gfn + 1;
> > +	u64 pfn = mapping->pfn + 1;
> > +
> > +	lockdep_assert_held_write(&kvm->mmu_lock);
> > +
> > +	pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> > +	mapping->nr_pages = 1;
> > +	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
> > +
> > +	while (nr_pages--) {
> > +		struct pkvm_mapping *m;
> > +
> > +		if (WARN_ON(list_empty(spares)))
> > +			break;
> > +
> > +		m = list_first_entry(spares, struct pkvm_mapping, list);
> > +		list_del(&m->list);
> > +
> > +		m->nr_pages = 1;
> > +		m->gfn = gfn++;
> > +		m->pfn = pfn++;
> > +
> > +		pkvm_mapping_insert(m, &pgt->pkvm_mappings);
> > +	}
> > +}
> > +
> 
> I don't see anything wrong with this linked list approach, but have you
> considered just allocating an array of pointers for the allocated
> pkvm_mappings? The union in pkvm_mappings can be avoided.

I have, but it doesn't fit the reclaim path which frees pkvm_mapping as a single
object.

> 
> >  int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >  			     struct kvm_pgtable_mm_ops *mm_ops)
> >  {
> > @@ -619,6 +682,91 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void
> >  	return -EINVAL;
> >  }
> >  
> > +/*
> > + * Splitting is only expected on the back of a guest HVC, while
> > + * pkvm_pgtable_stage2_split() can be called with dirty logging.
> > + */
> > +static int __pkvm_pgtable_stage2_split(struct kvm_vcpu *vcpu, phys_addr_t ipa, u64 size)
> > +{
> > +	struct kvm_hyp_memcache *mc = &vcpu->arch.pkvm_memcache;
> > +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +	struct page **pages __free(kfree) = NULL;
> > +	struct mm_struct *mm = current->mm;
> > +	struct kvm_memory_slot *memslot;
> > +	struct pkvm_mapping *mapping;
> > +	struct kvm *kvm = vcpu->kvm;
> > +	struct list_head spares;
> > +	unsigned long hva;
> > +	bool writable;
> > +	u64 nr_pages;
> > +	int ret, idx;
> > +	gfn_t gfn;
> > +
> > +	if (WARN_ON(!kvm_vm_is_protected(kvm)))
> > +		return -EINVAL;
> > +
> > +	if (!IS_ALIGNED(ipa, PMD_SIZE) || size != PMD_SIZE)
> > +		return -EINVAL;
> > +
> > +	ret = topup_hyp_memcache(mc, 1);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* We already have 1 pin on the huge-page */
> > +	gfn = gpa_to_gfn(ipa) + 1;
> > +	nr_pages = (size / PAGE_SIZE) - 1;
> > +	pages = kmalloc_objs(struct page *, nr_pages);
> > +	if (!pages)
> > +		return -ENOMEM;
> > +
> > +	INIT_LIST_HEAD(&spares);
> > +	ret = pkvm_mapping_alloc_spares(&spares, nr_pages);
> > +	if (ret)
> > +		return ret;
> > +
> > +	idx = srcu_read_lock(&kvm->srcu);
> > +	memslot = gfn_to_memslot(kvm, gfn);
> > +	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
> > +	if (kvm_is_error_hva(hva) || !writable) {
> > +		ret = -EFAULT;
> > +		goto unlock_srcu;
> > +	}
> > +
> > +	mmap_read_lock(mm);
> > +	ret = pin_user_pages(hva, nr_pages, FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE, pages);
> 
> If I am not mistaken this is for getting additional pins only. hva walk
> and pages[] are just by-product.
> 
> Can we use folio_add_pins() here instead? Then I think we won't need
> pages[], the hva walk, and unpin_user_pages().

Good point, folio_add_pins() sounds way simpler.

-- 
Vincent

> 
> Thanks,
> Wei-Lin Chang
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
> > +	if (!pkvm_mapping_can_split(mapping)) {
> > +		ret = -EINVAL;
> > +		goto unlock_mmu;
> > +	}
> > +
> > +	ret = kvm_call_hyp_nvhe(__pkvm_host_split_guest, gpa_to_gfn(ipa), size / PAGE_SIZE);
> > +	if (ret)
> > +		goto unlock_mmu;
> > +
> > +	pkvm_mapping_split(mapping, pgt, &spares);
> > +
> > +unlock_mmu:
> > +	write_unlock(&kvm->mmu_lock);
> > +	if (ret)
> > +		unpin_user_pages(pages, nr_pages);
> > +
> > +unlock_srcu:
> > +	srcu_read_unlock(&kvm->srcu, idx);
> > +	pkvm_mapping_free_spares(&spares);
> > +
> > +	return ret;
> > +}
> > +
> 
> [...]
> 
