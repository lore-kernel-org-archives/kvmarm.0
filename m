Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B9439E180
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783334882; cv=none; b=J0t5sRa7wGxsPt2P/g/QG3T103j8fl3UBj2FXdrKMXNgwn7VuvVAIJnIzG/N8GnbDqQ76REaT+qK+6jcWAPT+5wiQalN54oIAil6q/W0oZer4k53087T/J0GA7kHHghLn93kujCfFZYIG0TU1ABJqVSFzQ58rQw2XBzN4L/UuDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783334882; c=relaxed/simple;
	bh=XdbwIRzJ5LGmzdsKM6xKG8KCxeBTLkfj1uBthLZifHs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OPjVlLwcFUigGj7PsAoMNFfLyvmT21GJBfKCCYiGTROUvCoYLGnmZGeczcNcuqC6gPHtSHDxlgKRgPQ7Xc2sYVS1HOoMOQD68vFgxEJFpgDDVA5NRv/R8RwkUV+5+HmQe2QPvixiM/wvIoP9eWNKUgeC77IW7LQqAt7UEZ5xU4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=US4drQZQ; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="US4drQZQ"
X-Forwarded-Encrypted: i=1; AHgh+Rr93OTlKs0wgOaDbayCrPQ7qUcgA8XId6utsoyJcMEupTIFtFY6S4oIIvExAH/2oOrCKGVJanE=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783334878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XdbwIRzJ5LGmzdsKM6xKG8KCxeBTLkfj1uBthLZifHs=;
	b=US4drQZQ1UWZZw8EdcOnOjde3O53C4ox0tu0ztWVDxUmwcvGZ8wImXHfoLN1FHFlY/0faK
	sdXDpII1GuFzIqrKZhYkqGWAPKKHA+PZ+mbKpJlhxxj1WBjiucoZWFu/i4jSNnb9Xi6wYI
	baobU+NVcihn16HVJ7nKNbHeXRQbYyc=
X-Gm-Message-State: AOJu0Yyy38Cn845k5+jq6tr94jTo91qoUWL2MS7GF9wFsdzFLKcwgEXC
	2xTE/DdLPDdlKFYmYQj/4Q4ud8IX+YMylcCduWX5p/CYdbjEnfko8wkEtBcR1olCIKmL8KTXy1m
	rn6VXVKamTWg7Nry7TDyQe0AO8GrDgc9APT3d9cUQ
X-Received: by 2002:ac8:5a15:0:b0:51a:713c:7444 with SMTP id
 d75a77b69052e-51c4c0f67bbmr17724281cf.18.1783334858095; Mon, 06 Jul 2026
 03:47:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706083555.302972-1-fuad.tabba@linux.dev> <20260706083555.302972-4-fuad.tabba@linux.dev>
 <556ab72c-f440-434b-a24d-84200bd25842@arm.com> <CA+EHjTwA1w3eE-mn2r9DCCduFQuoRn_usPO0pxGf1k-jzLsDyw@mail.gmail.com>
 <akuHe3-51jYs_bbP@willie-the-truck>
In-Reply-To: <akuHe3-51jYs_bbP@willie-the-truck>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 6 Jul 2026 11:47:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxDzdtUhOby5-PefPc2LUO1W1xPB0CvJEvXYzOkhT58=w@mail.gmail.com>
X-Gm-Features: AVVi8Cddw55U2dhcZZDW8bpdnuxYkxUOVu91WrOaSi1xQIcwNR8g8R4g7NYhjXI
Message-ID: <CA+EHjTxDzdtUhOby5-PefPc2LUO1W1xPB0CvJEvXYzOkhT58=w@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 3/5] Use kvm_userspace_memory_region2 for all
 memory registration
To: Will Deacon <will@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 11:46, Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jul 06, 2026 at 11:41:21AM +0100, Fuad Tabba wrote:
> > Hi Suzuki,
> >
> > On Mon, 6 Jul 2026 at 11:25, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> > >
> > > Hi Fuad
> > >
> > > On 06/07/2026 09:35, Fuad Tabba wrote:
> > > > Switch kvm__register_mem() and kvm__destroy_mem() from
> > > > kvm_userspace_memory_region to kvm_userspace_memory_region2 and
> > > > KVM_SET_USER_MEMORY_REGION2 unconditionally. The v2 struct is a
> > > > superset; when the extra fields are zero, the ioctl behaves
> > > > identically to v1.
> > >
> > > Doesn't this break using this on older KVM implementations ? Not that I
> > > care, but do others care ?
> >
> > KVM_SET_USER_MEMORY_REGION2 goes back to 6.8, so this would break
> > kernels older than that. I can gate it so that REGION2 is only used
> > when --guest-memfd is requested, keeping REGION for the default path.
> > But like you said, do others care for kernels that old?
>
> v6.8 isn't that old, please don't break it ;)

Sure. I'll fix that in V2 :)

Cheers,
/fuad

>
> Will
