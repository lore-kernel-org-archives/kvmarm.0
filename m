Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B171EC433E3
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:13:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 687F42078D
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="altCK07T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 687F42078D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B954BE6E;
	Mon, 17 Aug 2020 21:13:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EcBYMBHPj5yA; Mon, 17 Aug 2020 21:13:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6F824C298;
	Mon, 17 Aug 2020 21:13:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ACAD4C2A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fBzsf8j8LILg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 21:13:45 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF1C4B971
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597713225;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/UyUZQlFNZNonbrtgfwk4rC2lg/6HG7WraLj4YOSyLs=;
 b=altCK07T3rd9xepNgQHqXHPnyQLkmHVLRJXSgg/Bgxof7XEpxRSSSp7Ab/4elPzS+n4KU9
 Nr1w4/WpuzQbUvNzLiF1vJ7kOY3qkWxLmrvZ5a3MrCE+3qviholEK46xLFOlJ4ABvBCvci
 wSu9vSDK2tX0UXpk/G1/KyB9mZQcX4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-cUeJzmjrPvKtynnJfTD_zg-1; Mon, 17 Aug 2020 21:13:43 -0400
X-MC-Unique: cUeJzmjrPvKtynnJfTD_zg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A3B61005E5F;
 Tue, 18 Aug 2020 01:13:42 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 735F25D9D2;
 Tue, 18 Aug 2020 01:13:39 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 4/6] arm64/kvm: Support async page fault
Date: Tue, 18 Aug 2020 11:13:17 +1000
Message-Id: <20200818011319.91777-5-gshan@redhat.com>
In-Reply-To: <20200818011319.91777-1-gshan@redhat.com>
References: <20200818011319.91777-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com, will@kernel.org
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

There are two stages of page fault. The guest kernel is responsible
for handling stage one page fault, while the host kernel is to take
care of the stage two page fault. When page fault is triggered because
of stage two page fault, the guest is suspended until the requested
memory (page) is populated. Sometimes, the cost to populate the requested
page isn't cheap and can take hundreds of milliseconds in extreme
cases. This impacts the overall guest's performance.

In order to resolve the issue and improve the guest's performance,
this introduces the feature (asychronous page fault). A page-not-present
notification is fired to guest if the requested page isn't ready so that
the guest can reschedule current process and pick another process to run.
Another page-ready notification is sent to guest so that the process,
which was rescheduled previously, can be picked up to run. With this,
the guest needn't necessarily suspend itself on stage two page fault.
These two notificatons are associated by so-called vCPU scoped tokens,
which is the combination of incremental sequence number and vCPU index
(@vcpu->vcpu_idx). Besides, the notifications are conveyed by SDEI and
PPI, whose numbers are specified by guest through SMCCC interface.

The asynchronous page fault always starts with a background woker if
current vCPU has enough token space and no pending notifications. After
the worker, which populates the requested page background, is started,
a page-not-present notification, together with an unique token, are sent
to guest through the specified private SDEI event. The notification is
acknowledged by clearing the shared cache (@vcpu->apf.cache). The current
process is marked for waiting completion of asynchronous page fault. A
subsequent (reschedule) IPI is sent to current vCPU so that the current
process can be reschedule and suspended until the asynchronous page is
completed. In the meanwhile, the woker populates the requested page and
it's queued to the completion queue once the task is completed. At this
point or the acknoledgement (by SMCCC) on pending PPI, a PPI is sent to
guest for page-ready notification. The guest uses the associated token
to locate the suspended process and wakes it up.

In order to fulfil the functions, there are several SMCCC function IDs
introduced and outlined as below:

   ARM_SMCCC_KVM_FUNC_APF_VERSION
      Returns the version, which can be used to identify ABI changes in
      the future.
   ARM_SMCCC_KVM_FUNC_APF_ENABLE
      Enable or disable asynchronous page fault on current vCPU.
   ARM_SMCCC_KVM_FUNC_APF_TOKEN_NUM
      Returns maximal number of tokens that current vCPU can have. It's
      used by guest to allocate the required resources.
   ARM_SMCCC_KVM_FUNC_APF_SDEI
   ARM_SMCCC_KVM_FUNC_APF_IRQ
      Used by guest to confiugre the SDEI event and PPI numbers.
   ARM_SMCCC_KVM_FUNC_APF_IRQ_ACK
      Acknowledge the page-ready notificaton in the PPI handler.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h      |  50 +++
 arch/arm64/include/asm/kvm_para.h      |  27 ++
 arch/arm64/include/uapi/asm/Kbuild     |   2 -
 arch/arm64/include/uapi/asm/kvm_para.h |  23 ++
 arch/arm64/kvm/Kconfig                 |   1 +
 arch/arm64/kvm/Makefile                |   1 +
 arch/arm64/kvm/arm.c                   |  45 ++-
 arch/arm64/kvm/async_pf.c              | 462 +++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c            |   8 +
 arch/arm64/kvm/mmu.c                   |  29 +-
 arch/arm64/kvm/sdei.c                  |   8 +
 include/linux/arm-smccc.h              |  15 +
 12 files changed, 665 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_para.h
 create mode 100644 arch/arm64/include/uapi/asm/kvm_para.h
 create mode 100644 arch/arm64/kvm/async_pf.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b6c9851b2a65..2e3bba6a99c3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,6 +46,7 @@
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_SDEI		KVM_ARCH_REQ(5)
+#define KVM_REQ_APF_READY	KVM_ARCH_REQ(6)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
@@ -239,6 +240,23 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+#ifdef CONFIG_KVM_ASYNC_PF
+
+/* Should be a power of two number */
+#define ASYNC_PF_PER_VCPU	64
+
+/*
+ * The association of gfn and token. The token will be sent to guest as
+ * page fault address. Also, the guest could be in aarch32 mode. So its
+ * length should be 32-bits.
+ */
+struct kvm_arch_async_pf {
+	u32     token;
+	gfn_t   gfn;
+	u32     esr;
+};
+#endif /* CONFIG_KVM_ASYNC_PF */
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
@@ -346,6 +364,22 @@ struct kvm_vcpu_arch {
 	struct kvm_sdei_vcpu_event	*sdei_normal_event;
 	struct kvm_sdei_vcpu_event	*sdei_critical_event;
 	struct list_head		sdei_events;
+
+#ifdef CONFIG_KVM_ASYNC_PF
+	struct {
+		struct gfn_to_hva_cache	cache;
+		gfn_t			gfns[ASYNC_PF_PER_VCPU];
+		u64			control_block;
+		bool			send_user_only;
+		u64			sdei_event_num;
+		u32			irq;
+
+		u16			id;
+		bool			notpresent_pending;
+		u32			notpresent_token;
+		bool			pageready_pending;
+	} apf;
+#endif
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -566,6 +600,22 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
+#ifdef CONFIG_KVM_ASYNC_PF
+bool kvm_async_pf_hash_find(struct kvm_vcpu *vcpu, gfn_t gfn);
+bool kvm_arch_async_not_present_allowed(struct kvm_vcpu *vcpu);
+int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, u32 esr, gpa_t gpa,
+			    gfn_t gfn);
+bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
+				     struct kvm_async_pf *work);
+void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu);
+bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
+void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
+			       struct kvm_async_pf *work);
+void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
+				 struct kvm_async_pf *work);
+long kvm_async_pf_hypercall(struct kvm_vcpu *vcpu);
+#endif /* CONFIG_KVM_ASYNC_PF */
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
new file mode 100644
index 000000000000..0ea481dd1c7a
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_para.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM_KVM_PARA_H
+#define _ASM_ARM_KVM_PARA_H
+
+#include <uapi/asm/kvm_para.h>
+
+static inline bool kvm_check_and_clear_guest_paused(void)
+{
+	return false;
+}
+
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return 0;
+}
+
+static inline unsigned int kvm_arch_para_hints(void)
+{
+	return 0;
+}
+
+static inline bool kvm_para_available(void)
+{
+	return false;
+}
+
+#endif /* _ASM_ARM_KVM_PARA_H */
diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
index 602d137932dc..f66554cd5c45 100644
--- a/arch/arm64/include/uapi/asm/Kbuild
+++ b/arch/arm64/include/uapi/asm/Kbuild
@@ -1,3 +1 @@
 # SPDX-License-Identifier: GPL-2.0
-
-generic-y += kvm_para.h
diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
new file mode 100644
index 000000000000..f0dbe86c2374
--- /dev/null
+++ b/arch/arm64/include/uapi/asm/kvm_para.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_ARM_KVM_PARA_H
+#define _UAPI_ASM_ARM_KVM_PARA_H
+
+#include <linux/types.h>
+
+#define KVM_FEATURE_ASYNC_PF	0
+
+/* Async PF */
+#define KVM_ASYNC_PF_ENABLED		(1 << 0)
+#define KVM_ASYNC_PF_SEND_ALWAYS	(1 << 1)
+
+#define KVM_PV_REASON_PAGE_NOT_PRESENT	1
+#define KVM_PV_REASON_PAGE_READY	2
+
+struct kvm_vcpu_pv_apf_data {
+	__u32	reason;
+	__u32	token;
+	__u8	pad[56];
+	__u32	enabled;
+};
+
+#endif /* _UAPI_ASM_ARM_KVM_PARA_H */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 13489aff4440..6dd843be8e10 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -32,6 +32,7 @@ menuconfig KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select KVM_ASYNC_PF
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 5ebd8abd81c8..f99fcccb8cc6 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,3 +25,4 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
+kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o async_pf.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4bec6c9ece18..1a57dc5dbf14 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -225,6 +225,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 */
 		r = 1;
 		break;
+#ifdef CONFIG_KVM_ASYNC_PF
+	case KVM_CAP_ASYNC_PF:
+	case KVM_CAP_ASYNC_PF_INT:
+		r = 1;
+		break;
+#endif
 	default:
 		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
 		break;
@@ -274,6 +280,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+#ifdef CONFIG_KVM_ASYNC_PF
+	vcpu->arch.apf.control_block = 0UL;
+#endif
 
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
@@ -432,8 +441,32 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
-	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off && !v->arch.pause);
+
+	if ((irq_lines || kvm_vgic_vcpu_pending_irq(v)) &&
+	    !v->arch.power_off && !v->arch.pause)
+		return true;
+
+#ifdef CONFIG_KVM_ASYNC_PF
+	if (v->arch.apf.control_block & KVM_ASYNC_PF_ENABLED) {
+		u32 val;
+		int ret;
+
+		if (!list_empty_careful(&v->async_pf.done))
+			return true;
+
+		ret = kvm_read_guest_offset_cached(v->kvm, &v->arch.apf.cache,
+						   &val, 0, sizeof(val));
+		if (ret || val)
+			return true;
+
+		ret = kvm_read_guest_offset_cached(v->kvm, &v->arch.apf.cache,
+						   &val, 4, sizeof(val));
+		if (ret || val)
+			return true;
+	}
+#endif
+
+	return false;
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -624,6 +657,11 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
 
+#ifdef CONFIG_KVM_ASYNC_PF
+		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
+			kvm_check_async_pf_completion(vcpu);
+#endif
+
 		if (kvm_check_request(KVM_REQ_SDEI, vcpu))
 			kvm_sdei_deliver(vcpu);
 
@@ -739,7 +777,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || need_new_vmid_gen(&vcpu->kvm->arch.vmid) ||
-		    kvm_request_pending(vcpu)) {
+		    (kvm_request_pending(vcpu) &&
+		     READ_ONCE(vcpu->requests) != (1UL << KVM_REQ_APF_READY))) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
diff --git a/arch/arm64/kvm/async_pf.c b/arch/arm64/kvm/async_pf.c
new file mode 100644
index 000000000000..910cb3a1bdc2
--- /dev/null
+++ b/arch/arm64/kvm/async_pf.c
@@ -0,0 +1,462 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright Gavin Shan, Redhat Inc 2020.
+ *
+ * Asynchronous page fault support
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_emulate.h>
+#include <kvm/arm_hypercalls.h>
+#include <kvm/arm_vgic.h>
+#include <asm/kvm_sdei.h>
+
+static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
+{
+	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
+}
+
+static inline u32 kvm_async_pf_hash_next(u32 key)
+{
+	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
+}
+
+static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
+		vcpu->arch.apf.gfns[i] = ~0;
+}
+
+/*
+ * Add gfn to the hash table. It's ensured there is a free entry
+ * when this function is called.
+ */
+static void kvm_async_pf_hash_add(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 key = kvm_async_pf_hash_fn(gfn);
+
+	while (vcpu->arch.apf.gfns[key] != ~0)
+		key = kvm_async_pf_hash_next(key);
+
+	vcpu->arch.apf.gfns[key] = gfn;
+}
+
+static u32 kvm_async_pf_hash_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 key = kvm_async_pf_hash_fn(gfn);
+	int i;
+
+	for (i = 0; i < ASYNC_PF_PER_VCPU; i++) {
+		if (vcpu->arch.apf.gfns[key] == gfn ||
+		    vcpu->arch.apf.gfns[key] == ~0)
+			break;
+
+		key = kvm_async_pf_hash_next(key);
+	}
+
+	return key;
+}
+
+static void kvm_async_pf_hash_remove(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 i, j, k;
+
+	i = j = kvm_async_pf_hash_slot(vcpu, gfn);
+	while (true) {
+		vcpu->arch.apf.gfns[i] = ~0;
+
+		do {
+			j = kvm_async_pf_hash_next(j);
+			if (vcpu->arch.apf.gfns[j] == ~0)
+				return;
+
+			k = kvm_async_pf_hash_fn(vcpu->arch.apf.gfns[j]);
+			/*
+			 * k lies cyclically in ]i,j]
+			 * |    i.k.j |
+			 * |....j i.k.| or  |.k..j i...|
+			 */
+		} while ((i <= j) ? (i < k && k <= j) : (i < k || k <= j));
+
+		vcpu->arch.apf.gfns[i] = vcpu->arch.apf.gfns[j];
+		i = j;
+	}
+}
+
+bool kvm_async_pf_hash_find(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u32 key = kvm_async_pf_hash_slot(vcpu, gfn);
+
+	return vcpu->arch.apf.gfns[key] == gfn;
+}
+
+static inline int kvm_async_pf_read_cache(struct kvm_vcpu *vcpu,
+					  u32 offset, u32 *val)
+{
+	return kvm_read_guest_offset_cached(vcpu->kvm,
+					    &vcpu->arch.apf.cache,
+					    val, offset, sizeof(*val));
+}
+
+static inline int kvm_async_pf_write_cache(struct kvm_vcpu *vcpu,
+					   u32 offset, u32 val)
+{
+	return kvm_write_guest_offset_cached(vcpu->kvm,
+					     &vcpu->arch.apf.cache,
+					     &val, offset, sizeof(val));
+}
+
+bool kvm_arch_async_not_present_allowed(struct kvm_vcpu *vcpu)
+{
+	u32 val;
+	int ret;
+
+	if (!(vcpu->arch.apf.control_block & KVM_ASYNC_PF_ENABLED))
+		return false;
+
+	if (vcpu->arch.apf.send_user_only && vcpu_mode_priv(vcpu))
+		return false;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return false;
+
+	if (vcpu->arch.sdei_critical_event ||
+	    vcpu->arch.sdei_normal_event)
+		return false;
+
+	/* Pending page fault, which isn't acknowledged by guest */
+	ret = kvm_async_pf_read_cache(vcpu, 0, &val);
+	if (ret || val)
+		return false;
+
+	ret = kvm_async_pf_read_cache(vcpu, 4, &val);
+	if (ret || val)
+		return false;
+
+	return true;
+}
+
+int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
+			    u32 esr, gpa_t gpa, gfn_t gfn)
+{
+	struct kvm_arch_async_pf arch;
+	unsigned long hva = kvm_vcpu_gfn_to_hva(vcpu, gfn);
+
+	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
+	arch.gfn = gfn;
+	arch.esr = esr;
+
+	return kvm_setup_async_pf(vcpu, gpa, hva, &arch);
+}
+
+/*
+ * It's guaranteed that no pending asynchronous page fault when this is
+ * called. It means all previous issued asynchronous page faults have
+ * been acknowledged.
+ */
+bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
+				     struct kvm_async_pf *work)
+{
+	kvm_async_pf_hash_add(vcpu, work->arch.gfn);
+
+	if (kvm_async_pf_write_cache(vcpu, 4, work->arch.token) ||
+	    kvm_async_pf_write_cache(vcpu, 0, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
+		kvm_err("%s: Error to write token (0x%08x)\n",
+			__func__, work->arch.token);
+		kvm_async_pf_write_cache(vcpu, 4, 0);
+		kvm_async_pf_write_cache(vcpu, 0, 0);
+		kvm_async_pf_hash_remove(vcpu, work->arch.gfn);
+		return false;
+	}
+
+	vcpu->arch.apf.notpresent_pending = true;
+	vcpu->arch.apf.notpresent_token = work->arch.token;
+
+	return !kvm_sdei_inject(vcpu, vcpu->arch.apf.sdei_event_num, false);
+}
+
+static void kvm_arch_async_sdei_notifier(struct kvm_vcpu *vcpu,
+					 unsigned long num,
+					 unsigned int state)
+{
+	if (num != vcpu->arch.apf.sdei_event_num) {
+		kvm_err("%s: Illegal event number %lu (%llu)\n",
+			__func__, num, vcpu->arch.apf.sdei_event_num);
+		return;
+	}
+
+	switch (state) {
+	case KVM_SDEI_STATE_DELIVERED:
+		if (!vcpu->arch.apf.notpresent_pending)
+			break;
+
+		vcpu->arch.apf.notpresent_token = 0;
+		vcpu->arch.apf.notpresent_pending = false;
+		break;
+	case KVM_SDEI_STATE_COMPLETED:
+		break;
+	default:
+		kvm_err("%s: Illegal state %d for event %lu\n",
+			__func__, state, num);
+	}
+}
+
+void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
+{
+	kvm_make_request(KVM_REQ_APF_READY, vcpu);
+	if (!vcpu->arch.apf.pageready_pending)
+		kvm_vcpu_kick(vcpu);
+}
+
+bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
+{
+	struct kvm_async_pf *work;
+	u32 reason, token;
+
+	if (!(vcpu->arch.apf.control_block & KVM_ASYNC_PF_ENABLED))
+		return true;
+
+	if (vcpu->arch.apf.pageready_pending)
+		goto fail;
+
+	if (kvm_async_pf_read_cache(vcpu, 0, &reason) ||
+	    kvm_async_pf_read_cache(vcpu, 4, &token)) {
+		kvm_err("%s: Error to read cache\n",
+			__func__);
+		goto fail;
+	}
+
+	/*
+	 * There might be pending page-not-present notification (SDEI)
+	 * to be delivered. However, the corresponding work has been
+	 * completed. For this case, we need to cancel the notification
+	 * early to avoid the overhead because of the injected SDEI
+	 * and interrupt.
+	 */
+	if (vcpu->arch.apf.notpresent_pending) {
+		spin_lock(&vcpu->async_pf.lock);
+		work = list_first_entry_or_null(&vcpu->async_pf.done,
+						typeof(*work), link);
+		spin_unlock(&vcpu->async_pf.lock);
+		if (!work)
+			goto fail;
+
+		if (reason == KVM_PV_REASON_PAGE_NOT_PRESENT &&
+		    work->arch.token == vcpu->arch.apf.notpresent_token &&
+		    token == vcpu->arch.apf.notpresent_token) {
+			kvm_make_request(KVM_REQ_APF_READY, vcpu);
+			return true;
+		}
+	}
+
+	if (reason || token)
+		goto fail;
+
+	return true;
+
+fail:
+	kvm_make_request(KVM_REQ_APF_READY, vcpu);
+	return false;
+}
+
+void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
+			       struct kvm_async_pf *work)
+{
+	struct kvm_memory_slot *memslot;
+	unsigned int esr = work->arch.esr;
+	phys_addr_t gpa = work->cr2_or_gpa;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	unsigned long hva;
+	bool write_fault, writable;
+	int idx;
+
+	/*
+	 * We shouldn't issue prefault for special work to wake up
+	 * all pending tasks because the associated token (address)
+	 * is invalid.
+	 */
+	if (work->wakeup_all)
+		return;
+
+	/*
+	 * The gpa was validated before the work is started. However, the
+	 * memory slots might be changed since then. So we need to redo the
+	 * validatation here.
+	 */
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	write_fault = (esr_get_trap_class(esr) != ESR_ELx_EC_IABT_LOW &&
+		       (esr_is_dabt_wnr(esr) || esr_is_dabt_iss1tw(esr)));
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
+	if (kvm_is_error_hva(hva) || (write_fault && !writable))
+		goto out;
+
+	kvm_handle_user_mem_abort(vcpu, gpa, memslot, hva, esr, true);
+
+out:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+}
+
+
+/*
+ * It's guaranteed that no pending asynchronous page fault when this is
+ * called. It means all previous issued asynchronous page faults have
+ * been acknowledged.
+ */
+void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
+				 struct kvm_async_pf *work)
+{
+	/*
+	 * The work might have been completed. In this case, we cancel
+	 * the page-not-present notification to avoid unnecessary overhead
+	 * which is introduced by SDEI event delivery and subsequent IRQ
+	 * context.
+	 */
+	if (work->wakeup_all) {
+		work->arch.token = ~0;
+	} else {
+		kvm_async_pf_hash_remove(vcpu, work->arch.gfn);
+
+		if (vcpu->arch.apf.notpresent_pending &&
+		    vcpu->arch.apf.notpresent_token == work->arch.token &&
+		    kvm_sdei_cancel(vcpu, vcpu->arch.apf.sdei_event_num)) {
+			kvm_async_pf_write_cache(vcpu, 4, 0);
+			kvm_async_pf_write_cache(vcpu, 0, 0);
+			vcpu->arch.apf.notpresent_pending = false;
+			vcpu->arch.apf.notpresent_token = 0;
+			return;
+		}
+	}
+
+	if (kvm_async_pf_write_cache(vcpu, 4, work->arch.token) ||
+	    kvm_async_pf_write_cache(vcpu, 0, KVM_PV_REASON_PAGE_READY)) {
+		kvm_async_pf_write_cache(vcpu, 4, 0);
+		kvm_async_pf_write_cache(vcpu, 0, 0);
+		kvm_err("%s: Error to token (0x%08x)\n",
+			__func__, work->arch.token);
+		return;
+	}
+
+	vcpu->arch.apf.pageready_pending = true;
+	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_idx,
+			    vcpu->arch.apf.irq, true, NULL);
+}
+
+long kvm_async_pf_hypercall(struct kvm_vcpu *vcpu)
+{
+	u32 func;
+	u64 data;
+	gpa_t gpa;
+	bool enabled, enable;
+	int err;
+	long ret = SMCCC_RET_SUCCESS;
+
+	func = smccc_get_arg1(vcpu);
+	switch (func) {
+	case ARM_SMCCC_KVM_FUNC_APF_VERSION:
+		/* v1.0.0 */
+		ret = 0x010000;
+		break;
+	case ARM_SMCCC_KVM_FUNC_APF_TOKEN_NUM:
+		ret = ARRAY_SIZE(vcpu->arch.apf.gfns);
+		break;
+	case ARM_SMCCC_KVM_FUNC_APF_ENABLE:
+		data = (smccc_get_arg3(vcpu) << 32) | smccc_get_arg2(vcpu);
+		gpa = (data & ~0x3F);
+
+		/* Bail if the state transition isn't allowed */
+		enabled = !!(vcpu->arch.apf.control_block &
+			     KVM_ASYNC_PF_ENABLED);
+		enable = !!(data & KVM_ASYNC_PF_ENABLED);
+		if (enable == enabled) {
+			kvm_debug("%s: Async PF has been %s (0x%llx -> 0x%llx)\n",
+				  __func__, enabled ? "enabled" : "disabled",
+				  vcpu->arch.apf.control_block, data);
+			ret = SMCCC_RET_NOT_REQUIRED;
+			break;
+		}
+
+		/* To disable the functinality */
+		if (!enable) {
+			kvm_clear_async_pf_completion_queue(vcpu);
+			vcpu->arch.apf.control_block = data;
+			break;
+		}
+
+		/*
+		 * To enable the functionality. The SDEI event or IRQ number
+		 * should have been configured in advance.
+		 */
+		if (!vcpu->arch.apf.sdei_event_num || !vcpu->arch.apf.irq) {
+			kvm_err("%s: Invalid SDEI event or IRQ number\n",
+				__func__);
+			ret = SMCCC_RET_INVALID_PARAMETER;
+			break;
+		}
+
+		/* Register SDEI event notifier */
+		err = kvm_sdei_register_notifier(vcpu->arch.apf.sdei_event_num,
+						 kvm_arch_async_sdei_notifier);
+		if (err) {
+			kvm_err("%s: Error %d registering SDEI notifier\n",
+				__func__, err);
+			ret = SMCCC_RET_NOT_SUPPORTED;
+			break;
+		}
+
+		/* Initialize cache shared by host and guest */
+		err = kvm_gfn_to_hva_cache_init(vcpu->kvm,
+						&vcpu->arch.apf.cache,
+						gpa, sizeof(u64));
+		if (err) {
+			kvm_err("%s: Error %d initializing cache\n",
+				__func__, err);
+			ret = SMCCC_RET_NOT_SUPPORTED;
+			break;
+		}
+
+		/* Flush the token table */
+		kvm_async_pf_hash_reset(vcpu);
+		vcpu->arch.apf.send_user_only =
+			!(data & KVM_ASYNC_PF_SEND_ALWAYS);
+		kvm_async_pf_wakeup_all(vcpu);
+		vcpu->arch.apf.control_block = data;
+
+		break;
+	case ARM_SMCCC_KVM_FUNC_APF_SDEI:
+	case ARM_SMCCC_KVM_FUNC_APF_IRQ:
+		if (!irqchip_in_kernel(vcpu->kvm)) {
+			ret = SMCCC_RET_NOT_SUPPORTED;
+			break;
+		}
+
+		if (vcpu->arch.apf.control_block & KVM_ASYNC_PF_ENABLED) {
+			ret = SMCCC_RET_NOT_REQUIRED;
+			break;
+		}
+
+		if (func == ARM_SMCCC_KVM_FUNC_APF_SDEI)
+			vcpu->arch.apf.sdei_event_num = smccc_get_arg2(vcpu);
+		else
+			vcpu->arch.apf.irq = smccc_get_arg2(vcpu);
+
+		break;
+	case ARM_SMCCC_KVM_FUNC_APF_IRQ_ACK:
+		if (!vcpu->arch.apf.pageready_pending)
+			break;
+
+		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_idx,
+				    vcpu->arch.apf.irq, false, NULL);
+		vcpu->arch.apf.pageready_pending = false;
+		kvm_check_async_pf_completion(vcpu);
+		break;
+	default:
+		ret = SMCCC_RET_NOT_SUPPORTED;
+	}
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index cd48fd724a52..ae7e07aaa521 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -71,7 +71,15 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
+#ifdef CONFIG_KVM_ASYNC_PF
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_APF);
+#endif
 		break;
+#ifdef CONFIG_KVM_ASYNC_PF
+	case ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID:
+		val[0] = kvm_async_pf_hypercall(vcpu);
+		break;
+#endif
 	case SDEI_1_0_FN_SDEI_VERSION:
 	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
 	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b23778392aa1..81579bdab4a8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1787,6 +1787,30 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
 	return PAGE_SIZE;
 }
 
+static bool try_async_pf(struct kvm_vcpu *vcpu, u32 esr, gpa_t gpa,
+			 gfn_t gfn, kvm_pfn_t *pfn, bool write,
+			 bool *writable, bool prefault)
+{
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+#ifdef CONFIG_KVM_ASYNC_PF
+	bool async = false;
+
+	/* Bail if *pfn has correct page */
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
+	if (!async)
+		return false;
+
+	if (!prefault && kvm_arch_async_not_present_allowed(vcpu)) {
+		if (kvm_async_pf_hash_find(vcpu, gfn) ||
+		    kvm_arch_setup_async_pf(vcpu, esr, gpa, gfn))
+			return true;
+	}
+#endif
+
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
+	return false;
+}
+
 int kvm_handle_user_mem_abort(struct kvm_vcpu *vcpu,
 			      phys_addr_t fault_ipa,
 			      struct kvm_memory_slot *memslot,
@@ -1870,7 +1894,10 @@ int kvm_handle_user_mem_abort(struct kvm_vcpu *vcpu,
 	 */
 	smp_rmb();
 
-	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
+	if (try_async_pf(vcpu, esr, fault_ipa, gfn, &pfn,
+			 write_fault, &writable, prefault))
+		return 1;
+
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 2c05edcb3fbb..8a9df119fa73 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -22,6 +22,14 @@ static struct kvm_sdei_priv kvm_sdei_privs[] = {
 	  0,
 	  NULL
 	},
+	{ 0x40200001,   /* Asynchronous page fault */
+	  SDEI_EVENT_TYPE_PRIVATE,
+	  1,
+	  SDEI_EVENT_PRIORITY_CRITICAL,
+	  SDEI_EVENT_REGISTER_RM_ANY,
+	  0,
+	  NULL
+	},
 };
 
 #ifdef CONFIG_ARM_SDE_INTERFACE
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 1c699fc6dc12..31a061a3a093 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -116,6 +116,7 @@
 
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_APF			1
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -125,6 +126,20 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
 			   ARM_SMCCC_KVM_FUNC_FEATURES)
 
+/* Async page fault service */
+#define ARM_SMCCC_KVM_FUNC_APF_VERSION		0
+#define ARM_SMCCC_KVM_FUNC_APF_ENABLE		1
+#define ARM_SMCCC_KVM_FUNC_APF_TOKEN_NUM	2
+#define ARM_SMCCC_KVM_FUNC_APF_SDEI		3
+#define ARM_SMCCC_KVM_FUNC_APF_IRQ		4
+#define ARM_SMCCC_KVM_FUNC_APF_IRQ_ACK		5
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_APF_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   ARM_SMCCC_KVM_FUNC_APF)
+
 /*
  * Return codes defined in ARM DEN 0070A
  * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
