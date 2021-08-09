Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB74C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC39961019
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC39961019
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CF604B11E;
	Mon,  9 Aug 2021 11:25:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G1mCL4f5g+2k; Mon,  9 Aug 2021 11:25:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 661414B0FA;
	Mon,  9 Aug 2021 11:25:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEE5B4B104
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DnbNUfVuk2el for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:38 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 079B44B12C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:38 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 v19-20020ad455530000b029032620cab853so12596249qvy.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=sdImyBobVK9C7JHfpgjE6AhabFh6YsuoqYzTsW8O26w=;
 b=kqZ+48HlyWqF47Nk0k2ceqQM9Fre+x1T8hoYnPiuq5PTJ4KtKnXsvPfN8z0efxyo2K
 1Cv/Y6nA1ri8uEP9fKKSe8ggvj8zxMwVMtyqCvsN0tbgapBu1uX/FRexEORPLaD7xkmC
 +iI0zK4K0HntIu3IDkwo8zkeuMEYV0LRMLftETQ0wMYxrrYH6anUuwIVrnBfhc6O89s9
 xaIOQKixOTX5PUFhjVwPfO+yshqSpKx+8GMXNTlSVVnsyFkqHsNp1k7CmVAv6G0yrlA6
 56I8EZTN3dqzfYafoy6B+aA2TdNoUdpIuu9GGm/oIh8KBQuT/PdupYj05j1672MfhIaQ
 EJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=sdImyBobVK9C7JHfpgjE6AhabFh6YsuoqYzTsW8O26w=;
 b=BaHkFboz7CC4WNb4jhaCnHeLv/haSCPX2b/oYLh/LWBsjC4y8oTi7wr9H4LqTv0phq
 Md5ZWg+V+F4GjLLHq2nrc1gtW2rtCBdmJl1Bd6Jzb8nNr8zENO5/s9ZuZU0lPJ3UaCJo
 2PmxYI+ZZ4luRoHdkAoCgxHM5Awhv0Twg/lvcj/umMoUTSZNt6YOMihIJhMt4IwmNaon
 Zt6mQ/5ppjIoXiSuaHd3KTZeZwuViewNfyhSrzK3DRnthvab/ft8IOR/0QXDc3/RV4j8
 hiI6pSeT41Xeq8v5+drzaYgXav+YzNrXiENucb3rjp0RWjz2Dn8a1c7D8T2gIRh6JtKh
 n29w==
X-Gm-Message-State: AOAM530sf3bSyMtoLguqnn/rMmXzXZ5ILPqF2HDBwrjYtKaDhj8sEUUL
 WlA4pwToen+46zG/cNRn0y2VKcKf3CYD
X-Google-Smtp-Source: ABdhPJzOPEvCyZwawEXBs8XVbjr2ljQD5haVjnGzWMLXjl905o6lFfqoGXZgRYKpOaaVjXYS/gQ/pMM6dBBo
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:6214:6af:: with SMTP id
 s15mr6751903qvz.52.1628522737726; Mon, 09 Aug 2021 08:25:37 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:48 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-22-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 21/21] KVM: arm64: Make __pkvm_create_mappings static
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

The __pkvm_create_mappings() function is no longer used outside of
nvhe/mm.c, make it static.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h | 2 --
 arch/arm64/kvm/hyp/nvhe/mm.c         | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index c76d7136ed9b..c9a8f535212e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -24,8 +24,6 @@ int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
-int __pkvm_create_mappings(unsigned long start, unsigned long size,
-			   unsigned long phys, enum kvm_pgtable_prot prot);
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 					    enum kvm_pgtable_prot prot);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 6fbe8e8030f6..2fabeceb889a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -23,8 +23,8 @@ u64 __io_map_base;
 struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
 unsigned int hyp_memblock_nr;
 
-int __pkvm_create_mappings(unsigned long start, unsigned long size,
-			  unsigned long phys, enum kvm_pgtable_prot prot)
+static int __pkvm_create_mappings(unsigned long start, unsigned long size,
+				  unsigned long phys, enum kvm_pgtable_prot prot)
 {
 	int err;
 
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
