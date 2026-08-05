Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57214409624
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 10:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785926986; cv=none; b=i2XYsCAAw88WnoYLC96Ml/Ft2u7z+K2vGk8CNyMvO0M4246KqkDfwgDCTEForblwojrWVGGXDgJZPaLl54WDcq0ecc+2FRF9foom0j5Svpn9yKCY/HKd7562Pv2cfmgAB2FZIb6p0j8J7YkIw37Oiexmz2b2TiuqrrxhYF7AXyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785926986; c=relaxed/simple;
	bh=HJgrN+baPIB54fPh+3N6hGUBcXC6EBE5fl+F6gyH+mM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bW134S3jlT+66/mfFt1K2a3Lsqn+8Z/s3nJQwjicGO77uhu5QttBHmSDCw+BnDIRf3i2XrnAgGuKgl3E+6RDMsJzS1innB7oWbGry22T5wizlffsUrIi6OUuoyGEbE5b+FgKJodn8T68S2Q5dHoxrVmfw9f9RZVHZMoYptptkxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UxqSlKb4; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UxqSlKb4"
X-Forwarded-Encrypted: i=1; AHgh+RohbSiDa14yBd96Ubodg2ujcDmgckVUy6vLY/Lnf+dAKDfQHWGDQNUeGQmJ3U54Xhnp4fuNF6A=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785926982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oz73Vxs80Yl5zg+diatiLy3lqHxN3wXu0wim3VnpUzU=;
	b=UxqSlKb4VE8M41K0kwCD8eCZrBfpRzMMFiPNp3CvPilZ2efJerPivUJLZ8TKd9kFMgGQ8W
	JnFbqJ2Cj8+P0sDiS70AF55FhtM7muvO0Vvk/pbt7eQzg2b6Fv4jGbAf+LW7ObIAs/gYUW
	5DMXfIpbBUMYqPpI1vhTFEefoYtMZGk=
X-Gm-Message-State: AOJu0YxAFSDMel3/ZkjIuRblsspmgsCb155nvQI/DsvDxVe8wiA0Fr6n
	dnoFlTp2rTf78JgnlL5jYAr52rwnXfpVRAkGbywF0c5iC/cHLpZxVa8VxUT59ZCcFQTyLNJY0Tm
	r6iktAifW65DJQF4wqKydhjwQw+hwHObT7uMlFJvU
X-Received: by 2002:a05:622a:9018:b0:517:5ac7:332e with SMTP id
 d75a77b69052e-52ce6ac5642mr19867781cf.6.1785926966008; Wed, 05 Aug 2026
 03:49:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260805093828.3626610-1-fuad.tabba@linux.dev>
 <20260805093828.3626610-4-fuad.tabba@linux.dev> <20260805095501.8E1461F000E9@smtp.kernel.org>
In-Reply-To: <20260805095501.8E1461F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 5 Aug 2026 11:49:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxuYLBwNsDnZd4B_jYWBDvGxXMWSDKPiMqjJjdCMYySaw@mail.gmail.com>
X-Gm-Features: AUfX_mzBMj9eSkHC0H-S_h_bqwmtqKM3Q89lGFKzHUk77W8cW2q1jAr85vg7aj8
Message-ID: <CA+EHjTxuYLBwNsDnZd4B_jYWBDvGxXMWSDKPiMqjJjdCMYySaw@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: vgic-its: Don't write past the end of the
 collection table
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Sashiko my good LLM friend,

On Wed, 5 Aug 2026 at 10:55, <sashiko-bot@kernel.org> wrote:
...
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-=
its.c
> > index ed281fbf008b9..c709fc5e17cda 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -2540,6 +2540,9 @@ static int vgic_its_save_collection_table(struct =
vgic_its *its)
> >       max_size =3D GITS_BASER_NR_PAGES(baser) * SZ_64K;
> >
> >       list_for_each_entry(collection, &its->collection_list, coll_list)=
 {
> > +             if (filled =3D=3D max_size)
> > +                     return -EINVAL;
> > +
> >               ret =3D vgic_its_save_cte(its, collection, gpa);
>
> [Severity: Medium]
> This is a pre-existing issue, but does this code save collections with ID=
s
> that exceed the current GITS_BASER size?
>
> If a guest maps a collection with a large ID, and then shrinks the table =
size
> in GITS_BASER while keeping VALID=3D1, the collection list isn't freed. S=
ince
> the total number of mapped collections might still be small enough to pas=
s the
> filled =3D=3D max_size check, it appears the collection with the large ID=
 will
> be successfully saved here.
>
> On the destination side, when vgic_its_restore_cte() reads this entry, it
> calls vgic_its_check_id() which checks the ID against the shrunken bounda=
ries,
> returning -EINVAL and failing the migration.

You're right, vgic_its_check_id() validates the collection ID against
both the 16-bit maximum and the current table capacity, so it's the
better check here:

+        if (!vgic_its_check_id(its, baser, collection->collection_id, NULL=
))
+            return -EINVAL;

This also bounds the walk, and the filled =3D=3D max_size check can go.
I'll switch to it in the respin.

Cheers,
/fuad

>
> Should this path also validate the collection ID against the current tabl=
e
> size, similar to how vgic_its_save_device_tables() uses vgic_its_check_id=
()?
>
> >               if (ret)
> >                       return ret;
> >               gpa +=3D cte_esz;
> >               filled +=3D cte_esz;
> >       }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805093828.36=
26610-1-fuad.tabba@linux.dev?part=3D3
