Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850AEC64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1AD322249
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 18:41:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1AD322249
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86D8F4B41E;
	Wed,  2 Dec 2020 13:41:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dYE5B2o5ZQFa; Wed,  2 Dec 2020 13:41:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E3084B421;
	Wed,  2 Dec 2020 13:41:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CED3C4B333
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gGzdHWXxP9TU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 13:41:48 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFACF4B40C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 13:41:48 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id d3so10150140wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 10:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=pY9jRbioJhJf7MwxwtV14CQQVHe+rZSO6XuQoMfB3LY=;
 b=NL0mNcnpizqXS1UX9W9Xx72wdHMsPuW8ohq6hfiQ1SgVzyFUmbVUVXO+UIp6cX3GXm
 3RCq57FWsycLSju3jZUWCY5zUMAXA5v0bk+c/SHgZ+/DxvtNWejec3R7jeVgNTVOb2HP
 bZ5FDOGmbS1J0e0Jdjsloi7TwnD2P14i6sFptC1oDSTb6TGcbtiIWyzIngfHvHg0nt67
 r0zCYXyh+Hl9naVwqPp7J42lS4ZqCn+t8zbHpiCjyDpyOfMByZmYCs7dHw2V0ZQZar/0
 cOrWwZ0Co16GFlvenZ9YCMR2+Dhj3+aApPouoNTu4ibFPYqp0AtKOFRF+GOJULHxAdVc
 E+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=pY9jRbioJhJf7MwxwtV14CQQVHe+rZSO6XuQoMfB3LY=;
 b=RdGfaYOM5LAJ3NICdYpflc7x3VKb7jE47YimyyZF6cc95V2//8pq0luX02svc0lLo/
 UdhP8LJ7MaI5UhwDdZc6LSlcMcQZADYzKoBRyS/xfmAKoRoeRJAibVy8/X4msZZpx7A7
 8AJuZYOUHmy0o6MvMcEs+5Cx+HPb5c2/9r7dMWYCS7sLZGm0iy8uKYWU5qBXQkEFSqgL
 BGS/+VDBQr6sTTtWQti7+Z6HQdC07MlcqJCvn7qdrcOUFeDlymFVL6590Ze0HrnBpuBZ
 uFqhBSgj51+r0w00hK4QRZTzUEBhHPT8wZwUUR6Inb0ZKAuOdbkYy4XJ1XbxTL+wcms3
 9xkg==
X-Gm-Message-State: AOAM530tI6xqrfElpCJTimd2xmCFVTkgBt1KmAI0j+DQdOHSCLQEVHLV
 fbTSW5mS1UDPvHbkTuPA+CWcxUMh37kEHw==
X-Google-Smtp-Source: ABdhPJz89vM2fd/nDXaPHt9j0cPFTGj1oyMk3PstTs/+u86wCoX9DNGJNGbi4MtwwUU+yDdDBPf3FQ==
X-Received: by 2002:a1c:328a:: with SMTP id y132mr4632122wmy.134.1606934507192; 
 Wed, 02 Dec 2020 10:41:47 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id n128sm3159374wmb.46.2020.12.02.10.41.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Dec 2020 10:41:46 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 09/26] kvm: arm64: Remove vector_ptr param of hyp-init
Date: Wed,  2 Dec 2020 18:41:05 +0000
Message-Id: <20201202184122.26046-10-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202184122.26046-1-dbrazdil@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
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

KVM precomputes the hyp VA of __kvm_hyp_host_vector, essentially a
constant (minus ASLR), before passing it to __kvm_hyp_init.
Now that we have alternatives for converting kimg VA to hyp VA, replace
this with computing the constant inside __kvm_hyp_init, thus removing
the need for an argument.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 --
 arch/arm64/include/asm/kvm_mmu.h   | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/arm.c               |  4 +---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  9 ++++++---
 4 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 4a6a77d8d13e..531f9d04eefd 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -163,10 +163,8 @@ struct kvm_vcpu;
 struct kvm_s2_mmu;
 
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
-DECLARE_KVM_NVHE_SYM(__kvm_hyp_host_vector);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
 #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
-#define __kvm_hyp_host_vector	CHOOSE_NVHE_SYM(__kvm_hyp_host_vector)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
 
 extern unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e298191a854d..e52d82aeadca 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -94,6 +94,30 @@ alternative_cb_end
 	sub	\reg, \reg, \tmp
 .endm
 
+/*
+ * Convert a kernel image address to a hyp VA
+ * reg: kernel address to be converted in place
+ * tmp: temporary register
+ *
+ * The actual code generation takes place in kvm_get_kimage_voffset, and
+ * the instructions below are only there to reserve the space and
+ * perform the register allocation (kvm_update_kimg_phys_offset uses the
+ * specific registers encoded in the instructions).
+ */
+.macro kimg_hyp_va reg, tmp
+alternative_cb kvm_update_kimg_phys_offset
+	movz	\tmp, #0
+	movk	\tmp, #0, lsl #16
+	movk	\tmp, #0, lsl #32
+	movk	\tmp, #0, lsl #48
+alternative_cb_end
+
+	sub	\reg, \reg, \tmp
+	mov_q	\tmp, PAGE_OFFSET
+	orr	\reg, \reg, \tmp
+	kern_hyp_va \reg
+.endm
+
 #else
 
 #include <linux/pgtable.h>
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d9e8d7dc7e11..9e5d0ea84822 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1386,7 +1386,6 @@ static void cpu_init_hyp_mode(void)
 {
 	phys_addr_t pgd_ptr;
 	unsigned long hyp_stack_ptr;
-	unsigned long vector_ptr;
 	unsigned long tpidr_el2;
 	struct arm_smccc_res res;
 
@@ -1404,7 +1403,6 @@ static void cpu_init_hyp_mode(void)
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
 	hyp_stack_ptr = kern_hyp_va(hyp_stack_ptr);
-	vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
@@ -1414,7 +1412,7 @@ static void cpu_init_hyp_mode(void)
 	 */
 	BUG_ON(!system_capabilities_finalized());
 	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init),
-			  pgd_ptr, tpidr_el2, hyp_stack_ptr, vector_ptr, &res);
+			  pgd_ptr, tpidr_el2, hyp_stack_ptr, &res);
 	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index b11a9d7db677..931a8c38f085 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -50,7 +50,6 @@ __invalid:
 	 * x1: HYP pgd
 	 * x2: per-CPU offset
 	 * x3: HYP stack
-	 * x4: HYP vectors
 	 */
 __do_hyp_init:
 	/* Check for a stub HVC call */
@@ -134,9 +133,13 @@ alternative_else_nop_endif
 	msr	sctlr_el2, x0
 	isb
 
-	/* Set the stack and new vectors */
+	/* Set the stack */
 	mov	sp, x3
-	msr	vbar_el2, x4
+
+	/* Set the host vector */
+	ldr	x0, =__kvm_hyp_host_vector
+	kimg_hyp_va x0, x1
+	msr	vbar_el2, x0
 
 	/* Hello, World! */
 	mov	x0, #SMCCC_RET_SUCCESS
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
