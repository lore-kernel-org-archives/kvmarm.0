Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD9FC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:17:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D160764F67
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:17:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D160764F67
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D9E4B5FD;
	Wed, 17 Mar 2021 10:17:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0-OvGTsAo3h6; Wed, 17 Mar 2021 10:17:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23E9B4B664;
	Wed, 17 Mar 2021 10:17:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1940A4B5FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:17:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FLv+aPcXtKc1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 10:17:23 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F1494B652
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:17:23 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id c7so10778804wml.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 07:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Q4V+uOAPZg+8IRDU5mahURH8jFF9ksprgkE8pnV2+pI=;
 b=nOjGyLVk+LQQpkIGloNKaOBZGiHuZP3o8hZS0+/PkEKwar0iBam9A/S5fY3dDEp2tv
 9eaTVYSgiNCZd9vqBh9EaR6rr5ABZcqJhepuIaJP/qswFsC/PblA0Uj/H/9RTNGBhAwc
 nJsxrNTaJDJ2sleNFqxmCW2yVVO+d2Wjy6hZHm94blPNYxt/12pwGeKx0qud6E9mpXc1
 SkgMzZv/otO2vBE54oi6bzmLhcaJC4iVNMm+YLttfKkRvOxjqZWbpL8lX755fLMcGwww
 oOzTADmiTzBT7CrXki6+oREF4m72flOVuTEm78cImMKccnkACbjJhWURXjcoGTStJPPw
 +J2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Q4V+uOAPZg+8IRDU5mahURH8jFF9ksprgkE8pnV2+pI=;
 b=EQ7qVqH4VqcUunNIO+mAPscjMUixwWJKqInsK5w/0/HgInkwIVdrYdL066OQcFoVpN
 f4UAUIlArqSiut09NDMx/UmIvDi0PJd7Cnu4espNPSw0JVo/RL8iqT0bGHdKWvf/NESl
 2Ucx7VOQ69cefs/caoZNotFaAWGqp1fWsWFZvktqIKdscDXx8thufb85D4fEJEH1PIXj
 di2sryENttbPze/kfBL7e1/y0G8VeKryv41aoicKGrB2GXOhnBl6qBKPBq5n9owfpHgM
 sIZSiIwCpaHs8FR96UK0uekKYkGqoamlTzCjjP1a/ebhO3UtDQLViPBeMY8MHKHsDjfJ
 3jpg==
X-Gm-Message-State: AOAM531goBIYRjvvtRPWsdNT68xo/1gk/EO9WzEyWpJoDN59CXmgVBcV
 0NsiA8fTo4ownuB8IeOua76XKE/ztwkW
X-Google-Smtp-Source: ABdhPJzfbGHlOZ2mswIVtX/K86GO+y6S/0YGq3nxkyi0qI2XV2uCdtoLRdQPNroMNClPqw4jAdENknrb1l1c
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:e912:: with SMTP id
 q18mr3949743wmc.59.1615990642409; Wed, 17 Mar 2021 07:17:22 -0700 (PDT)
Date: Wed, 17 Mar 2021 14:17:14 +0000
In-Reply-To: <20210317141714.383046-1-qperret@google.com>
Message-Id: <20210317141714.383046-3-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-34-qperret@google.com>
 <20210317141714.383046-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 2/2] KVM: arm64: Disable FWB in host stage-2
From: Quentin Perret <qperret@google.com>
To: qperret@google.com
Cc: kernel-team@android.com, android-kvm@google.com, catalin.marinas@arm.com,
 mate.toth-pal@arm.com, seanjc@google.com, tabba@google.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

We need the host to be in control of cacheability of its own mappings,
so let's disable FWB altogether in its stage 2.

Signed-off-by: Quentin Perret <qperret@google.com>

---

Obviously this will have to be folded in the relevant patch for v6, but
I kept it separate for the sake of review.
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index dd03252b9574..c472c3becf40 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -94,8 +94,8 @@ int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool)
 	if (ret)
 		return ret;
 
-	ret = kvm_pgtable_stage2_init(&host_kvm.pgt, &host_kvm.arch,
-				      &host_kvm.mm_ops);
+	ret = kvm_pgtable_stage2_init_flags(&host_kvm.pgt, &host_kvm.arch,
+					    &host_kvm.mm_ops, KVM_PGTABLE_S2_NOFWB);
 	if (ret)
 		return ret;
 
@@ -116,8 +116,6 @@ int __pkvm_prot_finalize(void)
 	params->vttbr = kvm_get_vttbr(mmu);
 	params->vtcr = host_kvm.arch.vtcr;
 	params->hcr_el2 |= HCR_VM;
-	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		params->hcr_el2 |= HCR_FWB;
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
 
 	write_sysreg(params->hcr_el2, hcr_el2);
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
