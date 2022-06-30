Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13F7C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jun 2022 13:58:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78DE14B0C2;
	Thu, 30 Jun 2022 09:58:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u395wnHTAjJa; Thu, 30 Jun 2022 09:58:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7410F4B431;
	Thu, 30 Jun 2022 09:58:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5B564B431
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1QRI2PO6r3jY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 09:58:40 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15DF94B4D6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:40 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 975FA6219B;
 Thu, 30 Jun 2022 13:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52EBC3411E;
 Thu, 30 Jun 2022 13:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656597519;
 bh=XHbnIjAE99mI8EWtHamyVofcSABl8SLt6G91nUjU0Wk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=djZ9rJLiTmkEkMgU8m3dAbaovV7dnjqgP4FHeesZI88oxKQfgmAJOCgOGPR5Ywfil
 5OWdnUQ6Jv/CSsZdRdmyXuwLIx2eIEmFr+m7SJp1Si8KEUGegKJqcFLEeNw/4he9FD
 PejgF/riPHzoi+Kjhaqg9Fy0LCPAhHM2QN9MQ7mIWkvsb11IYHBCeX44xqmIT8IrzQ
 hnjdXXFRK3PDct60/YW7T2mOzY/iZSly6GsVX5bvxWwXIOSAuXf9hgPKH4k7a3+tgq
 80xv7AzV68FN2E+ZYeSawtj8wOgd+HBodhTb1Q0wdcPnIa0B3E04vZiqfurX8hBtO0
 0va+VjQFycWYA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 11/24] KVM: arm64: Add hyp_spinlock_t static initializer
Date: Thu, 30 Jun 2022 14:57:34 +0100
Message-Id: <20220630135747.26983-12-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Having a static initializer for hyp_spinlock_t simplifies its
use when there isn't an initializing function.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
index 4652fd04bdbe..7c7ea8c55405 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -28,9 +28,17 @@ typedef union hyp_spinlock {
 	};
 } hyp_spinlock_t;
 
+#define __HYP_SPIN_LOCK_INITIALIZER \
+	{ .__val = 0 }
+
+#define __HYP_SPIN_LOCK_UNLOCKED \
+	((hyp_spinlock_t) __HYP_SPIN_LOCK_INITIALIZER)
+
+#define DEFINE_HYP_SPINLOCK(x)	hyp_spinlock_t x = __HYP_SPIN_LOCK_UNLOCKED
+
 #define hyp_spin_lock_init(l)						\
 do {									\
-	*(l) = (hyp_spinlock_t){ .__val = 0 };				\
+	*(l) = __HYP_SPIN_LOCK_UNLOCKED;				\
 } while (0)
 
 static inline void hyp_spin_lock(hyp_spinlock_t *lock)
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
