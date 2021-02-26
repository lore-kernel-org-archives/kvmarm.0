Return-Path: <SRS0=LqQy=H4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B8EC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 26 Feb 2021 18:13:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E5F864F1B
	for <kvmarm@archiver.kernel.org>; Fri, 26 Feb 2021 18:13:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E5F864F1B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E04B34B0EC;
	Fri, 26 Feb 2021 13:12:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e70qDMpZEFId; Fri, 26 Feb 2021 13:12:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F089F4B308;
	Fri, 26 Feb 2021 13:12:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EE784B2E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2021 13:12:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1HZVI2tBpiVV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2021 13:12:55 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43C3A4B190
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2021 13:12:55 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7B7B64E85;
 Fri, 26 Feb 2021 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614363173;
 bh=nAk4WrgY8B1ZZvvFfv8YJ7MnbT4maSdfShrZmvw4D64=;
 h=From:To:Cc:Subject:Date:From;
 b=oRVWGsLXznLVXC6SDWZGUxWKLSP5iTK6CsaJ6BXqEDc/NllJ8K40KI/TxRQPsinkB
 3+JjvMXwYe5xM4nRSRWg92AmWm6FkR0+QPL2cg1ehaH8LO+Dj6wBBh2NnGuTMXQHC/
 6+MJJJUtJlKOsnwgcW1TqZ5EUg6n4PfpmJzMTkhiibEoxkK81AC38RSDSpwzAoHk3m
 aNWV4oY0kKviXBM1bFZMclEl1ZkvB81TLxFmmkIVjZGVg65UOOXyNkE/JlciG9/iRX
 2b8PB8XAbpGkod0dKqAlwP5tHrnaJjQpZBLA5OL2aJjM2B58Wc+Woxwu8g7wBf5ksk
 IKha1ce9e8GVQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	maz@kernel.org
Subject: [PATCH] KVM: arm64: Avoid corrupting vCPU context register in guest
 exit
Date: Fri, 26 Feb 2021 18:12:11 +0000
Message-Id: <20210226181211.14542-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kernel-team@android.com, stable@vger.kernel.org,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Commit 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest
context") tracks the currently running vCPU, clearing the pointer to
NULL on exit from a guest.

Unfortunately, the use of 'set_loaded_vcpu' clobbers x1 to point at the
kvm_hyp_ctxt instead of the vCPU context, causing the subsequent RAS
code to go off into the weeds when it saves the DISR assuming that the
CPU context is embedded in a struct vCPU.

Leave x1 alone and use x3 as a temporary register instead when clearing
the vCPU on the guest exit path.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Andrew Scull <ascull@google.com>
Cc: <stable@vger.kernel.org>
Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest context")
Suggested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---

This was pretty awful to debug!

 arch/arm64/kvm/hyp/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index b0afad7a99c6..0c66a1d408fd 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -146,7 +146,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Now restore the hyp regs
 	restore_callee_saved_regs x2
 
-	set_loaded_vcpu xzr, x1, x2
+	set_loaded_vcpu xzr, x2, x3
 
 alternative_if ARM64_HAS_RAS_EXTN
 	// If we have the RAS extensions we can consume a pending error
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
