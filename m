Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2355428FA
	for <kvmarm@lists.linux.dev>; Tue, 27 Dec 2022 14:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9ADC433EF;
	Tue, 27 Dec 2022 14:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672151655;
	bh=9kbMwRw1b3bWWGee5WZ6Ix18o3oPlvtDVw1gJAcOYZE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dUhftpKJ1DS0PTo2XDKX+/my9yu0X6eIl3plXNW6P6ZRN0vETo/kDZ4crZm9FQHQ0
	 6zuqMd+Z4vL/D7EqqJnoyN8nwjvePNrJW0SkxxuFjOamUu+UNoC0b0Rs4fjMLLPkug
	 hoqaa3/CUjHMNpiK3yZ8IgS6UwUvTK/Vou7UJaYAkqSSEeMShXX0VbLk/7ZPGs0RB2
	 PqxAQUmVCqgVwTfAiY1gXzgYLXUqrODS/9TSnF5hHwB7CKHB93JNXvQhy0p40Ii27F
	 mlC+SuOn3xZpJclo5Xnd+ziq6nit5bGhDSHweIO1+Jn4VhUxOmjcta81f7M4jc9Gr/
	 VqNef3St0CCyA==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 27 Dec 2022 14:33:40 +0000
Subject: [PATCH 3/3] KVM: arm64: Clarify host SME state management
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id:
 <20221214-kvm-arm64-sme-context-switch-v1-3-383b4699de06@kernel.org>
References:
 <20221214-kvm-arm64-sme-context-switch-v1-0-383b4699de06@kernel.org>
In-Reply-To:
 <20221214-kvm-arm64-sme-context-switch-v1-0-383b4699de06@kernel.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.12-dev-7ab1d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6443; i=broonie@kernel.org;
 h=from:subject:message-id; bh=9kbMwRw1b3bWWGee5WZ6Ix18o3oPlvtDVw1gJAcOYZE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjqwJcAS16rY5LOKfqjf6sjf17oeVtYxdCxvZWRZJV
 P4N7P7eJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY6sCXAAKCRAk1otyXVSH0EMqB/
 9nZ+31z5Q1PN7A+oqbFtD5dYHj9VDkoJHx9+GthZOuYjaDbQVZziSU8dpjJVQumNIHTgpToB+jYmGc
 Ly6Cyf2o49zBpuq59bZTF/ID1KiQ5qIYY+9VilekuJDk8Tq88iAsbLK9QQvqwcPTuSYkTdQG1ahoxJ
 N2YYG8jjDJCZWLEiz9Pur/sa3meD+McH2bQHJi9gks9XnEsfoIZ6xdFwDDhh7B7OQMNkrALoqaZWNT
 /bxv7ul9aDcnE6FcN8ep05shIN1/A5j3qoxj7ZTP6KaVy9AkP+pCwzTJuetdnNWZISttThL17EUvJX
 r0ayqaTK39tmZH8K4KIxSPW2V6/XcS
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Normally when running a guest we do not touch the floating point
register state until first use of floating point by the guest, saving
the current state and loading the guest state at that point. This has
been found to offer a performance benefit in common cases. However
currently if SME is active when switching to a guest then we exit
streaming mode, disable ZA and invalidate the floating point register
state prior to starting the guest.

The exit from streaming mode is required for correct guest operation, if
we leave streaming mode enabled then many non-SME operations can
generate SME traps (eg, SVE operations will become streaming SVE
operations). If EL1 leaves CPACR_EL1.SMEN disabled then the host is
unable to intercept these traps. This will mean that a SME unaware guest
will see SME exceptions which will confuse it. Disabling streaming mode
also avoids creating spurious indications of usage of the SME hardware
which could impact system performance, especially with shared SME
implementations. Document the requirement to exit streaming mode
clearly.

There is no issue with guest operation caused by PSTATE.ZA so we can
defer handling for that until first floating point usage, do so if the
register state is not that of the current task and hence has already
been saved. We could also do this for the case where the register state
is that for the current task however this is very unlikely to happen and
would require disproportionate effort so continue to save the state in
that case.

Saving this state on first use would require that we map and unmap
storage for the host version of these registers for use by the
hypervisor, taking care to deal with protected KVM and the fact that the
host can free or reallocate the backing storage. Given that the strong
recommendation is that applications should only keep PSTATE.ZA enabled
when the state it enables is in active use it is difficult to see a case
where a VMM would wish to do this, it would need to not only be using
SME but also running the guest in the middle of SME usage. This can be
revisited in the future if a use case does arises, in the interim such
tasks will work but experience a performance overhead.

This brings our handling of SME more into line with our handling of
other floating point state and documents more clearly the constraints we
have, especially around streaming mode.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/fpsimd.c                 | 28 ++++++++++++++++++----------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 26 ++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 6c1cb945c777..25dfb0e4f93e 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -74,6 +74,8 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
  */
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
+	u64 svcr;
+
 	BUG_ON(!current->mm);
 
 	if (!system_supports_fpsimd())
@@ -92,21 +94,27 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
 		vcpu_set_flag(vcpu, HOST_SVE_ENABLED);
 
-	/*
-	 * We don't currently support SME guests but if we leave
-	 * things in streaming mode then when the guest starts running
-	 * FPSIMD or SVE code it may generate SME traps so as a
-	 * special case if we are in streaming mode we force the host
-	 * state to be saved now and exit streaming mode so that we
-	 * don't have to handle any SME traps for valid guest
-	 * operations. Do this for ZA as well for now for simplicity.
-	 */
 	if (system_supports_sme()) {
 		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
 			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
 
-		if (read_sysreg_s(SYS_SVCR) & (SVCR_SM_MASK | SVCR_ZA_MASK)) {
+		/*
+		 * If PSTATE.SM is enabled then save any pending FP
+		 * state and disable PSTATE.SM. If we leave PSTATE.SM
+		 * enabled and the guest does not enable SME via
+		 * CPACR_EL1.SMEN then operations that should be valid
+		 * may generate SME traps from EL1 to EL1 which we
+		 * can't intercept and which would confuse the guest.
+		 *
+		 * Do the same for PSTATE.ZA in the case where there
+		 * is state in the registers which has not already
+		 * been saved, this is very unlikely to happen.
+		 */
+		svcr = read_sysreg_s(SYS_SVCR);
+		if ((svcr & SVCR_SM_MASK) ||
+		    ((svcr & SVCR_ZA_MASK) &&
+		     !test_thread_flag(TIF_FOREIGN_FPSTATE))) {
 			vcpu->arch.fp_state = FP_STATE_FREE;
 			fpsimd_save_and_flush_cpu_state();
 		}
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 009f4ce6c691..51102d6632db 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -158,6 +158,27 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
+static inline void __hyp_sme_restore_guest(struct kvm_vcpu *vcpu)
+{
+	if (!system_supports_sme())
+		return;
+
+	/*
+	 * No guest support yet, always disable SME and reenable
+	 * traps.
+	 */
+	sme_smstop();
+
+	if (has_vhe())
+		sysreg_clear_set(cpacr_el1,
+				 CPACR_EL1_SMEN_EL0EN |
+				 CPACR_EL1_SMEN_EL1EN, 0);
+	else
+		sysreg_clear_set(cptr_el2, 0, CPTR_EL2_TSM);
+
+	isb();
+}
+
 /*
  * We trap the first access to the FP/SIMD to save the host context and
  * restore the guest context lazily.
@@ -195,12 +216,16 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		reg = CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
 		if (sve_guest)
 			reg |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
+		if (system_supports_sme())
+			reg |= CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN;
 
 		sysreg_clear_set(cpacr_el1, 0, reg);
 	} else {
 		reg = CPTR_EL2_TFP;
 		if (sve_guest)
 			reg |= CPTR_EL2_TZ;
+		if (system_supports_sme())
+			reg |= CPTR_EL2_TSM;
 
 		sysreg_clear_set(cptr_el2, reg, 0);
 	}
@@ -211,6 +236,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 
 	/* Restore the guest state */
+	__hyp_sme_restore_guest(vcpu);
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);
 	else

-- 
2.30.2
