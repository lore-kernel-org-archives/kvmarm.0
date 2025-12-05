Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DD43043D2
	for <kvmarm@lists.linux.dev>; Fri,  5 Dec 2025 23:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764977222; cv=none; b=LeU4nd83nTKCMe3zQc1UxnjGhsBZ9Vkrb035dX3Llx6VpYgsk2tCidSTeJ84munxDG7iv0soRRKhSs8yVEiOOQbUH1BOsUuT73e9dzbItQ7LvuiNl6StAOms6HeKgzTyzMpxLfWjW6Oy4f3m8KNLoH6wtFqjrWJ+ol93hWgfl+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764977222; c=relaxed/simple;
	bh=nxtMYd3/7km1v8qPXREoRp3J/IR2dBX6O6BgohFOtbQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NoIS7XYIjV2H797jeI8NmXo/CTPY+Bs+4cV4YjKvFIPXVbwi462HgR5K08eQwD6LGf4nPL3wTcu5N8Bfx4wsNgmQlMlWZdhF0pZfsPhWwt/DiVAjDYoIDRV7xSv8dmGLvBKBA9M7iGWWFfKD7TipDHE4sYxV+uy4G+qq70gMp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SmOL2O+K; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SmOL2O+K"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3418ad76023so4676519a91.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 15:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764977220; x=1765582020; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=82PAlwWO21tp8UbhKx8JvXdy7ipLM4mrMDPu9N9Uvlk=;
        b=SmOL2O+KZ0MUpOVm7IXvy3bhDoFv+Y9ykWy8JvUriMOicfNfZZT7nRg1cFwP6L26E7
         B53rfo9JMmBa2Rkoa79CtGT4GinB8oVGHXiqxDVYe/n445cUf2PK57DzcFxKc7HiFED4
         qWRLnJVOcjFjMm3Jkk/HRFVX1Z9vweNhwjUYSt3HmlcS7PsfVSkIRPq6BzmocyavGnI8
         oV2Y2ga3K8kreijeRDtYvP5eHXrUxPjT3Mh8/Z2bzG5mPyVwtIEUdeUDzIsEe+uzqAt2
         rru+cv6+5Vw+ev19VfNvLv+mKhUwT+tlpOBjVA1U6ZxbxEceDD9+WHpK0OR+QYCNgzit
         Urnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764977220; x=1765582020;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82PAlwWO21tp8UbhKx8JvXdy7ipLM4mrMDPu9N9Uvlk=;
        b=Uqn/mKI+ThCmErWugAOui4jr+LsN3vnfqmAioeLzZw+KKe1TnQ8l70ZNXtGEe+U9Gm
         Tnm/6fJk4HJ3wgScEaStGkQkyQMqXH9RBbSa4nLfSIF8mRydHeDwV+a5vAPhi/ss5YBb
         sIa14IabLc+sJV+oIxY3zNVpcl7q0ypcCQAewRgG6Wh8h+yIXoNdzrIt0n+OXe0rn7UM
         HrMioL4kvY6Wk0k0lACSk6/rJegpv+/TI40ZKgWTcXv5CExLcSlMA8ztqkP5QpT4U7f+
         tjjUhV2GkzaYrHmXGbxYSPVEC/VwKpCZMAiYAggUGF6uK2eGq8ENvV/2Ocr5BJd8B9t9
         rUKA==
X-Forwarded-Encrypted: i=1; AJvYcCU8jw49VbbLMnZhNOAa4iQ0iYto9YUVS8xDeLkWuVfIvxoJHefuRr2QlCKv7UMwtq9KoB+loBI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUFPA3TeW7KVN1x+AVx1sdZcNlzL+J1/DLiCQwgYN/jPNI6sVn
	wNGK35X2jYo4qJAYemwPWdqx77NQcKl9USXdsStGDkVynDezLCjwm1U3Ss0ndlQY5XDcYXOsZzp
	7zNm6Hw==
X-Google-Smtp-Source: AGHT+IErDx9AIrBqjFmTumbdAWc/cSbBSgvfKCPFfnkGw52vegmGTZZ2dg0HO4IMDrvo9ctTc+uVUsD59M4=
X-Received: from pjtv9.prod.google.com ([2002:a17:90a:c909:b0:33b:51fe:1a81])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384c:b0:343:6a79:6c75
 with SMTP id 98e67ed59e1d1-349a25e560bmr498079a91.29.1764977219654; Fri, 05
 Dec 2025 15:26:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:26:55 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205232655.445294-1-seanjc@google.com>
Subject: [PATCH] KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Remove KVM's internal pseudo-overlay of kvm_stats_desc, which subtly
aliases the flexible name[] in the uAPI definition with a fixed-size array
of the same name.  The unusual embedded structure results in compiler
warnings due to -Wflex-array-member-not-at-end, and also necessitates an
extra level of dereferencing in KVM.  To avoid the "overlay", define the
uAPI structure to have a fixed-size name when building for the kernel.

Opportunistically clean up the indentation for the stats macros, and
replace spaces with tabs.

No functional change intended.

Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Closes: https://lore.kernel.org/all/aPfNKRpLfhmhYqfP@kspp
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Posting this as a standalone patch/email to make review and merging easier
(assuming no one hates on the __KERNEL__ shenanigans).
 
 arch/arm64/kvm/guest.c    |  4 +-
 arch/loongarch/kvm/vcpu.c |  2 +-
 arch/loongarch/kvm/vm.c   |  2 +-
 arch/mips/kvm/mips.c      |  4 +-
 arch/powerpc/kvm/book3s.c |  4 +-
 arch/powerpc/kvm/booke.c  |  4 +-
 arch/riscv/kvm/vcpu.c     |  2 +-
 arch/riscv/kvm/vm.c       |  2 +-
 arch/s390/kvm/kvm-s390.c  |  4 +-
 arch/x86/kvm/x86.c        |  4 +-
 include/linux/kvm_host.h  | 83 +++++++++++++++++----------------------
 include/uapi/linux/kvm.h  |  8 ++++
 virt/kvm/binary_stats.c   |  2 +-
 virt/kvm/kvm_main.c       | 20 +++++-----
 14 files changed, 70 insertions(+), 75 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1c87699fd886..332c453b87cf 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -29,7 +29,7 @@
 
 #include "trace.h"
 
-const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+const struct kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
 };
 
@@ -42,7 +42,7 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 		       sizeof(kvm_vm_stats_desc),
 };
 
-const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+const struct kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, hvc_exit_stat),
 	STATS_DESC_COUNTER(VCPU, wfe_exit_stat),
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 6d833599ef2e..2bcbd27f1152 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -13,7 +13,7 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
-const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+const struct kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, int_exits),
 	STATS_DESC_COUNTER(VCPU, idle_exits),
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 194ccbcdc3b3..7deff56e0e1a 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -10,7 +10,7 @@
 #include <asm/kvm_eiointc.h>
 #include <asm/kvm_pch_pic.h>
 
-const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+const struct kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_ICOUNTER(VM, pages),
 	STATS_DESC_ICOUNTER(VM, hugepages),
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b0fb92fda4d4..23e69baad453 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -38,7 +38,7 @@
 #define VECTORSPACING 0x100	/* for EI/VI mode */
 #endif
 
-const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+const struct kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
 };
 
@@ -51,7 +51,7 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 		       sizeof(kvm_vm_stats_desc),
 };
 
-const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+const struct kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, wait_exits),
 	STATS_DESC_COUNTER(VCPU, cache_exits),
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d79c5d1098c0..2efbe05caed7 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -38,7 +38,7 @@
 
 /* #define EXIT_DEBUG */
 
-const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+const struct kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_ICOUNTER(VM, num_2M_pages),
 	STATS_DESC_ICOUNTER(VM, num_1G_pages)
@@ -53,7 +53,7 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 		       sizeof(kvm_vm_stats_desc),
 };
 
-const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+const struct kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, sum_exits),
 	STATS_DESC_COUNTER(VCPU, mmio_exits),
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 3401b96be475..f3ddb24ece74 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -36,7 +36,7 @@
 
 unsigned long kvmppc_booke_handlers;
 
-const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+const struct kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_ICOUNTER(VM, num_2M_pages),
 	STATS_DESC_ICOUNTER(VM, num_1G_pages)
@@ -51,7 +51,7 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 		       sizeof(kvm_vm_stats_desc),
 };
 
-const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+const struct kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, sum_exits),
 	STATS_DESC_COUNTER(VCPU, mmio_exits),
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index a55a95da54d0..fdd99ac1e714 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -24,7 +24,7 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
-const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+const struct kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
 	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 66d91ae6e9b2..715a06ae8c13 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -13,7 +13,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
 
-const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+const struct kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
 };
 static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 70dd9ce8cf2b..1cc90b8cf768 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -65,7 +65,7 @@
 #define VCPU_IRQS_MAX_BUF (sizeof(struct kvm_s390_irq) * \
 			   (KVM_MAX_VCPUS + LOCAL_IRQS))
 
-const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+const struct kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_COUNTER(VM, inject_io),
 	STATS_DESC_COUNTER(VM, inject_float_mchk),
@@ -91,7 +91,7 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 		       sizeof(kvm_vm_stats_desc),
 };
 
-const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+const struct kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, exit_userspace),
 	STATS_DESC_COUNTER(VCPU, exit_null),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6d899d53dd..62ee4816e573 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -237,7 +237,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_ipiv);
 bool __read_mostly enable_device_posted_irqs = true;
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_device_posted_irqs);
 
-const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+const struct kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
 	STATS_DESC_COUNTER(VM, mmu_pte_write),
@@ -263,7 +263,7 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 		       sizeof(kvm_vm_stats_desc),
 };
 
-const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+const struct kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, pf_taken),
 	STATS_DESC_COUNTER(VCPU, pf_fixed),
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..7428d9949382 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1927,56 +1927,43 @@ enum kvm_stat_kind {
 
 struct kvm_stat_data {
 	struct kvm *kvm;
-	const struct _kvm_stats_desc *desc;
+	const struct kvm_stats_desc *desc;
 	enum kvm_stat_kind kind;
 };
 
-struct _kvm_stats_desc {
-	struct kvm_stats_desc desc;
-	char name[KVM_STATS_NAME_SIZE];
-};
-
-#define STATS_DESC_COMMON(type, unit, base, exp, sz, bsz)		       \
-	.flags = type | unit | base |					       \
-		 BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |	       \
-		 BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |	       \
-		 BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),	       \
-	.exponent = exp,						       \
-	.size = sz,							       \
+#define STATS_DESC_COMMON(type, unit, base, exp, sz, bsz)		\
+	.flags = type | unit | base |					\
+		 BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |       \
+		 BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |	\
+		 BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),	\
+	.exponent = exp,						\
+	.size = sz,							\
 	.bucket_size = bsz
 
-#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vm_stat, generic.stat)   \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vcpu_stat, generic.stat) \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VM_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vm_stat, stat)	       \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vcpu_stat, stat)	       \
-		},							       \
-		.name = #stat,						       \
-	}
+#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	\
+{									\
+	STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),		\
+	.offset = offsetof(struct kvm_vm_stat, generic.stat),		\
+	.name = #stat,							\
+}
+#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	\
+{									\
+	STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),		\
+	.offset = offsetof(struct kvm_vcpu_stat, generic.stat),		\
+	.name = #stat,							\
+}
+#define VM_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		\
+{									\
+	STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),		\
+	.offset = offsetof(struct kvm_vm_stat, stat),			\
+	.name = #stat,							\
+}
+#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		\
+{									\
+	STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),		\
+	.offset = offsetof(struct kvm_vcpu_stat, stat),			\
+	.name = #stat,							\
+}
 /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
 #define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz)		       \
 	SCOPE##_STATS_DESC(stat, type, unit, base, exp, sz, bsz)
@@ -2053,7 +2040,7 @@ struct _kvm_stats_desc {
 	STATS_DESC_IBOOLEAN(VCPU_GENERIC, blocking)
 
 ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
-		       const struct _kvm_stats_desc *desc,
+		       const struct kvm_stats_desc *desc,
 		       void *stats, size_t size_stats,
 		       char __user *user_buffer, size_t size, loff_t *offset);
 
@@ -2098,9 +2085,9 @@ static inline void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value)
 
 
 extern const struct kvm_stats_header kvm_vm_stats_header;
-extern const struct _kvm_stats_desc kvm_vm_stats_desc[];
+extern const struct kvm_stats_desc kvm_vm_stats_desc[];
 extern const struct kvm_stats_header kvm_vcpu_stats_header;
-extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
+extern const struct kvm_stats_desc kvm_vcpu_stats_desc[];
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 static inline int mmu_invalidate_retry(struct kvm *kvm, unsigned long mmu_seq)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507..76bd54848b11 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -14,6 +14,10 @@
 #include <linux/ioctl.h>
 #include <asm/kvm.h>
 
+#ifdef __KERNEL__
+#include <linux/kvm_types.h>
+#endif
+
 #define KVM_API_VERSION 12
 
 /*
@@ -1579,7 +1583,11 @@ struct kvm_stats_desc {
 	__u16 size;
 	__u32 offset;
 	__u32 bucket_size;
+#ifdef __KERNEL__
+	char name[KVM_STATS_NAME_SIZE];
+#else
 	char name[];
+#endif
 };
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
diff --git a/virt/kvm/binary_stats.c b/virt/kvm/binary_stats.c
index eefca6c69f51..76ce697c773b 100644
--- a/virt/kvm/binary_stats.c
+++ b/virt/kvm/binary_stats.c
@@ -50,7 +50,7 @@
  * Return: the number of bytes that has been successfully read
  */
 ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
-		       const struct _kvm_stats_desc *desc,
+		       const struct kvm_stats_desc *desc,
 		       void *stats, size_t size_stats,
 		       char __user *user_buffer, size_t size, loff_t *offset)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74e1afd67b44..6ebf1936c8d4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -982,9 +982,9 @@ static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
 		kvm_free_memslot(kvm, memslot);
 }
 
-static umode_t kvm_stats_debugfs_mode(const struct _kvm_stats_desc *pdesc)
+static umode_t kvm_stats_debugfs_mode(const struct kvm_stats_desc *desc)
 {
-	switch (pdesc->desc.flags & KVM_STATS_TYPE_MASK) {
+	switch (desc->flags & KVM_STATS_TYPE_MASK) {
 	case KVM_STATS_TYPE_INSTANT:
 		return 0444;
 	case KVM_STATS_TYPE_CUMULATIVE:
@@ -1019,7 +1019,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	struct dentry *dent;
 	char dir_name[ITOA_MAX_LEN * 2];
 	struct kvm_stat_data *stat_data;
-	const struct _kvm_stats_desc *pdesc;
+	const struct kvm_stats_desc *pdesc;
 	int i, ret = -ENOMEM;
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
@@ -6160,11 +6160,11 @@ static int kvm_stat_data_get(void *data, u64 *val)
 	switch (stat_data->kind) {
 	case KVM_STAT_VM:
 		r = kvm_get_stat_per_vm(stat_data->kvm,
-					stat_data->desc->desc.offset, val);
+					stat_data->desc->offset, val);
 		break;
 	case KVM_STAT_VCPU:
 		r = kvm_get_stat_per_vcpu(stat_data->kvm,
-					  stat_data->desc->desc.offset, val);
+					  stat_data->desc->offset, val);
 		break;
 	}
 
@@ -6182,11 +6182,11 @@ static int kvm_stat_data_clear(void *data, u64 val)
 	switch (stat_data->kind) {
 	case KVM_STAT_VM:
 		r = kvm_clear_stat_per_vm(stat_data->kvm,
-					  stat_data->desc->desc.offset);
+					  stat_data->desc->offset);
 		break;
 	case KVM_STAT_VCPU:
 		r = kvm_clear_stat_per_vcpu(stat_data->kvm,
-					    stat_data->desc->desc.offset);
+					    stat_data->desc->offset);
 		break;
 	}
 
@@ -6334,7 +6334,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 static void kvm_init_debug(void)
 {
 	const struct file_operations *fops;
-	const struct _kvm_stats_desc *pdesc;
+	const struct kvm_stats_desc *pdesc;
 	int i;
 
 	kvm_debugfs_dir = debugfs_create_dir("kvm", NULL);
@@ -6347,7 +6347,7 @@ static void kvm_init_debug(void)
 			fops = &vm_stat_readonly_fops;
 		debugfs_create_file(pdesc->name, kvm_stats_debugfs_mode(pdesc),
 				kvm_debugfs_dir,
-				(void *)(long)pdesc->desc.offset, fops);
+				(void *)(long)pdesc->offset, fops);
 	}
 
 	for (i = 0; i < kvm_vcpu_stats_header.num_desc; ++i) {
@@ -6358,7 +6358,7 @@ static void kvm_init_debug(void)
 			fops = &vcpu_stat_readonly_fops;
 		debugfs_create_file(pdesc->name, kvm_stats_debugfs_mode(pdesc),
 				kvm_debugfs_dir,
-				(void *)(long)pdesc->desc.offset, fops);
+				(void *)(long)pdesc->offset, fops);
 	}
 }
 

base-commit: e0c26d47def7382d7dbd9cad58bc653aed75737a
-- 
2.52.0.223.gf5cc29aaa4-goog

