From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 7/8] KVM: arm: vgic-irqfd: Workaround changing
 kvm_set_routing_entry prototype
Date: Thu,  4 Aug 2016 13:40:35 +0200
Message-ID: <1470310836-10371-8-git-send-email-christoffer.dall@linaro.org>
References: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F13F49B1A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:34:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vAB638wXpPL7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2016 07:34:05 -0400 (EDT)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D8FC49B32
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:34:04 -0400 (EDT)
Received: by mail-lf0-f42.google.com with SMTP id l69so180219613lfg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2016 04:40:57 -0700 (PDT)
In-Reply-To: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

kvm_set_routing_entry is changing in -next, and causes things to
explode. Add a temporary workaround that should be dropped when
we hit 4.8-rc1

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-irqfd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index 683a589..b31a51a 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -41,12 +41,20 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
  * kvm_set_routing_entry: populate a kvm routing entry
  * from a user routing entry
  *
+ * @kvm: the VM this entry is applied to
  * @e: kvm kernel routing entry handle
  * @ue: user api routing entry handle
  * return 0 on success, -EINVAL on errors.
  */
+#ifdef KVM_CAP_X2APIC_API
+int kvm_set_routing_entry(struct kvm *kvm,
+			  struct kvm_kernel_irq_routing_entry *e,
+			  const struct kvm_irq_routing_entry *ue)
+#else
+/* Remove this version and the ifdefery once merged into 4.8 */
 int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
+#endif
 {
 	int r = -EINVAL;
 
-- 
1.9.1
