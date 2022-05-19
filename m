Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF85C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:43:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A8E4B383;
	Thu, 19 May 2022 09:43:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Tqw-nZqC2W7; Thu, 19 May 2022 09:43:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4134B392;
	Thu, 19 May 2022 09:43:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D58BC4B37F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rg8AEsZgyDPp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:43:22 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6D1E4B28F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:22 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id EDB2AB82477;
 Thu, 19 May 2022 13:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2A7C3411A;
 Thu, 19 May 2022 13:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967800;
 bh=nNZBdOA5NigbPc1M0gOv4ihVOwnmvSo9vvj+XEN8QEE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=j7NoBFU8bwOn6I+AuPUl7vI/GLMz9EE1gyvmRDAPQCAsqxaCXQgvzkWTxTMlEeU4b
 nKCxfCfk3UAb5Suzl20gX+EIh86HcGnn/OVC84fZm+c7yPrBTo3kkTEYMFXPqY6oFW
 Yrf5KPq7DWjcBRqtOYodbQ/2zfa6ms8Hj++BSXMMV18576Jr+Ka305u6AiCBu0sH6E
 q2B6ltG0V+vBJyh0Cgl3M7bU1BaqLxC1QbN+a9R5qehpeFQV1QOk8+LxfmURxMkP7T
 XI1N9IfmeI2Vjenox9AJWKR12NwgBNPZqsfx/CCNqX0/MBm6hSRr5GzRoWB0ObjjuD
 40tH47LOOXvkw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 14/89] KVM: arm64: Add hyp_spinlock_t static initializer
Date: Thu, 19 May 2022 14:40:49 +0100
Message-Id: <20220519134204.5379-15-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
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
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
