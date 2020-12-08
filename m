Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009C7C4167B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F16623A5B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F16623A5B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31DA64B278;
	Tue,  8 Dec 2020 09:25:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fTWokH7w2mMs; Tue,  8 Dec 2020 09:25:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B5944B27A;
	Tue,  8 Dec 2020 09:25:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ACC94B271
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k-Ho+UkrjVAf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 09:25:11 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C589D4B270
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:10 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id y17so6998189wrr.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 06:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=/OsSmUS/TA4WzvLCDGFMnERywT0JtFSnemYNOkWYU7I=;
 b=cDmmm0JhZog6Xpj0xnjDgjeGpv3JmrqqAS/Hzljmtb8vCenaWLk0Ip2XeAbYBS9NqG
 qTsMIEOZtuf8EF7qteO+W8tpzKkzx/uo957in9mqwbKHsZMWpNpdi+BoYHz9fMaBQ1tg
 Dzt8LNJ1VAjZQuATmdisp9eUPX8q90eYl6YgQTCE4z4PCr1nx2+P7/buuKoRG6NHG8Aj
 46wk2xK1UOFU4WpTk3SghsahwJ/PcFhU7EYNW4J6ys7RaNjB2VMJko+6b9L31x4niW2K
 0brar/neIAiT9q2EGjPKdN0j711bn51YXlrehLWLF3H/yZiZF8jdIXIPPYylY64Q0oSU
 xl1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=/OsSmUS/TA4WzvLCDGFMnERywT0JtFSnemYNOkWYU7I=;
 b=HDPnv/CW0mcPnEK2SsmwFWX/3arQk2gEROGmmCBa1+zg3uY6kC1EBuNdkiM8auDdjx
 qFUpI/+ZFTcMHe9X4F/m3GsDooVQejsakwKBaQXKSX8wmqe7wC44RDlqU4O+onoK1s1C
 DqZXNGq+NDudq6+zSJGHxQYUfksJWLXQrSz8dzUEmhWT91LB0vn/Rrdj8rxJijxDwQXk
 t+5m+ey6SjV7F5L2jSq2ry0kGEaZ1UjXLLxSCyysU8C2uo59lpA1Hc5NRckRERG35Lya
 8JLCA8yJmFgXvli8Zt1bZnp7yWrYm1Ej3ZM18dpXMhz9ZQ9BbCw6ctbvwg1RLlzZlTiT
 GPwQ==
X-Gm-Message-State: AOAM5330uKeW2MjdtWYeigfi6iWF6xL9KrpFOoB8DhCX5wOacMvBc1+F
 mGyVHMkCk87zAmFE1mQ7olJv336hdjhrLg==
X-Google-Smtp-Source: ABdhPJzAbt6RsNvdFXhB3aG8NC2B+lzZJ++35G/5BqR/OlHQfGVdFuDj/qtCUap6ioQzj3F+kC4a2g==
X-Received: by 2002:adf:e444:: with SMTP id t4mr25488751wrm.152.1607437509535; 
 Tue, 08 Dec 2020 06:25:09 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:258e:cb26:cef:a620])
 by smtp.gmail.com with ESMTPSA id z21sm3843405wmk.20.2020.12.08.06.25.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Dec 2020 06:25:08 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 5/6] kvm: arm64: Remove unused includes in psci-relay.c
Date: Tue,  8 Dec 2020 14:24:51 +0000
Message-Id: <20201208142452.87237-6-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201208142452.87237-1-dbrazdil@google.com>
References: <20201208142452.87237-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Minor cleanup removing unused includes.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 0d6f4aa39621..1f7237e45148 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -7,11 +7,8 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
-#include <kvm/arm_hypercalls.h>
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
-#include <linux/psci.h>
-#include <kvm/arm_psci.h>
 #include <uapi/linux/psci.h>
 
 #include <nvhe/trap_handler.h>
-- 
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
