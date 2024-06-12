Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDD42868D
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 17:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718211620; cv=none; b=A5zaeZaWJbG/MMtFJWDpKFkVHJG+JcUfdsyik0v73ZP+vxaWbknLutatBDHIEr14FRbJVp7zhxieCXdtkkj2+Y0xLN+DOX08MV589BsbmS9xSGKSnCg+9GbdGtjBHMgIQQPLXQoPDSmm6QO0y/ibUqxVPexwl/RZ1GbrvbMXYB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718211620; c=relaxed/simple;
	bh=lk6GPRb8cDY1Px2newtcG+uxRs8xIZKv4PbSRzkuVfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m3hAggDIovBpg36PoAUIfHLFl5xZfMHsExen8MI6Fr4VWSVTmHRV87ywlN13OC90G4X47XZZPcClX0YgJUJuXil/2By0S2a7Cp/50YVUVXoH3LONeo2GUwcDQWDFOW1ct+Iwx5N9A9BUj2v7E09qql/aQzCh6afiOHzRDBcKdPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MJeDdK+1; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MJeDdK+1"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42175bce556so1555e9.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 10:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718211617; x=1718816417; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HsvWeW5eyBF6ROygK9LGppgGGqUZLW2+K1PQvnJ6/gk=;
        b=MJeDdK+12wPn1wpx7i/7JzdRSZIE2ld9Xo31RSfR9UMZUjx6r+7/c5bduRZTrsAHWQ
         TpnKOcR44nkHeD0QHRF75Vk3NQDj9v4M5TxHpEemEsGJumNzahBsQIKq2VKef1YDutxM
         wSW0ZaIAgdrel17d0aekvb1AhD4mngmHZQXoqNjhj+ERrqH2gweFABwnjB/4x7GpHAGb
         sLIrjCO2COCKOlbS63gdf1XTWwyfsKJEwxBQOCBe6B1xFCwoo2j2jaJPEba5lJk8Y//z
         6vkfKTo1IgvkBn8n+T1aYwrMl2+LPs95kXlC87kfv09wTUr8aB62Jd/J3jrJaGr7N9eR
         BpSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718211617; x=1718816417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HsvWeW5eyBF6ROygK9LGppgGGqUZLW2+K1PQvnJ6/gk=;
        b=JfAb5ZQJPPjyPeOi/edKcX8RLMATul6QYJuOf5pAGx99CEcabIofOOOS2JEpM2aNYO
         j7yrPCwbNgDSIQTljcA7BrtiAZ2eoaK40tHqAfMajTrcp9p/uniwCTpFzQrljVw/MLFS
         pHO9Dlba3MuAFVWttZ22KcI1bHqm0pCMLPPihtrl+eg29Ehwv/1AEroTLv9zUgFwPsiz
         ksuX52UnpHUjz7mc6VE3GdS5gSTbnJRyvDdVsWC7lR6XsjJEN8jhLyUQTFTIhzUNZm6X
         m1caf1kHRD3z1ubWVFuh+D0qGeEbUNuB9YU+eXXx2zUDmRNyS5Hv0eidSWhGMsD0SuS9
         Q1xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRfa8RzaLyNhuWDRTxPBSGg3aeeDGqwNDF4RhiMBce/AtOQeYA6FX91FManU2sb460fNmfTJTZKxO33WsdAW4/FVoD0Ae2
X-Gm-Message-State: AOJu0Yy8y9nzawyJhZWcwma3fcv5FZc56f+TFwCXj6CNYci3RSUlk/Sa
	ZmeBtpooJ7KLp8qY5Y/Q9Yx2dsgf3ngG/dN3IddnCbdSdNQZiKGIfFGrfaHubnEzj8CQI0l/B+g
	lH+anzsjAWJr0GSLC5N+2lioUMC6/J4IcbVtg
X-Google-Smtp-Source: AGHT+IGkC8R6gs8FWiWHpUMtbGyq+bA7RbAETq6ID+j0qnlJP6qfOP8ypwWfjR3KUBqpX/w72oFg8by83yIZWemEZcA=
X-Received: by 2002:a05:600c:501e:b0:421:7195:43e with SMTP id
 5b1f17b1804b1-42280dae244mr2301425e9.0.1718211616345; Wed, 12 Jun 2024
 10:00:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-9-jthoughton@google.com> <ZmnGlpBR91TyI3Lt@google.com>
In-Reply-To: <ZmnGlpBR91TyI3Lt@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Wed, 12 Jun 2024 10:59:38 -0600
Message-ID: <CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024 at 10:02=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Jun 11, 2024, James Houghton wrote:
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index e8fc5ecb59b2..24a3ff639919 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -870,13 +870,10 @@ static bool folio_referenced_one(struct folio *fo=
lio,
> >                       continue;
> >               }
> >
> > -             if (pvmw.pte) {
> > -                     if (lru_gen_enabled() &&
> > -                         pte_young(ptep_get(pvmw.pte))) {
> > -                             lru_gen_look_around(&pvmw);
> > +             if (lru_gen_enabled() && pvmw.pte) {
> > +                     if (lru_gen_look_around(&pvmw))
> >                               referenced++;
> > -                     }
> > -
> > +             } else if (pvmw.pte) {
> >                       if (ptep_clear_flush_young_notify(vma, address,
> >                                               pvmw.pte))
> >                               referenced++;
>
> Random question not really related to KVM/secondary MMU participation.  A=
FAICT,
> the MGLRU approach doesn't flush TLBs after aging pages.  How does MGLRU =
mitigate
> false negatives on pxx_young() due to the CPU not setting Accessed bits b=
ecause
> of stale TLB entries?

I do think there can be false negatives but we have not been able to
measure their practical impacts since we disabled the flush on some
host MMUs long ago (NOT by MGLRU), e.g., on x86 and ppc,
ptep_clear_flush_young() is just ptep_test_andclear_young(). The
theoretical basis is that, given the TLB coverage trend (Figure 1 in
[1]), when a system is running out of memory, it's unlikely to have
many long-lived entries in its TLB. IOW, if that system had a stable
working set (hot memory) that can fit into its TLB, it wouldn't hit
page reclaim. Again, this is based on the theory (proposition) that
for most systems, their TLB coverages are much smaller than their
memory sizes.

If/when the above proposition doesn't hold, the next step in the page
reclaim path, which is to unmap the PTE, will cause a page fault. The
fault can be minor or major (requires IO), depending on the race
between the reclaiming and accessing threads. In this case, the
tradeoff, in a steady state, is between the PF cost of pages we
shouldn't reclaim and the flush cost of pages we scan. The PF cost is
higher than the flush cost per page. But we scan many pages and only
reclaim a few of them; pages we shouldn't reclaim are a (small)
portion of the latter.

[1] https://www.usenix.org/legacy/events/osdi02/tech/full_papers/navarro/na=
varro.pdf
