Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8614C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:08:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FE8C41049;
	Tue, 22 Mar 2022 04:08:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JyBYM1w+1tOM; Tue, 22 Mar 2022 04:08:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49F6549ECC;
	Tue, 22 Mar 2022 04:08:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 142D340BE7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:08:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id haWzynnEFKdR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:08:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1EEC40465
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:08:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936526;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CA0H5z8Y8jCywSeEwJTZ/p/KNFj1y45LOqR+04gyQvM=;
 b=P4lejcfDAKxMRzaHpAeRSzLSu6hyMzT1etaaXEZuOz37uFb5/hryx/Tz5CqoWausnHFmyT
 MRAhDcLjDHMyhIMfjZp2etuRx1IjL80eW9gLobgHVLhxKNVKNzX2c0agKBZ+IY5ts+ANER
 9XGBqOqMXnJTftO4DgTHS0XXL1CnjvU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-IV6VDCqaMjeWV-YfzD9R6Q-1; Tue, 22 Mar 2022 04:08:43 -0400
X-MC-Unique: IV6VDCqaMjeWV-YfzD9R6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0B5B1C05AF2;
 Tue, 22 Mar 2022 08:08:42 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0ACDB1121324;
 Tue, 22 Mar 2022 08:08:32 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 06/22] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
Date: Tue, 22 Mar 2022 16:06:54 +0800
Message-Id: <20220322080710.51727-7-gshan@redhat.com>
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

This supports SDEI_EVENT_CONTEXT hypercall. It's used by the guest
to retrieve the registers (R0 - R17) in the preempted context
in the SDEI event handler. The preempted context is saved prior to
servicing or handling the SDEI event and restored after that.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 4ab58f264992..4488d3f044f2 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -297,6 +297,34 @@ static unsigned long hypercall_enable(struct kvm_vcpu *vcpu, bool enable)
 	return ret;
 }
 
+static unsigned long hypercall_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_regs_state *regs;
+	unsigned long param_id = smccc_get_arg1(vcpu);
+	unsigned long ret = SDEI_SUCCESS;
+
+	spin_lock(&vsdei->lock);
+
+	/* Check if the pending event exists */
+	if (!vsdei->critical_event && !vsdei->normal_event) {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	/* Fetch the requested register */
+	regs = vsdei->critical_event ? &vsdei->state.critical_regs :
+				       &vsdei->state.normal_regs;
+	if (param_id < ARRAY_SIZE(regs->regs))
+		ret = regs->regs[param_id];
+	else
+		ret = SDEI_INVALID_PARAMETERS;
+
+unlock:
+	spin_unlock(&vsdei->lock);
+	return ret;
+}
+
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -333,6 +361,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = hypercall_enable(vcpu, false);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
+		ret = hypercall_context(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
 	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME:
 	case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
