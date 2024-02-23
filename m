Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE3012B61
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 00:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648999; cv=none; b=YrO/bheAeGWUWw0v1hcZmjjNjU1qxE9xcVncUeeA85gt7NfCbKq4qa90pkwyN/n5RNRu0PwRVjeuhPDmBzusdip69YhVR5yPJ0VoQNnfID57wJ2h1JMKipbvhfG1J0GPvrA9Q9tcIg/f269pHlLg0eHmxQgeEhMdVr4i/5Lyx64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648999; c=relaxed/simple;
	bh=3dMbCHQzR52bpjGwYgn8QVji/JNHNDJooagZhaAHL4A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IOn/WVMYnlYoq0+W9UeN6vKBzahQNKW5U7ENrmrc6+PA3mxEt89EMHx1pMU7TWqPY5xxS2d33OEWxrcZEwPiI8DLZJB0hejl6V0NxxBHjcBrWXpjyqFwvKBK7xb4wcoH4yQ2zkHf4HRJVI2D3aiaP2/Tym5SYSe0zm3fgcAUvpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2SA6h4x1; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2SA6h4x1"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cfc2041cdfso250916a12.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648997; x=1709253797; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QrUKJwHQx6OZ5c5u7S9Sq3lEDPXCQDh1cyYXS22x5bg=;
        b=2SA6h4x10605zwN5ZTuG5irm6FrrrKrlfmm+uTG4Yhxwhd9m2ECiCP2Meh3aq1Ffum
         C9cvzFYtLeUzbW/OfEa46g7Qvbwb+nh+1AaOGKBLrwEMWG0Y6Qa6840Sas5zkDWJWrou
         KpfUUdt2i9KFS6kBhCqdg1SvQ1SHQMNFvGqm0BeN9CIzalrgoUzW9Hv8rQ78BacQpuBF
         tWGpjMsaFlt707cSfCa5ve50ER9VJmoM6wqMlUzasAXAasHkZjezMfX4cNxNieBO485+
         DLiJt326Zuva9rSkMwJl5Zqfr66rQeHchpeJI4MuxwkfdNWcS4ICqHMJbfvZSG8w6Tul
         jDIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648997; x=1709253797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QrUKJwHQx6OZ5c5u7S9Sq3lEDPXCQDh1cyYXS22x5bg=;
        b=MmCT0rJz4l6cU58Odb6/ZcORD1mqF6/B9j53OgNedpncJVSiVRRtiuzlTHuGqc6OQY
         zhKpilbCxjEoFmggFINHzxOGfcMS1NfBwTNGRZ8he+vs2UfmvUPowidSwQPpAiVLCKLx
         Iqckp+uJg3klHawU1og+JvlzzEbZDRnqFXPb7cdnqsp6kkgA85zmxmm7U47z/p4qaCLo
         b0EefugzwEaGZ/dl69Z0sN9nAM30atLd4fjxUaip4bWT4mQm0rcUSHmNxm+sV2Tzgqt0
         zn/fk9kMMfzfv5cV1ujP/7SV/ZfeOSiGCucb+7qYD/hqNNa+kEpaCXpYagatpiN38bsI
         wtVA==
X-Forwarded-Encrypted: i=1; AJvYcCU3BozIIK1ZPrIZf2V0w49ncZNlFEdXTRTAXhFYVBEIvniBJV8baK0N693n3lCmT24W5irOVJmOpay3WuTlGR9cN+wuf79/
X-Gm-Message-State: AOJu0YwCE2dM67X4YBjidFGdwRHzlnQ+lhEAt8muhqGdmvD1ucqlsNab
	/oxXAPtKLNxtrXLg18SNd5CwJ06kTUJtvYGPb/uu+jR5B28YeEM83kJD4SNlDet4WEQNb95dgbu
	W8Q==
X-Google-Smtp-Source: AGHT+IEgZ6Xp4G0QNWZNXsSNaAdKPYaYAdXhVJMDIaBglQolhzxGBOSmSPQxMCreq2B5dM1DsELErPwgM6A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:a0e:b0:5dc:85a6:d74d with SMTP id
 cm14-20020a056a020a0e00b005dc85a6d74dmr962pgb.2.1708648997232; Thu, 22 Feb
 2024 16:43:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:55 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-9-seanjc@google.com>
Subject: [PATCH v9 08/11] KVM: selftests: Add library for creating and
 interacting with SEV guests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Add a library/APIs for creating and interfacing with SEV guests, all of
which need some amount of common functionality, e.g. an open file handle
for the SEV driver (/dev/sev), ioctl() wrappers to pass said file handle
to KVM, tracking of the C-bit, etc.

Add an x86-specific hook to initialize address properties, a.k.a. the
location of the C-bit.  An arch specific hook is rather gross, but x86
already has a dedicated #ifdef-protected kvm_get_cpu_address_width() hook,
i.e. the ugliest code already exists.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/include/x86_64/kvm_util_arch.h        |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |   8 ++
 .../selftests/kvm/include/x86_64/sev.h        | 105 +++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 .../selftests/kvm/lib/x86_64/processor.c      |  17 +++
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 110 ++++++++++++++++++
 7 files changed, 244 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ce58098d80fd..169b6ee8f733 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -38,6 +38,7 @@ LIBKVM_x86_64 += lib/x86_64/hyperv.c
 LIBKVM_x86_64 += lib/x86_64/memstress.c
 LIBKVM_x86_64 += lib/x86_64/pmu.c
 LIBKVM_x86_64 += lib/x86_64/processor.c
+LIBKVM_x86_64 += lib/x86_64/sev.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
 LIBKVM_x86_64 += lib/x86_64/vmx.c
diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
index 17bb38236d97..205ed788aeb8 100644
--- a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
@@ -8,6 +8,8 @@
 struct kvm_vm_arch {
 	uint64_t c_bit;
 	uint64_t s_bit;
+	int sev_fd;
+	bool is_pt_protected;
 };
 
 static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0f4792083d01..3bd03b088dda 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -23,6 +23,12 @@
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
 
+enum vm_guest_x86_subtype {
+	VM_SUBTYPE_NONE = 0,
+	VM_SUBTYPE_SEV,
+	VM_SUBTYPE_SEV_ES,
+};
+
 /* Forced emulation prefix, used to invoke the emulator unconditionally. */
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 
@@ -276,6 +282,7 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
 #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
 #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
+#define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
 #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
 
 #define X86_PROPERTY_MAX_CENTAUR_LEAF		KVM_X86_CPU_PROPERTY(0xC0000000, 0, EAX, 0, 31)
@@ -1093,6 +1100,7 @@ do {											\
 } while (0)
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
+void kvm_init_vm_address_properties(struct kvm_vm *vm);
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 struct ex_regs {
diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
new file mode 100644
index 000000000000..de5283bef752
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Helpers used for SEV guests
+ *
+ */
+#ifndef SELFTEST_KVM_SEV_H
+#define SELFTEST_KVM_SEV_H
+
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "linux/psp-sev.h"
+
+#include "kvm_util.h"
+#include "svm_util.h"
+#include "processor.h"
+
+enum sev_guest_state {
+	SEV_GUEST_STATE_UNINITIALIZED = 0,
+	SEV_GUEST_STATE_LAUNCH_UPDATE,
+	SEV_GUEST_STATE_LAUNCH_SECRET,
+	SEV_GUEST_STATE_RUNNING,
+};
+
+#define SEV_POLICY_NO_DBG	(1UL << 0)
+#define SEV_POLICY_ES		(1UL << 2)
+
+void sev_vm_launch(struct kvm_vm *vm, uint32_t policy);
+void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement);
+void sev_vm_launch_finish(struct kvm_vm *vm);
+
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+					   struct kvm_vcpu **cpu);
+
+kvm_static_assert(SEV_RET_SUCCESS == 0);
+
+/*
+ * The KVM_MEMORY_ENCRYPT_OP uAPI is utter garbage and takes an "unsigned long"
+ * instead of a proper struct.  The size of the parameter is embedded in the
+ * ioctl number, i.e. is ABI and thus immutable.  Hack around the mess by
+ * creating an overlay to pass in an "unsigned long" without a cast (casting
+ * will make the compiler unhappy due to dereferencing an aliased pointer).
+ */
+#define __vm_sev_ioctl(vm, cmd, arg)					\
+({									\
+	int r;								\
+									\
+	union {								\
+		struct kvm_sev_cmd c;					\
+		unsigned long raw;					\
+	} sev_cmd = { .c = {						\
+		.id = (cmd),						\
+		.data = (uint64_t)(arg),				\
+		.sev_fd = (vm)->arch.sev_fd,				\
+	} };								\
+									\
+	r = __vm_ioctl(vm, KVM_MEMORY_ENCRYPT_OP, &sev_cmd.raw);	\
+	r ?: sev_cmd.c.error;						\
+})
+
+#define vm_sev_ioctl(vm, cmd, arg)					\
+({									\
+	int ret = __vm_sev_ioctl(vm, cmd, arg);				\
+									\
+	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd,	ret, vm);		\
+})
+
+static inline void sev_vm_init(struct kvm_vm *vm)
+{
+	vm->arch.sev_fd = open_sev_dev_path_or_exit();
+
+	vm_sev_ioctl(vm, KVM_SEV_INIT, NULL);
+}
+
+
+static inline void sev_es_vm_init(struct kvm_vm *vm)
+{
+	vm->arch.sev_fd = open_sev_dev_path_or_exit();
+
+	vm_sev_ioctl(vm, KVM_SEV_ES_INIT, NULL);
+}
+
+static inline void sev_register_encrypted_memory(struct kvm_vm *vm,
+						 struct userspace_mem_region *region)
+{
+	struct kvm_enc_region range = {
+		.addr = region->region.userspace_addr,
+		.size = region->region.memory_size,
+	};
+
+	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
+}
+
+static inline void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
+					  uint64_t size)
+{
+	struct kvm_sev_launch_update_data update_data = {
+		.uaddr = (unsigned long)addr_gpa2hva(vm, gpa),
+		.len = size,
+	};
+
+	vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &update_data);
+}
+
+#endif /* SELFTEST_KVM_SEV_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 19511137d1ae..b2262b5fad9e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -317,6 +317,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 	case VM_MODE_PXXV48_4K:
 #ifdef __x86_64__
 		kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
+		kvm_init_vm_address_properties(vm);
 		/*
 		 * Ignore KVM support for 5-level paging (vm->va_bits == 57),
 		 * it doesn't take effect unless a CR4.LA57 is set, which it
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 6c1d2c0ec584..aa92220bf5da 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -9,6 +9,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "sev.h"
 
 #ifndef NUM_INTERRUPTS
 #define NUM_INTERRUPTS 256
@@ -278,6 +279,9 @@ uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 {
 	uint64_t *pml4e, *pdpe, *pde;
 
+	TEST_ASSERT(!vm->arch.is_pt_protected,
+		    "Walking page tables of protected guests is impossible");
+
 	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level < PG_LEVEL_NUM,
 		    "Invalid PG_LEVEL_* '%d'", *level);
 
@@ -573,6 +577,11 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 	vm_create_irqchip(vm);
 	sync_global_to_guest(vm, host_cpu_is_intel);
 	sync_global_to_guest(vm, host_cpu_is_amd);
+
+	if (vm->subtype == VM_SUBTYPE_SEV)
+		sev_vm_init(vm);
+	else if (vm->subtype == VM_SUBTYPE_SEV_ES)
+		sev_es_vm_init(vm);
 }
 
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
@@ -1063,6 +1072,14 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 	}
 }
 
+void kvm_init_vm_address_properties(struct kvm_vm *vm)
+{
+	if (vm->subtype == VM_SUBTYPE_SEV) {
+		vm->arch.c_bit = BIT_ULL(this_cpu_property(X86_PROPERTY_SEV_C_BIT));
+		vm->gpa_tag_mask = vm->arch.c_bit;
+	}
+}
+
 static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 			  int dpl, unsigned short selector)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
new file mode 100644
index 000000000000..9f5a3dbb5e65
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "sev.h"
+
+/*
+ * sparsebit_next_clear() can return 0 if [x, 2**64-1] are all set, and the
+ * -1 would then cause an underflow back to 2**64 - 1. This is expected and
+ * correct.
+ *
+ * If the last range in the sparsebit is [x, y] and we try to iterate,
+ * sparsebit_next_set() will return 0, and sparsebit_next_clear() will try
+ * and find the first range, but that's correct because the condition
+ * expression would cause us to quit the loop.
+ */
+static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)
+{
+	const struct sparsebit *protected_phy_pages = region->protected_phy_pages;
+	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
+	const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;
+	sparsebit_idx_t i, j;
+
+	if (!sparsebit_any_set(protected_phy_pages))
+		return;
+
+	sev_register_encrypted_memory(vm, region);
+
+	sparsebit_for_each_set_range(protected_phy_pages, i, j) {
+		const uint64_t size = (j - i + 1) * vm->page_size;
+		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
+
+		sev_launch_update_data(vm, gpa_base + offset, size);
+	}
+}
+
+void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
+{
+	struct kvm_sev_launch_start launch_start = {
+		.policy = policy,
+	};
+	struct userspace_mem_region *region;
+	struct kvm_sev_guest_status status;
+	int ctr;
+
+	vm_sev_ioctl(vm, KVM_SEV_LAUNCH_START, &launch_start);
+	vm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &status);
+
+	TEST_ASSERT_EQ(status.policy, policy);
+	TEST_ASSERT_EQ(status.state, SEV_GUEST_STATE_LAUNCH_UPDATE);
+
+	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node)
+		encrypt_region(vm, region);
+
+	vm->arch.is_pt_protected = true;
+}
+
+void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement)
+{
+	struct kvm_sev_launch_measure launch_measure;
+	struct kvm_sev_guest_status guest_status;
+
+	launch_measure.len = 256;
+	launch_measure.uaddr = (__u64)measurement;
+	vm_sev_ioctl(vm, KVM_SEV_LAUNCH_MEASURE, &launch_measure);
+
+	vm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &guest_status);
+	TEST_ASSERT_EQ(guest_status.state, SEV_GUEST_STATE_LAUNCH_SECRET);
+}
+
+void sev_vm_launch_finish(struct kvm_vm *vm)
+{
+	struct kvm_sev_guest_status status;
+
+	vm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &status);
+	TEST_ASSERT(status.state == SEV_GUEST_STATE_LAUNCH_UPDATE ||
+		    status.state == SEV_GUEST_STATE_LAUNCH_SECRET,
+		    "Unexpected guest state: %d", status.state);
+
+	vm_sev_ioctl(vm, KVM_SEV_LAUNCH_FINISH, NULL);
+
+	vm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &status);
+	TEST_ASSERT_EQ(status.state, SEV_GUEST_STATE_RUNNING);
+}
+
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+					   struct kvm_vcpu **cpu)
+{
+	struct vm_shape shape = {
+		.type = VM_TYPE_DEFAULT,
+		.mode = VM_MODE_DEFAULT,
+		.subtype = VM_SUBTYPE_SEV,
+	};
+	struct kvm_vm *vm;
+	struct kvm_vcpu *cpus[1];
+	uint8_t measurement[512];
+
+	vm = __vm_create_with_vcpus(shape, 1, 0, guest_code, cpus);
+	*cpu = cpus[0];
+
+	sev_vm_launch(vm, policy);
+
+	/* TODO: Validate the measurement is as expected. */
+	sev_vm_launch_measure(vm, measurement);
+
+	sev_vm_launch_finish(vm);
+
+	return vm;
+}
-- 
2.44.0.rc0.258.g7320e95886-goog

