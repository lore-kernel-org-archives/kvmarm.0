Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D64C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 14:13:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAA5049EC2;
	Tue,  1 Feb 2022 09:13:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AcsRYsEDP0rv; Tue,  1 Feb 2022 09:13:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 399E749EFB;
	Tue,  1 Feb 2022 09:13:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFFA049EC3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:13:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id saOYjOTwMna7 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 09:13:36 -0500 (EST)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com
 [209.85.167.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D46249EC2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:13:36 -0500 (EST)
Received: by mail-oi1-f175.google.com with SMTP id x193so33623808oix.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Feb 2022 06:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=GwqkeG+g4LwdC0sxgm8GhOw8w2Ac27ntPZtzSV9QXXQ=;
 b=TbszfdTD6hbW8GY3BhTg8qfFInWP7/coaawLYztDfTCwYZIxI4OTyYo9T+sCEEM2OS
 VWZ25OOWC3fULib+VnAyUczI4gCoRMnq6Oiv3mPKhqPj35fnd+5Ka4X3eUSnSXI2FbV0
 EbXlhj2x5ywVf14BqVac/vkmF2Vc/JDUiKZebU+jvIWY1HXWFr3yAYGQj38GCsqHX90E
 a+aPfpxMHXILp4LaM22vTsphA9ZsFKX94ejuBUnKr5xhAWaHmaJCr/NEKr1vZdMjNNYy
 bE/fPpGRTEh+eJRU0Ejt3r3/0NJjP7EmmMaUwk+9CNmFHtmKr/g6n558er8oMO79SfmF
 MH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GwqkeG+g4LwdC0sxgm8GhOw8w2Ac27ntPZtzSV9QXXQ=;
 b=rL0IXK8jGWLLV5Xb5Xin1L95J2rwCMcOalRI2DVWiazI1MZ6rpQwEhI7d75cT7R8Ey
 LTPeGvBon+OmcjvHcZRr5xP0pAECo/KT3JmMkOwDf71LdBYsiP39UCrvbhxhjUgj3Oo0
 SOOcuTjH4iLU/HXCPVF+0hCZbFb9nfJaU4b5eDmwDJpLtV/EJkcCmMKxjFCj4lVeqZVV
 rgVdWkka5UHwQUwRIMmPcW5Aamz/CFFj4ITGAmScAdqAKm+axMbkr2LrQG++v0NvNH80
 Ifec8okQqnC+4RWakG1Nr5eGHTU25DTgiyxQ+Hgm8nRlYG1/0eiAfSgRAsKrGpKAgLUn
 oEhQ==
X-Gm-Message-State: AOAM530cqdzH6oM0QIcph6e5kJ486qnIpu2Yjqpu+QERn68RKS8MWL3F
 0VVU/fjnTIMIEtS5m23YLLPMZbschQl0eQ1pgemTTA==
X-Google-Smtp-Source: ABdhPJxGjxzAErQUzyH4GFR5+L8XQBKsLvQtokC7pjfdp+yRUn37zezAq9QISJKFhKEQDdQxloO09st7izsG0AENlYw=
X-Received: by 2002:a05:6808:ec2:: with SMTP id
 q2mr1315303oiv.124.1643724815339; 
 Tue, 01 Feb 2022 06:13:35 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <CA+EHjTz1=Nwd97GzagkAqZ08m-yGUHeujmtX45mLDD1beF8Ykg@mail.gmail.com>
 <CAAeT=FzC4U380ZhhxFgZ0xa5xae2ZUf5uFOOfjT2RA6K2btX_w@mail.gmail.com>
In-Reply-To: <CAAeT=FzC4U380ZhhxFgZ0xa5xae2ZUf5uFOOfjT2RA6K2btX_w@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 1 Feb 2022 14:12:59 +0000
Message-ID: <CA+EHjTxwwswnpG25pY8KXSiSgW0Tw7LcYYBFgZnyRjP6=dxAEw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/26] KVM: arm64: Make CPU ID registers writable
 by userspace
To: Reiji Watanabe <reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Reiji,

On Tue, Jan 25, 2022 at 6:31 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Fuad,
>
> On Mon, Jan 24, 2022 at 8:19 AM Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Thu, Jan 6, 2022 at 4:27 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > > The patch series is for both VHE and non-VHE, except for protected VMs,
> > > which have a different way of configuring ID registers based on its
> > > different requirements [1].
> >
> > I am reviewing this patch series and I really like your approach. I
> > think that once it's through we might be able to generalize it for
> > protected VMs as well (I did some of the work for the ID registers for
> > those).
>
> Thank you for the review and comments for the series.
> I will be looking at your comments.
>
> > > The series is based on v5.16-rc8 with the patch [3] applied.
> >
> > I tried to apply this series on v5.16-rc8 after applying
> > 20220104194918.373612-2-rananta@google.com, and it didn't apply
> > cleanly. If you could point me to a working branch that I could
> > checkout I would like to test it and experiment with it a bit more.
>
> I'm sorry for the inconvenience.  I'm not sure why though...
> I tried that again (applied the series on v5.16-rc8 after applying
> 20220104194918.373612-2-rananta@google.com), and it worked fine.
>
> Anyway, you can find the branch at:
>  https://github.com/reijiw-kvm/kvmarm-idreg/tree/id-regs-v4-5.16-rc8

This works, thanks. I guess the problem I had earlier was that I got
the whole series in 20220104194918.373612-2-rananta@google.com and not
just the first patch.

Cheers,
/fuad


> Thanks,
> Reiji
>
>
> >
> >
> >
> >
> > > v4:
> > >   - Make ID registers storage per VM instead of per vCPU. [Marc]
> > >   - Implement arm64_check_features() in arch/arm64/kernel/cpufeature.c
> > >     by using existing codes in the file. [Marc]
> > >   - Use a configuration function to enable traps for disabled
> > >     features. [Marc]
> > >   - Document ID registers become immutable after the first KVM_RUN [Eric]
> > >   - Update ID_AA64PFR0.GIC at the point where a GICv3 is created. [Marc]
> > >   - Get TGranX's bit position by substracting 12 from TGranX_2's bit
> > >     position. [Eric]
> > >   - Don't validate AArch32 ID registers when the system doesn't support
> > >     32bit EL0. [Eric]
> > >   - Add/fixes comments for patches. [Eric]
> > >   - Made bug fixes/improvements of the selftest. [Eric]
> > >   - Added .kunitconfig for arm64 KUnit tests
> > >
> > > v3: https://lore.kernel.org/all/20211117064359.2362060-1-reijiw@google.com/
> > >   - Remove ID register consistency checking across vCPUs. [Oliver]
> > >   - Change KVM_CAP_ARM_ID_REG_WRITABLE to
> > >     KVM_CAP_ARM_ID_REG_CONFIGURABLE. [Oliver]
> > >   - Add KUnit testing for ID register validation and trap initialization.
> > >   - Change read_id_reg() to take care of ID_AA64PFR0_EL1.GIC.
> > >   - Add a helper of read_id_reg() (__read_id_reg()) and use the helper
> > >     instead of directly using __vcpu_sys_reg().
> > >   - Change not to run kvm_id_regs_consistency_check() and
> > >     kvm_vcpu_init_traps() for protected VMs.
> > >   - Update selftest to remove test cases for ID register consistency.
> > >     checking across vCPUs and to add test cases for ID_AA64PFR0_EL1.GIC.
> > >
> > > v2: https://lore.kernel.org/all/20211103062520.1445832-1-reijiw@google.com/
> > >   - Remove unnecessary line breaks. [Andrew]
> > >   - Use @params for comments. [Andrew]
> > >   - Move arm64_check_features to arch/arm64/kvm/sys_regs.c and
> > >     change that KVM specific feature check function.  [Andrew]
> > >   - Remove unnecessary raz handling from __set_id_reg. [Andrew]
> > >   - Remove sys_val field from the initial id_reg_info and add it
> > >     in the later patch. [Andrew]
> > >   - Call id_reg->init() from id_reg_info_init(). [Andrew]
> > >   - Fix cpuid_feature_cap_perfmon_field() to convert 0xf to 0x0
> > >     (and use it in the following patches).
> > >   - Change kvm_vcpu_first_run_init to set has_run_once to false
> > >     when kvm_id_regs_consistency_check() fails.
> > >   - Add a patch to introduce id_reg_info for ID_AA64MMFR0_EL1,
> > >     which requires special validity checking for TGran*_2 fields.
> > >   - Add patches to introduce id_reg_info for ID_DFR1_EL1 and
> > >     ID_MMFR0_EL1, which are required due to arm64_check_features
> > >     implementation change.
> > >   - Add a new argument, which is a pointer to id_reg_info, for
> > >     id_reg_info's validate().
> > >
> > > v1: https://lore.kernel.org/all/20211012043535.500493-1-reijiw@google.com/
> > >
> > > [1] https://lore.kernel.org/kvmarm/20211010145636.1950948-1-tabba@google.com/
> > > [2] https://lore.kernel.org/kvm/20201102033422.657391-1-liangpeng10@huawei.com/
> > > [3] https://lore.kernel.org/all/20220104194918.373612-2-rananta@google.com/
> > >
> > > Reiji Watanabe (26):
> > >   KVM: arm64: Introduce a validation function for an ID register
> > >   KVM: arm64: Save ID registers' sanitized value per guest
> > >   KVM: arm64: Introduce struct id_reg_info
> > >   KVM: arm64: Make ID_AA64PFR0_EL1 writable
> > >   KVM: arm64: Make ID_AA64PFR1_EL1 writable
> > >   KVM: arm64: Make ID_AA64ISAR0_EL1 writable
> > >   KVM: arm64: Make ID_AA64ISAR1_EL1 writable
> > >   KVM: arm64: Make ID_AA64MMFR0_EL1 writable
> > >   KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support for the guest
> > >   KVM: arm64: Make ID_AA64DFR0_EL1 writable
> > >   KVM: arm64: Make ID_DFR0_EL1 writable
> > >   KVM: arm64: Make MVFR1_EL1 writable
> > >   KVM: arm64: Make ID registers without id_reg_info writable
> > >   KVM: arm64: Add consistency checking for frac fields of ID registers
> > >   KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE capability
> > >   KVM: arm64: Add kunit test for ID register validation
> > >   KVM: arm64: Use vcpu->arch cptr_el2 to track value of cptr_el2 for VHE
> > >   KVM: arm64: Use vcpu->arch.mdcr_el2 to track value of mdcr_el2
> > >   KVM: arm64: Introduce framework to trap disabled features
> > >   KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
> > >   KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
> > >   KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
> > >   KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
> > >   KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
> > >   KVM: arm64: Add kunit test for trap initialization
> > >   KVM: arm64: selftests: Introduce id_reg_test
> > >
> > >  Documentation/virt/kvm/api.rst                |   12 +
> > >  arch/arm64/include/asm/cpufeature.h           |    3 +-
> > >  arch/arm64/include/asm/kvm_arm.h              |   32 +
> > >  arch/arm64/include/asm/kvm_host.h             |   19 +
> > >  arch/arm64/include/asm/sysreg.h               |    3 +
> > >  arch/arm64/kernel/cpufeature.c                |  228 +++
> > >  arch/arm64/kvm/.kunitconfig                   |    4 +
> > >  arch/arm64/kvm/Kconfig                        |   11 +
> > >  arch/arm64/kvm/arm.c                          |   24 +-
> > >  arch/arm64/kvm/debug.c                        |   13 +-
> > >  arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
> > >  arch/arm64/kvm/sys_regs.c                     | 1329 +++++++++++++++--
> > >  arch/arm64/kvm/sys_regs_test.c                | 1247 ++++++++++++++++
> > >  arch/arm64/kvm/vgic/vgic-init.c               |    5 +
> > >  include/uapi/linux/kvm.h                      |    1 +
> > >  tools/arch/arm64/include/asm/sysreg.h         |    1 +
> > >  tools/testing/selftests/kvm/.gitignore        |    1 +
> > >  tools/testing/selftests/kvm/Makefile          |    1 +
> > >  .../selftests/kvm/aarch64/id_reg_test.c       | 1239 +++++++++++++++
> > >  19 files changed, 4041 insertions(+), 146 deletions(-)
> > >  create mode 100644 arch/arm64/kvm/.kunitconfig
> > >  create mode 100644 arch/arm64/kvm/sys_regs_test.c
> > >  create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c
> > >
> > >
> > > base-commit: d399b107ee49bf5ea0391bd7614d512809e927b0
> > > --
> > > 2.34.1.448.ga2b2bfdf31-goog
> > >
> > > _______________________________________________
> > > kvmarm mailing list
> > > kvmarm@lists.cs.columbia.edu
> > > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
