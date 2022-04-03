Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EEEC433FE
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:41:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87A7B4B0F1;
	Sun,  3 Apr 2022 11:41:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BkZ26HT9NIsA; Sun,  3 Apr 2022 11:41:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 612124B20B;
	Sun,  3 Apr 2022 11:41:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CEF24B0DF
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:41:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hOUFD4lKQ4iA for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:41:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77DD64B0F1
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:41:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000479;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7UtGCQ6T1u11qhK091mocG/kgchg6wglV6l9vGFS41E=;
 b=ZIfKnbpOP0hCLcUCymr7s7q2hXysGxLwDsLx+6pdvjOosdlFcG8HdOAeYPW8yF7Ha3ZTMz
 Hmms9oJWpMSm1tFxxN/BJLThl9hmZGKbSv8tHQYZ0DjOUzBUgfaw33WK1R+VrNaHOPo4na
 r9O9bLLgR7+Bmsf8ZUdT4FZI7JVy5Kg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-HCKXWHClNaywshvC35LKUA-1; Sun, 03 Apr 2022 11:41:15 -0400
X-MC-Unique: HCKXWHClNaywshvC35LKUA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C810101A52C;
 Sun,  3 Apr 2022 15:41:14 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E61A403172;
 Sun,  3 Apr 2022 15:41:08 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 15/18] KVM: arm64: Support SDEI_FEATURES hypercall
Date: Sun,  3 Apr 2022 23:39:08 +0800
Message-Id: <20220403153911.12332-16-gshan@redhat.com>
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

This supports SDEI_FEATURES hypercall. It's used by guest to
retrieve the supported features, which are number of slots for
the interrupt binding events and relative mode for the event
handler. Currently, none of them is supported.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index e1f6ab9800ee..ab0b7b5e3191 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -527,6 +527,23 @@ static unsigned long hypercall_reset(struct kvm_vcpu *vcpu, bool private)
 	return ret;
 }
 
+static unsigned long hypercall_features(struct kvm_vcpu *vcpu)
+{
+	unsigned long feature = smccc_get_arg(vcpu, 1);
+	unsigned long ret;
+
+	switch (feature) {
+	case 0: /* BIND_SLOTS */
+	case 1: /* RELATIVE_MODE */
+		ret = 0;
+		break;
+	default:
+		ret = SDEI_INVALID_PARAMETERS;
+	}
+
+	return ret;
+}
+
 int kvm_sdei_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
@@ -590,6 +607,9 @@ int kvm_sdei_call(struct kvm_vcpu *vcpu)
 	case SDEI_1_0_FN_SDEI_SHARED_RESET:
 		ret = hypercall_reset(vcpu, false);
 		break;
+	case SDEI_1_1_FN_SDEI_FEATURES:
+		ret = hypercall_features(vcpu);
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
