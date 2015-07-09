From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 3/7] KVM: irqchip: convey devid to kvm_set_msi
Date: Thu,  9 Jul 2015 10:22:13 +0200
Message-ID: <1436430137-24205-4-git-send-email-eric.auger@linaro.org>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 903AA58284
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0c7TDvYjaJr6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 04:11:14 -0400 (EDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
 [209.85.212.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAB765828E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:14 -0400 (EDT)
Received: by wiwl6 with SMTP id l6so11101920wiw.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 01:22:49 -0700 (PDT)
In-Reply-To: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

on ARM, a devid field is populated in kvm_msi struct in case the
flag is set to KVM_MSI_VALID_DEVID. Let's populate the corresponding
kvm_kernel_irq_routing_entry devid field and set the msi type to
KVM_IRQ_ROUTING_EXTENDED_MSI.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/irqchip.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 21c1424..e678f8a 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -72,9 +72,17 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
 {
 	struct kvm_kernel_irq_routing_entry route;
 
-	if (!irqchip_in_kernel(kvm) || msi->flags != 0)
+	if (!irqchip_in_kernel(kvm))
 		return -EINVAL;
 
+	if (msi->flags & KVM_MSI_VALID_DEVID) {
+		route.devid = msi->devid;
+		route.type = KVM_IRQ_ROUTING_EXTENDED_MSI;
+	} else if (!msi->flags)
+		return -EINVAL;
+
+	/* historically the route.type was not set */
+
 	route.msi.address_lo = msi->address_lo;
 	route.msi.address_hi = msi->address_hi;
 	route.msi.data = msi->data;
-- 
1.9.1
