From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 01/13] ARM: KVM: Fix tracepoint generation after move to
 virt/kvm/arm/
Date: Thu, 18 May 2017 11:47:10 +0200
Message-ID: <20170518094722.9926-2-cdall@linaro.org>
References: <20170518094722.9926-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D0D240BC5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V40uqervnxqU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 May 2017 05:44:07 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3A5740430
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:07 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id 70so40075984wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 02:47:38 -0700 (PDT)
In-Reply-To: <20170518094722.9926-1-cdall@linaro.org>
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

Moving most of the shared code to virt/kvm/arm had for consequence
that KVM/ARM doesn't build anymore, because the code that used to
define the tracepoints is now somewhere else.

Fix this by defining CREATE_TRACE_POINTS in coproc.c, and clean-up
trace.h as well.

Fixes: 35d2d5d490e2 ("KVM: arm/arm64: Move shared files to virt/kvm/arm")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kvm/coproc.c | 1 +
 arch/arm/kvm/trace.h  | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 2c14b69..ac8d36d 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -32,6 +32,7 @@
 #include <asm/vfp.h>
 #include "../vfp/vfpinstr.h"
 
+#define CREATE_TRACE_POINTS
 #include "trace.h"
 #include "coproc.h"
 
diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
index fc09437..b0d1064 100644
--- a/arch/arm/kvm/trace.h
+++ b/arch/arm/kvm/trace.h
@@ -1,5 +1,5 @@
-#if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_KVM_H
+#if !defined(_TRACE_ARM_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ARM_KVM_H
 
 #include <linux/tracepoint.h>
 
@@ -74,10 +74,10 @@ TRACE_EVENT(kvm_hvc,
 		  __entry->vcpu_pc, __entry->r0, __entry->imm)
 );
 
-#endif /* _TRACE_KVM_H */
+#endif /* _TRACE_ARM_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH arch/arm/kvm
+#define TRACE_INCLUDE_PATH .
 #undef TRACE_INCLUDE_FILE
 #define TRACE_INCLUDE_FILE trace
 
-- 
2.9.0
