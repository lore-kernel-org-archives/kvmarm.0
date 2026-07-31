Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AFB42C507;
	Fri, 31 Jul 2026 12:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501479; cv=none; b=NpPwk66bZtk2AjGCWwfS7R6oWMbXmfdm3o1O5sf8LdQcIvkJWIA3UG3nP5auNNgZIUAtO3zCfgI6ZJrjoxGKDMkybdpQzi7NKgMFJLWndrtWeBSmzvkzSIC9BANg+YwkDjx+Q6ULlWtf5j0+w2S8n1RGAJDCoTPgrRGN1o1ymbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501479; c=relaxed/simple;
	bh=oWZdUmuK4nAtItYIMoZ1Nyc4/gTFqii47mmxgcveKIQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G23IWCASynfNj6+KUE5VOpIMPWSMZCibaKJ/WC5+I7VT+T1w52RENyD9F3p2M1vlUwjz7aSPOh3GeM+ac01N+lMly7Dhv5zFlXg4JdSLwjS6+IIfFG+7sHpfnxTJPMtjjO2TQCFqDwMkaUnIhFjr1pVGhy6mTFds01ZIA6dR35I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=biHSZU6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="biHSZU6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECB71F00A3D;
	Fri, 31 Jul 2026 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785501476;
	bh=P3e2rBRtLDRgrOIaI1elxNnJ/2QhoA9om1fNfFAW7Yo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=biHSZU6kYX5v/wvxBwgrqds94+SRUsdrs9cFYmKK2XfdaaWDUHcf0EmH/451Xh9Qy
	 0gmqeXJQ3gaxq/yhEniHylXGmwSruAxDjLnNZdyLAvMj7L7Qn2Oq9iv2uHKCAp/8YI
	 hLqIgCOAEo/E6WbmdYvHntzLnxUJc0Axhxf5a/RaauEKTRmODjOu4Eu4BxCccQiS4d
	 JDg0BcjawbsF0LCKcQ7756qpooTFVYLgJ9Py+mEYwxue00ctkomE6fFiF0B9P5AyYq
	 +Z/MeYLVKUs67p7UpkvgxiaIxeI9b6FR2pckj9k8oYQfdJnbTIMGzdYIjOdf1dnNWX
	 gmsRmrbgJkAog==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 31 Jul 2026 13:25:46 +0100
Subject: [PATCH v17 08/14] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-arm64-gcs-v17-8-5e39ca01b14e@kernel.org>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
In-Reply-To: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
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
 h=from:subject:message-id; bh=oWZdUmuK4nAtItYIMoZ1Nyc4/gTFqii47mmxgcveKIQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbJcCLPFgrfQ8svgEbiadv+hYFS4UMRXY1yBSB
 f+PnSAFLfqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCamyXAgAKCRAk1otyXVSH
 0HZbCACFJ9H+iuLy41JSKNoCVsfPYquTy02+GfUpVMKkTTYKxB+OUMC6X49vOrXNHgw4pyQuch2
 gKjY9JNWIpqojyCMFmUKeHMcSHLxFf8X+6MQAn6r1V4wTT4I31KiLHYdlbkTjGMaE/NFldVmh7m
 IaTG9IgcDwxmgBQmID8dHquSjsKnMOeiGwemb/kQvFcnCMd5SMR9XvhhG3+Il/YHNqL0E+NRFTy
 323bnRPy4jEhNj+/z71mFsC/r27M5NbLph+tMxF2IQ1AY+Y6Uor0MXouDBZaWrPu44LXgQE9M0J
 lOL+cqn/eRLorIGFfCzxhqfOSob2nRUmOiyDwOSWa2n1Hmi9
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
index 1a1e45d64552..3d9f4eb9d093 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2776,14 +2776,42 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
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
@@ -2792,10 +2820,16 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
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

