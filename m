Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA65CC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:29:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8BE2660F42
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:29:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8BE2660F42
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40DAC4B142;
	Thu, 29 Jul 2021 09:29:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t5vDJk3t+tAx; Thu, 29 Jul 2021 09:29:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 345F24B13A;
	Thu, 29 Jul 2021 09:29:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC5504B126
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:29:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eAEp-HIu-m1t for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:29:12 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 022554B11B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:29:11 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 g10-20020ac8768a0000b029023c90fba3dcso2745649qtr.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vQtosGJFAOrUOiBl4clG9WDMUZRQZWton/qwil1k0+Q=;
 b=dXygFS4MzHesaeMqbwJ0+cZ0afNQ4/u5vTF/RgsqUpPCSvO1FUb9yuOtobHsreJWqr
 dUqlIAu7Fvz+I43aDHKZyp8VKGAJcvdmKnnkeHIjZqt8EhOzaHANhcXh8RtV0Ilxlnt9
 4Pl/Gc+kDSrSP77EuPnHl91zLmkSkct+Gl67dPohs9YPPdMJ8ph+HGp8BjrsrKxaXVEy
 OoSuN3lBXk7s1yZPSllQnVPCpAnlYGI91eJ1m/mdcSbcCE+Z2qNsccfX2HfuY/+rJJcM
 noOMmdViiMNvT23lNHKkf8AZYFmTtkC55+7rWH4afynTCCzcjLC8ILshwjJH8cojfSWr
 oXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vQtosGJFAOrUOiBl4clG9WDMUZRQZWton/qwil1k0+Q=;
 b=SKeQO1//fkzInbD398ZTAqlb8qasiMf0fiuhKeY9ZsUQsL8wKS2e6gL6ACYBPo2RTM
 i6llvz8yEUVxrhzsWUIzsECDH8/q7EOerYImPJ6yiWwupCZcOLyr0JVH49x5DRB4K+CL
 rmyWPEgYmzOs4iGErYMMdl1B8iz7kIgm5IzWVv229gYcv3hXQ9nuBumkkqxSl7YoWuoV
 GROPp633jYNTg0O8nrjn4Ec9WeIQ2FCKJKqbhnBy+u2fBx0Vui8li/xQKnqasaTFOYPq
 +u09v5AUUDCxWhvMa7ME/3XE4s/L+kRJBy9EHEm2P7BbJrOHkGHCecbLls+cChodoWDo
 J2pA==
X-Gm-Message-State: AOAM532t+LaSs4wi/uJ6eLK6APipCv3Zjmar750NOK9iG/f9vQkCKweU
 nhXqjBVRiwRnJGmI2PhrWX8SfdXmlEB5
X-Google-Smtp-Source: ABdhPJzMM++UNzruvJmyLbB/7mURxGlTSkGbvn6rPkDW6SXHchtq4/8ma0IIMxLOdpKM8oJyuuW51EsCRzfk
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a05:6214:104b:: with SMTP id
 l11mr5321061qvr.40.1627565350559; Thu, 29 Jul 2021 06:29:10 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:18 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-22-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 21/21] KVM: arm64: Make __pkvm_create_mappings static
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
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
