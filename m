Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212A8C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C813361139
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C813361139
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DEF74B15D;
	Thu, 16 Sep 2021 14:16:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Am3m3L+rspPB; Thu, 16 Sep 2021 14:16:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BD634B0C0;
	Thu, 16 Sep 2021 14:16:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00F484A98B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1CjVsfPruXno for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:58 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E380A49DE7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:58 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 d17-20020a9287510000b0290223c9088c96so14981857ilm.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=bscRkoWhCmUqrdoE9Uy2kjhDd+L+Bo5wsdZYDj09NRA=;
 b=Omp+Kv8GsfsAlwd+15EkIN211lfCDN3xwS6/TjRxp1OFnDfl7A1eIes+NME14D5zkU
 SU1gHUL1v8E0n6cZMsL67wo8sqvGKsD9s7SAvNOZvGDLm6Q71CQQNHuWGokA8r1XgKgi
 AWItSWtYPx3zSkTSuimrx+ZsyhJJ3hwcJ9swS7QpIrDUpLoqkYvpi8/q45gdHgnABxyx
 MaVI1gl2p9k3pMHxCvAHnnwwDnruhyqoLrzOHHz9CXJjJldYYy7dVW9PIPmPfTyYbr1g
 /wa+qgJuAp4V2Z5IFkM7m9vs2beY/BcmGVV8PiWC9wd/8DN0Z7vNI+gLLJXM+LKExJim
 Nktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=bscRkoWhCmUqrdoE9Uy2kjhDd+L+Bo5wsdZYDj09NRA=;
 b=pcfIfOlM/wYPtMsd/6tUWj0plbP7mvNp7LgCsswIWbFwXoHNRTBkPgX8XOrN4447Fr
 5OmSzMwFU8TcpPLNb1LkjG17Z72ntAbR9c4FwuxdbKa6Ok1JLHSTv3hhQaNxojrwcgfp
 4tqTfX94jUgdiN900+pJaw0lzQoKnUgPTvrkCeLo3NAaPH5xIHxtFxfFJAZemdXiK4IS
 2OFPyBUAko8+HS8D41nxBw3M9B0cd9FbPZual8245ZaZaQzayEHa5UuvzSaX0lWbumsB
 HyfenOiz4WwMx2Ti7hTAbfmAdzSKrBxMBKL7RILCUADzVYdevMV6CaXgu5SNf6fT8gWO
 bwmg==
X-Gm-Message-State: AOAM531ADMf49PU2BYuoEZkMOY4R1LcFhiSIULZfMdZM5377DGujw9fK
 v7vowADV3M6Tm6lz1lhTHKgQPgFegIo=
X-Google-Smtp-Source: ABdhPJw7P9q6ohfaLCYYiJQsfCZ5CUJm5aQJkALSzTzedA418ocdFUdRDhmRlqyMXq3CYS/vrg37QpBFSCc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:2167:: with SMTP id
 s7mr4906857ilv.314.1631816158433; Thu, 16 Sep 2021 11:15:58 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:46 +0000
Message-Id: <20210916181555.973085-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 0/9] selftests: KVM: Test offset-based counter controls
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Patch 6 adds basic arm64 support to the counter offset test, checking
that the virtual counter-timer offset works correctly. Patch 7 does the
same for the physical counter-timer offset.

Patch 8 adds a benchmark for physical counter offsetting, since most
implementations available right now will rely on emulation.

Lastly, patch 9 extends the get-reg-list test to check for
KVM_REG_ARM_TIMER_OFFSET if userspace opts-in to the kernel capability.

This series applies cleanly to 5.15-rc1

Tests were ran against the respective architecture changes on the
following systems:

 - Haswell (x86)
 - Ampere Mt. Jade (non-ECV, nVHE and VHE)

v7: https://lore.kernel.org/r/20210816001246.3067312-1-oupton@google.com

v7 -> v8:
 - Rebased to 5.15-rc1
 - Dropped helper for checking if reg exists in reg list (no longer
   necessary)
 - Test and enable KVM_CAP_ARM_VTIMER_OFFSET
 - Add get-reg-list changes

Oliver Upton (9):
  tools: arch: x86: pull in pvclock headers
  selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
  selftests: KVM: Fix kvm device helper ioctl assertions
  selftests: KVM: Add helpers for vCPU device attributes
  selftests: KVM: Introduce system counter offset test
  selftests: KVM: Add support for aarch64 to system_counter_offset_test
  selftests: KVM: Test physical counter offsetting
  selftests: KVM: Add counter emulation benchmark
  selftests: KVM: Test vtimer offset reg in get-reg-list

 tools/arch/x86/include/asm/pvclock-abi.h      |  48 ++++
 tools/arch/x86/include/asm/pvclock.h          | 103 ++++++++
 tools/testing/selftests/kvm/.gitignore        |   3 +
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 207 ++++++++++++++++
 .../selftests/kvm/aarch64/get-reg-list.c      |  42 ++++
 .../selftests/kvm/include/aarch64/processor.h |  24 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  11 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  44 +++-
 .../kvm/system_counter_offset_test.c          | 220 ++++++++++++++++++
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 ++++++++++++++++
 11 files changed, 907 insertions(+), 3 deletions(-)
 create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
 create mode 100644 tools/arch/x86/include/asm/pvclock.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
