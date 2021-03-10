Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8863C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 663AB64FB1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 663AB64FB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A60C4B692;
	Wed, 10 Mar 2021 12:59:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cYKvH71clfYK; Wed, 10 Mar 2021 12:59:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C81D74B6AC;
	Wed, 10 Mar 2021 12:59:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56A0C4B336
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:59:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u77qfg-4OGbE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:59:10 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11CED4B644
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:59:10 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id n25so2991096wmk.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Izv1B26QXp5fMc/VBnQrm2CNhoL84Ug8LOnqFmCQ1Ig=;
 b=ItduwNAOHw7sl7SfTdrsmOhuNxkYB+uL69Ld1jgrXtbIP7oT1ltbUj65vkfckRejVo
 H/GtOSwQfQ4Wr7N4+fDgyoZfBOduWnHmU72oatPYqIPRkc3igSo8/5QhUPxoXKya+XTs
 5qhZDbYM7y3pLpa9R6ng1GacjsA/2G8nkofF5b+5rvRhEBHWRYY7NfG6pcuzeWcIYpVA
 hT08jBVRC3r2CbuMiiiWf8nZJhnCYaTX8l39dXYSBsNtQtK/VDJsb8SRsP+Gt1QwQLfZ
 HMWYfrRHApwAqtnlfExk0wR/m1YuVB0jdXNr8sy2DyeECS+GZ/c2h+biEiJV3oLKfgkA
 F+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Izv1B26QXp5fMc/VBnQrm2CNhoL84Ug8LOnqFmCQ1Ig=;
 b=jncmI+cIdPha+Tff5kBIsMSJ1MMrK+ObciuFQcIiMqJcvCHsi+i5KjYk9YFJygO90Z
 WFHyRju15+JaQQrYRZPyz+fiXEX6WrVOUbwKiQLFRelC6vdjmmx+W/l5Srhd9tccHlnZ
 wBNXgolOaeuNxbX5gxgqk8AQvFGAqnqoZzkE6lcZEkiDogh7teuyJdzxin2of8diJlb9
 oERT1zPUTlnLrz0zIj6NyQ9+Nde3NcqxFHSy8x/iy3mwtGVlUTCwfQU/c9sYpmNInyzR
 ErMcZyXDrbA0NFa25F1i5poGBy2rvghW8SpA/YMYDSDXQCR+g9Aot1b1+ScyKMgQaSHk
 BGwQ==
X-Gm-Message-State: AOAM532C/VMg5EcHnbyLLaKcpW6y7rlHob0l4xkdYkPlyAFbYcipvNFf
 pUefjGNXA+jPWp7iiQRd4DEBLwuyDqU0
X-Google-Smtp-Source: ABdhPJxrvGTs3vci5lUmhmaPsZPM93YibPtQp837uFnTbTMuR06Qiq5j6ejGsWMlr+vGUqW6o5C4jparLuWA
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:adf:e34f:: with SMTP id
 n15mr4749877wrj.224.1615399149316; Wed, 10 Mar 2021 09:59:09 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:51 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-35-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 34/34] KVM: arm64: Protect the .hyp sections from the host
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/arm.c                          | 46 +++++++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 33 +++++++++++++
 5 files changed, 91 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index b127af02bd45..d468c4b37190 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -62,6 +62,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
+#define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7e6a81079652..d6baf76d4747 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1894,11 +1894,57 @@ void _kvm_host_prot_finalize(void *discard)
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
index f47028d3fd0a..3df33d4de4a1 100644
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
index 5c88a325e6fc..fffa432ce3eb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,6 +25,8 @@ struct host_kvm host_kvm;
 struct hyp_pool host_s2_mem;
 struct hyp_pool host_s2_dev;
 
+static const u32 pkvm_hyp_id = 0xffffffff;
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
