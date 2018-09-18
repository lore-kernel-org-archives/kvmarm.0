From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 12/13] kvm: selftests: stop lying to aarch64 tests about
 PA-bits
Date: Tue, 18 Sep 2018 19:54:35 +0200
Message-ID: <20180918175436.19742-13-drjones@redhat.com>
References: <20180918175436.19742-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6DB4A0C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3DuH52N7JQva for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 13:55:20 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 161D94A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 13:55:20 -0400 (EDT)
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

Let's add the 40 PA-bit versions of the VM modes, that AArch64
should have been using, so we can extend the dirty log test without
breaking things.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c     | 13 ++++++++++---
 tools/testing/selftests/kvm/include/kvm_util.h   |  2 ++
 .../selftests/kvm/lib/aarch64/processor.c        |  8 ++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c       | 16 ++++++++++++++++
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 3afc7d607a2e..61396882ad4e 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -230,9 +230,11 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 
 	switch (mode) {
 	case VM_MODE_P52V48_4K:
+	case VM_MODE_P40V48_4K:
 		guest_page_shift = 12;
 		break;
 	case VM_MODE_P52V48_64K:
+	case VM_MODE_P40V48_64K:
 		guest_page_shift = 16;
 		break;
 	default:
@@ -317,11 +319,16 @@ static struct vm_guest_modes {
 	bool supported;
 	bool enabled;
 } vm_guest_modes[NUM_VM_MODES] = {
+#if defined(__x86_64__)
 	{ VM_MODE_P52V48_4K,	1, 1, },
-#ifdef __aarch64__
-	{ VM_MODE_P52V48_64K,	1, 1, },
-#else
 	{ VM_MODE_P52V48_64K,	0, 0, },
+	{ VM_MODE_P40V48_4K,	0, 0, },
+	{ VM_MODE_P40V48_64K,	0, 0, },
+#elif defined(__aarch64__)
+	{ VM_MODE_P52V48_4K,	0, 0, },
+	{ VM_MODE_P52V48_64K,	0, 0, },
+	{ VM_MODE_P40V48_4K,	1, 1, },
+	{ VM_MODE_P40V48_64K,	1, 1, },
 #endif
 };
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 6e3dff9d9d94..d76431322a30 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -36,6 +36,8 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 enum vm_guest_mode {
 	VM_MODE_P52V48_4K,
 	VM_MODE_P52V48_64K,
+	VM_MODE_P40V48_4K,
+	VM_MODE_P40V48_64K,
 	NUM_VM_MODES,
 };
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index b1dfc0d4b68e..b6022e2f116e 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -275,6 +275,14 @@ void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
 		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
 		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
 		break;
+	case VM_MODE_P40V48_4K:
+		tcr_el1 |= 0ul << 14; /* TG0 = 4KB */
+		tcr_el1 |= 2ul << 32; /* IPS = 40 bits */
+		break;
+	case VM_MODE_P40V48_64K:
+		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
+		tcr_el1 |= 2ul << 32; /* IPS = 40 bits */
+		break;
 	default:
 		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", vm->mode);
 	}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4d3bb515de17..dd8c8ed087b6 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -76,6 +76,8 @@ static void vm_open(struct kvm_vm *vm, int perm)
 const char * const vm_guest_mode_string[] = {
 	"PA-bits:52, VA-bits:48, 4K pages",
 	"PA-bits:52, VA-bits:48, 64K pages",
+	"PA-bits:40, VA-bits:48, 4K pages",
+	"PA-bits:40, VA-bits:48, 64K pages",
 };
 
 /*
@@ -124,6 +126,20 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 		vm->page_size = 0x10000;
 		vm->page_shift = 16;
 		break;
+	case VM_MODE_P40V48_4K:
+		vm->pgtable_levels = 4;
+		vm->pa_bits = 40;
+		vm->va_bits = 48;
+		vm->page_size = 0x1000;
+		vm->page_shift = 12;
+		break;
+	case VM_MODE_P40V48_64K:
+		vm->pgtable_levels = 3;
+		vm->pa_bits = 40;
+		vm->va_bits = 48;
+		vm->page_size = 0x10000;
+		vm->page_shift = 16;
+		break;
 	default:
 		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
 	}
-- 
2.17.1
