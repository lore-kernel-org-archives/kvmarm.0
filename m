Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1DB30B512
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 12:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767789967; cv=none; b=h05oVuXTeovTBSNv7VhpMOIzM9wpEETznt25QGZSfpcooX2oPW4ZWZTt2XXRQjYF/TFG3Z1hbQSfUPTXR84Dn0nu+j57XuH/lS2AeSA1GnYykl27ll4gSORy8T8H58StF4kb66CUrBBGVB3iBTf3PCeO6EQzA6iK9IoFlvf1ECM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767789967; c=relaxed/simple;
	bh=syl65owdP/RoGcNFHCnmuoWpmj3uNZRH9TwzlTpjGms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mrIM6coHiVafsM8RFNxzWrMIcyXqpcc8LIY4j1GvwEIUT+UUTZh60DpUHK1hmrVN+UAEIboh0tA68perhE934b48C1jSBTCKRvbLS2Gm812HlWI4b4xKgWAidK4SSjz8gMBkhCTg0ojKLWkz/UzAW8igrYWFfnY18lRgQFUXhMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJIQXrmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJIQXrmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3771DC4CEF7;
	Wed,  7 Jan 2026 12:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767789965;
	bh=syl65owdP/RoGcNFHCnmuoWpmj3uNZRH9TwzlTpjGms=;
	h=From:To:Cc:Subject:Date:From;
	b=rJIQXrmD2xnnqMZ65SkCCDm7c0xLAcMx7CHgIa4bV4T/EZwd5+9CW/iaI+TmDj5/y
	 KwhVL0Ha+NwsHueK4axzL6PoUFENR222xJOG87+WGqaBTJ8a9QNbCUKHWAvrZ3mCOJ
	 6tjyt/8ky3XsyAW3nxIYEFFkRD8v9Y1U3oe5VRsEaOxCoU/P0N5wn7DuA23HwxpsFT
	 JeXP8UVM/XUoh8AStF5S1X+cG1vT76wye+zILPfuj24CfDVzSD9Mz+fk4r+/IulhnF
	 BzVVkjEUxvYklmKhp5bB9jbB6DZnyuJxog4lgU21ov3TRUMpes4mIn/LKchTg07c1w
	 yuV5hEZmEm4bw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdSvK-000000004LB-3tNb;
	Wed, 07 Jan 2026 12:46:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] KVM: arm64: Don't blindly set set PSTATE.PAN on guest exit
Date: Wed,  7 Jan 2026 12:46:00 +0000
Message-ID: <20260107124600.2736328-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We set PSTATE.PAN to 1 on exiting from a guest if PAN support has
been compiled in and that it exists on the HW. However, this is not
necessarily correct.

In a nVHE configuration, there is no notion of PAN at EL2, so setting
PSTATE.PAN to anything is pointless.

Furthermore, not setting PAN to 0 when CONFIG_ARM64_PAN isn't set
means we run with the *guest's* PSTATE.PAN (which might be set to 1),
and we will explode on the next userspace access. Yes, the architecture
is delightful in that particular corner.

Fix the whole thing by always setting PAN to something when running
VHE (which implies PAN support), and only ignore it when running nVHE.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  2 ++
 arch/arm64/include/asm/sysreg.h  |  3 ++-
 arch/arm64/kernel/image-vars.h   |  1 +
 arch/arm64/kvm/hyp/entry.S       |  4 +++-
 arch/arm64/kvm/va_layout.c       | 28 ++++++++++++++++++++++++++++
 5 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a1ad12c72ebf1..ce516d8187b1b 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -300,6 +300,8 @@ void kvm_get_kimage_voffset(struct alt_instr *alt,
 	__le32 *origptr, __le32 *updptr, int nr_inst);
 void kvm_compute_final_ctr_el0(struct alt_instr *alt,
 	__le32 *origptr, __le32 *updptr, int nr_inst);
+void kvm_pan_patch_el2_entry(struct alt_instr *alt,
+			     __le32 *origptr, __le32 *updptr, int nr_inst);
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr_virt,
 	u64 elr_phys, u64 par, uintptr_t vcpu, u64 far, u64 hpfar);
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 129a5349e9984..939f9c5bbae67 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -91,7 +91,8 @@
  */
 #define pstate_field(op1, op2)		((op1) << Op1_shift | (op2) << Op2_shift)
 #define PSTATE_Imm_shift		CRm_shift
-#define SET_PSTATE(x, r)		__emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))
+#define ENCODE_PSTATE(x, r)		(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))
+#define SET_PSTATE(x, r)		__emit_inst(ENCODE_PSTATE(x, r))
 
 #define PSTATE_PAN			pstate_field(0, 4)
 #define PSTATE_UAO			pstate_field(0, 3)
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 85bc629270bd9..211f0e2e55e21 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -86,6 +86,7 @@ KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
 KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
 KVM_NVHE_ALIAS(kvm_compute_final_ctr_el0);
+KVM_NVHE_ALIAS(kvm_pan_patch_el2_entry);
 KVM_NVHE_ALIAS(spectre_bhb_patch_loop_iter);
 KVM_NVHE_ALIAS(spectre_bhb_patch_loop_mitigation_enable);
 KVM_NVHE_ALIAS(spectre_bhb_patch_wa3);
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 9f4e8d68ab505..d1ccddf9e87d9 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -126,7 +126,9 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 
 	add	x1, x1, #VCPU_CONTEXT
 
-	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
+	alternative_cb ARM64_ALWAYS_SYSTEM, kvm_pan_patch_el2_entry
+	nop
+	alternative_cb_end
 
 	// Store the guest regs x2 and x3
 	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 91b22a014610b..bf888d150dc79 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -296,3 +296,31 @@ void kvm_compute_final_ctr_el0(struct alt_instr *alt,
 	generate_mov_q(read_sanitised_ftr_reg(SYS_CTR_EL0),
 		       origptr, updptr, nr_inst);
 }
+
+void kvm_pan_patch_el2_entry(struct alt_instr *alt,
+			     __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	/*
+	 * If we're running at EL1 without hVHE, then SCTLR_EL2.SPAN means
+	 * nothing to us (it is RES1), and we don't need to set PSTATE.PAN
+	 * to anything useful.
+	 */
+	if (!is_kernel_in_hyp_mode() && !cpus_have_cap(ARM64_KVM_HVHE))
+		return;
+
+	/*
+	 * Leap of faith: at this point, we must be running VHE one way or
+	 * another, and FEAT_PAN is required to be implemented. If KVM
+	 * explodes at runtime because your system does not abide by this
+	 * requirement, call your favourite HW vendor, they have screwed up.
+	 *
+	 * We don't expect hVHE to access any userspace mapping, so always
+	 * set PSTATE.PAN on enty. Same thing if we have PAN enabled on an
+	 * EL2 kernel. Only force it to 0 if we have not configured PAN in
+	 * the kernel (and you know this is really silly).
+	 */
+	if (cpus_have_cap(ARM64_KVM_HVHE) || IS_ENABLED(CONFIG_ARM64_PAN))
+		*updptr = cpu_to_le32(ENCODE_PSTATE(1, PAN));
+	else
+		*updptr = cpu_to_le32(ENCODE_PSTATE(0, PAN));
+}
-- 
2.47.3

