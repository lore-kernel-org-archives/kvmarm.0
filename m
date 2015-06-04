From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 4/6] target-arm: kvm - support for single step
Date: Thu, 4 Jun 2015 11:59:17 +0100
Message-ID: <CAFEAcA9nTR_UfNyZB4h5VhnFFZKQGDG=rrw-M-=aPUcmmGr4Ug@mail.gmail.com>
References: <1432912764-7073-1-git-send-email-alex.bennee@linaro.org> <1432912764-7073-5-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1432912764-7073-5-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Christoffer Dall <christoffer.dall@linaro.org>, Zhichao Huang <zhichao.huang@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29 May 2015 at 16:19, Alex Benn=C3=A9e <alex.bennee@linaro.org> wrot=
e:
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
> v3
>   - use internals.h definitions
> ---
>  target-arm/kvm.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
> index c3bad6f..de2865a 100644
> --- a/target-arm/kvm.c
> +++ b/target-arm/kvm.c
> @@ -528,6 +528,13 @@ static int kvm_handle_debug(CPUState *cs, struct=
 kvm_run *run)
>      kvm_cpu_synchronize_state(cs);
>
>      switch (hsr_ec) {
> +    case EC_SOFTWARESTEP:
> +        if (cs->singlestep_enabled) {
> +            return true;
> +        } else {
> +            error_report("Came out of SINGLE STEP when not enabled")=
;

All-caps there is a bit odd.

> +        }
> +        break;
>      case EC_AA64_BKPT:
>          if (kvm_find_sw_breakpoint(cs, env->pc)) {
>              return true;
> @@ -588,6 +595,9 @@ int kvm_arch_on_sigbus(int code, void *addr)
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

Again, is there a guard somewhere to prevent us trying to enable
singlestep if the kernel doesn't support it?

-- PMM
