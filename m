Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA590C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 14:59:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 741A84B9FC;
	Fri, 25 Feb 2022 09:59:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q0EKNV1IN5Qs; Fri, 25 Feb 2022 09:59:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0656B4BA87;
	Fri, 25 Feb 2022 09:59:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E10A14BB07
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:40:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8sh8Oqh89WCD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 22:40:26 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 970F84BAFE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 22:40:26 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2d07ae11462so19846347b3.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 19:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=crLC6KNPSW6pjgkY7QG68MqSuOvzKzstw/mmXuRH0uQ=;
 b=eMACZV7Ulgx7cpO0c0twpxn/qhqjJw2zVig3i+P7saVXlXADzihFwDG1AYC5zvgZWn
 mNe85tgfJeyqyRM6l3SarGtFKFIpVugzsd/xhQdc0U0VCoHhDtKrXHdt2lKagz2QB4WK
 vNWuKwFAcN6rYAL39YUrOkSDOWwtP1m31bpK1hfR/FE2trbiIWOY1ehGd9eQUk4/jQRs
 NGJsqCj9Y6904z2Ztz5PWXVW5W7Xo+clWqBDdn6bW0HRlMK1SpSKCwgYloVC23KXYV7i
 OJOo4hUh7s0PhDrHE+xo4khiI09oZwLFYmNvgE0a5jdJkDWsC3zDE9JxGGuoOzxsilsR
 rJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=crLC6KNPSW6pjgkY7QG68MqSuOvzKzstw/mmXuRH0uQ=;
 b=ZBwKBAAPmHkW95Skkmi/OQtAibmC/VpdRyhw/UuX24jHolxD8ksXkUymkOjFmTOt53
 5QRCd2VjOrCTNTwYZ44EctQ+JOWdA6Y/uInzLz8tPRJiLrVSqkNcwQW6ojAgWH0/pHp+
 3Lh5WD5NduRo8OhWh851MBjAm9Wk9III2ZORkFbPONUdQsxrqEa3dVAOzn51OcsnyzQ8
 wLgOPp+U2BCD8bwdI8m1WG90Y+t1EC/Dur7YqL8n+V3WKMmy0BOhNZLximBs7so8/VPB
 46NpFVk2qRsfgg0O6Kc/Tg4VtSGsXeBSdDgyXqmU2APlOB69IZpucQk7AfFGIEzSwJaB
 iSlA==
X-Gm-Message-State: AOAM530Lz0/7eO+DlPvKKpqcWXpaVEktDtaJMFcMfsloDmCQ3orAtbX2
 YwOtttD4vSsREkC/SrqVGyKXHqdQdCj3B6J79w==
X-Google-Smtp-Source: ABdhPJwOno2FbkMIPrVxa3r/Jv3jyWkFh+CTqMQaXEkKcA6CWeuJZGCXA3mA7lF2W+OMJmTOcLVCDYV3FJvU1Uwfjg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:3a50:90b2:e6a2:9060])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:ed1:0:b0:624:4085:cd0c with SMTP
 id a17-20020a5b0ed1000000b006244085cd0cmr5397836ybs.574.1645760425872; Thu,
 24 Feb 2022 19:40:25 -0800 (PST)
Date: Thu, 24 Feb 2022 19:34:47 -0800
In-Reply-To: <20220225033548.1912117-1-kaleshsingh@google.com>
Message-Id: <20220225033548.1912117-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220225033548.1912117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 2/8] KVM: arm64: Introduce pkvm_alloc_private_va_range()
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
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

pkvm_hyp_alloc_private_va_range() can be used to reserve private VA ranges
in the pKVM nVHE hypervisor (). Also update __pkvm_create_private_mapping()
to allow specifying an alignment for the private VA mapping.

These will be used to implement stack guard pages for pKVM nVHE hypervisor
(in a subsequent patch in the series).

Credits to Quentin Perret <qperret@google.com> for the idea of moving
private VA allocation out of __pkvm_create_private_mapping()

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v4:
  - Handle null ptr in pkvm_alloc_private_va_range() and replace
    IS_ERR_OR_NULL checks in callers with IS_ERR checks, per Fuad
  - Fix kernel-doc comments format, per Fuad
  - Format __pkvm_create_private_mapping() prototype args (< 80 col), per Fuad

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark

Changes in v2:
  - Allow specifying an alignment for the private VA allocations, per Marc

 arch/arm64/kvm/hyp/include/nvhe/mm.h |  3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  5 ++-
 arch/arm64/kvm/hyp/nvhe/mm.c         | 60 +++++++++++++++++-----------
 arch/arm64/kvm/mmu.c                 |  2 +-
 4 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 2d08510c6cc1..76d6fcf1d4f4 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -20,7 +20,8 @@ int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
-					    enum kvm_pgtable_prot prot);
+				size_t align, enum kvm_pgtable_prot prot);
+unsigned long pkvm_alloc_private_va_range(size_t size, size_t align);
 
 static inline void hyp_vmemmap_range(phys_addr_t phys, unsigned long size,
 				     unsigned long *start, unsigned long *end)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5e2197db0d32..96b2312a0f1d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -158,9 +158,10 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 {
 	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
 	DECLARE_REG(size_t, size, host_ctxt, 2);
-	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
+	DECLARE_REG(size_t, align, host_ctxt, 3);
+	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 4);
 
-	cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, prot);
+	cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, align, prot);
 }
 
 static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 526a7d6fa86f..e6355180aa49 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -37,38 +37,53 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
-unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
-					    enum kvm_pgtable_prot prot)
+/**
+ * pkvm_alloc_private_va_range - Allocates a private VA range.
+ * @size:	The size of the VA range to reserve.
+ * @align:	The required alignment for the allocation.
+ *
+ * The private VA range is allocated above __io_map_base.
+ */
+unsigned long pkvm_alloc_private_va_range(size_t size, size_t align)
 {
-	unsigned long addr;
-	int err;
+	unsigned long base, addr;
 
 	hyp_spin_lock(&pkvm_pgd_lock);
 
-	size = PAGE_ALIGN(size + offset_in_page(phys));
-	addr = __io_map_base;
-	__io_map_base += size;
+	addr = ALIGN(__io_map_base, align);
+
+	/* The allocated size is always a multiple of PAGE_SIZE */
+	base = addr + PAGE_ALIGN(size);
 
 	/* Are we overflowing on the vmemmap ? */
-	if (__io_map_base > __hyp_vmemmap) {
-		__io_map_base -= size;
+	if (!addr || base > __hyp_vmemmap)
 		addr = (unsigned long)ERR_PTR(-ENOMEM);
-		goto out;
-	}
-
-	err = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, prot);
-	if (err) {
-		addr = (unsigned long)ERR_PTR(err);
-		goto out;
-	}
+	else
+		__io_map_base = base;
 
-	addr = addr + offset_in_page(phys);
-out:
 	hyp_spin_unlock(&pkvm_pgd_lock);
 
 	return addr;
 }
 
+unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
+				size_t align, enum kvm_pgtable_prot prot)
+{
+	unsigned long addr;
+	int err;
+
+	size += offset_in_page(phys);
+	addr = pkvm_alloc_private_va_range(size, align);
+	if (IS_ERR((void *)addr))
+		return addr;
+
+	err = __pkvm_create_mappings(addr, size, phys, prot);
+	if (err)
+		return  (unsigned long)ERR_PTR(err);
+
+	return addr + offset_in_page(phys);
+}
+
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot)
 {
 	unsigned long start = (unsigned long)from;
@@ -152,10 +167,9 @@ int hyp_map_vectors(void)
 		return 0;
 
 	phys = __hyp_pa(__bp_harden_hyp_vecs);
-	bp_base = (void *)__pkvm_create_private_mapping(phys,
-							__BP_HARDEN_HYP_VECS_SZ,
-							PAGE_HYP_EXEC);
-	if (IS_ERR_OR_NULL(bp_base))
+	bp_base = (void *)__pkvm_create_private_mapping(phys, __BP_HARDEN_HYP_VECS_SZ,
+							PAGE_SIZE, PAGE_HYP_EXEC);
+	if (IS_ERR(bp_base))
 		return PTR_ERR(bp_base);
 
 	__hyp_bp_vect_base = bp_base;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a4868a6fa1c3..433c49766671 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -506,7 +506,7 @@ int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 
 	if (!kvm_host_owns_hyp_mappings()) {
 		addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
-					 phys_addr, size, prot);
+					 phys_addr, size, align, prot);
 		if (IS_ERR((void *)addr))
 			return PTR_ERR((void *)addr);
 		*haddr = addr;
-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
