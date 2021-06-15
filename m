Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFE4C48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FCD661439
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FCD661439
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9A4B4B0EB;
	Tue, 15 Jun 2021 09:40:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q4xIpPAgny+G; Tue, 15 Jun 2021 09:40:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4F754B0FB;
	Tue, 15 Jun 2021 09:40:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EE4D4B0E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C3TVQLJ6Y5Hc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:15 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E63664B0E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:14 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 s8-20020adff8080000b0290114e1eeb8c6so8611217wrp.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=fyVnhosKjO9mJxnhSqbPrj1l9sRivPJB1/WXZpuNCbg=;
 b=CsYREq5TCGC3GlLAFzzpvOuZn77mbxFuT1HeSaoBYGBPIUqCCXllBpCItlg2k4J9dr
 wSW4SwkdS5tGyldgGcoUy59zWlwHp5ZAH3ecc8LlNxDUSiB9YfVxKGW/sxxQL4FmD/b+
 lKPpn/FO4Y8fhUufgBFz7+lNLUmV6L2V8rYBSuWAoF1UDcH5oKdF5OqRVwRBXg3N/1MZ
 ps27wzJM8b/nId19bb+KylGK8pGm8BGsaNY7gWq+3vNMhgVOP8xMrrcUwNzPNlBB+a+l
 +rYJ2mHuF+N2eSlDBlDFeTrII+2b/fjA+h4K7yJpfGmMjHrPMBcermkHOTaJZe94nhTY
 0D3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fyVnhosKjO9mJxnhSqbPrj1l9sRivPJB1/WXZpuNCbg=;
 b=oMMLhyrcsw56m0Q3jUALPGf2hvm3snyXW6ukD6tn9y+ZQ+O0uV9zhPEcxvHJx6tgGP
 oqhj78DUatd6d1XQmFIqWMEVMiUYDYbI92yLiMpa0TCeoo841lVreV4yVt4g+SjUAq7O
 F0ra9HCMZCHOhnoMAzHfkFadIVkY0IMDq3I+Gmw6KBLqnjw9q5lFrPaNTne2k7dcRe1R
 vWXq3DhzKkteCrkD02h1oc+BgjKexiIghSS2sA54PGB1aFSul20J4/p4fV0j7puo+YZk
 EtAMqV6dG80w8JWoDjPmXzAwiodMZ62EQUgy9cpKyALYMAkSZtUhBQPQNLzLDv+urdm7
 g2ig==
X-Gm-Message-State: AOAM532FqfjFCXgY71YIPKDUba1pLNt7mGUEJfsHeVV2KdBu2UnML02t
 Z30OUu/cEFHR/kheBF08dw419LlFRCeWq4ykNhLsz3csJaikE/l8+4a27VfH8gz/6hjwzQ0QIWX
 0re9o9og52AsdN3OXIEEibVqU0CkvZLYV4jCrbOEsOgzqG5q454eTVConJfG8vXc+Ed8=
X-Google-Smtp-Source: ABdhPJz7Ytktcyo9Dae8s0uQ8IHI2dhbPT3mA+LLAcl6XXLCYMUnLkF73AEFzonsZW/I662sARQOr6aDHg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c304:: with SMTP id
 k4mr5384103wmj.68.1623764414046; 
 Tue, 15 Jun 2021 06:40:14 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:47 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-11-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 10/13] KVM: arm64: Move sanitized copies of CPU features
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Move the sanitized copies of the CPU feature registers to the
recently created sys_regs.c. This consolidates all copies in a
more relevant file.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d938ce95d3bd..925c7db7fa34 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,12 +25,6 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
-/*
- * Copies of the host's CPU features registers holding sanitized values.
- */
-u64 id_aa64mmfr0_el1_sys_val;
-u64 id_aa64mmfr1_el1_sys_val;
-
 static const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index ab09ccc64fea..de995a8a5eb5 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -19,6 +19,8 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
