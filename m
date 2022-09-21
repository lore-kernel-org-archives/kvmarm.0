Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684D1C6FA82
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 04:49:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B31544B7F0;
	Wed, 21 Sep 2022 00:49:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 11KBnPl6APY5; Wed, 21 Sep 2022 00:49:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 110014B782;
	Wed, 21 Sep 2022 00:49:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C6F54B75E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 00:49:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hQJ05DFR2cO7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 00:49:31 -0400 (EDT)
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 232FF4B282
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 00:49:31 -0400 (EDT)
Received: from ole.1.ozlabs.ru (localhost [IPv6:::1])
 by ozlabs.ru (Postfix) with ESMTP id 45AAB82EFA;
 Wed, 21 Sep 2022 00:49:27 -0400 (EDT)
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: kvm@vger.kernel.org
Subject: [PATCH kernel v3] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
Date: Wed, 21 Sep 2022 14:49:25 +1000
Message-Id: <20220921044925.101802-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Marc Zyngier <maz@kernel.org>,
 kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

When introduced, IRQFD resampling worked on POWER8 with XICS. However
KVM on POWER9 has never implemented it - the compatibility mode code
("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
XIVE mode does not handle INTx in KVM at all.

This moved the capability support advertising to platforms and stops
advertising it on XIVE, i.e. POWER9 and later.

This stops advertising the capability on MIPS and RISC-V as these
do not select HAVE_KVM_IRQFD and do not implement IRQFD resampling
anyway.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
---
Changes:
v3:
* removed all ifdeferry
* removed the capability for MIPS and RISCV
* adjusted the commit log about MIPS and RISCV

v2:
* removed ifdef for ARM64.
---
 arch/arm64/kvm/arm.c       | 1 +
 arch/powerpc/kvm/powerpc.c | 6 ++++++
 arch/s390/kvm/kvm-s390.c   | 1 +
 arch/x86/kvm/x86.c         | 1 +
 virt/kvm/kvm_main.c        | 1 -
 5 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2ff0ef62abad..d2daa4d375b5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_IRQFD_RESAMPLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index fb1490761c87..908ce8bd91c9 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 #endif
 
+#ifdef CONFIG_HAVE_KVM_IRQFD
+	case KVM_CAP_IRQFD_RESAMPLE:
+		r = !xive_enabled();
+		break;
+#endif
+
 	case KVM_CAP_PPC_ALLOC_HTAB:
 		r = hv_enabled;
 		break;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index edfd4bbd0cba..7521adadb81b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -577,6 +577,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_S390_DIAG318:
 	case KVM_CAP_S390_MEM_OP_EXTENSION:
+	case KVM_CAP_IRQFD_RESAMPLE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..2d6c5a8fdf14 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4395,6 +4395,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+	case KVM_CAP_IRQFD_RESAMPLE:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..05cf94013f02 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4447,7 +4447,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	case KVM_CAP_IRQFD:
-	case KVM_CAP_IRQFD_RESAMPLE:
 #endif
 	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
 	case KVM_CAP_CHECK_EXTENSION_VM:
-- 
2.37.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
