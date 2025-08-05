Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823991F460B
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 17:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754414865; cv=none; b=hLMKJ11CdwuVtrLBqJjD82aq5lnnuQeY/87eEZirgGJSghmFEPKIl+R7vW3zDsuJorDM4uiv2kcXnGGNtQxvLbvSFHivHcmPbFVWEuVTIs0CEZ+Cb47juvJ3+uGvbErNiHx9+l9Q+6Cb9QM6aPYs5rYJxPQ4E3ExFlpOjM07h40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754414865; c=relaxed/simple;
	bh=ksPy7bPW/9nCkZK2o4mLxIR2SoHOhV5fATid0kfvACw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofueKspFSCz0EF4a3qZsaevobadABIHpWzw709uMZlRA6reEoBWuSlLfDMqmac4iVTF96taqf+h1vsQKM+FQdyVPTpTNcXn1ZRIVy2hoyNC22bs0BMLJmOit5ikvNu2qrU3FYovigW2s7xGXY7BFiK7VrL4NVIlPSrk0eN/Ax6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=RHQj1mNZ; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="RHQj1mNZ"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7e809baeef7so163180285a.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 10:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754414862; x=1755019662; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WjDqUy71lV/WUAYYIZFC/brYVFN0tl6XNylwIvC8u88=;
        b=RHQj1mNZoSrHDz/6LWVgVs32nORofP+zlZ8mVWzV0MO3HgX6WNqhvlmkpkowzz9VAy
         IdDCfRRf4MAx0R0cmwxQSbaVlFJhQms/T+EnO7M/GNqcKW0akeqeiowx86xZIfCeYGyu
         55RY0VnddZxqjNuiFCwSE2WRPQhp7Koy96FLpWyaq/nOQcJGy16LL7a5fOxxLYkt6lka
         MpIGy5x0IC/LfwHYTWAO8McK1WI5fypVfGgbBlCGq2l3M2kLgeJCN1yD4z6vu91vq8km
         mgl7NmfWx4bARx3dHvSvd9v17ZS9ZPaU7CryroVPL68GVXJmucC33hiAEDKFiIXvDu4D
         TtMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754414862; x=1755019662;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WjDqUy71lV/WUAYYIZFC/brYVFN0tl6XNylwIvC8u88=;
        b=u99h6P6lwH2OqBQlsHaDGhVy8WRPgk2zNWzNpw5PCP56JwWUji9MQ59nhDOetjyTrv
         QQtmQzRTT/hdjDKrWrlXly5LDyk78SrNLc1/DIjzY6ntPQMcgn1UTzH1ZbGD+amjyfUL
         ZsXHomJZZJXLUE3C7Vb45N1uW3egPE/HXxBonDh1kLGoY+GQb/ExTjPREFFWpE3MA70L
         gLUICo/zqyc+AYYRSVM2iRVT1XHnYfUyOVt82TCv4IfdmPP6H7r4XY3QaDt2lgkjcdXy
         YVJnn6WgCZ5ZkcwYtauo9IvW4oHZv0Mv/dBiv+Fkf56FmJ+0kXieMYqd2MvJj76IB5gy
         O5cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRAtNE0uw1ne5oRT1+xhDO8QHQcMLrto1iFPIySvz2IaCYelQ8816WjJ7NI23GeI2kzWW3HgE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqkGxHYIdGdjsEsMh5JDMAHwoMPgCc/7zYyMeoWsqqPGAydl5W
	PnBRj8BV/YRh3/btO4vfpW0peAM0SWJumNhFzsJaO8pTBOnQsG3gbx2qe/lYVSNHNAo=
X-Gm-Gg: ASbGncuLo9antB0g8NvFc9OP/SIiCE0LG69zsP0Gnx2uVzf53SoDOA153v/d8Lm4iqs
	GYwJ0tGuWXi+iBPjlaCjTdPEQ2RWAVCbwEEuqWKWjoG1CpspCCJroEwLb515FrVxiJrip8JfXNo
	EDiD0tzupzXfmnaD/wXqqx53cyVGk6nAy2kLF4ppeLYbmy5NvfxzNqYxdGDVkvIJl+YxH5X3htm
	QCi41J9dUUPErJXFxZuALJbeyCp+rrSN9Sk86QBQxiF3MFrEKQq0XO10rQPAWMJ7F8+rHttOeXL
	FuEi8ZB9pkKJP8FTjCQ66IqiatHwBQ39FwVkdsHbwByDXRwRvrQinUmqDUs5WeJUqLoxits4DN9
	p4C51okQ83jLtmY+ez/hpUkU6+eD+6i9pvzLz/EwSqSrBdtIOmKjds7ZxQm0pS+8dzxa8
X-Google-Smtp-Source: AGHT+IHy7XpO/6qEYngCoahXnCYpu69oHlagjnUCUPJ2Su1NtW9vipMRvRP+Dn6+sPrF7WNA3FiTmA==
X-Received: by 2002:a05:620a:a203:b0:7e3:2c33:6d9f with SMTP id af79cd13be357-7e814dad6abmr7669585a.31.1754414862403;
        Tue, 05 Aug 2025 10:27:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e806ad969dsm201306385a.78.2025.08.05.10.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 10:27:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujLRt-00000001ZRN-0PWO;
	Tue, 05 Aug 2025 14:27:41 -0300
Date: Tue, 5 Aug 2025 14:27:41 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: dan.j.williams@intel.com, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, aik@amd.com, lukas@wunner.de,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 00/38] ARM CCA Device Assignment support
Message-ID: <20250805172741.GX26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <688c2155849a2_cff99100dd@dwillia2-xfh.jf.intel.com.notmuch>
 <20250801155104.GC26511@ziepe.ca>
 <688d2f7ac39ce_cff9910024@dwillia2-xfh.jf.intel.com.notmuch>
 <yq5acy9a8ih6.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5acy9a8ih6.fsf@kernel.org>

On Tue, Aug 05, 2025 at 10:37:01AM +0530, Aneesh Kumar K.V wrote:
> > To me it is an unfortunate PCI specification wrinkle that writing to the
> > command register drops the device from RUN to ERROR. So you can LOCK
> > without setting BME, but then no DMA.
> 
> This is only w.r.t clearing BME isn't ?
>
> According to section 11.2.6 DSM Tracking and Handling of Locked TDI Configurations
> 
> Clearing any of the following bits causes the TDI hosted
> by the Function to transition to ERROR:
> 
> • Memory Space Enable
> • Bus Master Enable

Oh that's nice, yeah!

> Which implies the flow described in the cover-letter where driver enable the BME works?
> However clearing BME may be problematic? I did have a FIXME!!/comment in [1]
> 
> vfio_pci_core_close_device():
> 
> #if 0
> 	/*
> 	 * destroy vdevice which involves tsm unbind before we disable pci disable
> 	 * A MSE/BME clear will transition the device to error state.
> 	 */
> 	if (core_vdev->iommufd_device)
> 		iommufd_device_tombstone_vdevice(core_vdev->iommufd_device);
> #endif
> 
> 	vfio_pci_core_disable(vdev);

Here is where I feel the VMM should be trapping this and NOPing it, or
failing that the guest PCI Core should NOP it.

With the ideal version being the TSM and VMM would be able to block
the iommu as a functional stand in for BME.

> Currently, we destroy (TSM unbind) the vdevice after calling
> vfio_pci_core_disable(), which means BME is cleared before unbinding,
> and the TDI transitions to the ERROR state.

I don't think this ordering is deliberate, we can destroy the vdevice
much earlier??

Jason
