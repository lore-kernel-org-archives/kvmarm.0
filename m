Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CCFC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 19:14:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED1514B1BC;
	Mon,  2 May 2022 15:14:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cHdtn3pfMFW3; Mon,  2 May 2022 15:14:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D88C84B1D2;
	Mon,  2 May 2022 15:14:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9ABC4B1BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:14:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M+swagRqdy0q for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 15:14:10 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 873364B152
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:14:10 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 x79-20020a25ce52000000b006497f075e7dso2995421ybe.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 12:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=kctQu0Q+rBx9IOI1jVYX1kCsToTQ9FXaErspFG8A+BM=;
 b=PUaFQEUXTVeO3j8UqhdilVFBoS8MQyXXLOdKDTrAxE3OYq/faQPkSJWo8e7me1GEfx
 6PsNj1xxLGPhdzYlihe1rWIfDUcGXvJXU10tkvtxr6B/1FN7NalgVecXju0dhY3zvC3z
 Wn9cP13pNuedWp+KZQejkmkLKJWMyilvnVCZCeigqzu7y0HNaezqXPUdmoMOtc+bcbZg
 iGVOT37xPO8vnZ857v/bBUTDGk0QN0BZCLo8QSwtH1V7yUaedGw7RwWpenSonKMyFTwi
 MaX/+nPpNpve5ilD2cuRr96xbl7NBZ2cJyokJ9Cl3NLX6dlXkrvqfAJBFp8SZMNQPpEZ
 jtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=kctQu0Q+rBx9IOI1jVYX1kCsToTQ9FXaErspFG8A+BM=;
 b=jibaL1R1W6dCKLsBdbzbvhN309tW3cMw5bsWZf3FRr7hqsIOVNNwit+2oPNuJQ7+Kg
 FUgRGnkAVwsqdcQ+wGgxMYFlLVevC7HVerhqk8YlA8dCKBZCo0/fA5+fVusWtj7rmAb4
 +YRH3heKwHkzunddXxRf5gAQdnujdb77ohrhzLgM4A+kKzamb5bdxzmNbABPuW6mwICi
 WShTiKDDtGU0+tmY/2QCThoYQnS0dVsgvAvXslPJO2lUoFbRB34URyHh0P4mLurTIusz
 4q38UVVigsYRxzsbKUsuGixNDHi8S9qXtQHEJWJgayUSOrpwwbt0vFkaRjzrj+v7KwGy
 K4dA==
X-Gm-Message-State: AOAM531FTUcqdMK4KuI/RgXxlaWATEF8wQt4np55kksHwMkHPAwChc3j
 pee4xXvqqgU9OeWaZ9k74BQPl/cS2Dv1hvxdOg==
X-Google-Smtp-Source: ABdhPJxJbanbmKIqaVzeagTqMg3TVUzh6s0fqdiC3NI5Unq1sq+s6VeUa3qJVINa7kZWA+10cnCzYiMEVqhMJfYwMg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:55c:7548:7073:c14f])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:50c:b0:648:67e5:f160 with
 SMTP id x12-20020a056902050c00b0064867e5f160mr11569415ybs.22.1651518850044;
 Mon, 02 May 2022 12:14:10 -0700 (PDT)
Date: Mon,  2 May 2022 12:12:04 -0700
In-Reply-To: <20220502191222.4192768-1-kaleshsingh@google.com>
Message-Id: <20220502191222.4192768-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220502191222.4192768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 4/5] KVM: arm64: Allocate shared stacktrace pages
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, broonie@kernel.org, Peter Collingbourne <pcc@google.com>,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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

The nVHE hypervisor can use this shared area to dump its stacktrace
addresses on hyp_panic(). Symbolization and printing the stacktrace can
then be handled by the host in EL1 (done in a later patch in this series).

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/kvm_asm.h |  1 +
 arch/arm64/kvm/arm.c             | 34 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c  | 11 +++++++++++
 3 files changed, 46 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2e277f2ed671..ad31ac68264f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -174,6 +174,7 @@ struct kvm_nvhe_init_params {
 	unsigned long hcr_el2;
 	unsigned long vttbr;
 	unsigned long vtcr;
+	unsigned long stacktrace_hyp_va;
 };
 
 /* Translate a kernel address @ptr into its equivalent linear mapping */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d300def44f5c..26005182da20 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -50,6 +50,7 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stacktrace_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
@@ -1484,6 +1485,7 @@ static void cpu_prepare_hyp_mode(int cpu)
 	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
 	params->tcr_el2 = tcr;
 
+	params->stacktrace_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stacktrace_page, cpu));
 	params->pgd_pa = kvm_mmu_get_httbr();
 	if (is_protected_kvm_enabled())
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
@@ -1777,6 +1779,7 @@ static void teardown_hyp_mode(void)
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu) {
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+		free_page(per_cpu(kvm_arm_hyp_stacktrace_page, cpu));
 		free_pages(kvm_arm_hyp_percpu_base[cpu], nvhe_percpu_order());
 	}
 }
@@ -1868,6 +1871,23 @@ static int init_hyp_mode(void)
 		per_cpu(kvm_arm_hyp_stack_page, cpu) = stack_page;
 	}
 
+	/*
+	 * Allocate stacktrace pages for Hypervisor-mode.
+	 * This is used by the hypervisor to share its stacktrace
+	 * with the host on a hyp_panic().
+	 */
+	for_each_possible_cpu(cpu) {
+		unsigned long stacktrace_page;
+
+		stacktrace_page = __get_free_page(GFP_KERNEL);
+		if (!stacktrace_page) {
+			err = -ENOMEM;
+			goto out_err;
+		}
+
+		per_cpu(kvm_arm_hyp_stacktrace_page, cpu) = stacktrace_page;
+	}
+
 	/*
 	 * Allocate and initialize pages for Hypervisor-mode percpu regions.
 	 */
@@ -1975,6 +1995,20 @@ static int init_hyp_mode(void)
 		params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
 	}
 
+	/*
+	 * Map the hyp stacktrace pages.
+	 */
+	for_each_possible_cpu(cpu) {
+		char *stacktrace_page = (char *)per_cpu(kvm_arm_hyp_stacktrace_page, cpu);
+
+		err = create_hyp_mappings(stacktrace_page, stacktrace_page + PAGE_SIZE,
+					  PAGE_HYP);
+		if (err) {
+			kvm_err("Cannot map hyp stacktrace page\n");
+			goto out_err;
+		}
+	}
+
 	for_each_possible_cpu(cpu) {
 		char *percpu_begin = (char *)kvm_arm_hyp_percpu_base[cpu];
 		char *percpu_end = percpu_begin + nvhe_percpu_size();
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index e8d4ea2fcfa0..9b81bf2d40d7 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -135,6 +135,17 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 
 		/* Update stack_hyp_va to end of the stack's private VA range */
 		params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
+
+		/*
+		 * Map the stacktrace pages as shared and transfer ownership to
+		 * the hypervisor.
+		 */
+		prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_OWNED);
+		start = (void *)params->stacktrace_hyp_va;
+		end = start + PAGE_SIZE;
+		ret = pkvm_create_mappings(start, end, prot);
+		if (ret)
+			return ret;
 	}
 
 	/*
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
