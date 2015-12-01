From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Tue, 1 Dec 2015 22:35:13 +0800
Message-ID: <565DB021.3020901@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-19-git-send-email-zhaoshenglong@huawei.com>
 <20151130182258.684c9df6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 924794995C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 09:39:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PrCqmDK41lB4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 09:39:45 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A7C849A00
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 09:39:43 -0500 (EST)
In-Reply-To: <20151130182258.684c9df6@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, shannon.zhao@linaro.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/1 2:22, Marc Zyngier wrote:
> On Fri, 30 Oct 2015 14:22:00 +0800
> Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> 
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> When calling perf_event_create_kernel_counter to create perf_event,
>> assign a overflow handler. Then when perf event overflows, set
>> irq_pending and call kvm_vcpu_kick() to sync the interrupt.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  arch/arm/kvm/arm.c    |  4 +++
>>  include/kvm/arm_pmu.h |  4 +++
>>  virt/kvm/arm/pmu.c    | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 83 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 78b2869..9c0fec4 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/sched.h>
>>  #include <linux/kvm.h>
>>  #include <trace/events/kvm.h>
>> +#include <kvm/arm_pmu.h>
>>  
>>  #define CREATE_TRACE_POINTS
>>  #include "trace.h"
>> @@ -551,6 +552,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  
>>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
>>  			local_irq_enable();
>> +			kvm_pmu_sync_hwstate(vcpu);
> 
> This is very weird. Are you only injecting interrupts when a signal is
> pending? I don't understand how this works...
> 
>>  			kvm_vgic_sync_hwstate(vcpu);
>>  			preempt_enable();
>>  			kvm_timer_sync_hwstate(vcpu);
>> @@ -598,6 +600,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  		kvm_guest_exit();
>>  		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
>>  
>> +		kvm_pmu_post_sync_hwstate(vcpu);
>> +
>>  		kvm_vgic_sync_hwstate(vcpu);
>>  
>>  		preempt_enable();
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index acd025a..5e7f943 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -39,6 +39,8 @@ struct kvm_pmu {
>>  };
>>  
>>  #ifdef CONFIG_KVM_ARM_PMU
>> +void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
>> +void kvm_pmu_post_sync_hwstate(struct kvm_vcpu *vcpu);
> 
> Please follow the current terminology: _flush_ on VM entry, _sync_ on
> VM exit.
> 

Hi Marc,

Is below patch the right way for this?

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 78b2869..84008d1 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/kvm.h>
 #include <trace/events/kvm.h>
+#include <kvm/arm_pmu.h>

 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -531,6 +532,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu,
struct kvm_run *run)
                 */
                kvm_timer_flush_hwstate(vcpu);

+               kvm_pmu_flush_hwstate(vcpu);
+
                /*
                 * Preparing the interrupts to be injected also
                 * involves poking the GIC, which must be done in a
@@ -554,6 +557,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu,
struct kvm_run *run)
                        kvm_vgic_sync_hwstate(vcpu);
                        preempt_enable();
                        kvm_timer_sync_hwstate(vcpu);
+                       kvm_pmu_sync_hwstate(vcpu);
                        continue;
                }

@@ -604,6 +608,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu,
struct kvm_run *run)

                kvm_timer_sync_hwstate(vcpu);

+               kvm_pmu_sync_hwstate(vcpu);
+
                ret = handle_exit(vcpu, run, ret);
        }

diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 47bbd43..edfe4e5 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -41,6 +41,8 @@ struct kvm_pmu {
 };

 #ifdef CONFIG_KVM_ARM_PMU
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32
select_idx);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool
all_enable);
@@ -51,6 +53,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu
*vcpu, u32 data,
                                    u32 select_idx);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val);
 #else
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32
select_idx)
 {
        return 0;
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 15cac45..9aad2f7 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -21,6 +21,7 @@
 #include <linux/perf_event.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_vgic.h>

 /**
  * kvm_pmu_get_counter_value - get PMU counter value
@@ -79,6 +80,78 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
 }

 /**
+ * kvm_pmu_flush_hwstate - flush pmu state to cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Inject virtual PMU IRQ if IRQ is pending for this cpu.
+ */
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+       struct kvm_pmu *pmu = &vcpu->arch.pmu;
+       u32 overflow;
+
+       if (!vcpu_mode_is_32bit(vcpu))
+               overflow = vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+       else
+               overflow = vcpu_cp15(vcpu, c9_PMOVSSET);
+
+       if ((pmu->irq_pending || overflow != 0) && (pmu->irq_num != -1))
+               kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
pmu->irq_num, 1);
+
+       pmu->irq_pending = false;
+}
+
+/**
+ * kvm_pmu_sync_hwstate - sync pmu state for cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Inject virtual PMU IRQ if IRQ is pending for this cpu when back from
guest.
+ */
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+       struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+       if (pmu->irq_pending && (pmu->irq_num != -1))
+               kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
pmu->irq_num, 1);
+
+       pmu->irq_pending = false;
+}

-- 
Shannon
