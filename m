Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5652EC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0659461BE1
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0659461BE1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7DC4B133;
	Wed, 17 Nov 2021 10:37:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ojyDNOkMZGyx; Wed, 17 Nov 2021 10:37:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C80CB4B18F;
	Wed, 17 Nov 2021 10:37:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 086144B154
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JS4lgLLytRet for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E3734B134
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:11 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE0E2ED1;
 Wed, 17 Nov 2021 07:37:10 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 806D13F5A1;
 Wed, 17 Nov 2021 07:37:09 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 05/38] KVM: arm64: Perform CMOs on locked memslots when
 userspace resets VCPUs
Date: Wed, 17 Nov 2021 15:38:09 +0000
Message-Id: <20211117153842.302159-6-alexandru.elisei@arm.com>
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

Userspace resets a VCPU that has already run by means of a
KVM_ARM_VCPU_INIT ioctl. This is usually done after a VM shutdown and
before the same VM is rebooted, and during this interval the VM memory can
be modified by userspace (for example, to copy the original guest kernel
image). In this situation, KVM unmaps the entire stage 2 to trigger stage 2
faults, which ensures that the guest has the same view of memory as the
host's userspace.

Unmapping stage 2 is not an option for locked memslots, so instead do the
cache maintenance the first time a VCPU is run, similar to what KVM does
when a memslot is locked.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++-
 arch/arm64/kvm/mmu.c              | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3b4839b447c4..5f49a27ce289 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -115,7 +115,8 @@ struct kvm_arch_memory_slot {
 
 /* kvm->arch.mmu_pending_ops flags */
 #define KVM_LOCKED_MEMSLOT_FLUSH_DCACHE	0
-#define KVM_MAX_MMU_PENDING_OPS		1
+#define KVM_LOCKED_MEMSLOT_INVAL_ICACHE	1
+#define KVM_MAX_MMU_PENDING_OPS		2
 
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8e4787019840..188064c5839c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -607,8 +607,16 @@ void stage2_unmap_vm(struct kvm *kvm)
 	spin_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots)
+	kvm_for_each_memslot(memslot, slots) {
+		if (memslot_is_locked(memslot)) {
+			set_bit(KVM_LOCKED_MEMSLOT_FLUSH_DCACHE,
+				&kvm->arch.mmu_pending_ops);
+			set_bit(KVM_LOCKED_MEMSLOT_INVAL_ICACHE,
+				&kvm->arch.mmu_pending_ops);
+			continue;
+		}
 		stage2_unmap_memslot(kvm, memslot);
+	}
 
 	spin_unlock(&kvm->mmu_lock);
 	mmap_read_unlock(current->mm);
@@ -1334,6 +1342,11 @@ void kvm_mmu_perform_pending_ops(struct kvm *kvm)
 		clear_bit(KVM_LOCKED_MEMSLOT_FLUSH_DCACHE, &kvm->arch.mmu_pending_ops);
 	}
 
+	if (test_bit(KVM_LOCKED_MEMSLOT_INVAL_ICACHE, &kvm->arch.mmu_pending_ops)) {
+		icache_inval_all_pou();
+		clear_bit(KVM_LOCKED_MEMSLOT_INVAL_ICACHE, &kvm->arch.mmu_pending_ops);
+	}
+
 out_unlock:
 	mutex_unlock(&kvm->slots_lock);
 	return;
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
