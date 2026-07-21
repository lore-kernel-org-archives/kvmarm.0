Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B813400981
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 17:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653694; cv=none; b=qnPXkS6DYavSV5CEWKa0n7buKfgASE+6aYcvNO8Mhh52X8gSoIFuUn9qXoxRTEzEZ1ESY63FemT77MS7OTsd3doyOJ+AJMqiHK75hQz8UxFZO4NflZcdM4+3HpA9n6jEfx/g9kS9p7yEK0gKGSzdzrfUQuOpA2gAOeX2AvBpnto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653694; c=relaxed/simple;
	bh=/mw8xwPpHdJSIC8TicABTgAx3T4YnFSYUK7MjWEZ7xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhERxPIog9ZYanNKFopIARPkNyYZ2JsxxkDiDqJTLZ5RmQ7+yKY9cXQUnwaqjc1jPTbhWRrTfw6DmjYbWyt8195XtjGUEOS25JV38xQFoSMvzIo0SBzWI8WBtH6jayZDhEVhaD6j7+GRwpy8UG8bnxnGUhy5gtboIkeuXH54XYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOQyR3F0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOQyR3F0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6851F00ACF;
	Tue, 21 Jul 2026 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784653686;
	bh=UG3/8Bug5LYIHclBQdKEtaR/5iN83nN0sSesFr5lCbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOQyR3F0dzdbvj31C0GZsdgpEVSooi1ioTttS0ZNagXzPu0Ru98ycD7awfkmzTkqs
	 BuFUnMkQRi9GYilzQIH1bbWPicN4rWIe/U2ZVSt0Wp/r7J2AocaHykSYpFujJCnSiD
	 VihO2YV8AGNtdxa1f5E/Hxcl1arWUt0R750tcoykmiJHWlPk6uiF7J0ZSc9KEo1e+U
	 9oTk9NLgM0Qn9oJgBWtPtD6Kb8LS7qpY2NOCXLYlqVb/Da420ktfmW/WtVwvhLZNwE
	 9ELM+ZCugMhVjxORE6tiwGu1lKzUjiGFBlUNhbrqyKTezs2UZJyt1S+/KsLoGspNs/
	 hGwcOCb9VFUXw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmDwr-00000007J9p-0v4R;
	Tue, 21 Jul 2026 17:08:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 5/6] KVM: arm64: vgic-v3: Simplify initial GICv3 configuration sampling
Date: Tue, 21 Jul 2026 18:07:53 +0100
Message-ID: <20260721170754.3150521-6-maz@kernel.org>
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

Now that we have our magic inline helper for ICH_VTR_EL2, we can
get rid of the hack that was reporting a combination of that
register and of the indication of the CPU interface supporting
GICv2 compatibility. We now only report the latter.

As a small benefit, GICv5 is not involved in this stuff anymore,
since it never has GICv2 compatibility..

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c  | 23 +++--------------------
 arch/arm64/kvm/vgic/vgic-v3.c    |  9 +++------
 arch/arm64/kvm/vgic/vgic-v5.c    |  2 +-
 4 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78b..cb354a037fc5a 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -281,7 +281,7 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
 
-extern u64 __vgic_v3_get_gic_config(void);
+extern bool __vgic_v3_get_gic_config(void);
 extern void __vgic_v3_init_lrs(void);
 
 #define __KVM_EXTABLE(from, to)						\
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 3e5d5ddf35a19..74d4a509f1dec 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -437,26 +437,12 @@ void __vgic_v3_init_lrs(void)
 		__gic_v3_set_lr(0, i);
 }
 
-/*
- * Return the GIC CPU configuration:
- * - [31:0]  ICH_VTR_EL2
- * - [62:32] RES0
- * - [63]    MMIO (GICv2) capable
- */
-u64 __vgic_v3_get_gic_config(void)
+/* Return true if GICv3 is MMIO (GICv2) capable, false otherwise */
+bool __vgic_v3_get_gic_config(void)
 {
 	u64 val, sre;
 	unsigned long flags = 0;
 
-	/*
-	 * In compat mode, we cannot access ICC_SRE_EL1 at any EL
-	 * other than EL1 itself; just return the
-	 * ICH_VTR_EL2. ICC_IDR0_EL1 is only implemented on a GICv5
-	 * system, so we first check if we have GICv5 support.
-	 */
-	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
-		return vgic_ich_vtr();
-
 	sre = read_gicreg(ICC_SRE_EL1);
 	/*
 	 * To check whether we have a MMIO-based (GICv2 compatible)
@@ -497,10 +483,7 @@ u64 __vgic_v3_get_gic_config(void)
 		isb();
 	}
 
-	val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
-	val |= vgic_ich_vtr();
-
-	return val;
+	return !(val & ICC_SRE_EL1_SRE);
 }
 
 static void __vgic_v3_compat_mode_enable(void)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 098187e34c584..734fa31387235 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -936,12 +936,12 @@ void vgic_v3_enable_cpuif_traps(void)
  */
 int vgic_v3_probe(const struct gic_kvm_info *info)
 {
-	u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
+	u64 ich_vtr_el2;
 	bool has_v2;
 	int ret;
 
-	has_v2 = ich_vtr_el2 >> 63;
-	ich_vtr_el2 = (u32)ich_vtr_el2;
+	has_v2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
+	ich_vtr_el2 = vgic_ich_vtr();
 
 	/*
 	 * The ListRegs field is 5 bits, but there is an architectural
@@ -996,9 +996,6 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	if (has_v2)
 		static_branch_enable(&vgic_v3_has_v2_compat);
 
-	if (vgic_v3_broken_seis())
-		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_EL2_SEIS;
-
 	vgic_v3_enable_cpuif_traps();
 
 	kvm_vgic_global_state.vctrl_base = NULL;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index d4789ff3e7402..16bc0a670d3e5 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -83,7 +83,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	}
 
 	kvm_vgic_global_state.has_gcie_v3_compat = true;
-	ich_vtr_el2 =  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
+	ich_vtr_el2 = vgic_ich_vtr();
 	kvm_vgic_global_state.ich_vtr_el2 = (u32)ich_vtr_el2;
 
 	/*
-- 
2.47.3

