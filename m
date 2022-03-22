Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A97CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:10:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A54440CDE;
	Tue, 22 Mar 2022 04:10:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B1SQAbba1fJe; Tue, 22 Mar 2022 04:10:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D666043479;
	Tue, 22 Mar 2022 04:10:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F0E540CDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:10:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vJpYlBth1TUa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:10:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EE344141A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:10:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936613;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=npnSDsjzzEy3QMCifPgGVfzBgN0vFmIBHdTnsx69Pjw=;
 b=VXa8DDS5hND5ZBWk66+gq3WPQacDElJJ4X697qFd1Or+4djaQstNC6DYSUBaLzutIXVRtZ
 tVu4AxfJkSaoU1tKAMFctwqIshDgRuysgl/4PP8YI5fO+XYEtU6iU5b+XwIPuOwc7KwqAV
 u2v8N105Pqt/LsviLR9Mz9jaQfeRSIM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-RkZBMxGnOUOEPHCQHC-T7w-1; Tue, 22 Mar 2022 04:10:10 -0400
X-MC-Unique: RkZBMxGnOUOEPHCQHC-T7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABC63811E75;
 Tue, 22 Mar 2022 08:10:09 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A9A461121324;
 Tue, 22 Mar 2022 08:09:58 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 15/22] KVM: arm64: Support SDEI_EVENT_SIGNAL hypercall
Date: Tue, 22 Mar 2022 16:07:03 +0800
Message-Id: <20220322080710.51727-16-gshan@redhat.com>
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

This supports SDEI_EVENT_SIGNAL hypercall. It's used by the guest
to inject SDEI event, whose number must be zero to the specified
vCPU. As the routing mode and affinity isn't supported yet, the
calling vCPU is assumed to be the target.

The SDEI event 0x0 is a private one, with normal priority. It's
usually used for testing.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 64 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index a24270378305..ba2ca65c871b 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -726,6 +726,66 @@ static int do_inject_event(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static unsigned long hypercall_signal(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_exposed_event *exposed_event;
+	struct kvm_sdei_registered_event *registered_event;
+	unsigned long event_num = smccc_get_arg1(vcpu);
+	int index;
+	unsigned long ret = SDEI_SUCCESS;
+
+	/* @event_num must be zero */
+	if (!kvm_sdei_is_default(event_num)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	spin_lock(&ksdei->lock);
+
+	/* Check if the registered event exists */
+	registered_event = find_registered_event(kvm, event_num);
+	if (!registered_event) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock_kvm;
+	}
+
+	/*
+	 * Check if the event has been registered and enabled. The
+	 * @target_pe parameter isn't checked for now and the event
+	 * is assumed to injected the current vcpu. We should fix it
+	 * when the routing mode and affinity are supported.
+	 */
+	exposed_event = registered_event->exposed_event;
+	index = kvm_sdei_vcpu_index(vcpu, exposed_event);
+	if (!kvm_sdei_is_registered(registered_event, index) ||
+	    !kvm_sdei_is_enabled(registered_event, index) ||
+	    kvm_sdei_is_unregister_pending(registered_event, index)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock_kvm;
+	}
+
+	/* Check if the vcpu has been masked off */
+	spin_lock(&vsdei->lock);
+	if (vsdei->state.masked) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock_vcpu;
+	}
+
+	/* Inject the event */
+	if (do_inject_event(vcpu, registered_event, false))
+		ret = SDEI_INVALID_PARAMETERS;
+
+unlock_vcpu:
+	spin_unlock(&vsdei->lock);
+unlock_kvm:
+	spin_unlock(&ksdei->lock);
+out:
+	return ret;
+}
+
 static unsigned long hypercall_reset(struct kvm_vcpu *vcpu, bool private)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -827,9 +887,11 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		break;
 	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
 	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
-	case SDEI_1_1_FN_SDEI_EVENT_SIGNAL:
 		ret = SDEI_NOT_SUPPORTED;
 		break;
+	case SDEI_1_1_FN_SDEI_EVENT_SIGNAL:
+		ret = hypercall_signal(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
 		ret = hypercall_reset(vcpu, true);
 		break;
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
