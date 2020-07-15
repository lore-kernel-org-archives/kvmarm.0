Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061B4C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B9282207BC
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="E0k+1ahT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9282207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 559814B316;
	Wed, 15 Jul 2020 14:45:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wVnzlt7qESbB; Wed, 15 Jul 2020 14:45:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB3D4B3E7;
	Wed, 15 Jul 2020 14:45:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 636C04B1CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dHPfSCsaYbct for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:16 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DD844B1E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:16 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id g138so1558804wme.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=bynoXcd8hocBoiNtymx3u8KaOcRpgmrVNAmRk5YvXaQ=;
 b=E0k+1ahT92ys1eRP7X5XPAbD4tLCs75u6BLWHPJq2BKvjq9qnq0vInpEHFykozXNRK
 fTNXkfY9Da67ID5veCj8v3BgaUT4uDPRb1kSwqHwzSwT4T3NpNCf+HgvxqMCbWvBw7eT
 6aRZiOrxoLrOsZTl9XZudQp/8BK4YXMgNrhVYBL4dxoSrHiEFzeeQu1eLvpxDHDXwUX4
 Q6JriEo6UoP6EAB5mNBP4yAn7bZIY99N8Sr4noxGtJ839GYdMm/mPoiQdxJT6xMKgIJh
 PElIguu6uJYt+nGJG4wARVT4ZiKNBmAbE0HCcHWu8Vo/ficPxVyQq2+uLzgLWlIWEI7O
 O7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bynoXcd8hocBoiNtymx3u8KaOcRpgmrVNAmRk5YvXaQ=;
 b=uK08v3C+IbCVMwr6QpXkqqk+29bJj/clBPhNf/hGnmqYrhvGSDTMIt8XfiDM5VyYpV
 jRF2iFThFcJbTIpE91K2qWBzApto4Egoi7uKDd1nSlVF/gRTUHyDXoh4JX7FSj8b/qDO
 dIqxkOVPyvWm4OaoyEn3wv4y1eIMckTaZdh0w17YQBtkk4G4eLXMnofuLXYXZbHXH7R8
 k+uni8ppfnfzGZETUID4b8bnfyUF+prezy9Bu9c1myuRENTgU6IbJqkEhtb/nvx5UbHl
 63PBVNtJHPrKLB1aI6LfCv1HbuD546OIIP+m/KnT7oWEtPCUf8f6cawUm1GgQfaL6L9R
 Ej1g==
X-Gm-Message-State: AOAM530QDfywk4HhG+spNnRsztbtGEUX3NHCg7nZFioe3lQrCV++0og+
 y/WYFZfF8nLT0Grdfp0yHmWqF1rtVkksSFn3EOfvNeGS3PiWOXffHCF2SIEjRtV22TfLb32mV18
 FWY2z4rSA2iUmD802y906mQ+C6iwRi3u3HfN3VfqqSlQNZPnB6tISswOwqNu+tMX5M/cPCw==
X-Google-Smtp-Source: ABdhPJyMCjYYNeXkUgSPKRBFALmAq/8wrKX+htIRtH4MMqTvowZ6PrB3VJmG+WzgXz1Kyt0psfAry3U7ZUA=
X-Received: by 2002:a05:600c:2144:: with SMTP id
 v4mr802288wml.128.1594838715237; 
 Wed, 15 Jul 2020 11:45:15 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:13 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-13-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 12/37] KVM: arm64: nVHE: Fix pointers during SMCCC convertion
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
index 4e3634cdfde6..2d621bf5ac3e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -27,21 +27,21 @@ static void handle_host_hcall(unsigned long func_id, struct kvm_vcpu *host_vcpu)
 			phys_addr_t ipa = smccc_get_arg2(host_vcpu);
 			int level = smccc_get_arg3(host_vcpu);
 
-			__kvm_tlb_flush_vmid_ipa(mmu, ipa, level);
+			__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 			break;
 		}
 	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_vmid): {
 			struct kvm_s2_mmu *mmu =
 				(struct kvm_s2_mmu *)smccc_get_arg1(host_vcpu);
 
-			__kvm_tlb_flush_vmid(mmu);
+			__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 			break;
 		}
 	case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): {
 			struct kvm_s2_mmu *mmu =
 				(struct kvm_s2_mmu *)smccc_get_arg1(host_vcpu);
 
-			__kvm_tlb_flush_local_vmid(mmu);
+			__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
 			break;
 		}
 	case KVM_HOST_SMCCC_FUNC(__kvm_timer_set_cntvoff): {
@@ -54,7 +54,7 @@ static void handle_host_hcall(unsigned long func_id, struct kvm_vcpu *host_vcpu)
 			struct kvm_vcpu *vcpu =
 				(struct kvm_vcpu *)smccc_get_arg1(host_vcpu);
 
-			ret = __kvm_vcpu_run(vcpu);
+			ret = __kvm_vcpu_run(kern_hyp_va(vcpu));
 			break;
 		}
 	case KVM_HOST_SMCCC_FUNC(__kvm_enable_ssbs):
@@ -82,14 +82,14 @@ static void handle_host_hcall(unsigned long func_id, struct kvm_vcpu *host_vcpu)
 			struct vgic_v3_cpu_if *cpu_if =
 				(struct vgic_v3_cpu_if *)smccc_get_arg1(host_vcpu);
 
-			__vgic_v3_save_aprs(cpu_if);
+			__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
 			break;
 		}
 	case KVM_HOST_SMCCC_FUNC(__vgic_v3_restore_aprs): {
 			struct vgic_v3_cpu_if *cpu_if =
 				(struct vgic_v3_cpu_if *)smccc_get_arg1(host_vcpu);
 
-			__vgic_v3_restore_aprs(cpu_if);
+			__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
 			break;
 		}
 	default:
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 99cf90200bf7..d866bff8a142 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -173,8 +173,6 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		pmr_sync();
 	}
 
-	vcpu = kern_hyp_va(vcpu);
-
 	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index f31185272b50..e5f65f0da106 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -56,7 +56,6 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	/*
@@ -110,7 +109,6 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
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
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
