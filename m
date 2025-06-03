Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EADBA34
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 18:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748975604; cv=none; b=RpeAntI0SgLbdsvjFHCLcFlk1QQBCKK7soNtxAhbFa5QWXKlwWfEagw2sZKzH3SCUgdq2cYlRAIqspA/OH148ZbpTKBrZKcPaO2TQhj3n9kIZT5bw82hsuXXFLFT/s4yPQ+E9MF1DGhqVjR6dxqFD7w9BBB59rfdEHOp3ZgHsZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748975604; c=relaxed/simple;
	bh=EUHIy7+UpcvIDwPobMjG8eLPKQfw0iKGPPnSGrbYc0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lBpCWZQPgIgHSqyBZ6NQNfGc4ekaVOr+TifuEXJIaB4btsTr2jEV1PWac/0AMHto/MV6g+uQvTX/5uYMZ7ujkqxtzOaxfBxmXokFEnbXHbCdNaFtshu4MW6su7sIbtiqycmiFja1RYOYJj5laOn6UCj1npHMtLszSFqH1r2z5Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oUzlHEUT; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oUzlHEUT"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4a433f52485so68841cf.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Jun 2025 11:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748975601; x=1749580401; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=llBAJ9Mv+8G8+OG6m8CY66j0XQOFBHrZvO7P/h6ydKo=;
        b=oUzlHEUTiKTys6b9P/0RUBvAu4riDuH/mGU5TJn/coeiCF1ZiOmnIdxmAQoUF8SWan
         XDj5sutqmdYwwXyiOE+7BEBNR6Dys5tfl3g6wgyxEKEvLSY3uIh7UKKd2DyGF8Ny/T+a
         x9Fqc4loscHCj7FQR/MlgY8kQsatnCsSUJ03Ws4RipZqfEAGkzo6p48q5MTdeincmPFV
         lzPrkuJMjaCvg1vsIYId9pJooCYFkIwBN/1pNxyRmkX5ndKE5yO/WCGiz8qw3c0O2KUb
         JA8kbeRsvpjYdn2g+lXG6hyCovX1O08uyzpKpfqrmw7Pk+4tYy5K8HtpVGNxSDP/csYv
         RaQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748975601; x=1749580401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=llBAJ9Mv+8G8+OG6m8CY66j0XQOFBHrZvO7P/h6ydKo=;
        b=dwqGNpN7whiQGoKTdQDpxcO0F457aeazTfjVni7JTeeDymg4K3DW2ywwAXxSFik6aL
         18yttAmUa/hN/qDoaN/eSgo80w9U85bKbnE/RGf/DrfhK6gMkb+VB5qi/+OVzNptJf6l
         KJ+B88Tty7lrXCGLMezxwa8VHKvG8YCqf5mkFDZ3rLs8Z7BYskfEPd+cCvblbx1g/j+k
         AyGSE8z6x/70OfP8OokEKi2MrbgXRBuMETzV7QjYfWHzbBZcNOObfEwkGjFXs+bNtFww
         RMn1eJnoEnefZHamFfhBRXruVvHrdguVSKxqqs9HrAN9sf/hc2TrU6kdwx/l5mZOF8IE
         nRag==
X-Gm-Message-State: AOJu0YzMZSdDN07v39UW20sVlDEH6t8YhRoPBOSA85zODjWMVqIH7Ef8
	0QbeGi+TMzC0DJK0DbTb1hYjfysKJf0YnupMZtK458hBM7crSn1SPhKa4g7wrQNprfPs4o1afvv
	UkB3mr/2O/zSruHxcW7Pokfo8ctDtHxckhv6MmEvs
X-Gm-Gg: ASbGnctpRT/PFg7xxhOA3JmaeV9tlqs6ow5A0ClfwlYgX7o9/Uv63H9YCDUZOyRrupP
	6xO/eNUDGWe8GHAvURB7InUNRLXKlMdfnwprm4lNI+SGfilR2vPEpab2NpY6h56Y4CtXvURV5Jn
	ASRrDZyFHnCxnsuY/orZqC4gGy+xojEaOYpFq13QXK9IXbRxP57DDg6f9S9CtTyROzl9V5aMr3l
	Dh1
X-Google-Smtp-Source: AGHT+IHXig85qGXrNOA4tM2+ue7RicXlP1NEtKfTsyYP7hPWjvuNznOOfJU5p1yh0TbL9Ujkmqo55qRltTuM/qRbwjI=
X-Received: by 2002:a05:622a:4ac6:b0:48a:5b89:473b with SMTP id
 d75a77b69052e-4a5a53c9269mr127531cf.7.1748975600171; Tue, 03 Jun 2025
 11:33:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250531012545.709887-1-oliver.upton@linux.dev> <20250531012545.709887-4-oliver.upton@linux.dev>
In-Reply-To: <20250531012545.709887-4-oliver.upton@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 3 Jun 2025 11:33:08 -0700
X-Gm-Features: AX0GCFuuGQvlRo3iebuR8uQHHBOH10ZSdqcNAVsYrbApM2xmSuhTYHzzoK7tz08
Message-ID: <CAJHc60ydf74jG4gtqWVQb40PuMWYFDX8JqVovM1OANudWMuEnw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Introduce attribute to control GICD_TYPER2.nASSGIcap
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Ben Horgan <ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Fri, May 30, 2025 at 6:26=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> From: Raghavendra Rao Ananta <rananta@google.com>
>
> KVM unconditionally advertises GICD_TYPER2.nASSGIcap (which internally
> implies vSGIs) on GICv4.1 systems. Allow userspace to change whether a
> VM supports the feature. Only allow changes prior to VGIC initialization
> as at that point vPEs need to be allocated for the VM.
>
> For convenience, bundle support for vLPIs and vSGIs behind this feature,
> allowing userspace to control vPE allocation for VMs in environments
> that may be constrained on vPE IDs.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  .../virt/kvm/devices/arm-vgic-v3.rst          | 29 +++++++++++++++
>  arch/arm64/include/uapi/asm/kvm.h             |  3 ++
>  arch/arm64/kvm/vgic/vgic-init.c               |  3 ++
>  arch/arm64/kvm/vgic/vgic-kvm-device.c         | 37 +++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 10 ++++-
>  include/kvm/arm_vgic.h                        |  3 ++
>  6 files changed, 84 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v3.rst
> index e860498b1e35..049d77eae591 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> @@ -306,3 +306,32 @@ Groups:
>
>      The vINTID specifies which interrupt is generated when the vGIC
>      must generate a maintenance interrupt. This must be a PPI.
> +
> +  KVM_DEV_ARM_VGIC_GRP_FEATURES
> +   Attributes:
> +
> +    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap
> +      Control whether support for SGIs without an active state is expose=
d
> +      to the VM. attr->addr points to a __u8 value which indicates wheth=
er
> +      he feature is enabled / disabled.
> +
nit: s/he/the

> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/=
vgic-kvm-device.c
> index b0baad68777c..c9d41ae9fe4f 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -626,6 +626,26 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>                 dev->kvm->arch.vgic.mi_intid =3D val;
>                 return 0;
>         }
> +       case KVM_DEV_ARM_VGIC_GRP_FEATURES: {
> +               u8 __user *uaddr =3D (u8 __user *)attr->addr;
> +               u8 val;
> +
> +               if (attr->attr !=3D KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap)
> +                       return -ENXIO;
> +
> +               if (get_user(val, uaddr))
> +                       return -EFAULT;
> +
> +               guard(mutex)(&dev->kvm->arch.config_lock);
> +               if (vgic_initialized(dev->kvm))
> +                       return -EBUSY;
> +
Do we want to return success if userspace isn't trying to change the
value (similar to sysreg/fw-reg writes)?

> +               if (!(kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_=
vsgi()) && val)
> +                       return -EINVAL;
> +
> +               dev->kvm->arch.vgic.nassgicap =3D val;
> +               return 0;
> +       }
>         default:
>                 return vgic_set_common_attr(dev, attr);
>         }
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgi=
c-mmio-v3.c
> index 1a9c5b4418b2..43f59e70e1a2 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -50,12 +50,20 @@ bool vgic_has_its(struct kvm *kvm)
>
>  bool vgic_supports_direct_msis(struct kvm *kvm)
>  {
> +       /*
> +        * Deliberately conflate vLPI and vSGI support on GICv4.1 hardwar=
e,
> +        * indirectly allowing userspace to control whether or not vPEs a=
re
> +        * allocated for the VM.
> +        */
> +       if (kvm_vgic_global_state.has_gicv4_1 && !vgic_supports_direct_sg=
is(kvm))
> +               return false;
> +
Since vgic_supports_direct_sgis() is derived from
'kvm_vgic_global_state.has_gicv4_1', do we still need to depend on the
latter?

Also just to double-check, there are other references that directly
read 'kvm_vgic_global_state.has_gicv4_1' (vgic_v3_map_resources() for
instance). Do we not want them to be replaced with
vgic_supports_direct_sgis()?

Thank you.
Raghavendra
