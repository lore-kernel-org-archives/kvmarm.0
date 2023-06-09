Received: from out-15.mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C6923C93
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 22:01:21 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686348079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zv7Bx0yRs6nsqKrUyo8o/8EZhHqpOYtikkq6kaKoeUY=;
	b=JEjZMwmuXW4aBwPnFUNSUZiNtHFoWlY6HoUhj1xBxp4oMVJjA0SbvFatni5TN7cxH34Moj
	AUZylj18vEAdZE16SG/SoJrBTviav7Rt/AWempDCEkwUYiewSRMr37apFjD6qH9PH1TOXk
	UzpKWEF4zMsW3uhGlXjysZttn9y3naM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Darren Hart <darren@os.amperecomputing.com>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: Prevent guests from enabling HA/HD on Ampere1
Date: Fri,  9 Jun 2023 22:01:04 +0000
Message-ID: <20230609220104.1836988-4-oliver.upton@linux.dev>
In-Reply-To: <20230609220104.1836988-1-oliver.upton@linux.dev>
References: <20230609220104.1836988-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

An erratum in the HAFDBS implementation in AmpereOne was addressed by
clearing the feature in the ID register, with the expectation that
software would not attempt to use the corresponding controls in TCR_EL1.
The architecture, on the other hand, takes a much more pedantic stance
on the subject, requiring the TCR bits behave as RES0.

Take an extremely conservative stance on the issue and leverage the
precise write trap afforded by FGT. Handle guest writes by clearing HA
and HD before writing the intended value to the EL1 register alias.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 39 +++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e5702c27a8b2..17d6bcd321d8 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -75,6 +75,9 @@ static inline bool __hfgxtr_traps_required(void)
 	if (cpus_have_final_cap(ARM64_SME))
 		return true;
 
+	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
+		return true;
+
 	return false;
 }
 
@@ -89,6 +92,12 @@ static inline void __activate_traps_hfgxtr(void)
 		w_clr |= tmp;
 	}
 
+	/*
+	 * Trap guest writes to TCR_EL1 to prevent it from enabling HA or HD.
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
+		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
+
 	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
 	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
 }
@@ -104,6 +113,9 @@ static inline void __deactivate_traps_hfgxtr(void)
 		w_set |= tmp;
 	}
 
+	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
+		w_clr |= HFGxTR_EL2_TCR_EL1_MASK;
+
 	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
 	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
 }
@@ -400,12 +412,39 @@ static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool handle_ampere1_tcr(struct kvm_vcpu *vcpu)
+{
+	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+	int rt = kvm_vcpu_sys_get_rt(vcpu);
+	u64 val = vcpu_get_reg(vcpu, rt);
+
+	if (sysreg != SYS_TCR_EL1)
+		return false;
+
+	/*
+	 * Affected parts do not advertise support for hardware Access Flag /
+	 * Dirty state management in ID_AA64MMFR1_EL1.HAFDBS, but the underlying
+	 * control bits are still functional. The architecture requires these be
+	 * RES0 on systems that do not implement FEAT_HAFDBS.
+	 *
+	 * Uphold the requirements of the architecture by masking guest writes
+	 * to TCR_EL1.{HA,HD} here.
+	 */
+	val &= ~(TCR_HD | TCR_HA);
+	write_sysreg_el1(val, SYS_TCR);
+	return true;
+}
+
 static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
 	    handle_tx2_tvm(vcpu))
 		return true;
 
+	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38) &&
+	    handle_ampere1_tcr(vcpu))
+		return true;
+
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
 	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
 		return true;
-- 
2.41.0.162.gfafddb0af9-goog

