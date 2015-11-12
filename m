From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ARM64: use linux/types.h in kvm.h
Date: Thu, 12 Nov 2015 15:41:08 +0100
Message-ID: <9679324.UdV9GV0mFA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C08484155B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2015 09:41:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NRYKm27IaD1S for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Nov 2015 09:41:02 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78640411AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2015 09:41:02 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We should always use linux/types.h instead of asm/types.h for
consistency, and Kbuild actually warns about it:

./usr/include/asm/kvm.h:35: include of <linux/types.h> is preferred over <asm/types.h>

This patch does as Kbuild asks us.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Found on ARM64 allmodconfig

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 0cd7b5947dfc..2d4ca4bb0dd3 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -32,7 +32,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/psci.h>
-#include <asm/types.h>
+#include <linux/types.h>
 #include <asm/ptrace.h>
 
 #define __KVM_HAVE_GUEST_DEBUG
