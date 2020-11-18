Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81811C56201
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 19:44:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDDF4246A7
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 19:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kruEVN08"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDDF4246A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 454D34B986;
	Wed, 18 Nov 2020 14:44:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cWAH98sEbaZQ; Wed, 18 Nov 2020 14:44:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24EF04B9BF;
	Wed, 18 Nov 2020 14:44:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BBDF4B7B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 14:44:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dKGko2aamnL2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2020 14:44:09 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66E4C4B935
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 14:44:09 -0500 (EST)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6F8DC246AE;
 Wed, 18 Nov 2020 19:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605728648;
 bh=iamdI0EMF+o/KWORUGRU1InqkIRnYdPNT5y6X7O7diI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=kruEVN08RYDR9t6/+q33w6cniohV+gmPPgtF6KlEJaid9lXi2QGIHyMCRGOK6UYV7
 u89A9yIDfgu4zUkA6AhusrBWRefp62vjPqSB5y87+WOAdsW/lSTUsPhxvvulVB6uq8
 9FtFUn5KA0fQe9NwkkFpWmMOTQqbWnu1kqXi737c=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	maz@kernel.org
Subject: [PATCH 1/3] KVM: arm64: Move 'struct kvm_arch_memory_slot' out of
 uapi/
Date: Wed, 18 Nov 2020 19:44:00 +0000
Message-Id: <20201118194402.2892-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201118194402.2892-1-will@kernel.org>
References: <20201118194402.2892-1-will@kernel.org>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

'struct kvm_arch_memory_slot' isn't part of the user ABI, so move it out
of the uapi/ headers in case we start using it in future and accidentally
back ourselves into a corner.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/include/uapi/asm/kvm.h | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0cd9f0f75c13..24cb00ce30dd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -89,6 +89,9 @@ struct kvm_s2_mmu {
 	struct kvm *kvm;
 };
 
+struct kvm_arch_memory_slot {
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1c17c3a24411..24223adae150 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -156,9 +156,6 @@ struct kvm_sync_regs {
 	__u64 device_irq_level;
 };
 
-struct kvm_arch_memory_slot {
-};
-
 /*
  * PMU filter structure. Describe a range of events with a particular
  * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
