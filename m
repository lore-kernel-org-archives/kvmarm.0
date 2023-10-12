Received: from out-190.mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32333D971
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 20:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZAcW9hZk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697144078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wRuvR9d20FW3r49LLRBUOztpimezgSu3lq/SWcb2GhI=;
	b=ZAcW9hZkEswreIr566SiZTk1SfoIHRLbMvYa2gXIxq9U5lKogs+Po51x2Lf5LlGtN+BL4q
	DXg6qLI6h8xzxs6sew2csXqxK2zOBpGcM3f7QbUyQsi2v0/5FmEBYwyn/iIgXRAiB+0Efa
	f5nCis7HbMGEJn2Z97IxAXEO38D3s1g=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 4/5] KVM: arm64: Rename helpers for VHE vCPU load/put
Date: Thu, 12 Oct 2023 20:54:21 +0000
Message-ID: <20231012205422.3924618-5-oliver.upton@linux.dev>
In-Reply-To: <20231012205422.3924618-1-oliver.upton@linux.dev>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The names for the helpers we expose to the 'generic' KVM code are a bit
imprecise; we switch the EL0 + EL1 sysreg context and setup trap
controls that do not need to change for every guest entry/exit. Rename +
shuffle things around a bit in preparation for loading the stage-2 MMU
context on vcpu_load().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h  |  4 ++--
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/arm.c               |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c    | 18 +++++++++++++++---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 11 ++++-------
 5 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index be0ab101c557..759adee42018 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1109,8 +1109,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 #endif
 
-void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
-void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu);
+void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu);
 
 int __init kvm_set_ipa_limit(void);
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 66efd67ea7e8..80c779d1307a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -93,6 +93,8 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu);
 void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt);
 #else
+void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu);
+void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu);
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3ab904adbd64..584be562b1d4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -448,7 +448,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
 	if (has_vhe())
-		kvm_vcpu_load_sysregs_vhe(vcpu);
+		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
@@ -472,7 +472,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_put_debug_state_flags(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
-		kvm_vcpu_put_sysregs_vhe(vcpu);
+		kvm_vcpu_put_vhe(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 6537f58b1a8c..d05b6a08dcde 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -93,12 +93,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 NOKPROBE_SYMBOL(__deactivate_traps);
 
 /*
- * Disable IRQs in {activate,deactivate}_traps_vhe_{load,put}() to
+ * Disable IRQs in __vcpu_{load,put}_{activate,deactivate}_traps() to
  * prevent a race condition between context switching of PMUSERENR_EL0
  * in __{activate,deactivate}_traps_common() and IPIs that attempts to
  * update PMUSERENR_EL0. See also kvm_set_pmuserenr().
  */
-void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
+static void __vcpu_load_activate_traps(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
 
@@ -107,7 +107,7 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }
 
-void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
+static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
 
@@ -116,6 +116,18 @@ void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }
 
+void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
+{
+	__vcpu_load_switch_sysregs(vcpu);
+	__vcpu_load_activate_traps(vcpu);
+}
+
+void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
+{
+	__vcpu_put_deactivate_traps(vcpu);
+	__vcpu_put_switch_sysregs(vcpu);
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index b35a178e7e0d..8e1e0d5033b6 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -52,7 +52,7 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
 NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
 
 /**
- * kvm_vcpu_load_sysregs_vhe - Load guest system registers to the physical CPU
+ * __vcpu_load_switch_sysregs - Load guest system registers to the physical CPU
  *
  * @vcpu: The VCPU pointer
  *
@@ -62,7 +62,7 @@ NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
  * and loading system register state early avoids having to load them on
  * every entry to the VM.
  */
-void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
+void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
@@ -92,12 +92,10 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 	__sysreg_restore_el1_state(guest_ctxt);
 
 	vcpu_set_flag(vcpu, SYSREGS_ON_CPU);
-
-	activate_traps_vhe_load(vcpu);
 }
 
 /**
- * kvm_vcpu_put_sysregs_vhe - Restore host system registers to the physical CPU
+ * __vcpu_put_switch_syregs - Restore host system registers to the physical CPU
  *
  * @vcpu: The VCPU pointer
  *
@@ -107,13 +105,12 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
  * and deferring saving system register state until we're no longer running the
  * VCPU avoids having to save them on every exit from the VM.
  */
-void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
+void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	deactivate_traps_vhe_put(vcpu);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
-- 
2.42.0.655.g421f12c284-goog

