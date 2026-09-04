Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0E45111B0
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 22:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788560677; cv=none; b=OXwXBWLnbh4pA9qdJPHMsztbrtYFObH8q3yj7cXL2j5ArW2/tYC4QvSL4APbHkeKa5W6b/C5Y59sotQYbY25KF6tNcwtEwKR9XQfRnBtLBwSGXGM8Eit5Xm2X4N+yeKQ5AcT0OdOciFzXPeZCvHRiIWt21KKsMBCORJs06NYhrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788560677; c=relaxed/simple;
	bh=3yfBn1WOKGcBed81Nlc6oSVXKJPNrdGjHRd+VzAbRwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Af2In/n362LSi7Zjmj070Av9yQ+Wdl0CEbUHdUr/DMk8dU8faA1yjr+Y220wab5Ep21WTWfkNiOSdWkBR3Y3W5HMXZWdNIf011Wq7QFdxTYzizwJlCUJwXAF4e6QT1N0KfMnNr2xVQWfU2IjSS2oLt+4imcEZhL3QPA9AuRd3Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CQ/TTvJ2; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQ/TTvJ2"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc1a4c62804so1278724a12.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 15:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788560667; x=1789165467; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eSoy4tzP5/vZd/n79Ub53Qw/sODynJmx2A4LOY3bVO0=;
        b=CQ/TTvJ2Q4WMwTy4uIxIY0OaVGbv4RtlzpI3b+y79OIKqubRTYhnCg09g/BJUZLvMI
         YN8/hLNPWBHgZNf5I0r5DqCMd0OwfwJuyoIPxCNcetSbKBLeoJBp66PNhdOUtHFM3SNn
         y15NYOpSP3H4BO4Axw5b7Gmtic/l6nrdWuaw2X9prWKsgWo/eD8fdxCggZ9cjJok2c9H
         meQPbrpxNbcVk+4w2B00MImQYL50k79dxXwnbFr21NPpIarXQWLTWXCRaOpVynhYFq/h
         26DXqe7u8FkEbIEc/lJYpUWtw2PvDRH4y3GVUeeIDwQmX34kIfYC+ISse3T3og5QjKfx
         4Xew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788560667; x=1789165467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eSoy4tzP5/vZd/n79Ub53Qw/sODynJmx2A4LOY3bVO0=;
        b=mHWg8OA0Bk1gIlJ/kcJDEU6WgXC/4v+m8BalN0hr3o1aRxfmMxzdVDctHO/bse3nWC
         7ES7xKWxOI3aZ3a0lQ+OYFsiVYJKaH43yKDoLT4c8qlVXh5x3Jk1rDMB4voWc3816+Qe
         f16aXord9A6U2E8W1aztP2YjupLLF4BoI7iUF3D77ui8VzDZmfTLMucdQ1+JBijVo1XP
         DpqaeMAPvfO0lIDywXYbLvwxw4GVqVIXfVAyERpXsyNCOrlyb2I1ULkWxU6M4R8wBkis
         7ndTil42Hx0nd0MGQEjrjD/VGTAAqxSANY+TOGUJ5tHtyz6Vmv1Z5TOtV11Tm11lIBXK
         uXoA==
X-Forwarded-Encrypted: i=1; AKwUvBwABilymaUHup2BDtqlq3f6fnuoxISD5xrppIBXJfTiwfrNEDDaNXmLEtmKQ/3eJVnCGkw2s2I=@lists.linux.dev
X-Gm-Message-State: AFuF++mwnXcqwVjNffg1GoBZ7+bXCrn+jMI0gsU/K+Dv8m5XJ+HPMb/z
	AFwgClg2YtubWPzY6dY84+VeVG/Zbwjz4pZ5vlWpgNl0wTZf84PEsDVgF3Iz62A8fQ==
X-Gm-Gg: AYBFou3fnEc/G9SRZO5B7UbIXdKklw5py8KaP0Gb8i0FDq2ysyjUTSZ8XyvHIKZw99u
	IM526vq3K6krrjNMRWufRD5Tn+LmmatemTsz9rKAYuo7a2qjKGoJKdv5z7pMyqJr5RLYEynzj71
	PPs4xGS4pAHhfb2te18udEVSLWv7e9gNRwTttELSRdPouDhMbrpRuenAAvFmITk1jMe4QOzLV9K
	exiyMu4CKNWJWcNwlYsNbRvhd+dzX3tk4jUpI6iB9vv3MS4J2ApqKE70yiSWgBubH8xvEF7uCCX
	foC+A8r19IxbbSDcFLycCcKcfC+Hpopp9x4/5Fwn/x6174D7Ckzz0aBYnBEcUF3yNl51Z+L3diz
	U3u/YCfQbpesCK7Af6WFn26msmlGs2uqczPI/bfrooVcTzI1fcIgTeACc8MN0M4bFT7uypmUK+f
	a0/G+4sLYt1Hvl73CNHbQuxvX7spfxLhgJjaAIthLB1s/hhWOCIKNwI9peJokZEa9J+VcHNWOwe
	Doaw2VEIlpamAAjaxecsjmvlTVmOA==
X-Received: by 2002:a05:6a00:2e99:b0:84c:4b58:2cec with SMTP id d2e1a72fcca58-8616b26f6bfmr12056954b3a.15.1788560666130;
        Fri, 04 Sep 2026 15:24:26 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86153a1c1basm1621740b3a.52.2026.09.04.15.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 15:24:25 -0700 (PDT)
Date: Fri, 4 Sep 2026 22:24:21 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Logan Odell <loganodell@google.com>, arnd@arndb.de,
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com,
	maz@kernel.org, oupton@kernel.org, seanjc@google.com,
	bhelgaas@google.com, alex@shazbot.org, kevin.tian@intel.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
Message-ID: <aptFFYqcSiBdMLE8@google.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260904160009.GV4157646@nvidia.com>

On 2026-09-04 01:00 PM, Jason Gunthorpe wrote:
> On Wed, Sep 02, 2026 at 07:34:49PM -0700, Logan Odell wrote:
> > We're including maintainers from all subsystems that currently is or
> > will be expected to participate in live update to ensure alignment on
> > the path forward for compatibility.
> > 
> > Currently, Live Update Orchestrator (LUO) and its file handlers rely on
> > monolithic compatibility strings (such as "luo-v5" and "memfd-v1") to
> > validate ABI compatibility across kexec live updates. Any modification
> > to serialized structures requires bumping the version string, which
> > strictly breaks compatibility between adjacent kernels even when changes
> > are additive, backwards-compatible, or optional.
> 
> That was the intention, I aruged strongly that upstream does not want
> to maintain a CSP matrix of endless kernel version combinations. That
> is far too much work to push on maintainers. Upstream would do much
> less, maybe only same-version, depending.

We received basically the opposite stance from Sean regarding the KVM
LUO ABI:

  https://lore.kernel.org/kvm/aoSCCTTBn9D5hqzk@google.com/

So we're trying to use this series to get some alignment across LUO
ABIs.

> > This RFC series transitions LUO and subsystem file handlers to use
> > granular feature bitmasks instead of compatibility strings. We replace
> > the compatibility string with a header structure that includes some
> > reserved space to define the features that are included after the
> > feature.
> 
> The compatability string is only a small part of it, you also need a
> serializing ABI that can handle some random mixmash of these
> features. Ie the various TLV schemes that were all proposed. What is
> the plan here?

The proposal here (which is inspired by the KVM UAPI) is to ensure every
LUO ABI struct has 2 properties:

 1. A field to encode options/features (e.g. u64 flags).
 2. A way way to grow without breaking backward compatibility (e.g. so
    we can add new fields).

Each flag can mean whatever it needs to. e.g. It can indicate the
precence of one or more fields (i.e. new fields in the struct), or it
can mean a field now has a different meaning (i.e. union in the struct).

This would enable adding support for new features without breaking
backward compatibility. Downstream users would have to ensure their
kernel does not start using a new feature while it can still rollback to
a version that does not support the new feature.
