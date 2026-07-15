Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EC93546FA
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784113227; cv=none; b=MJOday8yjwYdx1PD8ON5tGOdHMHU9oVi/x2MBClsfhF613v8M0aTudEQ6V+sXxyfdNkb/uaLJIv9WZuwTcqtpj7nlTzX9KEPnek96d9ZoVWbKdFBawb3nAoYC0UDrBITLEoJ111/tYD0gCk4Lyj4WMwH6l0uuM8RshvKokjLqVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784113227; c=relaxed/simple;
	bh=UU6e+H5is0F6UZdW4bpH1uTAfABZqfH4PRTLFj4wF5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OSVjoAhr2X8c1mWibpxf09YVS/s2MBnu7CibQ1wZ93gRD4PDwayAMM0seawpgtMOnh1AQ5AcW2LDTSm7G8Xf3Zz6/SGpFp2+4lU/Hh1UwAANCR3Znz6Eci+S+d06pa8xCxlD63j+MmNdt1WqvsBTcG3VQecyOBdYgXRlrcuO8Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eOO4iK91; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eOO4iK91"
X-Forwarded-Encrypted: i=1; AHgh+RojZYdwQAJhrsVvLouv5X+DRoPUGlfv2PU0lPUfexoQ1anaSXik14TNkFvUQX6ETdCHHgPnPDY=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784113222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wutSnxvNy6igvRaEMd3gbXrLUSUMVfUeeNmLPMM/BOY=;
	b=eOO4iK91nf5GEHPIYs+8zbgetmlIiy8ekgj3wLZOmAtkzS88htHAOX8HgksvM3Q/qcsN/n
	N7a61aB4UXsMlFuYncWT2POtYucqCvfymVRKZPJVqlelhzMWiakU0wJ8nm9k8HOGc1ePsP
	qINBZvrgdFGJpOSBP4ZOGON/DRA9K/Q=
X-Gm-Message-State: AOJu0YzPfbSIroTdgNFotrJTmtrk+mJtgHGO05OHMlARcQsDtxCrJzWd
	ZNr7VvAfA/1CeE4I6UrgVS4IVplnS/ShI0M9vCeL2KF+joQkECVmw7Wd6Y8fOLrAVpEmt3N5ths
	uNC8MX6pns1fS3VvTZfEYjiVW8n6JTa/vIKuFCdGJ
X-Received: by 2002:a05:622a:448:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-51d7bdcb639mr25256371cf.12.1784113203159; Wed, 15 Jul 2026
 04:00:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-5-vdonnefort@google.com> <CA+EHjTzbQukkKpNfdTHKS5aAPCn4hnCxu+EHnm6OWpW=mTS+Gw@mail.gmail.com>
In-Reply-To: <CA+EHjTzbQukkKpNfdTHKS5aAPCn4hnCxu+EHnm6OWpW=mTS+Gw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 11:59:26 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwSupmgbjbeUap4EEwy8DP7y8euZRHd2tXc=FSDGzrghA@mail.gmail.com>
X-Gm-Features: AUfX_mxVJTjJv08F71yWXWNugINBRmANHQetyviK4RJokRf0LnDH0xcjy4A1SwY
Message-ID: <CA+EHjTwSupmgbjbeUap4EEwy8DP7y8euZRHd2tXc=FSDGzrghA@mail.gmail.com>
Subject: Re: [PATCH v2 04/18] KVM: arm64: Add a heap allocator for the pKVM hyp
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 14 Jul 2026 at 19:35, Fuad Tabba <fuad.tabba@linux.dev> wrote:
>
> On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> ...
>
> > +static u32 chunk_hash_compute(const struct chunk_hdr *chunk)
> > +{
> > +       u32 hash = 0;
> > +
> > +       BUILD_BUG_ON(sizeof(*chunk) != 16);
> > +
> > +       hash ^= hash_64(*(const u64 *)chunk, 32);
> > +       hash ^= hash_32(chunk->__unmapped, 32);
>
> Could you state the threat model in the commit msg? The VA range is
> hyp-private and the hash is unkeyed (anything that can write EL2
> memory recomputes it), so this only catches _accidental_ corruption,
> i.e. a debug aid.
>
> Since that's the goal, should it be gated on CONFIG_NVHE_EL2_DEBUG
> like the other checks here? As written it's O(n) hashing per
> hyp_alloc(), in production, for a check that only fires on a hyp bug.
> And a plain XOR/additive checksum would be cheaper and just as good
> for accidental corruption.

Thinking about it, I was wrong to say that it would be just as good,
slightly cheaper, but it would detect things like swaps.

Still, I think this should be gated.

Cheers,
/fuad

>
> > +       return hash;
> > +}
> > +
>
> ...
>
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index 75b00c323310..1c10cf78c869 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -10,6 +10,7 @@
> >  #include <asm/kvm_pgtable.h>
> >  #include <asm/kvm_pkvm.h>
> >
> > +#include <nvhe/alloc.h>
> >  #include <nvhe/early_alloc.h>
> >  #include <nvhe/ffa.h>
> >  #include <nvhe/gfp.h>
> > @@ -363,6 +364,10 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
> >         if (ret)
> >                 return ret;
> >
> > +       ret = hyp_alloc_init(SZ_128M);
>
> Where does 128M come from? A comment would help.
>
> Cheers,
> /fuad
>
>
>
> > +       if (ret)
> > +               return ret;
> > +
> >         update_nvhe_init_params();
> >
> >         /* Jump in the idmap page to switch to the new page-tables */
> > --
> > 2.55.0.rc2.803.g1fd1e6609c-goog
> >
