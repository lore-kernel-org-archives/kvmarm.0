Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A7F15B98E
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 22:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717021327; cv=none; b=OnKZa3sP1zi11O4Q0brn/HvjFmYOfNVwc8wu9R8hCWNEsFYHuRVy4MxkfG3BHjAQ3gJKVD7H7nsrMRq3lGkBHOVtpt1aNdPO1YWQOQT7vMR9es5tkbnA13i+fUFtpMJwXUYon0eauCbdQR5Ow3r3SzMfMGVWd4hiewnNUkpLhbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717021327; c=relaxed/simple;
	bh=dXNFpCWaiUyGAgeRu6GIx1Hrfse/W7At5lQK/blkjT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g5fLvS+bPwHXe/V8uvrLvq9UucYjSPyDdb8OqvMkaItebgVWxOMvabMiE4+0vmmvrZBnIlqXUOmBHi9wplJUGsoLEvKktbEwwed4v8mVi6YQxA/ZAggDdd3w2GYXwildm4d53RGnYU7Ej4mFUZKdQ4aSRODKuEVXTh0Nut/q2d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z6lJF/V0; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z6lJF/V0"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-41fef5dda72so8115e9.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 15:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717021324; x=1717626124; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXNFpCWaiUyGAgeRu6GIx1Hrfse/W7At5lQK/blkjT8=;
        b=Z6lJF/V0NELGyJ//KmQ1wP9sAYpfIudzvmNEv1tlMwQg4nVcVBbK7SAqZ2iAtDIe7u
         2NSIqhln5DQGN1/8BmvO++BAgkOviT42jABtCLg3vULaWauzp0nq5iSZC3VHJF7lGmEq
         awE1jBKIbOZKHqA8mNR5SDklarNNFLRY1ymhA9Ua3Dv/MEkeO3yocOrxQj586kH6zWnb
         0NJ5RAAv078wpAlWD+T+h+ZwPDBJBpv3BPuGpx/pH8Q8CX/VaSNDJRmU+BOLMYNPCH+4
         9GiqpxVLkrPDIdjZZu6HGYGbjfSycO7K2HNB+p6d+uFcUEV3U2tsKbHBRjYwdeVuonCd
         zXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717021324; x=1717626124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXNFpCWaiUyGAgeRu6GIx1Hrfse/W7At5lQK/blkjT8=;
        b=f3dzeYWll/BfF+gVT/X0BsxHS1jSDTV8m7ssurvyQ8SZX3jxs+grAy60mcjDW3DN3B
         QuTwYGvA+kfKJVT1woDTqYlT91MxE9VwRdPzAt7f85UfPC0govFpnIgyA7da8riv3jwc
         CIUdLsBQAx95EFOQjURuwfiM51HBF07WrGcD0jz420KLa5OFj59rQQPx2jOWZC6X9fg7
         GwSlwsqATMUyBJ+W0iOwzrKAyy1eAILiLIGGBohWAlyRtaZok8Cgifk8dzqxTpvv1Ep2
         zikMap2eyC2dtXp0faO52aELWPqZdid4vsFWY2FlP01qliWOn+5HYfJyhe6X/zCvBN4t
         vzRA==
X-Forwarded-Encrypted: i=1; AJvYcCWgCUdtpCPsWk3NIG+8jA9WVCf/oolI9fAuI6mevcVoV+wFIuvWThrivXZ7w5c6B0MOb8K0rpqAKrVlT/DxeaQ2307HTBlc
X-Gm-Message-State: AOJu0YxY7B4tDp940X+LxxVrd1yTTKDy5uxgaoI8A9RdA9n3fMWVMdpf
	LIaYLHulDJ2sri62s+Pbm3tkqgOOEJ3EeCtW0zHBKlLDOZPFOrPJMEJald7OP/pZ3zLT8ticNmD
	Xspbac2cUqQ1pMEWsS3Hi6qZg6BmwVzVmzOZC
X-Google-Smtp-Source: AGHT+IFqO7VFkypiYSn9vKfdPJnK37iD9z235VYJwF+JX9IAWq7RbNTOv7CYeuUojcdBQo9JI7fHcGh5LBFn8OI6V7U=
X-Received: by 2002:a05:600c:2146:b0:41b:8715:1158 with SMTP id
 5b1f17b1804b1-4212761becfmr670735e9.6.1717021322997; Wed, 29 May 2024
 15:22:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-3-jthoughton@google.com> <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
 <ZlelW93_T6P-ZuSZ@google.com>
In-Reply-To: <ZlelW93_T6P-ZuSZ@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Wed, 29 May 2024 16:21:24 -0600
Message-ID: <CAOUHufZdEpY6ra73SMHA33DegKxKaUM=Os7A7aDBFND6NkbUmQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Ankit Agrawal <ankita@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Bibo Mao <maobibo@loongson.cn>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2024 at 3:59=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, May 29, 2024, Yu Zhao wrote:
> > On Wed, May 29, 2024 at 12:05=E2=80=AFPM James Houghton <jthoughton@goo=
gle.com> wrote:
> > >
> > > Secondary MMUs are currently consulted for access/age information at
> > > eviction time, but before then, we don't get accurate age information=
.
> > > That is, pages that are mostly accessed through a secondary MMU (like
> > > guest memory, used by KVM) will always just proceed down to the oldes=
t
> > > generation, and then at eviction time, if KVM reports the page to be
> > > young, the page will be activated/promoted back to the youngest
> > > generation.
> >
> > Correct, and as I explained offline, this is the only reasonable
> > behavior if we can't locklessly walk secondary MMUs.
> >
> > Just for the record, the (crude) analogy I used was:
> > Imagine a large room with many bills ($1, $5, $10, ...) on the floor,
> > but you are only allowed to pick up 10 of them (and put them in your
> > pocket). A smart move would be to survey the room *first and then*
> > pick up the largest ones. But if you are carrying a 500 lbs backpack,
> > you would just want to pick up whichever that's in front of you rather
> > than walk the entire room.
> >
> > MGLRU should only scan (or lookaround) secondary MMUs if it can be
> > done lockless. Otherwise, it should just fall back to the existing
> > approach, which existed in previous versions but is removed in this
> > version.
>
> IIUC, by "existing approach" you mean completely ignore secondary MMUs th=
at don't
> implement a lockless walk?

No, the existing approach only checks secondary MMUs for LRU folios,
i.e., those at the end of the LRU list. It might not find the best
candidates (the coldest ones) on the entire list, but it doesn't pay
as much for the locking. MGLRU can *optionally* scan MMUs (secondary
included) to find the best candidates, but it can only be a win if the
scanning incurs a relatively low overhead, e.g., done locklessly for
the secondary MMU. IOW, this is a balance between the cost of
reclaiming not-so-cold (warm) folios and that of finding the coldest
folios.

Scanning host MMUs is likely to be a win because 1) there is usually
access locality 2) there is no coarsed locking. If neither holds,
scanning secondary MMUs would likely be a loss. And 1) is generally
weaker for secondary MMUs, since it's about (guest) physical address
space.
