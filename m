Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8C3ECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 04:47:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A19FD4CB20;
	Fri,  9 Sep 2022 00:47:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x3NbbCz+7kWg; Fri,  9 Sep 2022 00:47:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63BA14CA1B;
	Fri,  9 Sep 2022 00:47:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E29154C998
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 00:47:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dnx1SEzZ4AXu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 00:47:00 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFE9A4C278
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 00:47:00 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 k13-20020a056902024d00b0066fa7f50b97so749421ybs.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Sep 2022 21:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=qVBGSrI/KWTPkFtct01o77r/n8MEFbFBIyqHK8mbnss=;
 b=A+f8ccaReT78Mwr926D5zlus5ryXHfto50Ldpi0s9C5izCShLC+jvi3H3HpPwHgiW1
 XynSsZFsuLULMM1uIRAQjFeMBiRclaBgOq3b077Y6TGYw8a2f0FV2XwVx1c7sM9xUcON
 Lx+p6gimmASMygHqi7BWdXIqsj1C1gwasz0C7PoVfiekkcjql3fuuFkOJGOTi77Y7f9Q
 m/vV/W7X/38f33WtwECtJMdPGm8TDJSy66KHbUhGRfepKwNsM8rNVLVi0urb2BNf4CYv
 tPygzgftFS3sMHB/0T5HhrjApKv6pWtgwZIDB8o7QpvOIPe0Gzg7opLiK2Uu4GdP9ECU
 FVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=qVBGSrI/KWTPkFtct01o77r/n8MEFbFBIyqHK8mbnss=;
 b=qJ5ay3/YrYSt0UEtwnmDfhHRcriefYTlNQTFH8ay9jctLjDPmRCvelmsKAvRmvxro+
 rodMa853BjNC3edJ0QGdGflIR5OjEyH4Z63rmmszPjn8RM49fS49jl8EouTZyZp6FcWy
 fzf5xyXULrGWjXnmpIQVIF4sQflhlwXM0gI/yu4/TVdgxRKYXTBk7WDKKt8JKGh6jGqG
 KFRwieZqR+V7Opg2RA5yaUsf9PynAGhYP0bAcPAbZfdYGsOlvOVqh4VTRztt8tsEiZJq
 A9oa1iNC1PwFSgHsnAT7R7ZeCYncYbHtKoG+UMhzkT6LfehBQCfw1uQHvRhV4+t8SBs/
 xeVA==
X-Gm-Message-State: ACgBeo2+THh/fAHXmJnf03t8AQJleE9jmQ6FGmoZpSJKKoFPsyfgZrBX
 qZddb9Qa3gZG3a4ffoo24OessEQlPKQ=
X-Google-Smtp-Source: AA6agR6cNEIBry9BgSshMGxwWWRc5xAzxMKV1YLdQXwf+d9BHb/bCy3OT+neJ1h+yygWbHJZgWChiqkfD2E=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:8681:0:b0:33c:7394:9ee1 with SMTP id
 w123-20020a818681000000b0033c73949ee1mr10317707ywf.408.1662698820238; Thu, 08
 Sep 2022 21:47:00 -0700 (PDT)
Date: Thu,  8 Sep 2022 21:46:34 -0700
In-Reply-To: <20220909044636.1997755-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909044636.1997755-2-reijiw@google.com>
Subject: [PATCH 1/3] KVM: arm64: Don't set PSTATE.SS when Software Step state
 is Active-pending
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

Currently, PSTATE.SS is set on every guest entry if single-step is
enabled for the vCPU by userspace.  However, it could cause extra
single-step execution without returning to userspace, which shouldn't
be performed, if the Software Step state at the last guest exit was
Active-pending (i.e. the last exit was not triggered by Software Step
exception, but by an asynchronous exception after the single-step
execution is performed).

Fix this by not setting PSTATE.SS on guest entry if the Software
Step state at the last exit was Active-pending.

Fixes: 337b99bf7edf ("KVM: arm64: guest debug, add support for single-step")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/debug.c            | 19 ++++++++++++++++++-
 arch/arm64/kvm/guest.c            |  1 +
 arch/arm64/kvm/handle_exit.c      |  2 ++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e9c9388ccc02..4cf6eef02565 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -535,6 +535,9 @@ struct kvm_vcpu_arch {
 #define IN_WFIT			__vcpu_single_flag(sflags, BIT(3))
 /* vcpu system registers loaded on physical CPU */
 #define SYSREGS_ON_CPU		__vcpu_single_flag(sflags, BIT(4))
+/* Software step state is Active-pending */
+#define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(5))
+
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 0b28d7db7c76..125cfb94b4ad 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -188,7 +188,16 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
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
+
 			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
 			mdscr |= DBG_MDSCR_SS;
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
@@ -279,6 +288,14 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 						&vcpu->arch.debug_ptr->dbg_wcr[0],
 						&vcpu->arch.debug_ptr->dbg_wvr[0]);
 		}
+
+		if ((vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) &&
+		    !(*vcpu_cpsr(vcpu) & DBG_SPSR_SS))
+			/*
+			 * Mark the vcpu as ACTIVE_PENDING
+			 * until Software Step exception is confirmed.
+			 */
+			vcpu_set_flag(vcpu, DBG_SS_ACTIVE_PENDING);
 	}
 }
 
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
index bbe5b393d689..8e43b2668d67 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -154,6 +154,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 
 	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
+	else if (ESR_ELx_EC(esr) == ESR_ELx_EC_SOFTSTP_LOW)
+		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
 
 	return 0;
 }
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
