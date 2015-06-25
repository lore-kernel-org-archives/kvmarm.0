From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 2/3] arm/arm64: drop mmu_set_enabled
Date: Thu, 25 Jun 2015 20:45:10 +0200
Message-ID: <1435257911-9715-3-git-send-email-drjones@redhat.com>
References: <1435257911-9715-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1435257911-9715-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

The mmu is enabled automatically for all cpus, they must disable it
themselves if they don't want it on. Switch from managing a cpumask
of enabled cpus to one of disabled cpus. This allows us to remove
the mmu_set_enabled call from secondary_cinit, and the function all
together.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/mmu-api.h |  1 -
 lib/arm/mmu.c         | 21 ++++++++++-----------
 lib/arm/smp.c         |  1 -
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index c46c4b08b14cc..12fdc57918c27 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -2,7 +2,6 @@
 #define __ASMARM_MMU_API_H_
 extern pgd_t *mmu_idmap;
 extern bool mmu_enabled(void);
-extern void mmu_set_enabled(void);
 extern void mmu_enable(pgd_t *pgtable);
 extern void mmu_disable(void);
 extern void mmu_enable_idmap(void);
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 5966b408cb455..ad558e177dd1c 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -14,32 +14,31 @@ extern unsigned long etext;
 
 pgd_t *mmu_idmap;
 
-static cpumask_t mmu_enabled_cpumask;
+static cpumask_t mmu_disabled_cpumask;
+
 bool mmu_enabled(void)
 {
-	struct thread_info *ti = current_thread_info();
-	return cpumask_test_cpu(ti->cpu, &mmu_enabled_cpumask);
-}
+	int cpu = current_thread_info()->cpu;
 
-void mmu_set_enabled(void)
-{
-	struct thread_info *ti = current_thread_info();
-	cpumask_set_cpu(ti->cpu, &mmu_enabled_cpumask);
+	return !cpumask_test_cpu(cpu, &mmu_disabled_cpumask);
 }
 
 extern void asm_mmu_enable(phys_addr_t pgtable);
 void mmu_enable(pgd_t *pgtable)
 {
+	int cpu = current_thread_info()->cpu;
+
 	asm_mmu_enable(__pa(pgtable));
 	flush_tlb_all();
-	mmu_set_enabled();
+	cpumask_clear_cpu(cpu, &mmu_disabled_cpumask);
 }
 
 extern void asm_mmu_disable(void);
 void mmu_disable(void)
 {
-	struct thread_info *ti = current_thread_info();
-	cpumask_clear_cpu(ti->cpu, &mmu_enabled_cpumask);
+	int cpu = current_thread_info()->cpu;
+
+	cpumask_set_cpu(cpu, &mmu_disabled_cpumask);
 	asm_mmu_disable();
 }
 
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index f389ba6598faa..ca435dcd5f4a2 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -23,7 +23,6 @@ secondary_entry_fn secondary_cinit(void)
 	secondary_entry_fn entry;
 
 	thread_info_init(ti, 0);
-	mmu_set_enabled();
 
 	/*
 	 * Save secondary_data.entry locally to avoid opening a race
-- 
2.4.3

