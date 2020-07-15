Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2782DC433E5
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7A6820672
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="o75352bN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7A6820672
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B6A4B3F9;
	Wed, 15 Jul 2020 14:46:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PshEn2dnjVXD; Wed, 15 Jul 2020 14:45:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 885024B41E;
	Wed, 15 Jul 2020 14:45:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93DB54B170
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lrc7CF2lVHhg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:57 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EC2B4B3FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:57 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id 124so2084322qko.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iVU/LQgPVV7MKdopSyPrjaM27WZtO9bMI7n5fXqw88g=;
 b=o75352bNhQIOh3SrbrDZddfhVt1YCwucFpx2NKpaz61MrZCLgRuUElNuLG0KoVDc2W
 0mnVwFgP24kx3HciSuFzt9PQrpACNqpqqRe9P6GW1homOm1qH6ruNw9/paTu4T1eYCNS
 P3qdO0KrgqzXeB60nlk2pZW/XIdWIHRlwJ2uSkStG+4PKi5f0VUbEdqYCpwu+v9xsLXL
 A5p0DQ1VxRVJi+Bqcxhp+REPfbli9axa+JWfBtBwO7MysUp6/a4vvSqyq4AXMdBcW/I4
 jJ9cw8VPU07fFBGi+8lfuLbF3wWe/8aVA6mbBzvw+fuMz4ynTJxWova3v2v305SNlbMn
 etAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iVU/LQgPVV7MKdopSyPrjaM27WZtO9bMI7n5fXqw88g=;
 b=VQZU0k0d7Eadw50+je6Nexr3Nu4IvOmepEp07xTHuQJ/S501n9KDw6uLESzgfbC4IT
 DHBwY91XEu/hiShtCStYs5uvSCP3wD+vK3xP2fuU6GuToc4Y/J2d14OkUJl7m9UPqJ+L
 NQ8Cc3FZfSJJPFSQ5dhb11CKJ6FS+bT+bpnXCeOzQSDYVnNIKCo2hR8eZY/307qT81QA
 mAHf4MT2s9Te3AvulpUB1bNbPN1LqsQUcRU6zXscBm/ZBr4jZ8uiRn4GwdxQpAAkQWKP
 ZbGvxGarSJL/ZBSgRWWh6kJmnrKN/R08byQHld5a2VW+ElH58GYNsGZpF8djoh+Eoh7M
 S/Yw==
X-Gm-Message-State: AOAM530Q4w/xlYjZqftjgyb10wfvBkGuA2TC16+sL3Ttw7W6/g9afDY1
 hwssNAIswslHaAj2iBekF7PJWiqrAItSkjwnBio3uKiwvrysQAGdiffXV2ejJnhtW2Wl+sWEM6g
 +nIPtDfLi0Okb2vE5si3fENTNYvoU/9h3UBtxPyKQwUhL84MBntVyF93YXnHo3a4az9j6WA==
X-Google-Smtp-Source: ABdhPJyX5Dws739rJeXSgxWwcFaJXnaI18SyM/sJAV3uHPKYJqZOuwLf+pVAfOZ6wxagmpppSkBhEaWwfDI=
X-Received: by 2002:a0c:d44e:: with SMTP id r14mr691071qvh.105.1594838756797; 
 Wed, 15 Jul 2020 11:45:56 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:32 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-32-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 31/37] KVM: arm64: Move speculative AT ISBs into context
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

VHE's workaround requires an ISB between the configuration of the S2
translation and the update of HCR_EL2. It's much easier to see when and
why this is happening if it all happens at the same place in the same
file.

nVHE's workaround does not require an immediate ISB after the
configuration of the S2 translation as the necessary synchronization
happens at a later stage.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 7 -------
 arch/arm64/kvm/hyp/nvhe/tlb.c    | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c  | 1 +
 arch/arm64/kvm/hyp/vhe/tlb.c     | 4 ++--
 4 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 22157ded04ca..835d3fe2f781 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -596,13 +596,6 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
 {
 	write_sysreg(kern_hyp_va(mmu->kvm)->arch.vtcr, vtcr_el2);
 	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
-
-	/*
-	 * ARM errata 1165522 and 1530923 require the actual execution of the
-	 * above before we can switch to the EL1/EL0 translation regime used by
-	 * the guest.
-	 */
-	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 16fa06ff0554..2a0de9d67f00 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -38,7 +38,7 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 
 	/* __load_guest_stage2() includes an ISB for the workaround. */
 	__load_guest_stage2(mmu);
-	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
+	isb();
 }
 
 static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 3c475cc83a2d..04ee01774ea2 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -126,6 +126,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	 * (among other things).
 	 */
 	__activate_vm(vcpu->arch.hw_mmu);
+	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 	__activate_traps(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index fd7895945bbc..b9abd17c1180 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -50,10 +50,10 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 	 *
 	 * ARM erratum 1165522 requires some special handling (again),
 	 * as we need to make sure both stages of translation are in
-	 * place before clearing TGE. __load_guest_stage2() already
-	 * has an ISB in order to deal with this.
+	 * place before clearing TGE.
 	 */
 	__load_guest_stage2(mmu);
+	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 	val = read_sysreg(hcr_el2);
 	val &= ~HCR_TGE;
 	write_sysreg(val, hcr_el2);
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
