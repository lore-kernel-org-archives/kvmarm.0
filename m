From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [PATCH v3] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Thu,  1 Dec 2016 14:32:05 -0500
Message-ID: <1480620725-9864-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D9E5406F1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 14:31:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8YNp3O-PmkOd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 14:31:23 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 187E140499
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 14:31:22 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uB1JS5su026997
 for <kvmarm@lists.cs.columbia.edu>; Thu, 1 Dec 2016 14:32:14 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id AC10688
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 14:32:14 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 5E82088
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 14:32:14 -0500 (EST)
Received: from mail-qt0-f199.google.com (mail-qt0-f199.google.com
 [209.85.216.199])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uB1JWE4L027720
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 1 Dec 2016 14:32:14 -0500
Received: by mail-qt0-f199.google.com with SMTP id 41so157584532qtn.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2016 11:32:14 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, geoff@infradead.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, pbonzini@redhat.com
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
v2->v3: 
- Perform the initialization including CPU hotplug case.
- Move has_vhe() to asm/virt.h

v1->v2: 
- Skip configuring cnthctl_el2 in world switch path on VHE system.
- Write patch based on linux-next.
---
 arch/arm/include/asm/virt.h   |  5 +++++
 arch/arm/kvm/arm.c            |  3 +++
 arch/arm64/include/asm/virt.h | 10 ++++++++++
 include/kvm/arm_arch_timer.h  |  1 +
 virt/kvm/arm/arch_timer.c     | 23 +++++++++++++++++++++++
 virt/kvm/arm/hyp/timer-sr.c   | 33 +++++++++++++++++++++------------
 6 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index a2e75b8..6dae195 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -80,6 +80,11 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return false;
 }
 
+static inline bool has_vhe(void)
+{
+	return false;
+}
+
 /* The section containing the hypervisor idmap text */
 extern char __hyp_idmap_text_start[];
 extern char __hyp_idmap_text_end[];
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 8f92efa..13e54e8 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1099,6 +1099,9 @@ static void cpu_init_hyp_mode(void *dummy)
 	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
 	__cpu_init_stage2();
 
+	if (is_kernel_in_hyp_mode())
+		kvm_timer_init_vhe();
+
 	kvm_arm_init_debug();
 }
 
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index fea1073..b043cfd 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -47,6 +47,7 @@
 #include <asm/ptrace.h>
 #include <asm/sections.h>
 #include <asm/sysreg.h>
+#include <asm/cpufeature.h>
 
 /*
  * __boot_cpu_mode records what mode CPUs were booted in.
@@ -80,6 +81,15 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
 }
 
+static inline bool has_vhe(void)
+{
+#ifdef CONFIG_ARM64_VHE
+	if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
+		return true;
+#endif
+	return false;
+}
+
 #ifdef CONFIG_ARM64_VHE
 extern void verify_cpu_run_el(void);
 #else
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index dda39d8..2d54903 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -76,4 +76,5 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
+void kvm_timer_init_vhe(void);
 #endif
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 17b8fa5..c7c3bfd 100644
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
+void kvm_timer_init_vhe(void)
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
index 798866a..63e28dd 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -35,10 +35,16 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
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
@@ -50,14 +56,17 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
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
