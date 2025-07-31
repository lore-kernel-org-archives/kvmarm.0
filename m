Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786B525FA2C
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753980785; cv=none; b=LjwBOQkCgmly6tlrnrSQ4lkpHvzqlmyTInL5f9Apa/MuEIFXxB633P/NnK9WWv4e6Mgl+OdSTHV0Te4Vha6Md7zopRIYzvuVaPeGvjYDqatN9kvp+MrpkIPvkDqzQxTg0WOD6rfZ9vxaDSncHxT5aabyd6dwFZHA9aqSfcdRZ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753980785; c=relaxed/simple;
	bh=pZ8JW4BupERaCqn+7ehMHUhgMaXIyZtrBvv8TKORWvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+twxJi6RN7dH16Wi820uOy3FCyp0SKd8oTRL0dW3efXY03dbcnKFJT5WSiFBHwGUZraZ6J/0hmZZ4/2v77+z/ET+po8dRLUa6T0Xagcldh7SZ9Aq9YEqbGbnEzucAY9H54QkgrEIB+C33wqvfrbhitCJ1WIEkMc/DtnRT7RXSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VOQ9OOJs; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VOQ9OOJs"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7dd8773f9d9so92696285a.2
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 09:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753980782; x=1754585582; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ge8sFkdUD5dsmHZi6nhZDTs93Pw2wZ3dkBFapdPEw0U=;
        b=VOQ9OOJsQzrZPdKLW63yAGmiSvYZDx/mDzevlsOYOifqWFVPlxh82KtpPI+KMjPTKT
         0Mn7fmh50wfYZcWRTa2sgKayvRngGZWyP4X6m0Wg27nr58LfidhV5eGO12beglJNdQkB
         f9ti50f+PMEVibkoShnAv6ZHU5CMWGzMRX0Rln0GxXFSsM90B76Gy/kAGqFw7wcaHpdu
         1mS31wyCe0oDrAyPrDXeLR/gsUChyZx9DyQKhRW6tjzxQLwqCAajWRLLAACPwVfRmA73
         KhF9YQnYm9fx2mr/TiDA7CUXsh8Pbmww9hvYs2kEtvsNFEn33B74WG8Svpc6v7P+O/7B
         ZNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753980782; x=1754585582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ge8sFkdUD5dsmHZi6nhZDTs93Pw2wZ3dkBFapdPEw0U=;
        b=Wsr88fvE7KOHmbQ2pUpDtK1fg4XGwnhV80s6TPDec41wH3uah6e69KEJbXSKQDOCdB
         jc70fxmFSht0jfoiT+B8wqOI+q9/PhltcBmXdOV5YqrnrxVUP6hreY6bUTiKx+9HNdR/
         5cAqYQcUXeBVp+WElO5I7PZRrjgXA5DKCdSeOHtfYkFfpy5vKYgXLaAyIz5OyKG5zrGO
         1KGS1k6Ly69ScK6NBzTHTsmqYBSFpFv64I+AFs7kwqnC8KCqJEKL+J+HpLklIVAF9vbo
         Agn70Cv8Pheot0Jzo0RoVLAfncPlCqU5lT3wnMXFwwdGal++i0uBHpta+DVOuI7bAEZK
         JEQQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9pCYQsgOpBz+GZOaoRDGvBYYR3keIriiKItSEZ5R4MEvoaKH4FYw49wOEflpVrXUwiQgRe8M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwH4hhrTXwwJtc+MmsOUwppCsGn+wnUXIukRjFgnZPOwhNv3piZ
	CYutn9475hI4ZScMMWYEU5pNI7scQzhiwdvAgbOuzUm+UwG6X/eLGXWqNkKSy1pZ0sk=
X-Gm-Gg: ASbGncvPmZWD+YH2zKR00+DjFbAoZLXY8Pw2+PfhroyQZThvJNr5IcKgSkzH6+nbQM7
	ncPgy1hqf6J3H2gs1KoU68XF0xX70E0aNSUOJG2mZbY3nbGMZaRcrhpIPYiQ6Ns+hi7dz8ttiII
	kvyH1xo5h8sIou16i/asZk+wSt2iHlja92wEh2eNA/NZYx5fa9Y6fEQu+83UE4IFRekLt2zUBRn
	OM1jMdX11i0tIj3tdHT/lAackJxDMVqv1R/CamPVD1BG0IWFjJKWU5f8sqboZGGKJT44vPLZcxM
	kF4KhJG4I8TcXK+chzpyd/9Y9n42QUVW4LBe/g+2BYbKlczjhC6qXahtopci/wmkpOappWQP4+t
	RzQBRjh6DCKqMPb47UnN9tc6/jbD7gdJdjQdpexSIhpUtM9n43MtCZVf16fbjzvIpAxrqCbTg48
	Nn+kI=
X-Google-Smtp-Source: AGHT+IFxkpl6QnLP1d2Hal87IlMNzkW4ERQZ01Eb9frEOc1Kw3im7nXPwCw8k1/LtI/6s3msgQWswQ==
X-Received: by 2002:a05:620a:2808:b0:7e3:4b7c:40a0 with SMTP id af79cd13be357-7e66f3e29c2mr1060489785a.51.1753980782245;
        Thu, 31 Jul 2025 09:53:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5c5537sm108625985a.35.2025.07.31.09.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 09:53:01 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhWWb-00000000qDo-1Gf4;
	Thu, 31 Jul 2025 13:53:01 -0300
Date: Thu, 31 Jul 2025 13:53:01 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
	linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH v1 34/38] coco: guest: arm64: Validate mmio range
 found in the interface report
Message-ID: <20250731165301.GY26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-35-aneesh.kumar@kernel.org>
 <d57d12ce-78c6-4381-80eb-03e9e94f9903@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d57d12ce-78c6-4381-80eb-03e9e94f9903@nvidia.com>

On Thu, Jul 31, 2025 at 02:39:09PM +0300, Arto Merilainen wrote:
> On 28.7.2025 16.52, Aneesh Kumar K.V (Arm) wrote:
> 
> > +	for (int i = 0; i < interface_report->mmio_range_count; i++, mmio_range++) {
> > +
> > +		/*FIXME!! units in 4K size*/
> > +		range_id = FIELD_GET(TSM_INTF_REPORT_MMIO_RANGE_ID, mmio_range->range_attributes);
> > +
> > +		/* no secure interrupts */
> > +		if (msix_tbl_bar != -1 && range_id == msix_tbl_bar) {
> > +			pr_info("Skipping misx table\n");
> > +			continue;
> > +		}
> > +
> > +		if (msix_pba_bar != -1 && range_id == msix_pba_bar) {
> > +			pr_info("Skipping misx pba\n");
> > +			continue;
> > +		}
> > +
> 
> 
> MSI-X and PBA can be placed to a BAR that has other registers as well. While
> the PCIe specification recommends BAR-level isolation for MSI-X structures,
> it is not mandated.

Right, there are not enough BARs in most devices to give MSI its own
BAR.

>  It is enough to have sufficient isolation within the
> BAR. Therefore, skipping the MSI-X and PBA BARs altogether may leave
> registers unintentionally mapped via unprotected IPA when they
> should have been mapped via protected IPA.

Right, this sounds bad.

> Instead of skipping the whole BAR, would it make sense to determine
> where the MSI-X related regions reside, and skip validation only from these
> regions?

IMHO this is a mess. The virtualization must end up putting a shared
page(s) covering the MSI space in the middle of the MMIO region.

I think this should be done by fragmenting the layout in the IPA where
the private MMIO is within the protected IPA space with an unmapped
hole covering the MSIX registers. The acceptance process should
validate this.

The MSIX registers would then be located in the shared IPA space.

A normal driver mmaping it's BAR will then crash if it tries to access
the MSIX registers. This is good, we want to catch these non-secure
configurations and block them.

The MSI code will have to know to compute the shared IPA alias and use
that.

Jason
