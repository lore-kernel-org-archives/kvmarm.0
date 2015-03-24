From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [PATCH v5 1/6] target-arm: Store SPSR_EL1 state in
 banked_spsr[1] (SPSR_svc)
Date: Tue, 24 Mar 2015 14:37:40 +0000
Message-ID: <CAFEAcA9MCtdK_VicF8tgMmmtuoL0pm4TofLcJbcmir6ApjMf0Q@mail.gmail.com>
References: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org>
 <1427130344-27986-2-git-send-email-alex.bennee@linaro.org> <CAOgzsHUUsZS5hkyPCWer_OurJXy9v5U3g8AjtRV=9uszL4nntg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAOgzsHUUsZS5hkyPCWer_OurJXy9v5U3g8AjtRV=9uszL4nntg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Greg Bellows <greg.bellows@linaro.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 24 March 2015 at 14:32, Greg Bellows <greg.bellows@linaro.org> wrote=
:
> On Mon, Mar 23, 2015 at 12:05 PM, Alex Benn=C3=A9e <alex.bennee@linar=
o.org> wrote:
>> From: Peter Maydell <peter.maydell@linaro.org>

>> @@ -523,7 +523,7 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
>>          aarch64_save_sp(env, arm_current_el(env));
>>          env->elr_el[new_el] =3D env->pc;
>>      } else {
>> -        env->banked_spsr[0] =3D cpsr_read(env);
>> +        env->banked_spsr[aarch64_banked_spsr_index(new_el)] =3D cps=
r_read(env);
>
> Are the other banks (2-5) only used for KVM?  It seems we go out of
> our way to manage this larger SPSR array then not use all of the slot=
s
> in QEMU itself.

They're used in AArch32 (where they are the SPSR for various
32 bit modes). In AArch64 you can access those registers via
MSR/MRS (we probably haven't implemented those yet because they
are only accessible at EL2 and above) so hypervisors can do
worldswitches. But for exception entry and return (which is
what this code is) we only use SPSR_EL0/SPSR_EL1/SPSR_EL2/SPSR_EL3
which is a subset of the AArch32 SPSRs.

-- PMM
