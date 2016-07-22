From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/55] arm/arm64: KVM: Drop boot_pgd
Date: Fri, 22 Jul 2016 18:28:35 +0100
Message-ID: <1469208552-4155-19-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 950C649BAA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DVu26WFaVfU9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE25C49BA4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:04 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

Since we now only have one set of page tables, the concept of
boot_pgd is useless and can be removed. We still keep it as
an element of the "extended idmap" thing.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   |  8 +++-----
 arch/arm/include/asm/kvm_mmu.h    |  1 -
 arch/arm/kvm/arm.c                | 15 +++------------
 arch/arm/kvm/mmu.c                |  8 --------
 arch/arm64/include/asm/kvm_host.h |  6 ++----
 arch/arm64/include/asm/kvm_mmu.h  |  1 -
 6 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 96387d4..020f4eb 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -241,8 +241,7 @@ int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		int exception_index);
 
-static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
-				       phys_addr_t pgd_ptr,
+static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
 				       unsigned long vector_ptr)
 {
@@ -272,12 +271,11 @@ static inline void __cpu_init_stage2(void)
 	kvm_call_hyp(__init_stage2_translation);
 }
 
-static inline void __cpu_reset_hyp_mode(phys_addr_t boot_pgd_ptr,
-					phys_addr_t phys_idmap_start)
+static inline void __cpu_reset_hyp_mode(phys_addr_t phys_idmap_start)
 {
 	/*
 	 * TODO
-	 * kvm_call_reset(boot_pgd_ptr, phys_idmap_start);
+	 * kvm_call_reset(phys_idmap_start);
 	 */
 }
 
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 6cb4d4d..5d161d1 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -65,7 +65,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
-phys_addr_t kvm_mmu_get_boot_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 phys_addr_t kvm_get_idmap_start(void);
 int kvm_mmu_init(void);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index c74483f..0887cc1 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1038,7 +1038,6 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 static void cpu_init_hyp_mode(void *dummy)
 {
-	phys_addr_t boot_pgd_ptr;
 	phys_addr_t pgd_ptr;
 	unsigned long hyp_stack_ptr;
 	unsigned long stack_page;
@@ -1047,13 +1046,12 @@ static void cpu_init_hyp_mode(void *dummy)
 	/* Switch from the HYP stub to our own HYP init vector */
 	__hyp_set_vectors(kvm_get_idmap_vector());
 
-	boot_pgd_ptr = kvm_mmu_get_boot_httbr();
 	pgd_ptr = kvm_mmu_get_httbr();
 	stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
 	hyp_stack_ptr = stack_page + PAGE_SIZE;
 	vector_ptr = (unsigned long)kvm_ksym_ref(__kvm_hyp_vector);
 
-	__cpu_init_hyp_mode(boot_pgd_ptr, pgd_ptr, hyp_stack_ptr, vector_ptr);
+	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
 	__cpu_init_stage2();
 
 	kvm_arm_init_debug();
@@ -1075,15 +1073,8 @@ static void cpu_hyp_reinit(void)
 
 static void cpu_hyp_reset(void)
 {
-	phys_addr_t boot_pgd_ptr;
-	phys_addr_t phys_idmap_start;
-
-	if (!is_kernel_in_hyp_mode()) {
-		boot_pgd_ptr = kvm_mmu_get_boot_httbr();
-		phys_idmap_start = kvm_get_idmap_start();
-
-		__cpu_reset_hyp_mode(boot_pgd_ptr, phys_idmap_start);
-	}
+	if (!is_kernel_in_hyp_mode())
+		__cpu_reset_hyp_mode(kvm_get_idmap_start());
 }
 
 static void _kvm_arch_hardware_enable(void *discard)
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 80d3737..dd4ccc7 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1685,14 +1685,6 @@ phys_addr_t kvm_mmu_get_httbr(void)
 		return virt_to_phys(hyp_pgd);
 }
 
-phys_addr_t kvm_mmu_get_boot_httbr(void)
-{
-	if (__kvm_cpu_uses_extended_idmap())
-		return virt_to_phys(merged_hyp_pgd);
-	else
-		return virt_to_phys(hyp_pgd);
-}
-
 phys_addr_t kvm_get_idmap_vector(void)
 {
 	return hyp_idmap_vector;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 88462c3..6731d4e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -347,8 +347,7 @@ int kvm_perf_teardown(void);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
-static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
-				       phys_addr_t pgd_ptr,
+static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
 				       unsigned long vector_ptr)
 {
@@ -360,8 +359,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 }
 
 void __kvm_hyp_teardown(void);
-static inline void __cpu_reset_hyp_mode(phys_addr_t boot_pgd_ptr,
-					phys_addr_t phys_idmap_start)
+static inline void __cpu_reset_hyp_mode(phys_addr_t phys_idmap_start)
 {
 	kvm_call_hyp(__kvm_hyp_teardown, phys_idmap_start);
 }
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 2970537..390acab 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -170,7 +170,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
-phys_addr_t kvm_mmu_get_boot_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 phys_addr_t kvm_get_idmap_start(void);
 int kvm_mmu_init(void);
-- 
2.8.1
