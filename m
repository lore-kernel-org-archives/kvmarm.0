Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08C751AECE;
	Tue, 29 Sep 2026 11:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790683117; cv=none; b=Ne2bH/c/Id+akvblbRtD1L1IZLdLKFPDKbYORO6NEh7Fv0gHTbNM/OrGjTHk5CYpDEFaeKFXyEe4W4ZnkEZjCJerc4N7pQXJUc6kTYARnvnjoVOPubiadYylOcIGV/FGPFWsNVKRrAPMBv71wZUKzoSOB35jGhSb7VQt6SMW9sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790683117; c=relaxed/simple;
	bh=08pthla/KeEfJoW5PH8Y9z9NM4qE2TfAYbI4ohs8a2U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gaP5zmOdVI0iiv8W0KI/ABfGCelEPs1AzQuaBtTuF6dCeRN27NETc49c4y8B7/mGXAOPB5MURfgi4D7Td2xIxtWreke/2ufpTRv4cOOM6wid0c5jNtsfJ1cLbr9bqtWwipY0Ch9oKpbPpYRz6qdOCu7a1O7GsJUQcx6uauNBg8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAaYaRPm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAaYaRPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D04E1F00898;
	Tue, 29 Sep 2026 11:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790683115;
	bh=75sSf73F/qGlN5LJwJ0cElc/+w7oAcUg2oJs0tGEB1s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mAaYaRPmzGLDVJhT6E4iqQa8SsopnRLas6D6eMavhCn4Lww4A5RHomtB32zfGWmyx
	 AGeEof9Eu3duhoIQVecGsEZ0968Ye05I8y7BNeWAKr6pgPtCz8HwSULgtoML4mgUek
	 dW3YGinvbo4NBZAP3kJblSUNwO4IhLKe7fx63arvi0UT+wjBllp4NM81V7fF1cp6b2
	 XmVKD4mPC5zcd/G+9OYiRdA9+ZBybX8ByFf4iqG0ZPESItKUQT+wDJHNJ7PYRHxlXF
	 IZzHvH3N4QpxYXkOLlfM9/T8F54poDj5223tpcSNS8lO3osNwXlU3XGuiXoh/N+cfz
	 PEVYCTee56zMg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 29 Sep 2026 12:57:59 +0100
Subject: [PATCH v4 2/3] KVM: arm64: Block ID register changes after we rely
 on the values
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-kvm-arm64-idreg-final-v4-2-75296dde994d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7070; i=broonie@kernel.org;
 h=from:subject:message-id; bh=08pthla/KeEfJoW5PH8Y9z9NM4qE2TfAYbI4ohs8a2U=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqu6fgdH9BP+liZIqkCBuRjEbFyXu0f4gMkAO2H
 ma2Hpv80o+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCarun4AAKCRAk1otyXVSH
 0INxB/oDEaSZMjnRiSjHI0WAdlpugHULiLIOppDskAZGiKyXSuyXhW2FUlDqewAiPTyIXqn0d4Y
 DtWWR1yMr7PRz0cxzNzs2+o3ooZZUKWM203RbXUY8Vbgxsrc4GZv52LzqvUiSlfy7+ntxFQxBIN
 +Cr6BWbNUau/ysCuJGMZLV9+zcuJ53PZ05vqMfg/dBmfY2s60Q2q5yHPiHQhvycu9Q7bC4vWPID
 JhxcvCepvqXOdQFLZkOYW3iH4GPdNIiGJwcYmwVsM/DMU8N7JnhnVFjoklOHR1khHa30zlWJXu1
 H8/1aA6gIrO6obE+RQNnvIH4P4oXv9PgXQLPuwwba0BieJ5E
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In commit c5bac1ef7df6b ("KVM: arm64: Move existing feature disabling
over to FGU infrastructure") a check was added to suppress duplicate
recalculation of FGUs based on a flag KVM_ARCH_FLAG_FGU_INITIALIZED. This
flag is set when we complete kvm_calculate_traps(), which is called from
kvm_arch_vcpu_run_pid_change(). There are several points where that
function could fail after we have calculated FGUs (eg, due to an invalid
timer configuration). If this happens then userspace will still be able
to write to the ID registers, writes to which are gated on
KVM_ARCH_FLAG_HAS_RAN_ONCE being set. This in turn means that the FGU
configuration for a running guest may not match the ID register
configuration.

This will result in issues based on the hypervisor assuming a consistent
configuration, for example it allows the creation of guests which have
untrapped access to system registers which are not context switched for
the guest.

A similar issue exists in kvm_init_nv_sysregs() where once sysreg_masks
is allocated the RES0/RES1 masks for registers are fixed based on the ID
register values at the time the function ran, and also for copying the
implementation ID registers to the hypervisor for pKVM.

There is a further issue with vGIC setup, creating a vGIC includes
updating the ID registers to reflect the GIC configuration. We refuse
to create a vGIC after the first vCPU has run but if a vCPU fails its
first run we may already have finalized the ID register values.

Avoid these issues by adding a new flag that we set when we finalize the
system registers, blocking ID register changes after that has been set
even if something fails later on. Do this in kvm_vm_finalize_sys_regs(),
this is where we finalize the GIC fields in the ID registers and happens
before we do the FGU and RES0/1 setup. A VMM which tries to create an
irqchip after failing to run a vCPU will now get -EBUSY rather than a
likely misconfigured guest. Userspace is not expected to try to run a
guest that fails to start, never mind try to repair the guest
configuration after doing so, so this is not expected to have any impact
on practical users.

There is a preexisting flag KVM_ARCH_FLAG_ID_REGS_INITIALIZED, this was
added as part of the series that originally enabled writable ID
registers[1].  That is set when the vCPU feature flags are finalized in
KVM_ARM_VCPU_INIT when we initiailise the ID registers, we need to be
able to write to the ID registers after that point since the features
can influence ID registers (eg, ID_AA64ZFR0_EL1).  Given this and the
fact that the flag was introduced as part of making the ID registers
writable it appears to be a deliberate and desired ABI design decision
to not use this flag to block writes to the ID registers.  Introducing
the new flag preserves the existing behaviour.

[1] https://lore.kernel.org/r/20230609190054.1542113-7-oliver.upton@linux.dev

Fixes: c5bac1ef7df6b ("KVM: arm64: Move existing feature disabling over to FGU infrastructure")
Fixes: 888f088070229 ("KVM: arm64: nv: Add sanitising to VNCR-backed sysregs")
Fixes: 03e1b89d051f ("KVM: arm64: Copy MIDR_EL1 into hyp VM when it is writable")
Fixes: 8a9866ff8600 ("KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured")
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  8 ++++++++
 arch/arm64/kvm/sys_regs.c         | 17 ++++++++++-------
 arch/arm64/kvm/vgic/vgic-init.c   |  6 ++----
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7..777c46b34bb5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,6 +367,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
 	/* Unhandled SEAs are taken to userspace */
 #define KVM_ARCH_FLAG_EXIT_SEA				11
+	/* No further ID register changes possible */
+#define KVM_ARCH_FLAG_ID_REGS_FINAL			12
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
@@ -1149,6 +1151,12 @@ struct kvm_vcpu_arch {
 #define vcpu_has_ptrauth(vcpu)		false
 #endif
 
+#define kvm_id_regs_final(kvm)						\
+	test_bit(KVM_ARCH_FLAG_ID_REGS_FINAL, &(kvm)->arch.flags)
+
+#define vcpu_id_regs_final(vcpu)					\
+	kvm_id_regs_final((vcpu)->kvm)
+
 #define vcpu_on_unsupported_cpu(vcpu)					\
 	vcpu_get_flag(vcpu, ON_UNSUPPORTED_CPU)
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 57abbce52540..b9f18de772bf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2511,9 +2511,10 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 
 	/*
 	 * Once the VM has started the ID registers are immutable. Reject any
-	 * write that does not match the final register value.
+	 * write that does not match the final register value once we have
+	 * got far enough into first running the VM to use the values.
 	 */
-	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+	if (vcpu_id_regs_final(vcpu)) {
 		if (val != read_id_reg(vcpu, rd))
 			ret = -EBUSY;
 		else
@@ -2547,7 +2548,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (KVM_BUG_ON(kvm_vm_has_ran_once(kvm) || !p, kvm))
+	if (KVM_BUG_ON(kvm_id_regs_final(kvm) || !p, kvm))
 		return;
 
 	*p = val;
@@ -3243,10 +3244,10 @@ static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 		return -EINVAL;
 
 	/*
-	 * Once the VM has started the ID registers are immutable. Reject the
-	 * write if userspace tries to change it.
+	 * Once we have been far enough into starting the VM the ID registers
+	 * are immutable. Reject the write if userspace tries to change it.
 	 */
-	if (kvm_vm_has_ran_once(kvm))
+	if (kvm_id_regs_final(kvm))
 		return -EBUSY;
 
 	/*
@@ -5871,7 +5872,7 @@ static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (kvm_vm_has_ran_once(kvm))
+	if (kvm_id_regs_final(kvm))
 		return 0;
 
 	/*
@@ -5919,6 +5920,8 @@ static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
 		kvm_vgic_finalize_idregs(kvm);
 	}
 
+	set_bit(KVM_ARCH_FLAG_ID_REGS_FINAL, &kvm->arch.flags);
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 4012df6002ea..247c211bd68b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -123,10 +123,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu_has_run_once(vcpu))
-			goto out_unlock;
-	}
+	if (kvm_id_regs_final(kvm))
+		goto out_unlock;
 	ret = 0;
 
 	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)

-- 
2.47.3

