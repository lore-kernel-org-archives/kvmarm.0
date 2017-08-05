From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 14/15] arm-soc: shmobile: replace open coded VA->PA calculation
Date: Sat,  5 Aug 2017 21:52:21 +0100
Message-ID: <20170805205222.19868-15-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1818849C27
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vgtw6vMYMmrh for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:32 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2891D49C54
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:32 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id m85so42574147wma.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:56 -0700 (PDT)
In-Reply-To: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, linux@armlinux.org.uk, linux-omap@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, krzk@kernel.org, jason@lakedaemon.net, arm@kernel.org, andrew@lunn.ch, gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com, tony@atomide.com, baohua@kernel.org, horms@verge.net.au, magnus.damm@gmail.com, vireshk@kernel.org, shiraz.linux.kernel@gmail.com, patrice.chotard@st.com, nico@linaro.org, dave.martin@arm.com, marc.zyngier@arm.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This replaces a couple of open coded calculations to obtain the
physical address of a far symbol with calls to the new adr_l etc
macros.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/mach-shmobile/headsmp.S | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-shmobile/headsmp.S b/arch/arm/mach-shmobile/headsmp.S
index 32e0bf6e3ccb..f5e0d7c93cda 100644
--- a/arch/arm/mach-shmobile/headsmp.S
+++ b/arch/arm/mach-shmobile/headsmp.S
@@ -46,11 +46,10 @@ ENTRY(shmobile_smp_boot)
 	and	r0, r1, #0xffffff		@ MPIDR_HWID_BITMASK
 						@ r0 = cpu_logical_map() value
 	mov	r1, #0				@ r1 = CPU index
-	adr	r2, 1f
-	ldmia	r2, {r5, r6, r7}
-	add	r5, r5, r2			@ array of per-cpu mpidr values
-	add	r6, r6, r2			@ array of per-cpu functions
-	add	r7, r7, r2			@ array of per-cpu arguments
+
+	adr_l	r5, shmobile_smp_mpidr		@ array of per-cpu mpidr values
+	adr_l	r6, shmobile_smp_fn		@ array of per-cpu functions
+	adr_l	r7, shmobile_smp_arg		@ array of per-cpu arguments
 
 shmobile_smp_boot_find_mpidr:
 	ldr	r8, [r5, r1, lsl #2]
@@ -78,11 +77,6 @@ ENTRY(shmobile_smp_sleep)
 	b	shmobile_smp_boot
 ENDPROC(shmobile_smp_sleep)
 
-	.align	2
-1:	.long	shmobile_smp_mpidr - .
-	.long	shmobile_smp_fn - 1b
-	.long	shmobile_smp_arg - 1b
-
 	.bss
 	.globl	shmobile_smp_mpidr
 shmobile_smp_mpidr:
-- 
2.11.0
