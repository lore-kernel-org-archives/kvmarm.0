Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5C8502770
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789745807; cv=none; b=IUOqJKxuSJuE0crfzVwkGDPBvfZ8oqtNeGWz4x9Bqe59IKHbQU8ZlCBROWt24JKTjFwNKTb+jIRpOPwTxmNzTMLnmRtZyuJsWfJzrpBtV8X8nwSGpRsp59JVBm6KZfl9qDuP2vowq1PX70M7o2p8eXAFX7PACD7Jab1jfYrn/pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789745807; c=relaxed/simple;
	bh=tLlusUVv4qYOaeeWNFcYMsujMDmVr4vyuqgN+4B4l8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZZ/QAxhdnyPLIPia4L4tNcS/QC/Q5txPggcnIX8h3A8DyO2KgEhvtyBJ951Arjo3ZPgOQBYT0vN1BZMK6lNjzv+J2katOwigRj+UrxTUMhJdqDiP5qMn+Z76sGF+UX2b0SwSxmFwv5RnsGoA49hxKkVvMgQPgWTJl1550vVL8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=GHoydxrL; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="GHoydxrL"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93a0299c787so67671585a.1
        for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 08:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789745804; x=1790350604; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cl6MnsVJ2tgqjlk+JWZs6DCC+wi7QAAwiMKBJVJY4Nw=;
        b=GHoydxrLLgPnWGej3843MdjtqaGHo5dxIKNoS71j32inlUGewn4G6lYGsVRMRdxWmC
         hSVCOXAaHQEDwA0RFsofwopEqOY+kl6jqfO87/Bm94E2VenFhha8h1TuWYYKy2zCmCUm
         Ohl86mDe9wnuUt8xgAZ2ZE5fnQp/TlnaL2YfrgVWrbIoSQtm2/6Tk8uUe81c1f53cE6/
         jECxG5KOmUlQk1vmAjLEJa7C3xCnL61aD43DCzvmqwkEH0fy9batq//55dysP3jAPwqP
         a0GSJuped+hq+hRmvihmc2caEzkEfEIzW8Bw3+Qlys9Hm9r5gdm8Xnwwsc7cZ0zjbEeH
         arDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745804; x=1790350604;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cl6MnsVJ2tgqjlk+JWZs6DCC+wi7QAAwiMKBJVJY4Nw=;
        b=fDTPTVvaIvCrloot5+zi5fhL5nMdxLtYvPkrbUBIvz15LmJysppYWoHEvLJb4e//AF
         Ska/X2NZJ9A5QFWUwGmA+aMX+B9PTzaDWIedgJ7wcK006g7YZGsfCa0q2CkHORFqbJMk
         ElTZxLBa26U2xLZbJ8bUsuZcl+ONoJ4affqxm+c1v/+7z/eV/cAY+pZPMjWRwjXjDEKN
         uj/X67Q/HUuRD4NJ4RoJ7sY4/tyFnLcoe2ogB9DulNP632MPSB7K9xLaFnyfGcmfrdtU
         PK9wzxnLfh937+80zx4gGICxsc55zvyxEQioaA/XO3cGurDUpJpw/SU161Moy0eu8/U+
         xMRA==
X-Forwarded-Encrypted: i=1; AKwUvBx2njEawGmMQO18rjfiUNtSr8T+WcRITaum9mhg1uoKstnLP8EDUW+2tn7SMpkS4xNKOiN8Whw=@lists.linux.dev
X-Gm-Message-State: AFuF++mJmo/AMbqO/7rykKVcQtW8ar96u+JN1NOSyFm08/02ge1MtE0e
	cSiNieoFEP8Ge1c+SSb77lTqFSDZQ4ITva3MUmr0I6X3BkRevXF3QQxtZRt6av9ti5o=
X-Gm-Gg: AYBFou3XVgYgTxFwTxjFPIKqBh2sitMz4LXKHrioy89nt7jk7Cfz5JyDdWz+yiaP3Tm
	YC5bDuchr3/81xkEshnp1vyU4RoXoZcDSrnU+SALcyDMrUZtjLEOC9npKbWA03d0t4sV2TJlpna
	TkK4JW1+IvlV8ksjgs3mwmliM+T1jxjgJD8I2FrUEO55TUQ42v0RhuaTMMC9woLq8fNbYc8tr6h
	c44mMLNJlFC0mRLL1Ey96VQeFqdTQbGKAyOyHhUKHj4tuXEapQFPYhyYZx3b4WIf4H31uy75tAr
	wY6NP2TPNoYK/FMlgZoFAVtgcuGkD7f8MXFvkK7nuzMFl+s+T1Kk41swS3S1o10ATmz5NNryxck
	J+3TanvtiBf4e4DxpfaxEpcfK/VVlmyulmp9bqw2JBqI6NGtba+3AvX+e2kFM5OKFAakDNsWEE+
	Q7jiaYazNy60oO10/47rHj+NCciCdeN4nQJau5AfjqTq+fzJOjDpePpfcqkgoXtlVeFCnXjMqip
	RW1J/TzXZTpsdGL2c/FY3ihWtZUAQaC6Y2CyzORiMluZ7Q3qG2lv94x
X-Received: by 2002:a05:620a:470b:b0:93b:d7a3:45cc with SMTP id af79cd13be357-93bdc77f152mr382061885a.53.1789745804221;
        Fri, 18 Sep 2026 08:36:44 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0ec44fdsm163568285a.28.2026.09.18.08.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 08:36:43 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x7adm-00000001snW-2UlV;
	Fri, 18 Sep 2026 12:36:42 -0300
Date: Fri, 18 Sep 2026 12:36:42 -0300
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
Message-ID: <20260918153642.GD11599@ziepe.ca>
References: <aq1V3oeDdvXobt8J@arm.com>
 <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>

On Fri, Sep 18, 2026 at 05:23:32PM +0200, Christian König wrote:
> On 9/18/26 17:16, Catalin Marinas wrote:
> > First, none of the DMA-BUF maintainers have been cc'ed. It might be fine
> > for an RFC but this series got to version 6. We need their feedback.
> 
> Yeah, thanks for doing this.
> > On Fri, Sep 04, 2026 at 04:04:50PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> The system heap can allocate buffers that are decrypted and shared with the
> >> host. For confidential-computing guests, those shared buffers must cover
> >> whole shared-buffer granule; otherwise a userspace mmap of the dma-buf may
> >> expose only part of a host-managed granule and allow unintended access to
> >> adjacent private memory.
> >>
> >> Require cc-shared system-heap allocations to have a size aligned to
> >> mem_cc_shared_granule_size(), and allocate pages at least as large as the
> >> required granule. Keep the allocation bounded by the existing heap orders,
> >> but fall back to an exact minimum-order allocation when the required
> >> granule is not one of the preferred heap orders.
> 
> Uff, I don't think we can do that.
> 
> That is massively platform specific behavior in a non platform
> specific code.

What we really need is an allocator API that does all this for the caller.

It has been pointed out a few times, Aneesh maybe you need to try to
tackle that?

dmabuf heap just wants

'allocate me an array of shared folios totaling XX bytes'

Arch code can figure out how to do it. If some ARM configs only give
order 4 folios or whatever then dmabuf heap doesn't care.

And solve the double/triple zeroing problem.

Jason
