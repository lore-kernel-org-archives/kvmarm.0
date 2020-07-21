Return-Path: <SRS0=7ri5=BA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFBDC433E2
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5AFA207DD
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oDDM7LtH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5AFA207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 811B94B1CE;
	Tue, 21 Jul 2020 09:31:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gzuDoXOLgs7O; Tue, 21 Jul 2020 09:31:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41C1D4B1E8;
	Tue, 21 Jul 2020 09:31:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 137834B13A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:18:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3HIF9N8gipRb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jul 2020 00:18:13 -0400 (EDT)
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com
 [209.85.216.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D11474B23A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:18:13 -0400 (EDT)
Received: by mail-pj1-f68.google.com with SMTP id gc15so854362pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 21:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=R2tHBpFD/zM6h4tVPj+IrVJrkSfg9TGKlPGPIT24nik=;
 b=oDDM7LtHqXp5qpYiVH+FGIF7mIeFw9g/H9ceCsGbukvs6IZheFo4rGnwuTYqTjnOki
 03STa3SP9VOwJNdHhCUbMJyOnZs0f8h96t7P+jyufj1kK3CMKp+TXeMtdz8WHmv0Gyq3
 B9NO1IV9zbuiC7/6SbmNUx7cHgP4dY8qtcGruBUDT0+imgs8aJfPRZyeZH8j6tkhlbWk
 AfElBlurX1Xx9rnLY8EdqmRmgyMSkZU7eNAfGSPIryTbgk+eFxgt3qdsZd7cbt+dKZIk
 GfGZGMXncVsr8enfp9zxjyZOHzpxNRGmU0U7bo19wHRH9R/0JZdE8Lsr3lIie2QH+znF
 YrFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=R2tHBpFD/zM6h4tVPj+IrVJrkSfg9TGKlPGPIT24nik=;
 b=ALB3hdlRZUJP98dJS8E/lv88LwzO1RtIePFFj+JkiAXOqECtqqEcW6ufGAOhn9WipX
 GV6W80QIOLmI4c+N6gxIirM7zuvzRgH/cZEt4yZ7AaWxLpI/GBGHgnyCiZEgakFiIgdP
 8b/YW9uo+kkE54+lQSAPq2xvw8WUV6bYdYdmiDl57YyHgl01MHAGI+eX6vXbIZ7poG/V
 vOSEHNOs4RoFNrsFvjQYgsCgyDv9jqTLBTXWzpOU4o5dBqY+VKKhNIst4/vVx05yaAU6
 vWjOsKPib8fWaITvqzU0I6PnkTTplx6GPCdgX4l7dpW4BBCIsYnrs2npl0gOXow99cZW
 fjlg==
X-Gm-Message-State: AOAM532m6sFnqHECsx0K5wOI4DcIduHPP3gMhwu5WsmASy1i9oKI5JOj
 qCIfGxyZBQ/56KvKxa0C44w=
X-Google-Smtp-Source: ABdhPJz6jDEXiIALuJdwmDFR6vbfWPQbyUI4QPMyQxgQaCt9p5wG5NHhrMHzWwsT8nvAm/+lHWNlWw==
X-Received: by 2002:a17:90b:390e:: with SMTP id
 ob14mr2450924pjb.221.1595305092914; 
 Mon, 20 Jul 2020 21:18:12 -0700 (PDT)
Received: from localhost.localdomain ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
 by smtp.gmail.com with ESMTPSA id
 e28sm18467270pfm.177.2020.07.20.21.18.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jul 2020 21:18:12 -0700 (PDT)
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC][PATCH 3/4] arm64: add host pvstate support
Date: Tue, 21 Jul 2020 13:17:41 +0900
Message-Id: <20200721041742.197354-4-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 21 Jul 2020 09:31:48 -0400
Cc: joelaf@google.com, linux-kernel@vger.kernel.org,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, suleiman@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Add PV-state support bits to the host. Host uses the guest
PV-state per-CPU pointers to update the VCPU state each time
it kvm_arch_vcpu_load() or kvm_arch_vcpu_put() the VCPU, so
that guest scheduler can become aware of the fact that not
all VCPUs are always available. Currently guest scheduler
on amr64 always assumes that all CPUs are available because
vcpu_is_preempted() is not implemented on arm64.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 arch/arm64/include/asm/kvm_host.h | 23 ++++++++++++
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/arm.c              |  4 +++
 arch/arm64/kvm/hypercalls.c       | 11 ++++++
 arch/arm64/kvm/pvstate.c          | 58 +++++++++++++++++++++++++++++++
 5 files changed, 97 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/pvstate.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f6485c1b8c15..e6f325a4ba70 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -372,6 +372,12 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	/* PV state of the VCPU (e.g. vcpu_is_preempted()) */
+	struct {
+		gpa_t base;
+		struct gfn_to_hva_cache ghc;
+	} pv_state;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -556,6 +562,23 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
 	return (vcpu_arch->steal.base != GPA_INVALID);
 }
 
+int kvm_init_vcpu_state(struct kvm_vcpu *vcpu, gfn_t addr);
+int kvm_release_vcpu_state(struct kvm_vcpu *vcpu);
+
+static inline void kvm_arm_vcpu_state_init(struct kvm_vcpu_arch *vcpu_arch)
+{
+	vcpu_arch->pv_state.base = GPA_INVALID;
+	memset(&vcpu_arch->pv_state.ghc, 0x00, sizeof(struct gfn_to_hva_cache));
+}
+
+static inline bool
+kvm_arm_is_vcpu_state_enabled(struct kvm_vcpu_arch *vcpu_arch)
+{
+	return (vcpu_arch->pv_state.base != GPA_INVALID);
+}
+
+void kvm_update_vcpu_preempted(struct kvm_vcpu *vcpu, bool preempted);
+
 void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 99977c1972cc..efc05ac0d781 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_KVM) += hyp/
 
 kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o \
-	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
+	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o pvstate.o \
 	 inject_fault.o regmap.o va_layout.o hyp.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 691d21e4c717..a1229e3b7117 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -265,6 +265,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
+	kvm_arm_vcpu_state_init(&vcpu->arch);
+
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
 
 	err = kvm_vgic_vcpu_init(vcpu);
@@ -355,10 +357,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
+	kvm_update_vcpu_preempted(vcpu, false);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_update_vcpu_preempted(vcpu, true);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
 		kvm_vcpu_put_sysregs_vhe(vcpu);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 550dfa3e53cd..3660552a8e02 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -52,6 +52,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
 			val = SMCCC_RET_SUCCESS;
 			break;
+		case ARM_SMCCC_HV_PV_STATE_FEATURES:
+			val = SMCCC_RET_SUCCESS;
+			break;
 		}
 		break;
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
@@ -62,6 +65,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		if (gpa != GPA_INVALID)
 			val = gpa;
 		break;
+	case ARM_SMCCC_HV_PV_STATE_INIT:
+		if (kvm_init_vcpu_state(vcpu, smccc_get_arg1(vcpu)) == 0)
+			val = SMCCC_RET_SUCCESS;
+		break;
+	case ARM_SMCCC_HV_PV_STATE_RELEASE:
+		if (kvm_release_vcpu_state(vcpu) == 0)
+			val = SMCCC_RET_SUCCESS;
+		break;
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/arch/arm64/kvm/pvstate.c b/arch/arm64/kvm/pvstate.c
new file mode 100644
index 000000000000..3152555f3ed2
--- /dev/null
+++ b/arch/arm64/kvm/pvstate.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_mmu.h>
+#include <asm/paravirt.h>
+
+#include <kvm/arm_hypercalls.h>
+
+int kvm_init_vcpu_state(struct kvm_vcpu *vcpu, gpa_t addr)
+{
+	if (kvm_arm_is_vcpu_state_enabled(&vcpu->arch))
+		return 0;
+
+	if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+				      &vcpu->arch.pv_state.ghc,
+				      addr,
+				      sizeof(struct pvstate_vcpu_info)))
+		return -EINVAL;
+
+	vcpu->arch.pv_state.base = addr;
+	return 0;
+}
+
+int kvm_release_vcpu_state(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_arm_is_vcpu_state_enabled(&vcpu->arch))
+		return 0;
+
+	vcpu->arch.pv_state.base = GPA_INVALID;
+	return 0;
+}
+
+void kvm_update_vcpu_preempted(struct kvm_vcpu *vcpu, bool preempted)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 idx;
+
+	if (!kvm_arm_is_vcpu_state_enabled(&vcpu->arch))
+		return;
+
+	/*
+	 * This function is called from atomic context, so we need to
+	 * disable page faults. kvm_write_guest_cached() will call
+	 * might_fault().
+	 */
+	pagefault_disable();
+	/*
+	 * Need to take the SRCU lock because kvm_write_guest_offset_cached()
+	 * calls kvm_memslots();
+	 */
+	idx = srcu_read_lock(&kvm->srcu);
+	kvm_write_guest_cached(kvm, &vcpu->arch.pv_state.ghc,
+			       &preempted, sizeof(bool));
+	srcu_read_unlock(&kvm->srcu, idx);
+	pagefault_enable();
+}
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
