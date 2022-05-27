Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD0DC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:05:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D76B74B358;
	Fri, 27 May 2022 04:05:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S-KW9zT+civ1; Fri, 27 May 2022 04:05:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B59E74B284;
	Fri, 27 May 2022 04:05:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 979AC49F0F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4qDOsASDaN+X for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:05:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B98CF4B186
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:05:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638708;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0BNXaqWA1otDLXqlPZtOcrW0E3FZ4yYhwe+GYceYi8I=;
 b=YslvSMK7zft+0mx8wU6yBLfOva3a56L+MJU0Zd5PJRoQd0jmPTQ0EBVxVva2Bv+RIisVHI
 OXIGc58EKmYBvtLSy605g7q2XmAsizojrQ4jinE3gROToP9Aa8IMlNcsJEY4q6E0vwaqS7
 BAokKoEn42w8J0jIhci1ipoFq6lLs3E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-NQFO-vD3OKS2WgVUIQ3FNg-1; Fri, 27 May 2022 04:05:04 -0400
X-MC-Unique: NQFO-vD3OKS2WgVUIQ3FNg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 211233804506;
 Fri, 27 May 2022 08:05:04 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 391E42026D64;
 Fri, 27 May 2022 08:04:56 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 10/22] KVM: arm64: Support PE_{MASK, UNMASK} hypercall
Date: Fri, 27 May 2022 16:02:41 +0800
Message-Id: <20220527080253.1562538-11-gshan@redhat.com>
In-Reply-To: <20220527080253.1562538-1-gshan@redhat.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: maz@kernel.org, shijie@amperemail.onmicrosoft.com,
 linux-kernel@vger.kernel.org, eauger@redhat.com, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, vkuznets@redhat.com,
 will@kernel.org
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

This supports PE_{MASK, UNMASK} hypercall. When PE_UNMASK is called,
KVM_REQ_SDEI request becomes pending if there are any events need
to be delivered.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index cea523418c75..6afa49b4f3c7 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -169,6 +169,21 @@ static unsigned long event_info(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static unsigned long pe_mask(struct kvm_vcpu *vcpu, bool mask)
+{
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+
+	if (mask) {
+		vcpu->arch.flags |= KVM_ARM64_SDEI_MASKED;
+	} else {
+		vcpu->arch.flags &= ~KVM_ARM64_SDEI_MASKED;
+		if (vsdei->pending)
+			kvm_make_request(KVM_REQ_SDEI, vcpu);
+	}
+
+	return SDEI_SUCCESS;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -208,6 +223,12 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
 		ret = event_info(vcpu);
 		break;
+	case SDEI_1_0_FN_SDEI_PE_MASK:
+		ret = pe_mask(vcpu, true);
+		break;
+	case SDEI_1_0_FN_SDEI_PE_UNMASK:
+		ret = pe_mask(vcpu, false);
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
