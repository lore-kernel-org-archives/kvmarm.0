Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C21C4320A
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 19:59:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B51661100
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 19:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5B51661100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F15E44B0CA;
	Wed, 18 Aug 2021 15:59:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wq6Lxe6XiyY9; Wed, 18 Aug 2021 15:59:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F397A4B0EA;
	Wed, 18 Aug 2021 15:59:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F19A349E57
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Kjovvc2gKvA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 14:43:16 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEBEC4099E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:16 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 j9-20020a2581490000b02905897d81c63fso3851021ybm.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 11:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=l9Ep8m3SAn8ZPERlomDWGpbLnUSGIc8n7kJ/7XvQr3I=;
 b=oIzGtBG58c+wvTDLuFazeHcg/gPwfiCk99Ee97zl4k8+L1dKwwmXs34v0QUT+bnKvT
 zy2wQkhJznKa9FoL9aYZvaWbFcmaNuQ5HC7MaQIo23e5A65KMd5QY9coe3o8Cz+JX2Ho
 M4liQQY7ZD2n0JX+hAYWOcsYpcRw2GjnmE5vvhh4PuKMCSZjcvAR2RROiVsvHax1lE4k
 MLEjVq9Gc7d//PDBCATacOIlXbDaZkjxQbM6IRbd57wJS36WL/Hma0q8f7uJ+i9VgVs8
 Aa6/Rq3XxQ3+WcbKhYrsxs6dcXxbPlqk2kbX+K1Bj7/unA4RNBS4ewt+qC1CPtFoKXdc
 TMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=l9Ep8m3SAn8ZPERlomDWGpbLnUSGIc8n7kJ/7XvQr3I=;
 b=ppRTNzjap2Hg8KFKG/oc1lH+/oV8LPqVDD7ul7NJ2I4jIFsNuGZtJKTooV4UR3Z/Ug
 f/qWjBqu7lospfVUEkBpgFfuCgPPo8kZg4rPgeOSd8DBAsxXwTZ8CBqkSuqPnnzgUkZi
 0F2mF/uEyXTMltedtgofUe8GEdYm0iWH1jeNeHMoj0oyNMXAXXxsV0LU73mMSPQYwGEW
 BI+hxM75Z8G21EvdmzErEPgIsiul+K77rzzBCm4ozptdfStMtEgAGSz8IrlN8LlGGG0u
 pvKGtJB4Xo8gRytPxVHwa7vhbgrI+y4Xs+ZyTs/sOvEdn9uBhTj1nxUwsGD5IcoRXlNT
 s40g==
X-Gm-Message-State: AOAM530143lRb6H0l6Vo8RJIz9MzVbOlQbuGqVppQx2fbExBOESjVas0
 Pm3i91y8nGXZ4X9yIEYLyS5Sj9rKYiuv
X-Google-Smtp-Source: ABdhPJzL1rSeACANcoAXaGAe6gCJ9waFOyb6BJmgH5pkNGv5e5te1StvfFWXP1m0l6m9UcT33XY90MOeQG06
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6902:547:: with SMTP id
 z7mr4683235ybs.303.1629312196319; Wed, 18 Aug 2021 11:43:16 -0700 (PDT)
Date: Wed, 18 Aug 2021 18:43:01 +0000
Message-Id: <20210818184311.517295-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 00/10] KVM: arm64: selftests: Introduce arch_timer selftest
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 18 Aug 2021 15:59:47 -0400
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, kvmarm@lists.cs.columbia.edu
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

Hello,

The patch series adds a KVM selftest to validate the behavior of
ARM's generic timer (patch-9). The test programs the timer IRQs
periodically, and for each interrupt, it validates the behaviour
against the architecture specifications. The test further provides
a command-line interface to configure the number of vCPUs, the
period of the timer, and the number of iterations that the test
has to run for.

Since the test heavily depends on interrupts, the patch series also
adds a basic support for ARM Generic Interrupt Controller v3 (GICv3)
to the KVM selftest framework (patch-8).

Furthermore, additional processor utilities such as accessing the MMIO
(via readl/writel), read/write to assembler unsupported registers,
basic delay generation, enable/disable local IRQs, and so on, are also
introduced that the test/GICv3 takes advantage of (patches 1 through 7).

The patch series, specifically the library support, is derived from the
kvm-unit-tests and the kernel itself.

Regards,
Raghavendra

v1 -> v2:

Addressed comments from Zenghui in include/aarch64/arch_timer.h:
- Correct the header description
- Remove unnecessary inclusion of linux/sizes.h
- Re-arrange CTL_ defines in ascending order
- Remove inappropriate 'return' from timer_set_* functions, which
  returns 'void'.

Raghavendra Rao Ananta (10):
  KVM: arm64: selftests: Add MMIO readl/writel support
  KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
  KVM: arm64: selftests: Add support for cpu_relax
  KVM: arm64: selftests: Add basic support for arch_timers
  KVM: arm64: selftests: Add basic support to generate delays
  KVM: arm64: selftests: Add support to disable and enable local IRQs
  KVM: arm64: selftests: Add support to get the vcpuid from MPIDR_EL1
  KVM: arm64: selftests: Add light-weight spinlock support
  KVM: arm64: selftests: Add basic GICv3 support
  KVM: arm64: selftests: Add arch_timer test

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/arch_timer.c        | 382 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          | 142 +++++++
 .../selftests/kvm/include/aarch64/delay.h     |  25 ++
 .../selftests/kvm/include/aarch64/gic.h       |  21 +
 .../selftests/kvm/include/aarch64/processor.h | 140 ++++++-
 .../selftests/kvm/include/aarch64/spinlock.h  |  13 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 +++++
 .../selftests/kvm/lib/aarch64/gic_private.h   |  21 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 +++++++++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 ++++
 .../selftests/kvm/lib/aarch64/spinlock.c      |  27 ++
 13 files changed, 1176 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c

-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
