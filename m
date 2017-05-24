From: James Morse <james.morse@arm.com>
Subject: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Wed, 24 May 2017 17:32:50 +0100
Message-ID: <20170524163250.29281-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F344095A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 12:29:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pek77W2vVKmj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 May 2017 12:29:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7F840948
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 12:29:53 -0400 (EDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Once we enable ARCH_SUPPORTS_MEMORY_FAILURE on arm64, notifications for
broken memory can call memory_failure() in mm/memory-failure.c to deliver
SIGBUS to any user space process using the page, and notify all the
in-kernel users.

If the page corresponded with guest memory, KVM will unmap this page
from its stage2 page tables. The user space process that allocated
this memory may have never touched this page in which case it may not
be mapped meaning SIGBUS won't be delivered.

This works well until a guest accesses that page, and KVM discovers
pfn == KVM_PFN_ERR_HWPOISON when it comes to process the stage2 fault.

Do as x86 does, and deliver the SIGBUS when we discover
KVM_PFN_ERR_HWPOISON. Use the stage2 mapping size as the si_addr_lsb
as this matches the user space mapping size.

Cc: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>

---
This will be needed once we enable ARCH_SUPPORTS_MEMORY_FAILURE for
arm64[0]. It is harmless until then as KVM_PFN_ERR_HWPOISON will
never be seen.

Changes since v1:
 * Pass the vma to kvm_send_hwpoison_signal(), used Punit's huge_page_shift()
   calculation to find the block size.
 * ... tested against hugepage not transparent huge page ...

Today we will inherit some existing breakage between KVM, hugepages
and hwpoison. Patch at [1].


[0] https://www.spinics.net/lists/arm-kernel/msg581657.html
[1] https://marc.info/?l=linux-mm&m=149564219918427&w=2

 virt/kvm/arm/mmu.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 313ee646480f..eaa29aeb7c5b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -20,6 +20,7 @@
 #include <linux/kvm_host.h>
 #include <linux/io.h>
 #include <linux/hugetlb.h>
+#include <linux/sched/signal.h>
 #include <trace/events/kvm.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
@@ -1249,6 +1250,24 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
 	__coherent_cache_guest_page(vcpu, pfn, size);
 }
 
+static void kvm_send_hwpoison_signal(unsigned long address,
+				     struct vm_area_struct *vma)
+{
+	siginfo_t info;
+
+	info.si_signo   = SIGBUS;
+	info.si_errno   = 0;
+	info.si_code    = BUS_MCEERR_AR;
+	info.si_addr    = (void __user *)address;
+
+	if (is_vm_hugetlb_page(vma))
+		info.si_addr_lsb = huge_page_shift(hstate_vma(vma));
+	else
+		info.si_addr_lsb = PAGE_SHIFT;
+
+	send_sig_info(SIGBUS, &info, current);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1318,6 +1337,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	smp_rmb();
 
 	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
+	if (pfn == KVM_PFN_ERR_HWPOISON) {
+		kvm_send_hwpoison_signal(hva, vma);
+		return 0;
+	}
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
-- 
2.11.0
