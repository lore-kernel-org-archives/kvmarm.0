From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 3/3] sysbus: add irq_set_hook
Date: Tue, 28 Apr 2015 10:18:03 +0100
Message-ID: <1430212683-10984-4-git-send-email-eric.auger@linaro.org>
References: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86EC94ECBC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 05:09:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5LM42Hdrop22 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 05:09:47 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 992C34ECAA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 05:09:46 -0400 (EDT)
Received: by widdi4 with SMTP id di4so131750785wid.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 02:18:12 -0700 (PDT)
In-Reply-To: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, peter.crosthwaite@xilinx.com
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a new callback in the SysBusDeviceClass. This callback now can
be overriden by devices inheriting from sysbus. By default the callback
is set to the dummy object_property_allow_set_link callback.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/core/sysbus.c    | 8 +++++++-
 include/hw/sysbus.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
index 8553a6f..e2c4899 100644
--- a/hw/core/sysbus.c
+++ b/hw/core/sysbus.c
@@ -165,7 +165,10 @@ void sysbus_mmio_map_overlap(SysBusDevice *dev, int n, hwaddr addr,
 /* Request an IRQ source.  The actual IRQ object may be populated later.  */
 void sysbus_init_irq(SysBusDevice *dev, qemu_irq *p)
 {
-    qdev_init_gpio_out_named(DEVICE(dev), p, SYSBUS_DEVICE_GPIO_IRQ, 1);
+    SysBusDeviceClass *sbc = SYS_BUS_DEVICE_GET_CLASS(dev);
+
+    qdev_init_gpio_out_named(DEVICE(dev), p, SYSBUS_DEVICE_GPIO_IRQ, 1,
+                             sbc->irq_set_hook);
 }
 
 /* Pass IRQs from a target device.  */
@@ -316,8 +319,11 @@ MemoryRegion *sysbus_address_space(SysBusDevice *dev)
 static void sysbus_device_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *k = DEVICE_CLASS(klass);
+    SysBusDeviceClass *sbc = SYS_BUS_DEVICE_CLASS(klass);
+
     k->init = sysbus_device_init;
     k->bus_type = TYPE_SYSTEM_BUS;
+    sbc->irq_set_hook = object_property_allow_set_link;
 }
 
 static const TypeInfo sysbus_device_type_info = {
diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
index dbf3f0f..26ffb2e 100644
--- a/include/hw/sysbus.h
+++ b/include/hw/sysbus.h
@@ -42,6 +42,7 @@ typedef struct SysBusDeviceClass {
 
     int (*init)(SysBusDevice *dev);
     void (*irq_routing_notifier)(SysBusDevice *dev, qemu_irq irq);
+    object_property_set_link_t irq_set_hook;
 } SysBusDeviceClass;
 
 struct SysBusDevice {
-- 
1.8.3.2
