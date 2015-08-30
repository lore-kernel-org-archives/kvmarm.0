From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 1/2] arm/arm64: KVM: Add tracepoints for vgic and timer
Date: Sun, 30 Aug 2015 15:55:21 +0200
Message-ID: <1440942922-23955-2-git-send-email-christoffer.dall@linaro.org>
References: <1440942922-23955-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942922-23955-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The VGIC and timer code for KVM arm/arm64 doesn't have any tracepoints
or tracepoint infrastructure defined.  Rewriting some of the timer code
handling showed me how much we need this, so let's add these simple
trace points once and for all and we can easily expand with additional
trace points in these files as we go along.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c |  4 ++
 virt/kvm/arm/trace.h      | 97 +++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic.c       |  9 +++++
 3 files changed, 110 insertions(+)
 create mode 100644 virt/kvm/arm/trace.h

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 8a0fdfc..f63b208 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -28,6 +28,8 @@
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
 
+#include "trace.h"
+
 static struct timecounter *timecounter;
 static struct workqueue_struct *wqueue;
 static unsigned int host_vtimer_irq;
@@ -128,6 +130,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu)
 
 	BUG_ON(!vgic_initialized(vcpu->kvm));
 
+	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
+				   timer->irq->level);
 	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
 					 timer->map,
 					 timer->irq.level);
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
new file mode 100644
index 0000000..48c3c90
--- /dev/null
+++ b/virt/kvm/arm/trace.h
@@ -0,0 +1,97 @@
+#if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KVM_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+
+/*
+ * Tracepoints for vgic
+ */
+TRACE_EVENT(kvm_vgic_set_irqchip_active,
+	TP_PROTO(unsigned long vcpu_id, __u32 irq),
+	TP_ARGS(vcpu_id, irq),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_id	)
+		__field(	__u32,		irq	)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+		__entry->irq		= irq;
+	),
+
+	TP_printk("VCPU: %ld, IRQ %d", __entry->vcpu_id, __entry->irq)
+);
+
+TRACE_EVENT(kvm_vgic_clear_irqchip_active,
+	TP_PROTO(unsigned long vcpu_id, __u32 irq),
+	TP_ARGS(vcpu_id, irq),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_id	)
+		__field(	__u32,		irq	)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+		__entry->irq		= irq;
+	),
+
+	TP_printk("VCPU: %ld, IRQ %d", __entry->vcpu_id, __entry->irq)
+);
+
+TRACE_EVENT(vgic_update_irq_pending,
+	TP_PROTO(unsigned long vcpu_id, __u32 irq, bool level),
+	TP_ARGS(vcpu_id, irq, level),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_id	)
+		__field(	__u32,		irq	)
+		__field(	bool,		level	)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+		__entry->irq		= irq;
+		__entry->level		= level;
+	),
+
+	TP_printk("VCPU: %ld, IRQ %d, level: %d",
+		  __entry->vcpu_id, __entry->irq, __entry->level)
+);
+
+/*
+ * Tracepoints for arch_timer
+ */
+TRACE_EVENT(kvm_timer_inject_irq,
+	TP_PROTO(unsigned long vcpu_id, __u32 irq, int level),
+	TP_ARGS(vcpu_id, irq, level),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_id	)
+		__field(	__u32,		irq	)
+		__field(	int,		level	)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+		__entry->irq		= irq;
+		__entry->level		= level;
+	),
+
+	TP_printk("VCPU: %ld, IRQ %d, level %d",
+		  __entry->vcpu_id, __entry->irq, __entry->level)
+);
+
+#endif /* _TRACE_KVM_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../../virt/kvm/arm
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index f4ea950..45c95a0 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -34,6 +34,9 @@
 #include <asm/kvm.h>
 #include <kvm/iodev.h>
 
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
 /*
  * How the whole thing works (courtesy of Christoffer Dall):
  *
@@ -1314,6 +1317,8 @@ epilog:
 			struct irq_phys_map *map;
 			map = vgic_irq_map_search(vcpu, vlr.irq);
 
+			trace_kvm_vgic_set_irqchip_active(vcpu->vcpu_id,
+							  vlr.irq);
 			ret = irq_set_irqchip_state(map->irq,
 						    IRQCHIP_STATE_ACTIVE,
 						    true);
@@ -1449,6 +1454,8 @@ static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
 		 * non-active so that other VMs can see interrupts from this
 		 * device.
 		 */
+		trace_kvm_vgic_clear_irqchip_active(vcpu->vcpu_id,
+						    vlr.irq);
 		ret = irq_set_irqchip_state(map->irq,
 					    IRQCHIP_STATE_ACTIVE,
 					    false);
@@ -1585,6 +1592,8 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	int enabled;
 	bool ret = true, can_inject = true;
 
+	trace_vgic_update_irq_pending(cpuid, irq_num, level);
+
 	if (irq_num >= min(kvm->arch.vgic.nr_irqs, 1020))
 		return -EINVAL;
 
-- 
2.1.2.330.g565301e.dirty

