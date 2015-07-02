From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding control
Date: Thu,  2 Jul 2015 15:17:22 +0200
Message-ID: <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CC26576DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pziFsobEjjqU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:07:18 -0400 (EDT)
Received: from mail-wg0-f42.google.com (mail-wg0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2607576D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:02 -0400 (EDT)
Received: by wgqq4 with SMTP id q4so63059272wgq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 06:18:19 -0700 (PDT)
In-Reply-To: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

- [add,del]_[consumer,producer] updated to takes both the consumer and
  producer handles. This is requested to combine info from both,
  typically to link the source irq owned by the producer with the gsi
  owned by the consumer (forwarded IRQ setup).
- new functions are added: [stop,resume]_[consumer, producer]. Those are
  needed for forwarding since the state change requires to entermingle
  actions at consumer, producer.
- On handshake, we now call connect, disconnect which features the more
  complex sequence.
- new fields are added on producer side: linux irq, vfio_device handle,
  active which reflects whether the source is active (at interrupt
  controller level or at VFIO level - automasked -) and finally an
  opaque pointer which will be used to point to the vfio_platform_device
  in this series.
- new fields on consumer side: the kvm handle, the gsi

Integration of posted interrupt series will help to refine those choices

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

- connect/disconnect could become a cb too. For forwarding it may make
  sense to have failure at connection: this would happen when the physical
  IRQ is either active at irqchip level or VFIO masked. This means some
  of the cb should return an error and this error management could be
  prod/cons specific. Where to attach the connect/disconnect cb: to the
  cons or prod, to both?
- Hence may be sensible to do the list_add only if connect returns 0
- disconnect would not be allowed to fail.
---
 include/linux/irqbypass.h | 26 ++++++++++++++++++++++---
 kernel/irq/bypass.c       | 48 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index 718508e..591ae3f 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -3,17 +3,37 @@
 
 #include <linux/list.h>
 
+struct vfio_device;
+struct irq_bypass_consumer;
+struct kvm;
+
 struct irq_bypass_producer {
 	struct list_head node;
 	void *token;
-	/* TBD */
+	unsigned int irq; /* host physical irq */
+	struct vfio_device *vdev; /* vfio device that requested irq */
+	/* is irq active at irqchip or VFIO masked? */
+	bool active;
+	void *opaque;
+	void (*stop_producer)(struct irq_bypass_producer *);
+	void (*resume_producer)(struct irq_bypass_producer *);
+	void (*add_consumer)(struct irq_bypass_producer *,
+			     struct irq_bypass_consumer *);
+	void (*del_consumer)(struct irq_bypass_producer *,
+			     struct irq_bypass_consumer *);
 };
 
 struct irq_bypass_consumer {
 	struct list_head node;
 	void *token;
-	void (*add_producer)(struct irq_bypass_producer *);
-	void (*del_producer)(struct irq_bypass_producer *);
+	unsigned int gsi;		/* the guest gsi */
+	struct kvm *kvm;
+	void (*stop_consumer)(struct irq_bypass_consumer *);
+	void (*resume_consumer)(struct irq_bypass_consumer *);
+	void (*add_producer)(struct irq_bypass_consumer *,
+			     struct irq_bypass_producer *);
+	void (*del_producer)(struct irq_bypass_consumer *,
+			     struct irq_bypass_producer *);
 };
 
 int irq_bypass_register_producer(struct irq_bypass_producer *);
diff --git a/kernel/irq/bypass.c b/kernel/irq/bypass.c
index 5d0f92b..fb31fef 100644
--- a/kernel/irq/bypass.c
+++ b/kernel/irq/bypass.c
@@ -19,6 +19,46 @@ static LIST_HEAD(producers);
 static LIST_HEAD(consumers);
 static DEFINE_MUTEX(lock);
 
+/* lock must be hold when calling connect */
+static void connect(struct irq_bypass_producer *prod,
+		    struct irq_bypass_consumer *cons)
+{
+	pr_info("++++ %s prod(%d) -> cons(%d)\n",
+		__func__, prod->irq, cons->gsi);
+	if (prod->stop_producer)
+		prod->stop_producer(prod);
+	if (cons->stop_consumer)
+		cons->stop_consumer(cons);
+	if (prod->add_consumer)
+		prod->add_consumer(prod, cons);
+	if (cons->add_producer)
+		cons->add_producer(cons, prod);
+	if (cons->resume_consumer)
+		cons->resume_consumer(cons);
+	if (prod->resume_producer)
+		prod->resume_producer(prod);
+}
+
+/* lock must be hold when calling disconnect */
+static void disconnect(struct irq_bypass_producer *prod,
+		       struct irq_bypass_consumer *cons)
+{
+	pr_info("---- %s prod(%d) -> cons(%d)\n",
+		__func__, prod->irq, cons->gsi);
+	if (prod->stop_producer)
+		prod->stop_producer(prod);
+	if (cons->stop_consumer)
+		cons->stop_consumer(cons);
+	if (cons->del_producer)
+		cons->del_producer(cons, prod);
+	if (prod->del_consumer)
+		prod->del_consumer(prod, cons);
+	if (cons->resume_consumer)
+		cons->resume_consumer(cons);
+	if (prod->resume_producer)
+		prod->resume_producer(prod);
+}
+
 int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 {
 	struct irq_bypass_producer *tmp;
@@ -38,7 +78,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 
 	list_for_each_entry(consumer, &consumers, node) {
 		if (consumer->token == producer->token) {
-			consumer->add_producer(producer);
+			connect(producer, consumer);
 			break;
 		}
 	}
@@ -56,7 +96,7 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 
 	list_for_each_entry(consumer, &consumers, node) {
 		if (consumer->token == producer->token) {
-			consumer->del_producer(producer);
+			disconnect(producer, consumer);
 			break;
 		}
 	}
@@ -86,7 +126,7 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 
 	list_for_each_entry(producer, &producers, node) {
 		if (producer->token == consumer->token) {
-			consumer->add_producer(producer);
+			connect(producer, consumer);
 			break;
 		}
 	}
@@ -104,7 +144,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 
 	list_for_each_entry(producer, &producers, node) {
 		if (producer->token == consumer->token) {
-			consumer->del_producer(producer);
+			disconnect(producer, consumer);
 			break;
 		}
 	}
-- 
1.9.1
