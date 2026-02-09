Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFE131BC84
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676857; cv=none; b=Zz1tzHJNifqGQ5oTiy3tUyYsJNAu/geIQNpBwZ/Nb6is8f7OybHRJS9mp2yDH+8/Y7vpSUGtCxNSvnj+svLVwzd+Khxx7Xrrb01mU1FydpBKar3zdv8GeRJFXzW+h/LhyAbOjwWKDsXxC62yqzijZTSKW8UU157Ax+h69wfRwes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676857; c=relaxed/simple;
	bh=VlntSjT33zFT4cwsmNUlK5lpAzJYXAv17KA7vHnYPW8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jELclFGhxY/W2tnmUDYfO/kSnJgofBbpsOtyb+ZZhwHlFRKt8+rcmvGe3ReUaufVK8pyS/rhSd8umjQ1elLZsv6Vo1FWqz9d7D8p3ocLJOkAnsKABbP7XvoeWUJVLtMWXUmzbdzmx2U4QjSg6NF1H30MCPY42n+stB8Lzwr0YPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b9u4hRtm; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b9u4hRtm"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-45c9878359dso7506026b6e.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676853; x=1771281653; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1q4WN7z/SL7quCNEFM+ItoBlF4yxyRczz8LessGfPao=;
        b=b9u4hRtmKO83URjNVDGXA8BLRudCynrOX82dEH/AuXEgR87S0gyx3ZSt7PXg4GIFmt
         tvqd4o7xtx3grfLBqvxQQGXWdqG9WQRtOx+BLTYe1wJmjqQHSKl0QmrA8TjIIZCqna2w
         hNNkbxWCs7Atzg3DcVOSfY5bJHGczBbf3/+O6d0XLhBxMY1pOXUR+b8ZpxT+sJC83CLb
         b+kx0+QUk1refdHCo6yaAbdV594eF5XbR4TN1IfEze5P9bzQySYs7sjG9IV2JOGDe0gT
         XDlGL8PI1hEPutaLBRi+hGZdufZZt/l2XE/mBDPqtmwmDtG8Nox77oNseF/058uDW97f
         zZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676854; x=1771281654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1q4WN7z/SL7quCNEFM+ItoBlF4yxyRczz8LessGfPao=;
        b=EsaNinEtkyMKkhozQr564EBRU+aAwJbouNRswHT40p6O9VzNNUPpI6sB7YJh+q6e4D
         lUI48yLqanZROKsCScoFhWYlMOyzt2IRn6vd9VoeanaLsh8frDJ8O46fEmjANIp0ZkNZ
         JZj6xckyhPVrlrdqzxPlqoMukdlNRC6nL/cNsTY0Q2p2CoBN2NHYxrq8KuWIfG5BQIXu
         AudIYhvZ3JGVHUlcE6VzkjQ/lQcbyCsfRZtflrGv734S3ebizcwQiJaEaw2rDWh3dADg
         AtC1E4KphGRVHI/bO0G/rLFmVL6MID9fPd7vgeXEBU2/jGhGkV8vwkzE7X29ySdJ4NJc
         wAuA==
X-Forwarded-Encrypted: i=1; AJvYcCVyycHnvA488uUsWtd/Nc6+h0s6phbAHTiG/Jxm9G2zaQHIMfJrepwp0tPgrsfNrx4rjCosaP0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhA4ZOVuxP1rGO2fNfR2kyjiPjheBczRu2SaK2hRoJT1AcW086
	ILQcUwULflrzIN/VXdfu6ybCBWrICyNP/PH5Ow1VkYphgIIO1Epr1L2qXJ8u+Iz9iNUrVN3n+YB
	bmYjIdEb5wYJHVKWUzB1qSgD9Aw==
X-Received: from iong8.prod.google.com ([2002:a5d:8c88:0:b0:957:4b76:541e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:6aca:b0:663:9b9:9297 with SMTP id 006d021491bc7-66d0c6685ccmr6026920eaf.64.1770676853645;
 Mon, 09 Feb 2026 14:40:53 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:04 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-10-coltonlewis@google.com>
Subject: [PATCH v6 09/19] KVM: arm64: Write fast path PMU register handlers
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

We may want a partitioned PMU but not have FEAT_FGT to untrap the
specific registers that would normally be untrapped. Add a handler for
those registers in the fast path so we can still get a performance
boost from partitioning.

The idea is to handle traps for all the PMU registers quickly by
writing directly to the hardware when possible instead of hooking into
the emulated vPMU as the standard handlers in sys_regs.c do.

For registers that can't be written to hardware because they require
special handling (PMEVTYPER and PMOVS), write to the virtual
register. A later patch will ensure these are handled correctly at
vcpu_load time.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 238 ++++++++++++++++++++++++++++++++
 1 file changed, 238 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9db3f11a4754d..154da70146d98 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -28,6 +28,8 @@
 #include <asm/thread_info.h>
 #include <asm/vectors.h>
 
+#include <../../sys_regs.h>
+
 /* VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
@@ -482,6 +484,239 @@ static bool kvm_hyp_handle_zcr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
+/**
+ * kvm_hyp_handle_pmu_regs() - Fast handler for PMU registers
+ * @vcpu: Pointer to vcpu struct
+ *
+ * This handler immediately writes through certain PMU registers when
+ * we have a partitioned PMU (that is, MDCR_EL2.HPMN is set to reserve
+ * a range of counters for the guest) but the machine does not have
+ * FEAT_FGT to selectively untrap the registers we want.
+ *
+ * Return: True if the exception was successfully handled, false otherwise
+ */
+static bool kvm_hyp_handle_pmu_regs(struct kvm_vcpu *vcpu)
+{
+	struct sys_reg_params p;
+	u64 pmuser;
+	u64 pmselr;
+	u64 esr;
+	u64 val;
+	u64 mask;
+	u32 sysreg;
+	u8 nr_cnt;
+	u8 rt;
+	u8 idx;
+	bool ret;
+
+	if (!kvm_vcpu_pmu_is_partitioned(vcpu))
+		return false;
+
+	pmuser = kvm_vcpu_read_pmuserenr(vcpu);
+
+	if (!(pmuser & ARMV8_PMU_USERENR_EN))
+		return false;
+
+	esr = kvm_vcpu_get_esr(vcpu);
+	p = esr_sys64_to_params(esr);
+	sysreg = esr_sys64_to_sysreg(esr);
+	rt = kvm_vcpu_sys_get_rt(vcpu);
+	val = vcpu_get_reg(vcpu, rt);
+	nr_cnt = vcpu->kvm->arch.nr_pmu_counters;
+
+	switch (sysreg) {
+	case SYS_PMCR_EL0:
+		mask = ARMV8_PMU_PMCR_MASK;
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmcr_el0);
+		} else {
+			mask |= ARMV8_PMU_PMCR_N;
+			val = u64_replace_bits(
+				read_sysreg(pmcr_el0),
+				nr_cnt,
+				ARMV8_PMU_PMCR_N);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMUSERENR_EL0:
+		mask = ARMV8_PMU_USERENR_MASK;
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmuserenr_el0);
+		} else {
+			val = read_sysreg(pmuserenr_el0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMSELR_EL0:
+		mask = PMSELR_EL0_SEL_MASK;
+		val &= mask;
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmselr_el0);
+		} else {
+			val = read_sysreg(pmselr_el0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+		ret = true;
+		break;
+	case SYS_PMINTENCLR_EL1:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmintenclr_el1);
+		} else {
+			val = read_sysreg(pmintenclr_el1);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+		ret = true;
+
+		break;
+	case SYS_PMINTENSET_EL1:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmintenset_el1);
+		} else {
+			val = read_sysreg(pmintenset_el1);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMCNTENCLR_EL0:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmcntenclr_el0);
+		} else {
+			val = read_sysreg(pmcntenclr_el0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMCNTENSET_EL0:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			write_sysreg(val & mask, pmcntenset_el0);
+		} else {
+			val = read_sysreg(pmcntenset_el0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMOVSCLR_EL0:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~(val & mask));
+		} else {
+			val = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMOVSSET_EL0:
+		mask = kvm_pmu_accessible_counter_mask(vcpu);
+
+		if (p.is_write) {
+			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, val & mask);
+		} else {
+			val = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+			vcpu_set_reg(vcpu, rt, val & mask);
+		}
+
+		ret = true;
+		break;
+	case SYS_PMCCNTR_EL0:
+	case SYS_PMXEVCNTR_EL0:
+	case SYS_PMEVCNTRn_EL0(0) ... SYS_PMEVCNTRn_EL0(30):
+		if (sysreg == SYS_PMCCNTR_EL0)
+			idx = ARMV8_PMU_CYCLE_IDX;
+		else if (sysreg == SYS_PMXEVCNTR_EL0)
+			idx = FIELD_GET(PMSELR_EL0_SEL, kvm_vcpu_read_pmselr(vcpu));
+		else
+			idx = ((p.CRm & 3) << 3) | (p.Op2 & 7);
+
+		if (idx == ARMV8_PMU_CYCLE_IDX &&
+		    !(pmuser & ARMV8_PMU_USERENR_CR)) {
+			ret = false;
+			break;
+		} else if (!(pmuser & ARMV8_PMU_USERENR_ER)) {
+			ret = false;
+			break;
+		}
+
+		if (idx >= nr_cnt && idx < ARMV8_PMU_CYCLE_IDX) {
+			ret = false;
+			break;
+		}
+
+		pmselr = read_sysreg(pmselr_el0);
+		write_sysreg(idx, pmselr_el0);
+
+		if (p.is_write) {
+			write_sysreg(val, pmxevcntr_el0);
+		} else {
+			val = read_sysreg(pmxevcntr_el0);
+			vcpu_set_reg(vcpu, rt, val);
+		}
+
+		write_sysreg(pmselr, pmselr_el0);
+		ret = true;
+		break;
+	case SYS_PMCCFILTR_EL0:
+	case SYS_PMXEVTYPER_EL0:
+	case SYS_PMEVTYPERn_EL0(0) ... SYS_PMEVTYPERn_EL0(30):
+		if (sysreg == SYS_PMCCFILTR_EL0)
+			idx = ARMV8_PMU_CYCLE_IDX;
+		else if (sysreg == SYS_PMXEVTYPER_EL0)
+			idx = FIELD_GET(PMSELR_EL0_SEL, kvm_vcpu_read_pmselr(vcpu));
+		else
+			idx = ((p.CRm & 3) << 3) | (p.Op2 & 7);
+
+		if (idx == ARMV8_PMU_CYCLE_IDX &&
+		    !(pmuser & ARMV8_PMU_USERENR_CR)) {
+			ret = false;
+			break;
+		} else if (!(pmuser & ARMV8_PMU_USERENR_ER)) {
+			ret = false;
+			break;
+		}
+
+		if (idx >= nr_cnt && idx < ARMV8_PMU_CYCLE_IDX) {
+			ret = false;
+			break;
+		}
+
+		if (p.is_write) {
+			__vcpu_assign_sys_reg(vcpu, PMEVTYPER0_EL0 + idx, val);
+		} else {
+			val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx);
+			vcpu_set_reg(vcpu, rt, val);
+		}
+
+		ret = true;
+		break;
+	default:
+		ret = false;
+	}
+
+	if (ret)
+		__kvm_skip_instr(vcpu);
+
+	return ret;
+}
+
 static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (kvm_hyp_handle_tlbi_el2(vcpu, exit_code))
@@ -496,6 +731,9 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (kvm_hyp_handle_zcr_el2(vcpu, exit_code))
 		return true;
 
+	if (kvm_hyp_handle_pmu_regs(vcpu))
+		return true;
+
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 
-- 
2.53.0.rc2.204.g2597b5adb4-goog

