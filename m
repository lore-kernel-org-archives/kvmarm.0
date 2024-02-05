Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED3F17584
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129291; cv=none; b=A8EZTZPQYmRShnTboRaPLd+t7kLL6pP07Adt3aMDX2oahr+SKmTiS/sqmiJ/RJ+yCopqfZL3KGhiXKyWkxbyBkQKty1aGE/5v+GoyDQNfG3nBvIX9zWOzusAfyKjBYyWqGwaAULVMAEZHUECMSKtmXCzWEjswQukZeyY8VXobPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129291; c=relaxed/simple;
	bh=PpOwuADAsLxu45+C0oIAS3LP3QD5ZWqEix6d/oXEM3U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gs9XHS9Pd2yK2S9Hm6MG1mbiMge18U87RB7q4py+QeY4gdNSRzUdmi0ObFrn5LaYKo7eaPHIi+/HaKjtNNtgbhzdBZ0IuHiYYCogLqhV8f+auZ1UkZLucvu3BOPoAtN4OSjz5aVPLeotFLkGLRyZ4Ubrfq0UsKn1c6ZPVubJMKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6/0QpIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6/0QpIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF97C43399;
	Mon,  5 Feb 2024 10:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129290;
	bh=PpOwuADAsLxu45+C0oIAS3LP3QD5ZWqEix6d/oXEM3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6/0QpIex7aX6m+XofA7Fbbg3vWnf6Nyd63vrjKTG+LAwbPXc353ZC2XAQqW9T/3R
	 2jyeYxWMzgWorEJNhHHLCeWQCVMCzOCT53l4NjWqeooPnmFA46Zc9GJCYjpaJI6Hpr
	 gu02b6ZcTbvc4ek8Y61+zOfjuGAs8zTHED1wXb5+fgKeUTO6sW3lk6Kehcj+D2vnhw
	 MT1r9jNB8rXjpwr7oZHtNNk9ZVU8cbK381BELy+aKTZqgud6eEsprTsT4NbAETExdd
	 NZnkMAIyzvIi23qiVWLMO88oG4rGOYk8msAtvnDFiyPl2PXOHg8wbAKzoswcCPHEuL
	 Un5YizaNu8uHQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJM-000Nc3-Qa;
	Mon, 05 Feb 2024 10:34:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 19/26] KVM: arm64: Move existing feature disabling over to FGU infrastructure
Date: Mon,  5 Feb 2024 10:34:24 +0000
Message-Id: <20240205103431.1104133-20-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We already trap a bunch of existing features for the purpose of
disabling them (MAIR2, POR, ACCDATA, SME...).

Let's move them over to our brand new FGU infrastructure.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       |  4 ++++
 arch/arm64/kvm/arm.c                    |  6 ++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 17 +++--------------
 arch/arm64/kvm/sys_regs.c               | 23 +++++++++++++++++++++++
 4 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c69b258fc989..968a997b3f02 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -297,6 +297,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		6
 	/* Initial ID reg values loaded */
 #define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		7
+	/* Fine-Grained UNDEF initialised */
+#define KVM_ARCH_FLAG_FGU_INITIALIZED			8
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
@@ -1107,6 +1109,8 @@ int __init populate_nv_trap_config(void);
 bool lock_all_vcpus(struct kvm *kvm);
 void unlock_all_vcpus(struct kvm *kvm);
 
+void kvm_init_sysreg(struct kvm_vcpu *);
+
 /* MMIO helpers */
 void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
 unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c063e84fc72c..9f806c9b7d5d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -675,6 +675,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
+	/*
+	 * This needs to happen after NV has imposed its own restrictions on
+	 * the feature set
+	 */
+	kvm_init_sysreg(vcpu);
+
 	ret = kvm_timer_enable(vcpu);
 	if (ret)
 		return ret;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a09149fd91ed..245f9c1ca666 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -157,7 +157,7 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
+	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0;
 	u64 r_val, w_val;
 
 	CHECK_FGT_MASKS(HFGRTR_EL2);
@@ -174,13 +174,6 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	ctxt_sys_reg(hctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
 	ctxt_sys_reg(hctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
 
-	if (cpus_have_final_cap(ARM64_SME)) {
-		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
-
-		r_clr |= tmp;
-		w_clr |= tmp;
-	}
-
 	/*
 	 * Trap guest writes to TCR_EL1 to prevent it from enabling HA or HD.
 	 */
@@ -195,15 +188,11 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	compute_undef_clr_set(vcpu, kvm, HFGRTR_EL2, r_clr, r_set);
 	compute_undef_clr_set(vcpu, kvm, HFGWTR_EL2, w_clr, w_set);
 
-	/* The default to trap everything not handled or supported in KVM. */
-	tmp = HFGxTR_EL2_nAMAIR2_EL1 | HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nS2POR_EL1 |
-	      HFGxTR_EL2_nPOR_EL1 | HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nACCDATA_EL1;
-
-	r_val = __HFGRTR_EL2_nMASK & ~tmp;
+	r_val = __HFGRTR_EL2_nMASK;
 	r_val |= r_set;
 	r_val &= ~r_clr;
 
-	w_val = __HFGWTR_EL2_nMASK & ~tmp;
+	w_val = __HFGWTR_EL2_nMASK;
 	w_val |= w_set;
 	w_val &= ~w_clr;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 938df5dc3684..39e7c7f74717 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3942,6 +3942,29 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
 	return 0;
 }
 
+void kvm_init_sysreg(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
+		goto out;
+
+	kvm->arch.fgu[HFGxTR_GROUP] = (HFGxTR_EL2_nAMAIR2_EL1		|
+				       HFGxTR_EL2_nMAIR2_EL1		|
+				       HFGxTR_EL2_nS2POR_EL1		|
+				       HFGxTR_EL2_nPOR_EL1		|
+				       HFGxTR_EL2_nPOR_EL0		|
+				       HFGxTR_EL2_nACCDATA_EL1		|
+				       HFGxTR_EL2_nSMPRI_EL1_MASK	|
+				       HFGxTR_EL2_nTPIDR2_EL0_MASK);
+
+	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
+out:
+	mutex_unlock(&kvm->arch.config_lock);
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
 	struct sys_reg_params params;
-- 
2.39.2

