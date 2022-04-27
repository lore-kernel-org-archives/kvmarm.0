Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F72C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 18:49:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D7949DED;
	Wed, 27 Apr 2022 14:49:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8aTgDGm+e6VZ; Wed, 27 Apr 2022 14:49:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 642A249F2A;
	Wed, 27 Apr 2022 14:49:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABFE149DED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:49:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5hxIjLbwvNuE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 14:49:34 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DB3A4101F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:49:34 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2d11b6259adso24249167b3.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 11:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=Niw+TDgV2KxWJ6fEGzYEc3H0fJbmY41W2p5431uZWR8=;
 b=H5K4dvngFXeGToSiwJyc5gDMiauBTyAgTQcKNgijqRH4fda+ZalAnwFobgqTFx5m95
 07PESfGxsSypAvapcr9tVD1Dv5o7rLLVvBo/jR0R6LXTRctJIeTqK614GBBJ7Xs1iS25
 CY+xTyd2ftGYZh42x0clk4C/Bd/F8zBbHQ621AQ+E6V2xC8gGfH7/9MLLQKlnYkkUb/n
 LT7qd9n3S9QukrbaySOFwUwrig26yKbRGD/TnCYnSAqsDS3VhHTCZDVjsyAiuQjkV/VF
 +4z8HcP9gGcur7U6uJKwMpqRHKql3EVYLOGSUMYxAaBTcuIG3mHlfWRs4GZo8Gb7ivJE
 yEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=Niw+TDgV2KxWJ6fEGzYEc3H0fJbmY41W2p5431uZWR8=;
 b=g1C429YN5LCfoetazLH+BYR8nAEdCTgFiHAvNJTPjx+i4mjo+NgBptWQD/PFqqGc7T
 sHVqqJOHDZbp5F0tlQsMKdoduAlJBq/Nk07P37q4UoMS4CDqRTdhQXvCLKJ45GVAkFG8
 tw5le0JUz2k64pDHPe7CQ9dpI301xalqrAiu4YSQOxunAhrtHo947kP/hzTDX/5dRlwI
 eJNsVSKzH16cgxgWS1Uojc46ieGg3jBcKTw+Bbi3uz4T97WkxRUWFVy5hyCG5cYWdeg8
 /ngCVC8KzTaX2Ri52qy72dkHWRy1K9rK0XSQhPfwCw+SWDfVRqCc/WwdFgtOrk178ZH7
 0w3A==
X-Gm-Message-State: AOAM531doRbemYNDd3fdNIo6WJy/hgPFsWLiQVzfpRMiZ9VkD0OG4s31
 7MsZnhAQ1E721op5MOgeZkVUMcGe6gBbNdgKog==
X-Google-Smtp-Source: ABdhPJwQ9wuOJWR/zy4bZTJ2QdVCC1H5SyRAsiNowolDxo1lYvW9cV81p5PcXpipjoSEMhqkjHq4UkjNMEefFsqN/Q==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:16ec:6da0:8cc5:5f24])
 (user=kaleshsingh job=sendgmr) by 2002:a25:d44e:0:b0:648:3d5b:fbd5 with SMTP
 id m75-20020a25d44e000000b006483d5bfbd5mr20470009ybf.363.1651085374068; Wed,
 27 Apr 2022 11:49:34 -0700 (PDT)
Date: Wed, 27 Apr 2022 11:46:58 -0700
In-Reply-To: <20220427184716.1949239-1-kaleshsingh@google.com>
Message-Id: <20220427184716.1949239-4-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220427184716.1949239-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 3/4] KVM: arm64: Allocate shared stacktrace pages
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-kernel@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>
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
index dd257d9f21a2..1b21d5a99bfc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -50,6 +50,7 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stacktrace_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
@@ -1483,6 +1484,7 @@ static void cpu_prepare_hyp_mode(int cpu)
 	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
 	params->tcr_el2 = tcr;
 
+	params->stacktrace_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stacktrace_page, cpu));
 	params->pgd_pa = kvm_mmu_get_httbr();
 	if (is_protected_kvm_enabled())
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
@@ -1776,6 +1778,7 @@ static void teardown_hyp_mode(void)
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu) {
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+		free_page(per_cpu(kvm_arm_hyp_stacktrace_page, cpu));
 		free_pages(kvm_arm_hyp_percpu_base[cpu], nvhe_percpu_order());
 	}
 }
@@ -1867,6 +1870,23 @@ static int init_hyp_mode(void)
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
@@ -1974,6 +1994,20 @@ static int init_hyp_mode(void)
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
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
