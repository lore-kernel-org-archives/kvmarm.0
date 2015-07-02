From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 13/17] KVM: introduce kvm_arch functions for IRQ bypass
Date: Thu,  2 Jul 2015 15:17:23 +0200
Message-ID: <1435843047-6327-14-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 589CD576D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfYiEq1usvbz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:07:34 -0400 (EDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C68657738
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:07:05 -0400 (EDT)
Received: by wgqq4 with SMTP id q4so63060311wgq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 06:18:21 -0700 (PDT)
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

This patch introduces
- kvm_arch_add_producer
- kvm_arch_del_producer
- kvm_arch_stop_consumer
- kvm_arch_resume_consumer

They make possible to specialize the KVM IRQ bypass consumer.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 include/linux/kvm_host.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9564fd7..8e981e9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/irqflags.h>
 #include <linux/context_tracking.h>
+#include <linux/irqbypass.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -1133,5 +1134,31 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 {
 }
 #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
+
+#ifdef CONFIG_IRQ_BYPASS_MANAGER
+
+void kvm_arch_add_producer(struct irq_bypass_consumer *,
+			   struct irq_bypass_producer *);
+void kvm_arch_del_producer(struct irq_bypass_consumer *,
+			   struct irq_bypass_producer *);
+void kvm_arch_stop_consumer(struct irq_bypass_consumer *);
+void kvm_arch_resume_consumer(struct irq_bypass_consumer *);
+
+#else
+void kvm_arch_add_producer(struct irq_bypass_consumer *,
+			   struct irq_bypass_producer *)
+{
+}
+void kvm_arch_del_producer(struct irq_bypass_consumer *,
+			   struct irq_bypass_producer *)
+{
+}
+void kvm_arch_stop_consumer(struct irq_bypass_consumer *)
+{
+}
+void kvm_arch_resume_consumer(struct irq_bypass_consumer *)
+{
+}
+#endif /* CONFIG_IRQ_BYPASS_MANAGER */
 #endif
 
-- 
1.9.1
