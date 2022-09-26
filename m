Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09C3C32771
	for <kvmarm@archiver.kernel.org>; Mon, 26 Sep 2022 14:51:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3270A4B832;
	Mon, 26 Sep 2022 10:51:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hBok1PYn5htZ; Mon, 26 Sep 2022 10:51:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F0884B7F0;
	Mon, 26 Sep 2022 10:51:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEC174B638
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 10:51:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YuaX9IvesYOc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 10:51:29 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D32EC4B7CF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 10:51:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E8B01B80ACC;
 Mon, 26 Sep 2022 14:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9DEC43148;
 Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664203886;
 bh=WV5cxf5ghEnKU2Qr6KhozOGjAzkOIr41eedwlY0TKqw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=eIQck6//OBW+W1dywe0DknHum0rdmkdVAw4UgRVkCmCDEIdmX45GE0xpJyCygUGTP
 WlK7j873Xpn4lCec1VPZDjlQnu6piSbyDiXcY2CfFFGCGNeRIDzy10/4Hf3/3uMjSS
 IJYbT1xOcIMTv539YJ4ReXurJiV2TBeyZktZw8KsUjo54yc0/yzKAHAvAnFsQcvFdn
 VuBf1GPs91dXUCofN4W8M2DTD9yleuYT2uEb6Thd0mji7F+hAhmJLAYpaud2qDHu/5
 mAjV2SPztiS6ouhp/avwTmKB9kKTN3VPLDb9e0iurCs2M1/pI3Fve6joLNmqiwNqJM
 oAXkzq5lVixfQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ocpS8-00Cips-FQ;
 Mon, 26 Sep 2022 15:51:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH v2 5/6] KVM: selftests: dirty-log: Upgrade flag accesses to
 acquire/release semantics
Date: Mon, 26 Sep 2022 15:51:19 +0100
Message-Id: <20220926145120.27974-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
References: <20220926145120.27974-1-maz@kernel.org>
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

In order to preserve ordering, make sure that the flag accesses
in the dirty log are done using acquire/release accessors.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9c883c94d478..53627add8a7c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -17,6 +17,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/atomic.h>
+#include <asm/barrier.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -279,12 +280,12 @@ static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 
 static inline bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
 {
-	return gfn->flags == KVM_DIRTY_GFN_F_DIRTY;
+	return smp_load_acquire(&gfn->flags) == KVM_DIRTY_GFN_F_DIRTY;
 }
 
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
