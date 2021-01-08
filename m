Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26010C4332D
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A1C782399A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1C782399A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EED44B452;
	Fri,  8 Jan 2021 07:16:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lfhb2ODvXGRx; Fri,  8 Jan 2021 07:16:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 592E54B3D8;
	Fri,  8 Jan 2021 07:16:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 139AA4B192
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PMs8gm-4icuo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:16:21 -0500 (EST)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1C704B3EA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:20 -0500 (EST)
Received: by mail-qt1-f202.google.com with SMTP id i1so8141210qtw.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=ubj9eKj6feW724lUWuvX7193xJxAVUWYCd7LIBt/xZM=;
 b=ZyLpAlcpBv9O9CVzJMFTVvbJ+v6N6/MlI5lagtaZQ42jam3KCDm199szqV8m1XH6vm
 6GtLu1qOGyZthvo9l8MWkzfw/K4Xl7I4QFtfnfMIduarldtpphBLWUhCRFPwAl/SpFil
 MHMQ6ecjKrZdBANGg/u/TkAGtRynKiY+Sk/NiOrxwBMvVNpOuaEXjziQfL/DUqHuhahi
 0r6ZiITozRE25Td67i0Nq3Ldf5/d3TJNfFj9+Nl3f3DybGKwfPV2ON93JUo21Higyxi8
 P7ZnY2P8LAGAth/TT6nZsVWvGdmVB6IOZcbIPfZk4vnIxtEk1euUBNhPnbgVeBpb5uEQ
 KI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ubj9eKj6feW724lUWuvX7193xJxAVUWYCd7LIBt/xZM=;
 b=ApcueqJE5CQhhVyVuVjLU23CagcVptoEwB+V58iCSogeC0C9q1ErIHrXuEnmyR4CiE
 XJZSaCSQpGU6IWmktt4/rT3RpBXInXmdCkZlQI/jgw89WOoyah4HothzDntKoItBbAgn
 PssDUfdV2TW42KdsY/r1WNrK7UBHEyt6Gi7CGnexZROqm+FdbJUWCj2clLfPFj4XhlkV
 3phOp6/6GsYUrlsh93MhfjsV+YRmtEbIbqoucLrjZ4VqYClPqi6AZFuMIWcGowETfii2
 1HxxVsrdRwbtN3hnuPTO1MGsRWsOHTIp/DJ6aEDCKsuOi0cKSN9vyntK/deIj8a69QAS
 ALZA==
X-Gm-Message-State: AOAM530MnJH7YDPJbJ5DeYh3o+nJudCkcBpRw0t/vwtN9bk2SmoYoNcV
 ZZBxhAiVSd8YHB7j+RqCHu2gHwwC/VQp
X-Google-Smtp-Source: ABdhPJwsPu8BKRBWZUjzdMSkwBKnShyda60jjXL5FbZKOAM/v5VuP41Mk0K0+RI4xm3tuDvT7Z/bcAxZqOYT
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:4b21:: with SMTP id
 s1mr6284968qvw.59.1610108180588; Fri, 08 Jan 2021 04:16:20 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:23 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-26-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 25/26] KVM: arm64: Reserve memory for host stage 2
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
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
index f0cc09b127a5..cdf2e3447b2a 100644
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
index 6d1faede86ae..79b697df01e2 100644
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
index 32f648992835..ee97e55e3c59 100644
--- a/arch/arm64/kvm/hyp/reserved_mem.c
+++ b/arch/arm64/kvm/hyp/reserved_mem.c
@@ -74,6 +74,8 @@ void __init kvm_hyp_reserve(void)
 	 */
 	hyp_mem_size += NR_CPUS << PAGE_SHIFT;
 	hyp_mem_size += hyp_s1_pgtable_size();
+	hyp_mem_size += host_s2_mem_pgtable_size();
+	hyp_mem_size += host_s2_dev_pgtable_size();
 
 	/*
 	 * The hyp_vmemmap needs to be backed by pages, but these pages
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
