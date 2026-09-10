Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D2F318BB5
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 00:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789001912; cv=none; b=fKxA/H6SX7DCOoRvjN7n3VOlMebVzSBlnRso7ykm8xf3q32HWEDEUADwpU2/AJajKiHd/ZisiWaf4TEXq+Z8w48y0VXto4+BplNP6nJGt0KwssMB70N3vazJ3CdEGqraS1kxX2TghVOaCK/Q8JS4EdC4Xj8peCA0L8+xVd84JKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789001912; c=relaxed/simple;
	bh=EMDY7SWycMHhwbwPHJdS4oL+eSVJ8O6B3SZMgf9trmQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WzYv4hYAaPnowc3Q52D+LzwmYq69BORqmln0dEa6YpvKEqB7zRVcB+1x87CYAnoVPSb7H7PudqVcfvEO65xLbLubTHwGQZuZvHGa9jCy1e5evZKjK5y9jz+67bxIKa9QEKs2SZs7yxdLJmDQ6G5sNHPYbby0M1Cs0HtY+qdd2DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ui7sjVj1; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ui7sjVj1"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d94f086fedso90759805ad.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 17:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789001910; x=1789606710; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xgzlS1uxnCbzGMH5pUkXS6DY1hZkFu32UCS9PdpFsuk=;
        b=ui7sjVj1u2EujwJCMubYYxBNYk5PLCs2NS72NqU54teDvlyDWofXkvAY4UF3SlqYiM
         poyqBNCGcV1Z3x1rUth6xIej2XgvYzW5jfT0L0ITwKY4gYG3lgyoCLxrkDksn6/GjjEr
         eQCBuu4PVI3oXtStJvtjOnl/ERYSu+3fM7qAZtWPx0emek0UGMtmSow6nJtEPvVPBofO
         aDs9w5xBd2HCDQPc2M/NOO15Vwq3fTsyeG8WTsWls6THFYL29HVC8skcTISH/xk5qXWL
         vOwQmt/p0TyHxVp/Fm900HQxBk0ai/wtu3uFbrlwVaY3Y2mpwP3H/Gy4aCBjx99+A/2M
         rvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789001910; x=1789606710;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xgzlS1uxnCbzGMH5pUkXS6DY1hZkFu32UCS9PdpFsuk=;
        b=haFeuRwo818sGa39juUMxLtFiUG0xVJZIQ6wbQHXOiANvaFQCm+3pL6rHNDu0Mi+kW
         iN1MmkTTUkQjkgXdwr0Y0aG9xnTY7AMxRT5QSA6sk3XN6Zyu5CjsTE9pPwDmqRbsNrsW
         BMGqouiFN83ydSW4ktpb3R8B1iqt1e5IM7M55uwYa+neQeLyA+1TqrmjL16Z7nb/on63
         1tLvnp/+bq3w/RHPJmECnE/17Lsv8g8YsVrDy+MNUQZK+y3PJ11K9sw8PvvjE4Q+yM2Q
         9YQVK68zyVx2m/2Ex1tlpVl/9ErmCsFVooK5MXG5LlBpdn8vQELNmkOmLw6pHlXaBcR8
         uzgA==
X-Forwarded-Encrypted: i=1; AKwUvByIwfbn4ld7l95OM6/KgPRI31UZUGyAjBvNmI8nSmTeCGvLcwcBxCmf67wBQlZEhZgXvAv7rb4=@lists.linux.dev
X-Gm-Message-State: AFuF++kVpJiZQ/VV9DRWFYeB5VGz0bX3nZL5SxsDCTt7CbPxZJcEJm8a
	+qgiM4+vYXfHls5JKY10YIB6+UJFU/mel4CHgRSmFPp+YFFxb7PtycevdERna4MpBRuWVaSpmVD
	g3qhpHA==
X-Received: from plsk18.prod.google.com ([2002:a17:902:ba92:b0:2d2:c22c:7b8a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf10:b0:2d9:3636:d01a
 with SMTP id d9443c01a7336-2db126669d3mr557854145ad.15.1789001909390; Wed, 09
 Sep 2026 17:58:29 -0700 (PDT)
Date: Wed, 9 Sep 2026 17:58:28 -0700
In-Reply-To: <20260905012403.GX4157646@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com> <aptFFYqcSiBdMLE8@google.com> <20260905012403.GX4157646@nvidia.com>
Message-ID: <aqIAtOoew-_6jw29@google.com>
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

On Fri, Sep 04, 2026, Jason Gunthorpe wrote:
> On Fri, Sep 04, 2026 at 10:24:21PM +0000, David Matlack wrote:
> 
> > The proposal here (which is inspired by the KVM UAPI) is to ensure every
> > LUO ABI struct has 2 properties:
> > 
> >  1. A field to encode options/features (e.g. u64 flags).
> >  2. A way way to grow without breaking backward compatibility (e.g. so
> >     we can add new fields).
> > 
> > Each flag can mean whatever it needs to. e.g. It can indicate the
> > precence of one or more fields (i.e. new fields in the struct), or it
> > can mean a field now has a different meaning (i.e. union in the struct).
> > 
> > This would enable adding support for new features without breaking
> > backward compatibility. Downstream users would have to ensure their
> > kernel does not start using a new feature while it can still rollback to
> > a version that does not support the new feature.
> 
> This was never the biggest problem. The main issue was the functional
> behaviors of the kernel that cannot be represented simply as data in a
> struct with some flag bits.
> 
> Like for instance kernel A supports memfd folio sizes far larger than
> kernel B because we fixed MAX_ORDER. You can't fix that just with
> simplistic flags.

Can you elaborate on why the folio sizes matter?  Honest question, because I don't
understand why the serialization format wouldn't express things as "N contiguous
pages starting at PFN X".  Then the implementation would rebuild its folios as
appropriate.

I could see things like HugeTLB not working if someone booted the kernel with
support for only 1GiB pages and then tried to feed it payload with sub-1GiB ranges.
But to me, those sorts of things fall into the "well yeah, don't do that" category.
