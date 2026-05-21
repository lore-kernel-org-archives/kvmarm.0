Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41193C278B
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369978; cv=none; b=Aj8P/Y05EBucKaEmGfRB8n5HpGa68hxPdefh23UEPajHFPw/coHzdGzepiYgcacnd3pMJrQr6xAEBNbPnu/rkv5SYl97nOr5X0YnrrBepbwGZe6hI/w2EDG+nIsTd0bJTlGczQF3EqoqLoVO26mzCnup59t9dAoODMw0eLGyMDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369978; c=relaxed/simple;
	bh=KAaJ8ubZ1yhRgalDMlaHua1Q6wEIKyks/A63NqAloAc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M4O4Nxh3L2Rzzg5BiWkQVkRoYO6Wk2G84xayTVOy2zfyjWpiJ+vFmUcPomsXZTuO9RrY4GFismB08/1nvR7XVlIZoWSEiJLRzoHSMz4FAVRw/mO0l21xL8VLHXHc6jzLX6I6WLks9EBY+BCzJopPH9dOWfdCOCkEozGM0/u0nA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h7jwCCy3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h7jwCCy3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D4E11C00;
	Thu, 21 May 2026 06:26:11 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D4E403F7B4;
	Thu, 21 May 2026 06:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779369976; bh=KAaJ8ubZ1yhRgalDMlaHua1Q6wEIKyks/A63NqAloAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7jwCCy3evj1t9qF9bkcUgq/3wQMKJo1z6hVbHToj7tFsaF9kvjELbeqlEfgE5TVx
	 vBgDkErcyqIRw9ZMjFXVhmYlXGxohk9+lklGmxcpBsbH0A8e4OfLoMkQO/1PxRrCxI
	 bhI2X/5OOHl+wwf0UhR7Zjl3FW/M7Z6E4LgLNWhk=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 05/18] arm64: fpsimd: Fold sve_init_regs() into do_sve_acc()
Date: Thu, 21 May 2026 14:25:43 +0100
Message-Id: <20260521132556.584676-6-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260521132556.584676-1-mark.rutland@arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For historical reasons, do_sve_acc() is structurally different from
do_sme_acc(), and the logic to convert the task from FPSIMD to SVE is
out-of-line in sve_init_regs(). We only use sve_init_regs() within
do_sme_acc(), so it's not necessary for this to be a separate function.

Fold sve_init_regs() into do_sve_acc(), and simplify the associated
comments. This makes do_sve_acc() structurally similar to do_sme_acc(),
making it easier to see similarities and differences.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 48 ++++++++++++++------------------------
 1 file changed, 17 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 60a45d600b460..a8395cb303344 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1293,31 +1293,6 @@ void sme_suspend_exit(void)
 
 #endif /* CONFIG_ARM64_SME */
 
-static void sve_init_regs(void)
-{
-	/*
-	 * Convert the FPSIMD state to SVE, zeroing all the state that
-	 * is not shared with FPSIMD. If (as is likely) the current
-	 * state is live in the registers then do this there and
-	 * update our metadata for the current task including
-	 * disabling the trap, otherwise update our in-memory copy.
-	 * We are guaranteed to not be in streaming mode, we can only
-	 * take a SVE trap when not in streaming mode and we can't be
-	 * in streaming mode when taking a SME trap.
-	 */
-	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
-		unsigned long vq_minus_one =
-			sve_vq_from_vl(task_get_sve_vl(current)) - 1;
-		sve_set_vq(vq_minus_one);
-		sve_flush_live(true, vq_minus_one);
-		fpsimd_bind_task_to_cpu();
-	} else {
-		fpsimd_to_sve(current);
-		current->thread.fp_type = FP_STATE_SVE;
-		fpsimd_flush_task_state(current);
-	}
-}
-
 /*
  * Trapped SVE access
  *
@@ -1349,13 +1324,24 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
 		WARN_ON(1); /* SVE access shouldn't have trapped */
 
 	/*
-	 * Even if the task can have used streaming mode we can only
-	 * generate SVE access traps in normal SVE mode and
-	 * transitioning out of streaming mode may discard any
-	 * streaming mode state.  Always clear the high bits to avoid
-	 * any potential errors tracking what is properly initialised.
+	 * Convert the FPSIMD state to SVE. Stale SVE state can be present in
+	 * registers or memory, so we must zero all state that is not shared
+	 * with FPSIMD.
+	 *
+	 * SVE traps cannot be taken from streaming mode, so there cannot be
+	 * any effective streaming mode SVE state.
 	 */
-	sve_init_regs();
+	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
+		unsigned long vq_minus_one =
+			sve_vq_from_vl(task_get_sve_vl(current)) - 1;
+		sve_set_vq(vq_minus_one);
+		sve_flush_live(true, vq_minus_one);
+		fpsimd_bind_task_to_cpu();
+	} else {
+		fpsimd_to_sve(current);
+		current->thread.fp_type = FP_STATE_SVE;
+		fpsimd_flush_task_state(current);
+	}
 
 	put_cpu_fpsimd_context();
 }
-- 
2.30.2

