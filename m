Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74FD1E512
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 20:30:32 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-58456435437so59184557b3.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 13:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690835431; x=1691440231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5U+ePjx5uvIPbOFZvIPuPHJZ5mQDJ+KWLfp0+392RLI=;
        b=j+LTBrLYE45KvHh8yvAoteE2ggn6Qwq9y+k3kwsvbhuMIRZxzeC/Hkjnp1PzL4jKz6
         0SP7Y2Gyw3r8NONVoC4Os2TY22A/s+xUaYg8F+e67r3OuSq/79zEB/FJpE7SxNxQgu/Y
         gZOPprNIVKzVSAqxaZyd5xLl/r38weSLqHNqGEwiYrcDFt55ycppOXKngWWznZHV691M
         7Pgo+NJgXx2OqWMQ+bAElTC2/b6oHmyW5u0ibv3o7mfpTTpROKZbq6DYkG+21bO/Jl6+
         gma6G0gTU6JJ1sDlUZTklxSaDSY69hwMHE+D2+qOXCtqK6dc1gf2rR/85GyHtr0hKZyr
         mZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690835431; x=1691440231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5U+ePjx5uvIPbOFZvIPuPHJZ5mQDJ+KWLfp0+392RLI=;
        b=MIuDqcr/p2GlSXXTgGMGq1dRBCN+f9ImQaGpNaV54yuIlaPopLau8QXZzUG+2jMmBV
         fLdcPGX0BXkY3pbhX4b7Oajy+5YobdU2B7BTBr0vwlhKYnafdR7ON+5IN/R00lE6yd/d
         +haIvpPuFDutpLGn+lLufoWk+9e06WiIc9tgy1gdYSIhO6QpIGreR5iwlZgk1mxwwM+2
         LK8yx8ReUsRowG6RBIpdsq8hCKukv5w99u7+JXc8rKObi//NuFC7bpK1ZDGrmDbGGSDQ
         nRuC84NbK2vWVqVuhWOiQvQeKMmlhAE4Cyw8gH6N4KhsmwoSz6FoWuYe0W3pzCtv2S04
         w+bw==
X-Gm-Message-State: ABy/qLZJ2y4II4mdELlPtlHh+kcltdvuQXPjAIeADIze+ObrffWuvPVX
	8a6k2h0NKs5BljlH79cSkSap/cLKHHQ=
X-Google-Smtp-Source: APBJJlHsVu0gs/pIFQ5XNCO1CEWhZmz2TqbrIDwiZ84JP4lQkpQZDXLalyai8ajrI0RoXSI338A/z0leqG8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:30b:0:b0:cea:ef04:1c61 with SMTP id
 11-20020a25030b000000b00ceaef041c61mr69191ybd.1.1690835431546; Mon, 31 Jul
 2023 13:30:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 31 Jul 2023 13:30:24 -0700
In-Reply-To: <20230731203026.1192091-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230731203026.1192091-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230731203026.1192091-2-seanjc@google.com>
Subject: [PATCH v4.1 1/3] KVM: selftests: Add arch ucall.h and inline simple
 arch hooks
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add an architecture specific ucall.h and inline the simple arch hooks,
e.g. the init hook for everything except ARM, and the actual "do ucall"
hook for everything except x86 (which should be simple, but temporarily
isn't due to carrying a workaround).

Having a per-arch ucall header will allow adding a #define for the
expected KVM exit reason for a ucall that is colocated (for everything
except x86) with the ucall itself.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/aarch64/ucall.h      | 18 ++++++++++++++++++
 .../selftests/kvm/include/riscv/ucall.h        | 18 ++++++++++++++++++
 .../selftests/kvm/include/s390x/ucall.h        | 17 +++++++++++++++++
 .../selftests/kvm/include/ucall_common.h       |  1 +
 .../selftests/kvm/include/x86_64/ucall.h       | 11 +++++++++++
 .../testing/selftests/kvm/lib/aarch64/ucall.c  | 11 +----------
 tools/testing/selftests/kvm/lib/riscv/ucall.c  | 11 -----------
 tools/testing/selftests/kvm/lib/s390x/ucall.c  | 10 ----------
 tools/testing/selftests/kvm/lib/x86_64/ucall.c |  4 ----
 9 files changed, 66 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/ucall.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/ucall.h b/tools/testing/selftests/kvm/include/aarch64/ucall.h
new file mode 100644
index 000000000000..fe65fdf4f0d3
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/ucall.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "kvm_util_base.h"
+
+/*
+ * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
+ * VM), it must not be accessed from host code.
+ */
+extern vm_vaddr_t *ucall_exit_mmio_addr;
+
+static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+{
+	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/include/riscv/ucall.h b/tools/testing/selftests/kvm/include/riscv/ucall.h
new file mode 100644
index 000000000000..86ed0500972b
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/riscv/ucall.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "processor.h"
+
+static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+}
+
+static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+{
+	sbi_ecall(KVM_RISCV_SELFTESTS_SBI_EXT,
+		  KVM_RISCV_SELFTESTS_SBI_UCALL,
+		  uc, 0, 0, 0, 0, 0);
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/include/s390x/ucall.h b/tools/testing/selftests/kvm/include/s390x/ucall.h
new file mode 100644
index 000000000000..47ad4b1fbccb
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/ucall.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "kvm_util_base.h"
+
+static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+}
+
+static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+{
+	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
+	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 4ce11c15285a..9e5948dab030 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -7,6 +7,7 @@
 #ifndef SELFTEST_KVM_UCALL_COMMON_H
 #define SELFTEST_KVM_UCALL_COMMON_H
 #include "test_util.h"
+#include "ucall.h"
 
 /* Common ucalls */
 enum {
diff --git a/tools/testing/selftests/kvm/include/x86_64/ucall.h b/tools/testing/selftests/kvm/include/x86_64/ucall.h
new file mode 100644
index 000000000000..05cc69b0d550
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/ucall.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "kvm_util_base.h"
+
+static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index f212bd8ab93d..ddab0ce89d4d 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -6,11 +6,7 @@
  */
 #include "kvm_util.h"
 
-/*
- * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
- * VM), it must not be accessed from host code.
- */
-static vm_vaddr_t *ucall_exit_mmio_addr;
+vm_vaddr_t *ucall_exit_mmio_addr;
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
@@ -23,11 +19,6 @@ void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gva);
 }
 
-void ucall_arch_do_ucall(vm_vaddr_t uc)
-{
-	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
-}
-
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index 9a3476a2dfca..fe6d1004f018 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -10,10 +10,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
-{
-}
-
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
@@ -40,13 +36,6 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 	return ret;
 }
 
-void ucall_arch_do_ucall(vm_vaddr_t uc)
-{
-	sbi_ecall(KVM_RISCV_SELFTESTS_SBI_EXT,
-		  KVM_RISCV_SELFTESTS_SBI_UCALL,
-		  uc, 0, 0, 0, 0, 0);
-}
-
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index a7f02dc372cf..cca98734653d 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -6,16 +6,6 @@
  */
 #include "kvm_util.h"
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
-{
-}
-
-void ucall_arch_do_ucall(vm_vaddr_t uc)
-{
-	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
-	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
-}
-
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index a53df3ece2f8..1265cecc7dd1 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -8,10 +8,6 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
-{
-}
-
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
 	/*
-- 
2.41.0.585.gd2178a4bd4-goog

