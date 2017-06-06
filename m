From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/3] arm64: KVM: Allow unaligned accesses at EL2
Date: Tue,  6 Jun 2017 19:08:34 +0100
Message-ID: <20170606180835.14421-3-marc.zyngier@arm.com>
References: <20170606180835.14421-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A587C40CD1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 14:04:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Ho+w32wmpq9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 14:04:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE50E40C54
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 14:04:45 -0400 (EDT)
In-Reply-To: <20170606180835.14421-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We currently have the SCTLR_EL2.A bit set, trapping unaligned accesses
at EL2, but we're not really prepared to deal with it. So far, this
has been unnoticed, until GCC 7 started emitting those (in particular
64bit writes on a 32bit boundary).

Since the rest of the kernel is pretty happy about that, let's follow
its example and set SCTLR_EL2.A to zero. Modern CPUs don't really
care.

Cc: stable@vger.kernel.org
Reported-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp-init.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 4072d408a4b4..3f9615582377 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -108,9 +108,10 @@ __do_hyp_init:
 
 	/*
 	 * Preserve all the RES1 bits while setting the default flags,
-	 * as well as the EE bit on BE.
+	 * as well as the EE bit on BE. Drop the A flag since the compiler
+	 * is allowed to generate unaligned accesses.
 	 */
-	ldr	x4, =(SCTLR_EL2_RES1 | SCTLR_ELx_FLAGS)
+	ldr	x4, =(SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
 CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
 	msr	sctlr_el2, x4
 	isb
-- 
2.11.0
