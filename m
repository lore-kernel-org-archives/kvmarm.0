Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE0117E8F0
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 13:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716902073; cv=none; b=imKcWHaCLhLcRM2jgnQKzOQRPA8dkMOFkMz4oh1LkVfAD9Z4Lqr6Nek6nS7bwayfEBfpkuWx9x7zDj/H6WT5OLUtKARJetozlAJHqpT2Itn4MQd6B9a8jiwqrYXArEFxv5DA4ByUkanCmp9Q1nJj0Rh0viikk8I8IBnS6BCtqZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716902073; c=relaxed/simple;
	bh=epG9EF3K6e/qKPmu9qd2urkJjOCa+D4Eyo2op5nCbxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A1mrGNjVus3Dp0GJQo23Qd3hTSFQGGJj2yucztHgnI8hesqcP/HDa7RUlbqQ3gfyserA2vG3KJv3bVIhdDU3zjM0Xga4YjFdxCj5Fh+9I5Bf1eoREyEyWIismMOMWhfArszKUI4v+jOkIPoQWiJ1tzZDEHBMQYrK+/0KCUvj56g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DbDbXN4i; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DbDbXN4i"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6f8e287fa3eso436527a34.2
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 06:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716902070; x=1717506870; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMv6uxFhRlM6GGDjH1s2TgUkooWl+cbY6LhYE+ObOmw=;
        b=DbDbXN4iZ9iZ1v1l+Jfa65I/uWqvg6s/ikLZN7trUbVbeEullXGzWHwEZlTbQzfruR
         q8KWGiXPTrqKXnlGcRS5TuBpH05Lh3jtNILilemTFRw80Z2lmWKyYZGQvhngYEe+0YVU
         e39n0m1fKIgQpP0wJ8dBCL/LgUeQT6flA9ePZ32eYvKlz3pMhUKpYagulLUfjcF2is4t
         a13vkQ7qjzfFO5JJ6hxPbuK1kJpmpPWV1T+2Rk82tiyC0Zxj5XRAdoj2vo367clLSJ0Y
         //vWx70Cw7xxEKXkTKE+eMvYKcPVnlvvuORlrwKHW+uBZgKYkKKKs6j/DLjdxzh9Yuu3
         /3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716902070; x=1717506870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMv6uxFhRlM6GGDjH1s2TgUkooWl+cbY6LhYE+ObOmw=;
        b=i8/Y6xKVPTBffpN88aDahskQvt/tOFyl31RgZDEfX+kgKqDreHoODTBCFkVP4vByIN
         WTP+7i3O37eGQTbghi90bE74rGpxfuTNSFzhDwUkTqK3N+ynCP/wVLhslueXPwn4jOpJ
         KWwQKp/XMjyyKMQRDV3ACNESdM/a7tjjYOtrnhGttwyZVtjm6ohpjrRvlDziAj9AL5iu
         5LuO76eR/fqUPyQZ7ZB8IfFIsra+qcBI2oeNgFwL3WKABYELkzmRKVj7xFM7IIqQ7pc6
         QqLmFs8EDIoum1QgY4GHe3AKEE18/ArdrGAHEVTwbkZwPaRV2ISXO7RC0su5F8XYi/ij
         7eqA==
X-Gm-Message-State: AOJu0Yzd+HsVesb/+p10uInmjwAlwPeL0QpUMspcOhOtScuQY8dPXNi/
	eRc7vX7ZDU09/lQ8JTRSNxYDgtkEX+4kpGVyT+GlNVsQZlNDB6IENSyS1GqpyEHz2pFHKQapxAf
	d7c4+sJEx4gHG6RKAVr1H6vE1u4embl65UfvaUioll03ie0nqyNYt
X-Google-Smtp-Source: AGHT+IEz+6e5XtCNTnfFK2Lbjq/41CpB9x2JNCfnI/aO0gIJbIOU27gw1JSZGYZXv7eZjn4kxJTmGhI2frU4lHbas5A=
X-Received: by 2002:a9d:6a98:0:b0:6f0:e64f:de95 with SMTP id
 46e09a7af769-6f8d0a7e035mr13036591a34.2.1716902070294; Tue, 28 May 2024
 06:14:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 28 May 2024 14:13:53 +0100
Message-ID: <CA+EHjTwaMSBL2XXyAki1qKB6KJRQzL-hx9DFhEiBJdmsi39rJw@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] KVM: arm64: Fix handling of host fpsimd/sve
 state in protected mode
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, broonie@kernel.org, joey.gouly@arm.com, 
	rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 28, 2024 at 1:59=E2=80=AFPM Fuad Tabba <tabba@google.com> wrote=
:
>
> Changes since v2 [1]
> - Rebased on Linux 6.10-rc1 (1613e604df0c)
> - Apply suggestions/fixes suggested for V2 (Marc)
> - Add an isb() to __hyp_sve_restore_guest()
> - Squash patch that introduces kvm_host_sve_max_vl with following
>   patch, since it's used there
> - Some refactoring and tidying up
> - Introduce and use sve_cond_update_zcr_vq_isb(), which only does
>   an isb() if ZCR is updated (RFC, next to last patch)

Just realized that

"An indirect read of ZCR_EL1.LEN appears to occur in program order
relative to a direct write of the same register, without the need for
explicit synchronization."
https://developer.arm.com/documentation/ddi0595/2021-03/AArch64-Registers/Z=
CR-EL2--SVE-Control-Register--EL2-

I'll wait until I get comments on this series as it is before
respinning. Apologies for the spam.

Cheers,
/fuad

> - Remove sve_cond_update_zcr_vq_*, since it's not likely to help
>   much (RFC, last patch)
>
> With the KVM host data rework [2], handling of fpsimd and sve
> state in protected mode is done at hyp. For protected VMs, we
> don't want to leak any guest state to the host, including whether
> a guest has used fpsimd/sve.
>
> To complete the work started with the host data rework, in
> regards to protected mode, ensure that the host's fpsimd context
> and its sve context are restored on guest exit, since the rework
> has hidden the fpsimd/sve state from the host.
>
> This patch series eagerly restores the host fpsimd/sve state on
> guest exit when running in protected mode, which happens only if
> the guest has used fpsimd/sve. This means that the saving of the
> state is lazy, similar to the behavior of KVM in other modes, but
> the restoration of the host state is eager.
>
> The last two patches are not essential to this patch series, and
> the last one undoes the next-to-last. Please consider only one
> (or neither) of these two patches for inclusion.
>
> This series is based on Linux 6.10-rc1 (1613e604df0c).
>
> Tested on qemu, with the kernel sve stress tests.
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/20240521163720.3812851-1-tabba@google.com=
/
> [2] https://lore.kernel.org/all/20240322170945.3292593-1-maz@kernel.org/
>
> Fuad Tabba (11):
>   KVM: arm64: Reintroduce __sve_save_state
>   KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
>   KVM: arm64: Specialize handling of host fpsimd state on trap
>   KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM
>   KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
>   KVM: arm64: Consolidate initializing the host data's fpsimd_state/sve
>     in pKVM
>   KVM: arm64: Refactor CPACR trap bit setting/clearing to use ELx format
>   KVM: arm64: Add an isb before restoring guest sve state
>   KVM: arm64: Do not use sve_cond_update_zcr updating with
>     ZCR_ELx_LEN_MASK
>   KVM: arm64: Do not perform an isb() if ZCR_EL2 isn't updated
>   KVM: arm64: Drop sve_cond_update_zcr_vq_*
>
>  arch/arm64/include/asm/el2_setup.h      |  6 +-
>  arch/arm64/include/asm/fpsimd.h         | 11 ----
>  arch/arm64/include/asm/kvm_arm.h        |  6 ++
>  arch/arm64/include/asm/kvm_emulate.h    | 71 +++++++++++++++++++++--
>  arch/arm64/include/asm/kvm_host.h       | 25 +++++++-
>  arch/arm64/include/asm/kvm_hyp.h        |  2 +
>  arch/arm64/include/asm/kvm_pkvm.h       |  9 +++
>  arch/arm64/kvm/arm.c                    | 76 +++++++++++++++++++++++++
>  arch/arm64/kvm/fpsimd.c                 |  8 +--
>  arch/arm64/kvm/hyp/fpsimd.S             |  6 ++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 36 ++++++------
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  1 -
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 75 +++++++++++++++++++++---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c          | 17 ++----
>  arch/arm64/kvm/hyp/nvhe/setup.c         | 25 +++++++-
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 24 +++++++-
>  arch/arm64/kvm/hyp/vhe/switch.c         | 12 ++--
>  arch/arm64/kvm/reset.c                  |  3 +
>  18 files changed, 342 insertions(+), 71 deletions(-)
>
>
> base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
> --
> 2.45.1.288.g0e0cd299f1-goog
>
