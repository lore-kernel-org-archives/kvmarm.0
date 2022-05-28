Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35534C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:50:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE3CD4B346;
	Sat, 28 May 2022 07:50:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2YFSSpDowimK; Sat, 28 May 2022 07:50:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B47864B320;
	Sat, 28 May 2022 07:50:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EA334B338
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BCcqjmjsaY8u for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:50:08 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC97C4B322
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:07 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7BCCB60E0A;
 Sat, 28 May 2022 11:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3F4C34100;
 Sat, 28 May 2022 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653738606;
 bh=Ec6u8EQqS5wxvthn3XSyusPvGBwQrVTlwCZ9oXTDvkU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=E0p5wup+2w0opbr/dlcTkosvR5+j8BDyV0JtjQ4fc85x+bvP4gUGl8+a7glZlvrcK
 zaEmLDWKyTWtq73TSRlc4UKwgWef6+0pndxbzzDM9SrEPgbEdB967pz2DnTm5JNczL
 PP6BfPj3CdY63np6MUH61stttsxbuaUOfKsYIAf5ifpiWoGz16c6GZKOzXQ5EHctH+
 q1ujLSo9S4M5rhAw45Y55ZYkS5/bn/dEpYciFq0GjM5fz7R0qrMcR24bAgpLOQQNUM
 GWEDnrDsBK7xfU00/1FZ7prBwYe38yd5Sh40sZCdZkc3C4+ehXZ6AeAccWQCZlF0Q/
 WBPHs06b4ejkg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuumC-00EEGh-Jj; Sat, 28 May 2022 12:38:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 13/18] KVM: arm64: Kill unused vcpu flags field
Date: Sat, 28 May 2022 12:38:23 +0100
Message-Id: <20220528113829.1043361-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
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

Horray, we have now sorted all the preexisting flags, and the
'flags' field is now unused. Get rid of it while nobody is
looking.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fe7e1c44e6e9..d571c9991a11 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -335,9 +335,6 @@ struct kvm_vcpu_arch {
 		FP_STATE_DIRTY_GUEST,
 	} fp_state;
 
-	/* Miscellaneous vcpu state flags */
-	u64 flags;
-
 	/* Configuration flags */
 	u64 cflags;
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
