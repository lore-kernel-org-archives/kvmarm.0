Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574FE3CEBB7
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720025; cv=none; b=iJHcauvw0dtQ0mafGjVS/WkANA997rdHjfU6wZrq0hC8VrDQyh1pXyThP7eRacdbOb51bfG38JHfoOSVrXbYAIcWIX5rvgU1UAZmWL0YEX71cv39eTPqCZ0PPV1NVejmZmXRiVTugPeKB/Hdk+OUblePfcBBAuqBDop4+1+8/Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720025; c=relaxed/simple;
	bh=PetytEnD/eKCt7h8br4XZ452AV89Am+pmSldA4Q6ICU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UdMP7GOLpK+K2KL9flzjHIyBY6Tg8ccS5v+JvhI3cgvm2dSGwEXNf4b+ieKdc1reGQZtCGh1z226rgmG1mw3wButyPiaXEcyUlmj1BkF0fG9CUUTWZNlbwt8zrZLtH9aab7GyQuuoGL8dFZqzDapAXWxEoV9jixthgm/0M+aL+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cVhj0tm6; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cVhj0tm6"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82fa2165c3eso1590959b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720022; x=1777324822; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VsBM9gz9Yie/OJLkO0HZvINMCmSgzzZYsxZAlE1tm0I=;
        b=cVhj0tm6Q+M4Fh907xYzhE+JydbORTm0SL0I11mwAb0t673qgunjSCozHiM+GlURZQ
         rjQc3i8z6WGF6Tu57Cl5taKfT2o3AN5+EV7O/VuUC81h6qw8L5BMWWMG5MV84mERLmVy
         dOwu9zkH8oz5IuCT3jlA74M1SHTRhpoA6zzzDVqiN7y88vha6KgSpcJj4sNKpB7Aqgeq
         fAnLVNUQGOkFv4iTIg4mR83+VgleF9TryznauY2YN58diev7p1tn0t4tqSePAsG2uDPb
         hh4dlgfEfdCz84rlw3ntn/FBcT48oYn9qxF0y9TQME81Bwv4H4B646W6Gh/7rdK/R+4U
         o67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720022; x=1777324822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VsBM9gz9Yie/OJLkO0HZvINMCmSgzzZYsxZAlE1tm0I=;
        b=Garn5ZOH9VBx4HjfwU5GF0xJZAXpMyyV5k7N/dfNAjRUGotEVt4GUdhtEtuVqQKVBF
         /1tHlOpT7kbK04kgVaROZyFbGzatiP4JdqeMqaMI3nTqVyeMcDQoEM5IXYCT2vN+TW9a
         NsWUyFUocBp5thtfz9ayvv34kQ94vdhZCk8VxZG8EBEbMkNjUjaFX4I5QHbTtU0lXmw1
         YBcLfdxp+UXIjjbodG/uC4JWon9l4sblwzfp3kxPPfXnfeuSmJbw0ERjpJdagxiYVrrO
         snYVPJfwupVJmmdfIioINAO6K1YhiJR7sE++5z7CUgYPhThrgwILTlJMGJsgnmU8nABU
         B9Yg==
X-Forwarded-Encrypted: i=1; AFNElJ+/AR4dxq9siiw1MBC/mZUPCaxtQyi/Qp5N1wh4+8B7tHCXZh4Oit2kvCJxdAUsRfCzKAunvTg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWBFA36C7nZdo/1hf1sljJQb6VZy1LUVZ9Cp9ZsYrc3CaUvtL5
	eNqaszRyXCe5gYgBCwj97PP5fVZyYECkfOQWlmKiknNtbuUwMVDDdBVMA2gfSt5o1ucEkcKU4k7
	Tf/TItg==
X-Received: from pfna24.prod.google.com ([2002:aa7:80d8:0:b0:82f:5576:285b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:847:b0:82f:37e3:ae67
 with SMTP id d2e1a72fcca58-82f8c96288amr15742439b3a.27.1776720021487; Mon, 20
 Apr 2026 14:20:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:19:53 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-9-seanjc@google.com>
Subject: [PATCH v3 08/19] KVM: selftests: Use u16 instead of uint16_t
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Use u16 instead of uint16_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/uint16_t/u16/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/arm64/page_fault_test.c     |  2 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  2 +-
 .../testing/selftests/kvm/include/x86/evmcs.h |  2 +-
 .../selftests/kvm/include/x86/processor.h     | 58 +++++++++----------
 .../testing/selftests/kvm/lib/guest_sprintf.c |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  8 +--
 tools/testing/selftests/kvm/lib/x86/ucall.c   |  2 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     |  2 +-
 tools/testing/selftests/kvm/s390/memop.c      |  2 +-
 .../testing/selftests/kvm/x86/fastops_test.c  |  2 +-
 .../selftests/kvm/x86/sync_regs_test.c        |  2 +-
 11 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/page_fault_test.c b/tools/testing/selftests/kvm/arm64/page_fault_test.c
index cb52ac8aa0a5..b92a9614d7d2 100644
--- a/tools/testing/selftests/kvm/arm64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/arm64/page_fault_test.c
@@ -148,7 +148,7 @@ static void guest_at(void)
  */
 static void guest_dc_zva(void)
 {
-	uint16_t val;
+	u16 val;
 
 	asm volatile("dc zva, %0" :: "r" (guest_test_memory));
 	dsb(ish);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bdb91f627433..34c8a7d94997 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -216,7 +216,7 @@ struct vm_shape {
 	u32 type;
 	uint8_t  mode;
 	uint8_t  pad0;
-	uint16_t pad1;
+	u16 pad1;
 };
 
 kvm_static_assert(sizeof(struct vm_shape) == sizeof(u64));
diff --git a/tools/testing/selftests/kvm/include/x86/evmcs.h b/tools/testing/selftests/kvm/include/x86/evmcs.h
index 3b0f96b881f9..be79bda024bf 100644
--- a/tools/testing/selftests/kvm/include/x86/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86/evmcs.h
@@ -10,7 +10,7 @@
 #include "hyperv.h"
 #include "vmx.h"
 
-#define u16 uint16_t
+#define u16 u16
 #define u32 u32
 #define u64 u64
 
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 3898665ad2e9..8700d37a5727 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -399,8 +399,8 @@ struct gpr64_regs {
 };
 
 struct desc64 {
-	uint16_t limit0;
-	uint16_t base0;
+	u16 limit0;
+	u16 base0;
 	unsigned base1:8, type:4, s:1, dpl:2, p:1;
 	unsigned limit1:4, avl:1, l:1, db:1, g:1, base2:8;
 	u32 base3;
@@ -408,7 +408,7 @@ struct desc64 {
 } __attribute__((packed));
 
 struct desc_ptr {
-	uint16_t size;
+	u16 size;
 	u64 address;
 } __attribute__((packed));
 
@@ -476,9 +476,9 @@ static inline void wrmsr(u32 msr, u64 value)
 }
 
 
-static inline uint16_t inw(uint16_t port)
+static inline u16 inw(u16 port)
 {
-	uint16_t tmp;
+	u16 tmp;
 
 	__asm__ __volatile__("in %%dx, %%ax"
 		: /* output */ "=a" (tmp)
@@ -487,63 +487,63 @@ static inline uint16_t inw(uint16_t port)
 	return tmp;
 }
 
-static inline uint16_t get_es(void)
+static inline u16 get_es(void)
 {
-	uint16_t es;
+	u16 es;
 
 	__asm__ __volatile__("mov %%es, %[es]"
 			     : /* output */ [es]"=rm"(es));
 	return es;
 }
 
-static inline uint16_t get_cs(void)
+static inline u16 get_cs(void)
 {
-	uint16_t cs;
+	u16 cs;
 
 	__asm__ __volatile__("mov %%cs, %[cs]"
 			     : /* output */ [cs]"=rm"(cs));
 	return cs;
 }
 
-static inline uint16_t get_ss(void)
+static inline u16 get_ss(void)
 {
-	uint16_t ss;
+	u16 ss;
 
 	__asm__ __volatile__("mov %%ss, %[ss]"
 			     : /* output */ [ss]"=rm"(ss));
 	return ss;
 }
 
-static inline uint16_t get_ds(void)
+static inline u16 get_ds(void)
 {
-	uint16_t ds;
+	u16 ds;
 
 	__asm__ __volatile__("mov %%ds, %[ds]"
 			     : /* output */ [ds]"=rm"(ds));
 	return ds;
 }
 
-static inline uint16_t get_fs(void)
+static inline u16 get_fs(void)
 {
-	uint16_t fs;
+	u16 fs;
 
 	__asm__ __volatile__("mov %%fs, %[fs]"
 			     : /* output */ [fs]"=rm"(fs));
 	return fs;
 }
 
-static inline uint16_t get_gs(void)
+static inline u16 get_gs(void)
 {
-	uint16_t gs;
+	u16 gs;
 
 	__asm__ __volatile__("mov %%gs, %[gs]"
 			     : /* output */ [gs]"=rm"(gs));
 	return gs;
 }
 
-static inline uint16_t get_tr(void)
+static inline u16 get_tr(void)
 {
-	uint16_t tr;
+	u16 tr;
 
 	__asm__ __volatile__("str %[tr]"
 			     : /* output */ [tr]"=rm"(tr));
@@ -651,7 +651,7 @@ static inline struct desc_ptr get_idt(void)
 	return idt;
 }
 
-static inline void outl(uint16_t port, u32 value)
+static inline void outl(u16 port, u32 value)
 {
 	__asm__ __volatile__("outl %%eax, %%dx" : : "d"(port), "a"(value));
 }
@@ -1194,15 +1194,15 @@ struct ex_regs {
 };
 
 struct idt_entry {
-	uint16_t offset0;
-	uint16_t selector;
-	uint16_t ist : 3;
-	uint16_t : 5;
-	uint16_t type : 4;
-	uint16_t : 1;
-	uint16_t dpl : 2;
-	uint16_t p : 1;
-	uint16_t offset1;
+	u16 offset0;
+	u16 selector;
+	u16 ist : 3;
+	u16 : 5;
+	u16 type : 4;
+	u16 : 1;
+	u16 dpl : 2;
+	u16 p : 1;
+	u16 offset1;
 	u32 offset2; u32 reserved;
 };
 
diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index 551ad6c658aa..8d60aa81e27e 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -286,7 +286,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 		if (qualifier == 'l')
 			num = va_arg(args, u64);
 		else if (qualifier == 'h') {
-			num = (uint16_t)va_arg(args, int);
+			num = (u16)va_arg(args, int);
 			if (flags & SIGN)
 				num = (int16_t)num;
 		} else if (flags & SIGN)
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index dc31236b004b..8e6393384fa4 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -424,7 +424,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 		"addr         w exec dirty\n",
 		indent, "");
 	pml4e_start = (u64 *)addr_gpa2hva(vm, mmu->pgd);
-	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
+	for (u16 n1 = 0; n1 <= 0x1ffu; n1++) {
 		pml4e = &pml4e_start[n1];
 		if (!is_present_pte(mmu, pml4e))
 			continue;
@@ -436,7 +436,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 			is_writable_pte(mmu, pml4e), is_nx_pte(mmu, pml4e));
 
 		pdpe_start = addr_gpa2hva(vm, *pml4e & PHYSICAL_PAGE_MASK);
-		for (uint16_t n2 = 0; n2 <= 0x1ffu; n2++) {
+		for (u16 n2 = 0; n2 <= 0x1ffu; n2++) {
 			pdpe = &pdpe_start[n2];
 			if (!is_present_pte(mmu, pdpe))
 				continue;
@@ -449,7 +449,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 				is_nx_pte(mmu, pdpe));
 
 			pde_start = addr_gpa2hva(vm, *pdpe & PHYSICAL_PAGE_MASK);
-			for (uint16_t n3 = 0; n3 <= 0x1ffu; n3++) {
+			for (u16 n3 = 0; n3 <= 0x1ffu; n3++) {
 				pde = &pde_start[n3];
 				if (!is_present_pte(mmu, pde))
 					continue;
@@ -461,7 +461,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 					is_nx_pte(mmu, pde));
 
 				pte_start = addr_gpa2hva(vm, *pde & PHYSICAL_PAGE_MASK);
-				for (uint16_t n4 = 0; n4 <= 0x1ffu; n4++) {
+				for (u16 n4 = 0; n4 <= 0x1ffu; n4++) {
 					pte = &pte_start[n4];
 					if (!is_present_pte(mmu, pte))
 						continue;
diff --git a/tools/testing/selftests/kvm/lib/x86/ucall.c b/tools/testing/selftests/kvm/lib/x86/ucall.c
index 1af2a6880cdf..e7dd5791959b 100644
--- a/tools/testing/selftests/kvm/lib/x86/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86/ucall.c
@@ -6,7 +6,7 @@
  */
 #include "kvm_util.h"
 
-#define UCALL_PIO_PORT ((uint16_t)0x1000)
+#define UCALL_PIO_PORT ((u16)0x1000)
 
 void ucall_arch_do_ucall(gva_t uc)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 73b7faa7f357..b2f83c3f7f16 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -27,7 +27,7 @@ struct hv_vp_assist_page *current_vp_assist;
 
 int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 {
-	uint16_t evmcs_ver;
+	u16 evmcs_ver;
 
 	vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENLIGHTENED_VMCS,
 			(unsigned long)&evmcs_ver);
diff --git a/tools/testing/selftests/kvm/s390/memop.c b/tools/testing/selftests/kvm/s390/memop.c
index 1cd7b8f81fff..aa92fdf0664d 100644
--- a/tools/testing/selftests/kvm/s390/memop.c
+++ b/tools/testing/selftests/kvm/s390/memop.c
@@ -485,7 +485,7 @@ static __uint128_t cut_to_size(int size, __uint128_t val)
 	case 1:
 		return (uint8_t)val;
 	case 2:
-		return (uint16_t)val;
+		return (u16)val;
 	case 4:
 		return (u32)val;
 	case 8:
diff --git a/tools/testing/selftests/kvm/x86/fastops_test.c b/tools/testing/selftests/kvm/x86/fastops_test.c
index a634bc281546..721f56d38f49 100644
--- a/tools/testing/selftests/kvm/x86/fastops_test.c
+++ b/tools/testing/selftests/kvm/x86/fastops_test.c
@@ -186,7 +186,7 @@ if (sizeof(type_t) != 1) {							\
 static void guest_code(void)
 {
 	guest_test_fastops(uint8_t, "b");
-	guest_test_fastops(uint16_t, "w");
+	guest_test_fastops(u16, "w");
 	guest_test_fastops(u32, "l");
 	guest_test_fastops(u64, "q");
 
diff --git a/tools/testing/selftests/kvm/x86/sync_regs_test.c b/tools/testing/selftests/kvm/x86/sync_regs_test.c
index 8fa3948b0170..e0c52321f87c 100644
--- a/tools/testing/selftests/kvm/x86/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86/sync_regs_test.c
@@ -20,7 +20,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define UCALL_PIO_PORT ((uint16_t)0x1000)
+#define UCALL_PIO_PORT ((u16)0x1000)
 
 struct ucall uc_none = {
 	.cmd = UCALL_NONE,
-- 
2.54.0.rc1.555.g9c883467ad-goog

