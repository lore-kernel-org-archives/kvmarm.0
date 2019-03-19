From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 05/27] KVM: arm64: Add missing #includes to kvm_host.h
Date: Tue, 19 Mar 2019 17:51:56 +0000
Message-ID: <1553017938-710-6-git-send-email-Dave.Martin@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9A304A475
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tN2OiZ4wmXbm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 13:53:18 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8392E4A492
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:16 -0400 (EDT)
In-Reply-To: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

kvm_host.h uses some declarations from other headers that are
currently included by accident, without an explicit #include.

This patch adds a few #includes that are clearly missing.  Although
the header builds without them today, this should help to avoid
future surprises.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>

---

Changes since v5:

 * [Mark Rutland] Add additional missing #includes <linux/jump_label.h>,
   <linux/percpu.h>, <asm/barrier.h>, while we're about it.

   Commit message reworded to match.
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a01fe087..6d10100 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -22,9 +22,13 @@
 #ifndef __ARM64_KVM_HOST_H__
 #define __ARM64_KVM_HOST_H__
 
+#include <linux/bitmap.h>
 #include <linux/types.h>
+#include <linux/jump_label.h>
 #include <linux/kvm_types.h>
+#include <linux/percpu.h>
 #include <asm/arch_gicv3.h>
+#include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/daifflags.h>
 #include <asm/fpsimd.h>
-- 
2.1.4
