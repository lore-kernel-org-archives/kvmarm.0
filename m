Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D91530DF0;
	Wed, 30 Sep 2026 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804965; cv=none; b=oHgQc7vuw3KkGPZwzWpgqrsRep0UzL8QTLzjt60SlDL7Me1kNf//qm4GaDVfssXr+o5mK21N1mfhld9dqEbfY7P/7FG/6wEjCJCVnlUAOdX2nXwdkFdoS+N7KPNkh28kgwzQ9VtUdH7SbFSmFhdak1PwYk5yn6mxuo8rGP5B1qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804965; c=relaxed/simple;
	bh=p2SMLjfEfZRBygQRA7fMdB/WEVVEAeNCJ7sGMUq/zOk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tueTaPLpJf3KWydXyThec05QtAzzZDcsP0OvRX73QKkvnAN7JlGV9WUJMQTpw6j8U3sZmDWLi5kI/2QJdgKrHkYhFyEiQr1W+/D5Szr0ulrKP9JEpg+ssPsNc2NbxUxUSV3HnTgQM0b4crJfONIM4tN1+Cg/tfO9tyDTL/blUV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PoekURoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PoekURoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70611F00898;
	Wed, 30 Sep 2026 21:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804964;
	bh=Zd/+Jyw6bZX7UUcetdB7IGFu9m8nLhB6L7sX9bIi7t8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PoekURoQSMZiBIMi64huDTrJ8XyurMMyps4PwgX8Jhpg3Qox/1FqQldgWy/SBpDAy
	 w/bVQNh9+cQ4vXg9WaBkr0bguVRE0vfQB5UUsbfh8yHjFDDUnyFKo9Vmr8M4MDPyUA
	 anEC/wJx4K5PkR3bxoxobqenQV3dhJR58/TwMYrUony8jbyiVOBYm+psCYp+AIK2tX
	 K+lVvMqQa8jZNBDCEXiBZ/ih2nPLB2bE88W8zQtlbe3U0DoxP37ZSEv8jGNDIjZMph
	 BoDNpkcAYNLYclqMV6lWdYdWd/79chIw7twTJBXctKXCMyGv14EFnGD5Yhsgt+UK4U
	 ++dttQ7HbmyQQ==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:18 +0100
Subject: [PATCH v21 08/15] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-8-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3057; i=broonie@kernel.org;
 h=from:subject:message-id; bh=p2SMLjfEfZRBygQRA7fMdB/WEVVEAeNCJ7sGMUq/zOk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO52fYAk0djW5voyppA7cUSGG3uVSRxOiiRx
 JhEDbivJR2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DuQAKCRAk1otyXVSH
 0A47B/9vXV2XCZ6uLeUIFTwXHKySyUmCeMIABlrqUbh0HBy2DSdhuNhtCUJKVT+x5TEVGqHJZGz
 L12rQ9zN7WuGhDxeCCCC9mRC6Dwwuf3tBCd0w8JACxqvsnWKlOW5fPlyHfDfFxBRgeydVOc5dN0
 aZcsRdyj1mmww5kjbPCXanopo0fgnvnEI1ktiHCJaa4HZvU74IfpUMP8PL4DhaO2R6/0kyT1D2s
 q29bZa69GL7Bya0uou1HKWKGm86gASDjo6aydBCBNLs26KAOnkO0uN1j4qtkfkm2EqsqYPn4IvU
 g9TD4cUe+5McxzCFL56ctMFXmnZYHub5lDZpCB+1oep2x4Je
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As per I_CFFNS and the pseudocode for the SPSR_ELx and ELR_ELx registers
a GCS exception with ExType 1 is generated for attempts to write to
those registers when both GCSCR_ELx.EXLOCKEN and PSTATE.EXLOCK are set.
Ensure that this is enforced for guests if access to these registers
from the guest is handled by the hypervisor.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
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
index 823460106de8..faecf4657ec5 100644
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

