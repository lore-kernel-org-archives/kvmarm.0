Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FD2C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B8D06140D
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1B8D06140D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7A2B4B1EF;
	Fri, 24 Sep 2021 08:54:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id stTf+JtQdHuJ; Fri, 24 Sep 2021 08:54:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9AC240642;
	Fri, 24 Sep 2021 08:54:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1D7B4B1D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Al1MgwbZpS73 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:38 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D76DB4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:35 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 z6-20020a056214060600b0037a3f6bd9abso31195415qvw.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=56Ft6X8W77hY1O7BY33JIx3hfVz1zTOJLBEzRbdZLVw=;
 b=bNf2MAkSxeUvnC8APurNJOKp8j5WNRVTRWXn3WErUfYnVGPg5v/3n5gcIVXKw4t9W+
 ++aRVwRIoyywjT6TVBxQg1NUQyGIG0VzdvUVrPmsmOd0j6qsR/jOMsEc8AodGDClGEYE
 ilc5+eCrH2jUWhkTldhPyKFHm6/CQrcZGo/No50sHneGSa0fwYmSP74YwjfYULkYD+hn
 c5Y2MjS7Qyto3oZ343G5CHx9di3IAseWbWfsc1zBK/cjTfGcfNSlwFNI2q+xAnHGH574
 EU/1NvgGryTNgZSf9rJArmTNgJZZQh+vL1Qo+AIO/e4ZwxL72jO5CZVB43cxyj7O4E83
 ruhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=56Ft6X8W77hY1O7BY33JIx3hfVz1zTOJLBEzRbdZLVw=;
 b=0ClEqnw45sPXS3MDSGSEaTJTBBwOESiySTAF5BCXEWos7nyTQ941JHatR8XzWdG/13
 cT2s8qiTU3YC3q7yM0OCFi9YHLRaiO/1YNKqK5GKVrtRya2ToUmBoQQUmOr2sIhUJ+fZ
 FwiO4B6hf+b6D9jsqKZ2vC1dXIaWrwQo21Wg6Ysh/5Feupyi8Hh9QN7CMM2cLhbcHnHP
 En1MJgD19HRfCgHH7RBXek0TYFCPYJpD2vKdKwSEz9CAE1zkn5auSxs1Atx8mPTsCIEG
 wmFY/501NmGuiQTFOskSrZcV2e+n8JmXJz+GLD9BWWB/ciaJo/5mo18Punuoc6eko4gq
 bXPw==
X-Gm-Message-State: AOAM533Z4e6+J15w16HokIQn9eHbPNqgXU4r3ZdrfUuWqJhe4MGQ7Rml
 FkaeDAzrP149D+jbiBBaJEQH0iZ1DrFt4FymJZ313PWl37EAlfKriFhttAbSOWv3b9Sc9OTD23Y
 VhfKpd3o3hzyYJQk1epAU6fvKw7nuoh6LIF8aK6wZERm6xNcYUclTPYJydGMTwOGAoWo=
X-Google-Smtp-Source: ABdhPJyUkz++TQP8NYy0o2i3otydUYMEFbi7J6On+R3jI66SeEyVA2YIEWBaY5/7X1wyxFyCNX3yufb4nQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:cb10:: with SMTP id
 o16mr10045783qvk.57.1632488075438; 
 Fri, 24 Sep 2021 05:54:35 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:45 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-17-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 16/30] KVM: arm64: reduce scope of vgic_v3 access
 parameters
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

Now that the __vgic_v3_perform_cpuif_access only needs
vgic_v3_cpu_if, kvm_cpu_context, vcpu_hyps, pass these rather
than the whole vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h        | 4 +++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c         | 9 ++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index d9a8872a7efb..b379c2b96f33 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -63,7 +63,9 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
-int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
+int __vgic_v3_perform_cpuif_access(struct vgic_v3_cpu_if *cpu_if,
+				   struct kvm_cpu_context *vcpu_ctxt,
+				   struct vcpu_hyp_state *vcpu_hyps);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(void);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 30fcfe84f609..44e76993a9b4 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -502,7 +502,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgi
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
 	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 ||
 	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
-		int ret = __vgic_v3_perform_cpuif_access(vcpu);
+		int ret = __vgic_v3_perform_cpuif_access(&vcpu->arch.vgic_cpu.vgic_v3, vcpu_ctxt, vcpu_hyps);
 
 		if (ret == 1)
 			goto guest;
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 3e1951b04fce..2c16e0cd45f0 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -1097,11 +1097,10 @@ static void __vgic_v3_write_ctlr(struct vgic_v3_cpu_if *cpu_if,
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
-int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
+int __vgic_v3_perform_cpuif_access(struct vgic_v3_cpu_if *cpu_if,
+				   struct kvm_cpu_context *vcpu_ctxt,
+				   struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	int rt;
 	u32 esr;
 	u32 vmcr;
@@ -1112,7 +1111,7 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 
 	esr = kvm_hyp_state_get_esr(vcpu_hyps);
 	if (ctxt_mode_is_32bit(vcpu_ctxt)) {
-		if (!kvm_condition_valid(vcpu)) {
+		if (!__kvm_condition_valid(vcpu_ctxt, vcpu_hyps)) {
 			__kvm_skip_instr(vcpu_ctxt, vcpu_hyps);
 			return 1;
 		}
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
