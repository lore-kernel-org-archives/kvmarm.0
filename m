Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035361F0997
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 05:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741065015; cv=none; b=uibrMbEa55n4CWpNSdtSIvbEcrIShtIMgjZxdcElSegE3Knv5i1+ITxv6dQ9BBR4uqfwgSMUvLlBnThtdHuuIl9VHBDErUSr0KTiw09nTw+zs9P9JDL877liQHfXmVhQBFSZf2O6ZUJ9EiLdFXLFDOv7/isvwqxJflJHC46ULMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741065015; c=relaxed/simple;
	bh=mo6UEqLjhhD/gYk0pYC+753IVwsq5HZnkglHB39gdLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Twbk23NuTyDhA1nPAu0QUtONX78RBj8iw9CANqGeCl2Xm1SmXlyaEEUstKzIVw0iyTEZaBslKqcUSEU2ua/512lT5aapJA5TDgV+Ddf666EGUlUIGAXPxkIUNEMkJoS/be13uFbfc799BfJqfVeXjuDAhK9gJ5QZOfc07zlq7kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V9jnYiji; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V9jnYiji"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741065012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8NQ+qKZ44E29enCPM7Eb/wfq67YXGlkr0AyFJChf4s=;
	b=V9jnYijiXnU9qgnav4EdlqgYSO287yZ6l420/NPVpt9PPJ18dgBP7mPuAoNV585GWbPjtR
	CluNaCqL7PNJkFrK4Cw3w4E5hffORwilQ7qk+vFv+XsDXkHp2rmVjJlMKR+VRXHi2533Gd
	Bc/7fnERMw4rz3wEEsyb2u04LQgMWKg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-OcDGqXKAMIa1GJ09oK4bew-1; Tue, 04 Mar 2025 00:10:09 -0500
X-MC-Unique: OcDGqXKAMIa1GJ09oK4bew-1
X-Mimecast-MFC-AGG-ID: OcDGqXKAMIa1GJ09oK4bew_1741065009
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2fed20dd70cso5434923a91.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 21:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741065009; x=1741669809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U8NQ+qKZ44E29enCPM7Eb/wfq67YXGlkr0AyFJChf4s=;
        b=SZC1LzdoiPZUZv/a3SNDDJlgyoPVEqzfyQoIxw3eqjOie9GHLAyN3aRX5/cd6HXJ9x
         AANmuPVnIvcCo+F/diMgK/5f/zk4E9G6jMyhVhiEwjjgqhWI4ms13QLzTxhSaTdq2q8e
         lqGyPCyDpQoRmk5cjXoxaJ7rR61MB43Ew5RGFMFa11cUnbeaTEv+gGny8186iy/qzilq
         +0OuBfF8zNLNdwGnJ3PAAtZAQXZ7yIIuN5rUN02fkBb/rY85mrw6l05O5Gu7dVHgjFaY
         2EYpRzE8aOYNIwGl5knMNHVB1+VYRSZijzb8R5p6smFH5vkDT8ehPzkZYfFVW/YV0080
         HZeA==
X-Forwarded-Encrypted: i=1; AJvYcCXvt1Sr4nMtC8UpLAsz9HxY9WKuZQoyO2eBJZbyeEpX+UEE1/Pogh4FkuWCH4y7iGZl+3KWheE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYNUG95J/9ktjzPAmm5buKwKlH5hqD3B7yAswQG1opamL5Nate
	+Qg32w+cioeDUVRrTKgz3EVsIu2S8Krgp55v7dtm4XrlZUsxpYy59UHmtR0VW6DlzZw3GdyYaQb
	D5b3bMY2wKp9aI4IRGIaylrs0dwAZd5bM3r/JXP665xzbJRppBsR7ew==
X-Gm-Gg: ASbGncsjhpPAngcH34kjVAwUpT/ND82a3k8QeXDgqOaaF+mEPM8gvRBk8QKWsuucvdC
	BtmiB4+r8ZJZkjdsKMavykpbPRaMuYD0bHj4l9ZzTGGWo4QuLAjGvix3L33tLldB84mUj2NTUSi
	o8q8PxlaaHQwWC+OLia8SpafzduMv4NLQdSIW/r27vGgC+GfuAlnewUDQsVbktk/pcaZwxJx4ET
	BhwFdzFcdBs5r/jSOGrgS7a+mEcNXRz8aLTPxqIkoSZY1wt02p6KM8M2mcI8I+7hBJAKHhZw7Af
	/Zp7JxDC/ROtpvQQWA==
X-Received: by 2002:a17:90b:4c4d:b0:2fa:e9b:33ab with SMTP id 98e67ed59e1d1-2febab7878bmr27494277a91.16.1741065008849;
        Mon, 03 Mar 2025 21:10:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiZnTyS+PczRxTvLSMdHTFs/jB2+JERIbLYMAxRPKra+AaKI0Fes/aNpheWezo+oJpvWNtmw==
X-Received: by 2002:a17:90b:4c4d:b0:2fa:e9b:33ab with SMTP id 98e67ed59e1d1-2febab7878bmr27494245a91.16.1741065008475;
        Mon, 03 Mar 2025 21:10:08 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fe825d2b85sm12057524a91.26.2025.03.03.21.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:10:07 -0800 (PST)
Message-ID: <8e852bc0-9a02-42d9-8d56-712c11508626@redhat.com>
Date: Tue, 4 Mar 2025 15:09:59 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 20/45] arm64: RME: Allow populating initial contents
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-21-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-21-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Aj3_xN5BNAbS0tsjUIXRobD3g8U4pTyM53OZJdHTgGs_1741065009
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> The VMM needs to populate the realm with some data before starting (e.g.
> a kernel and initrd). This is measured by the RMM and used as part of
> the attestation later on.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Handle host potentially having a larger page size than the RMM
>     granule.
>   * Drop historic "par" (protected address range) from
>     populate_par_region() - it doesn't exist within the current
>     architecture.
>   * Add a cond_resched() call in kvm_populate_realm().
> Changes since v5:
>   * Refactor to use PFNs rather than tracking struct page in
>     realm_create_protected_data_page().
>   * Pull changes from a later patch (in the v5 series) for accessing
>     pages from a guest memfd.
>   * Do the populate in chunks to avoid holding locks for too long and
>     triggering RCU stall warnings.
> ---
>   arch/arm64/kvm/rme.c | 234 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 234 insertions(+)
> 

With the following comments addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f965869e9ef7..7880894db722 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -624,6 +624,228 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start, u64 size,
>   		realm_unmap_private_range(kvm, start, end);
>   }
>   
> +static int realm_create_protected_data_granule(struct realm *realm,
> +					       unsigned long ipa,
> +					       phys_addr_t dst_phys,
> +					       phys_addr_t src_phys,
> +					       unsigned long flags)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	int ret;
> +
> +	if (rmi_granule_delegate(dst_phys))
> +		return -ENXIO;
> +
> +	ret = rmi_data_create(rd, dst_phys, ipa, src_phys, flags);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		WARN_ON(level == RMM_RTT_MAX_LEVEL);
> +
> +		ret = realm_create_rtt_levels(realm, ipa, level,
> +					      RMM_RTT_MAX_LEVEL, NULL);
> +		if (ret)
> +			return -EIO;
> +
> +		ret = rmi_data_create(rd, dst_phys, ipa, src_phys, flags);
> +	}
> +	if (ret)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int realm_create_protected_data_page(struct realm *realm,
> +					    unsigned long ipa,
> +					    kvm_pfn_t dst_pfn,
> +					    kvm_pfn_t src_pfn,
> +					    unsigned long flags)
> +{
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	phys_addr_t dst_phys, src_phys;
> +	bool undelegate_failed = false;
> +	int ret, offset;
> +
> +	dst_phys = __pfn_to_phys(dst_pfn);
> +	src_phys = __pfn_to_phys(src_pfn);
> +
> +	for (offset = 0; offset < PAGE_SIZE; offset += RMM_PAGE_SIZE) {
> +		ret = realm_create_protected_data_granule(realm,
> +							  ipa,
> +							  dst_phys,
> +							  src_phys,
> +							  flags);
> +		if (ret)
> +			goto err;
> +
> +		ipa += RMM_PAGE_SIZE;
> +		dst_phys += RMM_PAGE_SIZE;
> +		src_phys += RMM_PAGE_SIZE;
> +	}
> +
> +	return 0;
> +
> +err:
> +	if (ret == -EIO) {
> +		/* current offset needs undelegating */
> +		if (WARN_ON(rmi_granule_undelegate(dst_phys)))
> +			undelegate_failed = true;
> +	}
> +	while (offset > 0) {
> +		ipa -= RMM_PAGE_SIZE;
> +		offset -= RMM_PAGE_SIZE;
> +		dst_phys -= RMM_PAGE_SIZE;
> +
> +		rmi_data_destroy(rd, ipa, NULL, NULL);
> +
> +		if (WARN_ON(rmi_granule_undelegate(dst_phys)))
> +			undelegate_failed = true;
> +	}
> +
> +	if (undelegate_failed) {
> +		/*
> +		 * A granule could not be undelegated,
> +		 * so the page has to be leaked
> +		 */
> +		get_page(pfn_to_page(dst_pfn));
> +	}
> +
> +	return -ENXIO;
> +}
> +
> +static int populate_region(struct kvm *kvm,
> +			   phys_addr_t ipa_base,
> +			   phys_addr_t ipa_end,
> +			   unsigned long data_flags)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct kvm_memory_slot *memslot;
> +	gfn_t base_gfn, end_gfn;
> +	int idx;
> +	phys_addr_t ipa;
> +	int ret = 0;
> +
> +	base_gfn = gpa_to_gfn(ipa_base);
> +	end_gfn = gpa_to_gfn(ipa_end);
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +	memslot = gfn_to_memslot(kvm, base_gfn);
> +	if (!memslot) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	/* We require the region to be contained within a single memslot */
> +	if (memslot->base_gfn + memslot->npages < end_gfn) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (!kvm_slot_can_be_private(memslot)) {
> +		ret = -EINVAL;
		ret = -EPERM;

> +		goto out;
> +	}
> +
> +	write_lock(&kvm->mmu_lock);
> +
> +	ipa = ALIGN_DOWN(ipa_base, PAGE_SIZE);

The aignment operation is unnecessary since the base/size are ensured
to be aligned to PAGE_SIZE by its caller (kvm_populate_realm()).

> +	while (ipa < ipa_end) {
> +		struct vm_area_struct *vma;
> +		unsigned long hva;
> +		struct page *page;
> +		bool writeable;
> +		kvm_pfn_t pfn;
> +		kvm_pfn_t priv_pfn;
> +		struct page *gmem_page;
> +
> +		hva = gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa));
> +		vma = vma_lookup(current->mm, hva);
> +		if (!vma) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		pfn = __kvm_faultin_pfn(memslot, gpa_to_gfn(ipa), FOLL_WRITE,
> +					&writeable, &page);
> +
> +		if (is_error_pfn(pfn)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		ret = kvm_gmem_get_pfn(kvm, memslot,
> +				       ipa >> PAGE_SHIFT,
> +				       &priv_pfn, &gmem_page, NULL);
> +		if (ret)
> +			break;
> +
> +		ret = realm_create_protected_data_page(realm, ipa,
> +						       priv_pfn,
> +						       pfn,
> +						       data_flags);
> +
> +		kvm_release_faultin_page(kvm, page, false, false);
> +
> +		if (ret)
> +			break;
> +
> +		ipa += PAGE_SIZE;
> +	}
> +
> +	write_unlock(&kvm->mmu_lock);
> +
> +out:
> +	srcu_read_unlock(&kvm->srcu, idx);
> +	return ret;
> +}
> +
> +static int kvm_populate_realm(struct kvm *kvm,
> +			      struct arm_rme_populate_realm *args)
> +{
> +	phys_addr_t ipa_base, ipa_end;
> +	unsigned long data_flags = 0;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EINVAL;
		return -EPERM;

> +
> +	if (!IS_ALIGNED(args->base, PAGE_SIZE) ||
> +	    !IS_ALIGNED(args->size, PAGE_SIZE))
> +		return -EINVAL;
> +
> +	if (args->flags & ~RMI_MEASURE_CONTENT)
> +		return -EINVAL;

It's perfect to combine those checks:

	if (!IS_ALIGNED(...) ||
	    !IS_ALIGNED(...) ||
	    args->flags & ~RMI_MEASURE_CONTENT)
		return -EINVAL;

> +
> +	ipa_base = args->base;
> +	ipa_end = ipa_base + args->size;
> +
> +	if (ipa_end < ipa_base)
> +		return -EINVAL;
> +
> +	if (args->flags & RMI_MEASURE_CONTENT)
> +		data_flags |= RMI_MEASURE_CONTENT;
> +
> +	/*
> +	 * Perform the populate in parts to ensure locks are not held for too
> +	 * long
> +	 */
	
s/populate/population ?

> +	while (ipa_base < ipa_end) {
> +		phys_addr_t end = min(ipa_end, ipa_base + SZ_2M);
> +
> +		int ret = populate_region(kvm, ipa_base, end,
> +					  args->flags);
> +
> +		if (ret)
> +			return ret;
> +
> +		ipa_base = end;
> +
> +		cond_resched();
> +	}
> +
> +	return 0;
> +}
> +
>   static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>   			       unsigned long start,
>   			       unsigned long end,
> @@ -873,6 +1095,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   		r = kvm_init_ipa_range_realm(kvm, &args);
>   		break;
>   	}
> +	case KVM_CAP_ARM_RME_POPULATE_REALM: {
> +		struct arm_rme_populate_realm args;
> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
> +
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +
> +		r = kvm_populate_realm(kvm, &args);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   		break;

Thanks,
Gavin

