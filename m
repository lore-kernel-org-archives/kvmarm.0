From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 3/4] target-arm: kvm - support for single step
Date: Mon, 20 Apr 2015 20:49:02 +0100
Message-ID: <CAFEAcA_dqx-78AoGiHViv_tMCDkSd7Uf2GpUz+uBm5QbgX0nvg@mail.gmail.com>
References: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org> <1427816446-31586-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427816446-31586-4-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Christoffer Dall <christoffer.dall@linaro.org>, Zhichao Huang <zhichao.huang@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 31 March 2015 at 16:40, Alex Benn=C3=A9e <alex.bennee@linaro.org> wr=
ote:
> This adds support for single-step. There isn't much to do on the QEMU
> side as after we set-up the request for single step via the debug ioc=
tl
> it is all handled within the kernel.
>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> ---
> v2
>   - convert to using HSR_EC
>
> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
> index 290c1fe..ae0f8b2 100644
> --- a/target-arm/kvm.c
> +++ b/target-arm/kvm.c
> @@ -475,6 +475,7 @@ void kvm_arch_post_run(CPUState *cs, struct kvm_r=
un *run)
>  */
>
>  #define HSR_EC_SHIFT            26
> +#define HSR_EC_SOFT_STEP        0x32
>  #define HSR_EC_SW_BKPT          0x3c

We already include internals.h in this file, so can you just use
the EC_* constants and ARM_EL_EC_SHIFT rather than defining
new ones? (Applies for patch 1 as well.)

>  static int kvm_handle_debug(CPUState *cs, struct kvm_run *run)
> @@ -483,6 +484,13 @@ static int kvm_handle_debug(CPUState *cs, struct=
 kvm_run *run)
>      int hsr_ec =3D arch_info->hsr >> HSR_EC_SHIFT;
>
>      switch (hsr_ec) {
> +    case HSR_EC_SOFT_STEP:
> +        if (cs->singlestep_enabled) {
> +            return true;
> +        } else {
> +            error_report("Came out of SINGLE STEP when not enabled")=
;

This can only happen if there's a kernel bug, right?

> +        }
> +        break;
>      case HSR_EC_SW_BKPT:
>          if (kvm_find_sw_breakpoint(cs, arch_info->pc)) {
>              return true;
> @@ -542,6 +550,9 @@ int kvm_arch_on_sigbus(int code, void *addr)
>
>  void kvm_arch_update_guest_debug(CPUState *cs, struct kvm_guest_debu=
g *dbg)
>  {
> +    if (cs->singlestep_enabled) {
> +        dbg->control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLES=
TEP;
> +    }
>      if (kvm_sw_breakpoints_active(cs)) {
>          dbg->control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_=
BP;
>      }
> --
> 2.3.4
>


thanks
-- PMM
