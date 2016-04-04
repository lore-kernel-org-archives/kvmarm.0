From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Mon,  4 Apr 2016 10:47:33 +0200
Message-ID: <1459759657-7402-4-git-send-email-eric.auger@linaro.org>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, pbonzini@redhat.com, p.fedin@samsung.com, Manish.Jaggi@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

on ARM, a devid field is populated in kvm_msi struct in case the
flag is set to KVM_MSI_VALID_DEVID. Let's propagate both flags and
devid field in kvm_kernel_irq_routing_entry.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- do not set the type to KVM_IRQ_ROUTING_EXTENDED_MSI anymore as
  suggested by Andre
- correct msi->flags check
- propagate the flags
---
 virt/kvm/irqchip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index fe84e1a..1c556cb 100644
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
1.9.1

