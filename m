From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 40/79] arm64: hyp-stub: Update documentation in asm/virt.h
Date: Sun, 23 Apr 2017 19:08:50 +0200
Message-ID: <20170423170929.27334-41-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13E7649CD3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rX+HM99Wfats for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:29 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AEB349C5D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:27 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id m123so50338773wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:14 -0700 (PDT)
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

Comments in asm/virt.h are slightly out of date, so let's align
them with the new behaviour of the code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/virt.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 1466d14..1569c3a 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -19,9 +19,14 @@
 #define __ASM__VIRT_H
 
 /*
- * The arm64 hcall implementation uses x0 to specify the hcall type. A value
- * less than 0xfff indicates a special hcall, such as get/set vector.
- * Any other value is used as a pointer to the function to call.
+ * The arm64 hcall implementation uses x0 to specify the hcall
+ * number. A value less than HVC_STUB_HCALL_NR indicates a special
+ * hcall, such as set vector. Any other value is handled in a
+ * hypervisor specific way.
+ *
+ * The hypercall is allowed to clobber any of the caller-saved
+ * registers (x0-x18), so it is advisable to use it through the
+ * indirection of a function call (as implemented in hyp-stub.S).
  */
 
 /* HVC_GET_VECTORS - Return the value of the vbar_el2 register. */
-- 
2.9.0
