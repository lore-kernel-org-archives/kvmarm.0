Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBB4C433E6
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 722D222D5B
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 722D222D5B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213B84B37B;
	Tue,  5 Jan 2021 13:06:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nhc2Ey8MXXCR; Tue,  5 Jan 2021 13:06:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AAA54B385;
	Tue,  5 Jan 2021 13:06:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4791F4B275
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PsbRKkq-OWTU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 13:06:04 -0500 (EST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AED9B4B36E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:04 -0500 (EST)
Received: by mail-wm1-f42.google.com with SMTP id a6so372326wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 10:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Pc2HqS8Yp/wLLNaRLrMUR3bpLwxoED7DL6jFSybCHtA=;
 b=NwMXL8631Z29wz/JNQC2mtB4LPJnxvcjKGq1fr1Utl3B/GGEKRb7ZHDWdnK2lDw5OG
 oTGcvo+K1wBAfozKawQtmBjFACNet+HKha0Qo7Am+Xt+UPZrvXPm1z1sPj41KhE1h5Ug
 WmaaMwftJ0NVNgYijUiGGeb3AjPOwDa/YWo+G1T3FO3wElFKgEL0fjPr1o8VWSKO6rBq
 Xu/nCJ9b+yCkUV1HToIHqLt28Y2OL0eeR387sTRTPas+KNfZHE2LgJc5q6E3Bm8rfVsU
 qngV6mgx+Uf22eI8s9F/Gt2QpyXWUFeKXyuKk00UgPwt3HbqD6q9MVhb3GYu0KPD5gwx
 OchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Pc2HqS8Yp/wLLNaRLrMUR3bpLwxoED7DL6jFSybCHtA=;
 b=rs7Vn6BFE0gDGbSwo/NNXXeqej6ykNXN04v/nojp/yPQOz2dht7XJSbD/qXiLSn/S4
 9HwbqHREIkXYqTjpDD9D2L09F+pI0IegZIdNsGu93zNP+UOhVpoiILY3dIkktzbuzCxI
 rCKoTX6tWXGjE5CbqcWny6IEfIvcAiEbHJyVurdHzf9ZCQba6z5JkEx1U68XCjZA5oVo
 cVuQ/GJx5yLbKQGLsYeJ6HP6xSCimQpSTQXxNk5rD2NKT2fCwdEOnFxF648Ae+hsItVc
 N7ThkCLHbiwmjIsaDGF4cXMr06HJ0hCza5dfG9KK58sLAUrClNap4XyGm4ywWDQBPUK2
 5qRA==
X-Gm-Message-State: AOAM532s58LOOlrC6BsBU5hmLnj/yMsIhnDGX1HX+qUDS8OYK3d6r6MD
 0gK7Tx25pneUrc3uWpUSOHRJgDb1RVZNWA==
X-Google-Smtp-Source: ABdhPJyjQgiFG9pABukLWKZ9tumLI2zRT36ETVQba0ShHk4CrZoXSiXzaLRNRGji3/47FkuqoFLB5Q==
X-Received: by 2002:a1c:5644:: with SMTP id k65mr339701wmb.62.1609869963460;
 Tue, 05 Jan 2021 10:06:03 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:4957:71a5:7b5c:c94f])
 by smtp.gmail.com with ESMTPSA id a14sm767523wrn.3.2021.01.05.10.06.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Jan 2021 10:06:02 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 5/8] KVM: arm64: Apply hyp relocations at runtime
Date: Tue,  5 Jan 2021 18:05:38 +0000
Message-Id: <20210105180541.65031-6-dbrazdil@google.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105180541.65031-1-dbrazdil@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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
so far it avoided using absolute addressing because the VA in a constant
pool is relocated by the linker to a kernel VA (see hyp_symbol_addr).

Now the kernel has access to a list of positions that contain a kimg VA
but will be accessed only in hyp execution context. These are generated
by the gen-hyprel build-time tool and stored in .hyp.reloc.

Add early boot pass over the entries and convert the kimg VAs to hyp VAs.
Note that this requires for .hyp* ELF sections to be mapped read-write
at that point.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h  |  1 +
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/smp.c           |  4 +++-
 arch/arm64/kvm/va_layout.c        | 28 ++++++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e52d82aeadca..6bbb44011c84 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -129,6 +129,7 @@ alternative_cb_end
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
 void kvm_compute_layout(void);
+void kvm_apply_hyp_relocations(void);
 
 static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 {
diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index a6f3557d1ab2..2f36b16a5b5d 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -12,6 +12,7 @@ extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
 extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
 extern char __hyp_rodata_start[], __hyp_rodata_end[];
+extern char __hyp_reloc_begin[], __hyp_reloc_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index d08948c6979b..006f61a86438 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -434,8 +434,10 @@ static void __init hyp_mode_check(void)
 			   "CPU: CPUs started in inconsistent modes");
 	else
 		pr_info("CPU: All CPU(s) started at EL1\n");
-	if (IS_ENABLED(CONFIG_KVM) && !is_kernel_in_hyp_mode())
+	if (IS_ENABLED(CONFIG_KVM) && !is_kernel_in_hyp_mode()) {
 		kvm_compute_layout();
+		kvm_apply_hyp_relocations();
+	}
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 70fcd6a12fe1..fee7dcd95d73 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -81,6 +81,34 @@ __init void kvm_compute_layout(void)
 	init_hyp_physvirt_offset();
 }
 
+/*
+ * The .hyp.reloc ELF section contains a list of kimg positions that
+ * contains kimg VAs but will be accessed only in hyp execution context.
+ * Convert them to hyp VAs. See gen-hyprel.c for more details.
+ */
+__init void kvm_apply_hyp_relocations(void)
+{
+	int32_t *rel;
+	int32_t *begin = (int32_t *)__hyp_reloc_begin;
+	int32_t *end = (int32_t *)__hyp_reloc_end;
+
+	for (rel = begin; rel < end; ++rel) {
+		uintptr_t *ptr, kimg_va;
+
+		/*
+		 * Each entry contains a 32-bit relative offset from itself
+		 * to a kimg VA position.
+		 */
+		ptr = (uintptr_t *)lm_alias((char *)rel + *rel);
+
+		/* Read the kimg VA value at the relocation address. */
+		kimg_va = *ptr;
+
+		/* Convert to hyp VA and store back to the relocation address. */
+		*ptr = __early_kern_hyp_va((uintptr_t)lm_alias(kimg_va));
+	}
+}
+
 static u32 compute_instruction(int n, u32 rd, u32 rn)
 {
 	u32 insn = AARCH64_BREAK_FAULT;
-- 
2.29.2.729.g45daf8777d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
