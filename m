From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v15 09/10] sysbus: add irq_routing_notifier
Date: Thu, 30 Apr 2015 13:49:14 +0100
Message-ID: <1430398155-11214-10-git-send-email-eric.auger@linaro.org>
References: <1430398155-11214-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE6024F045
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 08:41:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fpkd0v-+Xg8P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2015 08:41:05 -0400 (EDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31F564F061
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 08:41:04 -0400 (EDT)
Received: by wgin8 with SMTP id n8so61074458wgi.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2015 05:49:36 -0700 (PDT)
In-Reply-To: <1430398155-11214-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, agraf@suse.de, pbonzini@redhat.com, peter.crosthwaite@xilinx.com
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a new connect_irq_notifier notifier in the SysBusDeviceClass. This
notifier, if populated, is called after sysbus_connect_irq.

This mechanism is used to setup VFIO signaling once VFIO platform
devices get attached to their platform bus, on a machine init done
notifier.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>

---
v14 -> v15:
add Peter R-b

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
