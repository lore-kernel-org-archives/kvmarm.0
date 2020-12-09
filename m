Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED6FC4361B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:17:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FF4223B45
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:17:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FF4223B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3321E4B2D7;
	Wed,  9 Dec 2020 08:17:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tiDy7+cIkUor; Wed,  9 Dec 2020 08:17:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33A0A4B2F0;
	Wed,  9 Dec 2020 08:17:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B93D34B2D2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:17:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DD+MJI0Uq3FZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:17:53 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B1214B2D1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:17:53 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id l9so1691077wrt.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=ui2AyYakjARNpvT610MmpwVISaykxIjU1EziL4bq/8g=;
 b=TtPn5gbE5cUnZn/XoZAH5Q1SPuX8zUYSCs/O66h6C9BXK3fpK/Gxba6BH70xbSUMQI
 rysLsdyUKSLybXMLAMuifFTOgm/GYv7CzvMxgqTkJEp1Fzljb4N/quSYihWIbdHGfOMS
 YewS6M/7CjC7YsdpjGCrrDdk6y4EyOkTNlena25qIj6QWnxi/8p/lfEfwkgi6UyCbeb6
 sjUB6nqC+Uxvz6IBGuj5pn76G9Dt2QO8PEqw5mKADfHfuFpx49k489ssqc8jcB5yU5iE
 ahnxDbrtLwfx8ViQriceqefi2FsulHCF3546sTznByZRVN57V5UzPws2FuRb/mBmH1Xt
 6yQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=ui2AyYakjARNpvT610MmpwVISaykxIjU1EziL4bq/8g=;
 b=YmeoGKhvxlpILEh2zGNkjUVPkPeDblCF2jCy9MzzObY3yVk65GKrriBqDIyXu59ZWb
 q4JjMpSFcLS4aK2HCeIsq1kFzvtc8sHUFJOewk0oVY0v16eqVqQCFOfvuol0QuWf9RL0
 h3XdziiwGG0aT//XCZJ6fZQP2+X8slhlt72k3l5gd3fFR2EebHWTKPvv7BtdIAK6/jAt
 TEGa7A4rcdL0dpkxKBVsIvtzAWAskjdTw5Lxu26WO0QSbacsR9V5DdzBzuYRKTeCXYQq
 6xImAjytpHOzEejBsBxUEcb5YR09JpBeBgQuDQCPYeeL6BpajdrtO5c3O/3nzFgx9fxU
 esxw==
X-Gm-Message-State: AOAM530ulEtq1jvgXviUmONTlRfwvTPU+YkcLVNmxsB9Y7vziuIZSn0O
 vJ8c2NufvyUOP7b4cxY5g61QhZ9w/BT6NA==
X-Google-Smtp-Source: ABdhPJzlT1ZAQI8+iYY8fpTcJpj5l6KBwxxqgFiRZRdWFROI/wunQbz/voXHfXAhUBU4AIC7QtIReQ==
X-Received: by 2002:a5d:5146:: with SMTP id u6mr2832541wrt.66.1607519872306;
 Wed, 09 Dec 2020 05:17:52 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id g192sm3294480wme.48.2020.12.09.05.17.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 05:17:51 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/9] KVM: arm64: Correctly align nVHE percpu data
Date: Wed,  9 Dec 2020 13:17:38 +0000
Message-Id: <20201209131746.85622-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209131746.85622-1-dbrazdil@google.com>
References: <20201209131746.85622-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Jamie Iles <jamie@nuviainc.com>, linux-kernel@vger.kernel.org,
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

From: Jamie Iles <jamie@nuviainc.com>

The nVHE percpu data is partially linked but the nVHE linker script did
not align the percpu section.  The PERCPU_INPUT macro would then align
the data to a page boundary:

  #define PERCPU_INPUT(cacheline)					\
  	__per_cpu_start = .;						\
  	*(.data..percpu..first)						\
  	. = ALIGN(PAGE_SIZE);						\
  	*(.data..percpu..page_aligned)					\
  	. = ALIGN(cacheline);						\
  	*(.data..percpu..read_mostly)					\
  	. = ALIGN(cacheline);						\
  	*(.data..percpu)						\
  	*(.data..percpu..shared_aligned)				\
  	PERCPU_DECRYPTED_SECTION					\
  	__per_cpu_end = .;

but then when the final vmlinux linking happens the hypervisor percpu
data is included after page alignment and so the offsets potentially
don't match.  On my build I saw that the .hyp.data..percpu section was
at address 0x20 and then the percpu data would begin at 0x1000 (because
of the page alignment in PERCPU_INPUT), but when linked into vmlinux,
everything would be shifted down by 0x20 bytes.

This manifests as one of the CPUs getting lost when running
kvm-unit-tests or starting any VM and subsequent soft lockup on a Cortex
A72 device.

Fixes: 30c953911c43 ("kvm: arm64: Set up hyp percpu data for nVHE")
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201113150406.14314-1-jamie@nuviainc.com
---
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index 5d76ff2ba63e..1206d0d754d5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -13,6 +13,11 @@
 
 SECTIONS {
 	HYP_SECTION(.text)
+	/*
+	 * .hyp..data..percpu needs to be page aligned to maintain the same
+	 * alignment for when linking into vmlinux.
+	 */
+	. = ALIGN(PAGE_SIZE);
 	HYP_SECTION_NAME(.data..percpu) : {
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	}
-- 
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
