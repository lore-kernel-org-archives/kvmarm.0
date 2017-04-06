From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC kvm-unit-tests PATCH 7/8] Makefiles: fix up the x86 build include and link paths
Date: Thu,  6 Apr 2017 20:07:26 +0100
Message-ID: <20170406190727.5624-8-alex.bennee@linaro.org>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170406190727.5624-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We still need to tell the compiler the correct search path for finding
headers and the like. This is slightly complicated by the "dynamic"
asm search path which is in our build tree but (may be) symlinked to
the right architectures headers.

Also we explicitly include SRCDIR for the linking scripts as VPATH
doesn't seem to find them well enough.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 Makefile            |  2 +-
 x86/Makefile.common | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index c9fea88..22da887 100644
--- a/Makefile
+++ b/Makefile
@@ -78,7 +78,7 @@ $(libcflat): $(cflatobjs)
 	$(AR) rcs $@ $^
 
 include $(LIBFDT_srcdir)/Makefile.libfdt
-$(LIBFDT_archive): CFLAGS += -ffreestanding -I lib -I lib/libfdt -Wno-sign-compare
+$(LIBFDT_archive): CFLAGS += -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -Wno-sign-compare
 $(LIBFDT_archive): $(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS))
 	$(AR) rcs $@ $^
 
diff --git a/x86/Makefile.common b/x86/Makefile.common
index ef6e543..032ed19 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -17,7 +17,7 @@ cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 
 $(libcflat): LDFLAGS += -nostdlib
-$(libcflat): CFLAGS += -ffreestanding -I lib
+$(libcflat): CFLAGS += -ffreestanding -I $(SRCDIR)/lib -I lib
 
 CFLAGS += -m$(bits)
 CFLAGS += -O1
@@ -31,8 +31,8 @@ libgcc := $(shell $(CC) -m$(bits) --print-libgcc-file-name)
 .PRECIOUS: %.elf %.o
 
 FLATLIBS = lib/libcflat.a $(libgcc)
-%.elf: %.o $(FLATLIBS) x86/flat.lds $(cstart.o)
-	$(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,x86/flat.lds \
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
+	$(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS)
 
 %.flat: %.elf
@@ -60,10 +60,10 @@ scripts-common += $(TEST_DIR)/unittests.cfg
 test_cases: $(tests-common) $(tests)
 
 
-$(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I lib -I lib/x86
+$(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
 
 $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
-	$(CC) -m32 -nostdlib -o $@ -Wl,-T,$(TEST_DIR)/realmode.lds $^
+	$(CC) -m32 -nostdlib -o $@ -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
 $(TEST_DIR)/realmode.o: bits = 32
 
-- 
2.11.0
