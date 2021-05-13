Return-Path: <SRS0=4nKG=KI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E532C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 11:06:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 069FE611AD
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 11:06:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 069FE611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9066B4B89E;
	Thu, 13 May 2021 07:06:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2A7L4t9o7+lX; Thu, 13 May 2021 07:06:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 916854B8A1;
	Thu, 13 May 2021 07:06:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DCAB4B899
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 07:06:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vJNTqO-yFcmT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 May 2021 07:06:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F294B897
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 07:06:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620904005;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=gsWC6J70o6b0pVkL+gUwIw95ElvD0h548+CAgK/jyk8=;
 b=TUX0mKu9moGmbBHxptcMnbM0aM1DBEwxg7ycfmwpzAzMWEBxmkjOMR0YAqZrLsBaluMkS9
 nEoo6udzthWEAC26PMzdBhk19qoiBxxjdCKgs7f1IJa4tI/hvjblWijQ10Og29DZU5a+1I
 n4J7wgSJhT21BsjsMa/v7Mui307ENZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-AJtCcZ8pO0WKCjzLudgMyw-1; Thu, 13 May 2021 07:06:41 -0400
X-MC-Unique: AJtCcZ8pO0WKCjzLudgMyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A49C501E8;
 Thu, 13 May 2021 11:06:40 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-43.bne.redhat.com [10.64.54.43])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E33315D6AC;
 Thu, 13 May 2021 11:06:37 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: selftests: Request PMU feature in get-reg-list
Date: Thu, 13 May 2021 21:06:55 +0800
Message-Id: <20210513130655.73154-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 maz@kernel.org
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

Since the following commit, PMU registers are hidden from user until
it's explicitly requested by feeding feature (KVM_ARM_VCPU_PMU_V3).
Otherwise, 74 missing PMU registers are missing as the following
log indicates.

   11663111cd49 ("KVM: arm64: Hide PMU registers from userspace when not available")

   # ./get-reg-list
   Number blessed registers:   308
   Number registers:           238

   There are 74 missing registers.
   The following lines are missing registers:

      	ARM64_SYS_REG(3, 0, 9, 14, 1),
	ARM64_SYS_REG(3, 0, 9, 14, 2),
             :
	ARM64_SYS_REG(3, 3, 14, 15, 7),

This fixes the issue of wrongly reported missing PMU registers by
requesting it explicitly.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 486932164cf2..6c6bdc6f5dc3 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -314,6 +314,8 @@ static void core_reg_fixup(void)
 
 static void prepare_vcpu_init(struct kvm_vcpu_init *init)
 {
+	init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
+
 	if (reg_list_sve())
 		init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
 }
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
