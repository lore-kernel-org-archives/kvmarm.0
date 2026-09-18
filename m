Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D28B51991F
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 16:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750400; cv=none; b=eDNpdKljaMEf3bxD10cT6GcWI8eO6Z5NMM6IWmC3McgifutHH0ucXa9E5fv9ZL7qTkeVmsOQeV/2fQ52i1uQJHXpXn0kMaWYJCMooNcrp+oL30toOVjDWicx9Yzm7GipyJQHd3V+4FYRq0thJxNYOcJRVhnX+xMXX2nwGvoyaD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750400; c=relaxed/simple;
	bh=QHr3HItRfGIiXW33vm4AJyjNNIRgLrxwO2wwjz3RPCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdoKsTa+9NwC2UVB73322rV8P+Om6ZNTmaB0EqGA53wUavNBv1DugCmrC8gfKEwQCWklDQX6v4SeqtqlJzJG2E+xEIhiyUlEknMvwWJFrILkw3NVeRVOJClFOPR9BfRILAWYUmDL2185dB0Cpp4CUa7esJDZy7Gt4nBSCd2PihA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=pB5gO3mD; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="pB5gO3mD"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93a135ffb08so129365385a.2
        for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 09:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789750397; x=1790355197; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xZHhNZflcpTf7gpMtfLnrd+b6TKn7wbbrgvwwdWjf0M=;
        b=pB5gO3mDN1zFng2UzRAaAMcg/2DgorsFsoNSlY0HwOHCNY9m48jA8HES6C7+/vXb5N
         DEvZIgK/Z8/xT20/4l4SYZEcR1CjIBD8UR7OuFVyZhFY6yLmPk7dxfJ8q6j7Zj6VODth
         wgJKkG5W9G6pvSt2k464qwAvMBnwq5DvPQvivZ7V2oi22nbuhYmfgb4/7LeLu1mgh0JK
         oVX9ZLI+gt9evdOM/191RE8UlhxDDURPCvswkLwctcAsGLPar8d7y5SkzWNDZ6xsbJ7a
         6N8BR3UXZfs/9zdo9y1Uk6o0/ZbGFfmoPVXxqYoOJaENm3PXB+vE/SC+kUtg1SCmeeOc
         BXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789750397; x=1790355197;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xZHhNZflcpTf7gpMtfLnrd+b6TKn7wbbrgvwwdWjf0M=;
        b=OgdrWC0/zJY3c2FzJNJfXbK1bsQ2+b1BWP0ibfHlS2pSzmXYR/zJ2uGIBfuaH5NSFy
         qm/0Pk59fprP9PUwNPChHTvpu07c5z/T8IUAo9j7GAyyljrV+3INXxlzObDj1X+erp6R
         gNNHRjb3lXBFiIKc3APvU5sWh/LbUx+5nbuAKLOUxs7f7zj/4ezQ3Ef0blnvv6BLNx2w
         gLTxwOhzL948bkEnhYtXPCnDG/56mQLYbj1TFZqQOl4UZSKhjHS/xQneQLr/jms0TAwq
         z4K2Vt5rCm8TPuYbidr0xPblm8ttkKzKj5eSwUBZN/XLuhQBVn9RN7NIKCbBvi7agpFr
         TilQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8yHj0kltRb/w60oapbaa9L3Gl9wHQw6jk421UnJytZPKPnUipixc69BKvLpybh0BDjLZjAwA=@lists.linux.dev
X-Gm-Message-State: AFuF++mgMzw9ctXcvSf/+F6MNLmB2IZ/mS45aOygyzfZ73qdQUcQV7eP
	dJapq5kwFpsNGxSII6rlEuFIYhsKb74JO1um4laCMr9V4T2wanj2fVw81EKf4Qq/Tcc=
X-Gm-Gg: AYBFou3DJNfY2BROvBCBxS4CvHWtULEXMkJYZ4zou6gg5fX6/RFs88oiLTmX6Evqhix
	P9LejjCX61fPxO8yDxDXkMTIBom9hld36soP9BTLZeup+FN9UbxhBH8Lc8lExOABIlyuav4r5X0
	zzA2lQKwCi8w6X1Evap9drLAeKHNzZH3j+IURlgxWCi2vss5S2kti/9UdZT7NfnzBeLkH288lNu
	dz/eq3P2c10w1+eqkUkS5yFP03f9gfIE1f50fiLjcaFKzPcoMdQ1Gg79Ln7fzxaydA5PSYhdc42
	3HRGNaabpk63k7yVAdVrHUzcflxvS5H9y35Bdv5BMN6yQN+Heb9yuMSIRhyt0LOQZDk489azAOh
	3Vtm7VxAbBar0XDcTC/g4TjfU+ONDc8MTXhdayDQRUw4Z+vZNJoj8Y9SwcDydmc6uU4AFM8id5p
	EuVMA/ikCXxeVn8jhyzLnPy8QOoq8mJM83TNnmZ9+D340NXUOSnWuRLYJO2lS5cuWh+mPhS1Gfu
	G0WWlUI8sEY7znQdpLfiLhkyYghQ453HKaRqVSrsgxZlLqWaUVuJAMH
X-Received: by 2002:a05:620a:1a17:b0:939:ee44:36bf with SMTP id af79cd13be357-93bdc72000dmr495588285a.29.1789750396680;
        Fri, 18 Sep 2026 09:53:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260a60f21sm68476d6.19.2026.09.18.09.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:53:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x7bpr-00000001yyx-21Yo;
	Fri, 18 Sep 2026 13:53:15 -0300
Date: Fri, 18 Sep 2026 13:53:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH v6 7/9] dma-buf: system_heap: Enforce shared-granule
 alignment for cc-shared buffers
Message-ID: <20260918165315.GF11599@ziepe.ca>
References: <aq1V3oeDdvXobt8J@arm.com>
 <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>
 <20260918153642.GD11599@ziepe.ca>
 <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>

On Fri, Sep 18, 2026 at 05:39:55PM +0200, Christian König wrote:

> > Arch code can figure out how to do it. If some ARM configs only give
> > order 4 folios or whatever then dmabuf heap doesn't care.
> 
> The fundamental problem is that DMA allocations are highly
> architecture and device specific while Linux memory allocation APIs
> are generic.

This isn't a dma allocation, this is a memory allocation.

We made things so the CC shared folios are DMA mappable through the
DMA API. From the heap perspective the only difference is passing an
additional DMA_ATTR_CC_SHARED when DMA mapping the folio.

Jason
