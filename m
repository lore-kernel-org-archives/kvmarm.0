Return-Path: <SRS0=HTLS=NE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6E0C4338F
	for <kvmarm@archiver.kernel.org>; Fri, 13 Aug 2021 13:03:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 855CE610CC
	for <kvmarm@archiver.kernel.org>; Fri, 13 Aug 2021 13:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 855CE610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1031849FE6;
	Fri, 13 Aug 2021 09:03:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id esjJPD5ya059; Fri, 13 Aug 2021 09:03:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B1334A19E;
	Fri, 13 Aug 2021 09:03:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7102E49E8A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 09:03:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0fYmkzqY3ZqY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 09:03:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2EAED49DE3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 09:03:46 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A28BC61038;
 Fri, 13 Aug 2021 13:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628859824;
 bh=tFqwEo6YGudMe5fJLJdVzGsKgcRZXqP4SRV88c+qNQY=;
 h=From:To:Cc:Subject:Date:From;
 b=JbHFMesbZmqN2FZKavkCMG4rmhppA4Vm7183sy8uB2kAGKXKXYg/fNjD9/OMN3MpF
 96wS+E7dyFuSzlCOwGuk3xRTJozBAJuCe5wkfxlQRjIeOQUfxr5UibLxYNIXFTcKqw
 1OIwkg9q6PdR0drQReFh3kDKp8j6/ONM93Z2HX68+AzIQka0+tifmJErOrlaidjTA9
 PCG0PJfWbfA+/Z1mXaSVUsguhnhlxeVHtcog+pWTNWDzvxPDylqEU2ma9gmVUsw0kS
 Xz4uDGI8g5Sarz9/2fkCwXu3BUR4wahSPgFRtrq+wCaT/gzY4o/N7uymXXj20Wq+Rn
 L2SjlTLkoxuIA==
From: Will Deacon <will@kernel.org>
To: maz@kernel.org
Subject: [PATCH] KVM: arm64: Make hyp_panic() more robust when protected mode
 is enabled
Date: Fri, 13 Aug 2021 14:03:36 +0100
Message-Id: <20210813130336.8139-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

When protected mode is enabled, the host is unable to access most parts
of the EL2 hypervisor image, including 'hyp_physvirt_offset' and the
contents of the hypervisor's '.rodata.str' section. Unfortunately,
nvhe_hyp_panic_handler() tries to read from both of these locations when
handling a BUG() triggered at EL2; the former for converting the ELR to
a physical address and the latter for displaying the name of the source
file where the BUG() occurred.

Hack the EL2 panic asm to pass both physical and virtual ELR values to
the host and utilise the newly introduced CONFIG_NVHE_EL2_DEBUG so that
we disable stage-2 protection for the host before returning to the EL1
panic handler. If the debug option is not enabled, display the address
instead of the source file:line information.

Cc: Andrew Scull <ascull@google.com>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---

Based on kvmarm/next for CONFIG_NVHE_EL2_DEBUG although still applies
without that config option.

 arch/arm64/kvm/handle_exit.c   | 23 ++++++++++++++---------
 arch/arm64/kvm/hyp/nvhe/host.S | 21 +++++++++++++++++----
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6f48336b1d86..04ebab299aa4 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -292,11 +292,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
-void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
+void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
+					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
 					      u64 far, u64 hpfar) {
-	u64 elr_in_kimg = __phys_to_kimg(__hyp_pa(elr));
-	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr;
+	u64 elr_in_kimg = __phys_to_kimg(elr_phys);
+	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr_virt;
 	u64 mode = spsr & PSR_MODE_MASK;
 
 	/*
@@ -309,20 +310,24 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
 		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
-		struct bug_entry *bug = find_bug(elr_in_kimg);
 		const char *file = NULL;
 		unsigned int line = 0;
 
 		/* All hyp bugs, including warnings, are treated as fatal. */
-		if (bug)
-			bug_get_file_line(bug, &file, &line);
+		if (!is_protected_kvm_enabled() ||
+		    IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
+			struct bug_entry *bug = find_bug(elr_in_kimg);
+
+			if (bug)
+				bug_get_file_line(bug, &file, &line);
+		}
 
 		if (file)
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
-			kvm_err("nVHE hyp BUG at: %016llx!\n", elr + hyp_offset);
+			kvm_err("nVHE hyp BUG at: %016llx!\n", elr_virt + hyp_offset);
 	} else {
-		kvm_err("nVHE hyp panic at: %016llx!\n", elr + hyp_offset);
+		kvm_err("nVHE hyp panic at: %016llx!\n", elr_virt + hyp_offset);
 	}
 
 	/*
@@ -334,5 +339,5 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
 	kvm_err("Hyp Offset: 0x%llx\n", hyp_offset);
 
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
-	      spsr, elr, esr, far, hpfar, par, vcpu);
+	      spsr, elr_virt, esr, far, hpfar, par, vcpu);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 2b23400e0fb3..4b652ffb591d 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -7,6 +7,7 @@
 #include <linux/linkage.h>
 
 #include <asm/assembler.h>
+#include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 
@@ -85,12 +86,24 @@ SYM_FUNC_START(__hyp_do_panic)
 
 	mov	x29, x0
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	/* Ensure host stage-2 is disabled */
+	mrs	x0, hcr_el2
+	bic	x0, x0, #HCR_VM
+	msr	hcr_el2, x0
+	isb
+	tlbi	vmalls12e1
+	dsb	nsh
+#endif
+
 	/* Load the panic arguments into x0-7 */
 	mrs	x0, esr_el2
-	get_vcpu_ptr x4, x5
-	mrs	x5, far_el2
-	mrs	x6, hpfar_el2
-	mov	x7, xzr			// Unused argument
+	mov	x4, x3
+	mov	x3, x2
+	hyp_pa	x3, x6
+	get_vcpu_ptr x5, x6
+	mrs	x6, far_el2
+	mrs	x7, hpfar_el2
 
 	/* Enter the host, conditionally restoring the host context. */
 	cbz	x29, __host_enter_without_restoring
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
