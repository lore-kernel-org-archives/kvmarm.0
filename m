Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3842CC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:42:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E32554B372;
	Thu, 19 May 2022 09:42:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nFz-ci5ATcSt; Thu, 19 May 2022 09:42:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D174B105;
	Thu, 19 May 2022 09:42:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B545E410FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fe9NQiVzAKeU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:42:50 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1F5B4B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:42:49 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 783DF6173E;
 Thu, 19 May 2022 13:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7076EC34117;
 Thu, 19 May 2022 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967768;
 bh=3z3t2BrkvfovB2h5pwI3p5yIYTZRtSIyBD74PPTs0Yw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=G96M87Oxdl/MhNzXxjemh8P8hD9d+d9tOTeB1WXdxsMsH/EX7wiqHwKlO5j4HVvMB
 wppa1c+r5WyEKdbCnTaUShA+X7bXIr9pA2c6YB91FBoyEpHaDekbZd8KYShe9IjrIg
 BEZZBNvs+EiDogN8GOQi0dblPZK60+tPLi7j3z7IaA3DbWMh7En4SWPK8B5anJsFV5
 krURr+mlbzyq44nBBAoo4S+S2XsRIt/yn0eJGgr5gSgsNm9uP6SuTVVPf14nOrnRdL
 XgRvIlCY06gv78RiJd88/i8CdBGh5f/ctqmlqy0lkb8PIHLvHrCs5AihtV08LBnJvV
 YUJHDdmCFdWbQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 06/89] KVM: arm64: Drop stale comment
Date: Thu, 19 May 2022 14:40:41 +0100
Message-Id: <20220519134204.5379-7-will@kernel.org>
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

From: Marc Zyngier <maz@kernel.org>

The layout of 'struct kvm_vcpu_arch' has evolved significantly since
the initial port of KVM/arm64, so remove the stale comment suggesting
that a prefix of the structure is used exclusively from assembly code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e3b25dc6c367..14ed7c7ad797 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -339,11 +339,6 @@ struct kvm_vcpu_arch {
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
 
-	/*
-	 * Anything that is not used directly from assembly code goes
-	 * here.
-	 */
-
 	/*
 	 * Guest registers we preserve during guest debugging.
 	 *
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
