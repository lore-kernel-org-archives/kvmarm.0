Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA081BE49
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 03:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707795593; cv=none; b=QXKuSoKNw/IxORwOO5+wg9eJVcD5zj2HrDlchFHsCtefvo2xXC4f4lqocnJ7UhpkUS46oeScMTIZM98UzgjFvmr4l6XUvRzrX+D26kx1MA6IYt5Th5xY7SqNy3NiCchiPnWiEtWqPHfo2w1qbOylZQcLdj8dhBlkyRoRahFMxWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707795593; c=relaxed/simple;
	bh=5+qYZYJemzYwmTCaksNFbQuIKvJDzxrLlD2bZz/R0H8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cVDxj2mAm0EptzbKumj1iFAPWV4My0WsU34lx7RKbhGjbuGxmc8NJPBTNjQ8cii4obmLGBUeZlCxbEdyZdssB+iccPPpV/jvdr5JBimWBllprb0yalYAqYJ2W68lI5ZFIBdQhNV0XzUv8p5iNL3hif7qTQg97me7CDFTxyUPRMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m2uUeIC2; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m2uUeIC2"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e0e690a604so1220999b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 19:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707795591; x=1708400391; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RA6zNvnSFSM19FK25XmCjdxkJlEdzHYrL47jTvjMoZg=;
        b=m2uUeIC2nlDNjMJ1zLoQEpKIqqjc5422WmGkMizVSleqznR1MNCLyhYoXv7C07SzsL
         BL9dKqN0WUrwNOzDMaSflF1+7Y0CehATfI31oGM/R2VDVLon0dizIPgl3BgCuiViAcDc
         SR/4DCPJk0aMiu3d7WeS02AC5igF0BvLtuLu92AlZkWI++1jbDkciet6zZ3eo4T5ItPq
         3S6U/bglJs4RPNIxyfamTOP0wnUeEelwsymm+pX+mWNBJQh+oPi1PAC8NQG2OVPVWn7+
         3cF5+b72KbrsVKScUhw4rsdmUNDxXSPYMgRDMjgYozQsHIxJ+66OlvGe0iJarH4kxaNI
         JHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707795591; x=1708400391;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RA6zNvnSFSM19FK25XmCjdxkJlEdzHYrL47jTvjMoZg=;
        b=b/J5VJo3dDv8/CDYsDpQHaamI8qHrT6LVkHrNtYXoDpadvGjz5euWJqCMKpM602XY3
         RDUT+ETW4BWWsCdbo2NJh0OW3rIlwQw+wCBmXI3GyjMCdyhT7rAYKVhXgYOKrPEN6/kc
         z0QnjOi28+wtGUics/v16sx7k5TVK5IiDrMbww3Ub8iHCrA++wV2H/OqXibg8fdmAscC
         BMkFhjfMYGe4c0rA75P06KeJyjT0uqd/VAUNbgjBAmHUagk3qtxIOIFeEQoPrI19H4Pa
         06Nu12YliQzHUlKFWYS4JUjwaQaslW5aovtgF5bifdA88k7sl4B8scpW0UyA/FF8xfFR
         qKIA==
X-Gm-Message-State: AOJu0Yw74FtCnEbi7UqovW3H2sPmBtG+H32DAIuQ8SvtuK596d8xYJb0
	i9i0hzaEV1adW0+JnAo/jdjN7jedGO0dpXrOvsduEHnqtEfW4zR8FollYhqZoszuJiQUd21XUTk
	4nA==
X-Google-Smtp-Source: AGHT+IEVp/50JegG3InAOxeb5TGvnesSNFGJiZW76v1yp1CrU8i9BBgmf4sz3sT9bQH82+Mrt5/Bh9zaKk0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d2a:b0:6e0:e2f8:cf40 with SMTP id
 fa42-20020a056a002d2a00b006e0e2f8cf40mr175477pfb.0.1707795591087; Mon, 12 Feb
 2024 19:39:51 -0800 (PST)
Date: Mon, 12 Feb 2024 19:39:49 -0800
In-Reply-To: <ZcGn0t3l8OCL5mv6@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
 <ZUEPn_nIoE-gLspp@google.com> <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
 <ZYJFPoFYkp4xajRO@google.com> <ZcGn0t3l8OCL5mv6@google.com>
Message-ID: <ZcrkhTn1Da5-vND2@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 05, 2024, Sean Christopherson wrote:
> On Tue, Dec 19, 2023, Sean Christopherson wrote:
> > On Tue, Dec 12, 2023, David Stevens wrote:
> > > On Tue, Oct 31, 2023 at 11:30=E2=80=AFPM Sean Christopherson <seanjc@=
google.com> wrote:
> > > >
> > > > On Tue, Oct 31, 2023, David Stevens wrote:
> > > > > Sean, have you been waiting for a new patch series with responses=
 to
> > > > > Maxim's comments? I'm not really familiar with kernel contributio=
n
> > > > > etiquette, but I was hoping to get your feedback before spending =
the
> > > > > time to put together another patch series.
> > > >
> > > > No, I'm working my way back toward it.  The guest_memfd series took=
 precedence
> > > > over everything that I wasn't confident would land in 6.7, i.e. lar=
ger series
> > > > effectively got put on the back burner.  Sorry :-(
> > >=20
> > > Is this series something that may be able to make it into 6.8 or 6.9?
> >=20
> > 6.8 isn't realistic.  Between LPC, vacation, and non-upstream stuff, I'=
ve done
> > frustratingly little code review since early November.  Sorry :-(
> >=20
> > I haven't paged this series back into memory, so take this with a grain=
 of salt,
> > but IIRC there was nothing that would block this from landing in 6.9.  =
Timing will
> > likely be tight though, especially for getting testing on all architect=
ures.
>=20
> I did a quick-ish pass today.  If you can hold off on v10 until later thi=
s week,
> I'll try to take a more in-depth look by EOD Thursday.

So I took a "deeper" look, but honestly it wasn't really any more in-depth =
than
the previous look.  I think I was somewhat surprised at the relatively smal=
l amount
of churn this ended up requiring.

Anywho, no major complaints.  This might be fodder for 6.9?  Maybe.  It'll =
be
tight.  At the very least though, I expect to shove v10 in a branch and sta=
rt
beating on it in anticipation of landing it no later than 6.10.

One question though: what happened to the !FOLL_GET logic in kvm_follow_ref=
counted_pfn()?

In a previous version, I suggested:

  static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
                                             struct page *page)
  {
       kvm_pfn_t pfn =3D page_to_pfn(page);

       foll->is_refcounted_page =3D true;

       /*
        * FIXME: Ideally, KVM wouldn't pass FOLL_GET to gup() when the call=
er
        * doesn't want to grab a reference, but gup() doesn't support getti=
ng
        * just the pfn, i.e. FOLL_GET is effectively mandatory.  If that ev=
er
        * changes, drop this and simply don't pass FOLL_GET to gup().
        */
       if (!(foll->flags & FOLL_GET))
               put_page(page);

       return pfn;
  }

but in v9 it's simply:

  static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
					     struct page *page)
  {
	kvm_pfn_t pfn =3D page_to_pfn(page);

	foll->is_refcounted_page =3D true;
	return pfn;
  }

And instead the x86 page fault handlers manually drop the reference.  Why i=
s that?
