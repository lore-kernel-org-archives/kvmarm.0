Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F6DC432BE
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89AB8613A4
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 89AB8613A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DEBD4B0BF;
	Sun, 15 Aug 2021 20:13:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7LL0W3GysGZ1; Sun, 15 Aug 2021 20:12:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D6404B11E;
	Sun, 15 Aug 2021 20:12:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2F24B0B6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3y3esyQaohsz for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:12:55 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 980934B0DA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:52 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 o8-20020a0566021248b029058d0f91164eso8322899iou.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=F1Y2ySdU0qjQ/StQ1vR0ljtsbrXHDEZds9hmCSWeblg=;
 b=YcIkqrtnhORfqMQT0ShO4+KDFWoE1MjJea43Id/Vgb1S7RsPZL/xQQxfRS0DOXF8aa
 1uPDKwX9ByY5tMfkADf2SLiHa9FBzqehpAN4eW2U/aOwB13l6UGFDvS/c7ErHcpK1WlU
 xE+VeUjHHNw3qXydHD+ImzixbQRKIM5GssHpzrEEbfeYH5uAoxJADmH3VT0eh2pzQHJd
 Oaeu4jDRxoe5StYHRUo2RwbOineqAti8tOQAIGi3RqLDURfN3j6ipgMkXV59i8eM6zlB
 0rUm9v6qZsDAx5K7lvqrLPKuf/uON4DMsB/U0wgoWtLmle/tKkVoFMyutxtZL6JElcGa
 vR4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=F1Y2ySdU0qjQ/StQ1vR0ljtsbrXHDEZds9hmCSWeblg=;
 b=jjEQpYQv9Vg66sadgwojUSzD6wvsPIj7xd4Lg+FbcIXD8iQAHRVL32abcN7gSqYVGr
 K4iOJFeMB4IZm4PeqnJ37cZZkKeJ0Sg6KKyhkvsICrCv+KXXj0O1jc7E+031iny356WD
 bVs7uc+ENTynWeOnH/mJ5QBpR0J8RJhZYmTG88DU005KJEy4wAP2VpICppui5IlwD6FY
 ozjD+V3hhB4KUFBfZdajX5Q3/cKWgPJq0457tnAKLH84VTZoGI9aTrguaEJwsLN2e9Ta
 idLBV/hiLfOTF0sf3tWhnb4+eYRReHW6ECSF7SnZK6grNM+NK4MoAqvvTDaBqZQgNetw
 OZkA==
X-Gm-Message-State: AOAM531reShB/eoC3fkWg7pZDgU5N0SBaOn7GwmnlIW6O59m/mlr6N2S
 uGOJrC/3NypAkwKfta4/MPoWJx5anSI=
X-Google-Smtp-Source: ABdhPJzV58r8h0YFfNOivf1Fn8bXACngdOE1Ug6pupFWuSHobJwQrkpGDE51X8HKwmWt2BX0OShiuEIguSk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:296:: with SMTP id
 144mr8121137ioc.114.1629072772063; 
 Sun, 15 Aug 2021 17:12:52 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:37 +0000
Message-Id: <20210816001246.3067312-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 0/9] selftests: KVM: Test offset-based counter controls
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

This series implements new tests for the x86 and arm64 counter migration
changes that I've mailed out. These are sent separately as a dependent
change since there are cross-arch dependencies here.

Patch 1 yanks the pvclock headers into the tools/ directory so we can
make use of them within a KVM selftest guest.

Patch 2 tests the new capabilities of the KVM_*_CLOCK ioctls, ensuring
that the kernel accounts for elapsed time when restoring the KVM clock.

Patches 3-4 add some device attribute helpers and clean up some mistakes
in the assertions thereof.

Patch 5 implements a test for the KVM_VCPU_TSC_OFFSET attribute,
asserting that manipulation of the offset results in correct TSC values
within the guest.

Patch 6 adds a helper to check if KVM supports a given register in the
KVM_*_REG ioctls.

Patch 7 adds basic arm64 support to the counter offset test, checking
that the virtual counter-timer offset works correctly. Patch 8 does the
same for the physical counter-timer offset.

Patch 9 adds a benchmark for physical counter offsetting, since most
implementations available right now will rely on emulation.

This series applies cleanly to kvm/queue at the following commit:

3e0b8bd99ab ("KVM: MMU: change tracepoints arguments to kvm_page_fault")

Tests were ran against the respective architecture changes on the
following systems:

 - Haswell (x86)
 - Ampere Mt. Jade (non-ECV, nVHE and VHE)
 - ARM Base RevC FVP (ECV, nVHE and VHE)

*NOTE*: Though this tests changes between both x86 and arm64, these
tests check for capabilities and skip if missing, so its OK if they're
merged in trees that lack the patches for both architectures.

v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com

v6 -> v7:
 - adapted to UAPI renaming for physical counter offsetting on arm64

Oliver Upton (9):
  tools: arch: x86: pull in pvclock headers
  selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
  selftests: KVM: Fix kvm device helper ioctl assertions
  selftests: KVM: Add helpers for vCPU device attributes
  selftests: KVM: Introduce system counter offset test
  selftests: KVM: Add helper to check for register presence
  selftests: KVM: Add support for aarch64 to system_counter_offset_test
  selftests: KVM: Test physical counter offsetting
  selftests: KVM: Add counter emulation benchmark

 tools/arch/x86/include/asm/pvclock-abi.h      |  48 ++++
 tools/arch/x86/include/asm/pvclock.h          | 103 +++++++++
 tools/testing/selftests/kvm/.gitignore        |   3 +
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 207 +++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  24 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  13 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  63 +++++-
 .../kvm/system_counter_offset_test.c          | 211 ++++++++++++++++++
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 +++++++++++++++++
 10 files changed, 877 insertions(+), 3 deletions(-)
 create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
 create mode 100644 tools/arch/x86/include/asm/pvclock.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
