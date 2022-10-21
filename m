Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1786AB5
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 23:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376D4C433C1;
	Fri, 21 Oct 2022 23:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666393438;
	bh=LurYdMzw6a4VobeqgwhnTYVNbwK2SHbtWLHnad9p53Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJMCxLbMQT1/AYHxtZwmGB5+9TXJgjtZnrUjYBTOSjfJNsVHze1Ephv8A8eIYtoI/
	 xRfwIhk2IM0IktlfVk7DUK28nrKnB3YavPouZib5virDxvIgEyVJZiyVcJ7/dZJ1YM
	 fF4mqvIF7jsENzEE2f2zSPAgymcw3sMxxzwUhz732Jo6xk+XhEVF/RLSs5/K7seNrv
	 asz/yIQDLCumhshLr1Fq0HXGezn1zhd9PNdAtxEL+ZVT4IcVavATmYYz2ErIB0Ypag
	 zJxKRS5MmCxJD8rPdx9dnPhtp2Jd3axyJovXUzK4G/xmlbSR0lakQ2TMC7glnVcQwi
	 U1uXsIsg5/l7w==
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
Subject: [PATCH v4 6/8] arm64/fpsimd: SME no longer requires SVE register state
Date: Sat, 22 Oct 2022 00:03:19 +0100
Message-Id: <20221021230321.1159287-7-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021230321.1159287-1-broonie@kernel.org>
References: <20221021230321.1159287-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1450; i=broonie@kernel.org; h=from:subject; bh=LurYdMzw6a4VobeqgwhnTYVNbwK2SHbtWLHnad9p53Y=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjUyU2bqNq9S5MzwdxmiyAT3/z7pjEp7btJ9tyTvpe vCxiwzaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1MlNgAKCRAk1otyXVSH0DwrB/ 9xHL+4sIOmJfscIdT5NZmbd7a7o9JMXdl672nHd5qNiwL7wW/5iUWIXj4fe9t2Q7vh3NEkedXCxM89 rgBJQMiiuteewdtOk9veCBsaDowsgKvgoi4Mg1oKfY+HXLEtO5mgMV2TwFL0kTWy9Y9sUgOSDm1okQ 1sqzd6bVdMGrVSFfwTgTMo3+iuNJq/udYx1i6Q7q+IIdDJ+fj00C+Ec/M7Y6mB7DkR4h0OQBgibJ5a NJde4WvQ8iFxnmkDjGa9THy5R715svpm0o5JFR2b+CLSELjUNKCl1CvdlvV9gLxRaoFt3VQZ/V5D+h qaO7cohhJTTwexj+l8r1j8Sh0GZVui
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

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
index 6544ecb297a5..73a540a3a11c 100644
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

