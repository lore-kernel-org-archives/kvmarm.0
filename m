Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31228C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 14:19:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8538F4B1CA;
	Sat, 23 Apr 2022 10:19:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0rOi0G+0Bp2a; Sat, 23 Apr 2022 10:19:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 786024B131;
	Sat, 23 Apr 2022 10:19:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A44EE4B11F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2022 10:19:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dH-WTFauQJpu for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Apr 2022 10:19:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC9E4B11B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2022 10:19:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1650723553;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ut9tIfi4xazfLQ8vNUAkmzod65LSwZi4nsBvWAN5R+s=;
 b=QPhH1YDLK3pvbrQQhXDmV6UbA58yVUX75MN2V2ZJ9aUeTDWuaX2IC6oSUUEVpige/QeIUr
 LXyY/z7Q0iPpK2j6JcM6Rbka3bCax2diFauDmRJ2VTbrSeAFOfKBg7hTd1VqDT6Wubzp63
 NFcGbUFP1Kn9oHKVe4Q45xg96UY9IZc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-04IbD0wJPwycniYuatVFkQ-1; Sat, 23 Apr 2022 10:19:07 -0400
X-MC-Unique: 04IbD0wJPwycniYuatVFkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AAC6380670E;
 Sat, 23 Apr 2022 14:19:07 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 834102024CCE;
 Sat, 23 Apr 2022 14:18:53 +0000 (UTC)
Subject: Re: [PATCH v6 03/18] KVM: arm64: Add SDEI virtualization
 infrastructure
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-4-gshan@redhat.com> <YmMiyt/TDjJt0mdG@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <36899ea9-e8bd-27b2-8dfb-75b76eab50d7@redhat.com>
Date: Sat, 23 Apr 2022 22:18:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YmMiyt/TDjJt0mdG@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Oliver,

On 4/23/22 5:48 AM, Oliver Upton wrote:
> On Sun, Apr 03, 2022 at 11:38:56PM +0800, Gavin Shan wrote:
>> Software Delegated Exception Interface (SDEI) provides a mechanism
>> for registering and servicing system events, as defined by ARM DEN0054C
>> specification. One of these events will be used by Asynchronous Page
>> Fault (Async PF) to deliver notifications from host to guest.
>>
>> The events are classified into shared and private ones according to
>> their scopes. The shared events are system or VM scoped, but the
>> private events are CPU or VCPU scoped. The shared events can be
>> registered, enabled, unregistered and reset through hypercalls
>> issued from any VCPU. However, the private events are registered,
>> enabled, unregistered and reset on the calling VCPU through
>> hypercalls. Besides, the events are also classified into critical
>> and normal events according their priority. During event delivery
>> and handling, the normal event can be preempted by another critical
>> event, but not in reverse way. The critical event is never preempted
>> by another normal event.
> 
> We don't have any need for critical events though, right? We should avoid
> building out the plumbing around the concept of critical events until
> there is an actual use case for it.
> 

The Async PF one is critical event, as guest needs to handle it immediately.
Otherwise, it's possible that guest can't continue its execution. Besides,
the software signaled event (0x0) is normal event. They're the only two
events to be supported, I assume the software signaled event (0x0) is only
used selftest/kvm. So Async PF one becomes the only event and it can be
in normal priority until other SDEI event needs to be added and supported.

However, the logic to support critical/normal events has been here. So
I think it's probably nice to keep it. At least, it make it easier to
add a new SDEI event in future. We dropped the support for the shared
event from v5 to v6, I think we probably never need a shared event for
ever :)

>> This introduces SDEI virtualization infrastructure for various objects
>> used in the implementation. Currently, we don't support the shared
>> event.
>>
>>    * kvm_sdei_exposed_event
>>      The event which are defined and exposed by KVM. The event can't
>>      be registered until it's exposed. Besides, all the information
>>      in this event can't be changed after it's exposed.
>>
>>    * kvm_sdei_event
>>      The events are created based on the exposed events. Their states
>>      are changed when hypercalls are received or they are delivered
>>      to guest for handling.
>>
>>    * kvm_sdei_vcpu_context
>>      The vcpu context helps to handle events. The interrupted context
>>      is saved before the event handler is executed, and restored after
>>      the event handler is to finish.
>>
>>    * kvm_sdei_vcpu
>>      Place holder for all objects for one particular VCPU.
>>
>> The error of SDEI_NOT_SUPPORTED is returned for all hypercalls for now.
>> They will be supported one by one in the subsequent patches.
>>
>> Link: https://developer.arm.com/documentation/den0054/latest
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h |   1 +
>>   arch/arm64/include/asm/kvm_sdei.h | 148 ++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/Makefile           |   2 +-
>>   arch/arm64/kvm/arm.c              |   4 +
>>   arch/arm64/kvm/hypercalls.c       |   3 +
>>   arch/arm64/kvm/sdei.c             |  98 ++++++++++++++++++++
>>   include/uapi/linux/arm_sdei.h     |   4 +
>>   7 files changed, 259 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_sdei.h
>>   create mode 100644 arch/arm64/kvm/sdei.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index e3b25dc6c367..7644a400c4a8 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -343,6 +343,7 @@ struct kvm_vcpu_arch {
>>   	 * Anything that is not used directly from assembly code goes
>>   	 * here.
>>   	 */
>> +	struct kvm_sdei_vcpu *sdei;
>>   
>>   	/*
>>   	 * Guest registers we preserve during guest debugging.
>> diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
>> new file mode 100644
>> index 000000000000..2dbfb3ae0a48
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_sdei.h
>> @@ -0,0 +1,148 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Definitions of various KVM SDEI events.
>> + *
>> + * Copyright (C) 2022 Red Hat, Inc.
>> + *
>> + * Author(s): Gavin Shan <gshan@redhat.com>
>> + */
>> +
>> +#ifndef __ARM64_KVM_SDEI_H__
>> +#define __ARM64_KVM_SDEI_H__
>> +
>> +#include <uapi/linux/arm_sdei.h>
>> +#include <linux/arm-smccc.h>
>> +#include <linux/bits.h>
>> +#include <linux/spinlock.h>
>> +
>> +/*
>> + * The event which are defined and exposed by KVM. The event can't
>> + * be registered until it's exposed. Besides, all the information
>> + * in this event can't be changed after it's exposed.
>> + */
> 
> kernel doc style comments are highly preferable when describing a
> complex struct. Figuring out what each of the fields mean is not
> obvious.
> 

Yeah, it's a nice point and lets do this in next respin.

>> +struct kvm_sdei_exposed_event {
>> +	unsigned int	num;
>> +	unsigned char	type;
>> +	unsigned char	signaled;
> 
> what is this used for?
> 

It indicates the event can be raised by software or not. For those
events exposed by KVM should be raised by software, so this should
always be true.

>> +	unsigned char	priority;
>> +};
> 
> I don't think we have a need for this struct. ::type will always be set
> to PRIVATE and ::priority will always be NORMAL.
> 

If we don't support the critical event, this struct isn't needed except
@num field. However, I think it would be nice to support the critical
event. Besides, this struct can be merged with struct kvm_sdei_event
even the critical event is supported.

The struct and struct kvm_sdei_event are tracking the information
and state for one particular event. The information isn't changeable,
but state can be modify through hypercalls. It's the reason why I
had two separate structs to track the information and state.

>> +/*
>> + * Currently, only the private events are supported. The events are
>> + * created based on the exposed events and their states are changed
>> + * when hypercalls are received or they are delivered to guest for
>> + * handling.
>> + */
>> +struct kvm_sdei_event {
>> +	struct kvm_sdei_exposed_event	*exposed_event;
> 
> I'm not following what is meant by an exposed event. By default the
> KVM will expose all of the events to its guests.
> 

Please refer to the above reply. struct kvm_sdei_exposed_event
and this struct are tracking information and state for one particular
event on one particular vcpu. The unchangeable information is
maintained in kvm_sdei_exposed_event, but the changeable state
is tracked by this struct. Besides, the struct kvm_sdei_exposed_event
instance can be dereferenced by mutiple struct kvm_sdei_event
instances on different vcpus.

>> +	unsigned char			route_mode;
>> +	unsigned long			route_affinity;
> 
> If we only have private events, do we need to worry about routing?
> 

Yes, these two fields should be dropped. The private event is always
routed to the owning vcpu.

>> +	unsigned long			ep_address;
>> +	unsigned long			ep_arg;
>> +#define KVM_SDEI_EVENT_STATE_REGISTERED		BIT(0)
>> +#define KVM_SDEI_EVENT_STATE_ENABLED		BIT(1)
>> +#define KVM_SDEI_EVENT_STATE_UNREGISTER_PENDING	BIT(2)
>> +	unsigned long			state;
> 
> Isn't this state actually local to a PE (not VM) for private events?
> 

Yes, the state is vcpu scoped. After the support to shared event is
dropped from v5 to v6, there are no VM scoped properties any more.
Besides, For one same event, separate (struct kvm_sdei_event) instances
are created for the individual vcpus.


>> +	unsigned long			event_count;
>> +};
>> +
>> +/*
>> + * The vcpu context helps to handle events. The preempted or interrupted
>> + * context is saved before the event handler is executed, and restored
>> + * after the event handler is to finish. The event with normal priority
>> + * can be preempted by the one with critical priority. So there can be
>> + * two contexts on one particular vcpu for the events with normal and
>> + * critical priority separately.
>> + */
>> +struct kvm_sdei_vcpu_context {
>> +	struct kvm_sdei_event	*event;
> 
> Do we need this if we disallow nesting events?
> 

Yes, we need this. "event == NULL" is used as indication of invalid
context. @event is the associated SDEI event when the context is
valid.

>> +	unsigned long		regs[18];
>> +	unsigned long		pc;
>> +	unsigned long		pstate;
>> +};
>> +
>> +struct kvm_sdei_vcpu {
>> +	spinlock_t			lock;
> 
> Why do we need a lock? This state should only ever be messed with in the
> context of a single vCPU to which we already have exclusive access.
> 

Good point. I don't think we needn't it any more. The lock was introduced
to allow comprehensive event injection. For example, the event is injected
in the context, which is out of the vcpu. We shouldn't have this case now.

>> +	struct kvm_sdei_event		*events;
>> +	unsigned char			masked;
>> +	unsigned long			critical_event_count;
>> +	unsigned long			normal_event_count;
>> +	struct kvm_sdei_vcpu_context	context[SDEI_EVENT_PRIORITY_CRITICAL + 1];
>> +};
>> +
>> +/*
>> + * According to SDEI specification (v1.1), the event number spans 32-bits
>> + * and the lower 24-bits are used as the (real) event number. I don't
>> + * think we can use that much event numbers in one system. So we reserve
>> + * two bits from the 24-bits real event number, to indicate its types:
>> + * physical or virtual event. One reserved bit is enough for now, but
>> + * two bits are reserved for possible extension in future.
>> + *
>> + * The physical events are owned by firmware while the virtual events
>> + * are used by VMM and KVM.
> 
> Doesn't KVM own everything? I don't see how the guest could interact
> with another SDEI implementation.
> 

I might be overthinking on the scheme. The host's firmware might have
SDEI supported and we want to propogate these events originated from
host's firmware to guest. In this case, we need to distinguish the events
originated from host's firmware and kvm (guest's firmware). Even this
case isn't possible to happen, I think it's still nice to distinguish
the events originated from a real firmware or KVM emulated firmware.

>> + */
>> +#define KVM_SDEI_EVENT_NUM_TYPE_SHIFT	22
>> +#define KVM_SDEI_EVENT_NUM_TYPE_MASK	(3 << KVM_SDEI_EVENT_NUM_TYPE_SHIFT)
>> +#define KVM_SDEI_EVENT_NUM_TYPE_PHYS	0
>> +#define KVM_SDEI_EVENT_NUM_TYPE_VIRT	1
>> +
>> +static inline bool kvm_sdei_is_virtual(unsigned int num)
>> +{
>> +	unsigned int type;
>> +
>> +	type = (num & KVM_SDEI_EVENT_NUM_TYPE_MASK) >>
>> +	       KVM_SDEI_EVENT_NUM_TYPE_SHIFT;
>> +	if (type == KVM_SDEI_EVENT_NUM_TYPE_VIRT)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>> +static inline bool kvm_sdei_is_sw_signaled(unsigned int num)
>> +{
>> +	return num == SDEI_SW_SIGNALED_EVENT;
>> +}
> 
> Couldn't the caller just check the event number on their own?
> 

It would be hard because the caller can be guest. Generally, the
event and its associated information/state are accessed by hypercalls,
event injection and delivery, migration to be supported in future.
So I think it's good to check the event number by ourselves.

>> +static inline bool kvm_sdei_is_supported(unsigned int num)
>> +{
>> +	return kvm_sdei_is_sw_signaled(num) ||
>> +	       kvm_sdei_is_virtual(num);
>> +}
> 
> Is there ever going to be a situation where KVM has defined a new event
> but doesn't actually support it?
> 

Nice point. It's impossible. I will drop this helper and
kvm_sdei_is_supported(). Instead, the kvm_sdei_exposed_event
or kvm_sdei_event array should be checked. Besides, The macros
KVM_SDEI_EVENT_NUM_TYPE_* should be dropped either.

>> +static inline bool kvm_sdei_is_critical(unsigned char priority)
>> +{
>> +	return priority == SDEI_EVENT_PRIORITY_CRITICAL;
>> +}
>> +
>> +static inline bool kvm_sdei_is_normal(unsigned char priority)
>> +{
>> +	return priority == SDEI_EVENT_PRIORITY_NORMAL;
>> +}
>> +
>> +#define KVM_SDEI_REGISTERED_EVENT_FUNC(func, field)			\
>> +static inline bool kvm_sdei_is_##func(struct kvm_sdei_event *event)	\
>> +{									\
>> +	return !!(event->state & KVM_SDEI_EVENT_STATE_##field);		\
>> +}									\
>> +									\
>> +static inline void kvm_sdei_set_##func(struct kvm_sdei_event *event)	\
>> +{									\
>> +	event->state |= KVM_SDEI_EVENT_STATE_##field;			\
>> +}									\
>> +									\
>> +static inline void kvm_sdei_clear_##func(struct kvm_sdei_event *event)	\
>> +{									\
>> +	event->state &= ~KVM_SDEI_EVENT_STATE_##field;			\
>> +}
>> +
>> +KVM_SDEI_REGISTERED_EVENT_FUNC(registered, REGISTERED)
>> +KVM_SDEI_REGISTERED_EVENT_FUNC(enabled, ENABLED)
>> +KVM_SDEI_REGISTERED_EVENT_FUNC(unregister_pending, UNREGISTER_PENDING)
> 
> Are there any particular concerns about open coding the bitwise
> operations that are getting wrapped here? test_bit()/set_bit() is also a
> helpful construct.
> 

Ok. Lets drop these helpers and go ahead to use {test, set, clear}_bit()
in next respin.

>> +/* APIs */
>> +int kvm_sdei_call(struct kvm_vcpu *vcpu);
>> +void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
>> +void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
>> +
>> +#endif /* __ARM64_KVM_SDEI_H__ */
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 261644b1a6bb..d6ced92ae3f0 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -14,7 +14,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>>   	 inject_fault.o va_layout.o handle_exit.o \
>>   	 guest.o debug.o reset.o sys_regs.o \
>>   	 vgic-sys-reg-v3.o fpsimd.o pmu.o pkvm.o \
>> -	 arch_timer.o trng.o vmid.o \
>> +	 arch_timer.o trng.o vmid.o sdei.o \
>>   	 vgic/vgic.o vgic/vgic-init.o \
>>   	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
>>   	 vgic/vgic-v3.o vgic/vgic-v4.o \
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 523bc934fe2f..227c0e390571 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -38,6 +38,7 @@
>>   #include <asm/kvm_asm.h>
>>   #include <asm/kvm_mmu.h>
>>   #include <asm/kvm_emulate.h>
>> +#include <asm/kvm_sdei.h>
>>   #include <asm/sections.h>
>>   
>>   #include <kvm/arm_hypercalls.h>
>> @@ -331,6 +332,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   
>>   	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
>>   
>> +	kvm_sdei_create_vcpu(vcpu);
>> +
>>   	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
>>   
>>   	err = kvm_vgic_vcpu_init(vcpu);
>> @@ -352,6 +355,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>>   	kvm_timer_vcpu_terminate(vcpu);
>>   	kvm_pmu_vcpu_destroy(vcpu);
>> +	kvm_sdei_destroy_vcpu(vcpu);
>>   
>>   	kvm_arm_vcpu_destroy(vcpu);
>>   }
>> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
>> index b659387d8919..6aa027a4cee8 100644
>> --- a/arch/arm64/kvm/hypercalls.c
>> +++ b/arch/arm64/kvm/hypercalls.c
>> @@ -5,6 +5,7 @@
>>   #include <linux/kvm_host.h>
>>   
>>   #include <asm/kvm_emulate.h>
>> +#include <asm/kvm_sdei.h>
>>   
>>   #include <kvm/arm_hypercalls.h>
>>   #include <kvm/arm_psci.h>
>> @@ -93,6 +94,8 @@ static int kvm_hvc_standard(struct kvm_vcpu *vcpu, u32 func)
>>   	case PSCI_1_1_FN_SYSTEM_RESET2:
>>   	case PSCI_1_1_FN64_SYSTEM_RESET2:
>>   		return kvm_psci_call(vcpu);
>> +	case SDEI_1_0_FN_SDEI_VERSION ... SDEI_1_1_FN_SDEI_FEATURES:
>> +		return kvm_sdei_call(vcpu);
> 
> I mentioned in another thread, but reraising here on the new diff.
> Prefer using the defined function [start, end] range in this switch
> statement.
> 
> Overall, I think this still puts a lot of abstraction around the concept
> of SDEI events, even though we have a very narrow use case for it in KVM
> for now. Removing all of the plumbing for critical and shared events
> should help collapse this quite a bit.
> 

Yeah, I will define two macros in include/linux/arm-smccc.h, similar to
what you suggested for PATCH[02].

   #define SMCCC_STD_SDEI_RANGE_START	0x0020
   #define SMCCC_STD_SDEI_RANGE_END	0x003f

The support to share event was removed from v5 to v6. However, the @route_{
mode, affinity} fields in struct kvm_sdei_event should be dropped either.

For the critical event support, I think it would be nice to keep it as I
explained above. First of all, the async PF event is naturally a critical
event. Secondly, the support doesn't require any VM-scoped properties.
So the SDEI event and (vcpu) context can be accessed and migrated through
firmware pseudo-register easily in future.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
