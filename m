Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E09EC4332F
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2141B60F58
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2141B60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8EED4A534;
	Sun, 10 Oct 2021 10:56:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8ZzFF2T5X-fm; Sun, 10 Oct 2021 10:56:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58FBF4B0BD;
	Sun, 10 Oct 2021 10:56:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 664AF49F5F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 61PGXmngCwv3 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 10:56:41 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F9964B08F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:41 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 j193-20020a2523ca000000b005b789d71d9aso19678544ybj.21
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 07:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AF4eoE9nmTsCT0Js3LBGybKDMs//CEnYD1ixUfZLO5A=;
 b=XflL05ADful4uxsps5ra0A+wCH0x6MWE/ao6NvEq/CwT3pb3pn0AhNehQzl9K1uV0u
 aEAtxDXK0pevL/6oelBdHVRG+T6rYlw+ZHt651DXOb5PeW8GkuO0EjpdoACHGkRGH4K7
 zS9QdAnUbD0AnRFK3OO/uoZLLGW4IV4TbhKfHz99CqZzJxgt8o/1eavDbTsSwTDUeupa
 EF32yWN3AQRSkEpn0EI0xzSzNcVXcDBLHB8I262A2nJCZX/e8SQsIiX9dlM5zU9zVpJU
 gpk8cnMKk+EYhQX/g1gJ9EnQzIUJhjfCg2z+5R1/TG6QcSHvxLvkOGnoKpuEHVbN2N1V
 Vmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AF4eoE9nmTsCT0Js3LBGybKDMs//CEnYD1ixUfZLO5A=;
 b=bph8ATFvRP8WA3yWPUy77FmaqaNfCmI1TTLKd+T5+29BNHiQS9zPeGDqhq1pDc7Fgz
 6dcJSKJrwEK8yOJ98d+ZoxaP28Cg4lF+hcOkdBbA79fgngh61YwS8y8AZ3LZ83A9PL3/
 UTasM9VICGMUcLDkD3yfaycCIaPCacz/TYYqSLaD17OdZzle7BIXEDJ8rs2okdOp9wMd
 zPs++wz6K4VUcDco7BlnmvJLCXukhKmygbVgb1Awx05sXg58cOcpGg+NzAh6NvRIyV6x
 UIw4ibUBOezhuf5JjrdiVww3KK4l1GMmBFdHOARbQefz1f0xLA92zAHwiLp3QkOnv5hz
 MxGQ==
X-Gm-Message-State: AOAM5335bNtyLEZ7MTddRuuHcOeW3p91odGAmmvLj7D3JiTN7W78omOh
 lhT2gNJukGj8vkEBvW4Bgh5Mpa6AVUafz4ylbeutGclyOIz9usCI9Cm8evX9VCzmbjOxUbU9rLS
 guJemdfjwQikYdznA0q4M8sQqMjja8/UF+SGJmq6QwHEG/rVmdIOCJMX5KpvMPUvdADw=
X-Google-Smtp-Source: ABdhPJwnpy1svTwDLzGZ5pdZzA6DJ3cWHquCil74xVvfOw8SrbZFfkPC6MDyKzOW1m1VIvkkvVfRRVvFGA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:7254:: with SMTP id
 n81mr15286490ybc.330.1633877800675; 
 Sun, 10 Oct 2021 07:56:40 -0700 (PDT)
Date: Sun, 10 Oct 2021 15:56:26 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-2-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 01/11] KVM: arm64: Move __get_fault_info() and co into
 their own include file
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

From: Marc Zyngier <maz@kernel.org>

In order to avoid including the whole of the switching helpers
in unrelated files, move the __get_fault_info() and related helpers
into their own include file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/fault.h  | 75 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 61 +-------------------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  2 +-
 3 files changed, 77 insertions(+), 61 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h

diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
new file mode 100644
index 000000000000..1b8a2dcd712f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#ifndef __ARM64_KVM_HYP_FAULT_H__
+#define __ARM64_KVM_HYP_FAULT_H__
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
+{
+	u64 par, tmp;
+
+	/*
+	 * Resolve the IPA the hard way using the guest VA.
+	 *
+	 * Stage-1 translation already validated the memory access
+	 * rights. As such, we can use the EL1 translation regime, and
+	 * don't have to distinguish between EL0 and EL1 access.
+	 *
+	 * We do need to save/restore PAR_EL1 though, as we haven't
+	 * saved the guest context yet, and we may return early...
+	 */
+	par = read_sysreg_par();
+	if (!__kvm_at("s1e1r", far))
+		tmp = read_sysreg_par();
+	else
+		tmp = SYS_PAR_EL1_F; /* back to the guest */
+	write_sysreg(par, par_el1);
+
+	if (unlikely(tmp & SYS_PAR_EL1_F))
+		return false; /* Translation failed, back to guest */
+
+	/* Convert PAR to HPFAR format */
+	*hpfar = PAR_TO_HPFAR(tmp);
+	return true;
+}
+
+static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
+{
+	u64 hpfar, far;
+
+	far = read_sysreg_el2(SYS_FAR);
+
+	/*
+	 * The HPFAR can be invalid if the stage 2 fault did not
+	 * happen during a stage 1 page table walk (the ESR_EL2.S1PTW
+	 * bit is clear) and one of the two following cases are true:
+	 *   1. The fault was due to a permission fault
+	 *   2. The processor carries errata 834220
+	 *
+	 * Therefore, for all non S1PTW faults where we either have a
+	 * permission fault or the errata workaround is enabled, we
+	 * resolve the IPA using the AT instruction.
+	 */
+	if (!(esr & ESR_ELx_S1PTW) &&
+	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
+	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
+		if (!__translate_far_to_hpfar(far, &hpfar))
+			return false;
+	} else {
+		hpfar = read_sysreg(hpfar_el2);
+	}
+
+	fault->far_el2 = far;
+	fault->hpfar_el2 = hpfar;
+	return true;
+}
+
+#endif
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a0e78a6027be..54abc8298ec3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -8,6 +8,7 @@
 #define __ARM64_KVM_HYP_SWITCH_H__
 
 #include <hyp/adjust_pc.h>
+#include <hyp/fault.h>
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
@@ -133,66 +134,6 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
-{
-	u64 par, tmp;
-
-	/*
-	 * Resolve the IPA the hard way using the guest VA.
-	 *
-	 * Stage-1 translation already validated the memory access
-	 * rights. As such, we can use the EL1 translation regime, and
-	 * don't have to distinguish between EL0 and EL1 access.
-	 *
-	 * We do need to save/restore PAR_EL1 though, as we haven't
-	 * saved the guest context yet, and we may return early...
-	 */
-	par = read_sysreg_par();
-	if (!__kvm_at("s1e1r", far))
-		tmp = read_sysreg_par();
-	else
-		tmp = SYS_PAR_EL1_F; /* back to the guest */
-	write_sysreg(par, par_el1);
-
-	if (unlikely(tmp & SYS_PAR_EL1_F))
-		return false; /* Translation failed, back to guest */
-
-	/* Convert PAR to HPFAR format */
-	*hpfar = PAR_TO_HPFAR(tmp);
-	return true;
-}
-
-static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
-{
-	u64 hpfar, far;
-
-	far = read_sysreg_el2(SYS_FAR);
-
-	/*
-	 * The HPFAR can be invalid if the stage 2 fault did not
-	 * happen during a stage 1 page table walk (the ESR_EL2.S1PTW
-	 * bit is clear) and one of the two following cases are true:
-	 *   1. The fault was due to a permission fault
-	 *   2. The processor carries errata 834220
-	 *
-	 * Therefore, for all non S1PTW faults where we either have a
-	 * permission fault or the errata workaround is enabled, we
-	 * resolve the IPA using the AT instruction.
-	 */
-	if (!(esr & ESR_ELx_S1PTW) &&
-	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
-	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
-		if (!__translate_far_to_hpfar(far, &hpfar))
-			return false;
-	} else {
-		hpfar = read_sysreg(hpfar_el2);
-	}
-
-	fault->far_el2 = far;
-	fault->hpfar_el2 = hpfar;
-	return true;
-}
-
 static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 {
 	u8 ec;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bacd493a4eac..2a07d63b8498 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -11,7 +11,7 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
-#include <hyp/switch.h>
+#include <hyp/fault.h>
 
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
