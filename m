Return-Path: <SRS0=xfyP=MU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F9DC43214
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 15:32:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C72460FED
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 15:32:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3C72460FED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D54CB4B09A;
	Wed, 28 Jul 2021 11:32:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ff9FveqEdiTQ; Wed, 28 Jul 2021 11:32:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C36BA49FE6;
	Wed, 28 Jul 2021 11:32:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19DA840CC5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 11:32:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OzRQ9myhq-af for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jul 2021 11:32:45 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D2F14B082
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 11:32:45 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 c5-20020a5d52850000b0290126f2836a61so1081683wrv.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 08:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qzw4XcX4w+ny84Qln9d15Ry0/+5tfssrXUUN0rRDVVc=;
 b=G3I/3fhsNE6Og2SNbp7xijYfhxbbi8EEXzZO7tjVLLwHEwaGAf2WH4WDSAI9RuBK2v
 y7MINQTjeOU9oU90HjjguDGAwa4tof8t/8vq/m2JE5pv2a/YNi09Y4IPEqg/Mq+fBEPD
 Z0d/8fw19uWXRPZVYkNEbf40fgTfDWXSKtSXKuEpcdnImMph1V/8lTDcxryYsvCOGEJx
 bdhwsqESBm+n86hEdsfP11ImWIAtFpMKBxxxA86Z4l4ZbGbeKxemOU97Z+VC4VrnXV3V
 xL3tHvSnAfmB7Ax5kGhpV8zZqSzrsqsT6CwvAXBclwHpCvv307H5rs9J7qPyzU9u9jLx
 Izwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qzw4XcX4w+ny84Qln9d15Ry0/+5tfssrXUUN0rRDVVc=;
 b=VTpJdRp0q7h1ssJBEb5YCnUpXphVXN6dZQU3s6KeGPl8ohSQmIlOHibuQM+eV3ElOq
 WPjGDe9+bxVZfvAZcLMCzd00dCk0BF5mmNywrLBb8AGNvDbqbRDa7rTfG8q2aXOQwD9s
 vpxFqaB6IQR/HLiSp6Y9Am61otlZlVt48CVIB3qTJBdQk1OueKcqVoIK2WAcU+aaaC3z
 5uRG8m3jwRSLFD8+ryuSrIZW2ipMHFMmRfrwxNYB3HnwDKQ23vLdwIFUgmKD2LsKZr1c
 f5CZjs6oaHEvT+9LJpXpqihGzdeA1YCxgGOB9a84Jg0m6bQ6pAlgRwsf2Wh16zLG0wAN
 LpSQ==
X-Gm-Message-State: AOAM532i5QuZCSC4umpdj7AbTNV7c0faOO0oaqrcfTHpIXEMEpX9g5TD
 XMi8QcCX9bZM64Q+J6DSfUr6HAoVrQ39niKyUeMGVzdMEH7pcc4fkfQfyL7PgkgbYJ8ecl5INav
 7U7Gg7NIL6G5RP7JwVlfMtSxiFEgN4w2/QAhJTTGzRf+fLHYD9CyMssSe6cudVXVj4r6tjHqQ0s
 A=
X-Google-Smtp-Source: ABdhPJx3RYSTCqCub5lOGXrHgg5jPvAqfn3GPah0zCRIxkTx6aci9KeM6XDoX5DGxOYQRxwXx1QUpmsxtpyJMg==
X-Received: from dbrazdil.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:7f9b])
 (user=dbrazdil job=sendgmr) by 2002:a05:600c:4101:: with SMTP id
 j1mr308618wmi.110.1627486363975; Wed, 28 Jul 2021 08:32:43 -0700 (PDT)
Date: Wed, 28 Jul 2021 15:32:32 +0000
In-Reply-To: <20210728153232.1018911-1-dbrazdil@google.com>
Message-Id: <20210728153232.1018911-3-dbrazdil@google.com>
Mime-Version: 1.0
References: <20210728153232.1018911-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH 2/2] KVM: arm64: Minor optimization of range_is_memory
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

Currently range_is_memory finds the corresponding struct memblock_region
for both the lower and upper bounds of the given address range with two
rounds of binary search, and then checks that the two memblocks are the
same. Simplify this by only doing binary search on the lower bound and
then checking that the upper bound is in the same memblock.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a6ce991b1467..37d73af69634 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -189,13 +189,18 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 	return false;
 }
 
+static bool is_in_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
+{
+	return range->start <= addr && addr < range->end;
+}
+
 static bool range_is_memory(u64 start, u64 end)
 {
-	struct kvm_mem_range r1, r2;
+	struct kvm_mem_range r;
 
-	if (!find_mem_range(start, &r1) || !find_mem_range(end - 1, &r2))
+	if (!find_mem_range(start, &r))
 		return false;
-	if (r1.start != r2.start)
+	if (!is_in_mem_range(end - 1, &r))
 		return false;
 
 	return true;
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
