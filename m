Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0735C63697
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:25:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C7B9246AA
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="VF2/Zvdb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C7B9246AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C15314B528;
	Thu, 19 Nov 2020 11:25:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xnU8i7m6mwXe; Thu, 19 Nov 2020 11:25:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 950B44B4AF;
	Thu, 19 Nov 2020 11:25:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 857AE4B3D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:25:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jpiHrWf6xP1o for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 11:25:54 -0500 (EST)
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com
 [209.85.218.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E94B4B2EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:25:54 -0500 (EST)
Received: by mail-ej1-f67.google.com with SMTP id f20so8745922ejz.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 08:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=TT/5iT0z6kx2joICZ1NAOPL4bFSWCCwquQqtGIEaOSE=;
 b=VF2/ZvdbNQRSshIgrCaZnLi+OohPfeVvaLrNMfYhzLvwIdDhd8kH2e7s3w8TeJhyJt
 lqiGFQq2fh2RuHE47qpHCqlUAPJnELkLqqFjbV1TAULxG1k3twib5U4GDLOVmUuFZdNE
 lV0AVoJiA3v/889w4eJeTYP0bfqNk3g2YfkQjD0TiZFzgKTDmksWN3EMIfxSf5W3hukh
 Vv+VXQfRXy4bqlxBRRGXxmbn9c6de8SL+IJSqGfQQUDMTTCNJK9rvgI4R+4KJESvTPH1
 pDOjgFd/mVA2LPoFBXWBoewdcHQ3fyYW6RTLEar9cm+xIjSM4pQJKTFkZq0Oxq4agZ9N
 C4oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=TT/5iT0z6kx2joICZ1NAOPL4bFSWCCwquQqtGIEaOSE=;
 b=hoMh/XG8WA2C5lu1VVGe9cswIuI846UodaKDgv9/uccw+cSJB0yL/dI1fHfOVJOGjA
 JhvGRgZ6C+ETekUzbamnziVGs01Ggz4aAL76qkAroqnMzTc8vfsj1XdaMdBd/wzHKCQY
 vKz3eFO3eiayywy23/6mDJ6Aikmt9P83W96mpXmyP7BfLg5los6/zz8ISXjRCXSDjB+P
 +eTSug/Tg3l1YsxEtis/mM1x7aPxfpUUYfQUmJbLHnWA9w1B7iLDedKpchD4hHeYKPaC
 dR0ukjo43f99e8pw3Vu6LLrg1vLaV1Ps6Y1qylsg7E9VwQdC3jeKbvqwTTA1DWmIgL28
 wN2g==
X-Gm-Message-State: AOAM532F1zxWw+o80CeromhiS7zBMNGeUp0H0uzd830yicYkKM//IpFQ
 WFdEobKL22gwAmMTQ/MGfhCC4Fvh6miIdw==
X-Google-Smtp-Source: ABdhPJwP/VVLCtMC4MEEj1Tf0BE9yqBQPNpM9ZeLFkujWHC85kdVBcEDsd4LiFcCh9qpW7yuGVSGQQ==
X-Received: by 2002:a17:906:b0d8:: with SMTP id
 bk24mr17537665ejb.113.1605803152633; 
 Thu, 19 Nov 2020 08:25:52 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9843:cd3f:f36b:d55c])
 by smtp.gmail.com with ESMTPSA id lu33sm73443ejb.49.2020.11.19.08.25.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 19 Nov 2020 08:25:51 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 2/6] kvm: arm64: Fix up RELA relocations in hyp code/data
Date: Thu, 19 Nov 2020 16:25:39 +0000
Message-Id: <20201119162543.78001-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119162543.78001-1-dbrazdil@google.com>
References: <20201119162543.78001-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

KVM nVHE code runs under a different VA mapping than the kernel, hence
so far it relied only on PC-relative addressing to avoid accidentally
using a relocated kernel VA from a constant pool (see hyp_symbol_addr).

So as to reduce the possibility of a programmer error, fixup the
relocated addresses instead. Let the kernel relocate them to kernel VA
first, but then iterate over them again, filter those that point to hyp
code/data and convert the kernel VA to hyp VA.

This is done after kvm_compute_layout and before apply_alternatives.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  1 +
 arch/arm64/kernel/smp.c          |  4 +-
 arch/arm64/kvm/va_layout.c       | 76 ++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 5168a0c516ae..e5226f7e4732 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -105,6 +105,7 @@ alternative_cb_end
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
 void kvm_compute_layout(void);
+void kvm_fixup_hyp_relocations(void);
 
 static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 {
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 18e9727d3f64..30241afc2c93 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -434,8 +434,10 @@ static void __init hyp_mode_check(void)
 			   "CPU: CPUs started in inconsistent modes");
 	else
 		pr_info("CPU: All CPU(s) started at EL1\n");
-	if (IS_ENABLED(CONFIG_KVM))
+	if (IS_ENABLED(CONFIG_KVM)) {
 		kvm_compute_layout();
+		kvm_fixup_hyp_relocations();
+	}
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index d8cc51bd60bf..b80fab974896 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -10,6 +10,7 @@
 #include <asm/alternative.h>
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
+#include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/memory.h>
 
@@ -82,6 +83,81 @@ __init void kvm_compute_layout(void)
 	init_hyp_physvirt_offset();
 }
 
+#define __load_elf_u64(s)					\
+	({							\
+		extern u64 s;					\
+		u64 val;					\
+								\
+		asm ("ldr %0, =%1" : "=r"(val) : "S"(&s));	\
+		val;						\
+	})
+
+static bool __is_within_bounds(u64 addr, char *start, char *end)
+{
+	return start <= (char*)addr && (char*)addr < end;
+}
+
+static bool __is_in_hyp_section(u64 addr)
+{
+	return __is_within_bounds(addr, __hyp_text_start, __hyp_text_end) ||
+	       __is_within_bounds(addr, __hyp_rodata_start, __hyp_rodata_end) ||
+	       __is_within_bounds(addr,
+				  CHOOSE_NVHE_SYM(__per_cpu_start),
+				  CHOOSE_NVHE_SYM(__per_cpu_end));
+}
+
+static void __fixup_hyp_rel(u64 addr)
+{
+	u64 *ptr, kern_va, hyp_va;
+
+	/* Adjust the relocation address taken from ELF for KASLR. */
+	addr += kaslr_offset();
+
+	/* Skip addresses not in any of the hyp sections. */
+	if (!__is_in_hyp_section(addr))
+		return;
+
+	/* Get the LM alias of the relocation address. */
+	ptr = (u64*)kvm_ksym_ref((void*)addr);
+
+	/*
+	 * Read the value at the relocation address. It has already been
+	 * relocated to the actual kernel kimg VA.
+	 */
+	kern_va = (u64)kvm_ksym_ref((void*)*ptr);
+
+	/* Convert to hyp VA. */
+	hyp_va = __early_kern_hyp_va(kern_va);
+
+	/* Store hyp VA at the relocation address. */
+	*ptr = __early_kern_hyp_va(kern_va);
+}
+
+static void __fixup_hyp_rela(void)
+{
+	Elf64_Rela *rel;
+	size_t i, n;
+
+	rel = (Elf64_Rela*)(kimage_vaddr + __load_elf_u64(__rela_offset));
+	n = __load_elf_u64(__rela_size) / sizeof(*rel);
+
+	for (i = 0; i < n; ++i)
+		__fixup_hyp_rel(rel[i].r_offset);
+}
+
+/*
+ * The kernel relocated pointers to kernel VA. Iterate over relocations in
+ * the hypervisor ELF sections and convert them to hyp VA. This avoids the
+ * need to only use PC-relative addressing in hyp.
+ */
+__init void kvm_fixup_hyp_relocations(void)
+{
+	if (!IS_ENABLED(CONFIG_RELOCATABLE) || has_vhe())
+		return;
+
+	__fixup_hyp_rela();
+}
+
 static u32 compute_instruction(int n, u32 rd, u32 rn)
 {
 	u32 insn = AARCH64_BREAK_FAULT;
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
