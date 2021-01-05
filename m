Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA52C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B10E222D50
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B10E222D50
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DAD54B361;
	Tue,  5 Jan 2021 13:06:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0QN-8qYp5v4A; Tue,  5 Jan 2021 13:06:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AD954B363;
	Tue,  5 Jan 2021 13:06:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEF6D4B360
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:05:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o-9xLxVoG1Kc for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 13:05:57 -0500 (EST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
 [209.85.128.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B6384B367
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:05:57 -0500 (EST)
Received: by mail-wm1-f41.google.com with SMTP id e25so402438wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 10:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=X/13wAME+aCvCn5cqIsjPJwjMTVT6zNfbY7h8F95inU=;
 b=wN3JmV9nSFl9HK96BxwqTYn8/5UMJbxbz7CdJ8zLp9QDqHWYIr3oZGc4uAOw8rjKLq
 ETvqki58TnkhhMU0ZfEFIV77MlBPFlzO6+h17IU+14xd8Nsin6C9PEw8brMKfiL0DRb5
 7c0MmBmJFCilyM6rPfjXrkmU/QT25TSvmBKGpQWse1fdHtSTRTkIM8yVIv4cysMFfPBs
 N7woQ89PdailPKQd2ASmnmkRfySg0Vp79bgqYLXO0vzza6WKA4zV8jVJ66sIbeiIknVw
 grv9cfR0BaqYEdtyf/Z5tWlBNvt83zbHFsqtKqM2QMqAywqAU1MTqHg5LhwoynxmvWgW
 lwZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=X/13wAME+aCvCn5cqIsjPJwjMTVT6zNfbY7h8F95inU=;
 b=e94JJkBmM315zR7tSS2fmjutiqg6/FlKXQGhzLSTTYOQaw6YtTXq++zdYdVIiAkNR1
 P6PVKd19oum4N6KdFPZQIJwDT4qRLrv8j4m6NHl0s7hithovrXFgcnYshTyVKTnPCh/P
 sm2IEyg9mUmnaW08F9/jLwC8szqcB8DOcMisziPGlgKtkD8+UFMDSQ9cdqJ0DSG3uilc
 bE2qrE/VqOKal8OjVhbXWJbFhklotCEjBdyR2V9JczS64ZV1No7eiaWvTnL6h8aVkL0X
 Hz+GAp2aSqP+9nop317bWiXJqWE01NYmKC7gUPjjxCxw2SblX97Hft6pbtRpVPzHhhWm
 +3XA==
X-Gm-Message-State: AOAM531GcXyrEc9dZCOD6/roeZMecc3BQMXREb1fW9ujUjxa+HY05mb7
 5UM9UiIt7Rsxfb4QCQGBVd1+6LxG0+DpAw==
X-Google-Smtp-Source: ABdhPJz/PuVzjxuGEJSY0xr4tIJRO9R+UGeZ8GgQutDB2H8aMEedZEEpe4b16RKs/VWV9FRUwnJ//A==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr312455wml.11.1609869955809;
 Tue, 05 Jan 2021 10:05:55 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:4957:71a5:7b5c:c94f])
 by smtp.gmail.com with ESMTPSA id j15sm718938wrr.85.2021.01.05.10.05.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Jan 2021 10:05:54 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 1/8] KVM: arm64: Rename .idmap.text in hyp linker script
Date: Tue,  5 Jan 2021 18:05:34 +0000
Message-Id: <20210105180541.65031-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105180541.65031-1-dbrazdil@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

So far hyp-init.S created a .hyp.idmap.text section directly, without
relying on the hyp linker script to prefix its name. Change it to create
.idmap.text and add a HYP_SECTION entry to hyp.lds.S. This way all .hyp*
sections go through the linker script and can be instrumented there.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S  | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 31b060a44045..68fd64f2313e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -18,7 +18,7 @@
 #include <asm/virt.h>
 
 	.text
-	.pushsection	.hyp.idmap.text, "ax"
+	.pushsection	.idmap.text, "ax"
 
 	.align	11
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index 1206d0d754d5..70ac48ccede7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -12,6 +12,7 @@
 #include <asm/memory.h>
 
 SECTIONS {
+	HYP_SECTION(.idmap.text)
 	HYP_SECTION(.text)
 	/*
 	 * .hyp..data..percpu needs to be page aligned to maintain the same
-- 
2.29.2.729.g45daf8777d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
