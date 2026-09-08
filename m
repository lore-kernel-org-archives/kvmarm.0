Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43282598C01;
	Tue,  8 Sep 2026 18:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893912; cv=none; b=Guh84iw0yEaVbFRrHtVEoCI7rKy+n0/2HMEVe+2FNwTqJIUXdxTbb9gkS1jZN8mO6kyqow/5FIU687r3wufwer+Ugf89kqAHSTsDlpM6BpC3hR1t4fS+niBQ0Y47m3K9JW39sB/iMjp2E2TcfTVHO/dCTwhJIMOs51fsCTC/aCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893912; c=relaxed/simple;
	bh=y2y7T3KAoKP/KyE/uDm2tpyR/IuJRDUtV20f/glc+I0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YLisqI6Nh03CvqL+4htDpWS+tNAxBrZgq4PYBFOojCBcyixlH4cF4+AHkXiRpppomYear+W1guMcEzqvpbuZ7HMAYgHWL9iJtUIiO1NmEANOrywle5u+dvNnp61Le9RZATvmWtIn6lC8E1Vq5nWfyfHkuOPpuEgxEQCN3RRYnPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ju0/yovn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ju0/yovn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BEF7F1476;
	Tue,  8 Sep 2026 11:58:24 -0700 (PDT)
Received: from [10.57.49.201] (unknown [10.57.49.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B10353F528;
	Tue,  8 Sep 2026 11:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788893908; bh=y2y7T3KAoKP/KyE/uDm2tpyR/IuJRDUtV20f/glc+I0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ju0/yovnlJCOYeq4SXLgmLOwzg4nf4S7aWebIHFJWp8+ngmDbqkoNtSAqLuIwicnS
	 E1/g/tstnhlTxhCYpqRnrNtsH6gPbcc+Mag4k6LM7wP5waZrl7rBnB0G2Vc0i/1P46
	 AhVfQceVon7sB2t75xRqT9oUlVPpI0NQTc5LxtbU=
Message-ID: <f523ceb8-faa7-412d-9227-aca139e2bc1e@arm.com>
Date: Tue, 8 Sep 2026 19:58:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 12/20] KVM: arm64: CCA: Support timers in realm RECs
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-13-suzuki.poulose@arm.com>
 <20260908165643.50C501F00A3A@smtp.kernel.org>
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260908165643.50C501F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/09/2026 17:56, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Realm VM timers are blackholed on GICv5 hosts due to unconditional physical interrupt masking combined with disabled direct injection.
> --
> 
> commit 759ada4556cf9518a1b30ec3610b7b7833129bd9
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Support timers in realm RECs
> 
> This commit adds support for handling timers when exiting a realm REC to the
> normal world. It implements realm_timer_irq_ops which relies on the existing
> software resampling mechanism for Realm timer interrupts.
> 
>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> index eba84cab95d01..3eddf44f7b1dd 100644
>> --- a/arch/arm64/kvm/arch_timer.c
>> +++ b/arch/arm64/kvm/arch_timer.c
> [ ... ]
>> @@ -1609,8 +1623,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>>   
>>   	get_timer_map(vcpu, &map);
>>   
>> -	ops = vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
>> -				      &arch_timer_irq_ops;
>> +	if (vcpu_is_rec(vcpu))
>> +		ops = &realm_timer_irq_ops;
>> +	else if (vgic_is_v5(vcpu->kvm))
>> +		ops = &arch_timer_irq_ops_vgic_v5;
>> +	else
>> +		ops = &arch_timer_irq_ops;
>>   
>>   	for (int i = 0; i < nr_timers(vcpu); i++)
>>   		kvm_vgic_set_irq_ops(vcpu, timer_irq(vcpu_get_timer(vcpu, i)), ops);
> 
> [Severity: High]
> Will this cause Realm VM timers to be lost on a GICv5 host?
> 
> When a Realm VM is created on a GICv5 host, vcpu_is_rec(vcpu) takes precedence,
> assigning realm_timer_irq_ops. However, this struct lacks the
> .set_direct_injection callback used for hardware direct injection.
> 
> At the same time, because vgic_is_v5(vcpu->kvm) is still true for the host,
> other timer paths will unconditionally assume direct injection is active. For
> example, kvm_timer_update_irq() skips software injection:
> 
> kvm_timer_update_irq() {
>          ...
>          /* Skip injecting on GICv5 for directly injected (DVI'd) timers */
>          if (vgic_is_v5(vcpu->kvm)) {
>                  ...
>                  if (map.direct_ptimer == timer_ctx ||
>                      map.direct_vtimer == timer_ctx)
>                          return;
>          }
> }
> 
> Additionally, kvm_timer_vcpu_load_gic() unconditionally masks the physical
> timer interrupt for GICv5 setups:
> 
> kvm_timer_vcpu_load_gic() {
>          ...
>          phys_active |= pending;
>          phys_active |= vgic_is_v5(vcpu->kvm);
> 
>          set_timer_irq_phys_active(ctx, phys_active);
> }
> 
> Since hardware injection is not configured by the Realm ops and software
> injection is bypassed due to the GICv5 checks, does this completely blackhole
> timer interrupts for Realm VMs on GICv5 hardware?
> 

CCA doesn't support VGIC_V5. We only support VGIC_V3. I have added the 
following patch to make sure this is mandated:



---8>---

KVM: arm64: CCA: Mandate VGIC_V3 for Realms

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

diff --git a/arch/arm64/kvm/vgic/vgic-init.c 
b/arch/arm64/kvm/vgic/vgic-init.c
index 4012df6002ea6..452c085073f3e 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -84,6 +84,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
                 !kvm_vgic_global_state.can_emulate_gicv2)
                 return -ENODEV;

+       /* Realms only support VGIC_V3 */
+       if (kvm_vm_is_realm(kvm) && type != KVM_DEV_TYPE_ARM_VGIC_V3)
+               return -ENODEV;
         /*
          * Ensure mutual exclusion with vCPU creation and any vCPU 
ioctls by:

Suzuki


