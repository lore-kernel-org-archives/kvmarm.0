Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006C8C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 03:29:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88BD4601FD
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 03:29:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88BD4601FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 185D34B525;
	Mon,  8 Feb 2021 22:29:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mc+UW+4qp9gW; Mon,  8 Feb 2021 22:29:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3CC34B52A;
	Mon,  8 Feb 2021 22:29:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 661A74B52A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 22:29:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lf-q26iMRuZ4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 22:29:03 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47BA04B703
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 22:29:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612841343;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4O3bR91OQhTBAzOCEMKSoKJvq1Mfv9//Gx0KMgTUafM=;
 b=FsmSoFX2NlYJH8pZ8GXbVwCHRhgqJM7Z9zhXH/1QHHIRHQ6WTVK6/AwTe1de5aVXmtXeHl
 8rPiRJ89zV7ijX/ZloJqRUH05lQg2oPizNucJHL03ihMI6g2wr/yKEmsRt9B0Eqoli3q20
 DF60sPd7jASYvoPdrnNfL+a9ZFkXYrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-OFYASXHrP-W9KPcB4JVWmA-1; Mon, 08 Feb 2021 22:28:59 -0500
X-MC-Unique: OFYASXHrP-W9KPcB4JVWmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8577100CC85;
 Tue,  9 Feb 2021 03:28:57 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-26.bne.redhat.com [10.64.54.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 0AA2A19C66;
 Tue,  9 Feb 2021 03:28:52 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 16/21] KVM: arm64: Support SDEI ioctl commands on VM
Date: Tue,  9 Feb 2021 11:27:28 +0800
Message-Id: <20210209032733.99996-17-gshan@redhat.com>
In-Reply-To: <20210209032733.99996-1-gshan@redhat.com>
References: <20210209032733.99996-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

This supports ioctl commands on VM to manage the various objects.
It's primarily used by VMM to accomplish live migration. The ioctl
commands introduced by this are highlighted as blow:

   * KVM_SDEI_CMD_GET_VERSION
     Retrieve the version of current implementation
   * KVM_SDEI_CMD_SET_EVENT
     Add event to be exported from KVM so that guest can register
     against it afterwards
   * KVM_SDEI_CMD_GET_KEVENT_COUNT
     Retrieve number of registered SDEI events
   * KVM_SDEI_CMD_GET_KEVENT
     Retrieve the state of the registered SDEI event
   * KVM_SDEI_CMD_SET_KEVENT
     Populate the registered SDEI event

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_sdei.h      |   1 +
 arch/arm64/include/uapi/asm/kvm_sdei.h |  17 +++
 arch/arm64/kvm/arm.c                   |   3 +
 arch/arm64/kvm/sdei.c                  | 171 +++++++++++++++++++++++++
 include/uapi/linux/kvm.h               |   3 +
 5 files changed, 195 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index 19f2d9b91f85..8f5ea947ed0e 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -125,6 +125,7 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
 int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
 			       kvm_sdei_notifier notifier);
 void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
+long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg);
 void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
 void kvm_sdei_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
index 20ad724f63c8..55de8baff841 100644
--- a/arch/arm64/include/uapi/asm/kvm_sdei.h
+++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
@@ -54,4 +54,21 @@ struct kvm_sdei_vcpu_state {
 	struct kvm_sdei_vcpu_regs	normal_regs;
 };
 
+#define KVM_SDEI_CMD_GET_VERSION		0
+#define KVM_SDEI_CMD_SET_EVENT			1
+#define KVM_SDEI_CMD_GET_KEVENT_COUNT		2
+#define KVM_SDEI_CMD_GET_KEVENT			3
+#define KVM_SDEI_CMD_SET_KEVENT			4
+
+struct kvm_sdei_cmd {
+	uint32_t					cmd;
+	union {
+		uint32_t				version;
+		uint32_t				count;
+		uint64_t				num;
+		struct kvm_sdei_event_state		kse_state;
+		struct kvm_sdei_kvm_event_state		kske_state;
+	};
+};
+
 #endif /* _UAPI__ASM_KVM_SDEI_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e243bd5ad730..96b41bf1d094 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1334,6 +1334,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		return 0;
 	}
+	case KVM_ARM_SDEI_COMMAND: {
+		return kvm_sdei_vm_ioctl(kvm, arg);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 5f7a37dcaa77..bdd76c3e5153 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -931,6 +931,177 @@ void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.sdei = vsdei;
 }
 
+static long kvm_sdei_set_event(struct kvm *kvm,
+			       struct kvm_sdei_event_state *kse_state)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
+
+	if (!kvm_sdei_is_valid_event_num(kse_state->num))
+		return -EINVAL;
+
+	if (!(kse_state->type == SDEI_EVENT_TYPE_SHARED ||
+	      kse_state->type == SDEI_EVENT_TYPE_PRIVATE))
+		return -EINVAL;
+
+	if (!(kse_state->priority == SDEI_EVENT_PRIORITY_NORMAL ||
+	      kse_state->priority == SDEI_EVENT_PRIORITY_CRITICAL))
+		return -EINVAL;
+
+	kse = kvm_sdei_find_event(kvm, kse_state->num);
+	if (kse)
+		return -EEXIST;
+
+	kse = kzalloc(sizeof(*kse), GFP_KERNEL);
+	if (!kse)
+		return -ENOMEM;
+
+	kse->state = *kse_state;
+	kse->kvm = kvm;
+	list_add_tail(&kse->link, &ksdei->events);
+
+	return 0;
+}
+
+static long kvm_sdei_get_kevent_count(struct kvm *kvm, int *count)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_kvm_event *kske = NULL;
+	int total = 0;
+
+	list_for_each_entry(kske, &ksdei->kvm_events, link) {
+		total++;
+	}
+
+	*count = total;
+	return 0;
+}
+
+static long kvm_sdei_get_kevent(struct kvm *kvm,
+				struct kvm_sdei_kvm_event_state *kske_state)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_kvm_event *kske = NULL;
+
+	/*
+	 * The first entry is fetched if the event number is invalid.
+	 * Otherwise, the next entry is fetched.
+	 */
+	if (!kvm_sdei_is_valid_event_num(kske_state->num)) {
+		kske = list_first_entry_or_null(&ksdei->kvm_events,
+				struct kvm_sdei_kvm_event, link);
+	} else {
+		kske = kvm_sdei_find_kvm_event(kvm, kske_state->num);
+		if (kske && !list_is_last(&kske->link, &ksdei->kvm_events))
+			kske = list_next_entry(kske, link);
+		else
+			kske = NULL;
+	}
+
+	if (!kske)
+		return -ENOENT;
+
+	*kske_state = kske->state;
+
+	return 0;
+}
+
+static long kvm_sdei_set_kevent(struct kvm *kvm,
+				struct kvm_sdei_kvm_event_state *kske_state)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
+	struct kvm_sdei_kvm_event *kske = NULL;
+
+	/* Sanity check */
+	if (!kvm_sdei_is_valid_event_num(kske_state->num))
+		return -EINVAL;
+
+	if (!(kske_state->route_mode == SDEI_EVENT_REGISTER_RM_ANY ||
+	      kske_state->route_mode == SDEI_EVENT_REGISTER_RM_PE))
+		return -EINVAL;
+
+	/* Check if the event number is valid */
+	kse = kvm_sdei_find_event(kvm, kske_state->num);
+	if (!kse)
+		return -ENOENT;
+
+	/* Check if the event has been populated */
+	kske = kvm_sdei_find_kvm_event(kvm, kske_state->num);
+	if (kske)
+		return -EEXIST;
+
+	kske = kzalloc(sizeof(*kske), GFP_KERNEL);
+	if (!kske)
+		return -ENOMEM;
+
+	kske->state = *kske_state;
+	kske->kse   = kse;
+	kske->kvm   = kvm;
+	list_add_tail(&kske->link, &ksdei->kvm_events);
+
+	return 0;
+}
+
+long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_cmd *cmd = NULL;
+	void __user *argp = (void __user *)arg;
+	bool copy = false;
+	long ret = 0;
+
+	/* Sanity check */
+	if (!ksdei) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (copy_from_user(cmd, argp, sizeof(*cmd))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	spin_lock(&ksdei->lock);
+
+	switch (cmd->cmd) {
+	case KVM_SDEI_CMD_GET_VERSION:
+		copy = true;
+		cmd->version = (1 << 16);       /* v1.0.0 */
+		break;
+	case KVM_SDEI_CMD_SET_EVENT:
+		ret = kvm_sdei_set_event(kvm, &cmd->kse_state);
+		break;
+	case KVM_SDEI_CMD_GET_KEVENT_COUNT:
+		copy = true;
+		ret = kvm_sdei_get_kevent_count(kvm, &cmd->count);
+		break;
+	case KVM_SDEI_CMD_GET_KEVENT:
+		copy = true;
+		ret = kvm_sdei_get_kevent(kvm, &cmd->kske_state);
+		break;
+	case KVM_SDEI_CMD_SET_KEVENT:
+		ret = kvm_sdei_set_kevent(kvm, &cmd->kske_state);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	spin_unlock(&ksdei->lock);
+out:
+	if (!ret && copy && copy_to_user(argp, cmd, sizeof(*cmd)))
+		ret = -EFAULT;
+
+	kfree(cmd);
+	return ret;
+}
+
 void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 374c67875cdb..b056b4ac884b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1565,6 +1565,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+/* Available with KVM_CAP_ARM_SDEI */
+#define KVM_ARM_SDEI_COMMAND   _IOWR(KVMIO, 0xc8, struct kvm_sdei_cmd)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
