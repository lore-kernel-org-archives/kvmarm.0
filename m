Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC890C433E3
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:03:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 723D72100A
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="v8C0mKTO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 723D72100A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C2EB4B2A7;
	Fri, 29 May 2020 12:03:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dA6yzM6CFJcZ; Fri, 29 May 2020 12:03:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DB2B4B282;
	Fri, 29 May 2020 12:03:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89BFA4B2A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:03:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id skj8sg806rSp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2020 12:03:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99FA44B26E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:03:39 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A6485208B8;
 Fri, 29 May 2020 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590768218;
 bh=amVH5RFLdFQFJjtlToCdeoqrSAOdahRz6usFBpk+xUA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=v8C0mKTOuLqeCONu/g9NG6VxutxPfFamSnkdOomEf0gWaSTImcVYC9IsDudcXSU+1
 F649tHdCO3eQCEG2p67m/3hvRZYlPdU3e7BbqH1KxkxqBTeSIXfGwyN7+Yg7l5Mhd1
 k50Rhen65OLSzvGuQ90jtqQOCPKaUWt3NMtHjnX8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jehSI-00GJKc-Pj; Fri, 29 May 2020 17:01:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 18/24] KVM: arm64: vgic-v3: Take cpu_if pointer directly
 instead of vcpu
Date: Fri, 29 May 2020 17:01:15 +0100
Message-Id: <20200529160121.899083-19-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com,
 dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com,
 zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Jiang Yi <giangyi@amazon.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

If we move the used_lrs field to the version-specific cpu interface
structure, the following functions only operate on the struct
vgic_v3_cpu_if and not the full vcpu:

  __vgic_v3_save_state
  __vgic_v3_restore_state
  __vgic_v3_activate_traps
  __vgic_v3_deactivate_traps
  __vgic_v3_save_aprs
  __vgic_v3_restore_aprs

This is going to be very useful for nested virt, so move the used_lrs
field and change the prototypes and implementations of these functions to
take the cpu_if parameter directly.

No functional change.

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 12 ++++++------
 arch/arm64/kvm/hyp/switch.c      |  8 ++++----
 arch/arm64/kvm/hyp/vgic-v3-sr.c  | 33 ++++++++++----------------------
 arch/arm64/kvm/vgic/vgic-v2.c    | 10 +++++-----
 arch/arm64/kvm/vgic/vgic-v3.c    | 14 ++++++++------
 arch/arm64/kvm/vgic/vgic.c       | 25 ++++++++++++++++--------
 include/kvm/arm_vgic.h           |  5 ++++-
 7 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fe57f60f06a8..4f67b0cdffe8 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -56,12 +56,12 @@
 
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
-void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
-void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
-void __vgic_v3_activate_traps(struct kvm_vcpu *vcpu);
-void __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu);
-void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
-void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
+void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8a1e81a400e0..c07a45643cd4 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -270,8 +270,8 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
-		__vgic_v3_save_state(vcpu);
-		__vgic_v3_deactivate_traps(vcpu);
+		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
+		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 	}
 }
 
@@ -279,8 +279,8 @@ static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 static void __hyp_text __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
-		__vgic_v3_activate_traps(vcpu);
-		__vgic_v3_restore_state(vcpu);
+		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
+		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 6b85773e15c4..10ed539835c1 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -194,10 +194,9 @@ static u32 __hyp_text __vgic_v3_read_ap1rn(int n)
 	return val;
 }
 
-void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = cpu_if->used_lrs;
 
 	/*
 	 * Make sure stores to the GIC via the memory mapped interface
@@ -230,10 +229,9 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = cpu_if->used_lrs;
 	int i;
 
 	if (used_lrs || cpu_if->its_vpe.its_vm) {
@@ -257,10 +255,8 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-void __hyp_text __vgic_v3_activate_traps(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-
 	/*
 	 * VFIQEn is RES1 if ICC_SRE_EL1.SRE is 1. This causes a
 	 * Group0 interrupt (as generated in GICv2 mode) to be
@@ -306,9 +302,8 @@ void __hyp_text __vgic_v3_activate_traps(struct kvm_vcpu *vcpu)
 		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 }
 
-void __hyp_text __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 	u64 val;
 
 	if (!cpu_if->vgic_sre) {
@@ -333,15 +328,11 @@ void __hyp_text __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu)
 		write_gicreg(0, ICH_HCR_EL2);
 }
 
-void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if;
 	u64 val;
 	u32 nr_pre_bits;
 
-	vcpu = kern_hyp_va(vcpu);
-	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-
 	val = read_gicreg(ICH_VTR_EL2);
 	nr_pre_bits = vtr_to_nr_pre_bits(val);
 
@@ -370,15 +361,11 @@ void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
 	}
 }
 
-void __hyp_text __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if;
 	u64 val;
 	u32 nr_pre_bits;
 
-	vcpu = kern_hyp_va(vcpu);
-	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-
 	val = read_gicreg(ICH_VTR_EL2);
 	nr_pre_bits = vtr_to_nr_pre_bits(val);
 
@@ -451,7 +438,7 @@ static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
 						    u32 vmcr,
 						    u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
 	u8 priority = GICv3_IDLE_PRIORITY;
 	int i, lr = -1;
 
@@ -490,7 +477,7 @@ static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
 static int __hyp_text __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu,
 					       int intid, u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
 	int i;
 
 	for (i = 0; i < used_lrs; i++) {
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 621cc168fe3f..ebf53a4e1296 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -56,7 +56,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
 
-	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
+	for (lr = 0; lr < vgic_cpu->vgic_v2.used_lrs; lr++) {
 		u32 val = cpuif->vgic_lr[lr];
 		u32 cpuid, intid = val & GICH_LR_VIRTUALID;
 		struct vgic_irq *irq;
@@ -120,7 +120,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
-	vgic_cpu->used_lrs = 0;
+	cpuif->used_lrs = 0;
 }
 
 /*
@@ -427,7 +427,7 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = cpu_if->used_lrs;
 	u64 elrsr;
 	int i;
 
@@ -448,7 +448,7 @@ static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 {
 	void __iomem *base = kvm_vgic_global_state.vctrl_base;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = vcpu->arch.vgic_cpu.vgic_v2.used_lrs;
 
 	if (!base)
 		return;
@@ -463,7 +463,7 @@ void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	void __iomem *base = kvm_vgic_global_state.vctrl_base;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = cpu_if->used_lrs;
 	int i;
 
 	if (!base)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 3ccd6d3cb4d3..76e2d85789ed 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -39,7 +39,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 
 	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
 
-	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
+	for (lr = 0; lr < cpuif->used_lrs; lr++) {
 		u64 val = cpuif->vgic_lr[lr];
 		u32 intid, cpuid;
 		struct vgic_irq *irq;
@@ -111,7 +111,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
-	vgic_cpu->used_lrs = 0;
+	cpuif->used_lrs = 0;
 }
 
 /* Requires the irq to be locked already */
@@ -662,10 +662,10 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	if (likely(cpu_if->vgic_sre))
 		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
 
-	kvm_call_hyp(__vgic_v3_restore_aprs, vcpu);
+	kvm_call_hyp(__vgic_v3_restore_aprs, kern_hyp_va(cpu_if));
 
 	if (has_vhe())
-		__vgic_v3_activate_traps(vcpu);
+		__vgic_v3_activate_traps(cpu_if);
 
 	WARN_ON(vgic_v4_load(vcpu));
 }
@@ -680,12 +680,14 @@ void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
 
 void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
 	WARN_ON(vgic_v4_put(vcpu, false));
 
 	vgic_v3_vmcr_sync(vcpu);
 
-	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
+	kvm_call_hyp(__vgic_v3_save_aprs, kern_hyp_va(cpu_if));
 
 	if (has_vhe())
-		__vgic_v3_deactivate_traps(vcpu);
+		__vgic_v3_deactivate_traps(cpu_if);
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 99b02ca730a8..c3643b7f101b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -786,6 +786,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 	int count;
 	bool multi_sgi;
 	u8 prio = 0xff;
+	int i = 0;
 
 	lockdep_assert_held(&vgic_cpu->ap_list_lock);
 
@@ -827,11 +828,14 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	vcpu->arch.vgic_cpu.used_lrs = count;
-
 	/* Nuke remaining LRs */
-	for ( ; count < kvm_vgic_global_state.nr_lr; count++)
-		vgic_clear_lr(vcpu, count);
+	for (i = count ; i < kvm_vgic_global_state.nr_lr; i++)
+		vgic_clear_lr(vcpu, i);
+
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		vcpu->arch.vgic_cpu.vgic_v2.used_lrs = count;
+	else
+		vcpu->arch.vgic_cpu.vgic_v3.used_lrs = count;
 }
 
 static inline bool can_access_vgic_from_kernel(void)
@@ -849,13 +853,13 @@ static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
 	else
-		__vgic_v3_save_state(vcpu);
+		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
 
 /* Sync back the hardware VGIC state into our emulation after a guest's run. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	int used_lrs;
 
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
@@ -864,7 +868,12 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
 
-	if (vgic_cpu->used_lrs)
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		used_lrs = vcpu->arch.vgic_cpu.vgic_v2.used_lrs;
+	else
+		used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
+
+	if (used_lrs)
 		vgic_fold_lr_state(vcpu);
 	vgic_prune_ap_list(vcpu);
 }
@@ -874,7 +883,7 @@ static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
 	else
-		__vgic_v3_restore_state(vcpu);
+		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
 
 /* Flush our emulation state into the GIC hardware before entering the guest. */
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 69f4164d6477..a8d8fdcd3723 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -274,6 +274,8 @@ struct vgic_v2_cpu_if {
 	u32		vgic_vmcr;
 	u32		vgic_apr;
 	u32		vgic_lr[VGIC_V2_MAX_LRS];
+
+	unsigned int used_lrs;
 };
 
 struct vgic_v3_cpu_if {
@@ -291,6 +293,8 @@ struct vgic_v3_cpu_if {
 	 * linking the Linux IRQ subsystem and the ITS together.
 	 */
 	struct its_vpe	its_vpe;
+
+	unsigned int used_lrs;
 };
 
 struct vgic_cpu {
@@ -300,7 +304,6 @@ struct vgic_cpu {
 		struct vgic_v3_cpu_if	vgic_v3;
 	};
 
-	unsigned int used_lrs;
 	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
 
 	raw_spinlock_t ap_list_lock;	/* Protects the ap_list */
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
