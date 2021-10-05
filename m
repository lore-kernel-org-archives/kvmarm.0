Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2693DC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 15:08:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94880613D5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 15:08:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 94880613D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D9A24B313;
	Tue,  5 Oct 2021 11:08:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XXi2vQug9grG; Tue,  5 Oct 2021 11:08:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBBBD4B306;
	Tue,  5 Oct 2021 11:08:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF6E44B2EF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 11:08:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eQEQSQs2+lPq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 11:08:00 -0400 (EDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E54CD4B2BB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 11:07:59 -0400 (EDT)
Received: by mail-lf1-f50.google.com with SMTP id y26so88157127lfa.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 08:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gfNZfNwUJuypCW0p97c1ewxn6bpSqjVCmzxpI4oPhbM=;
 b=SIhjr28uhixoI7j8SX2mmlbQUd93wYChNWBSRLQooTUZjYmfacxuOuW/I9pXEGkhDw
 lmqyxyo+O59z538e3PhKxrvdKCMjc6w7jjNtrYs3fs0ZOIwMUNDLPYH7CYhm+a8mFuqv
 gib45O+EiQlRS3NQQJhzRbKQfNrSiw02k2nIfWKrWDqu2pQXZ+Ia1+XcvGamtSQ8nC4A
 MsryeeUw3sT3UTxzMLPC9AESdl1TR1oci/HFRDBpHTAwr2S9SGPNRStd3ufZshnXx7s7
 tn73V8mV2X8BYJxIvlwolSAAT2FkLJr6bwXXTqptCyKdZvTXiIASEFprqau/D7Po8IDC
 AvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gfNZfNwUJuypCW0p97c1ewxn6bpSqjVCmzxpI4oPhbM=;
 b=ldJoaysCjbLy+MbY6zjq5q/M/RhQZnKkKOETH0aQpY3b9kTc09La1HO9PhyWeSgNoI
 raFmfxIfYuFdk03iJB461+ZSiUgpAVpjSfMJ9GN+VFvXC/59QBFQt/cSjaR3cgvDGKVb
 oijU2YA3SgndoBZVRoMnkwL4Vac5GXCU5TNQL5a3uvXwIOqZb1dDgss/6Bra85gwn7O9
 q9HL3WNQJ8ez3rcQheYbiARALnXAbrpzISWPGoyk9u/Zs5lGg4aK0kgsPzh8rQwudJeo
 n3SSEflicJ9vEZvt/JsSaO0rgyEGiGd57wlARZ6fhN83VdX24ow4HBbOH9roSy583s1z
 h1Sw==
X-Gm-Message-State: AOAM531B3ImWqOgpBLa3kZaAeYTRZb2erEJ/mTTeMvPApaZTZwtCNg7B
 bMDiM/4dQmLOjbDASM92BVzA3DyDPXQNx7iMjLZ+uQ==
X-Google-Smtp-Source: ABdhPJzLw9VojD9PEhGs/n1Z97cLSFAovX7mtdM5uGgz+hhV2EC9ZBbYqmMTTSdw3aKoUFNZ0qeRBTsklGTwa+oXQZA=
X-Received: by 2002:a2e:b88c:: with SMTP id r12mr23915173ljp.479.1633446458809; 
 Tue, 05 Oct 2021 08:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-12-oupton@google.com>
 <20211005134930.dxej2lgcjklzouw7@gator.home>
In-Reply-To: <20211005134930.dxej2lgcjklzouw7@gator.home>
From: Oliver Upton <oupton@google.com>
Date: Tue, 5 Oct 2021 08:07:26 -0700
Message-ID: <CAOQ_Qsibr1dJUtY+h_GS0Gp=DF1G4JU2ECNO8=QFx7Xa6Q+nLQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
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

On Tue, Oct 5, 2021 at 6:49 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 23, 2021 at 07:16:10PM +0000, Oliver Upton wrote:
> > Assert that the vCPU exits to userspace with KVM_SYSTEM_EVENT_SUSPEND if
> > it correctly executes the SYSTEM_SUSPEND PSCI call. Additionally, assert
> > that the guest PSCI call fails if preconditions are not met (more than 1
> > running vCPU).
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/psci_test.c | 75 +++++++++++++++++++
> >  1 file changed, 75 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > index 90312be335da..5b881ca4d102 100644
> > --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> > @@ -45,6 +45,16 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
> >       return res.a0;
> >  }
> >
> > +static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
> > +{
> > +     struct arm_smccc_res res;
> > +
> > +     smccc_hvc(PSCI_1_0_FN64_SYSTEM_SUSPEND, entry_addr, context_id,
> > +               0, 0, 0, 0, 0, &res);
> > +
> > +     return res.a0;
> > +}
> > +
> >  static void guest_test_cpu_on(uint64_t target_cpu)
> >  {
> >       GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
> > @@ -69,6 +79,13 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
> >       vcpu_set_mp_state(vm, vcpuid, &mp_state);
> >  }
> >
> > +static void guest_test_system_suspend(void)
> > +{
> > +     uint64_t r = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
> > +
> > +     GUEST_SYNC(r);
> > +}
> > +
> >  static struct kvm_vm *setup_vm(void *guest_code)
> >  {
> >       struct kvm_vcpu_init init;
> > @@ -136,8 +153,66 @@ static void host_test_cpu_on(void)
> >       kvm_vm_free(vm);
> >  }
> >
> > +static void enable_system_suspend(struct kvm_vm *vm)
> > +{
> > +     struct kvm_enable_cap cap = {
> > +             .cap = KVM_CAP_ARM_SYSTEM_SUSPEND,
> > +     };
> > +
> > +     vm_enable_cap(vm, &cap);
> > +}
> > +
> > +static void host_test_system_suspend(void)
> > +{
> > +     struct kvm_run *run;
> > +     struct kvm_vm *vm;
> > +
> > +     vm = setup_vm(guest_test_system_suspend);
> > +     enable_system_suspend(vm);
> > +
> > +     vcpu_power_off(vm, VCPU_ID_TARGET);
> > +     run = vcpu_state(vm, VCPU_ID_SOURCE);
> > +
> > +     enter_guest(vm, VCPU_ID_SOURCE);
> > +
> > +     TEST_ASSERT(run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
> > +                 "Unhandled exit reason: %u (%s)",
> > +                 run->exit_reason, exit_reason_str(run->exit_reason));
> > +     TEST_ASSERT(run->system_event.type == KVM_SYSTEM_EVENT_SUSPEND,
> > +                 "Unhandled system event: %u (expected: %u)",
> > +                 run->system_event.type, KVM_SYSTEM_EVENT_SUSPEND);
> > +
> > +     assert_vcpu_reset(vm, VCPU_ID_SOURCE);
> > +     kvm_vm_free(vm);
> > +}
> > +
> > +static void host_test_system_suspend_fails(void)
> > +{
> > +     struct kvm_vm *vm;
> > +     struct ucall uc;
> > +
> > +     vm = setup_vm(guest_test_system_suspend);
> > +     enable_system_suspend(vm);
> > +
> > +     enter_guest(vm, VCPU_ID_SOURCE);
> > +     TEST_ASSERT(get_ucall(vm, VCPU_ID_SOURCE, &uc) == UCALL_SYNC,
> > +                 "Unhandled ucall: %lu", uc.cmd);
> > +     TEST_ASSERT(uc.args[1] == PSCI_RET_DENIED,
> > +                 "Unrecognized PSCI return code: %lu (expected: %u)",
> > +                 uc.args[1], PSCI_RET_DENIED);
> > +
> > +     kvm_vm_free(vm);
> > +}
> > +
> >  int main(void)
> >  {
> > +     if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
> > +             print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
> > +             exit(KSFT_SKIP);
> > +     }
>
> How about only guarding the new tests with this, so we can still do the
> cpu_on test when this feature isn't present?
>

Great suggestion, thanks!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
