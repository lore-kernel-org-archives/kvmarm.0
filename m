From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] KVM: arm64: Correct trace exception name after SError handling
Date: Sat,  8 Oct 2016 22:20:11 +0200
Message-ID: <20161008202011.30835-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82FC049B75
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Oct 2016 16:09:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kMBG3vOBQWSq for <kvmarm@lists.cs.columbia.edu>;
 Sat,  8 Oct 2016 16:09:50 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9C5549B74
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Oct 2016 16:09:49 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id k125so86924657wma.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 08 Oct 2016 13:19:44 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

After commit 9aecafc8 introduced ARM_EXCEPTION_EL1_SERROR we should
adjust the description of the exception type for trace events.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_arm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4b5c977..b942ce4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -207,7 +207,8 @@
 
 #define kvm_arm_exception_type	\
 	{0, "IRQ" }, 		\
-	{1, "TRAP" }
+	{1, "SError" }, 	\
+	{2, "TRAP" }
 
 #define ECN(x) { ESR_ELx_EC_##x, #x }
 
-- 
2.9.0
