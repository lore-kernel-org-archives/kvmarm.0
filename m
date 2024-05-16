Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9762614D6F9
	for <kvmarm@lists.linux.dev>; Thu, 16 May 2024 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715875381; cv=none; b=f4aPH77i8IUkKLKJbcbJcl4KnX7Nq2lGr/p2UOMz9qE9xmQVW+fCR7ubvDJ6W24dhHHHJcv1H2kN8AsRKyHcd1X0fF5Mw5Vuck/Zr98z2seMAdU/fxZBgeYhoiPHQ4guOpc7zcNuMVcehXLYsuYUWqj4mrEOMTAX3AqIWYqF07Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715875381; c=relaxed/simple;
	bh=Qvn+eDPV3KjfuRiCHUcxOODBkfjgRSK4kviR/a5h1b0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Usfjt/2fEokzrp1KDD1LoEVJcoZluIKU4xZDP342OCquNFBBW+uvu1YLbqhlG/4xRytlQSi/Y2XAWCpm/nmZntyzxOwwtYoIkEAVlGa67Da9hJLWUkGsQZqxBeNmOnV4TYHybPbOhgVCl20JVWG+VZehgOpqdfJSDGEGT4/uL9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Luf3UY6d; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Luf3UY6d"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dee902341c0so6824072276.3
        for <kvmarm@lists.linux.dev>; Thu, 16 May 2024 09:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715875378; x=1716480178; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7HpIXuT6tOszn6Sdim+VjymIhcvyFpypZfRE8OZjGxU=;
        b=Luf3UY6d6EdZvbsUK4iVusgxTZDMqxGeWq/YRSvGohCmTUP0lSoboS5bge9kcQC6X+
         6V+Y3LwM7IMsULtz2Cr9S7q+zvqyh6vQViVRUIUXcD3CthgA+aQdv00jIftLCLr5lF0l
         w4Spoan0c3llGYI7X2TBuKezvIRTcM0zIYXjGcRJYehGW0/5dMuWlBfDnOyiZuPrvNJL
         q2tLIeZug4xaVI8cHkjB7YB1wtzBklB8FaTL478zcCI/JdjPTnAFaqKh6PissdfL9lsg
         UahzzfA4yVqiOFiA8ZST5ivFBUB0cef2qeNnmQXT5kw6yfkCxpHeq4p+B/tfYiAYlOsT
         C06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715875378; x=1716480178;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7HpIXuT6tOszn6Sdim+VjymIhcvyFpypZfRE8OZjGxU=;
        b=c90p0cpxPVbUcdSoJ5Rf7KNL6Gmk0I/6/gNVSAdeRJeUPZSCxfn1INa8JtnkBAKBoP
         3Mh6EIksvMx1a5/VpiByUsjNVYkm5IL0Ru7BY/Awb1Pwd5nvyKJq4QVebq6LAQHsNL8W
         l6m641sJHgBrndy3/AKYHzExr+/H+j7MpbD/PL1x2FU5UoWTnZOd1djUJ19+K8SaZf/L
         TufDVXkFbxOvd0dY/iRY1TAKgLzX+SvVMbiORfGABLd0svz1uER4ZTr+QXGpkZktj+1U
         X0WsSy4rqOzRqePPwW+kA8Wz3pd/zKO7BuUyJgLOG/3A5F5vwvL8ZIryc1AYUAIFDxbb
         ZtFw==
X-Forwarded-Encrypted: i=1; AJvYcCVlzjL87h50TNuA7tlaz07wJerNK017y02swTtU59p7KU/Qp0umwCBh63dB14qlVlP1mIFJ4wSUF2WQikvoh9+bgqKDTJzd
X-Gm-Message-State: AOJu0YyzMT8ygLqMUBPlITQE7IRTXsO8aQCZU5ylhdHFszkl3F10MfqZ
	UjSs+WLA398eO3ubfGa4HjVb4ZRHF7vtT9o4iHsLra9GyOlVlT8kosmUeFNbe1ur90zqUdSWcBx
	5plH8w6IJ3/Y52UDdvfgwqg==
X-Google-Smtp-Source: AGHT+IF/VTizL3uRcaPz4FUA6Qw+im1lfzOrpyEK3SLZlU2Rx96wjJQrdDCUaoRmdREzsaN+wgsjcIqTNDS1LM0OIQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1201:b0:dee:6f9d:b753 with
 SMTP id 3f1490d57ef6-dee6f9dbdeamr1196625276.6.1715875378456; Thu, 16 May
 2024 09:02:58 -0700 (PDT)
Date: Thu, 16 May 2024 16:02:57 +0000
In-Reply-To: <861q69oi9c.wl-maz@kernel.org> (message from Marc Zyngier on Fri,
 10 May 2024 15:26:23 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntbk55agni.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5] KVM: arm64: Add early_param to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, corbet@lwn.net, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Marc. Thanks for the review.

Marc Zyngier <maz@kernel.org> writes:

> On Tue, 30 Apr 2024 19:14:44 +0100,
> Colton Lewis <coltonlewis@google.com> wrote:
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt  
>> b/Documentation/admin-guide/kernel-parameters.txt
>> index 31b3a25680d0..a4d94d9abbe4 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -2653,6 +2653,22 @@
>>   			[KVM,ARM] Allow use of GICv4 for direct injection of
>>   			LPIs.

>> +	kvm-arm.wfe_trap_policy=
>> +			[KVM,ARM] Control when to set WFE instruction trap for
>> +			KVM VMs.
>> +
>> +			trap: set WFE instruction trap
>> +
>> +			notrap: clear WFE instruction trap
>> +
>> +	kvm-arm.wfi_trap_policy=
>> +			[KVM,ARM] Control when to set WFI instruction trap for
>> +			KVM VMs.
>> +
>> +			trap: set WFI instruction trap
>> +
>> +			notrap: clear WFI instruction trap
>> +

> Please make it clear that neither traps are guaranteed. The
> architecture *allows* an implementation to trap when no events (resp.
> interrupts) are pending, but nothing more. An implementation is
> perfectly allowed to ignore these bits.

Will do. I'll just add an additional sentence stating "Traps are allowed
but not guaranteed by the CPU architecture"

>> diff --git a/arch/arm64/include/asm/kvm_host.h  
>> b/arch/arm64/include/asm/kvm_host.h
>> index 21c57b812569..315ee7bfc1cb 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -67,6 +67,13 @@ enum kvm_mode {
>>   	KVM_MODE_NV,
>>   	KVM_MODE_NONE,
>>   };
>> +
>> +enum kvm_wfx_trap_policy {
>> +	KVM_WFX_NOTRAP_SINGLE_TASK, /* Default option */
>> +	KVM_WFX_NOTRAP,
>> +	KVM_WFX_TRAP,
>> +};

> Since this is only ever used in arm.c, it really doesn't need to be
> exposed anywhere else.

I can move it to there.

>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index a25265aca432..5ec52333e042 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -46,6 +46,8 @@
>>   #include <kvm/arm_psci.h>

>>   static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
>> +static enum kvm_wfx_trap_policy kvm_wfi_trap_policy =  
>> KVM_WFX_NOTRAP_SINGLE_TASK;
>> +static enum kvm_wfx_trap_policy kvm_wfe_trap_policy =  
>> KVM_WFX_NOTRAP_SINGLE_TASK;

> It would be worth declaring those as __read_mostly.

Will do.

>> +static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
>> +{
>> +	if (likely(kvm_wfi_trap_policy == KVM_WFX_NOTRAP_SINGLE_TASK))
>> +		return single_task_running() &&
>> +			(atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
>> +			 vcpu->kvm->arch.vgic.nassgireq);

> So you are evaluating a runtime condition (scheduler queue length,
> number of LPIs)...

Yes. Only in the case of default behavior when no option is given, which
should be equivalent to what the code was doing before.

>> +
>> +	return kvm_wfi_trap_policy == KVM_WFX_NOTRAP;
>> +}
>> +
>> +static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
>> +{
>> +	if (likely(kvm_wfe_trap_policy == KVM_WFX_NOTRAP_SINGLE_TASK))
>> +		return single_task_running();
>> +
>> +	return kvm_wfe_trap_policy == KVM_WFX_NOTRAP;
>> +}
>> +
>> +static inline void kvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)

> Why the inline?

Because I moved it from the kvm_emulate.h header with no
modification. It doesn't have to be.

>> +{
>> +	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
>> +	if (has_vhe() || has_hvhe())
>> +		vcpu->arch.hcr_el2 |= HCR_E2H;
>> +	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
>> +		/* route synchronous external abort exceptions to EL2 */
>> +		vcpu->arch.hcr_el2 |= HCR_TEA;
>> +		/* trap error record accesses */
>> +		vcpu->arch.hcr_el2 |= HCR_TERR;
>> +	}
>> +
>> +	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
>> +		vcpu->arch.hcr_el2 |= HCR_FWB;
>> +	} else {
>> +		/*
>> +		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
>> +		 * get set in SCTLR_EL1 such that we can detect when the guest
>> +		 * MMU gets turned on and do the necessary cache maintenance
>> +		 * then.
>> +		 */
>> +		vcpu->arch.hcr_el2 |= HCR_TVM;
>> +	}
>> +
>> +	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
>> +	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
>> +		vcpu->arch.hcr_el2 |= HCR_TID4;
>> +	else
>> +		vcpu->arch.hcr_el2 |= HCR_TID2;
>> +
>> +	if (vcpu_el1_is_32bit(vcpu))
>> +		vcpu->arch.hcr_el2 &= ~HCR_RW;
>> +
>> +	if (kvm_has_mte(vcpu->kvm))
>> +		vcpu->arch.hcr_el2 |= HCR_ATA;
>> +
>> +
>> +	if (kvm_vcpu_should_clear_twe(vcpu))
>> +		vcpu->arch.hcr_el2 &= ~HCR_TWE;
>> +	else
>> +		vcpu->arch.hcr_el2 |= HCR_TWE;
>> +
>> +	if (kvm_vcpu_should_clear_twi(vcpu))
>> +		vcpu->arch.hcr_el2 &= ~HCR_TWI;
>> +	else
>> +		vcpu->arch.hcr_el2 |= HCR_TWI;

> ... and from the above runtime conditions you make it a forever
> decision, for a vcpu that still hasn't executed a single instruction.
> What could possibly go wrong?

Oh I see. kvm_arch_vcpu_ioctl_vcpu_init only executes once when the vcpu
is created (makes sense given the name), thereby making the decision
permanent for the life of the vcpu. I misunderstood that fact before.

I will move the decision back to when the vcpu is loaded as it was in
earlier versions of this series.

>> +static int __init early_kvm_wfx_trap_policy_cfg(char *arg, enum  
>> kvm_wfx_trap_policy *p)
>> +{
>> +	if (!arg)
>> +		return -EINVAL;
>> +
>> +	if (strcmp(arg, "trap") == 0) {
>> +		*p = KVM_WFX_TRAP;
>> +		return 0;
>> +	}
>> +
>> +	if (strcmp(arg, "notrap") == 0) {
>> +		*p = KVM_WFX_NOTRAP;
>> +		return 0;
>> +	}
>> +
>> +	if (strcmp(arg, "default") == 0) {
>> +		*p = KVM_WFX_NOTRAP_SINGLE_TASK;
>> +		return 0;
>> +	}

> Where is this "default" coming from? It's not documented.

It was explicitly documented on earlier patch versions, but then I was
told we didn't want people to rely on the default behavior so we have
flexibility to change it in the future.

There isn't much use for it if it isn't documented, so I'll take it out.
