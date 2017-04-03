From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 15/34] ARM: Update cpu_v7_reset documentation
Date: Mon,  3 Apr 2017 19:37:48 +0100
Message-ID: <20170403183807.1620-16-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3C0A40A7F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 58D9wGx4zIaU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:36:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6E6940C56
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:48 -0400 (EDT)
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
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
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

cpu_v7_reset() now takes a second parameter indicating whether
we should reboot in HYP or not. Update the documentation to
reflect this.

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mm/proc-v7.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 1846ca4255d0..01d64c0b2563 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -39,13 +39,14 @@ ENTRY(cpu_v7_proc_fin)
 ENDPROC(cpu_v7_proc_fin)
 
 /*
- *	cpu_v7_reset(loc)
+ *	cpu_v7_reset(loc, hyp)
  *
  *	Perform a soft reset of the system.  Put the CPU into the
  *	same state as it would be if it had been reset, and branch
  *	to what would be the reset vector.
  *
  *	- loc   - location to jump to for soft reset
+ *	- hyp   - indicate if restart occurs in HYP mode
  *
  *	This code must be executed using a flat identity mapping with
  *      caches disabled.
-- 
2.11.0
