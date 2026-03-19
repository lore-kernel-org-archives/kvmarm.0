Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E893E9F97;
	Thu, 19 Mar 2026 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773938535; cv=none; b=pJRvqyonlqRN+a6zXe7eHQHcnFsyzG1rr1egFDOzbxQJ1tjrX3IuRmyMvoWXAkA3PNE5y0aGLmJodYtvXxWBYBMg+pYLLsauSk0Efcdqv3cbNCVdAvlG5/2a5tkbgnDNnn5HxOUko9g/X3hSHnkddqz7JsrEZDOggxEotd6/YEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773938535; c=relaxed/simple;
	bh=8zVTfTYoZU2NrEdEOC5GKqCbAOSUZ2wAmRkMKL+K5GA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F9d4KQzEwvLMZPhu3MRLmUfCIp5U/bV0QETulF0kLPehm4Gd05jdJuA/eedDKqWdY7myUROClpcyb/xg8gw1SgsN7ywXc9P5vVKy50AQlro+mUF0EphRXDDiaU754/F+ToxkcgTf8OAAbg9K7VXEhhKq3LvS6pHfn/Ye7xImNuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A7BA16F2;
	Thu, 19 Mar 2026 09:42:02 -0700 (PDT)
Received: from [10.1.35.24] (e122027.cambridge.arm.com [10.1.35.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B4D393F7BD;
	Thu, 19 Mar 2026 09:42:02 -0700 (PDT)
Message-ID: <b273e494-456a-4c8f-a552-492fa4b078db@arm.com>
Date: Thu, 19 Mar 2026 16:42:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 07/48] arm64: RMI: Check for RMI support at KVM init
To: Wei-Lin Chang <weilin.chang@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
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
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-8-steven.price@arm.com>
 <yogcawvd7444m6lbk3nz7y57zx6wdxvoxccyaddpkbniug27nw@zdihyc6xvrbx>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yogcawvd7444m6lbk3nz7y57zx6wdxvoxccyaddpkbniug27nw@zdihyc6xvrbx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/03/2026 16:17, Wei-Lin Chang wrote:
> On Wed, Mar 18, 2026 at 03:53:31PM +0000, Steven Price wrote:
>> Query the RMI version number and check if it is a compatible version. A
>> static key is also provided to signal that a supported RMM is available.
>>
>> Functions are provided to query if a VM or VCPU is a realm (or rec)
>> which currently will always return false.
>>
>> Later patches make use of struct realm and the states as the ioctls
>> interfaces are added to support realm and REC creation and destruction.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v12:
>>  * Drop check for 4k page size.
>> Changes since v11:
>>  * Reword slightly the comments on the realm states.
>> Changes since v10:
>>  * kvm_is_realm() no longer has a NULL check.
>>  * Rename from "rme" to "rmi" when referring to the RMM interface.
>>  * Check for RME (hardware) support before probing for RMI support.
>> Changes since v8:
>>  * No need to guard kvm_init_rme() behind 'in_hyp_mode'.
>> Changes since v6:
>>  * Improved message for an unsupported RMI ABI version.
>> Changes since v5:
>>  * Reword "unsupported" message from "host supports" to "we want" to
>>    clarify that 'we' are the 'host'.
>> Changes since v2:
>>  * Drop return value from kvm_init_rme(), it was always 0.
>>  * Rely on the RMM return value to identify whether the RSI ABI is
>>    compatible.
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++
>>  arch/arm64/include/asm/kvm_host.h    |  4 ++
>>  arch/arm64/include/asm/kvm_rmi.h     | 56 +++++++++++++++++++++++++++
>>  arch/arm64/include/asm/virt.h        |  1 +
>>  arch/arm64/kernel/cpufeature.c       |  1 +
>>  arch/arm64/kvm/Makefile              |  2 +-
>>  arch/arm64/kvm/arm.c                 |  5 +++
>>  arch/arm64/kvm/rmi.c                 | 57 ++++++++++++++++++++++++++++
>>  8 files changed, 143 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>>  create mode 100644 arch/arm64/kvm/rmi.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 5bf3d7e1d92c..f38b50151ce8 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -688,4 +688,22 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>>  	}
>>  }
>> +
>> +static inline bool kvm_is_realm(struct kvm *kvm)
>> +{
>> +	if (static_branch_unlikely(&kvm_rmi_is_available))
>> +		return kvm->arch.is_realm;
>> +	return false;
>> +}
>> +
>> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>> +{
>> +	return READ_ONCE(kvm->arch.realm.state);
>> +}
>> +
>> +static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +
> 
> Hi,
> 
> Both kvm_vm_is_protected() and vcpu_is_protected() are in kvm_host.h, do
> you think that's a better place? Or is there a reason for this being in
> kvm_emulate.h?

I've no strong opinions, but as usual there are complications with the
header include order.

kvm_vm_is_protected/vcpu_is_protected are defined in asm/kvm_host.h, but
struct kvm is defined in linux/kvm_host.h (which includes
asm/kvm_host.h). The same is true for struct kvm_vcpu. This means that
we can't have a static inline function using the kvm pointer (because
the struct definition hasn't been reached). The 'solution' in the case
of kvm_vm_is_protected/vcpu_is_protected is to use a macro - which works
but has drawbacks (e.g. lack of type checking).

I'll move them if there's a strong feeling they are in the wrong place,
but to me it feels more like the macros in asm/kvm_host.h are just a
hack to get around them being in the wrong place.

Thanks,
Steve

> Thanks,
> Wei-Lin Chang
> 
>>  #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 5d5a3bbdb95e..9267a2f2d65b 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -27,6 +27,7 @@
>>  #include <asm/fpsimd.h>
>>  #include <asm/kvm.h>
>>  #include <asm/kvm_asm.h>
>> +#include <asm/kvm_rmi.h>
>>  #include <asm/vncr_mapping.h>
>>  
>>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>> @@ -405,6 +406,9 @@ struct kvm_arch {
>>  	 * the associated pKVM instance in the hypervisor.
>>  	 */
>>  	struct kvm_protected_vm pkvm;
>> +
>> +	bool is_realm;
>> +	struct realm realm;
>>  };
>>  
>>  struct kvm_vcpu_fault_info {
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> new file mode 100644
>> index 000000000000..3506f50b05cd
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -0,0 +1,56 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2023-2025 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_KVM_RMI_H
>> +#define __ASM_KVM_RMI_H
>> +
>> +/**
>> + * enum realm_state - State of a Realm
>> + */
>> +enum realm_state {
>> +	/**
>> +	 * @REALM_STATE_NONE:
>> +	 *      Realm has not yet been created. rmi_realm_create() has not
>> +	 *      yet been called.
>> +	 */
>> +	REALM_STATE_NONE,
>> +	/**
>> +	 * @REALM_STATE_NEW:
>> +	 *      Realm is under construction, rmi_realm_create() has been
>> +	 *      called, but it is not yet activated. Pages may be populated.
>> +	 */
>> +	REALM_STATE_NEW,
>> +	/**
>> +	 * @REALM_STATE_ACTIVE:
>> +	 *      Realm has been created and is eligible for execution with
>> +	 *      rmi_rec_enter(). Pages may no longer be populated with
>> +	 *      rmi_data_create().
>> +	 */
>> +	REALM_STATE_ACTIVE,
>> +	/**
>> +	 * @REALM_STATE_DYING:
>> +	 *      Realm is in the process of being destroyed or has already been
>> +	 *      destroyed.
>> +	 */
>> +	REALM_STATE_DYING,
>> +	/**
>> +	 * @REALM_STATE_DEAD:
>> +	 *      Realm has been destroyed.
>> +	 */
>> +	REALM_STATE_DEAD
>> +};
>> +
>> +/**
>> + * struct realm - Additional per VM data for a Realm
>> + *
>> + * @state: The lifetime state machine for the realm
>> + */
>> +struct realm {
>> +	enum realm_state state;
>> +};
>> +
>> +void kvm_init_rmi(void);
>> +
>> +#endif /* __ASM_KVM_RMI_H */
>> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
>> index b51ab6840f9c..dc9b2899e0b2 100644
>> --- a/arch/arm64/include/asm/virt.h
>> +++ b/arch/arm64/include/asm/virt.h
>> @@ -87,6 +87,7 @@ void __hyp_reset_vectors(void);
>>  bool is_kvm_arm_initialised(void);
>>  
>>  DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
>> +DECLARE_STATIC_KEY_FALSE(kvm_rmi_is_available);
>>  
>>  static inline bool is_pkvm_initialized(void)
>>  {
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index c31f8e17732a..ddf7e57f23e8 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -289,6 +289,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
>>  static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RME_SHIFT, 4, 0),
>>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_DIT_SHIFT, 4, 0),
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_AMU_SHIFT, 4, 0),
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_MPAM_SHIFT, 4, 0),
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 3ebc0570345c..e17c4077d8e7 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
>>  kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>>  	 inject_fault.o va_layout.o handle_exit.o config.o \
>>  	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
>> -	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
>> +	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o \
>>  	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
>>  	 vgic/vgic.o vgic/vgic-init.o \
>>  	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 29f0326f7e00..274d7866efdc 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -39,6 +39,7 @@
>>  #include <asm/kvm_nested.h>
>>  #include <asm/kvm_pkvm.h>
>>  #include <asm/kvm_ptrauth.h>
>> +#include <asm/kvm_rmi.h>
>>  #include <asm/sections.h>
>>  #include <asm/stacktrace/nvhe.h>
>>  
>> @@ -104,6 +105,8 @@ long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext)
>>  	return -EINVAL;
>>  }
>>  
>> +DEFINE_STATIC_KEY_FALSE(kvm_rmi_is_available);
>> +
>>  DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>>  
>>  DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
>> @@ -2921,6 +2924,8 @@ static __init int kvm_arm_init(void)
>>  
>>  	in_hyp_mode = is_kernel_in_hyp_mode();
>>  
>> +	kvm_init_rmi();
>> +
>>  	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>>  	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>>  		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> new file mode 100644
>> index 000000000000..fac151580c01
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -0,0 +1,57 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2023-2025 ARM Ltd.
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/rmi_cmds.h>
>> +#include <asm/virt.h>
>> +
>> +static int rmi_check_version(void)
>> +{
>> +	struct arm_smccc_res res;
>> +	unsigned short version_major, version_minor;
>> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>> +						     RMI_ABI_MINOR_VERSION);
>> +	unsigned long aa64pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
>> +
>> +	/* If RME isn't supported, then RMI can't be */
>> +	if (cpuid_feature_extract_unsigned_field(aa64pfr0, ID_AA64PFR0_EL1_RME_SHIFT) == 0)
>> +		return -ENXIO;
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
>> +
>> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>> +		return -ENXIO;
>> +
>> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
>> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
>> +
>> +	if (res.a0 != RMI_SUCCESS) {
>> +		unsigned short high_version_major, high_version_minor;
>> +
>> +		high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
>> +		high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
>> +
>> +		kvm_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
>> +			version_major, version_minor,
>> +			high_version_major, high_version_minor,
>> +			RMI_ABI_MAJOR_VERSION,
>> +			RMI_ABI_MINOR_VERSION);
>> +		return -ENXIO;
>> +	}
>> +
>> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
>> +
>> +	return 0;
>> +}
>> +
>> +void kvm_init_rmi(void)
>> +{
>> +	/* Continue without realm support if we can't agree on a version */
>> +	if (rmi_check_version())
>> +		return;
>> +
>> +	/* Future patch will enable static branch kvm_rmi_is_available */
>> +}
>> -- 
>> 2.43.0
>>

