Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8D33DE441
	for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 09:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778749807; cv=none; b=NzLFSD3pZ/Z3C3ZOjlPMcGllfddqr/mEKVvBKyn+hdEE5DPiho9PABuRzUreuejr1sXIGRxXTrahejWkNvg63Vc+hHTxIhsrlku/Vcao3srWiPHEP1OfbQElPkptpHUEEJ9l61eBqUQXCqFqwp8+9srzMnAAxOBtBqzUJ+q0/N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778749807; c=relaxed/simple;
	bh=C3Lb5cvFAMNlyCIVl8ipWcR3gjPB2vdBwhDFk2jz4H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DIVdIIU+0Kwkva63F2xXif2AqDQmvMIB4h5YoEvfVWHqFGrW+QeU4haZkXdHvJ81+33iJMFf00Flqs7sAJETHRXQhS4ZSsZ3ExXaMjsOq8MqCx9G95hGMzgoKpOoqdD7jeNO8cK1KmFW7T3wSAqgsrp5Kg3hhqFqO5aLXQHrjmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A7dOK7KN; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A7dOK7KN"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so128512975e9.2
        for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 02:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1778749804; x=1779354604; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/zJBoYCXvN5LO7DBit1Ku7VesIuEtdWFZWxNt6CCQH0=;
        b=A7dOK7KN3gfmjF+d5Q9y06TXSGHpKTTteXJEEHo20iRBJHhYpBgfUJ7Cao82IX0HcM
         2oW3QpIhK3h27cTtrCWwVtDzPP/SXWZDvz3YOa81Zt2vmIWYyXP2LV4llDq5iEiTRHnW
         M5jpm6YgrUFvQpD25XaKe1Qu3IV0JpWxTzk/bqPXZ0RGLhG28NAkCVSK1WxTZceahxJz
         VGIi4bBQArkwFSLcH/bs7DLkkRv8Rd6qRwuTCIrVJm9vu8Mw1ocIwNQQ+r+o2afzAhX2
         0f+Uj7AZB/Ybars47zPpb0thHvdGAuOgbUFIB6k6Wjy1FgX9DYzoyBw/Qql0WOmCE/N+
         YURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778749804; x=1779354604;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zJBoYCXvN5LO7DBit1Ku7VesIuEtdWFZWxNt6CCQH0=;
        b=RABkfNdVrnr0VHwj/zRrT1tURFvAyY6GLT0QYUdW4ygtfSsswb99lnwdf2VnUm8mTm
         6W+kTc++ODp1EQTa4duG2DN8v/10tzLTMEtFhupzykfuqYglcSHdv9k2+ivMdrKMC2g3
         SJf/LRoLTOXXBDQ2ZBHm4wSjZUwT57n+DNdIg1QID+7Pvz00x4hRYSaJEsssci4QzcLm
         YbQdAD7n2FBmjGd9CoIeK2FqPBFadeE+MJh8e7ur7mw3Z2h0OW0+iSY2DK4/zvoyUSNU
         yHTEucrSEX+YezydLhUjpOUU6lOXXAoN8IkHravCAtO058kTZsUSfJiV0a6ARv4JzxFN
         p25g==
X-Forwarded-Encrypted: i=1; AFNElJ/q+KGPm7fM+Fn95G876yq0BtCf7rSnKFWm1RE0riVT55jnyHDmGqV+a9q/50weq9tCGujLKWY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzW65lTes03MiTsseEAfod8C9d+cCNzQtNVi2dbsUrZ1SpdEvcw
	hksRbTl1GIBXGj7KInFUZTmZ7ZHc/YhQU7Tv2kP+YwkTfPc92e95emIPrZXPq3Itvpw=
X-Gm-Gg: Acq92OE3KGdh8/MOckbNZPEM40euLvUDf3lKMr2uB2AB0p84PnJsosceHrtdjL2TkjC
	zRhl9//LJFpqoZ5uzIhwi8Hf1/PMqm8YVVX9GpLWD3tCQ5+5PtkCvyNqdQxdscRo1YtMGMz2SCI
	W83O8N+RlzvcUummMXSy8qORc0gqYprL3ARRarzLF66SJN5nYQRT+HoMOxvG7IAMhZECDMmGvUn
	HI5F4eXdeo/79gwbfJI7vQEz8MxF/B3taPKT6HdUD+6iibd1fihjEjmDCuLhw1uUayvqWCDwter
	zA8bGWgomQL52bnMqSDLnZ7QoPyV3DyXRZwJykNmQy0RmvdAZ1wTbPzEuTONlhMK3O/0/VP7RIZ
	6SYpUKyGsfVU8k6Fe/sZkVkZ6Ff7mSRxSfGEOxHMHH9MOoga9MfF80iSv3+JLKhZt7oMqC/T9aM
	PvrSvC2Fkr5YU3qRgDGQyxFNV1u3/P
X-Received: by 2002:a05:600c:19d1:b0:48e:8499:4be0 with SMTP id 5b1f17b1804b1-48fdc714b8amr23783895e9.15.1778749804059;
        Thu, 14 May 2026 02:10:04 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fdb2788eesm34097965e9.7.2026.05.14.02.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 02:10:03 -0700 (PDT)
Message-ID: <66797cb2-18f7-4782-9370-68d0c10c35f4@linaro.org>
Date: Thu, 14 May 2026 10:10:02 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 13/20] KVM: arm64: Apply dynamic guest counter
 reservations
To: Colton Lewis <coltonlewis@google.com>
Cc: alexandru.elisei@arm.com, pbonzini@redhat.com, corbet@lwn.net,
 linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
 maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <gsntzf23b6m2.fsf@coltonlewis-kvm.c.googlers.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <gsntzf23b6m2.fsf@coltonlewis-kvm.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 13/05/2026 5:45 pm, Colton Lewis wrote:
> James Clark <james.clark@linaro.org> writes:
> 
>> On 04/05/2026 10:18 pm, Colton Lewis wrote:
>>> Apply dynamic guest counter reservations by checking if the requested
>>> guest mask collides with any events the host has scheduled and calling
>>> pmu_perf_resched_update() with a hook that updates the mask of
>>> available counters in between schedule out and schedule in.
> 
>>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>>> ---
>>>    arch/arm64/kvm/pmu-direct.c  | 69 ++++++++++++++++++++++++++++++++ 
>>> ++++
>>>    include/linux/perf/arm_pmu.h |  1 +
>>>    2 files changed, 70 insertions(+)
> 
>>> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
>>> index 2252d3b905db9..14cc419dbafad 100644
>>> --- a/arch/arm64/kvm/pmu-direct.c
>>> +++ b/arch/arm64/kvm/pmu-direct.c
>>> @@ -100,6 +100,73 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
>>>        return *host_data_ptr(nr_event_counters);
>>>    }
> 
>>> +/* Callback to update counter mask between perf scheduling */
>>> +static void kvm_pmu_update_mask(struct pmu *pmu, void *data)
>>> +{
>>> +    struct arm_pmu *arm_pmu = to_arm_pmu(pmu);
>>> +    unsigned long *new_mask = data;
>>> +
>>> +    bitmap_copy(arm_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
>>> +}
>>> +
>>> +/**
>>> + * kvm_pmu_set_guest_counters() - Handle dynamic counter reservations
>>> + * @cpu_pmu: struct arm_pmu to potentially modify
>>> + * @guest_mask: new guest mask for the pmu
>>> + *
>>> + * Check if guest counters will interfere with current host events and
>>> + * call into perf_pmu_resched_update if a reschedule is required.
>>> + */
>>> +static void kvm_pmu_set_guest_counters(struct arm_pmu *cpu_pmu, u64 
>>> guest_mask)
>>> +{
>>> +    struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
>>> +    DECLARE_BITMAP(guest_bitmap, ARMPMU_MAX_HWEVENTS);
>>> +    DECLARE_BITMAP(new_mask, ARMPMU_MAX_HWEVENTS);
>>> +    bool need_resched = false;
>>> +
>>> +    bitmap_from_arr64(guest_bitmap, &guest_mask, ARMPMU_MAX_HWEVENTS);
>>> +    bitmap_copy(new_mask, cpu_pmu->hw_cntr_mask, ARMPMU_MAX_HWEVENTS);
>>> +
>>> +    if (guest_mask) {
>>> +        /* Subtract guest counters from available host mask */
>>> +        bitmap_andnot(new_mask, new_mask, guest_bitmap, 
>>> ARMPMU_MAX_HWEVENTS);
>>> +
>>> +        /* Did we collide with an active host event? */
>>> +        if (bitmap_intersects(cpuc->used_mask, guest_bitmap, 
>>> ARMPMU_MAX_HWEVENTS)) {
>>> +            int idx;
>>> +
>>> +            need_resched = true;
>>> +            cpuc->host_squeezed = true;
>>> +
>>> +            /* Look for pinned events that are about to be preempted */
>>> +            for_each_set_bit(idx, guest_bitmap, ARMPMU_MAX_HWEVENTS) {
>>> +                if (test_bit(idx, cpuc->used_mask) && cpuc- 
>>> >events[idx] &&
>>> +                    cpuc->events[idx]->attr.pinned) {
>>> +                    pr_warn_ratelimited("perf: Pinned host event 
>>> squeezed out by KVM guest PMU partition\n");
> 
>> Hi Colton,
> 
>> I get "perf: Pinned host event squeezed out by KVM guest PMU partition"
>> even with arm_pmuv3.reserved_host_counters=3 for example. I would have
>> expected any non zero value to stop the warning.
> 
>> I think armv8pmu_get_single_idx() needs to be changed to allocate from
>> the high end host counters first. A more complicated option would be
>> checking to see if there are any non-pinned counters in the host
>> reserved half when a new pinned counter is opened, then swapping the
>> places of the new pinned and existing non-pinned counters so pinned
>> always prefer being put into the host half. But it's probably not worth
>> doing that.
> 
>> James
> 
> 
> I agree it makes the most sense to allocate from the top, but I'm happy
> the basic idea works.
> 

Another thing I forgot to mention is that even with the ratelimited 
warning, this spams the logs any time the host and guest are both using 
the PMU and I'm not sure how useful that is.

>>> +                    break;
>>> +                }
>>> +            }
>>> +        }
>>> +    } else {
>>> +        /*
>>> +         * Restoring to hw_cntr_mask.
>>> +         * Only resched if we previously squeezed an event.
>>> +         */
>>> +        if (cpuc->host_squeezed) {
>>> +            need_resched = true;
>>> +            cpuc->host_squeezed = false;
>>> +        }
>>> +    }
>>> +
>>> +    if (need_resched) {
>>> +        /* Collision: run full perf reschedule */
>>> +        perf_pmu_resched_update(&cpu_pmu->pmu, kvm_pmu_update_mask, 
>>> new_mask);
>>> +    } else {
>>> +        /* Host was never using guest counters anyway */
>>> +        bitmap_copy(cpu_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
>>> +    }
>>> +}
>>> +
>>>    /**
>>>     * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved 
>>> counters
>>>     * @pmu: Pointer to arm_pmu struct
>>> @@ -218,6 +285,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
> 
>>>        pmu = vcpu->kvm->arch.arm_pmu;
>>>        guest_counters = kvm_pmu_guest_counter_mask(pmu);
>>> +    kvm_pmu_set_guest_counters(pmu, guest_counters);
>>>        kvm_pmu_apply_event_filter(vcpu);
> 
>>>        for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
>>> @@ -319,5 +387,6 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
>>>        val = read_sysreg(pmintenset_el1);
>>>        __vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
> 
>>> +    kvm_pmu_set_guest_counters(pmu, 0);
>>>        preempt_enable();
>>>    }
>>> diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
>>> index f7b000bb3eca8..63f88fec5e80f 100644
>>> --- a/include/linux/perf/arm_pmu.h
>>> +++ b/include/linux/perf/arm_pmu.h
>>> @@ -75,6 +75,7 @@ struct pmu_hw_events {
> 
>>>        /* Active events requesting branch records */
>>>        unsigned int        branch_users;
>>> +    bool host_squeezed;
>>>    };
> 
>>>    enum armpmu_attr_groups {

