Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C3FC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:50:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C08FC4B332;
	Sat, 28 May 2022 07:50:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JAoqc0gMapQQ; Sat, 28 May 2022 07:50:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 776184B335;
	Sat, 28 May 2022 07:50:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FDD84B31E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1nMu9B-rEl9R for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:50:01 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EC374B324
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:01 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 43928B826FE;
 Sat, 28 May 2022 11:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED638C3411A;
 Sat, 28 May 2022 11:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653738599;
 bh=AkMuVhr5rTYujT3XS/iMRTcjONn9P25B4EDiWqrs1o4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tJpix81Xn0l8JwPJLFw5vgpDw7WPjrmyTTruKVK6Km2I0aKpJl5ShNpcgvLyeXJOH
 Qtk57bLwjelIhTkaJsokXq8ImNLBI2a6i+jRrXO86I0BI0/HyX/v3dlwUs0a2Z4y+a
 m8j/Nz9Vx1+/8CnYgy/G4VR2+20uyRnTdTij+hekj1Eeq3P9ob4eHl/6bwD3Sw79id
 TUCVAaRiAD3iHlyXzyqSDfFc3hbAVlO0TbylZGMYXKdljrYCKvENlE0lhwl++F3crW
 954WPlr/HHO7gGfWt4MSpwOdUSX6YtvbYRYlNBy8ZJzfYRJYS4wxhZfGuOR7YEfhh8
 nHNwg3StZoBvQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuumC-00EEGh-Ar; Sat, 28 May 2022 12:38:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 12/18] KVM: arm64: Move vcpu WFIT flag to the state flag set
Date: Sat, 28 May 2022 12:38:22 +0100
Message-Id: <20220528113829.1043361-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
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

The host kernel uses the WFIT flag to remember that a vcpu has used
this instruction and wake it up as required. Move it to the state
set, as nothing in the hypervisor uses this information.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/arch_timer.c       | 2 +-
 arch/arm64/kvm/arm.c              | 2 +-
 arch/arm64/kvm/handle_exit.c      | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e0a2edca5861..fe7e1c44e6e9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -513,6 +513,8 @@ struct kvm_vcpu_arch {
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
+/* WFIT instruction trapped */
+#define IN_WFIT			__vcpu_single_flag(sflags, BIT(3))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -534,8 +536,6 @@ struct kvm_vcpu_arch {
 	__size_ret;							\
 })
 
-/* vcpu_arch flags field values: */
-#define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 4e39ace073af..5290ca5db663 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -242,7 +242,7 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 static bool vcpu_has_wfit_active(struct kvm_vcpu *vcpu)
 {
 	return (cpus_have_final_cap(ARM64_HAS_WFXT) &&
-		(vcpu->arch.flags & KVM_ARM64_WFIT));
+		vcpu_get_flag(vcpu, IN_WFIT));
 }
 
 static u64 wfit_delay_ns(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d7d42d79ede1..49a3fe9f7009 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -657,7 +657,7 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 
 	kvm_vcpu_halt(vcpu);
-	vcpu->arch.flags &= ~KVM_ARM64_WFIT;
+	vcpu_clear_flag(vcpu, IN_WFIT);
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 
 	preempt_disable();
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 2ebebd3efaee..dac86d2c6654 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -120,7 +120,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
 		if (esr & ESR_ELx_WFx_ISS_WFxT)
-			vcpu->arch.flags |= KVM_ARM64_WFIT;
+			vcpu_set_flag(vcpu, IN_WFIT);
 
 		kvm_vcpu_wfi(vcpu);
 	}
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
