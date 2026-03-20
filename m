Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBFD3BAD9C;
	Fri, 20 Mar 2026 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774024364; cv=none; b=mtyRW9B5UXmM8WhDy5yryidtHr+anPWEqWzDcv67zS7Z+kkgP1Bpi0xs5GD1H2wN2tCPhwFzQJxbfjovmbPOMg8VCFmCZM+exZ6Q/LYFOPCfrmGBrJ6gDTPRWIwWO2plf6BHNTN6aAlQweif6aEqSxbX70xwp/I4ugqDJJSYfTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774024364; c=relaxed/simple;
	bh=b+R57N+VPURYVQ/32NFpfMOuEpqe+7ZDMK7ctEYXSRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fbv1NQf/NKKb0QCEMcDb3tZU0FWOFpVrWq+yFPoNC/Fr71cjZd7/Bgisjbkd6HjlnkczJiYEPP/20PyYBT769GswOTFbI1XZulFyErodaSjHCx8vB8P2mFiRYt7NllO13cAlsSKTCSJw/ln1fIpW16X3aJjlm/0K5kU6hI6NlxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAE76165C;
	Fri, 20 Mar 2026 09:32:35 -0700 (PDT)
Received: from [10.1.29.20] (e122027.cambridge.arm.com [10.1.29.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C48A53F7BD;
	Fri, 20 Mar 2026 09:32:37 -0700 (PDT)
Message-ID: <02582577-3701-4d5c-88c6-3ce0b3328377@arm.com>
Date: Fri, 20 Mar 2026 16:32:35 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 20/48] arm64: RMI: Handle realm enter/exit
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-21-steven.price@arm.com>
 <8929a008-0991-4e3c-98a1-f00af47dd0ff@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8929a008-0991-4e3c-98a1-f00af47dd0ff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 20/03/2026 14:08, Suzuki K Poulose wrote:
> On 18/03/2026 15:53, Steven Price wrote:
>> Entering a realm is done using a SMC call to the RMM. On exit the
>> exit-codes need to be handled slightly differently to the normal KVM
>> path so define our own functions for realm enter/exit and hook them
>> in if the guest is a realm guest.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> ---
>> Changes since v12:
>>   * Call guest_state_{enter,exit}_irqoff() around rmi_rec_enter().
>>   * Add handling of the IRQ exception case where IRQs need to be briefly
>>     enabled before exiting guest timing.
>> Changes since v8:
>>   * Introduce kvm_rec_pre_enter() called before entering an atomic
>>     section to handle operations that might require memory allocation
>>     (specifically completing a RIPAS change introduced in a later patch).
>>   * Updates to align with upstream changes to hpfar_el2 which now
>> (ab)uses
>>     HPFAR_EL2_NS as a valid flag.
>>   * Fix exit reason when racing with PSCI shutdown to return
>>     KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
>> Changes since v7:
>>   * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>>     been read (although that can never happen in the current code). Tidy
>>     up the condition to handle any future refactoring.
>> Changes since v6:
>>   * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>>     vcpu to the error.
>>   * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>>     this exit type.
>>   * Split code handling a RIPAS change triggered by the guest to the
>>     following patch.
>> Changes since v5:
>>   * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>>     change on next entry rather than immediately on the exit. This allows
>>     the VMM to 'reject' a RIPAS change by refusing to continue
>>     scheduling.
>> Changes since v4:
>>   * Rename handle_rme_exit() to handle_rec_exit()
>>   * Move the loop to copy registers into the REC enter structure from the
>>     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>>     where the handler exits to user space and user space wants to modify
>>     the GPRS.
>>   * Some code rearrangement in rec_exit_ripas_change().
>> Changes since v2:
>>   * realm_set_ipa_state() now provides an output parameter for the
>>     top_iap that was changed. Use this to signal the VMM with the correct
>>     range that has been transitioned.
>>   * Adapt to previous patch changes.
>> ---
>>   arch/arm64/include/asm/kvm_rmi.h |   4 +
>>   arch/arm64/kvm/Makefile          |   2 +-
>>   arch/arm64/kvm/arm.c             |  26 ++++-
>>   arch/arm64/kvm/rmi-exit.c        | 178 +++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/rmi.c             |  43 ++++++++
>>   5 files changed, 247 insertions(+), 6 deletions(-)
>>   create mode 100644 arch/arm64/kvm/rmi-exit.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/
>> asm/kvm_rmi.h
>> index 4e2c61e71a38..7bec3a3976e7 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -92,6 +92,10 @@ void kvm_destroy_realm(struct kvm *kvm);
>>   void kvm_realm_destroy_rtts(struct kvm *kvm);
>>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>   +int kvm_rec_enter(struct kvm_vcpu *vcpu);
>> +int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>> +
>>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>>                           unsigned long addr)
>>   {
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index e17c4077d8e7..4b103bcbe760 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
>>   kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>>        inject_fault.o va_layout.o handle_exit.o config.o \
>>        guest.o debug.o reset.o sys_regs.o stacktrace.o \
>> -     vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o \
>> +     vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o rmi-exit.o \
>>        arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
>>        vgic/vgic.o vgic/vgic-init.o \
>>        vgic/vgic-irqfd.o vgic/vgic-v2.o \
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 45eff4c41cde..badb94b398bc 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1311,6 +1311,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>           if (ret > 0)
>>               ret = check_vcpu_requests(vcpu);
>>   +        if (ret > 0 && vcpu_is_rec(vcpu))
>> +            ret = kvm_rec_pre_enter(vcpu);
>> +
>>           /*
>>            * Preparing the interrupts to be injected also
>>            * involves poking the GIC, which must be done in a
>> @@ -1358,7 +1361,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>           trace_kvm_entry(*vcpu_pc(vcpu));
>>           guest_timing_enter_irqoff();
>>   -        ret = kvm_arm_vcpu_enter_exit(vcpu);
>> +        if (vcpu_is_rec(vcpu))
>> +            ret = kvm_rec_enter(vcpu);
>> +        else
>> +            ret = kvm_arm_vcpu_enter_exit(vcpu);
>>             vcpu->mode = OUTSIDE_GUEST_MODE;
>>           vcpu->stat.exits++;
>> @@ -1404,7 +1410,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>            * context synchronization event) is necessary to ensure that
>>            * pending interrupts are taken.
>>            */
>> -        if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) {
>> +        if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ ||
>> +            (vcpu_is_rec(vcpu) &&
>> +             vcpu->arch.rec.run->exit.exit_reason == RMI_EXIT_IRQ)) {
>>               local_irq_enable();
>>               isb();
>>               local_irq_disable();
>> @@ -1416,8 +1424,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>             trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
>> *vcpu_pc(vcpu));
>>   -        /* Exit types that need handling before we can be preempted */
>> -        handle_exit_early(vcpu, ret);
>> +        if (!vcpu_is_rec(vcpu)) {
>> +            /*
>> +             * Exit types that need handling before we can be
>> +             * preempted
>> +             */
>> +            handle_exit_early(vcpu, ret);
>> +        }
>>             kvm_nested_sync_hwstate(vcpu);
>>   @@ -1442,7 +1455,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu
>> *vcpu)
>>               ret = ARM_EXCEPTION_IL;
>>           }
>>   -        ret = handle_exit(vcpu, ret);
>> +        if (vcpu_is_rec(vcpu))
>> +            ret = handle_rec_exit(vcpu, ret);
>> +        else
>> +            ret = handle_exit(vcpu, ret);
>>       }
>>         /* Tell userspace about in-kernel device output levels */
>> diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
>> new file mode 100644
>> index 000000000000..f5701153dec0
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rmi-exit.c
>> @@ -0,0 +1,178 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <kvm/arm_hypercalls.h>
>> +#include <kvm/arm_psci.h>
>> +
>> +#include <asm/rmi_smc.h>
>> +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_rmi.h>
>> +#include <asm/kvm_mmu.h>
>> +
>> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
>> +
>> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
>> +         rec->run->exit.esr);
>> +    return -ENXIO;
>> +}
>> +
>> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>> +{
>> +    return kvm_handle_guest_abort(vcpu);
>> +}
>> +
>> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
>> +         rec->run->exit.esr);
>> +    return -ENXIO;
>> +}
>> +
>> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long esr = kvm_vcpu_get_esr(vcpu);
>> +    int rt = kvm_vcpu_sys_get_rt(vcpu);
>> +    bool is_write = !(esr & 1);
>> +    int ret;
>> +
>> +    if (is_write)
>> +        vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
> 
> The RMM has been fixed to indicate the correct value in ESR_ELx_SRT. So
> this could be :
>         vcpu_set_reg(vcpu, rt, rec->run->ext.gprs[rt]); ?
> 
>> +
>> +    ret = kvm_handle_sys_reg(vcpu);
>> +    if (!is_write)
>> +        rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
> 
> Same here ^

True, although no functional change because it's always going to be 0.

>> +
>> +    return ret;
>> +}
>> +
>> +static exit_handler_fn rec_exit_handlers[] = {
>> +    [0 ... ESR_ELx_EC_MAX]    = rec_exit_reason_notimpl,
>> +    [ESR_ELx_EC_SYS64]    = rec_exit_sys_reg,
>> +    [ESR_ELx_EC_DABT_LOW]    = rec_exit_sync_dabt,
>> +    [ESR_ELx_EC_IABT_LOW]    = rec_exit_sync_iabt
>> +};
>> +
>> +static int rec_exit_psci(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    int i;
>> +
>> +    for (i = 0; i < REC_RUN_GPRS; i++)
>> +        vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
>> +
>> +    return kvm_smccc_call_handler(vcpu);
>> +}
>> +
>> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm *realm = &kvm->arch.realm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long base = rec->run->exit.ripas_base;
>> +    unsigned long top = rec->run->exit.ripas_top;
>> +    unsigned long ripas = rec->run->exit.ripas_value;
>> +
>> +    if (!kvm_realm_is_private_address(realm, base) ||
>> +        !kvm_realm_is_private_address(realm, top - 1)) {
>> +        vcpu_err(vcpu, "Invalid RIPAS_CHANGE for %#lx - %#lx, ripas:
>> %#lx\n",
>> +             base, top, ripas);
>> +        /* Set RMI_REJECT bit */
>> +        rec->run->enter.flags = REC_ENTER_FLAG_RIPAS_RESPONSE;
>> +        return -EINVAL;
>> +    }
>> +
>> +    /* Exit to VMM, the actual RIPAS change is done on next entry */
>> +    kvm_prepare_memory_fault_exit(vcpu, base, top - base, false, false,
>> +                      ripas == RMI_RAM);
>> +
>> +    /*
>> +     * KVM_EXIT_MEMORY_FAULT requires an return code of -EFAULT, see the
>> +     * API documentation
>> +     */
>> +    return -EFAULT;
>> +}
>> +
>> +static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    __vcpu_assign_sys_reg(vcpu, CNTV_CTL_EL0, rec->run->exit.cntv_ctl);
>> +    __vcpu_assign_sys_reg(vcpu, CNTV_CVAL_EL0, rec->run-
>> >exit.cntv_cval);
>> +    __vcpu_assign_sys_reg(vcpu, CNTP_CTL_EL0, rec->run->exit.cntp_ctl);
>> +    __vcpu_assign_sys_reg(vcpu, CNTP_CVAL_EL0, rec->run-
>> >exit.cntp_cval);
>> +
>> +    kvm_realm_timers_update(vcpu);
>> +}
>> +
>> +/*
>> + * Return > 0 to return to guest, < 0 on error, 0 (and set
>> exit_reason) on
>> + * proper exit to userspace.
>> + */
>> +int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);
>> +    unsigned long status, index;
>> +
>> +    status = RMI_RETURN_STATUS(rec_run_ret);
>> +    index = RMI_RETURN_INDEX(rec_run_ret);
>> +
>> +    /*
>> +     * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we
>> might
>> +     * see the following status code and index indicating an attempt
>> to run
>> +     * a REC when the RD state is SYSTEM_OFF.  In this case, we just
>> need to
>> +     * return to user space which can deal with the system event or
>> will try
>> +     * to run the KVM VCPU again, at which point we will no longer
>> attempt
>> +     * to enter the Realm because we will have a sleep request
>> pending on
>> +     * the VCPU as a result of KVM's PSCI handling.
>> +     */
>> +    if (status == RMI_ERROR_REALM && index == 1) {
>> +        vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
>> +        return 0;
>> +    }
>> +
>> +    if (rec_run_ret)
>> +        return -ENXIO;
>> +
>> +    vcpu->arch.fault.esr_el2 = rec->run->exit.esr;
> 
> Even ESR_EL2 is only valid when the exit reason is RMI_EXIT_SYNC or
> RMI_EXIT_SERROR.
> Doing this unconditional copying is fine, as long as we don't consume
> the esr_el2 in exit handling without consulting the exit reason, which
> may not be available to the rest of the KVM. It may be safer to set it
> to 0 ?

For HPFAR_EL2 there is code in the kernel which hijacks the EL2_NS bit a
'valid' bit, hence we have to handle that one specially to record
whether the value is valid or not.

esr_el2/far_el2 may or may not be valid depending on the exit, but
there's no 'valid' flag for the generic kernel code to look for - so
that generic code either depends on the value (in which case 0 is just
as invalid) or doesn't use it.

My preference is to avoid trying to keep track of the exit reasons where
such flags are valid and just provide the generic code with whatever the
RMM provides. In any case the values are generally 'sanitised' by the
RMM so they don't represent the real CPU registers.

>> +    vcpu->arch.fault.far_el2 = rec->run->exit.far;
>> +    /* HPFAR_EL2 is only valid for RMI_EXIT_SYNC */
>> +    vcpu->arch.fault.hpfar_el2 = 0;
>> +
>> +    update_arch_timer_irq_lines(vcpu);
>> +
>> +    /* Reset the emulation flags for the next run of the REC */
>> +    rec->run->enter.flags = 0;
>> +
>> +    switch (rec->run->exit.exit_reason) {
>> +    case RMI_EXIT_SYNC:
>> +        /*
>> +         * HPFAR_EL2_NS is hijacked to indicate a valid HPFAR value,
>> +         * see __get_fault_info()
>> +         */
>> +        vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar |
>> HPFAR_EL2_NS;
>> +        return rec_exit_handlers[esr_ec](vcpu);
>> +    case RMI_EXIT_IRQ:
>> +    case RMI_EXIT_FIQ:
>> +        return 1;
>> +    case RMI_EXIT_PSCI:
>> +        return rec_exit_psci(vcpu);
>> +    case RMI_EXIT_RIPAS_CHANGE:
>> +        return rec_exit_ripas_change(vcpu);
> 
> RMI_EXIT_SERROR is missing in the list above.

Indeed, I think I need to read up on how that's meant to be handled.

>> +    }
>> +
>> +    kvm_pr_unimpl("Unsupported exit reason: %u\n",
>> +              rec->run->exit.exit_reason);
> 
> 
> 
>> +    vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +    return 0;
>> +}
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 6daf14c4b413..ee8aab098117 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -394,6 +394,49 @@ static int realm_ensure_created(struct kvm *kvm)
>>       return -ENXIO;
>>   }
>>   +/*
>> + * kvm_rec_pre_enter - Complete operations before entering a REC
>> + *
>> + * Some operations require work to be completed before entering a
>> realm. That
>> + * work may require memory allocation so cannot be done in the
>> kvm_rec_enter()
>> + * call.
>> + *
>> + * Return: 1 if we should enter the guest
>> + *       0 if we should exit to userspace
>> + *       < 0 if we should exit to userspace, where the return value
>> indicates
>> + *       an error
>> + */
>> +int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +
>> +    if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
>> +        return -EINVAL;
>> +
>> +    switch (rec->run->exit.exit_reason) {
>> +    case RMI_EXIT_HOST_CALL:
>> +    case RMI_EXIT_PSCI:
>> +        for (int i = 0; i < REC_RUN_GPRS; i++)
>> +            rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>> +        break;
>> +    }
>> +
>> +    return 1;
>> +}
>> +
>> +int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
>> +{
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    int ret;
>> +
>> +    guest_state_enter_irqoff();
>> +    ret = rmi_rec_enter(virt_to_phys(rec->rec_page),
>> +                virt_to_phys(rec->run));
> 
> In the normal VM case, we try to fixup some of the exits (e.g., GIC
> CPUIF register accesses) which may be applicable to Realms. Do we
> need such fixups here ? Given the cost of world switch, it is
> debatable whether it matters or not.

I'm not really sure what you are referring to here. Can you point me at
the normal VM case? This function is the equivalent of
kvm_arm_vcpu_enter_exit().

Thanks,
Steve

> Suzuki
>> +    guest_state_exit_irqoff();
>> +
>> +    return ret;
>> +}
>> +
>>   static void free_rec_aux(struct page **aux_pages,
>>                unsigned int num_aux)
>>   {
> 

