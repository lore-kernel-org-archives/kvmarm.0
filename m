From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/13] arm64: KVM: skip HYP setup when already running in HYP
Date: Wed,  8 Jul 2015 17:19:07 +0100
Message-ID: <1436372356-30410-5-git-send-email-marc.zyngier@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BBE458127
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oDmmqNZf6WTH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 12:08:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD8A0580C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:00 -0400 (EDT)
In-Reply-To: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

With the kernel running at EL2, there is no point trying to
configure page tables for HYP, as the kernel is already mapped.

Take this opportunity to refactor the whole init a bit, allowing
the various parts of the hypervisor bringup to be split across
multiple functions.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 131 +++++++++++++++++++++++++++++++++--------------------
 arch/arm/kvm/mmu.c |   6 +++
 2 files changed, 89 insertions(+), 48 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index bc738d2..ca3c662 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -969,6 +969,58 @@ static inline void hyp_cpu_pm_init(void)
 }
 #endif
 
+static void teardown_common_resources(void)
+{
+	free_percpu(kvm_host_cpu_state);
+}
+
+static int init_common_resources(void)
+{
+	kvm_host_cpu_state = alloc_percpu(kvm_cpu_context_t);
+	if (!kvm_host_cpu_state) {
+		kvm_err("Cannot allocate host CPU state\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int init_subsystems(void)
+{
+	int err;
+
+	/*
+	 * Init HYP view of VGIC
+	 */
+	err = kvm_vgic_hyp_init();
+	if (err)
+		return err;
+
+	/*
+	 * Init HYP architected timer support
+	 */
+	err = kvm_timer_hyp_init();
+	if (err)
+		return err;
+
+	kvm_perf_init();
+	kvm_coproc_table_init();
+
+	return 0;
+}
+
+static void teardown_hyp_mode(void)
+{
+	int cpu;
+
+	if (is_kernel_in_hyp_mode())
+		return;
+
+	free_hyp_pgds();
+	for_each_possible_cpu(cpu)
+		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+}
+
 /**
  * Inits Hyp-mode on all online CPUs
  */
@@ -977,6 +1029,9 @@ static int init_hyp_mode(void)
 	int cpu;
 	int err = 0;
 
+	if (is_kernel_in_hyp_mode())
+		return 0;
+
 	/*
 	 * Allocate Hyp PGD and setup Hyp identity mapping
 	 */
@@ -999,7 +1054,7 @@ static int init_hyp_mode(void)
 		stack_page = __get_free_page(GFP_KERNEL);
 		if (!stack_page) {
 			err = -ENOMEM;
-			goto out_free_stack_pages;
+			goto out_err;
 		}
 
 		per_cpu(kvm_arm_hyp_stack_page, cpu) = stack_page;
@@ -1011,7 +1066,7 @@ static int init_hyp_mode(void)
 	err = create_hyp_mappings(__kvm_hyp_code_start, __kvm_hyp_code_end);
 	if (err) {
 		kvm_err("Cannot map world-switch code\n");
-		goto out_free_mappings;
+		goto out_err;
 	}
 
 	/*
@@ -1023,20 +1078,10 @@ static int init_hyp_mode(void)
 
 		if (err) {
 			kvm_err("Cannot map hyp stack\n");
-			goto out_free_mappings;
+			goto out_err;
 		}
 	}
 
-	/*
-	 * Map the host CPU structures
-	 */
-	kvm_host_cpu_state = alloc_percpu(kvm_cpu_context_t);
-	if (!kvm_host_cpu_state) {
-		err = -ENOMEM;
-		kvm_err("Cannot allocate host CPU state\n");
-		goto out_free_mappings;
-	}
-
 	for_each_possible_cpu(cpu) {
 		kvm_cpu_context_t *cpu_ctxt;
 
@@ -1045,7 +1090,7 @@ static int init_hyp_mode(void)
 
 		if (err) {
 			kvm_err("Cannot map host CPU state: %d\n", err);
-			goto out_free_context;
+			goto out_err;
 		}
 	}
 
@@ -1054,37 +1099,29 @@ static int init_hyp_mode(void)
 	 */
 	on_each_cpu(cpu_init_hyp_mode, NULL, 1);
 
-	/*
-	 * Init HYP view of VGIC
-	 */
-	err = kvm_vgic_hyp_init();
-	if (err)
-		goto out_free_context;
-
-	/*
-	 * Init HYP architected timer support
-	 */
-	err = kvm_timer_hyp_init();
-	if (err)
-		goto out_free_mappings;
-
 #ifndef CONFIG_HOTPLUG_CPU
 	free_boot_hyp_pgd();
 #endif
 
-	kvm_perf_init();
+	cpu_notifier_register_begin();
+
+	err = __register_cpu_notifier(&hyp_init_cpu_nb);
+
+	cpu_notifier_register_done();
+
+	if (err) {
+		kvm_err("Cannot register HYP init CPU notifier (%d)\n", err);
+		goto out_err;
+	}
+
+	hyp_cpu_pm_init();
 
 	kvm_info("Hyp mode initialized successfully\n");
 
 	return 0;
-out_free_context:
-	free_percpu(kvm_host_cpu_state);
-out_free_mappings:
-	free_hyp_pgds();
-out_free_stack_pages:
-	for_each_possible_cpu(cpu)
-		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+
 out_err:
+	teardown_hyp_mode();
 	kvm_err("error initializing Hyp mode: %d\n", err);
 	return err;
 }
@@ -1128,26 +1165,24 @@ int kvm_arch_init(void *opaque)
 		}
 	}
 
-	cpu_notifier_register_begin();
+	err = init_common_resources();
+	if (err)
+		return err;
 
 	err = init_hyp_mode();
 	if (err)
 		goto out_err;
 
-	err = __register_cpu_notifier(&hyp_init_cpu_nb);
-	if (err) {
-		kvm_err("Cannot register HYP init CPU notifier (%d)\n", err);
-		goto out_err;
-	}
-
-	cpu_notifier_register_done();
-
-	hyp_cpu_pm_init();
+	err = init_subsystems();
+	if (err)
+		goto out_hyp;
 
-	kvm_coproc_table_init();
 	return 0;
+
+out_hyp:
+	teardown_hyp_mode();
 out_err:
-	cpu_notifier_register_done();
+	teardown_common_resources();
 	return err;
 }
 
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 7b42012..dd128b7 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -594,6 +594,9 @@ int create_hyp_mappings(void *from, void *to)
 	unsigned long start = KERN_TO_HYP((unsigned long)from);
 	unsigned long end = KERN_TO_HYP((unsigned long)to);
 
+	if (is_kernel_in_hyp_mode())
+		return 0;
+
 	start = start & PAGE_MASK;
 	end = PAGE_ALIGN(end);
 
@@ -626,6 +629,9 @@ int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
 	unsigned long start = KERN_TO_HYP((unsigned long)from);
 	unsigned long end = KERN_TO_HYP((unsigned long)to);
 
+	if (is_kernel_in_hyp_mode())
+		return 0;
+
 	/* Check for a valid kernel IO mapping */
 	if (!is_vmalloc_addr(from) || !is_vmalloc_addr(to - 1))
 		return -EINVAL;
-- 
2.1.4
