Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705663;
	b=LNEH85nXr8+hJBQceU68Ccgz67j3JosCxc27vLjsph3SI2TwUOv6wjpqrdmjIGF0vDXo
	 XRS2wbj/U05xkopzO4vna+hGuIgRuED+wIToKT4/ToOSmY3KjzHwHURaQKkt++kkreF3r
	 ffbCotq9gQO9kbpEq3WfSYN4FSLFTF7mI5llyF320e7NnaECPivw8FpdjVfZ2tATqdeHh
	 jzGpHkX0KABTalDUtFhcHLADvt0il5GLfJJuDbrdkVbk3HxCbqtXLE9kJwRujwwhwTeXY
	 N+ZejSfUPZEbc5vtuokq6LGLvEXvTsofMwDDeKiVBeQz3ofQIr1N/+sntOAa1MDa/fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705663;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=4xnWshvkJ23X4uQ2FNxs2Hb9pWWi1vEC6ZBhkv3P+GA=;
	b=oqeK0gkjcx4jecEjRsCYcjvfcPInk5uQ7L/bPY93TZjMjQ/fywz+YVZqgCAWAWYgg//5
	 Ok3ypGg1EZoR/ANpLHMkHpI9UvG9CFnzFpYXIGRktBWPDCmHULcbmapDJowW1cKQAMmyx
	 I1CS/5lsjVLN/ro51UTmRpp71Nymmt5jXOeqcVEeDZD5geg+Jf33Q2JdZms3Da/TYAkqm
	 c8VSE5eudg5yTAQ9WJWceQcs7GswKYgK8QY7Jp+dply+wvGN0cTX4e9klMmLxNBfmds8T
	 m2EOj1STRU056zJczvTpP8yiGxBtH2te9wemD0Z9STx34ZzkKoDFum/cendHKyYdbaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=g5xkyovj;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111D2606A329;
	Tue,  3 Nov 2026 11:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 111D2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=g5xkyovj
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22ECD1576;
	Tue,  3 Nov 2026 03:34:18 -0800 (PST)
Received: from [10.57.66.79] (unknown [10.57.66.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E34F3F632;
	Tue,  3 Nov 2026 03:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793705661; bh=0p3wlH/rwVwhxafDQrx620E3G8yCsQDvQ9Ac/BAG9Sg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g5xkyovj6W2BqpiT6Huz0m7ftEkJvssMhm98c2Y3k2mFhb6f/JUQ+ideMdVXxe9Ss
	 a8/fHKP1uEj9zgUpPL1AVoM0OoN+lO7ZRh3qDANYbfFSSKBCAWTFU3m3YaVGVuelRt
	 AFG3MPqvgSrzzY8NJhS821dIIZ5gclJ4GahvDhUo=
Message-ID: <1869576e-f2e3-476f-9c1b-6a196d975ec5@arm.com>
Date: Tue, 3 Nov 2026 11:34:16 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/11] KVM: arm64: CCA: Introduce Realms
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-3-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261102141304.126883-3-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 02/11/2026 14:12, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Add foundational work for supporting Realms.
>   - Add a new VM flavor.
>   - At KVM init, check if the KVM can support Realms (though not functional
>     yet) and will be advertised by static key kvm_rmi_is_available. This
>     will be turned on in a later patch, once we have all the bits and
>     pieces ready. For now check if we are blessed with KVM_MODE_RMM.
>   - Add realm specific tracking in kvm_arch. Since Realm and protected pKVM
>     states are mutually exclusive, move them into a union.

I think this patch could stop with the above items.

>   - Also adjust the memslot preparation checks to reflect the changes.
> 

This and the VCPU features could be a separate patch or merged with the
other patches.

> Please note that we cannot create Realm VMs yet. This requires further
> changes to the UABI and core RMI driver support, which will come later.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_emulate.h   | 16 +++++++
>   arch/arm64/include/asm/kvm_host.h      | 57 +++++++++++++++++-------
>   arch/arm64/include/asm/kvm_rmi.h       | 61 ++++++++++++++++++++++++++
>   arch/arm64/include/asm/virt.h          |  1 +
>   arch/arm64/kvm/Makefile                |  2 +-
>   arch/arm64/kvm/arm.c                   | 24 ++++++++--
>   arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 +-
>   arch/arm64/kvm/hyp/nvhe/switch.c       |  4 +-
>   arch/arm64/kvm/hyp/nvhe/timer-sr.c     |  2 +-
>   arch/arm64/kvm/mmu.c                   | 13 +++---
>   arch/arm64/kvm/rmi.c                   | 18 ++++++++
>   11 files changed, 169 insertions(+), 31 deletions(-)
>   create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>   create mode 100644 arch/arm64/kvm/rmi.c
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 334211b8b2ee..32021bdf2610 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -831,4 +831,20 @@ static inline void kvm_reset_vcpu_psci(struct kvm_vcpu *vcpu,
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
> index ccd2dc8f73c3..7d0222047ca1 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -29,6 +29,7 @@
>   #include <asm/kvm.h>
>   #include <asm/kvm_asm.h>
>   #include <asm/kvm_hcall.h>
> +#include <asm/kvm_rmi.h>
>   #include <asm/vncr_mapping.h>
>   
>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -48,6 +49,13 @@
>   #define KVM_VCPU_MAX_FEATURES 10
>   #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
>   


> +#define KVM_REALM_VCPU_VALID_FEATURES			\
> +	(BIT(KVM_ARM_VCPU_POWER_OFF)		|	\
> +	 BIT(KVM_ARM_VCPU_PSCI_0_2)		|	\
> +	 BIT(KVM_ARM_VCPU_PTRAUTH_ADDRESS)	|	\
> +	 BIT(KVM_ARM_VCPU_SVE)			|	\
> +	 BIT(KVM_ARM_VCPU_PTRAUTH_GENERIC))
> +

Please could we move the ^^ to a separate patch ? See more below.

>   #define KVM_REQ_SLEEP \
>   	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
> @@ -409,6 +417,7 @@ enum kvm_arm_vm_flavor {
>   	VM_PKVM,		/* Normal guests on pKVM */
>   	MARKER(__VM_PROTECTED),
>   	VM_PROTECTED_PKVM,	/* Protected VM */
> +	VM_REALM,		/* CCA */
>   	VM_FLAVOR_MAX
>   };
>   
> @@ -502,11 +511,14 @@ struct kvm_arch {
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
> @@ -1572,30 +1584,43 @@ struct kvm *kvm_arch_alloc_vm(void);
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>   
> -#ifdef __KVM_NVHE_HYPERVISOR__
> +#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>   
> -#define kvm_vm_is_protected(kvm)			\
> -	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
> +#ifdef __KVM_NVHE_HYPERVISOR__
>   /*
>    * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
>    * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
> - * which is populated correctly and is gated on is_protected_kvm_enabled().
> + * which is populated correctly. Always vcpu_is_protected_pkvm(), which is
> + * gated on is_protected_kvm_enabled().
> + */
> +#define vcpu_is_protected(vcpu)		BUILD_BUG_ON(1)
> +#else
> +#define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
> +#endif
> +
> +#define kvm_vm_is_protected_pkvm(kvm)					\
> +	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
> +
> +/*
> + * Rely on is_protected_kvm_enabled() check in kvm_vm_is_protected_pkvm() to
> + * make sure the vcpu->kvm is always valid VA in the context
>    */
> -#define vcpu_is_protected(vcpu)						\
> +#define vcpu_is_protected_pkvm(vcpu)					\
>   	({								\
>   		struct kvm *__kvm = READ_ONCE((vcpu)->kvm);		\
>   									\
> -		(__kvm && kvm_vm_is_protected(__kvm));			\
> +		(__kvm && kvm_vm_is_protected_pkvm(__kvm));		\
>   	})
>   
> -#else
> -
> -#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
> -#define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
> +#define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
> +#define vcpu_is_rec(vcpu)		kvm_vm_is_realm((vcpu)->kvm)
>   
>   #define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
>   
> -#endif	/* __KVM_NVHE_HYPERVISOR__ */
> +#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)
> +
> +int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
> +bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>   
>   #define kvm_has_mte(kvm)					\
>   	(system_supports_mte() &&				\
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> new file mode 100644
> index 000000000000..3194daaacf2b
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
> +	 *      Realm is under construction, Realm Descriptor has been created,
> +	 *      but it is not yet activated. Memory may be populated.
> +	 */
> +	REALM_STATE_NEW,
> +	/**
> +	 * @REALM_STATE_ACTIVE:
> +	 *      Realm has been created and is eligible for execution with
> +	 *      rmi_rec_enter(). Memory may no longer be populated with known
> +	 *	contents.
> +	 */
> +	REALM_STATE_ACTIVE,
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
> index b546703c3ab9..92cec42952f4 100644
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
> index 7aaeeb84e788..66a719ab5b6b 100644
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
> index 157bf4b81202..c8599fed5902 100644
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
> @@ -1732,10 +1735,19 @@ static unsigned long system_supported_vcpu_features(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long features = KVM_VCPU_VALID_FEATURES;
>   
> -	if (vcpu->kvm->arch.vm_flavor == VM_PROTECTED_PKVM)
> +	switch (vcpu->kvm->arch.vm_flavor) {
> +	case VM_PROTECTED_PKVM:
>   		kvm_pkvm_vcpu_allowed_features(vcpu->kvm, &features);
> +		break;
> +	case VM_REALM:
> +		features = KVM_REALM_VCPU_VALID_FEATURES;
> +		break;
> +	default:
> +		break;
> +	}

This could be a separate patch ?

>   
> -	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
> +	if (vcpu_is_protected(vcpu) ||
> +	    !cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
>   		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);

We start with the allowed features and 32_BIT_EL1 is already cleared for 
both protected VMs. So we don't need this change anymore.

>   
>   	if (!kvm_supports_guest_pmuv3()) {
> @@ -1751,7 +1763,8 @@ static unsigned long system_supported_vcpu_features(struct kvm_vcpu *vcpu)
>   		clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
>   	}
>   
> -	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> +	if (vcpu_is_protected(vcpu) ||
> +	    !cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
>   		clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
>   

Same as above

>   	return features;
> @@ -1775,7 +1788,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>   	if (features & ~system_supported_vcpu_features(vcpu))
>   		return -EINVAL;
>   
> -	/* EL2 implements PSCI 1.1; the host must not dispatch as 0.1. */
> +	/* Both pKVM and RMM implements PSCI 1.1; the host must not dispatch as 0.1. */
>   	if (vcpu_is_protected(vcpu) &&
>   	    !test_bit(KVM_ARM_VCPU_PSCI_0_2, &features))

This too can be a separate patch, where we handle VCPU for Realms

>   		return -EINVAL;
> @@ -2312,6 +2325,7 @@ static const struct kvm_vcpu_ops *arm64_vcpu_ops[] = {
>   	KVM_VCPU_OPS(VM_VHE, vhe_vcpu_ops),
>   	KVM_VCPU_OPS(VM_PKVM, pkvm_vcpu_ops),
>   	KVM_VCPU_OPS(VM_PROTECTED_PKVM, pkvm_vcpu_ops),
> +	[VM_REALM] = NULL,
>   };
>   
>   static void kvm_init_vcpu_ops(struct kvm_vcpu *vcpu)
> @@ -3269,6 +3283,8 @@ static __init int kvm_arm_init(void)
>   
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
> +	kvm_init_rmi();
> +
>   	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>   	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>   		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 0261b2bc681f..ae6ced6d7b9e 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -84,7 +84,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
>   
>   static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
>   {
> -	return vcpu_is_protected(&hyp_vcpu->vcpu);
> +	return vcpu_is_protected_pkvm(&hyp_vcpu->vcpu);
>   }
>   
>   static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 89fb9dd351ad..6c03f48e6be3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -238,7 +238,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
>   
>   static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
>   {
> -	if (unlikely(vcpu_is_protected(vcpu)))
> +	if (unlikely(vcpu_is_protected_pkvm(vcpu)))
>   		return pvm_exit_handlers;
>   
>   	return hyp_exit_handlers;
> @@ -259,7 +259,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>   	 * it.  The check below is based on the one in
>   	 * kvm_arch_vcpu_ioctl_run().
>   	 */
> -	if (unlikely(vcpu_is_protected(vcpu) && vcpu_mode_is_32bit(vcpu))) {
> +	if (unlikely(vcpu_is_protected_pkvm(vcpu) && vcpu_mode_is_32bit(vcpu))) {
>   		/*
>   		 * As we have caught the guest red-handed, decide that it isn't
>   		 * fit for purpose anymore by making the vcpu invalid. The VMM
> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> index 993065716913..17bd1ff621ab 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> @@ -48,7 +48,7 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
>   	 * or running a protected VM (we don't offset anything in this case).
>   	 */
>   	clr = CNTHCTL_EL1PCEN;
> -	if (vcpu_is_protected(vcpu) ||
> +	if (vcpu_is_protected_pkvm(vcpu) ||
>   	    !timer_get_offset(vcpu_ptimer(vcpu)))
>   		set |= CNTHCTL_EL1PCTEN;
>   	else
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db7..34ddcb2f094a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2814,17 +2814,17 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   	hva_t hva, reg_end;
>   	int ret = 0;
>   
> -	if (kvm_vm_is_protected(kvm)) {
> +	if (kvm_vm_is_protected(kvm) && new &&
> +	    (new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)))
> +		return -EPERM;
> +
> +	if (kvm->arch.vm_flavor == VM_PROTECTED_PKVM) {
>   		/* Cannot modify memslots once a pVM has run. */
>   		if (pkvm_hyp_vm_is_created(kvm) &&
>   		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
>   			return -EPERM;
>   		}
>   
> -		if (new &&
> -		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
> -			return -EPERM;
> -		}
>   	}

May be the above could be a preparatory patch or add the changes common
for Realm and pVM when we come to do the memslot for Realms ?

>   
>   	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
> @@ -3158,13 +3158,14 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
>   };
>   
>   #define KVM_VM_S2_OPS(flavor, ops)		\
> -		[(flavor)] = &(ops)
> +		[flavor] = &(ops)

Spurious, unwanted change. Please drop this ^^

>   
>   static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
>   	KVM_VM_S2_OPS(VM_VHE, kvm_default_vm_s2_ops),
>   	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
>   	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
>   	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
> +	[VM_REALM] = NULL,
>   };
>   
>   static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> new file mode 100644
> index 000000000000..5ecc8b349869
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

Even this could be delayed to the end ? and this can be an empty stub 
for now.
> +
> +	/* TODO: Check if the RMI is available */
> +
> +	/* Future patch will enable static branch kvm_rmi_is_available */

Suzuki

