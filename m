Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA9CC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 09:28:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8A4149F48;
	Fri, 11 Feb 2022 04:28:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lcrKQSyooy-L; Fri, 11 Feb 2022 04:28:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC3934A3A5;
	Fri, 11 Feb 2022 04:28:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1156849F53
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:44:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dr64LF9yfJVF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 17:44:02 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1399849F4B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:44:02 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 z15-20020a25bb0f000000b00613388c7d99so15120262ybg.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=FWvONc6PPT7SOgcpYOOzYgnlsLgy4lIL2CKlJJtukzs=;
 b=mBuynU6nVtUUhgSN/Mzp+TKEbV4pFhe3dtKgEyVMOiwApKF6+HLlSY4gE57X5hOP70
 rAAiYgmNoRwzjL9PRCjeUoKyBvbWi9KRQIFADz3Q6trpDjsIh8e/dl0J/VD9kGCwAI+J
 BESFy4HJ4E6dX5+yow+EWQQLwzm01n1PyiQJhfT9IrZs+BepkmJI7SxxevOSmOe5Zkde
 eBCAolmAIMIZry/9HLPgsUjMn0zqebgFcw0PnbcfnYgLHiakd0mei8onuiCvnJNdqIbB
 Mix+BHSyf/9IvbRtthvYA/aAELP0sccVnHZzFmlpWyLkFP2bSNkbmY8rnK0kh6Acc1Vw
 G2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=FWvONc6PPT7SOgcpYOOzYgnlsLgy4lIL2CKlJJtukzs=;
 b=yCriKl4t4a3DxTjEn/pUCOayEMHuP1N73uUAyhgYjy0q55gxYhNg3Nq8/cymemh5OJ
 m7uUM5E7stumINTgqFC65tpEyiay2QhRcn+d8iy4TGDhSENwPVCOVotAxmFHcMJ+dCZL
 n5XQr7ls7IFs3AOcN3mdoySKgLdcQ0lIuqZfUmt9qC7XnM19fPHIUwi7doS5Zib1rWYp
 N1wsI9vhLCDv8OlwcpQ53Zaf9eBi3D+vx9342f+ssiU/TGT9FL1RIkjGC+EobVt8Hnh1
 W+43WaUK5nGnCHVWV5QeAtH6lMGmTkmept1/DbAtYs1d5I1Dm1FHrR1PxrVKCMKAWbTZ
 wcfQ==
X-Gm-Message-State: AOAM533xDsXb0pje9QGnXNT0QIzZuvqmPCnYMlmFH2jFtmgT+JvheCvg
 iSXLRX5pmL6EbVPjtZhKhoDn7AcOALTnYk8lJw==
X-Google-Smtp-Source: ABdhPJxZHBnjRsaIEqwkHqdAbXT7GDJWvj+cAd1UkPLHhqa+mVsLffzcbYP42soJ9363QIkLwEeaj1E/kFGFAp78sg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:8f02:232:ad86:2ab2])
 (user=kaleshsingh job=sendgmr) by 2002:a25:6f08:: with SMTP id
 k8mr8699054ybc.469.1644533041615; Thu, 10 Feb 2022 14:44:01 -0800 (PST)
Date: Thu, 10 Feb 2022 14:41:43 -0800
In-Reply-To: <20220210224220.4076151-1-kaleshsingh@google.com>
Message-Id: <20220210224220.4076151-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220210224220.4076151-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH 2/7] KVM: arm64: Factor out private range VA allocation
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 11 Feb 2022 04:28:10 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Pasha Tatashin <pasha.tatashin@soleen.com>, surenb@google.com,
 Peter Collingbourne <pcc@google.com>, linux-kernel@vger.kernel.org,
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

From: Quentin Perret <qperret@google.com>

__pkvm_create_private_mapping() is currently responsible for allocating
VA space in the hypervisor's "private" range and creating stage-1
mappings. In order to allow reusing the VA space allocation logic from
other places, let's factor it out in a standalone function. This is will
be used to allocate private VA ranges for hypervisor stack guard pages
in a subsequent patch in this series.

Signed-off-by: Quentin Perret <qperret@google.com>
[Kalesh - Resolve conflicts and make hyp_alloc_private_va_range
          available outside nvhe/mm.c, update commit message]
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mm.c         | 28 +++++++++++++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 2d08510c6cc1..f53fb0e406db 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -21,6 +21,7 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 					    enum kvm_pgtable_prot prot);
+unsigned long hyp_alloc_private_va_range(size_t size);
 
 static inline void hyp_vmemmap_range(phys_addr_t phys, unsigned long size,
 				     unsigned long *start, unsigned long *end)
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 526a7d6fa86f..e196441e072f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -37,6 +37,22 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
+unsigned long hyp_alloc_private_va_range(size_t size)
+{
+	unsigned long addr = __io_map_base;
+
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+	__io_map_base += PAGE_ALIGN(size);
+
+	/* Are we overflowing on the vmemmap ? */
+	if (__io_map_base > __hyp_vmemmap) {
+		__io_map_base = addr;
+		addr = (unsigned long)ERR_PTR(-ENOMEM);
+	}
+
+	return addr;
+}
+
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 					    enum kvm_pgtable_prot prot)
 {
@@ -45,16 +61,10 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 
 	hyp_spin_lock(&pkvm_pgd_lock);
 
-	size = PAGE_ALIGN(size + offset_in_page(phys));
-	addr = __io_map_base;
-	__io_map_base += size;
-
-	/* Are we overflowing on the vmemmap ? */
-	if (__io_map_base > __hyp_vmemmap) {
-		__io_map_base -= size;
-		addr = (unsigned long)ERR_PTR(-ENOMEM);
+	size = size + offset_in_page(phys);
+	addr = hyp_alloc_private_va_range(size);
+	if (IS_ERR((void *)addr))
 		goto out;
-	}
 
 	err = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, prot);
 	if (err) {
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
