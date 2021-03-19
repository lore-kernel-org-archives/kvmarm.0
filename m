Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C25C433E9
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F4B864F1F
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F4B864F1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 283844B6B3;
	Fri, 19 Mar 2021 06:03:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NMActNIF3abs; Fri, 19 Mar 2021 06:03:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6CC54B457;
	Fri, 19 Mar 2021 06:03:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC0184B77F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7FP-RM4Q6wb7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:03:13 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B342D4B682
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:12 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id r6so8312279wrt.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wcv4vREKnArTuR36LJ4s5XYbQOambx51fL/UYTrLPw8=;
 b=ZlpIZX+EzTuUNUCtgoUWPmG+bspeyGyRB0iNHGELTKyRSuIE88j3AtHAvQqGA2GL0K
 gDyCBwMDqdFgY2lQwbDIb0l4soFgilpvNr3ANJw1unBDhPqhTtRyK5xIIoym3M0rKoUs
 4JNemtx4mZwpdPWi5jp/4fJsNU/CSkpOu4T38HhuC86U/n5c4y3wnAZochAsOpWYPT9z
 aVtjkpk79a/JpA97r4W8+zGjIQt8rR/2G1AlcUqnEG/qpvJwRwrvXoGBA3JmpEEg3KWB
 PW9WGsgujq48fEGSg9ZgOH/4gbdYH15MLKJL4BTnJphwvQboNVO0NxGPwF6yph209lq2
 toww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wcv4vREKnArTuR36LJ4s5XYbQOambx51fL/UYTrLPw8=;
 b=APW2/NIjhhV7Da+7ZULQBrlm3shnYHP4Xzmww02zaC/OdDjtfiVR1j9LRUvHXdoxlC
 7VabEEOz6QFiuI8xzkml8+i0ZGsD3TCJIM6va2w/vrE8tPtZ/GzWdgx+dddh+WzKiE6L
 Awi9F15gnkPOMufkfb7CGW38aY7Sob4O6Eo3KSgd50LCjSo8WLDY+zDirJr0r4vFsbNV
 JI6+4BcRddt6nZTvoeWk6s/ABFmiyBdmPUAdDu9qL3HRvZEtT/khDiJB6kb3GWfRiZI/
 Kg1hrKsJhEx7MEs5SHZ/R0vQm1tpQIg6RCMP6BCgGwOhG65Jl1T1zJaVAqTch/06EFje
 gH+Q==
X-Gm-Message-State: AOAM530vCj6kAeXBGHbAU598EV/blFv8xkZ2waqD4mtbILzWDD9FL+3W
 Mg8hEtDL8Z1ERFIUhTBbKck6+0E0QYF7
X-Google-Smtp-Source: ABdhPJybx+Qdo727CriACvxjI8elDWIha3UJClfeaiUYbbbhNjfpa3HDhor+yghx9MsgdbSVYO+a+wFy0ogS
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:adf:ba87:: with SMTP id
 p7mr3723317wrg.298.1616148191951; Fri, 19 Mar 2021 03:03:11 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:46 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-39-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 38/38] KVM: arm64: Protect the .hyp sections from the host
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

When KVM runs in nVHE protected mode, use the host stage 2 to unmap the
hypervisor sections by marking them as owned by the hypervisor itself.
The long-term goal is to ensure the EL2 code can remain robust
regardless of the host's state, so this starts by making sure the host
cannot e.g. write to the .hyp sections directly.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/arm.c                          | 46 +++++++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 33 +++++++++++++
 5 files changed, 91 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 4149283b4cd1..cf8df032b9c3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -62,6 +62,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
+#define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d237c378e6fb..368159021dee 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1899,11 +1899,57 @@ void _kvm_host_prot_finalize(void *discard)
 	WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize));
 }
 
+static inline int pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
+{
+	return kvm_call_hyp_nvhe(__pkvm_mark_hyp, start, end);
+}
+
+#define pkvm_mark_hyp_section(__section)		\
+	pkvm_mark_hyp(__pa_symbol(__section##_start),	\
+			__pa_symbol(__section##_end))
+
 static int finalize_hyp_mode(void)
 {
+	int cpu, ret;
+
 	if (!is_protected_kvm_enabled())
 		return 0;
 
+	ret = pkvm_mark_hyp_section(__hyp_idmap_text);
+	if (ret)
+		return ret;
+
+	ret = pkvm_mark_hyp_section(__hyp_text);
+	if (ret)
+		return ret;
+
+	ret = pkvm_mark_hyp_section(__hyp_rodata);
+	if (ret)
+		return ret;
+
+	ret = pkvm_mark_hyp_section(__hyp_bss);
+	if (ret)
+		return ret;
+
+	ret = pkvm_mark_hyp(hyp_mem_base, hyp_mem_base + hyp_mem_size);
+	if (ret)
+		return ret;
+
+	for_each_possible_cpu(cpu) {
+		phys_addr_t start = virt_to_phys((void *)kvm_arm_hyp_percpu_base[cpu]);
+		phys_addr_t end = start + (PAGE_SIZE << nvhe_percpu_order());
+
+		ret = pkvm_mark_hyp(start, end);
+		if (ret)
+			return ret;
+
+		start = virt_to_phys((void *)per_cpu(kvm_arm_hyp_stack_page, cpu));
+		end = start + PAGE_SIZE;
+		ret = pkvm_mark_hyp(start, end);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Flip the static key upfront as that may no longer be possible
 	 * once the host stage 2 is installed.
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index d293cb328cc4..42d81ec739fa 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -21,6 +21,8 @@ struct host_kvm {
 extern struct host_kvm host_kvm;
 
 int __pkvm_prot_finalize(void);
+int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
+
 int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 69163f2cbb63..b4eaa7ef13e0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -156,6 +156,14 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
 {
 	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
 }
+
+static void handle___pkvm_mark_hyp(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, start, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, end, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_mark_hyp(start, end);
+}
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -180,6 +188,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_create_mappings),
 	HANDLE_FUNC(__pkvm_create_private_mapping),
 	HANDLE_FUNC(__pkvm_prot_finalize),
+	HANDLE_FUNC(__pkvm_mark_hyp),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 77b48c47344d..808e2471091b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -27,6 +27,8 @@ struct host_kvm host_kvm;
 struct hyp_pool host_s2_mem;
 struct hyp_pool host_s2_dev;
 
+static const u8 pkvm_hyp_id = 1;
+
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
 	return hyp_alloc_pages(&host_s2_mem, get_order(size));
@@ -182,6 +184,18 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 	return false;
 }
 
+static bool range_is_memory(u64 start, u64 end)
+{
+	struct kvm_mem_range r1, r2;
+
+	if (!find_mem_range(start, &r1) || !find_mem_range(end, &r2))
+		return false;
+	if (r1.start != r2.start)
+		return false;
+
+	return true;
+}
+
 static inline int __host_stage2_idmap(u64 start, u64 end,
 				      enum kvm_pgtable_prot prot,
 				      struct hyp_pool *pool)
@@ -229,6 +243,25 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
+int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
+{
+	int ret;
+
+	/*
+	 * host_stage2_unmap_dev_all() currently relies on MMIO mappings being
+	 * non-persistent, so don't allow changing page ownership in MMIO range.
+	 */
+	if (!range_is_memory(start, end))
+		return -EINVAL;
+
+	hyp_spin_lock(&host_kvm.lock);
+	ret = kvm_pgtable_stage2_set_owner(&host_kvm.pgt, start, end - start,
+					   &host_s2_mem, pkvm_hyp_id);
+	hyp_spin_unlock(&host_kvm.lock);
+
+	return ret != -EAGAIN ? ret : 0;
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
