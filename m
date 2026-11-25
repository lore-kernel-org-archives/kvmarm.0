Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587407;
	b=kRJ2BdOrd51934WbhAbC6+9Iwaum6FsrcdfFAkY+hc9bwigEXCecuy3Kcr8siDoWMLIu
	 TLfY4osdgdLHnvYOeTEwiMR3BoxPyeYC5v1iALNScAmkvo/KqkqnVKz6k23l+IO9lgLYN
	 +zE53XlbuguPmKWe/b+DynvrNBt7k32OorFdoYAKbSu2JpqCPkq6sTTGgcOibRe9I2pFV
	 8iuAE95tw4NCFbC18VAumBXJFR5RHE6P3l5v4MVAINbpx4Bas6X2XFXDDXXMhmi7b/4I2
	 SjkdfXNS0ScfsA2umSrFvYDOcDaeEcyK2oDfIj0g6y0o3KYa2b/cSdyqnUDPNO0WVeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587407;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=opbvbiqLtMKnZidmW1akDPMoAVRaFGJF5QXg9EIzgwM=;
	b=dIwKjsvm1nyrHPd7ppJtYRRSDqmeA/zwkksoAO4mTqaBBPQr+bphRcqYvXwJGgox+acN
	 uWWLl71KJTS8VNPth+NwMrX8Jr7emp332GTxJBmglM9dCIRQQvFFOabhF1g6UpvBj7WLZ
	 mj3jxf1qRGp9+O4+a2lGzVauBIhh9f+SKGacKQeL964weD2L1fl4oRHV7Q6JselEgyjgA
	 Qi3OXBH5jPGlFv7M8h41ssY/HA9HWLS+o5f0kIWZ/DzSS3ePI1Nc9pOtQ5Sl3Usjx7Ir0
	 5WBrBaeJNTesQX3xBSCW18qTtxAcr3hnBaomMNxpQiGf6UcWre1E8hEcQM5/7A+04QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Lv24EYny;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A412D606C83A
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A412D606C83A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Lv24EYny
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4fb73e868aaso5726467b6e.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587406; x=1796192206; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=opbvbiqLtMKnZidmW1akDPMoAVRaFGJF5QXg9EIzgwM=;
        b=Lv24EYny3QwiZKifkyP03og603ySdKDeyHN3Wf4dcIk01Fnd/L403pX7qObGFgPBU9
         OYvwYqs+zqlCpeCz8KcnM65jAMRiPvvXn3C4wa36Z5MkPJ2z7verBxnCSe/sJt+Wh+Q9
         BP3fRcMcgvhFJyb3vYp0obWHEKCr2YbzPR3zxbv0CxUHXJF/2iTt8ohmy5VJBYdg75KK
         JpPToOLWB7Ty4OOfE7vS0yg6xYhykJ0Df7ZmiC994dr6a/J/Ms7fDQu04xmGv0gt8x8+
         9tUK1VsspMSphsB00rofd9YPwnaQQxvIbhPCsscCr3njoDqcVJt76IxMz6VRh3zUqkl/
         3M2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587406; x=1796192206;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=opbvbiqLtMKnZidmW1akDPMoAVRaFGJF5QXg9EIzgwM=;
        b=kqx3ZsXZhDse5CvPBwo+bYfi2SqKlfswz+k9pxUnwLVfFefINHuHnmGbuIsaHe4KQf
         uyzqDono4BXCeN/t/zqkq5JNeRRx+LHlRFvtY5rKRD2gL7fXpMJ7Zi0gSP3GCUJXJ8Eb
         pqxchpdbtiB9Ug/0bT+rNE/OqUkzafVCTGFybiemgL0JF16OWCzPnlpGqi+Rrh4AzFNI
         +yHyXIt/8Ox4Ig+Rpf4hkxDxyiy6FlULEYxceviJDYkmp0uY3m2iYkdhcOpupbzzXDKI
         iQa4QKh2CzFcsLUaYyWvlqvnG4eaMfGiwvoKtW3j+jrlo5/V27/J3+P1pTKVIn5hmE0G
         8CtQ==
X-Forwarded-Encrypted: i=1; AL+hErH1GzpjyduuAJSTpVD0lJEgpkgS6cRS7LfdjjxvsX2SKhnjwcotbPN6k61MPXX8oB0O/gdp3Eg=@lists.linux.dev
X-Gm-Message-State: APuU4Z/HLgQotfZGmq9O+bJtAuhne/TT/p8oFPP5dmQQoFP2Oq3gAqvo
	ExybRz3ZNYZyaIDL6VXg8kcJ/I2KWeEEPD5fa4nriwW01li2cVn5ox/+E+qg6L5/p5H/KRUkOTU
	D0bEhMbQDFQ==
X-Received: from oigu20-n1.prod.google.com ([2002:a05:6809:5d4:10b0:4f5:740:2bcf])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:319b:b0:4f5:eaac:5173
 with SMTP id 5614622812f47-57a0b84fa3dmr15864618b6e.57.1795587405164; Tue, 24
 Nov 2026 22:16:45 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:17 -0800
In-Reply-To: <20261125061523.1540234-1-irogers@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261125061523.1540234-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261125061523.1540234-25-irogers@google.com>
Subject: [RFC PATCH v2 24/30] tools headers: Add linux/unwind_dwarf_cfi.h copy
 from the kernel sources
From: Ian Rogers <irogers@google.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org, 
	linux-kbuild@vger.kernel.org, ojeda@kernel.org, 
	rust-for-linux@vger.kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, 
	wnliu@google.com, dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Copy include/linux/unwind_dwarf_cfi.h to
tools/include/linux/unwind_dwarf_cfi.h for host unwinding verification
tools under tools/, and add it to tools/perf/check-headers.sh.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/include/linux/unwind_dwarf_cfi.h | 181 +++++++++++++++++++++++++
 tools/perf/check-headers.sh            |   1 +
 2 files changed, 182 insertions(+)
 create mode 100644 tools/include/linux/unwind_dwarf_cfi.h

diff --git a/tools/include/linux/unwind_dwarf_cfi.h b/tools/include/linux/unwind_dwarf_cfi.h
new file mode 100644
index 000000000000..3530794c8543
--- /dev/null
+++ b/tools/include/linux/unwind_dwarf_cfi.h
@@ -0,0 +1,181 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MIT */
+#ifndef _LINUX_UNWIND_DWARF_CFI_H
+#define _LINUX_UNWIND_DWARF_CFI_H
+
+#include <linux/types.h>
+
+/*
+ * Minimal DWARF Call Frame Information (CFI) unwinder subset.
+ *
+ * Evaluates a strictly bounded, non-Turing-complete subset of .eh_frame and
+ * .eh_frame_hdr tables matching SFrame's stack-unwinding state model (plus
+ * fixed-pattern DRAP stack-realignment and signal-frame expressions):
+ *  - Advances PC monotonically through a single FDE (no backward jumps)
+ *  - Tracks CFA = (SP | FP | scratch) + cfa_off or *(FP/SP + cfa_off)
+ *  - Tracks stack save offsets for SP, FP, and RA (ignoring callee-saved GPR
+ *    spills)
+ *  - Rejects general DWARF expressions, register-to-register rules on SP/FP/RA,
+ *    and DW_EH_PE_indirect FDE/table pointer encodings (skipping CIE
+ *    personality and LSDA fields without dereferencing).
+ */
+
+/* Hard safety bounds enforced on CIE/FDE lengths, offsets, and state stack */
+#define DWARF_CFI_MAX_CIE_LEN		128U
+#define DWARF_CFI_MAX_FDE_LEN		4096U
+#define DWARF_CFI_MAX_CIE_DELTA		(64U * 1024U * 1024U)
+#define DWARF_CFI_MAX_FDE_COUNT		(4U * 1024U * 1024U)
+#define DWARF_CFI_MAX_STATE_STACK	4U
+
+/**
+ * enum dwarf_cfi_base - Base register or addressing mode for computing the CFA
+ * @DWARF_CFI_BASE_UNDEFINED: CFA rule has not been established yet.
+ * @DWARF_CFI_BASE_SP: CFA = stack pointer + cfa_off.
+ * @DWARF_CFI_BASE_FP: CFA = frame pointer + cfa_off.
+ * @DWARF_CFI_BASE_FP_INDIRECT: DRAP stack realignment: CFA = *(FP + cfa_off).
+ * @DWARF_CFI_BASE_SP_INDIRECT: Signal trampoline frame: CFA = *(SP + cfa_off).
+ * @DWARF_CFI_BASE_REG: Transient prologue/epilogue scratch register:
+ *                      CFA = reg(cfa_reg) + cfa_off.
+ */
+enum dwarf_cfi_base {
+	DWARF_CFI_BASE_UNDEFINED = 0,
+	DWARF_CFI_BASE_SP,
+	DWARF_CFI_BASE_FP,
+	DWARF_CFI_BASE_FP_INDIRECT,
+	DWARF_CFI_BASE_SP_INDIRECT,
+	DWARF_CFI_BASE_REG,
+};
+
+/**
+ * enum dwarf_cfi_rule - Recovery rule for caller's SP, FP, or return address
+ * @DWARF_CFI_RULE_SAME: Register retains its value from the current frame
+ *                       (or defaults to CFA for SP).
+ * @DWARF_CFI_RULE_OFFSET: Saved on the stack at *(CFA + off).
+ * @DWARF_CFI_RULE_FP_OFFSET: Saved relative to FP at *(FP + off) (DRAP frame).
+ * @DWARF_CFI_RULE_SP_OFFSET: Saved relative to SP at *(SP + off) (sigframe).
+ * @DWARF_CFI_RULE_UNDEFINED: Explicitly undefined (DW_CFA_undefined); marks
+ *                            the bottom of a stack (e.g. _start or clone).
+ */
+enum dwarf_cfi_rule {
+	DWARF_CFI_RULE_SAME = 0,
+	DWARF_CFI_RULE_OFFSET,
+	DWARF_CFI_RULE_FP_OFFSET,
+	DWARF_CFI_RULE_SP_OFFSET,
+	DWARF_CFI_RULE_UNDEFINED,
+};
+
+/**
+ * struct dwarf_cfi_arch - Architecture DWARF register numbers and word size
+ * @ws: Target address/word size in bytes (4 or 8).
+ * @sp_reg: DWARF register number for the stack pointer.
+ * @fp_reg: DWARF register number for the frame pointer.
+ * @ra_reg: Default DWARF return-address column number.
+ */
+struct dwarf_cfi_arch {
+	u8 ws;
+	u8 sp_reg;
+	u8 fp_reg;
+	u8 ra_reg;
+};
+
+/**
+ * struct dwarf_cfi_row - Evaluated Minimal DWARF unwind state at a target PC
+ * @cfa_off: Byte offset added to the CFA base register before or as the CFA.
+ * @sp_off: Byte offset used to load the saved SP when @sp_rule is an offset.
+ * @fp_off: Byte offset used to load the saved FP when @fp_rule is an offset.
+ * @ra_off: Byte offset used to load the saved RA when @ra_rule is an offset.
+ * @cfa_base: CFA computation mode (&enum dwarf_cfi_base).
+ * @cfa_reg: DWARF register number when @cfa_base is %DWARF_CFI_BASE_REG.
+ * @sp_rule: Recovery rule for the stack pointer (&enum dwarf_cfi_rule;
+ *           %DWARF_CFI_RULE_SAME indicates caller SP equals CFA).
+ * @fp_rule: Recovery rule for the frame pointer (&enum dwarf_cfi_rule).
+ * @ra_rule: Recovery rule for the return address (&enum dwarf_cfi_rule).
+ * @signal: True if the CIE carries the 'S' signal/interrupt frame augmentation,
+ *          indicating that the saved PC points directly to the interrupted
+ *          instruction rather than after a call instruction.
+ * @ra_signed: True on AArch64 when DW_CFA_AARCH64_negate_ra_state indicates
+ *             that the saved return address carries a PAC signature.
+ */
+struct dwarf_cfi_row {
+	s32 cfa_off;
+	s32 sp_off;
+	s32 fp_off;
+	s32 ra_off;
+	u8 cfa_base;
+	u8 cfa_reg;
+	u8 sp_rule;
+	u8 fp_rule;
+	u8 ra_rule;
+	bool signal;
+	bool ra_signed;
+};
+
+/**
+ * struct eh_frame_hdr_entry - Binary-search index entry for an FDE
+ * @start_off: Signed 32-bit offset from the table base (or entry field) to the
+ *             FDE's initial PC location.
+ * @fde_off: Signed 32-bit offset from the table base (or entry field) to the
+ *           start of the FDE record in .eh_frame.
+ */
+struct eh_frame_hdr_entry {
+	s32 start_off;
+	s32 fde_off;
+};
+
+#ifdef CONFIG_UNWIND_DWARF_CFI
+
+extern const u8 __start_eh_frame_hdr[];
+extern const u8 __stop_eh_frame_hdr[];
+extern const u8 __start_eh_frame[];
+extern const u8 __stop_eh_frame[];
+
+int dwarf_cfi_eval_fde_kmem(const u8 *fde, const u8 *eh_start,
+			    const u8 *eh_end, unsigned long pc,
+			    const struct dwarf_cfi_arch *arch,
+			    struct dwarf_cfi_row *out_row);
+
+int dwarf_cfi_unwind_eh_frame_hdr(const u8 *hdr, size_t hdr_size,
+				  const u8 *eh_start, const u8 *eh_end,
+				  unsigned long pc,
+				  const struct dwarf_cfi_arch *arch,
+				  struct dwarf_cfi_row *out_row);
+
+int dwarf_cfi_scan_eh_frame_kmem(const u8 *eh_start, size_t eh_size,
+				 const struct dwarf_cfi_arch *arch,
+				 unsigned long base_addr,
+				 struct eh_frame_hdr_entry *entries,
+				 unsigned int max_entries,
+				 unsigned int *out_count);
+
+int dwarf_cfi_unwind_user_eh_frame_hdr(unsigned long hdr_uaddr,
+				       size_t hdr_size, unsigned long pc,
+				       const struct dwarf_cfi_arch *arch,
+				       struct dwarf_cfi_row *out_row);
+
+#if defined(CONFIG_UNWINDER_DWARF_CFI) && defined(CONFIG_MODULES)
+/**
+ * struct mod_dwarf_cfi_index - Sorted FDE lookup table for a loadable module
+ * @num_fdes: Number of sorted FDE index entries in @entries.
+ * @eh_frame: Pointer to the module's in-memory SHF_ALLOC .eh_frame section;
+ *            also serves as the base address for @entries offsets.
+ * @eh_frame_size: Size in bytes of the module's .eh_frame section.
+ * @entries: Sorted binary-search table mapping PCs to module FDEs.
+ */
+struct mod_dwarf_cfi_index {
+	unsigned int num_fdes;
+	const u8 *eh_frame;
+	size_t eh_frame_size;
+	struct eh_frame_hdr_entry entries[] __counted_by(num_fdes);
+};
+
+struct mod_dwarf_cfi_index *dwarf_cfi_mod_alloc(const void *eh_frame,
+						size_t eh_frame_size,
+						const struct dwarf_cfi_arch *arch);
+void dwarf_cfi_mod_free_rcu(struct mod_dwarf_cfi_index *idx);
+int dwarf_cfi_mod_eval(const struct mod_dwarf_cfi_index *idx, unsigned long ip,
+		       const struct dwarf_cfi_arch *arch,
+		       struct dwarf_cfi_row *out_row);
+#endif
+
+#endif /* CONFIG_UNWIND_DWARF_CFI */
+
+#endif /* _LINUX_UNWIND_DWARF_CFI_H */
diff --git a/tools/perf/check-headers.sh b/tools/perf/check-headers.sh
index 3e684c851a86..1b1bd04a6690 100755
--- a/tools/perf/check-headers.sh
+++ b/tools/perf/check-headers.sh
@@ -30,6 +30,7 @@ declare -a FILES=(
   "include/linux/hash.h"
   "include/linux/kmsan-checks.h"
   "include/linux/list-sort.h"
+  "include/linux/unwind_dwarf_cfi.h"
   "include/uapi/linux/hw_breakpoint.h"
   "arch/x86/include/asm/cpufeatures.h"
   "arch/x86/include/asm/inat_types.h"
-- 
2.56.1.831.g720f3f5937-goog

