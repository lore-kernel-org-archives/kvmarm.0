Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB18D28ED
	for <kvmarm@lists.linux.dev>; Tue, 15 Nov 2022 09:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69D5C433C1;
	Tue, 15 Nov 2022 09:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668505680;
	bh=eQ0O5WXjRLl05MqXyfSpc2gcLWJvbsiqkITWbYuLTBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFtzJwscgNDsc1toIL9rDsfmw6KOjxCmqgyCxiKLocWTYHBsjSKz8X5b864yBX0ai
	 aq+lfSBMFWuZnsFqYuYn9FHu2yskIw2P3nhynXy1vtuolZ1oObD+2jJn3T0EjecS6/
	 oXdZ0LaFMsSIiw7/61Yhzm8WqCOFzO4vcDkLJuP5JXvbGDniGtX83hEK2eYPIgVfED
	 e5gIgxpF/BsxQ9y+F87LWyZwsQCIsIrBbZtteBx/mCwGbUOMw4ZCFjzYha8yWRjItm
	 MGGVSWRA38s4arqBf/6UUZ3GbfVPiqu+F0ZLSxtIclDonrt8GgNMLSGVmKZc+Tn7/a
	 UCoSLZlPOwgYg==
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
Subject: [PATCH v5 6/8] arm64/fpsimd: SME no longer requires SVE register state
Date: Tue, 15 Nov 2022 09:46:38 +0000
Message-Id: <20221115094640.112848-7-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115094640.112848-1-broonie@kernel.org>
References: <20221115094640.112848-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1504; i=broonie@kernel.org; h=from:subject; bh=eQ0O5WXjRLl05MqXyfSpc2gcLWJvbsiqkITWbYuLTBw=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjc1/+u92vsIp+vXa+WyqK2PTd8TTo+i8LL4JHm9xb HoT5SSaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY3Nf/gAKCRAk1otyXVSH0EbJB/ 9/xZPTY6t/NVZLFe3kzLVNscFxRvvPDBzo275T8Pd+UvhkV/Bo4WaGX1EVBdhYurYwcKdKKe5ZLoQX D/vk2DBRcaQkbItvP8POGUg9y0V2ELirgGFXQVOMTfDhE5KtLt+2ls56r7LxCDpiPIGpJS7hRPNdLQ /8yjNlE33gj5xI/k3nXw4gAoZEWYRcVnl1EIVi20oSS/m+4LsrwyEvDBgVGjOlDRSDa8Rd6qmTznei B2spKxbjwrlrQ4Mdcv2O27z8ufgstMKKHJdFLb0nIOeVj1uzsp+tH9DXoiuqqHrx67wKlbra4tyFkj x0UhPujvPDbt8m2xkHTDihc4fd2wXp
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Now that we track the type of the stored register state separately to
what is active in the task, it is valid to have the FPSIMD register
state stored while in streaming mode. Remove the special case handling
for SME when setting FPSIMD register state.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 3 +--
 arch/arm64/kernel/ptrace.c | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index eb42b00dce54..7cb2d89ead83 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -815,8 +815,7 @@ void fpsimd_sync_to_sve(struct task_struct *task)
  */
 void sve_sync_to_fpsimd(struct task_struct *task)
 {
-	if (test_tsk_thread_flag(task, TIF_SVE) ||
-	    thread_sm_enabled(&task->thread))
+	if (task->thread.fp_type == FP_STATE_SVE)
 		sve_to_fpsimd(task);
 }
 
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 8a7c91791c16..979dbdc36d52 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -907,8 +907,6 @@ static int sve_set_common(struct task_struct *target,
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

