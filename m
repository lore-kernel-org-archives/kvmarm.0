Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AF4ECAAA1
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 01:06:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4739B4BD0E;
	Fri, 16 Sep 2022 21:06:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 12agZdaDcvso; Fri, 16 Sep 2022 21:06:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A4294BD3E;
	Fri, 16 Sep 2022 21:06:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7A374BD4B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id moeJ1FmxFzh9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2022 21:06:15 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 551584BD40
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:15 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 fa8-20020a17090af0c800b00202dd39c035so8611742pjb.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 18:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=YQt6uG8fSbZkAfWeNaxuSqzETg0b7PNb5gTd7k00f0w=;
 b=C1WrmyIH+Z/dEcpDleW+ejShqYj/QmixF8CLfHaQt75JUEhgIoCyN7bhhemLWp4AqZ
 rT0HMz9ZbSzM+mJNlatEa43Rct1kTQsdQBD7j2uPhZfV9aJit0KG3BazqL3T5cvph8iE
 vhkApKSHT/b4KTUgMpxtOHpf8/28y9m2eYA+0Ve+35/NqLo68eZDvtUiOvqc0G2CNz9M
 ftP4Zj7u6FQgIYZXuwyD/dSt8cNOABDha7Pl4auSkPFzj3y/49cwRbct5KDuXN1pNCgq
 D5vivhXn/orI+mcF0sLYmMMhGFPyzRcfGbygy1YXEBAYuDyb1BVtFArPu1tUFfcAjRrn
 sumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=YQt6uG8fSbZkAfWeNaxuSqzETg0b7PNb5gTd7k00f0w=;
 b=lAee3kZIPip0Cr8uQygYiIHNVdfkxHiBDC7A7hmkDRVMWbYJyYDLFO/d6nA7Jx4Bpq
 2pwz7888p/RkNZnbjmsEOOp7tOkT0oZfKa5XhPA24ImXecJm8AezpltwlcHGznKuFMad
 7ryK6zsVWHfkiVGA7sGm0yx3Qb4FDFszVXDqYmtcbRD3nAUA6YCv5Ze7CzH3coqOpqXO
 keOo0oOxFqdGECWwQPjyGllP3/aLgUOH59ZL61XX5Sba47Z1yXEjf15KJz1Um+ydJshJ
 fdaLuuAfQdsxorgsZi2IbKUuN91iQU42HSCnEARO9t4VciBUBhX4649UTDv7Ll0UWZoE
 VrKg==
X-Gm-Message-State: ACrzQf26xPVFXdJVqavCd0+zFkgqoJI800zz441lQ15rbRZ+TG6IJjCr
 ApcO5PDePnTGFJrBdGTjtexiAq+aTI0=
X-Google-Smtp-Source: AMsMyM6jpJMjpYqlFOfI2pB+UBe2eAmwk7phcNulJ/GQH7rJmrWkvdjDTb78mvBFDeztF18QqLIpkqt15UE=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a62:e702:0:b0:541:854b:3aaf with SMTP id
 s2-20020a62e702000000b00541854b3aafmr7615724pfh.41.1663376774245; Fri, 16 Sep
 2022 18:06:14 -0700 (PDT)
Date: Fri, 16 Sep 2022 18:05:58 -0700
In-Reply-To: <20220917010600.532642-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220917010600.532642-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220917010600.532642-3-reijiw@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: Clear PSTATE.SS when the Software Step
 state was Active-pending
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

While userspace enables single-step, if the Software Step state at the
last guest exit was "Active-pending", clear PSTATE.SS on guest entry
to restore the state.

Currently, KVM sets PSTATE.SS to 1 on every guest entry while userspace
enables single-step for the vCPU (with KVM_GUESTDBG_SINGLESTEP).
It means KVM always makes the vCPU's Software Step state
"Active-not-pending" on the guest entry, which lets the VCPU perform
single-step (then Software Step exception is taken). This could cause
extra single-step (without returning to userspace) if the Software Step
state at the last guest exit was "Active-pending" (i.e. the last
exit was triggered by an asynchronous exception after the single-step
is performed, but before the Software Step exception is taken.
See "Figure D2-3 Software step state machine" and "D2.12.7 Behavior
in the active-pending state" in ARM DDI 0487I.a for more info about
this behavior).

Fix this by clearing PSTATE.SS on guest entry if the Software Step state
at the last exit was "Active-pending" so that KVM restore the state (and
the exception is taken before further single-step is performed).

Fixes: 337b99bf7edf ("KVM: arm64: guest debug, add support for single-step")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/debug.c            | 22 +++++++++++++++++++++-
 arch/arm64/kvm/guest.c            |  1 +
 arch/arm64/kvm/handle_exit.c      |  8 +++++++-
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ccf8a144f009..45e2136322ba 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -536,6 +536,9 @@ struct kvm_vcpu_arch {
 #define IN_WFIT			__vcpu_single_flag(sflags, BIT(3))
 /* vcpu system registers loaded on physical CPU */
 #define SYSREGS_ON_CPU		__vcpu_single_flag(sflags, BIT(4))
+/* Software step state is Active-pending */
+#define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(5))
+
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 1bd2a1aee11c..56361e512b8a 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -200,7 +200,18 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		 * debugging the system.
 		 */
 		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
-			*vcpu_cpsr(vcpu) |=  DBG_SPSR_SS;
+			/*
+			 * If the software step state at the last guest exit
+			 * was Active-pending, we don't set DBG_SPSR_SS so
+			 * that the state is maintained (to not run another
+			 * single-step until the pending Software Step
+			 * exception is taken).
+			 */
+			if (!vcpu_get_flag(vcpu, DBG_SS_ACTIVE_PENDING))
+				*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
+			else
+				*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
+
 			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
 			mdscr |= DBG_MDSCR_SS;
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
@@ -274,6 +285,15 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 	 * Restore the guest's debug registers if we were using them.
 	 */
 	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
+		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+			if (!(*vcpu_cpsr(vcpu) & DBG_SPSR_SS))
+				/*
+				 * Mark the vcpu as ACTIVE_PENDING
+				 * until Software Step exception is taken.
+				 */
+				vcpu_set_flag(vcpu, DBG_SS_ACTIVE_PENDING);
+		}
+
 		restore_guest_debug_regs(vcpu);
 
 		/*
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index f802a3b3f8db..2ff13a3f8479 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -937,6 +937,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	} else {
 		/* If not enabled clear all flags */
 		vcpu->guest_debug = 0;
+		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
 	}
 
 out:
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index bbe5b393d689..e778eefcf214 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -152,8 +152,14 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 	run->debug.arch.hsr_high = upper_32_bits(esr);
 	run->flags = KVM_DEBUG_ARCH_HSR_HIGH_VALID;
 
-	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
+	switch (ESR_ELx_EC(esr)) {
+	case ESR_ELx_EC_WATCHPT_LOW:
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
+		break;
+	case ESR_ELx_EC_SOFTSTP_LOW:
+		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
+		break;
+	}
 
 	return 0;
 }
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
