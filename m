Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E4FC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 15:46:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDBA861207
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 15:46:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CDBA861207
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 508DF4B248;
	Tue,  9 Nov 2021 10:46:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NW-iad6B0bOF; Tue,  9 Nov 2021 10:46:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8A474B243;
	Tue,  9 Nov 2021 10:46:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D654B252
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 10:45:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 59okxIuxjw9N for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 10:45:25 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E0C84B22E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 10:45:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636472724;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wusfj/QY5Zfm1tBL3JiqBppffaSRXvQEivQ9LIV/0Sg=;
 b=Jm0orq8MwTHmzFyyNzrCDECVDL1sXoLEpX/G4XdizhX3dnbeB46MHdQ4nAfiTH+qrZSHpq
 ltDweJL//Rowv+S5/CMPIRObvuJD5ARwp5K3b2E7KLvkCX+uBFGLOn8pWzVChfjfjwnDtQ
 6M4f0JiaTI0Bw0LbqDBSh2tnkBV9eXg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-3s0JAhCTOi-tkpdSOHYx5w-1; Tue, 09 Nov 2021 10:45:23 -0500
X-MC-Unique: 3s0JAhCTOi-tkpdSOHYx5w-1
Received: by mail-wm1-f70.google.com with SMTP id
 n16-20020a05600c3b9000b003331973fdbbso1301261wms.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 07:45:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=wusfj/QY5Zfm1tBL3JiqBppffaSRXvQEivQ9LIV/0Sg=;
 b=ABtrCXc/y9H8a+gMbYyi3TB74UoboZs/hpaGMmbXubS97BpleN4fSp6Z9+kkfBu8qA
 w9wyGYxHIcIRnHsJ0eH0ONT/DPGUX0ubb6lU7qwFDG8MlovoEWdo61rmSuaAT59iOs5P
 5C1ehTupz7u5tPdJO5BuFumA9oggG2JDsqnUx2ENuCHj0iz3NOldTMWF2IWEgdMjK67h
 G9Jj+N6+/EJm4snzPpWMvUojJj1zJk8qwEWave98yipA2uNsMmaQSSDKA3pSaKDhtHlZ
 mB1PJVWhUwwjTfp9+mF0o3OQN37w4Hkevr00+hByWep19WkinP+EbwEN8NOysg3SAh9B
 xaBg==
X-Gm-Message-State: AOAM533v/0Rji3FYKXcBcL5rQpTBb2yJY8gVCOhDE0HbVF4Eqm/0mwMo
 w/XALJYgpmlBpWTDthHwEFpeuLifxjItdxsH2Bl+QQ5zPIsoufCjHOENs4UdvgvOkrVM7AO2Ugt
 mtr5tfUUk6XLwmmSbuS30R4h1
X-Received: by 2002:a05:600c:35d2:: with SMTP id
 r18mr8162829wmq.166.1636472721416; 
 Tue, 09 Nov 2021 07:45:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwiH3880zvdWg3RfHWdcAREl2o1MmXZKkgkNz9tPPhnisH6R0WrwxhRdJhhu+nxOCfOMkk56A==
X-Received: by 2002:a05:600c:35d2:: with SMTP id
 r18mr8162774wmq.166.1636472721037; 
 Tue, 09 Nov 2021 07:45:21 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id e12sm25287602wrq.20.2021.11.09.07.45.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 07:45:20 -0800 (PST)
Subject: Re: [PATCH v4 02/21] KVM: arm64: Add SDEI virtualization
 infrastructure
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-3-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <8108db38-e0fa-774b-c884-70b8606a3ab9@redhat.com>
Date: Tue, 9 Nov 2021 16:45:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-3-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
X-Mailman-Approved-At: Tue, 09 Nov 2021 10:46:40 -0500
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
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
On 8/15/21 2:13 AM, Gavin Shan wrote:
> Software Delegated Exception Interface (SDEI) provides a mechanism for
> registering and servicing system events. Those system events are high
> priority events, which must be serviced immediately. It's going to be
> used by Asynchronous Page Fault (APF) to deliver notification from KVM
> to guest. It's noted that SDEI is defined by ARM DEN0054A specification.
> 
> This introduces SDEI virtualization infrastructure where the SDEI events
> are registered and manuplated by the guest through hypercall. The SDEI
manipulated
> event is delivered to one specific vCPU by KVM once it's raised. This
> introduces data structures to represent the needed objects to implement
> the feature, which is highlighted as below. As those objects could be
> migrated between VMs, these data structures are partially exported to
> user space.
> 
>    * kvm_sdei_event
>      SDEI events are exported from KVM so that guest is able to register
>      and manuplate.
manipulate
>    * kvm_sdei_kvm_event
>      SDEI event that has been registered by guest.
I would recomment to revisit the names. Why kvm event? Why not
registered_event instead that actually would tell what it its. also you
have kvm twice in the struct name.
>    * kvm_sdei_kvm_vcpu
Didn't you mean kvm_sdei_vcpu_event instead?
>      SDEI event that has been delivered to the target vCPU.
>    * kvm_sdei_kvm
>      Place holder of exported and registered SDEI events.
>    * kvm_sdei_vcpu
>      Auxiliary object to save the preempted context during SDEI event
>      delivery.
> 
> The error is returned for all SDEI hypercalls for now. They will be
> implemented by the subsequent patches.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h      |   6 +
>  arch/arm64/include/asm/kvm_sdei.h      | 118 +++++++++++++++
>  arch/arm64/include/uapi/asm/kvm.h      |   1 +
>  arch/arm64/include/uapi/asm/kvm_sdei.h |  60 ++++++++
>  arch/arm64/kvm/Makefile                |   2 +-
>  arch/arm64/kvm/arm.c                   |   7 +
>  arch/arm64/kvm/hypercalls.c            |  18 +++
>  arch/arm64/kvm/sdei.c                  | 198 +++++++++++++++++++++++++
>  8 files changed, 409 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/kvm_sdei.h
>  create mode 100644 arch/arm64/include/uapi/asm/kvm_sdei.h
>  create mode 100644 arch/arm64/kvm/sdei.c
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 41911585ae0c..aedf901e1ec7 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -113,6 +113,9 @@ struct kvm_arch {
>  	/* Interrupt controller */
>  	struct vgic_dist	vgic;
>  
> +	/* SDEI support */
does not bring much. Why not reusing the commit msg explanation? Here
and below.
> +	struct kvm_sdei_kvm *sdei;
> +
>  	/* Mandated version of PSCI */
>  	u32 psci_version;
>  
> @@ -339,6 +342,9 @@ struct kvm_vcpu_arch {
>  	 * here.
>  	 */
>  
> +	/* SDEI support */
> +	struct kvm_sdei_vcpu *sdei;> +
>  	/*
>  	 * Guest registers we preserve during guest debugging.
>  	 *
> diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
> new file mode 100644
> index 000000000000..b0abc13a0256
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_sdei.h
> @@ -0,0 +1,118 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Definitions of various KVM SDEI events.
> + *
> + * Copyright (C) 2021 Red Hat, Inc.
> + *
> + * Author(s): Gavin Shan <gshan@redhat.com>
> + */
> +
> +#ifndef __ARM64_KVM_SDEI_H__
> +#define __ARM64_KVM_SDEI_H__
> +
> +#include <uapi/linux/arm_sdei.h>> +#include <uapi/asm/kvm_sdei.h>
> +#include <linux/bitmap.h>
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +
> +struct kvm_sdei_event {
> +	struct kvm_sdei_event_state		state;
> +	struct kvm				*kvm;
> +	struct list_head			link;
> +};
> +
> +struct kvm_sdei_kvm_event {
> +	struct kvm_sdei_kvm_event_state		state;
> +	struct kvm_sdei_event			*kse;
> +	struct kvm				*kvm;
can't you reuse the kvm handle in state?
> +	struct list_head			link;
> +};
> +
> +struct kvm_sdei_vcpu_event {
> +	struct kvm_sdei_vcpu_event_state	state;
> +	struct kvm_sdei_kvm_event		*kske;
> +	struct kvm_vcpu				*vcpu;
> +	struct list_head			link;
> +};
> +
> +struct kvm_sdei_kvm {
> +	spinlock_t		lock;
> +	struct list_head	events;		/* kvm_sdei_event */
> +	struct list_head	kvm_events;	/* kvm_sdei_kvm_event */
> +};
> +
> +struct kvm_sdei_vcpu {
> +	spinlock_t                      lock;
> +	struct kvm_sdei_vcpu_state      state;
could you explain the fields below?
> +	struct kvm_sdei_vcpu_event      *critical_event;
> +	struct kvm_sdei_vcpu_event      *normal_event;
> +	struct list_head                critical_events;
> +	struct list_head                normal_events;
> +};
> +
> +/*
> + * According to SDEI specification (v1.0), the event number spans 32-bits
> + * and the lower 24-bits are used as the (real) event number. I don't
> + * think we can use that much SDEI numbers in one system. So we reserve
> + * two bits from the 24-bits real event number, to indicate its types:
> + * physical event and virtual event. One reserved bit is enough for now,
> + * but two bits are reserved for possible extension in future.
I think this assumption is worth to be mentionned in the commit msg.
> + *
> + * The physical events are owned by underly firmware while the virtual
underly?
> + * events are used by VMM and KVM.
> + */
> +#define KVM_SDEI_EV_NUM_TYPE_SHIFT	22
> +#define KVM_SDEI_EV_NUM_TYPE_MASK	3
> +#define KVM_SDEI_EV_NUM_TYPE_PHYS	0
> +#define KVM_SDEI_EV_NUM_TYPE_VIRT	1
> +
> +static inline bool kvm_sdei_is_valid_event_num(unsigned long num)
the name of the function does does not really describe what it does. It
actually checks the sdei is a virtual one. suggest kvm_sdei_is_virtual?
> +{
> +	unsigned long type;
> +
> +	if (num >> 32)
> +		return false;
> +
> +	type = (num >> KVM_SDEI_EV_NUM_TYPE_SHIFT) & KVM_SDEI_EV_NUM_TYPE_MASK;
I think the the mask generally is applied before shifting. See
include/linux/irqchip/arm-gic-v3.h
> +	if (type != KVM_SDEI_EV_NUM_TYPE_VIRT)
> +		return false;
> +
> +	return true;
> +}
> +
> +/* Accessors for the registration or enablement states of KVM event */
> +#define KVM_SDEI_FLAG_FUNC(field)					   \
> +static inline bool kvm_sdei_is_##field(struct kvm_sdei_kvm_event *kske,	   \
> +				       unsigned int index)		   \
> +{									   \
> +	return !!test_bit(index, (void *)(kske->state.field));		   \
> +}									   \
> +									   \
> +static inline bool kvm_sdei_empty_##field(struct kvm_sdei_kvm_event *kske) \
nit: s/empty/none ?
> +{									   \
> +	return bitmap_empty((void *)(kske->state.field),		   \
> +			    KVM_SDEI_MAX_VCPUS);			   \
> +}									   \
> +static inline void kvm_sdei_set_##field(struct kvm_sdei_kvm_event *kske,   \
> +					unsigned int index)		   \
> +{									   \
> +	set_bit(index, (void *)(kske->state.field));			   \
> +}									   \
> +static inline void kvm_sdei_clear_##field(struct kvm_sdei_kvm_event *kske, \
> +					  unsigned int index)		   \
> +{									   \
> +	clear_bit(index, (void *)(kske->state.field));			   \
> +}
> +
> +KVM_SDEI_FLAG_FUNC(registered)
> +KVM_SDEI_FLAG_FUNC(enabled)
> +
> +/* APIs */
> +void kvm_sdei_init_vm(struct kvm *kvm);
> +void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
> +int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
> +void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
> +void kvm_sdei_destroy_vm(struct kvm *kvm);
> +
> +#endif /* __ARM64_KVM_SDEI_H__ */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..e1b200bb6482 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -36,6 +36,7 @@
>  #include <linux/types.h>
>  #include <asm/ptrace.h>
>  #include <asm/sve_context.h>
> +#include <asm/kvm_sdei.h>
>  
>  #define __KVM_HAVE_GUEST_DEBUG
>  #define __KVM_HAVE_IRQ_LINE
> diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
> new file mode 100644
> index 000000000000..8928027023f6
> --- /dev/null
> +++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
> @@ -0,0 +1,60 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Definitions of various KVM SDEI event states.
> + *
> + * Copyright (C) 2021 Red Hat, Inc.
> + *
> + * Author(s): Gavin Shan <gshan@redhat.com>
> + */
> +
> +#ifndef _UAPI__ASM_KVM_SDEI_H
> +#define _UAPI__ASM_KVM_SDEI_H
> +
> +#ifndef __ASSEMBLY__
> +#include <linux/types.h>
> +
> +#define KVM_SDEI_MAX_VCPUS	512
> +#define KVM_SDEI_INVALID_NUM	0
> +#define KVM_SDEI_DEFAULT_NUM	0x40400000

The motivation behind introducing such uapi should be clearer (besides
just telling this aims at migrating). To me atm, this justification does
not make possible to understand if those structs are well suited. You
should document the migration process I think.

I would remove _state suffix in all of them.
> +
> +struct kvm_sdei_event_state {
This is not really a state because it cannot be changed by the guest,
right? I would remove _state and just call it kvm_sdei_event
> +	__u64	num;
> +
> +	__u8	type;
> +	__u8	signaled;
> +	__u8	priority;
you need some padding to be 64-bit aligned. See in generic or aarch64
kvm.h for instance.
> +};
> +
> +struct kvm_sdei_kvm_event_state {
I would rename into kvm_sdei_registered_event or smth alike
> +	__u64	num;
how does this num differ from the event state one?
> +	__u32	refcount;
> +
> +	__u8	route_mode;
padding also here. See for instance
https://lore.kernel.org/kvm/20200911145446.2f9f5eb8@w520.home/T/#m7bac2ff2b28a68f8d2196ec452afd3e46682760d

Maybe put the the route_mode field and refcount at the end and add one
byte of padding?

Why can't we have a single sdei_event uapi representation where route
mode defaults to unset and refcount defaults to 0 when not registered?

> +	__u64	route_affinity;
> +	__u64	entries[KVM_SDEI_MAX_VCPUS];
> +	__u64	params[KVM_SDEI_MAX_VCPUS];
I would rename entries into ep_address and params into ep_arg.
> +	__u64	registered[KVM_SDEI_MAX_VCPUS/64];
maybe add a comment along with KVM_SDEI_MAX_VCPUS that it must be a
multiple of 64 (or a build check)

> +	__u64	enabled[KVM_SDEI_MAX_VCPUS/64];
Also you may clarify what this gets used for a shared event. I guess
this only makes sense for a private event which can be registered by
several EPs?
> +};
> +
> +struct kvm_sdei_vcpu_event_state {
> +	__u64	num;
> +	__u32	refcount;
how does it differ from num and refcount of the registered event?
padding++
> +};
> +
> +struct kvm_sdei_vcpu_regs {
> +	__u64	regs[18];
> +	__u64	pc;
> +	__u64	pstate;
> +};
> +
> +struct kvm_sdei_vcpu_state {
> +	__u8				masked;
padding++
> +	__u64				critical_num;
> +	__u64				normal_num;
> +	struct kvm_sdei_vcpu_regs	critical_regs;
> +	struct kvm_sdei_vcpu_regs	normal_regs;
> +};> +
> +#endif /* !__ASSEMBLY__ */
> +#endif /* _UAPI__ASM_KVM_SDEI_H */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 989bb5dad2c8..eefca8ca394d 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
>  	 inject_fault.o va_layout.o handle_exit.o \
>  	 guest.o debug.o reset.o sys_regs.o \
>  	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
> -	 arch_timer.o trng.o\
> +	 arch_timer.o trng.o sdei.o \
>  	 vgic/vgic.o vgic/vgic-init.o \
>  	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
>  	 vgic/vgic-v3.o vgic/vgic-v4.o \
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..2f021aa41632 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -150,6 +150,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	kvm_vgic_early_init(kvm);
>  
> +	kvm_sdei_init_vm(kvm);
> +
>  	/* The maximum number of VCPUs is limited by the host's GIC model */
>  	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
>  
> @@ -179,6 +181,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  
>  	kvm_vgic_destroy(kvm);
>  
> +	kvm_sdei_destroy_vm(kvm);
> +
>  	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>  		if (kvm->vcpus[i]) {
>  			kvm_vcpu_destroy(kvm->vcpus[i]);
> @@ -333,6 +337,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
>  
> +	kvm_sdei_create_vcpu(vcpu);
> +
>  	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
>  
>  	err = kvm_vgic_vcpu_init(vcpu);
> @@ -354,6 +360,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  	kvm_timer_vcpu_terminate(vcpu);
>  	kvm_pmu_vcpu_destroy(vcpu);
> +	kvm_sdei_destroy_vcpu(vcpu);
>  
>  	kvm_arm_vcpu_destroy(vcpu);
>  }
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 30da78f72b3b..d3fc893a4f58 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -139,6 +139,24 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	case ARM_SMCCC_TRNG_RND32:
>  	case ARM_SMCCC_TRNG_RND64:
>  		return kvm_trng_call(vcpu);
> +	case SDEI_1_0_FN_SDEI_VERSION:
> +	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
> +	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
> +	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
> +	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
> +	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
> +	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
> +	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
> +	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
> +	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
> +	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
> +	case SDEI_1_0_FN_SDEI_PE_MASK:
> +	case SDEI_1_0_FN_SDEI_PE_UNMASK:
> +	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
> +	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
> +	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
> +	case SDEI_1_0_FN_SDEI_SHARED_RESET:
> +		return kvm_sdei_hypercall(vcpu);
>  	default:
>  		return kvm_psci_call(vcpu);
>  	}
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> new file mode 100644
> index 000000000000..ab330b74a965
> --- /dev/null
> +++ b/arch/arm64/kvm/sdei.c
> @@ -0,0 +1,198 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * SDEI virtualization support.
> + *
> + * Copyright (C) 2021 Red Hat, Inc.
> + *
> + * Author(s): Gavin Shan <gshan@redhat.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/kvm_host.h>
> +#include <linux/spinlock.h>
> +#include <linux/slab.h>
> +#include <kvm/arm_hypercalls.h>
> +
> +static struct kvm_sdei_event_state defined_kse[] = {
> +	{ KVM_SDEI_DEFAULT_NUM,
> +	  SDEI_EVENT_TYPE_PRIVATE,
> +	  1,
> +	  SDEI_EVENT_PRIORITY_CRITICAL
> +	},
> +};
I understand from the above we currently only support a single static (~
platform) SDEI event with num = KVM_SDEI_DEFAULT_NUM. We do not support
bound events. You may add a comment here and maybe in the commit msg.
I would rename the variable into exported_events.
> +
> +static void kvm_sdei_remove_events(struct kvm *kvm)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_event *kse, *tmp;
> +
> +	list_for_each_entry_safe(kse, tmp, &ksdei->events, link) {
> +		list_del(&kse->link);
> +		kfree(kse);
> +	}
> +}
> +
> +static void kvm_sdei_remove_kvm_events(struct kvm *kvm,
> +				       unsigned int mask,
> +				       bool force)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_event *kse;
> +	struct kvm_sdei_kvm_event *kske, *tmp;
> +
> +	list_for_each_entry_safe(kske, tmp, &ksdei->kvm_events, link) {
> +		kse = kske->kse;
> +
> +		if (!((1 << kse->state.type) & mask))
> +			continue;
don't you need to hold a lock before looping? What if sbdy concurrently
changes the state fields, especially the refcount below?
> +
> +		if (!force && kske->state.refcount)
> +			continue;
Usually the refcount is used to control the lifetime of the object. The
'force' flag looks wrong in that context. Shouldn't you make sure all
users have released their refcounts and on the last decrement, delete
the object?
> +
> +		list_del(&kske->link);
> +		kfree(kske);
> +	}
> +}
> +
> +static void kvm_sdei_remove_vcpu_events(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_vcpu_event *ksve, *tmp;
> +
> +	list_for_each_entry_safe(ksve, tmp, &vsdei->critical_events, link) {
> +		list_del(&ksve->link);
> +		kfree(ksve);
> +	}
> +
> +	list_for_each_entry_safe(ksve, tmp, &vsdei->normal_events, link) {
> +		list_del(&ksve->link);
> +		kfree(ksve);
> +	}
> +}
> +
> +int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	u32 func = smccc_get_function(vcpu);
> +	bool has_result = true;
> +	unsigned long ret;
> +
> +	switch (func) {
> +	case SDEI_1_0_FN_SDEI_VERSION:
> +	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
> +	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
> +	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
> +	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
> +	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
> +	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
> +	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
> +	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
> +	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
> +	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
> +	case SDEI_1_0_FN_SDEI_PE_MASK:
> +	case SDEI_1_0_FN_SDEI_PE_UNMASK:
> +	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
> +	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
> +	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
> +	case SDEI_1_0_FN_SDEI_SHARED_RESET:
> +	default:
> +		ret = SDEI_NOT_SUPPORTED;
> +	}
> +
> +	/*
> +	 * We don't have return value for COMPLETE or COMPLETE_AND_RESUME
> +	 * hypercalls. Otherwise, the restored context will be corrupted.
> +	 */
> +	if (has_result)
> +		smccc_set_retval(vcpu, ret, 0, 0, 0);
If I understand the above comment, COMPLETE and COMPLETE_AND_RESUME
should have has_result set to false whereas in that case they will
return NOT_SUPPORTED. Is that OK for the context restore?
> +
> +	return 1;
> +}
> +
> +void kvm_sdei_init_vm(struct kvm *kvm)
> +{
> +	struct kvm_sdei_kvm *ksdei;
> +	struct kvm_sdei_event *kse;
> +	int i;
> +
> +	ksdei = kzalloc(sizeof(*ksdei), GFP_KERNEL);
> +	if (!ksdei)
> +		return;
> +
> +	spin_lock_init(&ksdei->lock);
> +	INIT_LIST_HEAD(&ksdei->events);
> +	INIT_LIST_HEAD(&ksdei->kvm_events);
> +
> +	/*
> +	 * Populate the defined KVM SDEI events. The whole functionality
> +	 * will be disabled on any errors.
You should definitively revise your naming conventions. this brings
confusion inbetween exported events and registered events. Why not
simply adopt the spec terminology?
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(defined_kse); i++) {
> +		kse = kzalloc(sizeof(*kse), GFP_KERNEL);
> +		if (!kse) {
> +			kvm_sdei_remove_events(kvm);
> +			kfree(ksdei);
> +			return;
> +		}
Add a comment saying that despite we currently support a single static
event we prepare for binding support by building a list of exposed events?

Or maybe simplify the implementation at this stage of the development
assuming a single platform event is supported?
> +
> +		kse->kvm   = kvm;
> +		kse->state = defined_kse[i];
> +		list_add_tail(&kse->link, &ksdei->events);
> +	}
> +
> +	kvm->arch.sdei = ksdei;
> +}
> +
> +void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_vcpu *vsdei;
> +
> +	if (!kvm->arch.sdei)
> +		return;
> +
> +	vsdei = kzalloc(sizeof(*vsdei), GFP_KERNEL);
> +	if (!vsdei)
> +		return;
> +
> +	spin_lock_init(&vsdei->lock);
> +	vsdei->state.masked       = 1;
> +	vsdei->state.critical_num = KVM_SDEI_INVALID_NUM;
> +	vsdei->state.normal_num   = KVM_SDEI_INVALID_NUM;
> +	vsdei->critical_event     = NULL;
> +	vsdei->normal_event       = NULL;
> +	INIT_LIST_HEAD(&vsdei->critical_events);
> +	INIT_LIST_HEAD(&vsdei->normal_events);
> +
> +	vcpu->arch.sdei = vsdei;
> +}
> +
> +void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +
> +	if (vsdei) {
> +		spin_lock(&vsdei->lock);
> +		kvm_sdei_remove_vcpu_events(vcpu);
> +		spin_unlock(&vsdei->lock);
> +
> +		kfree(vsdei);
> +		vcpu->arch.sdei = NULL;
> +	}
> +}
> +
> +void kvm_sdei_destroy_vm(struct kvm *kvm)
> +{
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	unsigned int mask = (1 << SDEI_EVENT_TYPE_PRIVATE) |
> +			    (1 << SDEI_EVENT_TYPE_SHARED);
> +
> +	if (ksdei) {
> +		spin_lock(&ksdei->lock);
> +		kvm_sdei_remove_kvm_events(kvm, mask, true);> +		kvm_sdei_remove_events(kvm);
> +		spin_unlock(&ksdei->lock);
> +
> +		kfree(ksdei);
> +		kvm->arch.sdei = NULL;
> +	}
> +}
> 
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
