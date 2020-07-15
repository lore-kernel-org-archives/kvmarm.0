Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB6CC43457
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3501620787
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="F74s60sg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3501620787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E36DD4B170;
	Wed, 15 Jul 2020 14:45:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xJhkQN14zF1o; Wed, 15 Jul 2020 14:45:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ED204B411;
	Wed, 15 Jul 2020 14:45:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33BB44B3F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zMGPm22b4cWt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:55 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 362BB4B3D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:55 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id j4so1846294qvt.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YqZJALsMBAbSuNuxUE8NKo8rlPaU6v6MzwYrXLsxGLc=;
 b=F74s60sg6Dgku69egU4IQnpOl/kq+fVrrPLbFjddpSX3iKO9xVnrzdrvz9cRo5rBRg
 n7tFUcv+TWluduTRzYCzthSJMDhtkrl+yCX12/Ldf4v9RjxgQrA8/FnEV3w8tmEZALko
 fkIBs9H82Hz62hpbMaetgQZ5FkEjvBefMDYlMnYI7VCZsdhz5iFAR0ha1Uw++Si7jviC
 wWTy7nkg6Ut4izrQXySLvX2s3n9vUsjdgOzgl/4l03qg2IDe/EiAVBwcCCpu6bJ3wbTH
 2F/NfWeHaeL5otaGwUPztKNiNuntdTGIvEk6Jsx/WTZIcfbWIfVlRwklR8efcghWTMAx
 Tj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YqZJALsMBAbSuNuxUE8NKo8rlPaU6v6MzwYrXLsxGLc=;
 b=g3Na5E8O2xWNNUGkOGl7TdRdKu9BM7wcfcbGjdX5KIOZwo5r7scJnMSAgfcJ0zgS1Z
 ddtsZLF2bqbIC/mZ/U+qq/1WzbLKfOnFtZDQRZFqhnZu7pHESO52Lcmpv5w1DwslSzRv
 uy2bDVqEMcsEJctNuUPPVUOwfplDC16PImzgwNZJvCF1i2PCybjHxdId+nICLxOMpmJW
 KA45N1PyCT2CuPVvtXC/5LSHjDtPjLutsVx/ACDbR+gCdmG9soxFnNy0rt/vo45M3FBW
 eukQocxIcZCBT5yYS+1/zqYq2PznY0vyU5h3k3Xuwn3EW9QqUEviBYr+xh2Id3NlwvYx
 A/2A==
X-Gm-Message-State: AOAM533rq4Px5tHDOAaehWCNMc7pxzEmAVKH8jwWfLKtEZuP4QOuyY1H
 13wetfRCIj9BHyKAHl+Z/zQMLew+ZgSYzyqiQwRcoD88UHByOQDX2xt1ZKQpCoQ4D2XQr4yGcby
 HAKiRjxRzVc6kcJcs8ESIip6/jTbpQJLQoe2WeDRNjandNPoEN2LcS1P4RVkMBu+03Ftfqg==
X-Google-Smtp-Source: ABdhPJzEpwS1eBdFEtVNOY94BEYyBQv7ehjmwdHCVvwwuSr15/SqHLYUXLZ6KL9rxvWRfwcEnX6XmdFiUB8=
X-Received: by 2002:ad4:4732:: with SMTP id l18mr690045qvz.208.1594838754689; 
 Wed, 15 Jul 2020 11:45:54 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:31 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-31-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 30/37] KVM: arm64: nVHE: Remove MMU assumption in speculative
 AT workaround
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

Rather than making an assumption about the state of the host's MMU,
always force it on. This starts reducing trust and dependence on the
host state and sets the stage for a common path for both guests and the
host vcpu.

The EPDx bits must be set for the full duration that the MMU is being
enabled so that no S1 walks can occur if we are enabling an
uninitialized or unused MMU.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  6 ++++--
 arch/arm64/kvm/hyp/nvhe/tlb.c              | 15 +++++++++++----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index c55b2d17ada8..0c24c922bae8 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -83,13 +83,15 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	} else	if (!ctxt->is_host) {
 		/*
 		 * Must only be done for guest registers, hence the context
-		 * test. We're coming from the host, so SCTLR.M is already
-		 * set. Pairs with nVHE's __activate_traps().
+		 * test. Pairs with nVHE's __activate_traps().
 		 */
 		write_sysreg_el1((ctxt_sys_reg(ctxt, TCR_EL1) |
 				  TCR_EPD1_MASK | TCR_EPD0_MASK),
 				 SYS_TCR);
 		isb();
+		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1] | SCTLR_ELx_M,
+				 SYS_SCTLR);
+		isb();
 	}
 
 	write_sysreg_el1(ctxt_sys_reg(ctxt, CPACR_EL1),	SYS_CPACR);
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index e5f65f0da106..16fa06ff0554 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -10,6 +10,7 @@
 
 struct tlb_inv_context {
 	u64		tcr;
+	u64		sctlr;
 };
 
 static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
@@ -21,14 +22,18 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 		/*
 		 * For CPUs that are affected by ARM 1319367, we need to
 		 * avoid a host Stage-1 walk while we have the guest's
-		 * VMID set in the VTTBR in order to invalidate TLBs.
-		 * We're guaranteed that the S1 MMU is enabled, so we can
-		 * simply set the EPD bits to avoid any further TLB fill.
+		 * VMID set in the VTTBR in order to invalidate TLBs. This
+		 * is done by setting the EPD bits in the TCR_EL1 register.
+		 * We also need to prevent TLB allocation from IPA->PA walks,
+		 * so we enable the S1 MMU.
 		 */
 		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
 		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
 		write_sysreg_el1(val, SYS_TCR);
 		isb();
+		val = cxt->sctlr = read_sysreg_el1(SYS_SCTLR);
+		val |= SCTLR_ELx_M;
+		isb();
 	}
 
 	/* __load_guest_stage2() includes an ISB for the workaround. */
@@ -43,7 +48,9 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/* Ensure write of the host VMID */
 		isb();
-		/* Restore the host's TCR_EL1 */
+		/* Restore the host's SCTLR and then TCR_EL1 */
+		write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
+		isb();
 		write_sysreg_el1(cxt->tcr, SYS_TCR);
 	}
 }
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
