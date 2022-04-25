Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D89C43217
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 23:53:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD8264B1A2;
	Mon, 25 Apr 2022 19:53:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PzW+szHZ-s5l; Mon, 25 Apr 2022 19:53:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9200C4B1A9;
	Mon, 25 Apr 2022 19:53:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D09364B172
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3MgOLPFMRkpN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 19:53:54 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40B294B1CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:54 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 q6-20020a170902eb8600b0015d1f318e82so2214272plg.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 16:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=IxHNHx5wJBVm+rn+jgN7nIqGaCqRxbvwWyLEAglKnWI=;
 b=BO1aKVrSqDD9Ar0XuW9GCnstLd6dqzKgozWJIYb2AWXq+i9HInlKJW+JM8QQ7DwNfq
 BzCri9AGFee+/Cg03nTnxQknM85IOpD1VLlaks2DOYHxTnDc0GDUtxrn8jFmyoc7Iwya
 LrB+PzlU7uNFxxEbFBLUDx5GqzUBM7Du2WHaUmp1uEqjJpahl6fY2OEUueuS+fJmFePz
 a6GUInOaDxJD1otn6Q5byCPbTRs090t5DzYKPvMKlUexwbyBZUActCjMi/Rb70jJQGGo
 AnZYlz5v/iyJreScwHMG3OgX0zXV7QcvUfaDMbRUc+hIMqqSyjWDHX4b1AwE+Ci//r06
 uqfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IxHNHx5wJBVm+rn+jgN7nIqGaCqRxbvwWyLEAglKnWI=;
 b=mlX8eOjGp63bHB4ndllDWnfHGm68kGNJL3ymbQnv9UojzJQuVBvMJtXAGa4d4jX5WL
 DnHNj0as9hnLrDluXXKwA+2O3Bh9VjeEiYSTXDjUOYwHnsXJLJF6hvKiYQ/TULgSO1yM
 pq774RLng8JI5VguIQ4B6+hicfo6DV+7kJsEt6Ui9Wi8jOozdVM57GBEJUeEUTd+nwpy
 yVyeIkDmJ1q6feM7dHAhconstyhVZLTtiHuUbtvXNgRZYm24W3yB8c/09A0fO93Qr+Lh
 vRLe882gt2Tg+jEnszr3UpnyeYoFdzNVlW23XlJRYJSIiAwVgJQuJOlxsKRYp9QPVaKY
 qJZQ==
X-Gm-Message-State: AOAM531lKeyv42ZHswdgWOahal0mGM98r6Q2uv1/mT+oFbyvMJ4JISN+
 CKY3bXcWExfhpa9N0tM+kvbeF5FH6P8BheEvwsupJGrMXiP/FSCT4dzVOh6hi2Arx4HEN2mnhny
 NkdoFWrxdbl1LLPy/15hs1udSnmviT+OxqqWGhqHvfc0O7S21r/GQa08Pk2oMzMXO77SzJQ==
X-Google-Smtp-Source: ABdhPJy8VMFMNE9Q7UkBKYVM4qUrLDosnMII9dPPPSbr5WKYB/hKuYfHo0mtNOfXwW2DsxYsAqekF2bfA/Q=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP id
 k5-20020a17090a910500b001d29e987e1emr1694934pjo.0.1650930832927; Mon, 25 Apr
 2022 16:53:52 -0700 (PDT)
Date: Mon, 25 Apr 2022 23:53:42 +0000
In-Reply-To: <20220425235342.3210912-1-oupton@google.com>
Message-Id: <20220425235342.3210912-6-oupton@google.com>
Mime-Version: 1.0
References: <20220425235342.3210912-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 5/5] KVM: arm64: Start trapping ID registers for 32 bit
 guests
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
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

To date KVM has not trapped ID register accesses from AArch32, meaning
that guests get an unconstrained view of what hardware supports. This
can be a serious problem because we try to base the guest's feature
registers on values that are safe system-wide. Furthermore, KVM does not
implement the latest ISA in the PMU and Debug architecture, so we
constrain these fields to supported values.

Since KVM now correctly handles CP15 and CP10 register traps, we no
longer need to clear HCR_EL2.TID3 for 32 bit guests and will instead
emulate reads with their safe values.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_arm.h     | 3 ++-
 arch/arm64/include/asm/kvm_emulate.h | 7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1767ded83888..b5de102928d8 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -80,11 +80,12 @@
  * FMO:		Override CPSR.F and enable signaling with VF
  * SWIO:	Turn set/way invalidates into set/way clean+invalidate
  * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
+ * TID3:	Trap EL1 reads of group 3 ID registers
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
-			 HCR_FMO | HCR_IMO | HCR_PTW )
+			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 )
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7496deab025a..ab5c66b77bb0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -86,13 +86,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 
 	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
-	else
-		/*
-		 * TID3: trap feature register accesses that we virtualise.
-		 * For now this is conditional, since no AArch32 feature regs
-		 * are currently virtualised.
-		 */
-		vcpu->arch.hcr_el2 |= HCR_TID3;
 
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
 	    vcpu_el1_is_32bit(vcpu))
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
