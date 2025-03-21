Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602CB4879B;
	Fri, 21 Mar 2025 00:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516302; cv=none; b=Wchse+jqCyiOqhHWmWejY19niQx+gD0rGfW7R7Z9dD/WgpynPVWW2QRcV2wGK2f3+zFkDqba2S/f7wk0WlW7TifVAYSJxyMmfGkuiXo3p0gXxWJNjUiVjmjUUEe1bbvAJvpK032KPlx1G5EG30ENilh1EagDmbkjHBbuYeHqTxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516302; c=relaxed/simple;
	bh=UbWww6ZZCpLEum2jlpLA8W/p3yJo1aXcx0b1YN9WsH4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YuX44K1Xi+E/SPlwI8Y1lR/uZMlMAVuGtqj01+Me/q5BuRwiiPwnFnXDV5/PQBbuRc8ftEKFU79+yLW99xl1Nj5JyTXj9QM7/JS1ZsA9V1BWMu8/TcJYum2qhNMzHCDh7Kcz1RcIeFUc89hIGASMCSmk1L+e4pD3Y+0RwhNOQtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLYDaHn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLYDaHn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2EEC4CEE3;
	Fri, 21 Mar 2025 00:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742516301;
	bh=UbWww6ZZCpLEum2jlpLA8W/p3yJo1aXcx0b1YN9WsH4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FLYDaHn8wRwuyMSE+yljDayCuGrvW3NaEp11czrX0vW63Qgb5ZKLx86eKcOLQLsEz
	 1hOHRdh85DhjeTOHf8W9HIf6H6JA9EuRIPvSdLd8I1jTJFR8qpzZI+vmGOqiS/LqSm
	 0S0WrikJtKvJ8y8INVZbdC3mM8c7vNwCwEDaN0YdhM0C0yI2u9YumbxOL6R7J7T8a/
	 lpleJapMvrc8rielFmoxGbXupNyFBM3EHHygykwi3/EWtR6Kk2f/38cHl236E+EQc/
	 eqrJ02WSp/ucjF/Iiqd8FxV9Effh51q7Q39QDOEQxDnCKBQSRmyS8S2ptIPe7o/oK5
	 xIcMhsXqaKxvQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:16:02 +0000
Subject: [PATCH 6.6 2/8] KVM: arm64: Unconditionally save+flush host
 FPSIMD/SVE/SME state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250321-stable-sve-6-6-v1-2-0b3a6a14ea53@kernel.org>
References: <20250321-stable-sve-6-6-v1-0-0b3a6a14ea53@kernel.org>
In-Reply-To: <20250321-stable-sve-6-6-v1-0-0b3a6a14ea53@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Eric Auger <eauger@redhat.com>, Wilco Dijkstra <wilco.dijkstra@arm.com>, 
 Eric Auger <eric.auger@redhat.com>, Florian Weimer <fweimer@redhat.com>, 
 Fuad Tabba <tabba@google.com>, Jeremy Linton <jeremy.linton@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=6160; i=broonie@kernel.org;
 h=from:subject:message-id; bh=1GT1GHGJkE6mMiHosvFrZPe9zuk67Q6/Q/eJEMkzMPE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn3LA7XVSV2UC+a4fX1hxzBSPcO8gNLi0mspm/i10/
 dd3hnKuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9ywOwAKCRAk1otyXVSH0LxMB/
 9MlW0SFYEJskV9nXzTGC/Iw897O08ZbXf+p9zefH3dMbq0jbne0GYrU5AOToosoCh9lqhaDQXV1vNp
 Pmopr9kh2FYMEHTcSfgRLY76KqPeizJryb5lf9B/zMtb1xh72T0T+Rzqn7EoeRFGW9rVfjKfYru3v0
 tGZkGyfCofbw5dPblJ5Pqr/yMGxNDA1CNmLzI3mSJM0LLcSKBjEecLNbmMRAV+VREPR/BnsVgxp3/d
 PhNk2a90Ec8APYJHfQEEt3q+e0Q2HH4PT1jZJu+jYabpbrI1aZ5VkG913X0s+VQZkoIk1d3hkasgoL
 Mvl+B6zdmtBXF8HXNKJ3e97dUq23Jx
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit fbc7e61195e23f744814e78524b73b59faa54ab4 ]

There are several problems with the way hyp code lazily saves the host's
FPSIMD/SVE state, including:

* Host SVE being discarded unexpectedly due to inconsistent
  configuration of TIF_SVE and CPACR_ELx.ZEN. This has been seen to
  result in QEMU crashes where SVE is used by memmove(), as reported by
  Eric Auger:

  https://issues.redhat.com/browse/RHEL-68997

* Host SVE state is discarded *after* modification by ptrace, which was an
  unintentional ptrace ABI change introduced with lazy discarding of SVE state.

* The host FPMR value can be discarded when running a non-protected VM,
  where FPMR support is not exposed to a VM, and that VM uses
  FPSIMD/SVE. In these cases the hyp code does not save the host's FPMR
  before unbinding the host's FPSIMD/SVE/SME state, leaving a stale
  value in memory.

Avoid these by eagerly saving and "flushing" the host's FPSIMD/SVE/SME
state when loading a vCPU such that KVM does not need to save any of the
host's FPSIMD/SVE/SME state. For clarity, fpsimd_kvm_prepare() is
removed and the necessary call to fpsimd_save_and_flush_cpu_state() is
placed in kvm_arch_vcpu_load_fp(). As 'fpsimd_state' and 'fpmr_ptr'
should not be used, they are set to NULL; all uses of these will be
removed in subsequent patches.

Historical problems go back at least as far as v5.17, e.g. erroneous
assumptions about TIF_SVE being clear in commit:

  8383741ab2e773a9 ("KVM: arm64: Get rid of host SVE tracking/saving")

... and so this eager save+flush probably needs to be backported to ALL
stable trees.

Fixes: 93ae6b01bafee8fa ("KVM: arm64: Discard any SVE state when entering KVM guests")
Fixes: 8c845e2731041f0f ("arm64/sve: Leave SVE enabled on syscall if we don't context switch")
Fixes: ef3be86021c3bdf3 ("KVM: arm64: Add save/restore support for FPMR")
Reported-by: Eric Auger <eauger@redhat.com>
Reported-by: Wilco Dijkstra <wilco.dijkstra@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Tested-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-2-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ Mark: Handle vcpu/host flag conflict ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 25 -------------------------
 arch/arm64/kvm/fpsimd.c    | 31 ++++++++-----------------------
 2 files changed, 8 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 0137d987631e089c935560eccbc678a258580232..bd4f6c6ee0f318e1f60d40755c0f4915edb415b8 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1707,31 +1707,6 @@ void fpsimd_signal_preserve_current_state(void)
 		sve_to_fpsimd(current);
 }
 
-/*
- * Called by KVM when entering the guest.
- */
-void fpsimd_kvm_prepare(void)
-{
-	if (!system_supports_sve())
-		return;
-
-	/*
-	 * KVM does not save host SVE state since we can only enter
-	 * the guest from a syscall so the ABI means that only the
-	 * non-saved SVE state needs to be saved.  If we have left
-	 * SVE enabled for performance reasons then update the task
-	 * state to be FPSIMD only.
-	 */
-	get_cpu_fpsimd_context();
-
-	if (test_and_clear_thread_flag(TIF_SVE)) {
-		sve_to_fpsimd(current);
-		current->thread.fp_type = FP_STATE_FPSIMD;
-	}
-
-	put_cpu_fpsimd_context();
-}
-
 /*
  * Associate current's FPSIMD context with this cpu
  * The caller must have ownership of the cpu FPSIMD context before calling
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 8c1d0d4853df48abf4d089bbde153bcee8d0e6d0..8b55de502c8c220e15e3a6b782d5012b9349b612 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -79,14 +79,16 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	if (!system_supports_fpsimd())
 		return;
 
-	fpsimd_kvm_prepare();
-
 	/*
-	 * We will check TIF_FOREIGN_FPSTATE just before entering the
-	 * guest in kvm_arch_vcpu_ctxflush_fp() and override this to
-	 * FP_STATE_FREE if the flag set.
+	 * Ensure that any host FPSIMD/SVE/SME state is saved and unbound such
+	 * that the host kernel is responsible for restoring this state upon
+	 * return to userspace, and the hyp code doesn't need to save anything.
+	 *
+	 * When the host may use SME, fpsimd_save_and_flush_cpu_state() ensures
+	 * that PSTATE.{SM,ZA} == {0,0}.
 	 */
-	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
+	fpsimd_save_and_flush_cpu_state();
+	vcpu->arch.fp_state = FP_STATE_FREE;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
@@ -96,23 +98,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
 			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
-
-		/*
-		 * If PSTATE.SM is enabled then save any pending FP
-		 * state and disable PSTATE.SM. If we leave PSTATE.SM
-		 * enabled and the guest does not enable SME via
-		 * CPACR_EL1.SMEN then operations that should be valid
-		 * may generate SME traps from EL1 to EL1 which we
-		 * can't intercept and which would confuse the guest.
-		 *
-		 * Do the same for PSTATE.ZA in the case where there
-		 * is state in the registers which has not already
-		 * been saved, this is very unlikely to happen.
-		 */
-		if (read_sysreg_s(SYS_SVCR) & (SVCR_SM_MASK | SVCR_ZA_MASK)) {
-			vcpu->arch.fp_state = FP_STATE_FREE;
-			fpsimd_save_and_flush_cpu_state();
-		}
 	}
 }
 

-- 
2.39.5

