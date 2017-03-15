From: James Morse <james.morse@arm.com>
Subject: [PATCH] KVM: arm/arm64: Signal SIGBUS when stage2 discovers hwpoison
 memory
Date: Wed, 15 Mar 2017 16:07:27 +0000
Message-ID: <20170315160727.16465-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2E8B40430
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 12:06:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OpZVNqG3xqej for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 12:06:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62C61400E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 12:06:39 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdj.1984@gmail.com>
Cc: punit.agrawal@arm.com, Marc Zyngier <marc.zyngier@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Once we enable ARCH_SUPPORTS_MEMORY_FAILURE on arm64[0], notifications for
broken memory can call memory_failure() in mm/memory-failure.c to deliver
SIGBUS to any user space process using the page, and notify all the
in-kernel users.

If the page corresponded with guest memory, KVM will unmap this page
from its stage2 page tables. The user space process that allocated
this memory may have never touched this page in which case it may not
be mapped meaning SIGBUS won't be delivered.

When this happens KVM discovers pfn == KVM_PFN_ERR_HWPOISON when it
comes to process the stage2 fault.

Do as x86 does, and deliver the SIGBUS when we discover
KVM_PFN_ERR_HWPOISON. Use the stage2 mapping size as the si_addr_lsb
as this matches the user space mapping size.

Signed-off-by: James Morse <james.morse@arm.com>
CC: gengdongjiu <gengdj.1984@gmail.com>
---
 Without this patch both kvmtool and Qemu exit as the KVM_RUN ioctl() returns
 EFAULT.
 QEMU: error: kvm run failed Bad address
 LVKM: KVM_RUN failed: Bad address

 With this patch both kvmtool and Qemu receive SIGBUS ... and then exit.
 In the future Qemu can use this signal to notify the guest, for more details
 see hwpoison[1].

 [0] https://www.spinics.net/lists/arm-kernel/msg560009.html
 [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/vm/hwpoison.txt


 arch/arm/kvm/mmu.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 962616fd4ddd..9d1aa294e88f 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -20,8 +20,10 @@
 #include <linux/kvm_host.h>
 #include <linux/io.h>
 #include <linux/hugetlb.h>
+#include <linux/sched/signal.h>
 #include <trace/events/kvm.h>
 #include <asm/pgalloc.h>
+#include <asm/siginfo.h>
 #include <asm/cacheflush.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
@@ -1237,6 +1239,23 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
 	__coherent_cache_guest_page(vcpu, pfn, size);
 }
 
+static void kvm_send_hwpoison_signal(unsigned long address, bool hugetlb)
+{
+	siginfo_t info;
+
+	info.si_signo   = SIGBUS;
+	info.si_errno   = 0;
+	info.si_code    = BUS_MCEERR_AR;
+	info.si_addr    = (void __user *)address;
+
+	if (hugetlb)
+		info.si_addr_lsb = PMD_SHIFT;
+	else
+		info.si_addr_lsb = PAGE_SHIFT;
+
+	send_sig_info(SIGBUS, &info, current);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1306,6 +1325,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	smp_rmb();
 
 	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
+	if (pfn == KVM_PFN_ERR_HWPOISON) {
+		kvm_send_hwpoison_signal(hva, hugetlb);
+		return 0;
+	}
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
-- 
2.10.1
