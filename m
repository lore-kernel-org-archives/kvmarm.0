From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH roundup 2/4] ARM: KVM: avoid "HYP init code too big" error
Date: Fri,  6 Mar 2015 15:34:40 +0100
Message-ID: <1425652482-31411-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1425652482-31411-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82FE447DCE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:29:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mZfrCiAllWbb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 09:29:03 -0500 (EST)
Received: from mail-we0-f182.google.com (mail-we0-f182.google.com
 [74.125.82.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C95047A40
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:29:01 -0500 (EST)
Received: by wesw55 with SMTP id w55so6468324wes.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Mar 2015 06:35:08 -0800 (PST)
In-Reply-To: <1425652482-31411-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, arnd@arndb.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Arnd Bergmann <arnd@arndb.de>

When building large kernels, the linker will emit lots of veneers
into the .hyp.idmap.text section, which causes it to grow beyond
one page, and that triggers the build error.

This moves the section into .rodata instead, which avoids the
veneers and is safe because the code is not executed directly
but remapped by the hypervisor into its own executable address
space.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[ardb: move the ALIGN() to .rodata as well, update log s/copied/remapped/]
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/vmlinux.lds.S | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index b31aa73e8076..2787eb8d3616 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -22,11 +22,15 @@
 	ALIGN_FUNCTION();						\
 	VMLINUX_SYMBOL(__idmap_text_start) = .;				\
 	*(.idmap.text)							\
-	VMLINUX_SYMBOL(__idmap_text_end) = .;				\
+	VMLINUX_SYMBOL(__idmap_text_end) = .;
+
+#define IDMAP_RODATA							\
+	.rodata : {							\
 	. = ALIGN(32);							\
 	VMLINUX_SYMBOL(__hyp_idmap_text_start) = .;			\
 	*(.hyp.idmap.text)						\
-	VMLINUX_SYMBOL(__hyp_idmap_text_end) = .;
+	VMLINUX_SYMBOL(__hyp_idmap_text_end) = .;			\
+	}
 
 #ifdef CONFIG_HOTPLUG_CPU
 #define ARM_CPU_DISCARD(x)
@@ -124,6 +128,7 @@ SECTIONS
 	. = ALIGN(1<<SECTION_SHIFT);
 #endif
 	RO_DATA(PAGE_SIZE)
+	IDMAP_RODATA
 
 	. = ALIGN(4);
 	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-- 
1.8.3.2
