Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CE820969D
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 11:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738666857; cv=none; b=iH3uHCeFlfb9np+Zg0BnAaPeJzJVReI39aNktblyxkJPhdCPwzHrOGori5QC2bAW459ZW3/LGkEeFGKZz8N21FeULRDxkhi/S26syjSBKWy/UpI9mDRNI2xLCmI5Ksk0iubhvCOLJzXbmtRJUohdlpEoMaVbuqZaFygMbZT03dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738666857; c=relaxed/simple;
	bh=SWdSwKO7kx1FsE9ReQpkXv30FO82J4DEVhTE8BQrNzg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JetAPBfZZb2a8K6XLJo4Q476FIdvk69+XwXnMDy6l08QW5v248Uh0Aex2yF9AskOhcDJpOvWwVt2BX8sYI1ROjvQvXJ7ci8sZjmv9Ne3hUhpcRKtFL/CskSvQtPd2NgcCDSt9GE6uCPD0LrBK6JFdqxihrvFK2ISVZtFXIlqZlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U1TnF8JP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U1TnF8JP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7836C4CEE6;
	Tue,  4 Feb 2025 11:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738666856;
	bh=SWdSwKO7kx1FsE9ReQpkXv30FO82J4DEVhTE8BQrNzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1TnF8JPxkV1AXv2+8Vz5MN4lQePtv7U+qBGff31zNjlw139mk3GnSI7zdOc2ecXi
	 E/kHPFxZVZoVTQ3WE+gIEC/CKjjmdDa+yJYV3aJY0ruvLDf3RTstAYRBP5iCAU4jl4
	 aVMSeAxUBpyjz1xNV2zlM0RMwr+bz/zmu78PKurBLJBlbzHw3NxXJz6NgpLRzsOAok
	 bCHkzv1lyA1XZeJZ1tyLMDG+SQSRyLcNVPdPYasbdfXWFnSgQqdnY0PDJj/QPXDjI8
	 C/fCZl++AtTJtu6d7LENn7LVe86nf+MwCZmHGt7hezQ60NRb6OFPkfaq+p7Q5nK/M2
	 wcdsj92J8s4hQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tfGfm-000OVe-Ne;
	Tue, 04 Feb 2025 11:00:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 3/3] KVM: arm64: timer: Don't adjust the EL2 virtual timer offset
Date: Tue,  4 Feb 2025 11:00:50 +0000
Message-Id: <20250204110050.150560-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250204110050.150560-1-maz@kernel.org>
References: <20250204110050.150560-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, r09922117@csie.ntu.edu.tw, Volodymyr_Babchuk@epam.com, Dmytro_Terletskyi@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The way we deal with the EL2 virtual timer is a bit odd.

We try to cope with E2H being flipped, and adjust which offset
applies to that timer depending on the current E2H value. But that's
a complexity we shouldn't have to worry about.

What we have to deal with is either E2H being RES1, in which case
there is no offset, or E2H being RES0, and the virtual timer simply
does not exist.

Drop the adjusting of the timer offset, which makes things a bit
simpler. At the same time, make sure that accessing the HV timer
when E2H is RES0 results in an UNDEF in the guest.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 15 ---------------
 arch/arm64/kvm/sys_regs.c   | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index e59836e0260cf..231c0cd9c7b4b 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -759,21 +759,6 @@ static void kvm_timer_vcpu_load_nested_switch(struct kvm_vcpu *vcpu,
 					    timer_irq(map->direct_ptimer),
 					    &arch_timer_irq_ops);
 		WARN_ON_ONCE(ret);
-
-		/*
-		 * The virtual offset behaviour is "interesting", as it
-		 * always applies when HCR_EL2.E2H==0, but only when
-		 * accessed from EL1 when HCR_EL2.E2H==1. So make sure we
-		 * track E2H when putting the HV timer in "direct" mode.
-		 */
-		if (map->direct_vtimer == vcpu_hvtimer(vcpu)) {
-			struct arch_timer_offset *offs = &map->direct_vtimer->offset;
-
-			if (vcpu_el2_e2h_is_set(vcpu))
-				offs->vcpu_offset = NULL;
-			else
-				offs->vcpu_offset = &__vcpu_sys_reg(vcpu, CNTVOFF_EL2);
-		}
 	}
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 526d66f24e34a..7968bee0d27ea 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1452,6 +1452,16 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_hv_timer(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		return undef_access(vcpu, p, r);
+
+	return access_arch_timer(vcpu, p, r);
+}
+
 static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 				    s64 new, s64 cur)
 {
@@ -3099,9 +3109,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(CNTHP_CTL_EL2, access_arch_timer, reset_val, 0),
 	EL2_REG(CNTHP_CVAL_EL2, access_arch_timer, reset_val, 0),
 
-	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_arch_timer },
-	EL2_REG(CNTHV_CTL_EL2, access_arch_timer, reset_val, 0),
-	EL2_REG(CNTHV_CVAL_EL2, access_arch_timer, reset_val, 0),
+	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_hv_timer },
+	EL2_REG(CNTHV_CTL_EL2, access_hv_timer, reset_val, 0),
+	EL2_REG(CNTHV_CVAL_EL2, access_hv_timer, reset_val, 0),
 
 	{ SYS_DESC(SYS_CNTKCTL_EL12), access_cntkctl_el12 },
 
-- 
2.39.2

