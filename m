From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding control
Date: Mon,  6 Jul 2015 14:11:29 +0200
Message-ID: <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D280579A4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 08:00:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rg7LdirGXzdi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 08:00:36 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86E45579CB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 08:00:36 -0400 (EDT)
Received: by widjy10 with SMTP id jy10so159008326wid.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 05:12:03 -0700 (PDT)
In-Reply-To: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
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
- new methods are added:
  x stop/resume: Those are needed for forwarding since the state change
    requires to entermingle actions at consumer, producer.
  x consumer update for posted interrupts
- On handshake, we now call connect, disconnect which features the more
  complex sequence.
- add irq on producer side

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- remove vfio_device, kvm, gsi, opaque fields included in v1 except common
- all those in can be retrieved with container_of in callbacks
---
 include/linux/irqbypass.h | 19 ++++++++++++++++---
 kernel/irq/bypass.c       | 44 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index 718508e..8f62235 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -3,17 +3,30 @@
 
 #include <linux/list.h>
 
+struct irq_bypass_consumer;
+
 struct irq_bypass_producer {
 	struct list_head node;
 	void *token;
-	/* TBD */
+	int irq; /* linux irq */
+	void (*stop)(struct irq_bypass_producer *);
+	void (*resume)(struct irq_bypass_producer *);
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
+	void (*stop)(struct irq_bypass_consumer *);
+	void (*resume)(struct irq_bypass_consumer *);
+	void (*add_producer)(struct irq_bypass_consumer *,
+			     struct irq_bypass_producer *);
+	void (*del_producer)(struct irq_bypass_consumer *,
+			     struct irq_bypass_producer *);
+	void (*update)(struct irq_bypass_consumer *);
 };
 
 int irq_bypass_register_producer(struct irq_bypass_producer *);
diff --git a/kernel/irq/bypass.c b/kernel/irq/bypass.c
index 5d0f92b..efadbe5 100644
--- a/kernel/irq/bypass.c
+++ b/kernel/irq/bypass.c
@@ -19,6 +19,42 @@ static LIST_HEAD(producers);
 static LIST_HEAD(consumers);
 static DEFINE_MUTEX(lock);
 
+/* lock must be hold when calling connect */
+static void connect(struct irq_bypass_producer *prod,
+		    struct irq_bypass_consumer *cons)
+{
+	if (prod->stop)
+		prod->stop(prod);
+	if (cons->stop)
+		cons->stop(cons);
+	if (prod->add_consumer)
+		prod->add_consumer(prod, cons);
+	if (cons->add_producer)
+		cons->add_producer(cons, prod);
+	if (cons->resume)
+		cons->resume(cons);
+	if (prod->resume)
+		prod->resume(prod);
+}
+
+/* lock must be hold when calling disconnect */
+static void disconnect(struct irq_bypass_producer *prod,
+		       struct irq_bypass_consumer *cons)
+{
+	if (prod->stop)
+		prod->stop(prod);
+	if (cons->stop)
+		cons->stop(cons);
+	if (cons->del_producer)
+		cons->del_producer(cons, prod);
+	if (prod->del_consumer)
+		prod->del_consumer(prod, cons);
+	if (cons->resume)
+		cons->resume(cons);
+	if (prod->resume)
+		prod->resume(prod);
+}
+
 int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 {
 	struct irq_bypass_producer *tmp;
@@ -38,7 +74,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 
 	list_for_each_entry(consumer, &consumers, node) {
 		if (consumer->token == producer->token) {
-			consumer->add_producer(producer);
+			connect(producer, consumer);
 			break;
 		}
 	}
@@ -56,7 +92,7 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 
 	list_for_each_entry(consumer, &consumers, node) {
 		if (consumer->token == producer->token) {
-			consumer->del_producer(producer);
+			disconnect(producer, consumer);
 			break;
 		}
 	}
@@ -86,7 +122,7 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 
 	list_for_each_entry(producer, &producers, node) {
 		if (producer->token == consumer->token) {
-			consumer->add_producer(producer);
+			connect(producer, consumer);
 			break;
 		}
 	}
@@ -104,7 +140,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 
 	list_for_each_entry(producer, &producers, node) {
 		if (producer->token == consumer->token) {
-			consumer->del_producer(producer);
+			disconnect(producer, consumer);
 			break;
 		}
 	}
-- 
1.9.1
