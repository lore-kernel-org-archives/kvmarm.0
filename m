Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA7C1F2C5B;
	Tue, 25 Mar 2025 18:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928588; cv=none; b=N14Frljej1Vv+wRw2vEvOTUXs5ioIi/26dQB3OoMxtj+97r3CSaaZ2jMPmA2TFL/ngFx62LxUeMdsH6C4HlmHPt5voYAhTC8JVqmVvBvwvMNFHEdm9jeqOOIpX9ci+JZjjL4GfvZ6EaVyjcXYt14w9aOPf9x0UGqinD3aE47iLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928588; c=relaxed/simple;
	bh=mkvTxdIaHOVoQg/PN+WHoGMe/wTgoxEDXWXJ93mvLPc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lj8PuIjOO8dH0MQkIfQHjzvhiFxTvTOl2wvSWhPJuvKWRBeJqlAfXEB3xaXu3f0KKGYZZX0DCD8x7tQKELc8zC1pC+3gBRbT5tj2Q0mssB3dK/ALQC76mkHeuf19fAm95G9ZXo+6OQzgvYIFV7giPf9JaCWYfwaaDXK0PFTI8Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFvV423Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFvV423Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F158C4CEE4;
	Tue, 25 Mar 2025 18:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742928588;
	bh=mkvTxdIaHOVoQg/PN+WHoGMe/wTgoxEDXWXJ93mvLPc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eFvV423ZKHWcrxffpn6SAjkkkIylPE2tno5KDKeeGkgs3a6GeDzsWHCJwmsbE92m7
	 MfcXEk4nexNPtZT2T714NRwb6oIkEJoCJKIqjJp52x5D1uDzO2g3JrZpy3WYCSFjQ5
	 QtwyMCjhFHlMDvGm9aceUBJdTmDvGGpDwoaefbGKD4SuflJ7TFQjht3T+TXiQG3mxs
	 c+aZeqwoY3A1cVKzhC67sTrn8nl5XRZQKVWcy1azCC/huaYDhm4ZR01WLg0aRM6ga0
	 9gKFKgRjYPfrqmXD3WzFUL3atgA3qGf4U//M/0n7MVnySt5paQHfL1bWYv+lOTo82S
	 ZpUjqnYLwVuzg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 25 Mar 2025 18:48:22 +0000
Subject: [PATCH 6.1 08/12] KVM: arm64: Remove VHE host restore of
 CPACR_EL1.SMEN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250325-stable-sve-6-1-v1-8-83259d427d84@kernel.org>
References: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
In-Reply-To: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <tabba@google.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=5061; i=broonie@kernel.org;
 h=from:subject:message-id; bh=e8sm3bVdKGiSFMPfGMxoLS31b4Pe7foaJqQ4sSxvqLM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn4vqscpJ+XGZeGryzI/YA13ZTYzfjGz3goro64dnl
 GtVJHs+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+L6rAAKCRAk1otyXVSH0FFzB/
 9rVAEmnovvGxTguFSumWqR9fYmivCJRYurw+/GlJIodM04qg/u9ZvW2xsLDngJIxlczEW22dmpJJpV
 ylZp+2pQaOjGwTkRSVbbB42Z76v5p3iNg2EqMMjbXi0Dvvp8YezHuAjCRuaz9R9a/HEKciCuIlRR7B
 S0Ge1e7H2iabInofA3MKQgeKFIktXh9nN0HyHJCVniZbzWfkxKpHLzF2vAsQ+Q9dqjlr7jhkOIOb5Y
 97vVcM5o3tVIFzLO6rKP4zaqraxwdP1a+ugrGTxYQ/G8hOH49I2Cy03XK4da5HthHjZYMaU/FnBiGv
 oYhfCLuj+0OzDEpjXAbJT0J7L80wg8
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 407a99c4654e8ea65393f412c421a55cac539f5b ]

When KVM is in VHE mode, the host kernel tries to save and restore the
configuration of CPACR_EL1.SMEN (i.e. CPTR_EL2.SMEN when HCR_EL2.E2H=1)
across kvm_arch_vcpu_load_fp() and kvm_arch_vcpu_put_fp(), since the
configuration may be clobbered by hyp when running a vCPU. This logic
has historically been broken, and is currently redundant.

This logic was originally introduced in commit:

  861262ab86270206 ("KVM: arm64: Handle SME host state when running guests")

At the time, the VHE hyp code would reset CPTR_EL2.SMEN to 0b00 when
returning to the host, trapping host access to SME state. Unfortunately,
this was unsafe as the host could take a softirq before calling
kvm_arch_vcpu_put_fp(), and if a softirq handler were to use kernel mode
NEON the resulting attempt to save the live FPSIMD/SVE/SME state would
result in a fatal trap.

That issue was limited to VHE mode. For nVHE/hVHE modes, KVM always
saved/restored the host kernel's CPACR_EL1 value, and configured
CPTR_EL2.TSM to 0b0, ensuring that host usage of SME would not be
trapped.

The issue above was incidentally fixed by commit:

  375110ab51dec5dc ("KVM: arm64: Fix resetting SME trap values on reset for (h)VHE")

That commit changed the VHE hyp code to configure CPTR_EL2.SMEN to 0b01
when returning to the host, permitting host kernel usage of SME,
avoiding the issue described above. At the time, this was not identified
as a fix for commit 861262ab86270206.

Now that the host eagerly saves and unbinds its own FPSIMD/SVE/SME
state, there's no need to save/restore the state of the EL0 SME trap.
The kernel can safely save/restore state without trapping, as described
above, and will restore userspace state (including trap controls) before
returning to userspace.

Remove the redundant logic.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-5-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[Update for rework of flags storage -- broonie]
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/fpsimd.c           | 31 -------------------------------
 2 files changed, 33 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 181e49120e0c4027aa52dd389de13f9ce5cd7b57..757f4dea1e563657eb5c79e624e4b91f514a113a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -556,8 +556,6 @@ struct kvm_vcpu_arch {
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
-/* SME enabled for EL0 */
-#define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
 /* WFIT instruction trapped */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 8d073a37c266db3dc2726c6a0bb39c7e2586f53f..df050e4d3562d2ef36b7c27602a6feaa431dfa93 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -87,21 +87,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 */
 	fpsimd_save_and_flush_cpu_state();
 	vcpu->arch.fp_state = FP_STATE_FREE;
-
-	/*
-	 * We don't currently support SME guests but if we leave
-	 * things in streaming mode then when the guest starts running
-	 * FPSIMD or SVE code it may generate SME traps so as a
-	 * special case if we are in streaming mode we force the host
-	 * state to be saved now and exit streaming mode so that we
-	 * don't have to handle any SME traps for valid guest
-	 * operations. Do this for ZA as well for now for simplicity.
-	 */
-	if (system_supports_sme()) {
-		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
-		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
-			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
-	}
 }
 
 /*
@@ -162,22 +147,6 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	local_irq_save(flags);
 
-	/*
-	 * If we have VHE then the Hyp code will reset CPACR_EL1 to
-	 * CPACR_EL1_DEFAULT and we need to reenable SME.
-	 */
-	if (has_vhe() && system_supports_sme()) {
-		/* Also restore EL0 state seen on entry */
-		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
-			sysreg_clear_set(CPACR_EL1, 0,
-					 CPACR_EL1_SMEN_EL0EN |
-					 CPACR_EL1_SMEN_EL1EN);
-		else
-			sysreg_clear_set(CPACR_EL1,
-					 CPACR_EL1_SMEN_EL0EN,
-					 CPACR_EL1_SMEN_EL1EN);
-	}
-
 	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);

-- 
2.39.5

