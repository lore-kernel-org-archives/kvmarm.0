Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F16C432BE
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 10:20:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E014D61212
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 10:20:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E014D61212
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92C9F4B1E7;
	Wed, 25 Aug 2021 06:20:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0yP6GjdnyrxL; Wed, 25 Aug 2021 06:20:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7064F4B28C;
	Wed, 25 Aug 2021 06:20:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C3444B277
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 22:51:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i7dKKoSxn7pV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Aug 2021 22:51:04 -0400 (EDT)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 436E74B210
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 22:51:04 -0400 (EDT)
Received: by mail-pf1-f175.google.com with SMTP id y11so20044781pfl.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 19:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=rKfFXl/BbyfwmX4rHQZ3Hn9r2Vj8gM4pm+E9o5QNLKs=;
 b=oaGWPYaI37IRjoaH+TWQNDm536ZSBnteIXFbFsJIRWONl2RyxSjvpCkJJrafPE3qwl
 pl0f54VAY8Mz5RYN+8THqTSTxc21EI+8plqLain6+3Q9Gou8B6mXg0c3sjVuLkmW7d8T
 ZU62l23yObbhBMHnhzBMg2wEecMY0BP6dWXHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=rKfFXl/BbyfwmX4rHQZ3Hn9r2Vj8gM4pm+E9o5QNLKs=;
 b=QHH2eYyJ9imEM0sze8eV+RN0Nj3DOesLyiUEY9Bn8o136nJS26zs/85+ZPYzJA5xRc
 PrPVSL6wNSprWcNmpqNj+77UbyOxENfO3wJhZJUZMhGsiV6iztHjlXZBGF1NgIo4a35Q
 F2LEcAcq88v/nQDNw3DTbzZ4W6H5RXPeKSXgwMP2XFCB7Pjd4oma7b9aoTkz+eEcMW6p
 ZmxkoFEzkip7XNMzDd6fvgpDuaLRB4q3Il7mxwFgLY7XTL/vJWP9hXKY2vMRBcI91Yvf
 psqrNrqThPlhb2QC5KEGgp/y6O38/83kIh0/BVneQYfJYWio1/DaTTjnlJinRt8XxkKQ
 5wkQ==
X-Gm-Message-State: AOAM532YvpepuLeYYKifHm2h4QZ2OuvTnUZ+mFX+/ukLjC9NQb/8kbrA
 3JdeUUsI7bYKNtowKtwSciBing==
X-Google-Smtp-Source: ABdhPJwBwxXyy2P4z2kutpUEa/D8L7EFlg94RCzvp0UEeNsPtaucsoMQia1pwsRo6utZst0JN8IfvA==
X-Received: by 2002:a62:e914:0:b029:3dd:a1d0:be57 with SMTP id
 j20-20020a62e9140000b02903dda1d0be57mr42699866pfh.11.1629859863420; 
 Tue, 24 Aug 2021 19:51:03 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:d273:c78c:fce8:a0e2])
 by smtp.gmail.com with UTF8SMTPSA id nl9sm3856717pjb.33.2021.08.24.19.51.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 24 Aug 2021 19:51:03 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 4/4] KVM: mmu: remove over-aggressive warnings
Date: Wed, 25 Aug 2021 11:50:09 +0900
Message-Id: <20210825025009.2081060-5-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
In-Reply-To: <20210825025009.2081060-1-stevensd@google.com>
References: <20210825025009.2081060-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 25 Aug 2021 06:20:00 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 David Stevens <stevensd@chromium.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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
index d2b99c2f7dfa..88ceded7f022 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -623,13 +623,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 
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
index 5c47ea93df23..e5ddf238ec64 100644
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
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
