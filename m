From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 3/6] KVM: irqchip: convey devid to kvm_set_msi
Date: Thu, 18 Jun 2015 19:40:55 +0200
Message-ID: <1434649258-27065-4-git-send-email-eric.auger@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E4A255FFD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:30:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mDU0bscFMnda for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 13:30:43 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2E9355FFE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:30:43 -0400 (EDT)
Received: by wicgi11 with SMTP id gi11so742705wic.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:41:24 -0700 (PDT)
In-Reply-To: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

on ARM, a devid field is conveyed in kvm_msi struct. Let's choose the
rooting type and struct according to its availability and fill the
corresponding struct. Also remove the flag check now this latter can
be non null.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/irqchip.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1d56a90..e76c7d2 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -73,12 +73,22 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
 {
 	struct kvm_kernel_irq_routing_entry route;
 
-	if (!irqchip_in_kernel(kvm) || msi->flags != 0)
+	if (!irqchip_in_kernel(kvm))
 		return -EINVAL;
 
-	route.msi.address_lo = msi->address_lo;
-	route.msi.address_hi = msi->address_hi;
-	route.msi.data = msi->data;
+	if (msi->flags & KVM_MSI_VALID_DEVID) {
+		route.type = KVM_IRQ_ROUTING_EXTENDED_MSI;
+		route.ext_msi.address_lo = msi->address_lo;
+		route.ext_msi.address_hi = msi->address_hi;
+		route.ext_msi.data = msi->data;
+		route.ext_msi.devid= msi->devid;
+	}
+	else {
+		route.type = KVM_IRQ_ROUTING_MSI;
+		route.msi.address_lo = msi->address_lo;
+		route.msi.address_hi = msi->address_hi;
+		route.msi.data = msi->data;
+	}
 
 	return kvm_set_msi(&route, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1, false);
 }
-- 
1.9.1
