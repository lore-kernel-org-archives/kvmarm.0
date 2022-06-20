Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA3EC43334
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 12:42:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C734B4FE;
	Mon, 20 Jun 2022 08:42:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vSVrD1ztWmH9; Mon, 20 Jun 2022 08:42:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C1314B309;
	Mon, 20 Jun 2022 08:42:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5BA34B2E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xL8X3oY5gSg3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 08:42:33 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59F364B282
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 94331B81154;
 Mon, 20 Jun 2022 12:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46718C3411B;
 Mon, 20 Jun 2022 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655728951;
 bh=cPrvpriWJsChNP82KsFji0zbKl3vf2f0kdEk7PRVSe0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=dL9tTb6t+QyBl48TC40x/rqH0lucjl0mv32UI1imV4battG8qMU4j9Rj9Tl4JQagm
 xOBSUD1D5NXfRqLs06Jn1Ejd1qeb9wZkZhg9RVZwMcD7hR/+dWxKEHuxSMTFp2RgRW
 gH2MO3/WyCH5QZ8KBMgf454iEGmaYZWhZVdNDMnqYidai3vHBO8ckaMAq7cG4kL1Wi
 eay7TDux4wc3G0gf/sU89s4H2zoS/ttC2NqwbxxuXBU0ORWCOhDJXFNst8xwDdV7mN
 oUy3aoO+TzDBgDyk8IPmIEriqEBfd0tnoxiTXATMfx9u1ffTo5b2wcigu1mAjE085f
 L/nDq0ecNfd3g==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 6/7] arm64/sve: Leave SVE enabled on syscall if we don't
 context switch
Date: Mon, 20 Jun 2022 13:41:57 +0100
Message-Id: <20220620124158.482039-7-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620124158.482039-1-broonie@kernel.org>
References: <20220620124158.482039-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3722; h=from:subject;
 bh=cPrvpriWJsChNP82KsFji0zbKl3vf2f0kdEk7PRVSe0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBisGsSqgpNBuUmVPgNW6fdcQ1mkeXzfECCDUFb78xS
 K/sfEweJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYrBrEgAKCRAk1otyXVSH0ERAB/
 9VACTUOs+mEtt+jrsLg/JEA3F5UfQKEsjPSedSeUfjSdvunDaPYpVviffQlg4dPDu9xN5Fly0MmfjF
 rXuadCbjFhKa+H9r+2ZL1lz3l5P1EHgRbRpVAaJj/nnMRq9Opi+fKklCxK30dvC3kmstIeUHqUR3Sz
 MXOpw3kH24apMdD6CnEe2HDTvkNuTgDUMWNlpL8TXgvbjUaPobvuFeFMwjbvwYPRlCldMfiDU+Qyry
 2OdvfQKXiSGVvwT1BhYMEHIw4P5qy3B+zkyshe/ujI6ha+1aXkjZDVdSnqEiuFe7nAr8VobQkKFBU1
 bhME8u3vPLJHxk8u3fpRsB1MRdb+v/
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
index f14452b7a629..5ec13c8bf98b 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -480,7 +480,13 @@ static void fpsimd_save(void)
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
