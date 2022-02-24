Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB244C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 10:36:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A514BFD5;
	Thu, 24 Feb 2022 05:36:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JnblM9x2B9T2; Thu, 24 Feb 2022 05:36:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D81724C03D;
	Thu, 24 Feb 2022 05:36:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2314BE99
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:18:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 94aG8prQggBs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 00:18:18 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2144E4BE36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:18:18 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d6b6cf0cafso11149327b3.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 21:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=WjbUGG0xKbMDb5kZ3phtYyC+0rOONMmeQOjqy/50x/c=;
 b=FHuVkJYODfDfl0B/txzDiDC6eLLacjGAf43dVMqRJLxMGNm+ImeYaDBNJD5gfJcv21
 Z9ohbr5zf1QC8/F1bTBF+ZtWze2p25FmnoYimvvp8tGfx9BVPZudUp/YbHnPxZvAYx55
 BqQBFSvFlWYpbE2iAz3wRpB2MQIzUJu+vUzz+Lh96Jvt7QNRq+kZQU99bHlUuJuxphka
 SBWOmouo+ZUbL8PlVbbewShLA/QY6RIkqnU5TnnahSBctuqAIesOkiMO0fGPQRCh9HHP
 62goySNV+LLta5Vhbshz1OV5YtgqzaIrnFy1jWIOuZFsvFmAUGNSod5QivSRYUMFNxUt
 nAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=WjbUGG0xKbMDb5kZ3phtYyC+0rOONMmeQOjqy/50x/c=;
 b=lL3QEYiJKJhXUWaN2sU5/zMVlBFoqtKINC90Ibqbi/ZaWGXPS0ujjxgJruzvkySuNn
 oyegErOcB+Xoys+TRC0vY+7HVKQYw+vTC6oayTNcfdgdF/52hn0KS7qtVAUlo81x0Twl
 es9YqQn7eIC/q0eccydw+ErXxZiKHkbBC6xl50h8OuUVReA90p6y3NU96PiEDEBjXeDe
 iY4iUXrk8K06VSXPIMEEHkdikNYhJmJtEnjg5RexZnnWzbkPN3jAejsmu4UgXDIjjXnP
 Mausfxq7DOx6/ytTvyRg9xGeHFD1vPuTwKP+azzrfPTHIb6quwtRXQbexZuw0GBCyUsn
 9guQ==
X-Gm-Message-State: AOAM531xPtOwXQhOYj9PeYoPQCv9gWu6/zU2F5nWCpQBfF2W0KxXXugv
 Us4C0P5h1UENktuI4kEr1/HYo63uzMUnyHT1fg==
X-Google-Smtp-Source: ABdhPJx3WSBr6Ord/trpGYMYJOGDBeI1xnyUZY7Sz4G+U3zbWcId4VvxdhF5xjfG8cDbo/CMBLseJWAynlqRPGyAbg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:415c:9be0:c461:440a])
 (user=kaleshsingh job=sendgmr) by 2002:a25:ae94:0:b0:624:4253:a8b with SMTP
 id b20-20020a25ae94000000b0062442530a8bmr999641ybj.529.1645679897623; Wed, 23
 Feb 2022 21:18:17 -0800 (PST)
Date: Wed, 23 Feb 2022 21:13:38 -0800
In-Reply-To: <20220224051439.640768-1-kaleshsingh@google.com>
Message-Id: <20220224051439.640768-4-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 3/8] KVM: arm64: Add guard pages for KVM nVHE hypervisor
 stack
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Thu, 24 Feb 2022 05:36:21 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

Maps the stack pages in the flexible private VA range and allocates
guard pages below the stack as unbacked VA space. The stack is aligned
to twice its size to aid overflow detection (implemented in a subsequent
patch in the series).

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark

 arch/arm64/include/asm/kvm_asm.h |  1 +
 arch/arm64/kvm/arm.c             | 32 +++++++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index d5b0386ef765..2e277f2ed671 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -169,6 +169,7 @@ struct kvm_nvhe_init_params {
 	unsigned long tcr_el2;
 	unsigned long tpidr_el2;
 	unsigned long stack_hyp_va;
+	unsigned long stack_pa;
 	phys_addr_t pgd_pa;
 	unsigned long hcr_el2;
 	unsigned long vttbr;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..7a23630c4a7f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1541,7 +1541,6 @@ static void cpu_prepare_hyp_mode(int cpu)
 	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
 	params->tcr_el2 = tcr;
 
-	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
 	params->pgd_pa = kvm_mmu_get_httbr();
 	if (is_protected_kvm_enabled())
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
@@ -1990,14 +1989,41 @@ static int init_hyp_mode(void)
 	 * Map the Hyp stack pages
 	 */
 	for_each_possible_cpu(cpu) {
+		struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 		char *stack_page = (char *)per_cpu(kvm_arm_hyp_stack_page, cpu);
-		err = create_hyp_mappings(stack_page, stack_page + PAGE_SIZE,
-					  PAGE_HYP);
+		unsigned long stack_hyp_va, guard_hyp_va;
 
+		/*
+		 * Private mappings are allocated downwards from io_map_base
+		 * so allocate the stack first then the guard page.
+		 *
+		 * The stack is aligned to twice its size to facilitate overflow
+		 * detection.
+		 */
+		err = __create_hyp_private_mapping(__pa(stack_page), PAGE_SIZE,
+						PAGE_SIZE * 2, &stack_hyp_va, PAGE_HYP);
 		if (err) {
 			kvm_err("Cannot map hyp stack\n");
 			goto out_err;
 		}
+
+		/* Allocate unbacked private VA range for stack guard page */
+		guard_hyp_va = hyp_alloc_private_va_range(PAGE_SIZE, PAGE_SIZE);
+		if (IS_ERR_OR_NULL((void *)guard_hyp_va)) {
+			err = guard_hyp_va ? PTR_ERR((void *)guard_hyp_va) : -ENOMEM;
+			kvm_err("Cannot allocate hyp stack guard page\n");
+			goto out_err;
+		}
+
+		/*
+		 * Save the stack PA in nvhe_init_params. This will be needed to recreate
+		 * the stack mapping in protected nVHE mode. __hyp_pa() won't do the right
+		 * thing there, since the stack has been mapped in the flexible private
+		 * VA space.
+		 */
+		params->stack_pa = __pa(stack_page) + PAGE_SIZE;
+
+		params->stack_hyp_va = stack_hyp_va + PAGE_SIZE;
 	}
 
 	for_each_possible_cpu(cpu) {
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
