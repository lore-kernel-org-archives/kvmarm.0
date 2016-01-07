From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v8 02/20] KVM: ARM64: Define PMU data structure for each
 vcpu
Date: Thu, 7 Jan 2016 20:07:49 +0100
Message-ID: <20160107190749.GG6199@hawk.localdomain>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-3-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450771695-11948-3-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 22, 2015 at 04:07:57PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Here we plan to support virtual PMU for guest by full software
> emulation, so define some basic structs and functions preparing for
> futher steps. Define struct kvm_pmc for performance monitor counter and
> struct kvm_pmu for performance monitor unit for each vcpu. According to
> ARMv8 spec, the PMU contains at most 32(ARMV8_MAX_COUNTERS) counters.
> 
> Since this only supports ARM64 (or PMUv3), add a separate config symbol
> for it.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/Kconfig            |  7 +++++++
>  include/kvm/arm_pmu.h             | 42 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 51 insertions(+)
>  create mode 100644 include/kvm/arm_pmu.h
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 689d4c9..6f0241f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -36,6 +36,7 @@
>  
>  #include <kvm/arm_vgic.h>
>  #include <kvm/arm_arch_timer.h>
> +#include <kvm/arm_pmu.h>
>  
>  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>  
> @@ -211,6 +212,7 @@ struct kvm_vcpu_arch {
>  	/* VGIC state */
>  	struct vgic_cpu vgic_cpu;
>  	struct arch_timer_cpu timer_cpu;
> +	struct kvm_pmu pmu;
>  
>  	/*
>  	 * Anything that is not used directly from assembly code goes
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index a5272c0..de7450d 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -36,6 +36,7 @@ config KVM
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
>  	select KVM_ARM_VGIC_V3
> +	select KVM_ARM_PMU if HW_PERF_EVENTS
>  	---help---
>  	  Support hosting virtualized guest machines.
>  	  We don't support KVM with 16K page tables yet, due to the multiple
> @@ -48,6 +49,12 @@ config KVM_ARM_HOST
>  	---help---
>  	  Provides host support for ARM processors.
>  
> +config KVM_ARM_PMU
> +	bool
> +	---help---
> +	  Adds support for a virtual Performance Monitoring Unit (PMU) in
> +	  virtual machines.
> +
>  source drivers/vhost/Kconfig
>  
>  endif # VIRTUALIZATION
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> new file mode 100644
> index 0000000..ddcb5b2
> --- /dev/null
> +++ b/include/kvm/arm_pmu.h
> @@ -0,0 +1,42 @@
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
> +#ifdef CONFIG_KVM_ARM_PMU
> +
> +#include <linux/perf_event.h>
> +#include <asm/pmu.h>
> +
> +struct kvm_pmc {
> +	u8 idx;/* index into the pmu->pmc array */
> +	struct perf_event *perf_event;
> +	u64 bitmask;
> +};
> +
> +struct kvm_pmu {
> +	/* PMU IRQ Number per VCPU */

This whole structure is per vcpu, so I find the above comment
unnecessary, and even a bit confusing.

> +	int irq_num;
> +	struct kvm_pmc pmc[ARMV8_MAX_COUNTERS];
> +};
> +#else
> +struct kvm_pmu {
> +};
> +#endif
> +
> +#endif
> -- 
> 2.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
