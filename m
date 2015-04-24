From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2] sysbus: add irq_routing_notifier
Date: Fri, 24 Apr 2015 13:39:13 +0100
Message-ID: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 197754E685
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 08:31:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wv3iQvVIyn7A for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2015 08:31:05 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9413A4E684
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 08:31:05 -0400 (EDT)
Received: by widdi4 with SMTP id di4so18700951wid.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 05:39:20 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a new irq_routing_notifier notifier in the SysBusDeviceClass. This
notifier, if populated, is called after sysbus_connect_irq.

This mechanism is used to setup VFIO signaling once VFIO platform
devices get attached to their platform bus, on a machine init done
notifier.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- duly put the notifier in the class and not in the device
---
 hw/core/sysbus.c    | 6 ++++++
 include/hw/sysbus.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
index b53c351..8553a6f 100644
--- a/hw/core/sysbus.c
+++ b/hw/core/sysbus.c
@@ -109,7 +109,13 @@ qemu_irq sysbus_get_connected_irq(SysBusDevice *dev, int n)
 
 void sysbus_connect_irq(SysBusDevice *dev, int n, qemu_irq irq)
 {
+    SysBusDeviceClass *sbd = SYS_BUS_DEVICE_GET_CLASS(dev);
+
     qdev_connect_gpio_out_named(DEVICE(dev), SYSBUS_DEVICE_GPIO_IRQ, n, irq);
+
+    if (sbd->irq_routing_notifier) {
+        sbd->irq_routing_notifier(dev, irq);
+    }
 }
 
 /* Check whether an MMIO region exists */
diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
index d1f3f00..dbf3f0f 100644
--- a/include/hw/sysbus.h
+++ b/include/hw/sysbus.h
@@ -41,6 +41,7 @@ typedef struct SysBusDeviceClass {
     /*< public >*/
 
     int (*init)(SysBusDevice *dev);
+    void (*irq_routing_notifier)(SysBusDevice *dev, qemu_irq irq);
 } SysBusDeviceClass;
 
 struct SysBusDevice {
-- 
1.8.3.2
