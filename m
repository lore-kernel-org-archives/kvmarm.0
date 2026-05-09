Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F532E2DDD
	for <kvmarm@lists.linux.dev>; Sat,  9 May 2026 23:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778369239; cv=none; b=GRq6b+eo6l0Sgc5gUYkVxB7ENX71ZM73jPKYvwAAm43W2bc6A6RugYmbkgzsk5OUE0Dc9z8GxxX+i1GkzePqV4ynVD0PmuIjT3Th+eYV5E4ZVfijNHuGybhDxFq2HkbhqbO9/MCQRbHn5LRg4zp/xGUMiebpzAeyoAEVhFymm+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778369239; c=relaxed/simple;
	bh=9b5dysotYvhcuqEuavmIJ06qiqt7pvWEv58b6w3WYXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffsfROcYdudO+DQYNPJgzIQGNieGCoGzoLLaCT5ysOwRK7Ow4KFPZ9Los6oRXf7HOo3LBk9yUPIWlGUOxYLvvNrxFTYcjRfyHpQB7tIqv1287RG3/udhe5IaUPi3XOzkXvVBChSPPb1wQLLwZWbHEUDhCO2dohdtPIlhD5AF+7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=V6onGv3X; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="V6onGv3X"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8dbbc6c16b2so424738785a.0
        for <kvmarm@lists.linux.dev>; Sat, 09 May 2026 16:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778369236; x=1778974036; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eKk8Oar5iZKEtHs3mIMqLniZOpjNKKqk8+Ef4SYJV3s=;
        b=V6onGv3XxVPpTKPN+pT62I2fHZuzjgZf0pho8JfdIbzB6d8OpbqXPTQYXgR6ahpzus
         C1klVDc19vBmuEsJ2kVDOagSRxxDjYT5aLg9yWa0KNe+XobvcUbexDycMT41kiuTQxMV
         fPGHfkR5Sog0UFoO40ssaC0vCvKNzXT71gfwaQNnuCNy2GTcG5UiO0HHJToNOeMFHfN0
         VwgUDsRGgQOXr9DuSUaI4TmZweSve1Z+RnaB8audrmZlI9pLvV09ACl/xVSwNK5/xUwX
         VEBOHZ5jdviHud6ryFh0IcMNSIOjVvLC7Uab2gGYmxihxODKTHUipV25WV6hQ6mtFnjw
         f5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778369236; x=1778974036;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eKk8Oar5iZKEtHs3mIMqLniZOpjNKKqk8+Ef4SYJV3s=;
        b=KFo+bk4TLJyqqrZaKsroFo2x5nyEL4p+7Z4MeZbSOfZYKtC1ZDXySpjBfSwa5nZT0e
         GQl3YVorCI2ddj3F4AJlPEsYYq4JhA0ipm+J0w4SsV2HEb5k3RwLE0Eg1KTSwQ1J+O6z
         lOM1qj/7F3mWr0+88i88K4zmIolEGMuLk707gGpjJUuAU9nR2QX+UrR1uJdGdv/1F+NR
         6dBv0yu3bls2nghxNehtibARufZtU7tT4EaA6jp7bLJZ8Hv0mfdSMFJaLp9n3aFmfqMl
         VR8/d1nUzOJdBvyQ+YS79jr6HYdnTiIXPK+DuV2keSKXkjSUHCv1mogA8wSp2rkRioxO
         kKrg==
X-Forwarded-Encrypted: i=1; AFNElJ8ZAwYhKZ66tmf85fSrt58EWltPRex9QufngKow+id8rZzSSBFlP2lFFih7xWGwAmkSUOIcyPI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvFRHUucgDDzyeAljy3F3Bzc22Nt62OMSCGC7KvhMnfCOxn5Jl
	kGlloyqkNYkiDa45UW8B54zkG5Ht3BwSRPY++OL1PKA7Tnz1ozUjWMka7jnNliDIfNs=
X-Gm-Gg: Acq92OGbRFNzthwlfXF5qztFnIp+gYkRadpouUzj6dNgHSlw7LPdp7r71U45IPM7Rne
	4tw6hEY4syMFfPpM1+qU1LadiXfLVCnl62Fcc2PKACAVQ5t4Kg5Wqy2noKj/bzoJjneyzYWE42d
	TbW2TyNGZCBc/bvxuYgXhxA+kn03TEYa69yNRyXwVfN8jDtjvpRYuSSvlOnfxRmAUSXDIONec5z
	ZFp7ooe2rIZ0vQtxscvuqf3aC4mSSKBNTTDmTuYSP+2+PhoWIdsn/VuAsZlYKwGz71RJmK2VdHC
	1Wbj+dL1rdK+LhAw2QK7u2OSPyCE0DMyg0i9UxHlL2vt5oRcTq5zTV/OVQ46bHtVVYPM9/jIu4j
	IiHPVj/Hzow+kiFR3/GqzDSV+Uy61WrOBqxsElP+zfDRpmmkW6Ok0kw3aZ5ff3OjdiJPv3HqKXG
	mghK7ugIUuDnKUPHF4/BTTlLWlFaA0GtgEhX2EJWIiwi5oCMAYPUqXgJWH7PfWhi3PP/KOMf7Hj
	7+LkA==
X-Received: by 2002:a05:620a:28c9:b0:8ef:3312:a165 with SMTP id af79cd13be357-90652193274mr1653712185a.24.1778369236452;
        Sat, 09 May 2026 16:27:16 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b87c3e01sm668270685a.26.2026.05.09.16.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 16:27:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wLr4k-00000002NhK-33XE;
	Sat, 09 May 2026 20:27:14 -0300
Date: Sat, 9 May 2026 20:27:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <20260509232714.GI9285@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <20260501130006.GF6912@ziepe.ca>
 <afiRB3e3o0G1oZvY@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afiRB3e3o0G1oZvY@google.com>

On Mon, May 04, 2026 at 12:28:55PM +0000, Mostafa Saleh wrote:
> So far this is the list of requirements/changes needed share the
> stage-2 page table (besides the obvious: same page table format,
> granularity, endianness...)
> 
> 1) HW BBM is not supported in the hypervisor page table, that’s
>    because it can generate TLB conflict aborts, which the hypervisor
>    can not handle because of the limited syndrome information.
>    We can rely on FEAT_BBML3 which was newly introduced to work
>    around that, it’s quite niche and not supported in KVM yet or
>    have an allow list similar to the kernel
>    (as in cpu_supports_bbml2_noabort()) which also limits the number
>    of CPUs that can run this.

Do you think pkvm will need BBM? Hitless replace of a PTE is already a
pretty advanced feature and the SMMU has its own support matrix there
too. Is it for shared/private conversion?

> 2) Handling page faults, devices must be able to stall and let the
>    hypervisor handle the page fault (which has to proxy through the
>    kernel as the hypervisor doesn’t handle interrupts), this includes
>    also IO page faults which are hard to get right from the HW which
>    and may lead to system stability issues or lockups.

No.. once you turn on IO like this you don't have page faults
anymore. Everything must be permantently mapped into the SMMU view, it
can never be made non-present and you must run without page
faults. That's what you have in the io-pgtable constructed table,
right?

>    Alternatively, we can pin the stage-2 pages, that would require some
>    hypercalls, hacks to the driver/IOMMU API and possibly new semantics
>    in the DMA-API for IDENTITY devices as they will still need to pin
>    the pages as they are actually in stage-2 translation and not bypass.

?? Then how does this series work?

> 3) SMMUv3 must be coherent.

Yes for sure.

> 4) Support BTM/DVM for TLB invalidation, otherwise some hooks are
>    still required (although not io-pgtable-arm)

SW needs to forward invalidations, BTM is rare..

> IMO, 1, 2 are the most tricky parts. It's more work and runs on very
> limited systems, However, it can be implemented as an optimization)
> which is my plan.

I think unless you can do it without these HW features (excluding 3)
don't bother.

> I am not sure how CCA deals with that, I’d expect they have a lot of
> constraints on CPUs/SMMUs and DMA capable devices on those systems.

3 is not supported. The entire S2 is permanently mapped and doesn't
really change alot at runtime. No page faults, not sure if the RMM
private/shard conversion would require BMM..

Jason
