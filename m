Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16493181B9D
	for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714500931; cv=none; b=QktyuqrMw92nFPD2uysMyad8wFdp2OYJ90GBQCqT03Q9bjWK+V5o8XN90gri+UKwDs3JFNOheJq7JyMOucVWUA04R59OQ6f6/Ku4K0cQ9SKd31nL4gGV9uvnA6tRREAqkcx5fbOyGG0jvZGNrWvb9mpKY55DjCbtZhAop9hMtmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714500931; c=relaxed/simple;
	bh=SV3V6cxCe1hxXs4ffQ+5SRGEEiW4ZwMlBo8pUcrukNY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hUFbqNcvcl5lto79LOzgD2E2tVpI/fXybzFc0GeVNhGqsLGlr5BUEi32Lt6Eorr/3oZGreqTogckOuo4jzAkQf/nY2pCs8+cMsfu2puuhiDZmd+KhUKnQfCiQB1az5zejtnfOMObuuVgoBwZ+lkoVE9xyOZzeD17c4fDewjf1Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XLGiWoNW; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XLGiWoNW"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de45c577ca9so136384276.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Apr 2024 11:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714500927; x=1715105727; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OOND0Wc6LHFDakdT/Gp/z0KSYn+8JMGA/w2gsPmNcgU=;
        b=XLGiWoNW2iHl0f8LB9wxbauuxNmFLb7PV0zVfWtrkXf+myOIrr3YeW5Snllz/DtTsU
         5PxU3rqjl6kGUB1hDg88CXyaTrQWBVM7dh3seo6YbCkJIjyQV06JS7TDvfdEo4Si09zL
         ka2Nk7xVOtjdte++xjwebBCm+RTY3ispuz4Iqf1BRK+6hnk/32jHw6vQjfk0jUWMsSGt
         YZlzMDqNkvGEWoIHJVo0rm9+hmLehuX9rW5HG6xKfzKDyd3ENrrH2hNxfMDRTvdDm6KF
         VKp2yaKSWYf5k2N0BwLRpaFOMDPNba2DdXIzoSTtubBPUB5nFuVg/TjPCYHLRP+FK118
         KERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714500927; x=1715105727;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OOND0Wc6LHFDakdT/Gp/z0KSYn+8JMGA/w2gsPmNcgU=;
        b=hWNpW5ksR6DbhGTRbXtJ1shV0b9dSF+8d+s+owqa0NYKOQYydDdXCGthi7e+9Lj+Kl
         OQtGThSYhcJcyMSnxA1AysBn4MA+4ttwspDT7zwDjiCsIN9cRCjPjdLvh+wX8tOc7391
         7hJvRFjkMsOA57iRbOO45EzJs3itd2HdpS52AVy8yYfCx1c2P42iqFn5NcVT65VW+034
         E4E78ivNgnTrzWuLmCyWJepjioHjvZ863eBRJ99A1kj99FMXLUnNdur+avQnzVrEN1ZS
         7aU0MgXgS5H4lXlAX8QZCg3LeHEqFLR36LGsL/aaalhSn+tLsl559avrLitlwj65OTke
         KBEg==
X-Forwarded-Encrypted: i=1; AJvYcCUjfdlx5zDoxVkk3WA0w9bDHyyeMYm8IyJlFuaQvbdp2IX/8DvMLguflI5q93eAsNC6frOmnwCTDMztqun4ELhwo10Py1q0
X-Gm-Message-State: AOJu0YwCygvJ5ug17LL1tbiH9cuEfC4C2K4BALLXthsTKEc2xzLXkzc7
	45rzwA5kp3HCEg5l3tWwgt2KqL1hA94Mi7BIORTVPXjSS42I04nD3oxUmi0/q3Q0ofacOhTksS5
	PdxArLTd8dbX/PiVzZAq7mg==
X-Google-Smtp-Source: AGHT+IFZX4OkaZT9f1Iz17d6NCT/rGoZ3ImWb/jbwJPJ+SyqpNN0LxB8nnl5a1tJ2nYlbr07zt95ivtf9PAzW7KOJQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:110c:b0:dda:c4ec:7db5 with
 SMTP id o12-20020a056902110c00b00ddac4ec7db5mr176675ybu.4.1714500926956; Tue,
 30 Apr 2024 11:15:26 -0700 (PDT)
Date: Tue, 30 Apr 2024 18:14:44 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430181444.670773-1-coltonlewis@google.com>
Subject: [PATCH v5] KVM: arm64: Add early_param to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add an early_params to control WFI and WFE trapping. This is to
control the degree guests can wait for interrupts on their own without
being trapped by KVM. Options for each param are trap and notrap. trap
enables the trap. notrap disables the trap. Absent an explicitly set
policy, default to current behavior: disabling the trap if only a
single task is running and enabling otherwise.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
v5:

* Move trap configuration to vcpu_reset_hcr(). This required moving
  kvm_emulate.h:vcpu_reset_hcr() to arm.c:kvm_vcpu_reset_hcr() to avoid needing
  to pull scheduler headers and my enums into kvm_emulate.h. I thought the
  function looked too bulky for that header anyway.
* Delete vcpu_{set,clear}_vfx_traps helpers that are no longer used anywhere.
* Remove documentation of explicit option for default behavior to avoid any
  implicit suggestion default behavior will stay that way.

v4:
https://lore.kernel.org/kvmarm/20240422181716.237284-1-coltonlewis@google.com/

v3:
https://lore.kernel.org/kvmarm/20240410175437.793508-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvmarm/20240319164341.1674863-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvmarm/20240129213918.3124494-1-coltonlewis@google.com/

 .../admin-guide/kernel-parameters.txt         |  16 +++
 arch/arm64/include/asm/kvm_emulate.h          |  53 ---------
 arch/arm64/include/asm/kvm_host.h             |   7 ++
 arch/arm64/kvm/arm.c                          | 110 +++++++++++++++++-
 4 files changed, 127 insertions(+), 59 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 31b3a25680d0..a4d94d9abbe4 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2653,6 +2653,22 @@
 			[KVM,ARM] Allow use of GICv4 for direct injection of
 			LPIs.

+	kvm-arm.wfe_trap_policy=
+			[KVM,ARM] Control when to set WFE instruction trap for
+			KVM VMs.
+
+			trap: set WFE instruction trap
+
+			notrap: clear WFE instruction trap
+
+	kvm-arm.wfi_trap_policy=
+			[KVM,ARM] Control when to set WFI instruction trap for
+			KVM VMs.
+
+			trap: set WFI instruction trap
+
+			notrap: clear WFI instruction trap
+
 	kvm_cma_resv_ratio=n [PPC]
 			Reserves given percentage from system memory area for
 			contiguous memory allocation for KVM hash pagetable
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b804fe832184..c2a9a409ebfe 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -67,64 +67,11 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 }
 #endif

-static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
-	if (has_vhe() || has_hvhe())
-		vcpu->arch.hcr_el2 |= HCR_E2H;
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
-		/* route synchronous external abort exceptions to EL2 */
-		vcpu->arch.hcr_el2 |= HCR_TEA;
-		/* trap error record accesses */
-		vcpu->arch.hcr_el2 |= HCR_TERR;
-	}
-
-	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
-		vcpu->arch.hcr_el2 |= HCR_FWB;
-	} else {
-		/*
-		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
-		 * get set in SCTLR_EL1 such that we can detect when the guest
-		 * MMU gets turned on and do the necessary cache maintenance
-		 * then.
-		 */
-		vcpu->arch.hcr_el2 |= HCR_TVM;
-	}
-
-	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
-	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
-		vcpu->arch.hcr_el2 |= HCR_TID4;
-	else
-		vcpu->arch.hcr_el2 |= HCR_TID2;
-
-	if (vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 &= ~HCR_RW;
-
-	if (kvm_has_mte(vcpu->kvm))
-		vcpu->arch.hcr_el2 |= HCR_ATA;
-}
-
 static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 {
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }

-static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.hcr_el2 &= ~HCR_TWE;
-	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
-	    vcpu->kvm->arch.vgic.nassgireq)
-		vcpu->arch.hcr_el2 &= ~HCR_TWI;
-	else
-		vcpu->arch.hcr_el2 |= HCR_TWI;
-}
-
-static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.hcr_el2 |= HCR_TWE;
-	vcpu->arch.hcr_el2 |= HCR_TWI;
-}
-
 static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..315ee7bfc1cb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -67,6 +67,13 @@ enum kvm_mode {
 	KVM_MODE_NV,
 	KVM_MODE_NONE,
 };
+
+enum kvm_wfx_trap_policy {
+	KVM_WFX_NOTRAP_SINGLE_TASK, /* Default option */
+	KVM_WFX_NOTRAP,
+	KVM_WFX_TRAP,
+};
+
 #ifdef CONFIG_KVM
 enum kvm_mode kvm_get_mode(void);
 #else
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..5ec52333e042 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -46,6 +46,8 @@
 #include <kvm/arm_psci.h>

 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
+static enum kvm_wfx_trap_policy kvm_wfi_trap_policy = KVM_WFX_NOTRAP_SINGLE_TASK;
+static enum kvm_wfx_trap_policy kvm_wfe_trap_policy = KVM_WFX_NOTRAP_SINGLE_TASK;

 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);

@@ -456,11 +458,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);

-	if (single_task_running())
-		vcpu_clear_wfx_traps(vcpu);
-	else
-		vcpu_set_wfx_traps(vcpu);
-
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
@@ -1391,6 +1388,72 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	return 0;
 }

+static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
+{
+	if (likely(kvm_wfi_trap_policy == KVM_WFX_NOTRAP_SINGLE_TASK))
+		return single_task_running() &&
+			(atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
+			 vcpu->kvm->arch.vgic.nassgireq);
+
+	return kvm_wfi_trap_policy == KVM_WFX_NOTRAP;
+}
+
+static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
+{
+	if (likely(kvm_wfe_trap_policy == KVM_WFX_NOTRAP_SINGLE_TASK))
+		return single_task_running();
+
+	return kvm_wfe_trap_policy == KVM_WFX_NOTRAP;
+}
+
+static inline void kvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
+	if (has_vhe() || has_hvhe())
+		vcpu->arch.hcr_el2 |= HCR_E2H;
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
+	}
+
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
+		vcpu->arch.hcr_el2 |= HCR_FWB;
+	} else {
+		/*
+		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
+		 * get set in SCTLR_EL1 such that we can detect when the guest
+		 * MMU gets turned on and do the necessary cache maintenance
+		 * then.
+		 */
+		vcpu->arch.hcr_el2 |= HCR_TVM;
+	}
+
+	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
+		vcpu->arch.hcr_el2 |= HCR_TID4;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TID2;
+
+	if (vcpu_el1_is_32bit(vcpu))
+		vcpu->arch.hcr_el2 &= ~HCR_RW;
+
+	if (kvm_has_mte(vcpu->kvm))
+		vcpu->arch.hcr_el2 |= HCR_ATA;
+
+
+	if (kvm_vcpu_should_clear_twe(vcpu))
+		vcpu->arch.hcr_el2 &= ~HCR_TWE;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TWE;
+
+	if (kvm_vcpu_should_clear_twi(vcpu))
+		vcpu->arch.hcr_el2 &= ~HCR_TWI;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TWI;
+}
+
 static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 					 struct kvm_vcpu_init *init)
 {
@@ -1427,7 +1490,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 			icache_inval_all_pou();
 	}

-	vcpu_reset_hcr(vcpu);
+	kvm_vcpu_reset_hcr(vcpu);
 	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);

 	/*
@@ -2654,6 +2717,41 @@ static int __init early_kvm_mode_cfg(char *arg)
 }
 early_param("kvm-arm.mode", early_kvm_mode_cfg);

+static int __init early_kvm_wfx_trap_policy_cfg(char *arg, enum kvm_wfx_trap_policy *p)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (strcmp(arg, "trap") == 0) {
+		*p = KVM_WFX_TRAP;
+		return 0;
+	}
+
+	if (strcmp(arg, "notrap") == 0) {
+		*p = KVM_WFX_NOTRAP;
+		return 0;
+	}
+
+	if (strcmp(arg, "default") == 0) {
+		*p = KVM_WFX_NOTRAP_SINGLE_TASK;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int __init early_kvm_wfi_trap_policy_cfg(char *arg)
+{
+	return early_kvm_wfx_trap_policy_cfg(arg, &kvm_wfi_trap_policy);
+}
+early_param("kvm-arm.wfi_trap_policy", early_kvm_wfi_trap_policy_cfg);
+
+static int __init early_kvm_wfe_trap_policy_cfg(char *arg)
+{
+	return early_kvm_wfx_trap_policy_cfg(arg, &kvm_wfe_trap_policy);
+}
+early_param("kvm-arm.wfe_trap_policy", early_kvm_wfe_trap_policy_cfg);
+
 enum kvm_mode kvm_get_mode(void)
 {
 	return kvm_mode;
--
2.45.0.rc0.197.gbae5840b3b-goog
