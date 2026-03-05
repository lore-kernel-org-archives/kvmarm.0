Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93759334374
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 13:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772716428; cv=none; b=CggxY539fyUcg656AtfQurwYMpQykYBc84nYuxv5BDt8VNQKEwCcWCEnQNlIzDDYGlfM21Uz6XsKz9jV6qMR9KH5bExgOR5sDhIi3wic1Ip7sJRvWTeiVcbse9fteMD9duzLll27JyOXOAjeKyTZb8362prItaWlcbLmK09pP8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772716428; c=relaxed/simple;
	bh=xzoyBsS3RdfXZnuxTKduBYkLsBpXuUM8LDu2CyMKGgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6fqvuNEHhyPpzHjbjjXMNXNNe9n3vIdA1vzGy5oCcFXWqBy6+0ajpYxhzmVO9WXnDQGEdMtgeIOCkzdwMcAqGgpqpPx9UDepA/KKj6z/GFw0L0p1ePyHZzODx8HRxqqR8FmfXrNyV7fQfY0RlgJKm+GhVWqhvG+DfV/XwPqAW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x3eqn5td; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x3eqn5td"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5a131870b72so867178e87.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 05:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772716425; x=1773321225; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Vo6LolXreM1BYx+KUx8ovfJxU2nYq3Q7Wemen42flk=;
        b=x3eqn5tdX1BSAdB90I7/B8h9dJsfB26NEFmeLy0IzljOrSPrtaGL2xpKegNnKAgjJB
         z2VQIq6j8GE5kLsUIbz4EZFbihGMXDR1sFZUGxfVZld6mUa0PtJbe+J7hxdfGpimeFNM
         tp7xIuPgXRbSUv1A7/rSyc+ovPVwSh4NUEpQ+fqMRF8b74y4JjjHYz4eTH/gfdGGJKzT
         hphAT2HaVMOgQkHVFdyZ/tNNussa9/ktzNh+Fzr3C0/ghAI3d59AGmbZLDax13Ij7r9P
         oZprOBgEY+FhNP5WL1jlDwePt/uhQXE2soaqaWCXWdVYxkZLKBwIAVp2pmCldhnJaeV5
         lnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772716425; x=1773321225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Vo6LolXreM1BYx+KUx8ovfJxU2nYq3Q7Wemen42flk=;
        b=oZQQZz86tijSuRetcQrkczk0WvDDTlh6kEdwZ2O5q1ibQF/S5PeA6QGjgM/TXP+kYj
         lpJQvS6KAm6Xmsw/018iezJt/QCXhlXmg9JFG6b/2/vGM3sGPEDDbKvgMXm80+3G+4jw
         PI0DCpoM+QmVk/hPg/b2nrlPDianThqXhkngYxXoFdb0MmhDLjZQSkKZE9lghyrbpRst
         EJelDup8Oztf+p8mZ3dhmGhTjfXW68TuTlheMHE+1XD9+0xePCNCcu10sOXa8Y/MtPqS
         M9ii49itHAjPMTL1rL61kKiCrVJBcBRXh/8EC2q5yxSXPJgN52hv7cOLqSEsX119niN6
         zudg==
X-Forwarded-Encrypted: i=1; AJvYcCWq56uFcxernubfy2Ky2NBebyDzPMgn/C2a4O/+NzPm0FBPHa/BzenupnNEiBZpoGkpYjNH/yw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYnXnDobJby7gIpSwf1YKAYpKNKJrd8vr/z3U/zqvAJH9SzQzX
	hNaaLIPZqNfdHPnBLd3dUY33s4mYfyx2IPZTvHiyayoi03VeLXRrmBePDDJYxVaphg==
X-Gm-Gg: ATEYQzzio7MGV4ulb49taRzf7JgU1X4xTE0aKT28jE2R4PbVMJ7xWAdYx92TtBciiwd
	IWlhhzDh/vUeMR8tHZndvbo5GuLwslHla40473mlW3w2qjEquxz7f0S/KbfjUUnXICsA+jln0JC
	VoQ5prVjn/V1iXc624wu4zwImKzgDEwoui0bWJNiBt9SJuBszXBo4N4aVLuVTZIgaPfozxilWui
	iIgzaHtV37vkz3fbLAao3UjnineFKLfYiyDk56GlIjENdB+nJl1eTB7ZcnouR2RYkCtV+Dveoc9
	Etz7riT9pVHg1GIxZLxq+LYdxqmPlAcx2R83+K2AV0XqXwDD9IdxCWJGfXqzBaGtoPJcsfdfllM
	zNWsHapCl3kGS0w2jIXgIKTq1XmtGqMFxPc8NRii42lTShlLOf2v4nFHLmAPgBvLDJit+uU7ZO/
	Rs/YR9dUmsMctkqieh0KUVWkTdwElkiXxselO1QFaFVBWOI10jSSwbydirXePlQSqVcg==
X-Received: by 2002:a05:6512:3b14:b0:5a1:1daf:f7b2 with SMTP id 2adb3069b0e04-5a12c2990e7mr994159e87.0.1772716424198;
        Thu, 05 Mar 2026 05:13:44 -0800 (PST)
Received: from google.com (27.69.88.34.bc.googleusercontent.com. [34.88.69.27])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a1308fb9eesm519960e87.66.2026.03.05.05.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 05:13:43 -0800 (PST)
Date: Thu, 5 Mar 2026 13:13:40 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Leo Yan <leo.yan@arm.com>
Subject: Re: [PATCH] KVM: arm64: Adjust range correctly during host stage-2
 faults
Message-ID: <fdqyxxlu2n4hngowq2ksllhwew33swrsj6mqpeyzb7vaofzuzf@ks7z6dnatyoo>
References: <20250625105548.984572-1-qperret@google.com>
 <86wlzr77cn.wl-maz@kernel.org>
 <86seae7dg1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86seae7dg1.wl-maz@kernel.org>

On Thursday 05 Mar 2026 at 10:55:42 (+0000), Marc Zyngier wrote:
> On Wed, 04 Mar 2026 18:55:04 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Wed, 25 Jun 2025 11:55:48 +0100,
> > Quentin Perret <qperret@google.com> wrote:
> > > 
> > > host_stage2_adjust_range() tries to find the largest block mapping that
> > > fits within a memory or mmio region (represented by a kvm_mem_range in
> > > this function) during host stage-2 faults under pKVM. To do so, it walks
> > > the host stage-2 page-table, finds the faulting PTE and its level, and
> > > then progressively increments the level until it finds a granule of the
> > > appropriate size. However, the condition in the loop implementing the
> > > above is broken as it checks kvm_level_supports_block_mapping() for the
> > > next level instead of the current, so pKVM may attempt to map a region
> > > larger than can be covered with a single block.
> > > 
> > > This is not a security problem and is quite rare in practice (the
> > > kvm_mem_range check usually forces host_stage2_adjust_range() to choose a
> > > smaller granule), but this is clearly not the expected behaviour.
> > > 
> > > Refactor the loop to fix the bug and improve readability.
> > > 
> > > Fixes: c4f0935e4d95 ("KVM: arm64: Optimize host memory aborts")
> > > Signed-off-by: Quentin Perret <qperret@google.com>
> > 
> > This patch prevents my O6 board from booting in protected mode as of
> > e728e705802fe. Reverting it on top of 7.0-rc2 make the box work again.
> > 
> > I haven't quite worked out why though. The hack below makes it work,
> > but implies that we can get ranges that are smaller than a page.  That
> > feels unlikely, but I'm not sure we can rule it out (the kernel page
> > size could be pretty large anyway).
> 
> Having spent a bit of time on this, I'm pretty sure this is the cause
> of the issue. The memblock tables are as such:
> 
> maz@cosmic-debris:~/vminstall$ sudo cat /sys/kernel/debug/memblock/memory
>    0: 0x0000000080000000..0x00000000843fffff    0 NOMAP
>    1: 0x0000000084400000..0x00000000845fffff    0 NONE
>    2: 0x0000000085000000..0x000000009fffffff    0 NONE
>    3: 0x00000000a0000000..0x00000000a7ffffff    0 NOMAP
>    4: 0x00000000a8000000..0x00000000fffbffff    0 NONE
>    5: 0x00000000fffc0000..0x00000000fffeffff    0 NOMAP
>    6: 0x00000000ffff0000..0x00000000ffffdfff    0 NONE
>    7: 0x00000000ffffe000..0x00000000ffffffff    0 NOMAP
>    8: 0x0000000100000000..0x00000007fe4effff    0 NONE
>    9: 0x00000007fe4f0000..0x00000007fedeffff    0 NOMAP
>   10: 0x00000007fedf0000..0x00000007ffffffff    0 NONE
>   11: 0x0000008000000000..0x000000807a290fff    0 NONE
>   12: 0x000000807a291000..0x000000807a2927b2    0 NOMAP
>   13: 0x000000807a2927b3..0x000000807fffffff    0 NONE

Ouch, these last few are 'interesting', oh well :-)

> Any access to page 0x000000807a292000 is going to blow up in your
> face, because there is no way you can map this and still respect the
> memblock boundary. Same thing for any region that is smaller than
> PAGE_SIZE, or not aligned on PAGE_SIZE. Which is even more annoying.
> 
> I'm starting to think that my hack is not that idiotic in the end...

Yes, I can't think of anything better TBH. We've already asserted that
we don't have an annotated PTE here, and at the last level we're
guaranteed not to accidentally map a neighbouring private region, so yes
we should just proceed with a page-aligned mapping there.

Want me to post a proper patch or do you already have one in stock?

Thanks!
Quentin
