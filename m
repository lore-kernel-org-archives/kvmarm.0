Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0009E486B8F
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933221; cv=none; b=JYMF9iIvJ6q49QEQ2dMidegDU0fk3uBwx7Sa3S1UP0CtxEVmsPlb5REa49iWvgpqNwsVv2x6Dp2qim6JU+635RDhrfn3ahbRPbA1lAEhnFNPD55iff3uvw3V8J/VXiavBI0fVPi+nIep5XWwkrDYakiFxJwXvo7f/UcH/ZYnYvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933221; c=relaxed/simple;
	bh=mCIoZuoMY+IBAKdDMsYQQIR91MDw4b5hVFEekbjU484=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2DOFwC6wDuI4K8Xfp0IGAGYGm5sceYhAJ5DtQ+BrilB0H3zjBEz14lKaFXep2ETqKGwggZkXvZDNBIzWG9FTwsHlnWgwhgfG18M+vAScFr4IGdRR/afNPOIr8mUJjxUjh7rzWAQBVg/E4Dy4LnxpFIYFo4uTnVJwNQk1Hq8Nuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=OEJCSWyo; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="OEJCSWyo"
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab20f4bso2224169d50.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933218; x=1790538018; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EGHl9G2Q8EmXvEbGL4UYBvGbfn4j1FoYD4wdklwyMj4=;
        b=OEJCSWyoM5g0f59nrEH/uPVV1s8UBkOOqtDgh900q5+0bvUySc/I50I9aM5etQM5q4
         3kh+kvSFWmoNqaLbt8gp2iMzvg4gd+0FkNo803baA2Sdq6HnNkJ+5YMkVr+SvB7sNM/l
         2iGIiuNeBiQUqEtxoGhzcl2lDqSpPc7MHS+ZUwRGXGx0SsKvIodqa06i7ggWi2bPJsFv
         3MISW4st9Kfy5kkyxyMfXTj54EnEzBrnUeG3yF9F+4muJksSuGOikL82Pa9K+tPVjnvz
         exe+NlA+XKqRga9GizAHt6R12zWW/F92UKyjkUsXImA33ri9u/OF7VIbBw5BKbLgi3wc
         l19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933218; x=1790538018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=EGHl9G2Q8EmXvEbGL4UYBvGbfn4j1FoYD4wdklwyMj4=;
        b=ZG12oZtYnQhS/qsq7WEIwtcz83FVBp8abG8u0YTRcuhLEou8v3RqZW5NuM2jQd2HF7
         hSsP6gV+9faLEiLdtUpwmIHEl+wsAK2y2UhsOTGxRtJRB8zv6TGqa6iI1xZ5oW5ZSUPm
         ZV/uS257gN4iZHJW7sI9m7Cc0MyTToWYmcnWeacZ+YfscgfXbdK6xGaF1dVeC/yTs7UE
         +yC0k26098hNGUskEqsl6ND9Vh/qL7RkrSyFSPq5iXnFtwAsBHXCKaAJE4s4rd1FrrLF
         Tr1bedajqv5rlEHiS7EtL1jNFpp//YxTEkq5FsAQjYjMVscFI7OlrsN3ved3ElUe849L
         Dg+A==
X-Forwarded-Encrypted: i=1; AKwUvBwI7rcfEt4mBMh1E9AnkWsr17/03GRmKmRU+kW9VqWADzqc+/t1PA4+KkUNmbSnlrFkMNKEoUI=@lists.linux.dev
X-Gm-Message-State: AFuF++n8vXO4wDMajIRHUtjdjUqSwuZj/ZOlldi+0spVPngN29myqLLI
	ecQoandZJYSmk0wDWJin9/bIpBsJf0DJmILr2tM35HD3sZ0U8ZQ9MIac0eOAVe1HhZc=
X-Gm-Gg: AYBFou3oVjHtdF1DF2wB1P9jZwHkQd/5/xpLXoaj0MB+ARUvEwvu0KTp2WzwQeJrQsd
	1dbkHBwv3hv9tDYHrtB9WgnufGY4jOv8cxg4v6w8+/B0ZvlkfcqS6hc+p80pPnKRo3CyqL4zZxr
	XIGVi4vr8nHNwN84Cnc0srZhD08PHgGIdyQGI3+GBIwb6lGLGsgQtouujat7z8MDMB2ghNrt9kd
	U92YuJL5Y0RpESBviU70wXSs+3jevSKlCjnEFJlkKjyEx4iBqesuOLBQAFnxwuuwRQUoeScHRmK
	JxAJsWL2EZADpyKE7pHwXBNRDwYWh+oXKc4muihPBudBJ5n7DUk6rPYm8J4ZgOmEfERTzZRfpQM
	339sBdUPLhDMGa8gCfySIONbnRzDEko0GC5dPAKB6cHr43H8jhfGeXMt/LIUXhQH5ABycMfkSLY
	5JleNpDtsEUluu0d3HnBhbng/EABmQY19LnecvX5N0SXVOUCt3/fEfffMbSEo2mNdXPaUreGiyL
	pFGmyCnpJj5wjFdP6NC8e+Q0rZPM4TCJFxxV9rrLxvJ59U81FLve9X/M7BCcKuL7igMMp7yQf4L
	3I0RaGUnBkmapcJey8Rthc1pIbYaDg==
X-Received: by 2002:a05:690e:12c4:b0:672:99e0:ebda with SMTP id 956f58d0204a3-67299e0ee4emr1603719d50.114.1789933217886;
        Sun, 20 Sep 2026 12:40:17 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a45d8fb9asm18884327b3.17.2026.09.20.12.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:16 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 34/46] KVM: x86: Implement Caretaker LAPIC timer and interrupt injection
Date: Sun, 20 Sep 2026 15:36:38 -0400
Message-ID: <20260920193650.3373435-35-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement standalone Caretaker LAPIC timer deadline programming and
interrupt injection helpers in arch/x86/kvm/caretaker.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/caretaker.c | 312 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 312 insertions(+)
 create mode 100644 arch/x86/kvm/caretaker.c

diff --git a/arch/x86/kvm/caretaker.c b/arch/x86/kvm/caretaker.c
new file mode 100644
index 000000000000..9e0f20cbb137
--- /dev/null
+++ b/arch/x86/kvm/caretaker.c
@@ -0,0 +1,312 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * x86 KVM Caretaker execution loop and hardware virtualization attachment.
+ */
+
+#include <linux/cpu.h>
+#include <linux/cpu_preserve.h>
+#include <linux/delay.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/oncore.h>
+#include <linux/smp.h>
+#include <uapi/linux/serial_reg.h>
+
+#include <asm/apic.h>
+#include <asm/cpu_entry_area.h>
+#include <linux/cpu_preserve.h>
+#include <asm/desc.h>
+#include <asm/fpu/api.h>
+#include <asm/fixmap.h>
+#include <asm/irq_vectors.h>
+#include <linux/kvm_host.h>
+#include <asm/msr.h>
+#include <linux/sync_core.h>
+#include <asm/trapnr.h>
+#include <asm/virt.h>
+
+#include "caretaker.h"
+#include "cpuid.h"
+#include "lapic.h"
+#include "regs.h"
+#include "x86.h"
+
+/* Host register state saved around an on-core caretaker run. */
+struct caretaker_x86_host_state {
+	struct desc_ptr orig_idt;
+	unsigned long orig_cr2;
+	unsigned long orig_fs_base;
+	unsigned long orig_gs_base;
+	unsigned long orig_kernel_gs_base;
+	u64 orig_star;
+	u64 orig_lstar;
+	u64 orig_fmask;
+};
+
+/* Defined below their first use. */
+static void kvm_x86_caretaker_save_gprs(struct kvm_vcpu *vcpu, u64 *gprs);
+static void kvm_x86_caretaker_init_idt(gate_desc *idt);
+static void kvm_x86_caretaker_init_gdt_tss(struct desc_struct *gdt,
+					   struct x86_hw_tss *tss,
+					   unsigned long stack_top);
+
+/*
+ * A preserved page is handed over by physical address.  The SME/SEV C-bit is
+ * an encryption attribute, not part of the address, so strip it before
+ * forming a kernel virtual address.
+ *
+ * Both helpers are __always_inline because callers live in
+ * __cpu_preserved_text: an out-of-line copy would sit outside the section
+ * that survives the kexec.
+ */
+static __always_inline void *caretaker_pa_to_va(u64 pa)
+{
+	return phys_to_virt(__sme_clr(pa));
+}
+
+/* The control block is embedded in the vendor-agnostic caretaker page. */
+static __always_inline struct caretaker_x86_page *
+cxp_from_cb(struct kvm_caretaker_cb_ser *cb)
+{
+	return container_of(cb, struct caretaker_x86_page, abi.cb);
+}
+
+static const struct kvm_x86_caretaker_ops *kvm_x86_caretaker_ops __cpu_preserved_data;
+
+void kvm_x86_caretaker_register_ops(const struct kvm_x86_caretaker_ops *ops)
+{
+	WRITE_ONCE(kvm_x86_caretaker_ops, ops);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_register_ops);
+
+void kvm_x86_caretaker_unregister_ops(const struct kvm_x86_caretaker_ops *ops)
+{
+	if (kvm_x86_caretaker_ops == ops)
+		WRITE_ONCE(kvm_x86_caretaker_ops, NULL);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_unregister_ops);
+
+static bool caretaker_x86_has_tsc_deadline __cpu_preserved_data;
+static u32 caretaker_x86_lapic_timer_period __cpu_preserved_data;
+static u32 caretaker_x86_tsc_khz __cpu_preserved_data;
+gate_desc caretaker_x86_idt[IDT_ENTRIES] __caretaker_data __aligned(16);
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(caretaker_x86_idt);
+static bool caretaker_x86_idt_initialized;
+
+static void kvm_x86_caretaker_init_uart(struct caretaker_uart *uart)
+{
+	if (!uart)
+		return;
+
+	uart->lcr = UART_LCR_WLEN8;
+	uart->ier = 0x00;
+	uart->mcr = UART_MCR_DTR | UART_MCR_RTS;
+	uart->scr = 0x00;
+	uart->dll = 0x01;
+	uart->dlm = 0x00;
+}
+
+int kvm_x86_caretaker_preserve_page(struct kvm_caretaker_arch_ser *abi,
+				    struct page *page)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(abi->nr_preserved_pages >= KVM_X86_CARETAKER_MAX_PAGES))
+		return -ENOSPC;
+
+	ret = kho_preserve_pages(page, 1);
+	if (ret)
+		return ret;
+
+	abi->preserved_pages_pa[abi->nr_preserved_pages++] = page_to_phys(page);
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_preserve_page);
+
+void kvm_x86_caretaker_unpreserve_pages(struct kvm_caretaker_arch_ser *abi)
+{
+	u32 i;
+
+	for (i = 0; i < abi->nr_preserved_pages; i++)
+		kho_unpreserve_pages(phys_to_page(__sme_clr(abi->preserved_pages_pa[i])), 1);
+	abi->nr_preserved_pages = 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_unpreserve_pages);
+
+int kvm_x86_caretaker_init_common_page(struct caretaker_x86_page *cxp,
+				       struct kvm_vcpu *vcpu,
+				       size_t full_page_size)
+{
+	struct oncore_session *sess;
+	phys_addr_t pgd_pa;
+	u32 apic_id;
+	int pcpu;
+	int ret;
+
+	if (!cxp || !vcpu)
+		return -EINVAL;
+
+	caretaker_x86_has_tsc_deadline = boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER);
+	caretaker_x86_lapic_timer_period = lapic_timer_period;
+	caretaker_x86_tsc_khz = tsc_khz;
+	cpu_preserved_clean(&caretaker_x86_has_tsc_deadline);
+	cpu_preserved_clean(&caretaker_x86_lapic_timer_period);
+	cpu_preserved_clean(&caretaker_x86_tsc_khz);
+	if (!caretaker_x86_idt_initialized) {
+		kvm_x86_caretaker_init_idt(caretaker_x86_idt);
+		cpu_preserved_clean_sz(caretaker_x86_idt, sizeof(caretaker_x86_idt));
+		caretaker_x86_idt_initialized = true;
+	}
+
+	memset(cxp, 0, full_page_size);
+
+	kvm_caretaker_init_common_vcpu(&cxp->vcpu, &cxp->abi.cb, vcpu, cxp,
+				       full_page_size, NULL, cxp);
+
+	pcpu = cxp->abi.cb.pcpu_id;
+
+	apic_id = apic->cpu_present_to_apicid(pcpu);
+	if (apic_id == BAD_APICID)
+		apic_id = pcpu;
+	cxp->abi.apic_id = apic_id;
+
+	kvm_x86_caretaker_init_uart(&cxp->uart);
+
+	cxp->save_guest_fpu = boot_cpu_has(X86_FEATURE_XSAVE) &&
+			      !fpstate_is_confidential(&vcpu->arch.guest_fpu);
+
+	/* Capture guest GPRs */
+	kvm_x86_caretaker_save_gprs(vcpu, &cxp->rax);
+
+	/* Preserved CR3 from session or fallback to global cpu_preserve page table */
+	sess = oncore_job_session(vcpu->caretaker.job);
+	pgd_pa = oncore_session_get_pgd_pa(sess);
+	cxp->host_cr3 = pgd_pa ? pgd_pa : x86_caretaker_pgd_pa;
+	cxp->cr3 = kvm_read_cr3(vcpu);
+	cxp->cr0 = kvm_read_cr0(vcpu);
+	cxp->cr4 = kvm_read_cr4(vcpu);
+	cxp->efer = vcpu->arch.efer;
+
+	/* Build KHO-preserved Host GDT and TSS */
+	kvm_x86_caretaker_init_gdt_tss(cxp->gdt, &cxp->tss,
+				       (unsigned long)&cxp->stack[CXP_STACK_SIZE]);
+
+	/* Preserve in-kernel local APIC register page across kexec */
+	if (vcpu->arch.apic && vcpu->arch.apic->regs) {
+		ret = kvm_x86_caretaker_preserve_page(&cxp->abi,
+						      virt_to_page(vcpu->arch.apic->regs));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_init_common_page);
+
+static void kvm_x86_caretaker_save_gprs(struct kvm_vcpu *vcpu, u64 *gprs)
+{
+	gprs[0]  = kvm_register_read_raw(vcpu, VCPU_REGS_RAX);
+	gprs[1]  = kvm_register_read_raw(vcpu, VCPU_REGS_RBX);
+	gprs[2]  = kvm_register_read_raw(vcpu, VCPU_REGS_RCX);
+	gprs[3]  = kvm_register_read_raw(vcpu, VCPU_REGS_RDX);
+	gprs[4]  = kvm_register_read_raw(vcpu, VCPU_REGS_RSI);
+	gprs[5]  = kvm_register_read_raw(vcpu, VCPU_REGS_RDI);
+	gprs[6]  = kvm_register_read_raw(vcpu, VCPU_REGS_RBP);
+	gprs[7]  = kvm_register_read_raw(vcpu, VCPU_REGS_R8);
+	gprs[8]  = kvm_register_read_raw(vcpu, VCPU_REGS_R9);
+	gprs[9]  = kvm_register_read_raw(vcpu, VCPU_REGS_R10);
+	gprs[10] = kvm_register_read_raw(vcpu, VCPU_REGS_R11);
+	gprs[11] = kvm_register_read_raw(vcpu, VCPU_REGS_R12);
+	gprs[12] = kvm_register_read_raw(vcpu, VCPU_REGS_R13);
+	gprs[13] = kvm_register_read_raw(vcpu, VCPU_REGS_R14);
+	gprs[14] = kvm_register_read_raw(vcpu, VCPU_REGS_R15);
+}
+
+static void kvm_x86_caretaker_init_idt(gate_desc *idt)
+{
+	int v;
+
+	for (v = 0; v < IDT_ENTRIES; v++) {
+		bool has_err = (v == X86_TRAP_DF ||
+				(v >= X86_TRAP_TS && v <= X86_TRAP_PF) ||
+				v == X86_TRAP_AC || v == X86_TRAP_CP ||
+				v == X86_TRAP_VC || v == 30);
+		unsigned long handler = (v >= FIRST_EXTERNAL_VECTOR) ?
+			(unsigned long)&x86_preserved_apic_eoi_stub :
+			(has_err ? (unsigned long)&x86_preserved_iret_err_stub :
+				   (unsigned long)&x86_preserved_iret_stub);
+
+		pack_gate(&idt[v], GATE_INTERRUPT, handler, 0, 0, __KERNEL_CS);
+	}
+}
+
+static void kvm_x86_caretaker_init_gdt_tss(struct desc_struct *gdt,
+					   struct x86_hw_tss *tss,
+					   unsigned long stack_top)
+{
+	int k;
+
+	memcpy(gdt, get_current_gdt_ro(), sizeof(struct desc_struct) * GDT_ENTRIES);
+	memset(tss, 0, sizeof(*tss));
+	tss->sp0 = stack_top;
+	tss->io_bitmap_base = sizeof(*tss);
+	for (k = 0; k < ARRAY_SIZE(tss->ist); k++)
+		tss->ist[k] = stack_top;
+
+	caretaker_set_tss_desc(gdt, (unsigned long)tss, sizeof(struct x86_hw_tss) - 1);
+}
+
+__caretaker_text void kvm_x86_caretaker_arm_timer(u64 deadline_ticks)
+{
+	if (!deadline_ticks)
+		return;
+
+	if (caretaker_x86_has_tsc_deadline) {
+		u32 lvtt = LOCAL_TIMER_VECTOR | APIC_LVT_TIMER_TSCDEADLINE;
+
+		native_wrmsrq(APIC_BASE_MSR + (APIC_LVTT >> 4), lvtt);
+		native_wrmsrq(MSR_IA32_TSC_DEADLINE, deadline_ticks);
+	} else {
+		u64 now = rdtsc();
+		u64 delta_tsc = (deadline_ticks > now) ? (deadline_ticks - now) : 1;
+		u32 lvtt = LOCAL_TIMER_VECTOR;
+		u64 count;
+
+		if (caretaker_x86_tsc_khz != 0 && caretaker_x86_lapic_timer_period != 0) {
+			u64 period = caretaker_x86_lapic_timer_period;
+			u64 apic_khz = (period * HZ) / 1000ULL;
+
+			count = (delta_tsc * apic_khz) /
+				((u64)caretaker_x86_tsc_khz * 16ULL);
+		} else {
+			count = delta_tsc >> 4;
+		}
+		if (count == 0)
+			count = 1;
+		if (count > U32_MAX)
+			count = U32_MAX;
+
+		native_wrmsrq(APIC_BASE_MSR + (APIC_TDCR >> 4),
+			      APIC_TDR_DIV_16);
+		native_wrmsrq(APIC_BASE_MSR + (APIC_LVTT >> 4), lvtt);
+		native_wrmsrq(APIC_BASE_MSR + (APIC_TMICT >> 4), (u32)count);
+	}
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_arm_timer);
+
+__caretaker_text void kvm_x86_caretaker_disarm_timer(void)
+{
+	if (caretaker_x86_has_tsc_deadline)
+		native_wrmsrq(MSR_IA32_TSC_DEADLINE, 0);
+	else
+		native_wrmsrq(APIC_BASE_MSR + (APIC_TMICT >> 4), 0);
+
+	native_wrmsrq(APIC_BASE_MSR + (APIC_LVTT >> 4),
+		      APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_x86_caretaker_disarm_timer);
+
-- 
2.55.0.1082.g2b9226bbc0-goog

