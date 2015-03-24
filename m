From: Greg Bellows <greg.bellows@linaro.org>
Subject: Re: [Qemu-devel] [PATCH v5 1/6] target-arm: Store SPSR_EL1 state in
 banked_spsr[1] (SPSR_svc)
Date: Tue, 24 Mar 2015 09:32:40 -0500
Message-ID: <CAOgzsHUUsZS5hkyPCWer_OurJXy9v5U3g8AjtRV=9uszL4nntg@mail.gmail.com>
References: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org>
	<1427130344-27986-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427130344-27986-2-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 23, 2015 at 12:05 PM, Alex Benn=C3=A9e <alex.bennee@linaro.=
org> wrote:
> From: Peter Maydell <peter.maydell@linaro.org>
>
> The AArch64 SPSR_EL1 register is architecturally mandated to
> be mapped to the AArch32 SPSR_svc register. This means its
> state should live in QEMU's env->banked_spsr[1] field.
> Correct the various places in the code that incorrectly
> put it in banked_spsr[0].
>
> Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
>
> diff --git a/target-arm/helper-a64.c b/target-arm/helper-a64.c
> index 7e0d038..861f6fa 100644
> --- a/target-arm/helper-a64.c
> +++ b/target-arm/helper-a64.c
> @@ -523,7 +523,7 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
>          aarch64_save_sp(env, arm_current_el(env));
>          env->elr_el[new_el] =3D env->pc;
>      } else {
> -        env->banked_spsr[0] =3D cpsr_read(env);
> +        env->banked_spsr[aarch64_banked_spsr_index(new_el)] =3D cpsr=
_read(env);

Are the other banks (2-5) only used for KVM?  It seems we go out of
our way to manage this larger SPSR array then not use all of the slots
in QEMU itself.

>          if (!env->thumb) {
>              env->cp15.esr_el[new_el] |=3D 1 << 25;
>          }
> diff --git a/target-arm/helper.c b/target-arm/helper.c
> index 10886c5..d77c6de 100644
> --- a/target-arm/helper.c
> +++ b/target-arm/helper.c
> @@ -2438,7 +2438,7 @@ static const ARMCPRegInfo v8_cp_reginfo[] =3D {
>      { .name =3D "SPSR_EL1", .state =3D ARM_CP_STATE_AA64,
>        .type =3D ARM_CP_ALIAS,
>        .opc0 =3D 3, .opc1 =3D 0, .crn =3D 4, .crm =3D 0, .opc2 =3D 0,
> -      .access =3D PL1_RW, .fieldoffset =3D offsetof(CPUARMState, ban=
ked_spsr[0]) },
> +      .access =3D PL1_RW, .fieldoffset =3D offsetof(CPUARMState, ban=
ked_spsr[1]) },
>      /* We rely on the access checks not allowing the guest to write =
to the
>       * state field when SPSel indicates that it's being used as the =
stack
>       * pointer.
> diff --git a/target-arm/internals.h b/target-arm/internals.h
> index bb171a7..2cc3017 100644
> --- a/target-arm/internals.h
> +++ b/target-arm/internals.h
> @@ -82,11 +82,14 @@ static inline void arm_log_exception(int idx)
>
>  /*
>   * For AArch64, map a given EL to an index in the banked_spsr array.
> + * Note that this mapping and the AArch32 mapping defined in bank_nu=
mber()
> + * must agree such that the AArch64<->AArch32 SPSRs have the archite=
cturally
> + * mandated mapping between each other.
>   */
>  static inline unsigned int aarch64_banked_spsr_index(unsigned int el=
)
>  {
>      static const unsigned int map[4] =3D {
> -        [1] =3D 0, /* EL1.  */
> +        [1] =3D 1, /* EL1.  */
>          [2] =3D 6, /* EL2.  */
>          [3] =3D 7, /* EL3.  */
>      };
> --
> 2.3.2
>
>
