From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/5] arm/arm64: KVM: Add a protection parameter to create_hyp_mappings
Date: Mon, 13 Jun 2016 15:00:45 +0100
Message-ID: <1465826449-14349-2-git-send-email-marc.zyngier@arm.com>
References: <1465826449-14349-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1465826449-14349-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently, create_hyp_mappings applies a "one size fits all" page
protection (PAGE_HYP). As we're heading towards separate protections
for different sections, let's make this protection a parameter, and
let the callers pass their prefered protection (PAGE_HYP for everyone
for the time being).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  2 +-
 arch/arm/kvm/arm.c               | 13 +++++++------
 arch/arm/kvm/mmu.c               |  5 +++--
 arch/arm64/include/asm/kvm_mmu.h |  2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index a0c6cf4..73c2818 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -40,7 +40,7 @@
 #include <asm/pgalloc.h>
 #include <asm/stage2_pgtable.h>
 
-int create_hyp_mappings(void *from, void *to);
+int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
 void free_hyp_pgds(void);
 
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index fe20532..7978e15 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -122,7 +122,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_fail_alloc;
 
-	ret = create_hyp_mappings(kvm, kvm + 1);
+	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
 	if (ret)
 		goto out_free_stage2_pgd;
 
@@ -239,7 +239,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 	if (err)
 		goto free_vcpu;
 
-	err = create_hyp_mappings(vcpu, vcpu + 1);
+	err = create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
 	if (err)
 		goto vcpu_uninit;
 
@@ -1285,14 +1285,14 @@ static int init_hyp_mode(void)
 	 * Map the Hyp-code called directly from the host
 	 */
 	err = create_hyp_mappings(kvm_ksym_ref(__hyp_text_start),
-				  kvm_ksym_ref(__hyp_text_end));
+				  kvm_ksym_ref(__hyp_text_end), PAGE_HYP);
 	if (err) {
 		kvm_err("Cannot map world-switch code\n");
 		goto out_err;
 	}
 
 	err = create_hyp_mappings(kvm_ksym_ref(__start_rodata),
-				  kvm_ksym_ref(__end_rodata));
+				  kvm_ksym_ref(__end_rodata), PAGE_HYP);
 	if (err) {
 		kvm_err("Cannot map rodata section\n");
 		goto out_err;
@@ -1303,7 +1303,8 @@ static int init_hyp_mode(void)
 	 */
 	for_each_possible_cpu(cpu) {
 		char *stack_page = (char *)per_cpu(kvm_arm_hyp_stack_page, cpu);
-		err = create_hyp_mappings(stack_page, stack_page + PAGE_SIZE);
+		err = create_hyp_mappings(stack_page, stack_page + PAGE_SIZE,
+					  PAGE_HYP);
 
 		if (err) {
 			kvm_err("Cannot map hyp stack\n");
@@ -1315,7 +1316,7 @@ static int init_hyp_mode(void)
 		kvm_cpu_context_t *cpu_ctxt;
 
 		cpu_ctxt = per_cpu_ptr(kvm_host_cpu_state, cpu);
-		err = create_hyp_mappings(cpu_ctxt, cpu_ctxt + 1);
+		err = create_hyp_mappings(cpu_ctxt, cpu_ctxt + 1, PAGE_HYP);
 
 		if (err) {
 			kvm_err("Cannot map host CPU state: %d\n", err);
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 819517d..6023abd 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -660,12 +660,13 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
  * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
  * @from:	The virtual kernel start address of the range
  * @to:		The virtual kernel end address of the range (exclusive)
+ * @prot:	The protection to be applied to this range
  *
  * The same virtual address as the kernel virtual address is also used
  * in Hyp-mode mapping (modulo HYP_PAGE_OFFSET) to the same underlying
  * physical pages.
  */
-int create_hyp_mappings(void *from, void *to)
+int create_hyp_mappings(void *from, void *to, pgprot_t prot)
 {
 	phys_addr_t phys_addr;
 	unsigned long virt_addr;
@@ -685,7 +686,7 @@ int create_hyp_mappings(void *from, void *to)
 		err = __create_hyp_mappings(hyp_pgd, virt_addr,
 					    virt_addr + PAGE_SIZE,
 					    __phys_to_pfn(phys_addr),
-					    PAGE_HYP);
+					    prot);
 		if (err)
 			return err;
 	}
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 5b8a5622..e1f7520 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -149,7 +149,7 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 
 #include <asm/stage2_pgtable.h>
 
-int create_hyp_mappings(void *from, void *to);
+int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
 void free_hyp_pgds(void);
 
-- 
2.1.4

