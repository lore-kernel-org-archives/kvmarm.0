Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C683DC4320E
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7778161052
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7778161052
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F25C40D0A;
	Thu, 29 Jul 2021 09:28:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U0ovw2+fScHu; Thu, 29 Jul 2021 09:28:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A7654B085;
	Thu, 29 Jul 2021 09:28:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C1C34B0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vt-GCzdRN7C9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:53 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 369B14B0DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:53 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 r14-20020a0c8d0e0000b02902e82df307f0so3933326qvb.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AlIcs6je/4eH5g1VpJMJ6MIaoeGclfxxvTq2IG6FTnE=;
 b=PojaLSp2J3h7SGHoj/wg3sKvQEJru11qmRDv6TPyUDNP0v2sIgCgjnQcQBfVvjJIBd
 yvSNbLe1o+nRvt4gE0x+yU5fyEqbr0b5rs+ag4a5W3POPPbpSKs5xgMCz0wnKXhZeNQJ
 Jz8fp9z+v6v263KlELujgmCZkDPY4LwdYCPTuK3m51ARcYRoysYF4I+3aFi/t2XpYMF3
 LZR4+yesCGdVYduYfwUa+43g/OSLzHdoLEJ6HOnuqE+eHQa2gYpDnE7HKgtttm2Q3g6D
 wMuKjYgK7mmdnQTrjI/+6Qfcz2yvwA+zA0dgaLkl/O6s+UYLBYYi6gfD4pqB6YDAw10Q
 LWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AlIcs6je/4eH5g1VpJMJ6MIaoeGclfxxvTq2IG6FTnE=;
 b=GSsEHFuLtMoJ2jmYFKyvAHZBcs9RIa6AY5P8CwrHIwyrLYVGMKMLmDh9Afy/CiHyQ2
 Hw1asmS7oEXF0oJjDXF/nMVBJa2441L/PYQW/CcnNvt3FX+lSsSJ6ZlBAdhAmqNegu/f
 wzYyLDxDRxJUlCAaj56lPCkvjyDLBNxVTXG5u0YKBt8i+Rm8zQSrS68J+jUzd0XOiPgZ
 g2g8eyWUaFWD8HtFniYokFLBzj7ULnljAwZNN4OVDia7KyFXiH/cJe4iIuAs+riUWeg3
 w1pYHbNyKt9LLQEU3FMn0PEiR8NDjE1po7b733TrVoZ432NCttPrUOlbqsUj+2rsjoTD
 ZKvQ==
X-Gm-Message-State: AOAM531QVX4DtqOCn0JfYrvkegjoUT4uhvqsh1k4k1MwRggJb5jrgcc8
 QWmrLqbmVgolbg+Hd6YxjntTeHGsHVSg
X-Google-Smtp-Source: ABdhPJwjclaLvF9NNfuY6mTQNdmoAJ3rTkidxuL1gXdxsvT/IfAhg+ijqY4w89EJuF24aa4xY4D+MGf/w1eo
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a05:6214:20c8:: with SMTP id
 8mr1933136qve.4.1627565332854; Thu, 29 Jul 2021 06:28:52 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:10 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-14-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 13/21] KVM: arm64: Expose host stage-2 manipulation helpers
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

We will need to manipulate the host stage-2 page-table from outside
mem_protect.c soon. Introduce two functions allowing this, and make
them usable to users of mem_protect.h.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ae355bfd8c01..47c2a0c51612 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -49,6 +49,8 @@ extern struct host_kvm host_kvm;
 int __pkvm_prot_finalize(void);
 int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
 
+int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot);
+int host_stage2_set_owner_locked(u64 start, u64 end, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 70c57d2c3024..a7f6134789e0 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -272,6 +272,21 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 	return 0;
 }
 
+int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot)
+{
+	hyp_assert_lock_held(&host_kvm.lock);
+
+	return host_stage2_try(__host_stage2_idmap, start, end, prot);
+}
+
+int host_stage2_set_owner_locked(u64 start, u64 end, u8 owner_id)
+{
+	hyp_assert_lock_held(&host_kvm.lock);
+
+	return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
+			       start, end - start, &host_s2_pool, owner_id);
+}
+
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
 {
 	/*
@@ -309,7 +324,7 @@ static int host_stage2_idmap(u64 addr)
 	if (ret)
 		goto unlock;
 
-	ret = host_stage2_try(__host_stage2_idmap, range.start, range.end, prot);
+	ret = host_stage2_idmap_locked(range.start, range.end, prot);
 unlock:
 	hyp_spin_unlock(&host_kvm.lock);
 
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
