From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] target-arm: kvm: Differentiate registers based on
 write-back levels
Date: Sat, 11 Jul 2015 14:18:50 +0200
Message-ID: <20150711121850.GB25650@cbox>
References: <1436526053-4516-1-git-send-email-christoffer.dall@linaro.org>
 <CAFEAcA8a+RDxPwKsjKSzSZq6khqZjKEZXCokp3rQEuaNBj0B1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DEFD58641
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jul 2015 08:07:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gV-Kl-uGYaGR for <kvmarm@lists.cs.columbia.edu>;
 Sat, 11 Jul 2015 08:07:03 -0400 (EDT)
Received: from mail-lb0-f171.google.com (mail-lb0-f171.google.com
 [209.85.217.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0348958634
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jul 2015 08:07:02 -0400 (EDT)
Received: by lbbyj8 with SMTP id yj8so19776603lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Jul 2015 05:18:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA8a+RDxPwKsjKSzSZq6khqZjKEZXCokp3rQEuaNBj0B1Q@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@web.de>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 10, 2015 at 12:22:31PM +0100, Peter Maydell wrote:
> On 10 July 2015 at 12:00, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > Some registers like the CNTVCT register should only be written to the
> > kernel as part of machine initialization or on vmload operations, but
> > never during runtime, as this can potentially make time go backwards or
> > create inconsistent time observations between VCPUs.
> >
> > Introduce a list of registers that should not be written back at runtime
> > and check this list on syncing the register state to the KVM state.
> 
> Thanks for picking this one up...
> 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  target-arm/kvm.c     | 34 +++++++++++++++++++++++++++++++++-
> >  target-arm/kvm32.c   |  2 +-
> >  target-arm/kvm64.c   |  2 +-
> >  target-arm/kvm_arm.h |  3 ++-
> >  target-arm/machine.c |  2 +-
> >  5 files changed, 38 insertions(+), 5 deletions(-)
> >
> > diff --git a/target-arm/kvm.c b/target-arm/kvm.c
> > index 548bfd7..2e92699 100644
> > --- a/target-arm/kvm.c
> > +++ b/target-arm/kvm.c
> > @@ -409,7 +409,35 @@ bool write_kvmstate_to_list(ARMCPU *cpu)
> >      return ok;
> >  }
> >
> > -bool write_list_to_kvmstate(ARMCPU *cpu)
> > +typedef struct cpreg_state_level {
> > +    uint64_t kvm_idx;
> > +    int level;
> > +} cpreg_state_level;
> 
> (QEMU's coding style prefers CPRegStateLevel for struct types.)
> 

ok

> > +
> > +/* All system registers not listed in the following table are assumed to be
> > + * of the level KVM_PUT_RUNTIME_STATE, a register should be written less
> > + * often, you must add it to this table with a state of either
> > + * KVM_PUT_RESET_STATE or KVM_PUT_FULL_STATE.
> > + */
> > +cpreg_state_level non_runtime_cpregs[] = {
> > +    { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
> 
> This should be KVM_PUT_RESET_STATE, right?
> 
should it?  If you reset a real machine, you will not necessarily see a
counter value of zero will you?

I guess this depends on whether QEMU reset means power the system
completely off and then on again, or some softer reset?

> > +};
> 
> The other option here would be to keep the level information
> in the cpreg structs (which is where we put everything else
> we know about cpregs); we'd probably need to then initialise
> some other data structure if we wanted to avoid the hash
> table lookup for every register in write_list_to_kvmstate.
> 
> I guess if we expect this list to remain a fairly small
> set of exceptional cases then this is OK (and vaguely
> comparable to the existing kvm_arm_reg_syncs_via-cpreg_list
> handling).

I thought about this too, and sent this as an RFC for exactly this
reason.  I did it this way initially for two reasons: (1) I don't
understand the hash-table register initialization flow for aarch64 and
(2) I could really only identify this single register for now that needs
to be marked as a non-runtime register, and then this is less invasive.

> 
> Don't we need separate 32-bit and 64-bit versions of
> this list?
> 
Do we?  I thought this file would compile separately for the 32-bit and
64-bit versions and the register index define is the same name for both
architectures, did I get this wrong?

Of course, for other registers with unique-to-32-bit-or-64-bit reg index
defines, yes, we would need a separate table.  Should they then be
defined in the kvm32.c and kvm64.c and passed in as a pointer to
write_kvmstate_to_list() ?

Thanks,
-Christoffer
