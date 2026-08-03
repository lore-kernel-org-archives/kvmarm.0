Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892613815E3;
	Mon,  3 Aug 2026 23:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798854; cv=none; b=hC0jqSHpIv7mh3zIR5pMRD8OSS7VUJrfG8yest2S4gMaKd3j4tdZwH54byoVfSSEncE+r+URafdtIAJT4nDCxMH4hZ1eWsx9F4NqyZ+RV30U6U0cajxf8u4DXOuyD0z6jgI0Nl8aPf95SPBIA8KWABn5V68+/BjtGyhuZtYaU70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798854; c=relaxed/simple;
	bh=dYXTcrQgfnk8FxnmgXg6ADstB4n1DYUswquMHXPAUUY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dhfWGS+scKEWuQLCm7u7vQnUe1jEtg9YCKAI6s/nN78RZpsoOOcD5I+x0Ke6vu0Ke3yX/p9VbtweudTk8TUGegdvBacs1jWl37nyohlZHgliTOGPAadSPBumwEYIzLxl8R34lFv/zW7sgulyuK0BOaMhMfiRM+3J/fmoD8Z8cxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioiICQYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioiICQYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CD21F000E9;
	Mon,  3 Aug 2026 23:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798850;
	bh=zoyq8Inen+VAWRiWz/um6XRtPFDfayF6DG7fxVMTx/o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ioiICQYpyvdsUZNRXOM2rAHl31xYTBontCQMRP1yN9JruPVThooXeBQk7z8eIUCAI
	 7/+jEOxzE4Fz1RBngaY78EZAzTSRnVFRHt8h8duZ9OhXvb0iwP7914dmcKcSYGoEMc
	 ERLskkc+RJZ806KHNeYi8WG7PMayK8YN3nxg7CnT9Q6P3qy7C4gsdjPskFFjLH2vw9
	 SJdHRAWKa44LSpkBAZ5AQ1hD3ts88rsye4nSHns8KDhbWYudKSmw7SauajTQNcpMJL
	 Y9O7/RKVv5WA6hjY43EaVJAN9zsIvJ3jsxoiRx2w/Xpa4BejHSAdAy13lYhhIa8T7B
	 my83Ioy9JtFiQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:53 +0100
Subject: [PATCH v18 08/14] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-8-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3010; i=broonie@kernel.org;
 h=from:subject:message-id; bh=dYXTcrQgfnk8FxnmgXg6ADstB4n1DYUswquMHXPAUUY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCgZxL3vnMN/fdXvvlTWz7G2jUymHEbk80nG
 VGlBh/oOo6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgoAAKCRAk1otyXVSH
 0AfCB/994WaXrj0FxhuZLpXWKMkoWnuJzBwOu2c5GkJcdKi3+WqEe94KqUqJGMq4L5LsrGGmj66
 rmOQoLZ7n/Zfe2AHNiEi6BLNDwlRcMm94pcaJmWXD7wjOVlyrGm3aLKmXQNNwpaP9CmkQ/ePZM7
 VHJaLWib1K/WYDMhmycFJW041eFXVFYEnOzTWKycKJYb9gXPleLX8LOv4XMSsfTy835sOftUaa4
 OIItrP8OYOANc6y7xMDxiL9rtH7CcaF7NOAqfmu9OEpnxBHJkq9KwqRkSEy37covX0WebB/PZUV
 eOaePDOxENwfTA5E+MxHnJm/hlh+mVzEV7/XSBItTbxYJLvB
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As per I_CFFNS and the pseudocode for the SPSR_ELx and ELR_ELx registers
a GCS exception with ExType 1 is generated for attempts to write to
those registers when both GCSCR_ELx.EXLOCKEN and PSTATE.EXLOCK are set.
Ensure that this is enforced for guests if access to these registers
from the guest is handled by the hypervisor.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  8 +++++++
 arch/arm64/kvm/sys_regs.c            | 42 ++++++++++++++++++++++++++++++++----
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index ee774c3b8dcd..bc012c86fcd6 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -81,6 +81,14 @@ int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
 int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
 int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr);
 
+static inline void kvm_inject_exlock(struct kvm_vcpu *vcpu)
+{
+	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_GCS) | ESR_ELx_IL |
+		  FIELD_PREP(ESR_ELx_ExType_MASK, ESR_ELx_ExType_EXLOCK);
+
+	kvm_inject_sync(vcpu, esr);
+}
+
 static inline void kvm_inject_nested_sve_trap(struct kvm_vcpu *vcpu)
 {
 	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SVE) |
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d18ada283809..387c14a33524 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2782,14 +2782,42 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static inline bool sysregs_exlocked(struct kvm_vcpu *vcpu)
+{
+	u64 gcscr;
+
+	if (!kvm_has_gcs(vcpu->kvm))
+		return false;
+
+	if (!(vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT))
+		return false;
+
+	/*
+	 * Note that the EXLOCKEN for the running EL is checked
+	 * regardless of the register written to.
+	 */
+	if (is_hyp_ctxt(vcpu))
+		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL2);
+	else
+		gcscr = vcpu_read_sys_reg(vcpu, GCSCR_EL1);
+
+	return gcscr & GCSCR_ELx_EXLOCKEN;
+}
+
 static bool access_elr(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
 {
-	if (p->is_write)
+	if (p->is_write) {
+		if (sysregs_exlocked(vcpu)) {
+			kvm_inject_exlock(vcpu);
+			return false;
+		}
+
 		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
-	else
+	} else {
 		p->regval = vcpu_read_sys_reg(vcpu, ELR_EL1);
+	}
 
 	return true;
 }
@@ -2798,10 +2826,16 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
-	if (p->is_write)
+	if (p->is_write) {
+		if (sysregs_exlocked(vcpu)) {
+			kvm_inject_exlock(vcpu);
+			return false;
+		}
+
 		__vcpu_assign_sys_reg(vcpu, SPSR_EL1, p->regval);
-	else
+	} else {
 		p->regval = __vcpu_sys_reg(vcpu, SPSR_EL1);
+	}
 
 	return true;
 }

-- 
2.47.3

