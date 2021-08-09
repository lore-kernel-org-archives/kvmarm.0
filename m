Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435B9C4320E
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9EC86101D
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D9EC86101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D1B64A19F;
	Mon,  9 Aug 2021 11:25:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y39wGXZm99r3; Mon,  9 Aug 2021 11:25:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49E9F4B0FA;
	Mon,  9 Aug 2021 11:25:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA424B0ED
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yp8rgZSNox3l for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:36 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A8084B0E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:36 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 m5-20020a5d6a050000b0290154e83dce73so1198246wru.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KFZVGZ+Mzblb6mTT1CbKeaimyRVzKWDYIpGPBkKJMH8=;
 b=pTWmztROLpoZ/YEoV+ztylPoctL8IiBHjZvfPn5BF25G67RHEP1SM5mfeOIA3mYaqD
 jTjA77K/PVHAviLqbXufrID4P5t/K9hJjg9RIyFKzrsEnXGIHCy0RQlttOVSQrZ96C/8
 26dycaUIiMRShVlPsHmbBSkGaAWpT3F5sT5SC1Gq2DSYmzeVqSnHZ2tJBkQyQPnDNrI2
 uEBimzTF1mF8hYtql2vkagTqfB3QunZkJ7dmhkO7vmnwI9PhbmY96O9HhCMk6jKvaxYv
 E8kNrnjWesO1Y1nHStFmPOK75x+zDLL0ERSj/IflF1OU+GZPW93aOnQYF5Hv8ouk+Dx7
 Rmhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KFZVGZ+Mzblb6mTT1CbKeaimyRVzKWDYIpGPBkKJMH8=;
 b=Yg6pqp/JTpOL4Yigv/KPPjP8Be9nY+bZ6XRPASTV1qH1D7bJKhDcOCyr5HPuOJZkgg
 q6IsebgoY8PYqSboX49Ql6ZtjMgNj4b/FZUIw8N/BPctzfmXUrSexS2n5ORCHMqcSJmW
 2JU3f78VDjT0qbGjR9G/dFqqtGQ5tyZxYN22CR+wb4SYjnO4jbskJ95zA2e5NnBmvvKV
 YGmFO5U99yCohPWbFsLqY7Jpuhr5XR0OpeM2tzIPwobDxsp2NRqTsI14XeMJGp1cID/C
 TFpfZfQbKUJWeTVdy/fu1/cH+xY5/Z+Z8fm3u/IjK72t/N9JAvxESmJo6FRDSZO3viR0
 v8bA==
X-Gm-Message-State: AOAM530medltClnSxhpGtoieWqkMcjUVa8V8X9ourfIrqZTYtiTGKixL
 Ykj2BR3F1l31zfKGPM+alkf4Vr62HmjP
X-Google-Smtp-Source: ABdhPJyvCDOjAG2Hu7aKsLby4Z+3QpOn0rmCk7GJ0Z+BakNZ9SXQUH+1+hp9v3IxblCUxUDyje28JERIawZx
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:600c:5116:: with SMTP id
 o22mr72964wms.0.1628522735422; Mon, 09 Aug 2021 08:25:35 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:47 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-21-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 20/21] KVM: arm64: Restrict EL2 stage-1 changes in
 protected mode
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

The host kernel is currently able to change EL2 stage-1 mappings without
restrictions thanks to the __pkvm_create_mappings() hypercall. But in a
world where the host is no longer part of the TCB, this clearly poses a
problem.

To fix this, introduce a new hypercall to allow the host to share a
physical memory page with the hypervisor, and remove the
__pkvm_create_mappings() variant. The new hypercall implements
ownership and permission checks before allowing the sharing operation,
and it annotates the shared page in the hypervisor stage-1 and host
stage-2 page-tables.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 11 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 88 +++++++++++++++++++
 arch/arm64/kvm/mmu.c                          | 28 +++++-
 5 files changed, 118 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 432a9ea1f02e..aed2aa61766a 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -59,7 +59,7 @@
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
 #define __KVM_HOST_SMCCC_FUNC___pkvm_init			15
-#define __KVM_HOST_SMCCC_FUNC___pkvm_create_mappings		16
+#define __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp		16
 #define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 0118527b07b0..03e604f842e2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -49,6 +49,7 @@ extern struct host_kvm host_kvm;
 extern const u8 pkvm_hyp_id;
 
 int __pkvm_prot_finalize(void);
+int __pkvm_host_share_hyp(u64 pfn);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7900d5b66ba3..2da6aa8da868 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -140,14 +140,11 @@ static void handle___pkvm_cpu_set_vector(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = pkvm_cpu_set_vector(slot);
 }
 
-static void handle___pkvm_create_mappings(struct kvm_cpu_context *host_ctxt)
+static void handle___pkvm_host_share_hyp(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(unsigned long, start, host_ctxt, 1);
-	DECLARE_REG(unsigned long, size, host_ctxt, 2);
-	DECLARE_REG(unsigned long, phys, host_ctxt, 3);
-	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 4);
+	DECLARE_REG(u64, pfn, host_ctxt, 1);
 
-	cpu_reg(host_ctxt, 1) = __pkvm_create_mappings(start, size, phys, prot);
+	cpu_reg(host_ctxt, 1) = __pkvm_host_share_hyp(pfn);
 }
 
 static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
@@ -185,7 +182,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_restore_aprs),
 	HANDLE_FUNC(__pkvm_init),
 	HANDLE_FUNC(__pkvm_cpu_set_vector),
-	HANDLE_FUNC(__pkvm_create_mappings),
+	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_create_private_mapping),
 	HANDLE_FUNC(__pkvm_prot_finalize),
 };
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2991dc6996b9..8165390d3ec9 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -339,6 +339,94 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
+static inline bool check_prot(enum kvm_pgtable_prot prot,
+			      enum kvm_pgtable_prot required,
+			      enum kvm_pgtable_prot denied)
+{
+	return (prot & (required | denied)) == required;
+}
+
+int __pkvm_host_share_hyp(u64 pfn)
+{
+	phys_addr_t addr = hyp_pfn_to_phys(pfn);
+	enum kvm_pgtable_prot prot, cur;
+	void *virt = __hyp_va(addr);
+	enum pkvm_page_state state;
+	kvm_pte_t pte;
+	int ret;
+
+	if (!addr_is_memory(addr))
+		return -EINVAL;
+
+	hyp_spin_lock(&host_kvm.lock);
+	hyp_spin_lock(&pkvm_pgd_lock);
+
+	ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, NULL);
+	if (ret)
+		goto unlock;
+	if (!pte)
+		goto map_shared;
+
+	/*
+	 * Check attributes in the host stage-2 PTE. We need the page to be:
+	 *  - mapped RWX as we're sharing memory;
+	 *  - not borrowed, as that implies absence of ownership.
+	 * Otherwise, we can't let it got through
+	 */
+	cur = kvm_pgtable_stage2_pte_prot(pte);
+	prot = pkvm_mkstate(0, PKVM_PAGE_SHARED_BORROWED);
+	if (!check_prot(cur, PKVM_HOST_MEM_PROT, prot)) {
+		ret = -EPERM;
+		goto unlock;
+	}
+
+	state = pkvm_getstate(cur);
+	if (state == PKVM_PAGE_OWNED)
+		goto map_shared;
+
+	/*
+	 * Tolerate double-sharing the same page, but this requires
+	 * cross-checking the hypervisor stage-1.
+	 */
+	if (state != PKVM_PAGE_SHARED_OWNED) {
+		ret = -EPERM;
+		goto unlock;
+	}
+
+	ret = kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL);
+	if (ret)
+		goto unlock;
+
+	/*
+	 * If the page has been shared with the hypervisor, it must be
+	 * already mapped as SHARED_BORROWED in its stage-1.
+	 */
+	cur = kvm_pgtable_hyp_pte_prot(pte);
+	prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_BORROWED);
+	if (!check_prot(cur, prot, ~prot))
+		ret = EPERM;
+	goto unlock;
+
+map_shared:
+	/*
+	 * If the page is not yet shared, adjust mappings in both page-tables
+	 * while both locks are held.
+	 */
+	prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_BORROWED);
+	ret = pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, prot);
+	BUG_ON(ret);
+
+	prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_OWNED);
+	ret = host_stage2_idmap_locked(addr, PAGE_SIZE, prot);
+	BUG_ON(ret);
+
+unlock:
+	hyp_spin_unlock(&pkvm_pgd_lock);
+	hyp_spin_unlock(&host_kvm.lock);
+
+	return ret;
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0625bf2353c2..cbab146cda6a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -259,10 +259,8 @@ static int __create_hyp_mappings(unsigned long start, unsigned long size,
 {
 	int err;
 
-	if (!kvm_host_owns_hyp_mappings()) {
-		return kvm_call_hyp_nvhe(__pkvm_create_mappings,
-					 start, size, phys, prot);
-	}
+	if (WARN_ON(!kvm_host_owns_hyp_mappings()))
+		return -EINVAL;
 
 	mutex_lock(&kvm_hyp_pgd_mutex);
 	err = kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
@@ -282,6 +280,21 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
 	}
 }
 
+static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
+{
+	phys_addr_t addr;
+	int ret;
+
+	for (addr = ALIGN_DOWN(start, PAGE_SIZE); addr < end; addr += PAGE_SIZE) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
+					__phys_to_pfn(addr));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /**
  * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
  * @from:	The virtual kernel start address of the range
@@ -302,6 +315,13 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
+	if (!kvm_host_owns_hyp_mappings()) {
+		if (WARN_ON(prot != PAGE_HYP))
+			return -EPERM;
+		return pkvm_share_hyp(kvm_kaddr_to_phys(from),
+				      kvm_kaddr_to_phys(to));
+	}
+
 	start = start & PAGE_MASK;
 	end = PAGE_ALIGN(end);
 
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
