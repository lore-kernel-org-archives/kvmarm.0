From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 1/4] pre_init: rename x86/init.S to x86/init64.S
Date: Wed, 24 Feb 2016 15:33:05 +0000
Message-ID: <1456327988-31568-2-git-send-email-andre.przywara@arm.com>
References: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

To make room for the 32-bit implementation of that assembly stub,
rename it.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile                 | 2 +-
 x86/{init.S => init64.S} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename x86/{init.S => init64.S} (100%)

diff --git a/Makefile b/Makefile
index 19eb7e5..e26afa3 100644
--- a/Makefile
+++ b/Makefile
@@ -110,7 +110,7 @@ endif
 ifeq ($(ARCH),x86_64)
 	ARCH         := x86
 	DEFINES      += -DCONFIG_X86_64
-	ARCH_PRE_INIT = x86/init.S
+	ARCH_PRE_INIT = x86/init64.S
 endif
 
 ### Arch-specific stuff
diff --git a/x86/init.S b/x86/init64.S
similarity index 100%
rename from x86/init.S
rename to x86/init64.S
-- 
2.6.4

