Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4918C426680
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553762; cv=none; b=sFhBAH476cpcEENjWQ/qLP8/t20/76A2WzEuwTJM0wguqj4zmv/1AiYKClOHdwE+pBtDuDV8odanV+71lVB6CMC3R3f7zjP0IxhQKimB7rx3cd+34Ciw/xezXapfnohHA8yEcNoUSBZUE8IEfe/9BCPXH2Twmy/VRPZ1+jcSc3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553762; c=relaxed/simple;
	bh=0pcfahOJwQNrlyIn2k6XQ3gsNAXkQkv8Sa4rS9MW98s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3ewNFXLReDtpgGBAnhS5ENWZUpKGXlKPlqNQH9FhDOpwfswhZfdl419q9Z459/lxYFaf5JiUeP03Rp47njOkzqeV0qN6dg/kEbcZtnIJxWCCJSpRcHXy02/GbsCl+Eyufhqnq2LkRIq3/jNN0tVuNk/k/vnfeCBbZF5yOeOLo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYck7O4k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYck7O4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9441F00ACF;
	Mon, 20 Jul 2026 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784553761;
	bh=jbQDACakTRETryp3VlBQ7FasPGSnCE+jqltMPIJeasw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYck7O4kWWxsUSxL58MlrgkK2QNm1fOsMqUghUiVUSK9KCF3J1Sinpr2AEdvLFPhk
	 ytKPGNsGL1f0RXfM+JZNjJcx+SIRdA+x4akjyw93/GerLM//BZ5K/MXe53vhZEm3lr
	 q+a2y+wx9akzVDAm5vOq7MvD5U62C42Je6NLzwo/04OMdZmtUDLRLl5eIQztAQfCIZ
	 rIHQBjCCiNvsqOdkUMJG+r0weTgFWyOAbCbnt1NHei3I++h0DqKKAV/B4SMZs1r0S8
	 OsqjEf9chwrw1IxuBfSfB2ou3eoVE1SZF0fxgxxO1pvmzG0W7ToFJfCWpeG/MN+Up2
	 tONl6H51zIRUw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wlnx9-00000006oKK-1El7;
	Mon, 20 Jul 2026 13:22:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/5] KVM: arm64: Convert most ICH_VTR_EL2 accesses to inlined literal value
Date: Mon, 20 Jul 2026 14:22:18 +0100
Message-ID: <20260720132220.2143486-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720132220.2143486-1-maz@kernel.org>
References: <20260720132220.2143486-1-maz@kernel.org>
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

Now that we have a new helper that inlines the value of ICH_VTR_EL2
into the code, use this to replace most of the sysreg accesses to
that register.

This avoids a lot of traps when running KVM under NV.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 8da7a40ced58a..3e5d5ddf35a19 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -367,7 +367,7 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 	u64 val;
 	u32 nr_pre_bits;
 
-	val = read_gicreg(ICH_VTR_EL2);
+	val = vgic_ich_vtr();
 	nr_pre_bits = vtr_to_nr_pre_bits(val);
 
 	switch (nr_pre_bits) {
@@ -400,7 +400,7 @@ static void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
 	u64 val;
 	u32 nr_pre_bits;
 
-	val = read_gicreg(ICH_VTR_EL2);
+	val = vgic_ich_vtr();
 	nr_pre_bits = vtr_to_nr_pre_bits(val);
 
 	switch (nr_pre_bits) {
@@ -430,7 +430,7 @@ static void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
 
 void __vgic_v3_init_lrs(void)
 {
-	int max_lr_idx = vtr_to_max_lr_idx(read_gicreg(ICH_VTR_EL2));
+	int max_lr_idx = vtr_to_max_lr_idx(vgic_ich_vtr());
 	int i;
 
 	for (i = 0; i <= max_lr_idx; i++)
@@ -455,7 +455,7 @@ u64 __vgic_v3_get_gic_config(void)
 	 * system, so we first check if we have GICv5 support.
 	 */
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
-		return read_gicreg(ICH_VTR_EL2);
+		return vgic_ich_vtr();
 
 	sre = read_gicreg(ICC_SRE_EL1);
 	/*
@@ -498,7 +498,7 @@ u64 __vgic_v3_get_gic_config(void)
 	}
 
 	val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
-	val |= read_gicreg(ICH_VTR_EL2);
+	val |= vgic_ich_vtr();
 
 	return val;
 }
@@ -540,7 +540,7 @@ void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if)
 static int __vgic_v3_bpr_min(void)
 {
 	/* See Pseudocode for VPriorityGroup */
-	return 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
+	return 8 - vtr_to_nr_pre_bits(vgic_ich_vtr());
 }
 
 static int __vgic_v3_get_group(struct kvm_vcpu *vcpu)
@@ -614,7 +614,7 @@ static int __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu, int intid,
 
 static int __vgic_v3_get_highest_active_priority(void)
 {
-	u8 nr_apr_regs = vtr_to_nr_apr_regs(read_gicreg(ICH_VTR_EL2));
+	u8 nr_apr_regs = vtr_to_nr_apr_regs(vgic_ich_vtr());
 	u32 hap = 0;
 	int i;
 
@@ -707,7 +707,7 @@ static void __vgic_v3_set_active_priority(u8 pri, u32 vmcr, int grp)
 
 static int __vgic_v3_clear_highest_active_priority(void)
 {
-	u8 nr_apr_regs = vtr_to_nr_apr_regs(read_gicreg(ICH_VTR_EL2));
+	u8 nr_apr_regs = vtr_to_nr_apr_regs(vgic_ich_vtr());
 	u32 hap = 0;
 	int i;
 
@@ -1039,7 +1039,7 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 vtr, val;
 
-	vtr = read_gicreg(ICH_VTR_EL2);
+	vtr = vgic_ich_vtr();
 	/* PRIbits */
 	val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
 	/* IDbits */
-- 
2.47.3

