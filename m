Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1CBEEA8
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 05:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779946238; cv=none; b=FSZFDe2wyPtziMgIn65jbDKEtWxCdKR8RiNO5l+rXDUvBqdhYoJCmqM9bM61AOALoZppNTcKMfcicun1wji6ZEs4pzIuX9wWOlw9X8Rnl/5lwfVcqN01j03oo3O6pAr88mTCGOwAFjhbx/6v31FJ02AdUbZF6SZMGCyY2aR34nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779946238; c=relaxed/simple;
	bh=DgWGKIje13k1TapEkr+MBgcoQR7z1LfAsyvCQ1fD20E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=APkgsXUbhqUvP4Qj7rBnxL/vXtTWqtgNRDWzQSDonoEZgRQPbPBOUiVtGXNf666PdN3a6UXyZdVSXCBRVOWwLD0tM0jD1M5uW5Lu5SDITcS3CaiJqhG8ys3dMN/hNpOsx/sqRLj8ZTGeJXJqMfvfHiHKqJPTrUcxVrr8JlpobaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qa6Gis8B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qa6Gis8B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779946234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q73WX9HWItM842HL8te6BLbm9UQjrRb26yA0hD3pI7M=;
	b=Qa6Gis8BG1wUGDSH62+t+2Tlwjygubw1RSeXwSNm5LryKxXY0WB95vzYad0xD3s8fSqzRb
	ghLLKYGzhlndFD/dE0XT5m+EaanMLlyJil0Z/Gt6XpHgLNl2QhIg/006MIQ8vhiZrMx4Fh
	054RR9oi7fjT9RrI0m2ukVAFXWz6oXY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-cHgx4tiXNda_CXOABiMl5w-1; Thu, 28 May 2026 01:30:33 -0400
X-MC-Unique: cHgx4tiXNda_CXOABiMl5w-1
X-Mimecast-MFC-AGG-ID: cHgx4tiXNda_CXOABiMl5w_1779946232
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bf004bf8beso8049045ad.3
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 22:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779946232; x=1780551032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q73WX9HWItM842HL8te6BLbm9UQjrRb26yA0hD3pI7M=;
        b=bGM8Gl3LmiGyzQfu5LkBxWsp6bl8EdCMaPsFDFViHdTG7i0/ld4GDS1oHHao0be+kW
         texQOIrIjKYYZazY6Fuon7FaaLdXGxdepRYja5xYnqPiSXqrqFSgjV/U4VpNmwlh/J1Z
         49htDdiKY55l9O6QvunSwWWrfK1+2ClRr/teKYWq5VoM2xt1ZObiKMVyuWtHqUmVEngj
         eCjOyUXmgq2vKSfpcNYOkJYwWeaqiiTicIeObBCaU5SZDBm6q6YHX1aN3xzwZnXJrM/C
         m7G2F7zBzOYhGg6euospjiOBuzIpUWyN6U6VCFHvPSbH1aLXaa3ODHx9qrcrOMZah1Cf
         DZRQ==
X-Forwarded-Encrypted: i=1; AFNElJ+DxeWW9ChmpT2qYHrtERdyBuGrd32jCCA0toL2Tv6vQ94jutf4dzKcPjaNHKTRL5AUAjnPzmc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVXU+9QyIvnSYwChhKvSaOW7u88cdhfBxEzzkVfQh/wJciYcnM
	gbOe8thkxhBpKz1e5kw8fGYOPEU87aJwkq7O2HXqNqbOTE2QtVNFxsPbRtsDknCIM1raM7UzVLE
	PcdxVeAcg1/NCthk13Q1z8syct1X1Dxpfbaewf9zcCTzdtYN2Ybph48hOLQ==
X-Gm-Gg: Acq92OGeLgFztaeZbr3YQPgBX8xQFv0xi7jTRQFh3dD2qcbvlMNSFCvcO9yWss0pEjN
	KLZgX+r9IzAz1ejlocujFdnSyjJeKGom1lVq4Ix+B1BZ7+4SwSrcBa2tOaFIKL9JR81KfMB8mB/
	iLvohtFZHZp1kz+wMl1PC5sMV5xxP+G2aLTl9MLgNIR+w0CtQ+bHYOmGBMT+Px8mgUx9CFdXjx1
	LBO1O3r8qXkGWG3qDGvkp0DnadsMomfRY/DSwfWIrcFxhdzL0vNZbyEPHZYJcTUn1oYjiyZwDUO
	PJr5hhRI8MQdpxf+CX2H8kdGzfptQTi5emQZBgBN77wicbfmPMO+O7KzXVnn+Dl8sRdJGbzVk8j
	qPOEqg8v5OEuyBopp9jC9MTqCJBMZzA5gfQJt0apOSvVHC2IAb+M5TLeY7Cq5vEtlln9RGYyysw
	E=
X-Received: by 2002:a17:903:4b07:b0:2bd:5b20:a5b5 with SMTP id d9443c01a7336-2beb066cd73mr260282085ad.37.1779946232105;
        Wed, 27 May 2026 22:30:32 -0700 (PDT)
X-Received: by 2002:a17:903:4b07:b0:2bd:5b20:a5b5 with SMTP id d9443c01a7336-2beb066cd73mr260281545ad.37.1779946231485;
        Wed, 27 May 2026 22:30:31 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56d2702sm173761155ad.31.2026.05.27.22.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 22:30:30 -0700 (PDT)
Message-ID: <ea4be6c5-9506-4253-80c5-c76c9ac3b77d@redhat.com>
Date: Thu, 28 May 2026 15:30:19 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 26/44] arm64: RMI: Allow populating initial contents
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-27-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260513131757.116630-27-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rJRInwJU6f1CY_M-LbgNryWjcBGSHLcvX93WCZJVKaQ_1779946232
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

On 5/13/26 11:17 PM, Steven Price wrote:
> The VMM needs to populate the realm with some data before starting (e.g.
> a kernel and initrd). This is measured by the RMM and used as part of
> the attestation later on.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v13:
>   * Rename realm_create_protected_data_page() to realm_data_map_init().
> Changes since v12:
>   * The ioctl now updates the structure with the amount populated rather
>     than returning this through the ioctl return code.
>   * Use the new RMM v2.0 range based RMI calls.
>   * Adapt to upstream changes in kvm_gmem_populate().
> Changes since v11:
>   * The multiplex CAP is gone and there's a new ioctl which makes use of
>     the generic kvm_gmem_populate() functionality.
> Changes since v7:
>   * Improve the error codes.
>   * Other minor changes from review.
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
>   arch/arm64/include/asm/kvm_rmi.h |   4 ++
>   arch/arm64/kvm/Kconfig           |   1 +
>   arch/arm64/kvm/arm.c             |  13 ++++
>   arch/arm64/kvm/rmi.c             | 106 +++++++++++++++++++++++++++++++
>   4 files changed, 124 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 007249a13dbc..a2b6bc412a22 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -88,6 +88,10 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
>   int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>   int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>   
> +struct kvm_arm_rmi_populate;
> +
> +int kvm_arm_rmi_populate(struct kvm *kvm,
> +			 struct kvm_arm_rmi_populate *arg);
>   void kvm_realm_unmap_range(struct kvm *kvm,
>   			   unsigned long ipa,
>   			   unsigned long size,
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 4e16719fda22..d0cd011cf672 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -38,6 +38,7 @@ menuconfig KVM
>   	select GUEST_PERF_EVENTS if PERF_EVENTS
>   	select KVM_GUEST_MEMFD
>   	select KVM_GENERIC_MEMORY_ATTRIBUTES
> +	select HAVE_KVM_ARCH_GMEM_POPULATE
>   	help
>   	  Support hosting virtualized guest machines.
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ed88a203b892..073ba9181da9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2131,6 +2131,19 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   			return -EFAULT;
>   		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
>   	}
> +	case KVM_ARM_RMI_POPULATE: {
> +		struct kvm_arm_rmi_populate req;
> +		int ret;
> +
> +		if (!kvm_is_realm(kvm))
> +			return -ENXIO;
> +		if (copy_from_user(&req, argp, sizeof(req)))
> +			return -EFAULT;
> +		ret = kvm_arm_rmi_populate(kvm, &req);
> +		if (copy_to_user(argp, &req, sizeof(req)))
> +			return -EFAULT;
> +		return ret;
> +	}

s/return ret/return 0; The variable 'ret' can be dropped.

>   	default:
>   		return -EINVAL;
>   	}
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index a89873a5eb77..209087bcf399 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -486,6 +486,75 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>   		realm_unmap_private_range(kvm, start, end, may_block);
>   }
>   
> +static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
> +			       kvm_pfn_t dst_pfn, kvm_pfn_t src_pfn,
> +			       unsigned long flags)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	phys_addr_t dst_phys, src_phys;
> +	int ret;
> +
> +	dst_phys = __pfn_to_phys(dst_pfn);
> +	src_phys = __pfn_to_phys(src_pfn);
> +
> +	if (rmi_delegate_page(dst_phys))
> +		return -ENXIO;
> +
> +	ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		KVM_BUG_ON(level == KVM_PGTABLE_LAST_LEVEL, kvm);

		KVM_BUG_ON(level >= KVM_PGTABLE_LAST_LEVEL, kvm);> +
> +		ret = realm_create_rtt_levels(realm, ipa, level,
> +					      KVM_PGTABLE_LAST_LEVEL, NULL);
> +		if (!ret) {
> +			ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys,
> +						    flags);
> +		}
> +	}
> +
> +	if (ret) {
> +		if (WARN_ON(rmi_undelegate_page(dst_phys))) {
> +			/* Undelegate failed, so we leak the page */
> +			get_page(pfn_to_page(dst_pfn));
> +		}
> +	}
> +

	if (ret && WARN_ON(rmi_undelegate_page(dst_phys)) {
		/* Leak the page that fails to be undelegated */
		get_page(pfn_to_page(dst_pfn));
	}

> +	return ret;
> +}
> +
> +static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +			      struct page *src_page, void *opaque)
> +{
> +	unsigned long data_flags = *(unsigned long *)opaque;
> +	phys_addr_t ipa = gfn_to_gpa(gfn);
> +
> +	if (!src_page)
> +		return -EOPNOTSUPP;
> +
> +	return realm_data_map_init(kvm, ipa, pfn, page_to_pfn(src_page),
> +				   data_flags);
> +}
> +
> +static long populate_region(struct kvm *kvm,
> +			    gfn_t base_gfn,
> +			    unsigned long pages,
> +			    u64 uaddr,
> +			    unsigned long data_flags)
> +{
> +	long ret = 0;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	ret = kvm_gmem_populate(kvm, base_gfn, u64_to_user_ptr(uaddr), pages,
> +				populate_region_cb, &data_flags);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return ret;
> +}
> +
>   enum ripas_action {
>   	RIPAS_INIT,
>   	RIPAS_SET,
> @@ -574,6 +643,43 @@ static int realm_ensure_created(struct kvm *kvm)
>   	return -ENXIO;
>   }
>   
> +int kvm_arm_rmi_populate(struct kvm *kvm,
> +			 struct kvm_arm_rmi_populate *args)
> +{
> +	unsigned long data_flags = 0;
> +	unsigned long ipa_start = args->base;
> +	unsigned long ipa_end = ipa_start + args->size;
> +	long pages_populated;
> +	int ret;
> +
> +	if (args->reserved ||
> +	    (args->flags & ~KVM_ARM_RMI_POPULATE_FLAGS_MEASURE) ||
> +	    !IS_ALIGNED(ipa_start, PAGE_SIZE) ||
> +	    !IS_ALIGNED(ipa_end, PAGE_SIZE) ||
> +	    !IS_ALIGNED(args->source_uaddr, PAGE_SIZE))
> +		return -EINVAL;
> +

There are more conditions missed here:

	args->size == 0, return 0;
	args->base + args->size < args->base, return -EINVAL;  // wrapped range

> +	ret = realm_ensure_created(kvm);
> +	if (ret)
> +		return ret;
> +
> +	if (args->flags & KVM_ARM_RMI_POPULATE_FLAGS_MEASURE)
> +		data_flags |= RMI_MEASURE_CONTENT;
> +
> +	pages_populated = populate_region(kvm, gpa_to_gfn(ipa_start),
> +					  args->size >> PAGE_SHIFT,
> +					  args->source_uaddr, data_flags);
> +
> +	if (pages_populated < 0)
> +		return pages_populated;

pages_populaged is 'unsigned long', this function returns a 'int' value.

> +
> +	args->size -= pages_populated << PAGE_SHIFT;
> +	args->source_uaddr += pages_populated << PAGE_SHIFT;
> +	args->base += pages_populated << PAGE_SHIFT;
> +
> +	return 0;
> +}
> +
>   static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm *kvm = vcpu->kvm;

Thanks,
Gavin

