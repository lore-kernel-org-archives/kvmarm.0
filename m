Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EA084A35
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042985; cv=none; b=PCWAe9BPPV+/wO9ir3WSoZhezLruNqlE7f69yEU35tgdGIvquLinTwv9MZUgOU9SivAcMshyIi7gw5awpIjd8ld3n17Pxjo7wZh+QP8Ybx6C2Ah34p/6u/28lotwfWVLmlf/MCP0lpsbduLkCIvnjilchpPbiA3PnWDz2+fElhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042985; c=relaxed/simple;
	bh=i+cKN7kvlmSwCbheJAMEk6ZSnnzPsXRqTPu/u16iMjk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lz3aV4ttsfkUYtwQoWILGPpVIHFcBzAWEmdxkrh/JXWz2BwrY6a5/ZKUURdrXKf+8AO80/2S8YWkLjEsa4y/HKhvq+xc6a8qcYcmj0orK9MeYMvgOwgDizcBxNspnHgo63wRmTttNyU6uDCZ8LkaGFAWMNxVf/NsR7rjEHSqrYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=myxZiA0n; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="myxZiA0n"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fd657c9199so395455ad.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 08:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723042983; x=1723647783; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kl+B4ZpfEXlczthXYPnKJxRHMc3GQi5TyNP+ymJuxKA=;
        b=myxZiA0nYg3iKt0xde+7AikW7S8LrOgCbhC/AnCiAw7qMklQBOOeP8VzC86UfY1ApI
         iVT0nNso32hCNs1eMwlTNDjQvZK3ANGlit91c0CAbTgiEw1GUQOLtPuc7Mn+X7MC02U5
         fO2lmS8Cvrmc8y711noZ5S95YGvbkYJML9uf2ieOI9xaxRrnSEnabalSaOnnBNGCZO7N
         bi/Pveb0W3adkiAnamTGRfx/rDwmeFY4GXvV4asNsZKsloizKYKH11ahku8GN211D/7h
         Re+Layx2ODI4hTVlcGjXvfOeWAZvy9+rNW92KTeU+0Zr9/2bKXBJiNK9yA9C4LymUfQd
         ErIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723042983; x=1723647783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kl+B4ZpfEXlczthXYPnKJxRHMc3GQi5TyNP+ymJuxKA=;
        b=TthIgUPOY7hvo1oOA1YrSZvMIdQ9Y4+GJaOsmgaOqBa9BOzCLrre6r9ZX301oqKZsz
         lxoA4q3PEBi5UHJ+nqzfCLt6UvDXXGiEX6oBa6PyfaiOrm+jc2wzHggIR0T+NNdV0kk8
         AnP9Wox4WQG0j+OVUwmpcpuihFg2ZLaE23oT6aj2JHVl8BneiyqBNwLQid8Sbah7mR0W
         HFv1JI0OuP7cRWb4DpiotxF1J3V4o5TsjT59Vi4P3yrFz0ujmrHTkoX4g1Yvw25Hj4UV
         Aln4Yk9QPhrJR4NDrdOJ5TOc/8zlu3BtUgDgw6d9phNLKWuzaQd1S30CBHNUwxegyEFm
         IVfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMZj8KiB2PgknDSVy/mPYE4IepX6trOm2WT+iaxOXvIzEoIHvI4rUWAzYJ89lXfAp9/Hzd2esQoPcrbQfcpDLs0eKkJQud
X-Gm-Message-State: AOJu0YwiYls5Yoz4Rj4QXoCM0fSe2gMAkjuQBSI5nYZtlwvMqOGiW8gN
	5StaejcycO2DX7rjyPkKp2sDVr6xGboNEZ8gRJF/dga3GrVvZ/AmQnbAjAk12RMKieZdtYrbDqy
	kPRVomtrS40gOhLnDRtdnD3Hk6sIHct5UXL6N
X-Google-Smtp-Source: AGHT+IEr49aHCdjCgL7YLIeYK1keo+SAW0FFZJxDENp6M5+q2ZuFNNnSP3R4yjqSv3wfAioC7aVTpFhpJO2Or0Jv1jg=
X-Received: by 2002:a17:902:f547:b0:1fb:563:3c25 with SMTP id
 d9443c01a7336-20083799d8emr3462625ad.18.1723042982895; Wed, 07 Aug 2024
 08:03:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-6-jthoughton@google.com> <37ae59f2-777a-4a58-ae58-4a20066364dd@redhat.com>
 <CADrL8HUmQWDc-75p=Z2KZzHkyWCCh8xnX=+ZXm5MZ-drALjKTA@mail.gmail.com> <20240806172349.GQ676757@ziepe.ca>
In-Reply-To: <20240806172349.GQ676757@ziepe.ca>
From: James Houghton <jthoughton@google.com>
Date: Wed, 7 Aug 2024 08:02:26 -0700
Message-ID: <CADrL8HXFK=1cUS+0Z5k048U4rzpTNL634f57VtJ7TD_umrbNiA@mail.gmail.com>
Subject: Re: [PATCH v6 05/11] mm: Add fast_only bool to test_young and
 clear_young MMU notifiers
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 10:23=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Thu, Aug 01, 2024 at 04:13:40PM -0700, James Houghton wrote:
> > --- a/include/linux/mmu_notifier.h
> > +++ b/include/linux/mmu_notifier.h
> > @@ -106,6 +106,18 @@ struct mmu_notifier_ops {
> >          * clear_young is a lightweight version of clear_flush_young. L=
ike the
> >          * latter, it is supposed to test-and-clear the young/accessed =
bitflag
> >          * in the secondary pte, but it may omit flushing the secondary=
 tlb.
> > +        *
> > +        * The fast_only parameter indicates that this call should not =
block,
> > +        * and this function should not cause other MMU notifier calls =
to
> > +        * block. Usually this means that the implementation should be
> > +        * lockless.
> > +        *
> > +        * When called with fast_only, this notifier will be a no-op un=
less
> > +        * has_fast_aging is set on the struct mmu_notifier.
>
> If you add a has_fast_aging I wonder if it is better to introduce new
> ops instead? The semantics are a bit easier to explain that way

v5 implemented these with a new op[1]. *Just* having the new op is
kind of problematic -- we have yet another op to do something very
similar to what already exists. We are left with two options:
consolidate everything into a single notifier[2] or add a new
parameter to test/clear_young()[3]. The latter, implemented in this
v6, is somewhat simpler to implement (fewer LoC, reduces some
duplication in KVM), though it does indeed make the explanation for
test/clear_young() slightly more complex. I don't feel very strongly,
but unless you do, I think I just ought to stick with how the v6 does
it. :)

Thanks Jason!

[1]: https://lore.kernel.org/linux-mm/20240611002145.2078921-5-jthoughton@g=
oogle.com/
[2]: https://lore.kernel.org/linux-mm/CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9=
ZpueyifgNdGggw@mail.gmail.com/
[3]: https://lore.kernel.org/linux-mm/CADrL8HXhGFWwHt728Bg15x1YxJmS=3DWD8z=
=3DKJc_Koaah=3DOvHDwg@mail.gmail.com/
