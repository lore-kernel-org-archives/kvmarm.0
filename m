Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56800C433F5
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:40:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4E54B172;
	Sun,  3 Apr 2022 11:40:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rUz1yy7YqLn4; Sun,  3 Apr 2022 11:40:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1BF049ED7;
	Sun,  3 Apr 2022 11:40:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64C304A0FE
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SWbezWLY5Qcl for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:40:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69C7D49EC5
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:40:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000417;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hOAckF7XE+z1BmKgQieJWiGjz7ieZRtxUaQvoClm23s=;
 b=BKC8XrUIQ/zNur+IL8Awk0tTmDZ07xtP/M5lvictopVbQnSHJqosh0ImvUHZIaSKgZZR0O
 AS/gdd76bw/uIuRchraMR1/PNNe1Pp7521cECaS4/Qki1hZZA2EoOyQK4WCVdm14u8NAMg
 kxP+gT0d8w/2QL43UhxBOL3IrN2WySw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-XbBqwpsSMZazJ7r2LOKjjg-1; Sun, 03 Apr 2022 11:40:14 -0400
X-MC-Unique: XbBqwpsSMZazJ7r2LOKjjg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67501811E7A;
 Sun,  3 Apr 2022 15:40:13 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CA54403172;
 Sun,  3 Apr 2022 15:40:06 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 06/18] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
Date: Sun,  3 Apr 2022 23:38:59 +0800
Message-Id: <20220403153911.12332-7-gshan@redhat.com>
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

This supports SDEI_EVENT_CONTEXT hypercall. It's used by the guest
to retrieve the registers (x0 - x17) from the interrupted or preempted
context in the event handler. The interrupted or preempted context
is saved prior to handling the event by executing its handler and
restored after that.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 941263578b30..af5d11b8eb2f 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -140,6 +140,37 @@ static unsigned long hypercall_enable(struct kvm_vcpu *vcpu, bool enable)
 	return ret;
 }
 
+static unsigned long hypercall_context(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	struct kvm_sdei_vcpu_context *context;
+	unsigned long param_id = smccc_get_arg(vcpu, 1);
+	unsigned long ret = SDEI_SUCCESS;
+
+	spin_lock(&vsdei->lock);
+
+	/* Check if we have events are being handled */
+	context = &vsdei->context[SDEI_EVENT_PRIORITY_CRITICAL];
+	context = context->event ? context : NULL;
+	context = context ? : &vsdei->context[SDEI_EVENT_PRIORITY_NORMAL];
+	context = context->event ? context : NULL;
+	if (!context) {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	/* Fetch the requested register */
+	if (param_id < ARRAY_SIZE(context->regs))
+		ret = context->regs[param_id];
+	else
+		ret = SDEI_INVALID_PARAMETERS;
+
+unlock:
+	spin_unlock(&vsdei->lock);
+
+	return ret;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -170,6 +201,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
 		ret = hypercall_enable(vcpu, false);
 		break;
+	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
+		ret = hypercall_context(vcpu);
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
