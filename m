Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AC2C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 15:58:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E077164E60
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 15:58:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E077164E60
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50E464B0B5;
	Tue, 23 Feb 2021 10:58:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uM430JwXKT-g; Tue, 23 Feb 2021 10:58:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A5CB4B1C0;
	Tue, 23 Feb 2021 10:58:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F494B0C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 10:58:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bY3moMGmT0vM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 10:58:04 -0500 (EST)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49C4B4B0B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 10:58:04 -0500 (EST)
Received: by mail-qv1-f73.google.com with SMTP id u8so10323245qvm.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 07:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=8+RAJRfk7OgTbqYxM+UQ8jVedyDuoEoPCHMyB2VOKvw=;
 b=snwCyNWSPwFiEEeXVMcwvUJc/IRLxmiXQcR7NjazF5zumyLDL41CwJuCP2fGuVho1C
 z5RYgOeRTAfC/A8s46Ycm002cgQir0u2TrRHv7a5W5s5GaHUNAl+Q4ozk53eCwJcm+bj
 8qt9sgY/Jlt+1Xnvh/HLfAm021tDWKoeAa7kBxKFmXWHPqn+A0H8GJv3kqUwWVXA4yHh
 5DpuhixsHvEA2k4L6Da4x3qFZm0yPkbdZ4I4MJoYXkJD8djPs6fCBa7k88HX/Q007WzO
 8r6bkwmdzRd9sxsvGiHLRdTI4pnJ7U1qvIlPgmmCmTLDaohHrp/uhKmlMcwZPwn1/CO/
 Ksvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=8+RAJRfk7OgTbqYxM+UQ8jVedyDuoEoPCHMyB2VOKvw=;
 b=N417cyJWfEJuSuNIifwN5DfMLbpAxT/dlioY9u9YJJ9WCewgLNG2Bdmybw7rBAdpFr
 mXp1BOpXjdGXRSFETqzC6NEi75lgcuWEEdmAwc4pZYsC+fvRvxLZSdPpHf7UJ+Waedqt
 H73dGjm2CjhbnKTHH4tTc3VBm0W3CIMHPXxZxZORCISZS0DfCZfUT5zOMyRfnnB9D8iD
 JN+q4cUr2gJG8xvbYwW0+AmGIARqFbITdJPbep8aczvbScAaXWCLEgPkzdLBqltkba/p
 k8F3kfWNaoyD0SA0CzKj+w0DaW8SVoXm0rwC81x1VAYFCkI1cyZiR7qz81GfwyR1DQXs
 mYYw==
X-Gm-Message-State: AOAM533bWSh9z0L/EJSe2yVnVCa8ac5sBqr2iV+bTwHLm700s9petY1u
 LGnfNVXjpcUVvLWGAlRBqORVQVDOMpXBfhvYbOc+poCEiFWFcjYKz1TW+cQHnML8AbLPxGAdmgq
 JctRKwY93HogtmT9ZqVZoj3T8v7EHGYBDy1GSKS7vw5CDJMC477TEQUA1JmvsT8HNRhLKzQ==
X-Google-Smtp-Source: ABdhPJxbhW6PmZUZmluboVPrGia5p5n2v2pDxQTnwmvGVtN8k23UllNq5Fr1Q5n5YQhxcPwFJhKZvg6Qm0c=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a0c:b495:: with SMTP id
 c21mr25640106qve.19.1614095882687; 
 Tue, 23 Feb 2021 07:58:02 -0800 (PST)
Date: Tue, 23 Feb 2021 15:57:55 +0000
Message-Id: <20210223155759.3495252-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH v2 0/4] Debug info for nVHE hyp panics
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org
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

Panics from arm64's nVHE hyp mode are hard to interpret. This series
adds some more debug info to help with diagnosis.

Using BUG() in nVHE hyp gives a meaningful address to locate invariants
that fail to hold. The host can also look up the bug to provide the file
and line, if the debug configs are enabled. Otherwise a kimg address is
much more useful than a hyp VA since it can be looked up in vmlinux.

The lib/bug.c changes apply on 5.11.

This arm64 KVM changes apply on top of the previous panic fix at
https://lore.kernel.org/r/20210219122406.1337626-1-ascull@google.com/

From v1 (https://lore.kernel.org/r/20210223094927.766572-1-ascull@google.com/):
 - keeping struct bug details in bug.c
 - using SPSR to distinguish hyp from host
 - inlined __hyp_panic_string

Andrew Scull (4):
  bug: Remove redundant condition check in report_bug
  bug: Factor out a getter for a bug's file line
  KVM: arm64: Use BUG and BUG_ON in nVHE hyp
  KVM: arm64: Log source when panicking from nVHE hyp

 arch/arm64/include/asm/kvm_hyp.h        |  1 -
 arch/arm64/include/asm/kvm_mmu.h        |  2 +
 arch/arm64/kernel/image-vars.h          |  3 +-
 arch/arm64/kvm/handle_exit.c            | 31 ++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 -
 arch/arm64/kvm/hyp/nvhe/host.S          | 17 ++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c       |  6 +--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c    |  2 -
 arch/arm64/kvm/hyp/vhe/switch.c         |  4 +-
 include/linux/bug.h                     |  3 ++
 lib/bug.c                               | 54 +++++++++++++------------
 12 files changed, 77 insertions(+), 50 deletions(-)

-- 
2.30.0.617.g56c4b15f3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
