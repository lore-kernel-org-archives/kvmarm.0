From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 2/2] arm64: KVM: Register CPU notifiers when the kernel runs at HYP
Date: Fri,  1 Apr 2016 11:07:27 +0200
Message-ID: <1459501647-20726-3-git-send-email-christoffer.dall@linaro.org>
References: <1459501647-20726-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1459501647-20726-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, James Morse <james.morse@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: James Morse <james.morse@arm.com>

When the kernel is running at EL2, it doesn't need init_hyp_mode() to
configure page tables for HYP. This function also registers the CPU
hotplug and lower power notifiers that cause HYP to be re-initialised
after the CPU has been reset.

To avoid losing the register state that controls stage2 translation, move
the registering of these notifiers into init_subsystems(), and add a
is_kernel_in_hyp_mode() path to each callback.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Fixes: 1e947bad0b6 ("arm64: KVM: Skip HYP setup when already running in HYP")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 52 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 6accd66..b538431 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1061,15 +1061,27 @@ static void cpu_init_hyp_mode(void *dummy)
 	kvm_arm_init_debug();
 }
 
+static void cpu_hyp_reinit(void)
+{
+	if (is_kernel_in_hyp_mode()) {
+		/*
+		 * cpu_init_stage2() is safe to call even if the PM
+		 * event was cancelled before the CPU was reset.
+		 */
+		cpu_init_stage2(NULL);
+	} else {
+		if (__hyp_get_vectors() == hyp_default_vectors)
+			cpu_init_hyp_mode(NULL);
+	}
+}
+
 static int hyp_init_cpu_notify(struct notifier_block *self,
 			       unsigned long action, void *cpu)
 {
 	switch (action) {
 	case CPU_STARTING:
 	case CPU_STARTING_FROZEN:
-		if (__hyp_get_vectors() == hyp_default_vectors)
-			cpu_init_hyp_mode(NULL);
-		break;
+		cpu_hyp_reinit();
 	}
 
 	return NOTIFY_OK;
@@ -1084,9 +1096,8 @@ static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
 				    unsigned long cmd,
 				    void *v)
 {
-	if (cmd == CPU_PM_EXIT &&
-	    __hyp_get_vectors() == hyp_default_vectors) {
-		cpu_init_hyp_mode(NULL);
+	if (cmd == CPU_PM_EXIT) {
+		cpu_hyp_reinit();
 		return NOTIFY_OK;
 	}
 
@@ -1128,6 +1139,22 @@ static int init_subsystems(void)
 	int err;
 
 	/*
+	 * Register CPU Hotplug notifier
+	 */
+	cpu_notifier_register_begin();
+	err = __register_cpu_notifier(&hyp_init_cpu_nb);
+	cpu_notifier_register_done();
+	if (err) {
+		kvm_err("Cannot register KVM init CPU notifier (%d)\n", err);
+		return err;
+	}
+
+	/*
+	 * Register CPU lower-power notifier
+	 */
+	hyp_cpu_pm_init();
+
+	/*
 	 * Init HYP view of VGIC
 	 */
 	err = kvm_vgic_hyp_init();
@@ -1270,19 +1297,6 @@ static int init_hyp_mode(void)
 	free_boot_hyp_pgd();
 #endif
 
-	cpu_notifier_register_begin();
-
-	err = __register_cpu_notifier(&hyp_init_cpu_nb);
-
-	cpu_notifier_register_done();
-
-	if (err) {
-		kvm_err("Cannot register HYP init CPU notifier (%d)\n", err);
-		goto out_err;
-	}
-
-	hyp_cpu_pm_init();
-
 	/* set size of VMID supported by CPU */
 	kvm_vmid_bits = kvm_get_vmid_bits();
 	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
-- 
2.1.2.330.g565301e.dirty

