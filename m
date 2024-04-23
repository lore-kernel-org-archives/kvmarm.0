Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D77913BAF5
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884781; cv=none; b=WTD4cmZeefi0AKcgOkahIyaH3f1743JxolAtnEmLi2U+X44/xj8zudcYMjp6GEC4Z+6erWMtAnI6+0B4yY4zTTPEd4Y9xO/iQ5jOIliYDhs5h9o6xBw1KKlNln6/8lsiF332MrupnV5kDhGnfrhzw+CHgnT+K+J2xOfOA3kTnz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884781; c=relaxed/simple;
	bh=Drdcxmv3Aqjbpnr8Fyhim/arM6wEW611DDIICvf4weA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oFw58dKpMQr0O+YZz7/bVRgFIfeiNH0o0c48QIsNTh/tXpNFRc/Rjh6JFGYy6h0MsyTnvrka2kXQXGjqR5DIGU/ChStSg3uEExpvSoMrH3k5kvQEKt1lDiZYN5rIoxVomCqCAK0XBOw9ORIatFZ0CRe1Jo26/3nGc3kPIGQpAq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XCJCCjWn; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XCJCCjWn"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-343e46df264so3930116f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884777; x=1714489577; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g/kRZlE6b7TEKrvzcJMjG33YHE+fzQcdwoxZ/lVhhtU=;
        b=XCJCCjWneNxlwg1pfeTkzYVpuiW4hvlaSwSev8Zi5OfQF4WJ3538JSoEmOXNL/pJnv
         ZhIfS5zFW9aA4j9eWfsxa7K8FSieF1y/Raw5whk5JSmi1bi0CR0rA/eKebLfxWKUUg1F
         4UoyfzcNHTczpnx+Dtcbminf+G35ssc8i5Wj+9NnXt+kTg4EfEypnU0NcsTAHQ7smZy8
         +qwMfQKVNj1MykHta+Ad/Tns4YT4NF32F/Nn4nZKYcBDuH5JzAssfxAc4wI7e+hvNMV5
         0b63b8KY/xXUKjFSyHQnXQ6Am0tKI8gEPL03k7Pw1cV+Uta6g0ILJcCxrpu8geB6P+s5
         Jksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884777; x=1714489577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g/kRZlE6b7TEKrvzcJMjG33YHE+fzQcdwoxZ/lVhhtU=;
        b=nbecbxFnTFwSPXZDO6NprbFDkzWUuwnbERh+tKgWOcBP3d4MTi/wbbjBPB9QsPLs6Z
         NpYuXKQaOSVvUydFuDd2H8IhlvnhpmsYRiw1cv9kvCTUYXrwHRSncLgMi6E3LrPWUhO4
         n4FCdPbDgMWv4kMfi1GV7rQ/AZlkjMy8mdlMamkucewUpLdqSC1l/qgilTJ1zey8R9Uk
         MePwn9bdoYn6MRcmZubD/EGTjlzdT5aqkngn4K0lCErnbpSiQDAbWwj69Yf0v6CwdDIK
         yKxspOOYPW5nA8YkjKSexUGEQgPXnwKlMRrVfFGvXZXzufsfPaIKkng3AK3I1dvZ4vbC
         VLpQ==
X-Gm-Message-State: AOJu0YwNiqEDDsi82MNpPZ/NlPak4oj+0g6argFVi3wJap9scwpD5vUT
	s14EG8Uo43i1/gQFWQbtfgJloWaWMav5/1zeDbaib0T/RZ6PEjZjrpj+oAv25lLAyxf+Rdse8cV
	A/CnS7zgB1v9mq1czWGKzSGzvp5RP4FCPdNLIroemWwtZVPSt646eh6kHez5z42cDBfwT5SGlGl
	+ODIuNGXj1HfJ6tcXIW3wkaUE0S6A=
X-Google-Smtp-Source: AGHT+IGNWDSOk2YkxCGPHkNg5XAua7oujH9yn6d/QTo7DtV2nCbFMEDanTrdYp08uJ7PEO0HGHFqxtngCA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:b4f:b0:343:c41b:3e37 with SMTP id
 dk15-20020a0560000b4f00b00343c41b3e37mr33325wrb.10.1713884777594; Tue, 23 Apr
 2024 08:06:17 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:24 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-17-tabba@google.com>
Subject: [PATCH v4 16/30] KVM: arm64: Simplify vgic-v3 hypercalls
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

Consolidate the GICv3 VMCR accessor hypercalls into the APR save/restore
hypercalls so that all of the EL2 GICv3 state is covered by a single pair
of hypercalls.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  8 ++------
 arch/arm64/include/asm/kvm_hyp.h   |  4 ++--
 arch/arm64/kvm/arm.c               |  5 ++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 24 ++++++------------------
 arch/arm64/kvm/hyp/vgic-v3-sr.c    | 27 +++++++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-v2.c      |  9 +--------
 arch/arm64/kvm/vgic/vgic-v3.c      | 23 ++---------------------
 arch/arm64/kvm/vgic/vgic.c         | 11 -----------
 arch/arm64/kvm/vgic/vgic.h         |  2 --
 include/kvm/arm_vgic.h             |  1 -
 10 files changed, 38 insertions(+), 76 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 24b5e6b23417..a6330460d9e5 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -73,10 +73,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_write_vmcr,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_init_traps,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
@@ -241,8 +239,6 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
 
 extern u64 __vgic_v3_get_gic_config(void);
-extern u64 __vgic_v3_read_vmcr(void);
-extern void __vgic_v3_write_vmcr(u32 vmcr);
 extern void __vgic_v3_init_lrs(void);
 
 extern u64 __kvm_get_mdcr_el2(void);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3e2a1ac0c9bb..3e80464f8953 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -80,8 +80,8 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if);
-void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
-void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_save_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9eab8f2c6db..e1003c782792 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -857,9 +857,8 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	 * doorbells to be signalled, should an interrupt become pending.
 	 */
 	preempt_disable();
-	kvm_vgic_vmcr_sync(vcpu);
 	vcpu_set_flag(vcpu, IN_WFI);
-	vgic_v4_put(vcpu);
+	kvm_vgic_put(vcpu);
 	preempt_enable();
 
 	kvm_vcpu_halt(vcpu);
@@ -867,7 +866,7 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 	vcpu_clear_flag(vcpu, IN_WFI);
-	vgic_v4_load(vcpu);
+	kvm_vgic_load(vcpu);
 	preempt_enable();
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 26561c562f7a..d5c48dc98f67 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -175,16 +175,6 @@ static void handle___vgic_v3_get_gic_config(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __vgic_v3_get_gic_config();
 }
 
-static void handle___vgic_v3_read_vmcr(struct kvm_cpu_context *host_ctxt)
-{
-	cpu_reg(host_ctxt, 1) = __vgic_v3_read_vmcr();
-}
-
-static void handle___vgic_v3_write_vmcr(struct kvm_cpu_context *host_ctxt)
-{
-	__vgic_v3_write_vmcr(cpu_reg(host_ctxt, 1));
-}
-
 static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
 {
 	__vgic_v3_init_lrs();
@@ -195,18 +185,18 @@ static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __kvm_get_mdcr_el2();
 }
 
-static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
+static void handle___vgic_v3_save_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
 
-	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
+	__vgic_v3_save_vmcr_aprs(kern_hyp_va(cpu_if));
 }
 
-static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
+static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
 
-	__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
+	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
 }
 
 static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
@@ -337,10 +327,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
-	HANDLE_FUNC(__vgic_v3_read_vmcr),
-	HANDLE_FUNC(__vgic_v3_write_vmcr),
-	HANDLE_FUNC(__vgic_v3_save_aprs),
-	HANDLE_FUNC(__vgic_v3_restore_aprs),
+	HANDLE_FUNC(__vgic_v3_save_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__pkvm_vcpu_init_traps),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 6cb638b184b1..7b397fad26f2 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -330,7 +330,7 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 		write_gicreg(0, ICH_HCR_EL2);
 }
 
-void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
+static void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 val;
 	u32 nr_pre_bits;
@@ -363,7 +363,7 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 	}
 }
 
-void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
+static void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 val;
 	u32 nr_pre_bits;
@@ -455,16 +455,35 @@ u64 __vgic_v3_get_gic_config(void)
 	return val;
 }
 
-u64 __vgic_v3_read_vmcr(void)
+static u64 __vgic_v3_read_vmcr(void)
 {
 	return read_gicreg(ICH_VMCR_EL2);
 }
 
-void __vgic_v3_write_vmcr(u32 vmcr)
+static void __vgic_v3_write_vmcr(u32 vmcr)
 {
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
+void __vgic_v3_save_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if)
+{
+	__vgic_v3_save_aprs(cpu_if);
+	if (cpu_if->vgic_sre)
+		cpu_if->vgic_vmcr = __vgic_v3_read_vmcr();
+}
+
+void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if)
+{
+	/*
+	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
+	 * is dependent on ICC_SRE_EL1.SRE, and we have to perform the
+	 * VMCR_EL2 save/restore in the world switch.
+	 */
+	if (cpu_if->vgic_sre)
+		__vgic_v3_write_vmcr(cpu_if->vgic_vmcr);
+	__vgic_v3_restore_aprs(cpu_if);
+}
+
 static int __vgic_v3_bpr_min(void)
 {
 	/* See Pseudocode for VPriorityGroup */
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 7e9cdb78f7ce..ae5a44d5702d 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -464,17 +464,10 @@ void vgic_v2_load(struct kvm_vcpu *vcpu)
 		       kvm_vgic_global_state.vctrl_base + GICH_APR);
 }
 
-void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu)
-{
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-
-	cpu_if->vgic_vmcr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VMCR);
-}
-
 void vgic_v2_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 
-	vgic_v2_vmcr_sync(vcpu);
+	cpu_if->vgic_vmcr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VMCR);
 	cpu_if->vgic_apr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_APR);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 4ea3340786b9..ed6e412cd74b 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -722,15 +722,7 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	/*
-	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
-	 * is dependent on ICC_SRE_EL1.SRE, and we have to perform the
-	 * VMCR_EL2 save/restore in the world switch.
-	 */
-	if (likely(cpu_if->vgic_sre))
-		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
-
-	kvm_call_hyp(__vgic_v3_restore_aprs, cpu_if);
+	kvm_call_hyp(__vgic_v3_restore_vmcr_aprs, cpu_if);
 
 	if (has_vhe())
 		__vgic_v3_activate_traps(cpu_if);
@@ -738,24 +730,13 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	WARN_ON(vgic_v4_load(vcpu));
 }
 
-void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
-{
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-
-	if (likely(cpu_if->vgic_sre))
-		cpu_if->vgic_vmcr = kvm_call_hyp_ret(__vgic_v3_read_vmcr);
-}
-
 void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
 	WARN_ON(vgic_v4_put(vcpu));
 
-	vgic_v3_vmcr_sync(vcpu);
-
-	kvm_call_hyp(__vgic_v3_save_aprs, cpu_if);
-
 	if (has_vhe())
 		__vgic_v3_deactivate_traps(cpu_if);
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 4ec93587c8cd..fcc5747f51e9 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -939,17 +939,6 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 		vgic_v3_put(vcpu);
 }
 
-void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu)
-{
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
-		return;
-
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_vmcr_sync(vcpu);
-	else
-		vgic_v3_vmcr_sync(vcpu);
-}
-
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0c2b82de8fa3..4b93528e6a89 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -214,7 +214,6 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 void vgic_v2_init_lrs(void);
 void vgic_v2_load(struct kvm_vcpu *vcpu);
 void vgic_v2_put(struct kvm_vcpu *vcpu);
-void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu);
 
 void vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void vgic_v2_restore_state(struct kvm_vcpu *vcpu);
@@ -253,7 +252,6 @@ bool vgic_v3_check_base(struct kvm *kvm);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);
 void vgic_v3_put(struct kvm_vcpu *vcpu);
-void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu);
 
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 47035946648e..0c3cce31e0a2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -388,7 +388,6 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
-void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-- 
2.44.0.769.g3c40516874-goog

