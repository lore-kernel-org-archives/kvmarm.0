Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F78C132C1F
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713290836; cv=none; b=r/aWsuWtR/sSS15UG1N7r3JcE9EHw3w8rTkcZG76hQDGgHgjLf94ySm38F5se0DebzbTy/hGJIjhn1pUrkrl5QYu0iwHwWkKMp9ZxHtvYjk97qfPx2UEwxaqKZjYH5cMjO8XZmz5CJaLt6IKOYmPfFdVXf6Kt4azd9qph3ASzpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713290836; c=relaxed/simple;
	bh=/LlGT6GqHaBxjeUxYhV24fF/dhI9tX89h4Ru8NEz/yE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FzQIUwFviTv6YncJcOCGd7ppLXrJXYIFAMNFM2ZvZPv5ALCRJcOSNDlFZWZola3hFylm9xxO4BJLiG/6Z3tJqCPJmmjFVCOJLSelOKfZuQ5LiCCWMEYPj30wWnXpEW8sEp6EKH2NPWVu6UY5npxZcIlXd5QnEEkd5lOFdN17720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wejaTkkx; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wejaTkkx"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3bbbc6b4ed1so2912259b6e.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 11:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713290834; x=1713895634; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIqmM8dAK0ox5jTI4LjAVnCBk7sM4SVAOaXsg0H9yng=;
        b=wejaTkkxG/plcMf7XgA7mAcD6SeqqX+QNSWksBjmrdNzNPPzdgI2nHMwXw0GJkpRJt
         eiyJ+77AIg0ncSXnRTVIHG1um0PHfvAtxTKbCqLkk1wEFdNhWN8H+6NHF17aF0ylYN9l
         rqilOApYoKgFLHtFsHPS5UO6EJtTVvp2l3k2iHvCAp0EMQWa4spZ4dfrycyWRUolkJKx
         pMB66+CqRvYBE6agUGP2Yh+Ff0yt7KMr9BLxCoDziOHvYAhvC3ATx7NMOFjg/N1/FZLG
         31o6AgmG+U2ofjD1JXNeOyYpmTbFY3DGjq4/l/uRN9AfmOEk9qLOSM9btaxSYJpMoVg/
         LY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713290834; x=1713895634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIqmM8dAK0ox5jTI4LjAVnCBk7sM4SVAOaXsg0H9yng=;
        b=tDwpAeyHZ1w91EXafRvOnWQJGuNHzIyqYIibXtPMaErjLF6M5fQufWrlF0BlnEYtkd
         qe7AcFec+0EU0wJkMzxkKgD8oigeK3Sho33pph1SgbOhJ7xQI7QpArs9bZRrZFe80uGG
         3BBGmqOVn3feuAUTZurqiA4GUPDQKIF3ZooVEqUg+fXq/jVCTHjRQohEIXWmTYuQ90pd
         y6zbrhBrnj264fVsOXsEjwtUTvp1e/wSIkj0mp5ixvB2WEjpe4MeaSFH7A5o8mXcKzyw
         0xo7Hn2oUm+OiqZYmQOSvX5DryOIHTndrsfHWzGNh+LiGJ1+Y+7o/8H5uTgmB50XN64h
         Oj3A==
X-Gm-Message-State: AOJu0YwtAjy8cyLnTei8FZ9UWEkqiqcu7vfJlEabxHfLZqSgRhzx7zj2
	eFASPMV29HNQz43T1dorpS+gsAABQGloaY5o6atR/R2He3O3Y2HVzAFch8ObywGBmkQN8TWz71E
	MFp1c8zvZ8PoA6ZyoSPBlEDVxKmYQxxJ1t+0p
X-Google-Smtp-Source: AGHT+IE70w6ZGCSmvxHsiUiNmJOk0KxeWg62MoH1SC6UtxgMq91MsxjHtdPqH91CNkGqxfVpHv8b03hmaTx7SigJlYI=
X-Received: by 2002:a05:6808:14cc:b0:3c7:fda:2053 with SMTP id
 f12-20020a05680814cc00b003c70fda2053mr8532229oiw.56.1713290834077; Tue, 16
 Apr 2024 11:07:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com> <20240416095638.3620345-10-tabba@google.com>
 <Zh6ujO8qbVviKlEk@linux.dev>
In-Reply-To: <Zh6ujO8qbVviKlEk@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 16 Apr 2024 19:06:37 +0100
Message-ID: <CA+EHjTz6WZD7VYie1CTnv8F4CAzk+uVJA6hrt4oF0evhHFdwvQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/47] KVM: arm64: Avoid BBM when changing only s/w
 bits in Stage-2 PTE
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Tue, Apr 16, 2024 at 6:00=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Fuad,
>
> On Tue, Apr 16, 2024 at 10:56:00AM +0100, Fuad Tabba wrote:
> > From: Will Deacon <will@kernel.org>
> >
> > Break-before-make (BBM) can be expensive, as transitioning via an
> > invalid mapping (i.e. the "break" step) requires the completion of TLB
> > invalidation and can also cause other agents to fault concurrently on
> > the invalid mapping.
> >
> > Since BBM is not required when changing only the software bits of a PTE=
,
> > avoid the sequence in this case and just update the PTE directly.
> >
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 67647b853c9b..30a9a503c477 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -979,6 +979,21 @@ static int stage2_map_walker_try_leaf(const struct=
 kvm_pgtable_visit_ctx *ctx,
> >       if (!stage2_pte_needs_update(ctx->old, new))
> >               return -EAGAIN;
> >
> > +     /* If we're only changing software bits, then store them and go! =
*/
> > +     if (!kvm_pgtable_walk_shared(ctx) &&
> > +         !((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW)) {
> > +             bool old_is_counted =3D stage2_pte_is_counted(ctx->old);
> > +
> > +             if (old_is_counted !=3D stage2_pte_is_counted(new)) {
> > +                     if (old_is_counted)
> > +                             mm_ops->put_page(ctx->ptep);
> > +                     else
> > +                             mm_ops->get_page(ctx->ptep);
> > +             }
> > +             WRITE_ONCE(*ctx->ptep, new);
>
> IIUC, you're using a naked WRITE_ONCE() to avoid a error path that
> cleans up the reference count. That's fine, but can you change this to a
> WARN_ON_ONCE(stage2_try_set_pte())? Should this ever be changed to
> become a shared walk w/o gracefully handling a cleanup here I'd hope the
> warning would catch someone's attention.

I think you mean WARN_ON_ONCE(!stage2_try_set_pte(...)). I can do
that, but for now, warnings in protected mode are fatal. Should I do
that anyway?

Cheers,
/fuad

> --
> Thanks,
> Oliver
