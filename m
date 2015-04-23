From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 2/2] intc: arm_gic_kvm: set the get_gsi callback
Date: Thu, 23 Apr 2015 09:49:37 +0100
Message-ID: <1429778977-1632-3-git-send-email-eric.auger@linaro.org>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 426584E4CE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 04:41:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 25Ar8jr23SoS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 04:41:34 -0400 (EDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 531C74E4D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 04:41:34 -0400 (EDT)
Received: by wgyo15 with SMTP id o15so10885548wgy.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 01:49:46 -0700 (PDT)
In-Reply-To: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The arm_gic_kvm now sets the get_gsi_cb callback so that the
global system interrupt of a qemu_irq can be retrieved. This enables
VFIO platform signaling to be setup.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/intc/arm_gic_kvm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
index e1952ad..8a97a5b 100644
--- a/hw/intc/arm_gic_kvm.c
+++ b/hw/intc/arm_gic_kvm.c
@@ -87,6 +87,11 @@ static void kvm_arm_gic_set_irq(void *opaque, int irq, int level)
     kvm_set_irq(kvm_state, kvm_irq, !!level);
 }
 
+static int kvm_gic_get_gsi(int pin)
+{
+    return pin;
+}
+
 static bool kvm_arm_gic_can_save_restore(GICState *s)
 {
     return s->dev_fd >= 0;
@@ -554,6 +559,11 @@ static void kvm_arm_gic_realize(DeviceState *dev, Error **errp)
      */
     i += (GIC_INTERNAL * s->num_cpu);
     qdev_init_gpio_in(dev, kvm_arm_gic_set_irq, i);
+
+    for (i = 0; i < s->num_irq - GIC_INTERNAL; i++) {
+        qemu_irq irq = qdev_get_gpio_in(dev, i);
+        qemu_irq_set_get_gsi_cb(irq, kvm_gic_get_gsi);
+    }
     /* We never use our outbound IRQ lines but provide them so that
      * we maintain the same interface as the non-KVM GIC.
      */
-- 
1.8.3.2
