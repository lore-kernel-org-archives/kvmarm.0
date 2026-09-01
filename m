Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBB1263F4A;
	Tue,  1 Sep 2026 21:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299468; cv=none; b=Tp+4oJN3mMPDJMzOqXLLoDjtkRwxuIQVxl2Xs350MQu2o7GRPaLJKN1SDMEBLmKIFSRAjw7GRf+pPCEhkEovYJht4cWTEqCmlRas+E3aWWtJJ4W8pSGO4ponqyHUztHskEmYu1lQPFzaVNzVJdHUhkjI7P4XJbcU7If1HBsDuQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299468; c=relaxed/simple;
	bh=myX2r5YA1lyE6PF9X7vRwEe8NUR6TEzLmdONy7VX99g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oPuYkSebmsnsKuBrE5xJNCBtIdzoGazkhAYZzupeyHuoatYHQ7QX6eNc9PmwvzlKM0X/Cl1JzHV5yoNWEr+x1xIhJ2/+I0bdDViLzQBr+HOw/yxBd98Or6HuQqcGRWIywI2tpJIJEKZs+MSk1fYHkuVoYbfm5vglDEszO7lhAp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCUDSupB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCUDSupB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB9E1F000E9;
	Tue,  1 Sep 2026 21:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788299465;
	bh=d7n93eEAZcqp/uvmqepwIrUhrufzf1uDi7N0bfkYuMM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hCUDSupBguzYCJSzjIN8jCrAOnRGpWVOTC+sanb+LjjL3+NHLC6S/X5pkINtIwAg6
	 8zBjmcZg8T2CLfG7b+r5CGvSEWLG/QDm4xdMqtm5MeMHtomY0Kk+KlW3a3M9kgTjEc
	 UAaHkMtq5up6DWWDkMxFl2WiMnIQmf2VNIabN8tAutgOqJCfzeLVzwQ+PldmRjZURi
	 M3GksT4gOfQfw9IsbFURwPVRDK1woHem4PJ65YEfYo3swRQxFt/QgVs84hqkSunS28
	 JBmcnKY5YZOpFfdTmLfN2DC83UASDVjSje+36ev4BdmaNEhTn8MysQPaBtzxhuyb/t
	 0dN5NcAfikqYw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 22:47:06 +0100
Subject: [PATCH v20 08/14] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-arm64-gcs-v20-8-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3010; i=broonie@kernel.org;
 h=from:subject:message-id; bh=myX2r5YA1lyE6PF9X7vRwEe8NUR6TEzLmdONy7VX99g=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBql0iivg1NgLATu5WNvTFVbJ7dugWm+35vKG3Qb
 NQBKJxFH0yJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapdIogAKCRAk1otyXVSH
 0NfzB/9uir8kEpaV0c5Lfpwjc6r8ijRsibzD0J0REkxIG0i8cO38HIoEix85kGdmnKaObcKiprY
 9HoJ5z5ZQ5utr4kVqrPU13zPEGcmBDVgMOWt+uFNlxuGrmfyh5VjUxwbGJfd1iUPlhJs+QToEzN
 Fhy0AGKdJjX+79uhlNrmW0D2fzewV+OFXJdGHxTyl63CCsy2WARZZnu4Tn9402xE+cQrX+bRJut
 3RUba+1JExMN6oOVH9t2Ifv7x/gWV/z327McCpmjnwSjD1OB8Ti2dKhmdQ+nNChhvINfHX1mluF
 aIxqsdwgrqGjL/FiDEaMJKGksdiF+0IjdzQhK97jFtPPzgas
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
index 0cd91b3d6c82..e47ab38327de 100644
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
index c5ce18b3f7d8..1f80c26a9839 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2866,14 +2866,42 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
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
@@ -2882,10 +2910,16 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
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

