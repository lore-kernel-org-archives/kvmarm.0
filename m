Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31494C6FA82
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 17:02:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFA354B1AD;
	Thu, 22 Sep 2022 13:02:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tzlH2cBWw9Lk; Thu, 22 Sep 2022 13:01:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00E9E4B5F6;
	Thu, 22 Sep 2022 13:01:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E19D4B092
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:01:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nhHtNdv9Vf13 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 13:01:57 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54F214B241
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:01:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D1B24636C8;
 Thu, 22 Sep 2022 17:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DBFC43143;
 Thu, 22 Sep 2022 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663866116;
 bh=pC2zxGScPJel5jBl7cmWJaYW0XKiTgMLlXCj7lrGY/E=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=jvcHSo09VGBIrzBbBM8is+vE5mxReBabuYHEIAIkqymDExD6WK/tfO7CtdLCXysxq
 K7LUisvZUSQxPb254/YdXY5ijxDXUdtlVWkB1TayVUqsiztcAME0Ci8Mz4qxvPKQYH
 cp/V2RzuXTIu7oLTiMtuE4rX8YqB3rf9/v3EmP01iRwHzrthBBi5fYm6+i9EyMx8BS
 yBAcyB93ZUvp6V44PbRaMoBODLuds/tO91c3zBh2GFqQSwxhWkvmbxGER0VxEfYqtt
 ROKVFeWjl3RNodYoPSRUn9ozNzseQaWMbJrwILS2Lc0LcysMFHGd5iaCINIksJfh+w
 4jt1IiaG+eK0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1obPaE-00Bxdo-Bs;
 Thu, 22 Sep 2022 18:01:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH 5/6] KVM: selftests: dirty-log: Upgrade
 dirty_gfn_set_collected() to store-release
Date: Thu, 22 Sep 2022 18:01:32 +0100
Message-Id: <20220922170133.2617189-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922170133.2617189-1-maz@kernel.org>
References: <20220922170133.2617189-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
 andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
 peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
 shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org
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

To make sure that all the writes to the log marking the entries
as being in need of reset are observed in order, use a
smp_store_release() when updating the log entry flags.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9c883c94d478..3d29f4bf4f9c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -17,6 +17,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/atomic.h>
+#include <asm/barrier.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -284,7 +285,7 @@ static inline bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
 
 static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
 {
-	gfn->flags = KVM_DIRTY_GFN_F_RESET;
+	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_RESET);
 }
 
 static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
