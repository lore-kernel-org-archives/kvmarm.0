Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C7A3D6A
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 12:50:00 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id a10so2667945ljr.5
        for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 05:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681994999; x=1684586999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vze+cX/j4StM18SXLeilMyCPk1xIJShZ67ky2TAKGCM=;
        b=mnxmHElQ5jQgFkd58m77bsQMRnyFdsKcTuObob6YHC1oqBO4rJQiTA1J4oerhIkImu
         Rd2yVXTqLKHbf+Hfq5vBo/UYETTbAJje17oZf8sFV9pWhVN3Fd/So8y9/7yFYqqxJBAE
         xx172pIwDP6Q7vdX+6O4u8ZGvcGfO7zYDNDA4oEoa5HrBvW6vDKfJkVfdFGxAcnuioyr
         QTf4sVVVTCxjZNba59a72HnAEarHuSraPmTk2/l+FAiQ613S7Hpk5eLIsQRTPMgnfMCQ
         YEMzATb5PZDy7z/zg/uit8N5lAIKr2Lalnd4hP2ES3Wk7UDqUSKyWhhj29Etmk9ItF3X
         WHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681994999; x=1684586999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vze+cX/j4StM18SXLeilMyCPk1xIJShZ67ky2TAKGCM=;
        b=jVfBLUOqMpCc7s14sWw18jkpgyEC6Z+hj+08Jf6gsIpaGqyNLWYlY5U+wtz6Lcq5Wv
         oPZfT6jyCHf13xAafsRPk8JQiTnzVVGvgQGjpV3X5eiXHY6HHaZ8hSt1JxZW7zKRm27N
         mp8xuE0iKwtwdCYXqAOS9AWVEYVc17yePiYfCpA5Z5wkZZYVeFvX9pw3u6W0oUGGcus5
         3fBBqW27g1S6WPU5soIDL+RPoZ16AhKUiZEqh9Qa8vnap2w9sc7zhX0DDnj53Q4ulYtx
         cpZrOdJiBNVKphSBIbdXKjIoHwqHQIClEk9Iln3lT6aE3kRlVi3V75gSq4BCLGB5WA6T
         dZlw==
X-Gm-Message-State: AAQBX9cTRxCefLgL7Q0ysJoB9hZX57tO0HtyY+MZzN4kyzb/LiK4GHHH
	XT5/J3L4XxW2W9T4APCXkso1PYOmoHt694yeOa3wVw==
X-Google-Smtp-Source: AKy350bfTV5W3T4AWpifvutNTofesxfrfGGybLCLG/hWH9e4VdBEP9k6PNcHakGvcveeq1Kx3Ch+nTwnwTtSFaDVWQU=
X-Received: by 2002:a2e:3318:0:b0:2a8:b188:139a with SMTP id
 d24-20020a2e3318000000b002a8b188139amr335887ljc.45.1681994998759; Thu, 20 Apr
 2023 05:49:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230420123356.2708-1-will@kernel.org>
In-Reply-To: <20230420123356.2708-1-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 20 Apr 2023 13:49:22 +0100
Message-ID: <CA+EHjTwVoEWPBTjzYiDQ4Gm15B_Gx3sMewR+q1xyzST8PWX0ag@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Ensure CPU PMU probes before pKVM host de-privilege
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Thu, Apr 20, 2023 at 1:34=E2=80=AFPM Will Deacon <will@kernel.org> wrote=
:
>
> Although pKVM supports CPU PMU emulation for non-protected guests since
> 722625c6f4c5 ("KVM: arm64: Reenable pmu in Protected Mode"), this relies
> on the PMU driver probing before the host has de-privileged so that the
> 'kvm_arm_pmu_available' static key can still be enabled by patching the
> hypervisor text.
>
> As it happens, both of these events hang off device_initcall() but the
> PMU consistently won the race until 7755cec63ade ("arm64: perf: Move
> PMUv3 driver to drivers/perf"). Since then, the host will fail to boot
> when pKVM is enabled:
>
>   | hw perfevents: enabled with armv8_pmuv3_0 PMU driver, 7 counters avai=
lable
>   | kvm [1]: nVHE hyp BUG at: [<ffff8000090366e0>] __kvm_nvhe_handle_host=
_mem_abort+0x270/0x284!
>   | kvm [1]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STA=
CKTRACE
>   | kvm [1]: Hyp Offset: 0xfffea41fbdf70000
>   | Kernel panic - not syncing: HYP panic:
>   | PS:a00003c9 PC:0000dbe04b0c66e0 ESR:00000000f2000800
>   | FAR:fffffbfffddfcf00 HPFAR:00000000010b0bf0 PAR:0000000000000000
>   | VCPU:0000000000000000
>   | CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.3.0-rc7-00083-g0bce6746d1=
54 #1
>   | Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
>   | Call trace:
>   |  dump_backtrace+0xec/0x108
>   |  show_stack+0x18/0x2c
>   |  dump_stack_lvl+0x50/0x68
>   |  dump_stack+0x18/0x24
>   |  panic+0x13c/0x33c
>   |  nvhe_hyp_panic_handler+0x10c/0x190
>   |  aarch64_insn_patch_text_nosync+0x64/0xc8
>   |  arch_jump_label_transform+0x4c/0x5c
>   |  __jump_label_update+0x84/0xfc
>   |  jump_label_update+0x100/0x134
>   |  static_key_enable_cpuslocked+0x68/0xac
>   |  static_key_enable+0x20/0x34
>   |  kvm_host_pmu_init+0x88/0xa4
>   |  armpmu_register+0xf0/0xf4
>   |  arm_pmu_acpi_probe+0x2ec/0x368
>   |  armv8_pmu_driver_init+0x38/0x44
>   |  do_one_initcall+0xcc/0x240
>
> Fix the race properly by deferring the de-privilege step to
> device_initcall_sync(). This will also be needed in future when probing
> IOMMU devices and allows us to separate the pKVM de-privilege logic from
> the core hypervisor initialisation path.
>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Fixes: 7755cec63ade ("arm64: perf: Move PMUv3 driver to drivers/perf")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---

Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> Marc, Oliver -- in practice, this issue only crops with the patches
> moving the CPU PMU driver out into drivers/perf/ and so the arm64
> for-next/core branch is broken. Please can I queue this in the arm64
> tree for 6.4 with your Ack? Thanks.
>
>  arch/arm64/kvm/arm.c  | 45 -----------------------------------------
>  arch/arm64/kvm/pkvm.c | 47 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+), 45 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3bd732eaf087..890f730bc3ab 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -16,7 +16,6 @@
>  #include <linux/fs.h>
>  #include <linux/mman.h>
>  #include <linux/sched.h>
> -#include <linux/kmemleak.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_irqfd.h>
>  #include <linux/irqbypass.h>
> @@ -46,7 +45,6 @@
>  #include <kvm/arm_psci.h>
>
>  static enum kvm_mode kvm_mode =3D KVM_MODE_DEFAULT;
> -DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
>
>  DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>
> @@ -2105,41 +2103,6 @@ static int __init init_hyp_mode(void)
>         return err;
>  }
>
> -static void __init _kvm_host_prot_finalize(void *arg)
> -{
> -       int *err =3D arg;
> -
> -       if (WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)))
> -               WRITE_ONCE(*err, -EINVAL);
> -}
> -
> -static int __init pkvm_drop_host_privileges(void)
> -{
> -       int ret =3D 0;
> -
> -       /*
> -        * Flip the static key upfront as that may no longer be possible
> -        * once the host stage 2 is installed.
> -        */
> -       static_branch_enable(&kvm_protected_mode_initialized);
> -       on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
> -       return ret;
> -}
> -
> -static int __init finalize_hyp_mode(void)
> -{
> -       if (!is_protected_kvm_enabled())
> -               return 0;
> -
> -       /*
> -        * Exclude HYP sections from kmemleak so that they don't get peek=
ed
> -        * at, which would end badly once inaccessible.
> -        */
> -       kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_sta=
rt);
> -       kmemleak_free_part_phys(hyp_mem_base, hyp_mem_size);
> -       return pkvm_drop_host_privileges();
> -}
> -
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
>  {
>         struct kvm_vcpu *vcpu;
> @@ -2257,14 +2220,6 @@ static __init int kvm_arm_init(void)
>         if (err)
>                 goto out_hyp;
>
> -       if (!in_hyp_mode) {
> -               err =3D finalize_hyp_mode();
> -               if (err) {
> -                       kvm_err("Failed to finalize Hyp protection\n");
> -                       goto out_subs;
> -               }
> -       }
> -
>         if (is_protected_kvm_enabled()) {
>                 kvm_info("Protected nVHE mode initialized successfully\n"=
);
>         } else if (in_hyp_mode) {
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index cf56958b1492..6e9ece1ebbe7 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -4,6 +4,8 @@
>   * Author: Quentin Perret <qperret@google.com>
>   */
>
> +#include <linux/init.h>
> +#include <linux/kmemleak.h>
>  #include <linux/kvm_host.h>
>  #include <linux/memblock.h>
>  #include <linux/mutex.h>
> @@ -13,6 +15,8 @@
>
>  #include "hyp_constants.h"
>
> +DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> +
>  static struct memblock_region *hyp_memory =3D kvm_nvhe_sym(hyp_memory);
>  static unsigned int *hyp_memblock_nr_ptr =3D &kvm_nvhe_sym(hyp_memblock_=
nr);
>
> @@ -213,3 +217,46 @@ int pkvm_init_host_vm(struct kvm *host_kvm)
>         mutex_init(&host_kvm->lock);
>         return 0;
>  }
> +
> +static void __init _kvm_host_prot_finalize(void *arg)
> +{
> +       int *err =3D arg;
> +
> +       if (WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)))
> +               WRITE_ONCE(*err, -EINVAL);
> +}
> +
> +static int __init pkvm_drop_host_privileges(void)
> +{
> +       int ret =3D 0;
> +
> +       /*
> +        * Flip the static key upfront as that may no longer be possible
> +        * once the host stage 2 is installed.
> +        */
> +       static_branch_enable(&kvm_protected_mode_initialized);
> +       on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
> +       return ret;
> +}
> +
> +static int __init finalize_pkvm(void)
> +{
> +       int ret;
> +
> +       if (!is_protected_kvm_enabled())
> +               return 0;
> +
> +       /*
> +        * Exclude HYP sections from kmemleak so that they don't get peek=
ed
> +        * at, which would end badly once inaccessible.
> +        */
> +       kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_sta=
rt);
> +       kmemleak_free_part_phys(hyp_mem_base, hyp_mem_size);
> +
> +       ret =3D pkvm_drop_host_privileges();
> +       if (ret)
> +               pr_err("Failed to finalize Hyp protection: %d\n", ret);
> +
> +       return ret;
> +}
> +device_initcall_sync(finalize_pkvm);
> --
> 2.40.0.634.g4ca3ef3211-goog
>
