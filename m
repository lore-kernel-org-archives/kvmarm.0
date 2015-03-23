From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 06/12] KVM: mark kvm->buses as empty once they were
 destroyed
Date: Mon, 23 Mar 2015 15:58:23 +0000
Message-ID: <1427126309-11223-7-git-send-email-andre.przywara@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8B944976F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 11:51:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9EGpVro6nkMH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2015 11:51:47 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29F9F4974C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 11:51:45 -0400 (EDT)
In-Reply-To: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In kvm_destroy_vm() we call kvm_io_bus_destroy() pretty early,
especially before calling kvm_arch_destroy_vm(). To avoid
unregistering devices from the already destroyed bus, let's mark
the bus with NULL to let other users know it has been destroyed
already.
This avoids a crash on a VM shutdown with the VGIC using the
kvm_io_bus later (the unregistering is in there to be able to roll
back a faulting init).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/kvm_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8c7ab0b..6f164eb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -604,8 +604,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
 	kvm_free_irq_routing(kvm);
-	for (i = 0; i < KVM_NR_BUSES; i++)
+	for (i = 0; i < KVM_NR_BUSES; i++) {
 		kvm_io_bus_destroy(kvm->buses[i]);
+		kvm->buses[i] = NULL;
+	}
 	kvm_coalesced_mmio_free(kvm);
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
-- 
1.7.9.5
