Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85D4C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71A7A4C30C;
	Tue, 22 Feb 2022 23:19:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fPv+oE38yae9; Tue, 22 Feb 2022 23:19:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17DB14C416;
	Tue, 22 Feb 2022 23:19:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89C504C30C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vht4owTW+Ol6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:51 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 500974C3EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:51 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 x1-20020a25a001000000b0061c64ee0196so26582150ybh.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=oBFB/xilh37p90MAtedZ2XW8fyKmtZw3IlbClh+i4lM=;
 b=MojSaeqqFqDqfFiYP3GR7fpzY0v5x4pnqhX3VBYwF5yFq0D4eA8efuBrFc/dN5InRf
 mU629W/8VBRhfYCTuIUgoBniLHrNo6LXoPd9LXa+r/0CWi5SI+IPG0AD/9xtQUbKA9DM
 qnXOQDrMl7O87Zece/28SpHmBowt05GTXrp4VO7BDYeGr3lUAFUEU3DYxA5TejaZCyfR
 Pre2TDI4+Sw+qtMSJRhROfX+7i9oDVeoxmQrGlR/cc/eFQyAKufXTAKy9h5Y+JamOOeo
 Wx9Df6bQi7FbV9YCBq5ObX6ISYS+95ifzqS+vZPF8Xi+Er1W+/4Dnup0fF2lCat8M1ym
 A2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=oBFB/xilh37p90MAtedZ2XW8fyKmtZw3IlbClh+i4lM=;
 b=xs0e1NkPh/lobxvRe5FQP1q5QEDuSjd05xX0bdmpgFo/6QX67dBDT0S2FFVh7LI4vi
 t8wZLGGDI1mX2ot13giO7OkSGll04PruH9kFTuv0JPWjf2O7G/pS7T0Vms+gSntYynmT
 4MmWb+XDrXmCbdxJej21oCAv4yGK1ckUSgCHCJfWyuWgwuF7VfGn67+bhW8FEO6cgnkW
 VA7gxcxCNUzTa+BTDkUn7pO5pLbi+pAx/ak0hLQm2pnQXYFev1UMaSdbjQAPrjcUg867
 o8aGKhZlBZQj9LnJBrNXJV6Gsj+5kn6RnWrqB56mepiB4toEHfMcq1AX6KvXkpGYkfWk
 pO5w==
X-Gm-Message-State: AOAM5329biBy0GncFor9Mk9JtTHuZr35sHuyumUAdztlifvcaFHilOME
 m+3Z4B9u3Zvw1WYydZ2SGd3qigPyqgdULb27CMWPmSprAl0bTyTsL54FXi8EDcRF75bTvJxT/jl
 nztwL1yOCtq3ZYCIg8Qy2s4KD6fRQy3ODPbixhCOOZH2O3vB7j6JjRTIOTEiwKjEeyaYxIw==
X-Google-Smtp-Source: ABdhPJz9b+hfmnwYAU6AfGGVvol/lvhuJaB4WCMZd/mum6HGubo/Jo2QgD+znembhbgJPqgYTeAp2lLJ9BI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5b:347:0:b0:610:7b35:2806 with
 SMTP id
 q7-20020a5b0347000000b006107b352806mr26626791ybp.486.1645589990807; Tue, 22
 Feb 2022 20:19:50 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:38 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-14-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 13/19] KVM: arm64: Add support KVM_SYSTEM_EVENT_SUSPEND to
 PSCI SYSTEM_SUSPEND
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

Add a new system event type, KVM_SYSTEM_EVENT_SUSPEND, which indicates
to userspace that the guest has requested the VM be suspended. Userspace
can decide whether or not it wants to honor the guest's request by
changing the MP state of the vCPU. If it does not, userspace is
responsible for configuring the vCPU to return an error to the guest.
Document these expectations in the KVM API documentation.

To preserve ABI, this new exit requires explicit opt-in from userspace.
Add KVM_CAP_ARM_SYSTEM_SUSPEND which grants userspace the ability to
opt-in to these exits on a per-VM basis.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst    | 39 +++++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/arm.c              |  5 ++++
 arch/arm64/kvm/psci.c             |  5 ++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 54 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b4bdbc2dcc0..1e207bbc01f5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5930,6 +5930,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
   #define KVM_SYSTEM_EVENT_WAKEUP         4
+  #define KVM_SYSTEM_EVENT_SUSPENDED      5
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -5957,6 +5958,34 @@ Valid values for 'type' are:
  - KVM_SYSTEM_EVENT_WAKEUP -- the guest is in a suspended state and KVM
    has recognized a wakeup event. Userspace may honor this event by marking
    the exiting vCPU as runnable, or deny it and call KVM_RUN again.
+ - KVM_SYSTEM_EVENT_SUSPENDED -- the guest has requested a suspension of
+   the VM.
+
+For arm/arm64:
+^^^^^^^^^^^^^^
+
+   KVM_SYSTEM_EVENT_SUSPENDED exits are enabled with the
+   KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest successfully
+   invokes the PSCI SYSTEM_SUSPEND function, KVM will exit to userspace
+   with this event type.
+
+   The guest's x2 register contains the 'entry_address' where execution
+   should resume when the VM is brought out of suspend. The guest's x3
+   register contains the 'context_id' corresponding to the request. When
+   the guest resumes execution at 'entry_address', x0 should contain the
+   'context_id'. For more details on the SYSTEM_SUSPEND PSCI call, see
+   ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
+
+   Userspace is _required_ to take action for such an exit. It must
+   either:
+
+    - Honor the guest request to suspend the VM. Userspace must reset
+      the calling vCPU, then set PC to 'entry_address' and x0 to
+      'context_id'. Userspace may request in-kernel emulation of the
+      suspension by setting the vCPU's state to KVM_MP_STATE_SUSPENDED.
+
+    - Deny the guest request to suspend the VM. Userspace must set
+      registers x1-x3 to 0 and set x0 to PSCI_RET_INTERNAL_ERROR (-6).
 
 ::
 
@@ -7580,3 +7609,13 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_ARM_SYSTEM_SUSPEND
+-------------------------------
+
+:Capability: KVM_CAP_ARM_SYSTEM_SUSPEND
+:Architectures: arm64
+:Type: vm
+
+When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
+type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d32cab0c9752..e1c2ec18d1aa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -146,6 +146,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* System Suspend Event exits enabled for the VM */
+	bool system_suspend_exits;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d2b190f32651..ce3f14a77a49 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -101,6 +101,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+		r = 0;
+		kvm->arch.system_suspend_exits = true;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -209,6 +213,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 2bb8d047cde4..a7de84cec2e4 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -245,6 +245,11 @@ static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	if (kvm->arch.system_suspend_exits) {
+		kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_SUSPEND);
+		return 0;
+	}
+
 	__kvm_reset_vcpu(vcpu, &reset_state);
 	kvm_vcpu_wfi(vcpu);
 	return 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index babb16c2abe5..e5bb5f15c0eb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -445,6 +445,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
 #define KVM_SYSTEM_EVENT_WAKEUP         4
+#define KVM_SYSTEM_EVENT_SUSPEND        5
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -1136,6 +1137,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_ARM_SYSTEM_SUSPEND 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
