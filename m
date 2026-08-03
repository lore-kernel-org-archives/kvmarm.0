Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5C8E2F8E94;
	Mon,  3 Aug 2026 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785771040; cv=none; b=b+4Sx37UYoaBQAR9/cS5gX9r9EYfxJ03vMk1WJJtUK03vjljRY8iHjrcmw4Gc6x2NezsO61y+3QyxcSZYb3WAwgeW6bb2y/muFxAQgf5BQ/GYpivG4vCH6oGpm+QPIn0j/AFG6EPjri4Y2AUXIS0zyh6qo8cdlIcoRME3NCGSZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785771040; c=relaxed/simple;
	bh=djnR4L7T9Nrisx8TzEeW+nhNQswnUw3QiSMp/xK96/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BQzpmmnFt0fluaThgljpKPW8eYZvW3b+EWLDpYCzQ3dDdhNaFOuPM+ecKjiFi7ue/8XphIE1t7I4oPVPpp9HOqVDfSFN4YrAn5cbPvPcECw9YHGClfT78ircaKV0f/y6A4d+vejRLPdfIKQU7hISywTzf7r5R4rtJl/CAR6J+Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D0rI3FMP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D0rI3FMP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 141C3143D;
	Mon,  3 Aug 2026 08:30:34 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5953A3F66F;
	Mon,  3 Aug 2026 08:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785771038; bh=djnR4L7T9Nrisx8TzEeW+nhNQswnUw3QiSMp/xK96/g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D0rI3FMPyWOky0yFms0kfx2ss+EaVr5wLg2O/5kAG/n87Q0MbZvLlSVb7/Gu4DaZF
	 YAdr0X4BHABq0TJrTe9iT2ojEd6RvB2PmgiAo4JUxJtn5yt3PAvHAiQxHropqWA4jm
	 AWZ2+hcBgaeLnr2Ydjs7KxIPZeGtNzvadL2Zn/yc=
Message-ID: <5cbbcb2d-54d4-446d-8690-ab51a62b8ff5@arm.com>
Date: Mon, 3 Aug 2026 16:30:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 20/37] KVM: arm64: CCA: Allow populating initial
 contents
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-21-steven.price@arm.com> <861pcfcr2m.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <861pcfcr2m.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/08/2026 13:43, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 15:28:22 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The VMM needs to populate the realm with some data before starting (e.g.
>> a kernel and initrd). This is measured by the RMM and used as part of
>> the attestation later on.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v14:
>>  * Holding of locks slots_lock and config_lock have been moved up the
>>    callstack with lockdesp assertions placed in the lower functions.
>>  * Add overflow check into kvm_arm_rmi_populate().
>> Changes since v13:
>>  * Rename realm_create_protected_data_page() to realm_data_map_init().
>> Changes since v12:
>>  * The ioctl now updates the structure with the amount populated rather
>>    than returning this through the ioctl return code.
>>  * Use the new RMM v2.0 range based RMI calls.
>>  * Adapt to upstream changes in kvm_gmem_populate().
>> Changes since v11:
>>  * The multiplex CAP is gone and there's a new ioctl which makes use of
>>    the generic kvm_gmem_populate() functionality.
>> Changes since v7:
>>  * Improve the error codes.
>>  * Other minor changes from review.
>> Changes since v6:
>>  * Handle host potentially having a larger page size than the RMM
>>    granule.
>>  * Drop historic "par" (protected address range) from
>>    populate_par_region() - it doesn't exist within the current
>>    architecture.
>>  * Add a cond_resched() call in kvm_populate_realm().
>> Changes since v5:
>>  * Refactor to use PFNs rather than tracking struct page in
>>    realm_create_protected_data_page().
>>  * Pull changes from a later patch (in the v5 series) for accessing
>>    pages from a guest memfd.
>>  * Do the populate in chunks to avoid holding locks for too long and
>>    triggering RCU stall warnings.
>> ---
>>  arch/arm64/include/asm/kvm_rmi.h |   4 ++
>>  arch/arm64/kvm/Kconfig           |   1 +
>>  arch/arm64/kvm/arm.c             |  13 ++++
>>  arch/arm64/kvm/rmi.c             | 119 +++++++++++++++++++++++++++++++
>>  4 files changed, 137 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index 5cb99c187202..fd0c57594a22 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -105,6 +105,10 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
>>  int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>>  int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>>  
>> +struct kvm_arm_rmi_populate;
>> +
>> +int kvm_arm_rmi_populate(struct kvm *kvm,
>> +			 struct kvm_arm_rmi_populate *arg);
>>  void kvm_realm_unmap_range(struct kvm *kvm,
>>  			   unsigned long ipa,
>>  			   unsigned long size,
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index 189e8ad78b22..83b95e836b4d 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -37,6 +37,7 @@ menuconfig KVM
>>  	select SCHED_INFO
>>  	select GUEST_PERF_EVENTS if PERF_EVENTS
>>  	select KVM_GUEST_MEMFD
>> +	select HAVE_KVM_ARCH_GMEM_POPULATE
>>  	select ARM_RMM
>>  	help
>>  	  Support hosting virtualized guest machines.
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index df33322b8fea..1558bb12b1b1 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -2153,6 +2153,19 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>  			return -EFAULT;
>>  		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
>>  	}
>> +	case KVM_ARM_RMI_POPULATE: {
>> +		struct kvm_arm_rmi_populate req;
>> +		int ret;
>> +
>> +		if (!kvm_is_realm(kvm))
>> +			return -ENXIO;
>> +		if (copy_from_user(&req, argp, sizeof(req)))
>> +			return -EFAULT;
>> +		ret = kvm_arm_rmi_populate(kvm, &req);
>> +		if (copy_to_user(argp, &req, sizeof(req)))
>> +			return -EFAULT;
>> +		return ret;
>> +	}
>>  	default:
>>  		return -EINVAL;
>>  	}
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 53b5b18f2275..e2b4c64e982d 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -590,6 +590,76 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>>  		realm_unmap_private_range(kvm, start, end, may_block);
>>  }
>>  
>> +static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
>> +			       kvm_pfn_t dst_pfn, kvm_pfn_t src_pfn,
>> +			       unsigned long flags)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	phys_addr_t rd = virt_to_phys(realm->rd);
>> +	phys_addr_t dst_phys, src_phys;
>> +	int ret;
>> +
>> +	lockdep_assert_held(&kvm->slots_lock);
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	dst_phys = __pfn_to_phys(dst_pfn);
>> +	src_phys = __pfn_to_phys(src_pfn);
>> +
>> +	if (rmi_delegate_page(dst_phys))
>> +		return -ENXIO;
>> +
>> +retry:
>> +	ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
>> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +		/* Create missing RTTs and retry */
>> +		int level = RMI_RETURN_INDEX(ret);
>> +
>> +		KVM_BUG_ON(level >= KVM_PGTABLE_LAST_LEVEL, kvm);
> 
> Surely you should break here and make it stop, right? The VM is bugged
> anyway, so what's the point in continuing?

True, this should have an early error return.

>> +
>> +		ret = realm_create_rtt_levels(realm, ipa, level,
>> +					      level + 1, NULL);
>> +		if (!ret)
>> +			goto retry;
>> +	}
>> +
>> +	if (ret && WARN_ON(rmi_undelegate_page(dst_phys))) {
>> +		/* Leak the page if the undelegate fails */
>> +		get_page(pfn_to_page(dst_pfn));
> 
> Same here. The VM should be dead.

Ack.

>> +	}
>> +
>> +	return ret <= 0 ? ret : -ENXIO;
>> +}
>> +
>> +static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>> +			      struct page *src_page, void *opaque)
>> +{
>> +	unsigned long data_flags = *(unsigned long *)opaque;
>> +	phys_addr_t ipa = gfn_to_gpa(gfn);
>> +
>> +	return realm_data_map_init(kvm, ipa, pfn, page_to_pfn(src_page),
>> +				   data_flags);
>> +}
>> +
>> +static long populate_region(struct kvm *kvm,
>> +			    gfn_t base_gfn,
>> +			    unsigned long pages,
>> +			    u64 uaddr,
>> +			    unsigned long data_flags)
>> +{
>> +	long ret = 0;
>> +
>> +	lockdep_assert_held(&kvm->slots_lock);
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	if (!uaddr)
>> +		return -EINVAL;
>> +
>> +	ret = kvm_gmem_populate(kvm, base_gfn, u64_to_user_ptr(uaddr), pages,
>> +				false, populate_region_cb, &data_flags);
>> +
>> +	return ret;
>> +}
>> +
>>  enum ripas_action {
>>  	RIPAS_INIT,
>>  	RIPAS_SET,
>> @@ -705,6 +775,55 @@ static int realm_ensure_created(struct kvm *kvm)
>>  	return realm_create_rd(kvm);
>>  }
>>  
>> +int kvm_arm_rmi_populate(struct kvm *kvm,
>> +			 struct kvm_arm_rmi_populate *args)
>> +{
>> +	unsigned long data_flags = 0;
>> +	unsigned long ipa_start = args->base;
>> +	unsigned long ipa_end = ipa_start + args->size;
>> +	long pages_populated;
>> +	int ret;
>> +
>> +	if (args->reserved ||
>> +	    (args->flags & ~KVM_ARM_RMI_POPULATE_FLAGS_MEASURE) ||
>> +	    args->base + args->size < args->base ||
> 
> More importantly, what checks that this is within the IPA range?

So I think this should fail gracefully when we fail to find the memslot.
But I agree an explicit check here would be easier to reason about.

Thanks,
Steve

>> +	    !IS_ALIGNED(ipa_start, PAGE_SIZE) ||
>> +	    !IS_ALIGNED(ipa_end, PAGE_SIZE) ||
>> +	    !IS_ALIGNED(args->source_uaddr, PAGE_SIZE))
>> +		return -EINVAL;
>> +
>> +	if (args->flags & KVM_ARM_RMI_POPULATE_FLAGS_MEASURE)
>> +		data_flags |= RMI_MEASURE_CONTENT;
>> +
>> +	mutex_lock(&kvm->slots_lock);
>> +	mutex_lock(&kvm->arch.config_lock);
>> +
>> +	ret = realm_ensure_created(kvm);
>> +	if (ret)
>> +		goto out_unlock;
>> +
>> +	if (args->size == 0)
>> +		goto out_unlock;
>> +
>> +	pages_populated = populate_region(kvm, gpa_to_gfn(ipa_start),
>> +					  args->size >> PAGE_SHIFT,
>> +					  args->source_uaddr, data_flags);
>> +
>> +	if (pages_populated < 0) {
>> +		ret = pages_populated;
>> +		goto out_unlock;
>> +	}
>> +
>> +	args->size -= pages_populated << PAGE_SHIFT;
>> +	args->source_uaddr += pages_populated << PAGE_SHIFT;
>> +	args->base += pages_populated << PAGE_SHIFT;
>> +
>> +out_unlock:
>> +	mutex_unlock(&kvm->arch.config_lock);
>> +	mutex_unlock(&kvm->slots_lock);
>> +	return ret;
>> +}
>> +
>>  static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm *kvm = vcpu->kvm;
> 
> 	M.
> 

