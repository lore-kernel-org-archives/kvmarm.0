Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7507FC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:59:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 26CEC61029
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 26CEC61029
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA8134B173;
	Fri,  8 Oct 2021 11:58:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oEbdwnN8QyxW; Fri,  8 Oct 2021 11:58:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDE804B165;
	Fri,  8 Oct 2021 11:58:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E0C44B0E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qs4t-rxrM1uQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 11:58:57 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C84E84B161
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:54 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 v15-20020adfa1cf000000b00160940b17a2so7661730wrv.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rwYC2sE6wVOnGoN5vSGqYSfz4869siK4qW09U7txiBc=;
 b=c8ru3Qe1oXnPhtzT72VnFYCpAjo0RvFHMHZ080BzM5rLRiOjwEsYh2ClAFhCjYGfvG
 nLpo2bQPu7D531jc1Ec6uAziZD6qP5LbF249RkQBq2dqljC1jz6/7QvddfoLeEMALa28
 qZlD514iC2Z82FelXxaLD8MYSMyV0qB96wo+3ouHrFVENKxDnhnoaZPoq+lTw87I9uEQ
 ic0EQssLYoeM/ZVbSxuwdoKuWhAKrqgklMpbhcACsvMi4eQ6FWZ8xmUea4xv11y+zCU7
 xMYZUh0FYX1ri/vpv7r54fD6UAGR6UVBz5KhhTs8tSTUYsiUD3qnE0uyiI3NdmgiLAsI
 kwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rwYC2sE6wVOnGoN5vSGqYSfz4869siK4qW09U7txiBc=;
 b=qJoeNji1tpTMBMCyGIATEqQ3l3cKtykb0KFwlKhw2HJf7Qo5t1irgnKH6sPBd9JdGD
 RSg7ypYPeGxMIoK0WG/lm8eXnlINX+W8f/q4K4P39ENgwmPudqtgx6YGSiLOarTuxdd+
 mRC+aO6XTJZvveSOCEABe04bVpHuWM9emEqNEEU9ACfSgrTHexpEOafjnWKUTWZ39jQB
 d0ig9/6b2hggAWJ609xBiWXXd218k6PRDgLhMMk/TnsjVYQsSOkuZ7kF2liAYny+qioS
 gweOft9T99sTCIFmjfZdaqFACx6hBtAwcikMeN4/HKfWNDxQ3xGmHCh/azagLlx2Mluz
 rd5Q==
X-Gm-Message-State: AOAM531uHrvcRuccPdvqDzWPft+oTC7XsmOXO67KzlWpP0urLs+aKXjg
 se/i4TmdbGqbUexy4JZ2C6A7OP9Gfyk+Rgx8oSQc5CNcSUzLnj78FvC6TztAJ0xDsQEyKTgbzBd
 rpkDvvM1h2hm1Wo38uB4O6VI424qPchjAIPyfgeFUNeZFTeBuaCJ2ifBqxV4TkTDaZ+8=
X-Google-Smtp-Source: ABdhPJx7pb/1hcdGzJbeBZmEf+wJ6+Z2ZGHYJY+BCNomT7RALtBu2vWEN8kxXGiXRydZws0FAlsJUZqHrw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:240a:: with SMTP id
 10mr4334650wmp.170.1633708733981; Fri, 08 Oct 2021 08:58:53 -0700 (PDT)
Date: Fri,  8 Oct 2021 16:58:30 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-10-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 09/11] KVM: arm64: Move sanitized copies of CPU features
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

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2a07d63b8498..f6d96e60b323 100644
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
 const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index c4ed32521b7c..f5354233d03e 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -19,6 +19,8 @@ u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
