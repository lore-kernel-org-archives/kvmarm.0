From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/55] arm/arm64: KVM: Add a protection parameter to create_hyp_mappings
Date: Fri, 22 Jul 2016 18:28:18 +0100
Message-ID: <1469208552-4155-2-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently, create_hyp_mappings applies a "one size fits all" page
protection (PAGE_HYP). As we're heading towards separate protections
for different sections, let's make this protection a parameter, and
let the callers pass their prefered protection (PAGE_HYP for everyone
for the time being).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h   |  2 +-
 arch/arm/kvm/arm.c               | 13 +++++++------
 arch/arm/kvm/mmu.c               |  5 +++--
 arch/arm64/include/asm/kvm_mmu.h |  2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index f9a6506..6cb4d4d 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -49,7 +49,7 @@
 #include <asm/pgalloc.h>
 #include <asm/stage2_pgtable.h>
 
-int create_hyp_mappings(void *from, void *to);
+int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
 void free_boot_hyp_pgd(void);
 void free_hyp_pgds(void);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index f20ca84..45dd6df 100644
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
 
@@ -1293,14 +1293,14 @@ static int init_hyp_mode(void)
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
@@ -1311,7 +1311,8 @@ static int init_hyp_mode(void)
 	 */
 	for_each_possible_cpu(cpu) {
 		char *stack_page = (char *)per_cpu(kvm_arm_hyp_stack_page, cpu);
-		err = create_hyp_mappings(stack_page, stack_page + PAGE_SIZE);
+		err = create_hyp_mappings(stack_page, stack_page + PAGE_SIZE,
+					  PAGE_HYP);
 
 		if (err) {
 			kvm_err("Cannot map hyp stack\n");
@@ -1323,7 +1324,7 @@ static int init_hyp_mode(void)
 		kvm_cpu_context_t *cpu_ctxt;
 
 		cpu_ctxt = per_cpu_ptr(kvm_host_cpu_state, cpu);
-		err = create_hyp_mappings(cpu_ctxt, cpu_ctxt + 1);
+		err = create_hyp_mappings(cpu_ctxt, cpu_ctxt + 1, PAGE_HYP);
 
 		if (err) {
 			kvm_err("Cannot map host CPU state: %d\n", err);
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 45c43ae..49cb5cc 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -679,12 +679,13 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
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
@@ -704,7 +705,7 @@ int create_hyp_mappings(void *from, void *to)
 		err = __create_hyp_mappings(hyp_pgd, virt_addr,
 					    virt_addr + PAGE_SIZE,
 					    __phys_to_pfn(phys_addr),
-					    PAGE_HYP);
+					    prot);
 		if (err)
 			return err;
 	}
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index f05ac27..fdfbddb 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -81,7 +81,7 @@ alternative_endif
 
 #include <asm/stage2_pgtable.h>
 
-int create_hyp_mappings(void *from, void *to);
+int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
 void free_boot_hyp_pgd(void);
 void free_hyp_pgds(void);
-- 
2.8.1

