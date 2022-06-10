Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1659C43334
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 09:35:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C8C54B394;
	Fri, 10 Jun 2022 05:35:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kUCApUak5qwB; Fri, 10 Jun 2022 05:35:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA324B3BE;
	Fri, 10 Jun 2022 05:35:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 106934B3BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IPh-goK+qs2f for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 05:35:35 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A18B4B391
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:35 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id CD782CE3407;
 Fri, 10 Jun 2022 09:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251B9C34114;
 Fri, 10 Jun 2022 09:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654853728;
 bh=WO98t9PGem9PjQfpIvFZjfbm0/gruHeGAc6P6CvY+1E=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=sskOLIp1Y3k/bSaWbmw+9nKYVDoSSSW2cTBbrB/7ujV8mSnNsP6E7bpLu0CGKr/Li
 fdE1GhkykMcsp3bg+vbxxrzpbdkDDopMbvmhGiWiGf4tKiD0adhDeWFYrE1SpbEAOF
 pUI6juhdyaTzHOf0Np/YMAR44pdDJnywHqRsKezwJN9yLx9Ks5pIiIlB5giOFYX07C
 kc7WUqQhirnMaScu2UebtVMBv6c7FVvoUJrx0cR9iyefYlFsIRsZDXKLwbvsJg0aRR
 goNXOAMMXvFbFDx6nIzxtpT3z/OIuvXWaQut28hXLnKh2qOiFj1km33VxyUDByFJeM
 PHn+i+HCGFa/Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzawq-00H6Dt-O1; Fri, 10 Jun 2022 10:28:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 12/19] KVM: arm64: Move vcpu WFIT flag to the state flag set
Date: Fri, 10 Jun 2022 10:28:31 +0100
Message-Id: <20220610092838.1205755-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 reijiw@google.com, kernel-team@android.com
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

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/arch_timer.c       | 2 +-
 arch/arm64/kvm/arm.c              | 2 +-
 arch/arm64/kvm/handle_exit.c      | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0c22514cb7c7..0fb1a5b86f16 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -521,6 +521,8 @@ struct kvm_vcpu_arch {
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
+/* WFIT instruction trapped */
+#define IN_WFIT			__vcpu_single_flag(sflags, BIT(3))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -542,8 +544,6 @@ struct kvm_vcpu_arch {
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
index 5beabbe69585..8b9da9d30485 100644
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
index f66c0142b335..d045f5b973b9 100644
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
