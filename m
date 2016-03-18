From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: KVM: Turn kvm_ksym_ref into a NOP on VHE
Date: Fri, 18 Mar 2016 17:25:59 +0000
Message-ID: <1458321959-11728-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66CBD49B1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2016 13:25:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OIz6NUalaFfh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2016 13:25:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B9CE41390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2016 13:25:42 -0400 (EDT)
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When running with VHE, there is no need to translate kernel pointers
to the EL2 memory space, since we're already there (and we have a much
saner memory map to start with).

Unfortunately, kvm_ksym_ref is getting in the way, and the first
call into the "hypervisor" section is going to end up in fireworks,
since we're now branching into nowhereland. Meh.

A potential solution is to test if VHE is engaged or not, and only
perform the translation in the negative case. With this in place,
VHE is able to run again.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 226f49d..282f907 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -26,7 +26,13 @@
 #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
 #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
 
-#define kvm_ksym_ref(sym)		phys_to_virt((u64)&sym - kimage_voffset)
+#define kvm_ksym_ref(sym)						\
+	({								\
+		void *val = sym;					\
+		if (!is_kernel_in_hyp_mode())				\
+			val = phys_to_virt((u64)&sym - kimage_voffset);	\
+		val;							\
+	 })
 
 #ifndef __ASSEMBLY__
 struct kvm;
-- 
2.1.4
