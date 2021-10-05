Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106E1C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 19:05:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C2CF61371
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 19:05:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7C2CF61371
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9DF14B2F3;
	Tue,  5 Oct 2021 15:05:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KxNCnQ9olac3; Tue,  5 Oct 2021 15:05:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2B564B297;
	Tue,  5 Oct 2021 15:05:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B38F94B279
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 15:05:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2K2JJFIyiBE8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 15:05:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F0294B1D1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 15:05:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633460741;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Dl3aTJvWqGu6seveycGfN6caamqhyrUPV6cp3PR6dwA=;
 b=FuoPmGcKNuv6sdWeuO/hMMI6VQEYGQQPjVXda6SHs2gxtWLte1f776D71JQTYnSDS0L9Ts
 6vs1XRh2nuVlHTrxHaSapZp82m5HqAgWlxI3ZRwJ4sO6CGwe70eJInRr+fxmrNMC/lTiPl
 3o2CIbnRNTRMw/Ob6DKgfi+/h7NPNtQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-dX3jjKquOey5qWd9QhuN8A-1; Tue, 05 Oct 2021 15:05:39 -0400
X-MC-Unique: dX3jjKquOey5qWd9QhuN8A-1
Received: by mail-ed1-f70.google.com with SMTP id
 g28-20020a50d0dc000000b003dae69dfe3aso188474edf.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 12:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Dl3aTJvWqGu6seveycGfN6caamqhyrUPV6cp3PR6dwA=;
 b=F3XuEsfCAaKhk3iij9oJvW2tdK9NLj0zzCmA5HPd2vPjL47MAO9nDZjhAjJ41614PP
 rybFukYFjgiN8ci6jMg7rIUbPp0UN5QvhDvdzhMKSpAE5hqty+QQ2N05DU5fwN5wXXi7
 AEjdo13/TWIvOOM+7Zi34MxnsSH95IYSpm+q3uoVsCrtu7ruQ2sd+YRQoYdE8cQnca7+
 6cN4jpV/yZEAmAn539pC9VENnUTDVczQstFQp52ktBbD0V/PiO8ZSz6xaeQttjMyRhTs
 owm+EOrOZAlHr4B8zciXX2VlUXgcPr74Mo3joeH1Ds8aaqyu4K0BRiITNCFOI1vrss0G
 5a+g==
X-Gm-Message-State: AOAM531El9xydx7urx6DFXtPQwoY7ivnes2v838GXJtm8dGNWDrYUW7O
 jODqXPSXhb/fyor8l2eYeNfnUHDmVp9MwUEHR+0mcYam0+NpbRnqRUllRr5jC2hTYuVOBXmNfzu
 6z+jrwH6ODi0QwUHTGIPbocO8
X-Received: by 2002:a17:907:3e03:: with SMTP id
 hp3mr26025560ejc.183.1633460738408; 
 Tue, 05 Oct 2021 12:05:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyF8eNT+AVYZrVXza6mM5jC46JOKIEFUXE9ObrEwpUyLiPwySHkyfYF0utBleIoX6+4pNLMYw==
X-Received: by 2002:a17:907:3e03:: with SMTP id
 hp3mr26025507ejc.183.1633460738047; 
 Tue, 05 Oct 2021 12:05:38 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id z8sm8114401ejd.94.2021.10.05.12.05.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 12:05:37 -0700 (PDT)
Date: Tue, 5 Oct 2021 21:05:35 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 10/11] selftests: KVM: Refactor psci_test to make it
 amenable to new tests
Message-ID: <20211005190535.mxk6do6sbpf4j2c7@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-11-oupton@google.com>
 <20211005134539.s7kzhqlg2pykfcam@gator.home>
 <CAOQ_QsjQ28b8OXLR1o8QD=M8dsBKtPLyB-QRyd=D1UVMGy6o0w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsjQ28b8OXLR1o8QD=M8dsBKtPLyB-QRyd=D1UVMGy6o0w@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Tue, Oct 05, 2021 at 07:54:01AM -0700, Oliver Upton wrote:
> Hi Drew,
> 
> On Tue, Oct 5, 2021 at 6:45 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Thu, Sep 23, 2021 at 07:16:09PM +0000, Oliver Upton wrote:
> > > Split up the current test into several helpers that will be useful to
> > > subsequent test cases added to the PSCI test suite.
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  .../testing/selftests/kvm/aarch64/psci_test.c | 68 ++++++++++++-------
> > >  1 file changed, 45 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > > index 8d043e12b137..90312be335da 100644
> > > --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> > > +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > > @@ -45,7 +45,7 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
> > >       return res.a0;
> > >  }
> > >
> > > -static void guest_main(uint64_t target_cpu)
> > > +static void guest_test_cpu_on(uint64_t target_cpu)
> > >  {
> > >       GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
> > >       uint64_t target_state;
> > > @@ -69,12 +69,10 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
> > >       vcpu_set_mp_state(vm, vcpuid, &mp_state);
> > >  }

Context from last patch.

> > >
> > > -int main(void)
> > > +static struct kvm_vm *setup_vm(void *guest_code)
> > >  {
> > > -     uint64_t target_mpidr, obs_pc, obs_x0;
> > >       struct kvm_vcpu_init init;
> > >       struct kvm_vm *vm;
> > > -     struct ucall uc;
> > >
> > >       vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> > >       kvm_vm_elf_load(vm, program_invocation_name);
> > > @@ -83,31 +81,28 @@ int main(void)
> > >       vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> > >       init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
> > >
> > > -     aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_main);
> > > -     aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_main);
> > > +     aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_code);
> > > +     aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_code);

Context from last patch.

> > >
> > > -     /*
> > > -      * make sure the target is already off when executing the test.
> > > -      */
> > > -     vcpu_power_off(vm, VCPU_ID_TARGET);
> > > +     return vm;
> > > +}
> > >
> > > -     get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> > > -     vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> > > -     vcpu_run(vm, VCPU_ID_SOURCE);
> > > +static void enter_guest(struct kvm_vm *vm, uint32_t vcpuid)
> > > +{
> > > +     struct ucall uc;
> > >
> > > -     switch (get_ucall(vm, VCPU_ID_SOURCE, &uc)) {
> > > -     case UCALL_DONE:
> > > -             break;
> > > -     case UCALL_ABORT:
> > > +     vcpu_run(vm, vcpuid);
> > > +     if (get_ucall(vm, vcpuid, &uc) == UCALL_ABORT)
> > >               TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
> > >                         uc.args[1]);
> > > -             break;
> > > -     default:
> > > -             TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> > > -     }
> > > +}
> > >
> > > -     get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.pc), &obs_pc);
> > > -     get_reg(vm, VCPU_ID_TARGET, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> > > +static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
> > > +{
> > > +     uint64_t obs_pc, obs_x0;
> > > +
> > > +     get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
> > > +     get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
> > >
> > >       TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
> > >                   "unexpected target cpu pc: %lx (expected: %lx)",
> > > @@ -115,7 +110,34 @@ int main(void)
> > >       TEST_ASSERT(obs_x0 == CPU_ON_CONTEXT_ID,
> > >                   "unexpected target context id: %lx (expected: %lx)",
> > >                   obs_x0, CPU_ON_CONTEXT_ID);
> > > +}
> > >
> > > +static void host_test_cpu_on(void)
> > > +{
> > > +     uint64_t target_mpidr;
> > > +     struct kvm_vm *vm;
> > > +     struct ucall uc;
> > > +
> > > +     vm = setup_vm(guest_test_cpu_on);
> > > +
> > > +     /*
> > > +      * make sure the target is already off when executing the test.
> > > +      */
> > > +     vcpu_power_off(vm, VCPU_ID_TARGET);
> > > +
> > > +     get_reg(vm, VCPU_ID_TARGET, ARM64_SYS_REG(MPIDR_EL1), &target_mpidr);
> > > +     vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
> > > +     enter_guest(vm, VCPU_ID_SOURCE);
> > > +
> > > +     if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
> > > +             TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
> > > +
> > > +     assert_vcpu_reset(vm, VCPU_ID_TARGET);
> > >       kvm_vm_free(vm);
> > > +}
> > > +
> > > +int main(void)
> > > +{
> > > +     host_test_cpu_on();
> > >       return 0;
> > >  }
> > > --
> > > 2.33.0.685.g46640cef36-goog
> > >
> >
> > Hard to read diff, but I think the refactoring comes out right.
> 
> Yeah, this one's nasty, sorry about that. Thanks for parsing it out, heh.
> 
> > Please do this refactoring before adding the new test in the next revision, though.
> >
> 
> This is 10/11 in the series, and the test is 11/11. I'm not seeing any
> context belonging to the last patch, but perhaps I'm missing something
> obvious.

It's not much, but nicer to have none.

Thanks,
drew

> 
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> Thanks!
> 
> --
> Best,
> Oliver
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
