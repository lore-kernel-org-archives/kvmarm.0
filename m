Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C558278E67
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757954342; cv=none; b=aJ/U91prqNKBMvb4ZuJwgh2Pi4k1FysLRR7kS17jimQUott+nPJ/G/x215c5WQJuuAKGz1T5NS8kR6Ue9qyRjntLBrl6ng6x3nosIopCT/sEq/2IUiS4BtC1P/f/ybWqDIzvFzui7zkD8Bw+BNYihdElxKUAmUjQ2/a/f/ial3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757954342; c=relaxed/simple;
	bh=QEs4pZ5z6UV6DIBPa4q4aPt9EKdlHVU1+3WYy5ax+Bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tt5V9LD/vzlcw/EV2kGkHcc1CGd8IIokkL4kOrA9PuCh61pXpBzHV4wOH/LWo3e/YH8+wtmKyFGkZaBGK1rhsoGY2CXSlnrQQDABqQtZ9CcWwUFicpr8Zt575/hWRHD68zBnI/Uu26fVqlIlNDd8eOZItRfBeQKSOPnSIrX9auI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=N2EKYqjM; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="N2EKYqjM"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7742adc1f25so3027624b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 09:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1757954341; x=1758559141; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QEs4pZ5z6UV6DIBPa4q4aPt9EKdlHVU1+3WYy5ax+Bk=;
        b=N2EKYqjMhq5XQtOXanDvDl3UeHd3bNx2ykPfeavaCZM+oStmD03pLHILRXdHxjLqoa
         nnG6cT2gNArk0opr5mmG6kJLAXwKjY3o8ZJrxUHfF/jsNTRE5kw442cJww46I2+1T60H
         o5081iKoU9mS1IZ4IrHbX0xfizmk+WB3o5MoGKCVgFWq1/IjIXB5Sf1NSJqPSRpTTv0D
         j8hDu5RpIh7zjBnoEZp+5KLDk0e1+1LwYJyzc3BV4TBsqgEuNLRAa47waO9wPt9LcWpc
         lhPEEmBXTho2iasGQYPcJ8eu2AYKyJMxTpjOk32mYGeDN8x+qAwNB3PBTiQnsGqvVlrb
         oM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954341; x=1758559141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEs4pZ5z6UV6DIBPa4q4aPt9EKdlHVU1+3WYy5ax+Bk=;
        b=hoYtcmdJM2tkXCdWZoRAJ0mSoWHrAS09yJ3i/CjppWfzOz2tedM6HiwqcjtQD4c3hW
         7TAsfSykpzNZeFqWE6jMONHTKEifTQaCw3QesarTS9tJ7Z4+GC1dPmLKKXidyBVbcKiJ
         i5yPiVKj9BZraRuLA0EoL+J8rHiS4ldtr8Xl7254fgm0aoZKOuAhZinITkHj5x+el8sT
         Q9IItHM4ggYbjkMS08QtUy8caQn/fcI9nPgAKpQfe1BMBganuaWg2PGqlarToGcJxnMW
         SlDxzcpa6hxYI1e0h/gGMGYyrzrJpvkn8pskwE8cLZyyajV6N4BH0I6Cdx10ZqL5MbdZ
         6Lnw==
X-Forwarded-Encrypted: i=1; AJvYcCW8cAnfi5v/bV6WLWfZZx3sDx4wF17JCPuBfAFpRBUKU9KnFrsBspURmBVCg/CWvnPh+33xYx4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqE9E32memeOiRa222LPhEFI0FAeL77I+MW7n3+uSaX73tTUm9
	VN1qw5Ar22GFDnGdyJhlrRvx5bUehD1haNhtwqgfRZFGiXCb9w63wC1nC0nYqHNhwQg=
X-Gm-Gg: ASbGnct5K5sB6BPp7Rd96umTkMe2esV/LbXmDWgv3VeOGguu/EpYMaZ+qev95qdooFb
	9jWu+3FJLxfCgnl1Yo/3KqyGQYsV1nUeDNL6lQGEKeEjwpcRGXdL9WDBaAsyyqwGZ0yamL7kfxv
	z9rqvnySsASC2AIklbg7Ip+Jm6eKiU00m6V5Vr7t2rK5AAvSnB00cvOwwgKE2//FFRxFQSZf07t
	Y4ncKG7LcIaPInwPF9jxkC7ur2orFZl94w0RVAl4+H9iLKR0XBBKsd+spZUqufTri6tgalvFGrq
	rbpmJ9Fu1UAPjicLiYQCOuPslSp5nzn63Lq/0jyqFkBjJ/Vt2YorYiCkhRo5v/HfwkjJvclS
X-Google-Smtp-Source: AGHT+IEq+05CDclx85E3rLT3itHmH/cfmy9YNLof0QbJTkKIbzLS8n6ulerDKoJUcV6j36ozIpBilw==
X-Received: by 2002:a17:902:f693:b0:24c:e232:f92a with SMTP id d9443c01a7336-25d26e47c1fmr168980405ad.44.1757954340679;
        Mon, 15 Sep 2025 09:39:00 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-265819a61besm43370025ad.53.2025.09.15.09.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 09:39:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uyCEE-00000004THo-3rBl;
	Mon, 15 Sep 2025 13:38:58 -0300
Date: Mon, 15 Sep 2025 13:38:58 -0300
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
Message-ID: <20250915163858.GK882933@ziepe.ca>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-23-smostafa@google.com>
 <aMQroI4NDu74PDGT@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMQroI4NDu74PDGT@willie-the-truck>

On Fri, Sep 12, 2025 at 03:18:08PM +0100, Will Deacon wrote:
> Ideally, the data structures that are shadowed by the hypervisor would
> be mapped as normal-WB cacheable in both the host and the hypervisor so
> we don't have to worry about coherency and we get the performance
> benefits from the caches. Indeed, I think that's how you've mapped
> 'host_cmdq' above _however_ I sadly don't think we can do that if the
> actual SMMU hardware isn't coherent.

That seems like the right conclusion to me, pkvm should not be mapping
as cachable unless it knows the IORT/IDR is marked as coherent.

This is actually something I want to fix in the SMMU driver, it should
always be allocating cachable memory and using
dma_sync_single_for_device() instead of non-cachable DMA coherent
allocations. (Or perhaps better is to use
iommu_pages_flush_incoherent())

I'm hearing about an interesting use case where we'd want to tell the
SMMU to walk STEs non-cachable even if the HW is capable to do
cachable. Apparently in some SOCs it gives better isochronous
properties for realtime DMA.

IMHO for this series at this point pkvm should just require a coherent
SMMU until the above revisions happen.

Jason
