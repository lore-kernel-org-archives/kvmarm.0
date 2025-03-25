Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2795E1F1526;
	Tue, 25 Mar 2025 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928576; cv=none; b=ZY9fwxgMOfiCKYJacFiUAP/TIEltfgNvSh7mVYHlFDW9izqHMFlP6QPPT4M6rRYhmmSKsVQqbwE4GaWW7soQxpvWmbdg1o9tqfRKmYFVHaPrWfVBKWIuJsmbGp/54vNlLM4KYYWS2Os+wTMxEPyr+rdoxHlI/6J0JG+yrwzdr4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928576; c=relaxed/simple;
	bh=WYSB+kV0DAsAWmBSw2jSwXXGKnfDSojbRRnLHyx6xSQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PRD5LWZMnNRsX3JmyYnIcXtbmZBuKgpsTz3WEdbnngIOAz2fNEkWuXY2GzfNJZgJDDr7eDLEb5OrEX5MqOrqJqXZcjBfHRZO32Y4StmBJ5GMef4cCm80RcxSL7XGKKzK7ndft0n0+LuwCSDvH0GRT+fMV9OVwaeAtC1vB4gcrdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMEwDCdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMEwDCdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4A2C4CEEF;
	Tue, 25 Mar 2025 18:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742928575;
	bh=WYSB+kV0DAsAWmBSw2jSwXXGKnfDSojbRRnLHyx6xSQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nMEwDCdlshRVrKzWOvvfvo3bw77t0dNCk+TAA0+zrqQgE8zJHrCQsWMqbOaRXzDaq
	 PzzNKpK2A1fkuJmw2Vn8NZC5I2YcRQRTLiRQEV2vk9QDoxBtOL1uM0GTViOWi5SXOV
	 YAGcg6EUtRyLT/jEmPNI+zurUYpD+9c47tvP9t9nVqu4UYFLHvIA65yvkNQO6dcVnT
	 l4LCz4CEtIKz2+CtvJaGkPSyPCZcD2XzxxCwxq1cyNcWIgqj5nvlVEIs74CR6Tp0Sa
	 PkknD12YPL6aa6NOgG0BnUpjReDEkn2rieccSeQ0/1R2/nONVBgFEG2bt7wqFruJud
	 plE0sIPEhYUVw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 25 Mar 2025 18:48:18 +0000
Subject: [PATCH 6.1 04/12] arm64/fpsimd: Stop using TIF_SVE to manage
 register saving in KVM
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250325-stable-sve-6-1-v1-4-83259d427d84@kernel.org>
References: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
In-Reply-To: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3212; i=broonie@kernel.org;
 h=from:subject:message-id; bh=WYSB+kV0DAsAWmBSw2jSwXXGKnfDSojbRRnLHyx6xSQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn4vqpPArvKUVjN+KF44NX54Bgp2VN610UjgtlTk5W
 n/p5iH+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+L6qQAKCRAk1otyXVSH0C+QB/
 wJeL9MNcdj2gpaZea3N3n1HquK+ognf7vhmOR+z/22U5/B9DXskwcwk7R4GByQ7dIu9CG/a7FoCktL
 PVu1wVffqGnZFVdPlVdoQzwByaMWcsGjmaTubkZ5cZVvo3P28+b41BClrBhP2JpIXG6aI2QnfNYobo
 4rH+9BR+VFPcz7FZOMdU2KOfSgafJ1EYpQ7bMmMMfsbOVvDIgmLzuInBRqFG/gbXVs/iK1T5BD2rvJ
 Lzx2akA4bITBZfKSrw2h23bP7PoOjlAIJb6L9YQHkFK+B7EQzlU43YcmptW4jLmANNtuOPYE2AujoA
 p0V8DvhzdTw7u2o+x/MQGJ5R8oxTjK
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

[ Upstream commit 62021cc36add7b2c015b837f7893f2fb4b8c2586 ]

Now that we are explicitly telling the host FP code which register state
it needs to save we can remove the manipulation of TIF_SVE from the KVM
code, simplifying it and allowing us to optimise our handling of normal
tasks. Remove the manipulation of TIF_SVE from KVM and instead rely on
to_save to ensure we save the correct data for it.

There should be no functional or performance impact from this change.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115094640.112848-5-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 22 ++++------------------
 arch/arm64/kvm/fpsimd.c    |  3 ---
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 1f6fd9229e536966292a9751f08103912a48ba07..3fcacbce5d427e274a9439b8a6f9edf4080d54a4 100644
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
+	if ((last->to_save == FP_STATE_CURRENT && test_thread_flag(TIF_SVE)) ||
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
-	case FP_STATE_CURRENT:
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
index 89c02ce797b874196eff978464a936dfb020ad02..ec82d0191f76717ad17a43f87bd8a806eb4ab3b8 100644
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
2.39.5

