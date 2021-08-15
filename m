Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C1EC432BE
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:15:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8C3C60E76
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:15:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B8C3C60E76
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 606924A523;
	Sat, 14 Aug 2021 20:15:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nv7B4EtMt45H; Sat, 14 Aug 2021 20:15:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAE974B0CB;
	Sat, 14 Aug 2021 20:15:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 168774B0BD
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:15:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OFpgMT8ADIaw for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 20:15:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 335F24B0E2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:15:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628986541;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zaiJSgXud0XzYOvxzl4324+bZefArVwrSA/+8UGrzEs=;
 b=AWWFhuvrPfVi5zkCkDauE+44fztfTuirOyDv8mxFJSZKVNDNqsKqYD43Qgx+7pIwxIXFcW
 NpLDbWIATYXcAbWweDR/sJ86Hnvgb9PBXnJtxZ9RRdaex+ZKLZ8I07uLOP7R7pJ0FyM3OX
 4WTjx0anQ5ZPAMZCHMwK1JWQM/T073E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-T530wJTCO3ioRw8-0TKMLg-1; Sat, 14 Aug 2021 20:15:39 -0400
X-MC-Unique: T530wJTCO3ioRw8-0TKMLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5907A871471;
 Sun, 15 Aug 2021 00:15:38 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F24E21036D2E;
 Sun, 15 Aug 2021 00:15:33 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 17/21] KVM: arm64: Support SDEI ioctl commands on vCPU
Date: Sun, 15 Aug 2021 08:13:48 +0800
Message-Id: <20210815001352.81927-18-gshan@redhat.com>
In-Reply-To: <20210815001352.81927-1-gshan@redhat.com>
References: <20210815001352.81927-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com,
 pbonzini@redhat.com, will@kernel.org
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

This supports ioctl commands on vCPU to manage the various object.
It's primarily used by VMM to accomplish live migration. The ioctl
commands introduced by this are highlighted as below:

   * KVM_SDEI_CMD_GET_VEVENT_COUNT
     Retrieve number of SDEI events that pend for handling on the
     vCPU
   * KVM_SDEI_CMD_GET_VEVENT
     Retrieve the state of SDEI event, which has been delivered to
     the vCPU for handling
   * KVM_SDEI_CMD_SET_VEVENT
     Populate the SDEI event, which has been delivered to the vCPU
     for handling
   * KVM_SDEI_CMD_GET_VCPU_STATE
     Retrieve vCPU state related to SDEI handling
   * KVM_SDEI_CMD_SET_VCPU_STATE
     Populate vCPU state related to SDEI handling

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_sdei.h      |   1 +
 arch/arm64/include/uapi/asm/kvm_sdei.h |   7 +
 arch/arm64/kvm/arm.c                   |   3 +
 arch/arm64/kvm/sdei.c                  | 228 +++++++++++++++++++++++++
 4 files changed, 239 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_sdei.h b/arch/arm64/include/asm/kvm_sdei.h
index 8f5ea947ed0e..a997989bab77 100644
--- a/arch/arm64/include/asm/kvm_sdei.h
+++ b/arch/arm64/include/asm/kvm_sdei.h
@@ -126,6 +126,7 @@ int kvm_sdei_register_notifier(struct kvm *kvm, unsigned long num,
 			       kvm_sdei_notifier notifier);
 void kvm_sdei_deliver(struct kvm_vcpu *vcpu);
 long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg);
+long kvm_sdei_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long arg);
 void kvm_sdei_destroy_vcpu(struct kvm_vcpu *vcpu);
 void kvm_sdei_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
index 35ff05be3c28..b916c3435646 100644
--- a/arch/arm64/include/uapi/asm/kvm_sdei.h
+++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
@@ -62,6 +62,11 @@ struct kvm_sdei_vcpu_state {
 #define KVM_SDEI_CMD_GET_KEVENT_COUNT		2
 #define KVM_SDEI_CMD_GET_KEVENT			3
 #define KVM_SDEI_CMD_SET_KEVENT			4
+#define KVM_SDEI_CMD_GET_VEVENT_COUNT		5
+#define KVM_SDEI_CMD_GET_VEVENT			6
+#define KVM_SDEI_CMD_SET_VEVENT			7
+#define KVM_SDEI_CMD_GET_VCPU_STATE		8
+#define KVM_SDEI_CMD_SET_VCPU_STATE		9
 
 struct kvm_sdei_cmd {
 	__u32						cmd;
@@ -71,6 +76,8 @@ struct kvm_sdei_cmd {
 		__u64					num;
 		struct kvm_sdei_event_state		kse_state;
 		struct kvm_sdei_kvm_event_state		kske_state;
+		struct kvm_sdei_vcpu_event_state	ksve_state;
+		struct kvm_sdei_vcpu_state		ksv_state;
 	};
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8d61585124b2..215cdbeb272a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1308,6 +1308,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_finalize(vcpu, what);
 	}
+	case KVM_ARM_SDEI_COMMAND: {
+		return kvm_sdei_vcpu_ioctl(vcpu, arg);
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index bdd76c3e5153..79315b77f24b 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -35,6 +35,25 @@ static struct kvm_sdei_event *kvm_sdei_find_event(struct kvm *kvm,
 	return NULL;
 }
 
+static struct kvm_sdei_vcpu_event *kvm_sdei_find_vcpu_event(struct kvm_vcpu *vcpu,
+							    unsigned long num)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_event *ksve;
+
+	list_for_each_entry(ksve, &vsdei->critical_events, link) {
+		if (ksve->state.num == num)
+			return ksve;
+	}
+
+	list_for_each_entry(ksve, &vsdei->normal_events, link) {
+		if (ksve->state.num == num)
+			return ksve;
+	}
+
+	return NULL;
+}
+
 static void kvm_sdei_remove_events(struct kvm *kvm)
 {
 	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
@@ -1102,6 +1121,215 @@ long kvm_sdei_vm_ioctl(struct kvm *kvm, unsigned long arg)
 	return ret;
 }
 
+static long kvm_sdei_get_vevent_count(struct kvm_vcpu *vcpu, int *count)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_event *ksve = NULL;
+	int total = 0;
+
+	list_for_each_entry(ksve, &vsdei->critical_events, link) {
+		total++;
+	}
+
+	list_for_each_entry(ksve, &vsdei->normal_events, link) {
+		total++;
+	}
+
+	*count = total;
+	return 0;
+}
+
+static struct kvm_sdei_vcpu_event *next_vcpu_event(struct kvm_vcpu *vcpu,
+						   unsigned long num)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
+	struct kvm_sdei_kvm_event *kske = NULL;
+	struct kvm_sdei_vcpu_event *ksve = NULL;
+
+	ksve = kvm_sdei_find_vcpu_event(vcpu, num);
+	if (!ksve)
+		return NULL;
+
+	kske = ksve->kske;
+	kse  = kske->kse;
+	if (kse->state.priority == SDEI_EVENT_PRIORITY_CRITICAL) {
+		if (!list_is_last(&ksve->link, &vsdei->critical_events)) {
+			ksve = list_next_entry(ksve, link);
+			return ksve;
+		}
+
+		ksve = list_first_entry_or_null(&vsdei->normal_events,
+					struct kvm_sdei_vcpu_event, link);
+		return ksve;
+	}
+
+	if (!list_is_last(&ksve->link, &vsdei->normal_events)) {
+		ksve = list_next_entry(ksve, link);
+		return ksve;
+	}
+
+	return NULL;
+}
+
+static long kvm_sdei_get_vevent(struct kvm_vcpu *vcpu,
+				struct kvm_sdei_vcpu_event_state *ksve_state)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_event *ksve = NULL;
+
+	/*
+	 * If the event number is invalid, the first critical or
+	 * normal event is fetched. Otherwise, the next valid event
+	 * is returned.
+	 */
+	if (!kvm_sdei_is_valid_event_num(ksve_state->num)) {
+		ksve = list_first_entry_or_null(&vsdei->critical_events,
+					struct kvm_sdei_vcpu_event, link);
+		if (!ksve) {
+			ksve = list_first_entry_or_null(&vsdei->normal_events,
+					struct kvm_sdei_vcpu_event, link);
+		}
+	} else {
+		ksve = next_vcpu_event(vcpu, ksve_state->num);
+	}
+
+	if (!ksve)
+		return -ENOENT;
+
+	*ksve_state = ksve->state;
+
+	return 0;
+}
+
+static long kvm_sdei_set_vevent(struct kvm_vcpu *vcpu,
+				struct kvm_sdei_vcpu_event_state *ksve_state)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *kse = NULL;
+	struct kvm_sdei_kvm_event *kske = NULL;
+	struct kvm_sdei_vcpu_event *ksve = NULL;
+
+	if (!kvm_sdei_is_valid_event_num(ksve_state->num))
+		return -EINVAL;
+
+	kske = kvm_sdei_find_kvm_event(kvm, ksve_state->num);
+	if (!kske)
+		return -ENOENT;
+
+	ksve = kvm_sdei_find_vcpu_event(vcpu, ksve_state->num);
+	if (ksve)
+		return -EEXIST;
+
+	ksve = kzalloc(sizeof(*ksve), GFP_KERNEL);
+	if (!ksve)
+		return -ENOMEM;
+
+	kse = kske->kse;
+	ksve->state = *ksve_state;
+	ksve->kske  = kske;
+	ksve->vcpu  = vcpu;
+
+	if (kse->state.priority == SDEI_EVENT_PRIORITY_CRITICAL)
+		list_add_tail(&ksve->link, &vsdei->critical_events);
+	else
+		list_add_tail(&ksve->link, &vsdei->normal_events);
+
+	kvm_make_request(KVM_REQ_SDEI, vcpu);
+
+	return 0;
+}
+
+static long kvm_sdei_set_vcpu_state(struct kvm_vcpu *vcpu,
+				    struct kvm_sdei_vcpu_state *ksv_state)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_event *critical_ksve = NULL;
+	struct kvm_sdei_vcpu_event *normal_ksve = NULL;
+
+	if (kvm_sdei_is_valid_event_num(ksv_state->critical_num)) {
+		critical_ksve = kvm_sdei_find_vcpu_event(vcpu,
+					ksv_state->critical_num);
+		if (!critical_ksve)
+			return -EINVAL;
+	}
+
+	if (kvm_sdei_is_valid_event_num(ksv_state->critical_num)) {
+		normal_ksve = kvm_sdei_find_vcpu_event(vcpu,
+					ksv_state->critical_num);
+		if (!normal_ksve)
+			return -EINVAL;
+	}
+
+	vsdei->state = *ksv_state;
+	vsdei->critical_event = critical_ksve;
+	vsdei->normal_event   = normal_ksve;
+
+	return  0;
+}
+
+long kvm_sdei_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long arg)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_cmd *cmd = NULL;
+	void __user *argp = (void __user *)arg;
+	bool copy = false;
+	long ret = 0;
+
+	/* Sanity check */
+	if (!(ksdei && vsdei)) {
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
+	spin_lock(&vsdei->lock);
+
+	switch (cmd->cmd) {
+	case KVM_SDEI_CMD_GET_VEVENT_COUNT:
+		copy = true;
+		ret = kvm_sdei_get_vevent_count(vcpu, &cmd->count);
+		break;
+	case KVM_SDEI_CMD_GET_VEVENT:
+		copy = true;
+		ret = kvm_sdei_get_vevent(vcpu, &cmd->ksve_state);
+		break;
+	case KVM_SDEI_CMD_SET_VEVENT:
+		ret = kvm_sdei_set_vevent(vcpu, &cmd->ksve_state);
+		break;
+	case KVM_SDEI_CMD_GET_VCPU_STATE:
+		copy = true;
+		cmd->ksv_state = vsdei->state;
+		break;
+	case KVM_SDEI_CMD_SET_VCPU_STATE:
+		ret = kvm_sdei_set_vcpu_state(vcpu, &cmd->ksv_state);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	spin_unlock(&vsdei->lock);
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
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
