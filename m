Return-Path: <SRS0=mXZs=LT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C44C2B9F4
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 10:11:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 12CAD61428
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 10:11:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12CAD61428
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20A304B10B;
	Fri, 25 Jun 2021 06:11:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id azDuPu773vyA; Fri, 25 Jun 2021 06:11:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EF434B1B3;
	Fri, 25 Jun 2021 06:11:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69CEA4B162
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 03:37:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8WWWqVAd0b9G for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jun 2021 03:37:51 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 369C64B14F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 03:37:51 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id k5so4990287pjj.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 00:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=16WTMv4TM6XRqCXu1WqfhwXLGUuF1I5eSAZgF8nuzNU=;
 b=j1IBKqLi1jF1pVyyqujoaaEyDD956vhQFsW4IqQOy9pFHxew6pDCRuHqUYQPzXhgIV
 rZzKBOewFTMPizmmlwFMEzkUu3wwxGe2e89oLtXslKb8oDVXALVjACeulmB5NJhacKR6
 l2tBxaC35ppPnNjz4UkRwFuKRG263fy/OfW/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=16WTMv4TM6XRqCXu1WqfhwXLGUuF1I5eSAZgF8nuzNU=;
 b=g2hz0G3QnP+f4ii4xWlEIwY3Y5j7Q4Tgr+oxDJo3M82ubeKy4O9k/qQWXFGQQ9DQhQ
 sJ4qxluWFU1uJ1y/RU8dOYppOtMYuovFqmg/QWfmGciQ48pF8qRA9Hmdp8iGZ7Dd3VKf
 w5XNPAcYMY49iLx81FeI31O5olLoCRREAmDVz+yM0XffakOkj+52DCBHNvqkdwVgQ1sh
 z8dz0Np/48+slYB0CR8/LMesc34CN7YXkUMehKmUdMRRGj4mHpguQNyAxt9PNquvUQTz
 Qs+FcevXKKnsU3t6Gb6zUOYcOibTtXuwTW+ZilnJX2lPTQ7g8kZJDd/vq169K5BgC7Mb
 LjnQ==
X-Gm-Message-State: AOAM5320snjTkDjwUZRczskCe2Zf5PMzCDevxdVZj58r0VBClc5qCsoE
 YGNJt8oJ3JEuH/piRI2BCbwUGQ==
X-Google-Smtp-Source: ABdhPJyNGzGIGPRke+4sy9vknoJlahbCbtDrQ1Pof1+x3qW6lrR+9qBg5laf4ZCLScq2FNWqiUDGlQ==
X-Received: by 2002:a17:90b:b18:: with SMTP id
 bf24mr9795691pjb.220.1624606670432; 
 Fri, 25 Jun 2021 00:37:50 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:1492:9d4f:19fa:df61])
 by smtp.gmail.com with UTF8SMTPSA id j10sm4395324pjb.36.2021.06.25.00.37.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 25 Jun 2021 00:37:50 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Nick Piggin <npiggin@gmail.com>
Subject: [PATCH v2 5/5] KVM: mmu: remove over-aggressive warnings
Date: Fri, 25 Jun 2021 16:36:16 +0900
Message-Id: <20210625073616.2184426-6-stevensd@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
In-Reply-To: <20210625073616.2184426-1-stevensd@google.com>
References: <20210625073616.2184426-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 25 Jun 2021 06:11:50 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, Zhi Wang <zhi.a.wang@intel.com>,
 intel-gfx@lists.freedesktop.org, kvm-ppc@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, intel-gvt-dev@lists.freedesktop.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 David Stevens <stevensd@chromium.org>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

From: David Stevens <stevensd@chromium.org>

Remove two warnings that require ref counts for pages to be non-zero, as
mapped pfns from follow_pfn may not have an initialized ref count.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c | 7 -------
 virt/kvm/kvm_main.c    | 2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dd5cb6e33591..0c47245594c6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -607,13 +607,6 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 
 	pfn = spte_to_pfn(old_spte);
 
-	/*
-	 * KVM does not hold the refcount of the page used by
-	 * kvm mmu, before reclaiming the page, we should
-	 * unmap it from mmu first.
-	 */
-	WARN_ON(!kvm_is_reserved_pfn(pfn) && !page_count(pfn_to_page(pfn)));
-
 	if (is_accessed_spte(old_spte))
 		kvm_set_pfn_accessed(pfn);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1de8702845ac..ce7126bab4b0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -168,7 +168,7 @@ bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
 	 * page_count() is zero to help detect bad usage of this helper.
 	 */
-	if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
+	if (!pfn_valid(pfn) || !page_count(pfn_to_page(pfn)))
 		return false;
 
 	return is_zone_device_page(pfn_to_page(pfn));
-- 
2.32.0.93.g670b81a890-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
