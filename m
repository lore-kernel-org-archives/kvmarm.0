Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E554113D89D
	for <kvmarm@lists.linux.dev>; Thu, 30 Jan 2025 04:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738211919; cv=none; b=YuXLVatA39HS/+5jde6BrHN0UCs99qEltB7yAnGTDOPlKr9tUjEpCVHIjCfoYgGX0gxkvWWUxOUd/+Vv5h9sVjXqnq4OF/L9FtUZRLgpxntEXXwZD8qkkNcaPfWjze9wywQMnRrEAG12H5UUPKchrrSNE/1JPldxPSL1Uj3Neb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738211919; c=relaxed/simple;
	bh=4FKEvSUMzC2p53+6xAj3vhxfuVD67aqgvQeQrfYid4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uce9+1XTwKt/9zdxaHWnDZZUwLjzrigqGT2Visq/cIGigpuvYzgew8UKM0eqQQwvOsrwpfysFVZE4JjGSndhYIXe/kqXPUA4jk1Qw7SFkImVJdfBWlW8uWnhshrRGvgHk1x9JrUGLEHMhDVmW679rIBddXXwSstAL06ql1Nr2C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=crHQ9q/q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crHQ9q/q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738211916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dahlzWRlI1LALktUzZgSkyoAKZL8GDjGaQgiyJ8JjL0=;
	b=crHQ9q/q2tNSspgosFV3Xt+82fFiKFIziFpe4cmSuW0UqgUiW1gS4eS+Omn1dnBf9wpdcL
	XrWEqHDzPsrD4/VsWGHGNNG3fYz1RAft1Wi5vR4mVci9cEGA4RDZubjCofSvTOTkF005qC
	nmn/ebSJb0EuSZZLK3HDXQC8S9ufMsI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-ScZQ2eLVNoCRE5HqPbLG7w-1; Wed, 29 Jan 2025 23:38:33 -0500
X-MC-Unique: ScZQ2eLVNoCRE5HqPbLG7w-1
X-Mimecast-MFC-AGG-ID: ScZQ2eLVNoCRE5HqPbLG7w
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2163dc0f5dbso9334665ad.2
        for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 20:38:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738211912; x=1738816712;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dahlzWRlI1LALktUzZgSkyoAKZL8GDjGaQgiyJ8JjL0=;
        b=Gw0q5/AyR29SoaFlfaIPOmkSgFb7CF422F1RZAz7544XoF6hCiXE6udoMzB4tXp7ee
         zax+xD56vZ1midLdtf3vke3+PggTkxE732D6cb8axYlCMnCfGYBC736tIDNIomZKRbxg
         h7iU5g1vCQVNff00soIxvdBWePy1PoHRj+znZkxsUJu0lQRq4F4+i4bZdRT97vg9sAYg
         lEd+jTqjJyFvPW1hrYJcOgPTAv+f+Qst6x6smUJmKbu94Sb3QNYX8qkVVMXIo2w0HCj8
         bBh52Bihc9gGp8/hYkgVXnxBkRL16HPVrHlERUDV96LXKG5g/bjTO5VsrVxLMvkJlwk+
         tc7w==
X-Forwarded-Encrypted: i=1; AJvYcCXMSMKdh1ZNcpErkj57yFQ4ofy1rR1YWmgwA8Vik+USXNwFCdFwV+pry0uHlFcpbaNsUKUfQl0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrKh8zmR5OXlfjay3IxWBmhAPYD+d9kPL/iEzhWfhPh2TF6WJE
	e5ufk/IWNA7Djfc1x5USgtu4LlGq96D/kDD2jbZwsnIfF/5i07aWZTohIBaEVxGUW02AQg6oqwK
	wLlMEdybFfC4oz4tCtQaSPSV11mjvpXRpx049GW+5k/hfuGXgN1V5LA==
X-Gm-Gg: ASbGncv/RyW86rBBCZz3thMWmmGjfdHVsEIZnG9t+RzfFtsV07ET7/OdC4e/CtBKC/e
	IuZUz9Foa5sjvFxHY1XC0pXU3yhJELFIFnCaJhJkfsbBGQPqz3CWgDGeX6wXmVr25tsZr4CPc8g
	3yLbnXuxp/Hs8VG44sg/lRTnEG9i223U4Q5rb1IF1yU6WDMzAJPTCvF/Ito80qkpsAQkfYR+c1s
	W+zwmdLwA394AwhRx1QMKZbri/v5zE4Rmab2PQkGe+R7M0r5qUbs/lguBTagYldQMtYfx8+9HWP
	PrE3dQ==
X-Received: by 2002:a17:903:188:b0:215:7b06:90ca with SMTP id d9443c01a7336-21dd7c57d68mr81484465ad.17.1738211912349;
        Wed, 29 Jan 2025 20:38:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFiahIoPowSM27YGSPI2cloGv/kse1h98lrjSMBvVFsnZSHDm3HToPBIRU42xVvRKjySslt3w==
X-Received: by 2002:a17:903:188:b0:215:7b06:90ca with SMTP id d9443c01a7336-21dd7c57d68mr81484165ad.17.1738211911962;
        Wed, 29 Jan 2025 20:38:31 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de3320edfsm4454775ad.229.2025.01.29.20.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 20:38:31 -0800 (PST)
Message-ID: <68e545c8-57a3-4567-9e96-b46066cf6cee@redhat.com>
Date: Thu, 30 Jan 2025 14:38:22 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 19/43] arm64: RME: Allow populating initial contents
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-20-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-20-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KY1igUKJgowm5e_ervCSsdGwSD9Q9hhAnRtvH9j4q9Y_1738211912
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> The VMM needs to populate the realm with some data before starting (e.g.
> a kernel and initrd). This is measured by the RMM and used as part of
> the attestation later on.
> 
> For now only 4k mappings are supported, future work may add support for
> larger mappings.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Refactor to use PFNs rather than tracking struct page in
>     realm_create_protected_data_page().
>   * Pull changes from a later patch (in the v5 series) for accessing
>     pages from a guest memfd.
>   * Do the populate in chunks to avoid holding locks for too long and
>     triggering RCU stall warnings.
> ---
>   arch/arm64/kvm/rme.c | 243 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 243 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 22f0c74455af..d4561e368cd5 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -4,6 +4,7 @@
>    */
>   
>   #include <linux/kvm_host.h>
> +#include <linux/hugetlb.h>
>   

This wouldn't be needed since the huge pages, especially hugetlb part, isn't
supported yet.

>   #include <asm/kvm_emulate.h>
>   #include <asm/kvm_mmu.h>
> @@ -545,6 +546,236 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start, u64 size,
>   		realm_unmap_private_range(kvm, start, end);
>   }
>   
> +static int realm_create_protected_data_page(struct realm *realm,
> +					    unsigned long ipa,
> +					    kvm_pfn_t dst_pfn,
> +					    kvm_pfn_t src_pfn,
> +					    unsigned long flags)
> +{
> +	phys_addr_t dst_phys, src_phys;
> +	int ret;
> +
> +	dst_phys = __pfn_to_phys(dst_pfn);
> +	src_phys = __pfn_to_phys(src_pfn);
> +
> +	if (rmi_granule_delegate(dst_phys))
> +		return -ENXIO;
> +
> +	ret = rmi_data_create(virt_to_phys(realm->rd), dst_phys, ipa, src_phys,
> +			      flags);
> +
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		ret = realm_create_rtt_levels(realm, ipa, level,
> +					      RMM_RTT_MAX_LEVEL, NULL);
> +		if (ret)
> +			goto err;
> +
> +		ret = rmi_data_create(virt_to_phys(realm->rd), dst_phys, ipa,
> +				      src_phys, flags);
> +	}
> +
> +	if (!ret)
> +		return 0;
> +
> +err:
> +	if (WARN_ON(rmi_granule_undelegate(dst_phys))) {
> +		/* Page can't be returned to NS world so is lost */
> +		get_page(pfn_to_page(dst_pfn));
> +	}
> +	return -ENXIO;
> +}
> +
> +static int fold_rtt(struct realm *realm, unsigned long addr, int level)
> +{
> +	phys_addr_t rtt_addr;
> +	int ret;
> +
> +	ret = realm_rtt_fold(realm, addr, level + 1, &rtt_addr);
> +	if (ret)
> +		return ret;
> +
> +	free_delegated_granule(rtt_addr);
> +
> +	return 0;
> +}
> +
> +static int populate_par_region(struct kvm *kvm,
> +			       phys_addr_t ipa_base,
> +			       phys_addr_t ipa_end,
> +			       u32 flags)
> +{

At the first glance, I was wandering what's meant by 'par' in the function name.
It turns to be a 2MB region and I guess it represents 'part'. I think this may
be renamed to populate_sub_region() or populate_region() directly.

> +	struct realm *realm = &kvm->arch.realm;
> +	struct kvm_memory_slot *memslot;
> +	gfn_t base_gfn, end_gfn;
> +	int idx;
> +	phys_addr_t ipa;
> +	int ret = 0;
> +	unsigned long data_flags = 0;
> +
> +	base_gfn = gpa_to_gfn(ipa_base);
> +	end_gfn = gpa_to_gfn(ipa_end);
> +
> +	if (flags & KVM_ARM_RME_POPULATE_FLAGS_MEASURE)
> +		data_flags = RMI_MEASURE_CONTENT;
> +

The 'data_flags' can be sorted out by its caller kvm_populate_realm(), and passed
to populate_par_region(). In that way, we needn't to figure out 'data_flags' in
every call to populate_par_region().

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
> +		goto out;
> +	}
> +
> +	write_lock(&kvm->mmu_lock);
> +
> +	ipa = ipa_base;
> +	while (ipa < ipa_end) {
> +		struct vm_area_struct *vma;
> +		unsigned long map_size;
> +		unsigned int vma_shift;
> +		unsigned long offset;
> +		unsigned long hva;
> +		struct page *page;
> +		bool writeable;
> +		kvm_pfn_t pfn;
> +		int level, i;
> +
> +		hva = gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa));
> +		vma = vma_lookup(current->mm, hva);
> +		if (!vma) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		/* FIXME: Currently we only support 4k sized mappings */
> +		vma_shift = PAGE_SHIFT;
> +
> +		map_size = 1 << vma_shift;
> +
> +		ipa = ALIGN_DOWN(ipa, map_size);
> +

The blank lines in above 5 lines can be dropped :)

> +		switch (map_size) {
> +		case RMM_L2_BLOCK_SIZE:
> +			level = 2;
> +			break;
> +		case PAGE_SIZE:
> +			level = 3;
> +			break;
> +		default:
> +			WARN_ONCE(1, "Unsupported vma_shift %d", vma_shift);
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
> +		if (level < RMM_RTT_MAX_LEVEL) {
> +			/*
> +			 * A temporary RTT is needed during the map, precreate
> +			 * it, however if there is an error (e.g. missing
> +			 * parent tables) this will be handled in the
> +			 * realm_create_protected_data_page() call.
> +			 */
> +			realm_create_rtt_levels(realm, ipa, level,
> +						RMM_RTT_MAX_LEVEL, NULL);
> +		}
> +

This block of code to create the temporary RTT can be removed. With it removed,
we're going to rely on realm_create_protected_data_page() to create the needed
RTT in its failing path. If the temporary RTT has been existing, the function
call to realm_create_rtt_levels() doesn't nothing except multiple RMI calls are
issued. RMI calls aren't cheap and it causes performance lost if you agree.

> +		for (offset = 0, i = 0; offset < map_size && !ret;
> +		     offset += PAGE_SIZE, i++) {
> +			phys_addr_t page_ipa = ipa + offset;
> +			kvm_pfn_t priv_pfn;
> +			struct page *gmem_page;
> +			int order;
> +
> +			ret = kvm_gmem_get_pfn(kvm, memslot,
> +					       page_ipa >> PAGE_SHIFT,
> +					       &priv_pfn, &gmem_page, &order);
> +			if (ret)
> +				break;
> +
> +			ret = realm_create_protected_data_page(realm, page_ipa,
> +							       priv_pfn,
> +							       pfn + i,
> +							       data_flags);
> +		}
> +
> +		kvm_release_faultin_page(kvm, page, false, false);
> +
> +		if (ret)
> +			break;
> +
> +		if (level == 2)
> +			fold_rtt(realm, ipa, level);
> +
> +		ipa += map_size;
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
> +			      struct kvm_cap_arm_rme_populate_realm_args *args)
> +{
> +	phys_addr_t ipa_base, ipa_end;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EINVAL;
> +
> +	if (!IS_ALIGNED(args->populate_ipa_base, PAGE_SIZE) ||
> +	    !IS_ALIGNED(args->populate_ipa_size, PAGE_SIZE))
> +		return -EINVAL;
> +
> +	if (args->flags & ~RMI_MEASURE_CONTENT)
> +		return -EINVAL;
> +
> +	ipa_base = args->populate_ipa_base;
> +	ipa_end = ipa_base + args->populate_ipa_size;
> +
> +	if (ipa_end < ipa_base)
> +		return -EINVAL;
> +
> +	/*
> +	 * Perform the populate in parts to ensure locks are not held for too
> +	 * long
> +	 */
> +	while (ipa_base < ipa_end) {
> +		phys_addr_t end = min(ipa_end, ipa_base + SZ_2M);
> +
> +		int ret = populate_par_region(kvm, ipa_base, end,
> +					      args->flags);
> +
> +		if (ret)
> +			return ret;
> +

cond_resched() seems nice to have here so that those pending tasks can
be run immediately.

> +		ipa_base = end;
> +	}
> +
> +	return 0;
> +}
> +
>   int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>   			unsigned long start,
>   			unsigned long end,
> @@ -794,6 +1025,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   		r = kvm_init_ipa_range_realm(kvm, &args);
>   		break;
>   	}
> +	case KVM_CAP_ARM_RME_POPULATE_REALM: {
> +		struct kvm_cap_arm_rme_populate_realm_args args;
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

