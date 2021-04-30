Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6F4C43461
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 23:24:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3AF2A6141E
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 23:24:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AF2A6141E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 911C94B470;
	Fri, 30 Apr 2021 19:24:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q2ciNooXV3rd; Fri, 30 Apr 2021 19:24:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51F824B49C;
	Fri, 30 Apr 2021 19:24:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 512584B47F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 19:24:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tZNSL2NN6waw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Apr 2021 19:24:11 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91B554B470
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 19:24:11 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 oa1-20020a17090b1bc1b02901507fafb74fso2402476pjb.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 16:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=E9dhF2zRcjBoJyUagXIfZYrtnBYAcfcBi4++x+LfSDA=;
 b=eK+y/OfDIUCfpXL+6G9kEV5E1+nBdAlojXSCo0Mp5ScQGuZNoHJeAGJ4Egi6+RKL9Z
 zrmB1RpeE5bjubElxSbmIx52AhCcA5mvZMUz4IgwpZ29/DFmJ/YBfPh2A8hcZzfJXz6f
 Jstp0DbCQ/ZTzdSUOo6t9IXl1MoylEMA+PsEQozOB/STsbzC2+WdPRqrT2mv34O6rt/W
 SJwpLhRhMlapWReiTXgtI5qQ4PJuDsfZKHC6zgAXsHhTTBiDYqaqzTEexOVHb4vr7RhQ
 dvuiA2rWiTz7zsaXh7XsJwMiaOQxQj3aUnDQ0tVvYybkEIkP73dOpremRPmtcxlH3KA5
 xZfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=E9dhF2zRcjBoJyUagXIfZYrtnBYAcfcBi4++x+LfSDA=;
 b=krfM3gk8+k0IGK2XSOKOlqCD9L4ouinWrZMjRjBB/xbKDaB5B8hDXfPEOT6QvweYzq
 onMKQfUjfWqTqMUAPl0VpgpHQxUCF7DzD0zJDcNVg8A2xTcsojzqDdxumXnjAdvzl1ro
 Z7Jwl3N3QwcVvyHXw/KCF0QqpQAsyNqahogX64FJLOYdV/dw7OFNcTtZx332l9pqChlU
 X8ntJUYT+iId5CBZN2b5fYPxeAHTILD7U6p816VNpyghGnZ3+6kOUPe+KSGsdfJoIRf2
 yNnBf+GigHEsXDsYqPJ9uoXO4pLe90P0CxzApXFDv5MT1WscArEC0ehk/23X2unmgFjK
 RiVw==
X-Gm-Message-State: AOAM533yAsphZK7pq6DGwQtcn6bo6TkyOpXblhgYU16tS54IYAf8Y8aI
 U0XST1Xk7SEO33Kiqjz8iIXz0tDQny+Krw==
X-Google-Smtp-Source: ABdhPJx8Zj51M8c+P8fjodtaWXMvKND3bUmTo0cpsuI7daS6L06aMBpeM4573QKUNZ9T/hCuJU9qEZzNtfCIXA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:dacf:b029:ee:ac0e:d0fe with SMTP
 id q15-20020a170902dacfb02900eeac0ed0femr2916269plx.30.1619825050505; Fri, 30
 Apr 2021 16:24:10 -0700 (PDT)
Date: Fri, 30 Apr 2021 16:24:02 -0700
Message-Id: <20210430232408.2707420-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 0/5] KVM: selftests: arm64 exception handling and debug test
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
 .../selftests/kvm/aarch64/debug-exceptions.c  | 244 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  90 ++++++-
 .../testing/selftests/kvm/include/kvm_util.h  |  10 +
 .../selftests/kvm/include/x86_64/processor.h  |   4 +-
 .../selftests/kvm/lib/aarch64/handlers.S      | 130 ++++++++++
 .../selftests/kvm/lib/aarch64/processor.c     | 124 +++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  19 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
 .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
 13 files changed, 611 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

-- 
2.31.1.527.g47e6f16901-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
