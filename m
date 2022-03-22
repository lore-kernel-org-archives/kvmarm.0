Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79C7C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:10:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C5BE49F20;
	Tue, 22 Mar 2022 04:10:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pN5CbebX9PdL; Tue, 22 Mar 2022 04:10:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3890143479;
	Tue, 22 Mar 2022 04:10:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAADB40CDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:10:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S8wmLwNAff6y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:10:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA1FD40BE7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:10:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936634;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6LiuGwo8D8luzu1fufiYqiwAA/jy3lFuWpH7KFm91+c=;
 b=J7a6rfrfStzj6UNyvZw1wVq0FFvaKkvem9gyif8Ptt3QejLAmTD/wrYdNSzV1HmY+PVrW6
 bSTzBgb7wUgCBegM7JFgoiGqmc73/IWsYW+xKgwBQQjo8YYTA3ir/wyva+NUMmXtPs/WtE
 zYC9XiwqFFehw/91+AEfXWr8YWoj4Ec=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-urwu8cqxMw-e_yxNDHdsDg-1; Tue, 22 Mar 2022 04:10:31 -0400
X-MC-Unique: urwu8cqxMw-e_yxNDHdsDg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1AF63C01C0F;
 Tue, 22 Mar 2022 08:10:30 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F05E71121324;
 Tue, 22 Mar 2022 08:10:16 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 17/22] KVM: arm64: Support SDEI event notifier
Date: Tue, 22 Mar 2022 16:07:05 +0800
Message-Id: <20220322080710.51727-18-gshan@redhat.com>
In-Reply-To: <20220322080710.51727-1-gshan@redhat.com>
References: <20220322080710.51727-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

The owner of the SDEI event may want to know if the injected event
has been delivered and handled. For example, Async PF cancels the
injected SDEI event at early stage of the work, driven by the
event has been completed asynchronously.

This supports SDEI event state updating by introducing notifier
mechanism. It's notable the notifier (handler) should be capable of
migration.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_sdei.h | 10 +++++++
 arch/arm64/kvm/sdei.c             | 45 +++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index 54c730acd298..2480ec0e9824 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -18,6 +18,14 @@
 
 struct kvm_vcpu;
 
+typedef void (*kvm_sdei_notifier)(struct kvm_vcpu *vcpu,
+				  unsigned long num,
+				  unsigned int state);
+enum {
+	KVM_SDEI_NOTIFY_DELIVERED,
+	KVM_SDEI_NOTIFY_COMPLETED,
+};
+
 struct kvm_sdei_exposed_event {
 	struct kvm_sdei_exposed_event_state	state;
 	struct kvm				*kvm;
@@ -165,6 +173,8 @@ KVM_SDEI_REGISTERED_EVENT_FUNC(unregister_pending)
 void kvm_sdei_init_vm(struct kvm *kvm);
 void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
+int kvm_sdei_register_event_notifier(struct kvm *kvm, unsigned long num,
+				     kvm_sdei_notifier notifier);
 int kvm_sdei_inject_event(struct kvm_vcpu *vcpu,
 			  unsigned long num, bool immediate);
 int kvm_sdei_cancel_event(struct kvm_vcpu *vcpu, unsigned long num);
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 3019ac196e76..9f1959653318 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -353,6 +353,7 @@ static unsigned long hypercall_complete(struct kvm_vcpu *vcpu, bool resume)
 	struct kvm_sdei_registered_event *registered_event;
 	struct kvm_sdei_vcpu_event *vcpu_event;
 	struct kvm_sdei_vcpu_regs_state *regs;
+	kvm_sdei_notifier notifier = NULL;
 	unsigned long ret = SDEI_SUCCESS;
 	int index;
 
@@ -397,6 +398,7 @@ static unsigned long hypercall_complete(struct kvm_vcpu *vcpu, bool resume)
 	 */
 	registered_event = vcpu_event->registered_event;
 	exposed_event = registered_event->exposed_event;
+	notifier = (kvm_sdei_notifier)(exposed_event->state.notifier);
 	index = kvm_sdei_vcpu_index(vcpu, exposed_event);
 	if (kvm_sdei_is_unregister_pending(registered_event, index)) {
 		kvm_sdei_clear_enabled(registered_event, index);
@@ -413,6 +415,12 @@ static unsigned long hypercall_complete(struct kvm_vcpu *vcpu, bool resume)
 	spin_unlock(&vsdei->lock);
 	spin_unlock(&ksdei->lock);
 
+	/* Notifier */
+	if (notifier) {
+		notifier(vcpu, exposed_event->state.num,
+			 KVM_SDEI_NOTIFY_COMPLETED);
+	}
+
 	return ret;
 }
 
@@ -986,6 +994,35 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+int kvm_sdei_register_event_notifier(struct kvm *kvm,
+				     unsigned long num,
+				     kvm_sdei_notifier notifier)
+{
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_exposed_event *exposed_event = NULL;
+	int ret = 0;
+
+	if (!ksdei) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	spin_lock(&ksdei->lock);
+
+	exposed_event = find_exposed_event(kvm, num);
+	if (!exposed_event) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	exposed_event->state.notifier = (unsigned long)notifier;
+
+unlock:
+	spin_unlock(&ksdei->lock);
+out:
+	return ret;
+}
+
 int kvm_sdei_inject_event(struct kvm_vcpu *vcpu,
 			  unsigned long num,
 			  bool immediate)
@@ -1100,6 +1137,7 @@ void kvm_sdei_deliver_event(struct kvm_vcpu *vcpu)
 	struct kvm_sdei_registered_event *registered_event;
 	struct kvm_sdei_vcpu_event *vcpu_event;
 	struct kvm_sdei_vcpu_regs_state *regs;
+	kvm_sdei_notifier notifier = NULL;
 	unsigned long pstate;
 	int index;
 
@@ -1129,6 +1167,7 @@ void kvm_sdei_deliver_event(struct kvm_vcpu *vcpu)
 
 	registered_event = vcpu_event->registered_event;
 	exposed_event = registered_event->exposed_event;
+	notifier = (kvm_sdei_notifier)(exposed_event->state.notifier);
 	if (kvm_sdei_is_critical(exposed_event->state.priority)) {
 		vsdei->critical_event = vcpu_event;
 		vsdei->state.critical_num = vcpu_event->state.num;
@@ -1179,6 +1218,12 @@ void kvm_sdei_deliver_event(struct kvm_vcpu *vcpu)
 
 unlock:
 	spin_unlock(&vsdei->lock);
+
+	/* Notifier */
+	if (notifier) {
+		notifier(vcpu, exposed_event->state.num,
+			 KVM_SDEI_NOTIFY_DELIVERED);
+	}
 }
 
 void kvm_sdei_init_vm(struct kvm *kvm)
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
