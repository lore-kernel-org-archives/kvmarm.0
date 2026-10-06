Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BAF31F98D
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 03:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791258175; cv=none; b=Kq1xMpVW5t3j7/sYXmq6/a15lxLZ7c+ZvYTVoq75CYfuQ4RV7k0WcHOj7Q9NeOgge5vf0qtf1fPsCmDb48CvC+xY6XTEuOisHKg/qR43fDqp1s/RHZWYxprYMVwvE30At1DIqXue5Xlid4jyVlmiCjSqLeMwoplZvvK3GUnVTqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791258175; c=relaxed/simple;
	bh=ewL6r4+WUG3zvSaf1v33KUoNnFiMKovzld70FKrMj7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hdznNq4bIMY7f6isLHvGcRioTpgLC36HfFUceq0h8M1AFLfEawelxvZVbrBoNenlGHw7Nd4epAckDAZRGpS98QA4KIGY5QXpCmwbaPkfoFIxxKRoW1ztOB2mRQS5yjuB3Lmd1ELApwhWL8HOTIH48SJEvhkoGur4k2jXOQ9DUU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SzSL4ZVt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SzSL4ZVt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791258172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ciyrU+oMiPwGK5aZ+ysyOdFUKDXGXj8SaQGvfUaxVI=;
	b=SzSL4ZVtnOgWxgW+Sc8lI62BiquJcdntraIk3q9uipWIi34VW7vRyMReJCU8dCG8aSmqzk
	tY46IQbhQvZwkzx/TgSO8wSAn460BlQEnqxrxXtHwf1jHoSMF/L7VClKwXMD489RkJwZHO
	BhO5d2puaTfidFgHmOMUmwmkI19aRAk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-ZPkR-Il5Mb61cyuhfXVpQA-1; Mon, 05 Oct 2026 23:42:51 -0400
X-MC-Unique: ZPkR-Il5Mb61cyuhfXVpQA-1
X-Mimecast-MFC-AGG-ID: ZPkR-Il5Mb61cyuhfXVpQA_1791258170
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dbf293831so4343872a91.3
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 20:42:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791258170; x=1791862970;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ciyrU+oMiPwGK5aZ+ysyOdFUKDXGXj8SaQGvfUaxVI=;
        b=t206lPaKqe6AUZbvpeS7fhgqs/RZcH5BTXAlLM159ImrQKPuqWVcPTqo5iF3usblq9
         4ChYrT4MLQfIPI7K7pG1GYBxZsLXGDh4DlVlhOEw1YcRk5lv65aWywbwXdFz8FIF/2S6
         NT7PqZ4WSFm6PvoU54fKXdojSW6s1dp9ME11CyrEKM7QQNZvxlh454vZug0RPJnWDBF/
         ATxluj6SfKIZHFtS0A9n4N9P81+Gp84F2r7HTr4Gv8zWpOVt/7OSYhVTdAiRtZSww38b
         kvvkiiuw4VJxM0DnPUPWSZ6RcrCHGD0yucbogGcTCgb0hODh+Ar3RAe3ZEr27pj0ziLW
         BZzg==
X-Forwarded-Encrypted: i=1; AKwUvBwgUwQXGA+LNmWEZ7OeRk53LHQV+odF2hB5fAis/a2xg0Hc6QsyxFnnaWGH9FYaDOvjyQEd9AE=@lists.linux.dev
X-Gm-Message-State: AFq9FYLmN7M6lkAQnU4HzOoaZy2CPmXLwmH+/CaWLc2gUY/0V/DdDp79
	IyziyR2WGI0rnQu+v6D1dpS3M+FOSYkiDSsoHbROHPf7dyZBg7oPH+/jnAaDTIVVFn0AR1hOj57
	ffmzoSlbIcKfpTiaOZOE4Om81/w/faU6hnCE9xy3j9EwdQP9i6vTmPf5ulQ==
X-Gm-Gg: AYBFou1pZcv04eHHaAVYcMsPjU4dkFbpd5K7tqPYpb/8BmkDSwUmMx3fkMHuWq2b6Fc
	JanxmE37tAH8sLQw93GogRj9ZCBxs9ZoCHe6TbpoGjgoNPV69QOUK2BQusNE6EBrYmikn8SBJyG
	uECo7auZmpp5NcBelklLez5MfyeWVvLtI6f/Ew3iCeEiILIT9o6O7l5YD7CpuYy4yv15bLJ+QfT
	af20j2Bio2J6SSJ/9fdmKwa9ibN7pOyooaJZNH9w0q90k37d9DBqYfjSUgT/mtvu0ngFD7Jmccz
	rIBn5eJS9vBh2AQTnmijeAaBHBxnHaVnITMG5YdQ67rjHT42CEwmAZdEQzQuHuIBpkHRzm0EHVq
	j/FGnoPcLGqgeF+Rw+Hi1bhkj7nmbFMoilYeJVzZe5g==
X-Received: by 2002:a17:90b:2886:b0:3a8:2c7e:8986 with SMTP id 98e67ed59e1d1-3a82c7e90c0mr3024702a91.17.1791258169484;
        Mon, 05 Oct 2026 20:42:49 -0700 (PDT)
X-Received: by 2002:a17:90b:2886:b0:3a8:2c7e:8986 with SMTP id 98e67ed59e1d1-3a82c7e90c0mr3024671a91.17.1791258168948;
        Mon, 05 Oct 2026 20:42:48 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm5567281a91.1.2026.10.05.20.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 20:42:47 -0700 (PDT)
Message-ID: <9bbb3b3c-522f-4deb-9f32-0fcf731dd0bb@redhat.com>
Date: Tue, 6 Oct 2026 13:42:38 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 18/23] KVM: arm64: CCA: Introduce Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-19-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-19-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7_Vpv2UrBgTEjHNuWkSB7-kGVdQn-jkddjsM2GbrhOk_1791258170
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> Add foundational work for supporting Realms.
>   - Add a new VM flavor.
>   - At KVM init, check if the KVM can support Realms (though not functional
>     yet) and will be advertised by static key kvm_rmi_is_available. This
>     will be turned on in a later patches, once we have all the bits and
>     pieces ready. For now check if we are blessed with KVM_MODE_RMM.
>   - Add realm specific tracking in kvm_arch. Since Realm and protected pKVM
>     states are mutually exclusive, move them into a union.
> 
> Please note that we cannot create Realm VMs yet. This requires further
> changes to the UABI and core RMI driver support, which will come later.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/include/asm/kvm_emulate.h | 16 ++++++++
>   arch/arm64/include/asm/kvm_host.h    | 19 ++++++---
>   arch/arm64/include/asm/kvm_rmi.h     | 61 ++++++++++++++++++++++++++++
>   arch/arm64/include/asm/virt.h        |  1 +
>   arch/arm64/kvm/Makefile              |  2 +-
>   arch/arm64/kvm/arm.c                 |  6 +++
>   arch/arm64/kvm/mmu.c                 |  1 +
>   arch/arm64/kvm/rmi.c                 | 18 ++++++++
>   8 files changed, 118 insertions(+), 6 deletions(-)
>   create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>   create mode 100644 arch/arm64/kvm/rmi.c
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index a3c1928bdf743..d360a8b05b8bf 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -793,4 +793,20 @@ static inline void kvm_reset_vcpu_psci(struct kvm_vcpu *vcpu,
>   	vcpu_set_reg(vcpu, 0, reset_state->r0);
>   }
>   
> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
> +{
> +	return READ_ONCE(kvm->arch.realm.state);
> +}
> +
> +static inline void kvm_set_realm_state(struct kvm *kvm,
> +				       enum realm_state new_state)
> +{
> +	WRITE_ONCE(kvm->arch.realm.state, new_state);
> +}
> +
> +static inline bool kvm_realm_is_created(struct kvm *kvm)
> +{
> +	return kvm_vm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
> +}
> +
>   #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index dfa9d4ec61a76..3debffef638a4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -27,6 +27,7 @@
>   #include <asm/fpsimd.h>
>   #include <asm/kvm.h>
>   #include <asm/kvm_asm.h>
> +#include <asm/kvm_rmi.h>
>   #include <asm/vncr_mapping.h>
>   
>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -334,6 +335,7 @@ enum kvm_arm_vm_flavor {
>   	VM_PKVM,		/* Normal guests on pKVM */
>   	MARKER(__VM_PROTECTED),
>   	VM_PROTECTED_PKVM,	/* Protected VM */
> +	VM_REALM,		/* CCA */
>   	VM_FLAVOR_MAX
>   };
>   
> @@ -450,11 +452,14 @@ struct kvm_arch {
>   	/* Count the number of VNCR_EL2 TLBs */
>   	atomic_t vncr_tlb_count;
>   
> -	/*
> -	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
> -	 * the associated pKVM instance in the hypervisor.
> -	 */
> -	struct kvm_protected_vm pkvm;
> +	union {
> +		/*
> +		 * For an untrusted host VM, 'pkvm.handle' is used to lookup
> +		 * the associated pKVM instance in the hypervisor.
> +		 */
> +		struct kvm_protected_vm pkvm;
> +		struct realm realm;
> +	};
>   
>   #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>   	/* Nested virtualization info */
> @@ -1565,6 +1570,10 @@ struct kvm *kvm_arch_alloc_vm(void);
>   		(__kvm && kvm_vm_is_protected_pkvm(__kvm));		\
>   	})
>   
> +
> +#define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
> +#define vcpu_is_rec(vcpu)		kvm_vm_is_realm((vcpu)->kvm)
> +

vcpu_is_rec() isn't safely called in nVHE hyp stub. So do we need add something
similiar to what we had for vcpu_is_protected(vcpu) in PATCH[05]?

#ifdef __KVM_NVHE_HYPERVISOR__
/* vcpu_is_rec() isn't expected to called in nVHE hyp stub */
#define vcpu_is_rec(vcpu)	BUILD_BUG_ON(1)
#else
#define vcpu_is_rec(vcpu)	kvm_vm_is_realm((vcpu)->kvm)
#endif


>   #define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
>   
>   int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> new file mode 100644
> index 0000000000000..44f5c75a27b5b
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -0,0 +1,61 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023-2026 ARM Ltd.
> + */
> +
> +#ifndef __ASM_KVM_RMI_H
> +#define __ASM_KVM_RMI_H
> +
> +/**
> + * enum realm_state - State of a Realm
> + *
> + * Mirrors the RMM's Realm lifecycle states where they are meaningful to KVM,
> + * with REALM_STATE_DYING being a KVM-internal state used to prevent further
> + * requests while teardown is in progress. KVM does not track REALM_SYSTEM_OFF
> + * or REALM_ZOMBIE separately as they naturally lead to teardown.
> + */
> +enum realm_state {
> +	/**
> +	 * @REALM_STATE_NONE:
> +	 *      Realm has not yet been created. rmi_realm_create() has not
> +	 *      yet been called.
> +	 */
> +	REALM_STATE_NONE,
> +	/**
> +	 * @REALM_STATE_NEW:
> +	 *      Realm is under construction, rmi_realm_create() has been
> +	 *      called, but it is not yet activated. Pages may be populated.
                                                      ^^^^^
Granule instead of page is the term applicable to RMM. Lets use a generic
term 'memory' here. Also, lets mention the name of the function used to
populate the memory (granules), which is consistent to the comments for
REALM_STATE_ACTIVE.

	Memory may be populated by rmi_rtt_data_map_init().


> +	 */
> +	REALM_STATE_NEW,
> +	/**
> +	 * @REALM_STATE_ACTIVE:
> +	 *      Realm has been created and is eligible for execution with
> +	 *      rmi_rec_enter(). Pages may no longer be populated with
> +	 *      rmi_data_create().
> +	 */
> +	REALM_STATE_ACTIVE,

rmi_data_create() is an invalid function name.

	Memory can't longer be populated using rmi_rtt_data_map_init().

> +	/**
> +	 * @REALM_STATE_DYING:
> +	 *      Realm is in the process of being destroyed or has already been
> +	 *      destroyed.
> +	 */
> +	REALM_STATE_DYING,
> +	/**
> +	 * @REALM_STATE_DEAD:
> +	 *      Realm has been destroyed.
> +	 */
> +	REALM_STATE_DEAD
> +};
> +
> +/**
> + * struct realm - Additional per VM data for a Realm
> + *
> + * @state: The lifetime state machine for the realm
> + */
> +struct realm {
> +	enum realm_state state;
> +};
> +
> +void kvm_init_rmi(void);
> +
> +#endif /* __ASM_KVM_RMI_H */
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index b546703c3ab9a..92cec42952f42 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -87,6 +87,7 @@ void __hyp_reset_vectors(void);
>   bool is_kvm_arm_initialised(void);
>   
>   DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> +DECLARE_STATIC_KEY_FALSE(kvm_rmi_is_available);
>   
>   static inline bool is_pkvm_initialized(void)
>   {
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 59612d2f277c1..ed3cf30eb06e7 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
>   kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>   	 inject_fault.o va_layout.o handle_exit.o config.o \
>   	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
> -	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
> +	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o \
>   	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
>   	 vgic/vgic.o vgic/vgic-init.o \
>   	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 294cea4cc8271..37ef2ba4e43e2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -42,6 +42,7 @@
>   #include <asm/kvm_nested.h>
>   #include <asm/kvm_pkvm.h>
>   #include <asm/kvm_ptrauth.h>
> +#include <asm/kvm_rmi.h>
>   #include <asm/sections.h>
>   #include <asm/stacktrace/nvhe.h>
>   
> @@ -112,6 +113,8 @@ long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext)
>   	return -EINVAL;
>   }
>   
> +DEFINE_STATIC_KEY_FALSE(kvm_rmi_is_available);
> +
>   DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>   
>   DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
> @@ -2239,6 +2242,7 @@ static const struct kvm_vcpu_ops *arm64_vcpu_ops[] = {
>   	KVM_VCPU_OPS(VM_VHE, vhe_vcpu_ops),
>   	KVM_VCPU_OPS(VM_PKVM, pkvm_vcpu_ops),
>   	KVM_VCPU_OPS(VM_PROTECTED_PKVM, pkvm_vcpu_ops),
> +	KVM_VCPU_OPS(VM_REALM, realm_vcpu_ops),
>   };
>   
>   static void kvm_init_vcpu_ops(struct kvm_vcpu *vcpu)
> @@ -3192,6 +3196,8 @@ static __init int kvm_arm_init(void)
>   
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
> +	kvm_init_rmi();
> +
>   	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>   	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>   		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 58bc6a85f48b4..697f1ba6667a9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2927,6 +2927,7 @@ static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
>   	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
>   	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
>   	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
> +	KVM_VM_S2_OPS(VM_REALM, realm_vm_s2_ops),
>   };
>   
>   static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> new file mode 100644
> index 0000000000000..5ecc8b3498698
> --- /dev/null
> +++ b/arch/arm64/kvm/rmi.c
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023-2026 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/virt.h>
> +
> +void kvm_init_rmi(void)
> +{
> +	if (kvm_get_mode() != KVM_MODE_RMM)
> +		return;
> +
> +	/* TODO: Check if the RMI is available */
> +
> +	/* Future patch will enable static branch kvm_rmi_is_available */
> +}

Thanks,
Gavin

