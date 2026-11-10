Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.36.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794310979;
	b=WrJGrLBDgFA30RTdAgZS9xfUm3l4ZjPHysFVr7HifoPoMbRV5AyCjaoNV1noSmxvYqpw
	 TgRvmn8690YVhZu4vMZ7Qg1lJ5YbB3tHG2BbEL/P64EZ9m2NAagXWwkjt9tsjIsdIjQ06
	 zCPcVVCcD3c+3pBk62Zykp+yvZkby27JB+FRAiqC+zvFtdeCboSsTfje1g02/EoXBX5ic
	 MbMUS9N62Z5KL5Ll4UkJI+RGAEGC3hMTWYhzsIePQQZvv5+HukRmCi5ClWTkMJcm8uQUR
	 1vwl6LNwaHJCIo0JPNc03VfTPrV4Q2vVtIaliiqVqAoe5nQxfGWJw8ta5wgZduX9KAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794310979;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=UDfjj6f+4UQA+nIrJmQDTbohlU8B0SuA2IAGCHYP12U=;
	b=3pgpf2yu0acY3CtDswj5ZvG/lcvpRyeGZZnSJ56u4H320bDfW07j/OwdEQvYfaAkHXUY
	 waqTbvwLVQUfKOKm9RIshaQ0QevUd7n3DZgvg0WXMOQ/MjZv1vhM6/61H0wHNmn8vgFhQ
	 rfrfbFkHs+hdTvTCeNMoaMTlTKjMUc22Ji9GL2IFzfjf7OEnQ8ihjOJnCwRGzoMDBpDKj
	 HZ3uBrD1zHYCs6FevBWgRqv6XffT7gPbjkTe4Q1sKfJ0UqhqBS81kHSosqgdZsKVHdT0A
	 eP7lbqEzqx+D+F0PaDs2lDldw5dDnIfIsWPkwsXWYUfHMQBMC4YyWZlnn+sVMZHasEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=EtPhqJ26;
	arc=none smtp.remote-ip=139.138.36.225
Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49475606A326;
	Tue, 10 Nov 2026 11:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49475606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=EtPhqJ26
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1794310986; x=1825846986;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D3SLBgY9fe7hrDb5SERRAgjehrb+Hk8BhBruccWqiF8=;
  b=EtPhqJ262woSGcP1G7/lceHwE1UpToCiYvh+SgTpKISUI7Gezr+NWn3P
   pTf3LW0GPEwS3fnqh+amdurhDflw+SZbpu8+Cc4qYEjGv5prFGe7E8McI
   eNg/XQBsEtlXT2HosP0rMlvcvG966X3GZ/u2m2cVPXuBbFahv6JnBWv7y
   pJr0UYgmIgdAslmxhoauFCcjyCQggEcZ/dL+RpR0GhGO/UUsT0727qRyo
   0HtgZGh7gp/IWHvprmjisp/jPdJ4JGMW1684AlV6tb0NVEAQbWTzPZwfy
   fdQErQElxQVBca9/kkoV+zee7wWiASisEl6y/g3iNyseE/IeU5PK89gmD
   A==;
X-CSE-ConnectionGUID: oV036majSnyRta+OIg9ccA==
X-CSE-MsgGUID: hlRtqgfCSZSIHnOrrTZwFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="247475807"
X-IronPort-AV: E=Sophos;i="6.27,205,1786978800"; 
   d="scan'208";a="247475807"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 20:42:58 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 1AFC84274;
	Tue, 10 Nov 2026 11:42:51 +0000 (UTC)
Received: from az2nlsmom1.o.css.fujitsu.com (unknown [10.150.26.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id C5F721C00101;
	Tue, 10 Nov 2026 11:42:50 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.61.34])
	by az2nlsmom1.o.css.fujitsu.com (Postfix) with SMTP id 6AF96829EC7;
	Tue, 10 Nov 2026 11:42:40 +0000 (UTC)
Date: Tue, 10 Nov 2026 20:42:38 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH 02/11] KVM: arm64: CCA: Introduce Realms
Message-ID: <avL9kNR2mGmqmcA9@FCCLS0092175.localdomain>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-3-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261102141304.126883-3-steven.price@arm.com>

Hi Steve,

On 11/02 14:12, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Add foundational work for supporting Realms.
>  - Add a new VM flavor.
>  - At KVM init, check if the KVM can support Realms (though not functional
>    yet) and will be advertised by static key kvm_rmi_is_available. This
>    will be turned on in a later patch, once we have all the bits and
>    pieces ready. For now check if we are blessed with KVM_MODE_RMM.
>  - Add realm specific tracking in kvm_arch. Since Realm and protected pKVM
>    states are mutually exclusive, move them into a union.
>  - Also adjust the memslot preparation checks to reflect the changes.
> 
> Please note that we cannot create Realm VMs yet. This requires further
> changes to the UABI and core RMI driver support, which will come later.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h   | 16 +++++++
>  arch/arm64/include/asm/kvm_host.h      | 57 +++++++++++++++++-------
>  arch/arm64/include/asm/kvm_rmi.h       | 61 ++++++++++++++++++++++++++
>  arch/arm64/include/asm/virt.h          |  1 +
>  arch/arm64/kvm/Makefile                |  2 +-
>  arch/arm64/kvm/arm.c                   | 24 ++++++++--
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c       |  4 +-
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c     |  2 +-
>  arch/arm64/kvm/mmu.c                   | 13 +++---
>  arch/arm64/kvm/rmi.c                   | 18 ++++++++
>  11 files changed, 169 insertions(+), 31 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>  create mode 100644 arch/arm64/kvm/rmi.c
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 334211b8b2ee..32021bdf2610 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -831,4 +831,20 @@ static inline void kvm_reset_vcpu_psci(struct kvm_vcpu *vcpu,
>  	vcpu_set_reg(vcpu, 0, reset_state->r0);
>  }
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
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ccd2dc8f73c3..7d0222047ca1 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -29,6 +29,7 @@
>  #include <asm/kvm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_hcall.h>
> +#include <asm/kvm_rmi.h>
>  #include <asm/vncr_mapping.h>
>  
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -48,6 +49,13 @@
>  #define KVM_VCPU_MAX_FEATURES 10
>  #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
>  
> +#define KVM_REALM_VCPU_VALID_FEATURES			\
> +	(BIT(KVM_ARM_VCPU_POWER_OFF)		|	\
> +	 BIT(KVM_ARM_VCPU_PSCI_0_2)		|	\
> +	 BIT(KVM_ARM_VCPU_PTRAUTH_ADDRESS)	|	\
> +	 BIT(KVM_ARM_VCPU_SVE)			|	\
> +	 BIT(KVM_ARM_VCPU_PTRAUTH_GENERIC))
> +
>  #define KVM_REQ_SLEEP \
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
> @@ -409,6 +417,7 @@ enum kvm_arm_vm_flavor {
>  	VM_PKVM,		/* Normal guests on pKVM */
>  	MARKER(__VM_PROTECTED),
>  	VM_PROTECTED_PKVM,	/* Protected VM */
> +	VM_REALM,		/* CCA */
>  	VM_FLAVOR_MAX
>  };
>  
> @@ -502,11 +511,14 @@ struct kvm_arch {
>  	/* Count the number of VNCR_EL2 TLBs */
>  	atomic_t vncr_tlb_count;
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
>  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>  	/* Nested virtualization info */
> @@ -1572,30 +1584,43 @@ struct kvm *kvm_arch_alloc_vm(void);
>  
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>  
> -#ifdef __KVM_NVHE_HYPERVISOR__
> +#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>  
> -#define kvm_vm_is_protected(kvm)			\
> -	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
> +#ifdef __KVM_NVHE_HYPERVISOR__
>  /*
>   * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
>   * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
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
>   */
> -#define vcpu_is_protected(vcpu)						\
> +#define vcpu_is_protected_pkvm(vcpu)					\
>  	({								\
>  		struct kvm *__kvm = READ_ONCE((vcpu)->kvm);		\
>  									\
> -		(__kvm && kvm_vm_is_protected(__kvm));			\
> +		(__kvm && kvm_vm_is_protected_pkvm(__kvm));		\
>  	})

I've tested the integration branch and found that the secondary CPU
bring-up fails:
    [    1.426502] smp: Bringing up secondary CPUs ...
    [    9.194442] CPU1: failed to come online
    [    9.194558] CPU1: failed in unknown state : 0x0
    [    9.197714] smp: Brought up 1 node, 1 CPU
    [    9.197775] SMP: Total of 1 processors activated.

It seems that this patch missed replacing a use of
vcpu_is_protected() introduced by the following commit:

    25d726dddc23 ("KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off")

The following diff fixes the issue for me. Also, though not included in
the diff, I think vcpu_is_protected() in __pkvm_create_hyp_vcpu() should
be replaced with vcpu_is_protected_pkvm() as well.

Thanks,
Kohei

---8<---
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 522a837637fe..be676c13e219 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -960,7 +960,8 @@ static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu, u32 mp_state)
 /* The guest's own CPU_OFF: EL2 has already powered the vCPU off. */
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-       u32 mp_state = vcpu_is_protected(vcpu) ? KVM_MP_STATE_UNINITIALIZED : KVM_MP_STATE_STOPPED;
+       u32 mp_state = vcpu_is_protected_pkvm(vcpu) ?
+                      KVM_MP_STATE_UNINITIALIZED : KVM_MP_STATE_STOPPED;

        spin_lock(&vcpu->arch.mp_state_lock);
        __kvm_arm_vcpu_power_off(vcpu, mp_state);
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index b01f8d44033f..6674e8d6ff4c 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -68,7 +68,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
         * STOPPED before that is the VMM's pause.
         */
        if (!kvm_arm_vcpu_stopped(vcpu) ||
-           (vcpu_is_protected(vcpu) && !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
+           (vcpu_is_protected_pkvm(vcpu) && !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
                if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
                        ret = PSCI_RET_ALREADY_ON;
                else

