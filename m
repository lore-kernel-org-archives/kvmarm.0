Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BD437C108;
	Mon,  3 Aug 2026 23:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798849; cv=none; b=Iz7WUmuTDlpWVidIghcUtCeq6ZPtMa8M4qQdFOOOqB4NNHtvQkgRX/Tl1uQNbtRTwSiFUPvZGSdFpNRp/xLwBMV7IjjfF4QX6HKivJGiK2pSZjlnvn4yVEhCPs9/7e+2ZuZU9emmESIzlWetlEO+O/yhbqs9r4SwO9Sr29/ajg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798849; c=relaxed/simple;
	bh=ZU9mNb8TUUW8fTZnFvfc37aP+mNNUc8as/YCprUO5Nc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dJOV9wS6LdyE88HzG0qPTY9Gq6rFlgaIe8VO60NrnMX36Z7rip0mVYjHoGyUpZUO6lHR7+f+WrBmlxwkS2h1MyRpdQuvyGoTDjwso7pIUnxe15Tsw1lvRQ88prTR+dbwEKWQ4mZvxaIFDtDz5uqwbiJio8/fyoedsa1pD0BYLco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtI1EZ45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtI1EZ45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7131F00A3A;
	Mon,  3 Aug 2026 23:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798844;
	bh=DulmpQOh2UwOXi3qlin3hjgVoAUJhkyK/puVXl2lmtE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TtI1EZ454Sle8DrWdHjlktGs9gAblCXWealtta2X8IbB91P/T42f1lQ3fq2R4mYgw
	 aRRJsN8OXhIlr5md9kgI6JfRM3kAbH7I0C9SiWAyDDlS4nvK79glHA9yTkj0IQjXWr
	 os6jo9pJB7yBwch5z1ioURE3S2GxeKMKz6F08jvonnpgu8C9ZP+lk5KecJpK4ib642
	 3sNkr2cyG/6Wp/YXnaNAExT/FUqlJ9XtpCtZapUVZYzo8cCCp6M/Lu37EN4xKtGUYz
	 k8fijf3wpWNLkUG1xUAolOZt/WHEEwIQjCWppSbFP2tScsuCaBqEDT59MIanAQGgM8
	 3ydWb1H8WF9yg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:51 +0100
Subject: [PATCH v18 06/14] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-6-fd8c40f5ad88@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3924; i=broonie@kernel.org;
 h=from:subject:message-id; bh=ZU9mNb8TUUW8fTZnFvfc37aP+mNNUc8as/YCprUO5Nc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCe9LWKDOOy/w6LJ24GOuVZrMRkAuvQyfwya
 ZQ8U/jQ2reJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgngAKCRAk1otyXVSH
 0IR/CACDgp9eOXL4EhgWzixMCUIIWislVrhGoffwqK+a5vQQ/C8FKJvk/vKbto4Idh0/T/rgGFu
 au755xtVWtMpnDPoxIX6lNcSe7KtiAw9Ug9tEYjVV9U1lD6a0G1fFrzYi/8MkocoUKGJEWoN/OL
 lzlZN/EXewoWiF0BfkKOgHtZTyYFg8TxjyJgEAN9PYMLXPflCncWoLDARsS4nTq5JsjfniYxbAm
 Ev9uJ/njyH6KkGm7kWU5AHxcU7hfDf5CDPUcxZHv/o2ps3VfcHFiTENyUkmGJBmW9yJkVWWWPFQ
 DblgDA7yLD1f/kzbNyMzlKfio3t+DkxCve5YvAe9ZwP4j4h8
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As per DDI0487 R_TYTWB GCS adds an additional case where an illegal
exception return can be generated. If all of:

 - PSTATE.EXLOCK is 0.
 - The EL is not being changed by the ERET.
 - GCSCR_ELx.EXLOCKEN is 1.

are true then the return is illegal. Emulate this behaviour when
emulating ERET for nested guests, while we're at it using the symbolic
definition for EXLOCK in SPSR.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 39 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c     |  5 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c     |  4 ++++
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 012d711034d1..b2343f67d15b 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -240,6 +240,45 @@ static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
 }
 #endif
 
+#ifdef CONFIG_ARM64_GCS
+/*
+ * A subset of the pseudocode ELFromSPSR(), validity checks are
+ * assumed to have been done in code that is not GCS specific.
+ */
+static inline int exlock_el_from_spsr(u64 spsr)
+{
+	return FIELD_GET(GENMASK(3, 2), spsr);
+}
+
+/* See IllegalExceptionReturn() pseudocode */
+static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
+						   u64 spsr)
+{
+	u64 cur_el, target_el;
+
+	if (!kvm_has_gcs(vcpu->kvm))
+		return false;
+
+	if (vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT)
+		return false;
+
+	cur_el = exlock_el_from_spsr(vcpu->arch.ctxt.regs.pstate);
+	target_el = exlock_el_from_spsr(spsr);
+
+	if (cur_el != target_el)
+		return false;
+
+	return read_sysreg_el1(SYS_GCSCR) & GCSCR_ELx_EXLOCKEN;
+}
+
+#else
+static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
+						   u64 spsr)
+{
+	return false;
+}
+#endif
+
 #define KVM_NV_GUEST_MAP_SZ	(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0)
 
 static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b32742d9dd73..0f0723f22000 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2740,10 +2740,13 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 	 * - trying to return to an illegal M value
 	 * - trying to return to a 32bit EL
 	 * - trying to return to EL1 with HCR_EL2.TGE set
+	 * - GCSCR_ELx.EXLOCKEN is 1 and PSTATE.EXLOCK is 0 when attempting
+	 *   to return from ELx the same EL.
 	 */
 	if (mode == PSR_MODE_EL3t   || mode == PSR_MODE_EL3h ||
 	    mode == 0b00001         || (mode & BIT(1))       ||
 	    (spsr & PSR_MODE32_BIT) ||
+	    kvm_check_illegal_exlock_return(vcpu, spsr) ||
 	    (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
 					   mode == PSR_MODE_EL1h))) {
 		u64 mask;
@@ -2770,7 +2773,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 
 		mask = PSR_MODE_MASK | PSR_MODE32_BIT;
 		if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
-			mask |= BIT_ULL(34);	/* PSTATE.EXLOCK */
+			mask |= PSR_EXLOCK_BIT;
 
 		spsr |= *vcpu_cpsr(vcpu) & mask;
 		spsr |= PSR_IL_BIT;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index bbe9cebd3d9d..e09d9a425689 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -371,6 +371,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 		return false;
 	}
 
+	/* Push GCS exception lock failures into the slow path */
+	if (kvm_check_illegal_exlock_return(vcpu, spsr))
+		return false;
+
 	/* If ERETAx fails, take the slow path */
 	if (esr_iss_is_eretax(esr)) {
 		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))

-- 
2.47.3

