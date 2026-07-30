Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFC23B9927;
	Thu, 30 Jul 2026 07:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395470; cv=none; b=oaCy3TgylO8aMDRVKRXdfOtsyTdMNSPBAkiFMrfKMINixPzYlymF7Tdoy21KZIMLmmpwo1EXMTCCSz6Umj1AuEigJQ43xE7Ac+zeh1c1NbICgrn42fbAo7X2fPqwA/zEHnmdzLvVNxYQ+r/Oc5/E7b1ERfH13DlQoAN+66ZSHOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395470; c=relaxed/simple;
	bh=rnKZ58QBKfIY++xYHDPRcsBelDaTMTXU2ZCs3JwqvNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1On9ul6JJpjmZnBVFxMUCDuyf2pYGSMOaekvNLKdzreZpIWhLLo2vlmAtvM327lc4KDfxVJPzMWUaqorFLadgZDQJj+Nox7fxLDJiKhJjJM51oJsaHc77W+CZ3o02q/JWbCVbQyqOgZiAFxuNAXSjKnpm0Gp/8ymUpGaggKyGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcNbUDcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcNbUDcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F422E1F01572;
	Thu, 30 Jul 2026 07:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395455;
	bh=o6oNAaX1nAADau+V1jxaeTj6FIqCmAu9DozeddZoPbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcNbUDcxlY4WxV+zGZ0HPU012/XTrho5Uldhk30/vtqRLWR0OIweq9szhkEz6z66F
	 ymAkaHNYw4QIFfsmkrR5w1+k53nxgy0UfoOKiC1xKeuhSYMhbds/K1UBkVGTN1eNJL
	 YyYpuFl6i5E49bbcj6jzhlDYEfUMmKu2ek/FXcfCmDOejm1zUsyot+yaEKsCL0HE3S
	 mRIuoDIW0oAXcebaMDRik+OQb5eCM0SjYIopp/vZcCvhDsrM52V6dBWRjZ2e7Ul0tm
	 QLkAnqfLZEGO+hkE6PQo0TUsZlEtXeMaSgyOGNKyeDstlckIvYX/ScJwiflxfhEbwb
	 guk+XMbHwHmCA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKur-0000000AOpW-1U06;
	Thu, 30 Jul 2026 07:10:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 23/29] KVM: arm64: Add NVHCR_EL2 context switching
Date: Thu, 30 Jul 2026 08:10:16 +0100
Message-ID: <20260730071022.296811-24-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
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

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
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
index e5a51dc3cbe5e..cbda9e087db39 100644
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
@@ -567,7 +570,10 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
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

