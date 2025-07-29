Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CAD3597E
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 14:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753799623; cv=none; b=Q1I9IsJ5MDR/zbV7LlHQoLAAJx2OCL70laxWHUXfYnUXKGKPKzC676L98CuaPFDhblrCFSfXrmMlds2zoSs5z+Ysztc5VnzJHyFc0b6t/o4Nitg7gyNDvM5y4oW5YBtebCb8NBGv63v4FSxhAg6sQspj3YR4pg4UY4fufIbIBBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753799623; c=relaxed/simple;
	bh=ojv5Z7THW8JfrqGJ4bInzPOYWW8IoCSNM6sPyk5dgw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KtJaniEhFdVDjpi1Ai5mb7ZM5yeEZJy1i2Qcf4CkBzI1BVMXXiYtxioPqTWTe7rmn/jwuFcZYByNzvyWh0eHnXNiF3LqzstU9+r8mlqOIWs/7gifI5Ztyy1kf/bojPu/yvWiCTGQxGvIHlmDgR4Y5oHShC1wTFxzAKFeNNdzY1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=C5fImD0q; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="C5fImD0q"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e33d36491dso769255885a.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 07:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753799621; x=1754404421; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zc+uyc/10nytSXi8WQLd6ot7w8SU7ZrDrS30Eiz0b4M=;
        b=C5fImD0qczcn8zPNSv5JQJHYeSBQ/Uli/RsMr2vdNZQwKCxlmBMYyz49OgfbpkEDM8
         KC0sL7KYObkgRjmYMu3BU/Nlh0CwgZ//y1wZkAhcMHW8h97xspiJdQv2GJ0ENF25qciE
         Ey19bGtf7HWQcQh25uaS3RIZY0kpkw9bct4gvpV5lSoyZ+Y4BM8hTEzwL7dR+mURVD/v
         DDFFWAuN6Osuyr7FmP1ZC3KM72mwbamT7G5DG+FO2fbY7fUXl+C5T+uc9us4dlCPM1qe
         4Ki7Yn4rwXH2H2SkybGYoIEB6Q0LlQrz4sllFIJ/u2QyjeH0HrttxxXAmPfopedszMzZ
         FagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753799621; x=1754404421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zc+uyc/10nytSXi8WQLd6ot7w8SU7ZrDrS30Eiz0b4M=;
        b=dT4BGrcYV+dVYfFszRFvFRQgkeOAj0J9DZ3OYjDOJbHEFn1sNOZcE1wYFLk1by8roh
         76xNUT3juElUIo2rUmTS7AwzcanvSF42mxxybUeJ4D69FJ/CB2OfC5JEewmdrAfSNqSd
         e+MO4YB1tkpDDXJpBOjSfKpRn3tV6n0x4HZE7wutNl3m0/1d7p4KA7Re6KrQfMSsApX0
         FUAyIXjVC73HjKe+HgWoSbOIXmfHVkDmIMg3QkeLY1cSI+vAYHcq3Cq+rpUg4JMD7VB6
         ArDN07j40ra9dUraNHMrbpzgsQyGlKS4B3f81ahQ1MNgb7f/QN3t+xCvpcRpW/RxKtLb
         Vfdw==
X-Forwarded-Encrypted: i=1; AJvYcCVXAotKFurO1jDHc6hDytn52ztLgvGWu17oCHneaHbwI5psG76cMQn/xMBu3RjMQuZMLvU3gvs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyH0CchHMafDB2eWNNJKO7PTBIenz1Awk6eFi9thhvexA+v6pG0
	e90AA1Bp90UGOX1W2bVBdFdSMmYNHDIRfyruo9J5uKakX7plc7i3J0VY1l3oYn5r+1s=
X-Gm-Gg: ASbGncta3z4CArX4MbpAPjikWXOzqAY88QdaehK+eSFu81nIEunHwMNF3+4DS8Agg1E
	g+kqPyWqeHHAggCefiIMkPq9JpcxdH2FUFgbYRS2eFoACC39vAavfP1S6TCBMjlI9clNZdwLo+7
	2bXKXALMRAcnA9zIj+kEsMXMEYDzBrB+68AVzOD0HADfqGmhSeoQce1Et+FujloxlLSyoe4tyne
	isSUjAZB1HeHrg+dFvwqb6XRgZcoaLJqLNRdDN8ohOzaXMZI6zQWlSBfj7P/a/CTZLNFFHV3WE/
	Gb+MUaPQh4cBjGsm/M2pWUOLk/vcUqEz7QRldNQwLpFYcfyPzm6KS8CZMWqfb1PQtpYfu1r0fQ0
	KSCwn52GZcytYf1Xo+vtsED1rNtz6C0cSBy6TnOpXasSc+P11UVVoOhmgy5T5n1+XfbWU
X-Google-Smtp-Source: AGHT+IHlakacjzSc6HrtkoDQ+47XGGqWamMHvLTjn6gOzXHOqB44DtAdNM0WnIqA8RXRkWmuxkK6+g==
X-Received: by 2002:a05:620a:a509:b0:7e3:3da8:1d06 with SMTP id af79cd13be357-7e63c1bc55bmr1839986885a.54.1753799620968;
        Tue, 29 Jul 2025 07:33:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e64388f28asm436155985a.66.2025.07.29.07.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 07:33:40 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uglOd-00000000JId-3w7n;
	Tue, 29 Jul 2025 11:33:39 -0300
Date: Tue, 29 Jul 2025 11:33:39 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 04/38] tsm: Support DMA Allocation from private
 memory
Message-ID: <20250729143339.GH26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-5-aneesh.kumar@kernel.org>
 <20250728143318.GD26511@ziepe.ca>
 <yq5a5xfbbe35.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a5xfbbe35.fsf@kernel.org>

On Tue, Jul 29, 2025 at 01:53:10PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Mon, Jul 28, 2025 at 07:21:41PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> @@ -48,3 +49,12 @@ int set_memory_decrypted(unsigned long addr, int numpages)
> >>  	return crypt_ops->decrypt(addr, numpages);
> >>  }
> >>  EXPORT_SYMBOL_GPL(set_memory_decrypted);
> >> +
> >> +bool force_dma_unencrypted(struct device *dev)
> >> +{
> >> +	if (dev->tdi_enabled)
> >> +		return false;
> >
> > Is this OK? I see code like this:
> >
> > static inline dma_addr_t phys_to_dma_direct(struct device *dev,
> > 		phys_addr_t phys)
> > {
> > 	if (force_dma_unencrypted(dev))
> > 		return phys_to_dma_unencrypted(dev, phys);
> > 	return phys_to_dma(dev, phys);
> >
> > What are the ARM rules for generating dma addreses?
> >
> > 1) Device is T=0, memory is unencrypted, call dma_addr_unencrypted()
> >    and do "top bit IBA set"
> >
> > 2) Device is T=1, memory is encrypted, use the phys_to_dma() normally
> >
> > 3) Device it T=1, memory is uncrypted, use the phys_to_dma()
> >    normally??? Seems odd, I would have guessed the DMA address sould
> >    be the same as case #1?
> >
> > Can you document this in a comment?
> >
> 
> If a device is operating in secure mode (T=1), it is currently assumed
> that only access to private (encrypted) memory is supported.

No, this is no how the PCI specs were written as far as I
understand. The XT bit thing is supposed to add more fine grained
device side control over what memory the DMA can target. T alone does
not do that.

> It is unclear whether devices would need to perform DMA to shared
> (unencrypted) memory while operating in this mode, as TLPs with T=1
> are generally expected to target private memory.

PCI SIG supports it, kernel should support it.

Jason
