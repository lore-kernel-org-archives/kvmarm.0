From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v7 19/19] KVM: ARM64: Add a new kvm ARM PMU device
Date: Tue, 15 Dec 2015 23:50:54 +0800
Message-ID: <567036DE.80605@linaro.org>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
 <1450169379-12336-20-git-send-email-zhaoshenglong@huawei.com>
 <567032AD.8000206@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D508A411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 10:48:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G8dq+NiF2wJH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2015 10:48:44 -0500 (EST)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
 [209.85.220.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7E6D412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 10:48:44 -0500 (EST)
Received: by mail-pa0-f46.google.com with SMTP id wq6so6710881pac.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 07:51:02 -0800 (PST)
In-Reply-To: <567032AD.8000206@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/15 23:33, Marc Zyngier wrote:
> On 15/12/15 08:49, Shannon Zhao wrote:
>> >From: Shannon Zhao<shannon.zhao@linaro.org>
>> >
>> >Add a new kvm device type KVM_DEV_TYPE_ARM_PMU_V3 for ARM PMU. Implement
>> >the kvm_device_ops for it.
>> >
>> >Signed-off-by: Shannon Zhao<shannon.zhao@linaro.org>
>> >---
>> >  Documentation/virtual/kvm/devices/arm-pmu.txt |  16 ++++
>> >  arch/arm64/include/uapi/asm/kvm.h             |   3 +
>> >  include/linux/kvm_host.h                      |   1 +
>> >  include/uapi/linux/kvm.h                      |   2 +
>> >  virt/kvm/arm/pmu.c                            | 115 ++++++++++++++++++++++++++
>> >  virt/kvm/kvm_main.c                           |   4 +
>> >  6 files changed, 141 insertions(+)
>> >  create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt
>> >
>> >diff --git a/Documentation/virtual/kvm/devices/arm-pmu.txt b/Documentation/virtual/kvm/devices/arm-pmu.txt
>> >new file mode 100644
>> >index 0000000..5121f1f
>> >--- /dev/null
>> >+++ b/Documentation/virtual/kvm/devices/arm-pmu.txt
>> >@@ -0,0 +1,16 @@
>> >+ARM Virtual Performance Monitor Unit (vPMU)
>> >+===========================================
>> >+
>> >+Device types supported:
>> >+  KVM_DEV_TYPE_ARM_PMU_V3         ARM Performance Monitor Unit v3
>> >+
>> >+Instantiate one PMU instance for per VCPU through this API.
>> >+
>> >+Groups:
>> >+  KVM_DEV_ARM_PMU_GRP_IRQ
>> >+  Attributes:
>> >+    A value describing the interrupt number of PMU overflow interrupt. This
>> >+    interrupt should be a PPI.
>> >+
>> >+  Errors:
>> >+    -EINVAL: Value set is out of the expected range (from 16 to 31)
>> >diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> >index 2d4ca4b..568afa2 100644
>> >--- a/arch/arm64/include/uapi/asm/kvm.h
>> >+++ b/arch/arm64/include/uapi/asm/kvm.h
>> >@@ -204,6 +204,9 @@ struct kvm_arch_memory_slot {
>> >  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
>> >  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
>> >
>> >+/* Device Control API: ARM PMU */
>> >+#define KVM_DEV_ARM_PMU_GRP_IRQ		0
>> >+
>> >  /* KVM_IRQ_LINE irq field index values */
>> >  #define KVM_ARM_IRQ_TYPE_SHIFT		24
>> >  #define KVM_ARM_IRQ_TYPE_MASK		0xff
>> >diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> >index c923350..608dea6 100644
>> >--- a/include/linux/kvm_host.h
>> >+++ b/include/linux/kvm_host.h
>> >@@ -1161,6 +1161,7 @@ extern struct kvm_device_ops kvm_mpic_ops;
>> >  extern struct kvm_device_ops kvm_xics_ops;
>> >  extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
>> >  extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
>> >+extern struct kvm_device_ops kvm_arm_pmu_ops;
>> >
>> >  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
>> >
>> >diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> >index 03f3618..4ba6fdd 100644
>> >--- a/include/uapi/linux/kvm.h
>> >+++ b/include/uapi/linux/kvm.h
>> >@@ -1032,6 +1032,8 @@ enum kvm_device_type {
>> >  #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
>> >  	KVM_DEV_TYPE_ARM_VGIC_V3,
>> >  #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
>> >+	KVM_DEV_TYPE_ARM_PMU_V3,
>> >+#define	KVM_DEV_TYPE_ARM_PMU_V3		KVM_DEV_TYPE_ARM_PMU_V3
>> >  	KVM_DEV_TYPE_MAX,
>> >  };
>> >
>> >diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> >index d113ee4..1965d0d 100644
>> >--- a/virt/kvm/arm/pmu.c
>> >+++ b/virt/kvm/arm/pmu.c
>> >@@ -19,6 +19,7 @@
>> >  #include <linux/kvm.h>
>> >  #include <linux/kvm_host.h>
>> >  #include <linux/perf_event.h>
>> >+#include <linux/uaccess.h>
>> >  #include <asm/kvm_emulate.h>
>> >  #include <kvm/arm_pmu.h>
>> >  #include <kvm/arm_vgic.h>
>> >@@ -357,3 +358,117 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>> >
>> >  	pmc->perf_event = event;
>> >  }
>> >+
>> >+static inline bool kvm_arm_pmu_initialized(struct kvm_vcpu *vcpu)
>> >+{
>> >+	return vcpu->arch.pmu.irq_num != -1;
>> >+}
>> >+
>> >+static int kvm_arm_pmu_irq_access(struct kvm *kvm, int *irq, bool is_set)
>> >+{
>> >+	int j;
>> >+	struct kvm_vcpu *vcpu;
>> >+
>> >+	kvm_for_each_vcpu(j, vcpu, kvm) {
>> >+		struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> >+
>> >+		if (!is_set) {
>> >+			if (!kvm_arm_pmu_initialized(vcpu))
>> >+				return -EBUSY;
> Returning -EBUSY is a bit odd. Maybe -EINVAL? But this seems weird
> anyway. Actually, why would you return an error in this case?
>
While this is a unexpected operation from user space and it's already 
initialized and working, so I think it should return an error to user 
and tell user that it's already initialized and working (this should 
mean "busy" ?).

-- 
Shannon
