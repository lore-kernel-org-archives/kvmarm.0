Return-Path: <SRS0=4nKG=KI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAD5C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 00:28:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DEFBB61396
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 00:28:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEFBB61396
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 481494B845;
	Wed, 12 May 2021 20:28:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CDox++ecFVtN; Wed, 12 May 2021 20:28:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 145E44B490;
	Wed, 12 May 2021 20:28:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B138F4B490
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 20:28:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N4-FnP1NEOOM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 20:28:05 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BD264B378
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 20:28:05 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 g11-20020ac84b6b0000b02901dfe301071fso7064935qts.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 17:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Q0AXb1y4mM0XDKonC9J0l8yMJqRoopU+CAh1mjQac5o=;
 b=CrI++EttyKCarsBHhj1NIQX1W4Ytekgna+XEc9ugobp0lUmmfIwZzFo1y6719X4mWa
 ooESkvHZZiXHLMJiUzFUa3jQ8is6sMQs66uj87aggctlJoUiOXzdNg5xNeRbPlyxwswt
 nzVEsXMgWAMJ7eFqvvONv0zXveT8YQkG5zoKsobt8vgpdjS4zhdnmkl2Zauylo0xQcRq
 gDQKSzHpD3Yj+drg8Tpqc1PvoJXRwIHYU2O8RVLyZ8vxUEDHKq4X9kQfRwd10ncllZRB
 Br4lXRxacQze9mIF9bm6EbcfXQa4TSUVRhvxdRUsEBFMJK78I1GY7nZKnq2GKDsGUN8x
 I4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Q0AXb1y4mM0XDKonC9J0l8yMJqRoopU+CAh1mjQac5o=;
 b=Ddv/L/9k1w4qZ8PkkAC/UdWik+WZ4M+i0nZH5e8pVhmlBS0j+c2wB4PKCOQkDdy0xK
 W6O/orFNNlnVU3HNuJxiTs6FEiqF5YE6Mm5gDrIO526ZqummjQWGjeCn5LLaQZOo6kbz
 e7/vq4wD+5NMLYKqzG9F3WOg8lCjIQqHTjFJyoZyuraeb1M/DPvXlqUi2yniX1aZxRiB
 hhgSGpsPLmn8IWEWJ8ZHDpcHRHhDp55y6LORqEyLYEBhIDEXOmR+d0XKNfElZxaUrmc6
 ZN/Ne7SXiBkaPR9j0hJZCbE6AjESjGeh16kp9IHHq4uw1ChyRnnLecvYcd0RArdfAmew
 boMw==
X-Gm-Message-State: AOAM533iXzK9h4BIsZMxkkn9gH7uqWnMXtsb6qIprolDXmLL1KVTESLB
 qPV1Jj7bkD5mBiuYQ3Gtz50laDWRZILecA==
X-Google-Smtp-Source: ABdhPJxhFvkTjka33EvfCorfu2A02LxQsuxtWR2/unbLQbI0MG7cVU2h5YFOzLNjwwnPjheVBuGa9gkKTi3q2Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a0c:ef42:: with SMTP id
 t2mr34819008qvs.48.1620865685059; Wed, 12 May 2021 17:28:05 -0700 (PDT)
Date: Wed, 12 May 2021 17:27:57 -0700
Message-Id: <20210513002802.3671838-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 0/5] KVM: selftests: arm64 exception handling and debug test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pbonzini@redhat.com
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

Hi,

These patches add a debug exception test in aarch64 KVM selftests while
also adding basic exception handling support.

The structure of the exception handling is based on its x86 counterpart.
Tests use the same calls to initialize exception handling and both
architectures allow tests to override the handler for a particular
vector, or (vector, ec) for synchronous exceptions in the arm64 case.

The debug test is similar to x86_64/debug_regs, except that the x86 one
controls the debugging from outside the VM. This proposed arm64 test
controls and handles debug exceptions from the inside.

Thanks,
Ricardo

v2 -> v3:

Addressed comments from Andrew and Marc (thanks again). Also, many thanks for
the reviews and tests from Eric and Zenghui.
- add missing ISBs after writing into debug registers.
- not store/restore of sp_el0 on exceptions.
- add default handlers for Error and FIQ.
- change multiple TEST_ASSERT(false, ...) to TEST_FAIL.
- use Andrew's suggestion regarding __GUEST_ASSERT modifications
  in order to easier implement GUEST_ASSERT_EQ (Thanks Andrew).

v1 -> v2:

Addressed comments from Andrew and Marc (thank you very much):
- rename vm_handle_exception in all tests.
- introduce UCALL_UNHANDLED in x86 first.
- move GUEST_ASSERT_EQ to common utils header.
- handle sync and other exceptions separately: use two tables (like
  kvm-unit-tests).
- add two separate functions for installing sync versus other exceptions
- changes in handlers.S: use the same layout as user_pt_regs, treat the
  EL1t vectors as invalid, refactor the vector table creation to not use
  manual numbering, add comments, remove LR from the stored registers.
- changes in debug-exceptions.c: remove unused headers, use the common
  GUEST_ASSERT_EQ, use vcpu_run instead of _vcpu_run.
- changes in processor.h: write_sysreg with support for xzr, replace EL1
  with current in macro names, define ESR_EC_MASK as ESR_EC_NUM-1.

Ricardo Koller (5):
  KVM: selftests: Rename vm_handle_exception
  KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector
    reporting
  KVM: selftests: Move GUEST_ASSERT_EQ to utils header
  KVM: selftests: Add exception handling support for aarch64
  KVM: selftests: Add aarch64/debug-exceptions test

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  83 +++++-
 .../testing/selftests/kvm/include/kvm_util.h  |  23 +-
 .../selftests/kvm/include/x86_64/processor.h  |   4 +-
 .../selftests/kvm/lib/aarch64/handlers.S      | 124 +++++++++
 .../selftests/kvm/lib/aarch64/processor.c     | 131 +++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  22 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
 .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
 13 files changed, 615 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

-- 
2.31.1.607.g51e8a6a459-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
