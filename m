From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v6 3/6] KVM: irqchip: convey devid to kvm_set_msi
Date: Wed,  6 Jul 2016 10:47:52 +0200
Message-ID: <1467794875-5237-4-git-send-email-eric.auger@redhat.com>
References: <1467794875-5237-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA38E410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2016 04:42:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U6PoqR2PIaFc for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2016 04:42:58 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48CB8412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2016 04:42:58 -0400 (EDT)
In-Reply-To: <1467794875-5237-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

on ARM, a devid field is populated in kvm_msi struct in case the
flag is set to KVM_MSI_VALID_DEVID. Let's propagate both flags and
devid field in kvm_kernel_irq_routing_entry.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

---
v4 -> v5:
- Add Christoffer's R-b

v2 -> v3:
- do not set the type to KVM_IRQ_ROUTING_EXTENDED_MSI anymore as
  suggested by Andre
- correct msi->flags check
- propagate the flags
---
 virt/kvm/irqchip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 8db197b..32e5646 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -62,12 +62,14 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
 {
 	struct kvm_kernel_irq_routing_entry route;
 
-	if (!irqchip_in_kernel(kvm) || msi->flags != 0)
+	if (!irqchip_in_kernel(kvm) || (msi->flags & ~KVM_MSI_VALID_DEVID))
 		return -EINVAL;
 
 	route.msi.address_lo = msi->address_lo;
 	route.msi.address_hi = msi->address_hi;
 	route.msi.data = msi->data;
+	route.flags = msi->flags;
+	route.devid = msi->devid;
 
 	return kvm_set_msi(&route, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1, false);
 }
-- 
2.5.5
