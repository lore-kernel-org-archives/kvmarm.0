Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D512C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05BC42075E
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="svS4aSTW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05BC42075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A197C4B894;
	Thu, 20 Aug 2020 06:35:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cnV1T4gzPcKY; Thu, 20 Aug 2020 06:35:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 516AD4B886;
	Thu, 20 Aug 2020 06:35:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF5834B841
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L2QgoOYNp0+U for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:23 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 103CD4B83E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:23 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id w17so1785575ybl.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=HYWwnaxxN9FJeVd5cnyIhTlJLg1bqv4TtHfD3U0RlXs=;
 b=svS4aSTW4PpT7iw+VQyZ1+qUl5GF34lMx8mgpWm/FIcXopzSZVkRyVBaiXS+OVT59C
 aGrxUS22s1Xx1Jw+jHR2ONIsp04jUPnucFBy5vMq/c+/LMODP5IS9dqfHw/UY3Ja1bTO
 /tMOy41QXvgt9i3123BZGxKykQ6MqDzhixhhuy0L0dhsEZkfRVeSS8jl0JZFyEDrjZdc
 QoY0FQwEmvXF1C361lJJ7bk44EnFjiUS+TpcbHnhX2wUk8QS8zo4gfF5YNXB4DwPCC9p
 gZUkB9RRxx0Xw5rZO9ZMFO24n/OZijeMxmZCl5i+ANZwxnvfYzUeF3SC53cZxclyqFg4
 FSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HYWwnaxxN9FJeVd5cnyIhTlJLg1bqv4TtHfD3U0RlXs=;
 b=cQ0m7af5NQEPYY8G2Fk1q+PzAh6B5UnqvCvhdlUQKHRNLWqc2X2ji0OfcH84rnjqOS
 9gsBy/zKXsoKU9pClHL7YmfooKZNmlFfIKnMI0l+VzP6g3NVfB1ED30SV0HmhUowV0ha
 kRJHNh1dPzeUVsvlJ1D6yEVv8o2AFTs3rfvrbBnTg5JYjaayD6/SrxoKeAO478T043j/
 PdMAX4N3AF8NMaFC8IpON1uocTbP+J/uWV1q3lIYQXAMQ/8GpXVD3BrkPG1fKMW+kgzL
 x8a1jKklbQj1chm474yhXYZnTLnoc3/HVzt/yBFjjl371YixTnaVhTHi/wATB5qci/L6
 HIjA==
X-Gm-Message-State: AOAM530X17LPjar7uBwCJHpCQGxT0cBXPdIjSuINb4rOWYU/RRj5wdDF
 gmhxQGhTWJiEMdl1hCa8yS/Z1IwAsONUMTNUnU1+pCa4j/RPR+XwquFFHD1rtzA394Ij30ryOuW
 hoM2qsJa8dZWtACO0IHhprtHNfnojYrGyuvxgLHi1n1dUHG/cy2AJtJAOiZJIbZzGRPu3xA==
X-Google-Smtp-Source: ABdhPJxLn2z0cBy11YDIYFTd9OIYnRwhQlbqitdefWbhHlYAbLRzYH4IboahCiHc9HaQFEgmqJAQXZbSPu4=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a25:f20d:: with SMTP id
 i13mr3686021ybe.152.1597919722311; 
 Thu, 20 Aug 2020 03:35:22 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:27 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-2-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 01/20] KVM: arm64: Remove __activate_vm wrapper
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

The __activate_vm wrapper serves no useful function and has a misleading
name as it simply calls __load_guest_stage2 and does not touch
HCR_EL2.VM so remove it.

Also rename __deactivate_vm to __load_host_stage2 to match naming
pattern.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 -----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  8 ++++----
 arch/arm64/kvm/hyp/vhe/switch.c         | 10 +++++-----
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 426ef65601dd..d07777d857a3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -122,11 +122,6 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void __activate_vm(struct kvm_s2_mmu *mmu)
-{
-	__load_guest_stage2(mmu);
-}
-
 static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 {
 	u64 par, tmp;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 341be2f2f312..2940d220096d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -93,7 +93,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
-static void __deactivate_vm(struct kvm_vcpu *vcpu)
+static void __load_host_stage2(void)
 {
 	write_sysreg(0, vttbr_el2);
 }
@@ -194,7 +194,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
-	__activate_vm(kern_hyp_va(vcpu->arch.hw_mmu));
+	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
 	__activate_traps(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
@@ -219,7 +219,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__hyp_vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
-	__deactivate_vm(vcpu);
+	__load_host_stage2();
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
@@ -253,7 +253,7 @@ void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 	if (read_sysreg(vttbr_el2)) {
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
-		__deactivate_vm(vcpu);
+		__load_host_stage2();
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c52d714e0d75..30bb76066cc0 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -120,12 +120,12 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	 * HCR_EL2.TGE.
 	 *
 	 * We have already configured the guest's stage 1 translation in
-	 * kvm_vcpu_load_sysregs_vhe above.  We must now call __activate_vm
-	 * before __activate_traps, because __activate_vm configures
-	 * stage 2 translation, and __activate_traps clear HCR_EL2.TGE
-	 * (among other things).
+	 * kvm_vcpu_load_sysregs_vhe above.  We must now call
+	 * __load_guest_stage2 before __activate_traps, because
+	 * __load_guest_stage2 configures stage 2 translation, and
+	 * __activate_traps clear HCR_EL2.TGE (among other things).
 	 */
-	__activate_vm(vcpu->arch.hw_mmu);
+	__load_guest_stage2(vcpu->arch.hw_mmu);
 	__activate_traps(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
