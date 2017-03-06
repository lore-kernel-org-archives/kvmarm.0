From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 10/25] ARM: Update cpu_v7_reset documentation
Date: Mon,  6 Mar 2017 14:24:43 +0000
Message-ID: <20170306142458.8875-11-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D708640AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 75+ZRiCAMd6o for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:25:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA20E40430
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:04 -0500 (EST)
In-Reply-To: <20170306142458.8875-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, james.morse@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

cpu_v7_reset() now takes a second parameter indicating whether
we should reboot in HYP or not. Update the documentation to
reflect this.

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
