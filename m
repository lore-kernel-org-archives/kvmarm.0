Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C970DC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51D8D64F2A
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:33:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51D8D64F2A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D68424B765;
	Thu, 18 Mar 2021 10:33:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7erYIlIGgmh1; Thu, 18 Mar 2021 10:33:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDCFB4B757;
	Thu, 18 Mar 2021 10:33:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 752F74B74F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a-eM6JGryFVs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 10:33:15 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72CB04B746
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:33:15 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id r32so20192906qtd.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 07:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=VqrWDjY6Azq6yNXO1kkbJhpUxWqTgqc1Avzlqep9PQc=;
 b=BCoCthBWUxbv/Q3cGKz6KW9FskmB3uYXyeJU+uKZVxxCNZndTRUvhw7gn66pgkGJw5
 lDGssYpXiAO9HzIcAV+BstopknQ+kghY/KXu3MSmwiWKCXbSPrGAylWHP9AUHc76VN4w
 vtr37nKhudUhItt9HQ3Ah/ayNVwAAyr/l5+SDwdBlK3XgkorW4DlUVebuGtKFNvrfP49
 QFMx7UgKwZaXQmrBHTmpNy6hHvVYTR/CINjscKClaUMufFXH16LYEFeUGMslQO3RznaI
 tfnLDmKHalPD8Zp0rzjq3vw401wfKD0cbcXMraVrE0t42t2BVfw5rtmonjd3XnjOnFLY
 j8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=VqrWDjY6Azq6yNXO1kkbJhpUxWqTgqc1Avzlqep9PQc=;
 b=UlVG3tmtxmYSilzii+B5gOpfGxuclxPbhqzGwu0XBxNcibCKQhAcRfDBkx2qfAW5v8
 E/VCzqArjZdJCoyJ+3ucitUvQMkZhXKNFPwMh5E8Fw5fTDxx7P15cyU3KxmcMogdZgIC
 ORl7v9MMmmytiEWGlVWhErnfCH/4JAW9LUzdUzhloYsbDKXgKFNwG58GVU2uNpbxUASe
 VHMTsCzetmJXyQLp82a0bQ8lqk52pjZAEzbQz49P7ZcXzKDVT70jYkVhR9DfvKXELcCp
 RXi3a41iAqdrLBo67/qAup8x6u7MksgnanhU7dDDc1ilaMABomaz0uXfRso107PXFwjD
 oZLQ==
X-Gm-Message-State: AOAM530o2i2XCyYlCSViRarJHS+9D2+LiGmMROuq1LwZCGiRugbjSmH0
 yotFquKVP94/kYQOTy5CsIiSeonAb5txChygYE6hj7FuHDeJNEFLGJXPMzmCR6MabDgehiglxLR
 fNjqBq8YSS6b5eE8UDz/US75dtXzidY0932hgTzQ9+FbFaNoJShu1Rt2Ucs+w49t9XbB7Gw==
X-Google-Smtp-Source: ABdhPJzJp1hgM86HmI4ko4ffqQxrRcH7bNZFJcdumLVVnprmYVVgzk0XeIu5NJ2tU0NB1+ZL7k1hUUXd9FQ=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a05:6214:1424:: with SMTP id
 o4mr4523127qvx.34.1616077994878; Thu, 18 Mar 2021 07:33:14 -0700 (PDT)
Date: Thu, 18 Mar 2021 14:33:06 +0000
Message-Id: <20210318143311.839894-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v3 0/5] Debug info for nVHE hyp panics
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

Panics from arm64's nVHE hyp mode are hard to interpret. This series
adds some more debug info to help with diagnosis.

Using BUG() in nVHE hyp gives a meaningful address to locate invariants
that fail to hold. The host can also look up the bug to provide the file
and line, if the debug configs are enabled. Otherwise a kimg address is
much more useful than a hyp VA since it can be looked up in vmlinux.

Applies on 5.12-rc3.

From v2 (https://lore.kernel.org/r/20210223155759.3495252-1-ascull@google.com/):
 - Rebased
 - An extra little refactor in bug.c for Steve
 - Handling for the randomized offset

From v1 (https://lore.kernel.org/r/20210223094927.766572-1-ascull@google.com/):
 - keeping struct bug details in bug.c
 - using SPSR to distinguish hyp from host
 - inlined __hyp_panic_string

Andrew Scull (5):
  bug: Remove redundant condition check in report_bug
  bug: Factor out a getter for a bug's file line
  bug: Assign values once in bug_get_file_line()
  KVM: arm64: Use BUG and BUG_ON in nVHE hyp
  KVM: arm64: Log source when panicking from nVHE hyp

 arch/arm64/include/asm/kvm_hyp.h        |  1 -
 arch/arm64/include/asm/kvm_mmu.h        |  2 +
 arch/arm64/kernel/image-vars.h          |  3 +-
 arch/arm64/kvm/handle_exit.c            | 45 +++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 -
 arch/arm64/kvm/hyp/nvhe/host.S          | 18 ++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c       |  6 +--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c    |  2 -
 arch/arm64/kvm/hyp/vhe/switch.c         |  4 +-
 include/linux/bug.h                     |  3 ++
 lib/bug.c                               | 54 +++++++++++++------------
 12 files changed, 91 insertions(+), 51 deletions(-)

-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
