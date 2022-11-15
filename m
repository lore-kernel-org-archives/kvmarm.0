Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974428ED
	for <kvmarm@lists.linux.dev>; Tue, 15 Nov 2022 09:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534C7C433B5;
	Tue, 15 Nov 2022 09:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668505685;
	bh=/V7Jxc6AB8Op857hwCL4QLQVcS/plHLASC1fjS3u6B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzmxSYFsLBkRcEAVuZ/GoIp/QL+uJCptx6ye1g94V8QYVLTSIlIdzv0lxwuQ3wlY6
	 VDURIrAHsZLCViYDPRdhI1Abej2SeHKj8E+3cZpKF73wjSSgBtyVZeMMe0PfA0jBuP
	 RYH9D09VJ+jVY/Nv14CaBuGTH6bNAf5FnXBC0WUolbBsR1eJ/L1QUfU+WjRvZtW9Fr
	 ICY3YtJRCmSksUG+sdxl/znxeSWMWB4NX5qcl3I+YE/xNePkWzf1QqS+MNG31IPpWu
	 GbNSlHav6/5t2TamvnqzS7MXMEXwy5oeXB/ozCeanp2LlvjhnK1G/9Yy/8V91YfHSA
	 P1IZRM5yNC9Sg==
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
Subject: [PATCH v5 7/8] arm64/sve: Leave SVE enabled on syscall if we don't context switch
Date: Tue, 15 Nov 2022 09:46:39 +0000
Message-Id: <20221115094640.112848-8-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115094640.112848-1-broonie@kernel.org>
References: <20221115094640.112848-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3803; i=broonie@kernel.org; h=from:subject; bh=/V7Jxc6AB8Op857hwCL4QLQVcS/plHLASC1fjS3u6B0=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjc1/+TmotjMo64NEIeLhVBfQl6TyNhZRv/XTkSTpB seoo5ZaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY3Nf/gAKCRAk1otyXVSH0I4uB/ sGa0j9HvONdl9AIN9o/uwnIo1uQGePnTJclnK8W98yL2Blz2CK9m8AL9P2adIQX1U/LSVwifjZc6cE 1G2iqgDgN2o1Gilz8WRI2bfSjtadp23ATH8KxknrHDHIWt0+g068PsoGm1kbljggM1iwsv/DbU76XJ +PwOEE+BGEu4BjrCHZ8tUpLCfJoIbv+XPoKaO45VqHLfiVgg9birF3IjFh0ynGIxsSppeMpakDyzEy RtOZi7yID8vgDwLsRXK1txAw1XpV85OBfnt7C2szZ0twMdrJssF+CE2VJ6a60wsL637uonfKs5N2Ep glaZkPpRLZUjJf58t/QqETkD+oWFpu
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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/fpsimd.c  |  8 +++++++-
 arch/arm64/kernel/syscall.c | 19 +++++--------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 7cb2d89ead83..a66b8640a0a4 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -481,7 +481,13 @@ static void fpsimd_save(void)
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
 		return;
 
-	if ((last->to_save == FP_STATE_CURRENT && test_thread_flag(TIF_SVE)) ||
+	/*
+	 * If a task is in a syscall the ABI allows us to only
+	 * preserve the state shared with FPSIMD so don't bother
+	 * saving the full SVE state in that case.
+	 */
+	if ((last->to_save == FP_STATE_CURRENT && test_thread_flag(TIF_SVE) &&
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

