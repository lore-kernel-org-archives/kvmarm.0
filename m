Received: from out-48.mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B241BB27
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 23:19:07 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689808744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RInEWc3E9TaPTm8drtOMJ4+JYKQUruPRE5WAbSdwOs4=;
	b=XLSKPpEVjzQbO2dlmWEmOAjmgx/JQaXd9ku4THGMbMiw8XFQ9Rnfw1fTz7GL6+Wh9ly0sw
	ZnEZ0xUVqLItE3eMIHoMFxHU+Q05VI+RL9fSGtIxmyqvxw1kFzfs+5Zq8/ABwJy7fHaZ1M
	0C1SMl7PUM+jzv3B39g+8P3jXE9AwDU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Rephrase percpu enable/disable tracking in terms of hyp
Date: Wed, 19 Jul 2023 23:18:55 +0000
Message-ID: <20230719231855.262973-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

kvm_arm_hardware_enabled is rather misleading, since it doesn't track
the state of all hardware resources needed for running a VM. What it
actually tracks is whether or not the hyp cpu context has been
initialized.

Since we're now at the point where vgic + timer irq management has
been separated from kvm_arm_hardware_enabled, rephrase it (and the
associated helpers) to make it clear what state is being tracked.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

Applies to kvmarm/fixes, on top of Raghu's bugfix [*]

[*] https://lore.kernel.org/kvmarm/20230719215725.799162-1-rananta@google.com/

 arch/arm64/kvm/arm.c | 46 ++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d8540563a623..d1cb298a58a0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -55,7 +55,7 @@ DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 
 static bool vgic_present, kvm_arm_initialised;
 
-static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
+static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 bool is_kvm_arm_initialised(void)
@@ -1864,11 +1864,19 @@ static void cpu_hyp_reinit(void)
 	cpu_hyp_init_features();
 }
 
-static void _kvm_arch_hardware_enable(void *discard)
+static void cpu_hyp_init(void *discard)
 {
-	if (!__this_cpu_read(kvm_arm_hardware_enabled)) {
+	if (!__this_cpu_read(kvm_hyp_initialized)) {
 		cpu_hyp_reinit();
-		__this_cpu_write(kvm_arm_hardware_enabled, 1);
+		__this_cpu_write(kvm_hyp_initialized, 1);
+	}
+}
+
+static void cpu_hyp_uninit(void *discard)
+{
+	if (__this_cpu_read(kvm_hyp_initialized)) {
+		cpu_hyp_reset();
+		__this_cpu_write(kvm_hyp_initialized, 0);
 	}
 }
 
@@ -1882,7 +1890,7 @@ int kvm_arch_hardware_enable(void)
 	 */
 	preempt_disable();
 
-	_kvm_arch_hardware_enable(NULL);
+	cpu_hyp_init(NULL);
 
 	kvm_vgic_cpu_up();
 	kvm_timer_cpu_up();
@@ -1892,21 +1900,13 @@ int kvm_arch_hardware_enable(void)
 	return 0;
 }
 
-static void _kvm_arch_hardware_disable(void *discard)
-{
-	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
-		cpu_hyp_reset();
-		__this_cpu_write(kvm_arm_hardware_enabled, 0);
-	}
-}
-
 void kvm_arch_hardware_disable(void)
 {
 	kvm_timer_cpu_down();
 	kvm_vgic_cpu_down();
 
 	if (!is_protected_kvm_enabled())
-		_kvm_arch_hardware_disable(NULL);
+		cpu_hyp_uninit(NULL);
 }
 
 #ifdef CONFIG_CPU_PM
@@ -1915,16 +1915,16 @@ static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
 				    void *v)
 {
 	/*
-	 * kvm_arm_hardware_enabled is left with its old value over
+	 * kvm_hyp_initialized is left with its old value over
 	 * PM_ENTER->PM_EXIT. It is used to indicate PM_EXIT should
 	 * re-enable hyp.
 	 */
 	switch (cmd) {
 	case CPU_PM_ENTER:
-		if (__this_cpu_read(kvm_arm_hardware_enabled))
+		if (__this_cpu_read(kvm_hyp_initialized))
 			/*
-			 * don't update kvm_arm_hardware_enabled here
-			 * so that the hardware will be re-enabled
+			 * don't update kvm_hyp_initialized here
+			 * so that the hyp will be re-enabled
 			 * when we resume. See below.
 			 */
 			cpu_hyp_reset();
@@ -1932,8 +1932,8 @@ static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
 		return NOTIFY_OK;
 	case CPU_PM_ENTER_FAILED:
 	case CPU_PM_EXIT:
-		if (__this_cpu_read(kvm_arm_hardware_enabled))
-			/* The hardware was enabled before suspend. */
+		if (__this_cpu_read(kvm_hyp_initialized))
+			/* The hyp was enabled before suspend. */
 			cpu_hyp_reinit();
 
 		return NOTIFY_OK;
@@ -2014,7 +2014,7 @@ static int __init init_subsystems(void)
 	/*
 	 * Enable hardware so that subsystem initialisation can access EL2.
 	 */
-	on_each_cpu(_kvm_arch_hardware_enable, NULL, 1);
+	on_each_cpu(cpu_hyp_init, NULL, 1);
 
 	/*
 	 * Register CPU lower-power notifier
@@ -2052,7 +2052,7 @@ static int __init init_subsystems(void)
 		hyp_cpu_pm_exit();
 
 	if (err || !is_protected_kvm_enabled())
-		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
+		on_each_cpu(cpu_hyp_uninit, NULL, 1);
 
 	return err;
 }
@@ -2090,7 +2090,7 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
 	 * The stub hypercalls are now disabled, so set our local flag to
 	 * prevent a later re-init attempt in kvm_arch_hardware_enable().
 	 */
-	__this_cpu_write(kvm_arm_hardware_enabled, 1);
+	__this_cpu_write(kvm_hyp_initialized, 1);
 	preempt_enable();
 
 	return ret;
-- 
2.41.0.255.g8b1d071c50-goog

