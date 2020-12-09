Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1DFC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3CA1923BE0
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CA1923BE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D17D54B2F1;
	Wed,  9 Dec 2020 08:17:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PrpuvNk84eww; Wed,  9 Dec 2020 08:17:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 504F94B2F5;
	Wed,  9 Dec 2020 08:17:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E224A4B2EF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:17:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kHPTS65vP3ib for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:17:56 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E52234B2F7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:17:55 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id q75so1639162wme.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ODR//cwk6hwl4QVv9WxKniuODKXuHa0De3QF5nrHIF8=;
 b=D9l4XlNV7e+nqwFqjwgoM8i0tZtjPXnV/1t9K4p0LHGAHrDPuK6Uh4KI0K1Ccf4rYR
 RyzWt8rtG2bUkWDMfweQh4sRU//DySGqA6cTqBEqWrjCga2vPp0k8VLsnHuhaRz8WW0p
 PIh6vQZhhs+WknKoOizMB6X9fo2KSgguJmaznyyhXFHP3tg8lgDhJP4ZEDwdn+hc3nwc
 CJe6Say+NGiW2MOE3ooxvI8ONCt2j+yYmQP9X7HEsWluFyovewhRwyv7SS9kVpnRoZi9
 Xsgl/EBsv8L0ZK5fNxVuQD0bOcT1j24yA9hR6pEk1+ESD99B5RZPMzRIQimFBNqgTeTp
 wicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ODR//cwk6hwl4QVv9WxKniuODKXuHa0De3QF5nrHIF8=;
 b=fSb1ZCx1OPsArA8+XVglGBs8kWg+kOsajCSraB5Xz9XH8BP3nwYo0lByb4AJol2KAZ
 N7LvfbaaM2vUTFpDj5wcvjIc8GWYK6YYqdZuKIdGwTsa97GLo3m8B4U4MFFdlCLHA7lW
 XpCROoYT7mEPfYZjqnQq0UtNePz2P/ofgaU9vDs69v8f3HYQ2qcdTiPQ7wZGCBDi4U36
 pf1W3wiVotQz1XFNvINIIkvK2l8WcGDgkjlWddRMhtdN8EfCzfpiLr+LdLKx2hEyCjBi
 81yFN6oohVURcH2lrewoSjv1ZcnZiyhY7dBcWMF1ZgFF3xQ3HtIlNzsgtKsxr+Us8zHK
 p4dQ==
X-Gm-Message-State: AOAM532MHUaQB/IOVZsAi2Oiw2BiuVc2UIq60cOxLVBtFcC98bJlwten
 PSuICM8nRYkxwOU5JS8cCYtYhTV+QBWonQ==
X-Google-Smtp-Source: ABdhPJxiJo216uaUR1rOvqNVgnsgrbK2oTOt+NyDqS8ioUu6zr1yo3ZpJ7RnHh81iFNCSDXZK4u0DQ==
X-Received: by 2002:a7b:c843:: with SMTP id c3mr2777094wml.100.1607519874381; 
 Wed, 09 Dec 2020 05:17:54 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id q25sm3750194wmq.37.2020.12.09.05.17.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 05:17:53 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/9] KVM: arm64: Rename .idmap.text in hyp linker script
Date: Wed,  9 Dec 2020 13:17:39 +0000
Message-Id: <20201209131746.85622-3-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209131746.85622-1-dbrazdil@google.com>
References: <20201209131746.85622-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
