From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 02/13] kvm: selftests: introduce ucall
Date: Tue, 18 Sep 2018 19:54:25 +0200
Message-ID: <20180918175436.19742-3-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 055A64A1FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QhdaUTGnJ8GQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:54:47 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A8D54A20F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:54:47 -0400 (EDT)
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

Rework the guest exit to userspace code to generalize the concept
into what it is, a "hypercall to userspace", and provide two
implementations of it: the PortIO version currently used, but only
useable by x86, and an MMIO version that other architectures (except
s390) can use.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/cr4_cpuid_sync_test.c       |  12 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   5 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  76 ++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c    |  14 --
 tools/testing/selftests/kvm/lib/ucall.c       | 144 ++++++++++++++++++
 tools/testing/selftests/kvm/state_test.c      |  23 +--
 .../selftests/kvm/vmx_tsc_adjust_test.c       |  17 +--
 8 files changed, 214 insertions(+), 79 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/ucall.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 87d1a8488af8..0b254dbf6e86 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -3,7 +3,7 @@ all:
 top_srcdir = ../../../../
 UNAME_M := $(shell uname -m)
 
-LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c
+LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebit.c
 LIBKVM_x86_64 = lib/x86.c lib/vmx.c
 
 TEST_GEN_PROGS_x86_64 = set_sregs_test
diff --git a/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c
index 11ec358bf969..fd4f419fe9ab 100644
--- a/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/cr4_cpuid_sync_test.c
@@ -67,6 +67,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_sregs sregs;
 	struct kvm_cpuid_entry2 *entry;
+	struct ucall uc;
 	int rc;
 
 	entry = kvm_get_supported_cpuid_entry(1);
@@ -87,21 +88,20 @@ int main(int argc, char *argv[])
 		rc = _vcpu_run(vm, VCPU_ID);
 
 		if (run->exit_reason == KVM_EXIT_IO) {
-			switch (run->io.port) {
-			case GUEST_PORT_SYNC:
+			switch (get_ucall(vm, VCPU_ID, &uc)) {
+			case UCALL_SYNC:
 				/* emulate hypervisor clearing CR4.OSXSAVE */
 				vcpu_sregs_get(vm, VCPU_ID, &sregs);
 				sregs.cr4 &= ~X86_CR4_OSXSAVE;
 				vcpu_sregs_set(vm, VCPU_ID, &sregs);
 				break;
-			case GUEST_PORT_ABORT:
+			case UCALL_ABORT:
 				TEST_ASSERT(false, "Guest CR4 bit (OSXSAVE) unsynchronized with CPUID bit.");
 				break;
-			case GUEST_PORT_DONE:
+			case UCALL_DONE:
 				goto done;
 			default:
-				TEST_ASSERT(false, "Unknown port 0x%x.",
-					    run->io.port);
+				TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
 			}
 		}
 	}
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 0c2cdc105f96..7cf3e4ae6046 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -110,7 +110,7 @@ void *vcpu_worker(void *data)
 	uint64_t loops, *guest_array, pages_count = 0;
 	struct kvm_vm *vm = data;
 	struct kvm_run *run;
-	struct guest_args args;
+	struct ucall uc;
 
 	run = vcpu_state(vm, VCPU_ID);
 
@@ -124,9 +124,8 @@ void *vcpu_worker(void *data)
 	while (!READ_ONCE(host_quit)) {
 		/* Let the guest to dirty these random pages */
 		ret = _vcpu_run(vm, VCPU_ID);
-		guest_args_read(vm, VCPU_ID, &args);
 		if (run->exit_reason == KVM_EXIT_IO &&
-		    args.port == GUEST_PORT_SYNC) {
+		    get_ucall(vm, VCPU_ID, &uc) == UCALL_SYNC) {
 			pages_count += TEST_PAGES_PER_LOOP;
 			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		} else {
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bb5a25fb82c6..138289f7d489 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -148,43 +148,49 @@ allocate_kvm_dirty_log(struct kvm_userspace_memory_region *region);
 
 int vm_create_device(struct kvm_vm *vm, struct kvm_create_device *cd);
 
-#define GUEST_PORT_SYNC         0x1000
-#define GUEST_PORT_ABORT        0x1001
-#define GUEST_PORT_DONE         0x1002
-
-static inline void __exit_to_l0(uint16_t port, uint64_t arg0, uint64_t arg1)
-{
-	__asm__ __volatile__("in %[port], %%al"
-			     :
-			     : [port]"d"(port), "D"(arg0), "S"(arg1)
-			     : "rax");
-}
-
-/*
- * Allows to pass three arguments to the host: port is 16bit wide,
- * arg0 & arg1 are 64bit wide
- */
-#define GUEST_SYNC_ARGS(_port, _arg0, _arg1) \
-	__exit_to_l0(_port, (uint64_t) (_arg0), (uint64_t) (_arg1))
-
-#define GUEST_ASSERT(_condition) do {				\
-		if (!(_condition))				\
-			GUEST_SYNC_ARGS(GUEST_PORT_ABORT,	\
-					"Failed guest assert: "	\
-					#_condition, __LINE__);	\
-	} while (0)
-
-#define GUEST_SYNC(stage)  GUEST_SYNC_ARGS(GUEST_PORT_SYNC, "hello", stage)
+#define sync_global_to_guest(vm, g) ({				\
+	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	memcpy(_p, &(g), sizeof(g));				\
+})
+
+#define sync_global_from_guest(vm, g) ({			\
+	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	memcpy(&(g), _p, sizeof(g));				\
+})
+
+/* ucall implementation types */
+typedef enum {
+	UCALL_PIO,
+	UCALL_MMIO,
+} ucall_type_t;
+
+/* Common ucalls */
+enum {
+	UCALL_NONE,
+	UCALL_SYNC,
+	UCALL_ABORT,
+	UCALL_DONE,
+};
 
-#define GUEST_DONE()  GUEST_SYNC_ARGS(GUEST_PORT_DONE, 0, 0)
+#define UCALL_MAX_ARGS 6
 
-struct guest_args {
-	uint64_t arg0;
-	uint64_t arg1;
-	uint16_t port;
-} __attribute__ ((packed));
+struct ucall {
+	uint64_t cmd;
+	uint64_t args[UCALL_MAX_ARGS];
+};
 
-void guest_args_read(struct kvm_vm *vm, uint32_t vcpu_id,
-		     struct guest_args *args);
+void ucall_init(struct kvm_vm *vm, ucall_type_t type, void *arg);
+void ucall_uninit(struct kvm_vm *vm);
+void ucall(uint64_t cmd, int nargs, ...);
+uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
+
+#define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
+#define GUEST_DONE()		ucall(UCALL_DONE, 0)
+#define GUEST_ASSERT(_condition) do {			\
+	if (!(_condition))				\
+		ucall(UCALL_ABORT, 2,			\
+			"Failed guest assert: "		\
+			#_condition, __LINE__);		\
+} while (0)
 
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e9ba389c48db..107622ce2b8c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1580,17 +1580,3 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
 }
-
-void guest_args_read(struct kvm_vm *vm, uint32_t vcpu_id,
-		     struct guest_args *args)
-{
-	struct kvm_run *run = vcpu_state(vm, vcpu_id);
-	struct kvm_regs regs;
-
-	memset(&regs, 0, sizeof(regs));
-	vcpu_regs_get(vm, vcpu_id, &regs);
-
-	args->port = run->io.port;
-	args->arg0 = regs.rdi;
-	args->arg1 = regs.rsi;
-}
diff --git a/tools/testing/selftests/kvm/lib/ucall.c b/tools/testing/selftests/kvm/lib/ucall.c
new file mode 100644
index 000000000000..4777f9bb5194
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/ucall.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ucall support. A ucall is a "hypercall to userspace".
+ *
+ * Copyright (C) 2018, Red Hat, Inc.
+ */
+#include "kvm_util.h"
+#include "kvm_util_internal.h"
+
+#define UCALL_PIO_PORT ((uint16_t)0x1000)
+
+static ucall_type_t ucall_type;
+static vm_vaddr_t *ucall_exit_mmio_addr;
+
+static bool ucall_mmio_init(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	if (kvm_userspace_memory_region_find(vm, gpa, gpa + 1))
+		return false;
+
+	virt_pg_map(vm, gpa, gpa, 0);
+
+	ucall_exit_mmio_addr = (vm_vaddr_t *)gpa;
+	sync_global_to_guest(vm, ucall_exit_mmio_addr);
+
+	return true;
+}
+
+void ucall_init(struct kvm_vm *vm, ucall_type_t type, void *arg)
+{
+	ucall_type = type;
+	sync_global_to_guest(vm, ucall_type);
+
+	if (type == UCALL_PIO)
+		return;
+
+	if (type == UCALL_MMIO) {
+		vm_paddr_t gpa, start, end, step;
+		bool ret;
+
+		if (arg) {
+			gpa = (vm_paddr_t)arg;
+			ret = ucall_mmio_init(vm, gpa);
+			TEST_ASSERT(ret, "Can't set ucall mmio address to %lx", gpa);
+			return;
+		}
+
+		/*
+		 * Find an address within the allowed virtual address space,
+		 * that does _not_ have a KVM memory region associated with it.
+		 * Identity mapping an address like this allows the guest to
+		 * access it, but as KVM doesn't know what to do with it, it
+		 * will assume it's something userspace handles and exit with
+		 * KVM_EXIT_MMIO. Well, at least that's how it works for AArch64.
+		 * Here we start with a guess that the addresses around two
+		 * thirds of the VA space are unmapped and then work both down
+		 * and up from there in 1/6 VA space sized steps.
+		 */
+		start = 1ul << (vm->va_bits * 2 / 3);
+		end = 1ul << vm->va_bits;
+		step = 1ul << (vm->va_bits / 6);
+		for (gpa = start; gpa >= 0; gpa -= step) {
+			if (ucall_mmio_init(vm, gpa & ~(vm->page_size - 1)))
+				return;
+		}
+		for (gpa = start + step; gpa < end; gpa += step) {
+			if (ucall_mmio_init(vm, gpa & ~(vm->page_size - 1)))
+				return;
+		}
+		TEST_ASSERT(false, "Can't find a ucall mmio address");
+	}
+}
+
+void ucall_uninit(struct kvm_vm *vm)
+{
+	ucall_type = 0;
+	sync_global_to_guest(vm, ucall_type);
+	ucall_exit_mmio_addr = 0;
+	sync_global_to_guest(vm, ucall_exit_mmio_addr);
+}
+
+static void ucall_pio_exit(struct ucall *uc)
+{
+#ifdef __x86_64__
+	asm volatile("in %[port], %%al"
+		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax");
+#endif
+}
+
+static void ucall_mmio_exit(struct ucall *uc)
+{
+	*ucall_exit_mmio_addr = (vm_vaddr_t)uc;
+}
+
+void ucall(uint64_t cmd, int nargs, ...)
+{
+	struct ucall uc = {
+		.cmd = cmd,
+	};
+	va_list va;
+	int i;
+
+	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
+
+	va_start(va, nargs);
+	for (i = 0; i < nargs; ++i)
+		uc.args[i] = va_arg(va, uint64_t);
+	va_end(va);
+
+	switch (ucall_type) {
+	case UCALL_PIO:
+		ucall_pio_exit(&uc);
+		break;
+	case UCALL_MMIO:
+		ucall_mmio_exit(&uc);
+		break;
+	};
+}
+
+uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
+{
+	struct kvm_run *run = vcpu_state(vm, vcpu_id);
+
+	memset(uc, 0, sizeof(*uc));
+
+#ifdef __x86_64__
+	if (ucall_type == UCALL_PIO && run->exit_reason == KVM_EXIT_IO &&
+	    run->io.port == UCALL_PIO_PORT) {
+		struct kvm_regs regs;
+		vcpu_regs_get(vm, vcpu_id, &regs);
+		memcpy(uc, addr_gva2hva(vm, (vm_vaddr_t)regs.rdi), sizeof(*uc));
+		return uc->cmd;
+	}
+#endif
+	if (ucall_type == UCALL_MMIO && run->exit_reason == KVM_EXIT_MMIO &&
+	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
+		vm_vaddr_t gva;
+		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
+			    "Unexpected ucall exit mmio address access");
+		gva = *(vm_vaddr_t *)run->mmio.data;
+		memcpy(uc, addr_gva2hva(vm, gva), sizeof(*uc));
+	}
+
+	return uc->cmd;
+}
diff --git a/tools/testing/selftests/kvm/state_test.c b/tools/testing/selftests/kvm/state_test.c
index 900e3e9dfb9f..cdf82735d6e7 100644
--- a/tools/testing/selftests/kvm/state_test.c
+++ b/tools/testing/selftests/kvm/state_test.c
@@ -127,6 +127,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct kvm_x86_state *state;
+	struct ucall uc;
 	int stage;
 
 	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
@@ -155,23 +156,23 @@ int main(int argc, char *argv[])
 
 		memset(&regs1, 0, sizeof(regs1));
 		vcpu_regs_get(vm, VCPU_ID, &regs1);
-		switch (run->io.port) {
-		case GUEST_PORT_ABORT:
-			TEST_ASSERT(false, "%s at %s:%d", (const char *) regs1.rdi,
-				    __FILE__, regs1.rsi);
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
+				    __FILE__, uc.args[1]);
 			/* NOT REACHED */
-		case GUEST_PORT_SYNC:
+		case UCALL_SYNC:
 			break;
-		case GUEST_PORT_DONE:
+		case UCALL_DONE:
 			goto done;
 		default:
-			TEST_ASSERT(false, "Unknown port 0x%x.", run->io.port);
+			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
 		}
 
-		/* PORT_SYNC is handled here.  */
-		TEST_ASSERT(!strcmp((const char *)regs1.rdi, "hello") &&
-			    regs1.rsi == stage, "Unexpected register values vmexit #%lx, got %lx",
-			    stage, (ulong) regs1.rsi);
+		/* UCALL_SYNC is handled here.  */
+		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
+			    uc.args[1] == stage, "Unexpected register values vmexit #%lx, got %lx",
+			    stage, (ulong)uc.args[1]);
 
 		state = vcpu_save_state(vm, VCPU_ID);
 		kvm_vm_release(vm);
diff --git a/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c
index 49bcc68b0235..8d487c78796a 100644
--- a/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/vmx_tsc_adjust_test.c
@@ -146,26 +146,25 @@ int main(int argc, char *argv[])
 
 	for (;;) {
 		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
-		struct guest_args args;
+		struct ucall uc;
 
 		vcpu_run(vm, VCPU_ID);
-		guest_args_read(vm, VCPU_ID, &args);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (args.port) {
-		case GUEST_PORT_ABORT:
-			TEST_ASSERT(false, "%s", (const char *) args.arg0);
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_ASSERT(false, "%s", (const char *)uc.args[0]);
 			/* NOT REACHED */
-		case GUEST_PORT_SYNC:
-			report(args.arg1);
+		case UCALL_SYNC:
+			report(uc.args[1]);
 			break;
-		case GUEST_PORT_DONE:
+		case UCALL_DONE:
 			goto done;
 		default:
-			TEST_ASSERT(false, "Unknown port 0x%x.", args.port);
+			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
 		}
 	}
 
-- 
2.17.1
