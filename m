Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D9DC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A21D64EF6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A21D64EF6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2514B74B;
	Fri, 19 Mar 2021 06:02:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RJK1hs4Yn1U0; Fri, 19 Mar 2021 06:02:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BBFB4B722;
	Fri, 19 Mar 2021 06:02:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF264B712
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h8mMLKjoVohH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:46 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 100A24B556
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:46 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id o9so4387668wmq.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XmlXvszH/b/asNjtzAQpiqetpKnqM2IpsKRJDC1QZ6Q=;
 b=n4Dk7ghOSzuv6hVrIpa0xZkXJiJp/2GO82+nTiQ8hFfxhtk7tfUubAu5G6oAsbQ3B0
 J/XUIjaZfAGthgBmJZnzVE7NvdMLH7gOUo3BNzXhIqUHXTczuV3LrPo2veo6MqS0Vr18
 BZ2PaFQo3EVEHLmVITwSYsopCbG6T5mhJlHfW78S6B9IAiknDWxS7ZcEpBpZf4kDtvDG
 1TQVQ/lMArkzLkuu5rRrjpTVy0B/G+/vRlL+P0QaA9wAPeyOX0fPLGqIKOy7t7G5nQWF
 Fs1v54qAANB1TYF5F8ggD8dCP72Rfo6Z0PA9awAi+CXrXvkOt3vI34oofG/rj38cYwLT
 G17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XmlXvszH/b/asNjtzAQpiqetpKnqM2IpsKRJDC1QZ6Q=;
 b=LaZdICk2SaqLeb+dWvLUD1tGEKlQp3GqBim1MM3J/7B2WcdnbAnTnKcBG0oEF/eIwt
 bjqiE/SU2sLdn/4t+3mFNDbKA9ziU3scGkOZDV6aynMw0sVlu+bjL0GuJP9Fw2SY5w3O
 l7cThjSn4bem8L6dsGt7jYXtffyqZ4U8wd8aH8wFG+eg+GHOwhQxlhXe2G495kzzAGt1
 xw/Ver5ZfMJXtNJhdsljVcxIVUz27NtzfEmJJ39M6olO6dMF82L4Y9EsWUL7yVBX8bQb
 BoI4kcD/jK6+ovbCxk5wjK7vT9J9P3Lxu3lkgWx7DleaCDA7gjjGb3S2KoD2cvyC814Q
 p4fg==
X-Gm-Message-State: AOAM531FEolcrEY/NtBaRlek8cq5lrwIXcBXIlkvoDbGGIXUr0yvR/wb
 st3ecNI2gVnIhT2V8mrPvXh5eIFR/acv
X-Google-Smtp-Source: ABdhPJyKLub7Z2Ft8FpJd3MRpj7QJlTmb4+0KdzJwP4kzpAVYBqTYcgFFYc/BSNYBr8q/foqT52fgwT7jAlv
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:290b:: with SMTP id
 i11mr3046295wmd.129.1616148165171; Fri, 19 Mar 2021 03:02:45 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:34 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-27-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 26/38] KVM: arm64: Reserve memory for host stage 2
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

Extend the memory pool allocated for the hypervisor to include enough
pages to map all of memory at page granularity for the host stage 2.
While at it, also reserve some memory for device mappings.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h | 27 ++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c      | 12 ++++++++++++
 arch/arm64/kvm/hyp/reserved_mem.c    |  2 ++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index ac0f7fcffd08..0095f6289742 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -53,7 +53,7 @@ static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
 	return total;
 }
 
-static inline unsigned long hyp_s1_pgtable_pages(void)
+static inline unsigned long __hyp_pgtable_total_pages(void)
 {
 	unsigned long res = 0, i;
 
@@ -63,9 +63,34 @@ static inline unsigned long hyp_s1_pgtable_pages(void)
 		res += __hyp_pgtable_max_pages(reg->size >> PAGE_SHIFT);
 	}
 
+	return res;
+}
+
+static inline unsigned long hyp_s1_pgtable_pages(void)
+{
+	unsigned long res;
+
+	res = __hyp_pgtable_total_pages();
+
 	/* Allow 1 GiB for private mappings */
 	res += __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
 
 	return res;
 }
+
+static inline unsigned long host_s2_mem_pgtable_pages(void)
+{
+	/*
+	 * Include an extra 16 pages to safely upper-bound the worst case of
+	 * concatenated pgds.
+	 */
+	return __hyp_pgtable_total_pages() + 16;
+}
+
+static inline unsigned long host_s2_dev_pgtable_pages(void)
+{
+	/* Allow 1 GiB for MMIO mappings */
+	return __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
+}
+
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 1e8bcd8b0299..c1a3e7e0ebbc 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -24,6 +24,8 @@ unsigned long hyp_nr_cpus;
 
 static void *vmemmap_base;
 static void *hyp_pgt_base;
+static void *host_s2_mem_pgt_base;
+static void *host_s2_dev_pgt_base;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
@@ -42,6 +44,16 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	if (!hyp_pgt_base)
 		return -ENOMEM;
 
+	nr_pages = host_s2_mem_pgtable_pages();
+	host_s2_mem_pgt_base = hyp_early_alloc_contig(nr_pages);
+	if (!host_s2_mem_pgt_base)
+		return -ENOMEM;
+
+	nr_pages = host_s2_dev_pgtable_pages();
+	host_s2_dev_pgt_base = hyp_early_alloc_contig(nr_pages);
+	if (!host_s2_dev_pgt_base)
+		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
index 9bc6a6d27904..fd42705a3c26 100644
--- a/arch/arm64/kvm/hyp/reserved_mem.c
+++ b/arch/arm64/kvm/hyp/reserved_mem.c
@@ -52,6 +52,8 @@ void __init kvm_hyp_reserve(void)
 	}
 
 	hyp_mem_pages += hyp_s1_pgtable_pages();
+	hyp_mem_pages += host_s2_mem_pgtable_pages();
+	hyp_mem_pages += host_s2_dev_pgtable_pages();
 
 	/*
 	 * The hyp_vmemmap needs to be backed by pages, but these pages
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
