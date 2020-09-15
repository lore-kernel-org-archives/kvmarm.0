Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29CFC2D0E0
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 522AB21D24
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="SLYJYNZQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 522AB21D24
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 079E04B326;
	Tue, 15 Sep 2020 06:47:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LsUiDv4QHUiF; Tue, 15 Sep 2020 06:47:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC9DE4B331;
	Tue, 15 Sep 2020 06:47:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DC744B332
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VS3lWTJpiJmZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:32 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B6CE4B37E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:32 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id j35so2392923qtk.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=ZNdQt146Mi5cisK8WiEUChoUYY2x0Hq+mJmQkVSykvI=;
 b=SLYJYNZQD/oA5Dys7oElRphXMNsjgfiOX5SyLcObpNY39iuXFfAJpZ2faDwnoJnPhB
 TVB1vQp22/tKXxRghHVaD2UlbWYpWa16Gj3O9v+kDm4uxESyzI7rTaQaukFr9DfIMpIs
 wAZ3kqggPHiSLX4mvpVWcp1FDazBEssvSU0c5oUSviul+5J+RtEnuleEdIP1M4Oif0N+
 hnsX5gpv2z6kkp8kOfhgTkuIhfZf4CjqgnnuC6VU/5H+Qs8ztojUohPESpWoI62spb54
 EarHYgvHVmEkMIxuGBKu1yEneOWhjiYxuxriJpO9QYbnwkWZ5gWaVxyTiZvxyMwe6lnV
 y+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ZNdQt146Mi5cisK8WiEUChoUYY2x0Hq+mJmQkVSykvI=;
 b=G1mvMyhRqzvZjI/yDr1R9knztvS1Zrp6eqyXd6DvELtk69oJYWF+sIt6xAatsZ1gih
 EBtTak2YlZR1oaolnX46+sr024aU4rf++hDT00kxklg5AzqgEEmluuDPB8JUdCkPpzOB
 AvtOiPjhR5rezpEbTs7h0pdjbtbGkO2ryBCTj5mQxOtJK4nmeFQR5EO8bNtzVgQJ8L6w
 qCWeTCfoW7wH1Haw2Sq4+p0nV3zaLiKnFH4BJkf7cbornFnVkqwnuBKKl/0XZ7AacZMq
 KvpH2FDl2ZAuo6fw5fmO6j8t1n5XMXH5xKgOdsXI1B7t09pnhGxi1W2JeKLqLEIK+ujD
 ViWg==
X-Gm-Message-State: AOAM531gYC2cHyICpyirtz5cL9dQrGKYYRbx/sqTIdYShI/CmNnWL0bP
 J2jlRIQO2FQfkpbzjGVMQitLNnpFlPr7gS9yZYqKrfZrPADv1zVnQ+Ux8yflStjNZVKUDcuvXUR
 rONkeQa2DrnTTshLU5Fxnlfwjsc42fX5ZMKAv9Xt+S3Gfwb9M0n2tjfQAmMxR6bIuWrLb5g==
X-Google-Smtp-Source: ABdhPJzrLarU1nSXE5M3B+eZrAj4ZuoYNk5kpu4n9NQAgOx6eKWaVGsw2ogOhpRydn2R3EqYkAHcUBsEA9Q=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:f04d:: with SMTP id
 b13mr14553797qvl.31.1600166851468; 
 Tue, 15 Sep 2020 03:47:31 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:43 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-20-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 19/19] KVM: arm64: nVHE: Fix pointers during SMCCC
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
index 41aaf038599a..e2eafe2c93af 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -24,7 +24,7 @@ static void handle_host_hcall(unsigned long func_id,
 		unsigned long r1 = host_ctxt->regs.regs[1];
 		struct kvm_vcpu *vcpu = (struct kvm_vcpu *)r1;
 
-		ret = __kvm_vcpu_run(vcpu);
+		ret = __kvm_vcpu_run(kern_hyp_va(vcpu));
 		break;
 	}
 	case KVM_HOST_SMCCC_FUNC(__kvm_flush_vm_context):
@@ -36,21 +36,21 @@ static void handle_host_hcall(unsigned long func_id,
 		phys_addr_t ipa = host_ctxt->regs.regs[2];
 		int level = host_ctxt->regs.regs[3];
 
-		__kvm_tlb_flush_vmid_ipa(mmu, ipa, level);
+		__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 		break;
 	}
 	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid): {
 		unsigned long r1 = host_ctxt->regs.regs[1];
 		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
 
-		__kvm_tlb_flush_vmid(mmu);
+		__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 		break;
 	}
 	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): {
 		unsigned long r1 = host_ctxt->regs.regs[1];
 		struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
 
-		__kvm_tlb_flush_local_vmid(mmu);
+		__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
 		break;
 	}
 	case KVM_HOST_SMCCC_FUNC(__kvm_timer_set_cntvoff): {
@@ -84,14 +84,14 @@ static void handle_host_hcall(unsigned long func_id,
 		unsigned long r1 = host_ctxt->regs.regs[1];
 		struct vgic_v3_cpu_if *cpu_if = (struct vgic_v3_cpu_if *)r1;
 
-		__vgic_v3_save_aprs(cpu_if);
+		__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
 		break;
 	}
 	case KVM_HOST_SMCCC_FUNC(__vgic_v3_restore_aprs): {
 		unsigned long r1 = host_ctxt->regs.regs[1];
 		struct vgic_v3_cpu_if *cpu_if = (struct vgic_v3_cpu_if *)r1;
 
-		__vgic_v3_restore_aprs(cpu_if);
+		__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
 		break;
 	}
 	default:
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 29febf9a93f2..a29f247f35e3 100644
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
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
