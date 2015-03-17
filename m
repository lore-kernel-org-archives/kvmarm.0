From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 4/5] target-arm: kvm64 fix save/restore of SPSR regs
Date: Tue, 17 Mar 2015 20:04:58 +0100
Message-ID: <20150317190458.GE26480@cbox>
References: <1426503716-13931-1-git-send-email-alex.bennee@linaro.org>
 <1426503716-13931-5-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA8hJTFeR63gJO9QX7nWuFktkehDzGmJjqhTBkTjw4=7Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA8hJTFeR63gJO9QX7nWuFktkehDzGmJjqhTBkTjw4=7Jw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 17, 2015 at 04:18:16PM +0000, Peter Maydell wrote:
> On 16 March 2015 at 11:01, Alex Benn=E9e <alex.bennee@linaro.org> wro=
te:
> > From: Christoffer Dall <christoffer.dall@linaro.org>
> >
> > The current code was negatively indexing the cpu state array and no=
t
> > synchronizing banked spsr register state with the current mode's sp=
sr
> > state, causing occasional failures with migration.
> >
> > Some munging is done to take care of the aarch64 mapping and also t=
o
> > ensure the most current value of the spsr is updated to the banked
> > registers (relevant for KVM<->TCG migration).
> >
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >
> > ---
> > v2 (ajb)
> >   - minor tweaks and clarifications
> > v3
> >   - Use the correct bank index function for setting/getting env->sp=
sr
> >   - only deal with spsrs in elevated exception levels
> > v4
> >  - try and make commentary clearer
> >  - ensure env->banked_spsr[0] =3D env->spsr before we sync
> >
> > diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
> > index 8fd0c8d..7ddb1b1 100644
> > --- a/target-arm/kvm64.c
> > +++ b/target-arm/kvm64.c
> > @@ -140,6 +140,7 @@ int kvm_arch_put_registers(CPUState *cs, int le=
vel)
> >      uint64_t val;
> >      int i;
> >      int ret;
> > +    unsigned int el;
> >
> >      ARMCPU *cpu =3D ARM_CPU(cs);
> >      CPUARMState *env =3D &cpu->env;
> > @@ -206,9 +207,29 @@ int kvm_arch_put_registers(CPUState *cs, int l=
evel)
> >          return ret;
> >      }
> >
> > +    /* Saved Program State Registers
> > +     *
> > +     * Before we restore from the banked_spsr[] array we need to
> > +     * ensure that any modifications to env->spsr are correctly
> > +     * reflected and map aarch64 exception levels if required.
>=20
> "AArch64". Not entirely sure what the "map exception levels"
> is saying.
>=20
> > +     */
> > +    el =3D arm_current_el(env);
> > +    if (el > 0) {
> > +        if (is_a64(env)) {
> > +            g_assert(el =3D=3D 1);
> > +            env->banked_spsr[0] =3D env->spsr;
>=20
> If we're in AArch64 mode then I don't believe
> env->spsr has valid content at this point. The live
> copy is in env->banked_sprsr[] for all cases.
>=20

ah, ok, so we can just get rid of that one.

> > +            /* QEMUs AARCH64 EL1 SPSR is in bank 0, so map it to
> > +             * KVM_SPSR_SVC for syncing to KVM */
>=20
> "QEMU's" and "AArch64", but this is just a bug in our
> implementation -- the mapping between AArch64 SPSR_EL1
> and AArch32 SPSR_svc is architecturally mandated.
> We should be using banked_spsr[1] for our regdef for
> SPSR_EL1 in helper.c.
>=20
> Also the "*/" should be on its own line.
>=20
> > +            env->banked_spsr[1] =3D env->banked_spsr[0];
>=20
> What is going on here? Architecturally, AArch64 SPSR_EL1
> is mapped to AArch32 SPSR_svc, which is env->banked_spsr[1].
> env->banked_spsr[0] would be the SPSR for USR and SYS, except
> they don't have an SPSR (you cannot take exceptions into them).
> I think QEMU just has a banked_spsr[0] for convenience of
> implementation and it should never actually be used.
> Is this code just working around the QEMU SPSR_EL1 bug?
>=20

no, the idea was just to let the loop below just work.  We accomplish
this by taking the AArch64 spsr (which is stored in banked_spsr[0]) and
copying it into banked_spsr[1], which is not used in AArch64 and we can
do the QEMU's spsr are indexed at kvm-index + 1.



> > +            i =3D bank_number(env->uncached_cpsr & CPSR_M);
> > +            env->banked_spsr[i] =3D env->spsr;
> > +        }
> > +    }
> > +
> >      for (i =3D 0; i < KVM_NR_SPSR; i++) {
> >          reg.id =3D AARCH64_CORE_REG(spsr[i]);
> > -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
> > +        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];
>=20
> Coding style demands spaces around the "+" operator.
>=20
> Note that this code is implicitly relying on the
> ordering of register banks defined by the bank_number()
> function, which is a bit icky.

right, I thought you wrote this code with some deeper intention of doin=
g
it this way so I tried to stick with the general idea - but now I
actually looked at git blame and realized that you didn't even write it=
=2E

Given all this churn around this, probably it's much cleaner to get rid
of the loop and have an explicit sync for each architecturally
implemented register, i.e. the SPSR_EL1 and the various mode-specific
AArch32 SPSR registers?

>=20
> >          ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
> >          if (ret) {
> >              return ret;
> > @@ -254,6 +275,7 @@ int kvm_arch_get_registers(CPUState *cs)
> >      struct kvm_one_reg reg;
> >      uint64_t val;
> >      uint32_t fpr;
> > +    unsigned int el;
> >      int i;
> >      int ret;
> >
> > @@ -326,15 +348,34 @@ int kvm_arch_get_registers(CPUState *cs)
> >          return ret;
> >      }
> >
> > +    /* Fetch the SPSR registers
> > +     *
> > +     * KVM has an array of state indexed for all the possible aarc=
h32
> > +     * privilege levels. These map onto QEMUs aarch32 banks 1 - 4.
>=20
> QEMU's. AArch32. Also, you mean "1 - 5".
>=20
> > +     */
> >      for (i =3D 0; i < KVM_NR_SPSR; i++) {
> >          reg.id =3D AARCH64_CORE_REG(spsr[i]);
> > -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
> > +        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];
>=20
> Spaces again.
>=20
> >          ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
> >          if (ret) {
> >              return ret;
> >          }
> >      }
> >
> > +    el =3D arm_current_el(env);
> > +    if (el > 0) {
> > +        if (is_a64(env)) {
> > +            g_assert(el =3D=3D 1);
> > +            /* KVM_SPSR_SVC holds the AARCH64 EL1 SPSR which QEMU
> > +             * keeps in bank 0 so copy it across. */
> > +            env->banked_spsr[0] =3D env->banked_spsr[1];
> > +            i =3D aarch64_banked_spsr_index(el);
>=20
> More workarounds for a bug we should just fix, I think.
>=20

again, this is just for the loop above to be generic, and then fix
things up afterwards so that things work both for is_a64() and
!is_a64().

Thanks,
-Christoffer
