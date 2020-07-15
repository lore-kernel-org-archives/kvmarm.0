Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFBFC433ED
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6ED002065F
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="KTTXAkeh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ED002065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D8E54B3F4;
	Wed, 15 Jul 2020 14:45:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zhfTEoC6OaEx; Wed, 15 Jul 2020 14:45:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB42B4B3FC;
	Wed, 15 Jul 2020 14:45:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3C24B212
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ul9uZH0ufexb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:48 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9D4A4B3CF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:48 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id 205so3908109yby.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+Zg+5c83+TafNVFKvxy65y7/dSEVY4GZL4S5Qt/PiCA=;
 b=KTTXAkehKFZ1Ozu4q2Ca4l0W5Q8L/xWSM3gIAdePbcTXFVSl6D/AjWwfTwOBZ7tfIu
 WS990F1iOt3vaLmIMt9LOPToR0WTYHyPZU+RU6mxGR7x+D9ms7GaBTvkclDNX+e9T3fX
 EiznpUY23885hNUhAwRiTMwhaIpxi7xd6FsL28cRoYuK9WcB4enJlYQWThBawotu1W7s
 cDllmxa/HT1dI5CpZXHKUNJ1q4l9zHJJHlv2zoRLGM6BRd2nA4pE0hHc2cbW+DHvvNqe
 mYbhiVGW7OKd+CkgdoFlA5OoMbVAM+7nNfdVWcJAUGr5P7gQkG5HVWGfFjWa0TaN7oVx
 U9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+Zg+5c83+TafNVFKvxy65y7/dSEVY4GZL4S5Qt/PiCA=;
 b=AjdsEsxJYzOb4vwHyZpTL886xHFStLEKpcxALuh/5cKR1B3p73a7+X2OtuAGBAGnyk
 gBoG6Wsmkl4UNyLRwU7aDiIMxBQxAV4a1dujb4yU67uJEjMxrghe8sidpRABNCNugm2H
 wJNxeJqFOeQeC22VB3p3eIcUpKERLjURbN2vUVvCUkR3nH5HnwXtoxqd5dQ0iM6E0n4F
 Vc0TwxYD5y70aLpnkE8fuCWtgeVpIkdEb4sHs7OrqSE4F66Mtaz5ghc7vwMhwOIoD9ww
 eEY9cyZbcENqvRKMePYBCIdbpOYJ81T+RnWgp4nD7nuHllOFrTw96OtBrTlDJNQfxaXl
 Gehw==
X-Gm-Message-State: AOAM5315ZYSyPKuq0hR7ToOOvEAwDVHBsW62OCqMoNzRX/V20uEQ8ZDo
 fsJ8nhkJYKciyYmVAsyWry/wliaKOJOGrD9kEYTgmk/+dpaWM3OBsKp2fESuUeSegsFY+BvaAJ3
 eAsAa0G5RriXF/FDiAa2qZbi/GoN5UqKAwKWq4oxlhMNhxsJ7/pSQ4BIt2Smnxw9WMmvFRA==
X-Google-Smtp-Source: ABdhPJyP9IWB7iFDxSnXMQQ/rIWzr//JY/7Zl9Ae5IZMQoMdSsrXUQHRsQBlCLkRgTH90RItfwiUD/EzWnA=
X-Received: by 2002:a25:cc55:: with SMTP id l82mr584824ybf.232.1594838748364; 
 Wed, 15 Jul 2020 11:45:48 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:28 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-28-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 27/37] KVM: arm64: nVHE: Unify vgic save and restore
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

If interrupts are trapped for the vcpu, save and restore the vgic state.
Interrupts are not trapped for the host vcpu so the vgic will remain
untouched.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index a23eba0ccd3e..eb10579174f2 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -94,6 +94,9 @@ static void __deactivate_vm(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.ctxt.is_host)
+		return;
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -103,6 +106,9 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 /* Restore VGICv3 state on non_VEH systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.ctxt.is_host)
+		return;
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -169,7 +175,6 @@ static void __kvm_vcpu_switch_to_guest(struct kvm_vcpu *host_vcpu,
 	__activate_vm(kern_hyp_va(vcpu->arch.hw_mmu));
 	__activate_traps(vcpu);
 
-	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
 
 	__debug_switch_to_guest(host_vcpu, vcpu);
@@ -181,7 +186,6 @@ static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 
 	__timer_disable_traps(vcpu);
-	__hyp_vgic_save_state(vcpu);
 
 	__deactivate_traps(host_vcpu, vcpu);
 	__deactivate_vm(vcpu);
@@ -208,6 +212,7 @@ static void __vcpu_save_state(struct kvm_vcpu *vcpu)
 {
 	__sysreg_save_state_nvhe(&vcpu->arch.ctxt);
 	__sysreg32_save_state(vcpu);
+	__hyp_vgic_save_state(vcpu);
 }
 
 static void __vcpu_restore_state(struct kvm_vcpu *vcpu)
@@ -225,6 +230,8 @@ static void __vcpu_restore_state(struct kvm_vcpu *vcpu)
 	else
 		__kvm_vcpu_switch_to_guest(running_vcpu, vcpu);
 
+	__hyp_vgic_restore_state(vcpu);
+
 	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 }
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
