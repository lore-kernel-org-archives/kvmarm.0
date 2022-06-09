Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417B9C43334
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 12:12:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0F684B3BC;
	Thu,  9 Jun 2022 08:12:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Ccm-CnfUrC9; Thu,  9 Jun 2022 08:12:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 099D74B3A3;
	Thu,  9 Jun 2022 08:12:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C6FD4B374
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Km2DPvH3tRYq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 08:12:41 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28B4B4B397
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:41 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3C932B82D50;
 Thu,  9 Jun 2022 12:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBF6C341C5;
 Thu,  9 Jun 2022 12:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654776758;
 bh=LxU7fuaFrS1upsAZVNVrFcaeQoyaqGRLJQVCKcd3y+s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=U5n1sSbwe0oLqa3cOclRUTXArFmRJtXkXrJmqo/VgrWVoAMWqYjuyUgtLp/n5xvLj
 LrC58s2W2bHB2/ppdYJAcK3JNUUrbvZEsQ02hWlguWN1DJs38289D5YYT7F6hT1rgd
 oOKSkRfF1QyafkJIS+kha+HDXAEJr7peKooKzkgAqgHrdR/34KO6lzf94bHJeRpTZB
 N1Shkhh3LxvspdO3qHrTPeWeyH7/k8Qo46Sth/sXo3Ps3fS6WfGyb36HAohVTaangO
 TP6P3M9DPVUWFBAeCTQJCi//j/S6N8Nw66z0sErntOXFsYKdLFkctcbuTRXW04OQe7
 8S5TDjqcf5bzQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 5/6] KVM: arm64: Remove redundant hyp_assert_lock_held()
 assertions
Date: Thu,  9 Jun 2022 13:12:22 +0100
Message-Id: <20220609121223.2551-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220609121223.2551-1-will@kernel.org>
References: <20220609121223.2551-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
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
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
