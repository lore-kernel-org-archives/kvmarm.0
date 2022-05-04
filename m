Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8DDC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 16:39:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53ADA4B120;
	Wed,  4 May 2022 12:39:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DgXtLBjAQ63S; Wed,  4 May 2022 12:39:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEEAC4B137;
	Wed,  4 May 2022 12:39:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4AD4B12C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 12:39:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yE5zz58KSlRz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 12:39:30 -0400 (EDT)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 207234B120
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 12:39:30 -0400 (EDT)
Received: by mail-pl1-f178.google.com with SMTP id i17so1879100pla.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 May 2022 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=m1io7k35g0XkxBE66aLJmCdfAolmvIrbMMfT0zopegk=;
 b=NLb2jf/Au5xzZ7oXie6CwJZPh2AlRsupNDu2fSb1lWW/BldJTRHdf+XcKva/rpFWTT
 91pmoaVlPGdWS9TezpYbWPv/Xkq3T903F1K1828RMOkEVK6DwrQJqSChuGoQgpSK5DH2
 nBZUo/muE6yWD3J6Gj2FCBSNbV5YboygeEbAjtEJKu5elGxXLW62ml+JUIcWM0yUoIom
 0vauUwCpaYPYucnNCJZLfKZkZ4NVx6V+qT4RovPsdM6YuIq4Mjpd+G6+BvP/dSOa4tZV
 fNwijU/J8STzHJGfUwB5RqR30kEqVh/G/wtaEf+I2kSsgXJ8XfxN0ZrIK+tWandqhbEC
 Ihaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=m1io7k35g0XkxBE66aLJmCdfAolmvIrbMMfT0zopegk=;
 b=O5f+AW8Qln72DLQ+Fx4ESoWKGPqChIMT3o7AVLIgh4XCTbtO74scVLRpdaasrl0Tam
 KFes+tkn+WfaylKz6YgMbjxN0qOtX30gDLLhxrZPl35hN11zQphBjlEjLm1vJwr8qZIc
 HnXW/wgX9SVFtzKlJzTK7KmokfkvWY1dGgiNojgCWMx0vBObAxIkufpyhj+QNmLWZAPF
 heNbII/gc9+YVTrL5lKGrCqOU8mBWzW4OgTCk5UWgkObnqZwe/IEu+NjWOoojaL4U8HO
 retl1YTsnl/5OHv8C7SiR8qJnKcXoSfHQ3lVeVJYngqzZ5cO33blKOSWrsAkpWJv+kKY
 evzw==
X-Gm-Message-State: AOAM533ystNvZwq4VePnGvaoN7L1Ww00OezRml1TtqmJadL9YudjUShV
 y+PxpgFk8BCt3krlXYHjudP7CA==
X-Google-Smtp-Source: ABdhPJwrGW7n1baZfamUHku5h2p2HjtP2KsLnmxX+a/cSxQ3eqCQQFzgZdqdKZBpyvIEx9EZY+vziw==
X-Received: by 2002:a17:90b:1b47:b0:1dc:3c0a:dde3 with SMTP id
 nv7-20020a17090b1b4700b001dc3c0adde3mr389278pjb.52.1651682368881; 
 Wed, 04 May 2022 09:39:28 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 d5-20020a17090ae28500b001d960eaed66sm3499510pjz.42.2022.05.04.09.39.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 May 2022 09:39:27 -0700 (PDT)
Date: Wed, 4 May 2022 09:39:24 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic: Check that new ITEs could be
 saved in guest memory
Message-ID: <YnKsPFnQCcEpX0qC@google.com>
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-2-ricarkol@google.com>
 <da752e67-1fff-e27f-bcaf-e29aaa536532@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <da752e67-1fff-e27f-bcaf-e29aaa536532@redhat.com>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, pshier@google.com,
 maz@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, May 03, 2022 at 07:14:24PM +0200, Eric Auger wrote:
> Hi Ricardo,
> =

> On 4/27/22 20:48, Ricardo Koller wrote:
> > Try to improve the predictability of ITS save/restores by failing
> > commands that would lead to failed saves. More specifically, fail any
> > command that adds an entry into an ITS table that is not in guest
> > memory, which would otherwise lead to a failed ITS save ioctl. There
> > are already checks for collection and device entries, but not for
> > ITEs.  Add the corresponding check for the ITT when adding ITEs.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 51 ++++++++++++++++++++++++----------
> >  1 file changed, 37 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-=
its.c
> > index 2e13402be3bd..e14790750958 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -894,6 +894,18 @@ static int vgic_its_cmd_handle_movi(struct kvm *kv=
m, struct vgic_its *its,
> >  	return update_affinity(ite->irq, vcpu);
> >  }
> >  =

> > +static bool __is_visible_gfn_locked(struct vgic_its *its, gpa_t gpa)
> > +{
> > +	gfn_t gfn =3D gpa >> PAGE_SHIFT;
> > +	int idx;
> > +	bool ret;
> > +
> > +	idx =3D srcu_read_lock(&its->dev->kvm->srcu);
> > +	ret =3D kvm_is_visible_gfn(its->dev->kvm, gfn);
> > +	srcu_read_unlock(&its->dev->kvm->srcu, idx);
> > +	return ret;
> > +}
> > +
> >  /*
> >   * Check whether an ID can be stored into the corresponding guest tabl=
e.
> >   * For a direct table this is pretty easy, but gets a bit nasty for
> > @@ -908,9 +920,7 @@ static bool vgic_its_check_id(struct vgic_its *its,=
 u64 baser, u32 id,
> >  	u64 indirect_ptr, type =3D GITS_BASER_TYPE(baser);
> >  	phys_addr_t base =3D GITS_BASER_ADDR_48_to_52(baser);
> >  	int esz =3D GITS_BASER_ENTRY_SIZE(baser);
> > -	int index, idx;
> > -	gfn_t gfn;
> > -	bool ret;
> > +	int index;
> >  =

> >  	switch (type) {
> >  	case GITS_BASER_TYPE_DEVICE:
> > @@ -933,12 +943,11 @@ static bool vgic_its_check_id(struct vgic_its *it=
s, u64 baser, u32 id,
> >  			return false;
> >  =

> >  		addr =3D base + id * esz;
> > -		gfn =3D addr >> PAGE_SHIFT;
> >  =

> >  		if (eaddr)
> >  			*eaddr =3D addr;
> >  =

> > -		goto out;
> > +		return __is_visible_gfn_locked(its, addr);
> >  	}
> >  =

> >  	/* calculate and check the index into the 1st level */
> > @@ -964,16 +973,30 @@ static bool vgic_its_check_id(struct vgic_its *it=
s, u64 baser, u32 id,
> >  	/* Find the address of the actual entry */
> >  	index =3D id % (SZ_64K / esz);
> >  	indirect_ptr +=3D index * esz;
> > -	gfn =3D indirect_ptr >> PAGE_SHIFT;
> >  =

> >  	if (eaddr)
> >  		*eaddr =3D indirect_ptr;
> >  =

> > -out:
> > -	idx =3D srcu_read_lock(&its->dev->kvm->srcu);
> > -	ret =3D kvm_is_visible_gfn(its->dev->kvm, gfn);
> > -	srcu_read_unlock(&its->dev->kvm->srcu, idx);
> > -	return ret;
> > +	return __is_visible_gfn_locked(its, indirect_ptr);
> > +}
> > +
> > +/*
> > + * Check whether an event ID can be stored in the corresponding Interr=
upt
> > + * Translation Table, which starts at device->itt_addr.
> > + */
> > +static bool vgic_its_check_event_id(struct vgic_its *its, struct its_d=
evice *device,
> > +		u32 event_id)
> > +{
> > +	const struct vgic_its_abi *abi =3D vgic_its_get_abi(its);
> > +	int ite_esz =3D abi->ite_esz;
> > +	gpa_t gpa;
> > +
> > +	/* max table size is: BIT_ULL(device->num_eventid_bits) * ite_esz */
> > +	if (event_id >=3D BIT_ULL(device->num_eventid_bits))
> > +		return false;
> > +
> > +	gpa =3D device->itt_addr + event_id * ite_esz;
> > +	return __is_visible_gfn_locked(its, gpa);
> >  }
> >  =

> >  static int vgic_its_alloc_collection(struct vgic_its *its,
> > @@ -1061,9 +1084,6 @@ static int vgic_its_cmd_handle_mapi(struct kvm *k=
vm, struct vgic_its *its,
> >  	if (!device)
> >  		return E_ITS_MAPTI_UNMAPPED_DEVICE;
> >  =

> > -	if (event_id >=3D BIT_ULL(device->num_eventid_bits))
> > -		return E_ITS_MAPTI_ID_OOR;
> I would put
> =A0=A0=A0 if (!vgic_its_check_event_id(its, device, event_id))
> =A0=A0 =A0=A0=A0=A0 return E_ITS_MAPTI_ID_OOR;
> here instead of after since if the evend_id not correct, no use to look
> the ite for instance.

Thanks Eric. Will fix in v2.

> > -
> >  	if (its_cmd_get_command(its_cmd) =3D=3D GITS_CMD_MAPTI)
> >  		lpi_nr =3D its_cmd_get_physical_id(its_cmd);
> >  	else
> > @@ -1076,6 +1096,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *k=
vm, struct vgic_its *its,
> >  	if (find_ite(its, device_id, event_id))
> >  		return 0;
> >  =

> > +	if (!vgic_its_check_event_id(its, device, event_id))
> > +		return E_ITS_MAPTI_ID_OOR;
> > +
> >  	collection =3D find_collection(its, coll_id);
> >  	if (!collection) {
> >  		int ret =3D vgic_its_alloc_collection(its, &collection, coll_id);
> Besides look good to me
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> =

> Eric
> =

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
