Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A2EC38A2D
	for <kvmarm@archiver.kernel.org>; Tue, 25 Oct 2022 14:52:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B85049EFA;
	Tue, 25 Oct 2022 10:52:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lXuAicMPJgJK; Tue, 25 Oct 2022 10:52:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E457E49F37;
	Tue, 25 Oct 2022 10:52:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C174249EC2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 10:52:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CNm71qhz2EH4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Oct 2022 10:52:06 -0400 (EDT)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C51643C96
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 10:52:06 -0400 (EDT)
Received: by mail-ed1-f73.google.com with SMTP id
 t4-20020a056402524400b004620845ba7bso1941657edd.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Oct 2022 07:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=iW7y1fLgpkJui3hvQxzLoNSX4KE+fgXa0IU1VCGorq8=;
 b=qJakZ6WY7j9J9m8Y0t0mKscdKtWoQFQZx/SlIwtmdVidxM8A5xf050QT9Ki74jQrL1
 I1jtlS5bPffVifc9+0ncXh2wwwFOzVaq6063eYqf/v/Pl2+CjzJRqU13Oz7kC4XO9shq
 rk7e1jP74dU+C6IgUOoa4PVz3g4RhXXyTqm6wsiEhNC7ZVMmHNQhgmULb6ksYf93T5Pq
 Hz1ccacdzLT7No3GpTOIBgRj9eUiZYuKalDOV91XpIhsNHChn2V7IF28NwUwvxVpR7ps
 7iqals/Wlf90wOzqbZc+9XGB9AKrzHp5iU5dKE+mCdqT+LlsVAHopgFQJUCQmhrKOdkS
 ENcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=iW7y1fLgpkJui3hvQxzLoNSX4KE+fgXa0IU1VCGorq8=;
 b=rTrHmT2IaLKpo4CqivC1CRSW68eM9soUOAEQ5AcXFcvKgp1L1fEL/K31VSZNIt0ZUL
 HnykMMitrV71khGThyF6pnOv5DxreAkqRIFXvcoRnrrDiaHYDBi3/xJVGj8VKBIgEKOE
 UwhtFMaLmElKwiNcUTuiho+tXrHHpvFVtAbcwq4E1xpAgE1RDdtIFiUf/sLDVi4BZv4k
 lEE7a/TZ1nQ7IAi2fpProia4QviDJFLVyuqv+xR0d/JoV3tge9PR3yRsdrRNGkZ53jgH
 fjXOs1rK7mi7X9RWceTvC/Ygm1bNxIbcnCcA9MVDj2wmzJXw0Bbkpi0HTua7H1BIh4sj
 o8wg==
X-Gm-Message-State: ACrzQf2wqBkyWsKij795ZlIaqBgcicy6w2mpYtRWnV0xaF6thoESHw0n
 2Z9OS7yl1mskwZouGw7pRVN5QARitsBI
X-Google-Smtp-Source: AMsMyM4BGDxK+RsryB8gWtAc8z+lfBDtIE7P/25DUQWrqxjJtocSP2UPxVASx3qt+ngO9qDF5OIYpYiVN++A
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a05:6402:d06:b0:45a:3ac6:ad26 with SMTP id
 eb6-20020a0564020d0600b0045a3ac6ad26mr36497510edb.195.1666709525134; Tue, 25
 Oct 2022 07:52:05 -0700 (PDT)
Date: Tue, 25 Oct 2022 14:51:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221025145156.855308-1-qperret@google.com>
Subject: [PATCH] KVM: arm64: Use correct accessor to parse stage-1 PTEs
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

hyp_get_page_state() is used with pKVM to retrieve metadata about a page
by parsing a hypervisor stage-1 PTE. However, it incorrectly uses a
helper which parses *stage-2* mappings. Ouch.

Luckily, pkvm_getstate() only looks at the software bits, which happen
to be in the same place for stage-1 and stage-2 PTEs, and this all ends
up working correctly by accident. But clearly, we should do better.

Fix hyp_get_page_state() to use the correct helper.

Fixes: e82edcc75c4e ("KVM: arm64: Implement do_share() helper for sharing memory")
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1e78acf9662e..07f9dc9848ef 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -516,7 +516,7 @@ static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
 	if (!kvm_pte_valid(pte))
 		return PKVM_NOPAGE;
 
-	return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
+	return pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
 }
 
 static int __hyp_check_page_state_range(u64 addr, u64 size,
-- 
2.38.0.135.g90850a2211-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
