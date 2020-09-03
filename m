Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913D4C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 343E6208FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="CumNjUfG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 343E6208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5F844B341;
	Thu,  3 Sep 2020 09:53:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9sGx1HHd9Ngf; Thu,  3 Sep 2020 09:53:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15AD74B326;
	Thu,  3 Sep 2020 09:53:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5A34B2FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zclbSiqti27q for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:53 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B40B4B280
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:53 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id n15so1092611wrv.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=SSMgwsDERxeH1C9AIeHiykVI2xNip90xe/fTZ0SwDeI=;
 b=CumNjUfGOifQba/B20PBpMeVCu238q477osYFMnInIKZ39dhnbrvjngo7wBzWTmCKC
 Go4DwQ971jvo6zoBV9wicpTNNZJMvCU62KK1u0OD/uKpMG5+5WgdEICJv3u20hrRmYR9
 jCSU0e4Pkv9CrEIKJVJ33WsLXWhLJAA8JyNaKPJfMCs6tIc/pzoRO3RCFQukKiuH7tqq
 hVWfEL7Qo6T0EsJIX1UKESlaAXs9inDivqh7Q3OzUy8INeqQmUcXj+aaNAkWzv0icVHs
 R8x68VIxvFrp09fsd9eThK3z6OGx3zPYL5X+2LSZ9LCCVMKjJqJiBB+ycX8V67mAq5mR
 rNwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SSMgwsDERxeH1C9AIeHiykVI2xNip90xe/fTZ0SwDeI=;
 b=ltv8vqZslc2aHHWR+510pGgPU6FUM/woJrhcd41lWymbyEUzccnMyS4HkXJ3yILQoD
 EpRcu28U3+T8cmPInpHFuRf2n8EXe913cXTUt67PDfWD4OvkTOtMAsmYZNmXUXKQYJay
 i7LxNYD/B1/8TDML3ghIE2SR99nl5paZpKB24z3NBBYSE6t8DpEXTtzFrYGHFIh4CKeg
 mctuNn7wWwCxWbGkjmnRnUZjaDVs46GPxYVcX2WXXmL9hs1N6COWEzvCKUtPDRzECWqa
 fVqZGJM4rGAQf+h9blfTYvUjvT3Pr7wHE+UU/EXmII4Yojtar3wHOYuLSAtsNa6OKWIG
 x0/w==
X-Gm-Message-State: AOAM532q20aunrBguvuYjTwbE2wp0KNLAUrhev35qQHSOF3v6/sQI3+8
 wyDD9SrDmgrlgZ/4Y4d6DBWq3o+NX/Yit+D0gF8YDrCkknMAlrejYVMsJnE1RSHkOCNuGt0+jJ1
 kSUyQ+KyeCrc7hZ+p7kiC+aB000vmVwZQ0oXjivbkr2okzVbA60R3cvjeNo5osROTLY2tcA==
X-Google-Smtp-Source: ABdhPJxOcTfOHi/LwXdsaDwL4B6glURhxFGbKkKrQXNsKtuhTeaH3Zh6brvCBzoCoiXV3lduNp3jGqzw+tM=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a1c:8109:: with SMTP id
 c9mr2665815wmd.130.1599141232149; 
 Thu, 03 Sep 2020 06:53:52 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:53:07 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-19-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 18/18] KVM: arm64: nVHE: Fix pointers during SMCCC
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
index b4f6ae1d579a..6443ef91bff4 100644
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
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
