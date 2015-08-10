From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v5 4/5] KVM: introduce kvm_arch functions for IRQ bypass
Date: Mon, 10 Aug 2015 15:31:06 +0200
Message-ID: <1439213467-13668-5-git-send-email-eric.auger@linaro.org>
References: <1439213467-13668-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C01515A823
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:19:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z8Gkj+9s5qYN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:19:00 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BADC5A813
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:18:59 -0400 (EDT)
Received: by wicja10 with SMTP id ja10so25865064wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:32:00 -0700 (PDT)
In-Reply-To: <1439213467-13668-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, feng.wu@intel.com
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch introduces
- kvm_arch_irq_bypass_add_producer
- kvm_arch_irq_bypass_del_producer
- kvm_arch_irq_bypass_stop
- kvm_arch_irq_bypass_start

They make possible to specialize the KVM IRQ bypass consumer in
case CONFIG_KVM_HAVE_IRQ_BYPASS is set.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Feng Wu <feng.wu@intel.com>

---
v4 -> v5:
- remove static inline stub functions

v2 -> v3 (Feng Wu):
- use 'kvm_arch_irq_bypass_start' instead of 'kvm_arch_irq_bypass_resume'
- Remove 'kvm_arch_irq_bypass_update', which is not needed to be
  a irqbypass callback per Alex's comments.
- Make kvm_arch_irq_bypass_add_producer return 'int'

v1 -> v2:
- use CONFIG_KVM_HAVE_IRQ_BYPASS instead CONFIG_IRQ_BYPASS_MANAGER
- rename all functions according to Paolo's proposal
- add kvm_arch_irq_bypass_update according to Feng's need
---
 include/linux/kvm_host.h | 10 ++++++++++
 virt/kvm/Kconfig         |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 05e99b8..5ac8d21 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/irqflags.h>
 #include <linux/context_tracking.h>
+#include <linux/irqbypass.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -1151,5 +1152,14 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 {
 }
 #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
+
+#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
+int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
+			   struct irq_bypass_producer *);
+void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
+			   struct irq_bypass_producer *);
+void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *);
+void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
+#endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
 #endif
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index e2c876d..9f8014d 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -47,3 +47,6 @@ config KVM_GENERIC_DIRTYLOG_READ_PROTECT
 config KVM_COMPAT
        def_bool y
        depends on COMPAT && !S390
+
+config HAVE_KVM_IRQ_BYPASS
+       bool
-- 
1.9.1
