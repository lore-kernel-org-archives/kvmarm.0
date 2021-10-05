Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3710C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 14:54:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2EC9761371
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 14:54:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2EC9761371
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1C04B2F3;
	Tue,  5 Oct 2021 10:54:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FLxMZpBR1BDY; Tue,  5 Oct 2021 10:54:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2294D4B2F9;
	Tue,  5 Oct 2021 10:54:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2149B4B2F3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 10:54:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CyLgfFHQABeJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 10:54:16 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C14E94B2D1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 10:54:15 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id y15so21616506lfk.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 07:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=oeEs3eMOlEupf6UUcoQibPqVHwuKrUKDBy8LbYPEqoA=;
 b=aAdD3HDLKufLpxvfw0oGt+CD/52iSjYVFKTbMfXrcgeIWKy/ANG/EOvtDTstbiZjUD
 vHOWVCtkQiIVyOCjDOLKNQ9WRTDkTnW7pDJ8UuAmqg1CHUT16Xsmu0KoHfWZFvM+iuzN
 t8K7TSc5VrhuLZ76BwUsl54GmSEKEY3JVH/dze9QJSUviRrlxt4XKyzW4xsXjhqlT0Rf
 goG9zd8VWIGLcYdzg9gN7j2qPqssd5HfnKCj5jgv3HBDeA/+PE928o1AOtWyRAnCwxDZ
 nK/seETkoeRizucnfoDV+m96VScxwz1vVpiW3ajBDelpeQrufEGwu0B8DV5DL4ToNRzx
 yBeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=oeEs3eMOlEupf6UUcoQibPqVHwuKrUKDBy8LbYPEqoA=;
 b=h9Iyd5lwt78Satmr1lpXKxprZFqVivT8DKqEUdOR1BkCwysIjB3BvOcZEoOy026GcD
 iZDOTwVTw+tuLnHEgWvYYh9N18qLlLklWi5LMB5tB0aTFzLG7oaDPBQsgtCHClMtaacd
 ilGm9jhHLy3gI7O05muRb7lP2QkRz72J66KIfaDMl2aDdllmDaQjlLIlUDZ32K6NFr+w
 wdg+ZECOZ2aqAISxZHJ7Yu1GOOyu14/hcVTr1S7885mgwS/re823e4iPf4K+Wbk0BJJT
 tDY/LjB6h2KLR/3Ge4jq8giusPlqRGtPzhJquVKuyw8x+dtCio98GJbvFmO9LXynH3BR
 H+Qg==
X-Gm-Message-State: AOAM533znPL5/e9o2XYKyI5xraHnyWCEole0AEQMxXAsRqSbI0OYULF1
 Zsy3lymZ2ORYSTHv2jQS6NTKkQkjbFtRH2qPa5kA1w==
X-Google-Smtp-Source: ABdhPJyMTR6su6M9JlR0TJe8fr8yMC+jDLWW2Ybj4JUSc+O7b6KU84U7G8Up+QrZwUDi/aCBdOK6JBGjZtL/iGUTRlg=
X-Received: by 2002:ac2:4217:: with SMTP id y23mr3879463lfh.361.1633445653503; 
 Tue, 05 Oct 2021 07:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-11-oupton@google.com>
 <20211005134539.s7kzhqlg2pykfcam@gator.home>
In-Reply-To: <20211005134539.s7kzhqlg2pykfcam@gator.home>
From: Oliver Upton <oupton@google.com>
Date: Tue, 5 Oct 2021 07:54:01 -0700
Message-ID: <CAOQ_QsjQ28b8OXLR1o8QD=M8dsBKtPLyB-QRyd=D1UVMGy6o0w@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

Hi Drew,

On Tue, Oct 5, 2021 at 6:45 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 23, 2021 at 07:16:09PM +0000, Oliver Upton wrote:
> > Split up the current test into several helpers that will be useful to
> > subsequent test cases added to the PSCI test suite.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/psci_test.c | 68 ++++++++++++-------
> >  1 file changed, 45 insertions(+), 23 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > index 8d043e12b137..90312be335da 100644
> > --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > @@ -45,7 +45,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
> >       return res.a0;
> >  }
> >
> > -static void guest_main(uint64_t target_cpu)
> > +static void guest_test_cpu_on(uint64_t target_cpu)
> >  {
> >       GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
> >       uint64_t target_state;
> > @@ -69,12 +69,10 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
> >       vcpu_set_mp_state(vm, vcpuid, &mp_state);
> >  }
> >
> > -int main(void)
> > +static struct kvm_vm *setup_vm(void *guest_code)
> >  {
> > -     uint64_t target_mpidr, obs_pc, obs_x0;
> >       struct kvm_vcpu_init init;
> >       struct kvm_vm *vm;
> > -     struct ucall uc;
> >
> >       vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> >       kvm_vm_elf_load(vm, program_invocation_name);
> > @@ -83,31 +81,28 @@ int main(void)
> >       vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> >       init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
> >
> > -     aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
> > -     aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
> > +     aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_code);
> > +     aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_code);
> >
> > -     /*
> > -      * make sure the target is already off when executing the test.
> > -      */
> > -     vcpu_power_off(vm, VCPU_ID_TARGET);
> > +     return vm;
> > +}
> >
> > -     get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> > -     vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> > -     vcpu_run(vm, VCPU_ID_SOURCE);
> > +static void enter_guest(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +     struct ucall uc;
> >
> > -     switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
> > -     case UCALL_DONE:
> > -             break;
> > -     case UCALL_ABORT:
> > +     vcpu_run(vm, vcpuid);
> > +     if (get_ucall(vm, vcpuid, &uc) == UCALL_ABORT)
> >               TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
> >                         uc.args[1]);
> > -             break;
> > -     default:
> > -             TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> > -     }
> > +}
> >
> > -     get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
> > -     get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> > +static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +     uint64_t obs_pc, obs_x0;
> > +
> > +     get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
> > +     get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> >
> >       TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
> >                   "unexpected target cpu pc: %lx (expected: %lx)",
> > @@ -115,7 +110,34 @@ int main(void)
> >       TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
> >                   "unexpected target context id: %lx (expected: %lx)",
> >                   obs_x0, CPU_ON_CONTEXT_ID);
> > +}
> >
> > +static void host_test_cpu_on(void)
> > +{
> > +     uint64_t target_mpidr;
> > +     struct kvm_vm *vm;
> > +     struct ucall uc;
> > +
> > +     vm = setup_vm(guest_test_cpu_on);
> > +
> > +     /*
> > +      * make sure the target is already off when executing the test.
> > +      */
> > +     vcpu_power_off(vm, VCPU_ID_TARGET);
> > +
> > +     get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> > +     vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> > +     enter_guest(vm, VCPU_ID_SOURCE);
> > +
> > +     if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
> > +             TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> > +
> > +     assert_vcpu_reset(vm, VCPU_ID_TARGET);
> >       kvm_vm_free(vm);
> > +}
> > +
> > +int main(void)
> > +{
> > +     host_test_cpu_on();
> >       return 0;
> >  }
> > --
> > 2.33.0.685.g46640cef36-goog
> >
>
> Hard to read diff, but I think the refactoring comes out right.

Yeah, this one's nasty, sorry about that. Thanks for parsing it out, heh.

> Please do this refactoring before adding the new test in the next revision, though.
>

This is 10/11 in the series, and the test is 11/11. I'm not seeing any
context belonging to the last patch, but perhaps I'm missing something
obvious.

> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
