Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3902D3ADB94
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 07:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297894; cv=none; b=DFHZQgZ5vr9h2UXW5a0HlU6IgGL/w+3UqDqzQjGuZCpyLb6ST5C12jSYr9+ycBIKBFSvImCOuhvH+2/u3GHrEYLvuQAwcBXWx8d0+HetKmlF55ZI7gZbAph2Y909pX+gBAJox6UseE+moUi0ARpetAc0h7kPhN9bTa82i4X4xpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297894; c=relaxed/simple;
	bh=yah7MrKK7PNquSWPJQDCIwVZ2JPFu1xOp+2NvgehUVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JIwAmIf1TYeU19aLDbi+vQNFNKs96OU5MkcrlDgzIbneMXouv1ifXyeE9oq8K7dtQZWj2vg+3YBN1NbSA+RpESNx398BfUtWq6++SD8H+gKME2oLxXheH09JMy2TAuw7j5YwBEgtVp/IpAsTjmf5quuL9qgR1S/oT1aJKv0WseE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rs+2PKOQ; arc=none smtp.client-ip=95.215.58.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rs+2PKOQ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yah7MrKK7PNquSWPJQDCIwVZ2JPFu1xOp+2NvgehUVA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787297883; v=1; x=1787902683;
 b=Rs+2PKOQxiDadgUV9kvGaGCORRX+fL7ovwXQOqiVPB4+++j8/9qzNbGyVyxTPgEH4/LeDppA
 PtvaYwfO1sKRClj3hVvbxhS3rDiyjI38ldnFuC5T3R2NTAKMKmSe8IIunL31E43eoAzlvhm23QB
 i9F0QXEW8Yr2W16JVZ5cyeM8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f50.google.com (209.85.167.50)
	by smtp.migadu.com with ESMTPS id 3b3adeaa624c651a;
	Fri, 21 Aug 2026 07:38:03 +0000
X-Mizu-Trace-ID: 3b3adeaa624c651a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a8173142so3380e87.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 00:38:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoLk864wHS7/HLAM/rF+rxnzIfiJucgGAvbbMGsn1fMVYdfD9ET7uejHWDUzOJGwh77b80+5kk=@lists.linux.dev
X-Gm-Message-State: AFuF++nRNK+r2Mb2QtVSDN3PFbw7eIctSUDDixjYFVmpVP44XLDGE1k9
	WK7yToJvd5fZp6X7oHPwhBrEzudw1Ygsjy4/RhwACPZzeh8LtTkGelxIzGE9b6M06NiJqCLCi8c
	wDzq6NCQlEx/+qan7D0qRfHUqzjgkI3oRA/CYneYS
X-Received: by 2002:a05:6512:ba3:b0:5b2:8963:e5d4 with SMTP id
 2adb3069b0e04-5b484abe418mr132544e87.5.1787297880970; Fri, 21 Aug 2026
 00:38:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260821064445.615838-1-fuad.tabba@linux.dev> <20260821064445.615838-2-fuad.tabba@linux.dev>
 <20260821065743.3563C1F000E9@smtp.kernel.org>
In-Reply-To: <20260821065743.3563C1F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 21 Aug 2026 08:37:24 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy6Qb8dv_apBg4RVU+V-LsP1Z+BkDYfRKLX0f6PnbKpeg@mail.gmail.com>
X-Gm-Features: AcwNN1V3Jgp2N0wWKRNXl0kP7pIhBFQl-DudY3Ff6wk0kH-wghLTEWnL5baySig
Message-ID: <CA+EHjTy6Qb8dv_apBg4RVU+V-LsP1Z+BkDYfRKLX0f6PnbKpeg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic-its: Free the caches when
 GITS_BASER changes
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sashiko, this one is real.

On Fri, 21 Aug 2026 at 07:57, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Pre-existing race condition in ITS MMIO handler allows MSI injec=
tion while ITS is disabled due to a stale translation cache entry.
> --
>
> --- Patch [1]: [PATCH v2 1/4] KVM: arm64: vgic-its: Free the caches when =
GITS_BASER changes ---
> commit 98c89973da07ed23e9bd8348bfd2cf61333c4e66
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
>
> A guest that disables the ITS and changes GITS_BASER<n> with VALID still =
set
> keeps the mapped devices and collections. This patch frees the list and
> drops the translation cache whenever the stored value changes.
>
> Link: https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/
>
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-=
its.c
> > index 9e782a4fea7e5..ab89b0138efd0 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
>
> [ ... ]
>
> > @@ -1702,6 +1705,8 @@ static void vgic_mmio_write_its_baser(struct kvm =
*kvm,
> >                       vgic_its_free_collection_list(kvm, its);
> >                       break;
> >               }
> > +             /* A concurrent injection may have cached a translation. =
*/
> > +             vgic_its_invalidate_cache(its);
>
> [Severity: High]
> This is a pre-existing issue, but the commit message explicitly notes tha=
t
> an injection can still cache an entry after the ITS is disabled.
>
> Is it possible for a subsequent MSI to trigger an unexpected LPI injectio=
n?

Yes, and it violates the spec: with GITS_CTLR.Enabled =3D=3D 0 writes to
GITS_TRANSLATER are ignored, so nothing should be injected.

It was reported in June [1] and is being worked on.

Cheers,
/fuad

[1] https://lore.kernel.org/all/ah6Lsi4MfKUU6wBR@v4bel/

>
> If Thread 1 (e.g. irqfd) calls vgic_its_inject_msi(), takes its_lock, and
> enters vgic_its_resolve_lpi() in arch/arm64/kvm/vgic/vgic-its.c, it reads
> its->enabled as true.
>
> If Thread 2 (guest vCPU) concurrently disables the ITS via
> vgic_mmio_write_its_ctlr(), it acquires cmd_lock (but not its_lock), sets
> its->enabled to false, and clears the cache.
>
> Thread 1 could then resume, finish resolving the LPI, and call
> vgic_its_cache_translation() to insert the entry into the cache, ignoring=
 the
> fact that its->enabled is now false.
>
> A subsequent MSI would then hit vgic_its_inject_cached_translation(), whi=
ch
> does a fast-path lookup without checking its->enabled, successfully injec=
ting
> the MSI.
>
> Could this violate the GICv3 specification by delivering LPIs while the I=
TS
> is explicitly disabled, potentially crashing a guest OS during kexec?
>
> >               mutex_unlock(&its->its_lock);
> >       }
> >  }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821064445.61=
5838-1-fuad.tabba@linux.dev?part=3D1
