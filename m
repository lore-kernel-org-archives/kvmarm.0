From: Greg Bellows <greg.bellows@linaro.org>
Subject: Re: [Qemu-devel] [PATCH v2 5/6] target-arm: kvm64 fix save/restore of
 SPSR regs
Date: Wed, 11 Mar 2015 14:41:40 -0500
Message-ID: <CAOgzsHV8RsvZpkgHqWfp=u0drCjZcbtk3+kgG4Vj1RZZ+VEhhQ@mail.gmail.com>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
	<1425479753-18349-6-git-send-email-alex.bennee@linaro.org>
	<20150309132611.GB20559@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150309132611.GB20559@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 9, 2015 at 8:26 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Wed, Mar 04, 2015 at 02:35:52PM +0000, Alex Benn=C3=A9e wrote:
>> From: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> The current code was negatively indexing the cpu state array and not
>> synchronizing banked spsr register state with the current mode's sps=
r
>> state, causing occasional failures with migration.
>>
>> Some munging is done to take care of the aarch64 mapping and also to
>> ensure the most current value of the spsr is updated to the banked
>> registers (relevant for KVM<->TCG migration).
>>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>
>> ---
>> v2 (ajb)
>>   - minor tweaks and clarifications
>> v3
>>   - Use the correct bank index function for setting/getting env->sps=
r
>>   - only deal with spsrs in elevated exception levels
>>
>> diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
>> index c60e989..45e5c3f 100644
>> --- a/target-arm/kvm64.c
>> +++ b/target-arm/kvm64.c
>> @@ -140,6 +140,7 @@ int kvm_arch_put_registers(CPUState *cs, int lev=
el)
>>      uint64_t val;
>>      int i;
>>      int ret;
>> +    unsigned int el;
>>
>>      ARMCPU *cpu =3D ARM_CPU(cs);
>>      CPUARMState *env =3D &cpu->env;
>> @@ -206,9 +207,27 @@ int kvm_arch_put_registers(CPUState *cs, int le=
vel)
>>          return ret;
>>      }
>>
>> +    /* Saved Program State Registers
>> +     *
>> +     * Before we restore from the banked_spsr[] array we need to
>> +     * ensure that any modifications to env->spsr are correctly
>> +     * reflected and map aarch64 exception levels if required.
>> +     */
>> +    el =3D arm_current_el(env);
>> +    if (el > 0) {
>> +        if (is_a64(env)) {
>> +            g_assert(el =3D=3D 1);
>> +            /* KVM only maps KVM_SPSR_SVC to KVM_SPSR_EL1 for aarch=
64 ATM */
>
> not sure about the 'for aarch64' comment; I would say that it's for
> aarch32 support.  Also, you can drop the ATM, since this is user spac=
e
> ABI that we don't change easily.
>
>
> don't you need to do env->banked_spsr[0] =3D env->spsr first?

I agree with Christoffer, env->spsr actually has the most current
value so you need to sync up with it before sending it out.

>
>> +            env->banked_spsr[1] =3D env->banked_spsr[0];
>
>
>> +        } else {
>> +            i =3D bank_number(env->uncached_cpsr & CPSR_M);
>> +            env->banked_spsr[i] =3D env->spsr;
>
> so here we don't need to worry about banked_spsr[1] =3D banked_spsr[0=
]
> because banked_spsr[0] is meaningless for 32-bit state and we only sy=
nc
> banked_spsr[1] and up to KVM, correct?  I think this is what may dese=
rve
> a comment.
>
>> +        }
>> +    }
>> +
>>      for (i =3D 0; i < KVM_NR_SPSR; i++) {
>>          reg.id =3D AARCH64_CORE_REG(spsr[i]);
>> -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
>> +        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];
>>          ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
>>          if (ret) {
>>              return ret;
>> @@ -253,6 +272,7 @@ int kvm_arch_get_registers(CPUState *cs)
>>      struct kvm_one_reg reg;
>>      uint64_t val;
>>      uint32_t fpr;
>> +    unsigned int el;
>>      int i;
>>      int ret;
>>
>> @@ -325,15 +345,35 @@ int kvm_arch_get_registers(CPUState *cs)
>>          return ret;
>>      }
>>
>> +    /* Fetch the SPSR registers
>> +     *
>> +     * KVM has an array of state indexed for all the possible aarch=
32
>> +     * privilage levels. Although not all are valid at all points
>
> privilege
>
>> +     * there are some transitions possible which can access old sta=
te
>> +     * so it is worth keeping them all.
>> +     */
>
> dubious comment overall
>
>>      for (i =3D 0; i < KVM_NR_SPSR; i++) {
>>          reg.id =3D AARCH64_CORE_REG(spsr[i]);
>> -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
>> +        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];
>>          ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
>>          if (ret) {
>>              return ret;
>>          }
>>      }
>>
>> +    el =3D arm_current_el(env);
>> +    if (el > 0) {
>> +        if (is_a64(env)) {
>> +            g_assert(el =3D=3D 1);
>> +            /* KVM maps KVM_SPSR_SVC to KVM_SPSR_EL1 for aarch64 */
>
> same as above

If Christoffer's comment is referring to updating env->spsr, it occurs
below based on 'i'.

>
>> +            env->banked_spsr[0] =3D env->banked_spsr[1];
>> +            i =3D aarch64_banked_spsr_index(el);
>> +        } else {
>> +            i =3D bank_number(env->uncached_cpsr & CPSR_M);
>
> same potential place for comment as above.
>
>> +        }
>> +        env->spsr =3D env->banked_spsr[i];
>> +    }
>> +
>>      /* Advanced SIMD and FP registers */
>>      for (i =3D 0; i < 32; i++) {
>>          reg.id =3D AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
>> --
>> 2.3.1
>>
>
