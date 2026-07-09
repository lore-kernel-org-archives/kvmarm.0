Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2114343745B;
	Thu,  9 Jul 2026 18:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622439; cv=none; b=AQL8Zae/2ZtZS16fZ9lP7eGt8SWz3q6Z6porJVEIPzc5bRIaghXqUq/E0eAd/fHyy8u4zx953PYHsukabVuH/xtM0KMATmPq6wy5HW/e/wD8fMiSMxidxU9lmmRiS+ahfmIqBB21/GuZm2KxKbZnH8nUkbWTxM7u0vK/tn0MviM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622439; c=relaxed/simple;
	bh=1qAIu+pXeO/t0Rjmal4q8j7FSwr2awFBos2cAAJK0lg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i7K1Tn4UiuOxGxi5PFTI6oI5t1xoRptRhGY8x0Zg01UgWjJYEOX9mPdQpvZWQenW6YWIvStHLVBYX1+U/VhDiLbdC8/n13LbKTw5ZvhWZS4Ekqes2Pck2OmJw+clrwL1kFUD8nQGiF1HPQCHCgU21OHSTjvyOSR3V/EmBL/8I2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ihfTHfp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ihfTHfp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E148C1F000E9;
	Thu,  9 Jul 2026 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622438;
	bh=+YU88ZRUFkvSVuCkK74k+hG8HaktkRVNfkNeUzR+i14=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ihfTHfp87MdYBmJMxHtgFose6qvgob6opLw+t2eNcVMQ9aukbr9PFuT5zLFRDQxon
	 MFWoLUz8TKmgMge4d8xs95RbZp9tEzTKgW2ZrRJvMNI3i0E/e9gemLP9MYZv7ugXBJ
	 LdqPl0ZcmpRGJtnNtu8MuEZ5JXLRncGkwxb1RLVG60fJrfvBZba8s1LcTALMqOh1Zk
	 +mRGAIpe/4LltijI6QYtw8M9PYOTaC+D47L+YPmZnmHZ8evM84t8C4VNR49P78lAoA
	 OlWQ8KZqTzugKwBx6hlzuXtFnRUxnR1p7DQdTl9jzE/Y5fdlW5qBZjQtV1OdSOsOD9
	 zhYQe9qdDojeg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:28 +0100
Subject: [PATCH v12 07/29] KVM: arm64: Pull ctxt_has_ helpers to start of
 sysreg-sr.h
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-7-d0301d79ef58@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4004; i=broonie@kernel.org;
 h=from:subject:message-id; bh=1qAIu+pXeO/t0Rjmal4q8j7FSwr2awFBos2cAAJK0lg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+rv0CVZZwhvdmr4w8M1D6/eLk7nCAkotHen7
 paipmGSVSaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q7wAKCRAk1otyXVSH
 0NOlB/9h/rb4vEOB1waSDv3vQ16SkU7O4lt+3wSt0PSB3b66FkebY62Q86k3v7tvxzuhfJzqwVj
 +wPYMe9WHg6A6qxbw7izS/lGW1s5LIg9xXZJis3QoJDFqdiZh6gNkNByHw4Sw/hmSB2YG9NAziP
 J46MN1Wo2hXY3vIBZjgOnSyjnGxeLPU14J4g7S6bTKSoAlMHf7rHl7bHBXqAjaC2rHb+EFG85cb
 jDuRspccrjL/qiJksEQzZaJTQN5WpT+Jtgj6qMS/q6I4u+eubQ7Ad7Ly8GJIslX/jNtYXqHgrvS
 r7uoHw+XEfoFCgDc5r9xYl/zjIdqV71ujCFEykpP/Xh1/ML1
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Rather than add earlier prototypes of specific ctxt_has_ helpers let's just
pull all their definitions to the top of sysreg-sr.h so they're all
available to all the individual save/restore functions.

Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 84 +++++++++++++++---------------
 1 file changed, 41 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index a17cbe7582de..5624fd705ae3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -16,8 +16,6 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt);
-
 static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
@@ -28,47 +26,6 @@ static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
 	return vcpu;
 }
 
-static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
-{
-	return host_data_ptr(host_ctxt) != ctxt;
-}
-
-static inline u64 *ctxt_mdscr_el1(struct kvm_cpu_context *ctxt)
-{
-	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
-
-	if (ctxt_is_guest(ctxt) && kvm_host_owns_debug_regs(vcpu))
-		return &vcpu->arch.external_mdscr_el1;
-
-	return &ctxt_sys_reg(ctxt, MDSCR_EL1);
-}
-
-static inline u64 ctxt_midr_el1(struct kvm_cpu_context *ctxt)
-{
-	struct kvm *kvm = kern_hyp_va(ctxt_to_vcpu(ctxt)->kvm);
-
-	if (!(ctxt_is_guest(ctxt) &&
-	      test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &kvm->arch.flags)))
-		return read_cpuid_id();
-
-	return kvm_read_vm_id_reg(kvm, SYS_MIDR_EL1);
-}
-
-static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
-{
-	*ctxt_mdscr_el1(ctxt)	= read_sysreg(mdscr_el1);
-
-	// POR_EL0 can affect uaccess, so must be saved/restored early.
-	if (ctxt_has_s1poe(ctxt))
-		ctxt_sys_reg(ctxt, POR_EL0)	= read_sysreg_s(SYS_POR_EL0);
-}
-
-static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
-{
-	ctxt_sys_reg(ctxt, TPIDR_EL0)	= read_sysreg(tpidr_el0);
-	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
-}
-
 static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
@@ -131,6 +88,47 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
 	return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
 }
 
+static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
+{
+	return host_data_ptr(host_ctxt) != ctxt;
+}
+
+static inline u64 *ctxt_mdscr_el1(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
+
+	if (ctxt_is_guest(ctxt) && kvm_host_owns_debug_regs(vcpu))
+		return &vcpu->arch.external_mdscr_el1;
+
+	return &ctxt_sys_reg(ctxt, MDSCR_EL1);
+}
+
+static inline u64 ctxt_midr_el1(struct kvm_cpu_context *ctxt)
+{
+	struct kvm *kvm = kern_hyp_va(ctxt_to_vcpu(ctxt)->kvm);
+
+	if (!(ctxt_is_guest(ctxt) &&
+	      test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &kvm->arch.flags)))
+		return read_cpuid_id();
+
+	return kvm_read_vm_id_reg(kvm, SYS_MIDR_EL1);
+}
+
+static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
+{
+	*ctxt_mdscr_el1(ctxt)	= read_sysreg(mdscr_el1);
+
+	// POR_EL0 can affect uaccess, so must be saved/restored early.
+	if (ctxt_has_s1poe(ctxt))
+		ctxt_sys_reg(ctxt, POR_EL0)	= read_sysreg_s(SYS_POR_EL0);
+}
+
+static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt_sys_reg(ctxt, TPIDR_EL0)	= read_sysreg(tpidr_el0);
+	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
+}
+
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);

-- 
2.47.3

