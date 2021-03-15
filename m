Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7AEC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87A5B6502D
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87A5B6502D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C37B4B5AA;
	Mon, 15 Mar 2021 10:36:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nUZKbDq+A53S; Mon, 15 Mar 2021 10:36:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C34054B6FD;
	Mon, 15 Mar 2021 10:36:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E5A24B223
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hAJPJyLC85Kp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:34 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F5004B649
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:34 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id j3so23192483qvo.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XmlXvszH/b/asNjtzAQpiqetpKnqM2IpsKRJDC1QZ6Q=;
 b=PLWGPtcPO447N2pO6R95sG7rL4oGVx0r8DVGs09d8RPZ+UAk/bpKyLsvpYEO7Jr09W
 7vEOA1LoSW6Vkbkkl04YI7eIQ4wLahgyU6ZvMQD2jorBU0h/hUzKifbMFLIt+3GiJgY8
 epbInKMYcsNC4twnTe4fVnovvofLaYfBIw1i7LfW+snvn5MmVBLdV6JJnWtIo8MjwYma
 CcmiweMhEBu/HkjjmDOKMIU5C4XDBW9B0Ok0x0S4nOebQEBLt+JaZ7H+IZlKTwf/qZVS
 gpVWR87Eawg6/JYS5YCefIwizWgjMpbV7Jy1xpLuE7E6qI96JG1o98zxfOf7wporssQb
 lUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XmlXvszH/b/asNjtzAQpiqetpKnqM2IpsKRJDC1QZ6Q=;
 b=H5LQgSpnzczEc2zXPoI1pSuCjuY+Jn3tdxr0auHt8ZjPHTV6ohZZZ2U64Sem/R+wFH
 f59twV673HUEnM4ulj8n/hASFt0FMpCw7jQUGaFtBCVJLKHmdA0JnwNFRvBCkv23vrhE
 kxxNjtaGwAORMR4ruRyFjJO/vMqlwNKy4wkv8faBdUOU5ijs8Nownq8KIptjeLnEC4In
 LIVg5FrRruunbsKRXY0/nQUto07aSLM6i2OGDQAt3FTcYV4js9m9kVX1GYLijThcoXaC
 fq3DmwEWfH1jYj31TsF4aCWNKnvSgKTrV2D8Qpd4R00vwi9Tq7PPFQQCIIarJPIbr+w4
 Dgaw==
X-Gm-Message-State: AOAM532tIftcPKyeDiom38SzqQT4EnZ5q7EBD8NWomJ5+KzKx5K9QpzH
 qhCoeJDF7vKapam5F2zK0GE73RHmKxtV
X-Google-Smtp-Source: ABdhPJwAA7/qi6bGmFDF6ghn4cxNNtvfeiI/Bx71D4jefC9+P79Vwc6+UC2XJmXdxS1pinufzNuW1KMAGW0e
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:f946:: with SMTP id
 i6mr24752203qvo.40.1615818993951; Mon, 15 Mar 2021 07:36:33 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:26 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-27-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 26/36] KVM: arm64: Reserve memory for host stage 2
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
