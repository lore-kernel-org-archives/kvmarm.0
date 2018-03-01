From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 16/23] arm64: KVM: Move vector offsetting from hyp-init.S
 to kvm_get_hyp_vector
Date: Thu,  1 Mar 2018 15:55:31 +0000
Message-ID: <20180301155538.26860-17-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9568649E56
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:51:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aYe2jEGuqgEY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 10:51:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E55D649F64
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:19 -0500 (EST)
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We currently provide the hyp-init code with a kernel VA, and expect
it to turn it into a HYP va by itself. As we're about to provide
the hypervisor with mappings that are not necessarily in the memory
range, let's move the kern_hyp_va macro to kvm_get_hyp_vector.

No functionnal change.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 3 ++-
 arch/arm64/kvm/hyp-init.S        | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a5e0fc900de8..bfb81e73da06 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -374,6 +374,7 @@ static inline void *kvm_get_hyp_vector(void)
 			vect = lm_alias(vect);
 	}
 
+	vect = kern_hyp_va(vect);
 	return vect;
 }
 
@@ -387,7 +388,7 @@ static inline int kvm_map_vectors(void)
 #else
 static inline void *kvm_get_hyp_vector(void)
 {
-	return kvm_ksym_ref(__kvm_hyp_vector);
+	return kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
 }
 
 static inline int kvm_map_vectors(void)
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 5aa9ccf6db99..6fd91b31a131 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -117,7 +117,6 @@ CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
 	/* Set the stack and new vectors */
 	kern_hyp_va	x1
 	mov	sp, x1
-	kern_hyp_va	x2
 	msr	vbar_el2, x2
 
 	/* copy tpidr_el1 into tpidr_el2 for use by HYP */
-- 
2.14.2
