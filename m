Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3947714EC62
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 20:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729715099; cv=none; b=FInAy9xj6CfAWe10MknJgTxCtaj6V9sAI6HKSYgO7zkjla7J6YoLiqWHzGe58MltIne/XjNUZ/x8heNTx6GfzyL1cNfDzRJSPPEudmqKA4RDMa+pzs6+XhCFW/cY9bfCMexIG5GmfpzQuUYz2UB1HIYI74GzjjX0PAjQtdgbSWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729715099; c=relaxed/simple;
	bh=EJAfJDQUv69BScwPP7hNV7TwNqik9leF1T6f5RraUUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kY2NBDuUnAS110WKDlzIIKw+bAd//Bm5WSoYkjoxCDE3VBKDfol7krQ+u4DvZ1QDWOhayR00imfrYJDSYGucGg280NgqaTCaJuDTslka3lzusFJqgJLhETudatuX/+yalBCc646XsjsHM3GMmDRj7rcm2AQiAnbZhm7xUrjeLMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oMrjBwTY; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oMrjBwTY"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539f4d8ef84so197096e87.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 13:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729715096; x=1730319896; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/J5U+OF3K0AErChj6IORznXj9y2ILqqHHrJf2bXcts=;
        b=oMrjBwTYr1HTkd2PlcQ1oyDfY8dfV0fcwcPSFkfAH9FnI71XzMkTxSuy2YJVkFKVKE
         aiVDq5GlvS7i8skbN041yZMJxXEMVH5dq26EMO8uQrohCg9xvGVOy9IEK7ux2YDbABWM
         rbpKI/ba8D/0JOk8XrU7EjsuCJLsf2ZXbwBDhMEGBCuT+5JNCpNC9j15xuWeIjXiT2xY
         m0sLuKnD2w4NsKqbB2uyKbLl2cNp0T8/DbRdyfmGUIK5y54PGpm2cUbiIlZJWYQPtkFe
         Rqu5SrwaB0jOyh98aAStzJhWa6BYUsEYrVX2LIZTrvib78nj35aD/qnRI6F/sownnNZ1
         JYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729715096; x=1730319896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/J5U+OF3K0AErChj6IORznXj9y2ILqqHHrJf2bXcts=;
        b=VEYK/hzQbuQapC9rURQWXCgoDm77HducmQfePLXifE9/iqcbo8xCBLrNOsuAWzd4aM
         oasfE74Z04HO5LHcZ7Dj1urRqTdhED50pOWNEB/vvfAaGNZ1afGft5cQM2gfuZFW9D1g
         8KHK4SC73emgRs9SrZMih1WsqQUn0bP1P2ZiM/5x669jXXcRWgmPwujRa2Qi4okZaprk
         huzNOvSa0o4a7l1uVCIWfM+cvjsk+7sXIfMbBjczDACMuPEiC6431Gl1OWvPGOIkqGJ3
         d3aPn8GXlOpBV8mUbCjXX9u58TR91TQ0HPG9eX1QmJc/hbpeeMiyxz1gBuV4RGLfwqKg
         EoYg==
X-Forwarded-Encrypted: i=1; AJvYcCV8Hqhzx0qZuQCV/f/QKNpPJzwUht3Wg/hRFiN4B7HDBtcmPybV9OexzxPeP580AahrrwKJUaY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVenG5Zgba4fDZk1BlfRAm2NAcwvHwpdzUMojm/PryhNV472rs
	wIV1S4XewOWT89Mmo5vV83+xLMSjUBNwsGvCgfSKjDpozSCkFazdi2Qlf27P8TkNflTZfxVFYEz
	QHScG8RqKupo6SYf6xxvPPSd/E4hNdZFspq5t
X-Google-Smtp-Source: AGHT+IHSCllmfqejwDRgdq9fg0cwSTgDHJ9uCrH0pP5pEKEvOyQTqWtxF24V69vdYn/lXl2ijuB2u9hDFq2MvYh8EMA=
X-Received: by 2002:a05:6512:1246:b0:536:9f72:c427 with SMTP id
 2adb3069b0e04-53b1a343cfamr1983190e87.28.1729715096162; Wed, 23 Oct 2024
 13:24:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704142319.728-1-jiangkunkun@huawei.com> <20240704142319.728-2-jiangkunkun@huawei.com>
In-Reply-To: <20240704142319.728-2-jiangkunkun@huawei.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 23 Oct 2024 13:24:45 -0700
Message-ID: <CAAdAUtjOMtE-f6L1YZn339MPSUtVHm72cT+F-vDLT2bXJ+HNtQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
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
> In all the vgic_its_save_*() functinos, it does not check whether
typo: functions
> the data length is 8 bytes before calling vgic_write_guest_lock.
> This patch add the check. To prevent the kernel from being blown up
typo: adds
> when the fault occurs, KVM_BUG_ON() is used. And the other BUG_ON()'s
> are replaced together.
>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 40bb43f20bf3..344bd8c20f67 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2094,6 +2094,10 @@ static int vgic_its_save_ite(struct vgic_its *its,=
 struct its_device *dev,
>                ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
>                 ite->collection->collection_id;
>         val =3D cpu_to_le64(val);
> +
> +       if (KVM_BUG_ON(ite_esz !=3D sizeof(val), kvm))
> +               return -EINVAL;
> +
>         return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
>  }
>
> @@ -2246,6 +2250,10 @@ static int vgic_its_save_dte(struct vgic_its *its,=
 struct its_device *dev,
>                (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
>                 (dev->num_eventid_bits - 1));
>         val =3D cpu_to_le64(val);
> +
> +       if (KVM_BUG_ON(dte_esz !=3D sizeof(val), kvm))
> +               return -EINVAL;
> +
>         return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
>  }
>
> @@ -2427,12 +2435,17 @@ static int vgic_its_save_cte(struct vgic_its *its=
,
>                              struct its_collection *collection,
>                              gpa_t gpa, int esz)
>  {
> +       struct kvm *kvm =3D its->dev->kvm;
>         u64 val;
>
>         val =3D (1ULL << KVM_ITS_CTE_VALID_SHIFT |
>                ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT)=
 |
>                collection->collection_id);
>         val =3D cpu_to_le64(val);
> +
> +       if (KVM_BUG_ON(esz !=3D sizeof(val), kvm))
> +               return -EINVAL;
> +
>         return vgic_write_guest_lock(its->dev->kvm, gpa, &val, esz);
>  }
>
> @@ -2449,7 +2462,9 @@ static int vgic_its_restore_cte(struct vgic_its *it=
s, gpa_t gpa, int esz)
>         u64 val;
>         int ret;
>
> -       BUG_ON(esz > sizeof(val));
> +       if (KVM_BUG_ON(esz !=3D sizeof(val), kvm))
> +               return -EINVAL;
> +
>         ret =3D kvm_read_guest_lock(kvm, gpa, &val, esz);
>         if (ret)
>                 return ret;
> @@ -2513,7 +2528,9 @@ static int vgic_its_save_collection_table(struct vg=
ic_its *its)
>          * with valid bit unset
>          */
>         val =3D 0;
> -       BUG_ON(cte_esz > sizeof(val));
> +       if (KVM_BUG_ON(cte_esz !=3D sizeof(val), its->dev->kvm))
> +               return -EINVAL;
> +
>         ret =3D vgic_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
>         return ret;
>  }
> --
> 2.27.0
>
>

Jing
