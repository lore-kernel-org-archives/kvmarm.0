Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5DB1C27
	for <kvmarm@lists.linux.dev>; Sat, 17 Aug 2024 00:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723855600; cv=none; b=BvRuh7yfuNA38S1t0kkONj5PWaAH5raLpFrxgW++0VrhLBsEvgL/izAxPLuLCOUtH2X0scoAdsupllveYaMce04c3NjmzZ3POYG+Q8G49g+eYidxSnRVhHEaYq5+HXoLVbwkyuOVXF0FsZcbgddHMSPtleC7O8NwTbkHyWuo+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723855600; c=relaxed/simple;
	bh=bb1MWnkDkGldXADxQf3JhyfD+gBzbYqcRmbOgpBPRRw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SD5AHBiU5JYASyizk1VnF5K/AQ8LON22jwGocTci6qvslYtOQ0r9waO7YghR0DZqIIP6EY1OCcsMPao/4SZHU1EL3QrUFLhkgfGSl6HaDi5XYNKpsJ11BYh46ezzAnfSEfMT+7MAlwHArzBeTWX9yxq9xUwYFPYkB9Cp9opc1js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DGsnbGHA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DGsnbGHA"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d3c02f6b57so2237244a91.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 17:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723855598; x=1724460398; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pUVcDB/UhVzyJRPGgEdwjLq8K5rZucutDkBEkag+mUI=;
        b=DGsnbGHAI0f8ZpoUzsmVCNVGmSpmSGtZu1yj6gUgNQ/JjuTL0JcsIDw2doPvgQTiw6
         fJ/2gF3IP8bn2rxFlOC/6ZKecn/Hsl55NSsvrdmvz3NjUQCfQykg34p4KaDSgnc/U7vb
         RvtQOtvzlcyrZMK4ij831ICeVbOhAesf+TRgF7eLCDpB/6QYZ9ChfiTpRasdC0vD7175
         mvw+SnMWunh9U7oM06ezdv9kVN2q70crOIA+0Eh+Qku3j7s3AiV7k0A50dtoSwTkciC3
         FYblk+42hzpAyBloF6fRBs3QMviGHoBBOaRkpb1mfX6MadCvWCZe7LOXr9rsUcd7v/x3
         DbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723855598; x=1724460398;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pUVcDB/UhVzyJRPGgEdwjLq8K5rZucutDkBEkag+mUI=;
        b=RiB0yOR5VuNeUK+LbaUXGeRE+18U2S++3CjjVl6T7jzU8AYiNNCaw9cdH/7yDdG4wI
         NsxengGkKr2F25/j6mVgje8RWtuLPrL9EmuPdl31EjWcYj5CCuPLofhtbVs6+IfzMAwX
         VwfMNvXtmHiDfsMqnuRF5nVnzfKrG9MLNVRo7ik9EtgKG/enkqGF1vUILzPVBFkO/Dlm
         rwXr4lxsWyugcvrpmXnUseqXjGlhC/nasZ0nYkCcS05FVgiw2UqWNeAoA8YJfU+iywVB
         qtF/dRoOfOFCgR4eJnjR7naIgeSn5IL+KhaVmXGFQ7uBeYLfVPOBq0E+HO2gG1Q85Qm2
         xYdw==
X-Forwarded-Encrypted: i=1; AJvYcCXDvpr00vk+9xSI2Nn+7/akVuW0YMaqSK+GtFhmkwJS6KsakkpEZgq+E0xOJNkCUTzwO70zOF4VSrlV3EsqOx5z+qePLLXy
X-Gm-Message-State: AOJu0YxTgtob7d+o60o4krayZN4qklTvGcpCi9mGCdEfYx93JAM8h3iC
	O4ZP8AFmeATF6/Sk9xNODIqUj2Y08cx2A5NzzGRh71aMjPJv6LIPHvFFHqORSePGROUdypAZcZv
	s+g==
X-Google-Smtp-Source: AGHT+IF8ePhNFPsi5W3jK4xS3om0njOksRe8S5j87v+OHTQjcpd6pz36Ai21gNWSPDXmyrWg15yLm3dMmPg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:fcb:b0:2d3:c00d:b362 with SMTP id
 98e67ed59e1d1-2d3dfc1310cmr13127a91.1.1723855597709; Fri, 16 Aug 2024
 17:46:37 -0700 (PDT)
Date: Fri, 16 Aug 2024 17:46:36 -0700
In-Reply-To: <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-4-jthoughton@google.com> <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
Message-ID: <Zr_y7Fn63hdowfYM@google.com>
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024, James Houghton wrote:
> On Tue, Jul 23, 2024 at 6:11=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > Replace the MMU write locks (taken in the memslot iteration loop) for
> > read locks.
> >
> > Grabbing the read lock instead of the write lock is safe because the
> > only requirement we have is that the stage-2 page tables do not get
> > deallocated while we are walking them. The stage2_age_walker() callback
> > is safe to race with itself; update the comment to reflect the
> > synchronization change.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
>=20
> Here is some data to show that this patch at least *can* be helpful:
>=20
> # arm64 patched to do aging (i.e., set HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_O=
NLY)
> # The test is faulting memory in while doing aging as fast as possible.
> # taskset -c 0-32 ./access_tracking_perf_test -l -r /dev/cgroup/memory
> -p -v 32 -m 3
>=20
> # Write lock
> vcpu wall time                : 3.039207157s
> lru_gen avg pass duration     : 1.660541541s, (passes:2, total:3.32108308=
3s)
>=20
> # Read lock
> vcpu wall time                : 3.010848445s
> lru_gen avg pass duration     : 0.306623698s, (passes:11, total:3.3728606=
88s)
>=20
> Aging is able to run significantly faster, but vCPU runtime isn't
> affected much (in this test).

Were you expecting vCPU runtime to improve (more)?  If so, lack of movement=
 could
be due to KVM arm64 taking mmap_lock for read when handling faults:

https://lore.kernel.org/all/Zr0ZbPQHVNzmvwa6@google.com
