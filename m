Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035095013D1
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024457; cv=none; b=LFHe7+iC1IYErSg8URMsplDOTxh8NnFxf1Izmg5F4SdNmlliH0OtuAIs+QWibs2OrPbHCm8gDiwnzUrDFNLYF++ILe6DEzhOw8gZCdqgRkTjNKmFakEz/NnuXRr6W/cjo3DSfTZXTucyLywMkgzov/PxuhSoAllPKbb9lX1dLvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024457; c=relaxed/simple;
	bh=jeUnNZnBozcV18h8xg9nhFwbW1R0zFkdzFZ6lKG6jbM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd97Ht0s11ERc0A0UXhNPFwWSnEZvAyZcZMV6cKzdKFubBnbO0ZOtQziYbI9LFdOPx15iaSh8JX1Dgq+RTGHlrOjfQWbXvnOt40uezoFTpCe68YGMZadBCw13VbradcKQieXLErtJtNCNGxIAVg1d5XYUf9jPtm9DV+4dYNra0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=U01xTCTz; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="U01xTCTz"
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-895eaf306cfso29172237b3.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790024452; x=1790629252; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yiFGjgmYdihnRq5zn4J7+lquPNFdcPY4JCSVkkBVe/c=;
        b=U01xTCTz6DrQQqvvrAvBdBSUzadh9g8gPWdtFhGAcmZKnQQvQxuIVtyPUiyVKa8e5w
         dRkjjPDLbwo8la2FVJlzcLGV451C8/lRfZIL1DKmjy5rvYna0Up2EArlG19k2x1dWDAT
         TnzQq9L55Vhg2oIIjhgVEhcF8QQV0IOTBP65hcYP7btjs6nUyCQ5ehdoNS1bMvrj0G9D
         ZS0/kQ7MhqrvFJtMgxH8+bMkTAHWheBJv3sDKwfi4zqqYa8UkPRdnOzCx1czYe2UQ1kG
         pcKvnVrDGNmSHixxCAHecnZUL0cXHRFG8jq7P0MGLqlCTxwkzCJ7bZwKzncYTVbR/azu
         Im6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024452; x=1790629252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=yiFGjgmYdihnRq5zn4J7+lquPNFdcPY4JCSVkkBVe/c=;
        b=c7JoOzYUVVZzXiWJA9yuI1tBVzrhLLVsuUmvP2bhb9RD9wadrTk3hiTmBEZvhBF3SA
         df6MAM12kADfKNa0v5UzuieW7I5JDueFm1X2n0tDRoN1ifQdcrxehANo5ZEH7hPMaqI7
         PG13RwKNBckje5/mDNkJweUU/pzJm+D/vCzbLoaV9n6Wt2TGWamNBdBRPp7ZkoNVRWBG
         i5nQaT6T4w8e1jj+0drE6jxIaQelGROI9AxFTvTOTbxI04lbjtPDPzpDhIa4pz4Gz/iE
         7xVJi8FH3AIOrwXnXIr9OsjGwuMYT18GmrbixidZj/HZ6rJPvUcD2QDZ3oF+lj4WgL6B
         ABLQ==
X-Forwarded-Encrypted: i=1; AKwUvBwa/j0S5Zw1mnyO5H67lWx4hfHb0elyqzwkHyQOlMYQRgMac+ViHEqsfJ+WQ3kY8d2q2Vhe98Q=@lists.linux.dev
X-Gm-Message-State: AFuF++mVvKYrVgklEgjzNO422UHKmsO232r0Snl56H1+CAxvyxIwArBH
	Z1X9TOS+IdLnkecvvQHYrzzCzYiCeWni+5bu51djL4x7FftWCU8wdrUBRprVBO/4If0=
X-Gm-Gg: AYBFou1bB28nWoQBB6EzHL3va8ZcFBTmr2WTPT1B0LPGrid3O22HqiGzPHYPZUl+qLT
	d61ctViN5IhPeHZlg6LLhOiv2XzsBXbcL2IpW8jpFoyWhS8KJN9592yJmSyR4/FtYvB2m436IM6
	OGf/I3QGlM3As6TOmk6YKMqAA1lfKANYBHkAXt1GUyqqXItEm6bdGFmmAqIH3bCksQ424c9nkuH
	IZfbVLIG3xLd3w2Fai7hOT9sH89OgPslQCoWgUVgpePhzR3YciU3A3Fyqu14uATVbgvrpP7Xxm/
	p9uc9uRR/XUVMYazLnO0H2modQ6mQZAtexxLeGhRMPO/qAZdTxQRGsfQmt6x3WSj35lAxCgPUE8
	RC2VmE7S5PGGRrt5VYp+G419T3LBKM3PAbeYCx/4yF6o9TvtTH22+jy8T/IrvkEynAOK/ejOXAJ
	hN/AfXvQpSsYCblsWjXM5ujbUzaz97n4hQ7r9lJOtnTwbbUrGmvAvdeqahdj9lBKDijONA8W9gB
	qo6XRg3UrWTXAQDk2H/jJ8+FzhcHLZX5rlsfNLxUd2zSkejFYrjYq3WJ0O9CuU6yaLGsnpQ1XYi
	iPyuodetw3z/vHGo6RE=
X-Received: by 2002:a05:690c:6:b0:873:5ddf:d85d with SMTP id 00721157ae682-897346e159emr38436627b3.40.1790024451380;
        Mon, 21 Sep 2026 14:00:51 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a23c738bdfsm1445297b3.11.2026.09.21.14.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:00:50 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 44/46] KVM: arm64: Implement Caretaker GICv3 CPU interface and arch timer emulation
Date: Mon, 21 Sep 2026 17:00:32 -0400
Message-ID: <20260921210034.180424-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260921210034.180424-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
 <20260921210034.180424-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement standalone Caretaker GICv3 ICH_* register save/restore and
virtual timer deadline emulation in arch/arm64/kvm/caretaker.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/kvm/caretaker.c | 521 +++++++++++++++++++++++++++++++++++++
 1 file changed, 521 insertions(+)
 create mode 100644 arch/arm64/kvm/caretaker.c

diff --git a/arch/arm64/kvm/caretaker.c b/arch/arm64/kvm/caretaker.c
new file mode 100644
index 000000000000..65c11fe8c2fa
--- /dev/null
+++ b/arch/arm64/kvm/caretaker.c
@@ -0,0 +1,521 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <linux/cpu_preserve.h>
+#include <linux/delay.h>
+#include <linux/irqchip/arm-gic-v3.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/objtool.h>
+#include <linux/oncore.h>
+#include <linux/sched.h>
+
+#include <asm/barrier.h>
+#include <asm/caretaker.h>
+#include <asm/cpu_ops.h>
+#include <linux/cpufeature.h>
+#include <asm/cputype.h>
+#include <asm/fpsimd.h>
+#include <asm/kernel-pgtable.h>
+#include <linux/kexec.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/kvm_ptrauth.h>
+#include <linux/mmu_context.h>
+#include <linux/pgtable.h>
+#include <asm/smp_plat.h>
+#include <asm/sysreg.h>
+#include <asm/tlbflush.h>
+#include <asm/vectors.h>
+
+#include <kvm/arm_arch_timer.h>
+#include <kvm/arm_vgic.h>
+
+#include "caretaker.h"
+
+struct caretaker_fault_info {
+	u64 elr;
+	u64 esr;
+	u64 far;
+	u64 count;
+};
+
+static struct caretaker_fault_info arm64_caretaker_faults[NR_CPUS] __cpu_preserved_data;
+
+void __caretaker_text
+arm64_caretaker_handle_invalid(u64 elr, u64 esr, u64 far)
+{
+	int cpu = arm64_caretaker_get_pcpu();
+
+	if (cpu >= 0 && cpu < ARRAY_SIZE(arm64_caretaker_faults)) {
+		arm64_caretaker_faults[cpu].elr = elr;
+		arm64_caretaker_faults[cpu].esr = esr;
+		arm64_caretaker_faults[cpu].far = far;
+		arm64_caretaker_faults[cpu].count++;
+	}
+
+	while (1) {
+		if (cpu_preserved_should_exit(cpu)) {
+			cpu_preserved_set_dead(cpu);
+			arch_cpu_preserved_park_finish(cpu);
+		}
+		arch_cpu_preserved_park_wait();
+	}
+}
+
+__caretaker_text static inline void
+arm64_caretaker_load_sysregs(struct kvm_cpu_context *ctxt)
+{
+	u64 mpidr = ctxt_sys_reg(ctxt, MPIDR_EL1);
+	u64 midr = read_cpuid_id();
+
+	write_sysreg(midr, vpidr_el2);
+	write_sysreg(mpidr, vmpidr_el2);
+
+	write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1), SYS_SCTLR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, CPACR_EL1), SYS_CPACR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL1), SYS_TTBR0);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL1), SYS_TTBR1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1), SYS_TCR);
+	if (cpus_have_final_cap(ARM64_HAS_TCR2)) {
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR2_EL1), SYS_TCR2);
+		if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
+			write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1), SYS_PIR);
+			write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL1), SYS_PIRE0);
+		}
+	}
+	if (cpus_have_final_cap(ARM64_HAS_SCTLR2))
+		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR2_EL1), SYS_SCTLR2);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL1), SYS_ESR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL1), SYS_AFSR0);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL1), SYS_AFSR1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, FAR_EL1), SYS_FAR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, MAIR_EL1), SYS_MAIR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, VBAR_EL1), SYS_VBAR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, CONTEXTIDR_EL1), SYS_CONTEXTIDR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, AMAIR_EL1), SYS_AMAIR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, CNTKCTL_EL1), SYS_CNTKCTL);
+	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1), par_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1), tpidr_el1);
+	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL0), tpidr_el0);
+	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0), tpidrro_el0);
+	write_sysreg(ctxt_sys_reg(ctxt, SP_EL1), sp_el1);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1), SYS_ELR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1), SYS_SPSR);
+	write_sysreg(ctxt_sys_reg(ctxt, MDSCR_EL1), mdscr_el1);
+}
+
+__caretaker_text static inline void
+arm64_caretaker_save_sysregs(struct kvm_cpu_context *ctxt)
+{
+	ctxt_sys_reg(ctxt, SCTLR_EL1) = read_sysreg_el1(SYS_SCTLR);
+	ctxt_sys_reg(ctxt, CPACR_EL1) = read_sysreg_el1(SYS_CPACR);
+	ctxt_sys_reg(ctxt, TTBR0_EL1) = read_sysreg_el1(SYS_TTBR0);
+	ctxt_sys_reg(ctxt, TTBR1_EL1) = read_sysreg_el1(SYS_TTBR1);
+	ctxt_sys_reg(ctxt, TCR_EL1) = read_sysreg_el1(SYS_TCR);
+	if (cpus_have_final_cap(ARM64_HAS_TCR2)) {
+		ctxt_sys_reg(ctxt, TCR2_EL1) = read_sysreg_el1(SYS_TCR2);
+		if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
+			ctxt_sys_reg(ctxt, PIR_EL1) = read_sysreg_el1(SYS_PIR);
+			ctxt_sys_reg(ctxt, PIRE0_EL1) = read_sysreg_el1(SYS_PIRE0);
+		}
+	}
+	if (cpus_have_final_cap(ARM64_HAS_SCTLR2))
+		ctxt_sys_reg(ctxt, SCTLR2_EL1) = read_sysreg_el1(SYS_SCTLR2);
+	ctxt_sys_reg(ctxt, ESR_EL1) = read_sysreg_el1(SYS_ESR);
+	ctxt_sys_reg(ctxt, AFSR0_EL1) = read_sysreg_el1(SYS_AFSR0);
+	ctxt_sys_reg(ctxt, AFSR1_EL1) = read_sysreg_el1(SYS_AFSR1);
+	ctxt_sys_reg(ctxt, FAR_EL1) = read_sysreg_el1(SYS_FAR);
+	ctxt_sys_reg(ctxt, MAIR_EL1) = read_sysreg_el1(SYS_MAIR);
+	ctxt_sys_reg(ctxt, VBAR_EL1) = read_sysreg_el1(SYS_VBAR);
+	ctxt_sys_reg(ctxt, CONTEXTIDR_EL1) = read_sysreg_el1(SYS_CONTEXTIDR);
+	ctxt_sys_reg(ctxt, AMAIR_EL1) = read_sysreg_el1(SYS_AMAIR);
+	ctxt_sys_reg(ctxt, CNTKCTL_EL1) = read_sysreg_el1(SYS_CNTKCTL);
+	ctxt_sys_reg(ctxt, PAR_EL1) = read_sysreg_par();
+	ctxt_sys_reg(ctxt, TPIDR_EL1) = read_sysreg(tpidr_el1);
+	ctxt_sys_reg(ctxt, TPIDR_EL0) = read_sysreg(tpidr_el0);
+	ctxt_sys_reg(ctxt, TPIDRRO_EL0) = read_sysreg(tpidrro_el0);
+	ctxt_sys_reg(ctxt, SP_EL1) = read_sysreg(sp_el1);
+	ctxt_sys_reg(ctxt, ELR_EL1) = read_sysreg_el1(SYS_ELR);
+	ctxt_sys_reg(ctxt, SPSR_EL1) = read_sysreg_el1(SYS_SPSR);
+	ctxt_sys_reg(ctxt, MDSCR_EL1) = read_sysreg(mdscr_el1);
+}
+
+int arm64_kvm_caretaker_preserve(struct kvm_vcpu *vcpu,
+				 struct kvm_vcpu_ser *ser)
+{
+	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu ?
+				 vcpu->arch.hw_mmu : &vcpu->kvm->arch.mmu;
+	struct oncore_session *sess = oncore_job_session(vcpu->caretaker.job);
+	struct arch_timer_context *vtimer;
+	struct caretaker_arm64_page *head;
+	struct caretaker_arm64_page *cap;
+
+	if (!has_vhe() || is_protected_kvm_enabled() || vcpu_has_nv(vcpu))
+		return -EOPNOTSUPP;
+	/*
+	 * Same predicate as kvm_arch_vcpu_luo_preserve() (kvm_luo.c) and
+	 * kvm_arm_copy_sys_reg_indices() (sys_regs.c): what matters is whether
+	 * an in-kernel irqchip exists at all, not whether it has been
+	 * initialised yet.  vgic_initialized() would let a created-but-not-ready
+	 * in-kernel VGICv2 through, and the caretaker cannot emulate one.
+	 */
+	if (irqchip_in_kernel(vcpu->kvm) &&
+	    vcpu->kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+		return -EOPNOTSUPP;
+	if (kvm_has_mte(vcpu->kvm) || kvm_has_s1poe(vcpu->kvm) ||
+	    vcpu_has_sve(vcpu) || vcpu_has_ptrauth(vcpu) ||
+	    test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &vcpu->kvm->arch.flags))
+		return -EOPNOTSUPP;
+
+	cap = kho_alloc_preserve(sizeof(*cap));
+	if (IS_ERR(cap)) {
+		pr_err("caretaker arm64: failed to allocate preserved page\n");
+		return -ENOMEM;
+	}
+	oncore_session_map_buffer(sess, cap, sizeof(*cap));
+
+	memset(cap, 0, sizeof(*cap));
+
+	kvm_caretaker_init_common_vcpu(&cap->vcpu, &cap->abi.cb, vcpu, cap,
+				       sizeof(*cap), NULL, cap);
+
+	/* Copy architectural execution state */
+	cap->ctx.ctxt = vcpu->arch.ctxt;
+	cap->ctx.fault = vcpu->arch.fault;
+	cap->ctx.hcr_el2 = vcpu->arch.hcr_el2;
+	cap->ctx.mdcr_el2 = vcpu->arch.mdcr_el2;
+	cap->ctx.cflags = vcpu->arch.cflags;
+
+	cap->ctx.vtcr_el2 = mmu->vtcr;
+	cap->ctx.vttbr_el2 = kvm_get_vttbr(mmu);
+
+	if (vgic_initialized(vcpu->kvm)) {
+		int i;
+
+		cap->ctx.vgic_initialized = true;
+		cap->ctx.vgic_v3 = vcpu->arch.vgic_cpu.vgic_v3;
+
+		for (i = 0; ; i++) {
+			phys_addr_t rpa;
+			unsigned long rva;
+			size_t rsize;
+
+			if (gicv3_caretaker_get_redist_region(i, &rpa, &rva, &rsize))
+				break;
+			oncore_session_map_range(sess, rpa, rva, rsize,
+						 pgprot_device(PAGE_KERNEL));
+		}
+	}
+
+	vtimer = vcpu_vtimer(vcpu);
+	cap->ctx.cntvoff_el2 = timer_get_offset(vtimer);
+	cap->ctx.cntv_cval_el0 = timer_get_cval(vtimer);
+	cap->ctx.cntv_ctl_el0 = timer_get_ctl(vtimer);
+
+	head = vcpu->kvm->caretaker_vm;
+	if (!head) {
+		cap->next_vcpu = cap;
+		vcpu->kvm->caretaker_vm = cap;
+	} else {
+		struct caretaker_arm64_page *peer;
+
+		cap->next_vcpu = head->next_vcpu;
+		head->next_vcpu = cap;
+		cpu_preserved_clean(head);
+
+		for (peer = cap->next_vcpu; peer != cap; peer = peer->next_vcpu)
+			oncore_session_map_buffer(sess, peer, sizeof(*peer));
+	}
+
+	cap->abi.vgic_initialized = cap->ctx.vgic_initialized ? 1 : 0;
+	cap->abi.cntvoff_el2 = cap->ctx.cntvoff_el2;
+	cap->abi.hcr_el2 = cap->ctx.hcr_el2;
+	cap->abi.mdcr_el2 = cap->ctx.mdcr_el2;
+	cap->abi.cflags = (u32)cap->ctx.cflags;
+	if (cap->ctx.vgic_initialized) {
+		int i;
+
+		cap->abi.used_lrs = cap->ctx.vgic_v3.used_lrs;
+		cap->abi.vgic_hcr = cap->ctx.vgic_v3.vgic_hcr;
+		cap->abi.vgic_vmcr = cap->ctx.vgic_v3.vgic_vmcr;
+		for (i = 0; i < 4; i++) {
+			cap->abi.vgic_ap0r[i] = cap->ctx.vgic_v3.vgic_ap0r[i];
+			cap->abi.vgic_ap1r[i] = cap->ctx.vgic_v3.vgic_ap1r[i];
+		}
+		for (i = 0; i < 16; i++)
+			cap->abi.vgic_lr[i] = cap->ctx.vgic_v3.vgic_lr[i];
+	}
+
+	if (ser->arch_state.phys) {
+		struct kvm_vcpu_arch_ser *state =
+			phys_to_virt(ser->arch_state.phys);
+		size_t sz = struct_size(state, sysregs, state->num_sysregs);
+
+		cap->arch_state = state;
+		oncore_session_map_buffer(sess, state, sz);
+	}
+
+	ser->cb.phys = virt_to_phys(cap);
+
+	cpu_preserved_clean(cap);
+
+	return 0;
+}
+
+static __always_inline void arm64_caretaker_save_ptrauth(struct arm64_caretaker_ptrauth_keys *k)
+{
+	if (!arm64_caretaker_has_ptrauth)
+		return;
+
+	k->apia_lo = read_sysreg_s(SYS_APIAKEYLO_EL1);
+	k->apia_hi = read_sysreg_s(SYS_APIAKEYHI_EL1);
+	k->apib_lo = read_sysreg_s(SYS_APIBKEYLO_EL1);
+	k->apib_hi = read_sysreg_s(SYS_APIBKEYHI_EL1);
+	k->apda_lo = read_sysreg_s(SYS_APDAKEYLO_EL1);
+	k->apda_hi = read_sysreg_s(SYS_APDAKEYHI_EL1);
+	k->apdb_lo = read_sysreg_s(SYS_APDBKEYLO_EL1);
+	k->apdb_hi = read_sysreg_s(SYS_APDBKEYHI_EL1);
+	k->apga_lo = read_sysreg_s(SYS_APGAKEYLO_EL1);
+	k->apga_hi = read_sysreg_s(SYS_APGAKEYHI_EL1);
+}
+
+static __always_inline void
+arm64_caretaker_restore_ptrauth(const struct arm64_caretaker_ptrauth_keys *k)
+{
+	if (!arm64_caretaker_has_ptrauth)
+		return;
+
+	write_sysreg_s(k->apia_lo, SYS_APIAKEYLO_EL1);
+	write_sysreg_s(k->apia_hi, SYS_APIAKEYHI_EL1);
+	write_sysreg_s(k->apib_lo, SYS_APIBKEYLO_EL1);
+	write_sysreg_s(k->apib_hi, SYS_APIBKEYHI_EL1);
+	write_sysreg_s(k->apda_lo, SYS_APDAKEYLO_EL1);
+	write_sysreg_s(k->apda_hi, SYS_APDAKEYHI_EL1);
+	write_sysreg_s(k->apdb_lo, SYS_APDBKEYLO_EL1);
+	write_sysreg_s(k->apdb_hi, SYS_APDBKEYHI_EL1);
+	write_sysreg_s(k->apga_lo, SYS_APGAKEYLO_EL1);
+	write_sysreg_s(k->apga_hi, SYS_APGAKEYHI_EL1);
+	isb();
+}
+
+#define __caretaker_apr_save(_v, _reg)		((_v) = read_sysreg_s(_reg))
+#define __caretaker_apr_restore(_v, _reg)	write_sysreg_s((_v), _reg)
+
+/*
+ * ICH_AP0R<n>_EL2 and ICH_AP1R<n>_EL2 encode <n> in the instruction, so the
+ * accesses cannot be put in a loop.  Generate the ladder for either group and
+ * either direction from one pattern instead of writing it out four times.
+ *
+ * @_dir: save or restore
+ * @_grp: 0 or 1, selecting ICH_AP0R<n>_EL2 or ICH_AP1R<n>_EL2
+ */
+#define caretaker_vgic_v3_apr(_dir, _grp, _regs, _nr_pre_bits)			\
+do {										\
+	switch (_nr_pre_bits) {							\
+	case 7:									\
+		__caretaker_apr_##_dir((_regs)[3], SYS_ICH_AP##_grp##R3_EL2);	\
+		__caretaker_apr_##_dir((_regs)[2], SYS_ICH_AP##_grp##R2_EL2);	\
+		fallthrough;							\
+	case 6:									\
+		__caretaker_apr_##_dir((_regs)[1], SYS_ICH_AP##_grp##R1_EL2);	\
+		fallthrough;							\
+	default:								\
+		__caretaker_apr_##_dir((_regs)[0], SYS_ICH_AP##_grp##R0_EL2);	\
+	}									\
+} while (0)
+
+/*
+ * Acknowledge and retire whichever Group 1 interrupt is pending on this CPU.
+ * EOImode is 1 (priority drop and deactivation are separate), so a real INTID
+ * needs both an EOIR1 and a DIR write.  The special INTIDs (1020-1023) mean
+ * "nothing pending" and must not be written back.
+ */
+__caretaker_text static void caretaker_gic_drain_iar(void)
+{
+	u32 iar = read_sysreg_s(SYS_ICC_IAR1_EL1);
+
+	if (iar < GIC_SPECIAL_INTID_START) {
+		write_sysreg_s(iar, SYS_ICC_EOIR1_EL1);
+		write_sysreg_s(iar, SYS_ICC_DIR_EL1);
+	}
+}
+
+/*
+ * Put EL2 back into host (VHE) configuration.  Both vector bases are pointed
+ * at the caretaker's own hyp vectors: while a preserved core is running a
+ * guest the caretaker owns EL2, and the kernel that installed kvm_hyp_vector
+ * may no longer exist.
+ */
+__caretaker_text static void caretaker_restore_host_el2(void)
+{
+	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
+	write_sysreg((unsigned long)caretaker_hyp_vector, vbar_el1);
+	write_sysreg_s((unsigned long)caretaker_hyp_vector, SYS_VBAR_EL2);
+	dsb(sy);
+	isb();
+}
+
+__caretaker_text static u64 caretaker_gic_v3_get_lr(unsigned int lr)
+{
+	switch (lr & 0xf) {
+	case 0:
+		return read_gicreg(ICH_LR0_EL2);
+	case 1:
+		return read_gicreg(ICH_LR1_EL2);
+	case 2:
+		return read_gicreg(ICH_LR2_EL2);
+	case 3:
+		return read_gicreg(ICH_LR3_EL2);
+	case 4:
+		return read_gicreg(ICH_LR4_EL2);
+	case 5:
+		return read_gicreg(ICH_LR5_EL2);
+	case 6:
+		return read_gicreg(ICH_LR6_EL2);
+	case 7:
+		return read_gicreg(ICH_LR7_EL2);
+	case 8:
+		return read_gicreg(ICH_LR8_EL2);
+	case 9:
+		return read_gicreg(ICH_LR9_EL2);
+	case 10:
+		return read_gicreg(ICH_LR10_EL2);
+	case 11:
+		return read_gicreg(ICH_LR11_EL2);
+	case 12:
+		return read_gicreg(ICH_LR12_EL2);
+	case 13:
+		return read_gicreg(ICH_LR13_EL2);
+	case 14:
+		return read_gicreg(ICH_LR14_EL2);
+	default:
+		return read_gicreg(ICH_LR15_EL2);
+	}
+}
+
+__caretaker_text static void caretaker_gic_v3_set_lr(u64 val, unsigned int lr)
+{
+	switch (lr & 0xf) {
+	case 0:
+		write_gicreg(val, ICH_LR0_EL2);
+		break;
+	case 1:
+		write_gicreg(val, ICH_LR1_EL2);
+		break;
+	case 2:
+		write_gicreg(val, ICH_LR2_EL2);
+		break;
+	case 3:
+		write_gicreg(val, ICH_LR3_EL2);
+		break;
+	case 4:
+		write_gicreg(val, ICH_LR4_EL2);
+		break;
+	case 5:
+		write_gicreg(val, ICH_LR5_EL2);
+		break;
+	case 6:
+		write_gicreg(val, ICH_LR6_EL2);
+		break;
+	case 7:
+		write_gicreg(val, ICH_LR7_EL2);
+		break;
+	case 8:
+		write_gicreg(val, ICH_LR8_EL2);
+		break;
+	case 9:
+		write_gicreg(val, ICH_LR9_EL2);
+		break;
+	case 10:
+		write_gicreg(val, ICH_LR10_EL2);
+		break;
+	case 11:
+		write_gicreg(val, ICH_LR11_EL2);
+		break;
+	case 12:
+		write_gicreg(val, ICH_LR12_EL2);
+		break;
+	case 13:
+		write_gicreg(val, ICH_LR13_EL2);
+		break;
+	case 14:
+		write_gicreg(val, ICH_LR14_EL2);
+		break;
+	default:
+		write_gicreg(val, ICH_LR15_EL2);
+		break;
+	}
+}
+
+__caretaker_text static void caretaker_vgic_v3_restore(struct caretaker_arm64_page *cap)
+{
+	struct vgic_v3_cpu_if *cpu_if = &cap->ctx.vgic_v3;
+	unsigned int used_lrs = cpu_if->used_lrs;
+	u64 vtr = read_sysreg_s(SYS_ICH_VTR_EL2);
+	unsigned int max_lrs = FIELD_GET(ICH_VTR_EL2_ListRegs, vtr) + 1;
+	u32 nr_pre_bits = FIELD_GET(ICH_VTR_EL2_PREbits, vtr) + 1;
+	unsigned int i;
+
+	/* Drain any pending software-generated SGIs into empty LRs */
+	if (cap->ctx.pending_sgis) {
+		for (i = 0; i < max_lrs && cap->ctx.pending_sgis; i++) {
+			if (i >= used_lrs || (cpu_if->vgic_lr[i] & ICH_LR_STATE) == 0) {
+				int sgi = __ffs(cap->ctx.pending_sgis);
+
+				cap->ctx.pending_sgis &= ~BIT(sgi);
+				cpu_if->vgic_lr[i] = ((u64)sgi & 0xf) |
+						     ICH_LR_PENDING_BIT |
+						     ICH_LR_GROUP |
+						     ((u64)GIC_DEFAULT_SGI_PRIO <<
+						      ICH_LR_PRIORITY_SHIFT);
+				if (i >= used_lrs)
+					used_lrs = i + 1;
+			}
+		}
+		cpu_if->used_lrs = used_lrs;
+	}
+
+	write_sysreg_s(cpu_if->vgic_vmcr, SYS_ICH_VMCR_EL2);
+
+	caretaker_vgic_v3_apr(restore, 0, cpu_if->vgic_ap0r, nr_pre_bits);
+	caretaker_vgic_v3_apr(restore, 1, cpu_if->vgic_ap1r, nr_pre_bits);
+
+	write_sysreg_s(cpu_if->vgic_hcr | ICH_HCR_EL2_En, SYS_ICH_HCR_EL2);
+
+	used_lrs = min3(used_lrs, max_lrs, (unsigned int)VGIC_V3_MAX_LRS);
+
+	for (i = 0; i < used_lrs; i++)
+		caretaker_gic_v3_set_lr(cpu_if->vgic_lr[i], i);
+	isb();
+}
+
+__caretaker_text static void caretaker_vgic_v3_save(struct vgic_v3_cpu_if *cpu_if)
+{
+	u64 vtr = read_sysreg_s(SYS_ICH_VTR_EL2);
+	unsigned int max_lrs = FIELD_GET(ICH_VTR_EL2_ListRegs, vtr) + 1;
+	u32 nr_pre_bits = FIELD_GET(ICH_VTR_EL2_PREbits, vtr) + 1;
+	unsigned int used_lrs = cpu_if->used_lrs;
+	unsigned int i;
+
+	used_lrs = min3(used_lrs, max_lrs, (unsigned int)VGIC_V3_MAX_LRS);
+
+	for (i = 0; i < used_lrs; i++) {
+		cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
+		__gic_v3_set_lr(0, i);
+	}
+
+	cpu_if->vgic_vmcr = read_sysreg_s(SYS_ICH_VMCR_EL2);
+
+	caretaker_vgic_v3_apr(save, 0, cpu_if->vgic_ap0r, nr_pre_bits);
+	caretaker_vgic_v3_apr(save, 1, cpu_if->vgic_ap1r, nr_pre_bits);
+
+	write_sysreg_s(0, SYS_ICH_HCR_EL2);
+	isb();
+}
+
-- 
2.55.0.1082.g2b9226bbc0-goog

