Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0813C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 545DB6135E
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 545DB6135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 082854B168;
	Tue, 19 Oct 2021 08:13:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mXGf9iAXujWU; Tue, 19 Oct 2021 08:13:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F35804B13A;
	Tue, 19 Oct 2021 08:13:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEEBB4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KfJQly7WIhag for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:14 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD0F14AC78
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:14 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 j12-20020adf910c000000b0015e4260febdso3089598wrj.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=TYk1LPnI99k/ggVKO8Mj9uEvzzDQ3GdDPOmXLwpCDNI=;
 b=O8yTSrO0Uca5wm5K4vU0ejt4H7paio27+Bqs4+KFIFEGBAiFkCCrrUrGNwkEt/Fefe
 28wzo1Ssyx+9lQZLUUAw2vVund8vhlY/9UwK8rovsHyNg4yw2Rn3gBGVepSL7Eq2w3yF
 hOEEM+UMiw4N/19fDLtDtMDjzcuOLCQZrQwnn8kjya9y0T0dnD7uEF3AAv8UWU/4yrKi
 S6OImPM+oD/vG3KMqhrA+Gyqt8kAYJpzoj+A1WyLb90HutKsJMU8ddw6cAouTDJTBNKC
 PQvZvate6zTr45VFMsJe5Czj+08pSBtCAh4K0m25lr/XPX0osBrElQ5U3Cd9eTV8m49b
 ZmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=TYk1LPnI99k/ggVKO8Mj9uEvzzDQ3GdDPOmXLwpCDNI=;
 b=V+CqQPzJySMfdj56CAnktcLHsDKl+BcjClXGHjDFRHixaRJ8KNUxGQ9B7l3BRdVosT
 VrrVePk1PbDGEzwxWZluDh60A+VPKnTjnJTIVdLkkqBwFKbUqpxhtWjNl0mqw+dsXy/N
 1Ityi4EvsprbiG30KtO6Z0l4uuJ8axiPsuTgvGC59bFdvFmEBfOBGDtzbpZSYqELUwC5
 PnSG0b1eaLCt8zVsQCrSNxNMFZ7YYF2B18wksrFC/+3XHsG8oq0xpWEtMa9fPmfnL3/H
 OaZQC/0mm4Bgfj1lCJLwG7k893+zJEDDpmrM19q59IowhUjv4mxxX0wHZkckjCcjuZjv
 bLig==
X-Gm-Message-State: AOAM532MXoXKWSScjDW0D7svtCcoGv0jqDjEs+Z1yK4DqQUN+uXQ+s8M
 Np/oPQqLf+1vT0BKuoukPJ8XPqbahALp
X-Google-Smtp-Source: ABdhPJzFSw1s7wfnFX8qmHfRSKmq59QIp1f27cUPH/WdPiT9CqXbF6yjtS78WRcCH6lpSA4IMEtzt5LuNzVT
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a1c:2b04:: with SMTP id
 r4mr5781071wmr.48.1634645593915; Tue, 19 Oct 2021 05:13:13 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:52 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-4-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 03/15] KVM: arm64: Refcount hyp stage-1 pgtable pages
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

To prepare the ground for allowing hyp stage-1 mappings to be removed at
run-time, update the KVM page-table code to maintain a correct refcount
using the ->{get,put}_page() function callbacks.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f8ceebe4982e..768a58835153 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -408,8 +408,10 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		return false;
 
 	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (hyp_pte_needs_update(old, new))
+	if (hyp_pte_needs_update(old, new)) {
 		smp_store_release(ptep, new);
+		data->mm_ops->get_page(ptep);
+	}
 
 	data->phys += granule;
 	return true;
@@ -433,6 +435,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return -ENOMEM;
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
+	mm_ops->get_page(ptep);
 	return 0;
 }
 
@@ -482,8 +485,16 @@ static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	kvm_pte_t pte = *ptep;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	mm_ops->put_page(ptep);
+
+	if (kvm_pte_table(pte, level))
+		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
 
-	mm_ops->put_page((void *)kvm_pte_follow(*ptep, mm_ops));
 	return 0;
 }
 
@@ -491,7 +502,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_free_walker,
-		.flags	= KVM_PGTABLE_WALK_TABLE_POST,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 		.arg	= pgt->mm_ops,
 	};
 
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
