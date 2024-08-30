Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF601B8EA6
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 17:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725037774; cv=none; b=QIA+YVNDZvUiLAjEuMQqsuz1oG0mqM2klWwVLYWoFET4THdOTwIYiIxXUyVUohweIrvC579aGYbLQ02q+z4n/EWizzQMJB9rI/sD5Vwy6FsQVBSOl9xq0GEP5wRp/qgVmUc7os7y8s0frjwxl4c4Dl+JKnf4pnc+TrqdyBjEGDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725037774; c=relaxed/simple;
	bh=CU346vDOqsSTaU3Zni7xFPxbjTXZB+6lE4+IxGvIin4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GfQJCeW63RcdrZw92SEVtFTiRA4zDzT3nLJekeRri2jf7RbttDouBsN5jgbytuZklSNQYx9nbxb0788ZI2yxEuDBzsbdHJurlsL3D3jlPSoo8o7rmxhGMc75STngHZks7I8wL7MiQFzX+iSWh3qE5gUrRl3cMNMHULbk/H449YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hH+tDlWN; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hH+tDlWN"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7144c67e3d0so2017371b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 10:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725037773; x=1725642573; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U/DqUd03uLisJ+lBV6coVazHA/8Mv1E9hChZqzhDQx4=;
        b=hH+tDlWNOjbW/qtgZVOF3xU7RaIuHGeARhqDVqD0Wu6rCSfa5uhLvuX2vSJoJlApQ3
         BUs8rpD1O8OeBrTsk5YWR32eiD2FBC39lyr3z8Jt60u6UIRnZdHsixdrZQLQs7oGX5yj
         w/XYouTikZD5W9Fzpx+tEN++/eqi5CjS2bvwCtZsOgIbtMWDzDL6VvmweHtumj47kceR
         sB0A0cnfNZs9xUcGu01G87E2TkE7IzUZ8554YdQCAL8cvOk1lt+nOH7u0L2RgzZGrlxH
         F+m4dsyC54Bu0JmVJmL3E3JTvZJvC1M1IqsOJY7R0fbEmHFyqyg0A6jwW5gYLQ641kGr
         qFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725037773; x=1725642573;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U/DqUd03uLisJ+lBV6coVazHA/8Mv1E9hChZqzhDQx4=;
        b=mJfJtyJuLMeM+kjPii90WohXl/UWx3vNksVdpDjzAUbg5xD/KGrCShdWB0j5AglrKu
         bmzZXEQXn3WEn0U75/ApClzwF17KsQ3XbEHu2ufoMTOWSgMcXkk7Zf8yt0pXXGePhktQ
         R17rNzC3FdsZowZtMTfui0Mwy2PBU2F1lmRPSWRS+mznICviLpY/0dOcj7QwhBYK1tFC
         DDWirM+tuKZUAOuh0PCmr4G5CokfBAP1XRKA9r7Ff4OaiwTmDV/Zu1w2lGPCFM1xyEb6
         NhxNlr6HHv1HlVoEM8pkI1UfCM43grPIVLUxmJTgOPVkUmd+rZH8Ue6CtT5azgGoSYXv
         6uFQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0np1OeQxoVx/iTZ7BokSLu3LW+zC9YuZiPZ9aOxH5UpCjcPaU2wWKLfi+2j7dYaggZI/oyL0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz89u+4tOChsFU2MyGmel2hR05NIEj+nZMtyiss2RB0DChg69J1
	CrdmuC9m3tNTs/RgrBBLJSsbjcmPmksaVDfv34L+HU2qouC8NXj5wGa64137qv1gmq0Sh6Xa2U9
	NKg==
X-Google-Smtp-Source: AGHT+IFFKP/thrpWlcd7MMBTCnnTgAMVFprrx6gPBFzwzuc79yk0sgtRNBZcK7vPcXyz945EdY+xAc0UhR8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9467:b0:714:24bf:eaf5 with SMTP id
 d2e1a72fcca58-717307852dcmr5463b3a.5.1725037772263; Fri, 30 Aug 2024 10:09:32
 -0700 (PDT)
Date: Fri, 30 Aug 2024 10:09:30 -0700
In-Reply-To: <20240830124720.GX3468552@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-3-jthoughton@google.com> <Zr_3Vohvzt0KmFiN@google.com>
 <CADrL8HWQqVm5VbNnR6iMEZF17+nuO_Y25m6uuScCBVSE_YCTdg@mail.gmail.com>
 <ZtFA79zreVt4GBri@google.com> <20240830124720.GX3468552@ziepe.ca>
Message-ID: <ZtH8yv5AabMEpBoj@google.com>
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn and kvm_age_gfn
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 30, 2024, Jason Gunthorpe wrote:
> On Thu, Aug 29, 2024 at 08:47:59PM -0700, Sean Christopherson wrote:
> > On Thu, Aug 29, 2024, James Houghton wrote:
> > > On Fri, Aug 16, 2024 at 6:05=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > > +static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
> > > > > +             struct kvm *kvm,
> > > > > +             struct kvm_gfn_range *range,
> > > > > +             tdp_handler_t handler)
> > > >
> > > > Please burn all the Google3 from your brain, and code ;-)
> > >=20
> > > I indented this way to avoid going past the 80 character limit. I've
> > > adjusted it to be more like the other functions in this file.
> > >=20
> > > Perhaps I should put `static __always_inline bool` on its own line?
> >=20
> > Noooo. Do not wrap before the function name.  Linus has a nice explanat=
ion/rant
> > on this[1].
>=20
> IMHO, run clang-format on your stuff and just be happy with 99% of
> what it spits out. Saves *so much time* and usually arguing..

Heh, nope, not bending on this one.  The time I spend far hunting for imple=
mentations
because of wraps before the function name far exceeds the time it takes me =
to
push back on these warts in review.
