Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9E54B04B0
	for <kvmarm@lists.linux.dev>; Sat,  8 Aug 2026 14:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786199481; cv=pass; b=Q3hnf7aeFYvaeaVN/RSvKrludUDbephCiY/YHCzONbGHnKahmbmI4lG1z19nZQKM7oQjH4vFjjsoR/CXHAWrBDH88ISn0NJaVuTmmpmQypS1qP/Men5AedY6KQ5F457kTgQs5Cg1pYspjgPGVeWpkUSm7tNHwVTzP8JIqDaEI+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786199481; c=relaxed/simple;
	bh=fxE4Lsqa/IUUklbaLaucYs+XJ3vWVGUGgb2qgYTtM/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sEv04rcchzn0vQEiDyD4w0YIXjKnGG+iPR3/P4y1vt6eJkMtJH324FoyujTetjHoGEgJbIu0uRkQwlG/7fUEb4AVTnweNYtOntPuhM3gGL+0KNDQ8EeepK0rt/GJsj4/FyDNZEi+si4k92mmzctCPnSUuKt1fNHfog0D183FlZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TFY7OXD+; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TFY7OXD+"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a1f8757b4eso2530a12.0
        for <kvmarm@lists.linux.dev>; Sat, 08 Aug 2026 07:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786199478; cv=none;
        d=google.com; s=arc-20260327;
        b=mUV1Y7VxyA7K+SPyeJI1PH4Tg4ro+FcML7An77kYcM6Tc+6++iRsUMh6LE1Klj6VIu
         2+sbC3Ksq8IBjzXv7btTYryZBvN9xu0vgpM85L0cAMjTWqvcf6ZMF6NG6pOsZVQrR2bQ
         PuCZlYjzNZRUS9gOkexwgqLr3Iha4BDcyPedlXk6xBwUni+sJJLj4B8yNx0EEXcw7Xbr
         05pz2XVxviC4FUPhDivWsiOwu2N/NxJ3fIqGWRrdpCztkeRdu1K9KGQd8SOhW2g+T2NP
         XmgC3/c/pEkSKXBWGb+GF86/0TkfBzT7DWk3TrFSYuadoIroIB83WOdPGZGAEKagRrP+
         Bn2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=umhegfornY2q+dliAsJ0qNPWy6KgS5Ezk4jQr8oXmA0=;
        fh=LXtNKv0PeXTvNWBQwpJoTlR/WweCaLWNiN6WywJ5X+w=;
        b=FFNeSb9Gu1cKxW9siIb2tte6tG//FgpA6rlt9eZdcwPhvC1AW2SWbuBZI2C6Ojmohj
         r3ZZ3NWApAMI2d1QY2BWnrNRwrGqx/WvYg9b7JXdg8AYeJMTVlguSMhQS+grkA5qbZeq
         2vRl7w/dskpBcPANgkKqzkMw+u+Vxmp+wUSzW20PP98L45Y6ZxdU5ZQsdpu8HkbacuMi
         +znhSQpMOKorOWxh9L8RXxSiHTI9JQ8WHrT41Pj06DgXrY+S4BOxDq84SoGgGWaOyd0q
         X16FEdWp0NQ6e0p4A4m+bCDTiQDFUwAovSsbHVk5oyNrkAeWLkibIjuBh53XoMOsFklK
         VX4A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786199478; x=1786804278; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=umhegfornY2q+dliAsJ0qNPWy6KgS5Ezk4jQr8oXmA0=;
        b=TFY7OXD+ceW2cWxR9tuXjwSXd5QlL0LrOXEtrVToh5V5zQdov5pQrjPppUF81oYh4x
         /JRvCgtwqVj2fhdRnGszuuedJ8HZmWsP1aEXJXv6E5fNWO2pPgY51b2+60hAtyWpFErF
         LtCv1x7n4Yi0sBcY+j8fI1S32rhYxEK+dtetDEsT+cxz9oc0RazlXEHbBIBO/HfuraKd
         ccLOlWmqEe64/yhC5KeYthzsvCfGmZtuYEmkDlu2qadcrjyh+J9sfF+LtFJN07a5Tz2x
         i1frRbwpfVGGqH7NKDjpczPSX5xl9bSfiokO1ifFszui/MUr4xEkoX4/T61mhqHLOxsu
         gMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786199478; x=1786804278;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=umhegfornY2q+dliAsJ0qNPWy6KgS5Ezk4jQr8oXmA0=;
        b=lwWvf1VgALveWvmgdPa1GMcOOLF5gF1x4UTVxBVm5vy2Z44jZHW8KxrzA1uZsfkOfw
         g9hgpLlvSA4pmHnrVbNPkwNUt579f4juxb51JmrN3RGKmqJnCTeOdnQOg+fYOtvLwSNH
         PA9A7lzNiR3VeO7CcJyZtxbESrmBUbMoPeAahH6KP36l9i6jODlIwH9QhfymioG67r9D
         /jpF0v4gLKMfVhV6EU/U1FZak4quKn4x+dSwKZ2Dsd4LMEDVdAlZ58HgdCsUdjYIDvbK
         fWN1bv+8AG6yj3Q9mI23jr66vyzsXzcGct67bfEABvZlz+dnU9TapAsgY8qAGJ1+WA3b
         ql/Q==
X-Forwarded-Encrypted: i=1; AHgh+Rpy82bIdumVLGVTqz2XENnxUtKDSmugAhnCuOMJXVxdNf18OSUvcDI7ZCYi0m7cRYH+8NxoHcs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHOb4oz/jOk06oNa+LDHOYvX6w9rtngstSqZFGJ6ioPQDeEGth
	jWN0mx/8Ap51THEWZt3WNPduzlWNb48V3pwXg6cqYfWkRBnjWB9UNbWjkE0dUb5SL+NiwllyASm
	BoZC5UECGRpMl26sAnxwXIbME7XkQpq7VaugkKN0u
X-Gm-Gg: AR+sD12Xyv4QY3vNQ2bXqSV252GbAO1q/LxjkVMYYgigZOUlmVTwSutT2t7oVVk999j
	/+vKz/Y5VinroeB8jHHuGDW4Co+kquz5azjFiNS3/QrvqqKiWUWeVbNigqX/9ILhM2ThYoOYnZO
	oH8OUzm5ebef8NkVaN8FsHK/GLXm7eUk1T4+90QajM12pMJENGI9NwhcJgs2nOGAacz2tdJ2ldC
	I7dP+3HyBRAOuVf1hZPoM2CGkLVb5VraQdklSNcQ6/R4ObdNEsmnMLWQDWtx5jxGxVgaKAiOPok
	BmvLZsKTqccFbsBCMVLEAlHwU0Z/Dqevp4bg6UyFgl/y63pcxvg+f9YIKFToIIanSjPyPMNvpMg
	=
X-Received: by 2002:a05:6402:2c5:b0:697:7f69:48e3 with SMTP id
 4fb4d7f45d1cf-6a1f4f5d874mr38566a12.10.1786199477331; Sat, 08 Aug 2026
 07:31:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260808085824.732659-1-smostafa@google.com> <20260808085824.732659-4-smostafa@google.com>
In-Reply-To: <20260808085824.732659-4-smostafa@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Sat, 8 Aug 2026 15:31:04 +0100
X-Gm-Features: AUfX_mx7PbbfJVVT5axwb5kWqfzAC8auOtaruvcG6cTNxOokXMk8vC24H5OnKzM
Message-ID: <CAFgf54pb+5UnYYkbMKe280-ODvbQ=Vhtj8Qk7btR6ZNDwrmzrQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	yaoyuan@linux.alibaba.com, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 8, 2026 at 9:58=E2=80=AFAM Mostafa Saleh <smostafa@google.com> =
wrote:
>
> When running on a setup affected with broken CNTVOFF_EL2
> (has_broken_cntvoff())
>
> Booting with VHE or protected mode(nvhe) (id_aa64mmfr1.vh=3D0
> and arm64_sw.hvhe=3D0) works fine.
>
> However launching a protected VM with protected hvhe mode panics the
> guest kernel:
>
> [    0.000000] Internal error: Oops - Undefined instruction: 000000000000=
0000 [#1]  SMP
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.2.0-rc3=
-g05f75bd71e0e-dirty #29 PREEMPT
> [    0.000000] Hardware name: linux,dummy-virt (DT)
> [    0.000000] pstate: 000003c5 (nzcv DAIF -PAN -UAO -TCO -DIT -SSBS BTYP=
E=3D--)
> [    0.000000] pc : arch_timer_shutdown_virt+0x4/0x1c
> [    0.000000] lr : arch_timer_starting_cpu+0x1c4/0x2d4
> [    0.000000] sp : ffffa6bd9a193c00
> [    0.000000] x29: ffffa6bd9a193c20 x28: ffffa6bd9a1bcf88 x27: 000000000=
0000000
> [    0.000000] x26: ffff00001be70dd8 x25: ffffa6bd99d85000 x24: ffffa6bd9=
9d85ee4
> [    0.000000] x23: ffffa6bd99d85000 x22: ffffa6bd9a1499c0 x21: ffffa6bd9=
a1ab900
> [    0.000000] x20: 00ffffffffffffff x19: ffff00001be8b600 x18: 000000000=
000028c
> [    0.000000] x17: 00000000510f0010 x16: 00000000510f0010 x15: 000000005=
00f0000
> [    0.000000] x14: 0000000000000000 x13: 0000000000000000 x12: 000000000=
0000018
> [    0.000000] x11: ffffa6bd9a8ac000 x10: 0000000000f0000f x9 : fffffffff=
fffffff
> [    0.000000] x8 : ffffa6bd98822e18 x7 : 0070752d65746174 x6 : 00111ff76=
e007261
> [    0.000000] x5 : ffffa6bd9ad68078 x4 : 0000000000000000 x3 : ffffa6bd9=
8822a0c
> [    0.000000] x2 : 0000000000000073 x1 : 0000000000000001 x0 : ffff00001=
be8b600
> [    0.000000] Call trace:
> [    0.000000]  arch_timer_shutdown_virt+0x4/0x1c (P)
> [    0.000000]  cpuhp_invoke_callback+0x11c/0x280
> [    0.000000]  cpuhp_issue_call+0x1e8/0x224
> [    0.000000]  __cpuhp_setup_state_cpuslocked+0x1d8/0x2b8
> [    0.000000]  __cpuhp_setup_state+0x50/0x74
> [    0.000000]  arch_timer_register+0xc0/0x148
> [    0.000000]  arch_timer_of_init+0x148/0x170
> [    0.000000]  timer_probe+0x74/0x124
> [    0.000000]  time_init+0x18/0x58
> [    0.000000]  start_kernel+0x1c0/0x3ac
> [    0.000000]  __primary_switched+0x88/0x90
> [    0.000000] Code: c80b7d2a 35ffffab 17ffffeb d503245f (d53be328)
>
> The workaround avoids setting non-zero CNTVOFF_EL2 and trapping the
> virtual counter to emulate the offset.
> In the VHE path (timer_set_traps()), traps are only enabled when the
> guest actually has a non-zero virtual timer offset.
> However, __timer_enable_traps() in hyp/nvhe/timer-sr.c unconditionally
> set CNTHCTL_EL1TVT and CNTHCTL_EL1TVCT whenever has_broken_cntvoff()
> was true.
>
> Which causes 2 issues:
> 1) Protected VMs: kvm_handle_pvm_sysreg() does not find "cntv_ctl_el0"
> in pvm_sys_reg_descs and injects undefined instruction exceptions.
>
> 2) non-protected guests are trapped all the time even with offset of
> zero.
>
> Fix this by adding a check in __timer_enable_traps() similar to the one i=
n
> timer_set_traps()
>
> Fixes: 0bc9a9e85fcf ("KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity"=
)
> Signed-off-by: Marc Zyngier <maz@kernel.org>

For some reason, when I used b4 to pull the first version, it added
Marc's `Signed-off-by` which was not intended.
Probably it got confused by the patch in the reply.

Thanks,
Mostafa

> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe=
/timer-sr.c
> index 51b4f5010b66..993065716913 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> @@ -61,9 +61,9 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
>
>         /*
>          * Trap the virtual counter/timer if we have a broken cntvoff
> -        * implementation.
> +        * implementation and non zero offset as in timer_set_traps()
>          */
> -       if (has_broken_cntvoff())
> +       if (has_broken_cntvoff() && timer_get_offset(vcpu_vtimer(vcpu)))
>                 set |=3D CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;
>
>         sysreg_clear_set(cnthctl_el2, clr, set);
> --
> 2.55.0.654.g21b8a5bc05-goog
>
