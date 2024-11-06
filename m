Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E38201104
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 18:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730917009; cv=none; b=Cvf1MTojFgxdOTbDCqpksQ9/18zQ2Nh5y1earEkE/I3zxTRPhK3oYKva2LBlCSz2Te/tV37L0MwzSRSiDkB1vsdZKThrDO/06DTTKP+RQ1E6BqutD/+QrzLxZpaLgULEzCc+anNpz+iC/34lT5Ec/ToCztbRwAet44kiX040MC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730917009; c=relaxed/simple;
	bh=akr2pHWvlpxX6Fg1IQ3TT51LBTF7P5k6M3NIk8ktde8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n4Uj1oZOF9/i4MhZIV3dUy1rIlalUYBnPtKPAw/B7wDTRJ+S0oPmaCKv9E74OHB+xaUkHZRt5+GVL33LHITyhmGezqEqktec/MvuNPeD9iI9Et9X4rb5LylRCvVUmQA10W48N38kjOQjUyXz0OAO+uswTD8qRg1MqBMSq/bMhXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OGwcJ4jJ; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OGwcJ4jJ"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539e8607c2aso4971e87.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Nov 2024 10:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730917005; x=1731521805; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeWA172BYFuvJUs17jk2BLJpPj+VSqEWSdhQr3Tt5lU=;
        b=OGwcJ4jJiIW4D8Hr9MHF1LqQaJr8OeNh/VwWDS/1m7o9OLMhWbzNjHDWt7Y/JCCQHn
         rMnf9yw2JznajbXRjdptoPRGHHg2fTTDmz6nKgTtPRVIu8dLvPudPxa47y+U1fKlxNrt
         V2TyouqONXXup130j4jJF4N2eODC6dtDji/U6n3CNZ2EIRM1aS30NSGPDHutRDZBkc2C
         ZMLuv3IRf4kS9bBTntrsYg72E3sUUTaZJxitoVKNdh4hOIgwNkH3N90z+7kZVJSfZC9K
         DExWgPb1SBsOSrravPcMsiXsxafMhCW+S8njzKo7rx605hgqaZhvJnJis/7JT8FPsy0f
         uFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730917005; x=1731521805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LeWA172BYFuvJUs17jk2BLJpPj+VSqEWSdhQr3Tt5lU=;
        b=qAAFqMtx5rc4pHIylUIQlaGXV7eLAEDmaXG/uuHUSbBZSEXS5Fc1kQ0z/ELruGVyY9
         2wMo3cWQZWPKbR8MsdT0aGH6wjHLEJNB4ZsUXvO3smWhT/TRB//n6SybZnT2Z6ZSE8Vh
         zvqtaxviYI5hTqvprxztCZnOs0gL/f6UFJcbqUEhhMmuw7Z0S613gEsIvK2Oz6qd5l1q
         AsKALq3VAyJKawCWR+BV0hp9d9UUJclK+9UMKlmFBiobmPGgNGUIgD2niukZvZtSwVV/
         VKY6e9f/cWL9ZSV4AOIwlUPG9J6+Z/bnHFlynslowYgj+Odgxws0IHk6qZRvUH92FZL1
         ovig==
X-Forwarded-Encrypted: i=1; AJvYcCXOSlPa+ujEStoJIyWOyCrQ242/TytONdfRbgmCR+2R5t/DYcES6ELpClaZX2rHh6qDu/el8IE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzzUw442zN5Gr6mIYIz1P6HlcW8BUNv3MIdaw9R8lubldR7KmMs
	za9MB95y7SmW1gu/kt+tJyL2COwvnJmqU9VbUs1/zjI5qSQUiqPNlDY2UeLzKkQSxHzIHqPMUgK
	jqEcRl6G6qnV9SSDAUIc0fac2+6ANcaRZB+Kf
X-Google-Smtp-Source: AGHT+IH0eyYrDiApka0FCPYt2gCEKlK4/mAq7uw29tSP1xJ7qJxDTSHGX9xhi6kEHhZbsrB00EH2FETbJzZH1P9TZow=
X-Received: by 2002:a05:6512:12c5:b0:539:e88f:23a1 with SMTP id
 2adb3069b0e04-53b3491c80emr21831365e87.44.1730917005120; Wed, 06 Nov 2024
 10:16:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
 <20241106083035.2813799-2-jingzhangos@google.com> <86cyj81sdl.wl-maz@kernel.org>
In-Reply-To: <86cyj81sdl.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 6 Nov 2024 10:16:33 -0800
Message-ID: <CAAdAUtgiWxhY6DQrS_B=6PhL3+V-qfJVSsqWWeVuGqW7DLcotw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
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

On Wed, Nov 6, 2024 at 4:03=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 06 Nov 2024 08:30:32 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > From: Kunkun Jiang <jiangkunkun@huawei.com>
> >
> > In all the vgic_its_save_*() functinos, they do not check whether
> > the data length is 8 bytes before calling vgic_write_guest_lock.
> > This patch adds the check. To prevent the kernel from being blown up
> > when the fault occurs, KVM_BUG_ON() is used. And the other BUG_ON()s
> > are replaced together.
> >
> > Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-=
its.c
> > index ba945ba78cc7..2381bc5ce544 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -2095,6 +2095,10 @@ static int vgic_its_save_ite(struct vgic_its *it=
s, struct its_device *dev,
> >              ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
> >               ite->collection->collection_id;
> >       val =3D cpu_to_le64(val);
> > +
> > +     if (KVM_BUG_ON(ite_esz !=3D sizeof(val), kvm))
> > +             return -EINVAL;
> > +
> >       return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
> >  }
> >
> > @@ -2250,6 +2254,10 @@ static int vgic_its_save_dte(struct vgic_its *it=
s, struct its_device *dev,
> >              (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
> >               (dev->num_eventid_bits - 1));
> >       val =3D cpu_to_le64(val);
> > +
> > +     if (KVM_BUG_ON(dte_esz !=3D sizeof(val), kvm))
> > +             return -EINVAL;
> > +
> >       return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
> >  }
> >
> > @@ -2431,12 +2439,17 @@ static int vgic_its_save_cte(struct vgic_its *i=
ts,
> >                            struct its_collection *collection,
> >                            gpa_t gpa, int esz)
> >  {
> > +     struct kvm *kvm =3D its->dev->kvm;
>
> nit: just use its->dev->kvm consistently, as this is what we are
> already doing in this function.

Sure. Will do.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
