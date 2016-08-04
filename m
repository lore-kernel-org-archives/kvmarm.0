From: Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH 1/4] arm64: insn: Do not disable irqs during patching
Date: Thu,  4 Aug 2016 11:15:14 +0200
Message-ID: <1470302117-32296-2-git-send-email-mbrugger@suse.com>
References: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com
Cc: suzuki.poulose@arm.com, james.morse@arm.com, david.daney@cavium.com, rrichter@cavium.com, agraf@suse.de, mbrugger@suse.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com, dave.long@linaro.org, ard.biesheuvel@linaro.org, zlim.lnx@gmail.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Robert Richter <rrichter@cavium.com>

__aarch64_insn_write() is always called with interrupts enabled. Thus,
there is no need to use an irqsave variant for the spin lock.

This change should also address the fix of:

commit abffa6f3b157 ("arm64: convert patch_lock to raw lock")

We need to enable interrupts to allow cpu sync for code patching
using smp_call_function*().

Signed-off-by: Robert Richter <rrichter@cavium.com>
Signed-off-by: Matthias Brugger <mbrugger@suse.com>
---
 arch/arm64/kernel/insn.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 63f9432..138bd8a 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -86,7 +86,7 @@ bool aarch64_insn_is_branch_imm(u32 insn)
 		aarch64_insn_is_bcond(insn));
 }
 
-static DEFINE_RAW_SPINLOCK(patch_lock);
+static DEFINE_SPINLOCK(patch_lock);
 
 static void __kprobes *patch_map(void *addr, int fixmap)
 {
@@ -129,16 +129,15 @@ int __kprobes aarch64_insn_read(void *addr, u32 *insnp)
 static int __kprobes __aarch64_insn_write(void *addr, u32 insn)
 {
 	void *waddr = addr;
-	unsigned long flags = 0;
 	int ret;
 
-	raw_spin_lock_irqsave(&patch_lock, flags);
+	spin_lock(&patch_lock);
 	waddr = patch_map(addr, FIX_TEXT_POKE0);
 
 	ret = probe_kernel_write(waddr, &insn, AARCH64_INSN_SIZE);
 
 	patch_unmap(FIX_TEXT_POKE0);
-	raw_spin_unlock_irqrestore(&patch_lock, flags);
+	spin_unlock(&patch_lock);
 
 	return ret;
 }
-- 
2.6.6
