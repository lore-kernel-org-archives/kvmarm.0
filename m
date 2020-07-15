Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BC7C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60B62207BB
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="SZ1p5kOk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60B62207BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB004B3F9;
	Wed, 15 Jul 2020 14:46:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OM0v2N0XO-9w; Wed, 15 Jul 2020 14:46:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01FD74B40D;
	Wed, 15 Jul 2020 14:46:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18B664B39D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:46:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 91N576wLAjJ2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:46:04 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 186004B3CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:46:04 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id g6so2026036qtr.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=y5s18XRBlAyzcp9Hg66XxhMhUCdEQOYdhCBF6Q4nOOc=;
 b=SZ1p5kOk/RSS8l83qZfs0tlTlFx2DrdpazV+4RpwXaJwWQPI2dcjZz7rnasikwKZeJ
 TILDC6bj7Y0o6PcK1oIaqbSKxF7SbYYRCr0SISimI8qZpRB5PoQJtrzSheWBHCzGaO/L
 1+kSrjG+zwc8fSvUmiDqb60Fx/c5l0iGypt2sHOW5aD35MaQBthocJw0NXsVBIPgeMjS
 r+89tVMDQOLlRsc4c9qA/rtxsnj/hBx0HM2tXeBYHdSPJAZ2yIQs8V0hNJmNfKeO29Rh
 i64Lo2579pGQ9sk4TFHctBkJAG42Xitzrs73GzzvGiAs2crgHIgu8hm6CfpgqxyyB6MG
 VWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=y5s18XRBlAyzcp9Hg66XxhMhUCdEQOYdhCBF6Q4nOOc=;
 b=l0PMtLaFAufh/CUYnk0SgOe/Oeu7kosKf8ElUxIVWYf1ke7F5b+776vNsc4T1pIl3L
 qeI414oOtXxRg3uIxGSfXwlYo0hB08ooCidAyyjMO0A3+5JmZKIv67Fu4CofbQYFP38R
 980vOmEV1AiXsMk/sa0vKDqiLMMILkCigybxpWgTCP0NXm1LOIIpmdjJxUnvBzDNQMLq
 he4GJN5AE2XXR/2wEj0+uy4hbaxdaHpsMt3LiyYBDeMlX0Ri9OK5Jg63ZcRhArHFJXSA
 tZjt7TQUE3CCPhlWac0kY1o3Pq5Ya4UcUsFdr/gZRQ/INgApmqDiPKGyOOdvt8oG31XN
 Fi/A==
X-Gm-Message-State: AOAM533c49lTMgbGlBY5eV/57sb/cfLC0BMfjpp+WuUAU+YhiVsUnLaU
 t/Y5MX3AP26YkBAWgL3wyArxq/nt5Dth9JlUqjnkzbIDRtasaZ5Ew5sHYaeldA1Hrrj0hONdNwZ
 avrsspaFd1y4JsuWAlcus4yY4Vh+xuC6JbR7yf2CTpi/zu9VhudBwQ6ybOglFtaRvvOOALA==
X-Google-Smtp-Source: ABdhPJziqPjFNLmp+6OS2J/uDxCsVDimukSKnx5FRuEJTs5BSnerF3+a1+C2QdOPzhr4uEzym5Q21NSZl1I=
X-Received: by 2002:ad4:458f:: with SMTP id x15mr734391qvu.176.1594838763514; 
 Wed, 15 Jul 2020 11:46:03 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:35 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-35-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 34/37] KVM: arm64: nVHE: Unify timer restore paths
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

Different actions are taken depending on whether the vcpu is the host or
not but this choice could easily be changed to another property of the
vcpu, if required.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  3 +--
 arch/arm64/kvm/hyp/nvhe/switch.c   |  7 ++----
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 35 +++++++++++-------------------
 3 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index d4d366e0d78d..fdacb26ac475 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -81,8 +81,7 @@ void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __timer_enable_traps(struct kvm_vcpu *vcpu);
-void __timer_disable_traps(struct kvm_vcpu *vcpu);
+void __timer_restore_traps(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index fa90fc776374..05f1cf7ee9e7 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -131,15 +131,11 @@ static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
 	}
 
 	__pmu_switch_to_guest();
-
-	__timer_enable_traps(vcpu);
 }
 
 static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 				      struct kvm_vcpu *vcpu)
 {
-	__timer_disable_traps(vcpu);
-
 	__pmu_switch_to_host();
 
 	/* Returning to host will clear PSR.I, remask PMR if needed */
@@ -211,6 +207,7 @@ static void __vcpu_restore_state(struct kvm_vcpu *vcpu, bool restore_debug)
 		__activate_traps(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
+	__timer_restore_traps(vcpu);
 
 	/*
 	 * This must come after restoring the sysregs since SPE may make use if
@@ -280,7 +277,7 @@ void __noreturn hyp_panic(void)
 	unsigned long str_va;
 
 	if (vcpu != host_vcpu) {
-		__timer_disable_traps(vcpu);
+		__timer_restore_traps(host_vcpu);
 		__deactivate_traps(host_vcpu, vcpu);
 		__restore_stage2(host_vcpu);
 		__sysreg_restore_state_nvhe(&host_vcpu->arch.ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..914d2624467d 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -19,30 +19,21 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
  * Should only be called on non-VHE systems.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
-void __timer_disable_traps(struct kvm_vcpu *vcpu)
+void __timer_restore_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val = read_sysreg(cnthctl_el2);
 
-	/* Allow physical timer/counter access for the host */
-	val = read_sysreg(cnthctl_el2);
-	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
-	write_sysreg(val, cnthctl_el2);
-}
-
-/*
- * Should only be called on non-VHE systems.
- * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
- */
-void __timer_enable_traps(struct kvm_vcpu *vcpu)
-{
-	u64 val;
+	if (vcpu->arch.ctxt.is_host) {
+		/* Allow physical timer/counter access for the host */
+		val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
+	} else {
+		/*
+		 * Disallow physical timer access for the guest
+		 * Physical counter access is allowed
+		 */
+		val &= ~CNTHCTL_EL1PCEN;
+		val |= CNTHCTL_EL1PCTEN;
+	}
 
-	/*
-	 * Disallow physical timer access for the guest
-	 * Physical counter access is allowed
-	 */
-	val = read_sysreg(cnthctl_el2);
-	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
 	write_sysreg(val, cnthctl_el2);
 }
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
