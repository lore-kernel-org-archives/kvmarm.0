Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED448C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 01:08:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C36C4B263;
	Thu, 31 Mar 2022 21:08:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YM3c4XWslZL2; Thu, 31 Mar 2022 21:08:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ED4D4B26D;
	Thu, 31 Mar 2022 21:08:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3985D4B20D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 21:08:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NB781BDON136 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2022 21:08:43 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B40904B25F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 21:08:42 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 f18-20020a926a12000000b002be48b02bc6so849359ilc.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 18:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KA/GWZbBcAZRmPygWsfcVB729yBAl8Atyl9ZfVZwME0=;
 b=sMywx6e53vxiNm4E7wJ847vJbS+tcnm34/ZvNhHoQYy3ROOnRY8CHkP+7EpwRTLD2h
 AEVnejaGwfgGzpWlTAvEbVcBQm1DiuJymuDnOlrWvcpiYhiAAfIie8xcEH5/lV2gi+Rg
 rIeKknmv5TNIOdJJvLCVQvMIxhl5TA5nhOFphDxuLihvtPjhacgeXFDDGIijv/QtJEP4
 VQEi8k5K+UV2d75IyliDY1pMTb/7L71JmYJYDFuFb1xuspzzyYBYfjE4S1v5dqgIZyeU
 bgfxp0AuTGYKCl70CX9fglhMu9JKuwbtXv4epNY207xjuTeVr5xPsSH8+Cy5xh0SKL6A
 +x7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KA/GWZbBcAZRmPygWsfcVB729yBAl8Atyl9ZfVZwME0=;
 b=A/4IFhNTovz7wKY6Nbw2nUF2CORVUs8wnELivN5rT9jiMZzzAakiNh2VicagC5/fs8
 cvPUtUEQjNSZS+YSijHGfG+EavHzc+bVsaEllq5ieVaygbhTIKRJaB4bDd9ze2hMWJgt
 dd5oXmxEEHicQHu/6nrDIlyaWW/crSjvOocvb65fBHF3YcaLu+qYJi39g/jubWbXkFKf
 +fMQmkpTpc63wxz5M/CNT/aDluXEpydVUPNUl+Z/fDR0szWmVgmDkl7+VgVMmcIGCZqR
 k2ownjZkBVO1QpXzOmFh9pDTyjxhh+0nxmGlBDMAYVFRBcykuAiIhbG7UuITyjPKcqV+
 rS5g==
X-Gm-Message-State: AOAM532H9O+CjBfDW+pgNjg+Dpp20bVb3u1waKjCFbULsPXtfaJPrZJP
 Z1JeXiHn1Kdm5d0P/yof9uQ2kSHfyGfx/UH39M8s7q40sKZe7f5wHXcRg2Ssb4WHURbCq62snu3
 Wl2Af0jgaqHOTR6/s6Pf3cz7IiLukkCRp/bEFv4G7ur5MDi9M5H3NwNtijB6Nz+pnnNxoTg==
X-Google-Smtp-Source: ABdhPJxcIUgZkoq89DTW0ywDzVC0rUVYrGgHm6b0KDPOULWi8CbLKK4sO2bQ4yU/R77yJcpXNH3RlNMdqm8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:190b:b0:2ca:3be:2f52
 with SMTP id
 w11-20020a056e02190b00b002ca03be2f52mr1730936ilu.8.1648775322203; Thu, 31 Mar
 2022 18:08:42 -0700 (PDT)
Date: Fri,  1 Apr 2022 01:08:32 +0000
In-Reply-To: <20220401010832.3425787-1-oupton@google.com>
Message-Id: <20220401010832.3425787-4-oupton@google.com>
Mime-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 3/3] KVM: arm64: Start trapping ID registers for 32 bit
 guests
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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
---
 arch/arm64/include/asm/kvm_arm.h     | 3 ++-
 arch/arm64/include/asm/kvm_emulate.h | 8 --------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 01d47c5886dc..2fc2d995c10a 100644
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
index d62405ce3e6d..fe32b4c8b35b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -75,14 +75,6 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
-	/*
-	 * TID3: trap feature register accesses that we virtualise.
-	 * For now this is conditional, since no AArch32 feature regs
-	 * are currently virtualised.
-	 */
-	if (!vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 |= HCR_TID3;
-
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
 	    vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID2;
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
