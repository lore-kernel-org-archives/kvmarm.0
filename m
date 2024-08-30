Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FC423BE
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 00:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724978092; cv=none; b=ltqF9hNy4GZU7a6zel8gJZSEK+w/xOa4BChdKN/Jv9roUt52RnOJN5/OtMH6LKVwSmnKQel0GuMQ+9IfTpqL9iLDG0yMUdQHxNlDs/xvGMCNWx+28t48u2Evpq+spalq35HBsgF+r0hdiXdxV0o88uWr9yjrC7/pGpaA52X53Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724978092; c=relaxed/simple;
	bh=FqpnbV2f9pzqLhpgsHuN0fCsazH+X/gkpf6dLbPjAVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AHvBol5yYe5hJ9envIpQU6lmV8LCBCxALeMTOJiSFBk2OLcBdJnj4LEggiCZa8DZ/50w1gK3vaPMo21ocZkxskHiZimqzoFznMm3r40yCp3GpyZzgwRk2ruCyxoL+TBagL9KMKW+fZ2LVKn4RUzc7kkYYNXfXYKs6BU5uf2VP1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eD6bcQgx; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eD6bcQgx"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6c3f1939d12so11331347b3.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 17:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724978089; x=1725582889; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScuyZghAxUsq77xlIUmB3FT5rIh3r/8m9ZVZaLG04YU=;
        b=eD6bcQgx59UjBZ34isfemGHUOvNHn75jSnpgQ/lF5lnr6gXgXwtnFpHZr39F7gIlZz
         fy1ouJH1MmrvGkwKzqdSNrdLBs76p83A0tXGPuwUJM1SF6J02+P5yB5tiqOKnOCfTBMD
         xB5jo+YU2ps0f2AM4+SFE0SxX9QgYd+s0cHG+a847r69WIofKJu8wd6XVFB4M2qaYazq
         6XB2jcmgc0j2WQnOz0pjlJKjM9AWjyCfyC19Xim/x6YoObB2sGCT36oQ9nIuBOsucs9Q
         99DeKWVgIfTdGxCUv+SfZ4qt2eyFK6E5OJm4X8hGQehIlGGseUt7UjNn5sarSUo6loE9
         ziDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724978089; x=1725582889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScuyZghAxUsq77xlIUmB3FT5rIh3r/8m9ZVZaLG04YU=;
        b=RFjeXHi3mqBqibkdQlg2SWIbsFLtdvoe0wJy812OEKZEr6/bA3cY54y0foIsnbL90C
         PTaZW09yv3iMBZOSuZnaFdspr526/ENquW2+lhF5CJS1CY5cuyXfhcQ5Qp4JCMeL/1b0
         TuM+28g7qtI+FcozGPoajZIQxhvi5bgq/KbxD60zyYdCC6hY1FC1+T8qm0mNkmtZAXRv
         SdCK4jtuFFtE1aB9AOuABMbMhLu8XDJW+NRJ5e9w3PBh/DyavrMDDSJ23UK6uX1jE/2v
         Jdtgf8PTl0FNgwURxg8LowtUPzPYvEZtpoGApfn5R0WdbL0gLJ5AdSK+22r3CzjmOsU1
         qvIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtGfGLvPGzlyUD+0cR9Y+Ezq05aKw11DjceKvw9LUZns56DzEb1L9Tn4YP39j92KvCRxZkaXk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAFb2KoxaNgjHTBPQAPSTc1AqPZYVabygJc/b55ZXtkkDBkVej
	CBNJzNSlNPx8emo2z0w8uJdrlRi1/xYkuL7Jee8SlqagJk946kznaQNUsILcYlQTXccE4PNNN+1
	hqxCCuWIoWcF9gMAa/7KGH7Wa6ewCU1nEzaj4
X-Google-Smtp-Source: AGHT+IEHfgQ7ITmpC9nLKgn2p9q5pKXn+MuPyh1yHF6iMxunaqm5ZCNB9dh715WRCvs589w6aHZcopQzVWBPqtznylA=
X-Received: by 2002:a05:690c:7409:b0:6ae:d19f:8b62 with SMTP id
 00721157ae682-6d40ff0ca84mr4280747b3.43.1724978089470; Thu, 29 Aug 2024
 17:34:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-9-jthoughton@google.com> <ZqKWxfqRoJzUWroG@google.com>
 <Zr_2Qhflx5xBhFCY@google.com>
In-Reply-To: <Zr_2Qhflx5xBhFCY@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 29 Aug 2024 17:34:13 -0700
Message-ID: <CADrL8HXnV8cmpytBSvGPvqvhjryWwT__MwWLbjzxX6hbd2UxFQ@mail.gmail.com>
Subject: Re: [PATCH v6 08/11] KVM: x86: Optimize kvm_{test_,}age_gfn a little bit
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 6:00=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jul 25, 2024, David Matlack wrote:
> > On 2024-07-24 01:10 AM, James Houghton wrote:
> > > Optimize both kvm_age_gfn and kvm_test_age_gfn's interaction with the
> >
> > nit: Use () when referring to functions.
> >
> > > shadow MMU by, rather than checking if our memslot has rmaps, check i=
f
> > > there are any indirect_shadow_pages at all.
> >
> > What is optimized by checking indirect_shadow_pages instead of
> > have_rmaps and what's the benefit? Smells like a premature optimization=
.
>
> Checking indirect_shadow_pages avoids taking mmu_lock for write when KVM =
doesn't
> currently have shadow MMU pages, but did at some point in the past, where=
as
> kvm_memslots_have_rmaps() is sticky and will return true forever.

Thanks for the clear explanation.

> > > Also, for kvm_test_age_gfn, reorder the TDP MMU check to be first. If=
 we
> > > find that the range is young, we do not need to check the shadow MMU.
> >
> > This should be a separate commit since it's a logically distinct change
> > and no dependency on the other change in this commit (other than both
> > touch the same function).

Done.

> > Splitting the commits up will also make it easier to write more specifi=
c
> > short logs (instead of "optimize a little bit" :)
>
> +1.  Especially code movement and refactoring, e.g. factoring out
> tdp_mmu_clear_spte_bits_atomic() would ideally be in a standalone patch t=
hat's
> dead simple to review.

I have now split out the creation of tdp_mmu_clear_spte_bits_atomic()
into its own patch. Though I'm not entirely convinced splitting out
every refactor like that is always a good thing.
