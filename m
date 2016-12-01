From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [PATCH v2] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Thu,  1 Dec 2016 06:38:30 -0500
Message-ID: <1480592310-26079-1-git-send-email-jintack@cs.columbia.edu>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Current KVM world switch code is unintentionally setting wrong bits to
CNTHCTL_EL2 when E2H == 1, which may allow guest OS to access physical
timer.  Bit positions of CNTHCTL_EL2 are changing depending on
HCR_EL2.E2H bit.  EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is
not set, but they are 11th and 10th bits respectively when E2H is set.

In fact, on VHE we only need to set those bits once, not for every world
switch. This is because the host kernel runs in EL2 with HCR_EL2.TGE ==
1, which makes those bits have no effect for the host kernel execution.
So we just set those bits once for guests, and that's it.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
v2: Skip configuring cnthctl_el2 in world switch path on VHE system.
This patch is based on linux-next.

---
 arch/arm/kvm/arm.c           |  1 +
 include/kvm/arm_arch_timer.h |  1 +
 virt/kvm/arm/arch_timer.c    | 23 ++++++++++++++++++++++
 virt/kvm/arm/hyp/timer-sr.c  | 45 ++++++++++++++++++++++++++++++++------------
 4 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 8f92efa..38c0645 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1286,6 +1286,7 @@ static void teardown_hyp_mode(void)
 
 static int init_vhe_mode(void)
 {
+	on_each_cpu(kvm_timer_init_vhe, NULL, 1);
 	kvm_info("VHE mode initialized successfully\n");
 	return 0;
 }
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index dda39d8..5853399 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -76,4 +76,5 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
+void kvm_timer_init_vhe(void *dummy);
 #endif
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 17b8fa5..7a0d85d7 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -24,6 +24,7 @@
 
 #include <clocksource/arm_arch_timer.h>
 #include <asm/arch_timer.h>
+#include <asm/kvm_hyp.h>
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
@@ -507,3 +508,25 @@ void kvm_timer_init(struct kvm *kvm)
 {
 	kvm->arch.timer.cntvoff = kvm_phys_timer_read();
 }
+
+/*
+ * On VHE system, we only need to configure trap on physical timer and counter
+ * accesses in EL0 and EL1 once, not for every world switch.
+ * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
+ * and this makes those bits have no effect for the host kernel execution.
+ */
+void kvm_timer_init_vhe(void *dummy)
+{
+	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
+	u32 cnthctl_shift = 10;
+	u64 val;
+
+	/*
+	 * Disallow physical timer access for the guest.
+	 * Physical counter access is allowed.
+	 */
+	val = read_sysreg(cnthctl_el2);
+	val &= ~(CNTHCTL_EL1PCEN << cnthctl_shift);
+	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
+	write_sysreg(val, cnthctl_el2);
+}
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index 798866a..f7fc957 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -21,6 +21,18 @@
 
 #include <asm/kvm_hyp.h>
 
+#ifdef CONFIG_ARM64
+static inline bool has_vhe(void)
+{
+	if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
+		return true;
+
+	return false;
+}
+#else
+#define has_vhe()	false
+#endif
+
 /* vcpu is already in the HYP VA space */
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 {
@@ -35,10 +47,16 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 	/* Disable the virtual timer */
 	write_sysreg_el0(0, cntv_ctl);
 
-	/* Allow physical timer/counter access for the host */
-	val = read_sysreg(cnthctl_el2);
-	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
-	write_sysreg(val, cnthctl_el2);
+	/*
+	 * We don't need to do this for VHE since the host kernel runs in EL2
+	 * with HCR_EL2.TGE ==1, which makes those bits have no impact.
+	 */
+	if (!has_vhe()) {
+		/* Allow physical timer/counter access for the host */
+		val = read_sysreg(cnthctl_el2);
+		val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
+		write_sysreg(val, cnthctl_el2);
+	}
 
 	/* Clear cntvoff for the host */
 	write_sysreg(0, cntvoff_el2);
@@ -50,14 +68,17 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	u64 val;
 
-	/*
-	 * Disallow physical timer access for the guest
-	 * Physical counter access is allowed
-	 */
-	val = read_sysreg(cnthctl_el2);
-	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
-	write_sysreg(val, cnthctl_el2);
+	/* Those bits are already configured at boot on VHE-system */
+	if (!has_vhe()) {
+		/*
+		 * Disallow physical timer access for the guest
+		 * Physical counter access is allowed
+		 */
+		val = read_sysreg(cnthctl_el2);
+		val &= ~CNTHCTL_EL1PCEN;
+		val |= CNTHCTL_EL1PCTEN;
+		write_sysreg(val, cnthctl_el2);
+	}
 
 	if (timer->enabled) {
 		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
-- 
1.9.1


