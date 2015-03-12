From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 1/6] target-arm: kvm: save/restore mp state
Date: Thu, 12 Mar 2015 15:43:40 +0000
Message-ID: <CAFEAcA-286NkXcSAtRpB-_UEAszSg_Fawc-7pa+OXDY8NupYhA@mail.gmail.com>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org> <1425479753-18349-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1425479753-18349-2-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 4 March 2015 at 14:35, Alex Benn=C3=A9e <alex.bennee@linaro.org> wro=
te:
> This adds the saving and restore of the current Multi-Processing stat=
e
> of the machine. While the KVM_GET/SET_MP_STATE API exposes a number o=
f
> potential states for x86 we only use two for ARM. Either the process =
is
> running or not. We then save this state into the cpu_powered TCG stat=
e
> to avoid changing the serialisation format.
>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> ---
> v2
>   - make mpstate field runtime dependant (kvm_enabled())
>   - drop initial KVM_CAP_MP_STATE requirement
>   - re-use cpu_powered instead of new field
>
> diff --git a/target-arm/machine.c b/target-arm/machine.c
> index 9446e5a..185f9a2 100644
> --- a/target-arm/machine.c
> +++ b/target-arm/machine.c
> @@ -161,6 +161,7 @@ static const VMStateInfo vmstate_cpsr =3D {
>      .put =3D put_cpsr,
>  };
>
> +
>  static void cpu_pre_save(void *opaque)
>  {
>      ARMCPU *cpu =3D opaque;
> @@ -170,6 +171,20 @@ static void cpu_pre_save(void *opaque)
>              /* This should never fail */
>              abort();
>          }
> +#if defined CONFIG_KVM
> +        if (kvm_check_extension(CPU(cpu)->kvm_state, KVM_CAP_MP_STAT=
E)) {
> +            struct kvm_mp_state mp_state;
> +            int ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MP_STATE, &=
mp_state);
> +            if (ret) {
> +                fprintf(stderr, "%s: failed to get MP_STATE %d/%s\n"=
,
> +                        __func__, ret, strerror(ret));
> +                abort();
> +            }
> +            cpu->powered_off =3D
> +                (mp_state.mp_state =3D=3D KVM_MP_STATE_RUNNABLE)
> +                ? false : true;

Ternary operator to produce a true-or-false result is a bit
redundant...

> +        }
> +#endif

Why is this in pre-save/post-load rather than in the
kvm_arch_get/put_registers functions like all the other
syncing code?

-- PMM
