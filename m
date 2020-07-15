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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F96C433E8
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E835207CB
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="KNH5aOM9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E835207CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 378D04B381;
	Wed, 15 Jul 2020 14:45:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IgjPuFeeOE-F; Wed, 15 Jul 2020 14:45:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 393174B3F3;
	Wed, 15 Jul 2020 14:45:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B74F4B381
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DZMXY6-D+hCM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:38 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 416BE4B3FE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:38 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id b13so1744191wme.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0z/MiPlBDRsHJF7rBDqdEMFFrKLB9C9HVm3iOVMZkUs=;
 b=KNH5aOM91lvpEZiNF2yIpXNMMKK4R40K8U8Fx4UHIOY1wdnl3TqHXQcwGAXHGiaHXd
 vKZEfkndRGeiL6jM5f7t/KY+6g2K2/VbOXw/rSUgHl0jUVn5svzDG5zaRMoWxKFJPhlX
 FSllxbfOW7BUbje99RK6X/K2dO+4QBFJjeh4haNEy5iQMdHkAIFlkR5Ut2jZk0fYyad2
 ui3SArX8ChZaj2h9B00o2eRVioC8LdZvU/wj9aaqEQ1NAfzfTzaAZIFMdXT2jj/oLgoe
 iTulZcKhIWGrBr7LWAAcjfO2lDG3kwTm4DPWswD8fOFvPINhGS0Can1XiMKnpTxM7Qu6
 0L+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0z/MiPlBDRsHJF7rBDqdEMFFrKLB9C9HVm3iOVMZkUs=;
 b=uK2IqWN6ZUEfwqX9rjcbZ4ATKS0m+dWr2MFR/hL3sk8H+kVh++3swvXPqER8wrK81p
 9nN3FHYPfejLJymdWnnPp6VlpCzk13MXb+fiMcuInwWu7BCi/5FZKSRpzTPCyh6aRReW
 i7UKnZYQEHfEgEwGGsS7TAL8HrLKfOiFMVpE6rs1tlnHnekaL2gCZH/U5yr2q9U6QmiS
 WGsFPRJW7xtn+4SgkRxb8AtQPW5+jgAmgyq9Ip5uT/c3DMzCl6fyfD07IOxoIMecHt3q
 o+pUdsiDjHpkvFHlnNRzXwgOnZvuS+KFnBjKOrRXrzfv4TVcK0mUetbLTgq05bUBKbkM
 2skg==
X-Gm-Message-State: AOAM532uQLB47O2v01/a5Lnc8RBhcBGcahXbX39xI4tQc+Y9lqtrlb95
 Bj8E5QXRobWyqfhNtyOfT/Zt2Dv3NMDaSj2VKYNhJcDuLPQHbmDz8p1GDs9JpDYnshoRoV8nriB
 RTAKHhEXYCxrvie/i3DSqxzb31bAevYUO4LjlbMRYOBzwd5x8U92JjTCsyWkTxzJn8e034g==
X-Google-Smtp-Source: ABdhPJzwqYmpIBd6FEfulgMm+7rik4YbvG0zz3ok0WSrhgInfuUJIl/TzHuAOgY0yvYrKI2O5bJ4gpI+3NM=
X-Received: by 2002:a7b:c116:: with SMTP id w22mr707371wmi.97.1594838737380;
 Wed, 15 Jul 2020 11:45:37 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:23 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-23-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 22/37] KVM: arm64: nVHE: Store host's mdcr_el2 and hcr_el2 in
 its vcpu
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

This make the host vcpu's state more accurate and lays the foundations
for the configurations being dynamic.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  7 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c   | 17 +++++------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e7601de3b901..3a78fe8b923a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -163,13 +163,20 @@ void __noreturn kvm_hyp_main(void)
 {
 	/* Set tpidr_el2 for use by HYP */
 	struct kvm_vcpu *host_vcpu;
+	u64 mdcr_el2;
 
 	host_vcpu = __hyp_this_cpu_ptr(kvm_host_vcpu);
 
 	kvm_init_host_cpu_context(&host_vcpu->arch.ctxt);
 
+	mdcr_el2 = read_sysreg(mdcr_el2);
+	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
+	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
+
 	host_vcpu->arch.flags = KVM_ARM64_HOST_VCPU_FLAGS;
 	host_vcpu->arch.workaround_flags = VCPU_WORKAROUND_2_FLAG;
+	host_vcpu->arch.hcr_el2 = HCR_HOST_NVHE_FLAGS;
+	host_vcpu->arch.mdcr_el2 = mdcr_el2;
 	host_vcpu->arch.debug_ptr = &host_vcpu->arch.vcpu_debug_state;
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 629fea722de1..88e7946a35d5 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -58,14 +58,10 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void __deactivate_traps(struct kvm_vcpu *vcpu)
+static void __deactivate_traps(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *vcpu)
 {
-	u64 mdcr_el2;
-
 	___deactivate_traps(vcpu);
 
-	mdcr_el2 = read_sysreg(mdcr_el2);
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
@@ -85,11 +81,8 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	__deactivate_traps_common();
 
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
-	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
-
-	write_sysreg(mdcr_el2, mdcr_el2);
-	write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
+	write_sysreg(host_vcpu->arch.mdcr_el2, mdcr_el2);
+	write_sysreg(host_vcpu->arch.hcr_el2, hcr_el2);
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
@@ -194,7 +187,7 @@ static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
 
-	__deactivate_traps(vcpu);
+	__deactivate_traps(host_vcpu, vcpu);
 	__deactivate_vm(vcpu);
 
 	__sysreg_restore_state_nvhe(&host_vcpu->arch.ctxt);
@@ -283,7 +276,7 @@ void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 
 	if (vcpu != host_vcpu) {
 		__timer_disable_traps(vcpu);
-		__deactivate_traps(vcpu);
+		__deactivate_traps(host_vcpu, vcpu);
 		__deactivate_vm(vcpu);
 		__sysreg_restore_state_nvhe(&host_vcpu->arch.ctxt);
 	}
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
