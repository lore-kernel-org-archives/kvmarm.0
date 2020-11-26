Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5EBC64E7A
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3412C21D46
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="aDvl7dCl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3412C21D46
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3AC94C07D;
	Thu, 26 Nov 2020 10:54:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TFSuAaY2+Uw1; Thu, 26 Nov 2020 10:54:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC20B4C066;
	Thu, 26 Nov 2020 10:54:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04D814B9FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9kpp+Tha+eJ0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:44 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBF2F4C079
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:42 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id w24so2879356wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ZrCAS9ygWkC2ufXbj2Wobao4dQO/5x9OhapFi6lV40s=;
 b=aDvl7dClV2uddSkR11BaXY3pN+uz5HABtJLBS7EVNJEKoJNZV0iBk9o8D59nUGH/+a
 3B7FnrMyxDa9I5WhiMmMzlAgUJydOA7B1ixiCwBNjGHS2f23ntZe758HSRDydqFfNx0G
 AqoHtivWbZj+IUF4KFbqnve9WibgLTwyw/zq0e3ULZgspz4+L2SoR4O0BzQb0HfNfyP+
 VYu7VHGair8YbXPnsqfj10NbpQwbS+RfY/5HLENNvh3lTrEkIqim4RFcHVQKoZZ6IQRB
 oNuaz8WBT941Oa80szhb6hkSCeWKRh0zO+o7NbC2ztdnZAqmYks//F5Q/aWEttvKUeYa
 +CyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ZrCAS9ygWkC2ufXbj2Wobao4dQO/5x9OhapFi6lV40s=;
 b=cNOHueyrKzpGq7j8DW7IBtGxyAkYV4kmnetUx1QPz8GSejKZqHDQdFtB7+OzYeCmFg
 uTVLqmvde5IpcjkYBhU/+JUOqaziiG4zV6MwNDfnK/cYwztcRhDrnAdhvLpjjo3GE9xc
 IJSmIKRwHfbEQZ7k5FHnyMUcmKgQgyk3U91A59eVrdpSj81zXDE2EY6bR5LOafRFFR/p
 wdhamnYjcA2iWpenF2kyNKSHUzvfcm344XTDjMwIyZtCNym+DEddeGFKAEM1Rl+Zo6eR
 wxtAkgBhx/xRflDjAorj+9VzE1KpztRqrVFNzmfjz6FH5JVtvcaFGTtMFzguZ0vP3PGl
 J3dQ==
X-Gm-Message-State: AOAM533mqBKrstZGDkQUqmKQ5paDvrXmbLWbtxhW7rPxgt+DP3AMuUs6
 b4jbisO0KZ7ge+PWh4EFPUhOQZRPlRIEa37c
X-Google-Smtp-Source: ABdhPJzjuSUApvEOEPjZQvj0RwSRQkwjvpqFgqkQbvkP2wAo7cyRvkYNRsvgHC/RhJaCaStDd8X2AQ==
X-Received: by 2002:a05:600c:286:: with SMTP id
 6mr4043009wmk.125.1606406081513; 
 Thu, 26 Nov 2020 07:54:41 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id s2sm9141206wmh.37.2020.11.26.07.54.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:40 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 07/23] kvm: arm64: Initialize MAIR_EL2 using a constant
Date: Thu, 26 Nov 2020 15:54:05 +0000
Message-Id: <20201126155421.14901-8-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

MAIR_EL2 is currently initialized to the value of MAIR_EL1, which itself
is set to a constant MAIR_ELx_SET.

Initialize MAIR_EL2 to MAIR_ELx_SET directly in preparation for allowing
KVM to start CPU cores itself before ERETing to EL1. In that case,
MAIR_EL2 will be initialized before MAIR_EL1.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index b11a9d7db677..17b58dbc3a2f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -111,7 +111,7 @@ alternative_else_nop_endif
 
 	msr	tcr_el2, x0
 
-	mrs	x0, mair_el1
+	mov_q	x0, MAIR_ELx_SET
 	msr	mair_el2, x0
 	isb
 
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
