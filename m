Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2808CCA47B
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:35:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E3984C592;
	Thu, 14 Jul 2022 11:35:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rWZE4p2d8xtO; Thu, 14 Jul 2022 11:35:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31FB44C54F;
	Thu, 14 Jul 2022 11:35:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13CBF4C5B9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l9algyLIndEA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:35:34 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8F974C5F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6550761F20;
 Thu, 14 Jul 2022 15:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32182C3411C;
 Thu, 14 Jul 2022 15:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812933;
 bh=cjEJJ+tICPXcomBqvfwVOb8VeczOy4va3hJvn5AgE1E=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=S7yEei5g2NQKRLAboRSC5hlT9zP8nF8cCAQ7RDl/+9HlnGBJEA2Qk5XUljJRJynf6
 yCmNOw7laNWrVNZo/0zaGtqROxAHYOXWw4Z9DMCBqMj12uPEB0XZ89TI8ci3smUKF0
 rCrbDNoiX3btCpBwfdMPBkGSfE0t42D3YqQnLeXtseUXRrf86l9gwkOLP3045n5N5b
 s3gxUD8I8ShENVEHIAl23m8SDZr5Vl0gNTF1qFQoXRRzL30ouEqUlOhJPd8dp6Hy/G
 sJSQzDGz7dim4LrHtPAwAlWzghsCDb6XcBbLdLoaRLeSu06jy1lVGSDFGtgbsw4Lee
 CMi0HSymIoB7Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0dl-007UVL-C2;
 Thu, 14 Jul 2022 16:20:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 20/20] KVM: arm64: Get rid or outdated comments
Date: Thu, 14 Jul 2022 16:20:24 +0100
Message-Id: <20220714152024.1673368-21-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com, schspa@gmail.com, kernel-team@android.com
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
index 7ab67a7fc0d8..b4fda04413f2 100644
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
