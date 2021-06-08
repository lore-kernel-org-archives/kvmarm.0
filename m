Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA7DC48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:21:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67EAB611BD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:21:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67EAB611BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BDEE4086C;
	Wed,  9 Jun 2021 06:21:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MZpD1CM89xKF; Wed,  9 Jun 2021 06:21:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1AD24A19E;
	Wed,  9 Jun 2021 06:21:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B999406AD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:48:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DqqIcFHsHqML for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 17:48:04 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89E2740291
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:48:04 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 q8-20020ad45ca80000b02902329fd23199so4425584qvh.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 14:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Ca/qZaiknXj3Iq9ZLm3iYeH+fivlx7sz5NKgsuoyOb4=;
 b=FucUvvJFCa05/fx+2iKbRyVJpDUoSdRufaojOSwRTffpsdVFvbdf/J9dXzxOAmTCGK
 m0Z3BztkAnyYMsLiTRVsqHq1OXRbF6kIZkTtKPpx0QwTYLaF+dswbCCEq+ZWNjJmQ+m0
 uuI4gku9wm37sKM0u7PbfqYSD4ol8UUT2aRAA4uMCbaM41+UXNi8wmOZvO42vej34B6G
 Z1N1DHhgMcBAjElxU0oU0lWQd7Isg8O1ff3iAQDBJ02sumAPfBUMYOpMXVjWfl1GWUJ1
 ZxEZ3e7RP+EBvHIHvVRd1m0jn113P0YM7qrkBwukO4eMSu/bqDqfpm+/NKlijZ+MWW63
 zYrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ca/qZaiknXj3Iq9ZLm3iYeH+fivlx7sz5NKgsuoyOb4=;
 b=YACxB/nznHwBntbfq0twDwCjGUH9dUsB34rRUIF9A+4K5DndDe1e6X3U1mrgCTBXJa
 qvtfQBzcuiHCcxFz6mIl3v7VZ0p7yPsDJCPx+jaK/5ijKeb3WbH77CAINAO/haJ/FVYP
 o+sggUNxvsPV2F744oDZb8ZV6ir0O3BsOHGIrNN3vUAvan3qBiXofVoekZTRg/I7c8CM
 kE7KajtRwiZKTfSmMag/Nrc/+ef0/qnlfISGfl+N96uYpR/lcEkzjHdcSU1ADYiaPhB8
 FzI2re48ObvJyvao3G9Q0BaQQ/W+aO8wawq37rRAZfbGUwH2vj7wOYsLLSE/pxnH6AUn
 hEQw==
X-Gm-Message-State: AOAM532G6IXfBShcz1hb1vv++RCbLnRdBbwM5ZfCLxDDP/xbuashrP4n
 nxe5o/P22wc0xTQkMvAC8row7Mnk7v8=
X-Google-Smtp-Source: ABdhPJyOt0TfQ9WWojPwzmuw0t6yU1SRclBJiOl4Nkj1pFOEutp+3uVpbmEDpDFTcOwrVm5OIBfDBOZQmlY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:ad4:4241:: with SMTP id
 l1mr2485084qvq.2.1623188883854; 
 Tue, 08 Jun 2021 14:48:03 -0700 (PDT)
Date: Tue,  8 Jun 2021 21:47:34 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-3-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 02/10] KVM: arm64: Implement initial support for
 KVM_CAP_SYSTEM_COUNTER_STATE
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Wed, 09 Jun 2021 06:21:47 -0400
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>
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

ARMv8 provides for a virtual counter-timer offset that is added to guest
views of the virtual counter-timer (CNTVOFF_EL2). To date, KVM has not
provided userspace with any perception of this, and instead affords a
value-based scheme of migrating the virtual counter-timer by directly
reading/writing the guest's CNTVCT_EL0. This is problematic because
counters continue to elapse while the register is being written, meaning
it is possible for drift to sneak in to the guest's time scale. This is
exacerbated by the fact that KVM will calculate an appropriate
CNTVOFF_EL2 every time the register is written, which will be broadcast
to all virtual CPUs. The only possible way to avoid causing guest time
to drift is to restore counter-timers by offset.

Implement initial support for KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
to migrate the value of CNTVOFF_EL2. These ioctls yield precise control
of the virtual counter-timers to userspace, allowing it to define its
own heuristics for managing vCPU offsets.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++++
 arch/arm64/include/uapi/asm/kvm.h | 10 ++++++++++
 arch/arm64/kvm/arch_timer.c       | 22 ++++++++++++++++++++++
 arch/arm64/kvm/arm.c              | 25 +++++++++++++++++++++++++
 4 files changed, 62 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..31107d5e61af 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -781,4 +781,9 @@ void __init kvm_hyp_reserve(void);
 static inline void kvm_hyp_reserve(void) { }
 #endif
 
+int kvm_arm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
+					  struct kvm_system_counter_state *state);
+int kvm_arm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
+					  struct kvm_system_counter_state *state);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 24223adae150..d3987089c524 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -184,6 +184,16 @@ struct kvm_vcpu_events {
 	__u32 reserved[12];
 };
 
+/* for KVM_{GET,SET}_SYSTEM_COUNTER_STATE */
+struct kvm_system_counter_state {
+	/* indicates what fields are valid in the structure */
+	__u32 flags;
+	__u32 pad;
+	/* guest counter-timer offset, relative to host cntpct_el0 */
+	__u64 cntvoff;
+	__u64 rsvd[7];
+};
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 74e0699661e9..955a7a183362 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1259,3 +1259,25 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	return -ENXIO;
 }
+
+int kvm_arm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
+					  struct kvm_system_counter_state *state)
+{
+	if (state->flags)
+		return -EINVAL;
+
+	state->cntvoff = timer_get_offset(vcpu_vtimer(vcpu));
+
+	return 0;
+}
+
+int kvm_arm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
+					  struct kvm_system_counter_state *state)
+{
+	if (state->flags)
+		return -EINVAL;
+
+	timer_set_offset(vcpu_vtimer(vcpu), state->cntvoff);
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1126eae27400..b78ffb4db9dd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -207,6 +207,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_SYSTEM_COUNTER_STATE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -1273,6 +1274,30 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_finalize(vcpu, what);
 	}
+	case KVM_GET_SYSTEM_COUNTER_STATE: {
+		struct kvm_system_counter_state state;
+
+		if (copy_from_user(&state, argp, sizeof(state)))
+			return -EFAULT;
+
+		r = kvm_arm_vcpu_get_system_counter_state(vcpu, &state);
+		if (r)
+			break;
+
+		if (copy_to_user(argp, &state, sizeof(state)))
+			return -EFAULT;
+
+		break;
+	}
+	case KVM_SET_SYSTEM_COUNTER_STATE: {
+		struct kvm_system_counter_state state;
+
+		if (copy_from_user(&state, argp, sizeof(state)))
+			return -EFAULT;
+
+		r = kvm_arm_vcpu_set_system_counter_state(vcpu, &state);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
