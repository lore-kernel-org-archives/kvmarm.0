Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504313033E1;
	Fri, 31 Jul 2026 20:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785530799; cv=none; b=WqgydxG4VhsSvBQvw5BtRv6YaIRY3W9qTSn0DbutJIAtbVlClMYRn7E0rFLQw9xjbpEURyPrKWmOpKQ2yoHBzWMQWQQOwdCAQpdqRG8WyekAikU4f8mlmVxDS+f77lpKXmCFAUtZi7pbme40uAQ2645puQ+O976Ji/mteJM94VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785530799; c=relaxed/simple;
	bh=ZYIdTyS6+gTxOz7kuPB5KP6ZwC/NiAAsdSBfmdRN8oc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J6F3zjjjJMzaPHU1zdEcNCoqk5B6w8u8lTzIpgNM2BzQCtdf19SOdfFAN7oy7Yfk0LCGl5zzkUqLTyylpTeRQYPrZw3CvqphYnF+vmJAujjQxiWaeBdwXSAJ2UiTx7GG1qAdeOLej9oliF90/+q4+2enNr0oGg7P5RoTiJKheyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WS+nR94d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WS+nR94d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE221F00AC4;
	Fri, 31 Jul 2026 20:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785530798;
	bh=1788FpKq2MQsvrC2BttQ63hnkLjcQiCKybYoWgRjOgQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WS+nR94dCib0xZGZnyZdvSxQnjqD+bKYY5jlAmNsfLWUGachUjSoPgyycuvKhCv+1
	 p99jXfr320l9VxbC3bYp55zHdDc0lWDsrs3vXz0YPmRNXqwdtuyjyNFJsgrPog5gNo
	 TBMtb4OG5enIxZAbxHuRw644sMAWd+4kgmMtAT+6w8aGWGBtpzgPqahHGi3fp062Sy
	 CSAIBeUkVBdG1OTlkyB1AwtHN/RYxpOHn2Jzh/EOYD494qEUbS9pcP5P2hPsMPwOUt
	 euYI+hsptfx7QNhutWauFB9XpvpKmRxhTqvkk2+I5KKautd4aQMqshGJNLW6Ami95Y
	 C2re7gOH0TfFg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 31 Jul 2026 21:44:46 +0100
Subject: [PATCH 2/2] KVM: arm64: Block ID register changes after we rely on
 the values
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-kvm-arm64-idreg-final-v1-2-3de2a5616dc6@kernel.org>
References: <20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org>
In-Reply-To: <20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5514; i=broonie@kernel.org;
 h=from:subject:message-id; bh=ZYIdTyS6+gTxOz7kuPB5KP6ZwC/NiAAsdSBfmdRN8oc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqbQmkQTFNHE/X7jyM1RgY6o2RlLj5bNDIwZVxk
 gYIxajU7HiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCam0JpAAKCRAk1otyXVSH
 0N76B/kBW8hT2mUncxHGhc3FwXoG/eT1fkFUlw/OZJ9q1wCEuJKuGwkrarYovvT4bOCCpurY3L2
 TWSR9PWfZwYC46nCJvj5FIYymhLSZS2HbBblqZf+MWY3HQwWti9s9HGJ0DJ7F+XCle9iwQMuXKA
 810bC9rqO5559zQIMB5C4KiDMb6ycE/5lz1iY/BhScMqn93zdPiHfFwkOSyGIekWdoxNYKxer+Z
 TBJ3xIHv7oJD3tDhe0PeufT0P2v7HBMKyCtQIJKlpFD4vSvmlD0QI+IbN6kfYuqJO8Tp/IGiI7O
 9XlQKDVzfyn+mVWNPqCnSKoAdSF0LQox7ZUZCIoOGVYL7o0I
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
 arch/arm64/kvm/sys_regs.c         | 13 ++++++++-----
 arch/arm64/kvm/vgic/vgic-init.c   |  6 ++----
 3 files changed, 18 insertions(+), 9 deletions(-)

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
index 958d7ef78785..3b423db56d3c 100644
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

