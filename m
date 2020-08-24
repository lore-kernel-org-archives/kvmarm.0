Return-Path: <SRS0=9KKW=CC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA00BC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 392DD2074D
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIcmqzOC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 392DD2074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83D8B4CC6F;
	Mon, 24 Aug 2020 14:36:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J3-0B8MObFUQ; Mon, 24 Aug 2020 14:36:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 870E04CC83;
	Mon, 24 Aug 2020 14:36:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 075304CC81
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id POZ6yjj6axY8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Aug 2020 14:36:03 -0400 (EDT)
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com
 [209.85.215.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF8EA4CC6F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:02 -0400 (EDT)
Received: by mail-pg1-f196.google.com with SMTP id m34so4972691pgl.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 11:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=0q3yj900uh0Ob40g7BB3IvyNcAY/lFT70Br/QukZZGg=;
 b=LIcmqzOCVpHqgmI9hDZEPhZLds5gQ4yk7wpmblvSuMH+QIlzN6CvpZLKjD946EM0Kz
 8ytEwHFIDk7EZWA787zBoGrCx495LTEFwHXz+wZnIncHiGZ2pmZeY47eTvTD9y8IImRh
 ivApC4OJX47d24kn8Kli+TT7ZEl5/VURAcARcGKTHo2LcaGXHzZIBZGZiwuGAQDZUXqE
 6Nyn6HgeGCFCzvM93jhXGGrGM1iOSszQqXq0mgrG2ZsI8hHs376aG1uLx1SxZzBLarhT
 dAgZxDkrIKGByzlhcYU8tdR+CYvq9zs5Ghjf/qh3Y5Rh6yhBr0y7lFe+Ue5zjQIqPshw
 yrMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=0q3yj900uh0Ob40g7BB3IvyNcAY/lFT70Br/QukZZGg=;
 b=FTCne6Sk2aQ3YYUPFQ6Oj3GkhvCbQbMy8rfHhtku/ixEquhMq5ZVa0/9yfc09iLHUC
 1CZI/o6oByzPBCWxP7slQiCG0t1YcvRHhwZLGdnhY8tr1L+95GWPuoSfIG0Jw3U2qjmj
 yEYTJmjqyBjppoXl2q2y7rqsUWD4T1QuhIqrlQPdZZD9aRa3j+Rjp/+aFn6ZvIzqGBht
 bxbAAuik9FHCj+m2+0ONlpg/liCUrll5em2ZIMdfxvSw5CBYO7vlAegQOtF5qZrevB/t
 D83NNN3W2yvRzTGSbW1k3JvtmjPVWaWPccBGSL7cdQU1BHB/0aUMno+PQwWaNM/Krjw1
 A9XA==
X-Gm-Message-State: AOAM532bbEYnWZsen+y3Hb2gVjaMj6ahitrklpVVMdPsz+2BrQ9OMR/f
 YHICGcEpzZgXi/JR2wPh9sc=
X-Google-Smtp-Source: ABdhPJwBGdPN9kSlUa5MQoEYHoyE/DxDybs19vVY2S9ykx0HiGZwuaZLpKa7AiNCvrpGrhFFDoq6vw==
X-Received: by 2002:a17:902:8eca:: with SMTP id
 x10mr4557058plo.336.1598294160989; 
 Mon, 24 Aug 2020 11:36:00 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id j10sm12167900pff.171.2020.08.24.11.35.59
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 24 Aug 2020 11:36:00 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable 4.19 v2 0/2] arm64: entry: Place an SB sequence
 following an ERET instruction
Date: Mon, 24 Aug 2020 11:35:10 -0700
Message-Id: <1598294112-19197-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
Cc: Florian Fainelli <f.fainelli@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Fangrui Song <maskray@google.com>,
 Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Sami Tolvanen <samitolvanen@google.com>, Greg KH <gregkh@linuxfoundation.org>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Changes in v2:

- included missing preliminary patch to define the SB barrier instruction

Will Deacon (2):
  arm64: Add support for SB barrier and patch in over DSB; ISB sequences
  arm64: entry: Place an SB sequence following an ERET instruction

 arch/arm64/include/asm/assembler.h  | 13 +++++++++++++
 arch/arm64/include/asm/barrier.h    |  4 ++++
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/sysreg.h     |  6 ++++++
 arch/arm64/include/asm/uaccess.h    |  3 +--
 arch/arm64/include/uapi/asm/hwcap.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
 arch/arm64/kernel/cpuinfo.c         |  1 +
 arch/arm64/kernel/entry.S           |  2 ++
 arch/arm64/kvm/hyp/entry.S          |  1 +
 arch/arm64/kvm/hyp/hyp-entry.S      |  4 ++++
 11 files changed, 47 insertions(+), 3 deletions(-)

-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
