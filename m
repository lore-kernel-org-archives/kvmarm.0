Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FECBC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E965260F23
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E965260F23
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DF4249D50;
	Thu, 29 Jul 2021 09:28:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U0uWUNZx0Mf2; Thu, 29 Jul 2021 09:28:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CB924B0DF;
	Thu, 29 Jul 2021 09:28:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFCB94B0E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XoMdgPio4Lsn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:44 -0400 (EDT)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA1454B0E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:44 -0400 (EDT)
Received: by mail-ed1-f73.google.com with SMTP id
 j22-20020a50ed160000b02903ab03a06e86so2931414eds.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3edu5r5MgiwqKIsFZqWR1OVvbwtz5pLkXdnxfKTgrkE=;
 b=kiFyFVttc3U28KQ3sfRTofJfHRrKRTa08Tr1wUv7AmJ7kmxQRQqWLqlx2vJLxnRtiB
 gRP5OSpTMXZ/ELbIz+ZiYYSRyHJQB4gpq308Q//Q+M8a+IkmJK4zXuePNe1iad8R6ja5
 eMzYY5Z+oyjxt+f/5LtLu0Hsc68dLxTSalqaiC6MOS51NM7Vok4vOIm5S9qUlX2pNnEf
 OeA6/wlF2Q8cQRv34+Q8Oe3lAuIlBdBzWJOPvwJcpQE1dOMoCrTw3OPaL+7abgre+E4P
 F0O7kH46klsMF5HsRReEdQc0jztwb9nOkD0bFWkPhtVneMWJ37S8n/CMDzd2iYeuib5c
 oFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3edu5r5MgiwqKIsFZqWR1OVvbwtz5pLkXdnxfKTgrkE=;
 b=T9QB/vKJP3YUR22XiRr4uBgEtKzhmjt3A/R1lzeZ6+J28R1O7K8irbRaUpF85dNxgD
 vCrqV2iWo7BWrcu009H+1KmZuDf8MQhCgNSQqofhBiEmeI7kwZMw4BlRI1vPomt4foNZ
 s5BuV8q2qGGER6QWwYtCrV5j2x0Th4gtgvFL/UgwteCXAsgSUFZCSzdF1Zk1Un+Hz10q
 dQaFTfaV/WNwFLq6UyJy9+YisuiRaPK16jx8hR5T2fNw8ylN9pn4w1qYp6fqFKXCbneg
 HT3h9CAO4HXpp/joDgg7bPZQydXg0qpKzYx3Jy3vim+uBtasdL3K9b0weXjgXer5fR4w
 oHSQ==
X-Gm-Message-State: AOAM532GRuMixDr9Bvz4Raq9+GIl++2v6Agch9IoW5ZHCCyrD4aTSTyL
 fCzlk5BDpXJV9FhO4INh3aifLRiiRoZN
X-Google-Smtp-Source: ABdhPJwP/AN3fa8sbZcgybFMXXlf8hjA0Q9gZJpOb0OUTytheQm4ssO6cEU1bGXuFiecy7eUiVkRiSSKUJ8i
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a17:906:2bc9:: with SMTP id
 n9mr4537344ejg.23.1627565323698; Thu, 29 Jul 2021 06:28:43 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:06 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-10-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 09/21] KVM: arm64: Tolerate re-creating hyp mappings to set
 software bits
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

The current hypervisor stage-1 mapping code doesn't allow changing an
existing valid mapping. Relax this condition by allowing changes that
only target software bits, as that will soon be needed to annotate shared
pages.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1ee1168ac32d..2689fcb7901d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -362,6 +362,21 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	return 0;
 }
 
+static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
+{
+	/*
+	 * Tolerate KVM recreating the exact same mapping, or changing software
+	 * bits if the existing mapping was valid.
+	 */
+	if (old == new)
+		return false;
+
+	if (!kvm_pte_valid(old))
+		return true;
+
+	return !WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW);
+}
+
 static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				    kvm_pte_t *ptep, struct hyp_map_data *data)
 {
@@ -371,9 +386,8 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
-	/* Tolerate KVM recreating the exact same mapping */
 	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (old != new && !WARN_ON(kvm_pte_valid(old)))
+	if (hyp_pte_needs_update(old, new))
 		smp_store_release(ptep, new);
 
 	data->phys += granule;
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
