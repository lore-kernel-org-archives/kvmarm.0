From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v7 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Mon, 18 Jul 2016 13:25:53 +0000
Message-ID: <1468848357-2331-4-git-send-email-eric.auger@redhat.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

on ARM, a devid field is populated in kvm_msi struct in case the
flag is set to KVM_MSI_VALID_DEVID. Let's propagate both flags and
devid field in kvm_kernel_irq_routing_entry.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

---
v6 -> v7:
- use renamed msi_flags and msi_devid
- added Andre's R-b

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
index 8db197b..5511824 100644
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
+	route.msi_flags = msi->flags;
+	route.msi_devid = msi->devid;
 
 	return kvm_set_msi(&route, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1, false);
 }
-- 
1.9.1

