From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v16 7/9] intc: arm_gic_kvm: set the qemu_irq/gsi mapping
Date: Wed, 27 May 2015 10:11:09 +0100
Message-ID: <1432717871-2393-8-git-send-email-eric.auger@linaro.org>
References: <1432717871-2393-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 106AE521FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2015 05:01:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EtpUtomxCNXM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2015 05:01:55 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FF35521E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2015 05:01:53 -0400 (EDT)
Received: by wizk4 with SMTP id k4so104128048wiz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2015 02:11:35 -0700 (PDT)
In-Reply-To: <1432717871-2393-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The arm_gic_kvm now calls kvm_irqchip_set_qemuirq_gsi to build
the hash table storing qemu_irq/gsi mappings. From that point on
irqfd can be setup directly from the qemu_irq using
kvm_irqchip_add_irqfd_notifier.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Tested-by: Vikram Sethi <vikrams@codeaurora.org>

---
v15 -> v16:
- added Vikram's T-b
- Resolve rebase conflict

v2 -> v3:
- kvm_irqchip_add_qemuirq_irqfd_notifier renamed into
  kvm_irqchip_add_irqfd_notifier
---
 hw/intc/arm_gic_kvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
index 2cb7d25..f56bff1 100644
--- a/hw/intc/arm_gic_kvm.c
+++ b/hw/intc/arm_gic_kvm.c
@@ -570,6 +570,12 @@ static void kvm_arm_gic_realize(DeviceState *dev, Error **errp)
      */
     i += (GIC_INTERNAL * s->num_cpu);
     qdev_init_gpio_in(dev, kvm_arm_gic_set_irq, i);
+
+    for (i = 0; i < s->num_irq - GIC_INTERNAL; i++) {
+        qemu_irq irq = qdev_get_gpio_in(dev, i);
+        kvm_irqchip_set_qemuirq_gsi(kvm_state, irq, i);
+    }
+
     /* We never use our outbound IRQ/FIQ lines but provide them so that
      * we maintain the same interface as the non-KVM GIC.
      */
-- 
1.8.3.2
