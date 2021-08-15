Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526BEC4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:15:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED2E661038
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 00:15:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ED2E661038
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EC8D4B0BD;
	Sat, 14 Aug 2021 20:15:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zuVEectFRiQY; Sat, 14 Aug 2021 20:15:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF7B4B0D3;
	Sat, 14 Aug 2021 20:15:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 050834AC78
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:15:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F5b6Pvu1Id-i for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 20:15:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE584B0D8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 20:15:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628986536;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=X46dL+Dxa0Beu/4FdJWlRN+ae/iv3cx+wb2LKnpjilA=;
 b=DKe9Fpl21bW8nZsVgkGiVvcVbTvsvV3l+K13SmwNzhwFETxOu+SOyW4Mx0nec3tXn+TB+Q
 RRtMbAR3uLnftWIlYQoJvLo9JDU6Alhtnb3jtl+7Uu8LWUKz4ZWLBeLDfmPBOpOHsXuVwI
 x2M8xkR0lGF7+kBYchUCiImOAXUA79Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-aGFhUmwHNHWxZvW-hqqlEg-1; Sat, 14 Aug 2021 20:15:34 -0400
X-MC-Unique: aGFhUmwHNHWxZvW-hqqlEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F1E4800493;
 Sun, 15 Aug 2021 00:15:33 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9321F10016FF;
 Sun, 15 Aug 2021 00:15:26 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 16/21] KVM: arm64: Support SDEI ioctl commands on VM
Date: Sun, 15 Aug 2021 08:13:47 +0800
Message-Id: <20210815001352.81927-17-gshan@redhat.com>
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
index 4ef661d106fe..35ff05be3c28 100644
--- a/arch/arm64/include/uapi/asm/kvm_sdei.h
+++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
@@ -57,5 +57,22 @@ struct kvm_sdei_vcpu_state {
 	struct kvm_sdei_vcpu_regs	normal_regs;
 };
 
+#define KVM_SDEI_CMD_GET_VERSION		0
+#define KVM_SDEI_CMD_SET_EVENT			1
+#define KVM_SDEI_CMD_GET_KEVENT_COUNT		2
+#define KVM_SDEI_CMD_GET_KEVENT			3
+#define KVM_SDEI_CMD_SET_KEVENT			4
+
+struct kvm_sdei_cmd {
+	__u32						cmd;
+	union {
+		__u32					version;
+		__u32					count;
+		__u64					num;
+		struct kvm_sdei_event_state		kse_state;
+		struct kvm_sdei_kvm_event_state		kske_state;
+	};
+};
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _UAPI__ASM_KVM_SDEI_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0c3db1ef1ba9..8d61585124b2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1389,6 +1389,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
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
index d9e4aabcb31a..8cf41fd4bf86 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1679,6 +1679,9 @@ struct kvm_xen_vcpu_attr {
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
 
+/* Available with KVM_CAP_ARM_SDEI */
+#define KVM_ARM_SDEI_COMMAND	_IOWR(KVMIO, 0xce, struct kvm_sdei_cmd)
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
