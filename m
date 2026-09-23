Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4D1524AE0
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 13:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168437; cv=none; b=honWTJz60QHu6GQFTbZQbOEu+y/61pWlltsau8ceFnHXa/GGhlDLIY1xI/T/ZIi5CYXUB7U5faaXirKR3TP9yD20i41dp0xtkVEeZ/foC4AjMigRkTgDfc7upLlFpYXsJ90Lyxir0P6cz+AxeLjiBx978Z1JV7KT0B6VkB8O3Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168437; c=relaxed/simple;
	bh=3lvjhy1fcuALXtgW37aXB9csFPun7VRHCuWT7ETMTgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hwSA8JlJHTxxHO1MUmdeNGngpi4GmQ7ZPZgTPOMo8+pp+N9CUCrt4r37GXZA8kW0WWoxdTJ5+HAp1AvdFyqZ6Yur8LcGTkZlxmpywnYX74P57VLwIBc/MMI9BwHEDpE2248K2nkvMhgGXpdf6usulvY1715qWKvlrygp+6EYroA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=o0m2Hhx8; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="o0m2Hhx8"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33bfb26865fso728311eec.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 06:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790168434; x=1790773234; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3lvjhy1fcuALXtgW37aXB9csFPun7VRHCuWT7ETMTgM=;
        b=o0m2Hhx8QDoOfr7nyg9T4HPPr46PS7MbTIk/6zzbcJZtF6FKeJf3BnJ9kY0iMnBJBB
         hnDPqzQ2Ly0QPA+e12giMhdHs/4FCzoaErNG7jZ5UGOy1XUDeXbsEaszAHm3yOa8hSoh
         +oCnBJO+aMfALgiWaIocd02AtYg1elXBKWz2EBp4r2G+0c6ZohBp3tlp08gsv+Bg4nZT
         +5Y8x3IfukVcrsQPLje0MMWyjjDz/pmlasBo3N8gbvTemEyKoNzm3k7qYXqnfIJEZIp4
         MUWZoKboilrB6IxLbpE1dD90KrUpydYaAv8ttVgdhkIvhpf5rzi9QXZCrMJWydOiCmRc
         VWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790168434; x=1790773234;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3lvjhy1fcuALXtgW37aXB9csFPun7VRHCuWT7ETMTgM=;
        b=UVbYV7Yi5mFEIbddn/6h+dcsWOfNdpzxD5OWmb3XgtxoqJT5WSLmbZhLnF5/lbVMB6
         V2pIMasI5DRRYsBdkJAY1OZdFM1qSW6xRd0cgy9HhL+ASvMd/vsZAqhQDheOxHQT0Yku
         173CZzFWnP0FGXZvcifyTMj+Hs80pJaqIGWqP9VxVSa+RIEpjfbK/xBWwhLYsqQ5mUEZ
         MKoiJoWZT2lcV4Irm1FEIr822RKGh3Bn9b4GE7c9UdjwVJ9mBNtcE8cJs2CJe4whh5/M
         BdEvfiPT4+Yo+KnM40MWRvR7DIBq/Aw8qwq/aLkFrnv6ugXKCHtXI9DtmELYSq94u+UE
         vIOA==
X-Forwarded-Encrypted: i=1; AKwUvByD08Yxqjamm1gJml7hg9tmR5dOJPlpv1PWN+F5aTnIc7x1HJtYjvQnzClgMImX4U46B1GBMhY=@lists.linux.dev
X-Gm-Message-State: AFuF++mivqNlxGNkC45gF2T2CgL9CnTjWkvmjU/PDTpd0c+OahsLzPYI
	q+DdN4DYzr9F3zd47vcez8hDO1+XXwhKyzfujcS6tRxbEvwl6FnwZsA66G/CFTKrctU=
X-Gm-Gg: AYBFou0V58dqS/FZ3OETFBMgaGx+gXWb29LxxGrrWYgpJRHT+oLY4Ad6Nu8p+UbxcHD
	ebdgbAGZZkpOT7oMnCPuttOt39KMpzmeQtPU2PAGku1kf3pF+Yqb19Sa7jwPSgY/vQYurRz8J2V
	LuAIilVaaLIqnubd/dTacBKYzSb1zGkhhBvUtA1ktr7zXaBR4eiRUebnADLKw5nPB5co9fh4kjh
	0CcU5i5UlvlQxXA1PyT3onudArqt5+TsApnYLQVEUi6J18ApjS7LWpQxarE6fLFA2WY9KywcX8X
	5BjMfxldKIkaVFDvzTLji9qfX65LzlUtyUTT09pFuRHnXNhbtbRG1pt+RF3m3opJYpFmtMiozLz
	IcpQCRkDO5w8vxUoZ6p7LjrfYZWsFa124lwAh5oTHMYvdfACf3Szsm0vLXu5B+hjsrnP8dgKRG7
	HyEOGlmuVqHFy8bq2OJhUQQXaGY9KsoFEaA7663hXE4pHFJfKrQfRM87g=
X-Received: by 2002:a05:7300:7949:b0:31e:b832:be with SMTP id 5a478bee46e88-33e8c24a34bmr2627336eec.10.1790168434062;
        Wed, 23 Sep 2026 06:00:34 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96358e2bsm6859478eec.16.2026.09.23.06.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:00:33 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9MaO-0000000DYPQ-01dr;
	Wed, 23 Sep 2026 10:00:32 -0300
Date: Wed, 23 Sep 2026 10:00:31 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <20260923130031.GE1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOfD6syXOgQhZYA@arm.com>

On Wed, Sep 23, 2026 at 10:42:39AM +0100, Catalin Marinas wrote:

> On pKVM, we want set_memory_decrypted() to zero the buffer
> before the host can access it (I guess currently relying on __GFP_ZERO
> allocations). Since no cryptographic encryption takes place, there's not
> much point in memset'ing again after the operation as the content was
> already zeroed.

It sounds like this a pkvm unique thing, since RMM always makes the
memory hidden, pkvm flow should do it too. Either inside its guest
set_memory_decrypted() or inside the hypervisor like RMM.

Hypervisor doing it is the right place, hypervisor always needs to
ensure guest memory is cleansed whenever the guest gives it up. Either
via a private to shared, unmap or just exiting.

> I don't think cc_make_shared() has the right information on how to
> safely and efficiently do the zeroing. That's only known to the
> set_memory_* backend. So you'd have to propagate the flag down.

+1

Jason
