Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F8EC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B324611AD
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B324611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B30C54B159;
	Wed, 13 Oct 2021 11:59:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2MygAywyNXNB; Wed, 13 Oct 2021 11:59:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2003A4B13E;
	Wed, 13 Oct 2021 11:59:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4202B4B13A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3zfQTNr7gGft for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:58:58 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26C5B4B11F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:58 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 10-20020a5d47aa000000b001610cbda93dso2309895wrb.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GgLFMX5ztF6MYNVqoJJByZkg6Wz7p+0QQnn9yyaHjyk=;
 b=cUeoq1DeA87knFLwnUtEgKxY640obWSkOmx7AfI3ZJdKiaB6Mx8rYTVKhNur1p87QB
 jm9ZaR/lI0BJG1IX3S2G7KPqWoItGL5ubgXk8A3ThwjlnGXWXTFuvnQLUDi9HnHWWMWY
 oj1BPDy46BPaw6G9ju6PLhpN2geyNjQ7KHUYpJH2FzlmIDiStfRs+ZAPrx/9VnFeG00N
 Xh8arHQniKhSNwtLAmoFpn9z4CiaUNi8HP4k1rIX/nfjhUqrglB/BShDGi56lWAICv2k
 xyPA38fgIGMrmJbxsCNuuEyMuM7lP/hOo1LvhRqPCaED1bbCdjWGx0Zl/XAfsq/MflpU
 2pQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GgLFMX5ztF6MYNVqoJJByZkg6Wz7p+0QQnn9yyaHjyk=;
 b=cza3/EPGjXyI6hl5vXcYAUwpwwjMaAaaGFWirR5sKMTSJmuhupkzDFq34Z37JgzHv3
 6tFaSf5qQUa302NbWUniCo3pIx8u4Pk9TkyuB5ZVsHEdTXZPsYMn2KHk/bhLpba+fYQ4
 fcCaur4xITOPkXKXNChzUXI+4xEQ2oYG/mU0FbBQ5wU3vAQFmuWjnih59Nc6OGKRq8fS
 I/jhjHtERADN1nbLypxue28AoOk48tTkKNHeGm8Rs5H8koVfJL+NcwR62iH86rAwyR/K
 GEGQ6BPPS7vzdGI3NtDFZY6kKV26fo8TjwrWXJxCOFFBpeM50Ctv3X3f4EU9A/Wi9Srg
 jqhQ==
X-Gm-Message-State: AOAM533rbuCdF4FGwVlAaoiMwv/0CULnyHDfjIcROSf11jZ4a9MkEQpW
 0ixKaAr8qIdtWuzBm5Xjqlq1oNb7xzQV
X-Google-Smtp-Source: ABdhPJx39xlz/CuqQEOAPZTgH38vTKO4XOGwFEQgLo6W0tWY3kTr+StXLmrf/wZMhbyCtA1/odiou1VmT96v
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a05:600c:1c05:: with SMTP id
 j5mr142153wms.1.1634140737029; Wed, 13 Oct 2021 08:58:57 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:25 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-11-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 10/16] KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

From: Will Deacon <will@kernel.org>

Implement kvm_pgtable_hyp_unmap() which can be used to remove hypervisor
stage-1 mappings at EL2.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 21 ++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 63 ++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 027783829584..9d076f36401d 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -251,6 +251,27 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
 int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 			enum kvm_pgtable_prot prot);
 
+/**
+ * kvm_pgtable_hyp_unmap() - Remove a mapping from a hypervisor stage-1 page-table.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_hyp_init().
+ * @addr:	Virtual address from which to remove the mapping.
+ * @size:	Size of the mapping.
+ *
+ * The offset of @addr within a page is ignored, @size is rounded-up to
+ * the next page boundary and @phys is rounded-down to the previous page
+ * boundary.
+ *
+ * TLB invalidation is performed for each page-table entry cleared during the
+ * unmapping operation and the reference count for the page-table page
+ * containing the cleared entry is decremented, with unreferenced pages being
+ * freed. The unmapping operation will stop early if it encounters either an
+ * invalid page-table entry or a valid block mapping which maps beyond the range
+ * being unmapped.
+ *
+ * Return: Number of bytes unmapped, which may be 0.
+ */
+u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
+
 /**
  * kvm_get_vtcr() - Helper to construct VTCR_EL2
  * @mmfr0:	Sanitized value of SYS_ID_AA64MMFR0_EL1 register.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 768a58835153..6ad4cb2d6947 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -463,6 +463,69 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 	return ret;
 }
 
+struct hyp_unmap_data {
+	u64				unmapped;
+	struct kvm_pgtable_mm_ops	*mm_ops;
+};
+
+static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			    enum kvm_pgtable_walk_flags flag, void * const arg)
+{
+	kvm_pte_t pte = *ptep, *childp = NULL;
+	u64 granule = kvm_granule_size(level);
+	struct hyp_unmap_data *data = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+
+	if (!kvm_pte_valid(pte))
+		return -EINVAL;
+
+	if (kvm_pte_table(pte, level)) {
+		childp = kvm_pte_follow(pte, mm_ops);
+
+		if (mm_ops->page_count(childp) != 1)
+			return 0;
+
+		kvm_clear_pte(ptep);
+		dsb(ishst);
+		__tlbi_level(vae2is, __TLBI_VADDR(addr, 0), level);
+	} else {
+		if (end - addr < granule)
+			return -EINVAL;
+
+		kvm_clear_pte(ptep);
+		dsb(ishst);
+		__tlbi_level(vale2is, __TLBI_VADDR(addr, 0), level);
+		data->unmapped += granule;
+	}
+
+	dsb(ish);
+	isb();
+	mm_ops->put_page(ptep);
+
+	if (childp)
+		mm_ops->put_page(childp);
+
+	return 0;
+}
+
+u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct hyp_unmap_data unmap_data = {
+		.mm_ops	= pgt->mm_ops,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb	= hyp_unmap_walker,
+		.arg	= &unmap_data,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+	};
+
+	if (!pgt->mm_ops->page_count)
+		return 0;
+
+	kvm_pgtable_walk(pgt, addr, size, &walker);
+	return unmap_data.unmapped;
+}
+
 int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 			 struct kvm_pgtable_mm_ops *mm_ops)
 {
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
