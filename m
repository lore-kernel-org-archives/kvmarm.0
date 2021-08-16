Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5113C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5524E6137D
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5524E6137D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4864B0FA;
	Sun, 15 Aug 2021 20:12:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uG1sl-0JnfO5; Sun, 15 Aug 2021 20:12:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F0B34B121;
	Sun, 15 Aug 2021 20:12:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D68D4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T8BveOyvYvVV for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:12:28 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FA574B0C0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:24 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 a15-20020a92444f000000b0022473393120so1399368ilm.16
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=yxA2cYvOw4or+4AZfWJZCSU9QyWVjXr9zaqNQ/48i2s=;
 b=nDtqvdQ7zdtXwYiwMQDF1s28Q9lRq1TBtvEl+wjguLSzHMES3Pf850aZrjq+l1VkiK
 Fucj07/fJK/i61BnxLOsPalL7upt2tFLHRujsOoNh43R4Qq1Ub/pcwk7Vi8h63ayHMWD
 M26bjm8VVbjK7WXmzXvj3wgfnn1F8pZojrfk/J3vw2GLKqjxQrY2ca2Bw62oTOHWH42v
 4knKF0JoyrwcPu5g+9oTCbo142kzPsweaYVEm90m9r2APr0C/bzyvPL5gKpvocVWL5e/
 6tMpeTHVVge3uNusTDxpWcxoHgP0nBT0OEsVuIp/CrPkgqepYBV3TMztvlob3v85IbY7
 b/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=yxA2cYvOw4or+4AZfWJZCSU9QyWVjXr9zaqNQ/48i2s=;
 b=uh5oQTAFLCrC77mjNDJI/VRjE2bGJHDaOShJ0RFUWtl2F6UCw4U9PSp8BeubHlFK7w
 qf1Dx6I1Og346cauGFVY71r/t3SyTUk+r8J+D976o0fb8ffio6UsoqnXCggCn+JkL9WD
 qEIPOcfuQdEQ4avIwpL72P6TQTGGLZ8/99Gr048c89TmGmQfU8mrY6MtfQoVHkynseys
 MSoYlbOk3++wP/9fDbOw5FNO5XVC6JNrJg2gOfWw6ItrNvhyjeHM7qCJBAWRX24d2R3S
 qHxkOLHvc2YMEod90/6rFgQOKlEQiCxiYxi276HyQBSCprkvZ0/whYFzjp4qkHLDXOZ/
 bodw==
X-Gm-Message-State: AOAM531rC1kJ9Xi/UGHgL3xx14dWIjNUSqsQhAoD1vuVSZPe9vkdAvo2
 2snyWvJG4QCWM/2MvlHoFRMuWRcQGB4=
X-Google-Smtp-Source: ABdhPJx644XoMFt3hlty2696xX3FxZmd66p9kDnVbuGf4x2YsF8E74EImbYhqgKOdzTd2jkXFJuzEGDoHCY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:6610:: with SMTP id
 a16mr9329536ilc.71.1629072744206; 
 Sun, 15 Aug 2021 17:12:24 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:13 +0000
In-Reply-To: <20210816001217.3063400-1-oupton@google.com>
Message-Id: <20210816001217.3063400-4-oupton@google.com>
Mime-Version: 1.0
References: <20210816001217.3063400-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 3/7] KVM: arm64: Allow userspace to configure a vCPU's
 virtual offset
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Allow userspace to access the guest's virtual counter-timer offset
through the ONE_REG interface. The value read or written is defined to
be an offset from the guest's physical counter-timer. Add some
documentation to clarify how a VMM should use this and the existing
CNTVCT_EL0.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virt/kvm/api.rst    | 10 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 arch/arm64/kvm/arch_timer.c       | 23 +++++++++++++++++++++++
 arch/arm64/kvm/guest.c            |  6 +++++-
 include/kvm/arm_arch_timer.h      |  1 +
 5 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index dae68e68ca23..adb04046a752 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2463,6 +2463,16 @@ arm64 system registers have the following id bit patterns::
      derived from the register encoding for CNTV_CVAL_EL0.  As this is
      API, it must remain this way.
 
+.. warning::
+
+     The value of KVM_REG_ARM_TIMER_OFFSET is defined as an offset from
+     the guest's view of the physical counter-timer.
+
+     Userspace should use either KVM_REG_ARM_TIMER_OFFSET or
+     KVM_REG_ARM_TIMER_CNT to pause and resume a guest's virtual
+     counter-timer. Mixed use of these registers could result in an
+     unpredictable guest counter value.
+
 arm64 firmware pseudo-registers have the following bit pattern::
 
   0x6030 0000 0014 <regno:16>
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..949a31bc10f0 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -255,6 +255,7 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
 #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
 #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
+#define KVM_REG_ARM_TIMER_OFFSET	ARM64_SYS_REG(3, 4, 14, 0, 3)
 
 /* KVM-as-firmware specific pseudo-registers */
 #define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index cf2f4a034dbe..9d9bac3ec40e 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -92,6 +92,18 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
 	}
 }
 
+static u64 timer_get_guest_offset(struct arch_timer_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt->vcpu;
+
+	switch (arch_timer_ctx_index(ctxt)) {
+	case TIMER_VTIMER:
+		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+	default:
+		return 0;
+	}
+}
+
 static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
@@ -852,6 +864,10 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 		timer = vcpu_vtimer(vcpu);
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
 		break;
+	case KVM_REG_ARM_TIMER_OFFSET:
+		timer = vcpu_vtimer(vcpu);
+		update_vtimer_cntvoff(vcpu, value);
+		break;
 	case KVM_REG_ARM_PTIMER_CTL:
 		timer = vcpu_ptimer(vcpu);
 		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
@@ -896,6 +912,9 @@ u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
 	case KVM_REG_ARM_TIMER_CVAL:
 		return kvm_arm_timer_read(vcpu,
 					  vcpu_vtimer(vcpu), TIMER_REG_CVAL);
+	case KVM_REG_ARM_TIMER_OFFSET:
+		return kvm_arm_timer_read(vcpu,
+					  vcpu_vtimer(vcpu), TIMER_REG_OFFSET);
 	case KVM_REG_ARM_PTIMER_CTL:
 		return kvm_arm_timer_read(vcpu,
 					  vcpu_ptimer(vcpu), TIMER_REG_CTL);
@@ -933,6 +952,10 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 		val = kvm_phys_timer_read() - timer_get_offset(timer);
 		break;
 
+	case TIMER_REG_OFFSET:
+		val = timer_get_guest_offset(timer);
+		break;
+
 	default:
 		BUG();
 	}
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1dfb83578277..17fc06e2b422 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -591,7 +591,7 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
  * ARM64 versions of the TIMER registers, always available on arm64
  */
 
-#define NUM_TIMER_REGS 3
+#define NUM_TIMER_REGS 4
 
 static bool is_timer_reg(u64 index)
 {
@@ -599,6 +599,7 @@ static bool is_timer_reg(u64 index)
 	case KVM_REG_ARM_TIMER_CTL:
 	case KVM_REG_ARM_TIMER_CNT:
 	case KVM_REG_ARM_TIMER_CVAL:
+	case KVM_REG_ARM_TIMER_OFFSET:
 		return true;
 	}
 	return false;
@@ -614,6 +615,9 @@ static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	uindices++;
 	if (put_user(KVM_REG_ARM_TIMER_CVAL, uindices))
 		return -EFAULT;
+	uindices++;
+	if (put_user(KVM_REG_ARM_TIMER_OFFSET, uindices))
+		return -EFAULT;
 
 	return 0;
 }
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 9d65d4a29f81..615f9314f6a5 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -21,6 +21,7 @@ enum kvm_arch_timer_regs {
 	TIMER_REG_CVAL,
 	TIMER_REG_TVAL,
 	TIMER_REG_CTL,
+	TIMER_REG_OFFSET,
 };
 
 struct arch_timer_context {
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
