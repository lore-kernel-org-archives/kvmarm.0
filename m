Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514C54F7997;
	Thu,  9 Jul 2026 18:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622490; cv=none; b=fQXNqkhpI/h6P+zFas4+Y1YSuWzZqwVrIrX0SSix+gqj5YeXfugxTpJQhel+fXzZPXZBCv3U1E0BOv5gdT9f4QSSapHR2Wdp0Y/f4KQ0Y1wRaISb20AtFACv+dOdkSfafw9lERMCrpww+XTqqGmzMbSLctpRQTDJOVuuu3SRbfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622490; c=relaxed/simple;
	bh=cQOTqwdunjLIZgL4rF+SwwGCqO26Oh5PN9HCvtmvnxc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Bj5j2X3PS3oAmDWTfhV/7br+opTM04rwg5XpY6At+TJVqUGC09FUZ5q/pFCVKtLd4oLh28c1vU9vpsxmqhhNlxDmKY941rUAOU04neEEcCFsjVz6vcU7BZV7V3ZrPMhuqqvE5ntGz5D/ZflqObZsJ6Uz1WifNq30QLbqI8mdBQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6igcleB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6igcleB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5CC1F00A3A;
	Thu,  9 Jul 2026 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622488;
	bh=+zsbnn3YS/GuNqXb5/oAI/TG0iEFK1kmPP5/xMQf7S0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P6igcleB1FnD31LovBqf5Z4AMefvMz8yE0Q+kXx6GkLAAtSiN1pbCuGoCozQHHIZB
	 U1bi4keeVTHOYXmXdCm4zKgCzGR7DfuWBtiYuhSxETOdaGIySGJfsfwcZo+3U8BV89
	 5+oc0bfpTieJUcDVESTjbtGXssr42CEnHicKoagXO+r4vv+WEzWWzEQKKwGCezPQaN
	 Ood0wR19aZbYM8DZgAsAYeU4PYoiT/qXjyMXdtf9KeX06s1E0v4D9rNmDzqphYIqs8
	 BzZsQIB9tkqRI5gKTyxYnYjq/9HCj3PKUgPZUhKTvupI6LfFv3h1aPeAIJp/Qn1OdX
	 V3/4Y98Dz3wAA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:39 +0100
Subject: [PATCH v12 18/29] KVM: arm64: Support SME priority registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-18-d0301d79ef58@kernel.org>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6235; i=broonie@kernel.org;
 h=from:subject:message-id; bh=cQOTqwdunjLIZgL4rF+SwwGCqO26Oh5PN9HCvtmvnxc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+r4MjZuB7zMChKgyrzW6IU5hQAp04ROuoCBt
 41AaprhheyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q+AAKCRAk1otyXVSH
 0IFEB/9yQ5ZSe/X7bAP1zbd03UqzI3xw/lXAnBAIDTqcgPmvKGeQNJhWQjNEu3sDnUMAKexCLT+
 U09NOqg2XrfX4N3HBinvi/XOK6lZq2VHXBFrXw3srsbcQNcyX8Pz0TqKvkBw4R9lw40yO/CPIoN
 ivgdyu8t2OwhChCQ9KCtaRzZR2ZPkvrOtfVSYkgz9vbdOmYekS6bJMB4Lc64ODUF4Bwo3Pfuhyb
 QisSw9H6AeTQOlGYWuja3PmB8c7ZfUAykBWWPxb8X2axQVyqcnIDhUmy6Ia0u5l+H/XLh7pogcA
 uLCPCt/aXf6Vk4Xz+pR0YenQToFk4jOLaf6wljlCUi4q8aFl
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME has optional support for configuring the relative priorities of PEs
in systems where they share a single SME hardware block, known as a
SMCU. Currently we do not have any support for this in Linux and will
also hide it from KVM guests, pending experience with practical
implementations. The interface for configuring priority support is via
two new system registers, these registers are always defined when SME is
available.

The register SMPRI_EL1 allows control of SME execution priorities. Since
we disable SME priority support for guests this register is RES0, define
it as such and enable fine grained traps for SMPRI_EL1 to ensure that
guests can't write to it even if the hardware supports priorities.  Since
the register should be readable with fixed contents we only trap writes,
not reads. Since there is no host support for using priorities the
register currently left with a value of 0 by the host so we do not need
to update the value for guests.

There is also an EL2 register SMPRIMAP_EL2 for virtualisation of
priorities, this is RES0 when priority configuration is not supported
but has no specific traps available.  When saving state from a nested
guest we overwrite any value the guest stored.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h     |  1 +
 arch/arm64/include/asm/vncr_mapping.h |  1 +
 arch/arm64/kvm/config.c               |  4 ++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c    |  7 +++++++
 arch/arm64/kvm/sys_regs.c             | 31 ++++++++++++++++++++++++++++++-
 5 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e8c2907aacd2..35339cbf23f9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -558,6 +558,7 @@ enum vcpu_sysreg {
 	VNCR(CPACR_EL1),/* Coprocessor Access Control */
 	VNCR(ZCR_EL1),	/* SVE Control */
 	VNCR(SMCR_EL1),	/* SME Control */
+	VNCR(SMPRIMAP_EL2),	/* Streaming Mode Priority Mapping Register */
 	VNCR(TTBR0_EL1),/* Translation Table Base Register 0 */
 	VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
 	VNCR(TCR_EL1),	/* Translation Control Register */
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index c3bf92ac52d4..f6152fbbfe03 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -45,6 +45,7 @@
 #define VNCR_ZCR_EL1            0x1E0
 #define VNCR_HAFGRTR_EL2	0x1E8
 #define VNCR_SMCR_EL1		0x1F0
+#define VNCR_SMPRIMAP_EL2	0x1F8
 #define VNCR_TTBR0_EL1          0x200
 #define VNCR_TTBR1_EL1          0x210
 #define VNCR_FAR_EL1            0x220
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index cb6f3ea556c2..f71edb59106b 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1677,6 +1677,10 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
 		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
+
+	/* Emulate RES0 for SMPRI_EL1 until we support priorities */
+	if (cpus_have_final_cap(ARM64_SME))
+		*vcpu_fgt(vcpu, HFGWTR_EL2) &= ~HFGWTR_EL2_nSMPRI_EL1;
 }
 
 static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index be685b63e8cf..0fe7153eab08 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -80,6 +80,13 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 
 	if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
 		__vcpu_assign_sys_reg(vcpu, SCTLR2_EL2, read_sysreg_el1(SYS_SCTLR2));
+
+	/*
+	 * We block SME priorities so SMPRIMAP_EL2 is RES0, however we
+	 * do not have traps to block access so the guest might have
+	 * updated the state, overwrite anything there.
+	 */
+	__vcpu_assign_sys_reg(vcpu, SMPRIMAP_EL2, 0);
 }
 
 static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 91ef82dd6b1a..c43cb1b8fb68 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -779,6 +779,15 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+static int set_res0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		    u64 val)
+{
+	if (val)
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -2054,6 +2063,15 @@ static unsigned int fp8_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int sme_raz_visibility(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *rd)
+{
+	if (vcpu_has_sme(vcpu))
+		return REG_RAZ;
+
+	return REG_HIDDEN;
+}
+
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	if (!vcpu_has_sve(vcpu))
@@ -3441,7 +3459,15 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TRFCR_EL1), undef_access },
-	{ SYS_DESC(SYS_SMPRI_EL1), undef_access },
+
+	/*
+	 * SMPRI_EL1 is UNDEF when SME is disabled, the UNDEF is
+	 * handled via FGU which is handled without consulting this
+	 * table.
+	 */
+	{ SYS_DESC(SYS_SMPRI_EL1), trap_raz_wi, .set_user = set_res0,
+	  .visibility = sme_raz_visibility },
+
 	{ SYS_DESC(SYS_SMCR_EL1), NULL, reset_val, SMCR_EL1, 0, .visibility = sme_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
@@ -3818,6 +3844,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
+	{ SYS_DESC(SYS_SMPRIMAP_EL2), .reg = SMPRIMAP_EL2,
+	  .access = trap_raz_wi, .set_user = set_res0, .reset = reset_val,
+	  .val = 0, .visibility = sme_el2_visibility },
 	EL2_REG_FILTERED(SMCR_EL2, access_smcr_el2, reset_val, 0,
 			 sme_el2_visibility),
 

-- 
2.47.3

