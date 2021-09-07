Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB85C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:10:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC22661100
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BC22661100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ACFB4B1F0;
	Tue,  7 Sep 2021 14:10:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J8ryEoKq+bPB; Tue,  7 Sep 2021 14:10:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 432A34B0D7;
	Tue,  7 Sep 2021 14:10:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2812C4A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:10:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mPQLmqxoFeA5 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 14:10:03 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E8574079D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:10:03 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 l12-20020a170903120c00b00138e2063268so2371284plh.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 11:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=3EL/0cpyqgf5kZhn/yI/Lhs/U8ef49iFyluZ/iCjP80=;
 b=mhBXZVspu3u44w6TnlIsSrX/pVRWzIeWBIqJN19OPCjAKtUCzp9L1+erO/3M5TG5E2
 YsJQFd2dV86my+qU4BDCIHO9Qp0Gyq4JhiQkKCmwOdaB6Ha2Sa8oiZXIRaEjQ7ARhP/O
 uEyob5uMh30dBZLgRsynbm53OdjaGwG5VNUg0KLKoikkbX1QQ4q0QcPg1yJwnfPCE9IE
 vZ4UaiwFk+dkegtlPWVIOIfbF/443npVnmrOsc4PhEsDE+ZLG9SnIRn9RMJxZ3khEyPj
 sGCEJxfNtZtNLVZrBqKoXihL5r6gTkNHrVANo1j712hzk0QYK8wWsAg63OZ3kL0IO/DL
 ylHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=3EL/0cpyqgf5kZhn/yI/Lhs/U8ef49iFyluZ/iCjP80=;
 b=R/IpkMBpRlvPIjw7dSL0NNVEA6R50sflAzVVjR+ouCe5VALkxJ6bgE4kl2HIzFvnYM
 oEDWJxWsmkMf7SL9CR4d3hNmeqLJ6tC//mFpU3+S3eHBaNqpskh4UdNBu/3huVCjyVmR
 X2eUMkehdnPz099ekvW8vsR8ZZ/TDYPnSy/dGdzB5jILzak+RcCam5CI+e8WN3T99b2G
 pIeYapWRgTrEwIwxZ8GArTmMf0JGRlyK0QuK4zkAx0D3tRrE0/zmvRFqvi8CAkpo8H4C
 qJMeUFLEc+K0RhUOUQ6fXwJgqTh4b07XAlBWSUenpdJarOzuHOerI4kIVyP5q6DsikIJ
 sLLg==
X-Gm-Message-State: AOAM531GUiZjXJkRgWsWaSEEcsdkeaY4HGpw2osYMe2W6evXPRW8Mq+c
 nNtdD1WAdkR4VMQKI9dYhoMuR+vW5QE0jw==
X-Google-Smtp-Source: ABdhPJz/ZY6iRv5Y40MiQYuqg5TkSzsHv35QJyuWITR9HdnZag3X6B7AjX4oAnAHsqIedrszpQ7J/tN3PRlyOw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:7f04:: with SMTP id
 k4mr112383pjl.0.1631038201805; Tue, 07 Sep 2021 11:10:01 -0700 (PDT)
Date: Tue,  7 Sep 2021 11:09:55 -0700
Message-Id: <20210907180957.609966-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v2 0/2] KVM: selftests: enable the memslot tests in ARM64
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com
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

Enable memslot_modification_stress_test and memslot_perf_test in ARM64
(second patch). memslot_modification_stress_test builds and runs in
aarch64 without any modification. memslot_perf_test needs some nits
regarding ucalls (first patch).

Can anybody try these two tests in s390, please?

Changes:
v2: Makefile tests in the right order (from Andrew).

Ricardo Koller (2):
  KVM: selftests: make memslot_perf_test arch independent
  KVM: selftests: build the memslot tests for arm64

 tools/testing/selftests/kvm/Makefile          |  2 +
 .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
 2 files changed, 36 insertions(+), 22 deletions(-)

-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
