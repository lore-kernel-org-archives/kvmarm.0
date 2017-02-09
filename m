From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 13/25] arm/arm64: KVM: Get rid of KVM_MEMSLOT_INCOHERENT
Date: Thu,  9 Feb 2017 14:59:11 +0000
Message-ID: <1486652363-7696-14-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C48F740C17
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SNLKvz3OEa2J for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Feb 2017 09:59:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E959540C49
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:26 -0500 (EST)
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM_MEMSLOT_INCOHERENT is not used anymore, as we've killed its
only use in the arm/arm64 MMU code. Let's remove the last artifacts.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/mmu.c       | 9 ---------
 include/linux/kvm_host.h | 1 -
 2 files changed, 10 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 5cc35080..962616f 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1876,15 +1876,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
-	/*
-	 * Readonly memslots are not incoherent with the caches by definition,
-	 * but in practice, they are used mostly to emulate ROMs or NOR flashes
-	 * that the guest may consider devices and hence map as uncached.
-	 * To prevent incoherency issues in these cases, tag all readonly
-	 * regions as incoherent.
-	 */
-	if (slot->flags & KVM_MEM_READONLY)
-		slot->flags |= KVM_MEMSLOT_INCOHERENT;
 	return 0;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1c5190d..cda457b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -45,7 +45,6 @@
  * include/linux/kvm_h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
-#define KVM_MEMSLOT_INCOHERENT	(1UL << 17)
 
 /* Two fragments for cross MMIO pages. */
 #define KVM_MAX_MMIO_FRAGMENTS	2
-- 
2.1.4
