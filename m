Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9C51F239B;
	Fri,  4 Apr 2025 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773260; cv=none; b=Suw2F5GM3Qd9GLr/eaMZyLSTUeXRRJFdqjKfPXuFxp9TWkpLzo/P6OgXENPGnHRWSKN6HcWwOic7NA69lRP3ZH+uoWjWgr8nGkY8ufCZYOKK4NDzXz44xutZQqhcDFcx/Pob6xA5hbIVVbwGOC7yay0TpwyonTKZdiSupSgtV+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773260; c=relaxed/simple;
	bh=4VF5KHNGR8pAFy/QCy5ziE4tio3jSPNyk9q/Tymigz0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=szqkWNcNO/CYm+cQrCL/s7tSD9dPA8mloka1OwcEOK4QRieJB87EB9chSCrfh7FEWpAU9m3VccytfVpoZ1L2CH8z+fjpEJ84H1pTfIsIxR54HFfWO0u4ZV0l93XwRRFPXdSxgxv2NiDH+iy52POG1KqDRv6WQQbWOIgYchspk4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/Aprl38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/Aprl38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADDEC4CEED;
	Fri,  4 Apr 2025 13:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743773260;
	bh=4VF5KHNGR8pAFy/QCy5ziE4tio3jSPNyk9q/Tymigz0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Q/Aprl38znGI4/+PHdXyCSj349psoGfqd2TmhKOuUZGkLxW0P2EHxsOkgbZ1JKYfi
	 SUyEKQfUe6wg0uypgWmfInNFSxOJjo8YxcnDDSkupJV6eWDb2AZ2t0zN4Mzfguzpiq
	 hr9Ta41+Z3OPwv066eAq17VSOfUNntG0Dt9hp+aN9iAWdDz2R+FyDB+udg9kO0HhO/
	 aRxq7TsJOBdipi9Nrt0vc952xEgJN8Z/NdWsmiEsOi1QTBiE2Jzs6GiOx95DScISSz
	 m2fbb4uuKaUXHEz/2arM1A/fb5sPs/bekXYEYlF7BOkd1GTH5xpdaYXGjcqwKE9TAQ
	 5QzK32Xeyy+kA==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Apr 2025 14:23:37 +0100
Subject: [PATCH RESEND 6.1 04/12] arm64/fpsimd: Stop using TIF_SVE to
 manage register saving in KVM
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250404-stable-sve-6-1-v1-4-cd5c9eb52d49@kernel.org>
References: <20250404-stable-sve-6-1-v1-0-cd5c9eb52d49@kernel.org>
In-Reply-To: <20250404-stable-sve-6-1-v1-0-cd5c9eb52d49@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, stable@vger.kernel.org, 
 Mark Rutland <mark.rutland@arm.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3100; i=broonie@kernel.org;
 h=from:subject:message-id; bh=4VF5KHNGR8pAFy/QCy5ziE4tio3jSPNyk9q/Tymigz0=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhvT39wyOKrLvEp2bfsLho/Hd60opRd7tHWZ/YuV29Lq9VC1m
 4uzuZDRmYWDkYpAVU2RZ+yxjVXq4xNb5j+a/ghnEygQyhYGLUwAmclaB/X/Uy77E8sO8MWYrcjdIbj
 2yYj/zJZaijilH5378/yD8cYS+2Kx6i2sK5rJerUfyrES5Nx245ZSZKvym3VO9eK9+U/XTK11aFw6b
 CTlWFErU7D5axp2t7Fu2TaTXpuKOuiEbF8eXtpfnSr5NUPn2daHBbr60E0JrpWsCXyiIqUsXnBF2+q
 p3jNtan32V3+Wb3G4GM3ez/9hpsUrP7fnMp9VzA8xXMIelTnaZst5vR+npX3eK+WOvMqWpBfg4ril3
 npMvYndyw/JrHMyCTU3Lbs8NXphrrrhubrrlii1FKUfn8PCWOmSGhdX+nKhU7rjlx4P2VW0fPcQ4Na
 Ky+wzeX2M9p9pT6SqUyny67NsGAA==
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
index 1f6fd9229e53..3fcacbce5d42 100644
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
2.39.5

