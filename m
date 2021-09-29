Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1D1C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 821426137E
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 821426137E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E8AC4B0C5;
	Wed, 29 Sep 2021 03:12:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IlNbcYBXNzzN; Wed, 29 Sep 2021 03:12:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8D94B12C;
	Wed, 29 Sep 2021 03:12:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 697F2405EE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 00:29:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iA1tprzoC-F9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 00:29:51 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 621934048B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 00:29:51 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id pg10so250979pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 21:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=bA6NN/73uMxgRf2do26zZix4NIbIajvF9h0MlhypsP0=;
 b=D0DhDCankrqgNpGj/wZQ1bIG5lFpI686lVV9x5x7cV5N+TTyY6WG29/QP3px1+RW2E
 qkDXyIM7HJuu7S2dzfC6MbZIJyGpSQFXEArdEgLZLzeDhs9Fxl+nCbS+mIb+M1NN/nsX
 2IiV0ctP8MYuEYzwCB0TW+zCzwm3c2ngkt59k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=bA6NN/73uMxgRf2do26zZix4NIbIajvF9h0MlhypsP0=;
 b=dF15TTTMvUb/j9h3CLMsDf27fR+PeELk7O7rrzREVPGtukUdfEdYKByrGvX+L+4Yxf
 uZLvHL+saaokvXTIuQ95qQtkgg1Iaq8kpp6TYYuzHYa1kM17K3L1rSXgtGw+GkcUaVZl
 DR5rH4clVf5A5FIs7suHWTdJqOULeWJKNSsG0RLxDtCYeZvy8Sa6EDtPr1EAMJh4NRr/
 Co3oRux/nxJvQ1JzHHGYdZ4O1M/z0xOX3WLEfNODIWoO1yHy8wX3JxdAZV1gPZXkix60
 Vhpg10VnF+YiOzr8R4RHewuNP4FAeD+SQeGly7MR38YO8uet5PClH3P2qGRGFrv7Pecw
 vpcg==
X-Gm-Message-State: AOAM533yGy8Dt4/3OQHeIiM+pjKf5fm4B/NgPr+ba5b5M2/mwWL7MsQB
 Z7F69MOMU3JbUT7TmURUDI2kBg==
X-Google-Smtp-Source: ABdhPJxDITqPEpm4RXGmxbl4ubLf862UOuk9hpD6Czqg5k8tUb7xT3tmlnO8vUsHmwXIgQt1huUhKw==
X-Received: by 2002:a17:90a:f98f:: with SMTP id
 cq15mr4146513pjb.74.1632889790661; 
 Tue, 28 Sep 2021 21:29:50 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:f818:368:93ef:fa36])
 by smtp.gmail.com with UTF8SMTPSA id c206sm652324pfc.220.2021.09.28.21.29.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 28 Sep 2021 21:29:50 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v4 4/4] KVM: mmu: remove over-aggressive warnings
Date: Wed, 29 Sep 2021 13:29:08 +0900
Message-Id: <20210929042908.1313874-5-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929042908.1313874-1-stevensd@google.com>
References: <20210929042908.1313874-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 29 Sep 2021 03:12:40 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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
index 5a1adcc9cfbc..3b469df63bcf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -617,13 +617,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 
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
index 421146bd1360..c72ad995a359 100644
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
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
