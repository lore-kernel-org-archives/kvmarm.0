Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744ABC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:09:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29A8140CDE;
	Tue, 22 Mar 2022 04:09:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wv0oGAH+70ij; Tue, 22 Mar 2022 04:09:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20B6740FC0;
	Tue, 22 Mar 2022 04:09:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F26E40BE7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:09:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o8p0xA2DRGvQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:09:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD13A40431
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:09:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936575;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gltiXYOSEEjNUqLYmzcduTiT7DayTJW8FdFdmgcfQdQ=;
 b=XQGib4GKZCKJGGSBB5LlhWEG6Da0CyHUw+wAUpLXTvoBoofQH3xhlX5GLVahFe3f8ErKIp
 o6v0VWVf5EJ3unQMIfxnGp8l/TEoWrfiQRSGgMsg4TlMtTzDMtGmZmn6nEApeWruIIK6ll
 ErWOp3L5/i7+FpGJnXiiqVOaxJCN7pk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-Q090hviFPbuszSirU_DsBQ-1; Tue, 22 Mar 2022 04:09:34 -0400
X-MC-Unique: Q090hviFPbuszSirU_DsBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96E4C185A794;
 Tue, 22 Mar 2022 08:09:33 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ED681121324;
 Tue, 22 Mar 2022 08:09:11 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 11/22] KVM: arm64: Support SDEI_PE_{MASK, UNMASK} hypercall
Date: Tue, 22 Mar 2022 16:06:59 +0800
Message-Id: <20220322080710.51727-12-gshan@redhat.com>
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

This supports SDEI_PE_{MASK, UNMASK} hypercall. They are used by
the guest to stop or start receiving SDEI event on the specified
vCPU.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index db82ea441eae..b2a916724cfa 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -625,6 +625,18 @@ static unsigned long hypercall_route(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long hypercall_mask(struct kvm_vcpu *vcpu, bool mask)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	unsigned long ret = SDEI_SUCCESS;
+
+	spin_lock(&vsdei->lock);
+	vsdei->state.masked = mask ? 1 : 0;
+	spin_unlock(&vsdei->lock);
+
+	return ret;
+}
+
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -680,7 +692,11 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = hypercall_route(vcpu);
 		break;
 	case SDEI_1_0_FN_SDEI_PE_MASK:
+		ret = hypercall_mask(vcpu, true);
+		break;
 	case SDEI_1_0_FN_SDEI_PE_UNMASK:
+		ret = hypercall_mask(vcpu, false);
+		break;
 	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
 	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
 	case SDEI_1_1_FN_SDEI_EVENT_SIGNAL:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
