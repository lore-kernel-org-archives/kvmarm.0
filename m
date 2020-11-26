Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36931C63798
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC847221F8
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="L83CDnry"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC847221F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 369974C088;
	Thu, 26 Nov 2020 10:54:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NmwKPhEA7ezd; Thu, 26 Nov 2020 10:54:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 147F74C08B;
	Thu, 26 Nov 2020 10:54:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC5924B9FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R+vbUvP7KI4h for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:45 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E61CB4C07D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:44 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id g14so2604876wrm.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=utPvkzoqy6/nIv7yirT7WFlgfKz1OWQA6qiMqU5NSCo=;
 b=L83CDnryQMuuOUO42YEM1Fei9cFaqRJ6AxwBerQHFEt9tWXMW0lNOkPpS2bejSW/iu
 tEbbm0lx868wYcgllszhwgBocoNjjhpRethBq4ewq1j2wlI0/ZkmNjLzjNhb/T5wDs0L
 uE8FlKRHQVHKYNpJJmKdt8Oqd7WY7PiRrcKTAyrLPIZe14wtKCPqpe0/nA/ozRQN8zVy
 prbEpoF0/+E0KBzkxM79MvkufhuPbIS5u0EoQplVHSL8Zj8YC8wXXkPWfHECdf9KcpuD
 LGOTL0W9oT4TEWa0ylv9yro0tguEgWkdJ6sWfhkDrJ4ahom5TB2nKKtsgMzPLBwm/SDX
 ZG5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=utPvkzoqy6/nIv7yirT7WFlgfKz1OWQA6qiMqU5NSCo=;
 b=HYBDKCeVTiMlAfCz0UG/+jEMzyoHzJ9KxAGHS1Rt3S3+onSGpo6o0aIH+P54Nu0GBD
 IHISLZYSZVRGXcw28jXHK7EM6nrNqWXjXeMXesHBQR1xD+xunf29VkamGp6ESpPHV8Wj
 IBarioawzwbLT9+GgM9oK6mqnXPMkCk3p9uaUf7Kt9NlCKPBYuVuLdFSmdEwHFSnqFkE
 LNtVzMLCZGSjpidg3eNXIqg+JTNG2nL7GBqy/t/m/h8YWobQhRcqIRgcYEQPMzcSdNqE
 C6lqnQgzUDMtCafIeyRy+bYP84FaN7QxuwEpuhfNHM19vTqBhquQEwH77IuDEB4qnSmE
 8Czg==
X-Gm-Message-State: AOAM53005tIPDWmUBXBv7L6QK4+MjmZfxFz9+mZ7ASxWYofn7zc+oI+2
 NRkV05taGJBbUzyxQB42OayrQm1mGmk8mC67
X-Google-Smtp-Source: ABdhPJxbpHUEbEI7H8KyDN6Qt9yHuAuJ3eZuUVlv4sN6UGfKQTpLTnLejNgi4Q50yjIL+OaOhuCKIw==
X-Received: by 2002:a5d:6191:: with SMTP id j17mr4556274wru.299.1606406083603; 
 Thu, 26 Nov 2020 07:54:43 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id j8sm9486504wrx.11.2020.11.26.07.54.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:42 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 08/23] kvm: arm64: Remove vector_ptr param of hyp-init
Date: Thu, 26 Nov 2020 15:54:06 +0000
Message-Id: <20201126155421.14901-9-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
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
 arch/arm64/include/asm/kvm_mmu.h   | 26 +++++++++++++++++++++++++-
 arch/arm64/kvm/arm.c               |  4 +---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  9 ++++++---
 4 files changed, 32 insertions(+), 9 deletions(-)

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
index 5168a0c516ae..6945faeb68ac 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -93,7 +93,31 @@ alternative_cb_end
        /* reg = __pa(reg) */
        sub     \reg, \reg, \tmp
 .endm
-	 
+
+/*
+ * Convert a kernel image address to a hyp VA
+ * reg: kernel address to be converted in place
+ * tmp: temporary register
+ *
+ * The actual code generation takes place in kvm_get_kimage_voffset, and
+ * the instructions below are only there to reserve the space and
+ * perform the register allocation (kvm_get_kimage_voffset uses the
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
index b25035dc0478..cd6e5dec203f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1355,7 +1355,6 @@ static void cpu_init_hyp_mode(void)
 {
 	phys_addr_t pgd_ptr;
 	unsigned long hyp_stack_ptr;
-	unsigned long vector_ptr;
 	unsigned long tpidr_el2;
 	struct arm_smccc_res res;
 
@@ -1373,7 +1372,6 @@ static void cpu_init_hyp_mode(void)
 	pgd_ptr = kvm_mmu_get_httbr();
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
 	hyp_stack_ptr = kern_hyp_va(hyp_stack_ptr);
-	vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
@@ -1383,7 +1381,7 @@ static void cpu_init_hyp_mode(void)
 	 */
 	BUG_ON(!system_capabilities_finalized());
 	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init),
-			  pgd_ptr, tpidr_el2, hyp_stack_ptr, vector_ptr, &res);
+			  pgd_ptr, tpidr_el2, hyp_stack_ptr, &res);
 	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 17b58dbc3a2f..b3492a3c4232 100644
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
