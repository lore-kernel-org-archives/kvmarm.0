Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0857F346E74;
	Mon,  3 Aug 2026 22:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785797691; cv=none; b=TTwF9LW7Yezq/3cr7AH5aqn0SWCeq4tl2PvlN5SBa0IBtXiC9KLp3cI4WQ3SV7DEF/moSNr3PeaMRIbEcCdWk/h36gIJ0JlsPg130ehjmyZZw4CW5Fc1e3o6xlwPOw1MQbuWSlYH+LCurKVkCG0JCxhUqh7G5Gsdy+78ECS/kmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785797691; c=relaxed/simple;
	bh=gIuB8qQD2XUy2r1j/zjU8r7imnju8wWDVO4XYyXjtsI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Iq1nzrrfxwzKNCeunbno3WH4hLkj4OZ7+C6fmQW5VVG+WmQKFf8K99Wmw7PSC+jiBc3sqPTuAwZbT/BGjhjmrbn6944hUuWuBxefbke+4IGowg+29pJIDpiJALpMb6tfqqRGHfeZmOTHYsnA0rH/7ysekUXSiIjDZhKAtN0k0FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzBKqchn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzBKqchn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FA61F00A3D;
	Mon,  3 Aug 2026 22:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785797689;
	bh=2yt0hWvO/M3ghqp8GUUr4bjdfb2oE3xG5LNQ7g8tkXM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DzBKqchnEByOV/+dxT4jrdmo55kcurL15VrX1wpyO84t3WMx0078hW5Qa1aT996dm
	 SK7e6+g8q3cGAGN/15NV8bRA9uXuCllgZuniurLXmEoz1KZ4wMejCT/Gsbzt2sXAAj
	 mM0hyGvgmO1U3firijROKl7FWGMluz1ZzE2wuRKSScvOUrWvkA1khtfrhcOknPB5av
	 EW9nRxIcqGOOut5V5gF8kiIBC48BA+RomAADn3A/WSrwpRet7ypkuy8UkOgLggdM4l
	 rHszKuI/HvoTeqpqqhMAJnLNHr694tPtSUDkFz5j1njBO0p2t4RN1w2xg2dNt2YDwz
	 6P2NY58mlG+jQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:53:54 +0100
Subject: [PATCH v2 2/2] KVM: arm64: Block ID register changes after we rely
 on the values
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-kvm-arm64-idreg-final-v2-2-d7d7e4efc640@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6015; i=broonie@kernel.org;
 h=from:subject:message-id; bh=gIuB8qQD2XUy2r1j/zjU8r7imnju8wWDVO4XYyXjtsI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcRwvQbgicC0JqWIrJ+j/I4fbCaaKYJj/U0xUS
 NdH1vr75VWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEcLwAKCRAk1otyXVSH
 0DCpB/9aPYbqF165XlyEhzzc4YWN6huhSNpYRwkB9SUHZXy2AEfyOIfJsteWkI/T3AZhfwX11yc
 elDMRuKK9Wm890TN8R7pZS+o/Vv3rpANirCMEzUM+BILBU3WsQTGgKPE5oAd0cT+dFvdPggzliQ
 HVkO17Z/9DdGx8qLHGH7NilT0S1q5Wj06KXjU3Gm6ZyiaweZgxcEyLpHnxS+DkKKFUSeUSfbnY2
 GNp4OoUzRGR00R9bVIMbIXh8eu2syPM/UNOY/Zc+k0m+3kS8++NDFCYv9kBvgMyLTDgaFe+Ny1U
 FoX/VF9weS+Yx0HsYAQD0D6t7gAC9BDVB8MqLSH0v3pnhNi/
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

Fixes: c5bac1ef7df6b ("KVM: arm64: Move existing feature disabling over to FGU infrastructure")
Fixes: 888f088070229 ("KVM: arm64: nv: Add sanitising to VNCR-backed sysregs")
Fixes: 03e1b89d051f ("KVM: arm64: Copy MIDR_EL1 into hyp VM when it is writable")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  8 ++++++++
 arch/arm64/kvm/sys_regs.c         | 17 ++++++++++-------
 arch/arm64/kvm/vgic/vgic-init.c   |  6 ++----
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..8c8f7d83b6ff 100644
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
@@ -1143,6 +1145,12 @@ struct kvm_vcpu_arch {
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
index 958d7ef78785..c8cfe30b56b4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2427,9 +2427,10 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 
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
@@ -2463,7 +2464,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (KVM_BUG_ON(kvm_vm_has_ran_once(kvm) || !p, kvm))
+	if (KVM_BUG_ON(kvm_id_regs_final(kvm) || !p, kvm))
 		return;
 
 	*p = val;
@@ -3149,10 +3150,10 @@ static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
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
@@ -5763,7 +5764,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
  */
 static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
 {
-	if (kvm_vm_has_ran_once(kvm))
+	if (kvm_id_regs_final(kvm))
 		return 0;
 
 	/*
@@ -5811,6 +5812,8 @@ static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
 		kvm_vgic_finalize_idregs(kvm);
 	}
 
+	set_bit(KVM_ARCH_FLAG_ID_REGS_FINAL, &kvm->arch.flags);
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 907057881b26..4ffe0b7c3407 100644
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

