Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A7EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 05:13:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 681214B0DE;
	Wed, 24 Nov 2021 00:13:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XV8QzCq-fYau; Wed, 24 Nov 2021 00:13:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7F1C4B0F1;
	Wed, 24 Nov 2021 00:13:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70A434B0D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 00:13:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RTR+rNdsxpBn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 00:13:44 -0500 (EST)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F4C84B0BA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 00:13:44 -0500 (EST)
Received: by mail-pg1-f182.google.com with SMTP id m15so1061117pgu.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 21:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=e1dzqsYgP1AOU3wSeDrdX/w4s62HxZ9tSYror2UqHsg=;
 b=Vosw69fUhO15RMMhi8w93lj7tX+6o2sgctmKWvVNdY5HmcUhOjO4KEePVuh2y3kBN7
 feWeYgUy8xfghytaQ39DsHDkKGwTZSJhJQP5QLKRpQAiEdTDJOgC0KAvphqQQ6Fu7Qhp
 hTesiOHPgGm/Og3cUdWEacwbjpkWBT28hOr2IGB7JFrqpOBjwauIeId3+8+krBcNaNhq
 mgjxOC1/yWuiVXvmLfEhWqWbhxz97ahtnUyEaV7HljLpaVywdsnGhc+KKd+ZmzxZ+0s4
 1JXzWdIMfUW7vcH2JiGeipvNpABfGcKpzdyWRO+p9x7PNo8BPDgyiTXO+Xy2puf8XrHi
 vfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=e1dzqsYgP1AOU3wSeDrdX/w4s62HxZ9tSYror2UqHsg=;
 b=QHT/SOR5bV5TrkxsdM9cBW92nEdW3AxdfaKF+KM4sriFdVzTnXt/24tY6WQXRmau25
 UUFh7K/aX/B224BiCbCA4F0AgbRk5tIuOjKcENpER4wQVRrShAydhiucbmDQlmm9MoKh
 f9GJ3mFMRKuXl7mFp0WG/ZKORlChHxsaoRJBe96aNOBMgAKhjKD8jKqngjcwe1hLMDDO
 A4EpOTd5Hj8/lhJb2TuaQkmv/UxZEb0PpRZAs3PiUaz60VRp1+v6yaZQWVafwNDBX9/K
 klhGumrn00XBJxcGi6Spc8htPn9xCmGd70LbBUBy4nEHq1qQIMcgadHoY4zXqc8ePb63
 w80w==
X-Gm-Message-State: AOAM532xdrgI7cVQ9bF3uYoWuMLofQksa0xf69MCwiYkzfA+pyETRX2E
 iQ9wwNCihA2WP6LJwO8L+x69RFtE8Uk74BVbAGuT+Q==
X-Google-Smtp-Source: ABdhPJyvokOAgCXpC9DVsZl7yuHWNZAyv4IA9VRFby5H56KFnxxSyU3prkd4d0LB9u5pSW8jts1Phe00+k31dTnEvl0=
X-Received: by 2002:aa7:8198:0:b0:44b:e191:7058 with SMTP id
 g24-20020aa78198000000b0044be1917058mr3161845pfi.39.1637730822945; Tue, 23
 Nov 2021 21:13:42 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <YZ0QMK1QFjw/uznl@monolith.localdoman>
In-Reply-To: <YZ0QMK1QFjw/uznl@monolith.localdoman>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 23 Nov 2021 21:13:27 -0800
Message-ID: <CAAeT=FxeXmgM3Pyt_brYRdehMrKHQwZut5xTbHOv-9um7anhYw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/29] KVM: arm64: Make CPU ID registers writable
 by userspace
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

HI Alex,

On Tue, Nov 23, 2021 at 7:59 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Reiji,
>
> I started reviewing the series, but I ended up being very confused, see
> below.
>
> On Tue, Nov 16, 2021 at 10:43:30PM -0800, Reiji Watanabe wrote:
> > In KVM/arm64, values of ID registers for a guest are mostly same as
> > its host's values except for bits for feature that KVM doesn't support
> > and for opt-in features that userspace didn't configure.  Userspace
> > can use KVM_SET_ONE_REG to a set ID register value, but it fails
> > if userspace attempts to modify the register value.
> >
> > This patch series adds support to allow userspace to modify a value of
> > ID registers (as long as KVM can support features that are indicated
> > in the registers) so userspace can have more control of configuring
> > and unconfiguring features for guests.
>
> What not use VCPU features? Isn't that why the field
> kvm_vcpu_init->features exists in the first place? This cover letter does
> nothing to explaing why any changes are needed.
>
> Do you require finer grained control over certain feature that you cannot
> get with the 32 * 7 = 224 feature flag bits from kvm_vcpu_init? Does using
> the ID registers simplify certain aspects of the implementation?

Since some features are not binary in nature (e.g. AA64DFR0_EL1.BRPs
fields indicate number of breakpoints minus 1), using
kvm_vcpu_init->features to configure such features is inconvenient.

One of the reasons why we want the finer grained control is that
we want to expose a uniform set/level of features for a group of
guests on systems with different ARM CPUs.

I will update the cover letter.

Thanks,
Reiji

>
> Thanks,
> Alex
>
> >
> > The patch series is for both VHE and non-VHE, except for protected VMs,
> > which have a different way of configuring ID registers based on its
> > different requirements [1].
> > There was a patch series that tried to achieve the same thing [2].
> > A few snippets of codes in this series were inspired by or came from [2].
> >
> > The initial value of ID registers for a vCPU will be the host's value
> > with bits cleared for unsupported features and for opt-in features that
> > were not configured. So, the initial value userspace can see (via
> > KVM_GET_ONE_REG) is the upper limit that can be set for the register.
> > Any requests to change the value that conflicts with opt-in features'
> > configuration will fail.
> >
> > When a guest tries to use a CPU feature that is not exposed to the guest,
> > trapping it (to emulate a real CPU's behavior) would generally be a
> > desirable behavior (when it is possible with no or little side effects).
> > The later patches in the series add codes for this.  Only features that
> > can be trapped independently will be trapped by this series though.
> >
> > This series adds kunit tests for new functions in sys_regs.c (except for
> > trivial ones), and these tests are enabled with a new configuration
> > option 'CONFIG_KVM_KUNIT_TEST'.
> >
> > The series is based on v5.16-rc1.
> >
> > v3:
> >   - Remove ID register consistency checking across vCPUs [Oliver]
> >   - Change KVM_CAP_ARM_ID_REG_WRITABLE to
> >     KVM_CAP_ARM_ID_REG_CONFIGURABLE [Oliver]
> >   - Add KUnit testing for ID register validation and trap initialization.
> >   - Change read_id_reg() to take care of ID_AA64PFR0_EL1.GIC
> >   - Add a helper of read_id_reg() (__read_id_reg()) and use the helper
> >     instead of directly using __vcpu_sys_reg()
> >   - Change not to run kvm_id_regs_consistency_check() and
> >     kvm_vcpu_init_traps() for protected VMs.
> >   - Update selftest to remove test cases for ID register consistency
> >     checking across vCPUs and to add test cases for ID_AA64PFR0_EL1.GIC.
> >
> > v2: https://lore.kernel.org/all/20211103062520.1445832-1-reijiw@google.com/
> >   - Remove unnecessary line breaks. [Andrew]
> >   - Use @params for comments. [Andrew]
> >   - Move arm64_check_features to arch/arm64/kvm/sys_regs.c and
> >     change that KVM specific feature check function.  [Andrew]
> >   - Remove unnecessary raz handling from __set_id_reg. [Andrew]
> >   - Remove sys_val field from the initial id_reg_info and add it
> >     in the later patch. [Andrew]
> >   - Call id_reg->init() from id_reg_info_init(). [Andrew]
> >   - Fix cpuid_feature_cap_perfmon_field() to convert 0xf to 0x0
> >     (and use it in the following patches).
> >   - Change kvm_vcpu_first_run_init to set has_run_once to false
> >     when kvm_id_regs_consistency_check() fails.
> >   - Add a patch to introduce id_reg_info for ID_AA64MMFR0_EL1,
> >     which requires special validity checking for TGran*_2 fields.
> >   - Add patches to introduce id_reg_info for ID_DFR1_EL1 and
> >     ID_MMFR0_EL1, which are required due to arm64_check_features
> >     implementation change.
> >   - Add a new argument, which is a pointer to id_reg_info, for
> >     id_reg_info's validate()
> >
> > v1: https://lore.kernel.org/all/20211012043535.500493-1-reijiw@google.com/
> >
> > [1] https://lore.kernel.org/kvmarm/20211010145636.1950948-1-tabba@google.com/
> > [2] https://lore.kernel.org/kvm/20201102033422.657391-1-liangpeng10@huawei.com/
> >
> > Reiji Watanabe (29):
> >   KVM: arm64: Add has_reset_once flag for vcpu
> >   KVM: arm64: Save ID registers' sanitized value per vCPU
> >   KVM: arm64: Introduce struct id_reg_info
> >   KVM: arm64: Make ID_AA64PFR0_EL1 writable
> >   KVM: arm64: Make ID_AA64PFR1_EL1 writable
> >   KVM: arm64: Make ID_AA64ISAR0_EL1 writable
> >   KVM: arm64: Make ID_AA64ISAR1_EL1 writable
> >   KVM: arm64: Make ID_AA64MMFR0_EL1 writable
> >   KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support for the guest
> >   KVM: arm64: Make ID_AA64DFR0_EL1 writable
> >   KVM: arm64: Make ID_DFR0_EL1 writable
> >   KVM: arm64: Make ID_DFR1_EL1 writable
> >   KVM: arm64: Make ID_MMFR0_EL1 writable
> >   KVM: arm64: Make MVFR1_EL1 writable
> >   KVM: arm64: Make ID registers without id_reg_info writable
> >   KVM: arm64: Add consistency checking for frac fields of ID registers
> >   KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE capability
> >   KVM: arm64: Add kunit test for ID register validation
> >   KVM: arm64: Use vcpu->arch cptr_el2 to track value of cptr_el2 for VHE
> >   KVM: arm64: Use vcpu->arch.mdcr_el2 to track value of mdcr_el2
> >   KVM: arm64: Introduce framework to trap disabled features
> >   KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
> >   KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
> >   KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
> >   KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
> >   KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
> >   KVM: arm64: Initialize trapping of disabled CPU features for the guest
> >   KVM: arm64: Add kunit test for trap initialization
> >   KVM: arm64: selftests: Introduce id_reg_test
> >
> >  Documentation/virt/kvm/api.rst                |    8 +
> >  arch/arm64/include/asm/cpufeature.h           |    2 +-
> >  arch/arm64/include/asm/kvm_arm.h              |   32 +
> >  arch/arm64/include/asm/kvm_host.h             |   15 +
> >  arch/arm64/include/asm/sysreg.h               |    2 +
> >  arch/arm64/kvm/Kconfig                        |   11 +
> >  arch/arm64/kvm/arm.c                          |   12 +-
> >  arch/arm64/kvm/debug.c                        |   13 +-
> >  arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
> >  arch/arm64/kvm/reset.c                        |    4 +
> >  arch/arm64/kvm/sys_regs.c                     | 1265 +++++++++++++++--
> >  arch/arm64/kvm/sys_regs_test.c                | 1109 +++++++++++++++
> >  include/uapi/linux/kvm.h                      |    1 +
> >  tools/arch/arm64/include/asm/sysreg.h         |    1 +
> >  tools/testing/selftests/kvm/.gitignore        |    1 +
> >  tools/testing/selftests/kvm/Makefile          |    1 +
> >  .../selftests/kvm/aarch64/id_reg_test.c       | 1128 +++++++++++++++
> >  17 files changed, 3488 insertions(+), 131 deletions(-)
> >  create mode 100644 arch/arm64/kvm/sys_regs_test.c
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c
> >
> > --
> > 2.34.0.rc1.387.gb447b232ab-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
