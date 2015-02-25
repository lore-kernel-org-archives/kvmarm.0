From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 1/6] target-arm: kvm: save/restore mp state
Date: Thu, 26 Feb 2015 08:36:23 +0900
Message-ID: <CAFEAcA9oWeYGYcGtf8So6VrYLMXjWr4FiZ2tS+jBnDtv87jAKw@mail.gmail.com>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org> <1424880159-29348-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1424880159-29348-2-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 26 February 2015 at 01:02, Alex Benn=C3=A9e <alex.bennee@linaro.org>=
 wrote:
> This adds the saving and restore of the current Multi-Processing stat=
e
> of the machine. While the KVM_GET/SET_MP_STATE API exposes a number o=
f
> potential states for x86 we only use two for ARM. Either the process =
is
> running or not.

By this you mean "is the CPU in the PSCI powered down state or not",
right?

> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
> index 23cefe9..8732854 100644
> --- a/target-arm/kvm.c
> +++ b/target-arm/kvm.c
> @@ -25,6 +25,7 @@
>  #include "hw/arm/arm.h"
>
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] =3D {
> +    KVM_CAP_INFO(MP_STATE),

Does this really want to be a required cap? I haven't checked,
but assuming 'required' means what it says this presumably
means we'll stop working on host kernels we previously ran
fine on (even if migration didn't work there).

>      KVM_CAP_LAST_INFO
>  };
>
> diff --git a/target-arm/machine.c b/target-arm/machine.c
> index 9446e5a..70b1bc4 100644
> --- a/target-arm/machine.c
> +++ b/target-arm/machine.c
> @@ -161,6 +161,34 @@ static const VMStateInfo vmstate_cpsr =3D {
>      .put =3D put_cpsr,
>  };
>
> +#if defined CONFIG_KVM
> +static int get_mpstate(QEMUFile *f, void *opaque, size_t size)
> +{
> +    ARMCPU *cpu =3D opaque;
> +    struct kvm_mp_state mp_state =3D { .mp_state =3D  qemu_get_be32(=
f)};
> +    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MP_STATE, &mp_state);
> +}

Won't this break if you're running a QEMU built with KVM
support in TCG mode on an aarch64 host?

In any case, for that configuration we should be migrating the
TCG cpu->powered_off flag, which is where we keep the PSCI
power state for TCG.

> +
> +static void put_mpstate(QEMUFile *f, void *opaque, size_t size)
> +{
> +    ARMCPU *cpu =3D opaque;
> +    struct kvm_mp_state mp_state;
> +    int ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MP_STATE, &mp_state=
);
> +    if (ret) {
> +        fprintf(stderr, "%s: failed to get MP_STATE %d/%s\n",
> +                __func__, ret, strerror(ret));
> +        abort();
> +    }
> +    qemu_put_be32(f, mp_state.mp_state);
> +}
> +
> +static const VMStateInfo vmstate_mpstate =3D {
> +    .name =3D "mpstate",
> +    .get =3D get_mpstate,
> +    .put =3D put_mpstate,
> +};
> +#endif
> +
>  static void cpu_pre_save(void *opaque)
>  {
>      ARMCPU *cpu =3D opaque;
> @@ -244,6 +272,16 @@ const VMStateDescription vmstate_arm_cpu =3D {
>          VMSTATE_UINT32_ARRAY(env.regs, ARMCPU, 16),
>          VMSTATE_UINT64_ARRAY(env.xregs, ARMCPU, 32),
>          VMSTATE_UINT64(env.pc, ARMCPU),
> +#if defined CONFIG_KVM
> +        {
> +            .name =3D "mp_state",
> +            .version_id =3D 0,
> +            .size =3D sizeof(uint32_t),
> +            .info =3D &vmstate_mpstate,
> +            .flags =3D VMS_SINGLE,
> +            .offset =3D 0,
> +        },
> +#endif

This means the migration format will be different on different
build configurations, which seems like a really bad idea.

Have you considered having the KVM state sync functions just
sync the kernel's MP state into cpu->powered_off, and then
migrating that flag here unconditionally?

>          {
>              .name =3D "cpsr",
>              .version_id =3D 0,
> --
> 2.3.0
>

-- PMM
