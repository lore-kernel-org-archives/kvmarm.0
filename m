Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B0C153BFF
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713809887; cv=none; b=C3joP8LM/m8CBfDGkkdUHnlf06GyjH1ZNtCfyQwp/DWGIIpg4awg1HrsDu2psW6c+RnbbIvH5wOWg6IhhDKxhaJ+xWsUuDbQHL92bqJcvOsHoxF48vfQqPWvbggpgu8LvoXvWElnAt5Rg+2N/XIaut+OdlkE8M2meo2gLVF12y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713809887; c=relaxed/simple;
	bh=EqSTPNMowwCgymn+v0WtAz03SumIq2vQhNLhAloGFtY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GcmVvPQtLd2VO71lZ3avWV817V3mmEEm7g5m+FtKaB9cj+0f2m0zbbLP8NC15ngIzJlaotc8qqjLBh1J80FFsIjWLqAfZQx+aV75j3RzLBC1IP3pxYuJlmGKkDt2q0r0azPF4u7TFpqRAPnqZg1xAkJCgrqJUv4U6Sv9Me10vCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A02haNec; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A02haNec"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso9800841276.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 11:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713809883; x=1714414683; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oI5PsFH5OqKQcxn/PnstoUW6QKwHJtSKvuBDm6LMOPQ=;
        b=A02haNecmxq2v2lMUSe+FoZRPSzK+nfv61QYZOsbp6EbDFxZag3vjR9kde5A/lUGef
         FMnEJltkkhfj3Jd/xy1NO9hSwYfQS7UIUxsrCRBYyl74NN4IoJ4i26WW/aNQdTDD6ONa
         FbFGEGJwdTJzf9/6Fe0ZT1aFJC8Y1tz/gB0aZ0dCxm49m6MPQ7FfeW8DVg2zmnlOhCf2
         bHwXs/jHqWrHsCGHhLY41dfa0UcWYfe1++5rRF+gTGC9yOdkmKkiNVNFT7YhGr/TsLIO
         SLBDtCUNcSWAbu5JqF63O9k3GRhhY27mbE9YMeHVUlhuTF/5RQh80pV8+lxP1CDQUQC0
         Dkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713809883; x=1714414683;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oI5PsFH5OqKQcxn/PnstoUW6QKwHJtSKvuBDm6LMOPQ=;
        b=e8y/wkULmH8D/ykbf6FOSAaXCr3kVcKLUte0W5IHuD9H6yroReAhtpJcsHu5W9Y4nS
         49xeZRSxrCuXOp8vP0oNlEEoOj6zGUpVJXjBJ8BYStVon6jr45svnPXIYq0Bylqonjo0
         DYbgSDHJFJILOSbMMMxZKS1xLW9vMpcqcCW+5EHDJJN+7dMtrwBGjCcCP4ScZHK+TG/J
         ZgPHzAeTx9ITJyfppCtsFXNI4w5X/Iuab0Jxc+KWTdDDwjfn26D2K1GbYgdzA4g7qXh9
         uoeZe7wlKax1pohHqrWXVhIB5MwghKJrQFrB97qf/rqhaqbGpy+LCqlM/xdXKErMibs/
         zFdg==
X-Forwarded-Encrypted: i=1; AJvYcCVzQRZqiNAJaumuhUobywsHUc+PVeBo+rHo/OLk7ho87tE48sZHkfrPLuEzfeilSp8uy9F/0vV+hpu0dkAKI10cvXVEoxXa
X-Gm-Message-State: AOJu0YwBksiYJgQpQpdGn9vadehQfEH7eXktD7FXaluJ6EB1hiZQVc7P
	1t1FhpGewdsicKvvTQRrb/SW1T1goNyS2qSefL8X3KGZtSq+Y8GzUknuiVFFIuPKVnLyGe1b+pr
	Iagr7HDLr8gTrMiwTOjMrOQ==
X-Google-Smtp-Source: AGHT+IEKODLHt0IICOPUeVBmNrFEXzRI0P6fCZGRCIutCpq1JEBl/VDOZ6TtUkQgtYk3XxRPPL+MJTGy5Ijvtnur4w==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1146:b0:dc7:49a9:6666 with
 SMTP id p6-20020a056902114600b00dc749a96666mr3364862ybu.3.1713809883531; Mon,
 22 Apr 2024 11:18:03 -0700 (PDT)
Date: Mon, 22 Apr 2024 18:17:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240422181716.237284-1-coltonlewis@google.com>
Subject: [PATCH v4] KVM: arm64: Add early_param to control WFx trapping
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
being trapped by KVM. Options for each param are trap, notrap, and
default. trap enables the trap. notrap disables the trap. default
preserves current behavior, disabling the trap if only a single task
is running and enabling otherwise.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
v4:

* Fixed inaccurate names that incorrectly implied this controls interrupts
  themselves instead of instructions waiting for interrupts and events
* Split into two separate params as interrupts (WFI) and events (WFE) do
  different things and may warrant separate controls.
* Document new params in Documentation/admin-guide/kernel-parameters.txt


v3:
https://lore.kernel.org/kvmarm/20240410175437.793508-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvmarm/20240319164341.1674863-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvmarm/20240129213918.3124494-1-coltonlewis@google.com/

 .../admin-guide/kernel-parameters.txt         | 22 +++++++-
 arch/arm64/include/asm/kvm_emulate.h          | 24 ++++++++-
 arch/arm64/include/asm/kvm_host.h             |  7 +++
 arch/arm64/kvm/arm.c                          | 54 +++++++++++++++++--
 4 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 31b3a25680d0..f8d16c792e66 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2653,6 +2653,27 @@
 			[KVM,ARM] Allow use of GICv4 for direct injection of
 			LPIs.

+	kvm-arm.wfe_trap_policy=
+			[KVM,ARM] Control when to set wfe instruction trap.
+
+			trap: set wfe instruction trap
+
+			notrap: clear wfe instruction trap
+
+			default: set wfe instruction trap only if multiple
+				 tasks are running on the CPU
+
+	kvm-arm.wfi_trap_policy=
+			[KVM,ARM] Control when to set wfi instruction trap.
+
+			trap: set wfi instruction trap
+
+			notrap: clear wfi instruction trap
+
+			default: set wfi instruction trap only if multiple
+				 tasks are running on the CPU
+
+
 	kvm_cma_resv_ratio=n [PPC]
 			Reserves given percentage from system memory area for
 			contiguous memory allocation for KVM hash pagetable
@@ -7394,4 +7415,3 @@
 				memory, and other data can't be written using
 				xmon commands.
 			off	xmon is disabled.
-
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b804fe832184..efd0a3fb6f00 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -109,9 +109,13 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }

-static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
+static inline void vcpu_clear_wfe_trap(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 &= ~HCR_TWE;
+}
+
+static inline void vcpu_clear_wfi_trap(struct kvm_vcpu *vcpu)
+{
 	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
 	    vcpu->kvm->arch.vgic.nassgireq)
 		vcpu->arch.hcr_el2 &= ~HCR_TWI;
@@ -119,12 +123,28 @@ static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TWI;
 }

-static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
+static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu_clear_wfe_trap(vcpu);
+	vcpu_clear_wfi_trap(vcpu);
+}
+
+static inline void vcpu_set_wfe_trap(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 |= HCR_TWE;
+}
+
+static inline void vcpu_set_wfi_trap(struct kvm_vcpu *vcpu)
+{
 	vcpu->arch.hcr_el2 |= HCR_TWI;
 }

+static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu_set_wfe_trap(vcpu);
+	vcpu_set_wfi_trap(vcpu);
+}
+
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
index a25265aca432..5106ba5a8a39 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -46,6 +46,8 @@
 #include <kvm/arm_psci.h>

 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
+static enum kvm_wfx_trap_policy kvm_wfi_trap_policy = KVM_WFX_NOTRAP_SINGLE_TASK;
+static enum kvm_wfx_trap_policy kvm_wfe_trap_policy = KVM_WFX_NOTRAP_SINGLE_TASK;

 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);

@@ -423,6 +425,12 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)

 }

+static bool kvm_should_clear_wfx_trap(enum kvm_wfx_trap_policy p)
+{
+	return (p == KVM_WFX_NOTRAP && kvm_vgic_global_state.has_gicv4)
+		|| (p == KVM_WFX_NOTRAP_SINGLE_TASK && single_task_running());
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_s2_mmu *mmu;
@@ -456,10 +464,15 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);

-	if (single_task_running())
-		vcpu_clear_wfx_traps(vcpu);
+	if (kvm_should_clear_wfx_trap(kvm_wfi_trap_policy))
+		vcpu_clear_wfi_trap(vcpu);
 	else
-		vcpu_set_wfx_traps(vcpu);
+		vcpu_set_wfi_trap(vcpu);
+
+	if (kvm_should_clear_wfx_trap(kvm_wfe_trap_policy))
+		vcpu_clear_wfe_trap(vcpu);
+	else
+		vcpu_set_wfe_trap(vcpu);

 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
@@ -2654,6 +2667,41 @@ static int __init early_kvm_mode_cfg(char *arg)
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
2.44.0.769.g3c40516874-goog
