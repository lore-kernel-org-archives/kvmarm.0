Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C65C4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07F17222B9
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="lYaecYgi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07F17222B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC8784C25A;
	Mon, 16 Nov 2020 15:44:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a7tiMjSupFvO; Mon, 16 Nov 2020 15:44:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F0AA4C282;
	Mon, 16 Nov 2020 15:44:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D49464C25A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vkDCB2hxmQwi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:44:02 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEA3E4C27F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:00 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id s8so20252745wrw.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=1vh/ZyQWPccQlBaf9TiRx0Z2M+/9lMwlUGC5PwlE2iA=;
 b=lYaecYgiUsVh5Y29T3TA+aUzv2MBsym263hl7v7/lCIsYy/caQZPdpdPDwRun3GkVQ
 TibEno2QAgL5uGVeuMPYrhhkkwr03mY7fPYSeVkbxTaUfzAqdhHPmokaNPXImivnNQCH
 1e4MxfRd8KuJ8d9Rh83Mg1aQHNrCYYGSVoLDsZw0m+gnmtehTXh21pCK7K8z2USUdjyr
 eIAVkt9IfAXZl4ZRzVlgVQwmVP+MxCSvApzQmWgu5Fmjn/Mdv4Nf2cIZW+x88Q8FRESy
 1iTTnAUdmQzvgQHuJ/g6EZ7YT5cIPjXxfJnpaTBHkUaxmCGS1kVEKvD4sc6GjQ6h/ZFj
 lTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=1vh/ZyQWPccQlBaf9TiRx0Z2M+/9lMwlUGC5PwlE2iA=;
 b=mBI2lucInUR0hghhT1/Ynpe6r0r3t9MJKnzbJ8idQggaRqPu500hd7qomc4VLmfajt
 6IFBOnjb2GwEwZFh2pg9yuvgh5jX0BQ+aL0npZr0W6Ud22ZSOu1tSak363VcwKQHWOnE
 BHtzW+85Olq6mdS//m7OicMb51Rx/iYU0gO3YX8dKxQIm/TTmem8wL0Urtlxftoqi1sV
 JVw3seYglmYjNAloMJjG1BYrpd6ifWvKNxsBV+mg6ago2oX5G7R8kEHN1ho7FmErn8j+
 X5TCDoyhoVZl9tjJnldB4Nd8Z+6+KybqTQ5vHgs3/IdCAN1PywYhbykc5b350KBX8u23
 Z3jQ==
X-Gm-Message-State: AOAM530MaYQzmYXJ68Kqr+rkvIrAEw6Jl1n0dyynVsi80AnA04tG9LJN
 lwwoWsGMVixqrPY67jOEKqaYTOuP7VxEb3FT9h4=
X-Google-Smtp-Source: ABdhPJz+z6lHUZHhLRo8hPqDD5egPFyYy5Oa9Q7KVNb2Md2cVBffXmyb9o9Xy5q1uJzaghGQ8wBNnw==
X-Received: by 2002:adf:8366:: with SMTP id 93mr21195149wrd.321.1605559439365; 
 Mon, 16 Nov 2020 12:43:59 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id u14sm21439797wrq.93.2020.11.16.12.43.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:58 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 17/24] kvm: arm64: Add CPU entry point in nVHE hyp
Date: Mon, 16 Nov 2020 20:43:11 +0000
Message-Id: <20201116204318.63987-18-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

When nVHE hyp starts interception host's PSCI CPU_ON SMCs, it will need
to install KVM on the newly booted CPU before returning to the host. Add
an entry point which expects the same kvm_nvhe_init_params struct as the
__kvm_hyp_init HVC in the CPU_ON context argument (x0).

The entry point initializes EL2 state with the same init_el2_state macro
used by the kernel's entry point. It then initializes KVM using the same
helper function used in the __kvm_hyp_init HVC.

When done, the entry point branches to a function provided in the init
params.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kernel/asm-offsets.c    |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 32 ++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 01904e88cead..109867fb76f6 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -154,6 +154,7 @@ struct kvm_nvhe_init_params {
 	unsigned long tpidr_el2;
 	unsigned long vector_hyp_va;
 	unsigned long stack_hyp_va;
+	unsigned long entry_hyp_va;
 	phys_addr_t pgd_pa;
 };
 
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 4435ad8be938..9752100bf01f 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -113,6 +113,7 @@ int main(void)
   DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
   DEFINE(NVHE_INIT_VECTOR_HYP_VA,	offsetof(struct kvm_nvhe_init_params, vector_hyp_va));
   DEFINE(NVHE_INIT_STACK_HYP_VA,	offsetof(struct kvm_nvhe_init_params, stack_hyp_va));
+  DEFINE(NVHE_INIT_ENTRY_HYP_VA,	offsetof(struct kvm_nvhe_init_params, entry_hyp_va));
   DEFINE(NVHE_INIT_PGD_PA,	offsetof(struct kvm_nvhe_init_params, pgd_pa));
 #endif
 #ifdef CONFIG_CPU_PM
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index d4a71ac34254..6d8202d2bdfb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -9,6 +9,7 @@
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
+#include <asm/el2_setup.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
@@ -159,6 +160,37 @@ alternative_else_nop_endif
 	ret
 SYM_CODE_END(___kvm_hyp_init)
 
+SYM_CODE_START(__kvm_hyp_cpu_entry)
+	msr	SPsel, #1			// We want to use SP_EL{1,2}
+
+	/* Check that the core was booted in EL2. */
+	mrs	x1, CurrentEL
+	cmp	x1, #CurrentEL_EL2
+	b.eq	2f
+
+	/* The core booted in EL1. KVM cannot be initialized on it. */
+1:	wfe
+	wfi
+	b	1b
+
+	/* Initialize EL2 CPU state to sane values. */
+2:	mov	x29, x0
+	init_el2_state nvhe
+	mov	x0, x29
+
+	/*
+	 * Load hyp VA of C entry function. Must do so before switching on the
+	 * MMU because the struct pointer is PA and not identity-mapped in hyp.
+	 */
+	ldr	x29, [x0, #NVHE_INIT_ENTRY_HYP_VA]
+
+	/* Enable MMU, set vectors and stack. */
+	bl	___kvm_hyp_init
+
+	/* Leave idmap. */
+	br	x29
+SYM_CODE_END(__kvm_hyp_cpu_entry)
+
 SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	1f
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
