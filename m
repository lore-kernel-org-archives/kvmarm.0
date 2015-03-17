From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 1/5] target-arm: kvm: save/restore mp state
Date: Tue, 17 Mar 2015 15:17:15 +0000
Message-ID: <CAFEAcA9VZrH07DB5+3Gb1dPg4bzt6uHdK9uXMPCp8JeC0EvBYQ@mail.gmail.com>
References: <1426503716-13931-1-git-send-email-alex.bennee@linaro.org> <1426503716-13931-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1426503716-13931-2-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 16 March 2015 at 11:01, Alex Benn=C3=A9e <alex.bennee@linaro.org> wr=
ote:
> This adds the saving and restore of the current Multi-Processing stat=
e
> of the machine. While the KVM_GET/SET_MP_STATE API exposes a number o=
f
> potential states for x86 we only use two for ARM. Either the process =
is
> running or not. We then save this state into the cpu_powered TCG stat=
e
> to avoid changing the serialisation format.

This (and the comments and function names below) still seem to
be looking at this in terms of some ambiguous "multiprocessing
state". What we are actually dealing with here is "is the
vCPU powered on or not", and I'd rather we said so explicitly.

> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> ---
> v2
>   - make mpstate field runtime dependant (kvm_enabled())
>   - drop initial KVM_CAP_MP_STATE requirement
>   - re-use cpu_powered instead of new field
>
> v4
>   - s/HALTED/STOPPED/
>   - move code from machine.c to kvm.
>
> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
> index 72c1fa1..a74832c 100644
> --- a/target-arm/kvm.c
> +++ b/target-arm/kvm.c
> @@ -458,6 +458,46 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu)
>      }
>  }
>
> +/*
> + * Update KVM's MP_STATE based on what QEMU thinks it is
> + */
> +int kvm_arm_sync_mpstate_to_kvm(ARMCPU *cpu)
> +{
> +    if (kvm_check_extension(CPU(cpu)->kvm_state, KVM_CAP_MP_STATE)) =
{

Doesn't seem like a great idea to do the extension check
every time we sync state, when it's always going to be the
same for any particular run of QEMU.

> +        struct kvm_mp_state mp_state =3D {
> +            .mp_state =3D
> +            cpu->powered_off ? KVM_MP_STATE_STOPPED : KVM_MP_STATE_R=
UNNABLE
> +        };
> +        int ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MP_STATE, &mp_s=
tate);
> +        if (ret) {
> +            fprintf(stderr, "%s: failed to set MP_STATE %d/%s\n",
> +                    __func__, ret, strerror(ret));

kvm_vcpu_ioctl() returns a negative errno, but strerror wants
a positive one.

> +            return -1;
> +        }
> +    }
> +
> +    return 0;
> +}
> +
> +/*
> + * Sync the KVM MP_STATE into QEMU
> + */
> +int kvm_arm_sync_mpstate_to_qemu(ARMCPU *cpu)
> +{
> +    if (kvm_check_extension(CPU(cpu)->kvm_state, KVM_CAP_MP_STATE)) =
{
> +        struct kvm_mp_state mp_state;
> +        int ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MP_STATE, &mp_s=
tate);
> +        if (ret) {
> +            fprintf(stderr, "%s: failed to get MP_STATE %d/%s\n",
> +                    __func__, ret, strerror(ret));
> +            abort();
> +        }
> +        cpu->powered_off =3D (mp_state.mp_state =3D=3D KVM_MP_STATE_=
STOPPED);
> +    }
> +
> +    return 0;
> +}
> +
>  void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
>  {
>  }
> diff --git a/target-arm/kvm32.c b/target-arm/kvm32.c
> index 94030d1..49b6bab 100644
> --- a/target-arm/kvm32.c
> +++ b/target-arm/kvm32.c
> @@ -356,6 +356,8 @@ int kvm_arch_put_registers(CPUState *cs, int leve=
l)
>          return EINVAL;
>      }
>
> +    kvm_arm_sync_mpstate_to_kvm(cpu);
> +
>      return ret;
>  }
>
> @@ -427,5 +429,7 @@ int kvm_arch_get_registers(CPUState *cs)
>       */
>      write_list_to_cpustate(cpu);
>
> +    kvm_arm_sync_mpstate_to_qemu(cpu);
> +
>      return 0;
>  }
> diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
> index 8cf3a62..fed03f2 100644
> --- a/target-arm/kvm64.c
> +++ b/target-arm/kvm64.c
> @@ -211,6 +211,8 @@ int kvm_arch_put_registers(CPUState *cs, int leve=
l)
>          return EINVAL;
>      }
>
> +    kvm_arm_sync_mpstate_to_kvm(cpu);
> +
>      /* TODO:
>       * FP state
>       */
> @@ -310,6 +312,8 @@ int kvm_arch_get_registers(CPUState *cs)
>       */
>      write_list_to_cpustate(cpu);
>
> +    kvm_arm_sync_mpstate_to_qemu(cpu);
> +
>      /* TODO: other registers */
>      return ret;
>  }
> diff --git a/target-arm/kvm_arm.h b/target-arm/kvm_arm.h
> index 455dea3..7b75758 100644
> --- a/target-arm/kvm_arm.h
> +++ b/target-arm/kvm_arm.h
> @@ -162,6 +162,24 @@ typedef struct ARMHostCPUClass {
>   */
>  bool kvm_arm_get_host_cpu_features(ARMHostCPUClass *ahcc);
>
> +
> +/**
> + * kvm_arm_sync_mpstate_to_kvm
> + * @cpu: ARMCPU
> + *
> + * If supported set the KVM MP_STATE based on QEMUs migration data.

"QEMU's". Also, not migration data, it's just our state.

> + */
> +int kvm_arm_sync_mpstate_to_kvm(ARMCPU *cpu);
> +
> +/**
> + * kvm_arm_sync_mpstate_to_qemu
> + * @cpu: ARMCPU
> + *
> + * If supported get the MP_STATE from KVM and store in QEMUs migrati=
on
> + * data.

Apostrophe again.

> + */
> +int kvm_arm_sync_mpstate_to_qemu(ARMCPU *cpu);

thanks
-- PMM
