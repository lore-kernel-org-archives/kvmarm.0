From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Mon, 29 Jun 2015 17:37:13 +0200
Message-ID: <1435592237-17924-4-git-send-email-eric.auger@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83896569E8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tJKPS91AYcNC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 11:26:42 -0400 (EDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B135569D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:42 -0400 (EDT)
Received: by wgqq4 with SMTP id q4so144786434wgq.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 08:37:51 -0700 (PDT)
In-Reply-To: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, p.fedin@samsung.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

on ARM, a devid field is conveyed in kvm_msi struct. Let's choose the
routing type and struct according to its availability and fill the
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
