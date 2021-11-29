Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD479C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 08:41:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 798ED4B231;
	Mon, 29 Nov 2021 03:41:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NPimCZmhwh3s; Mon, 29 Nov 2021 03:41:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F81B4B252;
	Mon, 29 Nov 2021 03:41:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C64F44B208
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 22:43:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OOVg+aX53G3Y for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Nov 2021 22:43:58 -0500 (EST)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E3AC4B1FD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 22:43:58 -0500 (EST)
Received: by mail-pf1-f174.google.com with SMTP id i12so15396091pfd.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Nov 2021 19:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=9Hs2KkuD2RvJU1MuHxuaC5QQB7g97DRylbbix/DEyMM=;
 b=k6uPJkAreyLqR/oL85kAD76M20sYasXKj1QbtK3CkHo3sgCCQCC4FWtVOblMCLxb/z
 bPi22S2w7YghmBm3Kka1/UIGGiA8AiUT2+RMrGmqVQlt4EUYiTQn1smbFmUJatk/XJub
 u6epHvK0KKlesLZEIUpl4jFhfksZXtlcfSic4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=9Hs2KkuD2RvJU1MuHxuaC5QQB7g97DRylbbix/DEyMM=;
 b=ixCc30OclMft1lkgGvcknCJqt3WCDLo4gkNOWN6tTRxuNE+8z2oNHCuYkLQ0rk2ZKe
 45s88sIVAuJP7O0Gmr+4I3D7DHjk1L8qqBrJGI/EAH340jbRpIk52BBrGPJ/qP9G7FNt
 VNSw3yjnSHLBtIgkFOqqKKmAZA0nRXC1FEyzbF6GTmJDD1ZGXO2QCon4obPhd4+91nPa
 1ciC1Qnhm7kkRKZeXRt7Hokpi/t+odYuwb9k2/X72KPlvLqpiN0vqcKsLLDnGOjuhkSr
 uZZhcVDZsBD/b4WQtRFWmdiiMoyuuO7IwsL1w4Ardi+h4nZZQH4bmcRajUQuRrsdBaeE
 oOYw==
X-Gm-Message-State: AOAM533j4zkRH4AU6JqVQQj9w5R2PS8IoN2CS3W6r3CRWHlNpdzlA/Io
 lnCIByjPTrsZdBUbMnTpy6zWliJpWmZ62Q==
X-Google-Smtp-Source: ABdhPJwtRlhKS2AxEOFgBKvN/CyDcHjbqYa75A4CX+1o9/zI6sOg74qnXMkTRUr57A+X+/j0+SotFg==
X-Received: by 2002:a63:c044:: with SMTP id z4mr33793003pgi.335.1638157437859; 
 Sun, 28 Nov 2021 19:43:57 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:72d1:80f6:e1c9:ed0a])
 by smtp.gmail.com with UTF8SMTPSA id y8sm15439643pfi.56.2021.11.28.19.43.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 28 Nov 2021 19:43:57 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
Date: Mon, 29 Nov 2021 12:43:17 +0900
Message-Id: <20211129034317.2964790-5-stevensd@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129034317.2964790-1-stevensd@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Mon, 29 Nov 2021 03:41:49 -0500
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
index 0626395ff1d9..7c4c7fededf0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -621,13 +621,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 
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
index 16a8a71f20bf..d81edcb3e107 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -170,7 +170,7 @@ bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
 	 * page_count() is zero to help detect bad usage of this helper.
 	 */
-	if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
+	if (!pfn_valid(pfn) || !page_count(pfn_to_page(pfn)))
 		return false;
 
 	return is_zone_device_page(pfn_to_page(pfn));
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
