Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBB836D
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730917833; cv=none; b=FE82uFadtExB2uFQIO+Ab6ATVgTUa0MBiNH3GzPzKyIH2FRVGbKnXn+ut1JhPmNal88PQl33Jq5Zgaq7hkPgKqmwcOz7oXG6A2lQ40nn+DvetSvYz8L8eu3TJmLu2xw8UUqsR3Bz0ylX12ZkfHPbBRDMyXD0Sms2Gh60GLcPCpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730917833; c=relaxed/simple;
	bh=mjoz83CLqaDv8rpTVVqzpgd8HTB+bg+8p56PWi41xqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GuMpkeExr8x6PWgZCAsnLZ9IobgiEjKPI6ubZwOwl25oPmN7VT0WajPxCB5pCtHSGk6CcvJxaqMCK+L0acvhwz1+C/v/MVjNXrWnyUhY93tEQ058LDCGmHpBwTLTkt9qFu/EaO1A6iOcC5ddkSS+d9sJiYub9JROv935alF0s9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rX6f7pMk; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rX6f7pMk"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53b13ea6b78so16875e87.2
        for <kvmarm@lists.linux.dev>; Wed, 06 Nov 2024 10:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730917830; x=1731522630; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NbT+MVFmQWldHSwvQIAZqRuAjWXImGGsq+3vijULiGE=;
        b=rX6f7pMkZ8xaPxhj6ft0pLKLgS4xIXehS89ZT59W6VW7bH7ZTApY/e6PZM6vxAQDJy
         kAaWJsmGchZHQMY8hRAnYpbhJNVZTiNwJkFyzPGQ0r1+N13CvtXE0TXQybPE9WUGZZyi
         l9s7zvf0boq1hlbUBB8XKzI0DgkqwTLiixZwB/Faq6d6yK0aFh5CHV4i1g1jYm7iyKyp
         qCHdrwDt4R0MRv4+V6fSqc7jaq9QxASA2WbZUY7XDDVLK9zFuJ6GWktOszQ1LDdp4FhB
         vQPER9C/zp0MYPBHUToWEZoEFjCxE3TkJx1/dga8SLBsgEMwYABtOGlehDdgIaecMlQ5
         mjWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730917830; x=1731522630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NbT+MVFmQWldHSwvQIAZqRuAjWXImGGsq+3vijULiGE=;
        b=H+ALNFduBkLEwl/EyPRYM/0sMzGRRqWxgrYCXmASOFYeALQXoFZjA5sKwowC9hFiel
         AojnsbGyJqTj4nkTpLRNgjcZTQ/iHtzCK+tlDhob2y3sk8w5TkgXDVZ1Ngco9oXUaS9k
         IYfRbAqyD//DJkY1/8fcaRmDd8qZIIhiNjsU+DcyncirefTuBzlrYR+kLQr8mT1Bm4Wj
         e6yZcV2Mcx5BzhYyC/+3DKzB0OR9ohR91OF10oJz8tP6rxNyMUbZXgActRPq97EN2FCn
         Pr3/lpoImP0yTWE/t1AztmSumxcL2l5xajNMdPu2YwUrTArL6CGilRtLqvDq5ytuXQQY
         Y3lA==
X-Forwarded-Encrypted: i=1; AJvYcCWeQ2YJc75HnThnQAZH3qRZD/MkLCy9ortKS3Y9HpmI5izg3IPfyRAjUfz1Vgz9jHE3TM/4YAs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRECr+n+awnEXgx+V2MQ6DWBmaMhSop0Klu/7CxUvLqBWrNxCi
	T39tm4Uv1hUmil8wFEt7n1TaO9Hr/Cdaxj6Vf7F1U1RpxiXuOa+dzs1TDI2LuCjF/3EYZ0BAnfP
	lqsEGtxvIa1f3kk0XLVyQCycCFqs+96s5+GME
X-Google-Smtp-Source: AGHT+IGYKAJXEmT25HizfPd98EM7DkJ/wBTM9jTTkKgsvpun+NHaqwmwMvXWcTOmNi+oHO6/SxiZtFDZUwiPL4oYAew=
X-Received: by 2002:a05:6512:159c:b0:539:8f3c:4586 with SMTP id
 2adb3069b0e04-53d65e16881mr14669176e87.55.1730917829767; Wed, 06 Nov 2024
 10:30:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
 <20241106083035.2813799-3-jingzhangos@google.com> <86bjys1p45.wl-maz@kernel.org>
In-Reply-To: <86bjys1p45.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 6 Nov 2024 10:30:17 -0800
Message-ID: <CAAdAUthN14kLmeH0eLK991soGeZD8qzD+Sp1jR2gZjqLVE771Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Kunkun Jiang <jiangkunkun@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 5:14=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 06 Nov 2024 08:30:33 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > From: Kunkun Jiang <jiangkunkun@huawei.com>
> >
> > vgic_its_save_device_tables will traverse its->device_list to
> > save DTE for each device. vgic_its_restore_device_tables will
> > traverse each entry of device table and check if it is valid.
> > Restore if valid.
> >
> > But when MAPD unmaps a device, it does not invalidate the
> > corresponding DTE. In the scenario of continuous saves
> > and restores, there may be a situation where a device's DTE
> > is not saved but is restored. This is unreasonable and may
> > cause restore to fail. This patch clears the corresponding
> > DTE when MAPD unmaps a device.
> >
> > Co-developed-by: Shusen Li <lishusen2@huawei.com>
> > Signed-off-by: Shusen Li <lishusen2@huawei.com>
> > Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-=
its.c
> > index 2381bc5ce544..7c57c7c6fbff 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -1140,8 +1140,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *k=
vm, struct vgic_its *its,
> >       u8 num_eventid_bits =3D its_cmd_get_size(its_cmd);
> >       gpa_t itt_addr =3D its_cmd_get_ittaddr(its_cmd);
> >       struct its_device *device;
> > +     gpa_t gpa;
> >
> > -     if (!vgic_its_check_id(its, its->baser_device_table, device_id, N=
ULL))
> > +     if (!vgic_its_check_id(its, its->baser_device_table, device_id, &=
gpa))
> >               return E_ITS_MAPD_DEVICE_OOR;
> >
> >       if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
> > @@ -1161,8 +1162,17 @@ static int vgic_its_cmd_handle_mapd(struct kvm *=
kvm, struct vgic_its *its,
> >        * The spec does not say whether unmapping a not-mapped device
> >        * is an error, so we are done in any case.
> >        */
> > -     if (!valid)
> > +     if (!valid) {
> > +             struct kvm *kvm =3D its->dev->kvm;
> > +             int dte_esz =3D vgic_its_get_abi(its)->dte_esz;
> > +             u64 val =3D 0;
> > +
> > +             if (KVM_BUG_ON(dte_esz !=3D sizeof(val), kvm))
> > +                     return -EINVAL;
>
> I find it pretty odd to bug only in that case, and the sprinkling of
> these checks all over the place is horrible. I'm starting to wonder if
> we shouldn't simply wrap vgic_write_guest() and co to do the checking.
>
> > +
> > +             vgic_write_guest_lock(kvm, gpa, &val, dte_esz);
>
> I'm thinking of something like:
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index ba945ba78cc7d..d8e57aefcd3a5 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -1128,6 +1128,19 @@ static struct its_device *vgic_its_alloc_device(st=
ruct vgic_its *its,
>         return device;
>  }
>
> +
> +#define its_write_entry_lock(i, g, valp, t)                            \
> +       ({                                                              \
> +               struct kvm *__k =3D (i)->dev->kvm;                       =
 \
> +               int __sz =3D vgic_its_get_abi(i)->t;                     =
 \
> +               int __ret =3D 0;                                         =
 \
> +               if (KVM_BUG_ON(__sz !=3D sizeof(*(valp)), __k))          =
 \
> +                       __ret =3D -EINVAL;                               =
 \
> +               else                                                    \
> +                       vgic_write_guest_lock(__k, (g), (valp), __sz);  \
> +               __ret;                                                  \
> +       })
> +
>  /*
>   * MAPD maps or unmaps a device ID to Interrupt Translation Tables (ITTs=
).
>   * Must be called with the its_lock mutex held.
> @@ -1140,8 +1153,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm=
, struct vgic_its *its,
>         u8 num_eventid_bits =3D its_cmd_get_size(its_cmd);
>         gpa_t itt_addr =3D its_cmd_get_ittaddr(its_cmd);
>         struct its_device *device;
> +       gpa_t gpa;
>
> -       if (!vgic_its_check_id(its, its->baser_device_table, device_id, N=
ULL))
> +       if (!vgic_its_check_id(its, its->baser_device_table, device_id, &=
gpa))
>                 return E_ITS_MAPD_DEVICE_OOR;
>
>         if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
> @@ -1161,8 +1175,10 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kv=
m, struct vgic_its *its,
>          * The spec does not say whether unmapping a not-mapped device
>          * is an error, so we are done in any case.
>          */
> -       if (!valid)
> -               return 0;
> +       if (!valid) {
> +               u64 val =3D 0;
> +               return its_write_entry_lock(its, gpa, &val, dte_esz);
> +       }
>
>         device =3D vgic_its_alloc_device(its, device_id, itt_addr,
>                                        num_eventid_bits);
>
> which can be generalised everywhere (you can even extract the check
> and move it to an out-of-line helper as required).

Sounds good. Will do as you suggested.

Jing
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
