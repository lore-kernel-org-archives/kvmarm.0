Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0C9485CE6
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134300; cv=none; b=FTTBhX/m4OLgwODG1WJ9trHsjVDi8OhxNv+ISVGTF03YtMH/GXgxHnVmTzOs8Qq9C1cBriiQqj0ez8Si3mkO5JrgUVradQ+gpq1xsz7Rsve/CBtlPHJPvoIe9UVKwVGGmDuuaAxrZTtVSNnU2zhEiP1nul3j8yGSbXoaPuCYnwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134300; c=relaxed/simple;
	bh=z1IBBN+1WUfDf5cT8bAka5f8p45OV+l+sxZzQy3xMvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o3LtdN/fYdAiQfqjLwZ7d8frogIHzIf9N5BRUJ2tf5ohQcWoMmzlk/NcS+EkC48dbmZB5+CpTuVzrVYUUtEo05nno5n6KA56MQhLEfSkARL6EZfMs07VnYmFDWrIqh8g0XNhBtk9zUpWvrLi6VsOoS1PLLd8XMU5OsNni8IJSHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ewDHLYok; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ewDHLYok"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbee6bb8408so1114122a12.3
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134291; x=1789739091; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=35qTFGciq12kEJU+EMJ4woELZzEj6I4YMtoPAd4aNAQ=;
        b=ewDHLYok0hz6jSUZb51Zl9R14qTwzUXqsAfXC4yGTS8ZzlV+7sGmt4nwqGCbGztQbe
         GW/kCVqwNPO93zS7oPzQ9L2/gvV09aE8LrlMaNE8Lh8Q1kM1uap3w4GiRoEYO8n9clVU
         0A6nWnsaWqV/EhpfhxDZ5GF18cD9f65U0M77Z/fIUKgotGYhat+0Rr76GeCxUig1ZlER
         1lWrxtlpwIiBGSSUe60ET9L41tlUb0qCZyY9VSBsb+fV0DQAPXP86KVO0TR6gtLsXix2
         aL/2nqRMBtLKAfV+aT5NvkA9gbxd3xIS1Bdx8j/7buGp1q4WVy5i8KTLvuyZ4O8b80tc
         EPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134291; x=1789739091;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=35qTFGciq12kEJU+EMJ4woELZzEj6I4YMtoPAd4aNAQ=;
        b=KoCI0yBG6AQLbvIVxQnbJkY7FMN8A3VE6EABE3ZaiIOseN2GLc5N4R9cAC2FD/RKH5
         YxqEhQ3F8XGcZbb8zfQCEN7rlhJ5RtQ5ZKr7qKRQOc7o4vNqvtMThDtDct5nfCw0Jef/
         RPv4lcV9r/LvImhM1dMzI5LQemwIUpLGw+bMbIrh6SPBnf4aOdNgQoDcXrEwwqqgduZ1
         lNilUloOvCdiKTKLt6J2DgH1+ec0ZKxc+1x9V6UGuaoj60kFhqBmQawtYZZVhUrjQ1tt
         P4FO0MQ5AGQyOJeDjStdyx8IBuPKnYSn3GWWf4ahXlgWL+z6b+QQ0BYFxbxm14kDDyYe
         rkHg==
X-Forwarded-Encrypted: i=1; AKwUvBz9HLtw3YEe6z80RUf16o3memXDZdkCp4+L5nLAbCdoMGweVZPdfGfrptecj47rDPeLYbJf1HA=@lists.linux.dev
X-Gm-Message-State: AFuF++msRsSgh28l3jSm0mOuC9ZmebWr8eC8wsDrh0qoSg7x5G5iwvGe
	zqubS4E1ufxcOVoCVviHXhhK7P0WnI2UjzPRKyVyDM51xH7OhVs2qCziJU4E18Ectr0AsCvfSYw
	R868R7w==
X-Received: from pgjj10.prod.google.com ([2002:a63:230a:0:b0:cc4:5907:21e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:b08d:b0:3c6:61b9:917c
 with SMTP id adf61e73a8af0-3daed1fd3cfmr8633653637.11.1789134291123; Fri, 11
 Sep 2026 06:44:51 -0700 (PDT)
Date: Fri, 11 Sep 2026 06:44:50 -0700
In-Reply-To: <20260910225728.GB857650@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <aptFFYqcSiBdMLE8@google.com> <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com> <20260910143448.GD3968357@nvidia.com>
 <aqLOWkuVKccR-I7W@google.com> <20260910171210.GF3968357@nvidia.com>
 <aqMgjXfTJ8u3n7Kj@google.com> <20260910221832.GH3968357@nvidia.com>
 <aqMyXE-fD-UN6w5L@google.com> <20260910225728.GB857650@nvidia.com>
Message-ID: <aqQF0gz3Q2weDyEd@google.com>
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Logan Odell <loganodell@google.com>, arnd@arndb.de, 
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org, 
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com, 
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com, alex@shazbot.org, 
	kevin.tian@intel.com, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> On Thu, Sep 10, 2026 at 03:42:36PM -0700, Sean Christopherson wrote:
> > On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> > > Sean's initial email was asking for strict never-break ABI compatability
> > > rules on top, and that is what I've been reacting to.
> > 
> > No, I was never asking for that.  I think we just have a different interpretation
> > of ABI, or rather are talking about different pieces of ABI.
> > 
> > I am still asking for never-break serialization format compatibility, i.e. the
> > more literal save/restore ABI.  I'm not asking for full backwards/forwards
> > compatibility across all kernels version, i.e. the higher level "kernel" ABI.
> > 
> > To phrase things differently: I am a-ok if kernels are inherently incompatible
> > because they fundamentally operate differently and/or support different features.
> > I am not ok if we end up with incompatible kernels because the save/restore
> > interfaces and payloads are poorly designed, lack abstraction, etc.  
> 
> I can more agree with this, it is mostly what I thought we'd end up
> doing anyhow with version numbers and growing the structs not
> replacing them.
> 
> So you still end up with a version label (string I guess?) because we
> can break it from time to time, 
   
Why bother with a label/string?  I don't understand what it buys us; I see only
pain.  Make the features discoverable and punt on all of the "is this pile of
insanity my company has created compatible with this other pile of insanity?" to
layers above the kernel.

IMO, trying to capture compatibility in a version string is doomed to fail.  To
be useful, the version would have to be extremely sensitive to changes, otherwise
userspace will have to do its own compatibility analysis/checks anyways.  And at
that point, a verson string will be too restrictive, e.g. will mismatch due to
changes in features the deployment isn't using.

> just the version should have the feature mechanism layered under it? I'm fine
> with that
> 
> Jason
