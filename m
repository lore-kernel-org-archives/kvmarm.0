Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2EAC2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08D912465E
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="OEoAZqf/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08D912465E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B455F4B8EE;
	Tue, 17 Nov 2020 13:17:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zTpRylYV1C6n; Tue, 17 Nov 2020 13:17:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7924B8ED;
	Tue, 17 Nov 2020 13:17:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BAD54B7DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fCEc0Wdo+CTV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:17:18 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B7BB4B60C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:18 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id k128so2127694wme.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=U9buW3EkB/K6NinBuCPzqj4JKuwVqT/SXDU0SZ8bieQ=;
 b=OEoAZqf/nKz8y4wwbNx4ce9JZPHSdATgOxmylZEZ63UUl4SLy8rF5lv+5jh8HRhWHV
 l3jGcsZVeScg2fnHeX8O1ZoHr2neKk6P/nYD6Urly0tw8n40b2B5togib9oJ6S8u3J2G
 DFJzS6t4+o1+m2Wrt+X107G2mNv5796ZBQ3LThG4GqG3MHwAyh/szE5NsseL5rxg6NbE
 jradhxYJAJ+gyWiQzQs70x7NpeqFztQHGIra3pXzLaVk+w+fYaQrxiIKC6MLVCNPhS1a
 WAn/iamjzPdbSB5+T9yPzgX/YFXLTSRG0UxqXOOA97dB1iR3N49f6Pd3LVxRUZ/1Iq49
 GbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=U9buW3EkB/K6NinBuCPzqj4JKuwVqT/SXDU0SZ8bieQ=;
 b=o3QxAZbGoR/KK0Cud0RPF1dlNHCelcVW5iRb7zVe5T8YzvGtt0aD0F8jHc3lLZ3NOy
 EyMPEsIo5i75WuG9rKxw54cg2rqHv17SakFFTlfDzLTLcc/8IDC6QTcKSQts/c4XXVFZ
 styILQSqpmuAQJFxLpiw6zdbd5IgGjNCsU+QOqjd/5wMs5L6c7WtyEn2lMh4FC/BKNfY
 1HhBt4gaTj+bAwkcn4k/HqL/LK1NDuy2bos1v/1Vxbd+2GWwXpg9yZi7v212xtEkr/YV
 i49xYmiNKHGzGmdlLfGCFIpstRNneYuEPLY31n+QkbwyPYhGX5qklCFQi8jCQBRVLhMt
 xmtA==
X-Gm-Message-State: AOAM5316TZYR8zTpOYnmVfThiTPacM5sUmqudkqB+Ax5zTHpXqh2wdVy
 Awvs4+p+/RC0f7wzMadQ+vFK/4QyPBd4
X-Google-Smtp-Source: ABdhPJxdY+lqNlpPzdnmipW4jOsekrda/kjR1w92gZ+51XZgmNLFCJj9D0pJqUaOPEVX/Dsw6fZ/dN80t1P3
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:adf:a3ca:: with SMTP id
 m10mr842044wrb.228.1605637037211; Tue, 17 Nov 2020 10:17:17 -0800 (PST)
Date: Tue, 17 Nov 2020 18:16:05 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-26-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 25/27] KVM: arm64: Reserve memory for host stage 2
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

Extend the memory pool allocated for the hypervisor to include enough
pages to map all of memory at page granularity for the host stage 2.
While at it, also reserve some memory for device mappings.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h | 36 ++++++++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/setup.c      | 12 ++++++++++
 arch/arm64/kvm/hyp/reserved_mem.c    |  2 ++
 3 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 5a3ad6f4e5bc..b79be2580164 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -52,15 +52,12 @@ static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
 	return total;
 }
 
-static inline unsigned long hyp_s1_pgtable_size(void)
+static inline unsigned long __hyp_pgtable_total_size(void)
 {
 	struct hyp_memblock_region *reg;
 	unsigned long nr_pages, res = 0;
 	int i;
 
-	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
-		return 0;
-
 	for (i = 0; i < kvm_nvhe_sym(hyp_memblock_nr); i++) {
 		reg = &kvm_nvhe_sym(hyp_memory)[i];
 		nr_pages = (reg->end - reg->start) >> PAGE_SHIFT;
@@ -68,6 +65,18 @@ static inline unsigned long hyp_s1_pgtable_size(void)
 		res += nr_pages << PAGE_SHIFT;
 	}
 
+	return res;
+}
+
+static inline unsigned long hyp_s1_pgtable_size(void)
+{
+	unsigned long res, nr_pages;
+
+	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
+		return 0;
+
+	res = __hyp_pgtable_total_size();
+
 	/* Allow 1 GiB for private mappings */
 	nr_pages = (1 << 30) >> PAGE_SHIFT;
 	nr_pages = __hyp_pgtable_max_pages(nr_pages);
@@ -76,4 +85,23 @@ static inline unsigned long hyp_s1_pgtable_size(void)
 	return res;
 }
 
+static inline unsigned long host_s2_mem_pgtable_size(void)
+{
+	unsigned long max_pgd_sz = 16 << PAGE_SHIFT;
+
+	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
+		return 0;
+
+	return __hyp_pgtable_total_size() + max_pgd_sz;
+}
+
+static inline unsigned long host_s2_dev_pgtable_size(void)
+{
+	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
+		return 0;
+
+	/* Allow 1 GiB for private mappings */
+	return __hyp_pgtable_max_pages((1 << 30) >> PAGE_SHIFT) << PAGE_SHIFT;
+}
+
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 9679c97b875b..b73e6b08cfba 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -24,6 +24,8 @@ unsigned long hyp_nr_cpus;
 static void *stacks_base;
 static void *vmemmap_base;
 static void *hyp_pgt_base;
+static void *host_s2_mem_pgt_base;
+static void *host_s2_dev_pgt_base;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
@@ -46,6 +48,16 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	if (!hyp_pgt_base)
 		return -ENOMEM;
 
+	nr_pages = host_s2_mem_pgtable_size() >> PAGE_SHIFT;
+	host_s2_mem_pgt_base = hyp_early_alloc_contig(nr_pages);
+	if (!host_s2_mem_pgt_base)
+		return -ENOMEM;
+
+	nr_pages = host_s2_dev_pgtable_size() >> PAGE_SHIFT;
+	host_s2_dev_pgt_base = hyp_early_alloc_contig(nr_pages);
+	if (!host_s2_dev_pgt_base)
+		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
index 02b0b18006f5..c2c0484b6211 100644
--- a/arch/arm64/kvm/hyp/reserved_mem.c
+++ b/arch/arm64/kvm/hyp/reserved_mem.c
@@ -47,6 +47,8 @@ void __init reserve_kvm_hyp(void)
 
 	hyp_mem_size += num_possible_cpus() << PAGE_SHIFT;
 	hyp_mem_size += hyp_s1_pgtable_size();
+	hyp_mem_size += host_s2_mem_pgtable_size();
+	hyp_mem_size += host_s2_dev_pgtable_size();
 
 	/*
 	 * The hyp_vmemmap needs to be backed by pages, but these pages
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
