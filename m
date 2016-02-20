From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v11 16/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Sat, 20 Feb 2016 21:32:05 +0800
Message-ID: <56C86AD5.5080702@linaro.org>
References: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com>
 <1454656456-11640-17-git-send-email-zhaoshenglong@huawei.com>
 <20160208122643.GD620@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3602C49692
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Feb 2016 08:25:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MZFeGTB9ZV2O for <kvmarm@lists.cs.columbia.edu>;
 Sat, 20 Feb 2016 08:25:45 -0500 (EST)
Received: from mail-pf0-f169.google.com (mail-pf0-f169.google.com
 [209.85.192.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF4B44968B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Feb 2016 08:25:44 -0500 (EST)
Received: by mail-pf0-f169.google.com with SMTP id x65so66854945pfb.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Feb 2016 05:32:14 -0800 (PST)
In-Reply-To: <20160208122643.GD620@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/2/8 20:26, Christoffer Dall wrote:
> On Fri, Feb 05, 2016 at 03:14:11PM +0800, Shannon Zhao wrote:
>> >From: Shannon Zhao<shannon.zhao@linaro.org>
>> >
>> >When calling perf_event_create_kernel_counter to create perf_event,
>> >assign a overflow handler. Then when the perf event overflows, set the
>> >corresponding bit of guest PMOVSSET register. If this counter is enabled
>> >and its interrupt is enabled as well, kick the vcpu to sync the
>> >interrupt.
>> >
>> >On VM entry, if there is counter overflowed, inject the interrupt with
>> >the level set to 1. Otherwise, inject the interrupt with the level set
>> >to 0.
>> >
>> >Signed-off-by: Shannon Zhao<shannon.zhao@linaro.org>
>> >Reviewed-by: Marc Zyngier<marc.zyngier@arm.com>
>> >Reviewed-by: Andrew Jones<drjones@redhat.com>
>> >---
>> >  arch/arm/kvm/arm.c    |  2 ++
>> >  include/kvm/arm_pmu.h |  2 ++
>> >  virt/kvm/arm/pmu.c    | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
>> >  3 files changed, 53 insertions(+), 1 deletion(-)
>> >
>> >diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> >index dda1959..f54264c 100644
>> >--- a/arch/arm/kvm/arm.c
>> >+++ b/arch/arm/kvm/arm.c
>> >@@ -28,6 +28,7 @@
>> >  #include <linux/sched.h>
>> >  #include <linux/kvm.h>
>> >  #include <trace/events/kvm.h>
>> >+#include <kvm/arm_pmu.h>
>> >
>> >  #define CREATE_TRACE_POINTS
>> >  #include "trace.h"
>> >@@ -577,6 +578,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> >  		 * non-preemptible context.
>> >  		 */
>> >  		preempt_disable();
>> >+		kvm_pmu_flush_hwstate(vcpu);
>> >  		kvm_timer_flush_hwstate(vcpu);
>> >  		kvm_vgic_flush_hwstate(vcpu);
>> >
>> >diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> >index 1f4bfa2..44a3c75 100644
>> >--- a/include/kvm/arm_pmu.h
>> >+++ b/include/kvm/arm_pmu.h
>> >@@ -44,6 +44,7 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
>> >  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
>> >  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
>> >  void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
>> >+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
>> >  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
>> >  void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>> >  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>> >@@ -67,6 +68,7 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>> >  static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>> >  static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
>> >  static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
>> >+static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
>> >  static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
>> >  static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
>> >  static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
>> >diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> >index c8ea825..5f983cb 100644
>> >--- a/virt/kvm/arm/pmu.c
>> >+++ b/virt/kvm/arm/pmu.c
>> >@@ -21,6 +21,7 @@
>> >  #include <linux/perf_event.h>
>> >  #include <asm/kvm_emulate.h>
>> >  #include <kvm/arm_pmu.h>
>> >+#include <kvm/arm_vgic.h>
>> >
>> >  /**
>> >   * kvm_pmu_get_counter_value - get PMU counter value
>> >@@ -180,6 +181,52 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
>> >  }
>> >
>> >  /**
>> >+ * kvm_pmu_flush_hwstate - flush pmu state to cpu
>> >+ * @vcpu: The vcpu pointer
>> >+ *
>> >+ * Inject virtual PMU IRQ if IRQ is pending for this cpu.
>> >+ */
>> >+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
>> >+{
>> >+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> >+	u64 overflow;
>> >+
>> >+	if (!kvm_arm_pmu_v3_ready(vcpu))
>> >+		return;
>> >+
>> >+	if (!(vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E))
>> >+		return;
> are we modeling the PMU interrupt as level-triggered?
>
Yes.
> In that case, shouldn't we lower the interrupt line on flush when
> PMCR_EL0.E == 0 ?
We inject the interrupt only based on the value of PMOVSSET. There might 
be a case that PMCR_EL0.E is 0 and PMOVSSET is not zero. In this case it 
should pull up the interrupt line.

-- 
Shannon
