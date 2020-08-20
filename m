Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC73C433E1
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:36:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4272A2075E
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:36:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Jindr9pC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4272A2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED34D4B7A1;
	Thu, 20 Aug 2020 06:36:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uPYCq7qJhKh2; Thu, 20 Aug 2020 06:36:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0B844B819;
	Thu, 20 Aug 2020 06:36:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFF54B865
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:36:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6hf41FpRCpYP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:36:04 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A75324B8A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:36:02 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id o10so504358wrs.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=Ii9zN72fbL1jNjFgtBff2Ivpkwsgf22REuUFgnGUMjw=;
 b=Jindr9pCOTI7BkHFOZrt7dPin1P9XAuaGpCEJXrxhTPBg769YCvJu2Y+p0sIHhUe0a
 m/mu4IUAoynf61YMQvuYWosZLzW6+gBVzqkRO2m+9FAlx2PlILA9EjDrojh4AHbxR++a
 4B7Xa5guHbJpBMFlEFKxiyAqI+X970sogPNvXic+hARIRUltbagQdhmD0ax58gT5Dw6i
 twfHRMbLt0Evuyoc7j4WBoXHukbVcOFmuFq02MCpj9k3qhz1AqW6Si7WW/3/AL/VKego
 q7AdHWUcMwcw+nMt6JnMi2eHbX12F57PAP+wgnjmdw/nDNO3IbL2XcRl6uV33vDfhS2L
 dqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ii9zN72fbL1jNjFgtBff2Ivpkwsgf22REuUFgnGUMjw=;
 b=Ioik+aDUCODNWarCp0kkOrQYmvvrUHQfgDuRUyEegOYodPxwFyRHStydDhbWPZ5xnI
 3Yn1yIxcLPubFJDrnPMi4zhP162n7mSttq9KTefcGuFxzxsl3uHqUxfeVeW7kRd5XZT/
 7d5yN6Q/Z1qgPPoU2IuIBZoMghwfyMmi0poQhQwerl+frBzqjJOA0iA8PIB4BGctYZyu
 zSzagJsuohM0tjewitiVXJV87R3tB2SKmpvS6tL99KmLwVwoREq+NrNNpF14nBdywhl3
 E4Xnek+ca+X2aRuoa9iCfwXPDngAB+0CEzap+BurpHcgiveoKIxFloRY3Tu60MtnW2Lw
 7eBA==
X-Gm-Message-State: AOAM530VnaNQLRdle5t/IrnFCg8CTy92SrweemI0vgEfOUTxBOL1Q/dI
 CBbzuDhYaRmttPWvzCZJxkARt+Z+HG8YHF5xMg8UUvGW647DYGVinIZ7QjiKfgcLE2OfKlbAfPX
 6gUyyEj4akhSJ+0ldgmuYaBrk77e13oWARwiTvL+i4PMTDFhFGsXmDfLTdEbfNscQX2+ZCA==
X-Google-Smtp-Source: ABdhPJxPNB+5u/RQcdi2M5ECef0JwtsHREpvlNV0aRevkqYpffhDYmOP41w94M1uuVN9yBJhZljPKl3ReRg=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a5d:494b:: with SMTP id
 r11mr2697698wrs.419.1597919761823; 
 Thu, 20 Aug 2020 03:36:01 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:45 +0100
In-Reply-To: <20200820103446.959000-1-ascull@google.com>
Message-Id: <20200820103446.959000-20-ascull@google.com>
Mime-Version: 1.0
References: <20200820103446.959000-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 19/20] KVM: arm64: nVHE: Fix pointers during SMCCC
 convertion
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

The host need not concern itself with the pointer differences for the
hyp interfaces that are shared between VHE and nVHE so leave it to the
hyp to handle.

As the SMCCC function IDs are converted into function calls, it is a
suitable place to also convert any pointer arguments into hyp pointers.
This, additionally, eases the reuse of the handlers in different
contexts.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++------
 arch/arm64/kvm/hyp/nvhe/switch.c   |  2 --
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  2 --
 arch/arm64/kvm/vgic/vgic-v3.c      |  4 ++--
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 13093df70c87..78d7afcefbb8 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -27,7 +27,7 @@ static void handle_host_hcall(unsigned long func_id,
 		struct kvm_vcpu *vcpu =
 			(struct kvm_vcpu *)host_ctxt->regs.regs[1];
 
-		ret = __kvm_vcpu_run(vcpu);
+		ret = __kvm_vcpu_run(kern_hyp_va(vcpu));
 		goto out;
 	}
 
@@ -41,21 +41,21 @@ static void handle_host_hcall(unsigned long func_id,
 			phys_addr_t ipa = host_ctxt->regs.regs[2];
 			int level = host_ctxt->regs.regs[3];
 
-			__kvm_tlb_flush_vmid_ipa(mmu, ipa, level);
+			__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 			break;
 		}
 	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid): {
 			struct kvm_s2_mmu *mmu =
 				(struct kvm_s2_mmu *)host_ctxt->regs.regs[1];
 
-			__kvm_tlb_flush_vmid(mmu);
+			__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 			break;
 		}
 	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): {
 			struct kvm_s2_mmu *mmu =
 				(struct kvm_s2_mmu *)host_ctxt->regs.regs[1];
 
-			__kvm_tlb_flush_local_vmid(mmu);
+			__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
 			break;
 		}
 	case KVM_HOST_SMCCC_FUNC(__kvm_timer_set_cntvoff): {
@@ -89,14 +89,14 @@ static void handle_host_hcall(unsigned long func_id,
 			struct vgic_v3_cpu_if *cpu_if =
 				(struct vgic_v3_cpu_if *)host_ctxt->regs.regs[1];
 
-			__vgic_v3_save_aprs(cpu_if);
+			__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
 			break;
 		}
 	case KVM_HOST_SMCCC_FUNC(__vgic_v3_restore_aprs): {
 			struct vgic_v3_cpu_if *cpu_if =
 				(struct vgic_v3_cpu_if *)host_ctxt->regs.regs[1];
 
-			__vgic_v3_restore_aprs(cpu_if);
+			__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
 			break;
 		}
 	default:
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index b7abe66fde22..0d8187358565 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -176,8 +176,6 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		pmr_sync();
 	}
 
-	vcpu = kern_hyp_va(vcpu);
-
 	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 69eae608d670..544bca3072b7 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -54,7 +54,6 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	/*
@@ -108,7 +107,6 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalls12e1is);
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 76e2d85789ed..9cdf39a94a63 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -662,7 +662,7 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	if (likely(cpu_if->vgic_sre))
 		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
 
-	kvm_call_hyp(__vgic_v3_restore_aprs, kern_hyp_va(cpu_if));
+	kvm_call_hyp(__vgic_v3_restore_aprs, cpu_if);
 
 	if (has_vhe())
 		__vgic_v3_activate_traps(cpu_if);
@@ -686,7 +686,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 
 	vgic_v3_vmcr_sync(vcpu);
 
-	kvm_call_hyp(__vgic_v3_save_aprs, kern_hyp_va(cpu_if));
+	kvm_call_hyp(__vgic_v3_save_aprs, cpu_if);
 
 	if (has_vhe())
 		__vgic_v3_deactivate_traps(cpu_if);
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
