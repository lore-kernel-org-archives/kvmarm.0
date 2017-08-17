From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 11/27] arm64/sve: Core task context handling
Date: Thu, 17 Aug 2017 17:46:44 +0100
Message-ID: <CAKv+Gu-dgsOcW032P2Zk36Rk4C-FUuJuWSkWox_-wPX+NHY2sA@mail.gmail.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-12-git-send-email-Dave.Martin@arm.com> <CAKv+Gu-Rei0LP9q77+KHtD4JqM-6j4XvQjG7oCLrjHx2M5DA7g@mail.gmail.com>
 <20170817164233.GJ6321@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170817164233.GJ6321@e103592.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, libc-alpha@sourceware.org, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17 August 2017 at 17:42, Dave Martin <Dave.Martin@arm.com> wrote:
> On Tue, Aug 15, 2017 at 06:31:05PM +0100, Ard Biesheuvel wrote:
>> Hi Dave,
>>
>> On 9 August 2017 at 13:05, Dave Martin <Dave.Martin@arm.com> wrote:
>> > This patch adds the core support for switching and managing the SVE
>> > architectural state of user tasks.
>
> [...]
>
>> > +static u64 sve_cpacr_trap_on(u64 cpacr)
>> > +{
>> > +       return cpacr & ~(u64)CPACR_EL1_ZEN_EL0EN;
>> > +}
>> > +
>> > +static u64 sve_cpacr_trap_off(u64 cpacr)
>> > +{
>> > +       return cpacr | CPACR_EL1_ZEN_EL0EN;
>> > +}
>> > +
>> > +static void change_cpacr(u64 old, u64 new)
>> > +{
>> > +       if (old != new)
>> > +               write_sysreg(new, CPACR_EL1);
>> > +}
>
> [...]
>
>> > +static void task_fpsimd_load(void)
>> > +{
>> > +       if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
>> > +               unsigned int vl = current->thread.sve_vl;
>> > +
>> > +               BUG_ON(!sve_vl_valid(vl));
>> > +               sve_load_state(sve_pffr(current),
>> > +                              &current->thread.fpsimd_state.fpsr,
>> > +                              sve_vq_from_vl(vl) - 1);
>> > +       } else
>> > +               fpsimd_load_state(&current->thread.fpsimd_state);
>> > +
>>
>> Please use braces consistently on all branches of an if ()
>>
>> > +       if (system_supports_sve()) {
>> > +               u64 cpacr = read_sysreg(CPACR_EL1);
>> > +               u64 new_cpacr;
>> > +
>> > +               /* Toggle SVE trapping for userspace if needed */
>> > +               if (test_thread_flag(TIF_SVE))
>> > +                       new_cpacr = sve_cpacr_trap_off(cpacr);
>> > +               else
>> > +                       new_cpacr = sve_cpacr_trap_on(cpacr);
>> > +
>> > +               change_cpacr(cpacr, new_cpacr);
>>
>> I understand you want to avoid setting CPACR to the same value, but
>> this does look a bit clunky IMO. Wouldn't it be much better to have a
>> generic accessor with a mask and a value that encapsulates this?
>
> For this I now have:
>
> static void change_cpacr(u64 val, u64 mask)
> {
>         u64 cpacr = read_sysreg(CPACR_EL1);
>         u64 new = (cpacr & ~mask) | val;
>
>         if (new != cpacr)
>                 write_sysreg(new, CPACR_EL1);
> }
>
> static void sve_cpacr_trap_on(void)
> {
>         change_cpacr(0, CPACR_EL1_ZEN_EL0EN);
> }
>
> static void sve_cpacr_trap_off(void)
> {
>         change_cpacr(CPACR_EL1_ZEN_EL0EN, CPACR_EL1_ZEN_EL0EN);
> }
>
>
> This is stilla little verbose, but fairly clean.  Possibly this was the
> sort of thing you meant by a generic accessor.
>
> What do you think?
>

In my opinion, this does look a lot better. Having mask/val pairs like
this is a fairly common pattern, so it should be quite obvious to most
readers what is going on.
