From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v16 8/9] sysbus: add irq_routing_notifier
Date: Wed, 27 May 2015 10:11:10 +0100
Message-ID: <1432717871-2393-9-git-send-email-eric.auger@linaro.org>
References: <1432717871-2393-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A7BA521AB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2015 05:01:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DMrc9LXqTBO8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2015 05:01:55 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94C23521C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2015 05:01:54 -0400 (EDT)
Received: by wifw1 with SMTP id w1so14028694wif.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2015 02:11:36 -0700 (PDT)
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

Add a new connect_irq_notifier notifier in the SysBusDeviceClass. This
notifier, if populated, is called after sysbus_connect_irq.

This mechanism is used to setup VFIO signaling once VFIO platform
devices get attached to their platform bus, on a machine init done
notifier.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Tested-by: Vikram Sethi <vikrams@codeaurora.org>

---
v15 -> v16:
- add Vikram's T-b

v14 -> v15:
- add Peter R-b

v2 -> v3 (integrated into this series v14):
- rename irq_routing_notifier into connect_irq_notifier

v1 -> v2:
- duly put the notifier in the class and not in the device
---
 hw/core/sysbus.c    | 6 ++++++
 include/hw/sysbus.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
index b53c351..2d22aec 100644
--- a/hw/core/sysbus.c
+++ b/hw/core/sysbus.c
@@ -109,7 +109,13 @@ qemu_irq sysbus_get_connected_irq(SysBusDevice *dev, int n)
 
 void sysbus_connect_irq(SysBusDevice *dev, int n, qemu_irq irq)
 {
+    SysBusDeviceClass *sbd = SYS_BUS_DEVICE_GET_CLASS(dev);
+
     qdev_connect_gpio_out_named(DEVICE(dev), SYSBUS_DEVICE_GPIO_IRQ, n, irq);
+
+    if (sbd->connect_irq_notifier) {
+        sbd->connect_irq_notifier(dev, irq);
+    }
 }
 
 /* Check whether an MMIO region exists */
diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
index d1f3f00..e80b26d 100644
--- a/include/hw/sysbus.h
+++ b/include/hw/sysbus.h
@@ -41,6 +41,7 @@ typedef struct SysBusDeviceClass {
     /*< public >*/
 
     int (*init)(SysBusDevice *dev);
+    void (*connect_irq_notifier)(SysBusDevice *dev, qemu_irq irq);
 } SysBusDeviceClass;
 
 struct SysBusDevice {
-- 
1.8.3.2
