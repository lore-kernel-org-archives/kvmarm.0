From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 02/18] KVM: ARM64: Add initial support for PMU
Date: Thu, 16 Jul 2015 20:25:53 +0200
Message-ID: <20150716182553.GB14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-3-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436149068-3784-3-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: shannon.zhao@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 10:17:32AM +0800, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Here we plan to support virtual PMU for guest by full software
> emulation, so define some basic structs and functions preparing for
> futher steps. Define struct kvm_pmc for performance monitor counter and
> struct kvm_pmu for performance monitor unit for each vcpu. According to
> ARMv8 spec, the PMU contains at most 32(ARMV8_MAX_COUNTERS) counters.
> Initialize PMU for each vcpu when kvm initialize vcpus, while reset PMU
> when kvm reset vcpus.
> Since this only supports ARM64 (or PMUv3), add a separate config symbol
> for it.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm/kvm/arm.c                |  4 +++
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/include/asm/pmu.h      |  2 ++
>  arch/arm64/kvm/Kconfig            |  7 +++++
>  arch/arm64/kvm/Makefile           |  1 +
>  arch/arm64/kvm/reset.c            |  3 +++
>  include/kvm/arm_pmu.h             | 54 ++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/pmu.c                | 55 +++++++++++++++++++++++++++++++++++++++
>  8 files changed, 128 insertions(+)
>  create mode 100644 include/kvm/arm_pmu.h
>  create mode 100644 virt/kvm/arm/pmu.c
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index bc738d2..4e82625 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -28,6 +28,7 @@
>  #include <linux/sched.h>
>  #include <linux/kvm.h>
>  #include <trace/events/kvm.h>
> +#include <kvm/arm_pmu.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
> @@ -278,6 +279,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  	/* Set up the timer */
>  	kvm_timer_vcpu_init(vcpu);
>  
> +	/* Set up the PMU */
> +	kvm_pmu_init(vcpu);
> +
>  	return 0;
>  }
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2709db2..3c88873 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -42,6 +42,7 @@
>  
>  #include <kvm/arm_vgic.h>
>  #include <kvm/arm_arch_timer.h>
> +#include <kvm/arm_pmu.h>
>  
>  #define KVM_VCPU_MAX_FEATURES 3
>  
> @@ -116,6 +117,7 @@ struct kvm_vcpu_arch {
>  	/* VGIC state */
>  	struct vgic_cpu vgic_cpu;
>  	struct arch_timer_cpu timer_cpu;
> +	struct kvm_pmu pmu;
>  
>  	/*
>  	 * Anything that is not used directly from assembly code goes
> diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
> index b9f394a..95681e6 100644
> --- a/arch/arm64/include/asm/pmu.h
> +++ b/arch/arm64/include/asm/pmu.h
> @@ -19,6 +19,8 @@
>  #ifndef __ASM_PMU_H
>  #define __ASM_PMU_H
>  
> +#include <linux/perf_event.h>
> +
>  #define ARMV8_MAX_COUNTERS      32
>  #define ARMV8_COUNTER_MASK      (ARMV8_MAX_COUNTERS - 1)
>  
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index bfffe8f..eae3a1b 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -31,6 +31,7 @@ config KVM
>  	select KVM_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
> +	select KVM_ARM_PMU
>  	---help---
>  	  Support hosting virtualized guest machines.
>  
> @@ -52,4 +53,10 @@ config KVM_ARM_MAX_VCPUS
>  	  large, so only choose a reasonable number that you expect to
>  	  actually use.
>  
> +config KVM_ARM_PMU
> +	bool
> +	depends on KVM_ARM_HOST
> +	---help---
> +	  Adds support for the Performance Monitoring in virtual machines.

Adds support for a virtual Performance Monitoring Unit (PMU) in virtual
machines.

> +
>  endif # VIRTUALIZATION
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index f90f4aa..78db4ee 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -27,3 +27,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v3-switch.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
> +kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 0b43265..ee2c2e9 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -107,5 +107,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	/* Reset timer */
>  	kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
>  
> +	/* Reset PMU */
> +	kvm_pmu_vcpu_reset(vcpu);
> +
>  	return 0;
>  }
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> new file mode 100644
> index 0000000..27d14ca
> --- /dev/null
> +++ b/include/kvm/arm_pmu.h
> @@ -0,0 +1,54 @@
> +/*
> + * Copyright (C) 2015 Linaro Ltd.
> + * Author: Shannon Zhao <shannon.zhao@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __ASM_ARM_KVM_PMU_H
> +#define __ASM_ARM_KVM_PMU_H
> +
> +#include <asm/pmu.h>
> +#include <linux/irq_work.h>
> +
> +struct kvm_pmc {
> +	u8 idx;

which index is this?  Does it map to something architecturally or is it
just the array index number?

> +	u64 counter;
> +	u64 eventsel;

does this map to PMEVTYPER<n>_EL0.evtCount?

> +	bool interrupt;

is this that an interrupt which is pending or which is enabled?

> +	bool enable;
> +	struct perf_event *perf_event;
> +	struct kvm_vcpu *vcpu;
> +};
> +
> +struct kvm_pmu {
> +#ifdef CONFIG_KVM_ARM_PMU
> +	/* PMU IRQ Number per VCPU */
> +	int irq_num;
> +	int overflow_status;
> +	/* IRQ pending flag */
> +	bool irq_pending;
> +	struct irq_work irq_work;
> +	struct kvm_pmc pmc[ARMV8_MAX_COUNTERS];
> +#endif
> +};
> +
> +#ifdef CONFIG_KVM_ARM_PMU
> +void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
> +void kvm_pmu_init(struct kvm_vcpu *vcpu);
> +#else
> +static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_pmu_init(struct kvm_vcpu *vcpu) {}
> +#endif
> +
> +#endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> new file mode 100644
> index 0000000..dc252d0
> --- /dev/null
> +++ b/virt/kvm/arm/pmu.c
> @@ -0,0 +1,55 @@
> +/*
> + * Copyright (C) 2015 Linaro Ltd.
> + * Author: Shannon Zhao <shannon.zhao@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/cpu.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <kvm/arm_pmu.h>
> +
> +/**
> + * kvm_pmu_vcpu_reset - reset pmu state for cpu
> + * @vcpu: The vcpu pointer
> + *
> + */
> +void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +
> +	pmu->irq_pending = false;
> +}
> +
> +/**
> + * kvm_pmu_init - Initialize global PMU state for per vcpu

how is this both global and per VCPU?

> + * @vcpu: The vcpu pointer
> + *
> + * Initialize PMC and Set all the PMU IRQ numbers to invalid

s/Set/set/

> + * value so that user space has to explicitly provide PMU
> + * IRQ numbers using set device address ioctl.
> + */
> +void kvm_pmu_init(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +
> +	memset(pmu, 0, sizeof(*pmu));
> +	for (i = 0; i < ARMV8_MAX_COUNTERS; i++) {
> +		pmu->pmc[i].idx = i;
> +		pmu->pmc[i].vcpu = vcpu;
> +	}
> +
> +	pmu->irq_num = -1;
> +}
> -- 
> 2.1.0
> 
