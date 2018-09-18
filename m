From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 03/13] kvm: selftests: move arch-specific files to
 arch-specific locations
Date: Tue, 18 Sep 2018 19:54:26 +0200
Message-ID: <20180918175436.19742-4-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C31549F94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R21TEsis8cAe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:54:50 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D943F4A1FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:49 -0400 (EDT)
In-Reply-To: <20180918175436.19742-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        | 11 +++++-----
 tools/testing/selftests/kvm/Makefile          | 22 +++++++++----------
 .../testing/selftests/kvm/include/kvm_util.h  |  2 +-
 .../testing/selftests/kvm/include/sparsebit.h |  6 ++---
 .../testing/selftests/kvm/include/test_util.h |  6 ++---
 .../kvm/include/{x86.h => x86_64/processor.h} |  8 +++----
 .../selftests/kvm/include/{ => x86_64}/vmx.h  |  6 ++---
 tools/testing/selftests/kvm/lib/assert.c      |  2 +-
 .../selftests/kvm/lib/kvm_util_internal.h     |  8 +++----
 .../kvm/lib/{x86.c => x86_64/processor.c}     |  6 ++---
 .../selftests/kvm/lib/{ => x86_64}/vmx.c      |  4 ++--
 .../kvm/{ => x86_64}/cr4_cpuid_sync_test.c    |  2 +-
 .../kvm/{ => x86_64}/dirty_log_test.c         |  0
 .../kvm/{ => x86_64}/set_sregs_test.c         |  2 +-
 .../selftests/kvm/{ => x86_64}/state_test.c   |  2 +-
 .../kvm/{ => x86_64}/sync_regs_test.c         |  2 +-
 .../kvm/{ => x86_64}/vmx_tsc_adjust_test.c    |  6 ++---
 17 files changed, 48 insertions(+), 47 deletions(-)
 rename tools/testing/selftests/kvm/include/{x86.h => x86_64/processor.h} (99%)
 rename tools/testing/selftests/kvm/include/{ => x86_64}/vmx.h (99%)
 rename tools/testing/selftests/kvm/lib/{x86.c => x86_64/processor.c} (99%)
 rename tools/testing/selftests/kvm/lib/{ => x86_64}/vmx.c (99%)
 rename tools/testing/selftests/kvm/{ => x86_64}/cr4_cpuid_sync_test.c (98%)
 rename tools/testing/selftests/kvm/{ => x86_64}/dirty_log_test.c (100%)
 rename tools/testing/selftests/kvm/{ => x86_64}/set_sregs_test.c (98%)
 rename tools/testing/selftests/kvm/{ => x86_64}/state_test.c (99%)
 rename tools/testing/selftests/kvm/{ => x86_64}/sync_regs_test.c (99%)
 rename tools/testing/selftests/kvm/{ => x86_64}/vmx_tsc_adjust_test.c (98%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 4202139d81d9..9b3933fb5043 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,5 +1,6 @@
-cr4_cpuid_sync_test
-set_sregs_test
-sync_regs_test
-vmx_tsc_adjust_test
-state_test
+/x86_64/cr4_cpuid_sync_test
+/x86_64/set_sregs_test
+/x86_64/sync_regs_test
+/x86_64/vmx_tsc_adjust_test
+/x86_64/state_test
+/x86_64/dirty_log_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0b254dbf6e86..82d77e10b554 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -1,25 +1,25 @@
 all:
 
-top_srcdir = ../../../../
+top_srcdir = ../../../..
 UNAME_M := $(shell uname -m)
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebit.c
-LIBKVM_x86_64 = lib/x86.c lib/vmx.c
+LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
 
-TEST_GEN_PROGS_x86_64 = set_sregs_test
-TEST_GEN_PROGS_x86_64 += sync_regs_test
-TEST_GEN_PROGS_x86_64 += vmx_tsc_adjust_test
-TEST_GEN_PROGS_x86_64 += cr4_cpuid_sync_test
-TEST_GEN_PROGS_x86_64 += state_test
-TEST_GEN_PROGS_x86_64 += dirty_log_test
+TEST_GEN_PROGS_x86_64 = x86_64/set_sregs_test
+TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
+TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
+TEST_GEN_PROGS_x86_64 += x86_64/state_test
+TEST_GEN_PROGS_x86_64 += x86_64/dirty_log_test
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
-LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
-LINUX_TOOL_INCLUDE = $(top_srcdir)tools/include
-CFLAGS += -O2 -g -std=gnu99 -I$(LINUX_TOOL_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -I..
+LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include
+LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
+CFLAGS += -O2 -g -std=gnu99 -I$(LINUX_TOOL_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude -Iinclude/$(UNAME_M) -I..
 LDFLAGS += -lpthread
 
 # After inclusion, $(OUTPUT) is defined and
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 138289f7d489..607f68ba4ceb 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -7,7 +7,7 @@
  *
  */
 #ifndef SELFTEST_KVM_UTIL_H
-#define SELFTEST_KVM_UTIL_H 1
+#define SELFTEST_KVM_UTIL_H
 
 #include "test_util.h"
 
diff --git a/tools/testing/selftests/kvm/include/sparsebit.h b/tools/testing/selftests/kvm/include/sparsebit.h
index 54cfeb6568d3..31e030915c1f 100644
--- a/tools/testing/selftests/kvm/include/sparsebit.h
+++ b/tools/testing/selftests/kvm/include/sparsebit.h
@@ -15,8 +15,8 @@
  * even in the case where most bits are set.
  */
 
-#ifndef _TEST_SPARSEBIT_H_
-#define _TEST_SPARSEBIT_H_
+#ifndef SELFTEST_KVM_SPARSEBIT_H
+#define SELFTEST_KVM_SPARSEBIT_H
 
 #include <stdbool.h>
 #include <stdint.h>
@@ -72,4 +72,4 @@ void sparsebit_validate_internal(struct sparsebit *sbit);
 }
 #endif
 
-#endif /* _TEST_SPARSEBIT_H_ */
+#endif /* SELFTEST_KVM_SPARSEBIT_H */
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 73c3933436ec..c7dafe8bd02c 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -7,8 +7,8 @@
  *
  */
 
-#ifndef TEST_UTIL_H
-#define TEST_UTIL_H 1
+#ifndef SELFTEST_KVM_TEST_UTIL_H
+#define SELFTEST_KVM_TEST_UTIL_H
 
 #include <stdlib.h>
 #include <stdarg.h>
@@ -41,4 +41,4 @@ void test_assert(bool exp, const char *exp_str,
 		    #a, #b, #a, (unsigned long) __a, #b, (unsigned long) __b); \
 } while (0)
 
-#endif /* TEST_UTIL_H */
+#endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/x86.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
similarity index 99%
rename from tools/testing/selftests/kvm/include/x86.h
rename to tools/testing/selftests/kvm/include/x86_64/processor.h
index 42c3596815b8..bb76e8db9b2b 100644
--- a/tools/testing/selftests/kvm/include/x86.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1,5 +1,5 @@
 /*
- * tools/testing/selftests/kvm/include/x86.h
+ * tools/testing/selftests/kvm/include/x86_64/processor.h
  *
  * Copyright (C) 2018, Google LLC.
  *
@@ -7,8 +7,8 @@
  *
  */
 
-#ifndef SELFTEST_KVM_X86_H
-#define SELFTEST_KVM_X86_H
+#ifndef SELFTEST_KVM_PROCESSOR_H
+#define SELFTEST_KVM_PROCESSOR_H
 
 #include <assert.h>
 #include <stdint.h>
@@ -1044,4 +1044,4 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 #define MSR_VM_IGNNE                    0xc0010115
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
-#endif /* !SELFTEST_KVM_X86_H */
+#endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/include/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
similarity index 99%
rename from tools/testing/selftests/kvm/include/vmx.h
rename to tools/testing/selftests/kvm/include/x86_64/vmx.h
index b9ffe1024d3a..12ebd836f7ef 100644
--- a/tools/testing/selftests/kvm/include/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -1,5 +1,5 @@
 /*
- * tools/testing/selftests/kvm/include/vmx.h
+ * tools/testing/selftests/kvm/include/x86_64/vmx.h
  *
  * Copyright (C) 2018, Google LLC.
  *
@@ -11,7 +11,7 @@
 #define SELFTEST_KVM_VMX_H
 
 #include <stdint.h>
-#include "x86.h"
+#include "processor.h"
 
 #define CPUID_VMX_BIT				5
 
@@ -549,4 +549,4 @@ struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
 bool prepare_for_vmx_operation(struct vmx_pages *vmx);
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
 
-#endif /* !SELFTEST_KVM_VMX_H */
+#endif /* SELFTEST_KVM_VMX_H */
diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
index cd01144d27c8..6398efe67885 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -13,7 +13,7 @@
 #include <execinfo.h>
 #include <sys/syscall.h>
 
-#include "../../kselftest.h"
+#include "kselftest.h"
 
 /* Dumps the current stack trace to stderr. */
 static void __attribute__((noinline)) test_dump_stack(void);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index 542ed606b338..0278315cd930 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -1,13 +1,13 @@
 /*
- * tools/testing/selftests/kvm/lib/kvm_util.c
+ * tools/testing/selftests/kvm/lib/kvm_util_internal.h
  *
  * Copyright (C) 2018, Google LLC.
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
-#ifndef KVM_UTIL_INTERNAL_H
-#define KVM_UTIL_INTERNAL_H 1
+#ifndef SELFTEST_KVM_UTIL_INTERNAL_H
+#define SELFTEST_KVM_UTIL_INTERNAL_H
 
 #include "sparsebit.h"
 
@@ -69,4 +69,4 @@ void regs_dump(FILE *stream, struct kvm_regs *regs,
 void sregs_dump(FILE *stream, struct kvm_sregs *sregs,
 	uint8_t indent);
 
-#endif
+#endif /* SELFTEST_KVM_UTIL_INTERNAL_H */
diff --git a/tools/testing/selftests/kvm/lib/x86.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
similarity index 99%
rename from tools/testing/selftests/kvm/lib/x86.c
rename to tools/testing/selftests/kvm/lib/x86_64/processor.c
index bb6c65ebfa77..79c2c5c203c0 100644
--- a/tools/testing/selftests/kvm/lib/x86.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1,5 +1,5 @@
 /*
- * tools/testing/selftests/kvm/lib/x86.c
+ * tools/testing/selftests/kvm/lib/x86_64/processor.c
  *
  * Copyright (C) 2018, Google LLC.
  *
@@ -10,8 +10,8 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
-#include "kvm_util_internal.h"
-#include "x86.h"
+#include "../kvm_util_internal.h"
+#include "processor.h"
 
 /* Minimum physical address used for virtual translation tables. */
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
diff --git a/tools/testing/selftests/kvm/lib/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
similarity index 99%
rename from tools/testing/selftests/kvm/lib/vmx.c
rename to tools/testing/selftests/kvm/lib/x86_64/vmx.c
index b987c3c970eb..d7c401472247 100644
--- a/tools/testing/selftests/kvm/lib/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -1,5 +1,5 @@
 /*
- * tools/testing/selftests/kvm/lib/x86.c
+ * tools/testing/selftests/kvm/lib/x86_64/vmx.c
  *
  * Copyright (C) 2018, Google LLC.
  *
@@ -10,7 +10,7 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
-#include "x86.h"
+#include "processor.h"
 #include "vmx.h"
 
 /* Allocate memory regions for nested VMX tests.
diff --git a/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
similarity index 98%
rename from tools/testing/selftests/kvm/cr4_cpuid_sync_test.c
rename to tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index fd4f419fe9ab..d503a51fad30 100644
--- a/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -17,7 +17,7 @@
 #include "test_util.h"
 
 #include "kvm_util.h"
-#include "x86.h"
+#include "processor.h"
 
 #define X86_FEATURE_XSAVE	(1<<26)
 #define X86_FEATURE_OSXSAVE	(1<<27)
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/dirty_log_test.c
rename to tools/testing/selftests/kvm/x86_64/dirty_log_test.c
diff --git a/tools/testing/selftests/kvm/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
similarity index 98%
rename from tools/testing/selftests/kvm/set_sregs_test.c
rename to tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index 881419d5746e..35640e8e95bc 100644
--- a/tools/testing/selftests/kvm/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -22,7 +22,7 @@
 #include "test_util.h"
 
 #include "kvm_util.h"
-#include "x86.h"
+#include "processor.h"
 
 #define VCPU_ID                  5
 
diff --git a/tools/testing/selftests/kvm/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
similarity index 99%
rename from tools/testing/selftests/kvm/state_test.c
rename to tools/testing/selftests/kvm/x86_64/state_test.c
index cdf82735d6e7..43df194a7c1e 100644
--- a/tools/testing/selftests/kvm/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -17,7 +17,7 @@
 #include "test_util.h"
 
 #include "kvm_util.h"
-#include "x86.h"
+#include "processor.h"
 #include "vmx.h"
 
 #define VCPU_ID		5
diff --git a/tools/testing/selftests/kvm/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
similarity index 99%
rename from tools/testing/selftests/kvm/sync_regs_test.c
rename to tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 213343e5dff9..c8478ce9ea77 100644
--- a/tools/testing/selftests/kvm/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -19,7 +19,7 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
-#include "x86.h"
+#include "processor.h"
 
 #define VCPU_ID 5
 
diff --git a/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
similarity index 98%
rename from tools/testing/selftests/kvm/vmx_tsc_adjust_test.c
rename to tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index 8d487c78796a..38a91a5f04ac 100644
--- a/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -1,5 +1,5 @@
 /*
- * gtests/tests/vmx_tsc_adjust_test.c
+ * vmx_tsc_adjust_test
  *
  * Copyright (C) 2018, Google LLC.
  *
@@ -22,13 +22,13 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
-#include "x86.h"
+#include "processor.h"
 #include "vmx.h"
 
 #include <string.h>
 #include <sys/ioctl.h>
 
-#include "../kselftest.h"
+#include "kselftest.h"
 
 #ifndef MSR_IA32_TSC_ADJUST
 #define MSR_IA32_TSC_ADJUST 0x3b
-- 
2.17.1
