Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A900CCA47F
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 17:05:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5D2B4BEB4;
	Wed,  6 Jul 2022 13:05:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n3VCdUqkFADd; Wed,  6 Jul 2022 13:05:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8CCC4BE5F;
	Wed,  6 Jul 2022 13:05:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E6114BE4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 13:05:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QeAIExL5Tp0f for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 13:05:34 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F40E94BEAC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 13:05:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 081AFB81DA3;
 Wed,  6 Jul 2022 17:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2827C341C8;
 Wed,  6 Jul 2022 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657127131;
 bh=Eo9E4Nefyu/Kf+UJWebrylD0pKTMwvYjQaj9htsyQe8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hRmbHljJgJEVO+HqXEZGu487VsQfX7AGbih8FpxCRrSwrg7J7LdtqXQ12Nj6Bqn5B
 JAgziUhqyGutnTWVUmiO3iabG2VYhs/thU4Y5c2/ygtMPxCLszjYUtuCOc023yyE9W
 uExYCn0F293j4jmXKO6y1GtqOG7IJ8gGC+VDvmRjNbYAOUwwvy6YA4OBURZ9KFDaah
 A6sBEJjjORU6+FdQUnv6IQTNHhokEvC7whp/NN7wZIXO8mtCt6TrmcZZEHZsTKm0Nq
 l6b4HDvElmb9IxjZ2HVCQaKBVhvq5W3dBMFDHafYpg3OnPlr4W3nluL7yG9BxtOBAt
 alINKA+9NKIOw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o987O-005h9i-Oa;
 Wed, 06 Jul 2022 17:43:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 19/19] KVM: arm64: Get rid or outdated comments
Date: Wed,  6 Jul 2022 17:43:04 +0100
Message-Id: <20220706164304.1582687-20-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706164304.1582687-1-maz@kernel.org>
References: <20220706164304.1582687-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
 Oliver Upton <oliver.upton@linux.dev>
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

Once apon a time, the 32bit KVM/arm port was the reference, while
the arm64 version was the new kid on the block, without a clear
future... This was a long time ago.

"The times, they are a-changing."

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d3ac0cd1c2e2..8dc93d372d4f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -34,11 +34,6 @@
 #include "trace.h"
 
 /*
- * All of this file is extremely similar to the ARM coproc.c, but the
- * types are different. My gut feeling is that it should be pretty
- * easy to merge, but that would be an ABI breakage -- again. VFP
- * would also need to be abstracted.
- *
  * For AArch32, we only take care of what is being trapped. Anything
  * that has to do with init and userspace access has to go via the
  * 64bit interface.
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
