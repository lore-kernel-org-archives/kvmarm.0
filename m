Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8337E2701C4
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 00:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548171; cv=none; b=c5Lppb26/WOe06ocf6+uwbG5iVZWhRdl8S9xDdjYqLhNlaZVKUJPFzvPkVVbh8yCW5gZiyYelUGlbQ4o0Rct23H6X3sNW6Y3HLKjwPcjQld9Jh381sod/gRD4kxWvFg/eWsVGhKvMfgJ8MEq5ZPmTq3KQz+4CiMs0VqViEkkwJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548171; c=relaxed/simple;
	bh=cxF5mDnBbKFncuxIyYSfFoeE0lVsVPvqSqGW586Icpk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NYnnp2TCcg4k2oFtZJuSacHUxJIjP6aPc/d0OdB5Tv2ikK1nkgp7t2AHn/HTp2w2mBHkRFCAme0Dd5id8s6UDkNBIA/kQ6X3vQShMGk8gBPzNj2Y939RsRZygom0yinuVomj3ubNq1zEFUAfpz8xXkGdoUkW+tKKy7h0Rq7Jkuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N0zWx5nP; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N0zWx5nP"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a8c273332cso120227835ad.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 16:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548168; x=1772152968; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CF2RTlbmNq4Owf7ZHfECBb44vd1V9sy9uH51YmRnrYk=;
        b=N0zWx5nPaO/fU4rTiFO/5UdIP68FxOysLVxxmRuzz4G7V4+SPJJoismWj+mhF/2MO1
         Rw/O9Z2KCOeyNRhuVHNKc0XhjmEvoXGETr2Dsbshrw4zS6HXtDjgGGXOR8gOMyPdB7OS
         xrf3YCd24L2uHEinGmuUmQ27Z/eFrtjbMb05BCCwAf0xX/IbTXqWhsmRTXTMxcECSVF7
         kvEZcygC4hABP3rcLeGOcSfVGYjtz6bishowAB3DdJqoCuC0Q00Ii/mb2SjFb/ky9x5Q
         2jUbjFX2QT4wRoiY+8W9mKfGl4KYfqRJRv/UHPK6DeJ2VbOZ2e9nPJwmjymAAU/txOnL
         WLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548168; x=1772152968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CF2RTlbmNq4Owf7ZHfECBb44vd1V9sy9uH51YmRnrYk=;
        b=Q3ZKjbR5KgbUwcee2g7Eei4rHOfm9X9EpmUYl6+bdX9IQQzrZdnz1amxMyuOdDCwbD
         TdvSTSY6NNfNkGqAOB3Wlc/TM58s/vl8UaukoM22K3CsYR10tk4XNQLnU8OHZ7V16tXl
         sD4HPr0mb7kON+rr3BjmoQpKYlgLrEASpxxhMD0ud3EwrOwudHMsrz/wIXEhvAIYwz52
         w6Wfr+7XfrdPiRJxv0zZ/n4HBJZ99Q2fTKa/zvee7Ts7BTiGc/zSBkDm9nFUZVbxqG7n
         sHcmlZTBcIssJMAz5u1V3fDPYFk4zKnDbcYVdLNrA2g1jikn2iXEDQbgeotZUUS2z3Wf
         fmSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrfcVh5mTK9Np0SPh/ScfypWiJviCOpouB3ysWLdQuXrzedij7CQxicTIwncs/VB7wf7q4tRA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfJcqDsJRG9NpClrjB1/CA7M3ocmYxAIPvr7Grzr3sE59j9yk8
	R0yvHb2l99y34NXl6kLbzdcCVX/vZLzHS1S+fCfYWVz7t5ByfbeuCO4yH+4iyDjOVVFMAboAg4s
	Rtl0oIAN//ER/wA==
X-Received: from plbjf22.prod.google.com ([2002:a17:903:2696:b0:2ab:8fb:be81])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d50a:b0:2a9:4c2:e47 with SMTP id d9443c01a7336-2ad1759d351mr217116655ad.56.1771548167497;
 Thu, 19 Feb 2026 16:42:47 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:21 +0000
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-9-dmatlack@google.com>
Subject: [PATCH v2 08/10] KVM: selftests: Use u16 instead of uint16_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Use u16 instead of uint16_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/uint16_t/u16/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
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
index e928673dafd2..fef4373313bd 100644
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
index 71c43a66be78..716398e487a2 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -397,8 +397,8 @@ struct gpr64_regs {
 };
 
 struct desc64 {
-	uint16_t limit0;
-	uint16_t base0;
+	u16 limit0;
+	u16 base0;
 	unsigned base1:8, type:4, s:1, dpl:2, p:1;
 	unsigned limit1:4, avl:1, l:1, db:1, g:1, base2:8;
 	u32 base3;
@@ -406,7 +406,7 @@ struct desc64 {
 } __attribute__((packed));
 
 struct desc_ptr {
-	uint16_t size;
+	u16 size;
 	u64 address;
 } __attribute__((packed));
 
@@ -474,9 +474,9 @@ static inline void wrmsr(u32 msr, u64 value)
 }
 
 
-static inline uint16_t inw(uint16_t port)
+static inline u16 inw(u16 port)
 {
-	uint16_t tmp;
+	u16 tmp;
 
 	__asm__ __volatile__("in %%dx, %%ax"
 		: /* output */ "=a" (tmp)
@@ -485,63 +485,63 @@ static inline uint16_t inw(uint16_t port)
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
@@ -626,7 +626,7 @@ static inline struct desc_ptr get_idt(void)
 	return idt;
 }
 
-static inline void outl(uint16_t port, u32 value)
+static inline void outl(u16 port, u32 value)
 {
 	__asm__ __volatile__("outl %%eax, %%dx" : : "d"(port), "a"(value));
 }
@@ -1164,15 +1164,15 @@ struct ex_regs {
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
index 65523a2740b7..0d9dc255d857 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -421,7 +421,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 		"addr         w exec dirty\n",
 		indent, "");
 	pml4e_start = (u64 *)addr_gpa2hva(vm, mmu->pgd);
-	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
+	for (u16 n1 = 0; n1 <= 0x1ffu; n1++) {
 		pml4e = &pml4e_start[n1];
 		if (!is_present_pte(mmu, pml4e))
 			continue;
@@ -433,7 +433,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 			is_writable_pte(mmu, pml4e), is_nx_pte(mmu, pml4e));
 
 		pdpe_start = addr_gpa2hva(vm, *pml4e & PHYSICAL_PAGE_MASK);
-		for (uint16_t n2 = 0; n2 <= 0x1ffu; n2++) {
+		for (u16 n2 = 0; n2 <= 0x1ffu; n2++) {
 			pdpe = &pdpe_start[n2];
 			if (!is_present_pte(mmu, pdpe))
 				continue;
@@ -446,7 +446,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 				is_nx_pte(mmu, pdpe));
 
 			pde_start = addr_gpa2hva(vm, *pdpe & PHYSICAL_PAGE_MASK);
-			for (uint16_t n3 = 0; n3 <= 0x1ffu; n3++) {
+			for (u16 n3 = 0; n3 <= 0x1ffu; n3++) {
 				pde = &pde_start[n3];
 				if (!is_present_pte(mmu, pde))
 					continue;
@@ -458,7 +458,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
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
index 068937005417..516aa8c37f01 100644
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
index fc640f3c5176..2283ad346746 100644
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
2.53.0.414.gf7e9f6c205-goog

