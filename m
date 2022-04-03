Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922B2C433F5
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:41:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39C674B20F;
	Sun,  3 Apr 2022 11:41:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0vGsdm6bWmTo; Sun,  3 Apr 2022 11:41:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 325A44B14D;
	Sun,  3 Apr 2022 11:41:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79E244B0DF
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:41:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9kqDjqhK3y+w for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:41:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74DF94B0F1
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:41:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000472;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PrMW1GidvsPmhW46oQQCOc/ckEuxqUmXOy5/nPzOjBY=;
 b=XbmIqQ00NKBvMa6NF/UdhjjlAXne0O0wkriUENhVthQ0GeYYW2JoyO50KbCK5UcDRF9zqb
 VkdcNggcgxZOH+S3M89LH1vrbmKAsvl7DzweKl1Vm7lPUCai84XFJnnHxsRfSaOdp+2BNT
 dpbFzw2jOw8tjZFxlbe3JdyrY3jKfGY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-JnseUGxkPz2hLf1dmAnbPw-1; Sun, 03 Apr 2022 11:41:08 -0400
X-MC-Unique: JnseUGxkPz2hLf1dmAnbPw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B58303811A20;
 Sun,  3 Apr 2022 15:41:07 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A7682403172;
 Sun,  3 Apr 2022 15:41:01 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 14/18] KVM: arm64: Support SDEI_EVENT_SIGNAL hypercall
Date: Sun,  3 Apr 2022 23:39:07 +0800
Message-Id: <20220403153911.12332-15-gshan@redhat.com>
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

This supports SDEI_EVENT_SIGNAL hypercall. It's used by guest
to inject event, whose number must be zero to the specified
vCPU. As the shared event isn't supported, calling vCPU is
assumed to be the target.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index ebdbe7810cf0..e1f6ab9800ee 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -455,6 +455,48 @@ static unsigned long hypercall_mask(struct kvm_vcpu *vcpu, bool mask)
 	return ret;
 }
 
+static unsigned long hypercall_signal(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_event *event;
+	unsigned int num = smccc_get_arg(vcpu, 1);
+	unsigned long ret = SDEI_SUCCESS;
+
+	/*
+	 * The event must be the software signaled one, whose number
+	 * is zero.
+	 */
+	if (!kvm_sdei_is_sw_signaled(num)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	spin_lock(&vsdei->lock);
+
+	/* Check if the vcpu has been masked */
+	if (vsdei->masked) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+	/* Check if the event exists */
+	event = find_event(vcpu, num);
+	if (!event) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+	if (inject_event(vcpu, event)) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto unlock;
+	}
+
+unlock:
+	spin_unlock(&vsdei->lock);
+out:
+	return ret;
+}
+
 static unsigned long hypercall_reset(struct kvm_vcpu *vcpu, bool private)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -539,6 +581,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_PE_UNMASK:
 		ret = hypercall_mask(vcpu, false);
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
