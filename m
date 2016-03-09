From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 46/95] arm64: KVM: VHE: Add fpsimd enabling on guest access
Date: Wed,  9 Mar 2016 07:30:40 +0000
Message-ID: <1457508689-19672-47-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B772149B54
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T1ECLK2SK+4C for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:33:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 543E848531
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:55 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Despite the fact that a VHE enabled kernel runs at EL2, it uses
CPACR_EL1 to trap FPSIMD access. Add the required alternative
code to re-enable guest FPSIMD access when it has trapped to
EL2.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/entry.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index fd0fbe9..ce9e5e5 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -130,9 +130,15 @@ ENDPROC(__guest_exit)
 ENTRY(__fpsimd_guest_restore)
 	stp	x4, lr, [sp, #-16]!
 
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	mrs	x2, cptr_el2
 	bic	x2, x2, #CPTR_EL2_TFP
 	msr	cptr_el2, x2
+alternative_else
+	mrs	x2, cpacr_el1
+	orr	x2, x2, #CPACR_EL1_FPEN
+	msr	cpacr_el1, x2
+alternative_endif
 	isb
 
 	mrs	x3, tpidr_el2
-- 
2.1.4
