Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A913BC433E6
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56FF464D73
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56FF464D73
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DDC74B61F;
	Wed, 10 Mar 2021 12:59:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ffoCL2AKlZ6q; Wed, 10 Mar 2021 12:59:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02F2D4B62B;
	Wed, 10 Mar 2021 12:59:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A104B3D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:59:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DC0zkuGUUuoY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:59:00 -0500 (EST)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25EC94B68D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:59 -0500 (EST)
Received: by mail-qt1-f202.google.com with SMTP id k4so13515029qtd.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=6iNTe0mF+hjFWLgudHI/zWSf2clb7t9N+GDYgm7EigU=;
 b=uaCdrsKfFSgEFJjwltC9RmF59Ae7yc016S997ZvqjUKBgk8suIeUI8tNo9lXnjVcFu
 2TLmSeOAjSDRESJ/NLQB7NEcltJ8lm7/1lgfPzBhrxE0X30r58dk52bDkKiWrJ0U/ly4
 RFLMCW7FhB3lzNXpvkxGbEEWw2VsVX/v89kRWom2NPXRitUUuaSEtxub5xzCfAQj/QEv
 ipn9/xy2+PZHU7mfi6Eelvf9mWH+vr113PBdfw6Sxgv9/ZaPo0n+ZxYF95KSUq8n96zJ
 1xkQHpOlRKYCDEukUW/4tZsL1k+hh9mrB1hZ/5M5eDoytop/zTSDu4VEhsAUZqUHU6W7
 SHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6iNTe0mF+hjFWLgudHI/zWSf2clb7t9N+GDYgm7EigU=;
 b=CD1MY1gbagD6Ma+eH5fRYbFoFAhYhgIohHQ0nEHwNKJrQobSx12hTVJIs0fL1Ga/dC
 vGIRqDwwpPkmmP+O3PoiFnY623/ztRaQYl+frVDv7uCqGfclUWII5s3UJZsNXvitBVMy
 a9FVFJyP9vRmXWP4tDUSa6wPLAj5PmIYxoebf9GLPIQNqOxYyyCYtpAN/f+gcQrMlLq7
 WaFiP01QJBFy4AGZz68r5A8hVuDQMhIJqUwKf73HScp6t0REWsHrCX/dRz1U7e8vQEhr
 G2ku5NFK8o6GqWFe260VACiObQsBprpTX3fVSm49F1AXg3U2qdXMUr+6gC65eNaSX/i6
 QQng==
X-Gm-Message-State: AOAM531+0gVewV9cIPt57b9GE7ZbnvyATrLYN4OqZOjaqxZGWTnERDmw
 tgfwKeiWtdzWQGFmDw36bl/pf1UrRArJ
X-Google-Smtp-Source: ABdhPJyDfHqUWFaXueHB0jBN/4Y6pf8dWGEZxgcpIy7CVo3fvkDLvVm5LW+MkE2AJvNQ0cA1KndyOwMjPQzd
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:f092:: with SMTP id
 g18mr4249565qvk.11.1615399138690; Wed, 10 Mar 2021 09:58:58 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:46 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-30-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 29/34] KVM: arm64: Refactor stage2_map_set_prot_attr()
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

In order to ease its re-use in other code paths, refactor
stage2_map_set_prot_attr() to not depend on a stage2_map_data struct.
No functional change intended.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index e4670b639726..c16e0306dd9a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -489,8 +489,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
-				    struct stage2_map_data *data)
+static int stage2_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
 	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
@@ -510,7 +509,8 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
-	data->attr = attr;
+	*ptep = attr;
+
 	return 0;
 }
 
@@ -728,7 +728,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
-	ret = stage2_map_set_prot_attr(prot, &map_data);
+	ret = stage2_set_prot_attr(prot, &map_data.attr);
 	if (ret)
 		return ret;
 
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
