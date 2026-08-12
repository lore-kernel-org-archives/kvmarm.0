Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB073672A0;
	Wed, 12 Aug 2026 19:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786562023; cv=none; b=YaoKNAc6iVDQIpautcYruoVTtipQEhtCVk5bxNZC0TLhKeGMcX6Y7pwUrSpfbxZvLXZwD9mOwIcMLS7dI+IJq3BuuuyJNWGMkGte+Q8ymm5+8H8gtfdY2aD9Iq8KPK7QLx7u8XBa0db2Wj+B1IZlmanwq5lfwHwNAtdiEhI87F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786562023; c=relaxed/simple;
	bh=LgwwfLot59z6LxND49YWDAU1QqTEQ64y1Jg8Fmz6GeU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gMJTi0gK+gLxIqVsZEkZMurTmAYmYsf9opoD+G81sG6nDbELPGmN2kK9F8fpYH5LtfZWldVv91/VYdoBKoNc8IFGZI2Bwb8u956bkJycCY136m8Wetrp8l2wKIIeir/4xbXkg/Zkw13n9ZKi8mSRqCYH+0y9HE6NNvAKcjX/YuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lT0z/62g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lT0z/62g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5C31F00A3D;
	Wed, 12 Aug 2026 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786562021;
	bh=Xrro5Riy4X3i4jiHQrka706bGBWW4kkidtMzTaWIrHI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lT0z/62gLv7bsHCpxLcAAzhzgXjwGOVCQ/vA4PBaVjNIpWS+RrFxsfUMw8tmcX3ez
	 Kea2AHO7hXF1BRiYgjXo9y4TFiAYAjbhAN13rsn9N58kZ0jJ9maBIxkaZF4IoIzWbZ
	 JlLxGA1gaN9xX+eZAq1o17hH1s33+roBU4a5/78MzHsqfsf8nTksqbjjbSDjBnTlqx
	 9YYMqUegtoONwqDyohBtfBDjtxMW5pPFoDgpGCg5Ba3ViVV84isLp+RS1T64KJHYAN
	 loUx3HSrO1oqZlTKj9xyn9fHhS9DCASf6ZJ/trx0RYZMrtGcNRnEuxzVXIHXQ3AbNQ
	 ogdz0yff+xYfg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Aug 2026 20:12:07 +0100
Subject: [PATCH v19 08/14] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-arm64-gcs-v19-8-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3010; i=broonie@kernel.org;
 h=from:subject:message-id; bh=LgwwfLot59z6LxND49YWDAU1QqTEQ64y1Jg8Fmz6GeU=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhqyaowcCG1+r16krhC1r5zP4vmHPY7ONRTNkjebtbGJ6Y
 Mjl3CLUyWjMwsDIxSArpsiy9lnGqvRwia3zH81/BTOIlQlkCgMXpwBMpNOe/X/x5CtpdYEm7C2v
 BEzjLhbWH/iSbn5qdZ/QoRT5H/9umNxoXnL3fsHxQwlTo0Q2ydcXzL39x/yLTZGw56satttPN6z
 kecmmy6WWn+iyQm3O/Pwihpi3MUFFKoJbQk0VCj28vF5onj1SdFF22i/dM3v7dOb/LKmVLr0/J3
 IPU2pyYblCtMbqNVJrWtTrU9if1ddE6RqsEHU+1Hsyf4OP9AfTPY9WK6SfWH3m1nzxW+Z6D2e7d
 22olj8uynPEdbu13MWks5dk/lrIxL4I69tquPMVu2dfpim3cUtOgse0P74s81d+cpplL2L53a5o
 yuOePN/3C9M6Ih9JdliKPC06vktebuNEbkbtv9lMDWrvAA==
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
index 6aa4463c3d3a..bd1d5b778b9c 100644
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

