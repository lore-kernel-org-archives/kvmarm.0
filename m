Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19190C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B09132067C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YVaiTvSD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B09132067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FBC24C004;
	Mon, 17 Aug 2020 06:06:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F28kdyKSQ85V; Mon, 17 Aug 2020 06:06:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 398844BF11;
	Mon, 17 Aug 2020 06:06:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5324C029
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jy0nP8nG9H-v for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:48 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1D8A4BE67
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658807;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=RJSkSg+wA2/it56YgV78G24Vul4IAF78buFIkidCoM4=;
 b=YVaiTvSD20to0yVSnWrQt7/scoyE8TrdwO+yzsme5ZnGJi4fHkwNW8Do2gm25V4gc8/xPr
 ndWptzsCicPQJINVbVMfFrC9Z3IGiLDGEMQfezRf4fJH425HJh/yGVm9t81q6n9U4buZcq
 ejb0QT2/Go58d4SrRmc+9ZvEwjWHV+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-GBEG6Y1MNraJHp07mdxr1A-1; Mon, 17 Aug 2020 06:06:46 -0400
X-MC-Unique: GBEG6Y1MNraJHp07mdxr1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07C2E801AC8;
 Mon, 17 Aug 2020 10:06:45 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 4E9DE78498;
 Mon, 17 Aug 2020 10:06:42 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 16/18] arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_CONTEXT
 hypercall
Date: Mon, 17 Aug 2020 20:05:29 +1000
Message-Id: <20200817100531.83045-17-gshan@redhat.com>
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
References: <20200817100531.83045-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com
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

This supports SDEI_1_0_FN_SDEI_EVENT_CONTEXT hypercall by implementing
kvm_sdei_hypercall_context(). If there is valid context on the current
vCPU and the register index isn't out of scope, the register values are
returned. Otherwise, errno is returned.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index cf6908e87edd..0c5a16e8cbac 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -590,6 +590,35 @@ static unsigned long kvm_sdei_hypercall_enable(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static unsigned long kvm_sdei_hypercall_context(struct kvm_vcpu *vcpu)
+{
+	struct user_pt_regs *regs;
+	unsigned long index = smccc_get_arg1(vcpu);
+	unsigned long ret = SDEI_SUCCESS;
+
+	if (index > 17) {
+		ret = SDEI_INVALID_PARAMETERS;
+		goto out;
+	}
+
+	spin_lock(&vcpu->arch.sdei_lock);
+
+	if (vcpu->arch.sdei_critical_event) {
+		regs = &vcpu->arch.sdei_critical_regs;
+	} else if (vcpu->arch.sdei_normal_event) {
+		regs = &vcpu->arch.sdei_normal_regs;
+	} else {
+		ret = SDEI_DENIED;
+		goto unlock;
+	}
+
+	ret = regs->regs[index];
+unlock:
+	spin_unlock(&vcpu->arch.sdei_lock);
+out:
+	return ret;
+}
+
 static unsigned long kvm_sdei_hypercall_complete(struct kvm_vcpu *vcpu,
 						 bool resume)
 {
@@ -1075,7 +1104,7 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_sdei_hypercall_enable(vcpu, false);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_CONTEXT:
-		ret = SDEI_NOT_SUPPORTED;
+		ret = kvm_sdei_hypercall_context(vcpu);
 		break;
 	case SDEI_1_0_FN_SDEI_EVENT_COMPLETE:
 		has_result = false;
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
