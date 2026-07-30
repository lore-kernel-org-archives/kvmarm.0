Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9D944AB66;
	Thu, 30 Jul 2026 16:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428259; cv=none; b=FNS+uPEJWsUFaCc2sRJGyHmLvperE6ErL28acUiGes+cqhXCqR54RCeZKI9/Op+tW/AuGyuXK7JpiTlTHgobSnKSm5f4L0DRCYxOafTd5yW8nv832v7aocuFKUKvpY+Xha57oib2h1A+ePQIA6KZmNM1mRcYj3x1gpofMoTbNak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428259; c=relaxed/simple;
	bh=WNLUMqFMBH7pLGp1cRuwGPkP5cKPs481SYYLJ2vbEgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fGHna34aZgNzjK617HhIoRCwiAghukW8NGVCvqrd1ML1SGMyMb3moSsuUWbwT/0Om41XpckfEDNOMstVVBx6k5Zw83LzJD3VkyYuFWclNaxgTkubAl5AtYFjxegulGTvQTFdmZja9PsIwnvN4x/nuACMaXI8JQveXLSoB+cVqu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nRJa4BXq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nRJa4BXq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 241E5165C;
	Thu, 30 Jul 2026 09:17:32 -0700 (PDT)
Received: from [10.57.84.237] (unknown [10.57.84.237])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDFC33F66F;
	Thu, 30 Jul 2026 09:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785428256; bh=WNLUMqFMBH7pLGp1cRuwGPkP5cKPs481SYYLJ2vbEgE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nRJa4BXqmzgT19cH7GL9auQX6Znw59Y13hKnTEx2OGI++uy1Q590/z1+4nMyqkloW
	 rULfSgbT6Cz8j2N6LEAojty7A1P7LF3ecBo0GR0gLZhJK289mZlPK/bUr/8wg6iwMd
	 1zzpiBFIAWrYOzETcNV1OcPKLlfr+iCu5JdoX28Y=
Message-ID: <c23e02e9-1563-4baf-af1e-45d45a155bca@arm.com>
Date: Thu, 30 Jul 2026 17:17:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/37] KVM: arm64: CCA: Handle realm enter/exit
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
 <20260715142841.80544-15-steven.price@arm.com> <86zezccw8e.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86zezccw8e.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

Thanks for the detailed review, comments below.

On 27/07/2026 16:01, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 15:28:16 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> Entering a realm is done using a SMC call to the RMM. On exit the
>> exit-codes need to be handled slightly differently to the normal KVM
>> path so define our own functions for realm enter/exit and hook them
>> in if the guest is a realm guest.
> 
> What is so different that you need to reinvent the wheel?

Fair point - there's a bunch of differences, but CCA could definitely
fit in better.

>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> ---
>> Changes since v13:
>>  * The RMM is now required to provide an ESR value with the correct
>>    information to emulate MMIO, so we no longer need to hardcode 0s in
>>    rec_exit_sys_reg().
>>  * The PSCI changes mean that there is a potential race when turning on
>>    a VCPU which can cause a RMI_ERROR_REC return. Exit to user space
>>    with -EAGAIN in this case.
>> Changes since v12:
>>  * Call guest_state_{enter,exit}_irqoff() around rmi_rec_enter().
>>  * Add handling of the IRQ exception case where IRQs need to be briefly
>>    enabled before exiting guest timing.
>> Changes since v8:
>>  * Introduce kvm_rec_pre_enter() called before entering an atomic
>>    section to handle operations that might require memory allocation
>>    (specifically completing a RIPAS change introduced in a later patch).
>>  * Updates to align with upstream changes to hpfar_el2 which now (ab)uses
>>    HPFAR_EL2_NS as a valid flag.
>>  * Fix exit reason when racing with PSCI shutdown to return
>>    KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
>> Changes since v7:
>>  * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>>    been read (although that can never happen in the current code). Tidy
>>    up the condition to handle any future refactoring.
>> Changes since v6:
>>  * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>>    vcpu to the error.
>>  * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>>    this exit type.
>>  * Split code handling a RIPAS change triggered by the guest to the
>>    following patch.
>> Changes since v5:
>>  * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>>    change on next entry rather than immediately on the exit. This allows
>>    the VMM to 'reject' a RIPAS change by refusing to continue
>>    scheduling.
>> Changes since v4:
>>  * Rename handle_rme_exit() to handle_rec_exit()
>>  * Move the loop to copy registers into the REC enter structure from the
>>    to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>>    where the handler exits to user space and user space wants to modify
>>    the GPRS.
>>  * Some code rearrangement in rec_exit_ripas_change().
>> Changes since v2:
>>  * realm_set_ipa_state() now provides an output parameter for the
>>    top_iap that was changed. Use this to signal the VMM with the correct
>>    range that has been transitioned.
>>  * Adapt to previous patch changes.
>> ---
>>  arch/arm64/include/asm/kvm_rmi.h |   4 +
>>  arch/arm64/kvm/Makefile          |   2 +-
>>  arch/arm64/kvm/arm.c             |  25 ++++-
>>  arch/arm64/kvm/rmi-exit.c        | 182 +++++++++++++++++++++++++++++++
>>  arch/arm64/kvm/rmi.c             |  42 +++++++
>>  5 files changed, 249 insertions(+), 6 deletions(-)
>>  create mode 100644 arch/arm64/kvm/rmi-exit.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index ccd09d55c69f..b1e4cf0f6803 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -100,6 +100,10 @@ void kvm_destroy_realm(struct kvm *kvm);
>>  int kvm_realm_teardown_stage2(struct kvm *kvm);
>>  void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>  
>> +int kvm_rec_enter(struct kvm_vcpu *vcpu);
>> +int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>> +
>>  static inline bool kvm_realm_is_private_address(struct realm *realm,
>>  						unsigned long addr)
>>  {
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index ed3cf30eb06e..4a2d52fdb6a2 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
>>  kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>>  	 inject_fault.o va_layout.o handle_exit.o config.o \
>>  	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
>> -	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o \
>> +	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o rmi-exit.o \
>>  	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
>>  	 vgic/vgic.o vgic/vgic-init.o \
>>  	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 2959a1451232..534d33b7c67a 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1341,6 +1341,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  		if (ret > 0)
>>  			ret = check_vcpu_requests(vcpu);
>>  
>> +		if (ret > 0 && vcpu_is_rec(vcpu))
>> +			ret = kvm_rec_pre_enter(vcpu);
>> +
> 
> What needs to be done at this stage? Why isn't this handled as a
> request? Or similarly to an MMIO return?

Good point - a request looks like a better solution. I'll have a go
converting this to a new request.

>>  		/*
>>  		 * Preparing the interrupts to be injected also
>>  		 * involves poking the GIC, which must be done in a
>> @@ -1388,7 +1391,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  		trace_kvm_entry(*vcpu_pc(vcpu));
>>  		guest_timing_enter_irqoff();
>>  
>> -		ret = kvm_arm_vcpu_enter_exit(vcpu);
>> +		if (vcpu_is_rec(vcpu))
>> +			ret = kvm_rec_enter(vcpu);
>> +		else
>> +			ret = kvm_arm_vcpu_enter_exit(vcpu);
> 
> This either sidesteps all the RCU EQS, context management and co, or
> duplicates it. Either way, that's no good.

Yeah, this isn't great - there's an issue here where we want to use the
same infrastructure but we need to handle the different return codes
from the RMM. I'll have a go at fixing this by moving this down into
kvm_rec_enter() and mapping RMM result codes into KVM ones.

>>  		vcpu->mode = OUTSIDE_GUEST_MODE;
>>  		vcpu->stat.exits++;
>> @@ -1434,7 +1440,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  		 * context synchronization event) is necessary to ensure that
>>  		 * pending interrupts are taken.
>>  		 */
>> -		if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) {
>> +		if ((!vcpu_is_rec(vcpu) && ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) ||
>> +		    (vcpu_is_rec(vcpu) && vcpu->arch.rec.run->exit.exit_reason == RMI_EXIT_IRQ)) {
> 
> No. Please adapt the CCA code so that what it returns has the exact
> same format as the non-CCA code, having the vcpu state placed where it
> matters.

Agreed - this is horrid, sorry. As above I'll fix this to map the result
codes.

>>  			local_irq_enable();
>>  			isb();
>>  			local_irq_disable();
>> @@ -1446,8 +1453,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  
>>  		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
>>  
>> -		/* Exit types that need handling before we can be preempted */
>> -		handle_exit_early(vcpu, ret);
>> +		if (!vcpu_is_rec(vcpu)) {
>> +			/*
>> +			 * Exit types that need handling before we can be
>> +			 * preempted
>> +			 */
>> +			handle_exit_early(vcpu, ret);
>> +		}
> 
> Same thing.
> 
>>  
>>  		kvm_nested_sync_hwstate(vcpu);
>>  
>> @@ -1472,7 +1484,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>  			ret = ARM_EXCEPTION_IL;
>>  		}
>>  
>> -		ret = handle_exit(vcpu, ret);
>> +		if (vcpu_is_rec(vcpu))
>> +			ret = handle_rec_exit(vcpu, ret);
>> +		else
>> +			ret = handle_exit(vcpu, ret);
> 
> And same thing here as well.

Agreed.

>>  	}
>>  
>>  	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
>> diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
>> new file mode 100644
>> index 000000000000..973250563d7b
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rmi-exit.c
>> @@ -0,0 +1,182 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2023-2026 ARM Ltd.
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <kvm/arm_hypercalls.h>
>> +#include <kvm/arm_psci.h>
>> +
>> +#include <linux/arm-smccc-rmi.h>
>> +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_rmi.h>
>> +#include <asm/kvm_mmu.h>
>> +
>> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
>> +
>> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
>> +		 kvm_vcpu_get_esr(vcpu));
>> +	return -ENXIO;
>> +}
> 
> This should mark the VM dead.

Good point, thanks for pointing it out.

>> +
>> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>> +{
>> +	return kvm_handle_guest_abort(vcpu);
>> +}
>> +
>> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
>> +		 kvm_vcpu_get_esr(vcpu));
>> +	return -ENXIO;
>> +}
> 
> If you can't handle it, why do you specify a handler? isn't the
> default handler enough?

I think I can ditch the whole handler table as you mention below.

>> +
>> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
>> +{
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	unsigned long esr = kvm_vcpu_get_esr(vcpu);
>> +	int rt = kvm_vcpu_sys_get_rt(vcpu);
>> +	bool is_write = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_WRITE;
>> +	int ret;
>> +
>> +	if (is_write)
>> +		vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[rt]);
>> +
>> +	ret = kvm_handle_sys_reg(vcpu);
>> +	if (!is_write)
>> +		rec->run->enter.gprs[rt] = vcpu_get_reg(vcpu, rt);
>> +
>> +	return ret;
>> +}
>> +
>> +static exit_handler_fn rec_exit_handlers[] = {
>> +	[0 ... ESR_ELx_EC_MAX]	= rec_exit_reason_notimpl,
>> +	[ESR_ELx_EC_SYS64]	= rec_exit_sys_reg,
>> +	[ESR_ELx_EC_DABT_LOW]	= rec_exit_sync_dabt,
>> +	[ESR_ELx_EC_IABT_LOW]	= rec_exit_sync_iabt
>> +};
> 
> Frankly, none of that should exist. You should simply populate the
> state in the vcpu, and let the normal handlers run.

I'll have a go at doing that - I think it should be possible.

>> +
>> +static int rec_exit_psci(struct kvm_vcpu *vcpu)
>> +{
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	int i;
>> +
>> +	for (i = 0; i < REC_RUN_GPRS; i++)
>> +		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
>> +
>> +	return kvm_smccc_call_handler(vcpu);
>> +}
>> +
>> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct realm *realm = &kvm->arch.realm;
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	unsigned long base = rec->run->exit.ripas_base;
>> +	unsigned long top = rec->run->exit.ripas_top;
>> +	unsigned long ripas = rec->run->exit.ripas_value;
>> +
>> +	if (!kvm_realm_is_private_address(realm, base) ||
>> +	    !kvm_realm_is_private_address(realm, top - 1)) {
>> +		vcpu_err(vcpu, "Invalid RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
>> +			 base, top, ripas);
>> +		/* Set RMI_REJECT bit */
>> +		rec->run->enter.flags = REC_ENTER_FLAG_RIPAS_RESPONSE;
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Exit to VMM, the actual RIPAS change is done on next entry */
>> +	kvm_prepare_memory_fault_exit(vcpu, base, top - base, false, false,
>> +				      ripas == RMI_RAM);
>> +
>> +	/*
>> +	 * KVM_EXIT_MEMORY_FAULT requires an return code of -EFAULT, see the
>> +	 * API documentation
>> +	 */
>> +	return -EFAULT;
>> +}
>> +
>> +static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>> +{
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +	__vcpu_assign_sys_reg(vcpu, CNTV_CTL_EL0, rec->run->exit.cntv_ctl);
>> +	__vcpu_assign_sys_reg(vcpu, CNTV_CVAL_EL0, rec->run->exit.cntv_cval);
>> +	__vcpu_assign_sys_reg(vcpu, CNTP_CTL_EL0, rec->run->exit.cntp_ctl);
>> +	__vcpu_assign_sys_reg(vcpu, CNTP_CVAL_EL0, rec->run->exit.cntp_cval);
>> +
>> +	kvm_realm_timers_update(vcpu);
> 
> Why is that saved to memory? The expectations are that the HW timers
> are live when the guest state is loaded.

You mentioned this in the previous patch - I'm moving these to the
hardware registers as you requested, so this will go.

>> +}
>> +
>> +/*
>> + * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
>> + * proper exit to userspace.
>> + */
>> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>> +{
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);
>> +	unsigned long status, index;
>> +
>> +	status = RMI_RETURN_STATUS(rec_run_ret);
>> +	index = RMI_RETURN_INDEX(rec_run_ret);
>> +
>> +	/*
>> +	 * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we might
>> +	 * see the following status code and index indicating an attempt to run
>> +	 * a REC when the RD state is SYSTEM_OFF.  In this case, we just need to
>> +	 * return to user space which can deal with the system event or will try
>> +	 * to run the KVM VCPU again, at which point we will no longer attempt
>> +	 * to enter the Realm because we will have a sleep request pending on
>> +	 * the VCPU as a result of KVM's PSCI handling.
>> +	 */
>> +	if (status == RMI_ERROR_REALM) {
>> +		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
>> +		return 0;
>> +	}
>> +
>> +	/*
>> +	 * If a VCPU has been turned on, but the REC state hasn't been updated
>> +	 * we may experience RMI_ERROR_REC. Exit to the userspace with -EAGAIN
>> +	 * for a retry.
>> +	 */
>> +	if (status == RMI_ERROR_REC)
>> +		return -EAGAIN;
>> +	if (rec_run_ret)
>> +		return -ENXIO;
>> +
>> +	vcpu->arch.fault.esr_el2 = rec->run->exit.esr;
>> +	vcpu->arch.fault.far_el2 = rec->run->exit.far;
>> +	/* HPFAR_EL2 is only valid for RMI_EXIT_SYNC */
>> +	vcpu->arch.fault.hpfar_el2 = 0;
>> +
>> +	update_arch_timer_irq_lines(vcpu);
>> +
>> +	/* Reset the emulation flags for the next run of the REC */
>> +	rec->run->enter.flags = 0;
>> +
>> +	switch (rec->run->exit.exit_reason) {
>> +	case RMI_EXIT_SYNC:
>> +		/*
>> +		 * HPFAR_EL2_NS is hijacked to indicate a valid HPFAR value,
>> +		 * see __get_fault_info()
>> +		 */
>> +		vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar | HPFAR_EL2_NS;
>> +		return rec_exit_handlers[esr_ec](vcpu);
>> +	case RMI_EXIT_IRQ:
>> +	case RMI_EXIT_FIQ:
>> +	case RMI_EXIT_SERROR:
>> +		return 1;
>> +	case RMI_EXIT_PSCI:
>> +		return rec_exit_psci(vcpu);
>> +	case RMI_EXIT_RIPAS_CHANGE:
>> +		return rec_exit_ripas_change(vcpu);
>> +	}
>> +
>> +	kvm_pr_unimpl("Unsupported exit reason: %u\n",
>> +		      rec->run->exit.exit_reason);
>> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +	return 0;
>> +}
> 
> -ETOOMUCHCODE. Please rework this so that this is modelled after the
>  existing KVM code. Extra handling (such as the other RMI_EXIT*
>  reasons) can be treated as if they were an HVC call from the guest.

Ok - treating it as an HVC call looks like it should work. Thanks for
the suggestion.

>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index aa97ad5fd7e9..430b82c02d15 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -203,6 +203,48 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
>>  	return realm_destroy_rtts(kvm);
>>  }
>>  
>> +/*
>> + * kvm_rec_pre_enter - Complete operations before entering a REC
>> + *
>> + * Some operations require work to be completed before entering a realm. That
>> + * work may require memory allocation so cannot be done in the kvm_rec_enter()
>> + * call.
>> + *
>> + * Return: 1 if we should enter the guest
>> + *	   0 if we should exit to userspace
>> + *	   < 0 if we should exit to userspace, where the return value indicates
>> + *	   an error
>> + */
>> +int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
>> +{
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
>> +		return -EINVAL;
> 
> Do you really need to check for this in the run loop?

With the suggestion to use requests then I think this whole pre_enter
concept can be removed. But agreed this is a bit of a silly check for
every loop.

>> +
>> +	switch (rec->run->exit.exit_reason) {
>> +	case RMI_EXIT_HOST_CALL:
>> +		for (int i = 0; i < REC_RUN_GPRS; i++)
>> +			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>> +		break;
> 
> If this only happens on returning to the guest from a host call, this
> definitely can be done as a request.

Ack.

>> +	}
>> +
>> +	return 1;
>> +}
>> +
>> +int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
>> +{
>> +	struct realm_rec *rec = &vcpu->arch.rec;
>> +	int ret;
>> +
>> +	guest_state_enter_irqoff();
>> +	ret = rmi_rec_enter(virt_to_phys(rec->rec_page),
>> +			    virt_to_phys(rec->run));
> 
> Why don't you keep the PAs around instead? This should be merged into
> kvm_arm_vcpu_enter_exit().

Ack

> 
>> +	guest_state_exit_irqoff();
>> +
>> +	return ret;
>> +}
>> +
>>  static int __maybe_unused kvm_create_rec(struct kvm_vcpu *vcpu)
>>  {
>>  	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
> 
> Thanks,
> 
> 	M.
> 

Thanks for the review and suggestions!

Steve

