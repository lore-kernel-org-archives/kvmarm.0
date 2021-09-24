Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5227C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8CE8E61465
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8CE8E61465
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42F5D4B0DF;
	Fri, 24 Sep 2021 08:55:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uOlwStO8jKuR; Fri, 24 Sep 2021 08:55:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B27A4B1FB;
	Fri, 24 Sep 2021 08:55:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A104B218
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:55:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GSHR+ki0pbaf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:59 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4964C4B1FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:57 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 r7-20020a5d6947000000b0015e0f68a63bso7976416wrw.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nCXG0l+R9HIObQKW2P1KEyRjnYx24qX/arXoNkRGWM8=;
 b=bMETGKRZDsz/QLyWmlXkyVgIPXXIPgZPSQ+bmmIPAzzvTvXeq4PAlaA1o2khsZ2dh7
 hBNR5QqKDv2VXDgHc1rRqYT9wKChVUg2/OZHtAd6zlOm2g4HjZNM9TPWEO4bv4BxB6Qb
 g6G41+9Tk7ijHNcaP9/MxEwBz6R501wDU7EbBaGWYdJO4na0sllQa5q9OgYxpzMkfULB
 Kn/PDJ6p7qfvKukg7M9lfhYb/xfJstXcYLear6w70Opn6svw08NeeQRmTsvhtQSgF+0O
 mEr+wp8I0aGqt1vlM4lBjOLPvhgaM5zPqNPGcpptUZddXYcT+M1mGTG7Mndr5rkBZ+au
 XluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nCXG0l+R9HIObQKW2P1KEyRjnYx24qX/arXoNkRGWM8=;
 b=Izr8n1bppXMrqkZAYKnW3J9/nyZBINWFoj0kslHnjOHCItDJlj8g50ytfDUn1B5uZO
 oKltNn8swAe0a98D+BTFoAfWvf8dG1p6BfACiyQIFM7BDU9Mk+4aoGpkD+9jUKTNqfhn
 ulVKSuLdUOv90oUQZS+ySKxjFyFaZcpI+R9AYDyG+UbABRoQi0SoPXyL4sK1cOuuqXjJ
 4FPuid3/bEN9Sr1daOvh07Tg1uPyKvYEnx6hJZMrj9v5bPY3ACTHSvNMJPWhyPZATH0q
 ndUvGs9yo6a6mdokXr0pW35AAkBaqBnxZ9eZm8iBvIZKF2U9bVYFSJ1irMe6y0aqSGHY
 IROw==
X-Gm-Message-State: AOAM530DGAscGf5t2v/YAcpwgRyk/hrdp1BQDDFBYePOwtD7WhfO9vUZ
 T4sdBiKr7+iIp3OyJUvobd+n7K5eesy9pMtFqiehgNpJ+Bm4ukfYsplSHQxV3TodzW9rCcTWYc7
 7r3iXnuV8oQZ91FeK99paLMsFaNnL8YDKQDh4i3gMhnWDoA4MKdjN35xlRL9FGw7kq54=
X-Google-Smtp-Source: ABdhPJyLaWDPi72Md06wxlso8tc+C+HUsJOKyBd5N7LvM9mwCmnEhGULtENvFCUBKM2sh1nwCEuENi62Xw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:2184:: with SMTP id
 e4mr1925558wme.61.1632488096350; Fri, 24 Sep 2021 05:54:56 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:55 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-27-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 26/30] KVM: arm64: pVM activate_traps to use vcpu_ctxt
 and vcpu_hyp_state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Refactor protected VM activate_traps not to use vcpu. Protected
32 bit VMs are not supported, and therefore the code for setting
the floating point traps at 32 bits isn't needed for the pvm
case.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 35 +++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 9e79f97ba49e..0d654b324612 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -34,9 +34,10 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
-static void __activate_traps(struct kvm_vcpu *vcpu)
+/* Activate traps for protected guests */
+static void __activate_traps_pvm(struct kvm_cpu_context *vcpu_ctxt,
+				 struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	u64 val;
 
 	___activate_traps(vcpu_hyps);
@@ -44,26 +45,36 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
-	if (!update_fp_enabled(vcpu)) {
-		val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
-		__activate_traps_fpsimd32(vcpu);
-	}
 
 	write_sysreg(val, cptr_el2);
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
-
 		isb();
 		/*
 		 * At this stage, and thanks to the above isb(), S2 is
 		 * configured and enabled. We can now restore the guest's S1
 		 * configuration: SCTLR, and only then TCR.
 		 */
-		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
+		write_sysreg_el1(ctxt_sys_reg(vcpu_ctxt, SCTLR_EL1), SYS_SCTLR);
 		isb();
-		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
+		write_sysreg_el1(ctxt_sys_reg(vcpu_ctxt, TCR_EL1), SYS_TCR);
+	}
+}
+
+/* Activate traps for non-protected guests in nVHE */
+static void __activate_traps_nvhe(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu->arch.ctxt;
+
+	__activate_traps_pvm(vcpu_ctxt, vcpu_hyps);
+
+	if (!update_fp_enabled(vcpu)) {
+		u64 val = CPTR_EL2_DEFAULT | CPTR_EL2_TTA | CPTR_EL2_TAM |
+			  CPTR_EL2_TFP | CPTR_EL2_TZ;
+		__activate_traps_fpsimd32(vcpu);
+		write_sysreg(val, cptr_el2);
 	}
 }
 
@@ -219,7 +230,7 @@ static int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
-	__activate_traps(vcpu);
+	__activate_traps_nvhe(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps();
@@ -321,7 +332,7 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
-	__activate_traps(vcpu);
+	__activate_traps_pvm(vcpu_ctxt, vcpu_hyps);
 
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps();
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
