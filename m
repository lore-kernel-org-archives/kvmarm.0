Received: from mail-yx1-f73.google.com (mail-yx1-f73.google.com [74.125.224.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474ED3A7F6E
	for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778785148; cv=none; b=ORdprKFUCvx3GvYZe5MO/G6YWbkr1/OXYFDDNOKI2+jqa6hpPy29ioiMnf1TWgM4eWQDIhJYSIOwuTVk8lBUHsRvj4AQQT4Ty5J7Pka2apbj/k43631JMNKnCGWJz70vCSuW40DVyiv/kWIk85z+jVyi2USTqpGKoQd1aajekFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778785148; c=relaxed/simple;
	bh=gWP1ILhyScXHyRSOIDBKSyeHHxNav78NvuyAhfFN1Eg=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=sFYYTq3d9WaJflDNf4C0SPT3nfMNJJzaXy6gySfVaazwnqKXdcMHb5dWq6+rwN23mBCNa6Dw430aGzERw7c7reLMGn1EFIxp49PxFo4G98MmHlWPAvWoFI7YtB2Pw76wGeL/n1xIRgd7Ht+U229v16MiuAwVn/njSif3LO0knm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FBENJ1zJ; arc=none smtp.client-ip=74.125.224.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FBENJ1zJ"
Received: by mail-yx1-f73.google.com with SMTP id 956f58d0204a3-65db7715a7fso13316480d50.0
        for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 11:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778785146; x=1779389946; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ODwOeawQeH9yG3JQIK6jfQJAoFNmQmpkBT15tfR0sa0=;
        b=FBENJ1zJciSmSY+/vi0ZJqJu65qh1CF6xBaHa5R25jwWQUrMo8jqrTK+gGZ7Gxr/JS
         quRq3VwM0KyFbl3bFFueoAhkZ4JdR2rqt3G33CeRUeZ0UOdCMOA+trO8XF7UVa/dHIbq
         PsFLDOt2gA2YyIsrAXHo/Br0X2qJe7cgxCWxlQq67uqo+q7s+OhsaSl6M/rm25nQRLBG
         7Gdqm3Ko1QSMYfxEs5kRaVVvuKW2LAkS0buVbKe85QUhyNnpvHznSE02vVZC9fGYH4ph
         lnm6fhNdgjlGKZF+rdTXQZ142Vukky6H9IpumwivVhWkidBvKP5io2H64nQtJm5BmG5w
         BMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778785146; x=1779389946;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ODwOeawQeH9yG3JQIK6jfQJAoFNmQmpkBT15tfR0sa0=;
        b=TIc8Gmm2Ll+qAlYZQAMuxZUjtoNLtemrAlK3WcPxydMzv5aQX2/7t0nfne3wBOD1k+
         f53XRIFAYSXGhG+RcFGkfMGrrnDo2wvmTC6fP6J7BmF7mKnOnTZ9dSE9WmR6+USrJSjs
         MQmxGsYtdiaDrcsaUvzTjH7VIqNGF9XRqD3sGP4mRuhJp5c/XPRa5W6fTHsgQ55nQACT
         IyRGTLKMAhVhfqsv50okR4kAR61MuSsbtfsmAmXXkaJh72SUXgu8zCtDTRCZEuNdrLo7
         wOY1nYPoWIUsib5XCEkMnpmUSSFyYBB2y+roR65rShyUpcgZ6PXxk6Z4UWuurKsAYAKs
         z/jA==
X-Forwarded-Encrypted: i=1; AFNElJ+KASaSt42GguryeGHgIuiG6d1/hHMmc3r5GyJFNFjkpzPLFw71VQFQNMzj6dS9gJqaamAKzeg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXTFx21CvkuwAgKq3o2dNEgnb0PZoLwdin8dF5Sy7f252lVUt6
	Gd7eMOGcAYxAI5T7PEahucLyKvmSxhwf3qa3nOB4T7talJd47IOHnahn4H9cwD9gGlqkLek/2TV
	/27nWvO6etdfygIpgQXF8VNIzcg==
X-Received: from yxxr14.prod.google.com ([2002:a53:aece:0:b0:651:c562:b43b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:690e:191d:b0:651:b7e2:6835 with SMTP id 956f58d0204a3-65e227be0e1mr578484d50.35.1778785145996;
 Thu, 14 May 2026 11:59:05 -0700 (PDT)
Date: Thu, 14 May 2026 18:59:05 +0000
In-Reply-To: <agRBzkVcR-qZZdx2@kernel.org> (message from Oliver Upton on Wed,
 13 May 2026 02:18:06 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnto6ihbyx2.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v7 10/20] KVM: arm64: Context swap Partitioned PMU guest registers
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
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

Oliver Upton <oupton@kernel.org> writes:

> On Mon, May 04, 2026 at 09:18:03PM +0000, Colton Lewis wrote:
>> +
>> +/**
>> + * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved  
>> counters
>> + * @pmu: Pointer to arm_pmu struct
>> + *
>> + * Compute the bitmask that selects the host-reserved counters in the
>> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
>> + * in HPMN..N
>> + *
>> + * Return: Bitmask
>> + */
>> +u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
>> +{
>> +	u8 nr_counters = *host_data_ptr(nr_event_counters);
>> +
>> +	if (kvm_pmu_is_partitioned(pmu))
>> +		return GENMASK(nr_counters - 1, pmu->max_guest_counters);
>> +
>> +	return ARMV8_PMU_CNT_MASK_ALL;
>> +}
>> +
>> +/**
>> + * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved  
>> counters
>> + * @pmu: Pointer to arm_pmu struct
>> + *
>> + * Compute the bitmask that selects the guest-reserved counters in the
>> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
>> + * in 0..HPMN and the cycle and instruction counters.
>> + *
>> + * Return: Bitmask
>> + */
>> +u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
>> +{
>> +	if (kvm_pmu_is_partitioned(pmu))
>> +		return ARMV8_PMU_CNT_MASK_C | GENMASK(pmu->max_guest_counters - 1, 0);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * kvm_pmu_load() - Load untrapped PMU registers
>> + * @vcpu: Pointer to struct kvm_vcpu
>> + *
>> + * Load all untrapped PMU registers from the VCPU into the PCPU. Mask
>> + * to only bits belonging to guest-reserved counters and leave
>> + * host-reserved counters alone in bitmask registers.
>> + */
>> +void kvm_pmu_load(struct kvm_vcpu *vcpu)
>> +{
>> +	struct arm_pmu *pmu;
>> +	unsigned long guest_counters;
>> +	u64 mask;
>> +	u8 i;
>> +	u64 val;
>> +
>> +	/*
>> +	 * If we aren't guest-owned then we know the guest isn't using
>> +	 * the PMU anyway, so no need to bother with the swap.
>> +	 */
>> +	if (!kvm_vcpu_pmu_is_partitioned(vcpu))
>> +		return;
>> +
>> +	preempt_disable();
>> +
>> +	pmu = vcpu->kvm->arch.arm_pmu;
>> +	guest_counters = kvm_pmu_guest_counter_mask(pmu);
>> +
>> +	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
>> +		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
>> +
>> +		if (i == ARMV8_PMU_CYCLE_IDX) {
>> +			write_sysreg(val, pmccntr_el0);
>> +		} else {
>> +			write_sysreg(i, pmselr_el0);
>> +			write_sysreg(val, pmxevcntr_el0);

> This is wrong, you would need an intervening ISB. It'd be better to
> avoid the ISB altogether and just use {read,write}_pmevcntrn().

Good catch, I was using {read,write}_pmevcntrn here before but changed
it after your feedback that:

> I'd prefer KVM directly accessed the PMU registers to
> avoid the possibility of taking some instrumented codepath in the
> future.

https://lore.kernel.org/kvm/aUH7oC41XaEMsXf_@kernel.org/

I assume this is a compromise with that.
