Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0965E2E36F3
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 15:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758122177; cv=none; b=kl09RCzZcQJy97lmgg+frIsEpjtc/4ZzGIWp/n6u0gE21Z2aauF5JeI6owaoiNdPgpx+CDcsxJQaIIT/7nJBEN8WamiPglL+wfjGg4/Z1NWr7/i/i+axyHqomScr/ASjoz6lddxzickvz/M7N2dcrYeyoaJEsIpKepaKGnDzWtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758122177; c=relaxed/simple;
	bh=vr6s4p5RDrOlpzEnsFxEhXbnKDJ/Ny2Q/csoaU7WttE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGOeWkTJ0qbDq1tK4VxMzyOKTKAAmIoVqHUqlHCt7/oUSPg5BMiKyniOBc2xrPTugtulqCXt0P1Qlrm6I1ZwelJtXB0WEA8rACqJpyHo/IAuDJhi92RfBZ6m+iCT+5r5bThOoX8yok4fGtiKBh6HDKSsmBmOKq6TKRKiWYWnPIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=BPHcTlHO; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BPHcTlHO"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32e83953989so3062674a91.1
        for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 08:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1758122174; x=1758726974; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j5mwCMXZll74MsKobdLnh2paEF22CAKr4juHWA93w7A=;
        b=BPHcTlHO565R3xoiaGIyqYdhafe5BhruK2lsEiWhKwSVfn36B60bHwY1cXHenNbMF/
         WxkoUrfOGLkLGBytjgWFvKvFhIfF+isg3oXLVdkriLUNFcFp01isuRm4ABy9Mn+axD4J
         KhHry3DuXARRdLIYXlcpRYEhCeBHnBkCM3TlTReJD8a8Zjt8qC7Gl5a4rmAJmQWpgxUO
         fQ1n7SXMD5tG+CKfUCDJg1DjOr5RXzxeb/h3ZSwa78Kkw82fc4ix+5eibgivt4vN8wbT
         SL5ypP4x1iQwgNUCdBWduvQuJH2lb0/vPPVsoQIZbtPqg0aIsIhr1/w0vOzkRN6N0FPe
         UmHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758122174; x=1758726974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5mwCMXZll74MsKobdLnh2paEF22CAKr4juHWA93w7A=;
        b=a1RBBLES0yqxaEXNLREYb01PtFX7Nijtr0/kZnq/mhX7UbVdtwqsRjvQc9iS+0KiY5
         XEVVM7tkrxK0aHK88Dj8il0M15AtZlfJLK2Pqcd6d8iHxhC1zx5tVNCwrLrb/M1ERuSS
         T2MCs+h9LSXJ9O0/ZUddjxwEYax6YXy9MKHwt6Qh5vm0DU9XqeeaE30WY2RQnVgjL7u6
         GzNG/MaUTZtJEuYkDhyvPaM1ZbCFrxgmT7VVspFgiaMmJRBsIkI+L5kTNyRgjQuob+7X
         r/4QhgKBEAolWodbcvMDGalZilbuXfFGRcmP4LHHLyRrLSosY9BLINwQ4gwxYkVeJsYm
         VtkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGCwXs49lJ8c/5n93YHEmHWwVfFfpuC5AqBV9w3DJeiFFhSsrumSShy7D4Ino5nIFS5VQkZuE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfnN9cPCpGII4CprWn9x3D/ujj7Z0I8J/59elBGPo3UKDQP/dS
	X5xYWK31BYHJ/RLoxAYcXOjrQ/NU5hmsQxwbG+CsYwjZYFNm7BTo3IKywXutI+YNSds=
X-Gm-Gg: ASbGncuaMQU426CG6/nCZnfSWi7X4wfsDeB8OpDm8OUg5RRsJ82oCnDDSEjv/QP8DyP
	pY9IS1A/l0Llk4umuI8DneFUsZlDA8RFaaX/nSBsmSSnj98kw2MUvzUBBumqAC8ds25DPEhJfkZ
	xw9kuFpSbyfOOn1lCZvp9sVYaWOJT66EjdqFGe1clZTA+b2xaHuLHBACjXosNrZIFL9a5bKeCa5
	3RlX0UCY3kLu4DYbypq9YSA6+zfyk4B6wtkEnBfToes/FkI1t7n3jcqgXfavjTcWufiERf3ypB+
	C6UGfJUeOqx1f05sWvhV/JxQ8KJA4xJu03hMd1IYeYr+povc8WRPFlMQAUap/WWR0YSujUtU
X-Google-Smtp-Source: AGHT+IFT1177fnGaDPrsJvXBzm9YkFBr+A6b67xfQf6j5GBKuYGPXR9WdIUZ96yP+o/Tmx5sDbBqfQ==
X-Received: by 2002:a17:90a:d44b:b0:330:3fb8:3884 with SMTP id 98e67ed59e1d1-3303fb83a3dmr2234532a91.16.1758122173999;
        Wed, 17 Sep 2025 08:16:13 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54ff1a22fdsm28695a12.0.2025.09.17.08.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 08:16:13 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uyttE-00000008NhG-2B33;
	Wed, 17 Sep 2025 12:16:12 -0300
Date: Wed, 17 Sep 2025 12:16:12 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Will Deacon <will@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 22/28] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Message-ID: <20250917151612.GH1326709@ziepe.ca>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-23-smostafa@google.com>
 <aMQroI4NDu74PDGT@willie-the-truck>
 <20250915163858.GK882933@ziepe.ca>
 <aMl_5j8G3IGulAC6@google.com>
 <20250917123601.GA1326709@ziepe.ca>
 <aMrNTny9jgZJd_Ef@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMrNTny9jgZJd_Ef@willie-the-truck>

On Wed, Sep 17, 2025 at 04:01:34PM +0100, Will Deacon wrote:
> On Wed, Sep 17, 2025 at 09:36:01AM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 16, 2025 at 03:19:02PM +0000, Mostafa Saleh wrote:
> > 
> > > I think the fix for the problem Will mentioned is to just use CMOs
> > > before accessing the host structures, so that should be simple.
> > > If it turns to be more complicated, I am happy to drop the support
> > > for non-coherent devices from this series and we can add it later.
> > 
> > I feel like it is easier/better to fix the driver to use cachable
> > memory than to add CMOs to the pkvm side..
> 
> Hmm, but for non-coherent SMMU hardware (which sadly exists in
> production), I don't think there's a way for firmware to tell the driver
> that it needs to issue CMOs for the page-tables and the CDs but not the
> other in-memory data structures (e.g. STEs). I suppose we could do it in
> some pKVM-specific way, but then that's not really helping anybody else.

Not sure I understand?

I mean to issue CMOs in the smmu driver consistently for everthing,
page table, CD entry, STE, etc. Today it only does it for page table.

Make the driver consistently use cachable memory for everything
instead of having two different ways to deal with incoherent HW.

Jason
