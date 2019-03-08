From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v11 3/8] arm64: KVM: add accessors to track guest/host
 only counters
Date: Fri, 8 Mar 2019 16:40:51 +0000
Message-ID: <0158cabe-21bc-ee1d-d281-421ce4a94fef@arm.com>
References: <20190308120746.56897-1-andrew.murray@arm.com>
 <20190308120746.56897-4-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCBC54A4A4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Mar 2019 11:41:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lsgeoUAZMmRz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Mar 2019 11:40:59 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 763B04A47D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Mar 2019 11:40:59 -0500 (EST)
In-Reply-To: <20190308120746.56897-4-andrew.murray@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 08/03/2019 12:07, Andrew Murray wrote:
> In order to effeciently switch events_{guest,host} perf counters at
> guest entry/exit we add bitfields to kvm_cpu_context for guest and host
> events as well as accessors for updating them.
> 
> A function is also provided which allows the PMU driver to determine
> if a counter should start counting when it is enabled. With exclude_host,
> events on !VHE we may only start counting when entering the guest.
> 

I might have missed something here. Why is that true only for !VHE? Is
it because with VHE we can just exclude EL1?
(It's also a bit confusing since the patch does not seem to contain any
VHE/nVHE distinction)

> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 17 +++++++++++
>  arch/arm64/kvm/Makefile           |  2 +-
>  arch/arm64/kvm/pmu.c              | 49 +++++++++++++++++++++++++++++++
>  3 files changed, 67 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/pmu.c
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1d36619d6650..4b7219128f2d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -207,8 +207,14 @@ struct kvm_cpu_context {
>  	struct kvm_vcpu *__hyp_running_vcpu;
>  };
>  
> +struct kvm_pmu_events {
> +	u32 events_host;
> +	u32 events_guest;
> +};
> +
>  struct kvm_host_data {
>  	struct kvm_cpu_context host_ctxt;
> +	struct kvm_pmu_events pmu_events;
>  };
>  
>  typedef struct kvm_host_data kvm_host_data_t;
> @@ -479,11 +485,22 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
>  
> +static inline bool kvm_pmu_counter_defered(struct perf_event_attr *attr)
> +{
> +	return attr->exclude_host;
> +}
> +
>  #ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
>  static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  {
>  	return kvm_arch_vcpu_run_map_fp(vcpu);
>  }
> +
> +void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
> +void kvm_clr_pmu_events(u32 clr);
> +#else
> +static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
> +static inline void kvm_clr_pmu_events(u32 clr) {}
>  #endif
>  
>  static inline void kvm_arm_vhe_guest_enter(void)
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 0f2a135ba15b..f34cb49b66ae 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -19,7 +19,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o pmu.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
>  
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> new file mode 100644
> index 000000000000..43965a3cc0f4
> --- /dev/null
> +++ b/arch/arm64/kvm/pmu.c
> @@ -0,0 +1,49 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * arch/arm64/kvm/pmu.c: Switching between guest and host counters
> + *
> + * Copyright 2019 Arm Limited
> + * Author: Andrew Murray <Andrew.Murray@arm.com>
> + */
> +#include <linux/kvm_host.h>
> +#include <linux/perf_event.h>
> +
> +DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
> +
> +/*
> + * Given the exclude_{host,guest} attributes, determine if we are going
> + * to need to switch counters at guest entry/exit.
> + */
> +static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
> +{
> +	/* Only switch if attributes are different */
> +	return (attr->exclude_host ^ attr->exclude_guest);

Nit:

Is there any benefit to this rather than doing "attr->exclude_host !=
attr->exclude_guest" ? The code generated is most likely the same, I
just find the latter slightly more straightforward.

Cheers,

-- 
Julien Thierry
