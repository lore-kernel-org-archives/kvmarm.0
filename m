Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38323D962
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 18:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a2H47ZJI"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1cc29f3afe0so4670315ad.2
        for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 11:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698431015; x=1699035815; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=srZUoBPWZiKpBpFDSV5l36Sp6ql4zJFMGAxv8lh5kbY=;
        b=a2H47ZJIceuE9YQtwWcCJSRZrRHs67Bw6B/OLUbldu3FcPp6YazSwWCTCtDITcGAGq
         YxpNmiJPZAEp5MUpmT5tLHk4REdTtJ6ECcvyqj+JEKK9DG24bezCYZPrvJKYHz8bTDwb
         nkviMakhePTA4YjpeANOTUFbYbeaxHOzD/g0SjdB5QvVmWjK2UXv62uYXhxCbAJ0j+Ho
         IOpc5HsSPIsi3k58cFr9jfY+wtBq8iddpYJkeKOLAFtkFVYsaCbtkOkLFI6s2Wk8OYXl
         pMGuRlgO0O8NvK4yUR5yONVsI0sBdaRk1wbeyp2c9tYqqHLHdHQ5iM7p1j/wcXaDArk9
         fWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698431015; x=1699035815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=srZUoBPWZiKpBpFDSV5l36Sp6ql4zJFMGAxv8lh5kbY=;
        b=StOzjmVe2rFCoo/7B+R3OYzTkRXFPn51+fy2LU/a+OKY5r1TXHBLvH/hHGFPQ0htK8
         5xw28txWNxtEZ/L4SM80Lmc1ePyU3clds64GKJVictY5P9HXe5G33O2F1eBBtq21FJdC
         X7Q+x7XbEXapobiXZ7kx7mBqVnW5+KYAX5ra2abXJ/tZtujpCex7epn5BXFjsl0xTkRX
         2BkuiKxlY5R68QLUWD4GKvM4WJPYPoNVqBhHzKLgXn3smDGhNH1vsCMJzcwq+L8Ygc0l
         mEdKx8JjD/JzyEwQF05V35KdUwWGxBBVEPr9Q+FUPXEOE4uoK+nNCGMIIC5G43d3/Kks
         egzQ==
X-Gm-Message-State: AOJu0YyA14JAN/OHPERlOuQgEc3GhSoTLArMhhL6NpAGcRrT5tay4ArH
	xL2o9eZmila6bW52WsxKPrtmOpkCVMc=
X-Google-Smtp-Source: AGHT+IGsD3GBqEIwxpRuMZy6ZOrqAgR6Um5/oe2tLnBOXdqBPG31+kuimftnouCNE0Glk06NnY7NvSmeibY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:442:b0:1cc:1e05:e0e7 with SMTP id
 iw2-20020a170903044200b001cc1e05e0e7mr49290plb.2.1698431015053; Fri, 27 Oct
 2023 11:23:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 27 Oct 2023 11:22:17 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-36-seanjc@google.com>
Subject: [PATCH v13 35/35] KVM: selftests: Test KVM exit behavior for private memory/access
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

"Testing private access when memslot gets deleted" tests the behavior
of KVM when a private memslot gets deleted while the VM is using the
private memslot. When KVM looks up the deleted (slot = NULL) memslot,
KVM should exit to userspace with KVM_EXIT_MEMORY_FAULT.

In the second test, upon a private access to non-private memslot, KVM
should also exit to userspace with KVM_EXIT_MEMORY_FAULT.

Intentionally don't take a requirement on KVM_CAP_GUEST_MEMFD,
KVM_CAP_MEMORY_FAULT_INFO, KVM_MEMORY_ATTRIBUTE_PRIVATE, etc., as it's a
KVM bug to advertise KVM_X86_SW_PROTECTED_VM without its prerequisites.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
[sean: call out the similarities with set_memory_region_test]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/private_mem_kvm_exits_test.c   | 120 ++++++++++++++++++
 2 files changed, 121 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 2b1ef809d73a..f7fdd8244547 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -82,6 +82,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/private_mem_conversions_test
+TEST_GEN_PROGS_x86_64 += x86_64/private_mem_kvm_exits_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 += x86_64/smaller_maxphyaddr_emulation_test
diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
new file mode 100644
index 000000000000..7f7ca4475745
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022, Google LLC.
+ */
+#include <linux/kvm.h>
+#include <pthread.h>
+#include <stdint.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+/* Arbitrarily selected to avoid overlaps with anything else */
+#define EXITS_TEST_GVA 0xc0000000
+#define EXITS_TEST_GPA EXITS_TEST_GVA
+#define EXITS_TEST_NPAGES 1
+#define EXITS_TEST_SIZE (EXITS_TEST_NPAGES * PAGE_SIZE)
+#define EXITS_TEST_SLOT 10
+
+static uint64_t guest_repeatedly_read(void)
+{
+	volatile uint64_t value;
+
+	while (true)
+		value = *((uint64_t *) EXITS_TEST_GVA);
+
+	return value;
+}
+
+static uint32_t run_vcpu_get_exit_reason(struct kvm_vcpu *vcpu)
+{
+	int r;
+
+	r = _vcpu_run(vcpu);
+	if (r) {
+		TEST_ASSERT(errno == EFAULT, KVM_IOCTL_ERROR(KVM_RUN, r));
+		TEST_ASSERT_EQ(vcpu->run->exit_reason, KVM_EXIT_MEMORY_FAULT);
+	}
+	return vcpu->run->exit_reason;
+}
+
+const struct vm_shape protected_vm_shape = {
+	.mode = VM_MODE_DEFAULT,
+	.type = KVM_X86_SW_PROTECTED_VM,
+};
+
+static void test_private_access_memslot_deleted(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	pthread_t vm_thread;
+	void *thread_return;
+	uint32_t exit_reason;
+
+	vm = vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
+					   guest_repeatedly_read);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    EXITS_TEST_GPA, EXITS_TEST_SLOT,
+				    EXITS_TEST_NPAGES,
+				    KVM_MEM_PRIVATE);
+
+	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
+
+	/* Request to access page privately */
+	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
+
+	pthread_create(&vm_thread, NULL,
+		       (void *(*)(void *))run_vcpu_get_exit_reason,
+		       (void *)vcpu);
+
+	vm_mem_region_delete(vm, EXITS_TEST_SLOT);
+
+	pthread_join(vm_thread, &thread_return);
+	exit_reason = (uint32_t)(uint64_t)thread_return;
+
+	TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
+	TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
+	TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
+	TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+
+	kvm_vm_free(vm);
+}
+
+static void test_private_access_memslot_not_private(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	uint32_t exit_reason;
+
+	vm = vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
+					   guest_repeatedly_read);
+
+	/* Add a non-private memslot (flags = 0) */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    EXITS_TEST_GPA, EXITS_TEST_SLOT,
+				    EXITS_TEST_NPAGES, 0);
+
+	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
+
+	/* Request to access page privately */
+	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
+
+	exit_reason = run_vcpu_get_exit_reason(vcpu);
+
+	TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
+	TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
+	TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
+	TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
+
+	test_private_access_memslot_deleted();
+	test_private_access_memslot_not_private();
+}
-- 
2.42.0.820.g83a721a137-goog

