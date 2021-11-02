Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7B4C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 00:22:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86F8760F56
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 00:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 86F8760F56
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E79704B204;
	Mon,  1 Nov 2021 20:22:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OsrwNWd8HSq6; Mon,  1 Nov 2021 20:22:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDDB24B1F6;
	Mon,  1 Nov 2021 20:22:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4EF54B1D3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Nov 2021 20:22:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xCtf59HK-WNV for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Nov 2021 20:22:20 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66CB04B102
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Nov 2021 20:22:20 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 x14-20020a63cc0e000000b002a5bc462947so9389150pgf.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Nov 2021 17:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=0q1tLc0oeztZBZsXvvPTzof7ayB7Bik3/teaxGikVwA=;
 b=M9RyMn9NtpqtxZRq6dzqh0AmQGmFRmQFCx0PnDS2BS3EfbwgzHnzMPoUT2VW2baznj
 s/4fI0vdhHNI76oo0fmgPbIBhoai9JINiRpWpJUOG2dlyqm6CqqJR5kWP5ZUv+dsnVIV
 V6vOssewxpAsmnUIyrtJ1cuEd+jTbQVSJf+572afB4Bhyl/o6D41fSZK1n/iV2T7a/f7
 YlsTaWYn0UvkbjeKDIifzJna5+4mnIo+8UdBYC6+VQyTnS+Y0lkbYcoXGQVMjW4r7Cqj
 OV+FXdbxhJC+XuK8NFkZPJ+UG5ZcHG5ePMrx+yZEseXk7KjEywWzFJvgXxvVq5zrPO2P
 Wp/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=0q1tLc0oeztZBZsXvvPTzof7ayB7Bik3/teaxGikVwA=;
 b=FSNnVdBLQQY/42GCSg7BsEaD401siaKmb1KhzgfTB4K6e/cpaU/1G5qZnZFZbupLgq
 DvS29UW22YE3nPzUF3YmRlFLufT4ZRLsMl8/6BniJeFsUTee93Y70vDtT8+sF8GU/qbN
 P2YfpMVPELMCXHDlUP/D8zil9l+wiJVm6TrrZ163hPR8By1wO0AvS8NPZRulvS/6iAIO
 yxgp0l8ac50ANPydq11khv4zsUnT3ta9AergSxnXXNIA7QY4+vfPZ377/OXKXxqRE4he
 OEFoBSwtf2tqPHQTM8RNKt2L+XnR7uqpGt1ybjPHdJdlrNE1MS7+1eARaOCBLFaPdfnq
 z9AA==
X-Gm-Message-State: AOAM532EZiIbu/iOYENJolzSzjnEqXxozUCCjvlFb9YuTZ0BmtBqWk5D
 RZg2Qnf3J02JD5iG1BMWKzY2fP52N7Ka
X-Google-Smtp-Source: ABdhPJxNMFUzGq4vVDxdHLg1Zowo37UyC15esk5w81Yj2K1hViKi29lRAuknRKEVUhuJwiI85y6JmFLNHLAH
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:6bc8:b0:13f:8a54:1188 with SMTP id
 m8-20020a1709026bc800b0013f8a541188mr27979352plt.49.1635812539339; Mon, 01
 Nov 2021 17:22:19 -0700 (PDT)
Date: Tue,  2 Nov 2021 00:21:55 +0000
Message-Id: <20211102002203.1046069-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH 0/8] KVM: arm64: Add support for hypercall services
 selection
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
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

Continuing the discussion from [1], the series tries to add support
for the user-space to elect the hypercall services that it wishes
to expose to the guest, rather than the guest discovering them
unconditionally. The idea employed by the series was taken from
[1] as suggested by Marc Z.

In a broad sense, the idea is similar to the current implementation
of PSCI interface- create a 'psuedo-firmware register' to handle the
firmware revisions. The series extends this idea to all the other
hypercalls such as TRNG (True Random Number Generator), PV_TIME
(Paravirtualized Time), and PTP (Precision Time protocol).

For better categorization and future scaling, firmware registers
are introduced based on the SMCCC service call owner (standard secure
service, standard hypervisor service, and vendor specific hypervisor
service). Each of these registers exposes the features employed in
the form of a bitmap and are enveloped into a generic interface (for
future expansion).

Upon VM creation, all the features supported by each owner type are
enabled. User-space/VMM can learn about the services currently enabled
via GET_ONE_REG and can manipulate them via SET_ONE_REG interfaces.
These 'writes' directly effect the bitmap, which is further checked
when the guest tries to issue the hypercall and a decision is taken
weather or not the hypercall is accessable to the guest. The interface
works well across live-migrations where the VMM can simply save/restore
these firmware registers using the existing IOCTL interfaces.

Upon VM start (at least one vCPU runs), the registers become read-only
and cannot be manupulated by the VMM. This is just to avoid providing
conflicting views of the services to the guests.

One of the problems that the series need to address is the enablement
of the features carried by a firmware register, whose existance is
not known to the VMM yet. A couple of ideas were discussed to handle this:

    1) Upon the first SET_ONE_REG, clear all the firmware registers
    implicitly. It's the responsibility of the VMM to make sure that it
    configures all the registers that's known to it.

    2) Contrary to #1, which implicitly clears all the registers, introduce
    a new capability to handle this explicitly. That is, the after learning
    about the services supported by the host, the VMM writes to the
    capability to explictly clear the registers.

The series currently employs #1 just for the sake of completion, but is
open for further discussion.

The patches are based off of kvmarm-next 5.15-rc4, with the selftest
patches from [2] applied.

Patch-1 factors out the non-PSCI related interface from psci.c to
hypercalls.c, as the series would extend the list in the upcoming
patches.

Patch-2 sets up a base environment to handle the 'writes' of firmware
register- clear all the registers upon first 'write' and block 'writes'
to the registers upon VM start.

Patch-3 introduces the firmware register, KVM_REG_ARM_STD, which holds
the standard secure services (such as TRNG).

Patch-4 introduces the firmware register, KVM_REG_ARM_STD_HYP, which holds
the standard hypervisor services (such as PV_TIME).

Patch-5 introduces the firmware register, KVM_REG_ARM_VENDOR_HYP, which holds
the vendor specific hypercall services.

Patch-6 imports the firmware registers' UAPI definitions into tools/ for
further use in selftests.

Patch-7 imports the SMCCC definitions from linux/arm-smccc.h into tools/
for further use in selftests.

Patch-8 adds the selftest to test the guest (using 'hvc') and VMM
interfaces (SET/GET_ONE_REG).

[1]: https://lore.kernel.org/kvmarm/874kbcpmlq.wl-maz@kernel.org/T/
[2]: https://lore.kernel.org/kvmarm/YUzgdbYk8BeCnHyW@google.com/

Raghavendra Rao Ananta (8):
  KVM: arm64: Factor out firmware register handling from psci.c
  KVM: arm64: Setup base for hypercall firmware registers
  KVM: arm64: Add standard secure service calls firmware register
  KVM: arm64: Add standard hypervisor service calls firmware register
  KVM: arm64: Add vendor hypervisor service calls firmware register
  tools: Import the firmware registers
  tools: Import ARM SMCCC definitions
  selftests: KVM: aarch64: Introduce hypercall ABI test

 .../virt/kvm/arm/{psci.rst => hypercalls.rst} |  59 ++-
 Documentation/virt/kvm/arm/index.rst          |   2 +-
 arch/arm64/include/asm/kvm_host.h             |  12 +
 arch/arm64/include/uapi/asm/kvm.h             |  18 +
 arch/arm64/kvm/arm.c                          |  17 +
 arch/arm64/kvm/guest.c                        |   2 +-
 arch/arm64/kvm/hypercalls.c                   | 339 ++++++++++++++++-
 arch/arm64/kvm/psci.c                         | 167 +--------
 arch/arm64/kvm/pvtime.c                       |   3 +
 arch/arm64/kvm/trng.c                         |   9 +-
 include/kvm/arm_hypercalls.h                  |  18 +
 include/kvm/arm_psci.h                        |   8 +-
 tools/arch/arm64/include/uapi/asm/kvm.h       |  18 +
 tools/include/linux/arm-smccc.h               | 188 ++++++++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/hypercalls.c        | 340 ++++++++++++++++++
 17 files changed, 1018 insertions(+), 184 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (57%)
 create mode 100644 tools/include/linux/arm-smccc.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c

-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
