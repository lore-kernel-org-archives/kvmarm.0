From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 60/79] ARM: KVM: Gracefully handle hyp-stubs being restored
 from under our feet
Date: Sun, 23 Apr 2017 19:09:10 +0200
Message-ID: <20170423170929.27334-61-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 518A749CED
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gcua-07vATOV for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:53 -0400 (EDT)
Received: from mail-wr0-f174.google.com (mail-wr0-f174.google.com
 [209.85.128.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54A9449D47
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:49 -0400 (EDT)
Received: by mail-wr0-f174.google.com with SMTP id w50so55837511wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:35 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Should kvm_reboot() be invoked while guest is running, an IPI
wil be issued, forcing the guest to exit and HYP being reset to
the stubs. We will then try to reenter the guest, only to get
an error (HVC_STUB_ERR).

This patch allows this case to be gracefully handled by exiting
the run loop.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h | 2 +-
 arch/arm/kvm/handle_exit.c     | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index eae11b3..14d68a4 100644
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
index 96af65a..5fd7968 100644
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
2.9.0
