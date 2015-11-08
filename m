From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] kvmtool: Makefile: remove LDFLAGS from guest_init linking
Date: Sun,  8 Nov 2015 17:35:19 +0000
Message-ID: <1447004119-31873-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, Riku Voipio <riku.voipio@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Looking back at the HEAD from a few commits ago, it's obvious that
using the LDFLAGS variable for linking the guest_init binary was
rather pointless, as it was zeroed in the beginning and then never
set.

As guest_init is a rather special binary that does not cope well with
arbitrary linker flags, let's reinstantiate the previous state by
removing the LDFLAGS variable from those linking steps. This allows
LDFLAGS to be used for linking the actual kvmtool binary only and
helps to re-merge commit d0e2772b93a ("Makefile: allow overriding
CFLAGS on the command line").

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi,

Riku: can you confirm that this patch together with the one that was
reverted (d0e2772b93a) still works in your environment?

Will, if that works for Riku and you acknowledge this patch, can you
also re-merge the reverted patch mentioned above? Turns out that the
revert also made my other patch useless ;-)

Cheers,
Andre.

 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 9138942..8095d59 100644
--- a/Makefile
+++ b/Makefile
@@ -385,13 +385,13 @@ ifneq ($(ARCH_PRE_INIT),)
 $(GUEST_PRE_INIT): $(ARCH_PRE_INIT)
 	$(E) "  LINK    " $@
 	$(Q) $(CC) -s -nostdlib $(ARCH_PRE_INIT) -o $@
-	$(Q) $(LD) $(LDFLAGS) -r -b binary -o guest/guest_pre_init.o $(GUEST_PRE_INIT)
+	$(Q) $(LD) -r -b binary -o guest/guest_pre_init.o $(GUEST_PRE_INIT)
 endif
 
 $(GUEST_INIT): guest/init.c
 	$(E) "  LINK    " $@
 	$(Q) $(CC) $(GUEST_INIT_FLAGS) guest/init.c -o $@
-	$(Q) $(LD) $(LDFLAGS) -r -b binary -o guest/guest_init.o $(GUEST_INIT)
+	$(Q) $(LD) -r -b binary -o guest/guest_init.o $(GUEST_INIT)
 
 %.s: %.c
 	$(Q) $(CC) -o $@ -S $(CFLAGS) -fverbose-asm $<
-- 
1.8.4

