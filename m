Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5110BC4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:29:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0459160C41
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:29:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0459160C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AED2F4B12E;
	Thu, 29 Jul 2021 09:29:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f5Cm7BWGZCAB; Thu, 29 Jul 2021 09:29:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF884B12A;
	Thu, 29 Jul 2021 09:29:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79AC14B114
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:29:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 07ddtGkJ0mgZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:29:06 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 834C54B0D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:29:06 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 b8-20020a0562141148b02902f1474ce8b7so3895044qvt.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PD2lJrK2uUAJidILwsX5pR8ZyvNUyZDv1OnaXJdJLhM=;
 b=mUuZZtK9nPtQzaSeRR1efvqBrUoJ0pqBZlk3FM19wBDIbLOvb8fBAK1zLHnHmRvgG4
 9+m8SNZemfJ5wjNL0ad4SiPyjYjEBlLoS8Tyn4uwj2sswKXw+5b34Cpk+2cNl0zxU9i2
 hb1UtR4PqkuvDCfrkQgC0MmfZumGrmMdvx63kJ33dQX7N17wUy5Vt6SMNZbQpHP5yLox
 bd8gesl5DHYmN7n9sV5lvWk1BJ0SWoWsa969E0R98/3453gA3Yw8Lno5XA7wFKvbI4kS
 Ku3g9VDc96QVgpM4vZGdkPZ0QH5KCfDWuAHB2CAaVZfb6Aalj1LyRfmpbi6Z8uylubmZ
 KXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PD2lJrK2uUAJidILwsX5pR8ZyvNUyZDv1OnaXJdJLhM=;
 b=a8+CcWXY2sHBsjCspZ0CsLZbdgvmwfnCz9OWC8dAH1osDeIDpNP6rxJ3dGdB++FHC3
 u6zBeJSZDkk5ZmG+yGDtD4PIDzmgM+2GL6L3OX3JzP1Bc9xqubcIJ4H7LKylJomut/52
 Re/f/pGqayVWqXo85UMthZY/V5ighqSIJkGi3NjVejsncrToJCd0AGey6vVLskLTI0pz
 wjerV5USBQBX261H8UiqgLxyl/U9YrCqKTSirgxr7NM59+IVyStBPSecolwmzQ+DTDT9
 dlNsAFONv3+JGP0hHOgQC9o+P3ldTF3zdYB1My5CS7GtLdeMNGfIqhBLCqhlG6By+B5s
 62Dg==
X-Gm-Message-State: AOAM5301e01GX8ChipQAF7kdRFRNYNN+MpynuwpbsHok51RtksirmPJN
 2x5JlNc2JxH3pLK5lC9FsyKxgdhQMhc1
X-Google-Smtp-Source: ABdhPJz10hpfq0SGJNMP70xRlPb0dobUvsFM7yqmK2aN+qLJctMkUjDYhRjEE2aZ3LvI5a9WzZnTi+0sHxt+
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a05:6214:10e6:: with SMTP id
 q6mr4966976qvt.11.1627565346131; Thu, 29 Jul 2021 06:29:06 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:16 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-20-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 19/21] KVM: arm64: Refactor protected nVHE stage-1 locking
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

Refactor the hypervisor stage-1 locking in nVHE protected mode to expose
a new pkvm_create_mappings_locked() function. This will be used in later
patches to allow walking and changing the hypervisor stage-1 without
releasing the lock.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mm.c         | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 8ec3a5a7744b..c76d7136ed9b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -23,6 +23,7 @@ int hyp_map_vectors(void);
 int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
+int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
 int __pkvm_create_mappings(unsigned long start, unsigned long size,
 			   unsigned long phys, enum kvm_pgtable_prot prot);
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index a8efdf0f9003..6fbe8e8030f6 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -67,13 +67,15 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 	return addr;
 }
 
-int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
+int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot)
 {
 	unsigned long start = (unsigned long)from;
 	unsigned long end = (unsigned long)to;
 	unsigned long virt_addr;
 	phys_addr_t phys;
 
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+
 	start = start & PAGE_MASK;
 	end = PAGE_ALIGN(end);
 
@@ -81,7 +83,8 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 		int err;
 
 		phys = hyp_virt_to_phys((void *)virt_addr);
-		err = __pkvm_create_mappings(virt_addr, PAGE_SIZE, phys, prot);
+		err = kvm_pgtable_hyp_map(&pkvm_pgtable, virt_addr, PAGE_SIZE,
+					  phys, prot);
 		if (err)
 			return err;
 	}
@@ -89,6 +92,17 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return 0;
 }
 
+int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
+{
+	int ret;
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+	ret = pkvm_create_mappings_locked(from, to, prot);
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	return ret;
+}
+
 int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back)
 {
 	unsigned long start, end;
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
