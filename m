Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26EEC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A576C4B1ED;
	Sat,  9 Apr 2022 14:46:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id py7iwAvPtp-f; Sat,  9 Apr 2022 14:46:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12C804B1E0;
	Sat,  9 Apr 2022 14:46:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE5C4B1BD
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lW0YTHl5aySG for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:08 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12EDE4B1A0
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:07 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 h13-20020a056e021d8d00b002c7fb1ec601so7637680ila.6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=W7ugrni+J+xiWdzPAW6VM2XE4N3GdZLKCX0i6JAB9sQ=;
 b=kKU2jeLI8P2KaeZTnbErjo4GevTXqCTWEhgmW7eVoIPG9sS/OPQLdNOP9M5nNN1Dit
 XhjdznEjeNEWfDSG5O3QkrOCDtS+3E2MVlipKodpwbQ9YOBEMqZ8fDaA4ShhZoIlK95d
 rC5Sjuqwy2cpKTuKMSVo9NB5iq9kbPFxoeJchQ/D6B8LD4y+lbzUtxY+2Qe612iWp0Ty
 lstfioAuuPrb6z25QENXbHg5V+THnaoNWJ4ZQhAlY3dAV+uKtyvEP5ZI3L9f3IRjT57F
 +Khl7qnALagslscEn/R88E13uZ9X6R/s2CRE2hoUn6qoUlCRwSnKVs53ZqenitSdQdFQ
 8I/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=W7ugrni+J+xiWdzPAW6VM2XE4N3GdZLKCX0i6JAB9sQ=;
 b=LWHJYyhJS2WDhZxAKVm83hB4Rvc62m4iUx4dmWgMDRUHH6JwBOBRgNqBXA1A5FTf6z
 kqKWDXC4WQzH0CePNmT+nfHrIRLqfKIBs6+bqpI3ZN7Iy2K9uLlvhy+4ny4ry8zaS4O2
 EC84JFJL7OYEQTRLhS+qLw7M46GpjBT2znltOVLhxtT5toVmB0p++FaoMhYT2eid+LVF
 BiTBYfiaGv1aZLCVZgvH1DEbqIJCuT4Rytd9rphTSSlvaES2Ctla/UTvU9hKO9AF2i3k
 VUtJqs34ZLcHot0eAq30vQ14n1Ez+95UDRu2hZZZBxtyE/WQnwHzJAdbwsdF4hrDuzVd
 enuw==
X-Gm-Message-State: AOAM533mq0b0d2Bqr3P0IDXnXV0IFn2uPDcAai0i0pS+m6DPWtkQ4m1X
 X/pEt3Q7K2//KStPZvYvw+J8wWmYCNf98TKbeA8V7KtGAi4N7/jvgpvCdpT6GiqNlf1plC1b6h9
 /wE4w626pbuyB5O09MLAPF67eB0rVuvIWxKZvnnYdAK11MQfl/o6mEe6/V/eZnOZlvImakg==
X-Google-Smtp-Source: ABdhPJzcTHmaObyDQreTtHAITXXVl9onBtmGryca5MsSDigcC9fynmViucJVqafQ1y1Kxy+aGDlcRvNbgIo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1583:b0:648:c289:2dab
 with SMTP id
 e3-20020a056602158300b00648c2892dabmr10426129iow.60.1649529966566; Sat, 09
 Apr 2022 11:46:06 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:43 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-8-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 07/13] KVM: arm64: Add support for userspace to suspend a
 vCPU
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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

Introduce a new MP state, KVM_MP_STATE_SUSPENDED, which indicates a vCPU
is in a suspended state. In the suspended state the vCPU will block
until a wakeup event (pending interrupt) is recognized.

Add a new system event type, KVM_SYSTEM_EVENT_WAKEUP, to indicate to
userspace that KVM has recognized one such wakeup event. It is the
responsibility of userspace to then make the vCPU runnable, or leave it
suspended until the next wakeup event.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst    | 37 +++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              | 49 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 4 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d13fa6600467..d104e34ad703 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1476,14 +1476,43 @@ Possible values are:
                                  [s390]
    KVM_MP_STATE_LOAD             the vcpu is in a special load/startup state
                                  [s390]
+   KVM_MP_STATE_SUSPENDED        the vcpu is in a suspend state and is waiting
+                                 for a wakeup event [arm64]
    ==========================    ===============================================
 
 On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm64/riscv:
-^^^^^^^^^^^^^^^^
+For arm64:
+^^^^^^^^^^
+
+If a vCPU is in the KVM_MP_STATE_SUSPENDED state, KVM will emulate the
+architectural execution of a WFI instruction.
+
+If a wakeup event is recognized, KVM will exit to userspace with a
+KVM_SYSTEM_EVENT exit, where the event type is KVM_SYSTEM_EVENT_WAKEUP. If
+userspace wants to honor the wakeup, it must set the vCPU's MP state to
+KVM_MP_STATE_RUNNABLE. If it does not, KVM will continue to await a wakeup
+event in subsequent calls to KVM_RUN.
+
+.. warning::
+
+     If userspace intends to keep the vCPU in a SUSPENDED state, it is
+     strongly recommended that userspace take action to suppress the
+     wakeup event (such as masking an interrupt). Otherwise, subsequent
+     calls to KVM_RUN will immediately exit with a KVM_SYSTEM_EVENT_WAKEUP
+     event and inadvertently waste CPU cycles.
+
+     Additionally, if userspace takes action to suppress a wakeup event,
+     it is strongly recommended that it also restores the vCPU to its
+     original state when the vCPU is made RUNNABLE again. For example,
+     if userspace masked a pending interrupt to suppress the wakeup,
+     the interrupt should be unmasked before returning control to the
+     guest.
+
+For riscv:
+^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -5985,6 +6014,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_SHUTDOWN       1
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
+  #define KVM_SYSTEM_EVENT_WAKEUP         4
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -6009,6 +6039,9 @@ Valid values for 'type' are:
    has requested a crash condition maintenance. Userspace can choose
    to ignore the request, or to gather VM memory core dump and/or
    reset/shutdown of the VM.
+ - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
+   KVM has recognized a wakeup event. Userspace may honor this event by
+   marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
 
 Valid flags are:
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f3f93d48e21a..46027b9b80ca 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,6 +46,7 @@
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
+#define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index efe54aba5cce..e9641b86d375 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -444,6 +444,18 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
 	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
 }
 
+static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
+	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
+static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_SUSPENDED;
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
@@ -464,6 +476,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	case KVM_MP_STATE_STOPPED:
 		kvm_arm_vcpu_power_off(vcpu);
 		break;
+	case KVM_MP_STATE_SUSPENDED:
+		kvm_arm_vcpu_suspend(vcpu);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -648,6 +663,37 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_arm_vcpu_suspended(vcpu))
+		return 1;
+
+	kvm_vcpu_wfi(vcpu);
+
+	/*
+	 * The suspend state is sticky; we do not leave it until userspace
+	 * explicitly marks the vCPU as runnable. Request that we suspend again
+	 * later.
+	 */
+	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
+
+	/*
+	 * Check to make sure the vCPU is actually runnable. If so, exit to
+	 * userspace informing it of the wakeup condition.
+	 */
+	if (kvm_arch_vcpu_runnable(vcpu)) {
+		kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_WAKEUP, 0);
+		return 0;
+	}
+
+	/*
+	 * Otherwise, we were unblocked to process a different event, such as a
+	 * pending signal. Return 1 and allow kvm_arch_vcpu_ioctl_run() to
+	 * process the event.
+	 */
+	return 1;
+}
+
 /**
  * check_vcpu_requests - check and handle pending vCPU requests
  * @vcpu:	the VCPU pointer
@@ -686,6 +732,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
+
+		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
+			return kvm_vcpu_suspend(vcpu);
 	}
 
 	return 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 91a6fe4e02c0..64e5f9d83a7a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -444,6 +444,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_WAKEUP         4
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -640,6 +641,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
 #define KVM_MP_STATE_AP_RESET_HOLD     9
+#define KVM_MP_STATE_SUSPENDED         10
 
 struct kvm_mp_state {
 	__u32 mp_state;
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
