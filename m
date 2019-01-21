From: James Morse <james.morse@arm.com>
Subject: [PATCH 4/4] arm64: hibernate: Clean the __hyp_text to PoC after resume
Date: Mon, 21 Jan 2019 17:04:04 +0000
Message-ID: <20190121170404.142966-5-james.morse@arm.com>
References: <20190121170404.142966-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C08F74A3CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:04:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cpS58-nDRAnU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jan 2019 12:04:24 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF3BE4A3C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:04:24 -0500 (EST)
In-Reply-To: <20190121170404.142966-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

During resume hibernate restores all physical memory. Any memory
that is accessed with the MMU disabled needs to be cleaned to the
PoC.

KVMs __hyp_text was previously ommited as it runs with the MMU
enabled, but now that the hyp-stub is located in this section,
we must clean __hyp_text too.

This ensures secondary CPUs that come online after hibernate
has finished resuming, and load KVM via the freshly written
hyp-stub see the correct instructions.

Signed-off-by: James Morse <james.morse@arm.com>
Cc: stable@vger.kernel.org
---
 arch/arm64/kernel/hibernate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 29cdc99688f3..9859e1178e6b 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -299,8 +299,10 @@ int swsusp_arch_suspend(void)
 		dcache_clean_range(__idmap_text_start, __idmap_text_end);
 
 		/* Clean kvm setup code to PoC? */
-		if (el2_reset_needed())
+		if (el2_reset_needed()) {
 			dcache_clean_range(__hyp_idmap_text_start, __hyp_idmap_text_end);
+			dcache_clean_range(__hyp_text_start, __hyp_text_end);
+		}
 
 		/* make the crash dump kernel image protected again */
 		crash_post_resume();
-- 
2.20.1
