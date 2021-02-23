Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17CAC433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 09:49:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F1B364E58
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 09:49:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F1B364E58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FB564B1D3;
	Tue, 23 Feb 2021 04:49:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AOeeW89ft+eb; Tue, 23 Feb 2021 04:49:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87B424B1D4;
	Tue, 23 Feb 2021 04:49:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C0FE4B1C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 04:49:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rQ7iihM8W9DA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 04:49:33 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92D6F4B1B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 04:49:33 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id j204so974453wmj.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 01:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=wilH+J6ttDm5j8D4j/BY7e61WkaXbcZKLJ/faDu4VKE=;
 b=u4PBtdS6639IPYUBP1/UPbn99+dYsHnBX3Ln/1rao5vbhuaD+5Un9CI8RyJqOTF8VO
 3VsN2pqis7xDo5N/Xd5+njJwSlVfg/RibttDreWEmAilGNwu/AOZAzCVx5xg5OlgbzHJ
 +THd4gC2pQ9n5PiiJ+LA2Gj4p+ScehOtLGKv9SJjZ3hyVwwobiLQ0RHSSEtMSmJls6K/
 h53d0Va88WMtHtv6JxzwvVIcQnDI9P+m1B+K7rqVXOSPQXkHESKW0IRv/23XsgVFW/i2
 zSV8j93HHXfaaLAZf3dyIEqvmdIgFgnFwTkRkkAuL2Kq0Iah6TOlgUMBFSA5FQkOwr7I
 a/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=wilH+J6ttDm5j8D4j/BY7e61WkaXbcZKLJ/faDu4VKE=;
 b=I73sauBCU3D7jeenJelm2nJBn+OJrz7JLMmEUuWN2tY5tyOVtCGpW0zb8kUyrVYrvw
 CEo88h/X4280bTHmRSItFo/PRcQaeERx+rd3TOvgoAmCoQ4Qqc/g0i+QWLQdqyFytgoe
 NP1RjsX4Xb17A2Baqolh3pJgmYhmoXUyBoml5yceyEeVffp3t/yatdVWZWKwyAUmTAxA
 TxNrrERXJOXIfizFZhMgRltKj1T+O6XKvILqKsYzLcBbwlUw0L2Yu1S5vVbl3m69NqpA
 FTwq3+0a1nchYkAhyDoDqjEILcnkOEbVhpBYhbUASXRVHJRq0HlPldLir2serhHQDJzL
 Ohjw==
X-Gm-Message-State: AOAM530dpbiNsqPWNgysEX3z1sxW3OiDUNv+egbyGprniYo+Bwi1wOLK
 Qcg49pp04rtOIHI9l1AWL5h/q3DLaiLw2jW9ZpUj+blVEvzzaucFTskuHH8ZSkHdUnNoFdxMxQJ
 yIdHuuv9z7JAuR2Y/aXo2TgmiVtWVv2y/8dR7aEBbhptST8O4nrrgurrGPCkO6Kb0AOhtDQ==
X-Google-Smtp-Source: ABdhPJx7HpelQlKFYCxuVSxSag0yWaXAg/jK4nVcfIXZSZlo6i0JpTq4v6ZoZuZcheVev+Iq4xX/5lWbZYQ=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a1c:a791:: with SMTP id
 q139mr23786190wme.20.1614073772346; 
 Tue, 23 Feb 2021 01:49:32 -0800 (PST)
Date: Tue, 23 Feb 2021 09:49:25 +0000
Message-Id: <20210223094927.766572-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH 0/2] Debug info for nVHE hyp panics
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org
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

After being on the receiving end of an nVHE hyp panic and trying to
figure out what is was trying to tell me, it seemed like a good excuse
to add some debug info.

nVHE hyp has its own address space. Hyp VAs aren't much use for
debugging but they can be converted into kimg addresses which are
useful for looking up in vmlinux.

There are also a couple of invariant tests that call hyp_panic() but
these would give the ELR_EL2 of the previous VM which isn't very
meaningful. Converting these to use BUG() lets the correct hyp address
be captured and the source file and line can even be logged!

This applied on top of the previous panic fix at
https://lore.kernel.org/r/20210219122406.1337626-1-ascull@google.com/

Andrew Scull (2):
  KVM: arm64: Use BUG and BUG_ON in nVHE hyp
  KVM: arm64: Log source when panicking from nVHE hyp

 arch/arm64/include/asm/kvm_hyp.h        |  1 -
 arch/arm64/include/asm/kvm_mmu.h        |  2 ++
 arch/arm64/kernel/image-vars.h          |  3 +-
 arch/arm64/kvm/handle_exit.c            | 38 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 --
 arch/arm64/kvm/hyp/nvhe/host.S          | 18 ++++++------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c       |  6 ++--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c    |  2 --
 9 files changed, 52 insertions(+), 22 deletions(-)

-- 
2.30.0.617.g56c4b15f3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
