From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 6/6] KVM: ARM: no need for kvm_arch_flush_incoherent
Date: Fri,  6 Mar 2015 13:52:33 -0500
Message-ID: <1425667953-3566-7-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425667953-3566-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE93F47FE2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HqSOj5b6uS6k for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:46:41 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E2FF47FF5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:40 -0500 (EST)
In-Reply-To: <1425667953-3566-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

kvm_arch_flush_incoherent makes things too slow, and we don't
need it. Userspace can flush for us, as the necessary cache
maintenance instruction is not (necessarily) privileged.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 2f45db9cd436a..b2d87587a9d79 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1822,6 +1822,11 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 void kvm_arch_flush_incoherent(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
+	/*
+	 * We no longer need this function, now that userspace does the
+	 * flushing.
+	 */
+#if 0
 	if (slot->flags & KVM_MEM_READONLY) {
 		/*
 		 * Readonly memory shouldn't be changing, and we do a
@@ -1840,6 +1845,7 @@ void kvm_arch_flush_incoherent(struct kvm *kvm, struct kvm_memory_slot *slot)
 	 */
 
 	coherent_cache_memslot(slot, true);
+#endif
 }
 
 void kvm_arch_invalidate_incoherent(struct kvm *kvm, struct kvm_memory_slot *slot)
-- 
1.8.3.1
