Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223D4C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 10:36:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D335F4C035;
	Thu, 24 Feb 2022 05:36:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Tqfk2S0o0Hf; Thu, 24 Feb 2022 05:36:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B45924C037;
	Thu, 24 Feb 2022 05:36:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0609B4BE38
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:17:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YDczl-x5PArW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 00:17:16 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E6424BE36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:17:16 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 s22-20020a252d56000000b00624652ac3e1so889120ybe.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 21:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=zjkrHmiNRPu+xkjmRYtl/GGfGVxWhgBcWrDndSQY1ZI=;
 b=Q95PhZkuTj3mTiQTdWyA/cas59PM8HotrPoSBHBleUFfsGDZ+H8BDlNMcgFVXhTr9r
 /MI8YF1TH+9h5XzoX87kUd9gLIBzeivRDhdtwBvEaGcsB9JIMdTif9wH8Ad+3bWvCj4E
 qzBrRM/9BbZcs3edkYZnI0yYE9ptbzZ4KXUgpc+Y7Nqw5MVFoSG5XqrjLWTQV8HMt+PU
 /PN37+AdvRXsrKuxDxtHwLhYEQp8vJyCDk/iWAK7AsShDriIEyv7qTS3glTu3GBYpGBG
 tLPs8x375wqy623V/UueGb+TWcfsv+OZzuNSMLTGNBT1RgPIQsiBrqEFpIhGFXthhpQd
 CNAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=zjkrHmiNRPu+xkjmRYtl/GGfGVxWhgBcWrDndSQY1ZI=;
 b=SOUbfaJLgGsQYjCfYxNvy34n2sJMApqlIlHRtOgnTKSh7LkSDaNz5z4fu/+WJ8Ttss
 IYIbPtKnSGZzOPAzynd5tUp23UmZNaKdJRYsxqRdtNVolk+m8qp2R3TsJXI+DrC9stbm
 5FaDKYNvoWmGjlSav+95ArhLSTGnEVxyc7b+82f2eoQlzJyIuBXKGvCmdiEocrIn1hSA
 iuK2FV/WG/pLNW82D4wxRhjfTumNoC7r8wxzRxwYU0IsArKHbughGkxP2pr49DRentFc
 /WWjJ2FibVtPMtPASupa7of7TEJjEF55GI7Y11J6ThPmwGoH7IQoB+JeuNmxa3BXT5qv
 MnYA==
X-Gm-Message-State: AOAM532sghmCv+C7kcC7G7dnUFW6x3pHmg2CgUqKYtZVfhFfDl30iodn
 tXu8yFXNhPxr+fthwpqrkQ9qryBc41T77/Yc6A==
X-Google-Smtp-Source: ABdhPJwTsQs5w3bWg3HLZfUpV1mRpvUXTrwenTjM/5KRDY/s/xsywaNBh5k6hbdm6EBRXI1pEfunZGxTVf+s4otTCg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:415c:9be0:c461:440a])
 (user=kaleshsingh job=sendgmr) by 2002:a25:6911:0:b0:624:5f4b:2a01 with SMTP
 id e17-20020a256911000000b006245f4b2a01mr1014225ybc.303.1645679836014; Wed,
 23 Feb 2022 21:17:16 -0800 (PST)
Date: Wed, 23 Feb 2022 21:13:37 -0800
In-Reply-To: <20220224051439.640768-1-kaleshsingh@google.com>
Message-Id: <20220224051439.640768-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 2/8] KVM: arm64: Introduce pkvm_alloc_private_va_range()
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

pkvm_hyp_alloc_private_va_range() can be used to reserve private VA ranges
in the pKVM nVHE hypervisor (). Also update __pkvm_create_private_mapping()
to allow specifying an alignment for the private VA mapping.

These will be used to implement stack guard pages for pKVM nVHE hypervisor
(in a subsequent patch in the series).

Credits to Quentin Perret <qperret@google.com> for the idea of moving
private VA allocation out of __pkvm_create_private_mapping()

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark

Changes in v2:
  - Allow specifying an alignment for the private VA allocations, per Marc

 arch/arm64/kvm/hyp/include/nvhe/mm.h |  3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  5 +--
 arch/arm64/kvm/hyp/nvhe/mm.c         | 51 ++++++++++++++++++----------
 arch/arm64/kvm/mmu.c                 |  2 +-
 4 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 2d08510c6cc1..05d06ad00347 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -20,7 +20,8 @@ int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
-					    enum kvm_pgtable_prot prot);
+					size_t align, enum kvm_pgtable_prot prot);
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
index 526a7d6fa86f..f35468ec639d 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -37,26 +37,46 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
-unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
-					    enum kvm_pgtable_prot prot)
+/*
+ * Allocates a private VA range above __io_map_base.
+ *
+ * @size:	The size of the VA range to reserve.
+ * @align:	The required alignment for the allocation.
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
+	if (base > __hyp_vmemmap)
 		addr = (unsigned long)ERR_PTR(-ENOMEM);
+	else
+		__io_map_base = base;
+
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	return addr;
+}
+
+unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
+					size_t align, enum kvm_pgtable_prot prot)
+{
+	unsigned long addr;
+	int err;
+
+	size += offset_in_page(phys);
+	addr = pkvm_alloc_private_va_range(size, align);
+	if (IS_ERR((void *)addr))
 		goto out;
-	}
 
-	err = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, prot);
+	err = __pkvm_create_mappings(addr, size, phys, prot);
 	if (err) {
 		addr = (unsigned long)ERR_PTR(err);
 		goto out;
@@ -64,8 +84,6 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 
 	addr = addr + offset_in_page(phys);
 out:
-	hyp_spin_unlock(&pkvm_pgd_lock);
-
 	return addr;
 }
 
@@ -152,11 +170,10 @@ int hyp_map_vectors(void)
 		return 0;
 
 	phys = __hyp_pa(__bp_harden_hyp_vecs);
-	bp_base = (void *)__pkvm_create_private_mapping(phys,
-							__BP_HARDEN_HYP_VECS_SZ,
-							PAGE_HYP_EXEC);
+	bp_base = (void *)__pkvm_create_private_mapping(phys, __BP_HARDEN_HYP_VECS_SZ,
+							PAGE_SIZE, PAGE_HYP_EXEC);
 	if (IS_ERR_OR_NULL(bp_base))
-		return PTR_ERR(bp_base);
+		return bp_base ? PTR_ERR(bp_base) : -ENOMEM;
 
 	__hyp_bp_vect_base = bp_base;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fc09536c8197..298e6d8439ef 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -505,7 +505,7 @@ int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 
 	if (!kvm_host_owns_hyp_mappings()) {
 		addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
-					 phys_addr, size, prot);
+					 phys_addr, size, align, prot);
 		if (IS_ERR_OR_NULL((void *)addr))
 			return addr ? PTR_ERR((void *)addr) : -ENOMEM;
 		*haddr = addr;
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
