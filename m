Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2184C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77CDB64F3F
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77CDB64F3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AB284B68E;
	Tue,  2 Mar 2021 10:01:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CDXSBSOOEiB0; Tue,  2 Mar 2021 10:01:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5D7F4B67E;
	Tue,  2 Mar 2021 10:01:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBCC04B654
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9zyKsHMlXVYL for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:01:02 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E46CF4B688
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:01 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id p37so3788153qtb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=ul+o/tKmUBDOvYf9j24b0RRB4JIOz9FDoTsxVSxSXxM=;
 b=pW+u784h5cAco+WjZOeMEiOygQj1G34XbUjvs4ZXhx71GX9qwAHjt8XzF6oHZuDXwa
 wgH83z4PpOrQySx6tyjngu/mMG9opxnaGjMuW8fPgRw9ksCt32BlXarMT6Il7ZiaqZpn
 7mUiXkToZK1hphH6grtrtlOBQCywTGirf+rTHNtbVoZP+um/QY9vdrNEQNwSj0MNJiS+
 MIfwIQ4+QJGxoFsu7TAUOUcWNUeh+1aslU2OU1gnPefp+jW4YYjwrcvgJL0BBeFgLTJt
 L9uyxaiydQT4m4S48zXW72AmDfQx9xnJu2HB5JldL4/g248HlHOYz2ya1frny7PUEufs
 S6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ul+o/tKmUBDOvYf9j24b0RRB4JIOz9FDoTsxVSxSXxM=;
 b=YugPeSdBWP9dlK1jmHjym7jS1cE8a6d43DXsGOaLt2y8h/19GQ4gIYGje0NZQBXRLD
 u6DczUzu2znL05+1gWyKmZhVr0/oV6+70lHPXnI+K3ABgO0xho0Ea3+tjdT0srIayFwK
 EFyzuv7UKC6J7+Ix0OxGUK4xC958EOwgPwfgcA//W+ahtXbEXzH5zRTcjSQgFZWjbFab
 R5suUP6V9lBJXJakW2xTxhpJd323Dc2HjmwfGqPubZUVQfQawRodftWG0wFLALOjTuA2
 L/QacNcQWdtTHQqG9VNac+DKeXZh0xHXYEn48JF0VwF8qzTe26YMLpyi+PE5DEP15vyC
 jXfA==
X-Gm-Message-State: AOAM531cl1bk6Gojdth7aI93NTYKMOP5824vuGwgU9Mv60+7/5wAdL7/
 BsOebHF4BkP31vhjUxK2a1JsiCG1H9ET
X-Google-Smtp-Source: ABdhPJximV251/TA30yUjyxYuWzjKdxc4ib1kbnL5JjOJcV3XkuAkOyM4ZeRll9baZr9V40/GNB29ZHFcFmT
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:b59f:: with SMTP id
 g31mr19967030qve.28.1614697260716; Tue, 02 Mar 2021 07:01:00 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:54 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-25-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 24/32] KVM: arm64: Reserve memory for host stage 2
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

Extend the memory pool allocated for the hypervisor to include enough
pages to map all of memory at page granularity for the host stage 2.
While at it, also reserve some memory for device mappings.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h | 23 ++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c      | 12 ++++++++++++
 arch/arm64/kvm/hyp/reserved_mem.c    |  2 ++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index ac0f7fcffd08..411a35db949c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -53,7 +53,7 @@ static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
 	return total;
 }
 
-static inline unsigned long hyp_s1_pgtable_pages(void)
+static inline unsigned long __hyp_pgtable_total_pages(void)
 {
 	unsigned long res = 0, i;
 
@@ -63,9 +63,30 @@ static inline unsigned long hyp_s1_pgtable_pages(void)
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
+	return __hyp_pgtable_total_pages() + 16;
+}
+
+static inline unsigned long host_s2_dev_pgtable_pages(void)
+{
+	/* Allow 1 GiB for private mappings */
+	return __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
+}
+
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 178ec06f2b49..7e923b25271c 100644
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
