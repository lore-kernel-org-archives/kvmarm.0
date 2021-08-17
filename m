Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB21C4320A
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F205460F58
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F205460F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EA554B16F;
	Tue, 17 Aug 2021 04:12:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IAFmpL5E7bFZ; Tue, 17 Aug 2021 04:12:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F294B19D;
	Tue, 17 Aug 2021 04:12:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 153734B156
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xZ3g6TIoKcWh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:12:10 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0F3C4B15A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:06 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 z10-20020a5d440a0000b0290154e0f00348so6308745wrq.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=RY75TCp6EAmYPGA4I7+3iKQeuuwEdqY335GXVfnDS7k=;
 b=JYCa6cCgNtWF/sF0Bltf5bVCZmJFXv4748Iy5bRGGb+tbvHOCstp6BQWGgNwnjAz++
 ykeIvouot4Gx+7bHS4lR/vf4n38EIQV5c0vwbqfIxMWQ0Duh2plc+Z1hOYwMDf/PE7ii
 vrpDAnMRve8T7iTnx6xxkIr8J6d4/pGuQTJBcGtf72MnjQEoMT5z3cZE0IFKB4vIYZ8N
 Qyi+s2nQAKNGBdoqQCdd1Xj7jHpqX8ASK00m5yoxaaItWnRhIdmYBTuHaw8wSd2taDTR
 qMDZNZI/1U33C12jgjXOkicmnbPFKTwXX6/BXOCPPyKK1haKx+ejllyelOjzD62GHB4r
 Khbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=RY75TCp6EAmYPGA4I7+3iKQeuuwEdqY335GXVfnDS7k=;
 b=REiak6REsKIzUwLXzT6e/rXlrbXXWi/PDm/aBWVkS2VrVFvlFQntaRkQbcCac/CAP9
 VJf4O7O9GKnMF+0yV4hRGvbN6kEvKFpXYa8vjdxqe9+YtW1PwlAWIwPvX0kZ06Vom1wv
 5ifzgCvqki44gWUB90+B2B/QyTm6IfdVN6juHK7iELkAfaLgU9TEdXnUumkZTvdigkt8
 yl+ycKo98Gskggd4ld1Hg0F9gT9WRZQSvDUl30ijQj6vr2HEca9QS5tR3yKbt6YZ8qY5
 xEhHenR6NAL/hds3pw4hQxBuE9jjx6d9XQh2TtljSTUiu2U3R8qQoDrldx4sxoD3T0CO
 b+Nw==
X-Gm-Message-State: AOAM530IyI+LWCk3B9QbDPHzJrVaemlRv9LBtDGEf5Sf1Bo2ZbS0Dszr
 zl7xGoiKWAcQ1wWvMb/82efWyQ1ZKuJ7dyzP/mkH7N7VfdxoyUSslLjIZbHCzo490aBNdy2FRbn
 /mPuCtTFlXFyGij7huvhjbed5739iwd9/tWdF6GemJ8nL6Mdc3Wdkgoix9WscmXZ0sgs=
X-Google-Smtp-Source: ABdhPJy/OtVFqjYy4H9XKyK309GPg+Qg6SCvxgN3Qdf+Y2tTkAyZkPf+vBPU02aV6SLjKwZnco28Op+O2Q==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:32c1:: with SMTP id
 y184mr2010593wmy.70.1629187925926; 
 Tue, 17 Aug 2021 01:12:05 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:33 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-15-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 14/15] KVM: arm64: Trap access to pVM restricted features
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

Trap accesses to restricted features for VMs running in protected
mode.

Access to feature registers are emulated, and only supported
features are exposed to protected VMs.

Accesses to restricted registers as well as restricted
instructions are trapped, and an undefined exception is injected
into the protected guests, i.e., with EC = 0x0 (unknown reason).
This EC is the one used, according to the Arm Architecture
Reference Manual, for unallocated or undefined system registers
or instructions.

Only affects the functionality of protected VMs. Otherwise,
should not affect non-protected VMs when KVM is running in
protected mode.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 34 ++++++++++++++-----------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5a2b89b96c67..8431f1514280 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -33,6 +33,9 @@
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
 
+int kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu);
+int kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu);
+
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
 static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index b7f25307a7b9..398e62098898 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -159,27 +159,27 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 }
 
 static exit_handle_fn hyp_exit_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[0 ... ESR_ELx_EC_MAX]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_WFx]		= NULL,
-	[ESR_ELx_EC_CP15_32]		= NULL,
-	[ESR_ELx_EC_CP15_64]		= NULL,
-	[ESR_ELx_EC_CP14_MR]		= NULL,
-	[ESR_ELx_EC_CP14_LS]		= NULL,
-	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_CP15_64]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_MR]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_LS]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_64]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_HVC32]		= NULL,
 	[ESR_ELx_EC_SMC32]		= NULL,
 	[ESR_ELx_EC_HVC64]		= NULL,
 	[ESR_ELx_EC_SMC64]		= NULL,
-	[ESR_ELx_EC_SYS64]		= NULL,
-	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_IABT_LOW]		= NULL,
 	[ESR_ELx_EC_DABT_LOW]		= NULL,
-	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
-	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
-	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
-	[ESR_ELx_EC_BKPT32]		= NULL,
-	[ESR_ELx_EC_BRK64]		= NULL,
-	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_BREAKPT_LOW]	= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_BKPT32]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_BRK64]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_PAC]		= NULL,
 };
 
@@ -188,7 +188,11 @@ exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
 	u32 esr = kvm_vcpu_get_esr(vcpu);
 	u8 esr_ec = ESR_ELx_EC(esr);
 
-	return hyp_exit_handlers[esr_ec];
+	/* For now, only protected VMs have exit handlers. */
+	if (unlikely(kvm_vm_is_protected(kern_hyp_va(vcpu->kvm))))
+		return hyp_exit_handlers[esr_ec];
+	else
+		return NULL;
 }
 
 /* Switch to the guest for legacy non-VHE systems */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
