Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05342C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 11:25:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE14A20787
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 11:25:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE14A20787
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 783684B1DB;
	Mon, 25 May 2020 07:25:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Wast-SjQZlc; Mon, 25 May 2020 07:25:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E10E4B203;
	Mon, 25 May 2020 07:25:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05AFA4B1C2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 07:25:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YiokH0MHWeUo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 07:25:17 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B875A4B1E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 07:25:17 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 8C55850255F4F8827112;
 Mon, 25 May 2020 19:25:14 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 25 May 2020 19:25:04 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [RFC PATCH 3/7] KVM: arm64: Traverse page table entries when sync
 dirty log
Date: Mon, 25 May 2020 19:24:02 +0800
Message-ID: <20200525112406.28224-4-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200525112406.28224-1-zhukeqian1@huawei.com>
References: <20200525112406.28224-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Peng Liang <liangpeng10@huawei.com>, Alexios Zavras <alexios.zavras@intel.com>,
 Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

For hardware management of dirty state, dirty state is stored in
page table entries. We have to traverse page table entries when
sync dirty log.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 virt/kvm/arm/arm.c                |   6 +-
 virt/kvm/arm/mmu.c                | 127 ++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 32c8a675e5a4..916617d3fed6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -480,6 +480,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 
 void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
+int kvm_mmu_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
 
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		int exception_index);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 48d0ec44ad77..975311fa3a27 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1191,7 +1191,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-
+#ifdef CONFIG_ARM64_HW_AFDBM
+	if (kvm_hw_dbm_enabled()) {
+		kvm_mmu_sync_dirty_log(kvm, memslot);
+	}
+#endif
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index dc97988eb2e0..ff8df9702e04 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2266,6 +2266,133 @@ int kvm_mmu_init(void)
 	return err;
 }
 
+#ifdef CONFIG_ARM64_HW_AFDBM
+/**
+ * stage2_sync_dirty_log_ptes() - synchronize dirty log from PMD range
+ * @kvm:        The KVM pointer
+ * @pmd:	pointer to pmd entry
+ * @addr:	range start address
+ * @end:	range end address
+ */
+static void stage2_sync_dirty_log_ptes(struct kvm *kvm, pmd_t *pmd,
+				       phys_addr_t addr, phys_addr_t end)
+{
+	pte_t *pte;
+
+	pte = pte_offset_kernel(pmd, addr);
+	do {
+		if (!pte_none(*pte) && !kvm_s2pte_readonly(pte)) {
+			mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+		}
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+}
+
+/**
+ * stage2_sync_dirty_log_pmds() - synchronize dirty log from PUD range
+ * @kvm:	The KVM pointer
+ * @pud:	pointer to pud entry
+ * @addr:	range start address
+ * @end:	range end address
+ */
+static void stage2_sync_dirty_log_pmds(struct kvm *kvm, pud_t *pud,
+				       phys_addr_t addr, phys_addr_t end)
+{
+	pmd_t *pmd;
+	phys_addr_t next;
+
+	pmd = stage2_pmd_offset(kvm, pud, addr);
+	do {
+		next = stage2_pmd_addr_end(kvm, addr, end);
+		if (!pmd_none(*pmd) && !pmd_thp_or_huge(*pmd)) {
+			stage2_sync_dirty_log_ptes(kvm, pmd, addr, next);
+		}
+	} while (pmd++, addr = next, addr != end);
+}
+
+/**
+ * stage2_sync_dirty_log_puds() - synchronize dirty log from PGD range
+ * @kvm:	The KVM pointer
+ * @pgd:	pointer to pgd entry
+ * @addr:	range start address
+ * @end:	range end address
+ */
+static void stage2_sync_dirty_log_puds(struct kvm *kvm, pgd_t *pgd,
+				       phys_addr_t addr, phys_addr_t end)
+{
+	pud_t *pud;
+	phys_addr_t next;
+
+	pud = stage2_pud_offset(kvm, pgd, addr);
+	do {
+		next = stage2_pud_addr_end(kvm, addr, end);
+		if (!stage2_pud_none(kvm, *pud) && !stage2_pud_huge(kvm, *pud)) {
+			stage2_sync_dirty_log_pmds(kvm, pud, addr, next);
+		}
+	} while (pud++, addr = next, addr != end);
+}
+
+/**
+ * stage2_sync_dirty_log_range() - synchronize dirty log from stage2 memory
+ * region range
+ * @kvm:	The KVM pointer
+ * @addr:	Start address of range
+ * @end:	End address of range
+ */
+static void stage2_sync_dirty_log_range(struct kvm *kvm, phys_addr_t addr,
+					phys_addr_t end)
+{
+	pgd_t *pgd;
+	phys_addr_t next;
+
+	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
+	do {
+		/*
+		 * Release kvm_mmu_lock periodically if the memory region is
+		 * large. Otherwise, we may see kernel panics with
+		 * CONFIG_DETECT_HUNG_TASK, CONFIG_LOCKUP_DETECTOR,
+		 * CONFIG_LOCKDEP. Additionally, holding the lock too long
+		 * will also starve other vCPUs. We have to also make sure
+		 * that the page tables are not freed while we released
+		 * the lock.
+		 */
+		cond_resched_lock(&kvm->mmu_lock);
+		if (!READ_ONCE(kvm->arch.pgd))
+			break;
+		next = stage2_pgd_addr_end(kvm, addr, end);
+		if (stage2_pgd_present(kvm, *pgd))
+			stage2_sync_dirty_log_puds(kvm, pgd, addr, next);
+	} while (pgd++, addr = next, addr != end);
+}
+
+/**
+ * kvm_mmu_sync_dirty_log() - synchronize dirty log from stage2 entries for
+ * memory slot
+ * @kvm:	The KVM pointer
+ * @slot:	The memory slot to synchronize dirty log
+ *
+ * Called to synchronize dirty log (marked by hw) after memory region
+ * KVM_GET_DIRTY_LOG operation is called. After this function returns
+ * all dirty log information (for that hw will modify page tables during
+ * this routine, it is true only when guest is stopped, but it is OK
+ * because we won't miss dirty log finally.) are collected into memslot
+ * dirty_bitmap. Afterwards dirty_bitmap can be copied to userspace.
+ *
+ * Acquires kvm_mmu_lock. Called with kvm->slots_lock mutex acquired,
+ * serializing operations for VM memory regions.
+ */
+int kvm_mmu_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	spin_lock(&kvm->mmu_lock);
+	stage2_sync_dirty_log_range(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
+
+	return 0;
+}
+#endif /* CONFIG_ARM64_HW_AFDBM */
+
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
