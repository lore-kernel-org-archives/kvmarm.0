Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC4FC4167B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67C1B23B45
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67C1B23B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 177224B2D1;
	Wed,  9 Dec 2020 08:18:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uf0lzpj2jExP; Wed,  9 Dec 2020 08:18:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8AF54B2EF;
	Wed,  9 Dec 2020 08:18:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F69F4B2F6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:18:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P5B9GsFimdmW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:18:05 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E45584B2F9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:18:03 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id r7so1708598wrc.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=AnSc1Sgxbdzkn7VrpHIozks65PIKCh74xA+FbntzNXY=;
 b=fV0IqsCKJt3ivo+aspsTCn4tySosMb+82n5RnA2sAYTUUnT7GT1fshweSpCBAReyj/
 2SoMtQDPP3FnvvJAKFaqDKH5dcWNHZqK/CZL7MGg9dFP7zD8KCf5PZ2a6BBcicj977Ou
 0zgxnB/Skz+GAbr34KDFIGm1SWSVJpJ4mJqz8BgANsF6kW6dH0nSYakL6ykDEUf64EjV
 KnZWuetkZ8TvwYngLljRR9HKZHMH6bIxtjytbs5/EALMbZ/N/nU5gn7BWB3n4tc72taH
 T4YeQt7WHrQgQmEdBWJY/V/9Ypebzu9I3VWoWfG9dWXZ4KSomVBQkPfeyuxeCJJ1U/Cq
 1mEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=AnSc1Sgxbdzkn7VrpHIozks65PIKCh74xA+FbntzNXY=;
 b=Dt2E4E4T2V88NtVKu13TCzjsQunSLpe5I9tFttKRdJ9+R7Xdakz/bQDQAeowhwbLee
 7V2XRBaRDxZTJFc8ebzRXHw3vBTWmRvcT1fG++/KyXo8Yri1q7SojfNMLJMJ7bQuvN6Z
 shfFGOpjjyVqlngKye7a0/qHnbzHFItloChZXOu/qnQKWlyNQG2egRmd+FBLk9VmX4zW
 v7OrB7rnBm+oRLME0KuQxa/9K0+A0biLN+F9BARj5M3tbxZ0tIL5GiCAJdoDMmuCp5XD
 GwTfkSzJGxKhNETlT+90NJCR0XWPDKzYNqMZp0krGoGb01YJrrCnsMNvLhkkFTfl0I/7
 YJOA==
X-Gm-Message-State: AOAM532CQRoe25U0dJaOCXS4VzFTPzMQV9bKU81qF36BnIEOQAewFmF6
 07iHtxqWC0fB4WcZ/phDyrdVEsM0ugJuww==
X-Google-Smtp-Source: ABdhPJyFNsrtiECMYekEKiA3Vo/iG+G5NK6FdhcQmRaR2bdsDNr4G07R9LSXaBa+5xVT0OnDyzSXRw==
X-Received: by 2002:adf:97ce:: with SMTP id t14mr2716349wrb.368.1607519882606; 
 Wed, 09 Dec 2020 05:18:02 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id k11sm3202279wmj.42.2020.12.09.05.18.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 05:18:01 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 6/9] KVM: arm64: Apply hyp relocations at runtime
Date: Wed,  9 Dec 2020 13:17:43 +0000
Message-Id: <20201209131746.85622-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209131746.85622-1-dbrazdil@google.com>
References: <20201209131746.85622-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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
 arch/arm64/configs/defconfig      |  1 +
 arch/arm64/include/asm/kvm_mmu.h  |  1 +
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/smp.c           |  4 +++-
 arch/arm64/kvm/va_layout.c        | 28 ++++++++++++++++++++++++++++
 5 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 5cfe3cf6f2ac..73fc9f2f2661 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1092,3 +1092,4 @@ CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_PREEMPT is not set
 # CONFIG_FTRACE is not set
 CONFIG_MEMTEST=y
+# CONFIG_ARM64_VHE is not set
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
index 18e9727d3f64..47142395bc91 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -434,8 +434,10 @@ static void __init hyp_mode_check(void)
 			   "CPU: CPUs started in inconsistent modes");
 	else
 		pr_info("CPU: All CPU(s) started at EL1\n");
-	if (IS_ENABLED(CONFIG_KVM))
+	if (IS_ENABLED(CONFIG_KVM)) {
 		kvm_compute_layout();
+		kvm_apply_hyp_relocations();
+	}
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index d8cc51bd60bf..fb2ca02b7270 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -82,6 +82,34 @@ __init void kvm_compute_layout(void)
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
+	int32_t *begin = (int32_t*)__hyp_reloc_begin;
+	int32_t *end = (int32_t*)__hyp_reloc_end;
+
+	for (rel = begin; rel < end; ++rel) {
+		uintptr_t *ptr, kimg_va;
+
+		/*
+		 * Each entry contains a 32-bit relative offset from itself
+		 * to a kimg VA position.
+		 */
+		ptr = (uintptr_t*)lm_alias((char*)rel + *rel);
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
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
