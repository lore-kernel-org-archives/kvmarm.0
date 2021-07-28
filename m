Return-Path: <SRS0=xfyP=MU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2C2C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 15:32:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D12860F9D
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 15:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4D12860F9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2A7F4AED4;
	Wed, 28 Jul 2021 11:32:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mZ2sHET4skwz; Wed, 28 Jul 2021 11:32:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A34B84B08B;
	Wed, 28 Jul 2021 11:32:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FFA249D50
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 11:32:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8CP1PoDY-xIF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jul 2021 11:32:43 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18FE840CC5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 11:32:43 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 r2-20020a05600c35c2b029023a3f081487so1068482wmq.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 08:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wsuCFl3zJw45VJsq2CCpitdGwDgZYGVgJGVdlnAA78Y=;
 b=H8AiMx+L6JXn5Q+T+lMqgWRxobIRqr1+MD1xsZdr4m6FSo/4YE+a379Kuo8gyFA44C
 VJH3lsBWEIBwuqw4RWtBjV/tN0ISN2k68TGgN8BSEKrL0hD+GIIpEmg7bAQ3PxjKkBUS
 lmm/xrYOZ1ljLtSJwWL/yt3uv5QLcvQPySXsZGT/ev7ua1Z27AkwLUbkQNm6RG4rnl5+
 TkDkcFzqPQz/VFhensW0nxv8xcGF5dBu/mwQdIA+v/wiqyydrUvaAxKqNGg0FX6QRFOZ
 FEghjQ51cpIQVaISj8htiqpUP7Fpkh/kpbqUVbJJgN+xGUBdgVaH7cUvOkKQoqG4Xps1
 +P5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wsuCFl3zJw45VJsq2CCpitdGwDgZYGVgJGVdlnAA78Y=;
 b=dRF+wQIz/hS5dnv9o0B+qxQlVW4uePKBuZZo0DCQ+q2h2sJ5pIayNimilyixrvEign
 tPPe0vjah2a8+lYQjFeC0R6UAUhgZJxzgPbNH89cM4iUiv5S68aA8zVeRydES/8wr5n8
 k4YW0FsXYhjB6NyrGb7MW2Wtrl9OQFIHwjd+XYetxK+1I9fbE3qtk5VIrBK3YiCyQXIO
 /Z6Yj14UPRi3pvAcitMBv9TnNyoRRAkIwRQ4iT81YlGyd/4a0W1X7V3qgtIV8lFwTJBA
 gCBO/di84x/UA5DwVzrrscDkLGacFCKMg7a0Z+Q5GA3EmSln2XNG3DfzljSB3HYpRHxH
 6l3w==
X-Gm-Message-State: AOAM530SVWPodJ04QyabtINCtxM9i37D9cETV3I7yxTPJZt+wHyGhgA+
 Nuh1oZAvf200XdMS2hjmab6brTeGRAXxiYbnjx/+V8opKH+sGK/sOJOceQpUBKK14LPcuHvkau/
 GHWshRprTBVrugqR+IpjqxGkxyLYP4RIt/vVlQF96BPItFokJ4LHShhwvTsdo8kYula1QQYXsMA
 M=
X-Google-Smtp-Source: ABdhPJxuEfipJsCbHRn1LIm1ICWET52ttWIgJnQxaUq0o234lBR+T/9ot6YarV6e8XqcOQE6CGdknEA+TvYf8A==
X-Received: from dbrazdil.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:7f9b])
 (user=dbrazdil job=sendgmr) by 2002:a7b:cb4d:: with SMTP id
 v13mr10176875wmj.68.1627486362229; Wed, 28 Jul 2021 08:32:42 -0700 (PDT)
Date: Wed, 28 Jul 2021 15:32:31 +0000
In-Reply-To: <20210728153232.1018911-1-dbrazdil@google.com>
Message-Id: <20210728153232.1018911-2-dbrazdil@google.com>
Mime-Version: 1.0
References: <20210728153232.1018911-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH 1/2] KVM: arm64: Fix off-by-one in range_is_memory
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

Hyp checks whether an address range only covers RAM by checking the
start/endpoints against a list of memblock_region structs. However,
the endpoint here is exclusive but internally is treated as inclusive.
Fix the off-by-one error that caused valid address ranges to be
rejected.

Cc: Quentin Perret <qperret@google.com>
Fixes: 90134ac9cabb6 ("KVM: arm64: Protect the .hyp sections from the host")
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d938ce95d3bd..a6ce991b1467 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -193,7 +193,7 @@ static bool range_is_memory(u64 start, u64 end)
 {
 	struct kvm_mem_range r1, r2;
 
-	if (!find_mem_range(start, &r1) || !find_mem_range(end, &r2))
+	if (!find_mem_range(start, &r1) || !find_mem_range(end - 1, &r2))
 		return false;
 	if (r1.start != r2.start)
 		return false;
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
