Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDE430C37E;
	Thu,  2 Jul 2026 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008186; cv=none; b=sv7Scj5ajEgCuenfdFSqBxSVJdLlImtS2GqCe9qbdeqCl6+AoFk/+8V/ZZKUDjjODoCenFGkq8kx1Kqc1RYoSkTLDZJmRGkF5kYJc6YI08furZQe2/jJxmXCl/qy5TdEm9k7npIa2kT8xsBHUI8MQix1YPKeDdaDkXsJPDHw+Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008186; c=relaxed/simple;
	bh=AVyblLiBoc6BFs7TZ3MCZtfAyHWtjvDmAVGTp+sKnrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h18enJMK1baw1tu26xyTd5axtOPL15dQtuPILkn+wMJ0AyyIDSq3urSHw0xTNy9/iegOGNJHgXljdgKHhZCTrVY5LaSvziJoGlDPhRGag6/ttbEaBmnnb1A+MXC2oVK4r5lGcCAKXLvsxp0jvxdAUKU+QK0/esYFyVnkILUFWoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMZH/Bah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMZH/Bah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7201D1F01561;
	Thu,  2 Jul 2026 16:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008184;
	bh=umJnd+RGpiKuN+Mci1fPmKJJ/IMoXsyMfhf3FovnRlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMZH/BahOszGBq0R4pKkuARuRd7ecnGFdYjJKdo/vgaootem0mNXd+ZsZRulUYp3C
	 Mt14Ue83MozHamt+oXqI5HliftX9ZcCqyRaCUsYz4IzpnLqg3OFjzZIicFbAYciEGn
	 StkBHb05QhBbRpW6jSu/vKo08Xd7A8MVBbIcvVHrQPDtiy7CzCslv0rlwaKuk/vfhc
	 bb68iokq/ABjDsCNwuedwwbmLiKwIBnqwx0/nI15BGQD9B33RxOvqeTi0IzlLDP9WY
	 tUuC2ckl3p/RVac5iF7VwyGLUdmxo+xXgdH8Vj2Z1rWTC9uritARqaP+zU4VfomprR
	 foIieqw/LvmHw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsU-00000000ojd-3MGD;
	Thu, 02 Jul 2026 16:03:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 23/28] KVM: arm64: Add NVHCR_EL2 context switching
Date: Thu,  2 Jul 2026 17:02:43 +0100
Message-ID: <20260702160248.1377250-24-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since NVHCR_EL2 represents the HCR_EL2 state of the EL1 guest, it
must be dealt with in some particular way:

- for a guest in hyp context (an L1 by definition), NVHCR_EL2 directly
  reflects HCR_EL2 as read and written by the guest itself. It must
  therefore be eagerly synced back with the emulation code which only
  knows about HCR_EL2. This is unconditional if NV3 is available on
  the host.

- For an L2 guest, NVHCR_EL2 is controlled by the L1 guest, and we
  just context switch it like any other EL1 register. Yes, EL1, as
  that's where this thing runs from the PoV of L1. This is conditioned
  on the guest using NV3.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 11 +++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c            | 10 ++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index a17cbe7582de9..c382848d31947 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -172,6 +172,10 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 
 	if (ctxt_has_sctlr2(ctxt))
 		ctxt_sys_reg(ctxt, SCTLR2_EL1) = read_sysreg_el1(SYS_SCTLR2);
+
+	/* Retrieve L2's HCR_EL2, and save it for future use */
+	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
+		ctxt_sys_reg(ctxt, NVHCR_EL2) = read_sysreg_s(SYS_NVHCR_EL2);
 }
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
@@ -285,6 +289,13 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
 
 	if (ctxt_has_sctlr2(ctxt))
 		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR2_EL1), SYS_SCTLR2);
+
+	/*
+	 * Publish the L2 view of HCR_EL2 to the HW if L1 is using NV3.
+	 * Otherwise, the data is already in place in the L1's own VNCR.
+	 */
+	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
+		write_sysreg_s(ctxt_sys_reg(ctxt, NVHCR_EL2), SYS_NVHCR_EL2);
 }
 
 /* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 05bcf8bf7f978..c5c06ae41b229 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -71,7 +71,10 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 			hcr |= HCR_NV1;
 
 		/* Publish the guest's view of HCR_EL2 to the HW */
-		__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
+		if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
+			write_sysreg_s(__vcpu_sys_reg(vcpu, HCR_EL2), SYS_NVHCR_EL2);
+		else
+			__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
 
 		/*
 		 * Nothing in HCR_EL2 should impact running in hypervisor
@@ -565,7 +568,10 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
 		*vcpu_cpsr(vcpu) |= mode;
 
 		/* Publish the latest HCR_EL2 to the emulation */
-		hcr = __vcpu_sys_reg(vcpu, NVHCR_EL2);
+		hcr = (cpus_have_final_cap(ARM64_HAS_NV3) &&
+		       vcpu_el2_e2h_is_set(vcpu)) ?
+			read_sysreg_s(SYS_NVHCR_EL2) :
+			__vcpu_sys_reg(vcpu, NVHCR_EL2);
 
 		__vcpu_assign_sys_reg(vcpu, HCR_EL2, hcr);
 	}
-- 
2.47.3

