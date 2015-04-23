From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 1/2] irq: add get_gsi callback
Date: Thu, 23 Apr 2015 09:49:36 +0100
Message-ID: <1429778977-1632-2-git-send-email-eric.auger@linaro.org>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 869EC4E4CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 04:41:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oJBieynLWY1p for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 04:41:33 -0400 (EDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91B244E4CE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 04:41:33 -0400 (EDT)
Received: by wgso17 with SMTP id o17so10940248wgs.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 01:49:45 -0700 (PDT)
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

Add a new IRQState get_gsi_cb field, corresponding to a callback
that transforms the interrupt controller pin number into a global
system interrupt number.

A setter is introduced for the interrupt controller to populate the
callback. Also add a public function that calls this callback.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/core/irq.c    | 20 ++++++++++++++++++++
 include/hw/irq.h |  8 ++++++++
 2 files changed, 28 insertions(+)

diff --git a/hw/core/irq.c b/hw/core/irq.c
index 8a62a36..7eeb742 100644
--- a/hw/core/irq.c
+++ b/hw/core/irq.c
@@ -31,6 +31,7 @@ struct IRQState {
     Object parent_obj;
 
     qemu_irq_handler handler;
+    qemu_irq_get_gsi_t get_gsi_cb;
     void *opaque;
     int n;
 };
@@ -144,6 +145,25 @@ void qemu_irq_intercept_in(qemu_irq *gpio_in, qemu_irq_handler handler, int n)
     }
 }
 
+int qemu_irq_set_get_gsi_cb(qemu_irq irq, qemu_irq_get_gsi_t cb)
+{
+    if (!irq) {
+        return -ENXIO;
+    }
+
+    irq->get_gsi_cb = cb;
+    return 0;
+}
+
+int qemu_irq_get_gsi(qemu_irq irq)
+{
+    if (!irq) {
+        return -ENXIO;
+    }
+
+    return irq->get_gsi_cb(irq->n);
+}
+
 static const TypeInfo irq_type_info = {
    .name = TYPE_IRQ,
    .parent = TYPE_OBJECT,
diff --git a/include/hw/irq.h b/include/hw/irq.h
index 4c4c2ea..658b8f2 100644
--- a/include/hw/irq.h
+++ b/include/hw/irq.h
@@ -8,6 +8,7 @@
 typedef struct IRQState *qemu_irq;
 
 typedef void (*qemu_irq_handler)(void *opaque, int n, int level);
+typedef int (*qemu_irq_get_gsi_t)(int pin);
 
 void qemu_set_irq(qemu_irq irq, int level);
 
@@ -62,4 +63,11 @@ qemu_irq *qemu_irq_proxy(qemu_irq **target, int n);
    on an existing vector of qemu_irq.  */
 void qemu_irq_intercept_in(qemu_irq *gpio_in, qemu_irq_handler handler, int n);
 
+/* sets the get_gsi callback (function that converts the interrupt
+   controller pin into a global system interrupt number */
+int qemu_irq_set_get_gsi_cb(qemu_irq irq,  qemu_irq_get_gsi_t cb);
+
+/* returns the gsi associated to a qemu_irq handle */
+int qemu_irq_get_gsi(qemu_irq irq);
+
 #endif
-- 
1.8.3.2
