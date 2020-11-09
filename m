Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0F3C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0497620731
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="SyD0mWa9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0497620731
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9854D4B720;
	Mon,  9 Nov 2020 06:32:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8tkY54Aj519d; Mon,  9 Nov 2020 06:32:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ED4B4B75C;
	Mon,  9 Nov 2020 06:32:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFC764B743
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CmRO6-sw2JeZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:32:50 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A46A4B74E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:49 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id s8so1210331wrw.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=PeIzATuK4HaCEpAoHr0Z1pMl+lKl5fFRYxsg6dRwaTg=;
 b=SyD0mWa9i62nLyko7w4nkaHf7ozC+fygqfk86ETWkYyEDKiqrC9sxoXRkEb78sAa+g
 Q5YHHsufBgveiqRwJnVc4h75bxL7UirJVCgfACmmk0/wxzMgmhus7q9dfTf0+EGBYFih
 ++c2OLt6eafuSBAZr5rEkl04qlFEuqoGjl0BaealKzOslfViDNTgJRy8l072hl5Z0vO+
 ZGhIiRZTpow3BtUcNFeME9o4ZmiMYklE4DW8x0BxuytqkKsy03j1NMCFN2b/JlvlVLNk
 5dM23D18JCx33KIKpyB1zW/c1d+CJflcKJmxYjdoLt3i7qiM+VACIHVoFWUqGPEIf2RW
 eIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=PeIzATuK4HaCEpAoHr0Z1pMl+lKl5fFRYxsg6dRwaTg=;
 b=NiJniNjfZg9jL/BxtSv7u33WWpeGklttia5NHtrNUNgyl2rxcJL7zlNbXyz1TJ3q0A
 JIrY3IaYSjCbNW6uzL3pcSQyI/D/F/gend4Y/9+f2JBM467mJEEwzlIHxisjz5JW52PK
 sFSSsSom+gXIMkVQuuofx9fr2IDkzE1Uwj4PCI1poEKcw/N8zMusGUNoNRwxm9NkH2fQ
 AlTHZUDPj9PICWnx4lEf9mFCAvSGqoHE0tuSsrKNpjcGsQsklMa5X8TKAbTZtFkmQIFK
 11vlvuo+5mNoMWMCcPjS0OOIfqTfJhlmHtv7PRLGEVUqNhG1kxlWolnkdCdWh5LrhMok
 fzDw==
X-Gm-Message-State: AOAM532+AG1QOf3B9msaZVd6Q1IjXMXp6t6gvc3OOk1OsV3rT7nloEit
 o11T9hNQtK+IWUEQo/OS/Te7zIe0fWuW829E
X-Google-Smtp-Source: ABdhPJyobQPwdOjwCkk6kEF42K4XN94BQIwbCrTUXyd35ocJY0lhgKymeEjGBQwZcIFVd9d/y9rwQg==
X-Received: by 2002:a5d:530c:: with SMTP id e12mr11343267wrv.355.1604921567943; 
 Mon, 09 Nov 2020 03:32:47 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id o10sm12514211wma.47.2020.11.09.03.32.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:32:47 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 04/24] kvm: arm64: Initialize MAIR_EL2 using a constant
Date: Mon,  9 Nov 2020 11:32:13 +0000
Message-Id: <20201109113233.9012-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
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
is set to a constant MAIR_EL1_SET.

Initialize MAIR_EL2 to the MAIR_EL1_SET constant directly in preparation
of allowing KVM to start CPU cores itself and not initializing itself
before ERETing to EL1. In that case, MAIR_EL2 will be initialized before
MAIR_EL1.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index b11a9d7db677..96e70f976ff5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -111,7 +111,7 @@ alternative_else_nop_endif
 
 	msr	tcr_el2, x0
 
-	mrs	x0, mair_el1
+	mov_q	x0, MAIR_EL1_SET
 	msr	mair_el2, x0
 	isb
 
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
