Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97946C25B08
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 22:58:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 535F84D870;
	Mon, 15 Aug 2022 18:58:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NdzA1+6YFucj; Mon, 15 Aug 2022 18:58:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AD674D89F;
	Mon, 15 Aug 2022 18:58:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9A94D89F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h7qnzs2FRwLJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 18:58:27 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E90884D884
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8448B612D7;
 Mon, 15 Aug 2022 22:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17B5C433D7;
 Mon, 15 Aug 2022 22:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660604303;
 bh=uDCegzGXOGYpczHO7Ec5Pb6XL4/FQxD18k2p2ayhRbs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GSG6uMyUDTLj5lLs8vbbZoGApeTI559Id1TTj2rHGHokir6X6RYAeyA3DHe27lQkB
 nE7uhT7p/VNxRZ03cPevJrGO9uF1yY9h5fpxAVruPj9LyzCcuvqrbZfcLJWBNXRzJo
 ZiPPTueDN0iDshZ0I+TzWbEsvBOnTMvtJWOHwkW2ztNhFInM0pdUM34f89wgpuzo3B
 xB/ezAT5OAOUZkS4K81QZD+/xVoJgDJjpgWllvEEPrdFGv/zFeTRHbcX9/4nULGBhq
 zYbVMMywkyGTAP8kjNikeRJorBxyHjgm9IJ1MYmtDxTazA81Mg7mypv0IpOK+QPuew
 KxQ0ZNJlDy8rA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 7/7] arm64/sve: Leave SVE enabled on syscall if we don't
 context switch
Date: Mon, 15 Aug 2022 23:55:29 +0100
Message-Id: <20220815225529.930315-8-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815225529.930315-1-broonie@kernel.org>
References: <20220815225529.930315-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3722; i=broonie@kernel.org;
 h=from:subject; bh=uDCegzGXOGYpczHO7Ec5Pb6XL4/FQxD18k2p2ayhRbs=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBi+s7gceyWaznPJ0EQowjvWfeY/YMiA80SMqUa9tc5
 6jf6yEyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYvrO4AAKCRAk1otyXVSH0BKIB/
 9pdSMbY3xq3qMLhTMfmgLwQEMDylHXywqZGJUAgy2BtYVx2nX6/joeCugpuM11nRGf0g9z+dGpmp9U
 Ae+vtz99fQ6gaKPSNIYfLnMOl0KIVC1+jxcrVq5HABErQpQU2Uhv7eUvZAlW7u7dxxqGHmeHXacyFg
 KjOuu90ezDwfPgspKYLN4FnFXQcxhdo+O39C95OXClAcmDZe2K7odtOKcqxfBCiK0xaLIoo94c7uCU
 irXKydOaSbep+NVOnwlTrvEBC5aY1PQstTJ6zMXEYzRKF2lT/49UT8UZXL1vHSF1aHjwIYktciawia
 AIq8UQvEnRXDNGgF5RJyY+rbRzm8xy
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

The syscall ABI says that the SVE register state not shared with FPSIMD
may not be preserved on syscall, and this is the only mechanism we have
in the ABI to stop tracking the extra SVE state for a process. Currently
we do this unconditionally by means of disabling SVE for the process on
syscall, causing userspace to take a trap to EL1 if it uses SVE again.
These extra traps result in a noticeable overhead for using SVE instead
of FPSIMD in some workloads, especially for simple syscalls where we can
return directly to userspace and would not otherwise need to update the
floating point registers. Tests with fp-pidbench show an approximately
70% overhead on a range of implementations when SVE is in use - while
this is an extreme and entirely artificial benchmark it is clear that
there is some useful room for improvement here.

Now that we have the ability to track the decision about what to save
seprately to TIF_SVE we can improve things by leaving TIF_SVE enabled on
syscall but only saving the FPSIMD registers if we are in a syscall.
This means that if we need to restore the register state from memory
(eg, after a context switch or kernel mode NEON) we will drop TIF_SVE
and reenable traps for userspace but if we can just return to userspace
then traps will remain disabled.

Since our current implementation has the effect of zeroing all the SVE
register state not shared with FPSIMD on syscall we replace the
disabling of TIF_SVE with a flush of the non-shared register state, this
means that there is still some overhead for syscalls when SVE is in use
but it is much reduced.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c  |  8 +++++++-
 arch/arm64/kernel/syscall.c | 19 +++++--------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 46bc65b6bd81..8295acafe243 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -477,7 +477,13 @@ static void fpsimd_save(void)
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
 		return;
 
-	if ((last->to_save == FP_STATE_TASK && test_thread_flag(TIF_SVE)) ||
+	/*
+	 * If a task is in a syscall the ABI allows us to only
+	 * preserve the state shared with FPSIMD so don't bother
+	 * saving the full SVE state in that case.
+	 */
+	if ((last->to_save == FP_STATE_TASK && test_thread_flag(TIF_SVE) &&
+	     !in_syscall(current_pt_regs())) ||
 	    last->to_save == FP_STATE_SVE) {
 		save_sve_regs = true;
 		save_ffr = true;
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 733451fe7e41..69b4c06f2e39 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -183,21 +183,12 @@ static inline void fp_user_discard(void)
 	if (!system_supports_sve())
 		return;
 
-	/*
-	 * If SME is not active then disable SVE, the registers will
-	 * be cleared when userspace next attempts to access them and
-	 * we do not need to track the SVE register state until then.
-	 */
-	clear_thread_flag(TIF_SVE);
+	if (test_thread_flag(TIF_SVE)) {
+		unsigned int sve_vq_minus_one;
 
-	/*
-	 * task_fpsimd_load() won't be called to update CPACR_EL1 in
-	 * ret_to_user unless TIF_FOREIGN_FPSTATE is still set, which only
-	 * happens if a context switch or kernel_neon_begin() or context
-	 * modification (sigreturn, ptrace) intervenes.
-	 * So, ensure that CPACR_EL1 is already correct for the fast-path case.
-	 */
-	sve_user_disable();
+		sve_vq_minus_one = sve_vq_from_vl(task_get_sve_vl(current)) - 1;
+		sve_flush_live(true, sve_vq_minus_one);
+	}
 }
 
 void do_el0_svc(struct pt_regs *regs)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
