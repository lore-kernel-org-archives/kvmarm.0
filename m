Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C656AB5
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 23:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012CFC433C1;
	Fri, 21 Oct 2022 23:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666393433;
	bh=A4j0VrdZ9gg1XHGr2/1GtAoKMQUkgkmFuLKo8NhbBew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piMs88uaufRlS+IllP2EckBB0f+wdYg/hzuY6Uj1MaK6hPKcRkLeAyABZ8CSVeeIa
	 PPMSFuQkOpNKBJ6BcqNopKe7G4tAHuwqKDM6Oi2DNhmmNmsj0OyuNbzT8+1xGBkbHb
	 rCSJxVWAOpROc2RDKYk411GUjvJYyKVRkBD8P8A0FVLkYXXkJjTGMxhpcdDUg/ABHv
	 awedadC+BobZJTPdnsu8DPSF1Om3l5ALELLsjQVcCl+FdTo2st6hZjOHZN0hMb+pQW
	 6x2gFsHTrnp1eQYV0XlZaPlnWfsYOR4IPZCeVVaCG0hltYhT+zLVYs7jX5CDq2p/XT
	 1xH/Xz9f4Fuxg==
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
Subject: [PATCH v4 4/8] arm64/fpsimd: Stop using TIF_SVE to manage register saving in KVM
Date: Sat, 22 Oct 2022 00:03:17 +0100
Message-Id: <20221021230321.1159287-5-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021230321.1159287-1-broonie@kernel.org>
References: <20221021230321.1159287-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2678; i=broonie@kernel.org; h=from:subject; bh=A4j0VrdZ9gg1XHGr2/1GtAoKMQUkgkmFuLKo8NhbBew=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjUyU0uzI3R+iGcnjDzu0SRWNy+IaLClbpHNErAICK FsazqCqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1MlNAAKCRAk1otyXVSH0KkaB/ 0SkpNB0DHcOtt33CCI4xXHlLz6+WJtjf3ikRKkH/3Yloz+ZU9RIb8mwFCN0gRjlrxy/l6PZIvLuH1V WTZCJ6T93e1EcUn80Fw5J5/Rsd3LRRK5ARlC6HVfBdt/4FyRsKt2SHqKv0m8loUkL1aq+75x63tvdl 1q6qsCM0dUUizi4Q8ZUghXCDwGlgkLXlWc4f9by0MNJJu8FPey1mnkyy/o1gDN90TaTb5rpjej24lQ AHsR5Z1CdzrzZLnEyJXl/+ROMUaEy5bjY4YvRe2t+rQwwyDEqdq3L/y5yf7ICREvqOHAO5ZxRARNKF WJMYt0sYOQmXzduxwK/plu9ShTLYZx
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Now that we are explicitly telling the host FP code which register state
it needs to save we can remove the manipulation of TIF_SVE from the KVM
code, simplifying it and allowing us to optimise our handling of normal
tasks. Remove the manipulation of TIF_SVE from KVM and instead rely on
to_save to ensure we save the correct data for it.

There should be no functional or performance impact from this change.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 22 ++++------------------
 arch/arm64/kvm/fpsimd.c    |  3 ---
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index f819f79e69cc..65ea8163c7f6 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -439,8 +439,8 @@ static void task_fpsimd_load(void)
  * last, if KVM is involved this may be the guest VM context rather
  * than the host thread for the VM pointed to by current. This means
  * that we must always reference the state storage via last rather
- * than via current, other than the TIF_ flags which KVM will
- * carefully maintain for us.
+ * than via current, if we are saving KVM state then it will have
+ * ensured that the type of registers to save is set in last->to_save.
  */
 static void fpsimd_save(void)
 {
@@ -457,27 +457,13 @@ static void fpsimd_save(void)
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
 		return;
 
-	if (test_thread_flag(TIF_SVE)) {
+	if ((last->to_save == FP_STATE_TASK && test_thread_flag(TIF_SVE)) ||
+	    last->to_save == FP_STATE_SVE) {
 		save_sve_regs = true;
 		save_ffr = true;
 		vl = last->sve_vl;
 	}
 
-	/*
-	 * Validate that an explicitly specified state to save is
-	 * consistent with the task state.
-	 */
-	switch (last->to_save) {
-	case FP_STATE_TASK:
-		break;
-	case FP_STATE_FPSIMD:
-		WARN_ON_ONCE(save_sve_regs);
-		break;
-	case FP_STATE_SVE:
-		WARN_ON_ONCE(!save_sve_regs);
-		break;
-	}
-
 	if (system_supports_sme()) {
 		u64 *svcr = last->svcr;
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 89c02ce797b8..ec82d0191f76 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -151,7 +151,6 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 					 &vcpu->arch.fp_type, fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
-		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
 	}
 }
 
@@ -208,7 +207,5 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
 	}
 
-	update_thread_flag(TIF_SVE, 0);
-
 	local_irq_restore(flags);
 }
-- 
2.30.2

