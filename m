Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE25C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:50:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BDAA4B322;
	Sat, 28 May 2022 07:50:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 56g-mogMoWCi; Sat, 28 May 2022 07:50:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D20524B35D;
	Sat, 28 May 2022 07:50:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 768E94B28F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 34zDK-VeDda7 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:50:07 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 791FF4B320
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:06 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6BBFFB816FE;
 Sat, 28 May 2022 11:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2088AC34118;
 Sat, 28 May 2022 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653738604;
 bh=KMwi+oCF55/vO8plIgUNFSEzhuYgMbACCUE98soIwB8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=T3hI8rfuQBsgLszaqhqU15iR8sD+Z2zDQM27dvaj32XX2yhaZztqlT4xRjLMiJ8Qa
 3/6YpzAeXwhtl2a7vx6Q/effM1FskrKMbYFpP1CCmjTbHWY8oQ1yKl8+WhYBFhcq8L
 +MJWCI7UweKTJ4bQ+IX3quF1bNxiP43mfy+SsgZpEiZvHnEmW4yJL625/VtTBwVJc3
 9aU/UfBkibE18T1Z0v/DjcM8Hb9j+wJLqw+gfD/voc4fZmIIeU9pcPRKLeYd9VwVkd
 B4fEX2XBEiSqwQ/PsgUwmSXy7O/+8rAn33kK6J/s10cmr6ZRH3hmtqEaC5Uqw2ZhyN
 BpIMfC7v0kTsQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuumD-00EEGh-Tr; Sat, 28 May 2022 12:38:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 18/18] KVM: arm64: Document why pause cannot be turned into a
 flag
Date: Sat, 28 May 2022 12:38:28 +0100
Message-Id: <20220528113829.1043361-19-maz@kernel.org>
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

It would be tempting to turn the 'pause' state into a flag.

However, this cannot easily be done as it is updated out of context,
while all the flags expect to only be updated from the vcpu thread.
Turning it into a flag would require to make all flag updates
atomic, which isn't necessary desireable.

Document this, and take this opportunity to move the field next
to the flag sets, filling a hole in the vcpu structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 83f3dae4333a..8c47b7f8ef92 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -344,6 +344,15 @@ struct kvm_vcpu_arch {
 	/* State flags, unused by the hypervisor code */
 	u8 sflags;
 
+	/*
+	 * Don't run the guest (internal implementation need).
+	 *
+	 * Contrary to the flags above, this is set/cleared outside of
+	 * a vcpu context, and thus cannot be mixed with the flags
+	 * themselves (or the flag accesses need to be made atomic).
+	 */
+	bool pause;
+
 	/*
 	 * We maintain more than a single set of debug registers to support
 	 * debugging the guest from the host and to maintain separate host and
@@ -397,9 +406,6 @@ struct kvm_vcpu_arch {
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
 
-	/* Don't run the guest (internal implementation need) */
-	bool pause;
-
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
