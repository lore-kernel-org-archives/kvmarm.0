Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F46B1DEFD8
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 20:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729715468; cv=none; b=lwqohqikH8KeKumTEViz/E4X2GuvwvyQtQA8GCC/OkUZqSvgwfIvhF5CozVi5FlNoJshTThPSV6kZRWYJIv+sADmpGG+GHoxYLtEAeiccob876fzMiDTat9Jb/i6poHy+gmUgOp3Y8hJcfQmHnUL1W4RnHghjVFDx2KWtxxaPQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729715468; c=relaxed/simple;
	bh=tB8YjFRBHefXfMHdopyBr+6WJPVSg+zjwX4FEjBwhJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pqmZByGMTTVNFBgVskjzBCLAN5OhZaikZPwt0EvVryF2HHaZsj3Mn30sjTDL8/9BGZfl3ZQQFgn+Tyt2TNuHCophBZJ/PTDicumLvhHVeFIovUmhG+3RBdD31MUzdcKwRQOg4gt1QQY0LVTpgT6OW6dPOuRyofB8arMzGC5fuR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JBkiWHZT; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JBkiWHZT"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539f76a6f0dso192288e87.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 13:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729715465; x=1730320265; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ga5iUl1w2BkdYZ5rnWwUX+rnruTQCDzgYbSTQOQPjWI=;
        b=JBkiWHZT0PO3Faq5DFmittZgGzvmWzsLFSZa6rLZmgapeoZ30loYd3F2Ze9hVLnxeh
         E6i7ehKS0nyUBY1R9k4tU1LAXjy+R9tzsQRM6BitXM53S8QxGm4FP6vACeWPrm5PYqxF
         Q2ydIdygaxv+A1hX7Mb0B8Q+YMCCuqtxqQAYwBwzuXjjHXDbCgtrlemW1sVq5z+h4R/B
         3mp+ibZSggnZV6NLeX9voeFeEV8FHJFAQgXqtqkFlgmiVdlGYp+7ZTYv2q4oJgj1zkUq
         UezGx/QK/n1jMdZ/hqtTBWIYKRAu3U8G1x1kllbFRpzILtJ46w8mnGjv7FMs+X4hEyWf
         G83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729715465; x=1730320265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ga5iUl1w2BkdYZ5rnWwUX+rnruTQCDzgYbSTQOQPjWI=;
        b=CFTjd3n6WwPiUHwfE7IueF9tF60yMWz/1jTjRusrbNyu8JtXkoycQMl2kJn9FqLhPq
         iil1spFdhKy5GMA6PK6xq6Hn9PpDSXL7Y0td0cCzEtxgnbAp7zsvhDu5ijVScxdaL81Z
         +Ykk7rJtzmLtb/eSmadMBAahqt+N8Etko4DZUCnaPUfgF2YeKy2B4jefjXm81ldP5I1d
         nTqvBEGXLnrGvArilyMafEcB0U/Vyy1KNi/KmyJBDMoRZbVEaK3c9irJzJjJ3fh9Mjap
         Mo6AD4JrDgI4SZKSCyJynY/LGfrya712aBaEBacbEpZfI4vgHrcs3qEd8Fjlu57Lo/RX
         1IOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWF+pZWQ2+vH3h1aTmCejVS7I/N5OdDA6wpnlU6lRMfhvZNPranlAquvGX+v1Omqwek33VV2I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjPPDAx+qcsKDVXwROTKa14pUJ8zOdKdYHCJCQEJsUbEL5ZWTV
	PKYRHFN1qClHj8w3OnaB5e0gGUdFNiO55+M8z3Uhc89umld4yFQ0hTH6kB/+b1s452cFEUeh2nd
	sWhnY/gDnXhSe3VRmiQnSPweyZsXhT2P3X1Fa
X-Google-Smtp-Source: AGHT+IFOB5hl9xCTQi6KADVj+Ygz/KDWtgtceEAnJGc5F5DcfIsupKdCkMoYXTkWNpc4In12Fan0dWm/m/6oFWaM4OA=
X-Received: by 2002:a05:6512:308d:b0:539:f23b:59db with SMTP id
 2adb3069b0e04-53b1a2fb0b9mr2186529e87.5.1729715465274; Wed, 23 Oct 2024
 13:31:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704142319.728-1-jiangkunkun@huawei.com> <20240704142319.728-3-jiangkunkun@huawei.com>
In-Reply-To: <20240704142319.728-3-jiangkunkun@huawei.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 23 Oct 2024 13:30:54 -0700
Message-ID: <CAAdAUtgYzQe+G7nWuNLpOadGhC9XKQpoXt-He8cTyMHiUDLPVg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: vgic-its: Clear dte when mapd unmaps a device
To: Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric Auger <eauger@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	wanghaibin.wang@huawei.com, lishusen2@huawei.com, tangnianyao@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kunkun,

On Thu, Jul 4, 2024 at 7:23=E2=80=AFAM Kunkun Jiang <jiangkunkun@huawei.com=
> wrote:
>
> vgic_its_save_device_tables will traverse its->device_list to
> save dte for each device. vgic_its_restore_device_tables will
> traverse each entry of device table and check if it is valid.
> Restore if valid.
>
> But when mapd unmaps a devices, we do not invalidate the
type: devices -> device
> corresponding dte. In the scenario of continuous save
> and restore, there may be a situation where a device's dte
> is not saved but is restored. This is unreasonable and may
> cause restore to fail. This patch clears the corresponding
> dte when mapd unmaps a device.
>
> Co-developed-by: Shusen Li <lishusen2@huawei.com>
> Singed-off-by: Shusen Li <lishusen2@huawei.com>
typo: Signed
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 344bd8c20f67..223a5f1d6a3d 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -1140,8 +1140,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm=
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
> @@ -1161,8 +1162,17 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kv=
m, struct vgic_its *its,
>          * The spec does not say whether unmapping a not-mapped device
>          * is an error, so we are done in any case.
>          */
> -       if (!valid)
> +       if (!valid) {
> +               struct kvm *kvm =3D its->dev->kvm;
> +               int dte_esz =3D vgic_its_get_abi(its)->dte_esz;
> +               u64 val =3D 0;
> +
> +               if (KVM_BUG_ON(dte_esz !=3D sizeof(val), kvm))
> +                       return -EINVAL;
> +
> +               vgic_write_guest_lock(kvm, gpa, &val, dte_esz);
>                 return 0;
> +       }
>
>         device =3D vgic_its_alloc_device(its, device_id, itt_addr,
>                                        num_eventid_bits);
> --
> 2.27.0
>
>

Jing
