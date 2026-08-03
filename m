Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099CD346A14;
	Mon,  3 Aug 2026 22:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785797688; cv=none; b=tMyctcbCtOvprpUN6CGep8AasVRHN0Admol8+xPdDNB3aV41TApmLcfta3YYYgi+rr+ZeN6/e2EgUCrVdLdOunhbeDwxnUZnnAp2B6J05S5FezrlQ1Qu7IXHJ3Ka+dnoUhxso6LLcFmHXM/yOVtbVuBrICoXEKtqcFWNPXWwGqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785797688; c=relaxed/simple;
	bh=sAoUaDyMQALfN+ONy0lnwC2Oo/ld3+Elyc6NDljIQe8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NMFvd5pUOk5di1rmkoTd7GZOUXOMF5jE1VO1o6/FnnO0JV/EhTCjezcPT+9IBlOxC5KfZ1zEBwdsjq2V0MAI4U1pLRlS9ZxKF+gu2gChuFHVCqGUOwt8p9PsKvqjsrQw8MPB6fdASSuAstbiY9GxpPwYuRpQfboey6MyoaD2/5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O84fkuXO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O84fkuXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B4A1F00A3A;
	Mon,  3 Aug 2026 22:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785797686;
	bh=N7URY0/P+czEc9oAhoLdople5LjdnyrNihUG3Il3dJU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O84fkuXOxY6TXMPZ24Sg1WO8Zi8nCA8JBnIaEy/fX5mthdhfpi17+9YDnhtTTBiPs
	 bPSvWxomV6vA2cq0NcH1XX1k8W0JIytLNNK4btb+DqVx1ygNGXXRBND9m8zGaJJfDC
	 I7zJHJh5ROErWqUKTKs81wM0LbW/tzcrbJ4XMKT5mW6LUX8pNQs7VOWLYCl4Wgfqc+
	 OR2Ad8zUXb0JLSrTM8aB0saNq3n3kEY45NNzItmeCr4qaiKaft17onaIyOUJDd2G4V
	 Uc1GoQjzcab+HWrJgjEatQq7D0+kTO7LbBPb+CKDLiTus44otbCrHVF0jyk0eBT6v/
	 VcUC4oXXPmgTw==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:53:53 +0100
Subject: [PATCH v2 1/2] KVM: arm64: Finalize guest-wide sysregs prior to
 per-vCPU sysregs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-kvm-arm64-idreg-final-v2-1-d7d7e4efc640@kernel.org>
References: <20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org>
In-Reply-To: <20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3763; i=broonie@kernel.org;
 h=from:subject:message-id; bh=sAoUaDyMQALfN+ONy0lnwC2Oo/ld3+Elyc6NDljIQe8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcRwvUJynXVIM5O1RycH+Ylg8WLTohID4H4fi+
 3Ln8w7HQ4qJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEcLwAKCRAk1otyXVSH
 0BuVB/9S2BjXFd/O02snAJx79z8SKdwb1oJtk6oHFq2JRPvhXqPhkKeL0ru0C71ALIfPZn6LlIO
 cNRGitOxqnMpQfuI7M/dKhcmIlMLPZifCebPLqEOxBiDgC6tzEkpUYJ3gT+76XqI3c9t9nJMJKo
 b6ui6BzSNmJq9YN1/L9BmE3PTTrTO1GYSIlDOq6pwBz7yjLIw5F8mD5GOmV5tc8GXqjgvrAbpOC
 z0gS6HEcVJ6HPbhxS2wrHtnYeOSUhT4ZrLYhKc3ws2dyXipP943dT+I7oArn5aBVG0m7ofHQfT2
 SJ6/Viw3QOgHqehC0y0fupD5y7zh4fY3oscJbheyQogn+ZTs
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In commit d82d09d5ba4b ("KVM: arm64: Don't skip per-vcpu NV
initialisation") the NV register sanitisation was moved earlier in
kvm_finalize_sys_regs() so that it runs for each vCPU rather than only
once per guest. This means that for the first vCPU it runs prior to vGIC
finalization, but the vGIC finalization updates the ID registers which
the NV initialization uses so we may end up with a mismatch. For
example, HFGRTR_EL2.ICC_IGRPENn_EL1 depends on GICv3 being enabled in
ID_AA64PFR0_EL1.GIC so may be mistakenly marked or not marked as RES0.

Split the initialization which runs once per guest into a separate
function and run that before the per-vCPU initialisation for NV,
renaming the per-vCPU function to make it clear that it does per-vCPU
setup.

Fixes: d82d09d5ba4b ("KVM: arm64: Don't skip per-vcpu NV initialisation")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/arm.c      |  2 +-
 arch/arm64/kvm/sys_regs.c | 40 ++++++++++++++++++++++++++--------------
 arch/arm64/kvm/sys_regs.h |  2 +-
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..2b75e1d5ca8d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -931,7 +931,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	ret = kvm_finalize_sys_regs(vcpu);
+	ret = kvm_vcpu_finalize_sys_regs(vcpu);
 	if (ret)
 		return ret;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5d5c579d4579..958d7ef78785 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5755,25 +5755,14 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Perform last adjustments to the ID registers that are implied by the
+ * Do system register finalization that is shared by the whole guest. This
+ * includes last adjustments to the ID registers that are implied by the
  * configuration outside of the ID regs themselves, as well as any
  * initialisation that directly depend on these ID registers (such as
  * RES0/RES1 behaviours). This is not the place to configure traps though.
- *
- * Because this can be called once per CPU, changes must be idempotent.
  */
-int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
+static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
 {
-	struct kvm *kvm = vcpu->kvm;
-
-	guard(mutex)(&kvm->arch.config_lock);
-
-	if (vcpu_has_nv(vcpu)) {
-		int ret = kvm_init_nv_sysregs(vcpu);
-		if (ret)
-			return ret;
-	}
-
 	if (kvm_vm_has_ran_once(kvm))
 		return 0;
 
@@ -5825,6 +5814,29 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+/*
+ * Because this can be called once per CPU, changes must be idempotent.
+ */
+int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	int ret;
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	ret = kvm_vm_finalize_sys_regs(kvm);
+	if (ret)
+		return ret;
+
+	if (vcpu_has_nv(vcpu)) {
+		ret = kvm_init_nv_sysregs(vcpu);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
 	const struct sys_reg_desc *gicv3_regs;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 2a983664220c..402c5774d916 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -235,7 +235,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 
 bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index);
 
-int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
+int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x

-- 
2.47.3

