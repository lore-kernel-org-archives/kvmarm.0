Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89012C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DEB86135E
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2DEB86135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3CB54B126;
	Tue, 19 Oct 2021 08:13:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aOqtXiuh-rRk; Tue, 19 Oct 2021 08:13:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1AF4B0D6;
	Tue, 19 Oct 2021 08:13:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34E604B0D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pCSnMThrYzcf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:12 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71D4B4B0CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:12 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 n9-20020a1c7209000000b0030da7d466b8so1072553wmc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9qioxcWNTdM29KTskJovFvpNouj7jwaQhn/w48JNYr0=;
 b=RCVF+kFj8+Q1ZIvAw2o1YEfdbyV/QvERANN2zOL3vp6KFp4sOKvq50TuiuJVXjk8CI
 sJ8+ANxFKAZIB5XW2WXqgfxqioUa8/FqpJDAAlHYk4VwJzPsMiTKfyXjGsWp6nYM2egs
 6ve8/RASgPFUMVKruWnMc+7Dq7xO467GfVDxse/ta3etQdRPTINc1Tn1t35gFQUffSa4
 I17Na6p96zob6zezj90RVS7pxK8HHoy186iRxq1vgOzGonEHYihEMN8mRi5acuaAqYmN
 0uVSCaCv9OaDCrMFHRsAD+gEn2IzZEReHw70B6v4JZTVux2bKXVrx5uW9Gfu3BqI6frT
 y8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9qioxcWNTdM29KTskJovFvpNouj7jwaQhn/w48JNYr0=;
 b=jA7YdBqseiv6y4W97hjOnMOf/dDmCnPjeEXHQXq+jMlu1qtXVNm7s8rcEVSl/RzN++
 6lPtvkrr+BP7oA5Vb2pzlSYUxWyp+hO5qQvymTV7zuuuLRVIEiTKPu5f9gjBxliwgmk/
 dvXvoL6X/FEB0thD9w+g5cMADZQH3LjxODRS8WMXCaJ1RSN7xtYLXKtkf8f9OhT66eQJ
 ng3BYkt6ytLRrCXT2VPM8gw3+vbwWgN8pyLekyMox/9RCmcAnlNDCBeepGDEoas22aVo
 uTGIuh7ndguEQHRQLC8RqGmAWlt1bQoqhjlEy4Z4umt87UQVyLJelMFfLSs3KpAi0+OR
 f7Pg==
X-Gm-Message-State: AOAM533ggnsfYjD7LJlYoxV3v7vfnfUpRrXDVK8zRHdE4sK0nIxFzFmw
 1gyBqx9z3jVxyVE7XtkK212n+ImLNSBe
X-Google-Smtp-Source: ABdhPJwlXJ0DM6qyO/wxtqG0399vc1RBGDWqJP0qqKuvfhECekIT7zJoTt4K3Fn+DO1gRLB/9VBwvtDmOWwC
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a05:6000:50:: with SMTP id
 k16mr42638419wrx.32.1634645591442; Tue, 19 Oct 2021 05:13:11 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:51 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-3-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 02/15] KVM: arm64: Provide {get, put}_page() stubs for early
 hyp allocator
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

In nVHE protected mode, the EL2 code uses a temporary allocator during
boot while re-creating its stage-1 page-table. Unfortunately, the
hyp_vmmemap is not ready to use at this stage, so refcounting pages
is not possible. That is not currently a problem because hyp stage-1
mappings are never removed, which implies refcounting of page-table
pages is unnecessary.

In preparation for allowing hypervisor stage-1 mappings to be removed,
provide stub implementations for {get,put}_page() in the early allocator.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/early_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
index 1306c430ab87..00de04153cc6 100644
--- a/arch/arm64/kvm/hyp/nvhe/early_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
@@ -43,6 +43,9 @@ void *hyp_early_alloc_page(void *arg)
 	return hyp_early_alloc_contig(1);
 }
 
+static void hyp_early_alloc_get_page(void *addr) { }
+static void hyp_early_alloc_put_page(void *addr) { }
+
 void hyp_early_alloc_init(void *virt, unsigned long size)
 {
 	base = cur = (unsigned long)virt;
@@ -51,4 +54,6 @@ void hyp_early_alloc_init(void *virt, unsigned long size)
 	hyp_early_alloc_mm_ops.zalloc_page = hyp_early_alloc_page;
 	hyp_early_alloc_mm_ops.phys_to_virt = hyp_phys_to_virt;
 	hyp_early_alloc_mm_ops.virt_to_phys = hyp_virt_to_phys;
+	hyp_early_alloc_mm_ops.get_page = hyp_early_alloc_get_page;
+	hyp_early_alloc_mm_ops.put_page = hyp_early_alloc_put_page;
 }
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
