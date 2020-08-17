Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53681C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0A7D2067C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFtRLzHC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0A7D2067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A015F4C012;
	Mon, 17 Aug 2020 06:06:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pAwJh7mXIUwb; Mon, 17 Aug 2020 06:06:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A24304BFFA;
	Mon, 17 Aug 2020 06:06:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C0014BF95
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YKPPX0VRg-2I for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:06:05 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6534C01A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:06:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658763;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jx2ft7jNk6uUKo4Q5fMBSwtYtcM9rKqy80U2CKK3g2w=;
 b=ZFtRLzHCGQNNOD+rw3meYw2Jsn5tFGbn4devsnrWB1Vm3IVOi+z/eEmUO7SOxevODWKwXc
 UNbEmiZtlHqbcvYF7tYhDDm2w0zSrWdHZngo6ll2e4g5gWKQSbL2CJM3C1NUYcSdgJ5e/O
 yZqO81Uw+1epp1fUnTJuVNyzsgPMvB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-IcLVVlPgNYOH4SPof9HxwA-1; Mon, 17 Aug 2020 06:06:02 -0400
X-MC-Unique: IcLVVlPgNYOH4SPof9HxwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D67A81F00A;
 Mon, 17 Aug 2020 10:06:01 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 2359D78414;
 Mon, 17 Aug 2020 10:05:55 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 05/18] arm64/kvm: Support SDEI_1_0_FN_SDEI_VERSION hypercall
Date: Mon, 17 Aug 2020 20:05:18 +1000
Message-Id: <20200817100531.83045-6-gshan@redhat.com>
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

This supports SDEI_1_0_FN_SDEI_VERSION hypercall by returning the
corresponding version. The SDEI version retrieved from the underly
firmware is returned if that's supported. Otherwise, v1.0 is returned
to support the kvm private events, which originates from the kvm module
itself.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index e2090e9bab8b..f5739c0063df 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -36,6 +36,21 @@ static inline int kvm_sdei_unregister_event(struct sdei_event *event)
 }
 #endif /* CONFIG_ARM_SDE_INTERFACE */
 
+static unsigned long kvm_sdei_hypercall_version(struct kvm_vcpu *vcpu)
+{
+	unsigned long ret = SDEI_NOT_SUPPORTED;
+
+	if (kvm_sdei_data && kvm_sdei_data->supported) {
+		ret = kvm_sdei_data->version;
+		goto out;
+	}
+
+	ret = (1UL << SDEI_VERSION_MAJOR_SHIFT);
+
+out:
+	return ret;
+}
+
 static unsigned long kvm_sdei_reset(struct kvm *kvm, unsigned int types)
 {
 	struct kvm_sdei_event *e, *event = NULL;
@@ -107,6 +122,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 
 	switch (function) {
 	case SDEI_1_0_FN_SDEI_VERSION:
+		ret = kvm_sdei_hypercall_version(vcpu);
+		break;
 	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
 	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
 	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
