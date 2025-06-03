Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845FF223321
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 21:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748986365; cv=none; b=gxYByMkLzycGGTI96otcxjHfsTYTk35REqu8hoiLwPNicKkhFnhZZ7VDKDD+y2nzZVCCQ+vw2xHuT0topKNtrHDikYPEKsg6946RRkRzk2yyQ2S+v2Pc/LCDW0aoXEpdXq2xWZDJhPr9kj9/h2ZF2j/TyKDR0RNZGBVjm+WSxZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748986365; c=relaxed/simple;
	bh=mRmmFnlPCP5qmGp8cqulc+n4NmAySDPtVlsv8iPw48Q=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=p8K2RUNSOOoew+sVLDJBqP2Nkj2xxdfpC06SCB+S2Qnq3/cVIlsry61O+xlwzIOeX52QCKVNXiHezlpKcJSlqdLqB6RYA9dPguSPa4rUghFvohn2boqa0pPtGdYRF2YveOepuZ1WewidMJCfPcOMVJ/FllxEmOYqxwRcD8RJ5X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AzaUGICJ; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AzaUGICJ"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3dca2d01b84so122031605ab.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Jun 2025 14:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748986362; x=1749591162; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A0l5G93fC29AgVAtcdaJmVpgHO/IQHFXQv4WdPYaaHE=;
        b=AzaUGICJs1aR94O1C+EY+dLY4EF4Hqmp4DkLCHeSCPNyL3Bth3kYg3vykUJPwZGvxi
         I7TV9i3Ft9gbpgYKHvBt1llGEZmsBJhif0LGtQyvvdc32FAXG8+5E28Uom0fOe1E22QJ
         XKENyirKIJ2c/S6TxwQdiKjhqAq6WDiV34AjE/1HM5PdfEGyWGborrX8JTAdwcVd7IIB
         In+BGi8Y0ImXBxRnlGhLWTxtCsXP1uqIWrQ0kEeVjVucg4jElWzZPdP/qks3CsLPscKH
         mXiLBxLO8bGRro5Ut7UQxxpF4vGmx+Bt5lYLkE3ez87U99BXCfSOC45M6s96QtU2xN7n
         cTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748986362; x=1749591162;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A0l5G93fC29AgVAtcdaJmVpgHO/IQHFXQv4WdPYaaHE=;
        b=wCz8uHQpC574xt8jNtJ/MDnDq3y+VlTvrk8ntM9yqRsISvGY7n4Q5UjrY3JmsfOBKH
         pTP1XPfR1QbU0BdlT8U+4uehBYifn9tsmcqrbjD3u7tbqlwgFLZtvRr5MTa/jS2KZFXH
         P1/H23SMvZQcQJ9h/GgId+G6veBL9vBrFwk0OgWFxd2yhjjFEX85+f3UBdUpIchwSQiJ
         9BjB5bxpTqIKUw5dZH+ByXVWKqKGz6tdvywrqB0vmcDN+uTOPxwXIqkRJOdZS60UkRkN
         wPe7i/p1n2KnnvUMbLVw9j2YWxPyIy0WDShnfEJhaQZlWQFbWLyyCYsz+xn05WbB4wZW
         26/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0bmax7j2xRppE1bmtFRzUDYdUa6DYY2C6UTRh/Y+S2RxPmJbUvLMsIRBOtjfvO/lkcb1fGgM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw13ABfQVZ2ESUD4eaeAkx5MdC6sslw4pxiWzwQScNZpWgj3nme
	yTESkRDAtSW6mwmImls8VDAcywD2g9UyYxEAWlEMLXLRsO7/HRGl698iadQAeGQ3s/50hEADhBT
	N3xDXyQ1KIfz4Z4os5d8YLrazXg==
X-Google-Smtp-Source: AGHT+IEpZcrefEWDzzUjOLjOnRYEdIFZat5s3G0oLfOvn/O8rphYPOQ1GWMYf3Wj71ilVVre/pSRPvqRpgjiaR79Qg==
X-Received: from ilbbm14.prod.google.com ([2002:a05:6e02:330e:b0:3d9:2b64:6884])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a92:c241:0:b0:3dc:7a9a:44d5 with SMTP id e9e14a558f8ab-3ddbedc8c8fmr6231205ab.22.1748986362621;
 Tue, 03 Jun 2025 14:32:42 -0700 (PDT)
Date: Tue, 03 Jun 2025 21:32:41 +0000
In-Reply-To: <aD4llDZwb_sC_Ptj@linux.dev> (message from Oliver Upton on Mon, 2
 Jun 2025 15:28:36 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt4iww3406.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 06/17] KVM: arm64: Introduce method to partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Mon, Jun 02, 2025 at 07:26:51PM +0000, Colton Lewis wrote:
>>   static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>>   {
>> +	u8 hpmn = vcpu->kvm->arch.arm_pmu->hpmn;
>> +
>>   	preempt_disable();

>>   	/*
>>   	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
>>   	 * to disable guest access to the profiling and trace buffers
>>   	 */
>> -	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
>> -					 *host_data_ptr(nr_event_counters));
>> -	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
>> +	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, hpmn);
>> +	vcpu->arch.mdcr_el2 |= (MDCR_EL2_HPMD |
>> +				MDCR_EL2_TPM |

> This isn't safe, as there's no guarantee that kvm_arch::arm_pmu is
> pointing that the PMU for this CPU. KVM needs to derive HPMN from some
> per-CPU state, not anything tied to the VM/vCPU.

I'm confused. Isn't this function preparing to run the vCPU on this
CPU? Why would it be pointing at a different PMU?

And HPMN is something that we only want set when running a vCPU, so
there isn't any per-CPU state saying it should be anything but the
default value (number of counters) outside that context.

Unless you just mean I should check the number of counters again and
make sure HPMN is not an invalid value.

>> +/**
>> + * kvm_pmu_partition() - Partition the PMU
>> + * @pmu: Pointer to pmu being partitioned
>> + * @host_counters: Number of host counters to reserve
>> + *
>> + * Partition the given PMU by taking a number of host counters to
>> + * reserve and, if it is a valid reservation, recording the
>> + * corresponding HPMN value in the hpmn field of the PMU and clearing
>> + * the guest-reserved counters from the counter mask.
>> + *
>> + * Passing 0 for @host_counters has the effect of disabling  
>> partitioning.
>> + *
>> + * Return: 0 on success, -ERROR otherwise
>> + */
>> +int kvm_pmu_partition(struct arm_pmu *pmu, u8 host_counters)
>> +{
>> +	u8 nr_counters;
>> +	u8 hpmn;
>> +
>> +	if (!kvm_pmu_reservation_is_valid(host_counters))
>> +		return -EINVAL;
>> +
>> +	nr_counters = *host_data_ptr(nr_event_counters);
>> +	hpmn = kvm_pmu_hpmn(host_counters);
>> +
>> +	if (hpmn < nr_counters) {
>> +		pmu->hpmn = hpmn;
>> +		/* Inform host driver of available counters */
>> +		bitmap_clear(pmu->cntr_mask, 0, hpmn);
>> +		bitmap_set(pmu->cntr_mask, hpmn, nr_counters);
>> +		clear_bit(ARMV8_PMU_CYCLE_IDX, pmu->cntr_mask);
>> +		if (pmuv3_has_icntr())
>> +			clear_bit(ARMV8_PMU_INSTR_IDX, pmu->cntr_mask);
>> +
>> +		kvm_debug("Partitioned PMU with HPMN %u", hpmn);
>> +	} else {
>> +		pmu->hpmn = nr_counters;
>> +		bitmap_set(pmu->cntr_mask, 0, nr_counters);
>> +		set_bit(ARMV8_PMU_CYCLE_IDX, pmu->cntr_mask);
>> +		if (pmuv3_has_icntr())
>> +			set_bit(ARMV8_PMU_INSTR_IDX, pmu->cntr_mask);
>> +
>> +		kvm_debug("Unpartitioned PMU");
>> +	}
>> +
>> +	return 0;
>> +}

> Hmm... Just in terms of code organization I'm not sure I like having KVM
> twiddling with *host* support for PMUv3. Feels like the ARM PMU driver
> should own partitioning and KVM just takes what it can get.

Okay. I can move the code.

>> @@ -239,6 +245,13 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>>   	if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
>>   		return;

>> +	if (reserved_host_counters) {
>> +		if (kvm_pmu_partition_supported())
>> +			WARN_ON(kvm_pmu_partition(pmu, reserved_host_counters));
>> +		else
>> +			kvm_err("PMU Partition is not supported");
>> +	}
>> +

> Hasn't the ARM PMU been registered with perf at this point? Surely the
> driver wouldn't be very pleased with us ripping counters out from under
> its feet.

AFAICT nothing in perf registration cares about the number of counters
the PMU has. The PMUv3 driver tracks its own available counters through
cntr_mask and I modify that during partition.

Since this is still initialization of the PMU, I don't believe anything
has had a chance to use a counter yet that will be ripped away.

Aesthetically It makes since to change this if I move the partitioning
code to the PMUv3 driver, but I think it's inconsequential to the
function.
