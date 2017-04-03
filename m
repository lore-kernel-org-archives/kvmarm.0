From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 25/34] ARM: KVM: Gracefully handle hyp-stubs being restored
 from under our feet
Date: Mon,  3 Apr 2017 19:37:58 +0100
Message-ID: <20170403183807.1620-26-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00F6D40CA1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B2gpvuOwHCnC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:37:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE05640017
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:07 -0400 (EDT)
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

Should kvm_reboot() be invoked while guest is running, an IPI
wil be issued, forcing the guest to exit and HYP being reset to
the stubs. We will then try to reenter the guest, only to get
an error (HVC_STUB_ERR).

This patch allows this case to be gracefully handled by exiting
the run loop.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h | 2 +-
 arch/arm/kvm/handle_exit.c     | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 7ccb6f1aac5b..df113302e637 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -33,7 +33,7 @@
 #define ARM_EXCEPTION_IRQ	  5
 #define ARM_EXCEPTION_FIQ	  6
 #define ARM_EXCEPTION_HVC	  7
-
+#define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 /*
  * The rr_lo_hi macro swaps a pair of registers depending on
  * current endianness. It is used in conjunction with ldrd and strd
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 96af65a30d78..5fd7968cdae9 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -160,6 +160,14 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case ARM_EXCEPTION_DATA_ABORT:
 		kvm_inject_vabt(vcpu);
 		return 1;
+	case ARM_EXCEPTION_HYP_GONE:
+		/*
+		 * HYP has been reset to the hyp-stub. This happens
+		 * when a guest is pre-empted by kvm_reboot()'s
+		 * shutdown call.
+		 */
+		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		return 0;
 	default:
 		kvm_pr_unimpl("Unsupported exception type: %d",
 			      exception_index);
-- 
2.11.0
