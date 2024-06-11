Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4928E1CF90
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 19:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718135393; cv=none; b=LC6iICff6gmx8zHUglvahRX4L1WqSzcyFu35Mzvj4/CTssK1c9FLqXeiBOoJoURqfFYjfCBB7M0c/Ifo1yNALJ1pdcD+J75eqPrv7ZTHValsdylRH9vb3SALQ+8sWnARFuWfnguZhwehbOH8hbnFxbfN9gzmBJ18FIiwXLg2TIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718135393; c=relaxed/simple;
	bh=/NwHUZCZvevcGs9AY7lN4MhT6WOwaqpKh7KDLpz5U4w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z8F6aZC39QHEwgDN9om0ToaG7Y8JvPyvQmGQw+yl7r6tGjadXuXcoeori4qMxretRN5b3Jmg4xwBgL3/bJi6YUduVzhpUTXfoXCGMNyyK903iMFZ55NbU8iPv05JzU0HiPjpl4R7ePjfW+1d4tcmMRmSrRQDt9n2j+tMSTIop+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l4LhTH7y; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l4LhTH7y"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a1e9807c0so2371407b3.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 12:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718135391; x=1718740191; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NsScqjx9mfx0RxKgLYLDE8PLKJt3i+CjnwDIOhR5gSU=;
        b=l4LhTH7y+6TswcwxP/uERg6AGpMTrqi4O2UjT+ubbwwkibPAgPR91AY1zuyjvvHG2K
         rgFw6w+fSoEfNDlKvAIKw+yzzlVyDNDFcTsz3OBky5bP6uPI0PhmCwcRCsXO5YzsVJya
         AopgKNsDGdnULY594XNUOpre0g0xU8YLfzoY1Um5wC/vKxURSFKXXWc59FuSQFMUGIYr
         zw1OOoPVM7QPqE2adC1J4bTs8N1x2GY/Abq9vDeIxWvd9a28nH8zBo6TgyOaI+W6kBeS
         5ZK7XFKSE/RLZbDxKmJQNabIb4XfizNp9dmtre7e323QUftns1MkPkMT/PO8x1e7uGOm
         VTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718135391; x=1718740191;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NsScqjx9mfx0RxKgLYLDE8PLKJt3i+CjnwDIOhR5gSU=;
        b=SKNQqyNxxCRlAXzbDsScpgW1fR8iFQ9LBR+nOZfgs8nAnoS1JhQgxKMfdfNlW2IKII
         bhzpzcduP3hubLZauUpIhw9bcHV6pvhPpgTHMqqcWaacQOtGmQCbPGCrpkdXv5hZoZgE
         13OlYJNHvs/ABwg4HuBMgKUYylg8feBCfidm4b7a21+CJia/EixMpzzLQIJXu7bVOyFQ
         aja0ukHeuXzrxCJtVZaXVw70vXZX6H0QRccOMN31NcmKi4U3AXSHIfp1BcTcVVRp1i7u
         P2RCLJEbJYQwlteW77VpHdqUBxLDO/Th0Y8jubM3fUSJb6gtlT6FpgIKsoigZqhxeXv/
         XNJA==
X-Forwarded-Encrypted: i=1; AJvYcCWafH+/UwjYQg/b506aANUOFFPYhAU5mSZuMzj4q/5YS5TMJn0G0yblvcYtHYbtOJQfUlafKk9EgNO2pC++UEfHUNMt8ENA
X-Gm-Message-State: AOJu0Yw/KlPh99nnT6T/v2KoMus6feylzXQW7RqrpEKcfwoe4Ynfz2Pd
	2u9lSqnqmFOd508cLb84PYGm61rUeyJW5joOEjUUES1WwD46k18FgZUUCi49cmlu/9OYR859nVf
	VaA==
X-Google-Smtp-Source: AGHT+IHKfAK7pE+6MrNjEhC62+VdpwmGAN149yNl7QeE40CZzlXANYBAeDvy6+hs91vFlM0KeuUkc8js0Mw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ca09:0:b0:627:edcb:cbe2 with SMTP id
 00721157ae682-62f171e8601mr6018567b3.5.1718135391323; Tue, 11 Jun 2024
 12:49:51 -0700 (PDT)
Date: Tue, 11 Jun 2024 12:49:49 -0700
In-Reply-To: <ZmidYAWKU1HANKU6@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com> <ZmidYAWKU1HANKU6@linux.dev>
Message-ID: <ZmiqXUwMXtUGanQc@google.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Yu Zhao <yuzhao@google.com>, 
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
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 11, 2024, Oliver Upton wrote:
> On Tue, Jun 11, 2024 at 09:49:59AM -0700, James Houghton wrote:
> > I think consolidating the callbacks is cleanest, like you had it in
> > v2. I really wasn't sure about this change honestly, but it was my
> > attempt to incorporate feedback like this[3] from v4. I'll consolidate
> > the callbacks like you had in v2.
> 
> My strong preference is to have the callers expectations of the
> secondary MMU be explicit. Having ->${BLAH}_fast_only() makes this
> abundantly clear both at the callsite and in the implementation.

Partially agreed.  We don't need a dedicated mmu_notifier API to achieve that
for the callsites, e.g. ptep_clear_young_notify() passes fast_only=false, and a
new ptep_clear_young_notify_fast_only() does the obvious.

On the back end, odds are very good KVM is going to squish the "fast" and "slow"
paths back into a common helper, so IMO having dedicated fast_only() APIs for the
mmu_notifier hooks doesn't add much value in the end.

I'm not opposed to dedicated hooks, but I after poking around a bit, I suspect
that passing a fast_only flag will end up being less cleaner for all parties.
