Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C253BE162
	for <kvmarm@lists.linux.dev>; Sat,  9 May 2026 23:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778368920; cv=none; b=Wh/xDHd7iDFOkSReIKYKxqv5Pi7+1yhfdbigqpkOxFbBWJ/nq+gP/FKdSLC3f/UNlXIBnt6gioWegJ+ILvmxO4P0gIWGCTJxcjsnG222RWSQWs4azrL9FAwxVZDEQAnQjAbVsNy3hIBUimJ2hZLCx+pqj/GQ0BxCWSv8DX5yQQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778368920; c=relaxed/simple;
	bh=7jPMvL2ceRZm3p/Zo0nDr4G1J8k+ih3rnehwKSYIxvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGKYDHXBbSkbCqYDG3iU0uUqE436EZIYZjNpdUBpTPnRs1NZ6rlwePpYElMvsNb/Se/GozTuxVg7thjFN7esCo1aJtvR26zgHzfVy4wZzruyfv4//bDKzOjefn6ZihVtgBuHeJPVeVRGCMq37firknn0wMs3yrbwwvOuqaMuNWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Q38QoGF9; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Q38QoGF9"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8b4298d271fso54634856d6.3
        for <kvmarm@lists.linux.dev>; Sat, 09 May 2026 16:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778368917; x=1778973717; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=335DhOmKigacyWrLMRbFPigANHuPSLtNVBCr6CAA1o8=;
        b=Q38QoGF9pdldyvEwDSTlX735P0BUssM7b/IWB3fH09Cu8JrNAjwxeR4T70vDxRbqtM
         ynGDkXYl/hql7ondx0MdfUowpCQ2hki0P2TxKA/G/HPmn15qN94/QkedMYje0bskQljk
         0yRk0l9A+f1kphY5hRZlYAGH9s6vpPJlVyvq0EPV46rqTpoKqIlCCrsH2SVWccnbvQpq
         AI0Cbvq1tNHdGAxSaVdat4iqxYyNw0VjPp7Ycg9L3BjaX83MSmb8HS/eIzXY4aPN+Hpj
         xeMINhLguhfgAkg2fes/JqQYX5sGOh1xu6rcyzk8tGM6EKiD3SZ1W7Dm62FvIKj2XEIZ
         6s4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778368917; x=1778973717;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=335DhOmKigacyWrLMRbFPigANHuPSLtNVBCr6CAA1o8=;
        b=LhbU/SkjqAtLiMAuE6qwTY7VOy4CSm9M120BZsSUNKmg6XMCHN8/WXVBR2KES5c/zO
         qSnU5qjtO8v6VrvyjV3kXvdVpzmPL2RFRsOLZ3i2MO+s+GK6aq4xJetNBKfypYcAGsoi
         +bE1Fr7sPhPPhRU5WXI3kopcvqg3lTpIY/hrgFBPpZsOo/keKx6y5KbKU8wNguvG3VLy
         4UmBVQyT/j1Rs47t+vZ4Ei403gNdpP6M2/sV5uha4lQpUPL1fMwgP32lEjY6kUS1KuUd
         6asD6IlWXuBHHTnZH5Y/CsZYEeBcG6NHxQy8UyuH4I/eRCs1rUjOhFVznaEOonxkgHG+
         rp9A==
X-Forwarded-Encrypted: i=1; AFNElJ/DiD9Fqb9pA85r6YOSGZKLUYMReukI2mUJbj7ogmubLt6khVCji4uWo6laqHtdp5oIr9YImzQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzleRDqrM3R1EZUMw8QIAHX9BX56wO8Hp4Xy8e8jxwRJGCGexvJ
	JTqnm3HacedQVqJ5ecjf1vFAH4P1hdHsMVDiTIBRCM3WhB6jJqVfFB6pqoLTOZbduqg=
X-Gm-Gg: Acq92OHH8GnVoHjYpMqRce49pajYmiuK88u1yznY8lknjxzoSYAwxNcjCGG9GtCc5Ls
	sxohoNAJcygxEj2qJLE//pLoqlj30qgk1UBbFdNFchIQpGLzbSYdKC8tM+8qLGfS0jalskaJVZi
	PuH3Sp0YWxAlGCO836c+/YefHrGcNFh7Yqt641xy7hyBLxRxtc7t0W4xaIEmtBumNquHhPh/kmp
	wcm4BzIzOQy/7PVVgn0w0rlHvhY8IBRBydsuEjKemHTG73INN4jZUJCDNY8xV3ik76m08qfGwW3
	DHS075YONK9vAA3UiXQ7IAeCLvwMhaytNMULSgjJ18koxA3EpP52X1iFRREEuzbQSj2dyriwS+c
	WcqLqrMYSuYGm/fK9e19d/Lbqi0dDgdSrdb9TyPi4dla+T1Dk2Fr2Pp6FUd1sy82vVEblSU9l70
	B4kHTMm06XBnKEtVr6iJWm+6CEl6jaiUlq52I3DStsWFXnHuo7N0GRFP16Bpw+x/mVpl9JYwDJ+
	UGWalRzALNXd11V
X-Received: by 2002:a05:6214:258c:b0:8a4:c1ef:d727 with SMTP id 6a1803df08f44-8bc422a6815mr269722106d6.10.1778368916771;
        Sat, 09 May 2026 16:21:56 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8bf3b0c84d4sm54348816d6.0.2026.05.09.16.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 16:21:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wLqzb-00000002N2n-20cg;
	Sat, 09 May 2026 20:21:55 -0300
Date: Sat, 9 May 2026 20:21:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 06/25] iommu/io-pgtable-arm: Rework to use the
 iommu-pages API
Message-ID: <20260509232155.GH9285@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-7-smostafa@google.com>
 <20260501122424.GA6912@ziepe.ca>
 <afiO2WL4ILGfmUui@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afiO2WL4ILGfmUui@google.com>

On Mon, May 04, 2026 at 12:19:37PM +0000, Mostafa Saleh wrote:
> > So.. I suggest you update it to use the iommu_pages API, #ifdef out
> > the allocator so the pkvm pkvm doesn't need to deal with it. Then
> > compile a special iommu-pages for the pkvm side presenting the same
> > API.
> 
> I see, we still need to leave the DMA-API calls for the custom config,
> as I am not sure if it can use pages not backed by the vmemmap, I
> pushed that into a separate function so it’s easily compiled out.

Yeah..

> Without this patch, now it looks like:

Seems reasonable, and then i'd probably just put something like
   #define dma_map(...)
   #define dma_umap(...)

To effectively take it out of the pkvm build

Then have a pkvm compile of iommu-pages to provide the functions in a
pkvm compatible way. I guess you can't actually fully do this, but
can do enough to support this file at least.

> > You should have a pkvm shim header that provides
> > kmalloc/kfree/virt_to_phys in the normal way and just #include that in
> > io-pgtable when doing a pkvm build instead of hacking up all the code.
> 
> Ok, I can do that in another change, but I believe it's better to
> change the usage in this file to arm_lpae_*(virt_to_phys...) so it's
> clear which parts are intended for that.

IDK, why? virt_to_phys() is part of the iommu-pages API, I'd just
leave it.. If you want to narrow it then #define it for pkvm when
compiling this file..

Jason
