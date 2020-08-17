Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697E9C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 12404206C0
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TjrO9D+n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12404206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7944BF11;
	Mon, 17 Aug 2020 06:06:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TcOk+pDAjKaK; Mon, 17 Aug 2020 06:06:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3FE04C01E;
	Mon, 17 Aug 2020 06:06:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA7C44C014
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1w5zuGvuGbZ2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:35 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E87F4C03B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658795;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1dZ0aXLidtYoyvbLx7GIZ7l3TBlg4odQZr/5puX9EoM=;
 b=TjrO9D+nzwd6/4xqVngT7ZcpXXAXH3Yh0/YKVjMgWqsom5beYo9kF7ofysvNVWs3QF9xJH
 CQmMJk/bIrJq6xTEgrYRDbOZhSrtDXyEzGkkkeqe3aO5FoEhhpSRJOFTEgFBF10M0I8M1c
 PcPVDJAUluWndwdHKue+/yUUvIGWFzk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510--I85izVzO5KD8h_2HWfhtA-1; Mon, 17 Aug 2020 06:06:33 -0400
X-MC-Unique: -I85izVzO5KD8h_2HWfhtA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 642EE1014DEE;
 Mon, 17 Aug 2020 10:06:32 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B72B878498;
 Mon, 17 Aug 2020 10:06:29 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 13/18] arm64/kvm: Support SDEI_1_0_FN_SDEI_{PRIVATE,
 SHARED}_RESET hypercall
Date: Mon, 17 Aug 2020 20:05:26 +1000
Message-Id: <20200817100531.83045-14-gshan@redhat.com>
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
References: <20200817100531.83045-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
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

This supports SDEI_1_0_FN_SDEI_{PRIVATE,SHARED}_RESET hypercall by
adding kvm_sdei_hypercall_reset(). We can't direct the hypercall to
underly firmware for passthrou event because it might be shared by
multiple VMs. So the trick is to simulate the behaviour to unregister
all the (private or shared) events which have been registered on the
speicific VM. However, the request is directed to underly firmware
by calling sdei_event_unregister() when last event (reference) exits.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 0816136e73a6..2d5e44bb5497 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -741,6 +741,18 @@ static unsigned long kvm_sdei_reset(struct kvm *kvm, unsigned int types)
 	return ret;
 }
 
+static unsigned long kvm_sdei_hypercall_reset(struct kvm_vcpu *vcpu,
+					      bool is_private)
+{
+	struct kvm *kvm = vcpu->kvm;
+	unsigned int types = is_private ? (1 << SDEI_EVENT_TYPE_PRIVATE) :
+					  (1 << SDEI_EVENT_TYPE_SHARED);
+
+	kvm_sdei_reset(kvm, types);
+
+	return SDEI_SUCCESS;
+}
+
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 {
 	u32 function = smccc_get_function(vcpu);
@@ -782,8 +794,14 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 		break;
 	case SDEI_1_0_FN_SDEI_INTERRUPT_BIND:
 	case SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE:
+		ret = SDEI_NOT_SUPPORTED;
+		break;
 	case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
+		ret = kvm_sdei_hypercall_reset(vcpu, true);
+		break;
 	case SDEI_1_0_FN_SDEI_SHARED_RESET:
+		ret = kvm_sdei_hypercall_reset(vcpu, false);
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
