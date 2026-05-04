Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9330F3A7F4D
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 12:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777896791; cv=none; b=Nbpup0KH5/QsrqKLzXUufZrFojQa+GlZ9fYnl0I1CcmFDT1dB/fH/ochvCXYZCmTOCog7lawc7zOb8Iw16TG6Eym0Jj2Vef26u19roQW44CaqQn5BXozWpeTFLbGF5aojmW01qzmDRPYt9u4nPkVQpTAsmAFJP3f1AXD2BDObro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777896791; c=relaxed/simple;
	bh=bX2UkMsTl6OcCaUjBf88U30d1MFR4spQoSasIx4OSUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TU4UxR2WDrsl66s9aKmcn1mpid3/XjcDKpRi5PzarEConlgT4Dv6akHSUQEqEH8nrcnX/YiSSHXEKd+IdM2tXjjFi1heCTXY2NN1fEpXk71tuQuW7e2pZa+2GYWctOf9rETtA6K4II5nSqGX+M39gbzKot05q9B+3g1npDA9Z6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aWkwRa0s; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aWkwRa0s"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891ad5c074so202385e9.0
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 05:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777896789; x=1778501589; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7MdnKaX0TB6YagnPneZAL0SbiGRfNhnRbVRU61aMvP8=;
        b=aWkwRa0sakHPeRkmCPnYeOHZueipbmwAyziJmR6pA7W6cuQaxzyHfGsXInU44kLHD8
         B7t0l6sd6cIVbV3RegDN2wXzx8JaZu0L1HEa/BQDR7OdcOiLJxFuwDThN5eq2A7zc1gi
         qXl6izeulrUf0PyWXl1X67HLw7rd/3pEHWvkualyLdssHHZm2x8smlFlWKU6xWOq8QQJ
         zlMDCiWhMe3C7mTiW5IYOGidUnlEnPsW29dWicJa09WQK3OWMaFLy6z/S2r8+PhLf/5U
         bqImwvk9i27VCHrDBpHkXTsfNxdgJPc7UIfXuy85xzIExUHCpt/HH8epcjeoRNNKi7Wa
         iFLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777896789; x=1778501589;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7MdnKaX0TB6YagnPneZAL0SbiGRfNhnRbVRU61aMvP8=;
        b=IwHd9JnvYzQ2+OWCaAOxbB7zelpHD6Og1L6+RuZ90zmhzUu/BqlCBBW0KKY7T5YFzV
         AqU5NglqlAGcJhUXce0Lq+N85/H56OuPiPvAvJvOhr9jxddY3Pm5fxPV2UoqDGQ36P/S
         KvrnIUU8zsYiWbxqUBAZ5v8vDcoBqYkURKLtwufz3n58ddyfn6oJYlbjFKGWgsPDzTBr
         7IxYZu7s6ECIJSxXGb/kmeDgKpkqbUgRul8L3L5PuFvtxjc1xMgXosW2EN61FcbX6Ger
         gIf23vbRZpkHCWi3E75dTHzVYV69iCUcBNDdNH1a6R1q0DQ4bDrC71ByLLmQV3f3h8XV
         bkhA==
X-Forwarded-Encrypted: i=1; AFNElJ8ON/BritVgbMn7TAhshk+1wBv3lYdmETi1GCH2Mmd0+c0HnkErnRAmryTTf7gPv9fdv4g/GGk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNsCCuZO5GNiwSehxK1aorwRfLpKyeT+wOvraKlBNtAvIkjOve
	tEcSqOosNZz2V+3KfLvdcUUqmxU0DdrnQzBsMusvC7riPWBewBr67kfbyHRv+Uy9yQ==
X-Gm-Gg: AeBDieug7b7gmetb6/X9AloOL7rJFKJchs2TcY6Nz0xcOjOCxO64IPHcMBSqtnkUSAm
	H13z9zZDZbEgka+4iewcdfjvcrJnoQBVSe1MeBHir+7/k45sxEnHOsYClfbdtre446bOj6+CvTV
	yKZVPlwhylvqjia72/SDYARjuDme/VjDZ/IpMMH+sOQp7AKs0wVvnEAmJaLhEwJAo9wvGzWSQgV
	NRt5EgDu6qVHJR+7zrYgpd9nHc7x69t00HetjjkllE+ZOFalc6nJqy57/9vSgiNDbc0+7osC1cN
	56+8pUOSl/17jvym5n2auKMfEATyHBn6zY3iRx9+bK+cw5bGr20HSDeewzEHjmi7hR6Mz37WJqT
	SDqAcZ6nzXvewRkA0HbBciXmFhY7yk4nQlaBSfFT4JxA6E2zMwN2Qs5rxlt5o+HZ26qyPrZGeLR
	QV4Kg4OM8ZV8mfKU5l+KinaObSzL7fsyi7CIMdeeG7y1WV/bT6a9TEMsNwkBhQU69xK17ZycOB1
	k8JBQ==
X-Received: by 2002:a05:600c:c3cf:10b0:485:1a54:9407 with SMTP id 5b1f17b1804b1-48a97f9d4cbmr1615265e9.0.1777896788643;
        Mon, 04 May 2026 05:13:08 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a8bf18c9bsm25362412f8f.0.2026.05.04.05.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 05:13:07 -0700 (PDT)
Date: Mon, 4 May 2026 12:13:04 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 03/25] iommu/arm-smmu-v3: Split code with hyp
Message-ID: <afiNUBlnTGNzXIan@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-4-smostafa@google.com>
 <20260501124445.GC6912@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260501124445.GC6912@ziepe.ca>

On Fri, May 01, 2026 at 09:44:45AM -0300, Jason Gunthorpe wrote:
> On Fri, May 01, 2026 at 11:19:05AM +0000, Mostafa Saleh wrote:
> > +int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
> > +{
> > +	memset(cmd, 0, 1 << CMDQ_ENT_SZ_SHIFT);
> > +	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
> 
> Hopefully I get to it today, but I am going to post a series that will
> move this logic into the headers while deleting arm_smmu_cmdq_ent. It
> should be directly usable for pkvm as well to achieve this same split
> without having to shove a giant inline into a header file.
> 
> https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
> 
> cover-letter: Remove SMMUv3 struct arm_smmu_cmdq_ent

I see it’s already posted, I will go through it and provide feedback there.

Thanks,
Mostafa

> 
> Jason
