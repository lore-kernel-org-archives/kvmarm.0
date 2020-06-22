Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491C4C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 14:27:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C558E20738
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 14:27:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDWRlNK4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C558E20738
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 444F74B0C3;
	Mon, 22 Jun 2020 10:27:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ygop0+njFBNt; Mon, 22 Jun 2020 10:27:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 209C34B096;
	Mon, 22 Jun 2020 10:27:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8076E4B08F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 10:27:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r1E-rCbf6RPv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 10:27:16 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EF7A4B285
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 10:27:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1592836036;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=9uD3j+Fl0EghgQ3JG4DsVJd4zWFJnSvudjcwl2IixxI=;
 b=gDWRlNK4X14drtMFiFsRsGLw1RZtQGDvDU67G4fdsQGSclwyU8RKTHcBn7v8Rzp/jtHjYs
 xfIIoXjOpEYHJg6kuA/jWfH3NilQaWAl2mt56JuOdz7Kr7W2245cTSy7sdX/tHYiG9odF7
 GITnA4RYTgWtpoyKJWcpbqCbW1KKzWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16--90-DXc-MGGDUbClYnY_Dg-1; Mon, 22 Jun 2020 10:27:14 -0400
X-MC-Unique: -90-DXc-MGGDUbClYnY_Dg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3290E107B765;
 Mon, 22 Jun 2020 14:27:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E26C87C1F9;
 Mon, 22 Jun 2020 14:27:11 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: pvtime: Ensure task delay accounting is enabled
Date: Mon, 22 Jun 2020 16:27:10 +0200
Message-Id: <20200622142710.18677-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, steven.price@arm.com
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

Ensure we're actually accounting run_delay before we claim that we'll
expose it to the guest. If we're not, then we just pretend like steal
time isn't supported in order to avoid any confusion.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/pvtime.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 1e0f4c284888..f7b52ce1557e 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -3,6 +3,7 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
+#include <linux/sched/stat.h>
 
 #include <asm/kvm_mmu.h>
 #include <asm/pvclock-abi.h>
@@ -73,6 +74,11 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	return base;
 }
 
+static bool kvm_arm_pvtime_supported(void)
+{
+	return !!sched_info_on();
+}
+
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr)
 {
@@ -82,7 +88,8 @@ int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 	int ret = 0;
 	int idx;
 
-	if (attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
+	if (!kvm_arm_pvtime_supported() ||
+	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
 		return -ENXIO;
 
 	if (get_user(ipa, user))
@@ -110,7 +117,8 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 	u64 __user *user = (u64 __user *)attr->addr;
 	u64 ipa;
 
-	if (attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
+	if (!kvm_arm_pvtime_supported() ||
+	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
 		return -ENXIO;
 
 	ipa = vcpu->arch.steal.base;
@@ -125,7 +133,8 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 {
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PVTIME_IPA:
-		return 0;
+		if (kvm_arm_pvtime_supported())
+			return 0;
 	}
 	return -ENXIO;
 }
-- 
2.25.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
