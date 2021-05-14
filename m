Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11CEC433B4
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 08:56:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 55A12613F1
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 08:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55A12613F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B12354B955;
	Fri, 14 May 2021 04:56:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id myoB6cECqJmU; Fri, 14 May 2021 04:56:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B16884B8FF;
	Fri, 14 May 2021 04:56:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB5A04B8FF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 04:56:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M688zNbiof4L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 May 2021 04:56:44 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD63B4B8E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 04:56:44 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 s7-20020adfc5470000b0290106eef17cbdso12441342wrf.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 01:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=oBZ3zUbmdP3GJjYvWy+mFyc/BHLyrBC8ox4hlEgpeiI=;
 b=WKHXLjzYWiT/4jERPgEofBhCQt28t3PC63tnUay47sIU23ZaXbo1HrxJOJTldLhS8K
 ZF0ZgC+1NA4w4+71qG22dcTND9CrYKjkvji+vwZKdGgZLdPKZ3nAAW6D0OD83BAH0Ve1
 PSb89U4n/e3kvR/5sMs1sRI/3a9ZyaMobbSrSPOE3fra8kY3TQFCQNu4Utpw/g8Tzeru
 c8cxY9qNu4SovP7mgInckIrEXjixsJnxn6/XZmlzJ3IYFGYWMpwiWPiE9BRMKBCtPCFT
 ZUs7GGsvviCYriiH3aNnIz08Ad7PzUzfzqn3qxyKKm6MKKWCnrei6XYs6dBwrxQkGq8p
 a5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=oBZ3zUbmdP3GJjYvWy+mFyc/BHLyrBC8ox4hlEgpeiI=;
 b=pHrUX9uGuGPxd0ntxT3gr+VqbrsNENCQpOp5bUZKGT4w08WI8oXeptnvQvmEfXp4bW
 ezT6SRAsx3zC7gNAQhe4DlPFFRx0hnj8Jni7zzsxtMPXeKxv8uHDqRODZELcVhs/8Njo
 EfD9laGWIkf8uqtcKyKpjgqW2snsf+haKQsF6ppwl5BuSyIuMupWv+Iud8lY+Zm80OPS
 LqQ6eOAlm5O0je2u5x7fbgvYyr5WBtw/v9vaipwZlM2sNoG/8jGFIeDXrSlF52QAlbjA
 ytWk+cYykIFhcBC/6q19ChRVzjk7iKNkvG2KNdKXqLcwgt0rCJuJ22PpVft+pwEuE6Sy
 sGdA==
X-Gm-Message-State: AOAM532FCe+2/SwYDgrtI9ifODCJCUmi1eYd8Rh14pyDD6D7qH9LksHw
 AVhjL9//yVn/mIfr8DwCkWfz3P5xR74RWggQAfMTTKL4deegDjWlvbEAPLsQ/2V6T5nrUKTTR03
 NQOnaXCVcPWtLZu31qpNHTE5MyxKkX26I4FA5BT/KCysLtHQalyuDKafXukiAkN56nZY3MEa9
X-Google-Smtp-Source: ABdhPJwyv6H7rVTA6UypyQ1OyyzY8xNyQYxbWPDZaqp3Qci6FdCyvNvcVik/OkeO5aIqxa3g9rL6EVSFHgVT
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:28b:: with SMTP id
 11mr8459617wmk.27.1620982603488; Fri, 14 May 2021 01:56:43 -0700 (PDT)
Date: Fri, 14 May 2021 08:56:38 +0000
Message-Id: <20210514085640.3917886-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 0/2] KVM: arm64: Mark a couple of variables static
From: Quentin Perret <qperret@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, will@kernel.org, kbuild-all@lists.01.org
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

The kernel test bot is complaining (and rightfully so) about variables
introduced by the host stage-2 series that should be static. This series
fixes all of them.

Thanks!

Quentin Perret (2):
  KVM: arm64: Mark pkvm_pgtable_mm_ops static
  KVM: arm64: Mark the host stage-2 memory pools static

 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++--
 arch/arm64/kvm/hyp/nvhe/setup.c       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.31.1.751.gd2f1c929bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
