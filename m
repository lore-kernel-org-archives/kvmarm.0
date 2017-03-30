From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: [PATCH v3 8/8] arm64: exception: check shared writable page in SEI
 handler
Date: Thu, 30 Mar 2017 18:31:17 +0800
Message-ID: <1490869877-118713-18-git-send-email-xiexiuqi@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DCA740A7F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:33:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TBqJnOB6vlEG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Mar 2017 06:33:37 -0400 (EDT)
Received: from dggrg01-dlp.huawei.com (unknown [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 261A940190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:33:35 -0400 (EDT)
In-Reply-To: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: wuquanming@huawei.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com, wangxiongfeng2@huawei.com, linux-acpi@vger.kernel.org, Wang Xiongfeng <wangxiongfengi2@huawei.com>, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Wang Xiongfeng <wangxiongfeng2@huawei.com>

Since SEI is asynchronous, the error data has been consumed. So we must
suppose that all the memory data current process can write are
contaminated. If the process doesn't have shared writable pages, the
process will be killed, and the system will continue running normally.
Otherwise, the system must be terminated, because the error has been
propagated to other processes running on other cores, and recursively
the error may be propagated to several another processes.

Signed-off-by: Wang Xiongfeng <wangxiongfengi2@huawei.com>
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 arch/arm64/kernel/traps.c | 149 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 144 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 99be6d8..b222589 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -34,6 +34,8 @@
 #include <linux/sched/task_stack.h>
 #include <linux/syscalls.h>
 #include <linux/mm_types.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 #include <asm/atomic.h>
 #include <asm/bug.h>
@@ -662,7 +664,144 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 	[ESR_ELx_AET_CE]	=	"Corrected",
 };
 
+static void shared_writable_pte_entry(pte_t *pte, unsigned long addr,
+				struct mm_walk *walk)
+{
+	int *is_shared_writable = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	struct page *page = NULL;
+	int mapcount = -1;
+
+	if (!pte_write(__pte(pgprot_val(vma->vm_page_prot))))
+		return;
+
+	if (pte_present(*pte)) {
+		page = vm_normal_page(vma, addr, *pte);
+	} else if (is_swap_pte(*pte)) {
+		swp_entry_t swpent = pte_to_swp_entry(*pte);
+
+		if (!non_swap_entry(swpent))
+			mapcount = swp_swapcount(swpent);
+		else if (is_migration_entry(swpent))
+			page = migration_entry_to_page(swpent);
+	}
+
+	if (mapcount == -1 && page)
+		mapcount = page_mapcount(page);
+	if (mapcount >= 2)
+		*is_shared_writable = 1;
+}
+
+static void shared_writable_pmd_entry(pmd_t *pmd, unsigned long addr,
+				struct mm_walk *walk)
+{
+	struct page *page;
+	int mapcount;
+	int *is_shared_writable = walk->private;
+
+	if (!pmd_write(*pmd))
+		return;
+
+	page = pmd_page(*pmd);
+	if (page) {
+		mapcount = page_mapcount(page);
+		if (mapcount >= 2)
+			*is_shared_writable = 1;
+	}
+}
+
+static int shared_writable_pte_range(pmd_t *pmd, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
+{
+	pte_t *pte;
+
+	if (pmd_trans_huge(*pmd)) {
+		shared_writable_pmd_entry(pmd, addr, walk);
+		return 0;
+	}
+
+	if (pmd_trans_unstable(pmd))
+		return 0;
+
+	pte = pte_offset_map(pmd, addr);
+	for (; addr != end; pte++, addr += PAGE_SIZE)
+	shared_writable_pte_entry(pte, addr, walk);
+	return 0;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE
+static int shared_writable_hugetlb_range(pte_t *pte, unsigned long hmask,
+					unsigned long addr, unsigned long end,
+					struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	int *is_shared_writable = walk->private;
+	struct page *page = NULL;
+	int mapcount;
+
+	if (!pte_write(*pte))
+		return 0;
+
+	if (pte_present(*pte)) {
+		page = vm_normal_page(vma, addr, *pte);
+	} else if (is_swap_pte(*pte)) {
+		swp_entry_t swpent = pte_to_swp_entry(*pte);
+
+		if (is_migration_entry(swpent))
+			page = migration_entry_to_page(swpent);
+	}
+
+	if (page) {
+		mapcount = page_mapcount(page);
+
+		if (mapcount >= 2)
+			*is_shared_writable = 1;
+	}
+	return 0;
+}
+#endif
+
+/*
+ *Check whether there exists a page in mm_struct which is shared with other
+ process and writable (not COW) at the same time. 0 means existing such a page.
+ */
+int mm_shared_writable(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+	int is_shared_writable = 0;
+	struct mm_walk shared_writable_walk = {
+		.pmd_entry = shared_writable_pte_range,
+#ifdef CONFIG_HUGETLB_PAGE
+		.hugetlb_entry = shared_writable_hugetlb_range,
+#endif
+		.mm = mm,
+		.private = &is_shared_writable,
+	};
+
+	if (!mm)
+		return -EPERM;
+
+	vma = mm->mmap;
+	while (vma) {
+		walk_page_vma(vma, &shared_writable_walk);
+		if (is_shared_writable)
+			return 1;
+		vma = vma->vm_next;
+	}
+	return 0;
+}
+
 DEFINE_PER_CPU(int, sei_in_process);
+
+/*
+ * Since SEI is asynchronous, the error data has been consumed. So we must
+ * suppose that all the memory data current process can write are
+ * contaminated. If the process doesn't have shared writable pages, the
+ * process will be killed, and the system will continue running normally.
+ * Otherwise, the system must be terminated, because the error has been
+ * propagated to other processes running on other cores, and recursively
+ * the error may be propagated to several another processes.
+ */
 asmlinkage void do_sei(struct pt_regs *regs, unsigned int esr, int el)
 {
 	int aet = ESR_ELx_AET(esr);
@@ -684,16 +823,16 @@ asmlinkage void do_sei(struct pt_regs *regs, unsigned int esr, int el)
 	if (el == 0 && IS_ENABLED(CONFIG_ARM64_ESB) &&
 	    cpus_have_cap(ARM64_HAS_RAS_EXTN)) {
 		siginfo_t info;
-		void __user *pc = (void __user *)instruction_pointer(regs);
 
 		if (aet >= ESR_ELx_AET_UEO)
 			return;
 
-		if (aet == ESR_ELx_AET_UEU) {
-			info.si_signo = SIGILL;
+		if (aet == ESR_ELx_AET_UEU &&
+		    !mm_shared_writable(current->mm)) {
+			info.si_signo = SIGKILL;
 			info.si_errno = 0;
-			info.si_code  = ILL_ILLOPC;
-			info.si_addr  = pc;
+			info.si_code = 0;
+			info.si_addr = 0;
 
 			current->thread.fault_address = 0;
 			current->thread.fault_code = 0;
-- 
1.8.3.1
