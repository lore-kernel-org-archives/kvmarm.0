Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A481172A;
	Fri, 21 Mar 2025 00:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516011; cv=none; b=FHyeiZFFAOyF2Tlopaiz+69WLXg09yStEQXkWOeQ7So5JVJ6rjeWhvQStvxwegO+0Ar1lhRMve+jgo4m3ifZOxEdVzNdKci3FfILGFkd3TjfHrwJ9rtALu2zNmtpF5SccyZy4fzzyBKvY8rCMvtKYg5ZxUD5nNZbbUpdlepKY5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516011; c=relaxed/simple;
	bh=K/8Nrb3lLZOisRi5mleFnZ95iWg89OwMyWVRd0rs/Ng=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EnfnQpkB+6K56KOJ4w7CxVgaKqh/6ZR7m0jZq2BTN7ezxIQWu/7WB8VqFCA3/4AOFMRUpsDvMXhODCuyPfY0wygxH6FIrKzFKNVx9jyjVCZsccS/Jx2X66HUW0u/3PIY6KagZC0J7Z57dFY/e6Mr9uwna8ZWmol1YL0zAWpHyHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKoGm2w7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKoGm2w7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12F5C4CEE3;
	Fri, 21 Mar 2025 00:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742516011;
	bh=K/8Nrb3lLZOisRi5mleFnZ95iWg89OwMyWVRd0rs/Ng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IKoGm2w7dW7xfv5ck2bBOP+6+kUo8LHNwmSw2epgVfAA+H+bKaC7nUXPUYm6CbSKP
	 BfQquwKLDplz4QAaZ4Wut4h+DxYCigCgJ8tkVL1+b7tGW5K8FOObnJvd1l6ghibTO8
	 slG/o52emyfKdqUKvrCQhwo/rGQ3jSJvNAgxrc2GxJkZHwo6VhMTqGCoGN2ujR+Y98
	 +AN5uXTm0kd/IB4vb+dk3k41uRUxci3u+hNJR2HDM/23yDilOAugY6KAcr4elQM8iI
	 AXgg7gDl6vaHbPj0369eTPtnoyBKE7uBJnBvOcx1iUOeBJxj9zbBWUikAQ+HZe+DjS
	 lxioMdQugk7AQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:12:57 +0000
Subject: [PATCH 6.12 v2 1/8] KVM: arm64: Calculate cptr_el2 traps on
 activating traps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250321-stable-sve-6-12-v2-1-417ca2278d18@kernel.org>
References: <20250321-stable-sve-6-12-v2-0-417ca2278d18@kernel.org>
In-Reply-To: <20250321-stable-sve-6-12-v2-0-417ca2278d18@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, Fuad Tabba <tabba@google.com>, 
 James Clark <james.clark@linaro.org>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=6732; i=broonie@kernel.org;
 h=from:subject:message-id; bh=hVLtg776pULslAUMCPL12ZcOO9mkq7DScfSM0RuRPfU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn3K8dVDc2Q+k88UeQ9mQyBWqNvx9PpQeChqCflC79
 wudbWqqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9yvHQAKCRAk1otyXVSH0HxuB/
 9CdZ4Po1jCddpilUs2HpsLsxliyAF3VPps9IWN7aK7e+ba8y6I+6a64r+gUh908AFawK+zhFEcEUK8
 720HCnLjye7dWoW7Pv5v++zgNGZcbA/LcLbxR35aJns+5d2ZQdyL5WtEphDQZwdgO1FYzwrnUmmytP
 9VNwVYS93inhBYher45IJ81zaUTbp4yLjPXnqZYa7lGNKIrWNfTyynu23MgQTTTXPRR4Chxqr3b0yI
 i+lhRzTjEOkdyJ01H5HS9MK5v6PzYJA/ep17TnB7tuT++XVzoZYVBc+YIbi3DT1dG7qoyK9TAxj0bc
 QAYflNRn8x6e2TOx1PAhXymXgTaaqp
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

From: Fuad Tabba <tabba@google.com>

[ Upstream commit 2fd5b4b0e7b440602455b79977bfa64dea101e6c ]

Similar to VHE, calculate the value of cptr_el2 from scratch on
activate traps. This removes the need to store cptr_el2 in every
vcpu structure. Moreover, some traps, such as whether the guest
owns the fp registers, need to be set on every vcpu run.

Reported-by: James Clark <james.clark@linaro.org>
Fixes: 5294afdbf45a ("KVM: arm64: Exclude FP ownership from kvm_vcpu_arch")
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://lore.kernel.org/r/20241216105057.579031-13-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/arm.c              |  1 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 29 ----------------------
 arch/arm64/kvm/hyp/nvhe/switch.c  | 51 ++++++++++++++++++++++++---------------
 4 files changed, 32 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1bf70fa1045dcd6704bdcd233767cdb7522b316f..d148cf578cb84e7dec4d1add2afa60a3c7a1e041 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -697,7 +697,6 @@ struct kvm_vcpu_arch {
 	u64 hcr_el2;
 	u64 hcrx_el2;
 	u64 mdcr_el2;
-	u64 cptr_el2;
 
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3cf65daa75a51f71fa7168016f8c3d81dc326cca..e6f0443210a8b7a65f616b25b2e6f74a05683ed6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1577,7 +1577,6 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
-	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
 
 	/*
 	 * Handle the "start in power-off" case.
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 077d4098548d2c87abdd3931285d87798d63adb3..7c464340bcd078df58b74164707f263a6bdb0272 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -28,8 +28,6 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 	u64 hcr_set = HCR_RW;
 	u64 hcr_clear = 0;
-	u64 cptr_set = 0;
-	u64 cptr_clear = 0;
 
 	/* Protected KVM does not support AArch32 guests. */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
@@ -59,21 +57,10 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	/* Trap AMU */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), feature_ids)) {
 		hcr_clear |= HCR_AMVOFFEN;
-		cptr_set |= CPTR_EL2_TAM;
-	}
-
-	/* Trap SVE */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), feature_ids)) {
-		if (has_hvhe())
-			cptr_clear |= CPACR_ELx_ZEN;
-		else
-			cptr_set |= CPTR_EL2_TZ;
 	}
 
 	vcpu->arch.hcr_el2 |= hcr_set;
 	vcpu->arch.hcr_el2 &= ~hcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
-	vcpu->arch.cptr_el2 &= ~cptr_clear;
 }
 
 /*
@@ -103,7 +90,6 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
 	u64 mdcr_set = 0;
 	u64 mdcr_clear = 0;
-	u64 cptr_set = 0;
 
 	/* Trap/constrain PMU */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), feature_ids)) {
@@ -130,21 +116,12 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceFilt), feature_ids))
 		mdcr_set |= MDCR_EL2_TTRF;
 
-	/* Trap Trace */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), feature_ids)) {
-		if (has_hvhe())
-			cptr_set |= CPACR_EL1_TTA;
-		else
-			cptr_set |= CPTR_EL2_TTA;
-	}
-
 	/* Trap External Trace */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_ExtTrcBuff), feature_ids))
 		mdcr_clear |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
 
 	vcpu->arch.mdcr_el2 |= mdcr_set;
 	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
 }
 
 /*
@@ -195,10 +172,6 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 	/* Clear res0 and set res1 bits to trap potential new features. */
 	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
 	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
-	if (!has_hvhe()) {
-		vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
-		vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
-	}
 }
 
 /*
@@ -579,8 +552,6 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		return ret;
 	}
 
-	hyp_vcpu->vcpu.arch.cptr_el2 = kvm_get_reset_cptr_el2(&hyp_vcpu->vcpu);
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index cc69106734ca732ba9276ac1eaf84be3e7381648..81d933a71310fd1132b2450cd08108e071a2cf78 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -36,33 +36,46 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 
-static void __activate_traps(struct kvm_vcpu *vcpu)
+static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val = CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
 
-	___activate_traps(vcpu, vcpu->arch.hcr_el2);
-	__activate_traps_common(vcpu);
+	if (has_hvhe()) {
+		val |= CPACR_ELx_TTA;
 
-	val = vcpu->arch.cptr_el2;
-	val |= CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
-	val |= has_hvhe() ? CPACR_EL1_TTA : CPTR_EL2_TTA;
-	if (cpus_have_final_cap(ARM64_SME)) {
-		if (has_hvhe())
-			val &= ~CPACR_ELx_SMEN;
-		else
-			val |= CPTR_EL2_TSM;
-	}
+		if (guest_owns_fp_regs()) {
+			val |= CPACR_ELx_FPEN;
+			if (vcpu_has_sve(vcpu))
+				val |= CPACR_ELx_ZEN;
+		}
+	} else {
+		val |= CPTR_EL2_TTA | CPTR_NVHE_EL2_RES1;
 
-	if (!guest_owns_fp_regs()) {
-		if (has_hvhe())
-			val &= ~(CPACR_ELx_FPEN | CPACR_ELx_ZEN);
-		else
-			val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
+		/*
+		 * Always trap SME since it's not supported in KVM.
+		 * TSM is RES1 if SME isn't implemented.
+		 */
+		val |= CPTR_EL2_TSM;
 
-		__activate_traps_fpsimd32(vcpu);
+		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
+			val |= CPTR_EL2_TZ;
+
+		if (!guest_owns_fp_regs())
+			val |= CPTR_EL2_TFP;
 	}
 
+	if (!guest_owns_fp_regs())
+		__activate_traps_fpsimd32(vcpu);
+
 	kvm_write_cptr_el2(val);
+}
+
+static void __activate_traps(struct kvm_vcpu *vcpu)
+{
+	___activate_traps(vcpu, vcpu->arch.hcr_el2);
+	__activate_traps_common(vcpu);
+	__activate_cptr_traps(vcpu);
+
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {

-- 
2.39.5

