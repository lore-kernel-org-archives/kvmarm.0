Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3AFC4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EEE0F61212
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EEE0F61212
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CCE34B10B;
	Sun, 15 Aug 2021 13:01:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pu-cdIkIS6US; Sun, 15 Aug 2021 13:01:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 614D94B12D;
	Sun, 15 Aug 2021 13:01:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DB214AC78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lv4LuPqGmsX9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 17:12:27 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BBA349FE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:27 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 mi10-20020a17090b4b4ab0290178b6d7574aso8570397pjb.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 14:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=9IqAMVDN2NozdVtjFEdbk6JqKoFIu+WmwhRN6uOxFxA=;
 b=qAW77aiXYqzGGXHikozcZU2p17a9Y6rCtGOzJA+UEmS1rzERQOEuQxGk+Y9lDmR4pp
 2k5hgts2pqCYNDy6+kVw4tC6hhZUug5WAoXLHDDC1So6EGqBdC+AQqfsgArOulZBBY5r
 PYdXlDJ4ZnJrFOcvTyGaeyT76cQNoOsyj6nwGCBj/q7O+Dc/q2ExM8Kt2MDKVqEcGhc3
 TOqQAz/cDM9rahlnt4Utgn7xzWtLKUXJ1EQdIdj23BeB7afGERU0fjKB9jLWI27TzJpr
 M/FP8EEQL05ITRfq9gRfKzNMO0O45dmTwf3piTN01SZLzJQySVwZ+FJV9pMWZ91+kv/P
 EhTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=9IqAMVDN2NozdVtjFEdbk6JqKoFIu+WmwhRN6uOxFxA=;
 b=L07NwvgDX7QfkoRcHdYX1pCzt8AqD3UJFA8uut4I+xcqWyJk82hd0FYb35VVEAb9H/
 zqpmwGx891eWXjrFxvay53Ii6vptf3za9Rxu0wy0VhrZ0UC0BnhaJwK5GWuUvvjl5huh
 zetYB0DZ8Z1ouN3Cfsb4uDYW3ezKmaggXFXBwJnoyAo9poQzUjwyxyRI5DuVpFktGQTc
 h65AJ77r1WRXdFRd3csc+hCnS+xgYPWut6aEmhEFE+X6oeOV4CDvcXvG8ngxnuchFz6l
 +EJIBgyR/IMfkv711tB2zFmdl3MWIpe/VfO0fYtgPqkLga8wAAftGo4hNMV94GPCCiEr
 x8Bw==
X-Gm-Message-State: AOAM530uCwXH28Rg8jekRi2msAeyxdzWAqyVRIkLhSAOxdszJmYq+tei
 ubafvFA5pf6G7ZAM1KBeQAbbVEm+rNmR
X-Google-Smtp-Source: ABdhPJyVflo8FKcK6yfQ6pxwcQBZMBxsijeAF87NjaiPKul2DJpwaWfgn72+BmB3c7kswtIAUEtGHnucOTva
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1a49:b029:3e0:3b2c:c9c7 with SMTP
 id h9-20020a056a001a49b02903e03b2cc9c7mr4271401pfv.8.1628889145999; Fri, 13
 Aug 2021 14:12:25 -0700 (PDT)
Date: Fri, 13 Aug 2021 21:12:01 +0000
Message-Id: <20210813211211.2983293-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 00/10] KVM: arm64: selftests: Introduce arch_timer selftest
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Sun, 15 Aug 2021 13:01:04 -0400
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
ARM's generic timer (patch-10). The test programs the timer IRQs
periodically, and for each interrupt, it validates the behaviour
against the architecture specifications. The test further provides
a command-line interface to configure the number of vCPUs, the
period of the timer, and the number of iterations that the test
has to run for.

Since the test heavily depends on interrupts, the patch series also
adds a basic support for ARM Generic Interrupt Controller v3 (GICv3)
to the KVM's aarch64 selftest framework (patch-9).

Furthermore, additional processor utilities such as accessing the MMIO
(via readl/writel), read/write to assembler unsupported registers,
basic delay generation, enable/disable local IRQs, spinlock support,
and so on, are also introduced that the test/GICv3 takes advantage of.
These are presented in patches 1 through 8.

The patch series, specifically the library support, is derived from the
kvm-unit-tests and the kernel itself.

Regards,
Raghavendra

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
 .../kvm/include/aarch64/arch_timer.h          | 138 +++++++
 .../selftests/kvm/include/aarch64/delay.h     |  25 ++
 .../selftests/kvm/include/aarch64/gic.h       |  21 +
 .../selftests/kvm/include/aarch64/processor.h | 140 ++++++-
 .../selftests/kvm/include/aarch64/spinlock.h  |  13 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 +++++
 .../selftests/kvm/lib/aarch64/gic_private.h   |  21 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 +++++++++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 ++++
 .../selftests/kvm/lib/aarch64/spinlock.c      |  27 ++
 13 files changed, 1172 insertions(+), 2 deletions(-)
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
