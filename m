From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 04/12] Makefile: remove unneeded -s switch on compiling BIOS
 files
Date: Fri, 17 Jul 2015 17:02:10 +0100
Message-ID: <1437148938-5394-5-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DDAD58CDE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h+XYGEyaraBj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 11:50:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7802058CDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 11:50:23 -0400 (EDT)
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Stripping has no effect on object files, so having "-s -c" on the
command line makes no sense.
In fact clang complains about it and aborts with an error, so lets
just remove the unneeded "-s" switch here.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 151fa9d..46e4a9d 100644
--- a/Makefile
+++ b/Makefile
@@ -421,15 +421,15 @@ x86/bios.o: x86/bios/bios.bin x86/bios/bios-rom.h
 
 x86/bios/bios.bin.elf: x86/bios/entry.S x86/bios/e820.c x86/bios/int10.c x86/bios/int15.c x86/bios/rom.ld.S
 	$(E) "  CC       x86/bios/memcpy.o"
-	$(Q) $(CC) -include code16gcc.h $(CFLAGS) $(BIOS_CFLAGS) -c -s x86/bios/memcpy.c -o x86/bios/memcpy.o
+	$(Q) $(CC) -include code16gcc.h $(CFLAGS) $(BIOS_CFLAGS) -c x86/bios/memcpy.c -o x86/bios/memcpy.o
 	$(E) "  CC       x86/bios/e820.o"
-	$(Q) $(CC) -include code16gcc.h $(CFLAGS) $(BIOS_CFLAGS) -c -s x86/bios/e820.c -o x86/bios/e820.o
+	$(Q) $(CC) -include code16gcc.h $(CFLAGS) $(BIOS_CFLAGS) -c x86/bios/e820.c -o x86/bios/e820.o
 	$(E) "  CC       x86/bios/int10.o"
-	$(Q) $(CC) -include code16gcc.h $(CFLAGS) $(BIOS_CFLAGS) -c -s x86/bios/int10.c -o x86/bios/int10.o
+	$(Q) $(CC) -include code16gcc.h $(CFLAGS) $(BIOS_CFLAGS) -c x86/bios/int10.c -o x86/bios/int10.o
 	$(E) "  CC       x86/bios/int15.o"
-	$(Q) $(CC) -include code16gcc.h $(CFLAGS) $(BIOS_CFLAGS) -c -s x86/bios/int15.c -o x86/bios/int15.o
+	$(Q) $(CC) -include code16gcc.h $(CFLAGS) $(BIOS_CFLAGS) -c x86/bios/int15.c -o x86/bios/int15.o
 	$(E) "  CC       x86/bios/entry.o"
-	$(Q) $(CC) $(CFLAGS) $(BIOS_CFLAGS) -c -s x86/bios/entry.S -o x86/bios/entry.o
+	$(Q) $(CC) $(CFLAGS) $(BIOS_CFLAGS) -c x86/bios/entry.S -o x86/bios/entry.o
 	$(E) "  LD      " $@
 	$(Q) $(LD) -T x86/bios/rom.ld.S -o x86/bios/bios.bin.elf x86/bios/memcpy.o x86/bios/entry.o x86/bios/e820.o x86/bios/int10.o x86/bios/int15.o
 
-- 
2.3.5
