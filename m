Return-Path: <SRS0=V360=D6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB57C4363A
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 17:01:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D00BF20797
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 17:01:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D00BF20797
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C06E54B77D;
	Fri, 23 Oct 2020 13:01:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4BCcBpN-k0Vn; Fri, 23 Oct 2020 13:01:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCBAC4B77E;
	Fri, 23 Oct 2020 13:01:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A0664B77C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 13:01:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bqJssSuRHAPE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2020 13:01:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15B4B4B77B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 13:01:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7F1C1FB;
 Fri, 23 Oct 2020 10:01:07 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA01E3F719;
 Fri, 23 Oct 2020 10:01:05 -0700 (PDT)
Subject: Re: [PATCH 4/6] arm64/kvm: Support async page fault
To: Gavin Shan <gshan@redhat.com>
References: <20200818011319.91777-1-gshan@redhat.com>
 <20200818011319.91777-5-gshan@redhat.com>
From: James Morse <james.morse@arm.com>
Message-ID: <00cc430b-1597-68ac-059c-c7d6df235f37@arm.com>
Date: Fri, 23 Oct 2020 18:01:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200818011319.91777-5-gshan@redhat.com>
Content-Language: en-GB
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Gavin,

[my mail client went a bit nuts - it thinks this got sent already, sorry if you received
it twice!]

I only got so far through this, so may have focussed on the wrong things.
This patch has too many things going on. Please split it up.

I think the page-fault and page-present should be done separately, with the gubbins the
core-code needs added first. The cap and corresponding documentation should be added last
so the whole thing bisects.

It looks like the guest and hypervisor parts are already split up, this is helpful,
thanks. Please ensure that the descriptions are clear on this distinction too. Its not at
all clear where where the 'reschedule ipi' comes from in this commit message.

I'd really like it if as much of the guest parts as possible lived in common code. There
is nothing arch-specific about an interrupt and reading from shared memory.


On 18/08/2020 02:13, Gavin Shan wrote:
> There are two stages of page fault. The guest kernel is responsible
> for handling stage one page fault, while the host kernel is to take
> care of the stage two page fault. When page fault is triggered because
> of stage two page fault, the guest is suspended until the requested
> memory (page) is populated. Sometimes, the cost to populate the requested
> page isn't cheap and can take hundreds of milliseconds in extreme
> cases. This impacts the overall guest's performance.

Yes, its the cost of abstracting the machine's resources and invisibly carving them up.

> In order to resolve the issue and improve the guest's performance,

Why is it an issue? You've missed the important part of the commit message: why we should
make this change.

This needs to mention postcopy live migration, which is the reason for doing any of this.

I don't think "I overcommited and swapped the guest to disk" is at all compelling.
(as the doctor says: don't do that then)


> this introduces the feature (asychronous page fault). A page-not-present

(asynchronous)

> notification is fired to guest if the requested page isn't ready so that
> the guest can reschedule current process and pick another process to run.
> Another page-ready notification is sent to guest so that the process,
> which was rescheduled previously, can be picked up to run. With this,

> the guest needn't necessarily suspend itself on stage two page fault.

Be suspended by the hypervisor until the resources are available.
Normally the guest has no idea this is happening.


> These two notificatons are associated by so-called vCPU scoped tokens,

(notifications)

> which is the combination of incremental sequence number and vCPU index
> (@vcpu->vcpu_idx). Besides, the notifications are conveyed by SDEI and
> PPI, whose numbers are specified by guest through SMCCC interface.

... so you don't need the ACPI table?

The 'asynchrononous page fault' notification obviously needs to be (er,) synchronous, so
it has to be per-cpu.

Why is the page-ready IRQ a PPI? We have a limited number of these, so shouldn't use one
unless it _needs_ to be per-cpu.

'vcpu index' should probably be the MPIDR_EL1, which is something both the host and guest
already know that identifies the vcpu. Inventing something new isn't necessary.


> The asynchronous page fault always starts with a background woker if

(worker. Please run your commit-messages through a spell checker)


> current vCPU has enough token space and no pending notifications. After
> the worker, which populates the requested page background, is started,

what does 'requested page background' mean? (missing the words 'in the'?)


> a page-not-present notification, together with an unique token, are sent
> to guest through the specified private SDEI event. The notification is
> acknowledged by clearing the shared cache (@vcpu->apf.cache). The current
> process is marked for waiting completion of asynchronous page fault. A
> subsequent (reschedule) IPI is sent to current vCPU so that the current
> process can be reschedule and suspended until the asynchronous page is
> completed. In the meanwhile, the woker populates the requested page and
> it's queued to the completion queue once the task is completed.

> At this
> point or the acknoledgement (by SMCCC) on pending PPI, a PPI is sent to
> guest for page-ready notification.

A PPI is made pending, when the PPI is pending?


> The guest uses the associated token
> to locate the suspended process and wakes it up.

I hope the 'token' is nothing more than the IPA.


> In order to fulfil the functions, there are several SMCCC function IDs
> introduced and outlined as below:

Please add a documentation file for these for the benefit of other guests (e.g.
kvm-unit-test) describing these in more detail, their parameters, the expected lifecycle etc.


>    ARM_SMCCC_KVM_FUNC_APF_VERSION
>       Returns the version, which can be used to identify ABI changes in
>       the future.
>    ARM_SMCCC_KVM_FUNC_APF_ENABLE
>       Enable or disable asynchronous page fault on current vCPU.
>    ARM_SMCCC_KVM_FUNC_APF_TOKEN_NUM
>       Returns maximal number of tokens that current vCPU can have. It's
>       used by guest to allocate the required resources.
>    ARM_SMCCC_KVM_FUNC_APF_SDEI
>    ARM_SMCCC_KVM_FUNC_APF_IRQ
>       Used by guest to confiugre the SDEI event and PPI numbers.
>    ARM_SMCCC_KVM_FUNC_APF_IRQ_ACK
>       Acknowledge the page-ready notificaton in the PPI handler.


> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b6c9851b2a65..2e3bba6a99c3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -46,6 +46,7 @@
>  #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>  #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>  #define KVM_REQ_SDEI		KVM_ARCH_REQ(5)
> +#define KVM_REQ_APF_READY	KVM_ARCH_REQ(6)
>
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>  				     KVM_DIRTY_LOG_INITIALLY_SET)
> @@ -239,6 +240,23 @@ struct vcpu_reset_state {
>  	bool		reset;
>  };
>
> +#ifdef CONFIG_KVM_ASYNC_PF
> +
> +/* Should be a power of two number */
> +#define ASYNC_PF_PER_VCPU	64
> +
> +/*
> + * The association of gfn and token. The token will be sent to guest as
> + * page fault address. Also, the guest could be in aarch32 mode. So its
> + * length should be 32-bits.
> + */
> +struct kvm_arch_async_pf {
> +	u32     token;
> +	gfn_t   gfn;
> +	u32     esr;
> +};
> +#endif /* CONFIG_KVM_ASYNC_PF */


#ifdef-ing a struct makes it harder to use IS_ENABLED() in the C code, which in turn makes
it harder to get complete coverage from the CI builders without aligning the stars to hit
the right randconfig combination.

Please avoid doing this unless its absolutely necessary. (its not like a struct definition
takes up any space in the binary)


>  struct kvm_vcpu_arch {
>  	struct kvm_cpu_context ctxt;
>  	void *sve_state;
> @@ -346,6 +364,22 @@ struct kvm_vcpu_arch {
>  	struct kvm_sdei_vcpu_event	*sdei_normal_event;
>  	struct kvm_sdei_vcpu_event	*sdei_critical_event;
>  	struct list_head		sdei_events;
> +
> +#ifdef CONFIG_KVM_ASYNC_PF

See above. Any reason these can't be dynamically allocated if the feature is enabled by
the VMM? (You're using a PPI, this has to be allocated by the VMM).

Not all guests would use this, so its a waste of space if its enabled but not in use.


> +	struct {
> +		struct gfn_to_hva_cache	cache;

> +		gfn_t			gfns[ASYNC_PF_PER_VCPU];
> +		u64			control_block;

> +		bool			send_user_only;

Hmmm...


> +		u64			sdei_event_num;
> +		u32			irq;

> +		u16			id;

a per-vcpu id? KVM already has one, and the architecture has one that the guest can see too.


> +		bool			notpresent_pending;
> +		u32			notpresent_token;
> +		bool			pageready_pending;
> +	} apf;
> +#endif
>  };
>
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */


> diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
> new file mode 100644
> index 000000000000..0ea481dd1c7a
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_para.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM_KVM_PARA_H
> +#define _ASM_ARM_KVM_PARA_H

> +#include <uapi/asm/kvm_para.h>

> +static inline bool kvm_check_and_clear_guest_paused(void)
> +{
> +	return false;
> +}

This is part of kvmclock? aarch64 has an architecture specific way of doing that stuff.
Why is this here?!

(if you've turned something on that needs these stubs, its probably worth doing that in an
preparation patch so you can explain why, instead of hiding it in here)


> +static inline unsigned int kvm_arch_para_features(void)
> +{
> +	return 0;
> +}
> +
> +static inline unsigned int kvm_arch_para_hints(void)
> +{
> +	return 0;
> +}
> +
> +static inline bool kvm_para_available(void)
> +{
> +	return false;
> +}
> +
> +#endif /* _ASM_ARM_KVM_PARA_H */



> diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
> index 602d137932dc..f66554cd5c45 100644
> --- a/arch/arm64/include/uapi/asm/Kbuild
> +++ b/arch/arm64/include/uapi/asm/Kbuild
> @@ -1,3 +1 @@
>  # SPDX-License-Identifier: GPL-2.0
> -
> -generic-y += kvm_para.h

The arch specific version is practically the same as the asm-generic one.

Please explain why you need to do this in a preparatory patch.


> diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
> new file mode 100644
> index 000000000000..f0dbe86c2374
> --- /dev/null
> +++ b/arch/arm64/include/uapi/asm/kvm_para.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_ASM_ARM_KVM_PARA_H
> +#define _UAPI_ASM_ARM_KVM_PARA_H
> +
> +#include <linux/types.h>
> +
> +#define KVM_FEATURE_ASYNC_PF	0
> +
> +/* Async PF */
> +#define KVM_ASYNC_PF_ENABLED		(1 << 0)
> +#define KVM_ASYNC_PF_SEND_ALWAYS	(1 << 1)
> +
> +#define KVM_PV_REASON_PAGE_NOT_PRESENT	1
> +#define KVM_PV_REASON_PAGE_READY	2
> +
> +struct kvm_vcpu_pv_apf_data {
> +	__u32	reason;
> +	__u32	token;
> +	__u8	pad[56];
> +	__u32	enabled;
> +};
> +
> +#endif /* _UAPI_ASM_ARM_KVM_PARA_H */

Presumably this is the reason to carry around an extra copy of kvm_para.h.

Wouldn't it be better to unpick that dependency instead?


> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4bec6c9ece18..1a57dc5dbf14 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -225,6 +225,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		 */
>  		r = 1;
>  		break;
> +#ifdef CONFIG_KVM_ASYNC_PF
> +	case KVM_CAP_ASYNC_PF:
> +	case KVM_CAP_ASYNC_PF_INT:
> +		r = 1;
> +		break;
> +#endif
>  	default:
>  		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
>  		break;
> @@ -274,6 +280,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
>
>  	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> +#ifdef CONFIG_KVM_ASYNC_PF
> +	vcpu->arch.apf.control_block = 0UL;
> +#endif

kvm_vm_ioctl_create_vcpu() allocates vcpu with kmem_cache_zalloc(), so this field will
already be zero.


> @@ -432,8 +441,32 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
>  	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
> -	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -		&& !v->arch.power_off && !v->arch.pause);

As you are adding a conditional __copy_from_user() in here, please add an unconditional
might_sleep() at the top of this function. This lets us catch locations that will
sometimes break the first time they happen.


> +	if ((irq_lines || kvm_vgic_vcpu_pending_irq(v)) &&
> +	    !v->arch.power_off && !v->arch.pause)
> +		return true;
> +
> +#ifdef CONFIG_KVM_ASYNC_PF

Please use IS_ENABLED() here, #ifdeffery make this stuff harder to read and harder to
build-test.

(if you can come up with a readable IS_ENABLED() way of returning the _check_extension()
result - even better!)


> +	if (v->arch.apf.control_block & KVM_ASYNC_PF_ENABLED) {
> +		u32 val;
> +		int ret;
> +
> +		if (!list_empty_careful(&v->async_pf.done))
> +			return true;

> +		ret = kvm_read_guest_offset_cached(v->kvm, &v->arch.apf.cache,
> +						   &val, 0, sizeof(val));

You added a helper for this: kvm_async_pf_read_cache()...


> +		if (ret || val)
> +			return true;
> +
> +		ret = kvm_read_guest_offset_cached(v->kvm, &v->arch.apf.cache,
> +						   &val, 4, sizeof(val));
> +		if (ret || val)
> +			return true;

These 0 and 4 really need some kind of name to give a hint as to what they are for.


> +	}

This really ought to wrapped up in a helper that gives a hint as to what it is doing.

There are two magic locations in guest memory that means the guest controls whether it is
runnable or not... this sounds like a source of hard-to-debug issues.

I'd much prefer it if the guest only ever got blocked in the stage2 fault handler, as it
does today. This mechanism just provides information about what is going on at stage2,
which allows the guest to avoid getting blocked if it can do something about it.

Giving the guest access to the controls doesn't look right.


> +#endif
> +
> +	return false;
>  }

>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> @@ -624,6 +657,11 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>  		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
>  			kvm_reset_vcpu(vcpu);
>
> +#ifdef CONFIG_KVM_ASYNC_PF
> +		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
> +			kvm_check_async_pf_completion(vcpu);
> +#endif

(IS_ENABLED() would save you the link error ... providing a stub in core-code for
kvm_check_async_pf_completion() would let you rely on this request never being made instead)


>  		if (kvm_check_request(KVM_REQ_SDEI, vcpu))
>  			kvm_sdei_deliver(vcpu);
>
> @@ -739,7 +777,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
>
>  		if (ret <= 0 || need_new_vmid_gen(&vcpu->kvm->arch.vmid) ||
> -		    kvm_request_pending(vcpu)) {

> +		    (kvm_request_pending(vcpu) &&
> +		     READ_ONCE(vcpu->requests) != (1UL << KVM_REQ_APF_READY))) {

A double READ_ONCE() looks wrong. If you have to do this, presumably you didn't want a
vcpu->request to begin with.

It looks like KVM_REQ_APF_READY only exists to move the page-ready work onto the vcpu
thread because the vcpu got blocked further out by kvm_arch_vcpu_runnable(), and the
second half of the stage2-fault now needs doing.


I think it would be simpler to only ever block in the stage2 fault handler. The guest can
only ever be blocked on one stage2 fault at a time, so this abstraction to let it sleep
for any number is pointless. If I'm waiting for ipa-4, and get restarted because ipa-6 is
now available ... I'm going to fault on ipa-4 for a second time. There is no point
restarting the guest until it can make progress again.


From the first stage2 fault you can kick off the page-fault notification (which must be
synchronous, so can be notified without taking this fault again). If the vcpu takes a
fault that was already notified, it clearly can't handle the page-fault notification and
must be blocked until that page is available.

We should be able to depend on the regular wakeup from mm when the vcpu is blocked.
The extra information from page-present lets the guest know it can now touch these pages
without getting blocked ... they shouldn't need a wakeup.


>  			vcpu->mode = OUTSIDE_GUEST_MODE;
>  			isb(); /* Ensure work in x_flush_hwstate is committed */
>  			kvm_pmu_sync_hwstate(vcpu);


> diff --git a/arch/arm64/kvm/async_pf.c b/arch/arm64/kvm/async_pf.c
> new file mode 100644
> index 000000000000..910cb3a1bdc2
> --- /dev/null
> +++ b/arch/arm64/kvm/async_pf.c
> @@ -0,0 +1,462 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright Gavin Shan, Redhat Inc 2020.
> + *
> + * Asynchronous page fault support
> + */
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_emulate.h>
> +#include <kvm/arm_hypercalls.h>
> +#include <kvm/arm_vgic.h>
> +#include <asm/kvm_sdei.h>

> +static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
> +{
> +	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
> +}
> +
> +static inline u32 kvm_async_pf_hash_next(u32 key)
> +{
> +	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
> +}
> +
> +static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
> +		vcpu->arch.apf.gfns[i] = ~0;
> +}

> +/*
> + * Add gfn to the hash table. It's ensured there is a free entry
> + * when this function is called.
> + */
> +static void kvm_async_pf_hash_add(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_async_pf_hash_fn(gfn);
> +
> +	while (vcpu->arch.apf.gfns[key] != ~0)
> +		key = kvm_async_pf_hash_next(key);
> +
> +	vcpu->arch.apf.gfns[key] = gfn;
> +}
> +
> +static u32 kvm_async_pf_hash_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_async_pf_hash_fn(gfn);
> +	int i;
> +
> +	for (i = 0; i < ASYNC_PF_PER_VCPU; i++) {
> +		if (vcpu->arch.apf.gfns[key] == gfn ||
> +		    vcpu->arch.apf.gfns[key] == ~0)
> +			break;
> +
> +		key = kvm_async_pf_hash_next(key);
> +	}
> +
> +	return key;
> +}
> +
> +static void kvm_async_pf_hash_remove(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 i, j, k;
> +
> +	i = j = kvm_async_pf_hash_slot(vcpu, gfn);
> +	while (true) {
> +		vcpu->arch.apf.gfns[i] = ~0;
> +
> +		do {
> +			j = kvm_async_pf_hash_next(j);
> +			if (vcpu->arch.apf.gfns[j] == ~0)
> +				return;
> +
> +			k = kvm_async_pf_hash_fn(vcpu->arch.apf.gfns[j]);
> +			/*
> +			 * k lies cyclically in ]i,j]
> +			 * |    i.k.j |
> +			 * |....j i.k.| or  |.k..j i...|
> +			 */
> +		} while ((i <= j) ? (i < k && k <= j) : (i < k || k <= j));
> +
> +		vcpu->arch.apf.gfns[i] = vcpu->arch.apf.gfns[j];
> +		i = j;
> +	}
> +}
> +
> +bool kvm_async_pf_hash_find(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_async_pf_hash_slot(vcpu, gfn);
> +
> +	return vcpu->arch.apf.gfns[key] == gfn;
> +}
> +
> +static inline int kvm_async_pf_read_cache(struct kvm_vcpu *vcpu,
> +					  u32 offset, u32 *val)
> +{
> +	return kvm_read_guest_offset_cached(vcpu->kvm,
> +					    &vcpu->arch.apf.cache,
> +					    val, offset, sizeof(*val));
> +}
> +
> +static inline int kvm_async_pf_write_cache(struct kvm_vcpu *vcpu,
> +					   u32 offset, u32 val)
> +{
> +	return kvm_write_guest_offset_cached(vcpu->kvm,
> +					     &vcpu->arch.apf.cache,
> +					     &val, offset, sizeof(val));
> +}


This hash stuff doesn't look at all specific to arm64. Could it be moved to core code or a
shared header file so multiple architectures only need one copy of the code.
If they need to be different, it would be good to know why.




Thanks,

James

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
