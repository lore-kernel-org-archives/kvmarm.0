Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C800CC43603
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 14:33:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57EA021D7D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 14:33:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57EA021D7D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD96E4A597;
	Tue, 17 Dec 2019 09:33:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XUoDYqd6wOQI; Tue, 17 Dec 2019 09:33:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFFC4A5A3;
	Tue, 17 Dec 2019 09:33:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3CEE4A597
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 09:33:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tB36kJmeztuB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 09:33:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3979E4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 09:33:06 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C68241FB;
 Tue, 17 Dec 2019 06:33:05 -0800 (PST)
Received: from arm.com (e112269-lin.cambridge.arm.com [10.1.196.56])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA7893F67D;
 Tue, 17 Dec 2019 06:33:03 -0800 (PST)
Date: Tue, 17 Dec 2019 14:33:01 +0000
From: Steven Price <steven.price@arm.com>
To: "yezengruan@huawei.com" <yezengruan@huawei.com>
Subject: Re: [PATCH 3/5] KVM: arm64: Support pvlock preempted via shared
 structure
Message-ID: <20191217143301.GC38811@arm.com>
References: <20191217135549.3240-1-yezengruan@huawei.com>
 <20191217135549.3240-4-yezengruan@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191217135549.3240-4-yezengruan@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 Catalin Marinas <Catalin.Marinas@arm.com>,
 "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Tue, Dec 17, 2019 at 01:55:47PM +0000, yezengruan@huawei.com wrote:
> From: Zengruan Ye <yezengruan@huawei.com>
> 
> Implement the service call for configuring a shared structure between a
> vcpu and the hypervisor in which the hypervisor can tell the vcpu is
> running or not.
> 
> The preempted field is zero if 1) some old KVM deos not support this filed.
> 2) the vcpu is not preempted. Other values means the vcpu has been preempted.
> 
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 13 +++++++++++++
>  arch/arm64/include/asm/kvm_host.h | 17 +++++++++++++++++
>  arch/arm64/kvm/Makefile           |  1 +
>  virt/kvm/arm/arm.c                |  8 ++++++++
>  virt/kvm/arm/hypercalls.c         |  4 ++++
>  virt/kvm/arm/pvlock.c             | 21 +++++++++++++++++++++
>  6 files changed, 64 insertions(+)
>  create mode 100644 virt/kvm/arm/pvlock.c
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 556cd818eccf..098375f1c89e 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -356,6 +356,19 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
>  	return false;
>  }
>  
> +static inline void kvm_arm_pvlock_preempted_init(struct kvm_vcpu_arch *vcpu_arch)
> +{
> +}
> +
> +static inline bool kvm_arm_is_pvlock_preempted_ready(struct kvm_vcpu_arch *vcpu_arch)
> +{
> +	return false;
> +}
> +
> +static inline void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
> +{
> +}
> +
>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>  
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c61260cf63c5..d9b2a21a87ac 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -354,6 +354,11 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +
> +	/* Guest PV lock state */
> +	struct {
> +		gpa_t base;
> +	} pv;
>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> @@ -515,6 +520,18 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
>  	return (vcpu_arch->steal.base != GPA_INVALID);
>  }
>  
> +static inline void kvm_arm_pvlock_preempted_init(struct kvm_vcpu_arch *vcpu_arch)
> +{
> +	vcpu_arch->pv.base = GPA_INVALID;
> +}
> +
> +static inline bool kvm_arm_is_pvlock_preempted_ready(struct kvm_vcpu_arch *vcpu_arch)
> +{
> +	return (vcpu_arch->pv.base != GPA_INVALID);
> +}
> +
> +void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted);
> +
>  void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
>  
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 5ffbdc39e780..e4591f56d5f1 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -15,6 +15,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hypercalls.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/pvtime.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/pvlock.o
>  
>  kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 12e0280291ce..c562f62fdd45 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -383,6 +383,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
>  
> +	kvm_arm_pvlock_preempted_init(&vcpu->arch);
> +
>  	return kvm_vgic_vcpu_init(vcpu);
>  }
>  
> @@ -421,6 +423,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		vcpu_set_wfx_traps(vcpu);
>  
>  	vcpu_ptrauth_setup_lazy(vcpu);
> +
> +	if (kvm_arm_is_pvlock_preempted_ready(&vcpu->arch))
> +		kvm_update_pvlock_preempted(vcpu, 0);
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -434,6 +439,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	vcpu->cpu = -1;
>  
>  	kvm_arm_set_running_vcpu(NULL);
> +
> +	if (kvm_arm_is_pvlock_preempted_ready(&vcpu->arch))
> +		kvm_update_pvlock_preempted(vcpu, 1);
>  }
>  
>  static void vcpu_power_off(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> index ff13871fd85a..5964982ccd05 100644
> --- a/virt/kvm/arm/hypercalls.c
> +++ b/virt/kvm/arm/hypercalls.c
> @@ -65,6 +65,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  		if (gpa != GPA_INVALID)
>  			val = gpa;
>  		break;
> +	case ARM_SMCCC_HV_PV_LOCK_PREEMPTED:
> +		vcpu->arch.pv.base = smccc_get_arg1(vcpu);
> +		val = SMCCC_RET_SUCCESS;

It would be useful to at least do some basic validation that the address
passed in is valid. Debugging problems with this interface will be hard
if it always returns success even if the address cannot be used.

The second patch also states that the structure should be 64 byte
aligned, but there's nothing here to enforce that.

Steve

> +		break;
>  	default:
>  		return kvm_psci_call(vcpu);
>  	}
> diff --git a/virt/kvm/arm/pvlock.c b/virt/kvm/arm/pvlock.c
> new file mode 100644
> index 000000000000..c3464958b0f5
> --- /dev/null
> +++ b/virt/kvm/arm/pvlock.c
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright(c) 2019 Huawei Technologies Co., Ltd
> + * Author: Zengruan Ye <yezengruan@huawei.com>
> + */
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/kvm_host.h>
> +
> +#include <kvm/arm_hypercalls.h>
> +
> +void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
> +{
> +	u64 preempted_le;
> +	u64 base;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	base = vcpu->arch.pv.base;
> +	preempted_le = cpu_to_le64(preempted);
> +	kvm_put_guest(kvm, base, preempted_le, u64);
> +}
> -- 
> 2.19.1
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
