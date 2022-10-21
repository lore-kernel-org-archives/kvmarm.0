Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E7F6AB5
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 23:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D183EC4347C;
	Fri, 21 Oct 2022 23:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666393441;
	bh=QFvyOjkeh6ipn1VD0G0dSkfz082NEPa+y5SeFW1VTTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+ww2BHwC/q6mbDbt3u1/7UBnam78dALUb17pKi+vC6iFC9biLzMpgvpxl0B2DPmR
	 NXkS2pfmlP4/dmAEd2nThK6kxzUpqmdU4vviyuNEepvtsWrIJAGGIddgUMA+VdQIE6
	 lgjNJNTrvCW9h49C6LK2nZpIVfQbdhWrCfSX+xf9ZpiaoINL8ff8jZdTwGrZXiLkh9
	 Nf6ONK7qLjar319LlG1FzdkJJIvWDLr1sZbKoXXjWe0GfwmpdfMpZKKC/Lr+dqvKkp
	 HP0E7AIhOc7WLbuS/jXM7XPk+SLNS7/fOa8QPH06wP4fF95jZAJiELIA0S2wpP1J7S
	 wc2dpqNFJUD7w==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 7/8] arm64/sve: Leave SVE enabled on syscall if we don't context switch
Date: Sat, 22 Oct 2022 00:03:20 +0100
Message-Id: <20221021230321.1159287-8-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021230321.1159287-1-broonie@kernel.org>
References: <20221021230321.1159287-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3741; i=broonie@kernel.org; h=from:subject; bh=QFvyOjkeh6ipn1VD0G0dSkfz082NEPa+y5SeFW1VTTE=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjUyU3KiJK8cMpH03UJ2L/+KMPPtCFV2U+0Ii3n2RX eWemjY+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1MlNwAKCRAk1otyXVSH0M5jB/ 0d4hhkruSnqyOGjBkGf0b0qgYoRk2DlNridXGCUv+cmURmv/xrY5aBxsfLlSYrAnb4z1Sl0XfCHP45 rddSRrerPO+o73cPNmCBtwC57Nnot9v/y/99HATaAgwqO835hijpt7H+CcWOJLvnh2bSZUvd4Ks04O RW7v8Dph5IMbZWhaDYGESngqz0R2HOm+2wt/Qc9ViAe9r/yZA/NOxu0D33Qo60qGCN09TYDqRpagM6 QXxyLFGI4Qj48GsPsPS+3WJIf104K2XHWFREqfh2rnt6oRnxhjQz7ydATpQdYaCB3MV5c6VXRKvtLe lOS/+rrTE7LqRPsepQl74IPjYBl9KP
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

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

Since our current implementation and hence ABI has the effect of zeroing
all the SVE register state not shared with FPSIMD on syscall we replace
the disabling of TIF_SVE with a flush of the non-shared register state,
this means that there is still some overhead for syscalls when SVE is in
use but it is very much reduced.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c  |  8 +++++++-
 arch/arm64/kernel/syscall.c | 19 +++++--------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 73a540a3a11c..984ea997e7ca 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -481,7 +481,13 @@ static void fpsimd_save(void)
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
index d72e8f23422d..a5de47e3df2b 100644
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

