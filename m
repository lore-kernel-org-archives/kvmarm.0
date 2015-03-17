From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 4/5] target-arm: kvm64 fix save/restore of SPSR regs
Date: Tue, 17 Mar 2015 19:08:00 +0000
Message-ID: <CAFEAcA-=mAu-T_JRk4cGjMzmgL61_aOWhWm9O-+fhOqVHd_F6w@mail.gmail.com>
References: <1426503716-13931-1-git-send-email-alex.bennee@linaro.org>
 <1426503716-13931-5-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA8hJTFeR63gJO9QX7nWuFktkehDzGmJjqhTBkTjw4=7Jw@mail.gmail.com> <20150317190458.GE26480@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150317190458.GE26480@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 17 March 2015 at 19:04, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Tue, Mar 17, 2015 at 04:18:16PM +0000, Peter Maydell wrote:
>> Note that this code is implicitly relying on the
>> ordering of register banks defined by the bank_number()
>> function, which is a bit icky.
>
> right, I thought you wrote this code with some deeper intention of doing
> it this way so I tried to stick with the general idea - but now I
> actually looked at git blame and realized that you didn't even write it.
>
> Given all this churn around this, probably it's much cleaner to get rid
> of the loop and have an explicit sync for each architecturally
> implemented register, i.e. the SPSR_EL1 and the various mode-specific
> AArch32 SPSR registers?

Yes, this seems like a good idea. I almost suggested it when
I was writing out my review comments, in fact...

>> >      for (i = 0; i < KVM_NR_SPSR; i++) {
>> >          reg.id = AARCH64_CORE_REG(spsr[i]);
>> > -        reg.addr = (uintptr_t) &env->banked_spsr[i - 1];
>> > +        reg.addr = (uintptr_t) &env->banked_spsr[i+1];
>>
>> Spaces again.
>>
>> >          ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
>> >          if (ret) {
>> >              return ret;
>> >          }
>> >      }
>> >
>> > +    el = arm_current_el(env);
>> > +    if (el > 0) {
>> > +        if (is_a64(env)) {
>> > +            g_assert(el == 1);
>> > +            /* KVM_SPSR_SVC holds the AARCH64 EL1 SPSR which QEMU
>> > +             * keeps in bank 0 so copy it across. */
>> > +            env->banked_spsr[0] = env->banked_spsr[1];
>> > +            i = aarch64_banked_spsr_index(el);
>>
>> More workarounds for a bug we should just fix, I think.
>>
>
> again, this is just for the loop above to be generic, and then fix
> things up afterwards so that things work both for is_a64() and
> !is_a64().

But the only reason we're fixing anything up is that we're
working around the bug. If we didn't have that bug and the
QEMU definition of where SPSR_EL1's state lived correctly
pointed at banked_spsr[1], then the only thing you'd need
to do for syncing is copy the KVM SPSRs into banked_spsr[1..5].

-- PMM
