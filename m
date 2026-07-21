Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D415400DFA
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653690; cv=none; b=ahreLNP2jeDL7mrrV9qEgJhVJlMsbcecoPSYkfObaOn5uqmOJ7BOHJxynadDMWYYzA1FjTrsd4S7XuKe9MoZ9blMzcRlmlDceR/mhs6iOBnwPtGb1Aq9yllsIb3ckt4JifSReWKiy8DJoxXnnVtyJIGteNe1hMgYqtDsI/yuS3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653690; c=relaxed/simple;
	bh=D5sfiOYpKvQJ/1qJwxKZGhzTseLfQS0Aq3mizHELsIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVk6MRHRYvePDtlVYlf5P6rCVU0wAQiTsaTGHgH1PmOYQg8cWfUrVSqvRAjvRy8wwExbiLEp50vlqKSMhQNOenMD5hs3waASceWul0LkGOhqKlN6Yoj4L8rCY7jCWIpXqyJ5DMLHfSNCR6MLSid0MhLCSGwNhUQvoiGOWGm9VIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgqsgQd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgqsgQd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDEF1F00AC4;
	Tue, 21 Jul 2026 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784653686;
	bh=0T1rRvgm8YMn9uIVkjkeXPYHQ+lULUcFY+iDKSyEFY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgqsgQd5/CVgMqsA3qGg++pkb9KlXuGAPz7dK3U/EHcOTrVz3EpovJfRjK5GFem7V
	 InXgwPfDS8kZ4ZCRT7LQtZQ/sKosz3HozgFZaa7RgyHn4tmd5lklWfl4dFb9PMuAOx
	 OSlOzRsKXWeuay9xouD2Fvx/6W9PKYZeMx7YlNFJ4PBiMGUout+1TCpQGPMrAS5q9K
	 vBnmpf75U68T0XkeiihWKogqbYDJ9QRxgs+YX+ndMq49Zid38dP09N8w2xX9qORUUl
	 WHIAHcGiJYlyWLpoylmawpyVhH/Gq8o9XQX++2WhdqBr/TNHf+LFSY4CZKyRn75EIb
	 MVNNv1MGkuI3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmDwq-00000007J9p-3ObA;
	Tue, 21 Jul 2026 17:08:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 3/6] KVM: arm64: Add a helper providing an inlined literal value for ICH_VTR_EL2
Date: Tue, 21 Jul 2026 18:07:51 +0100
Message-ID: <20260721170754.3150521-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721170754.3150521-1-maz@kernel.org>
References: <20260721170754.3150521-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We already have two ways to deal with ICH_VTR_EL2:

- directly read the system register
- read a cached copy in the vgic global state

Add a third way, in the form of an inlined literal value that will
eventually replace all of the above. This literal value is computed
at boot time, and patched in the relevant code locations.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/image-vars.h |  1 +
 arch/arm64/kvm/vgic/vgic-v3.c  | 55 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h     | 17 +++++++++++
 3 files changed, 73 insertions(+)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index d4c7d45ae6bc8..459c33634ebd1 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -92,6 +92,7 @@ KVM_NVHE_ALIAS(spectre_bhb_patch_wa3);
 KVM_NVHE_ALIAS(spectre_bhb_patch_clearbhb);
 KVM_NVHE_ALIAS(alt_cb_patch_nops);
 KVM_NVHE_ALIAS(kvm_compute_ich_hcr_trap_bits);
+KVM_NVHE_ALIAS(kvm_patch_ich_vtr_el2);
 
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 0991a649a5d1e..098187e34c584 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -858,6 +858,61 @@ void noinstr kvm_compute_ich_hcr_trap_bits(struct alt_instr *alt,
 	*updptr = cpu_to_le32(insn);
 }
 
+void noinstr kvm_patch_ich_vtr_el2(struct alt_instr *alt,
+				   __le32 *origptr, __le32 *updptr,
+				   int nr_inst)
+{
+	struct arm_smccc_res res = {};
+	u32 insn, oinsn, rd, vtr;
+
+	/* No KVM? Nothing to do */
+	if (!is_hyp_mode_available())
+		return;
+
+	/* No v3, compat, nor the fruity erzatz of a GIC? Bugger off */
+	if (!cpus_have_cap(ARM64_HAS_GICV5_LEGACY) &&
+	    !cpus_have_cap(ARM64_HAS_GICV3_CPUIF) &&
+	    !vgic_v3_broken_seis())
+		return;
+
+	/*
+	 * At the point where this is called, we are guaranteed that if
+	 * we're running at EL1, then the EL2 stubs are still in place.
+	 */
+	if (is_kernel_in_hyp_mode())
+		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
+	else
+		arm_smccc_1_1_hvc(HVC_GET_ICH_VTR_EL2, &res);
+
+	if (res.a0 == HVC_STUB_ERR)
+		return;
+
+	vtr = res.a1;
+
+	if (vgic_v3_broken_seis())
+		vtr &= ~ICH_VTR_EL2_SEIS;
+
+	/* Compute target register */
+	oinsn = le32_to_cpu(*origptr);
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
+
+	/* movz rd, #(vtr & 0xffff) */
+	insn = aarch64_insn_gen_movewide(rd,
+					 (u16)vtr,
+					 0,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_ZERO);
+	*updptr++ = cpu_to_le32(insn);
+
+	/* movk rd, #((vtr >> 16) & 0xffff), lsl #16 */
+	insn = aarch64_insn_gen_movewide(rd,
+					 (u16)(vtr >> 16),
+					 16,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_KEEP);
+	*updptr++ = cpu_to_le32(insn);
+}
+
 void vgic_v3_enable_cpuif_traps(void)
 {
 	u64 traps = vgic_ich_hcr_trap_bits();
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f45f7e3ec4d6e..b76bb6e56de37 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -71,6 +71,23 @@
 				 ICH_VTR_EL2_IDbits)
 #define KVM_ICH_VTR_EL2_RES1	ICH_VTR_EL2_nV4
 
+void kvm_patch_ich_vtr_el2(struct alt_instr *alt,
+			   __le32 *origptr, __le32 *updptr, int nr_inst);
+
+static inline u64 vgic_ich_vtr(void)
+{
+	u64 vtr;
+
+	/* All non-RES0 bits are in the bottom 32bits */
+	asm volatile(ALTERNATIVE_CB("movz %0, #0\n"
+				    "movk %0, #0, lsl #16\n",
+				    ARM64_ALWAYS_SYSTEM,
+				    kvm_patch_ich_vtr_el2)
+		     : "=r" (vtr));
+
+	return vtr;
+}
+
 static inline u64 kvm_get_guest_vtr_el2(void)
 {
 	u64 vtr;
-- 
2.47.3

