Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2CB3DB300
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 22:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787005493; cv=none; b=A33UahmZNq0Tx6hCvzBu885le+DWFudypVFH9nal8yRBORlG9agkCJSaAX1+Y4OsosXkz+t0ksm+ekKoBP/QN/hVBZpjMgZsGvvFHxyCZ7gKPE6StY7+Ub0KWt4i98DJ+wn1OEYZ/v26omwFlDzgxMuQwSG3kW3B0GSHHcHUxpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787005493; c=relaxed/simple;
	bh=X0XI1mBIwXiTsh/WI3BrAwfPGJazigDX28jJiz289Xw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Aj+h338dESnFeOJfqfMFY37r8TtTsvHaaQbZUpjvgy3XPdU7Zh/VmxGtahDS8LIhtwzq8gaDtnh5H2V30lXoJASaturX75ozKjA3l7HGG07HDLT657q7RtCBkD2K0+sgWi4oMmeWhOP5GDed58hVcu/k1VJZdcgX4GH87leFB50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dC+APQsV; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dC+APQsV"
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-49ab6a82cd5so5951769b6e.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 15:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787005489; x=1787610289; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CRgSmV2/Mlq0/0RFaXlCT6VkbcpoQhhxjZNhjQH02WQ=;
        b=dC+APQsVe1ggUJcX0AYl5XoRWHLGs2SnzCo0HXV5ybp5JULIjs9lbSq0j6PgD3B+Eh
         30KB4A5+xy9F8nFb78eCJXinrHIILXoY3RY200gG+ouiGYnqyGHIdr1yJ7oj+ZMjtPbl
         xldA4bd2M1Xi8hBlA1/1em2ahyV67EhUliI5EbnlxEa219ya9XhHDBLcX+GG3uhlqAwb
         p5e+Q27+QTdnr0oEdMqqNBsALItsDj+Fh0R0rMy8b6splO/eMM4MXgWJBqL4t619e4bq
         EA+FxuEw6Jx2WAtc68VYuw3eGGgRyhIqmz78oYmKOL2GjECrJ3tbImJmNBxWmm5nOsqZ
         D8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787005489; x=1787610289;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CRgSmV2/Mlq0/0RFaXlCT6VkbcpoQhhxjZNhjQH02WQ=;
        b=tGMU2j0BRlCvnWbftMv8Dd1XcGBfUaXaSKMrqCcnG7kuYyDr1kTRCZTAQoqcHqZMml
         buDTEFIC/pthhjpdUdQv8YJgFiUku8MpCsOUcfQg3k2kyfKjpuDp6Ey4fV5rbN/Ow5DO
         uxwEsl8ckq/PJzhMYBJuh89fUuQPMdqymQmgTQXYc5PL8eBDmCHFGW0+D0hU4tVEYYzQ
         iol521FPjAl5HW6pwJUP9BPCCt3iEtm+asNniMge5DgMd9C2RC/AWei1wINtFu7hCgFw
         UsceRzaBtGeWfRy+wCRvwROuSokGuhz24RIUHdUtYrM4dbIVlMyDiKxUOzthFvYMcwUK
         +4sg==
X-Forwarded-Encrypted: i=1; AHgh+Rp9pHQ+dXfgvaAAyXZ2RSBZ2oHC01b+fKfnSvThCTLCEMZA+7knwUKS0BSwcznKvjADv6z185w=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywt1d9LvgzmssPLjNjP1HT3u4WVZYka48OJ+YpAC+X1UiKqv3bZ
	SeRUtt5wrY8EdmX652Ot/vSB8gNtIvgIhSKXYlcrTDDIQCsHFa8CZLgkZ8MujypZHTOlu049g+e
	UCcnvBW/jA1WffYFsJA0i2Ek03w==
X-Received: from ilgj3.prod.google.com ([2002:a05:6e02:6343:b0:507:fa97:693c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:17a1:b0:4aa:d5f:123e with SMTP id 5614622812f47-4b241726ef4mr26959054b6e.9.1787005489082;
 Mon, 17 Aug 2026 15:24:49 -0700 (PDT)
Date: Mon, 17 Aug 2026 22:24:48 +0000
In-Reply-To: <16296d40-67f3-4e50-923c-5b26fc122121@intel.com> (zide.chen@intel.com)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntv798tmfj.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 14/21] KVM: arm64: Apply dynamic guest counter reservations
From: Colton Lewis <coltonlewis@google.com>
To: "Chen, Zide" <zide.chen@intel.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	james.clark@linaro.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Zide, thanks for the review.

"Chen, Zide" <zide.chen@intel.com> writes:

> On 6/12/2026 2:29 PM, Colton Lewis wrote:
>> Apply dynamic guest counter reservations by checking if the requested
>> guest mask collides with any events the host has scheduled and calling
>> pmu_perf_resched_update() with a hook that updates the mask of
>> available counters in between schedule out and schedule in.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm64/kvm/pmu-direct.c  | 69 +++++++++++++++++++++++++++++++++++-
>>   include/linux/perf/arm_pmu.h |  1 +
>>   2 files changed, 69 insertions(+), 1 deletion(-)

>> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
>> index 49f1feb5d280c..044f011c9c84b 100644
>> --- a/arch/arm64/kvm/pmu-direct.c
>> +++ b/arch/arm64/kvm/pmu-direct.c
>> @@ -87,6 +87,73 @@ u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
>>   		ARMV8_PMU_PMCR_N);
>>   }

>> +/* Callback to update counter mask between perf scheduling */
>> +static void kvm_pmu_update_mask(struct pmu *pmu, void *data)
>> +{
>> +	struct arm_pmu *arm_pmu = to_arm_pmu(pmu);
>> +	unsigned long *new_mask = data;
>> +
>> +	bitmap_copy(arm_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
>> +}
>> +
>> +/**
>> + * kvm_pmu_set_guest_counters() - Handle dynamic counter reservations
>> + * @cpu_pmu: struct arm_pmu to potentially modify
>> + * @guest_mask: new guest mask for the pmu
>> + *
>> + * Check if guest counters will interfere with current host events and
>> + * call into perf_pmu_resched_update if a reschedule is required.
>> + */
>> +static void kvm_pmu_set_guest_counters(struct arm_pmu *cpu_pmu, u64  
>> guest_mask)
>> +{
>> +	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
>> +	DECLARE_BITMAP(guest_bitmap, ARMPMU_MAX_HWEVENTS);
>> +	DECLARE_BITMAP(new_mask, ARMPMU_MAX_HWEVENTS);
>> +	bool need_resched = false;
>> +
>> +	bitmap_from_arr64(guest_bitmap, &guest_mask, ARMPMU_MAX_HWEVENTS);
>> +	bitmap_copy(new_mask, cpu_pmu->hw_cntr_impl, ARMPMU_MAX_HWEVENTS);
>> +
>> +	if (guest_mask) {
>> +		/* Subtract guest counters from available host mask */
>> +		bitmap_andnot(new_mask, new_mask, guest_bitmap, ARMPMU_MAX_HWEVENTS);
>> +
>> +		/* Did we collide with an active host event? */
>> +		if (bitmap_intersects(cpuc->used_mask, guest_bitmap,  
>> ARMPMU_MAX_HWEVENTS)) {
>> +			int idx;
>> +
>> +			need_resched = true;
>> +			cpuc->host_squeezed = true;
>> +
>> +			/* Look for pinned events that are about to be preempted */
>> +			for_each_set_bit(idx, guest_bitmap, ARMPMU_MAX_HWEVENTS) {
>> +				if (test_bit(idx, cpuc->used_mask) && cpuc->events[idx] &&
>> +				    cpuc->events[idx]->attr.pinned) {
>> +					pr_warn_once("perf: Pinned host event squeezed out by KVM guest  
>> PMU partition\n");
>> +					break;
>> +				}
>> +			}
>> +		}
>> +	} else {
>> +		/*
>> +		 * Restoring to hw_cntr_impl.
>> +		 * Only resched if we previously squeezed an event.
>> +		 */
>> +		if (cpuc->host_squeezed) {
>> +			need_resched = true;
>> +			cpuc->host_squeezed = false;
>> +		}
>> +	}
>> +
>> +	if (need_resched) {
>> +		/* Collision: run full perf reschedule */
>> +		perf_pmu_resched_update(&cpu_pmu->pmu, kvm_pmu_update_mask, new_mask);
>> +	} else {
>> +		/* Host was never using guest counters anyway */
>> +		bitmap_copy(cpu_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
>> +	}
>> +}
>> +
>>   /**
>>    * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved  
>> counters
>>    * @pmu: Pointer to arm_pmu struct
>> @@ -209,6 +276,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)

>>   	pmu = vcpu->kvm->arch.arm_pmu;
>>   	guest_counters = kvm_pmu_guest_counter_mask(pmu);
>> +	kvm_pmu_set_guest_counters(pmu, guest_counters);
>>   	kvm_pmu_apply_event_filter(vcpu);

>>   	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
>> @@ -317,7 +385,6 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
>>   	/* Stop guest counters and disable interrupts in hardware. */
>>   	write_sysreg(mask, pmcntenclr_el0);
>>   	write_sysreg(mask, pmintenclr_el1);
>> -
>>   	kvm_pmu_set_guest_counters(pmu, 0);

> I must have missed something.

> Here, vcpu->kvm->arch.arm_pmu->cntr_mask is restored to cntr_mask_impl.
> Is this same struct shared with the perf driver
> (to_arm_pmu(event->pmu)), and shared across other vCPUs as well?

> If so, if another pCPU still has a PMU-partition-enabled vcpu loaded
> with guest-owned counters (MDCR_EL2.HPMN is set), could a host event be
> scheduled onto one of those guest-owned counters, conflicting with the
> guest?

You're correct that is shared more widely than appropriate and could
cause such a conflict.

cntr_mask should be moved to the per-CPU struct pmu_hw_events inside
struct arm_pmu.

>>   	preempt_enable();
>>   }
