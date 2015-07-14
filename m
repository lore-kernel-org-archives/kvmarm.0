From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH] target-arm: kvm: Differentiate registers based on
 write-back levels
Date: Tue, 14 Jul 2015 15:54:10 +0100
Message-ID: <CAFEAcA8oz=qidQKMEQ7mFXp51iMfmzoP3MOf7fPN7jWhaE3LuQ@mail.gmail.com>
References: <1436526053-4516-1-git-send-email-christoffer.dall@linaro.org>
 <CAFEAcA8a+RDxPwKsjKSzSZq6khqZjKEZXCokp3rQEuaNBj0B1Q@mail.gmail.com>
 <20150711121850.GB25650@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87C475843A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jul 2015 10:42:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZOx35vLGgWQI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jul 2015 10:42:41 -0400 (EDT)
Received: from mail-vn0-f51.google.com (mail-vn0-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FC7A58430
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jul 2015 10:42:41 -0400 (EDT)
Received: by vnav203 with SMTP id v203so1302794vna.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jul 2015 07:54:30 -0700 (PDT)
In-Reply-To: <20150711121850.GB25650@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@web.de>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 11 July 2015 at 13:18, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Fri, Jul 10, 2015 at 12:22:31PM +0100, Peter Maydell wrote:
>> On 10 July 2015 at 12:00, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> > +/* All system registers not listed in the following table are assumed to be
>> > + * of the level KVM_PUT_RUNTIME_STATE, a register should be written less
>> > + * often, you must add it to this table with a state of either
>> > + * KVM_PUT_RESET_STATE or KVM_PUT_FULL_STATE.
>> > + */
>> > +cpreg_state_level non_runtime_cpregs[] = {
>> > +    { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
>>
>> This should be KVM_PUT_RESET_STATE, right?
>>
> should it?  If you reset a real machine, you will not necessarily see a
> counter value of zero will you?

I was confused, I thought PUT_FULL_STATE meant what PUT_RUNTIME_STATE
does.

> I guess this depends on whether QEMU reset means power the system
> completely off and then on again, or some softer reset?

QEMU reset means power cycle. But I think the semantics of
KVM_PUT_RESET_STATE are not "does real h/w change this on
reset" but "does QEMU's runtime code change this on reset"
(ie does the common code then need to do a sync of the register
in order to make the reset code's change show up to KVM).

>> The other option here would be to keep the level information
>> in the cpreg structs (which is where we put everything else
>> we know about cpregs); we'd probably need to then initialise
>> some other data structure if we wanted to avoid the hash
>> table lookup for every register in write_list_to_kvmstate.
>>
>> I guess if we expect this list to remain a fairly small
>> set of exceptional cases then this is OK (and vaguely
>> comparable to the existing kvm_arm_reg_syncs_via-cpreg_list
>> handling).
>
> I thought about this too, and sent this as an RFC for exactly this
> reason.  I did it this way initially for two reasons: (1) I don't
> understand the hash-table register initialization flow for aarch64 and
> (2) I could really only identify this single register for now that needs
> to be marked as a non-runtime register, and then this is less invasive.

Yes, it's the "only one register" part that makes it seem
overkill to do it the other way.

>> Don't we need separate 32-bit and 64-bit versions of
>> this list?
>>
> Do we?  I thought this file would compile separately for the 32-bit and
> 64-bit versions and the register index define is the same name for both
> architectures, did I get this wrong?

I think you're right, but it feels a bit fragile to depend on
the fact that the name used by the kernel headers is the same
in both cases, especially since as soon as we wanted to add a
register that only mattered for one of 32/64 we'd need to refactor
to split things into two lists.

> Of course, for other registers with unique-to-32-bit-or-64-bit reg index
> defines, yes, we would need a separate table.  Should they then be
> defined in the kvm32.c and kvm64.c and passed in as a pointer to
> write_kvmstate_to_list() ?

I think I would make cpreg_level() be a function defined in
kvm32.c/kvm64.c (as kvm_arm_reg_syncs_via_cpreg_list() is);
you'd need to give it a kvm_arm_ prefix, maybe
kvm_arm_reg_sync_level().

thanks
-- PMM
