Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB6CBA3F
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 17:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4D0C433A8;
	Tue,  7 Mar 2023 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678210658;
	bh=SmlxYiA/3ySntffM92fOSUEOm9jQcb7Zkb7ib6Xk9jM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ih8q8VrmT3ZP/doPzvCJFY/0Mjg68Q0zLZRMk+lpboJSaQMFKzNG91b4s7uWEWUwb
	 UfhDEj/if9pNf2S4GKfoLSp1InxfOGuldQd54yHwG8ji3ctkNMWezrPxaiSVXWDuMv
	 umJFv1MQqFs3dZ5PWuZFTyWUnbIrcV88mHJRz3Ts0gfB8e3vuzWgHyDR4qakxQnWot
	 CTksHnrjbQg9UTLIK7TeBrs3wISbdqTCgwdc4cyz1jTsrf7rZvqxgQG5CwS6EBUuLy
	 5LRqKIE0dfNSd3KP5+v4Nb/2bjQ2zxzuv9pne54WSfk2dK9gzkwVSDb8I7OZL0BkIJ
	 DOkVIubvKk1oA==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 07 Mar 2023 17:37:16 +0000
Subject: [PATCH v2 3/3] KVM: arm64: Clarify host SME state management
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221214-kvm-arm64-sme-context-switch-v2-3-57ba0082e9ff@kernel.org>
References: <20221214-kvm-arm64-sme-context-switch-v2-0-57ba0082e9ff@kernel.org>
In-Reply-To: <20221214-kvm-arm64-sme-context-switch-v2-0-57ba0082e9ff@kernel.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-bd1bf
X-Developer-Signature: v=1; a=openpgp-sha256; l=4231; i=broonie@kernel.org;
 h=from:subject:message-id; bh=SmlxYiA/3ySntffM92fOSUEOm9jQcb7Zkb7ib6Xk9jM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBkB3ZX/DoWd/fI96UBK0DTrNUPr3aelptmm4DFU6i/
 9lP3GdKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZAd2VwAKCRAk1otyXVSH0JleB/
 4xi0j0mnJdHTFNWsnyDghHsiHlqJKuYwCah6/en2pNwbiB0/6586Ocx/thDtDDfzp6djlzzYwdn7jS
 O+tyUW9XV0JEslXY1y2acIRvdQCwsGFHo6bVRgOcSsuO5n2kWr8XhTMYRn0T7qza8njNcdyMOqWLPA
 YoO2IUK/t6gIqsJEEvNgCYNGiiqBOq+PHpDlVqqDEeSgSzlg95M9SWwnzj0/dEO+jTBwxPizc2uP/V
 FnORx7wwJD8FA+EcCbMNA6SQXR/xSiEy8ZCG4WX0Xvk1UNY3+T0HcZctGhwqVn2qefyhvEP09zv/+G
 6PtTHLUKkzUZIwdB+IoE0J9QafZBUk
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
 arch/arm64/kvm/fpsimd.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 3fd0ce6a3500..4c9dcd8fc939 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -92,20 +92,23 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
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
 		if (read_sysreg_s(SYS_SVCR) & (SVCR_SM_MASK | SVCR_ZA_MASK)) {
 			vcpu->arch.fp_state = FP_STATE_FREE;
 			fpsimd_save_and_flush_cpu_state();

-- 
2.30.2

