From: Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
Date: Sun, 17 Mar 2019 14:36:13 +0000
Message-ID: <1552833373-19828-1-git-send-email-yuzenghui@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CA1C4A41B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Mar 2019 10:41:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bQmx+Py6Uckg for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Mar 2019 10:41:45 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E00A4A32E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Mar 2019 10:41:45 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@arm.com, eric.auger@redhat.com, andre.przywara@arm.com
Cc: kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently, IRQFD on arm still uses the deferred workqueue mechanism
to inject interrupts into guest, which will likely lead to a busy
context-switching from/to the kworker thread. This overhead is for
no purpose (only in my view ...) and will result in an interrupt
performance degradation.

Implement kvm_arch_set_irq_inatomic() for arm/arm64 to support direct
irqfd MSI injection, by which we can get rid of the annoying latency.
As a result, irqfd MSI intensive scenarios (e.g., DPDK with high packet
processing workloads) will benefit from it.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---

It seems that only MSI will follow the IRQFD path, did I miss something?

This patch is still under test and sent out for early feedback. If I have
any mis-understanding, please fix me up and let me know. Thanks!

---
 virt/kvm/arm/vgic/trace.h      | 22 ++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-irqfd.c | 21 +++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/virt/kvm/arm/vgic/trace.h b/virt/kvm/arm/vgic/trace.h
index 55fed77..bc1f4db 100644
--- a/virt/kvm/arm/vgic/trace.h
+++ b/virt/kvm/arm/vgic/trace.h
@@ -27,6 +27,28 @@
 		  __entry->vcpu_id, __entry->irq, __entry->level)
 );
 
+TRACE_EVENT(kvm_arch_set_irq_inatomic,
+	TP_PROTO(u32 gsi, u32 type, int level, int irq_source_id),
+	TP_ARGS(gsi, type, level, irq_source_id),
+
+	TP_STRUCT__entry(
+		__field(	u32,	gsi		)
+		__field(	u32,	type		)
+		__field(	int,	level		)
+		__field(	int,	irq_source_id	)
+	),
+
+	TP_fast_assign(
+		__entry->gsi		= gsi;
+		__entry->type		= type;
+		__entry->level		= level;
+		__entry->irq_source_id	= irq_source_id;
+	),
+
+	TP_printk("gsi %u type %u level %d source %d", __entry->gsi,
+		  __entry->type, __entry->level, __entry->irq_source_id)
+);
+
 #endif /* _TRACE_VGIC_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index 99e026d..4cfc3f4 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -19,6 +19,7 @@
 #include <trace/events/kvm.h>
 #include <kvm/arm_vgic.h>
 #include "vgic.h"
+#include "trace.h"
 
 /**
  * vgic_irqfd_set_irq: inject the IRQ corresponding to the
@@ -105,6 +106,26 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	return vgic_its_inject_msi(kvm, &msi);
 }
 
+/**
+ * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
+ *
+ * Currently only direct MSI injecton is supported.
+ */
+int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
+			      struct kvm *kvm, int irq_source_id, int level,
+			      bool line_status)
+{
+	int ret;
+
+	trace_kvm_arch_set_irq_inatomic(e->gsi, e->type, level, irq_source_id);
+
+	if (unlikely(e->type != KVM_IRQ_ROUTING_MSI))
+		return -EWOULDBLOCK;
+
+	ret = kvm_set_msi(e, kvm, irq_source_id, level, line_status);
+	return ret;
+}
+
 int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
 {
 	struct kvm_irq_routing_entry *entries;
-- 
1.8.3.1
