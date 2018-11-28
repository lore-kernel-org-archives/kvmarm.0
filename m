From: Steven Price <steven.price@arm.com>
Subject: [PATCH 08/12] KVM: Export mark_page_dirty_in_slot
Date: Wed, 28 Nov 2018 14:45:23 +0000
Message-ID: <20181128144527.44710-9-steven.price@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 717754A379
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oRRM9K2Cnxcn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Nov 2018 09:46:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B9AA4A377
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:42 -0500 (EST)
In-Reply-To: <20181128144527.44710-1-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

Callers outside kvm_main.c already holding a reference to the memslot
and the gfn of a page that gets modified by KVM should not have to
lookup the memslot one more time when when going via mark_page_dirty().
Instead, export this function.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c926698040e0..c192eda05b95 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -701,6 +701,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2679e476b6c3..af38ce961d24 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -127,8 +127,6 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
-
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
@@ -2050,8 +2048,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
-				    gfn_t gfn)
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn)
 {
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
@@ -2059,6 +2056,7 @@ static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
 		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
+EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
 
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.19.2
