From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH] KVM: arm/arm64: Enable adaptative WFE trapping
Date: Mon,  2 Jul 2018 17:46:21 +0100
Message-ID: <20180702164621.9899-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Trapping blocking WFE is extremely beneficial in situations where
the system is oversubscribed, as it allows another thread to run
while being blocked. In a non-oversubscribed environment, this is
the complete opposite, and trapping WFE is just unnecessary overhead.

Let's only enable WFE trapping if the CPU has more than a single task
to run (that is, more than just the vcpu thread).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
This small patchlet seem to have some interesting effects in my limited
testing. Installing 100 concurrent Debian VMs results results in about
90 million WFE exits without this patch, and only 7.6 millions with it
(TX1, 96 cores, 2 vcpu guests). I haven't measured any significant
performance variation in that process.

I'd welcome any benchmarking result from people with more interesting
workloads than mine so that I could make my mind about it.

 arch/arm/include/asm/kvm_emulate.h   | 10 ++++++++++
 arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
 virt/kvm/arm/arm.c                   |  6 ++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 6493bd479ddc..b50fe8380868 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -107,6 +107,16 @@ static inline unsigned long *vcpu_hcr(const struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr;
 }
 
+static inline void vcpu_clear_wfe_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr &= ~HCR_TWE;
+}
+
+static inline void vcpu_set_wfe_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr |= HCR_TWE;
+}
+
 static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 {
 	return 1;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1dab3a984608..a71e5af816a9 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -81,6 +81,16 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }
 
+static inline void vcpu_clear_wfe_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 &= ~HCR_TWE;
+}
+
+static inline void vcpu_set_wfe_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 |= HCR_TWE;
+}
+
 static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
 {
 	vcpu->arch.vsesr_el2 = vsesr;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 04e554cae3a2..8e66b89a3db2 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -30,6 +30,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
+#include <linux/sched/stat.h>
 #include <trace/events/kvm.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
@@ -380,6 +381,11 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+
+	if (single_task_running())
+		vcpu_clear_wfe_traps(vcpu);
+	else
+		vcpu_set_wfe_traps(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
-- 
2.17.1
