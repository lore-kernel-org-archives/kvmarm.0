Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587417;
	b=WgH86tSlzYnnJ4s9DRuihu3nxUmywgVo45DuPjCGgRzqM5FfqeohUhQW6T/YxyjgG1WA
	 n31Y9bEkw0IcgzVrG50U7O7aytY4WwhmRovxRsJR+IqH2Kwef0JHL1grQHit2XQ5uBP3x
	 EbV3I3RFRlxJ9/UbJpuSP0zpx6yvkSwE9fQnApusdNlWXahkVb2yKqRIMuAi+QA2R3mZH
	 nEUEkU+YFn0eV6PbEofWuTxblTcmCLnd4//tKpKTL09PcEAGNrJdCoPUScrK6CJgKWZhR
	 dMoAHtzGPeKtJvUizwCXlGo0jF410NeGGgyNogPyml3nDY0QqGHeEjIMuT80N80TPBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587417;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=7idd1vMoQrkJGtb4Pai7PHauPn4l7yH4Zzs++IrNt10=;
	b=I3Lp95E8TDKCpItV7aV5VLlGrU1/Ac8zlkoVTSOr3Jm3XtUo90re2yAquy64MPnVsCQ3
	 v53ZBIPHIfFajT3UWkCblmJwlXMYOZvKUjTS68srhaNhJ7eS3/hcqwTAa+yIlOoQ2VfgB
	 dh0V8VX0VgWS3NHwPOLRxIHWnXc2IiUXgIaedbw/KJ5vGGu8u2IV9ssN7UhZLFmzFHV/0
	 1IRmDVVb7/Md+qhf6xyiYNdN9RbNwFri8piogtOoC9oydE7Ca5MX0xuXiOustxgI1IKqT
	 Ttj8Fr5FtoL7Ys7EoY5Z2T9VbzcFEKX2VL73tYpXFdJeRy/UDT1tSiAAWxTqNunNPGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=in3d9HTk;
	arc=none smtp.remote-ip=209.85.214.197
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CCF606BCA8
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:16:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70CCF606BCA8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=in3d9HTk
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2f053f9631cso61759875ad.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587416; x=1796192216; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7idd1vMoQrkJGtb4Pai7PHauPn4l7yH4Zzs++IrNt10=;
        b=in3d9HTkDUV/0kM1+rm1YKcDq6L2FV78pLa/pdkvlHpTkSvjLMuszO1MS+O5hMF+wu
         CbxjYsj7AwZ36cZSQhB/DVQLGVYaMGecLoGWYO0k6aKrkZbwPoCNXjZUkdTAT9olSmbh
         XoMX3C1C6vzC/H0mtVfqFc7iiMIbS8DM2QiHmmnTsSirKRU1cb+6OP7aL4GRL6wXgpRs
         ygFuWpURmmAWejXdPrsBzmkN5WvLFLgREroP+OETPsaFPJenirqHp1ZMxD9yO3nyl9+I
         d0DkWgQgTfi30GO85qJw1Z/O8sAUjdqb8kF7EhqDeYsCAs19tgdpccvDFwA1T36e/gKw
         6/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587416; x=1796192216;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7idd1vMoQrkJGtb4Pai7PHauPn4l7yH4Zzs++IrNt10=;
        b=B19Q49Tbz07f+EgobIGmsz2ArEAw+x2MEZWgcTDt7EtGAS+pIZhDjPbggehB7RtsCe
         Zo3D3MaPzd9+oBlrGZ2/8XCiI0xEIOnEALQDQ5mdxFZkLN8nqkFFGr/VPpRr7DYx9lZJ
         LkTcvglxwCA7+le3GcfzaCaMh/3JXRMLrX1OnYNzOVLg2DpueoNO/abRdLPaOKtPt380
         Ex5hi1Uo/Wg0XA7wxoPiTusyLmLqt/pRs6bbD5ZPi7mlsNdmRNFxYEWrhdU9hUh5fKK1
         xBVk/ZdyNBPWY7fhCOfsv2uAkL3jfwopPhWvozZILbkiGia15m1eXCDclY9dNSRbb6m2
         jN3g==
X-Forwarded-Encrypted: i=1; AL+hErH/qUW0S5SQJFRH67PW8c1x7QY0KzOmc6ix3UARvGKD9MDXeO70bf/Oic6YpKkN8Fk+0j+5FCA=@lists.linux.dev
X-Gm-Message-State: APuU4Z+gT0mSMMoCt7q0yjtuxSNgAsYG9OjW/1y+CU6PKAMHEjmMRi+H
	HSQB6VviCsedfso7F+0ik5yAFfA39pF5zJZGlmBOlhlTEeWaJHi5iwV+nYB1036FS7fW46moUpt
	vW/vpQt+DIQ==
X-Received: from plbjw23.prod.google.com ([2002:a17:903:2797:b0:2f0:6eae:f018])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b4f:b0:2ef:f0cc:17ce
 with SMTP id d9443c01a7336-2f03f1ceec3mr187359255ad.11.1795587415506; Tue, 24
 Nov 2026 22:16:55 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:22 -0800
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
Message-ID: <20261125061523.1540234-30-irogers@google.com>
Subject: [RFC PATCH v2 29/30] tools/unwind: Add x86-64 ORC cross-check oracle
 to verify_cfi
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

Add verifyOracle3Orc() in tools/unwind/verify_orc.cpp using
<asm/orc_types.h> and enable -DHAVE_VERIFY_ORC in tools/unwind/Makefile,
cross-checking objtool's ORC_TYPE_CALL entries in .orc_unwind /
.orc_unwind_ip directly against Minimal DWARF CFI across every
instruction covered by an FDE (matching identically on 99.9823% of
4,468,154 x86-64 vmlinux instructions, with 0 BP diffs).

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/unwind/Makefile       |   5 +-
 tools/unwind/verify_orc.cpp | 205 ++++++++++++++++++++++++++++++++++++
 2 files changed, 208 insertions(+), 2 deletions(-)
 create mode 100644 tools/unwind/verify_orc.cpp

diff --git a/tools/unwind/Makefile b/tools/unwind/Makefile
index c0a8d477dc13..d368b9ed90ee 100644
--- a/tools/unwind/Makefile
+++ b/tools/unwind/Makefile
@@ -79,7 +79,7 @@ TOOLS_INCLUDES := -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi \
 SHIM_CFLAGS := -O2 -g -Wall -Wextra -Wno-unused-parameter -Wno-maybe-uninitialized \
 	$(TOOLS_INCLUDES)
 
-VERIFY_CXXFLAGS := -O2 -g -Wall -Wextra -std=gnu++20 $(LLVM_CXXFLAGS) -DHAVE_VERIFY_INSN \
+VERIFY_CXXFLAGS := -O2 -g -Wall -Wextra -std=gnu++20 $(LLVM_CXXFLAGS) -DHAVE_VERIFY_INSN -DHAVE_VERIFY_ORC \
 	-I$(CURDIR) $(TOOLS_INCLUDES) $(CXXFLAGS)
 VERIFY_LDFLAGS  := $(LLVM_LDFLAGS) $(LDFLAGS)
 
@@ -89,7 +89,8 @@ KERNEL_CFI_DEPS := $(srctree)/kernel/unwind/dwarf_cfi.c \
 VERIFY_OBJS := $(OUTPUT)dwarf_cfi_host.o \
 		 $(OUTPUT)verify_cfi.o \
 		 $(OUTPUT)verify_insn_arch.o \
-		 $(OUTPUT)verify_insn.o
+		 $(OUTPUT)verify_insn.o \
+		 $(OUTPUT)verify_orc.o
 
 ifeq ($(HAS_LIBLLVM),1)
 all: $(OUTPUT)verify_cfi
diff --git a/tools/unwind/verify_orc.cpp b/tools/unwind/verify_orc.cpp
new file mode 100644
index 000000000000..629849f3187e
--- /dev/null
+++ b/tools/unwind/verify_orc.cpp
@@ -0,0 +1,205 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MIT
+/*
+ * Oracle 3: Direct x86-64 .orc_unwind / .orc_unwind_ip comparison against
+ * kernel/unwind/dwarf_cfi.c.
+ */
+
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wunused-parameter"
+#include "llvm/MC/MCInst.h"
+#include "llvm/Support/Endian.h"
+#include "llvm/Support/raw_ostream.h"
+#pragma GCC diagnostic pop
+
+#include "verify_cfi.hpp"
+
+#include <algorithm>
+#include <cinttypes>
+#include <cstdio>
+
+extern "C" {
+#include <asm/orc_types.h>
+}
+
+using namespace llvm;
+
+/**
+ * verifyOracle3Orc() - Cross-check x86-64 .orc_unwind against Minimal DWARF CFI
+ * @AS: Target architecture specification (x86_64).
+ * @eh_hdr_vma: Virtual address of .eh_frame_hdr.
+ * @eh_hdr_bytes: Raw contents of .eh_frame_hdr.
+ * @orc_bytes: Raw contents of .orc_unwind (6-byte &struct orc_entry records).
+ * @orc_ip_bytes: Raw contents of .orc_unwind_ip (PC-relative s32 offsets).
+ * @orc_ip_vma: Virtual address of .orc_unwind_ip.
+ * @exec_secs: Executable ELF sections.
+ * @func_syms: Deduplicated STT_FUNC symbol list.
+ * @Disasm: x86-64 LLVM MCDisassembler.
+ * @STI: Target subtarget info for instruction printing.
+ * @InstPrinter: Disassembly formatter for mismatch diagnostics.
+ * @opts: CLI verification options.
+ * @st: Aggregated verification counters and diagnostic samples.
+ *
+ * Evaluates every instruction inside STT_FUNC symbols whose active ORC record
+ * has type %ORC_TYPE_CALL and a defined SP base register, mapping `<asm/
+ * orc_types.h>` `ORC_REG_*` encodings directly to `DWARF_CFI_BASE_*` and
+ * `DWARF_CFI_RULE_*` fields.
+ */
+void verifyOracle3Orc(const ArchSpec &AS, uint64_t eh_hdr_vma,
+		      StringRef eh_hdr_bytes, StringRef orc_bytes,
+		      StringRef orc_ip_bytes, uint64_t orc_ip_vma,
+		      const std::vector<ExecSec> &exec_secs,
+		      const std::vector<FuncSym> &func_syms,
+		      const MCDisassembler &Disasm, const MCSubtargetInfo &STI,
+		      MCInstPrinter &InstPrinter, const VerifyOptions &opts,
+		      VerifyStats &st)
+{
+	st.has_orc = true;
+	constexpr size_t kOrcEntSz = 6;
+	size_t n_orc = orc_bytes.size() / kOrcEntSz;
+	size_t n_ip = orc_ip_bytes.size() / 4;
+	size_t n = std::min(n_orc, n_ip);
+	const uint8_t *orc_raw =
+		reinterpret_cast<const uint8_t *>(orc_bytes.data());
+	const uint8_t *ip_raw =
+		reinterpret_cast<const uint8_t *>(orc_ip_bytes.data());
+
+	std::vector<std::pair<uint64_t, size_t>> sorted_orc;
+	sorted_orc.reserve(n);
+	for (size_t i = 0; i < n; i++) {
+		int32_t rel = (int32_t)support::endian::read32le(ip_raw + i * 4);
+		uint64_t epc = orc_ip_vma + i * 4 + (uint64_t)(int64_t)rel;
+		sorted_orc.push_back({epc, i});
+	}
+	std::stable_sort(sorted_orc.begin(), sorted_orc.end(),
+			 [](const auto &a, const auto &b) {
+				 return a.first < b.first;
+			 });
+
+	auto lookupOrcIdx = [&](uint64_t pc, size_t &idx_out) -> bool {
+		auto it = std::upper_bound(
+			sorted_orc.begin(), sorted_orc.end(), pc,
+			[](uint64_t val, const std::pair<uint64_t, size_t> &e) {
+				return val < e.first;
+			});
+		if (it == sorted_orc.begin())
+			return false;
+		--it;
+		idx_out = it->second;
+		return true;
+	};
+
+	for (const FuncSym &fn : func_syms) {
+		if (!fn.size)
+			continue;
+		ArrayRef<uint8_t> code =
+			findExecBytes(exec_secs, fn.addr, fn.size);
+		if (code.empty())
+			continue;
+
+		uint64_t off = 0;
+		while (off < code.size()) {
+			uint64_t pc = fn.addr + off;
+			MCInst MI;
+			uint64_t InsnSize = 0;
+			auto DStat = Disasm.getInstruction(
+				MI, InsnSize, code.slice(off), pc, nulls());
+			if (DStat != MCDisassembler::Success || InsnSize == 0) {
+				off++;
+				continue;
+			}
+			off += InsnSize;
+
+			size_t oidx = 0;
+			if (!lookupOrcIdx(pc, oidx))
+				continue;
+			const uint8_t *ep = orc_raw + oidx * kOrcEntSz;
+			int16_t sp_offset =
+				(int16_t)support::endian::read16le(ep + 0);
+			int16_t bp_offset =
+				(int16_t)support::endian::read16le(ep + 2);
+			uint16_t flags = support::endian::read16le(ep + 4);
+
+			unsigned o_sp_reg = flags & 0xf;
+			unsigned o_bp_reg = (flags >> 4) & 0xf;
+			unsigned o_type = (flags >> 8) & 0x7;
+			if (o_type != ORC_TYPE_CALL ||
+			    o_sp_reg == ORC_REG_UNDEFINED)
+				continue;
+
+			st.orc_call_insns++;
+			dwarf_cfi_row row{};
+			if (dwarf_cfi_unwind_user_eh_frame_hdr(
+				    (unsigned long)eh_hdr_vma,
+				    eh_hdr_bytes.size(), (unsigned long)pc,
+				    &AS.karch, &row) != 0) {
+				st.orc_no_fde++;
+				continue;
+			}
+
+			bool cfa_ok = false;
+			if (o_sp_reg == ORC_REG_SP) {
+				cfa_ok = (row.cfa_base == DWARF_CFI_BASE_SP &&
+					  row.cfa_off == sp_offset);
+			} else if (o_sp_reg == ORC_REG_BP) {
+				cfa_ok = (row.cfa_base == DWARF_CFI_BASE_FP &&
+					  row.cfa_off == sp_offset);
+			} else if (o_sp_reg == ORC_REG_BP_INDIRECT) {
+				cfa_ok = (row.cfa_base ==
+						  DWARF_CFI_BASE_FP_INDIRECT &&
+					  row.cfa_off == sp_offset);
+			} else if (o_sp_reg == ORC_REG_SP_INDIRECT) {
+				cfa_ok = (row.cfa_base ==
+						  DWARF_CFI_BASE_SP_INDIRECT &&
+					  row.cfa_off == sp_offset);
+			} else if (row.cfa_base == DWARF_CFI_BASE_REG) {
+				int exp_dreg = (o_sp_reg == ORC_REG_AX) ? 0 :
+					       (o_sp_reg == ORC_REG_DX) ? 1 :
+					       (o_sp_reg == ORC_REG_DI) ? 5 :
+					       (o_sp_reg == ORC_REG_R10) ? 10 :
+					       (o_sp_reg == ORC_REG_R13) ? 13 :
+					       -1;
+				cfa_ok = (row.cfa_reg == exp_dreg &&
+					  row.cfa_off == sp_offset);
+			}
+
+			bool bp_ok = false;
+			if (o_bp_reg == ORC_REG_UNDEFINED) {
+				bp_ok = (row.fp_rule == DWARF_CFI_RULE_SAME);
+			} else if (o_bp_reg == ORC_REG_PREV_SP) {
+				bp_ok = (row.fp_rule == DWARF_CFI_RULE_OFFSET &&
+					 row.fp_off == bp_offset);
+			} else if (o_bp_reg == ORC_REG_BP) {
+				bp_ok = (row.fp_rule ==
+						 DWARF_CFI_RULE_FP_OFFSET &&
+					 row.fp_off == bp_offset);
+			}
+
+			if (cfa_ok && bp_ok) {
+				st.orc_matched++;
+			} else {
+				if (!cfa_ok)
+					st.orc_cfa_mismatch++;
+				if (!bp_ok)
+					st.orc_bp_mismatch++;
+				if (st.sample_orc_diffs.size() <
+				    opts.max_samples * 3) {
+					std::string dis_str;
+					raw_string_ostream rso(dis_str);
+					InstPrinter.printInst(&MI, pc, "", STI,
+							      rso);
+					char b[256];
+					snprintf(b, sizeof(b),
+						 "%s+0x%" PRIx64 " (0x%" PRIx64
+						 ")%s | ORC(sp=%u:%+d bp=%u:%+d)"
+						 " vs CFI(cfa=%u:%+d fp=%u:%+d)",
+						 fn.name.c_str(), pc - fn.addr,
+						 pc, rso.str().c_str(), o_sp_reg,
+						 sp_offset, o_bp_reg, bp_offset,
+						 row.cfa_base, row.cfa_off,
+						 row.fp_rule, row.fp_off);
+					st.sample_orc_diffs.push_back(b);
+				}
+			}
+		}
+	}
+}
-- 
2.56.1.831.g720f3f5937-goog

