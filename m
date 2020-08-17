Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FBBC433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5757E2067C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MntYs9/P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5757E2067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1C524BD02;
	Mon, 17 Aug 2020 06:06:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0RIKzna41768; Mon, 17 Aug 2020 06:06:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BD264C008;
	Mon, 17 Aug 2020 06:06:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4C644C020
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fpJi4T2FoTyN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:50 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7799B4C004
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658810;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=HPAggAjMLo0SQV7bXV8f296J8MtqcSmvJIy7EiXlsgQ=;
 b=MntYs9/P0Al3WbUNTohVLmHlHiZJ/Q7Nafd9LRefDDcoTW953S5l4Bwm/UZRZd9pBc+gSR
 /49zTP0G++v9PKeFdAp0eJK2zOtqGHso6khALd+9U6eZYNu810YaYxEG+PZBSmoKBz0Gh/
 iTWE1AQLRc/TyhKVFsCkJcM+RzZX+zs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-BB26jqmxPlWPdBwVMyJHfA-1; Mon, 17 Aug 2020 06:06:48 -0400
X-MC-Unique: BB26jqmxPlWPdBwVMyJHfA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AD4C81F019;
 Mon, 17 Aug 2020 10:06:47 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 6B07D78414;
 Mon, 17 Aug 2020 10:06:45 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 17/18] arm64/kvm: Expose SDEI capability
Date: Mon, 17 Aug 2020 20:05:30 +1000
Message-Id: <20200817100531.83045-18-gshan@redhat.com>
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
References: <20200817100531.83045-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
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

This exposes SDEI capability, which is identified by KVM_CAP_ARM_SDEI.
Also, the ioctl interface (KVM_ARM_SDEI_INJECT) is introduced to allow
injecting KVM originated event from user space.

Besides, this implements the following APIs to register the notifier
and cancel the pending SDEI event: kvm_sdei_register_notifier() and
kvm_sdei_cancel().

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_sdei.h |   4 +
 arch/arm64/kvm/arm.c              |   8 ++
 arch/arm64/kvm/reset.c            |   3 +
 arch/arm64/kvm/sdei.c             | 134 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |   4 +
 5 files changed, 153 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index 70e613941577..67a5a398fe10 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -105,6 +105,10 @@ static inline bool kvm_sdei_num_is_valid(unsigned long num)
 
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu);
 void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
+int kvm_sdei_register_notifier(unsigned long num,
+			       kvm_sdei_notify_func_t func);
+int kvm_sdei_inject(struct kvm_vcpu *vcpu, unsigned long num, bool force);
+int kvm_sdei_cancel(struct kvm_vcpu *vcpu, unsigned long num);
 void kvm_sdei_init(void);
 void kvm_sdei_create_vcpu(struct kvm_vcpu *vcpu);
 void kvm_sdei_vcpu_load(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a79a4343bac6..4bec6c9ece18 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1201,6 +1201,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_finalize(vcpu, what);
 	}
+	case KVM_ARM_SDEI_INJECT: {
+		unsigned long num;
+
+		if (copy_from_user(&num, argp, sizeof(num)))
+			return -EFAULT;
+
+		return kvm_sdei_inject(vcpu, num, true);
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 6ed36be51b4b..f292bed61147 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -83,6 +83,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = has_vhe() && system_supports_address_auth() &&
 				 system_supports_generic_auth();
 		break;
+	case KVM_CAP_ARM_SDEI:
+		r = 1;
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 0c5a16e8cbac..2c05edcb3fbb 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -229,6 +229,18 @@ void kvm_sdei_deliver(struct kvm_vcpu *vcpu)
 	spin_unlock(&vcpu->arch.sdei_lock);
 }
 
+int kvm_sdei_register_notifier(unsigned long num, kvm_sdei_notify_func_t func)
+{
+	struct kvm_sdei_priv *priv = kvm_sdei_find_priv(num);
+
+	if (!priv)
+		return -ENOENT;
+
+	priv->notifier = func;
+
+	return 0;
+}
+
 static int kvm_sdei_queue_event(struct kvm_vcpu *vcpu,
 				struct kvm_sdei_kvm_event *kevent)
 {
@@ -272,6 +284,128 @@ static int kvm_sdei_queue_event(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+int kvm_sdei_inject(struct kvm_vcpu *vcpu, unsigned long num, bool force)
+{
+	struct kvm_sdei_event *event = NULL;
+	struct kvm_sdei_kvm_event *kevent = NULL;
+	unsigned long event_type, event_priority;
+	int index, ret = 0;
+
+	/* Find the event */
+	spin_lock(&kvm_sdei_lock);
+	event = kvm_sdei_find_event(vcpu->kvm, num, &kevent, NULL, NULL);
+	if (!kevent || !event->priv) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+	/*
+	 * We're unable to inject passthrou event, which means the
+	 * event should have been associated with KVM private event
+	 * or descriptor.
+	 */
+	spin_lock(&event->lock);
+	if (!event->priv) {
+		ret = -EINVAL;
+		goto unlock_event;
+	}
+
+	/*
+	 * The event should have been registered and enabled on the
+	 * target vCPU.
+	 */
+	event_type = event->priv->type;
+	event_priority = event->priv->priority;
+	index = (event_type == SDEI_EVENT_TYPE_PRIVATE) ? vcpu->vcpu_idx : 0;
+	if (!test_bit(index, kevent->registered) ||
+	    !test_bit(index, kevent->enabled)) {
+		ret = -EPERM;
+		goto unlock_event;
+	}
+
+	/*
+	 * We need deliver the event immediately when @force is
+	 * false. For this case, we need check if there is space
+	 * to do so.
+	 */
+	spin_lock(&vcpu->arch.sdei_lock);
+	if (!force) {
+		if (vcpu->arch.sdei_critical_event) {
+			ret = -ENOSPC;
+			goto unlock_vcpu;
+		}
+
+		if (vcpu->arch.sdei_normal_event &&
+		    event_type != SDEI_EVENT_PRIORITY_CRITICAL) {
+			ret = -ENOSPC;
+			goto unlock_vcpu;
+		}
+	}
+
+	ret = kvm_sdei_queue_event(vcpu, kevent);
+
+unlock_vcpu:
+	spin_unlock(&vcpu->arch.sdei_lock);
+unlock_event:
+	spin_unlock(&event->lock);
+unlock:
+	spin_unlock(&kvm_sdei_lock);
+	return ret;
+}
+
+int kvm_sdei_cancel(struct kvm_vcpu *vcpu, unsigned long num)
+{
+	struct kvm_sdei_event *event;
+	struct kvm_sdei_kvm_event *kevent = NULL;
+	struct kvm_sdei_vcpu_event *e, *vevent = NULL;
+	unsigned long event_num;
+	int ret = 0;
+
+	spin_lock(&vcpu->arch.sdei_lock);
+
+	list_for_each_entry(e, &vcpu->arch.sdei_events, link) {
+		event = e->event->event;
+		event_num = event->priv ? event->priv->num :
+					  event->event->event_num;
+		if (event_num == num) {
+			vevent = e;
+			break;
+		}
+	}
+
+	if (!vevent) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+	/* The event can't be cancelled if it has been delivered */
+	if (vevent->users == 1 &&
+	    (vevent == vcpu->arch.sdei_critical_event ||
+	     vevent == vcpu->arch.sdei_normal_event)) {
+		ret = -EINPROGRESS;
+		goto unlock;
+	}
+
+	/* Release the vCPU event if necessary */
+	kevent = vevent->event;
+	vevent->users--;
+	if (!vevent->users) {
+		list_del(&vevent->link);
+		kfree(vevent);
+	}
+
+unlock:
+	spin_unlock(&vcpu->arch.sdei_lock);
+
+	if (kevent) {
+		spin_lock(&event->lock);
+		kevent->users--;
+		spin_unlock(&event->lock);
+	}
+
+	return ret;
+}
+
 /*
  * Queue the shared event to the target VMs where the event have been
  * registered and enabled. For the particular VM, the event is delivered
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6d86033c4fa..c9731fad8bf5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_ARM_SDEI 187
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1536,6 +1537,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+/* Available with KVM_CAP_ARM_SDEI */
+#define KVM_ARM_SDEI_INJECT		_IOW(KVMIO, 0xc6, __u64)
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
