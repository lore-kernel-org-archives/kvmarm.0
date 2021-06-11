Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C14DC48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA73661376
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA73661376
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4869F49FB0;
	Thu, 10 Jun 2021 21:10:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7o5n9RAt3l8F; Thu, 10 Jun 2021 21:10:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F54F4B089;
	Thu, 10 Jun 2021 21:10:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 622E749FB0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1+pB73zBa4uq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 21:10:25 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DB3F49DE7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:25 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 s14-20020a63450e0000b029021f631b8861so755982pga.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 18:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=DuE/A6+ZG6NpgPPBvCfV9lHnuaMSkQcZ44Y2TiheBkQ=;
 b=F22a2+85RJnBkVWxq5Kh8Pdmyio3mW2wK7/olsitxBFoTGLNxInLljycY77yuxSItw
 C55BMRBGnhzYXmhmmpgf78DEkdwnbmvuEio7gIpkRA8/NM9jgV0TmCgNKdVzwlqWQL5C
 bIQvuxjob1rTEUHi+proCfcxriz4axUWbDqOIJJ7Fj5uoCH6Blq1JuMkuoZgKMXevK8c
 TT55V1sF+fny8XLEs5cMXkcmkqE5JZIEAcoP7XhhUFA5tvJ0HgXKPezXS6P1ofxSL8DU
 uRXsypP+UdiiUtrDI84K10gS0SDSNv51N4qpxMI62Ur1MOwQ9qCj7FqW779z6e+hLCAr
 eTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=DuE/A6+ZG6NpgPPBvCfV9lHnuaMSkQcZ44Y2TiheBkQ=;
 b=qbCKYg3hmLe+QxaIxK9YuWbMfBN9jDspMbXd0LT4VhLUggIabCIq8aPHaSPNlzcaeL
 goAx8CSbVh87WNgg1TlCAr2KwwnjCfcGmWFeTlswwN0KjzswnNgHrPs4NVIM1axtlCM4
 ABVxneggSe2aZtb+/quHssx2u81EIg+phOQOfrGc0rCsfUpSGK+Pht0V8iOUFhpDV5Dv
 gPN9FU4U7D1QHznx5WHwvya9jCkJktdsmucRYHMY6xIkwZ3wKflxKz7GOzAV/qUB0L90
 ubBMMMWaKrNquy+fFme9+xG7vQALiOowpO+q1mOxNvX5XfyvCzF9kRvr8W1P1A4j1dnI
 ttkQ==
X-Gm-Message-State: AOAM5337EaHIdjAMG2lhEtJnvg4LfP0eN6BQTAeNRt1adzGxW8hvKRoO
 qBZRznDrEoDFPLUGisapU+kZqzZtEDWpVg==
X-Google-Smtp-Source: ABdhPJzc1OUhWq39DEGvv1Q74X5Z4DbZEnAcBKCVfLNVtFdyoXJi3s+G+XZTARgAKKJiJiuDplex0QiX0AP9vQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:2e04:0:b029:2db:4c99:614f with SMTP
 id u4-20020a622e040000b02902db4c99614fmr5640609pfu.47.1623373823732; Thu, 10
 Jun 2021 18:10:23 -0700 (PDT)
Date: Thu, 10 Jun 2021 18:10:14 -0700
Message-Id: <20210611011020.3420067-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 0/6] KVM: selftests: arm64 exception handling and debug test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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

v3 -> v4:

V3 was dropped because it was breaking x86 selftests builds (reported by
the kernel test robot).
- rename vm_handle_exception to vm_install_sync_handler instead of
  vm_install_vector_handlers. [Sean]
- use a single level of routing for exception handling. [Sean]
- fix issue in x86_64/sync_regs_test when switching to ucalls for unhandled
  exceptions reporting.

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

Ricardo Koller (6):
  KVM: selftests: Rename vm_handle_exception
  KVM: selftests: Complete x86_64/sync_regs_test ucall
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
 .../selftests/kvm/lib/aarch64/handlers.S      | 126 +++++++++
 .../selftests/kvm/lib/aarch64/processor.c     |  97 +++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  23 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |   4 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
 .../selftests/kvm/x86_64/sync_regs_test.c     |   7 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
 .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
 15 files changed, 592 insertions(+), 50 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
