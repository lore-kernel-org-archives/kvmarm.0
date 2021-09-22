Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0ECC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3135611C9
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A3135611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56EFD4B0BF;
	Wed, 22 Sep 2021 08:47:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DLi8K5+yCxUK; Wed, 22 Sep 2021 08:47:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 331034A98B;
	Wed, 22 Sep 2021 08:47:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09D404A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X21erl9RcAp5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 08:47:09 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BDAF406E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:09 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 h18-20020ad446f2000000b0037a7b48ba05so11184826qvw.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8HufL+ywsGIDKOrokk6Iy8lrW4K6FhnOg3XWK/L1Z7I=;
 b=AKoItvs5G1Irmr9FftGFI8y5wIfg/Vj0slTcX7S8Hl+TEisu7ntGUaknkWjRPr/SHr
 4Wyup6YVc1mKURvD5CTf8K/xDPp+KIXKCdp6jIbkmxl6v1Zv00B2VCkRwTN71+A51yV1
 etgf5mHDPHB3i6MRufJhiFkPed0Xf8rAK4QCLh85/j8OB0xHoJMsmsaakvElo53Jrb8x
 bsl+pdAdbYN5um0hvoIIFh4iZirMejGZTYJ04iZ2W3mLAxRw8HrWg2XbF9XfAmlqTCQn
 5ME0FLaXjhzXFjxKdLhxGTj1WmZD8HrpWdFkgGEce5/jUQoop7PQhH+sDysZftIMrTs9
 KjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8HufL+ywsGIDKOrokk6Iy8lrW4K6FhnOg3XWK/L1Z7I=;
 b=WtjwKGkm3pmZreVlxnzqGYLc1GZgK91h8k4mrymZXYxCxeA5bV252sEp5Mzkn6kWI9
 JocRioiW5GeUcrTKlRlS+DarlOMugRQk0bMYeU91jjHD4+rJtCmlNNhyFK7WCGjqxfcG
 RaJxR4nUe3rSM2udp9NN5TxKsGJRunpT6u+5RHQAqJQ/cnFrMxi4oggoaVEVgnvT2v5a
 76vPdwOUvu5T3LPmsU3VhxnfoYJ7/PFXB8VyUizbX3b5Z2Mglf3zGTtfFeVfa0Yw8R/6
 sdvKTinZrFxZJLw6x/XfVVdPKcVNTAlZjEOBwviJHyUQSHCrF6eLy32VI6ZD7own7Aty
 5uDg==
X-Gm-Message-State: AOAM531kgcdhm6kooOXW6IqId4OB1+vsPvShu2VpJYvb+a9q4cjLkQgp
 rLzf4FGOXuau7krm76h1QenHgIODQOrZkLuDs9oGmHvH/jgBpsPiloPPyANZb00vQBfxd35zLT6
 TqgXFybzdJAmmAykIqoV3pQBqPU1E3T2nvV6bNnYh+QHWuvNeJQw2RAr0baYhAwD1dJ0=
X-Google-Smtp-Source: ABdhPJw3buv19fqH13VbQQgNA4MdU3C7vJmxElcvlCQdh9FVVRYMLcnwm/sfhAVRavjbgoLpN+vC3TKzmQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1233:: with SMTP id
 p19mr34061372qvv.20.1632314828877; Wed, 22 Sep 2021 05:47:08 -0700 (PDT)
Date: Wed, 22 Sep 2021 13:46:53 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-2-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 01/12] KVM: arm64: Move __get_fault_info() and co into
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
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
