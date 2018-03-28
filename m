From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 71/85] arm64: KVM: Move vector offsetting from hyp-init.S to
 kvm_get_hyp_vector
Date: Wed, 28 Mar 2018 13:52:40 +0100
Message-ID: <20180328125254.31380-72-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D428D4A14C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:00:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VTpsBLs2pCz7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:59:30 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1BB4A0E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:49 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We currently provide the hyp-init code with a kernel VA, and expect
it to turn it into a HYP va by itself. As we're about to provide
the hypervisor with mappings that are not necessarily in the memory
range, let's move the kern_hyp_va macro to kvm_get_hyp_vector.

No functionnal change.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 3 ++-
 arch/arm64/kvm/hyp-init.S        | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a84e2dd14ebe..8cd37eac6292 100644
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
