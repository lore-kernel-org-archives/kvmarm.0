Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05F91854
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 00:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718326141; cv=none; b=TqCbCOyhj9qDDDzJh7iTl/aPcpkdoJX3pm91pUsXw7Z4pka4NecqVBmWvduiuXQdefdc3EDOj2H2+Cy6v1d7o83Dy9L+uXxYsAFeMC0GGahpDe3/O/IRdLqEF4RUXrRO83oxTbE9pWb9qyNHSWg6pS+CRfcg5xKFYNFJApR+D8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718326141; c=relaxed/simple;
	bh=EzpkdrF+lhKU70e/G955Esb8W0Pby1fF9pS1lclAB+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UtzPJ/DlIxp973YODyd38NGpWeh07z3UK+4U6c04zYc4q7Q0i0dWrgAH8ijCJogoYC+Bht+gnPuVXQahHJ2O+nDp1HNAcI9/4atuQ35Nxo7T3WZyDqTW8XQxE1uMr+KT6Lg9Nw0wIgCFhh7Ng9OY/XTO7YK5E3WoOHFLj11QVs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mp5e5wJ+; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mp5e5wJ+"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f70ec6ff8bso85935ad.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 17:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718326139; x=1718930939; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cs3I7xb2JkPfyVWwhfDDItDBDpUbWjmYdCsu/iDXVRE=;
        b=mp5e5wJ+bgMYu9/rAsGt9miV1JY8K0HKSYuS1Arkbn1TkKdAT6O7GLNpGWr+x3xNIV
         1J4pH1re720VipDZoUmOQtRj3vM2cC1InfYIWMwJq5OeljQ98iEiu87MxlqTuVweVOZ4
         xeexp8SH2Zw9URjmr2EZc3y/8vGc+19smNRXpf2D91goHHOnCtUZg2EuSXVaDlQZ301M
         AMpZM1rxakwTOLMRXB2byPLAgKHXG3jOPAkGwr9APBUUfVujtTAA7w9KZX3iPIf9KR2q
         5aWuGy+dcRvJq6rpW5CWgjYniEJ57Y+/89iQBTBovxF02lWoEp9Zj5qKemtTewkWQBFs
         eQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718326139; x=1718930939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cs3I7xb2JkPfyVWwhfDDItDBDpUbWjmYdCsu/iDXVRE=;
        b=RKzJqGwnt4PjhizaDiFV57gh7DsOZZB4pqHkwlKpdAQG4+kHqgxyomKn02+qmPyXYv
         /7axa5n0F5wNGqhJukXw/TJTC2i/61ogSoB7ZaEnLIDeS+zbyEYArWbylEHtWV9uzrYj
         4kbHZOVAZiMnjPx+Nb9BIZeewxizZGBjlO9ucNTeEihLSs40N+jJb054cj8mPo2be8PF
         +xel7qx/DW6AkltkUheOf3AiyZ54Lp89NBHGaXi4Hj+1ttxesnlaHikiS8RZMAXbxFmn
         dB610MhvqkumiFxBvSrl/xvDtoknT6MY4LW5r/nVDjf+6icb8re8ZYx22gebP85+kHlk
         iDqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWa7THe+94hzoEeNl9+UwxYZZgs1f8lRTHOHRXfRn4KZh7zvZy2/+7Zy66/kVbZM93TNquzjDZwPQHOz3i1UflzO+210ot6
X-Gm-Message-State: AOJu0YxpYHC46auH1/m0w03B7tE1fQDXCNuyqMl7GDwzFwgchmQMYL30
	56JxSt9nsmDtzxhVdikeft1rAqdXIwbkIzW6luZd9mR0kjA1k+b4Bc9Dc0m57gUaFYUJmFOcmpl
	kjrgNr9nwBVEvzHdkJ+UXOt4fE6ZWvoE3dxIb
X-Google-Smtp-Source: AGHT+IG4rh9cysMLIjJvQTQbAGIfEWjp8FbFtGimlgyhxAwv6QoKwTYp7w2DNRBP89lE6kBTdOWPtAittybnD94st7Y=
X-Received: by 2002:a17:902:b782:b0:1e4:35b9:cce0 with SMTP id
 d9443c01a7336-1f86777297bmr804415ad.9.1718326138884; Thu, 13 Jun 2024
 17:48:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
 <ZmidYAWKU1HANKU6@linux.dev> <ZmiqXUwMXtUGanQc@google.com> <ZmqXRhFSoE38foh6@linux.dev>
In-Reply-To: <ZmqXRhFSoE38foh6@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Thu, 13 Jun 2024 17:48:22 -0700
Message-ID: <CADrL8HXhGFWwHt728Bg15x1YxJmS=WD8z=KJc_Koaah=OvHDwg@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024 at 11:53=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Jun 11, 2024 at 12:49:49PM -0700, Sean Christopherson wrote:
> > On Tue, Jun 11, 2024, Oliver Upton wrote:
> > > On Tue, Jun 11, 2024 at 09:49:59AM -0700, James Houghton wrote:
> > > > I think consolidating the callbacks is cleanest, like you had it in
> > > > v2. I really wasn't sure about this change honestly, but it was my
> > > > attempt to incorporate feedback like this[3] from v4. I'll consolid=
ate
> > > > the callbacks like you had in v2.
> > >
> > > My strong preference is to have the callers expectations of the
> > > secondary MMU be explicit. Having ->${BLAH}_fast_only() makes this
> > > abundantly clear both at the callsite and in the implementation.
> >
> > Partially agreed.  We don't need a dedicated mmu_notifier API to achiev=
e that
> > for the callsites, e.g. ptep_clear_young_notify() passes fast_only=3Dfa=
lse, and a
> > new ptep_clear_young_notify_fast_only() does the obvious.
> >
> > On the back end, odds are very good KVM is going to squish the "fast" a=
nd "slow"
> > paths back into a common helper, so IMO having dedicated fast_only() AP=
Is for the
> > mmu_notifier hooks doesn't add much value in the end.
> >
> > I'm not opposed to dedicated hooks, but I after poking around a bit, I =
suspect
> > that passing a fast_only flag will end up being less cleaner for all pa=
rties.
>
> Yeah, I think I'm headed in the same direction after actually reading
> the MM side of this, heh.

Yeah, I agree. What I have now for v6 is that the test_young() and
clear_young() notifiers themselves now take a `bool fast_only`. When
called with the existing helpers (e.g. `mmu_notifier_test_young()`,
`fast_only` is false, and I have new helpers (e.g.
`mmu_notifier_test_young_fast_only()`) that will set `fast_only` to
true. Seems clean to me. Thanks!
