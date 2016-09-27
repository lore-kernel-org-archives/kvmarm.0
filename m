From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 29/50] arm: KVM: Allow an exit code to be tagged with a Virtual
 Abort
Date: Tue, 27 Sep 2016 20:05:37 +0200
Message-ID: <20160927180558.14699-30-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3D4449B21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mmjp4--IxGh5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:54 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E049449B75
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:51 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id b130so27071147wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:15 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

An asynchronous abort can also be triggered whilst running at EL2.
But instead of making that a new error code, we need to communicate
it to the rest of KVM together with the exit reason.
So let's hijack a single bit that allows the exception code to be
tagged with a "pending Abort" information.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 58faff5..05e47fa 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -21,6 +21,10 @@
 
 #include <asm/virt.h>
 
+#define ARM_EXIT_WITH_ABORT_BIT  31
+#define ARM_EXCEPTION_CODE(x)	  ((x) & ~(1U << ARM_EXIT_WITH_ABORT_BIT))
+#define ARM_ABORT_PENDING(x)	  !!((x) & (1U << ARM_EXIT_WITH_ABORT_BIT))
+
 #define ARM_EXCEPTION_RESET	  0
 #define ARM_EXCEPTION_UNDEFINED   1
 #define ARM_EXCEPTION_SOFTWARE    2
-- 
2.9.0
