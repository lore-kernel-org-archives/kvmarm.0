Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F512F3C3A
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125983; cv=none; b=i60Ysn396qPzG/1tfZkLS5HDL0+fckFRYW3jz6tx/5yCypGLkU17OKEJu7OyMhjR60/bhNUwn5/WsCKmzeK9sGQD4lLtC5k3p9uuXK2hzIgw3u6smqQzcKBOefEi1P/8/U6ocfICiZvs83Z48RKOmGQnlWjDPvtpwSRAqbRuDb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125983; c=relaxed/simple;
	bh=yrT13gddazNWzpKILY32FF9cW6yTtx5tbKiQROUpzww=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NMRnUSt5M5v+yLxwbANBZL0OpbWhZLgNuFPynFWFDAWeXq2LOGacj/jDz9Qp0Od0GDkooXOAFHVLCvbOJ9sETletWYdoiyTBlgwllo/Llyh0yr1waWk/624Fk9fYSG8iMIAlbP3Fy6xXXGcUMHKYiNAnXWV5uVUY97fKWXrU2g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1OkGDGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1OkGDGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6B1C4CEE7;
	Wed, 17 Sep 2025 16:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125982;
	bh=yrT13gddazNWzpKILY32FF9cW6yTtx5tbKiQROUpzww=;
	h=From:To:Cc:Subject:Date:From;
	b=P1OkGDGYUrawyGfQ261kRY5ps7C0+2NkR62LcT52UTLl4mAwBBENJbAyilBIt6H6F
	 2mhb3TN0HNN4j+9sWQI/klhEM01aC2grwBmohg+s1TXVtzNIMsBP4cQeoLaVk9i5m2
	 aYRnmWToTCyHuDKFwF4ifIyQuCJ7bCMn7UF5j7KNwwwnxHIYD6XQxHvkaX/w0KhOhO
	 Z1F7JRR2QOX/KgrhZP85YlBAq3ZnlxyD4mU2OeD+UqOc4lKxeWRS6xNOn561v6krJk
	 vOtEpCRcU2v8Pn5M2LYOgNt6WQSRJSgC7wyYWSqqRQnRT4gAW+/ZF7NDYKSFLjLEFi
	 EskLAL/yDbIGQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyusd-000000079Zn-46Em;
	Wed, 17 Sep 2025 16:19:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH] KVM: arm64: Don't access ICC_SRE_EL2 if GICv3 doesn't support v2 compatibility
Date: Wed, 17 Sep 2025 17:19:35 +0100
Message-Id: <20250917161935.1630908-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently access ICC_SRE_EL2 at each load/put on VHE, and on each
entry/exit on nVHE. Both are quite onerous on NV, as this register
always traps.

We do this to make sure the EL1 guest doesn't flip between v2 and v3
behind our back. But all modern implementations have dropped v2,
and this is just overhead.

At the same time, the GICv5 spec has been fixed to allow access to
ICC_SRE_EL2 in legacy mode. Use this opportunity to replace the
GICv5 checks for v2 compat checks, with an ad-hoc static key.

Co-developed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/image-vars.h  |  3 +++
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 25 +++++++++----------------
 arch/arm64/kvm/vgic/vgic-v3.c   |  8 ++++++++
 include/kvm/arm_vgic.h          |  1 +
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 714b0b5ec5ac4..5369763606e71 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -105,6 +105,9 @@ KVM_NVHE_ALIAS(__hyp_stub_vectors);
 KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
 KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
 
+/* Static key indicating whether GICv3 has GICv2 compatibility */
+KVM_NVHE_ALIAS(vgic_v3_has_v2_compat);
+
 /* Static key which is set if CNTVOFF_EL2 is unusable */
 KVM_NVHE_ALIAS(broken_cntvoff_key);
 
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index d81275790e69b..acd909b7f2257 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -295,12 +295,8 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 		}
 	}
 
-	/*
-	 * GICv5 BET0 FEAT_GCIE_LEGACY doesn't include ICC_SRE_EL2. This is due
-	 * to be relaxed in a future spec release, at which point this in
-	 * condition can be dropped.
-	 */
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+	/* Only disable SRE if the host implements the GICv2 interface */
+	if (static_branch_unlikely(&vgic_v3_has_v2_compat)) {
 		/*
 		 * Prevent the guest from touching the ICC_SRE_EL1 system
 		 * register. Note that this may not have any effect, as
@@ -329,19 +325,16 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
 	}
 
-	/*
-	 * Can be dropped in the future when GICv5 spec is relaxed. See comment
-	 * above.
-	 */
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+	/* Only restore SRE if the host implements the GICv2 interface */
+	if (static_branch_unlikely(&vgic_v3_has_v2_compat)) {
 		val = read_gicreg(ICC_SRE_EL2);
 		write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
-	}
 
-	if (!cpu_if->vgic_sre) {
-		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
-		isb();
-		write_gicreg(1, ICC_SRE_EL1);
+		if (!cpu_if->vgic_sre) {
+			/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
+			isb();
+			write_gicreg(1, ICC_SRE_EL1);
+		}
 	}
 
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b01..f1c153106c563 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -588,6 +588,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
 }
 
 DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
+DEFINE_STATIC_KEY_FALSE(vgic_v3_has_v2_compat);
 
 static int __init early_group0_trap_cfg(char *buf)
 {
@@ -697,6 +698,13 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	if (kvm_vgic_global_state.vcpu_base == 0)
 		kvm_info("disabling GICv2 emulation\n");
 
+	/*
+	 * Flip the static branch if the HW supports v2, even if we're
+	 * not using it (such as in protected mode).
+	 */
+	if (has_v2)
+		static_branch_enable(&vgic_v3_has_v2_compat);
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_30115)) {
 		group0_trap = true;
 		group1_trap = true;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 404883c7af6e8..9a6340d9c91e5 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -375,6 +375,7 @@ struct vgic_cpu {
 
 extern struct static_key_false vgic_v2_cpuif_trap;
 extern struct static_key_false vgic_v3_cpuif_trap;
+extern struct static_key_false vgic_v3_has_v2_compat;
 
 int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr);
 void kvm_vgic_early_init(struct kvm *kvm);
-- 
2.39.2

