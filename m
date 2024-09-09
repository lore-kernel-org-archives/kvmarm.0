Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1854B1B78F7
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 13:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725887096; cv=none; b=iVtm1KJqB4WqiEf21pUz7FdiJUHkzReFx8/bBOgY+ND8zcSHzd5MGqOpZ9l/dBivFDC5m+SpDiVVrYibkxsA4LQoIoxytdymPuixdSyuRuRKUoUKc89i3MI4Cwv43lb3Db91e/O46pUNCPEUSAEs1qTeQuIrg3+8hEqN3mYR9wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725887096; c=relaxed/simple;
	bh=L0vwODwwSSBymebWFKwW4WyiZMvG/NRkmKNHnmKLW7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MIfG8TYGhEwYi+djGIuM1hKTj/BCJaxThYzAXeOBy/76e0X7GyQV2Fni3c3YfOVp4d9iQKnP2girgnasftxO2omdRAu3FFXw2Ybj2Lfe7u23KFgfzT05IsiriHKaB+eajZkct0a8CoHbsmlhO639BVclBHxVQNTrSegciEOPm78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QSxT9/16; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QSxT9/16"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7178df70f28so3484563b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 06:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725887094; x=1726491894; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cVvLY2VfZB6N+n3cVr06yApvKJo36SMbCLMd3Fv1sX4=;
        b=QSxT9/16lJYyoZqOzfXqZW7BS/W8QJR4UXi5CYowlbrzOR1nL5up7RVgzWf9p4hjs2
         hUNgT5w6x8hnp3lViEpxj4DrYAcyhZmxc2nC6DUd3COiJH/KQYBZlbnFd0tGKmLN4UNc
         1rHsuFQfqEWIeA0hy5r7KREj5roVH9jBSfaSvIq4NPnkMMMB8WiBr6JIj/PNnDcfhams
         xw26ai42kHdjhPcZ5fDn/cmVgrS5SEimV0oU2Tb9sSttutiNnc5i8NRZ/k6TEDy9qIqD
         Sv1WBY5grLlKcAEqti8IP52AQdEUOFlKmjxnvAtjyz2/kJJdfj1uktEyWXiuG4jquTue
         sYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725887094; x=1726491894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVvLY2VfZB6N+n3cVr06yApvKJo36SMbCLMd3Fv1sX4=;
        b=GIhQ6566JQQQyzKBSxu2zuCXky8yZ48fKvG9FCGxxqZpH/jc6U3HlcwjdbqSJ+GeNC
         tWjYhX7DmRR0MeyNthOFRn6ayYTK8pkMLlBUexNpTUi5KuAKkW5PAa58/c9WiydW81F+
         uIRw4oAwfJyAbG4HxdGRJnpNHKECqJg0NwE8N7F6F5huVKgM0li8HxHmSpoTmQoSFjRF
         KQwIkNCeSict+ofsnxOBwER1vXgiemAuOGSC4MdXrb/DxLsPFrKuSnwFeeuu2I7CvuHr
         9abWKP+Xk/dAgt/KIiMuZHJbW43hGeafrcdv6x0/XCLiTLyvqOLJpSJPquUOITmTFu+1
         CDkw==
X-Forwarded-Encrypted: i=1; AJvYcCUJ2oK0/YOLfoimrG4AEE/nX0m9Xods6/eJxF1e90DBu0SYUYdkNcsjF9gQHEoO7hqHSRSsKbw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJC+QcnE3OXonctUYduUQmCAmCfusa11qvWSp5LXRvQwTz7Cg8
	L9DodR6DVKMVZC670xTMphuGB3GGDciNHvO9uhH2KMC8k/w/QmNzKMgxRuUZYwRw3nAEDG6g4c0
	7QuVGS7zdsupdb7+cVC9xtFICRc+51vixsUcg
X-Google-Smtp-Source: AGHT+IFDy1qA+jlhwHF+kHq/KdBfZulF7F5n7E3iDmjlp1f+VOo/2osLQxLbnpMn7rApXlRIUljt3vDobqmAHL+Uua0=
X-Received: by 2002:a05:6a00:99f:b0:717:87af:fca0 with SMTP id
 d2e1a72fcca58-718d5c3644amr12733053b3a.0.1725887093727; Mon, 09 Sep 2024
 06:04:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906092732.113152-1-snehalreddy@google.com>
 <86ed5wvixw.wl-maz@kernel.org> <Zt6gvd4NwMmjS8JB@google.com>
In-Reply-To: <Zt6gvd4NwMmjS8JB@google.com>
From: Snehal Koukuntla <snehalreddy@google.com>
Date: Mon, 9 Sep 2024 14:04:42 +0100
Message-ID: <CADTD=jYYWSi-J08T17YAhjFYDcCjMegpwuO9hVPfWMRQ4=6E7g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Add memory length checks before it is xfered
To: Sebastian Ene <sebastianene@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks Sebastian for replying to Marc's comments.

> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -461,6 +461,11 @@ static __always_inline void do_ffa_mem_xfer(cons=
t u64 func_id,
> >
> > /facepalm: why do we have this __always_inline here? Nothing to do
> > with your patch, but definitely worth understanding why it is
> > required.
> I don't think it is needed, we can drop it. Maybe as part of this patch
> ?

I will send an updated patch removing the inline then.

> > The From: and Signed-off-by: tags do not match. You may want to add a
> > [user] section to your .gitconfig with your full name so that this
> > issue is sorted once and for all.

Thanks, I will update my git config to fix the inconsistency.

Thanks,
Snehal


On Mon, Sep 9, 2024 at 8:16=E2=80=AFAM Sebastian Ene <sebastianene@google.c=
om> wrote:
>
> On Fri, Sep 06, 2024 at 05:35:39PM +0100, Marc Zyngier wrote:
>
> Hi,
>
> > Hi Snehal,
> >
> > On Fri, 06 Sep 2024 10:27:32 +0100,
> > Snehal Koukuntla <snehalreddy@google.com> wrote:
> > >
> > > From: Snehal <snehalreddy@google.com>
> > >
> > > Check size during allocation to fix discrepancy in memory reclaim pat=
h.
> > > Currently only happens during memory reclaim, inconsistent with mem_x=
fer
> >
> > Can you please elaborate? It doesn't seem to fail at allocation time
> > here, as everything is pre-allocated. Some context would greatly help,
> > as my FFA-foo is as basic as it gets (I did read the spec once and ran
> > away screaming).
> >
>
> Right, I think what happens is that we use the fragmentation API to
> transfer memory to Trustzone that normally won't fit on the reclaim path
> where we use an auxiliary buffer to store the descriptors.
>
> All the descriptors are identified by the same handle and the reclaim
> will try to store them into the ffa_desc_buf before nuking the FF-A
> annotation from the stage-2.
>
> > >
> > > Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
> >
> > The From: and Signed-off-by: tags do not match. You may want to add a
> > [user] section to your .gitconfig with your full name so that this
> > issue is sorted once and for all.
> >
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/=
ffa.c
> > > index e715c157c2c4..e9223cc4f913 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -461,6 +461,11 @@ static __always_inline void do_ffa_mem_xfer(cons=
t u64 func_id,
> >
> > /facepalm: why do we have this __always_inline here? Nothing to do
> > with your patch, but definitely worth understanding why it is
> > required.
> >
>
> I don't think it is needed, we can drop it. Maybe as part of this patch
> ?
>
> > >             goto out_unlock;
> > >     }
> > >
> > > +   if (len > ffa_desc_buf.len) {
> > > +           ret =3D FFA_RET_NO_MEMORY;
> > > +           goto out_unlock;
> > > +   }
> > > +
> >
> > It took some digging to understand how the various queues are sized,
> > and a comment explaining the relation between ffa_desc_buf and the
> > other queues would be very welcome.
> >
> > I also notice that we have other places (apparently dealing with
> > fragments) that do not have such checks. Do they need anything else?
> >
>
> I think we don't need that check in other parts.
>
> > >     buf =3D hyp_buffers.tx;
> > >     memcpy(buf, host_buffers.tx, fraglen);
> > >
> >
> > Finally, this probably deserves a Fixes: tag and a Cc: stable so that
> > it can be backported.
> >
> > Thanks,
> >
> >       M.
> >
>
> Seb
>
> > --
> > Without deviation from the norm, progress is not possible.
