Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBF8C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 08:08:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B60E40CDE;
	Tue, 22 Mar 2022 04:08:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vX6ypDA0z84g; Tue, 22 Mar 2022 04:08:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9F6149ED5;
	Tue, 22 Mar 2022 04:08:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7829940FAA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:08:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gfUXzT82CuBV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 04:08:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A74D40CDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 04:08:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647936498;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hhCVxnMMhxOLAoQ7CT56ngfiw6zvDll/EwZY6fngGZg=;
 b=YRsiklvnVTBdwT8mNY7KiZ4Hik7rVoFmkcp9IPbxEnUbn3eARCcYiHC2nV01YHcjkWpxOi
 CWF2cH3HVATlmAZS58Do5cvjuPFn8b/8hMJDgtkz4e/G4QrF3hKBlu4bRJUzim19nWCq9w
 E+QbBcyPwL417YPrdZVlAzGll/ZHbDU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-GRq1ZWpqOvKw7cQW1QWGrQ-1; Tue, 22 Mar 2022 04:08:14 -0400
X-MC-Unique: GRq1ZWpqOvKw7cQW1QWGrQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26ACC38041CE;
 Tue, 22 Mar 2022 08:08:14 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 187621121325;
 Tue, 22 Mar 2022 08:08:07 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 03/22] KVM: arm64: Support SDEI_VERSION hypercall
Date: Tue, 22 Mar 2022 16:06:51 +0800
Message-Id: <20220322080710.51727-4-gshan@redhat.com>
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

This supports SDEI_VERSION hypercall by returning v1.1, which is
the specification version we're following. The vendor is set to
'KVM'.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/sdei.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 8a9b477b8977..5a3a64cd6e84 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -118,6 +118,14 @@ static bool remove_all_vcpu_events(struct kvm_vcpu *vcpu,
 	return pending;
 }
 
+static unsigned long hypercall_version(struct kvm_vcpu *vcpu)
+{
+	/* v1.1 and the vendor is KVM */
+	return (1UL << SDEI_VERSION_MAJOR_SHIFT) |
+	       (1UL << SDEI_VERSION_MINOR_SHIFT) |
+	       0x4b564d;
+}
+
 int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -142,6 +150,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
 
 	switch (func) {
 	case SDEI_1_0_FN_SDEI_VERSION:
+		ret = hypercall_version(vcpu);
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
