Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8E4C433E6
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47E4E64EB6
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47E4E64EB6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD3844B659;
	Tue,  9 Feb 2021 00:05:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qr8P9sGq+rtK; Tue,  9 Feb 2021 00:05:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 130114B707;
	Tue,  9 Feb 2021 00:05:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 627414B59B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ScLYVPMTOyYL for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2021 00:05:07 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 542094B69F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:05 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612847105;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dlw76BEcqgsLICHpLjr4wfTo1oCYV+bre8IHCdH08mE=;
 b=h04SPLpC/vZLc5xLnDLskeLfdxXWewPK741oESz3lJTkhh+MSefHrIc0lm6Fw9nvUhbI8i
 +nD45yPZsZ4l0Y6TQZtcmvCtIHnSRVfEefixaFuqKIlYyhFb+nHLcN4IxWlQ2xutvfwlag
 KuT5pf3uAnl+dVjJpUcJdmhvyUX/KwQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-gKEx2vGFMKaIQfkksgPFJQ-1; Tue, 09 Feb 2021 00:05:01 -0500
X-MC-Unique: gKEx2vGFMKaIQfkksgPFJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2078801965;
 Tue,  9 Feb 2021 05:04:59 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-26.bne.redhat.com [10.64.54.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 4EBAE5D9C0;
 Tue,  9 Feb 2021 05:04:56 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 11/17] KVM: arm64: Support async PF hypercalls
Date: Tue,  9 Feb 2021 13:03:57 +0800
Message-Id: <20210209050403.103143-12-gshan@redhat.com>
In-Reply-To: <20210209050403.103143-1-gshan@redhat.com>
References: <20210209050403.103143-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
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

This introduces (SMCCC) KVM vendor specific services to configure
the asynchronous page fault functionality. The following services
are introduced:

   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_VERSION
     Returns the version, which can be used to identify ABI changes
     in the future.
   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_SLOTS
     Return maximal number of tokens that current vCPU can have.
     It's used by guest to allocate the required resources.
   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_{SDEI, IRQ}
     Return the associated SDEI or (PPI) IRQ number, configured by
     vCPU ioctl command.
   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE
     Enable or disable asynchronous page fault on current vCPU.

The corresponding SDEI event and (PPI) IRQ are owned by VMM. So they
are configured by vCPU ioctl interface and it will be implemented when
the asynchronous page fault capability is exported in the subsequent
patches.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/async_pf.c | 119 ++++++++++++++++++++++++++++++++++++++
 include/linux/arm-smccc.h |   5 ++
 2 files changed, 124 insertions(+)

diff --git a/arch/arm64/kvm/async_pf.c b/arch/arm64/kvm/async_pf.c
index f73c406456e9..4734c5b26aa8 100644
--- a/arch/arm64/kvm/async_pf.c
+++ b/arch/arm64/kvm/async_pf.c
@@ -313,12 +313,115 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, token), 0);
 }
 
+static void kvm_arch_async_sdei_notifier(struct kvm_vcpu *vcpu,
+					 unsigned long num,
+					 unsigned int state)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+
+	if (!apf)
+		return;
+
+	if (num != apf->sdei_event_num) {
+		kvm_err("%s: Invalid event number (%d-%d %lx-%llx)\n",
+			__func__, kvm->userspace_pid, vcpu->vcpu_idx,
+			num, apf->sdei_event_num);
+		return;
+	}
+
+	switch (state) {
+	case KVM_SDEI_NOTIFY_DELIVERED:
+		if (!apf->notpresent_pending)
+			break;
+
+		apf->notpresent_token = 0;
+		apf->notpresent_pending = false;
+		break;
+	case KVM_SDEI_NOTIFY_COMPLETED:
+		break;
+	default:
+		kvm_err("%s: Invalid state (%d-%d %lx-%d)\n",
+			__func__, kvm->userspace_pid, vcpu->vcpu_idx,
+			num, state);
+	}
+}
+
+static long kvm_arch_async_enable(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+	gpa_t gpa = (data & ~0x3FUL);
+	bool enabled, enable;
+	int ret;
+
+	if (!apf || !irqchip_in_kernel(kvm))
+		return SMCCC_RET_NOT_SUPPORTED;
+
+	/* Bail if the state transition isn't allowed */
+	enabled = !!(apf->control_block & KVM_ASYNC_PF_ENABLED);
+	enable = !!(data & KVM_ASYNC_PF_ENABLED);
+	if (enable == enabled) {
+		kvm_debug("%s: Async PF has been %s on (%d-%d %llx-%llx)\n",
+			  __func__, enabled ? "enabled" : "disabled",
+			  kvm->userspace_pid, vcpu->vcpu_idx,
+			  apf->control_block, data);
+		return SMCCC_RET_NOT_REQUIRED;
+	}
+
+	/* To disable the functinality */
+	if (!enable) {
+		kvm_clear_async_pf_completion_queue(vcpu);
+		apf->control_block = data;
+		return SMCCC_RET_SUCCESS;
+	}
+
+	/*
+	 * The SDEI event and IRQ number should have been given
+	 * prior to enablement.
+	 */
+	if (!apf->sdei_event_num || !apf->irq) {
+		kvm_err("%s: Invalid SDEI event or IRQ (%d-%d %llx-%d)\n",
+			__func__, kvm->userspace_pid, vcpu->vcpu_idx,
+			apf->sdei_event_num, apf->irq);
+		return SMCCC_RET_INVALID_PARAMETER;
+	}
+
+	/* Register SDEI event notifier */
+	ret = kvm_sdei_register_notifier(kvm, apf->sdei_event_num,
+					 kvm_arch_async_sdei_notifier);
+	if (ret) {
+		kvm_err("%s: Error %d registering SDEI notifier (%d-%d %llx)\n",
+			__func__, ret, kvm->userspace_pid, vcpu->vcpu_idx,
+			apf->sdei_event_num);
+		return SMCCC_RET_NOT_SUPPORTED;
+	}
+
+	/* Initialize cache shared by host and guest */
+	ret = kvm_gfn_to_hva_cache_init(kvm, &apf->cache, gpa,
+			offsetofend(struct kvm_vcpu_pv_apf_data, token));
+	if (ret) {
+		kvm_err("%s: Error %d initializing cache (%d-%d)\n",
+			__func__, ret, kvm->userspace_pid, vcpu->vcpu_idx);
+		return SMCCC_RET_NOT_SUPPORTED;
+	}
+
+	/* Flush the token table */
+	kvm_async_pf_reset_slot(vcpu);
+	apf->send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
+	kvm_async_pf_wakeup_all(vcpu);
+	apf->control_block = data;
+
+	return SMCCC_RET_SUCCESS;
+}
+
 long kvm_arch_async_pf_hypercall(struct kvm_vcpu *vcpu,
 				 long *r1, long *r2, long *r3)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
 	u32 func;
+	u64 data;
 	long ret = SMCCC_RET_SUCCESS;
 
 	if (!apf) {
@@ -328,6 +431,22 @@ long kvm_arch_async_pf_hypercall(struct kvm_vcpu *vcpu,
 
 	func = smccc_get_arg1(vcpu);
 	switch (func) {
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_VERSION:
+		*r1 = 0x010000; /* v1.0.0 */
+		break;
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_SLOTS:
+		*r1 = ASYNC_PF_PER_VCPU;
+		break;
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_SDEI:
+		*r1 = apf->sdei_event_num;
+		break;
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ:
+		*r1 = apf->irq;
+		break;
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE:
+		data = (smccc_get_arg3(vcpu) << 32) | smccc_get_arg2(vcpu);
+		ret = kvm_arch_async_enable(vcpu, data);
+		break;
 	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ_ACK:
 		if (!apf->pageready_pending)
 			break;
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 0476afbd3178..ae081156132d 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -129,6 +129,11 @@
 			   ARM_SMCCC_KVM_FUNC_FEATURES)
 
 /* Asynchronous page fault service */
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_VERSION		0
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_SLOTS		1
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_SDEI		2
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ			3
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE		4
 #define ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ_ACK		5
 
 #define ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID		\
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
