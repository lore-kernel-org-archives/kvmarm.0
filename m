From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 02/18] KVM: ARM64: Add initial support for PMU
Date: Fri, 17 Jul 2015 14:48:42 +0200
Message-ID: <20150717124842.GO14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-3-git-send-email-shannon.zhao@linaro.org>
 <20150716182553.GB14024@cbox> <55A8B92F.9070706@linaro.org>
 <20150717095807.GK14024@cbox> <55A8E862.6000408@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6627A58C09
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 08:36:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q4Hzk923qmPq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 08:36:30 -0400 (EDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D220058BF8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 08:36:29 -0400 (EDT)
Received: by lagx9 with SMTP id x9so60454357lag.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 05:48:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55A8E862.6000408@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <shannon.zhao@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 17, 2015 at 07:34:58PM +0800, Shannon Zhao wrote:
> 
> 
> On 2015/7/17 17:58, Christoffer Dall wrote:
> >On Fri, Jul 17, 2015 at 04:13:35PM +0800, Shannon Zhao wrote:
> >>
> >>
> >>On 2015/7/17 2:25, Christoffer Dall wrote:
> >>>On Mon, Jul 06, 2015 at 10:17:32AM +0800, shannon.zhao@linaro.org wrote:
> >>>>From: Shannon Zhao <shannon.zhao@linaro.org>
> >>>>
> >>>>Here we plan to support virtual PMU for guest by full software
> >>>>emulation, so define some basic structs and functions preparing for
> >>>>futher steps. Define struct kvm_pmc for performance monitor counter and
> >>>>struct kvm_pmu for performance monitor unit for each vcpu. According to
> >>>>ARMv8 spec, the PMU contains at most 32(ARMV8_MAX_COUNTERS) counters.
> >>>>Initialize PMU for each vcpu when kvm initialize vcpus, while reset PMU
> >>>>when kvm reset vcpus.
> >>>>Since this only supports ARM64 (or PMUv3), add a separate config symbol
> >>>>for it.
> >>>>
> >>>>Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> >>>>---
> >>>>  arch/arm/kvm/arm.c                |  4 +++
> >>>>  arch/arm64/include/asm/kvm_host.h |  2 ++
> >>>>  arch/arm64/include/asm/pmu.h      |  2 ++
> >>>>  arch/arm64/kvm/Kconfig            |  7 +++++
> >>>>  arch/arm64/kvm/Makefile           |  1 +
> >>>>  arch/arm64/kvm/reset.c            |  3 +++
> >>>>  include/kvm/arm_pmu.h             | 54 ++++++++++++++++++++++++++++++++++++++
> >>>>  virt/kvm/arm/pmu.c                | 55 +++++++++++++++++++++++++++++++++++++++
> >>>>  8 files changed, 128 insertions(+)
> >>>>  create mode 100644 include/kvm/arm_pmu.h
> >>>>  create mode 100644 virt/kvm/arm/pmu.c
> >>>>
> >>>>diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >>>>index bc738d2..4e82625 100644
> >>>>--- a/arch/arm/kvm/arm.c
> >>>>+++ b/arch/arm/kvm/arm.c
> >>>>@@ -28,6 +28,7 @@
> >>>>  #include <linux/sched.h>
> >>>>  #include <linux/kvm.h>
> >>>>  #include <trace/events/kvm.h>
> >>>>+#include <kvm/arm_pmu.h>
> >>>>
> >>>>  #define CREATE_TRACE_POINTS
> >>>>  #include "trace.h"
> >>>>@@ -278,6 +279,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> >>>>  	/* Set up the timer */
> >>>>  	kvm_timer_vcpu_init(vcpu);
> >>>>
> >>>>+	/* Set up the PMU */
> >>>>+	kvm_pmu_init(vcpu);
> >>>>+
> >>>>  	return 0;
> >>>>  }
> >>>>
> >>>>diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>>>index 2709db2..3c88873 100644
> >>>>--- a/arch/arm64/include/asm/kvm_host.h
> >>>>+++ b/arch/arm64/include/asm/kvm_host.h
> >>>>@@ -42,6 +42,7 @@
> >>>>
> >>>>  #include <kvm/arm_vgic.h>
> >>>>  #include <kvm/arm_arch_timer.h>
> >>>>+#include <kvm/arm_pmu.h>
> >>>>
> >>>>  #define KVM_VCPU_MAX_FEATURES 3
> >>>>
> >>>>@@ -116,6 +117,7 @@ struct kvm_vcpu_arch {
> >>>>  	/* VGIC state */
> >>>>  	struct vgic_cpu vgic_cpu;
> >>>>  	struct arch_timer_cpu timer_cpu;
> >>>>+	struct kvm_pmu pmu;
> >>>>
> >>>>  	/*
> >>>>  	 * Anything that is not used directly from assembly code goes
> >>>>diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
> >>>>index b9f394a..95681e6 100644
> >>>>--- a/arch/arm64/include/asm/pmu.h
> >>>>+++ b/arch/arm64/include/asm/pmu.h
> >>>>@@ -19,6 +19,8 @@
> >>>>  #ifndef __ASM_PMU_H
> >>>>  #define __ASM_PMU_H
> >>>>
> >>>>+#include <linux/perf_event.h>
> >>>>+
> >>>>  #define ARMV8_MAX_COUNTERS      32
> >>>>  #define ARMV8_COUNTER_MASK      (ARMV8_MAX_COUNTERS - 1)
> >>>>
> >>>>diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> >>>>index bfffe8f..eae3a1b 100644
> >>>>--- a/arch/arm64/kvm/Kconfig
> >>>>+++ b/arch/arm64/kvm/Kconfig
> >>>>@@ -31,6 +31,7 @@ config KVM
> >>>>  	select KVM_VFIO
> >>>>  	select HAVE_KVM_EVENTFD
> >>>>  	select HAVE_KVM_IRQFD
> >>>>+	select KVM_ARM_PMU
> >>>>  	---help---
> >>>>  	  Support hosting virtualized guest machines.
> >>>>
> >>>>@@ -52,4 +53,10 @@ config KVM_ARM_MAX_VCPUS
> >>>>  	  large, so only choose a reasonable number that you expect to
> >>>>  	  actually use.
> >>>>
> >>>>+config KVM_ARM_PMU
> >>>>+	bool
> >>>>+	depends on KVM_ARM_HOST
> >>>>+	---help---
> >>>>+	  Adds support for the Performance Monitoring in virtual machines.
> >>>
> >>>Adds support for a virtual Performance Monitoring Unit (PMU) in virtual
> >>>machines.
> >>>
> >>>>+
> >>>>  endif # VIRTUALIZATION
> >>>>diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> >>>>index f90f4aa..78db4ee 100644
> >>>>--- a/arch/arm64/kvm/Makefile
> >>>>+++ b/arch/arm64/kvm/Makefile
> >>>>@@ -27,3 +27,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
> >>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
> >>>>  kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v3-switch.o
> >>>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
> >>>>+kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> >>>>diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> >>>>index 0b43265..ee2c2e9 100644
> >>>>--- a/arch/arm64/kvm/reset.c
> >>>>+++ b/arch/arm64/kvm/reset.c
> >>>>@@ -107,5 +107,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >>>>  	/* Reset timer */
> >>>>  	kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
> >>>>
> >>>>+	/* Reset PMU */
> >>>>+	kvm_pmu_vcpu_reset(vcpu);
> >>>>+
> >>>>  	return 0;
> >>>>  }
> >>>>diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> >>>>new file mode 100644
> >>>>index 0000000..27d14ca
> >>>>--- /dev/null
> >>>>+++ b/include/kvm/arm_pmu.h
> >>>>@@ -0,0 +1,54 @@
> >>>>+/*
> >>>>+ * Copyright (C) 2015 Linaro Ltd.
> >>>>+ * Author: Shannon Zhao <shannon.zhao@linaro.org>
> >>>>+ *
> >>>>+ * This program is free software; you can redistribute it and/or modify
> >>>>+ * it under the terms of the GNU General Public License version 2 as
> >>>>+ * published by the Free Software Foundation.
> >>>>+ *
> >>>>+ * This program is distributed in the hope that it will be useful,
> >>>>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>>+ * GNU General Public License for more details.
> >>>>+ *
> >>>>+ * You should have received a copy of the GNU General Public License
> >>>>+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> >>>>+ */
> >>>>+
> >>>>+#ifndef __ASM_ARM_KVM_PMU_H
> >>>>+#define __ASM_ARM_KVM_PMU_H
> >>>>+
> >>>>+#include <asm/pmu.h>
> >>>>+#include <linux/irq_work.h>
> >>>>+
> >>>>+struct kvm_pmc {
> >>>>+	u8 idx;
> >>>
> >>>which index is this?  Does it map to something architecturally or is it
> >>>just the array index number?
> >>>
> >>
> >>It's the index of the PMU counter.
> >>
> >
> >sorry, I don't feel this answers my question? ;)
> >
> 
> This index is only used for kvm_pmu_perf_overflow to locate the
> index of this PMU counter and kvm_pmu_perf_overflow will set the
> corresponding bit of overflow_status to show whether this counter
> overflows.
> 
> See patch 17/18:
> 
> +static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> +				  struct perf_sample_data *data,
> +				  struct pt_regs *regs)
> +{
> +	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> +	struct kvm_vcpu *vcpu = pmc->vcpu;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +
> +	if (pmc->interrupt == true) {
> +		__set_bit(pmc->idx, (unsigned long *)&pmu->overflow_status);
> 
> >>>>+	u64 counter;
> >>>>+	u64 eventsel;
> >>>
> >>>does this map to PMEVTYPER<n>_EL0.evtCount?
> >>>
> >>No, it just stores the event type.
> >>
> >
> >can you specify more clearly what this maps to/how I derive its meaning?
> >
> >Is this a perf (Linux) event type number, or an architecturally defined
> >thing?
> >
> 
> Yes, it stores a perf event type number. This is used for
> kvm_pmu_set_counter_event_type to check whether event type of this
> time is same with the previous one. If they are same, it will return
> and doesn't create a new perf event for it and just reuses the
> previous one.
> 
> See PATCH 07/18:
> 
> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned
> long data,
> +				    unsigned long select_idx)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +	struct perf_event *event;
> +	struct perf_event_attr attr;
> +	unsigned config, type = PERF_TYPE_RAW;
> +
> +	if ((data & ARMV8_EVTYPE_EVENT) == pmc->eventsel)
> +		return;
> 

ok, thanks for the explanation of both:

I think it would be helpful, especially for the review, to have a
one-line comment on the struct definition, along the lines of:


struct kvm_pmc {
	u8 idx;		/* index into the pmu->pmc array */
	u64 eventsel;	/* perf event number, see ARMV8_EVTYPE_EVENT */
	...
};

Thanks,
-Christoffer
