Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933BAC433F5
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:40:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A18B49EEB;
	Sun,  3 Apr 2022 11:40:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tdp6WueUUSx5; Sun,  3 Apr 2022 11:40:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C82C4B0BD;
	Sun,  3 Apr 2022 11:40:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A852449EEB
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IuUaSAik2hua for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:40:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A022F49EC5
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000432;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=8gXYZwt3oa1TLxdRQmFVOYT1n1r/hpVr+I1ttZPkVUo=;
 b=b+fV3quGWLjpggEDgq4dYkAWHaIFMNPP8VixQ31ImAHai1DF0oyOws7nCrS5fYBkczKu2N
 FBeJf8/uYWtG89TmMVLy4M7j/phzdD7NDD2K4dvLQjgOZ8S6nnSv6J0JuECIXj/Hl/zFPN
 CJRLTqzz1F1GYJLqk2MMV+RpU/TNAPQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-x_1FQuIINQis-IQ714WaUQ-1; Sun, 03 Apr 2022 11:40:27 -0400
X-MC-Unique: x_1FQuIINQis-IQ714WaUQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD0891C04B41;
 Sun,  3 Apr 2022 15:40:26 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F0C354538D7;
 Sun,  3 Apr 2022 15:40:20 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 08/18] KVM: arm64: Support SDEI_EVENT_STATUS hypercall
Date: Sun,  3 Apr 2022 23:39:01 +0800
Message-Id: <20220403153911.12332-9-gshan@redhat.com>
In-Reply-To: <20220403153911.12332-1-gshan@redhat.com>
References: <20220403153911.12332-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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

This supports SDEI_EVENT_STATUS hypercall. It's used by guest
to retrieve the status about the specified event. A bitmap is
returned to indicate the corresponding status: registration,
enablement and servicing state.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index f774f2cf0ac7..b847c6028b74 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -247,6 +247,48 @@ static unsigned long hypercall_unregister(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long hypercall_status(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_context *context;
+	struct kvm_sdei_exposed_event *exposed_event;
+	struct kvm_sdei_event *event;
+	unsigned int num = smccc_get_arg(vcpu, 1);
+	unsigned long ret = 0;
+
+	if (!kvm_sdei_is_supported(num)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	spin_lock(&vsdei->lock);
+
+	/*
+	 * Check if the event exists. None of the flags will be set
+	 * if it doesn't exist.
+	 */
+	event = find_event(vcpu, num);
+	if (!event)
+		goto unlock;
+
+	if (kvm_sdei_is_registered(event))
+		ret |= (1UL << SDEI_EVENT_STATUS_REGISTERED);
+	if (kvm_sdei_is_enabled(event))
+		ret |= (1UL << SDEI_EVENT_STATUS_ENABLED);
+
+	exposed_event = event->exposed_event;
+	context = kvm_sdei_is_critical(exposed_event->priority) ?
+		  &vsdei->context[SDEI_EVENT_PRIORITY_CRITICAL] :
+		  &vsdei->context[SDEI_EVENT_PRIORITY_NORMAL];
+	if (context->event == event)
+		ret |= (1UL << SDEI_EVENT_STATUS_RUNNING);
+
+unlock:
+	spin_unlock(&vsdei->lock);
+out:
+	return ret;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -283,6 +325,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
 		ret = hypercall_unregister(vcpu);
 		break;
+	case SDEI_1_0_FN_SDEI_EVENT_STATUS:
+		ret = hypercall_status(vcpu);
+		break;
 	default:
 		ret = SDEI_NOT_SUPPORTED;
 	}
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
