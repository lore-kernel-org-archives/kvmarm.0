Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154D6C00140
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 22:58:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C8C4D87A;
	Mon, 15 Aug 2022 18:58:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VjW52tbOpyoC; Mon, 15 Aug 2022 18:58:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E77CE4D8C2;
	Mon, 15 Aug 2022 18:58:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DB154D87A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zb-iixz+PBZn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 18:58:22 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B0C54D8A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:22 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 80F1F612E4;
 Mon, 15 Aug 2022 22:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D141C43150;
 Mon, 15 Aug 2022 22:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660604301;
 bh=fh/o88Q1u98u8rocOLB0zArepmlTdKv67Fv90R3R2Yk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SA0VE3vTnf2j26eUoP0hb5dFVvOfv1bSL0a65M/f6JLDeAoyPBkkYAt/1lb1EQEBG
 xJkeRf2G2fWOcl/OpZ36PImYw5h9QfWZdBxwVyze+lbMvNW+Vmr/4Zs2DprG/tKxxt
 vBOxNPTNCXYzR/7ZJZ/VpJC/GITOebDrM4ESWKs339g0pBqWob9s+jaHirblOFhi4y
 XPXt/uNtZVvojJm/LJR1XCmTWTHCH7+KG4Sr6GMRMo/bqkQecbMTqYe0ahESqIv3tp
 ACI8TaZf0rnfHvMVEHWLCE9JLe47/6ifCX9E4gwiA2nzhj7u7nEGcjOxgpvlVY9nZV
 uS6swuf9sxWUQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 6/7] arm64/fpsimd: SME no longer requires SVE register state
Date: Mon, 15 Aug 2022 23:55:28 +0100
Message-Id: <20220815225529.930315-7-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815225529.930315-1-broonie@kernel.org>
References: <20220815225529.930315-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1450; i=broonie@kernel.org;
 h=from:subject; bh=fh/o88Q1u98u8rocOLB0zArepmlTdKv67Fv90R3R2Yk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBi+s7fTdXX1rQrXyyng1h5ypLdXqCss5zeKE/Q4gHB
 l5X72SKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYvrO3wAKCRAk1otyXVSH0I5nB/
 9Qd9+lWEpE+o3aO2XkYmx6KcC+kr7GTrIzZVl9EGg4NAMJWgslX4rtVqCDYUvi9dgH+rM+/1nzHrRJ
 fQo4Pno0KwFNwe9a5BslTq5iBcDj+AjsX0UJ/JDg6HEj0ybE7FNSAwEVTTo7buNY7JPz0RDAhUhlDW
 RLjhuw+rVk/JR6hUV6LlGRfzr3iXBy1nyzxUbcGs0BmqcccuFy0Gk9tZmWkEAzSYiqH+cpvKCKS4Q4
 wrwE5zfiIbon1Wkdsr210DtXDtJoc4gdmyzjszcylvl4C2qrgfz3uIsTbv4rzPFBkkUuCmAk0HyGAt
 BY4lIrWzGxao7DElvIZcvZeIQhRljz
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Marc Zyngier <maz@kernel.org>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Mark Brown <broonie@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Now that we track the type of register state stored separately to
tracking what is active in the task it is valid to have FPSIMD register
state stored while in streaming mode so remove the special case handling
for SME when setting FPSIMD register state.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 3 +--
 arch/arm64/kernel/ptrace.c | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 4096530dd4c6..46bc65b6bd81 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -811,8 +811,7 @@ void fpsimd_sync_to_sve(struct task_struct *task)
  */
 void sve_sync_to_fpsimd(struct task_struct *task)
 {
-	if (test_tsk_thread_flag(task, TIF_SVE) ||
-	    thread_sm_enabled(&task->thread))
+	if (task->thread.fp_type == FP_STATE_SVE)
 		sve_to_fpsimd(task);
 }
 
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index fb6189bc45c9..2f479b7611fe 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -892,8 +892,6 @@ static int sve_set_common(struct task_struct *target,
 		ret = __fpr_set(target, regset, pos, count, kbuf, ubuf,
 				SVE_PT_FPSIMD_OFFSET);
 		clear_tsk_thread_flag(target, TIF_SVE);
-		if (type == ARM64_VEC_SME)
-			fpsimd_force_sync_to_sve(target);
 		target->thread.fp_type = FP_STATE_FPSIMD;
 		goto out;
 	}
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
