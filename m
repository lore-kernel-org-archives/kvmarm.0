Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C188C4320A
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C66466108E
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C66466108E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CA5B4B11C;
	Wed,  1 Sep 2021 17:14:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VNEofaYhZlJf; Wed,  1 Sep 2021 17:14:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AD1A4B149;
	Wed,  1 Sep 2021 17:14:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6B724B149
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FqoRnKVVSARY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 17:14:18 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA5B14B11C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:18 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 z6-20020a257e06000000b0059bad6decfbso834055ybc.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 14:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=IC7/AY/yxBuXuyMg4BXoHPpcO7Yg2Uivpm2g2M9LU9A=;
 b=YQHM7qcabtCeKsJwLf7HSWD9CrXjcLsr4d0DY40Vmr5wcyCYXWTLTf3b/khxxjj+17
 PKEVzkoqYS+iYNbfnnnrqg908lXzOGyt9JWO2ofeUyJJ1E57soPd0H6BH58byFMHx11f
 qcfjpZQw6/uvhxE/TNRHYOenlJR2uZxToYKHiTaBrRVLUOXil632AMGsPSv8Gq8OYzXT
 X5mwhkbk5S8sI64LX1hgVBuu1OzMoDJDn0mGLgHDJNn4QTEHPLG9AzFWCtxXy1j6wYuL
 h53KotFX7laUBh6f/2jJ8tg/TDIfr6anaMXLy2jWzoBHJXKg6YQxiv23D8cBtgJy3bpI
 OoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=IC7/AY/yxBuXuyMg4BXoHPpcO7Yg2Uivpm2g2M9LU9A=;
 b=RvEvRRglb9L+AZrFeLPJ6E1M8/pMi9mopV9y0Mbpa/e4oPmcooHn9KLf2cG780zGW7
 eNXRI8WBUWwNS/emAL675wXyUGjc1/2dNdMtZSNQFa4ftdox++tsR335cRIu6XtubJpd
 n9UYc+qvAXkxagUSk8SpNrDN0Xs1T1ufLmMwC/yVM7NPeGYsE1/FswonOC2a7rt65/VC
 89oOlpcTkxknFW2fGCL3HHlQrcepRVo+crcex6mqRIsxJjcjAyAOrHhPIof4i2EUd3fF
 1c3y+B2CwCE9MsHrUSH6/kjla56P4vYGk+sa2ND5rN8LQfDpuBuC7pM96IfboiJLFksa
 PKDA==
X-Gm-Message-State: AOAM532CveAxj7HtyjFwHMmvfu0rMypDLENrGvjwbocGP2fbQQU6YbJf
 5HRQmsnj/KJcDstWDnBDWRQ1Ro8MSmv1
X-Google-Smtp-Source: ABdhPJzVt2OJAdldm107LqGs2piLrTLDAJR7RMU/Sc/Yly0nF0QfNnqBHMDf+WR1oTUaLCXqKhGQrQRWp7fj
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a5b:443:: with SMTP id
 s3mr2083384ybp.299.1630530858232; 
 Wed, 01 Sep 2021 14:14:18 -0700 (PDT)
Date: Wed,  1 Sep 2021 21:14:00 +0000
Message-Id: <20210901211412.4171835-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 00/12] KVM: arm64: selftests: Introduce arch_timer selftest
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
ARM's generic timer (patch-11). The test programs the timer IRQs
periodically, and for each interrupt, it validates the behaviour
against the architecture specifications. The test further provides
a command-line interface to configure the number of vCPUs, the
period of the timer, and the number of iterations that the test
has to run for.

Patch-12 adds an option to randomly migrate the vCPUs to different
physical CPUs across the system. The bug for the fix provided by
Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
pending state on deactivation") was discovered using arch_timer
test with vCPU migrations.

Since the test heavily depends on interrupts, patch-10 adds a host
library to setup ARM Generic Interrupt Controller v3 (GICv3). This
includes creating a vGIC device, setting up distributor and
redistributor attributes, and mapping the guest physical addresses.
Symmetrical to this, patch-9 adds a guest library to talk to the vGIC,
which includes initializing the controller, enabling/disabling the
interrupts, and so on.

Furthermore, additional processor utilities such as accessing the MMIO
(via readl/writel), read/write to assembler unsupported registers,
basic delay generation, enable/disable local IRQs, and so on, are also
introduced that the test/GICv3 takes advantage of (patches 1 through 8).

The patch series, specifically the library support, is derived from the
kvm-unit-tests and the kernel itself.

Regards,
Raghavendra

v2 -> v3:

- Addressed the comments from Ricardo regarding moving the vGIC host
  support for selftests to its own library.
- Added an option (-m) to migrate the guest vCPUs to physical CPUs
  in the system.

v1 -> v2:

Addressed comments from Zenghui in include/aarch64/arch_timer.h:
- Correct the header description
- Remove unnecessary inclusion of linux/sizes.h
- Re-arrange CTL_ defines in ascending order
- Remove inappropriate 'return' from timer_set_* functions, which
  returns 'void'.

Raghavendra Rao Ananta (12):
  KVM: arm64: selftests: Add MMIO readl/writel support
  KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
  KVM: arm64: selftests: Add support for cpu_relax
  KVM: arm64: selftests: Add basic support for arch_timers
  KVM: arm64: selftests: Add basic support to generate delays
  KVM: arm64: selftests: Add support to disable and enable local IRQs
  KVM: arm64: selftests: Add support to get the vcpuid from MPIDR_EL1
  KVM: arm64: selftests: Add light-weight spinlock support
  KVM: arm64: selftests: Add basic GICv3 support
  KVM: arm64: selftests: Add host support for vGIC
  KVM: arm64: selftests: Add arch_timer test
  KVM: arm64: selftests: arch_timer: Support vCPU migration

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/arch_timer.c        | 457 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          | 142 ++++++
 .../selftests/kvm/include/aarch64/delay.h     |  25 +
 .../selftests/kvm/include/aarch64/gic.h       |  21 +
 .../selftests/kvm/include/aarch64/processor.h | 140 +++++-
 .../selftests/kvm/include/aarch64/spinlock.h  |  13 +
 .../selftests/kvm/include/aarch64/vgic.h      |  14 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 ++++
 .../selftests/kvm/lib/aarch64/gic_private.h   |  21 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 +++++++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 +++
 .../selftests/kvm/lib/aarch64/spinlock.c      |  27 ++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  67 +++
 15 files changed, 1332 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c

-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
