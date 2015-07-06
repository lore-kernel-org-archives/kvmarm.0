From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 6/9] irq: bypass: add active field on producer side
Date: Mon,  6 Jul 2015 15:24:40 +0200
Message-ID: <1436189083-32527-7-git-send-email-eric.auger@linaro.org>
References: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9F4757BC0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e-awdc6CZ+bZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 09:13:54 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91A4757BE5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:53 -0400 (EDT)
Received: by widjy10 with SMTP id jy10so160860502wid.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 06:25:20 -0700 (PDT)
In-Reply-To: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: pbonzini@redhat.com, alex.williamson@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

An active boolean is introduced on producer side: it reflects whether
the source is active (at interrupt controller level or at VFIO level
- automasked -).

This is a temporary hack for ARM IRQ forwarding with vfio platform.
I think the connect and disconnect should become callbacks too.
This would make possible to handle error in the process. Typically
active could be returned by producer->stop and analyzed before going
further. in that case the list_add only if connect returns 0.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 include/linux/irqbypass.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
index 8f62235..c89c3a8 100644
--- a/include/linux/irqbypass.h
+++ b/include/linux/irqbypass.h
@@ -9,6 +9,8 @@ struct irq_bypass_producer {
 	struct list_head node;
 	void *token;
 	int irq; /* linux irq */
+	/* is irq active at irqchip or VFIO masked? */
+	bool active;
 	void (*stop)(struct irq_bypass_producer *);
 	void (*resume)(struct irq_bypass_producer *);
 	void (*add_consumer)(struct irq_bypass_producer *,
-- 
1.9.1
