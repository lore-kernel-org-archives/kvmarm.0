From: James Morse <james.morse@arm.com>
Subject: [PATCH 2/4] arm64: kprobe: Always blacklist the KVM world-switch code
Date: Mon, 21 Jan 2019 17:04:02 +0000
Message-ID: <20190121170404.142966-3-james.morse@arm.com>
References: <20190121170404.142966-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2C054A3C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:04:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9lDYcQf1EIdd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jan 2019 12:04:22 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7774A3D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:04:19 -0500 (EST)
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

On systems with VHE the kernel and KVM's world-switch code run at the
same exception level. Code that is only used on a VHE system does not
need to be annotated as __hyp_text as it can reside anywhere in the
 kernel text.

__hyp_text was also used to prevent kprobes from patching breakpoint
instructions into this region, as this code runs at a different
exception level. While this is no longer true with VHE, KVM still
switches VBAR_EL1, meaning a kprobe's breakpoint executed in the
world-switch code will cause a hyp-panic.

Move the __hyp_text check in the kprobes blacklist so it applies on
VHE systems too, to cover the common code and guest enter/exit
assembly.

Signed-off-by: James Morse <james.morse@arm.com>
Fixes: 888b3c8720e0 ("arm64: Treat all entry code as non-kprobe-able")
---
 arch/arm64/kernel/probes/kprobes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 2a5b338b2542..f17afb99890c 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -478,13 +478,13 @@ bool arch_within_kprobe_blacklist(unsigned long addr)
 	    addr < (unsigned long)__entry_text_end) ||
 	    (addr >= (unsigned long)__idmap_text_start &&
 	    addr < (unsigned long)__idmap_text_end) ||
+	    (addr >= (unsigned long)__hyp_text_start &&
+	    addr < (unsigned long)__hyp_text_end) ||
 	    !!search_exception_tables(addr))
 		return true;
 
 	if (!is_kernel_in_hyp_mode()) {
-		if ((addr >= (unsigned long)__hyp_text_start &&
-		    addr < (unsigned long)__hyp_text_end) ||
-		    (addr >= (unsigned long)__hyp_idmap_text_start &&
+		if ((addr >= (unsigned long)__hyp_idmap_text_start &&
 		    addr < (unsigned long)__hyp_idmap_text_end))
 			return true;
 	}
-- 
2.20.1
