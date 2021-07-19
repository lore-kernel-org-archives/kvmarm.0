Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FED6C07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB2A861483
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB2A861483
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 599DC4B0DE;
	Mon, 19 Jul 2021 12:04:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lqv-Ib3D-JS1; Mon, 19 Jul 2021 12:04:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8CB4B0DB;
	Mon, 19 Jul 2021 12:04:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77E1C4A531
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IzDFwjpKcAdE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:04:18 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E44F4B0F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:17 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 g3-20020a256b030000b0290551bbd99700so25951002ybc.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XfYC7GtwCzce6ZhnFCXG3Bv02gpIIg+CxJPXUjvg7WQ=;
 b=bwTUJXGbHV60w2p6YQDBqFUvMzTRBOK+o/sNpUyXJPuo36SWYZtj2M/HxMZnK0kpa7
 af+PYMfDDtHVfTR7GZ7Zfj222Uws1N4VH9Tsbs+tcEr0ZNXC25MNmf1vwIdmPnZ7xUhY
 SlhnRt11MfFxPGlpenEuUxGJGZCJmyrZKvI4atxKugAQmrGPak5VHcCypKFwVvGtPb0Y
 R1N1rD+zSc2NRQprUU89+vNC3BEYv2REpidOs7XCBq6YvcBqC78huig7Dser2AX4eMlA
 1lLiZoEjV+GtacstdLDjpwQ5ID+mzhLUMXrnY6L2K/EmYewOXZQCwUWUCVsdhnxgCagG
 P6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XfYC7GtwCzce6ZhnFCXG3Bv02gpIIg+CxJPXUjvg7WQ=;
 b=Ic2WDHmxYemc0CVcgx8RXmn/kdO2NCSKhP/uwBR4Q3xZVVfj6+vd6lUH2gYysuhMGG
 H51aIpTa1MlJBv2mBe3/o0+qcL9+QzExpdsUsV5u9AFQm8pTrSLUMzVT7KSFfh5vWVQ7
 icsRVIoXO9zlWuhmUwBxRoL+phI5K/dRsN1Fr2KI9wJBAZTk3z26FYnBPdxKorIst2cg
 FCIaFAyq1GLhi79l33RKa1UUQJ+EXCKKy7MUkXtNbiVl7xRn9nhrVhv5GFkPhjT1rjZ6
 wRN69uVZ9P2iH31Og6g7H9f/McWSMzXA0hQy+wwQWQSf14TbtCCysVnl1bEzTvUu0IDB
 zegw==
X-Gm-Message-State: AOAM533k72cuF6HZHYYlbkF8WmokJegQXqmWZo7qteaAAmke2qVuGsqh
 33eC3lGIrGOGPFmKt0huVW8Tfktts42E/NSpjimcbZRg1cbnUTzveyHlTrNg/8VBkzj3wyj4a9W
 elYmyl0ZlF8n9SkreXIGsn7usZDwjUAh1sxiS13tAqXY9LLLqLAzFhbutnL/hYCyAdBY=
X-Google-Smtp-Source: ABdhPJz+V2mbnO0SPesWcZxOnZ7G22wvyRqCMG269fKYfL4HphjBW2ENB0OeZ0xD5198USCahPcX6YInPg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:d88a:: with SMTP id
 p132mr34391631ybg.409.1626710657055; 
 Mon, 19 Jul 2021 09:04:17 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:45 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-15-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
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

Protected KVM does not support protected AArch32 guests. However,
it is possible for the guest to force run AArch32, potentially
causing problems. Add an extra check so that if the hypervisor
catches the guest doing that, it can prevent the guest from
running again by resetting vcpu->arch.target and returning
ARM_EXCEPTION_IL.

Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
AArch32 systems")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 8431f1514280..f09343e15a80 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -23,6 +23,7 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
@@ -477,6 +478,29 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
 	}
 
+	/*
+	 * Protected VMs might not be allowed to run in AArch32. The check below
+	 * is based on the one in kvm_arch_vcpu_ioctl_run().
+	 * The ARMv8 architecture doesn't give the hypervisor a mechanism to
+	 * prevent a guest from dropping to AArch32 EL0 if implemented by the
+	 * CPU. If the hypervisor spots a guest in such a state ensure it is
+	 * handled, and don't trust the host to spot or fix it.
+	 */
+	if (unlikely(is_nvhe_hyp_code() &&
+		     kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
+		     FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
+			       PVM_ID_AA64PFR0_ALLOW) <
+			     ID_AA64PFR0_ELx_32BIT_64BIT &&
+		     vcpu_mode_is_32bit(vcpu))) {
+		/*
+		 * As we have caught the guest red-handed, decide that it isn't
+		 * fit for purpose anymore by making the vcpu invalid.
+		 */
+		vcpu->arch.target = -1;
+		*exit_code = ARM_EXCEPTION_IL;
+		goto exit;
+	}
+
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
