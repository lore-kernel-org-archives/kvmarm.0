From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 5/6] target-arm/kvm64: fix save/restore of SPSR regs
Date: Mon, 9 Mar 2015 13:56:50 +0100
Message-ID: <20150309125650.GA20559@cbox>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
 <1424880159-29348-7-git-send-email-alex.bennee@linaro.org>
 <20150302172212.GB10137@lvm>
 <874mq27222.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <874mq27222.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 03, 2015 at 11:28:21AM +0000, Alex Benn=E9e wrote:
>=20
> Christoffer Dall <christoffer.dall@linaro.org> writes:
>=20
> > Hi Alex,
> >
> > Seems like you accidentally sent out two copies of this patch, hope=
fully
> > I'm reviewing the right one...
>=20
> Oops, perils of not wiping your output directory. I think it was just=
 a
> title tweak!
>=20
> > On Wed, Feb 25, 2015 at 04:02:38PM +0000, Alex Benn=E9e wrote:
> >> From: Christoffer Dall <christoffer.dall@linaro.org>
> >>=20
> >> The current code was negatively indexing the cpu state array and n=
ot
> >> synchronizing banked spsr register state with the current mode's s=
psr
> >> state, causing occasional failures with migration.
> >>=20
> >> Some munging is done to take care of the aarch64 mapping and also =
to
> >> ensure the most current value of the spsr is updated to the banked
> >> registers (relevant for KVM<->TCG migration).
> >>=20
> >> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >>=20
> >> ---
> >> v2 (ajb)
> >>   - minor tweaks and clarifications
> >>=20
> >> diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
> >> index c60e989..1e36b0a 100644
> >> --- a/target-arm/kvm64.c
> >> +++ b/target-arm/kvm64.c
> >> @@ -140,6 +140,7 @@ int kvm_arch_put_registers(CPUState *cs, int l=
evel)
> >>      uint64_t val;
> >>      int i;
> >>      int ret;
> >> +    unsigned int el;
> >> =20
> >>      ARMCPU *cpu =3D ARM_CPU(cs);
> >>      CPUARMState *env =3D &cpu->env;
> >> @@ -206,9 +207,25 @@ int kvm_arch_put_registers(CPUState *cs, int =
level)
> >>          return ret;
> >>      }
> >> =20
> >> +    /* Saved Program State Registers
> >> +     *
> >> +     * Before we restore from the banked_spsr[] array we need to
> >> +     * ensure that any modifications to env->spsr are correctly
> >> +     * reflected and map aarch64 exception levels if required.
> >> +     */
> >> +    el =3D arm_current_el(env);
> >> +    if (is_a64(env) && el > 0) {
> >> +        g_assert(el =3D=3D 1);
> >> +        /* KVM maps KVM_SPSR_SVC to KVM_SPSR_EL1 for aarch64 */
> >> +        env->banked_spsr[1] =3D env->banked_spsr[0];
> >> +        env->banked_spsr[aarch64_banked_spsr_index(el)] =3D env->=
spsr;
> >> +    } else {
> >> +        env->banked_spsr[el] =3D env->spsr;
> >
> > is this valid if (is_a64(env) && el =3D=3D 0)) ?  I thought that if=
 you're
> > in el =3D=3D 0, then env->banked_spsr[x] is the most up-to-date one=
, not
> > env->spsr ?
>=20
> Actually they will both be the same (at least for KVM). In the end bo=
th:
>=20
>         VMSTATE_UINT32(env.spsr, ARMCPU),
>         VMSTATE_UINT64_ARRAY(env.banked_spsr, ARMCPU, 8),
>=20
> get serialised in the stream and when we save the stream out we make
> sure everything is in sync (i.e. env->spsr is correct). In reality th=
is
> makes more sense for TCG than KVM which is the only reason env->spsr
> exists.
>=20

this function, however, is not used only when migration, but should
generally cover the case where you want to synchronize QEMU's state int=
o
KVM's state, right?  So while it may not be harmful in currently
supported use cases, is there ever a situation where (is_a64(env) && el
=3D=3D 0) and env->spsr !=3D banked_spsr[el], and where env->spsr is
out-of-date?

If that's the case, I think it would be better to have an assert that
says "don't call the code in this situation" than relying on limited us=
e
cases for callers of this function.

> >
> > for !is_a64(env) this looks wrong, because of the same as above if =
el =3D=3D
> > 0, but also because I think you need
> > bank_number(env->uncached_cpsr & CPSR_M) to index into the array.
> >
>=20
> Good catch. For some reason I was treating the number from
> arm_current_el() as equivalent. How about:
>=20
>     el =3D arm_current_el(env);
>     if (is_a64(env) && el > 0) {
>         g_assert(el =3D=3D 1);
>         /* KVM only maps KVM_SPSR_SVC to KVM_SPSR_EL1 for aarch64 ATM=
 */
>         env->banked_spsr[1] =3D env->banked_spsr[0];
>     }
>     i =3D is_a64(env) ?
>         aarch64_banked_spsr_index(el) : bank_number(env->unached_cpsr=
 & CPSR_M);

I think that will fail due to the assert in aarch64_banked_spsr_index()
for el =3D=3D 0.


-Christoffer
