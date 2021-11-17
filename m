Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD45C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CF4B61AA5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1CF4B61AA5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C85394B104;
	Wed, 17 Nov 2021 10:37:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R+QBMYLkNYng; Wed, 17 Nov 2021 10:37:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C11E4B172;
	Wed, 17 Nov 2021 10:37:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC2714B13D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4aGdxdjQ5gaR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E9ED4B0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:15 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D68B1ED1;
 Wed, 17 Nov 2021 07:37:14 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6858F3F5A1;
 Wed, 17 Nov 2021 07:37:13 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 07/38] KVM: arm64: Unmap unlocked memslot from stage 2
 if kvm_mmu_has_pending_ops()
Date: Wed, 17 Nov 2021 15:38:11 +0000
Message-Id: <20211117153842.302159-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

KVM relies on doing the necessary maintenance operations for locked
memslots when the first VCPU is run. If the memslot has been locked, and
then unlocked before the first VCPU is run, the maintenance operations
won't be performed for the region described by the memslot, but the memory
remains mapped at stage 2. Which means that it is possible for a guest
running with the MMU off to read stale value from memory instead of the
newest values written by the host (and not written back to memory).

In this case, unmap the memslot from stage 2 to trigger stage 2 data
aborts, which will take care of any synchronisation requirements.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/api.rst |  7 +++++--
 arch/arm64/kvm/mmu.c           | 20 ++++++++++++++++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0ac12a730013..5a69b3b543c0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6979,8 +6979,11 @@ write permissions are specified for a memslot which logs dirty pages.
 
 Enabling this capability causes the memory pinned when locking the memslot
 specified in args[0] to be unpinned, or, optionally, all memslots to be
-unlocked. The IPA range is not unmapped from stage 2. It is considered an error
-to attempt to unlock a memslot which is not locked.
+unlocked. If between the user memory region being locked and the same region
+being unlocked no VCPU has run, then unlocking the memory region also causes the
+corresponding IPA range to be unmapped from stage 2; otherwise, stage 2 is left
+unchanged. It is considered an error to attempt to unlock a memslot which is not
+locked.
 
 8. Other capabilities.
 ======================
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2491e73e3d31..cd6f1bc7842d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1632,6 +1632,14 @@ static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 	bool writable = memslot->arch.flags & KVM_MEMSLOT_LOCK_WRITE;
 	unsigned long npages = memslot->npages;
 
+	/*
+	 * MMU maintenace operations aren't performed on an unlocked memslot.
+	 * Unmap it from stage 2 so the abort handler performs the necessary
+	 * operations.
+	 */
+	if (kvm_mmu_has_pending_ops(kvm))
+		kvm_arch_flush_shadow_memslot(kvm, memslot);
+
 	unpin_memslot_pages(memslot, writable);
 	account_locked_vm(current->mm, npages, false);
 
@@ -1642,6 +1650,7 @@ int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags)
 {
 	bool unlock_all = flags & KVM_ARM_UNLOCK_MEM_ALL;
 	struct kvm_memory_slot *memslot;
+	bool has_locked_memslot;
 	int ret = 0;
 
 	if (!unlock_all && slot >= KVM_MEM_SLOTS_NUM)
@@ -1664,6 +1673,17 @@ int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags)
 		unlock_memslot(kvm, memslot);
 	}
 
+	if (kvm_mmu_has_pending_ops(kvm)) {
+		has_locked_memslot = false;
+		kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
+			if (memslot_is_locked(memslot)) {
+				has_locked_memslot = true;
+			}
+		}
+		if (!has_locked_memslot)
+			kvm->arch.mmu_pending_ops = 0;
+	}
+
 out_unlock_slots:
 	mutex_unlock(&kvm->slots_lock);
 	return ret;
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
