Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EE0519DEE;
	Tue, 29 Sep 2026 11:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790683114; cv=none; b=SWqZSzhej6OoKNyyxJpDTr/N7YY5d2Oo5pV6F21o30F2v1sbnUf0UE82fa4tpQKnFGu880WQYXAriz5s/1ctHUD3wOYHNrEKI4+20s/01gFxzog1rVedkEykNXx8+pL9i/YgaoBJd1jF7C8gA5eRWdU67FeJKxOKTb0rvZOjVN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790683114; c=relaxed/simple;
	bh=/8dOhr1gHwA3YOOWxiuGFBTXYfDRB5yR3xWSZ8pB87M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LKDspG6X9GHOIh7l9Er6sI+djjB9h9Cd3CIvngjToJ7GDzLxzvHGI6gt+EWoFY4v0Q6tHzpYFdscHxmCPqKaSsF4xlX9DrZKPm9rmiIXr/xgmB7N9MH1WuV+K12PKfoqQN10DEtHlrky9Npxo+4V9vFUGs6ld44zkTSBurO5umg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LZ+35mo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZ+35mo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ED01F000FF;
	Tue, 29 Sep 2026 11:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790683112;
	bh=ufat+d28npEF/ToRnN5gETv0PJQDZGb4TLR/RIGpsDs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LZ+35mo4rWL+fA26NkvGnoM2CD/kCycO9eKIk8Bb2pURvO9Bp/LxuyxoyL6K9JjTv
	 Fu7P0tS/y0ApUeJDqGi0TInqVBBviZGsBw6Ussj4ZNP1GyuVNLKpS4PtiMQU4uVKyL
	 NNVaJsnp57an+SVUfXvBbfG5U0sm7vYYIo/LdH9saY3jpdNR4DV4Ku0KVV4OL/gw40
	 Tl0ljS5HZGOka8j6VSG2Q9jzgP+xzdcenOqb0EGPQ3NwgshsY3qBRSGLP9RvuYUEdM
	 dOh86o1qINWjEw8qzfu65pzGFib1AMollfp47F7krFc3mUfY1EhpIzSLwJ1bS+P50m
	 SasJI4my2AP0g==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 29 Sep 2026 12:57:58 +0100
Subject: [PATCH v4 1/3] KVM: arm64: Finalize guest-wide sysregs prior to
 per-vCPU sysregs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-kvm-arm64-idreg-final-v4-1-75296dde994d@kernel.org>
References: <20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org>
In-Reply-To: <20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4006; i=broonie@kernel.org;
 h=from:subject:message-id; bh=/8dOhr1gHwA3YOOWxiuGFBTXYfDRB5yR3xWSZ8pB87M=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqu6ffdl66ynyK36swKxoQmboo2P8ScRmq/E15Y
 QwCDrL59g6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCarun3wAKCRAk1otyXVSH
 0G3LB/9wYwQnxiRprmkqfQExqgIr3Wv66iCKoSWzJOkLD/zW6yn0ejhphoixjeMhV3OL7qzkhxF
 z9OVmQBNAnqoyy+QuE+S7Bq/5BIdwY8+vwFGcrw0u2g65e7YNCVoZSJHNkQGH8m69ycZ13Lj3dV
 8EBnfkdBKzvV68bFO2466XDStqHZ5ofSY4LaX8ODWKSs++tDCN1FyJboxhra9v39wqUqA1yStvJ
 5sRhu8fUAtkel6xLjiLWYAZ/FFUkEM0j/CiylHaUx3ErWZn8edBUQhOIgudaQF6dF8xe5p1FUrJ
 xq0C2CzzEC+22tbJQq4dJJqZtqHAy/IuYc+xuz5Q/x7afRSl
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
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/arm.c      |  2 +-
 arch/arm64/kvm/sys_regs.c | 40 +++++++++++++++++++++++++++-------------
 arch/arm64/kvm/sys_regs.h |  2 +-
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90..4f044280dec0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -949,7 +949,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	ret = kvm_finalize_sys_regs(vcpu);
+	ret = kvm_vcpu_finalize_sys_regs(vcpu);
 	if (ret)
 		return ret;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d..57abbce52540 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5861,24 +5861,15 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
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
+	lockdep_assert_held(&kvm->arch.config_lock);
 
 	if (kvm_vm_has_ran_once(kvm))
 		return 0;
@@ -5931,6 +5922,29 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
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
index bd56a45abbf9..a3cccad2766f 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -254,7 +254,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 
 bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index);
 
-int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
+int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x

-- 
2.47.3

