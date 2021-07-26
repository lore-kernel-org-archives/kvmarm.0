Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39152C432BE
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DCFA260F02
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DCFA260F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 911B34ACC9;
	Mon, 26 Jul 2021 05:29:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CzwybLUU82e7; Mon, 26 Jul 2021 05:29:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E8464A319;
	Mon, 26 Jul 2021 05:29:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EB25406E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dh8vW0u+yMW2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:47 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41F144B096
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:47 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 js9-20020a0562142aa9b0290310fecb5f78so7951020qvb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4KB8zz71n+ckn7q+A5npd/SGGm4PNZq4hk1c6+NwEJY=;
 b=kkbETL0dMsBo3aqN8t9V/kIx0Ztkf3eaIwZl0PzH5SGS9l2R07gZCo3SrYhlVi0Aq8
 DYE6R8DSj9iT04q9VHzh6K+4SpsFIWhZ21iXDGINKGvc1prCFhcttOusRwxU37nyzoBJ
 cGXebYm+WF+eQ3xmw+KAK1J3BjSZ3bPpSTpuIEjXY099wkk5S/7jGm6iLAJW4Ee1idbp
 5Skr4vyXufnVr58Rb40+iWEREgGtIjuPt7Gzvmz14VSeW3GBhdK8I9sPFbIysDe099cl
 VJTQxXrn2ZOjquQC+U5SzPZy1y6uov5YuZ6+JVs5ya29jcZkLE3TflfMn+pwghu4p+ZT
 uC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4KB8zz71n+ckn7q+A5npd/SGGm4PNZq4hk1c6+NwEJY=;
 b=i4RP5BFKDsjpDJrPkhXOnjR6FqA3c4w6xkA9kSeQ9qPk0z0bUl/MaoURGesTbX8Atk
 w1ugESrsrQhKu7sJm9IHecnaiNs3xWNj2o+vaNumCLn0Bj3ngthgeEkvavpvYavMxuTQ
 7bsBjtnrfOxsn91zbIuIWn8qLMHiy3p3g06gfgb/7MmlCWhXafQ6bg4fCBDCPaWQEZb4
 6/Nwl7lQpXZIlD+tZ8hQuTS1w8qSPCJQFkpoqkV9Z3mbrHSGUeDvWuD2OmzcK6igIj5d
 FaPGJ2MkAmjbp+ZFgvVqRklzjU3PSkePKu04ICDbDJtvGYjSl/sNHgYPDh7C+pe1/xoO
 NGvw==
X-Gm-Message-State: AOAM530nAhvkuk5Bv4TsbYRWjheG7cfJyn8iSdtbH1ZGyhOIiZoxi/Yo
 nBL2U7loTBrg6uQh2H3Zsr54kjheIlB+
X-Google-Smtp-Source: ABdhPJw4rV2DFKIOrC4bodeI8pRwP94WRLnn2cUKstVXAH0e5UMS4sxvzAPdNEu8x+a/0hc9RNwJfIDJlSr6
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a05:6214:2482:: with SMTP id
 gi2mr13928371qvb.51.1627291786850; Mon, 26 Jul 2021 02:29:46 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:29:05 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-17-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 16/16] KVM: arm64: Make __pkvm_create_mappings static
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
index 256cbe5c0dca..80303041f72f 100644
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
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
