Return-Path: <SRS0=IHVC=42=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0947BC18E5A
	for <kvmarm@archiver.kernel.org>; Mon,  9 Mar 2020 08:59:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CC7221775
	for <kvmarm@archiver.kernel.org>; Mon,  9 Mar 2020 08:59:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CC7221775
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CA0D40456;
	Mon,  9 Mar 2020 04:59:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xfKhTlY8wHQD; Mon,  9 Mar 2020 04:59:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B7EB4A4BE;
	Mon,  9 Mar 2020 04:59:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DE874A4A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2020 04:59:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sZcDB4FOzcwO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2020 04:59:46 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAF9440456
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2020 04:59:45 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 609C5D3890AF7904DCED;
 Mon,  9 Mar 2020 16:59:41 +0800 (CST)
Received: from linux-kDCJWP.huawei.com (10.175.104.212) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Mar 2020 16:59:35 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [RFC] KVM: arm64: support enabling dirty log graually in small chunks
Date: Mon, 9 Mar 2020 16:57:27 +0800
Message-ID: <20200309085727.1106-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
X-Originating-IP: [10.175.104.212]
X-CFilter-Loop: Reflected
Cc: Jay Zhou <jianjay.zhou@huawei.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
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

There is already support of enabling dirty log graually
in small chunks for x86. This adds support for arm64.

Under the Huawei Kunpeng 920 2.6GHz platform, I did some
tests with a 128G linux VM and counted the time taken of
memory_global_dirty_log_start, here is the numbers:

VM Size        Before    After optimization
128G           527ms     4ms

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
Cc: Jay Zhou <jianjay.zhou@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
---
 Documentation/virt/kvm/api.rst    |  2 +-
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 virt/kvm/arm/mmu.c                | 30 ++++++++++++++++++++++--------
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0adef66585b1..89d4f2680af1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5735,7 +5735,7 @@ will be initialized to 1 when created.  This also improves performance because
 dirty logging can be enabled gradually in small chunks on the first call
 to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
 KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
-x86 for now).
+x86 and arm64 for now).
 
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the name
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that make
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d87aa609d2b6..0deb2ac7d091 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/jump_label.h>
 #include <linux/kvm_types.h>
 #include <linux/percpu.h>
+#include <linux/kvm.h>
 #include <asm/arch_gicv3.h>
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
@@ -45,6 +46,9 @@
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 
+#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
+					KVM_DIRTY_LOG_INITIALLY_SET)
+
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int kvm_sve_max_vl;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index e3b9ee268823..5c7ca84dec85 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1438,9 +1438,11 @@ static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
  * @pud:	pointer to pud entry
  * @addr:	range start address
  * @end:	range end address
+ * @wp_ptes:	write protect ptes or not
  */
 static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
-			   phys_addr_t addr, phys_addr_t end)
+			   phys_addr_t addr, phys_addr_t end,
+			   bool wp_ptes)
 {
 	pmd_t *pmd;
 	phys_addr_t next;
@@ -1453,7 +1455,7 @@ static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
 			if (pmd_thp_or_huge(*pmd)) {
 				if (!kvm_s2pmd_readonly(pmd))
 					kvm_set_s2pmd_readonly(pmd);
-			} else {
+			} else if (wp_ptes) {
 				stage2_wp_ptes(pmd, addr, next);
 			}
 		}
@@ -1465,9 +1467,11 @@ static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
  * @pgd:	pointer to pgd entry
  * @addr:	range start address
  * @end:	range end address
+ * @wp_ptes:	write protect ptes or not
  */
 static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
-			    phys_addr_t addr, phys_addr_t end)
+			    phys_addr_t addr, phys_addr_t end,
+			    bool wp_ptes)
 {
 	pud_t *pud;
 	phys_addr_t next;
@@ -1480,7 +1484,7 @@ static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
 				if (!kvm_s2pud_readonly(pud))
 					kvm_set_s2pud_readonly(pud);
 			} else {
-				stage2_wp_pmds(kvm, pud, addr, next);
+				stage2_wp_pmds(kvm, pud, addr, next, wp_ptes);
 			}
 		}
 	} while (pud++, addr = next, addr != end);
@@ -1491,8 +1495,10 @@ static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
  * @kvm:	The KVM pointer
  * @addr:	Start address of range
  * @end:	End address of range
+ * @wp_ptes:	Write protect ptes or not
  */
-static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
+static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr,
+			    phys_addr_t end, bool wp_ptes)
 {
 	pgd_t *pgd;
 	phys_addr_t next;
@@ -1513,7 +1519,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 			break;
 		next = stage2_pgd_addr_end(kvm, addr, end);
 		if (stage2_pgd_present(kvm, *pgd))
-			stage2_wp_puds(kvm, pgd, addr, next);
+			stage2_wp_puds(kvm, pgd, addr, next, wp_ptes);
 	} while (pgd++, addr = next, addr != end);
 }
 
@@ -1535,6 +1541,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
 	phys_addr_t start, end;
+	bool wp_ptes;
 
 	if (WARN_ON_ONCE(!memslot))
 		return;
@@ -1543,7 +1550,14 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(kvm, start, end);
+	/*
+	 * If we're with initial-all-set, we don't need to write protect
+	 * any small page because they're reported as dirty already.
+	 * However we still need to write-protect huge pages so that the
+	 * page split can happen lazily on the first write to the huge page.
+	 */
+	wp_ptes = !kvm_dirty_log_manual_protect_and_init_set(kvm);
+	stage2_wp_range(kvm, start, end, wp_ptes);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1567,7 +1581,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(kvm, start, end);
+	stage2_wp_range(kvm, start, end, true);
 }
 
 /*
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
