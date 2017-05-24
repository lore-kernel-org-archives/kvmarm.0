From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 06/10] irqbypass: Add a private field in the producer
Date: Wed, 24 May 2017 22:13:19 +0200
Message-ID: <1495656803-28011-7-git-send-email-eric.auger@redhat.com>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6AEF40A66
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:10:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m0Dr2oFSbQiH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 May 2017 16:10:18 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41FE840992
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 May 2017 16:10:18 -0400 (EDT)
In-Reply-To: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The producer callbacks may need to use a private data
stored in the producer structure.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 include/linux/irqbypass.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index f0f5d26..7f18f1b 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -35,6 +35,7 @@ struct irq_bypass_consumer;
  * struct irq_bypass_producer - IRQ bypass producer definition
  * @node: IRQ bypass manager private list management
  * @token: opaque token to match between producer and consumer (non-NULL)
+ * @private: private data that may be used by producer callbacks (optional)
  * @irq: Linux IRQ number for the producer device
  * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
  * @del_consumer: Disconnect the IRQ producer from an IRQ consumer (optional)
@@ -48,6 +49,7 @@ struct irq_bypass_consumer;
 struct irq_bypass_producer {
 	struct list_head node;
 	void *token;
+	void *private;
 	int irq;
 	int (*add_consumer)(struct irq_bypass_producer *,
 			    struct irq_bypass_consumer *);
-- 
2.5.5
