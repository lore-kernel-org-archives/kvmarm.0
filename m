From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v13 11/12] sysbus: add irq_set_hook
Date: Tue, 28 Apr 2015 17:51:12 +0100
Message-ID: <1430239873-31950-12-git-send-email-eric.auger@linaro.org>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 927884ED97
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:43:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JGa6wlqI+wsx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 12:43:09 -0400 (EDT)
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93B7A4ED89
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:43:09 -0400 (EDT)
Received: by wgin8 with SMTP id n8so902916wgi.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 09:51:35 -0700 (PDT)
In-Reply-To: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
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
Cc: patches@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add a new callback in the SysBusDeviceClass. This callback now can
be overriden by devices inheriting from sysbus. By default the callback
is set to the dummy object_property_allow_set_link callback.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- use new LinkPropertySetter type
---
 hw/core/sysbus.c    | 7 ++++++-
 include/hw/sysbus.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
index 1bcb64d..ee573b4 100644
--- a/hw/core/sysbus.c
+++ b/hw/core/sysbus.c
@@ -159,8 +159,10 @@ void sysbus_mmio_map_overlap(SysBusDevice *dev, int n, hwaddr addr,
 /* Request an IRQ source.  The actual IRQ object may be populated later.  */
 void sysbus_init_irq(SysBusDevice *dev, qemu_irq *p)
 {
+    SysBusDeviceClass *sbc = SYS_BUS_DEVICE_GET_CLASS(dev);
+
     qdev_init_gpio_out_named(DEVICE(dev), p, SYSBUS_DEVICE_GPIO_IRQ, 1,
-                             object_property_allow_set_link);
+                             sbc->irq_set_hook);
 }
 
 /* Pass IRQs from a target device.  */
@@ -311,8 +313,11 @@ MemoryRegion *sysbus_address_space(SysBusDevice *dev)
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
index d1f3f00..b8dde79 100644
--- a/include/hw/sysbus.h
+++ b/include/hw/sysbus.h
@@ -41,6 +41,7 @@ typedef struct SysBusDeviceClass {
     /*< public >*/
 
     int (*init)(SysBusDevice *dev);
+    LinkPropertySetter irq_set_hook;
 } SysBusDeviceClass;
 
 struct SysBusDevice {
-- 
1.8.3.2
