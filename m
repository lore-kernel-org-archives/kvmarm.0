Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8349184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04DAC433D6;
	Sat, 12 Nov 2022 15:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266289;
	bh=16TcJUXx7TByNWK3ZREePc2xQJ7uGGHCMViO4LPLnVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzSkdtQW0GY4QsAPp8JjQw+4w4OGCSHDbYFXW1IwK0E4GvEh+6RzmN+SngnrDergn
	 N5HzA+pD2zCKHWKD+qO6FOmS9tWFxWNWVIN19A/N8tM85ZhcaodWTyGgMjFguIEK89
	 zcrxu7/AQBYuXc+x/Iynk4w9/ozmdDmwhGHSVpHmbICj7AMFZYESkFOkTyN0NwLtlV
	 BnpZINIpeOjZ8rNDKm0PLsiUW3HCLU8IiA6eKI1+3ACn4CPRxOhz9igwPYLV6jIgcR
	 e8w9+13MIFraxVke9a2O/OIOFAOIa04Gu1RRLBT/u8NSG9xxTO08TwqaVxIH1e4pEH
	 dfQpaOv0ncsQw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 09/14] KVM: arm64: Hide FEAT_NMI from guests
Date: Sat, 12 Nov 2022 15:17:03 +0000
Message-Id: <20221112151708.175147-10-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2080; i=broonie@kernel.org; h=from:subject; bh=16TcJUXx7TByNWK3ZREePc2xQJ7uGGHCMViO4LPLnVU=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7juXZHFkisEYb2JU6vcImxPS9r6K29A3RYLFP7v DyMOLwCJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+47gAKCRAk1otyXVSH0IlRB/ 4qQx4KGXZDq76v2g6fQRHSKhLC8FMDi8ZhLREI+AzOOgwvE4p/rhRjAP5+/W1I1pCAXMHl99HExHdf w1d1fnxSApfGg5pbOYwXZm/OEP1azFc5MemNBin3To1aii0QCvNvCpF/FwBDiPFLqY0Xa6RCIS+1MR jenH9P2VjrmPkiZl1prRr2qePCQx4dScFOFc/2OazH/AbFQBup+Hd7vOA8vovvYbTwl496RboM0o5M H8DXNcc4sV2oLF/FfwKW6f+Apl/ZJPwEEExz+wJVHxLIwTYA5hvi+45c9NNm+L4ZMZl/VNa1OuPXMj ISYJw3ssw18gfF6UsuS6y9sHtCN+CL
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

FEAT_NMI is not yet useful to guests pending implementation of vGIC
support. Mask out the feature from the ID register and prevent guests
creating state in ALLINT.ALLINT by activating the trap on write provided
in HCRX_EL2.TALLINT when they are running. There is no trap available
for reads from ALLINT.

We do not need to check for FEAT_HCRX since it is mandatory since v8.7
and FEAT_NMI is a v8.8 feature.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 6 ++++++
 arch/arm64/kvm/sys_regs.c               | 1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6cbbb6c02f66..89e78c4e5cce 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -85,6 +85,9 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
 
+	if (cpus_have_final_cap(ARM64_HAS_NMI))
+		sysreg_clear_set_s(SYS_HCRX_EL2, 0, HCRX_EL2_TALLINT);
+
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
@@ -93,6 +96,9 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 {
 	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
 
+	if (cpus_have_final_cap(ARM64_HAS_NMI))
+		sysreg_clear_set_s(SYS_HCRX_EL2, HCRX_EL2_TALLINT, 0);
+
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3())
 		write_sysreg(0, pmuserenr_el0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f4a7c5abcbca..1bd4d4109a05 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1092,6 +1092,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
 
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_NMI);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
-- 
2.30.2

