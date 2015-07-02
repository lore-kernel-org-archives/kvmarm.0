From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 16/17] KVM: eventfd: add irq bypass consumer management
Date: Thu,  2 Jul 2015 15:17:26 +0200
Message-ID: <1435843047-6327-17-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F8B57716
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ec7dy2Gbpl3I for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:07:31 -0400 (EDT)
Received: from mail-wg0-f52.google.com (mail-wg0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C822576DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:10 -0400 (EDT)
Received: by wgck11 with SMTP id k11so63133721wgc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 06:18:27 -0700 (PDT)
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

This patch adds the registration/unregistration of an
irq_bypass_consumer on irqfd assignment/deassignment.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/eventfd.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index f3da161..425a47b 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -34,6 +34,7 @@
 #include <linux/srcu.h>
 #include <linux/slab.h>
 #include <linux/seqlock.h>
+#include <linux/irqbypass.h>
 #include <trace/events/kvm.h>
 
 #include <kvm/iodev.h>
@@ -93,6 +94,7 @@ struct _irqfd {
 	struct list_head list;
 	poll_table pt;
 	struct work_struct shutdown;
+	struct irq_bypass_consumer *cons;
 };
 
 static struct workqueue_struct *irqfd_cleanup_wq;
@@ -429,7 +431,21 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 */
 	fdput(f);
 
-	/* irq_bypass_register_consumer(); */
+	irqfd->cons = kzalloc(sizeof(struct irq_bypass_consumer),
+			      GFP_KERNEL);
+	if (!irqfd->cons) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	irqfd->cons->token = (void *)irqfd->eventfd;
+	irqfd->cons->gsi = irqfd->gsi;
+	irqfd->cons->kvm = kvm;
+	irqfd->cons->add_producer = kvm_arch_add_producer;
+	irqfd->cons->del_producer = kvm_arch_del_producer;
+	irqfd->cons->stop_consumer = kvm_arch_stop_consumer;
+	irqfd->cons->resume_consumer = kvm_arch_resume_consumer;
+	ret = irq_bypass_register_consumer(irqfd->cons);
+	WARN_ON(ret);
 
 	return 0;
 
@@ -530,8 +546,6 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 	struct _irqfd *irqfd, *tmp;
 	struct eventfd_ctx *eventfd;
 
-	/* irq_bypass_unregister_consumer() */
-
 	eventfd = eventfd_ctx_fdget(args->fd);
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
@@ -550,6 +564,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 			irqfd->irq_entry.type = 0;
 			write_seqcount_end(&irqfd->irq_entry_sc);
 			irqfd_deactivate(irqfd);
+			irq_bypass_unregister_consumer(irqfd->cons);
+			kfree(irqfd->cons);
 		}
 	}
 
-- 
1.9.1
