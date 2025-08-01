Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D50D1F4181
	for <kvmarm@lists.linux.dev>; Fri,  1 Aug 2025 14:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754059989; cv=none; b=TNe9wT/+SZacfu15W3LO0mCKEeZsCEovsz3nOOc33DifWegAaD3iXaYfAnEVfrhKb93U//ZKe9Yj5ZbMJQbz4r7gSMWJDUNpcUe/hrFK/w28xPt7H/YIIiqW1HGGK7znbJacmicpT5w7uq2g8b7EcNKiW/v+k0tzuEx5HIpkepM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754059989; c=relaxed/simple;
	bh=9z8sFr7OTh7x/5XSMissRsaGqrEIK0lYaVRNZPtOZxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bo0Ho0SKzceN9SkDoTieBVTDnyd144XHgCEI1GPokBXwjT/3bYfqJIsnypA4uD08uBa3NfrZvg8h7LSEPe24gzH8lvfMrJf/AONWYuxdQhBdVRomzAbrtOtC5SKaNyu66O4xiUlQMFQOf+FtttjIkmkzJAPf2eaYvBCnsyjRAUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=LduHhoWI; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="LduHhoWI"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-70740598a9dso9056826d6.0
        for <kvmarm@lists.linux.dev>; Fri, 01 Aug 2025 07:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754059987; x=1754664787; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MNtgboVqwh20Ney7adiU0cV/UXdxsSM54P/Vl6XgEls=;
        b=LduHhoWId94Vq/huspbCNP5YPaVZ75RRDPgoCU7pUwLWcFsKZgIGATQpYDOVUyeme/
         Ft1i6Wa562YbWrkxEmZui7sda8pd//J3bq6acUrLdHbAud4AcJi3LR0nKsEASGgj20I6
         FKRN0nGrrVei6k3+tEqmvG8vO4DYgoGZDBUv1EKTevsrqC+lJAo1XGuJKerWxvU/059O
         yMnYSBN6s94D2a9Am3vD+lu2Cf8W9X1SorNMtMOM+5QAtlmDmduY/i+85bsH5ofBXirQ
         jWTAUIODSjVzlT9JzFNHt08O5BewsGJkXvpOV50wGAR6oh/GkwZkvJ5rvohOZ8i3llkT
         oOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754059987; x=1754664787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNtgboVqwh20Ney7adiU0cV/UXdxsSM54P/Vl6XgEls=;
        b=AazBmCGb0DkdjdZNRP5kpO4O5rVxC5AVK4uY4Avyn5IjY5Y2fgP03lgIDuoKeQv6yU
         GCGd5hhVguxPqISr47Uf8eAPZYISkiUUyk3zbRKQTrmUuWCbmCfYe0L48R76FI26jT4f
         8A0iT93L73xPL83krD2DDeOaLpivGupgTTeCTOmMN4tAuMrfRiy0mUl6/eBFN2G16WNL
         Hte0vYGiNO5WjkXTRWV5LRyMb9NnONL7lcjmsasbjZQvGabL4eTSKfAcw6RTLvUAdUz+
         kDcIzCETApEfCKB302cOeETc8hByh6h/WKdMwwOf36OQzd9s2j+dgqv6MuVWp3Ofb7sJ
         0h3A==
X-Forwarded-Encrypted: i=1; AJvYcCXXKhZ9oQPozolCV8USxZa0RX3tI4qRU30RSHCjStJxgXPPJmc4h/X9vQDLG9mgGFs19Jzpg84=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxSDtZu0iBXyyN/a6XZiBA5jjodlXCKvb6r7zAhUyEUAqQyFQH
	5YZ+kNjnQwNAoBqAiY0Zse9HVQJzQdmzJtMq5z8uKk6zwPeB72CC52EpSGAVkvTCNTY=
X-Gm-Gg: ASbGnctocoEMEbuqcwuiFYYJg8iUBqUwn8BI26YoTodFdOCBwUqZhg4P3VPFBnHDGhS
	Txpz5U4k9O/O0D0nIyOT49UO4uVo986joQJSZXn0dKhhIeHedmMx4DCukkqviyWQgMMFsyBS9PX
	mMl2NgYh7Ofv6S3xd7/0oehsleYh0jAA4VOAdAHRRqhYO2DmV2dTThNzrsAhih/g3VCV8P2M6rF
	pZyHGzVRTvOTSG9+woonD5wLLZziOrkHlZyJpcLVP2olELS6hRDNP25RekGAuy/8cTpOCFPq1vL
	g5mcqsoOUYF6lKNbWGX9pIYINBGg1kib7hjVGQ4seRDj64m+x7cJzIdKx9W2r+OF5/jU+F0W3Sd
	ceHItFYCFelQxYXy4z3qNC47mmPeGeMCOf7wULvXDQa4rscabOm8MLa98XAGgo/U8ncv6
X-Google-Smtp-Source: AGHT+IFhLzfh/tN6NcfbFOiHT6YBGOLWjYR19Ez0qlLrCLeR+IMa26shu3X/pz9tHfJr845QNLQ7TA==
X-Received: by 2002:a05:6214:495:b0:707:56dc:178d with SMTP id 6a1803df08f44-70767185894mr176316596d6.37.1754059986819;
        Fri, 01 Aug 2025 07:53:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077c9dfbbfsm22005316d6.13.2025.08.01.07.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 07:53:06 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhr85-000000012WJ-2mLW;
	Fri, 01 Aug 2025 11:53:05 -0300
Date: Fri, 1 Aug 2025 11:53:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 04/38] tsm: Support DMA Allocation from private
 memory
Message-ID: <20250801145305.GB26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-5-aneesh.kumar@kernel.org>
 <20250728143318.GD26511@ziepe.ca>
 <yq5a5xfbbe35.fsf@kernel.org>
 <20250729143339.GH26511@ziepe.ca>
 <bbe2a41a-8f72-4224-a0bc-225c1e35a180@arm.com>
 <20250731121740.GQ26511@ziepe.ca>
 <1388fb70-3d2d-4c41-9526-521cb75eb422@arm.com>
 <20250731164420.GW26511@ziepe.ca>
 <791e259b-3a57-487d-81ca-9d83f83ad685@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <791e259b-3a57-487d-81ca-9d83f83ad685@arm.com>

On Fri, Aug 01, 2025 at 10:30:35AM +0100, Suzuki K Poulose wrote:
> > Is there a reason not to just dump that into the T=0 SMMU using 1G
> > huge pages and never touch it again? The GPT provides protection?
> 
> That is possible, once we get guest_memfd mmap support merged upstream.
> GPT does provide protection. The only caveat is, does the guest_memfd
> support this at all ? i.e., shared->private transitions with a shared
> mapping in place (Though this is in SMMU only, not the Host CPU
> pagetables)

I don't know, we haven't got to the guestmemfd/IOMMU integration yet,
which is why I ask the questions.

I think AMD and ARM would both be interested in guestmemfd <-> iommu
working this way, at least.

> I think we can go ahead with VMM pre-populating the entire DRAM
> and keeping it pinned for DA. Rather than doing this from the
> vfio kernel, it could be done by the VMM as it has better knowledge
> of the populated contents and map the rest as "unmeasured" 0s.

Yes, if done it should be done by the VMM and run through
guestmemfd/kvm however that is agreed to.

Jason
