Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CBA311967;
	Thu,  2 Jul 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008183; cv=none; b=FAOdT2gsLPLR2iUaRdz7HORmiwVwkuJQRRUdGZ47hsbBhuKL/5fzUQ79x+m8TS8l0FTWyBEV/Sed9XjkpeIYlh63qySPkQuqydKyJv9EiH3k+OO0YxNSVG4LsYjEg+SgsatGXVH5ejP9ajdOnQ9+3y1yZ1N4v6SnUOlQuNHDqus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008183; c=relaxed/simple;
	bh=wmU2NQlrhsaEpspArusLAsoK3CbssJM/9mSnuC9M8J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNQonPa8Ky3r1HU1kONs2XWGI82vg2ExyjVBAE+yZky/ECxq3+r0880yk8tjBjx9cQ4Dr8VGYuDZfsKBEdUVj6h0drIto8n1yenqp1QdQrJcIUdM/3/XmNol+HvC7395qGgi1WYPrIHpswV/7kg0U3i1KA3o23XJSwOILSjoqMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cI3RZpYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cI3RZpYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEBC1F00ADF;
	Thu,  2 Jul 2026 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008181;
	bh=4stdxRal4cL+nFCp6TKtb9Ve4LwRjwY+2vtMdBovbZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cI3RZpYliMmGWvAOBErL/jV7GqnkgQrBG0OcA6nQvvOlPJIQIWc51d/bs+oJXIvNM
	 BVbswuw3iyB7O2tT+TNawSiaVIEzfL4fdGexDDbckZ4A5fF9Jj+tqw9BLE5hz7kLo3
	 cnTtKW+hWUwlFV347nEc92xCe6N8NsOE3g/XkYw2HxrKLlmH1MFi1uWphfGwcxEGXc
	 agwvNLp0x97EItm6XNNTCUEyKZ6Lkh81ga0NdBbxHEXTaflUclNMzRzzhetfbIHLYf
	 xt89XenBJTmS13i6VFMTWsqasGkqD4UOyRW0quvneDi0DAI3K+KKu5oSG0pF+//SbQ
	 fui6ysEStcoFg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsR-00000000ojd-3rP8;
	Thu, 02 Jul 2026 16:02:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 09/28] KVM: arm64: Relax CPTR_EL2 handling when FEAT_NV2p1 is present
Date: Thu,  2 Jul 2026 17:02:29 +0100
Message-ID: <20260702160248.1377250-10-maz@kernel.org>
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

With FEAT_NV2P1, it is no longer necessary to trap CPTR_EL2 accesses
via CPACR_EL1, as CPACR_EL1.TCPAC is guaranteed to be stateful.

Prevent such trapping and context switch CPACTR_EL1 in NV contexts
when NV2P1 is present.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 3 +++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c      | 8 +++++---
 arch/arm64/kvm/sys_regs.c               | 5 ++++-
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 8e5f492f39086..7b27296c94607 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -108,9 +108,10 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
 	 * The architecture is a bit crap (what a surprise): an EL2 guest
 	 * writing to CPTR_EL2 via CPACR_EL1 can't set any of TCPAC or TTA,
 	 * as they are RES0 in the guest's view. To work around it, trap the
-	 * sucker using the very same bit it can't set...
+	 * sucker using the very same bit it can't set. FEAT_NV2p1 fixes it.
 	 */
-	if (vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
+	if (!cpus_have_final_cap(ARM64_HAS_NV2P1) &&
+	    vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
 		val |= CPTR_EL2_TCPAC;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 3b76e0468317b..361d3f8344dd8 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -441,6 +441,9 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
 	u64 esr = kvm_vcpu_get_esr(vcpu);
 	int rt;
 
+	if (cpus_have_final_cap(ARM64_HAS_NV2P1))
+		return false;
+
 	if (!is_hyp_ctxt(vcpu) || esr_sys64_to_sysreg(esr) != SYS_CPACR_EL1)
 		return false;
 
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index be685b63e8cf2..6f0f046e4ca4e 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -42,10 +42,12 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 		u64 val;
 
 		/*
-		 * We don't save CPTR_EL2, as accesses to CPACR_EL1
-		 * are always trapped, ensuring that the in-memory
-		 * copy is always up-to-date. A small blessing...
+		 * Without FEAT_NV2p1, we don't save CPTR_EL2, as accesses
+		 * to CPACR_EL1 are always trapped, ensuring that the
+		 * in-memory copy is always up-to-date. A small blessing...
 		 */
+		if (cpus_have_final_cap(ARM64_HAS_NV2P1))
+			__vcpu_assign_sys_reg(vcpu, CPTR_EL2, read_sysreg_el1(SYS_CPACR));
 		__vcpu_assign_sys_reg(vcpu, SCTLR_EL2,	 read_sysreg_el1(SYS_SCTLR));
 		__vcpu_assign_sys_reg(vcpu, TTBR0_EL2,	 read_sysreg_el1(SYS_TTBR0));
 		__vcpu_assign_sys_reg(vcpu, TTBR1_EL2,	 read_sysreg_el1(SYS_TTBR1));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6b47d936efb32..1dfc1f88bec82 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -326,7 +326,10 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 			val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
 			return val;
 		case CPTR_EL2:
-			return __vcpu_sys_reg(vcpu, reg);
+			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
+				return read_sysreg_el1(SYS_CPACR);
+			else
+				return __vcpu_sys_reg(vcpu, reg);
 		default:
 			WARN_ON_ONCE(1);
 		}
-- 
2.47.3

