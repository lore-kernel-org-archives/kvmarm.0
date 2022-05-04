Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372F4C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E32DF4B1FA;
	Tue,  3 May 2022 23:25:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3FV8rT+v6lit; Tue,  3 May 2022 23:25:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 590A94B224;
	Tue,  3 May 2022 23:25:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC4574B132
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W4R0X5LMsmGi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:25:06 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 700E84B1D2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:06 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 u9-20020a17090282c900b0015ea48078b7so140286plz.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KbWTo46raws8ZeP/cKKWDq3eaHKeTtYLUUn/hJ/Yq0Q=;
 b=X0r5vKhQHXSlovMskTb+/Y0UulLv1K8SHFQGmjeHu2rRz4j+Y4EU7elWUwcL/mFSlD
 TIZ65arGMC7ZW+q+umFrbkLGcNl11Jl6qxeqkaLW0Eb5+jx7QtITYVeM7XFxTXLAkHrL
 Qv5yQsD49+fe0dYL0bKWl9n9hJsb/HdG2ktw8mnRSANSteqtmqJoOd/DXGi5bpPZFYVc
 55ts2YsQ/+eD2AAArLxxomKJwcZc44PQwWHQwfXYGY/T5+866ryGX4yEmMhnuCKRGMnV
 xM8RfSiLsLQHYkd/8p3g69vSc7EeO+k3jRWEjQ9+4UaUVKSoDqIVzk4t6nWqbH71KfMi
 A3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KbWTo46raws8ZeP/cKKWDq3eaHKeTtYLUUn/hJ/Yq0Q=;
 b=qbXJQIkE/XArUUfeOv6BilUJ2Zf5jS2oEc23wbmENlESqeAbCOAPNcPiAVFeXMU5h3
 PpXq78pou3IQ46i0p4oeGRUDfM3ihwDyCEmWKYEli0D5I6siE4XzFG6ZbAWxhkvQp5ez
 vDFmzoAlx+MVLlS7y16MDz9Gd0wtiMcBFygYK3Bn95+1nQp2YJojF9nmlvfQPd5ESmTD
 rn4PkoiVhdyCRviVWfYNbWnMi0P/Su6oPQZGXkBcrA5F5v0GoycITUhzUQ1vx+wF+EzH
 OCvzqEq1FAONa15VX9AMz12Oa38oEXbc36wfwIMrbrOfT4toZ3mZLCDBFWgIRUIVpYoS
 1CxQ==
X-Gm-Message-State: AOAM532w8rPORAKR7UdkwCA+Gns8ZwK+jUL7MVPzSQQAGxYq0FSRlGQH
 uRZ415JT+9crC8ov9rQ14Cdmy7xwk8rMBdAxU3Y4pcu1FnZcKDm6ytmdBZiqNGzxORdMXy1JXDN
 8ofO5mUbanP2Dsl5OTDRMfnGbDgo1ni4HYpaOPQFzrK2+5mquteDYFpGZFOsFomhJLon1Cg==
X-Google-Smtp-Source: ABdhPJwzOh9Zro9DkXmenF5EvONcdPDxMSRHAdOuF37FYVEDY72O/4dxF2znD0589wCi9jfRMfTPbfDRpqk=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:a1e:b0:50d:bb0c:2e27 with SMTP id
 p30-20020a056a000a1e00b0050dbb0c2e27mr18910040pfh.49.1651634705422; Tue, 03
 May 2022 20:25:05 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:41 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-8-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 07/12] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
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

ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND" describes a PSCI call that allows
software to request that a system be placed in the deepest possible
low-power state. Effectively, software can use this to suspend itself to
RAM.

Unfortunately, there really is no good way to implement a system-wide
PSCI call in KVM. Any precondition checks done in the kernel will need
to be repeated by userspace since there is no good way to protect a
critical section that spans an exit to userspace. SYSTEM_RESET and
SYSTEM_OFF are equally plagued by this issue, although no users have
seemingly cared for the relatively long time these calls have been
supported.

The solution is to just make the whole implementation userspace's
problem. Introduce a new system event, KVM_SYSTEM_EVENT_SUSPEND, that
indicates to userspace a calling vCPU has invoked PSCI SYSTEM_SUSPEND.
Additionally, add a CAP to get buy-in from userspace for this new exit
type.

Only advertise the SYSTEM_SUSPEND PSCI call if userspace has opted in.
If a vCPU calls SYSTEM_SUSPEND, punt straight to userspace. Provide
explicit documentation of userspace's responsibilites for the exit and
point to the PSCI specification to describe the actual PSCI call.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst    | 39 +++++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              |  5 ++++
 arch/arm64/kvm/psci.c             | 29 +++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 77 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 46ca84600dca..d8d7859fc556 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6015,6 +6015,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
   #define KVM_SYSTEM_EVENT_WAKEUP         4
+  #define KVM_SYSTEM_EVENT_SUSPEND        5
 			__u32 type;
                         __u32 ndata;
                         __u64 data[16];
@@ -6042,6 +6043,34 @@ Valid values for 'type' are:
  - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
    KVM has recognized a wakeup event. Userspace may honor this event by
    marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
+ - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested a suspension of
+   the VM.
+
+For arm/arm64:
+^^^^^^^^^^^^^^
+
+   KVM_SYSTEM_EVENT_SUSPEND exits are enabled with the
+   KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest invokes the PSCI
+   SYSTEM_SUSPEND function, KVM will exit to userspace with this event
+   type.
+
+   It is the sole responsibility of userspace to implement the PSCI
+   SYSTEM_SUSPEND call according to ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
+   KVM does not change the vCPU's state before exiting to userspace, so
+   the call parameters are left in-place in the vCPU registers.
+
+   Userspace is _required_ to take action for such an exit. It must
+   either:
+
+    - Honor the guest request to suspend the VM. Userspace can request
+      in-kernel emulation of suspension by setting the calling vCPU's
+      state to KVM_MP_STATE_SUSPENDED. Userspace must configure the vCPU's
+      state according to the parameters passed to the PSCI function when
+      the calling vCPU is resumed. See ARM DEN0022D.b 5.19.1 "Intended use"
+      for details on the function parameters.
+
+    - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
+      "Caller responsibilities" for possible return values.
 
 If KVM_CAP_SYSTEM_EVENT_DATA is present, the 'data' field can contain
 architecture specific information for the system-level event.  Only
@@ -7767,6 +7796,16 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
 this capability will disable PMU virtualization for that VM.  Usermode
 should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 
+8.36 KVM_CAP_ARM_SYSTEM_SUSPEND
+-------------------------------
+
+:Capability: KVM_CAP_ARM_SYSTEM_SUSPEND
+:Architectures: arm64
+:Type: vm
+
+When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
+type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 46027b9b80ca..d9df81949f76 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -137,6 +137,8 @@ struct kvm_arch {
 	 */
 #define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		3
 #define KVM_ARCH_FLAG_EL1_32BIT				4
+	/* PSCI SYSTEM_SUSPEND enabled for the guest */
+#define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
 
 	unsigned long flags;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index abd32a84ed7a..f8a89ae52710 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -97,6 +97,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+		r = 0;
+		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -210,6 +214,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 2e6f060214a7..5de30e72ad40 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -195,6 +195,15 @@ static void kvm_psci_system_reset2(struct kvm_vcpu *vcpu)
 				 KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2);
 }
 
+static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+
+	memset(&run->system_event, 0, sizeof(vcpu->run->system_event));
+	run->system_event.type = KVM_SYSTEM_EVENT_SUSPEND;
+	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+}
+
 static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -300,6 +309,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
 	unsigned long val = PSCI_RET_NOT_SUPPORTED;
 	u32 psci_fn = smccc_get_function(vcpu);
+	struct kvm *kvm = vcpu->kvm;
 	u32 arg;
 	int ret = 1;
 
@@ -331,6 +341,11 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		case ARM_SMCCC_VERSION_FUNC_ID:
 			val = 0;
 			break;
+		case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+			if (test_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags))
+				val = 0;
+			break;
 		case PSCI_1_1_FN_SYSTEM_RESET2:
 		case PSCI_1_1_FN64_SYSTEM_RESET2:
 			if (minor >= 1)
@@ -338,6 +353,20 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			break;
 		}
 		break;
+	case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+		/*
+		 * Return directly to userspace without changing the vCPU's
+		 * registers. Userspace depends on reading the SMCCC parameters
+		 * to implement SYSTEM_SUSPEND.
+		 */
+		if (test_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags)) {
+			kvm_psci_system_suspend(vcpu);
+			return 0;
+		}
+		break;
 	case PSCI_1_1_FN_SYSTEM_RESET2:
 		kvm_psci_narrow_to_32bit(vcpu);
 		fallthrough;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7f72fb7b05f2..32c56384fd08 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -445,6 +445,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
 #define KVM_SYSTEM_EVENT_WAKEUP         4
+#define KVM_SYSTEM_EVENT_SUSPEND        5
 			__u32 type;
 			__u32 ndata;
 			union {
@@ -1154,6 +1155,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DISABLE_QUIRKS2 213
 /* #define KVM_CAP_VM_TSC_CONTROL 214 */
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
+#define KVM_CAP_ARM_SYSTEM_SUSPEND 216
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
