Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C58C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 08:46:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B51A94B152;
	Wed,  4 May 2022 04:46:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R7Tw5lOMjTaN; Wed,  4 May 2022 04:46:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9BA64B105;
	Wed,  4 May 2022 04:46:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56FFD49F02
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 03:48:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fijXL19PoGoF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 03:48:13 -0400 (EDT)
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7445649F01
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 03:48:13 -0400 (EDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
 by ozlabs.ru (Postfix) with ESMTP id C4CC680511;
 Wed,  4 May 2022 03:48:09 -0400 (EDT)
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: kvm-ppc@vger.kernel.org
Subject: [PATCH kernel] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform
 dependent
Date: Wed,  4 May 2022 17:48:07 +1000
Message-Id: <20220504074807.3616813-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 04 May 2022 04:46:37 -0400
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Fabiano Rosas <farosas@linux.ibm.com>, Alexey Kardashevskiy <aik@ozlabs.ru>,
 x86@kernel.org, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, linux-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu,
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

When introduced, IRQFD resampling worked on POWER8 with XICS. However
KVM on POWER9 has never implemented it - the compatibility mode code
("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
XIVE mode does not handle INTx in KVM at all.

This moved the capability support advertising to platforms and stops
advertising it on XIVE, i.e. POWER9 and later.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---


Or I could move this one together with KVM_CAP_IRQFD. Thoughts?

---
 arch/arm64/kvm/arm.c       | 3 +++
 arch/mips/kvm/mips.c       | 3 +++
 arch/powerpc/kvm/powerpc.c | 6 ++++++
 arch/riscv/kvm/vm.c        | 3 +++
 arch/s390/kvm/kvm-s390.c   | 3 +++
 arch/x86/kvm/x86.c         | 3 +++
 virt/kvm/kvm_main.c        | 1 -
 7 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..092f0614bae3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -210,6 +210,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+#ifdef CONFIG_HAVE_KVM_IRQFD
+	case KVM_CAP_IRQFD_RESAMPLE:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index a25e0b73ee70..0f3de470a73e 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1071,6 +1071,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_IMMEDIATE_EXIT:
+#ifdef CONFIG_HAVE_KVM_IRQFD
+	case KVM_CAP_IRQFD_RESAMPLE:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 875c30c12db0..87698ffef3be 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -591,6 +591,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index c768f75279ef..b58579b386bb 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -63,6 +63,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
+#ifdef CONFIG_HAVE_KVM_IRQFD
+	case KVM_CAP_IRQFD_RESAMPLE:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 156d1c25a3c1..85e093fc8d13 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -564,6 +564,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_S390_DIAG318:
 	case KVM_CAP_S390_MEM_OP_EXTENSION:
+#ifdef CONFIG_HAVE_KVM_IRQFD
+	case KVM_CAP_IRQFD_RESAMPLE:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c0ca599a353..a0a7b769483d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4273,6 +4273,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
+#ifdef CONFIG_HAVE_KVM_IRQFD
+	case KVM_CAP_IRQFD_RESAMPLE:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e05af5ebea..885e72e668a5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4293,7 +4293,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	case KVM_CAP_IRQFD:
-	case KVM_CAP_IRQFD_RESAMPLE:
 #endif
 	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
 	case KVM_CAP_CHECK_EXTENSION_VM:
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
