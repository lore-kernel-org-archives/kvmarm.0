Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B95AC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:30:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF90661104
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:30:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF90661104
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 537CB4B121;
	Thu,  9 Sep 2021 13:30:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zi3it+UxEEWG; Thu,  9 Sep 2021 13:30:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 143BD4B17B;
	Thu,  9 Sep 2021 13:30:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C9194B173
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:30:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id klqIyATdz83e for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 13:30:02 -0400 (EDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com
 [209.85.219.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 416274B121
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:30:02 -0400 (EDT)
Received: by mail-yb1-f171.google.com with SMTP id z18so5412910ybg.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 10:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=GiZV+VOSrpb09z1mkI5MILx7tzRyWtgaYU7UjyBdlhA=;
 b=X9R1xWLzsLLJ+Xc5DkAphEfUoQL4Sgx4P263inr8zzzfPJN4TUf0YTjjtrZL+zpyFc
 /iyr7tMLTVt3jB3TCg3p1J6M3VnDR/Z7+/Phl9foipTICy1sx4NcDbXzzBaRYaq1T9aB
 GjWXpdoDs+Oaq26LMaDXLPoeJGi1vK2IMr5nxEW6w2OJJg2aFZNo+WC9nZ30plK7y0TE
 0uzhEyJM96tYm2oGeefUBTMkLxi9bPk13DtQg5iRqFzdFUGDGPeIcP1sKIe7HNMZqL5/
 YkYnqaxNsU9u21eyCbCpdAx22BwJhJXtv0ZKS2YFCjxtn+AsneNoOipXpp3/0yIfIGLl
 UZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GiZV+VOSrpb09z1mkI5MILx7tzRyWtgaYU7UjyBdlhA=;
 b=b/+IY1lUo2wrocy+MgqBUXAL8+KV+3nBcul6veqY2D1uEjyCo+yaaVqXHJxZWNpBL2
 fazq//YiXvP0iq8jF793Oy3YMiWxi0BySsRLSAK+vxLrmxX0vZxqaKMWUeT+RBxKNSsv
 KH7BpwFZ1SxXdNrD5LbnPA6wBUtHUkNpQUZioV7CxVf6nDtv7bwflgLGytPM08ZKqin3
 EFoCrUacJ7Ai5WDkigyvXZzefYBS1VjHw6veVDXK3J7NhJAE9DNEhEs6AoU2IP6UCEzq
 rCW+UKPCr9PnpLGg7lGevL0W/keCb8SrnP0Heb20CpN2uCnbMLHrrUeMyDQX43Xiq0bU
 Kbxg==
X-Gm-Message-State: AOAM533EWHs5+UHXkTtisHE1VeqABio+JDpvd2TijsQqY3GrCZ2U43HW
 /Z7qGwa9CFp+2s385NNNAhIDKoRLflRP0PXdoS0+7Q==
X-Google-Smtp-Source: ABdhPJyAci/Rm1CAnvHjp/OQwRqMZY619xplGV4skUVQQNF4ZMy4ME3Ocuw3RkFBm1c9pOlgGtJZ5W9057eYqmhj0pc=
X-Received: by 2002:a25:1c09:: with SMTP id c9mr5562897ybc.350.1631208601497; 
 Thu, 09 Sep 2021 10:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-18-rananta@google.com>
 <20210909133814.wsua43ya2erfw6gm@gator>
In-Reply-To: <20210909133814.wsua43ya2erfw6gm@gator>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Sep 2021 10:29:50 -0700
Message-ID: <CAJHc60yX69ddFiSpkp-gFd8OvNM43AnPED=iAEdmOk8aYHDzDA@mail.gmail.com>
Subject: Re: [PATCH v4 17/18] KVM: arm64: selftests: Replace ARM64_SYS_REG
 with ARM64_SYS_KVM_REG
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 9, 2021 at 6:38 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 01:38:17AM +0000, Raghavendra Rao Ananta wrote:
> > With the introduction of ARM64_SYS_KVM_REG, that takes the
> > system register encodings from sysreg.h directly, replace
> > all the users of ARM64_SYS_REG, relyiing on the encodings
> > created in processor.h, with ARM64_SYS_KVM_REG.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c     |  2 +-
> >  .../selftests/kvm/aarch64/psci_cpu_on_test.c     |  3 ++-
> >  .../selftests/kvm/include/aarch64/processor.h    | 10 ----------
> >  .../selftests/kvm/lib/aarch64/processor.c        | 16 ++++++++--------
> >  4 files changed, 11 insertions(+), 20 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index 11fd23e21cb4..b28b311f4dd7 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -190,7 +190,7 @@ static int debug_version(struct kvm_vm *vm)
> >  {
> >       uint64_t id_aa64dfr0;
> >
> > -     get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
> > +     get_reg(vm, VCPU_ID, ARM64_SYS_KVM_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
> >       return id_aa64dfr0 & 0xf;
> >  }
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> > index 018c269990e1..4c8aa7b8a65d 100644
> > --- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> > @@ -91,7 +91,8 @@ int main(void)
> >       init.features[0] |= (1 << KVM_ARM_VCPU_POWER_OFF);
> >       aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
> >
> > -     get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> > +     get_reg(vm, VCPU_ID_TARGET,
> > +             ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &target_mpidr);
>
> nit: I'd just leave this on one line. We don't mind long lines in this
> part of town.
>
Good to know. I'll pull it into one line.
> >       vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> >       vcpu_run(vm, VCPU_ID_SOURCE);
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index 150f63101f4c..ee81dd3db516 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -16,16 +16,6 @@
> >  #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> >                          KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
> >
> > -#define CPACR_EL1               3, 0,  1, 0, 2
> > -#define TCR_EL1                 3, 0,  2, 0, 2
> > -#define MAIR_EL1                3, 0, 10, 2, 0
> > -#define MPIDR_EL1               3, 0,  0, 0, 5
> > -#define TTBR0_EL1               3, 0,  2, 0, 0
> > -#define SCTLR_EL1               3, 0,  1, 0, 0
> > -#define VBAR_EL1                3, 0, 12, 0, 0
> > -
> > -#define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
> > -
> >  /*
> >   * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
> >   * SYS_* register definitions in sysreg.h to use in KVM
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 9844b62227b1..d7b89aa092f5 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -240,10 +240,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
> >        * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
> >        * registers, which the variable argument list macros do.
> >        */
> > -     set_reg(vm, vcpuid, ARM64_SYS_REG(CPACR_EL1), 3 << 20);
> > +     set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_CPACR_EL1), 3 << 20);
> >
> > -     get_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), &sctlr_el1);
> > -     get_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), &tcr_el1);
> > +     get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), &sctlr_el1);
> > +     get_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), &tcr_el1);
> >
> >       switch (vm->mode) {
> >       case VM_MODE_P52V48_4K:
> > @@ -281,10 +281,10 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
> >       tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
> >       tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
> >
> > -     set_reg(vm, vcpuid, ARM64_SYS_REG(SCTLR_EL1), sctlr_el1);
> > -     set_reg(vm, vcpuid, ARM64_SYS_REG(TCR_EL1), tcr_el1);
> > -     set_reg(vm, vcpuid, ARM64_SYS_REG(MAIR_EL1), DEFAULT_MAIR_EL1);
> > -     set_reg(vm, vcpuid, ARM64_SYS_REG(TTBR0_EL1), vm->pgd);
> > +     set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_SCTLR_EL1), sctlr_el1);
> > +     set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TCR_EL1), tcr_el1);
> > +     set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
> > +     set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_TTBR0_EL1), vm->pgd);
> >  }
> >
> >  void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
> > @@ -370,7 +370,7 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
> >  {
> >       extern char vectors;
> >
> > -     set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
> > +     set_reg(vm, vcpuid, ARM64_SYS_KVM_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
> >  }
> >
> >  void route_exception(struct ex_regs *regs, int vector)
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
>
> I also agree with Oliver that this patch may be squashed into the one that
> introduces ARM64_SYS_KVM_REG.
>
Sure, will do.

Regards,
Raghavendra
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
