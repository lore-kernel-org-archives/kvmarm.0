Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E22C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:42:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 428754B28D;
	Thu, 19 May 2022 09:42:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t1xqqR4O7GdH; Thu, 19 May 2022 09:42:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36C484B36D;
	Thu, 19 May 2022 09:42:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2CC84B374
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hcHPSAnw01mm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:42:33 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF53B4B33C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 45CE26176B;
 Thu, 19 May 2022 13:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389CEC34117;
 Thu, 19 May 2022 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967752;
 bh=mMTpj6Xf/moTi8ciNje9mfw0SiHtqrhrJpD/i+TIPXM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=E3l6TybAXqwnFz+PuQUJNPYnXdGaGAa/sINGfllzMjmJ9fmoxX60ta2V6T8T5wAXS
 r0TxsBQbV/p1EQXXAMwz5JHFLvJYywVGR3B/6xd92EYJGRjKAbmxvUu8EWey52622A
 IEKimIrbD9LJaQjtsazUZvwfYw5xCi6+cGqJK2dABHIo57bynSetnVWHVsoB41W8Du
 LiWHiXR1/MtGUum1ISCJbEMgkYDtLsJJHcYP7vk4UyY1Vavri18c1+18acC8dq1DWh
 /3wLJExnd7ks7/gDNefTSpFTXJf1T4IRTHys6br0PyC983WymUXbK8x6WulJ7gKyxq
 LsN8wRpQQrx1A==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 02/89] KVM: arm64: Remove redundant hyp_assert_lock_held()
 assertions
Date: Thu, 19 May 2022 14:40:37 +0100
Message-Id: <20220519134204.5379-3-will@kernel.org>
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

host_stage2_try() asserts that the KVM host lock is held, so there's no
need to duplicate the assertion in its wrappers.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 78edf077fa3b..1e78acf9662e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -314,15 +314,11 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
 			     enum kvm_pgtable_prot prot)
 {
-	hyp_assert_lock_held(&host_kvm.lock);
-
 	return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
 }
 
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 {
-	hyp_assert_lock_held(&host_kvm.lock);
-
 	return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
 			       addr, size, &host_s2_pool, owner_id);
 }
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
