Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD7339937B
	for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 18:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778784214; cv=none; b=NStN2SAOLHRKlZopv7E4HVZ5SsSi1F5vwuyMhQiMW6gq9w85KJvHM+eveW1RVnxZIOFeDkXUQqeU7lLxY0Sn7Delb7ldO06wg85a/2hux1+HiB5EJcX+RgUx7lOiWBUsc0VaxExgoKGuXr/IQD57CHYErXi03j5wFeX2RktAPog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778784214; c=relaxed/simple;
	bh=dPbNCzf9KCRMLpqX405TL92VnoYbLgcOy7+YnXmORW0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=N8eIL6js/wIpY7Y/2PxUFaZqHDDT/yBZmBwoBd2esZZBEt7ItZirFJPPmhEoXBmiE0EaAvAHz75lgH3LZKu9fnIEXvTIGhTXN9zbvzEN+XhzoaLsB3zj+YtsJZKc/df1IDhZx365rv7p6dXo46gLu453sRnCq4gPmI9xq/3wv2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tu6gbtUJ; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tu6gbtUJ"
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-439d43ddfa9so3661763fac.1
        for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 11:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778784209; x=1779389009; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rKsaF96H0ao5LtAeB6Jowvi3N+dV7tElJWwhr8XO8PU=;
        b=Tu6gbtUJg+y0sSvsFii8gsN7ySvq+HLIdIQM/Vb9ZU3mkMpEmMTN2hNqAK4OgqUj+0
         mJTUqqa1jqNus9igk3Z+/ijBYp5YX8Zll1y1V25d/cuD5vhuiyDRT4gTgO30ct16QcqJ
         NioYsgxPyGDaDy0jxoXSHGSyoNWcj+pnQfT9n9UdwAtvVHfNtXWmk130Pa3ahCCJ7d6s
         3DHHzbRPfmmHFnrFAHAom5wtO+wmvcBaw3LKlL0CRyV5Yp2eRbjY+SqP90xc8lI86yU2
         pdmTcx0GPjz1v+FgHJUvZBrN4/PYccVug4zpQC7ZKWKerMvvuelSkUWtwKV1vrtI12zO
         hM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778784209; x=1779389009;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rKsaF96H0ao5LtAeB6Jowvi3N+dV7tElJWwhr8XO8PU=;
        b=R3dQ+4kgR/NgpI+G7jnzYqq/eSGKS7SaWiPmqjp9uFE1PLWPzTAOIkBBxcRZ8MEg8v
         rt2qZRbg0t44052aQ5MuYMtmXQu5AbRkgd87I18Upn6ODlDp9DpGl1p0KUH23cEG1DRP
         xQk1x1hKcKfYcG2/VWkF5TvW4ZENO50Mvma1zyUMYK7/ie1wsdzSUj4F1FvIQVV9rfjG
         VEglfmGlEKrbMZtTf6eZ15mUXVkTVnoOHcINujFHQjxChADyTRrjl58CgwmhQnxkZAKX
         LkEb3d9+wrhPTEKfC1Gf8llaKsT6Ym+yH5DVCWVM2viSpnw0/nCe774at+v+S/by9oeu
         K9Wg==
X-Forwarded-Encrypted: i=1; AFNElJ+kSERy8OOFkqtlmZb5Yy2XBkeCjByiP2aBFLlg5M2JSGKeqx8DiYcbdB+2wsfZRfy/Fle2b0w=@lists.linux.dev
X-Gm-Message-State: AOJu0YzydyvS/MAqEqysNuo378ZYMFJsLe0mhPM9a5vwTR0f4Np9SDBL
	kEygXrf24VEXiNTk8gdw2hNDD/SHn5KIbnW0R7Pv6dG5dQDSoYDZyupSSVw8O23TWdtPNt55Eqg
	hKQY5vrJo3K19lgmo+5mbjAzJjw==
X-Received: from ioym2.prod.google.com ([2002:a05:6602:3142:b0:964:6792:360])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1795:b0:694:9a67:edf6 with SMTP id 006d021491bc7-69c942ffd04mr447091eaf.17.1778784209181;
 Thu, 14 May 2026 11:43:29 -0700 (PDT)
Date: Thu, 14 May 2026 18:43:28 +0000
In-Reply-To: <agQu9kLnbHjSni-C@kernel.org> (message from Oliver Upton on Wed,
 13 May 2026 00:57:42 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntqzndbzn3.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v7 09/20] KVM: arm64: Set up MDCR_EL2 to handle a
 Partitioned PMU
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

> On Mon, May 04, 2026 at 09:18:02PM +0000, Colton Lewis wrote:
>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>> index 3ad6b7c6e4ba7..0ab89c91e19cb 100644
>> --- a/arch/arm64/kvm/debug.c
>> +++ b/arch/arm64/kvm/debug.c
>> @@ -36,20 +36,43 @@ static int cpu_has_spe(u64 dfr0)
>>    */
>>   static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>>   {
>> +	int hpmn = kvm_pmu_hpmn(vcpu);
>> +
>>   	preempt_disable();

>>   	/*
>>   	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
>>   	 * to disable guest access to the profiling and trace buffers
>>   	 */
>> -	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
>> -					 *host_data_ptr(nr_event_counters));
>> +
>> +	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, hpmn);
>>   	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
>>   				MDCR_EL2_TPMS |
>>   				MDCR_EL2_TTRF |
>>   				MDCR_EL2_TPMCR |
>>   				MDCR_EL2_TDRA |
>> -				MDCR_EL2_TDOSA);
>> +				MDCR_EL2_TDOSA |
>> +				MDCR_EL2_HPME);
>> +
>> +	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
>> +		/*
>> +		 * Filtering these should be redundant because we trap
>> +		 * all the TYPER and FILTR registers anyway and ensure
>> +		 * they filter EL2, but set the bits if they are here.
>> +		 */
>> +		if (is_pmuv3p1(read_pmuver()))
>> +			vcpu->arch.mdcr_el2 |= MDCR_EL2_HPMD;
>> +		if (is_pmuv3p5(read_pmuver()))
>> +			vcpu->arch.mdcr_el2 |= MDCR_EL2_HCCD;

> Neither of these controls are of any consequence on unsupported
> hardware (RES0). Set them unconditionally?

Sure.

>> +		/*
>> +		 * Take out the coarse grain traps if we are using
>> +		 * fine grain traps.
>> +		 */
>> +		if (kvm_vcpu_pmu_use_fgt(vcpu))

> I think open coding the check here would actually improve readability.

> 		if (cpus_have_final_cap(ARM64_HAS_FGT) &&
> 		    (cpus_have_final_cap(ARM64_HAS_HPMN0) ||
> 		     vcpu->kvm->arch.nr_pmu_counters != 0))
> 			vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR);

I disagree but I'll do it.

>> +
>> +/**
>> + * kvm_pmu_hpmn() - Calculate HPMN field value
>> + * @vcpu: Pointer to struct kvm_vcpu
>> + *
>> + * Calculate the appropriate value to set for MDCR_EL2.HPMN. If
>> + * partitioned, this is the number of counters set for the guest if
>> + * supported, falling back to max_guest_counters if needed. If we are  
>> not
>> + * partitioned or can't set the implied HPMN value, fall back to the
>> + * host value.
>> + *
>> + * Return: A valid HPMN value
>> + */
>> +u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
>> +{
>> +	u8 nr_guest_cntr = vcpu->kvm->arch.nr_pmu_counters;
>> +
>> +	if (kvm_vcpu_pmu_is_partitioned(vcpu)
>> +	    && !vcpu_on_unsupported_cpu(vcpu)
>> +	    && (cpus_have_final_cap(ARM64_HAS_HPMN0) || nr_guest_cntr > 0))
>> +		return nr_guest_cntr;
>> +
>> +	return *host_data_ptr(nr_event_counters);
>> +}

> This helper isn't helpful. Just open code it in the place where we are
> computing MDCR_EL2.

I disagree but I'll do it.

>> @@ -542,6 +542,13 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
>>   	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
>>   		return 1;

>> +	/*
>> +	 * If partitioned then we are limited by the max counters in
>> +	 * the guest partition.
>> +	 */
>> +	if (kvm_pmu_is_partitioned(arm_pmu))
>> +		return arm_pmu->max_guest_counters;
>> +

> Ok, this is exactly what I was getting at earlier. What about a VM with
> an emulated PMU? It should use cntr_mask calculation, not the guest
> range.

True. I should use something different here.


> Thanks,
> Oliver
