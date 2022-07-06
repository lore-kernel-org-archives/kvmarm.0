Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FED4CCA47F
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 17:05:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AB854BE39;
	Wed,  6 Jul 2022 13:05:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6MlL638QcGSD; Wed,  6 Jul 2022 13:05:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DDA44BE4E;
	Wed,  6 Jul 2022 13:05:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 000144BEA0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 13:05:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 75q2yin13H0S for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 13:05:22 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDCB04BEA1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 13:05:22 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 699A561E7C;
 Wed,  6 Jul 2022 17:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FC3C3411C;
 Wed,  6 Jul 2022 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657127121;
 bh=R/yEgMh7z7fdGbMO2kbb8mcFadwBI9nk3leyMdDelqg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=eQsuGml4GQTZh7nxo9xQMXq7Jv8QdaLqKs//hUvgy3fMd1BFNKaHnLwmQZMskqroO
 ijNPvAaYPGWjgrdgQU2bcHzIdIZalWxLTRr+/beo9/OY/7x9xXSYCDmXOo1tPGJtQt
 2Fr/h+3NX3AteS28s/XGaS2csfZeBDniE8WksYZGSbe1PNLXBBl3Mt2iIdfhg2l43F
 UCLkgJkahmD8m+15A8h5wJrartCfZl+pEhIct/WytBT/jWCgmOq5mpMhje08V+AJzR
 LTCDJBCbOPwUPHIQ31Ua096wAy4F1X9c6+x3kVMHxR2/XUWVm5Yznq+435FdbEgiyb
 GU4E/9R7EyaVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o987O-005h9i-CS;
 Wed, 06 Jul 2022 17:43:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 17/19] KVM: arm64: Get rid of find_reg_by_id()
Date: Wed,  6 Jul 2022 17:43:02 +0100
Message-Id: <20220706164304.1582687-18-maz@kernel.org>
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

This helper doesn't have a user anymore, let's get rid of it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 11 -----------
 arch/arm64/kvm/sys_regs.h |  5 -----
 2 files changed, 16 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b66be9df7a02..d3ac0cd1c2e2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2577,17 +2577,6 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
 	}
 }
 
-const struct sys_reg_desc *find_reg_by_id(u64 id,
-					  struct sys_reg_params *params,
-					  const struct sys_reg_desc table[],
-					  unsigned int num)
-{
-	if (!index_to_params(id, params))
-		return NULL;
-
-	return find_reg(params, table, num);
-}
-
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num)
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index b8b576a2af2b..49517f58deb5 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -190,11 +190,6 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
-const struct sys_reg_desc *find_reg_by_id(u64 id,
-					  struct sys_reg_params *params,
-					  const struct sys_reg_desc table[],
-					  unsigned int num);
-
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
