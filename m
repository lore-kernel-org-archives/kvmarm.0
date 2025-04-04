Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D2D1F4633;
	Fri,  4 Apr 2025 13:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773285; cv=none; b=S+x3ZR0Cl6d/BkQYMd5ekg2fpRzJn7BIe3xK8OQXGOcKRvJ3vd6scvd32aCrrgRf92BjSUSeZUrUlzT31u50FGnENteQnwO/IzTk3MUFVYjPgK4CNfiwpTb2ReD8QNMusWR30f+hvFzCWuRuEwwrWclWYh9JhfK1En2ovhqCBpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773285; c=relaxed/simple;
	bh=xyb9ktUTYx4rT1MelffKyVOs0iYTO0lKjr3wBYum9u4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X7r8pWH5bb76U8NWvVe5SG6uJYLUIZE/XiMqR3oOGOzwRWLCHGRFb15vPXKUSpKPvH22rksQ7d/+PHNIsRoQoZlhlXUoZpHB0LTZqpDoPEZJqyiupyjkXifFKhGPf+o+pdOD/usC/W0Be9svGnTXq3e4e+aytFUvc5mDvApPBZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YdeJS5Zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YdeJS5Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37524C4CEDD;
	Fri,  4 Apr 2025 13:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743773285;
	bh=xyb9ktUTYx4rT1MelffKyVOs0iYTO0lKjr3wBYum9u4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YdeJS5ZpAhGPE/KnTmUEaQ3xwEaCk0/WaXyt0kflFeC3daCjNxCLeijJFjuf6NAat
	 Ed751g9kW8aEhd8HrquBCNIA+UnqA7h+Aj6D8Nd9rXSADNwwWoJRkzb7iedTPGdRew
	 FJntEoVZUGcg+QYEBJ/gW5RCl2MLT8XWYNJC6dSnqTrn0JISliW9XWKY3/N21DVmGu
	 V6Gjb8LUT3IpOOpgcT2KwrFBJ/nMBoxU9Tra2hhcBJeV+HzG2u53T0Vclt/37QHv2T
	 nEtH84cErW+wLDF5IUXPuhig45TKinic9Y53hW/6wil5pp80aSo0SXpnwDfXt038d3
	 /S+WAaIYLdaEQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Apr 2025 14:23:44 +0100
Subject: [PATCH RESEND 6.1 11/12] KVM: arm64: Calculate cptr_el2 traps on
 activating traps
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250404-stable-sve-6-1-v1-11-cd5c9eb52d49@kernel.org>
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
 Fuad Tabba <tabba@google.com>, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5520; i=broonie@kernel.org;
 h=from:subject:message-id; bh=qvm9qyLJYigRBXj8TcEQBujrpaXuVewbDgg+IEJx/RI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn7941ZPDRUYGl503npn9lrEuVyJL+B3CYx9Ss3PnJ
 9d47rXyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+/eNQAKCRAk1otyXVSH0LTpB/
 9VPFvByOqTzxG8Dq/Y7pcrVQ9NEKVsPxgwkc/Ul0oODJOmiTI3G6QF6S1Q7z0WTBtVeS5bdQgCWkmW
 Y8fZAY4dMTJJfz6dmWpX55EwliV/7UdgH8dfF6V4kY/CdGfoqyFpoOtqftbxG3/xLL+hiQ7GRZFMfs
 IbPaO0zog9wAqvZx0ZsQDkqbiwiFuLYLUjmq4eeS5qg5n1rlLuKXtSH5YgKFzpp3ij8fX6pGkclkE1
 Vg20FrZXT5pmwdKHrOkcXG8rx11IZj7ALaxLe3JHnSr2J2Nr1Nx3n1w4aRngPf3zbqT6IRbi8XO5mL
 Z385hdZNOArVBmGYaPz3jApHWSuqyX
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
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 15 ---------------
 arch/arm64/kvm/hyp/nvhe/switch.c  | 38 +++++++++++++++++++++++++++-----------
 4 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 757f4dea1e56..c13a0d5907e8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -330,7 +330,6 @@ struct kvm_vcpu_arch {
 	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
 	u64 mdcr_el2;
-	u64 cptr_el2;
 
 	/* Values of trap registers for the host before guest entry. */
 	u64 mdcr_el2_host;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3a05f364b4b6..4629505d5fa8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1230,7 +1230,6 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
-	vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
 
 	/*
 	 * Handle the "start in power-off" case.
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 85d3b7ae720f..93586bf80ec9 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -17,7 +17,6 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 	u64 hcr_set = HCR_RW;
 	u64 hcr_clear = 0;
-	u64 cptr_set = 0;
 
 	/* Protected KVM does not support AArch32 guests. */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
@@ -44,16 +43,10 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	/* Trap AMU */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), feature_ids)) {
 		hcr_clear |= HCR_AMVOFFEN;
-		cptr_set |= CPTR_EL2_TAM;
 	}
 
-	/* Trap SVE */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), feature_ids))
-		cptr_set |= CPTR_EL2_TZ;
-
 	vcpu->arch.hcr_el2 |= hcr_set;
 	vcpu->arch.hcr_el2 &= ~hcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
 }
 
 /*
@@ -83,7 +76,6 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
 	u64 mdcr_set = 0;
 	u64 mdcr_clear = 0;
-	u64 cptr_set = 0;
 
 	/* Trap/constrain PMU */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), feature_ids)) {
@@ -110,13 +102,8 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceFilt), feature_ids))
 		mdcr_set |= MDCR_EL2_TTRF;
 
-	/* Trap Trace */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), feature_ids))
-		cptr_set |= CPTR_EL2_TTA;
-
 	vcpu->arch.mdcr_el2 |= mdcr_set;
 	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
 }
 
 /*
@@ -167,8 +154,6 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 	/* Clear res0 and set res1 bits to trap potential new features. */
 	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
 	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
-	vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
-	vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 844c466f1b1f..58171926f9ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -36,23 +36,39 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 
-static void __activate_traps(struct kvm_vcpu *vcpu)
+static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val = CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
 
-	___activate_traps(vcpu);
-	__activate_traps_common(vcpu);
+	/* !hVHE case upstream */
+	if (1) {
+		val |= CPTR_EL2_TTA | CPTR_NVHE_EL2_RES1;
 
-	val = vcpu->arch.cptr_el2;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
-	if (!guest_owns_fp_regs(vcpu)) {
-		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
-		__activate_traps_fpsimd32(vcpu);
-	}
-	if (cpus_have_final_cap(ARM64_SME))
+		/*
+		 * Always trap SME since it's not supported in KVM.
+		 * TSM is RES1 if SME isn't implemented.
+		 */
 		val |= CPTR_EL2_TSM;
 
+		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs(vcpu))
+			val |= CPTR_EL2_TZ;
+
+		if (!guest_owns_fp_regs(vcpu))
+			val |= CPTR_EL2_TFP;
+	}
+
+	if (!guest_owns_fp_regs(vcpu))
+		__activate_traps_fpsimd32(vcpu);
+
 	write_sysreg(val, cptr_el2);
+}
+
+static void __activate_traps(struct kvm_vcpu *vcpu)
+{
+	___activate_traps(vcpu);
+	__activate_traps_common(vcpu);
+	__activate_cptr_traps(vcpu);
+
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {

-- 
2.39.5

