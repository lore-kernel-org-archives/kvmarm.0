Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7122427A121
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 15:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754408936; cv=none; b=K4GtR4yj9oudRdQDlcJq7uw6vmwSEwOFOgu1w3EIZXlQblimdFf3HvoD0xbY6lG5SHQBUlvO9BlAkDDiQYTg/Ur5trJCWtmYYfct2WztXC3nS7pk9sISEAit5fOFb1Rjt1nrxXU+Xft9m2uahwKMHy/0QMdObo2fWbl5WiX+DYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754408936; c=relaxed/simple;
	bh=vK/izEOcqRroDKEjuurkSpJYsxNQb8UJ35ZS/H8ApXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdASyLWePa/vCJlBWVU2XvFlZ0N8TrNEQF5haeRq1aGgHOloVzF+21WfNHvDNkLBQge+zT6ZgBEIWpDYdo2+hfYtgHbgXRATG+Y86C1C0qgMj+t7mjFACClQKDGZyBQR/AgA+I18DgmI7AwnssHlu2ElI2Pzz++einII8FWLT7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=kLxISsO5; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kLxISsO5"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7e69960c557so435501385a.1
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 08:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754408933; x=1755013733; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PvWDI0NE7eWO/Fmxnrgsva4q0z87yVrAZ5bf0Zwi6vs=;
        b=kLxISsO5ZfOIXIn5/TPwoB3DGILRcIgKnIPIjRtNQ8C+DZDKNTlh86MdtUJzQ/n+D4
         5NJuL/+4w3OkPAlAEfZpBgaxiVLIwoA6YWe8Wb0kJaPsK67I0JYkrCA7ulM/UUjJBiDI
         H0aRe9vuv+XT/VRAuf/o8eITt0RHQ4iQcKWw7QiUk7K1+suvQSRNtVgxqYpnglHAmMQR
         j71SDsvPE3JDXIttWaOQhDijqOS2Xqedgfk7GAnzqJvlECRKCTBVuRVQMsMKEy97ZMFy
         a4HKWbilm00qC19+AnTP00aBxQXJeuI6zvaK1SWoDgJDh8Ir+Y+dCMlaEi2ejpWhjsUr
         YuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754408933; x=1755013733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PvWDI0NE7eWO/Fmxnrgsva4q0z87yVrAZ5bf0Zwi6vs=;
        b=iemdQIj8eXAcprDQf2fjElvMjsz9ABEppaZK46qXdC5A3wypgVzGg1Fx4E0eKpR7u4
         EPsW+hV7OjbgZ5JW19N7exU4A+vYsqz4Wc8U9C8Cb6ndw2pweeF0PpyLEGeoK54zHHvn
         u03n8lvqs2wEsFfdQTHvOoKBKn7/87Kx6dT/G3s0Uot0+e6bQMqluQj72O7uINdj6ViN
         AwBn9Qwbv6U8oj5TvnssOwrVOrl7ARlML560cZquLLT8WyTVBHxfTGWlfV7Sa4B/WBJh
         Q+SplxnD71u4XQd58ZXuuPhm3s1aXta8/rDxJK9stALjiQgdygl6oN17Zfpz8Mzm9Ek5
         QKTA==
X-Forwarded-Encrypted: i=1; AJvYcCWY17e0dBgtW+5D4DZ280wAeqHUTkVNXuqABrKsiHOZEp0xk/SQYCEfehXK2CPdlIb2p3Ffqrg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7LPQsgIclg8BedX3mDkjgSExV6jnX4lA9HOMmoPTifebsdq4T
	mQfshAL/bdF1+0uhujm79dO2AxRsEyWftBszsVWJYAb5QBB/clfa5W9Ox+EooX1lp60=
X-Gm-Gg: ASbGncuewpWLdGHzPVtV4FVw1xtRg1JbIrshSe7cveoq70M50gAXn/GRa8GctyZE8ea
	R5JE28s9MBOAQRRp0iZkUJbBMPY4KYn4sOBLUoMwCJBjB52XJoz9kA/9+7TdHJFiZLkXHwznI2D
	DZ2XSb5Q9CafoSVl88uOkp0nG3aAuilSexF5XykkD+82ms8od8nIH7j0IH65dObTT9G1uvigW3u
	jtRV7me/4QDPvqCEKQ+Ioqu6HP3gwGwDUuwx9L/9WDNdRq73Oa1DlQhaGPptCogMUs6/se2JLuq
	WBcSs5s4EnbxK7ZMtheZhNZZQsZ54dh53m4VV3kJizxZ8eeZxUqr8fi/XmwrmwQb5s2rOshwbke
	nHCMb7BJYVCYb5iV69b65Cs89DD8BilYe/NWGL219+CakULct6SXTp5QADM7no1Vx4k3Z
X-Google-Smtp-Source: AGHT+IHt6aPFR2Bw0HlJGSa/mOk3c8+BRcWZQsYV0g4OgyGhD3tGZLbn6be+rsoLdw/XIZZFhDjoag==
X-Received: by 2002:a05:620a:2541:b0:7e6:3030:e480 with SMTP id af79cd13be357-7e6963a6eedmr1890516185a.57.1754408933141;
        Tue, 05 Aug 2025 08:48:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e8040a9154sm214850385a.70.2025.08.05.08.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 08:48:52 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujJuF-00000001Ydr-4AIQ;
	Tue, 05 Aug 2025 12:48:52 -0300
Date: Tue, 5 Aug 2025 12:48:51 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 10/38] iommufd/vdevice: Add TSM map ioctl
Message-ID: <20250805154851.GT26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-11-aneesh.kumar@kernel.org>
 <20250728141701.GC26511@ziepe.ca>
 <bfac9ab6-9115-44d5-90c8-e22c3dbdb607@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfac9ab6-9115-44d5-90c8-e22c3dbdb607@amd.com>

On Mon, Aug 04, 2025 at 08:02:23AM +0530, Alexey Kardashevskiy wrote:
> I ended up exporting the guestmemfd's kvm_gmem_get_folio() for gfn->pfn and its fd a bit differently in iommufd - "no extra referencing":
> https://github.com/AMDESE/linux-kvm/commit/f1ebd358327f026f413f8d3d64d46decfd6ab7f6

This patch needs to explain how the lifecylce works and why the IOMMU
can't UAF the memory. I think it cannot really work as shown without
more things like an invalidation callback.

IOW you need to define for how long the return result of
guest_memfd_get_pfn() is valid for.

> > I was kind of thinking it would be nice to have a guestmemfd mode that
> > was "pinned", meaning the memory is allocated and remains almost
> > always mapped into the TSM's page tables automatically. VFIO using
> > guests would set things this way.
> 
> Yeah while doing the above, I was wondering if I want to pass the fd
> type when DMA-mapping from an fd or "detect" it as I do in the above
> commit or have some iommufd_fdmap_ops in this fd saying "(no)
> pinning needed" (or make this a flag of IOMMU_IOAS_MAP_FILE).

It should be autodetected.

Since this is unique behavior for guestmemfd it is fine to start
there..

> btw in the AMD case, here it does not matter as much if it is
> private or shared, I map everything and let RMP and the VM deal with
> the permissions. Thanks,

I think ARM would like to do this as well.

Hence my suggestion that guestmemfd could just have unchanging 1G PFNs
and all shared/private changes have no impact on iommufd.

If so likely all this needs is an invalidation callback from
guestmemfd to iommufd to revoke on ftruncate.

Jason
