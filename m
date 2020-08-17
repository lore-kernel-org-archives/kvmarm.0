Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C337CC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F048206C0
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UbMvti7e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F048206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EF7F4C024;
	Mon, 17 Aug 2020 06:06:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8-sY9XO8Ryip; Mon, 17 Aug 2020 06:06:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CE504BF87;
	Mon, 17 Aug 2020 06:06:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87E584BE67
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wEwrdQoLOHQR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:00 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1C864BFFD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658760;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bmwepLz9Qgc+9YdyI28alw55eNj69TIB9rPqVjcZKug=;
 b=UbMvti7ekcVmQiwXvcdll4AXWoAxCWhlbhjJab7DItcykXV0ny0Ir2bf7TYtEwlYbM95Dn
 +o9Y3UVN3C3WQc2Yh8E7hEjWVIhD+DFCaAOtUd3+zQkQWhBH2x0MkP6dZKpccjnpH5dMaY
 2jZ8V0ehMZ6EAwmtW8wNYiGA2t+liUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-98s_Q4MeNP2aRovrTpLtQA-1; Mon, 17 Aug 2020 06:05:56 -0400
X-MC-Unique: 98s_Q4MeNP2aRovrTpLtQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EB97801AC3;
 Mon, 17 Aug 2020 10:05:55 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C290C78498;
 Mon, 17 Aug 2020 10:05:52 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 04/18] arm64/kvm: Add SDEI virtualization infrastructure
Date: Mon, 17 Aug 2020 20:05:17 +1000
Message-Id: <20200817100531.83045-5-gshan@redhat.com>
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
References: <20200817100531.83045-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.004
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This adds SDEI virtualization infrastructure by introducing the source
files and data structures. Here are the details about the design:

   * The infrastructure is deisnged to route two types of SDEI events,
     which are originated from underly firmware or KVM module itself.
     Lets name them as passthrou and kvm private event separately. In
     order to identify these two types of events, bits[23:20] of the
     event number is reserved. More details can be found from the
     defined types (KVM_SDEI_EV_NUM_TYPE_{VIRT, PRIV}) in kvm_sdei.h

   * "struct kvm_sdei_event" represents the SDEI event identified by
     the event number. All the events are linked to @kvm_sdei_events
     as a link list, which is protected by lock @kvm_sdei_lock. For
     this event, its backup event could be underly firmware exposed
     physical event (struct sdei_event), or the kvm private event
     (struct kvm_sdei_priv). For the former one, the event is needed
     to be registered/unregistered/enabled/disabled from the underly
     firmware at appropriate time. We needn't do same thing for the
     later one.

   * "struct kvm_sdei_kvm_event" represents the SDEI event that has
     been registered to particular VM. All the events are organized
     as a RB-tree, whose root is "struct kvm_sdei_event". It's indexed
     by @kvm->userspace_pid.

   * "struct kvm_sdei_vcpu_event" represents the event which have been
     pending for the target vCPU. These events forms a link list through
     @vcpu->arch.sdei_events, protected by lock @vcpu->arch.sdei_lock.

For now, errno (SDEI_NOT_SUPPORTED) is returned for all SDEI hypercalls
and they will be implemented and suppoerted one by one in the subsequent
patches.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |   9 ++
 arch/arm64/include/asm/kvm_sdei.h | 111 +++++++++++++++++++++
 arch/arm64/kvm/Makefile           |   2 +-
 arch/arm64/kvm/arm.c              |   7 ++
 arch/arm64/kvm/hypercalls.c       |  19 ++++
 arch/arm64/kvm/sdei.c             | 156 ++++++++++++++++++++++++++++++
 drivers/firmware/arm_sdei.c       |  19 ++++
 include/linux/arm_sdei.h          |   4 +
 8 files changed, 326 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/kvm_sdei.h
 create mode 100644 arch/arm64/kvm/sdei.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f81151ad3d3c..2a8cfb3895f7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -336,6 +336,15 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	spinlock_t			sdei_lock;
+	bool				sdei_masked;
+	int				sdei_cpu;
+	struct user_pt_regs		sdei_normal_regs;
+	struct user_pt_regs		sdei_critical_regs;
+	struct kvm_sdei_vcpu_event	*sdei_normal_event;
+	struct kvm_sdei_vcpu_event	*sdei_critical_event;
+	struct list_head		sdei_events;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
new file mode 100644
index 000000000000..6cbf4015a371
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright Gavin Shan, Redhat Inc 2020.
+ */
+
+#ifndef __ARM64_KVM_SDEI_H__
+#define __ARM64_KVM_SDEI_H__
+
+#include <linux/bitmap.h>
+#include <linux/arm_sdei.h>
+#include <asm/kvm_host.h>
+
+struct kvm_sdei_info {
+	bool		supported;
+	bool		use_hvc;
+	unsigned long	version;
+};
+
+typedef void (*kvm_sdei_notify_func_t)(struct kvm_vcpu *vcpu,
+				       unsigned long num,
+				       unsigned int state);
+
+enum {
+	KVM_SDEI_STATE_DELIVERED,
+	KVM_SDEI_STATE_COMPLETED,
+};
+
+struct kvm_sdei_priv {
+	unsigned long		num;
+	unsigned long		type;
+	unsigned long		signaled;
+	unsigned long		priority;
+	unsigned long		route_mode;
+	unsigned long		route_affinity;
+	kvm_sdei_notify_func_t	notifier;
+};
+
+struct kvm_sdei_event;
+struct kvm_sdei_kvm_event {
+	struct kvm_sdei_event	*event;
+	struct kvm		*kvm;
+	struct rb_node		node;
+	unsigned long		users;
+
+	unsigned long		route_mode;
+	unsigned long		route_affinity;
+	unsigned long		entries[KVM_MAX_VCPUS];
+	unsigned long		params[KVM_MAX_VCPUS];
+	unsigned long		registered[BITS_TO_LONGS(KVM_MAX_VCPUS)];
+	unsigned long		enabled[BITS_TO_LONGS(KVM_MAX_VCPUS)];
+};
+
+struct kvm_sdei_vcpu_event {
+	struct kvm_sdei_kvm_event	*event;
+	unsigned long			users;
+	struct list_head		link;
+};
+
+struct kvm_sdei_event {
+	struct sdei_event	*event;
+	struct kvm_sdei_priv	*priv;
+
+	spinlock_t		lock;
+	struct rb_root		root;
+	unsigned long		count;
+
+	unsigned long		num;
+	struct list_head	link;
+};
+
+/*
+ * According to SDEI specification (v1.0), the event number spans 32-bits
+ * and the lower 24-bits are used as the (real) event number. I don't think
+ * we can use that much SDEI numbers in one system. So we reserve 4-bits
+ * from the 24-bits real event number, to indicate its type here.
+ */
+#define KVM_SDEI_EV_NUM_TYPE_SHIFT     20
+#define KVM_SDEI_EV_NUM_TYPE_MASK      0xF
+#define KVM_SDEI_EV_NUM_TYPE_PHYS      0
+#define KVM_SDEI_EV_NUM_TYPE_VIRT      1
+#define KVM_SDEI_EV_NUM_TYPE_PRIV      2
+
+#define KVM_SDEI_DECLARE_FUNC(name, value)			\
+static inline bool kvm_sdei_num_is_##name(unsigned long num)	\
+{								\
+	return (((num >> KVM_SDEI_EV_NUM_TYPE_SHIFT) &		\
+		KVM_SDEI_EV_NUM_TYPE_MASK) ==			\
+		KVM_SDEI_EV_NUM_TYPE_##value);			\
+}
+
+KVM_SDEI_DECLARE_FUNC(phys, PHYS)
+KVM_SDEI_DECLARE_FUNC(virt, VIRT)
+KVM_SDEI_DECLARE_FUNC(priv, PRIV)
+
+static inline unsigned long kvm_sdei_num_to_std(unsigned long num)
+{
+	return (num & ~(KVM_SDEI_EV_NUM_TYPE_MASK <<
+		KVM_SDEI_EV_NUM_TYPE_SHIFT));
+}
+
+static inline bool kvm_sdei_num_is_valid(unsigned long num)
+{
+	return kvm_sdei_num_is_virt(num) || kvm_sdei_num_is_priv(num);
+}
+
+int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
+void kvm_sdei_init(void);
+void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
+void kvm_sdei_destroy_vm(struct kvm *kvm);
+
+#endif /* __ARM64_KVM_SDEI_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 8d3d9513cbfe..5ebd8abd81c8 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
-	 aarch32.o arch_timer.o \
+	 aarch32.o arch_timer.o sdei.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 73e12869afe3..bb539b51cd57 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -36,6 +36,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
+#include <asm/kvm_sdei.h>
 #include <asm/sections.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -158,6 +159,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	int i;
 
+	kvm_sdei_destroy_vm(kvm);
+
 	kvm_vgic_destroy(kvm);
 
 	free_percpu(kvm->arch.last_vcpu_ran);
@@ -285,6 +288,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
+	kvm_sdei_create_vcpu(vcpu);
+
 	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
 }
 
@@ -1681,6 +1686,8 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		goto out_hyp;
 
+	kvm_sdei_init();
+
 	if (in_hyp_mode)
 		kvm_info("VHE mode initialized successfully\n");
 	else
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 550dfa3e53cd..1268465efa64 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -5,6 +5,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_sdei.h>
 
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
@@ -62,6 +63,24 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		if (gpa != GPA_INVALID)
 			val = gpa;
 		break;
+	case SDEI_1_0_FN_SDEI_VERSION:
+	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
+	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
+	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
+	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
+	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
+	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
+	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
+	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
+	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
+	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
+	case SDEI_1_0_FN_SDEI_PE_MASK:
+	case SDEI_1_0_FN_SDEI_PE_UNMASK:
+	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
+	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
+	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
+	case SDEI_1_0_FN_SDEI_SHARED_RESET:
+		return kvm_sdei_hypercall(vcpu);
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
new file mode 100644
index 000000000000..e2090e9bab8b
--- /dev/null
+++ b/arch/arm64/kvm/sdei.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright Gavin Shan, Redhat Inc 2020.
+ */
+
+#include <linux/kernel.h>
+#include <linux/rbtree.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <kvm/arm_hypercalls.h>
+#include <asm/kvm_sdei.h>
+
+static struct kvm_sdei_info *kvm_sdei_data;
+static DEFINE_SPINLOCK(kvm_sdei_lock);
+static LIST_HEAD(kvm_sdei_events);
+
+#ifdef CONFIG_ARM_SDE_INTERFACE
+static struct kvm_sdei_info *kvm_sdei_get_kvm_info(void)
+{
+	return sdei_get_kvm_info();
+}
+
+static int kvm_sdei_unregister_event(struct sdei_event *event)
+{
+	return sdei_event_unregister(event);
+}
+#else
+static inline struct kvm_sdei_info *kvm_sdei_get_kvm_info(void)
+{
+	return NULL;
+}
+
+static inline int kvm_sdei_unregister_event(struct sdei_event *event)
+{
+	return -EPERM;
+}
+#endif /* CONFIG_ARM_SDE_INTERFACE */
+
+static unsigned long kvm_sdei_reset(struct kvm *kvm, unsigned int types)
+{
+	struct kvm_sdei_event *e, *event = NULL;
+	struct kvm_sdei_kvm_event *tmp, *kevent = NULL;
+	unsigned long event_type, event_num;
+	unsigned long ret = SDEI_SUCCESS;
+
+	spin_lock(&kvm_sdei_lock);
+
+	list_for_each_entry_safe(event, e, &kvm_sdei_events, link) {
+		spin_lock(&event->lock);
+
+		/* Check if the event type is the requested one */
+		event_type = event->priv ? event->priv->type :
+					   event->event->type;
+		event_num = event->priv ? event->priv->num :
+					  event->event->event_num;
+		if (!(types & (1 << SDEI_EVENT_TYPE_PRIVATE)) &&
+		     (event_type == SDEI_EVENT_TYPE_PRIVATE)) {
+			spin_unlock(&event->lock);
+			continue;
+		}
+
+		if (!(types & (1 << SDEI_EVENT_TYPE_SHARED)) &&
+		     (event_type == SDEI_EVENT_TYPE_SHARED)) {
+			spin_unlock(&event->lock);
+			continue;
+		}
+
+		/* Remove all unused kvm events */
+		rbtree_postorder_for_each_entry_safe(kevent, tmp,
+						     &event->root, node) {
+			if (kevent->users)
+				continue;
+
+			if (kvm && kevent->kvm != kvm)
+				continue;
+
+			rb_erase(&kevent->node, &event->root);
+			kfree(kevent);
+			event->count--;
+		}
+
+		/*
+		 * Destroy the event if necessary. The passthrou event
+		 * will be unregistered if it's going to be destroyed.
+		 */
+		if (event->count) {
+			spin_unlock(&event->lock);
+			continue;
+		}
+
+		spin_unlock(&event->lock);
+		list_del(&event->link);
+		if (event->event)
+			kvm_sdei_unregister_event(event->event);
+		kfree(event);
+	}
+
+	spin_unlock(&kvm_sdei_lock);
+
+	return ret;
+}
+
+int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
+{
+	u32 function = smccc_get_function(vcpu);
+	unsigned long ret;
+
+	switch (function) {
+	case SDEI_1_0_FN_SDEI_VERSION:
+	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
+	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
+	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
+	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
+	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
+	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
+	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
+	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
+	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
+	case SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET:
+	case SDEI_1_0_FN_SDEI_PE_MASK:
+	case SDEI_1_0_FN_SDEI_PE_UNMASK:
+	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
+	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
+	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
+	case SDEI_1_0_FN_SDEI_SHARED_RESET:
+	default:
+		ret = SDEI_NOT_SUPPORTED;
+	}
+
+	smccc_set_retval(vcpu, ret, 0, 0, 0);
+
+	return 1;
+}
+
+void kvm_sdei_init(void)
+{
+	kvm_sdei_data = kvm_sdei_get_kvm_info();
+}
+
+void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.sdei_masked = true;
+	vcpu->arch.sdei_cpu = INT_MAX;
+	vcpu->arch.sdei_normal_event = NULL;
+	vcpu->arch.sdei_critical_event = NULL;
+	spin_lock_init(&vcpu->arch.sdei_lock);
+	INIT_LIST_HEAD(&vcpu->arch.sdei_events);
+}
+
+void kvm_sdei_destroy_vm(struct kvm *kvm)
+{
+	unsigned int types = ((1 << SDEI_EVENT_TYPE_PRIVATE) |
+			      (1 << SDEI_EVENT_TYPE_SHARED));
+
+	kvm_sdei_reset(kvm, types);
+}
diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 6bc84ab317d3..e6fc390615ba 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -32,6 +32,9 @@
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
+#ifdef CONFIG_KVM
+#include <asm/kvm_sdei.h>
+#endif
 
 /*
  * The call to use to reach the firmware.
@@ -68,6 +71,9 @@ static DEFINE_MUTEX(sdei_events_lock);
 /* and then hold this when modifying the list */
 static DEFINE_SPINLOCK(sdei_list_lock);
 static LIST_HEAD(sdei_list);
+#ifdef CONFIG_KVM
+static struct kvm_sdei_info kvm_sdei_data;
+#endif
 
 /* Private events are registered/enabled via IPI passing one of these */
 struct sdei_crosscall_args {
@@ -1042,6 +1048,12 @@ static int sdei_probe(struct platform_device *pdev)
 		goto remove_reboot;
 	}
 
+#ifdef CONFIG_KVM
+	kvm_sdei_data.supported = true;
+	kvm_sdei_data.use_hvc = (conduit == SMCCC_CONDUIT_HVC);
+	kvm_sdei_data.version = ver;
+#endif
+
 	return 0;
 
 remove_reboot:
@@ -1119,6 +1131,13 @@ static int __init sdei_init(void)
  */
 subsys_initcall_sync(sdei_init);
 
+#ifdef CONFIG_KVM
+struct kvm_sdei_info *sdei_get_kvm_info(void)
+{
+	return &kvm_sdei_data;
+}
+#endif
+
 int sdei_event_handler(struct pt_regs *regs,
 		       struct sdei_registered_event *arg)
 {
diff --git a/include/linux/arm_sdei.h b/include/linux/arm_sdei.h
index 28d5d5853314..055b298b1f37 100644
--- a/include/linux/arm_sdei.h
+++ b/include/linux/arm_sdei.h
@@ -83,6 +83,10 @@ struct sdei_registered_event {
 	u8			 priority;
 };
 
+#ifdef CONFIG_KVM
+struct kvm_sdei_info *sdei_get_kvm_info(void);
+#endif
+
 /* The arch code entry point should then call this when an event arrives. */
 int notrace sdei_event_handler(struct pt_regs *regs,
 			       struct sdei_registered_event *arg);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
