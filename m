Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F4DC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8811461AA5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8811461AA5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C30E4B119;
	Wed, 17 Nov 2021 10:37:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J8kHBHrznank; Wed, 17 Nov 2021 10:37:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CA774B13D;
	Wed, 17 Nov 2021 10:37:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 492B64B15E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Lejh6I-8fMf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D17054B130
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:16 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E0151FB;
 Wed, 17 Nov 2021 07:37:16 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 247EC3F5A1;
 Wed, 17 Nov 2021 07:37:15 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 08/38] KVM: arm64: Unlock memslots after stage 2 tables
 are freed
Date: Wed, 17 Nov 2021 15:38:12 +0000
Message-Id: <20211117153842.302159-9-alexandru.elisei@arm.com>
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

Unpin the backing pages mapped at stage 2 after the stage 2 translation
tables are destroyed.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/mmu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cd6f1bc7842d..072e2aba371f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1627,11 +1627,19 @@ int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags)
 	return ret;
 }
 
-static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
+static void __unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 	bool writable = memslot->arch.flags & KVM_MEMSLOT_LOCK_WRITE;
 	unsigned long npages = memslot->npages;
 
+	unpin_memslot_pages(memslot, writable);
+	account_locked_vm(current->mm, npages, false);
+
+	memslot->arch.flags &= ~KVM_MEMSLOT_LOCK_MASK;
+}
+
+static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
 	/*
 	 * MMU maintenace operations aren't performed on an unlocked memslot.
 	 * Unmap it from stage 2 so the abort handler performs the necessary
@@ -1640,10 +1648,7 @@ static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 	if (kvm_mmu_has_pending_ops(kvm))
 		kvm_arch_flush_shadow_memslot(kvm, memslot);
 
-	unpin_memslot_pages(memslot, writable);
-	account_locked_vm(current->mm, npages, false);
-
-	memslot->arch.flags &= ~KVM_MEMSLOT_LOCK_MASK;
+	__unlock_memslot(kvm, memslot);
 }
 
 int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags)
@@ -1951,7 +1956,15 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
+	struct kvm_memory_slot *memslot;
+
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
+
+	kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
+		if (!memslot_is_locked(memslot))
+			continue;
+		__unlock_memslot(kvm, memslot);
+	}
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
