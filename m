Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29750286D7D
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 08:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758010568; cv=none; b=pA8PVON3kTOXP3we4CeTZLmbW4op29tvC/bWswFIOdDKOgJQwN7WLvF2kycO6kWNvlPUbq+dOYViM/CJPpxSRbf7z3t6Ottp/AMCMs4IV3p8IBQRuHA8UBpZbdb1rOI1vHmRzeM6JatYP4CenQt5SrKmAC60Q7CRP/EhjN3yWSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758010568; c=relaxed/simple;
	bh=m871iIeOfCazaoSPmTALTlNsX9LyCc0jz8OY6/Cozzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bz4lrFzF9xF27kfI0pRX5o44fOjPpV0uwQBxZZVSkEf5f0v7b19V8J8AO9ZHtaBWBop1xAfCc6Th4EIyCVN3ckmYht0lYr8cO+esQ28O8bN2PDsxtxkaHy/3QxPerUt/TqZCChN2JTqcvkWfTtAHyIhD5N1j4O+ES+Fc3Q2Cylc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=heBU+3N8; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="heBU+3N8"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45f30011eceso32165e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 01:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758010565; x=1758615365; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=meShyEXsOGbbZChp3RRq7DlLygLq0PznBxg+g8h90lU=;
        b=heBU+3N8JU2l9SPGcGYCjBJNPiXN2tQ0wA3xthu8Bw/ocjG49qyeXpa7Vkt+Ot72SZ
         y9bXj/Tm5R9tXlhLx+A2ibfAuLYl+0kzlnuhpeqKFcTB0Q+E1QhpVh/xFiXwpGQ8V3a8
         SQniLwku/LW1/9LwpBhtVAqSugid7RNjPq6p8IHPFgrypGH0Uyjd/QArTwTK9RCErQwH
         UZgQef2+3XzvsY39vmvojBcXWBBHLVs+Z/eQsiGfYOPWCUauVa5LwxsYKBYrHmj93gnk
         ekl+7MiS3Jd0G9htHuaM7wqakbAl4i0sTsEpP8tnHVh3f2Znz6XiSHtaamlYtLUQK0F1
         MbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758010565; x=1758615365;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=meShyEXsOGbbZChp3RRq7DlLygLq0PznBxg+g8h90lU=;
        b=WX0tz9YqlwXduB1UUUF3YQDwowkcn571xKwKyuW2h6ir3lk3Xvw4gWL4W/vVs9V4AQ
         rz5SiLetf+s/hUIZcE7xgA5eBGf2WXF9ANgSFnBZBIEOmkfUOD3r+bcL2uuITYsBGNFx
         Hy+PyaLCLbp5PE4jW6MGo+2+CoQWjXZ34wfTKBLtTrA88lH4HBccfKIgO9kMD4iwWg0D
         Vl6YRZegqkEKA4uDNiiE7b7zETAnpZgU8y4Z3Kq4DIA8ettM6S4KFe85omxsC9VWANIL
         GpOwgcc9IMMfk8ISIM1Npr+gHmTayG8lYSp13xLnmdzCS8yiZQri6b+QYQ5bB5kVugSe
         M0xg==
X-Forwarded-Encrypted: i=1; AJvYcCWq77hlW5KFv7LkVqlmEsbpnHpGUXm2tSzK1ytL3BIuVqy9rU53TzvOAmiU2igFgPM2bHX8L3A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFxOltBe1SmRVPIHmZ5efcE6zYOPj0auoJSGafz+7qmDN3OhsI
	Aaxc4tpqGPeDFY6eiuPsDuQxYxPd7CvOqBGlr1PBxsCXdRuprMvaL6FhRVbXcz6M9Q==
X-Gm-Gg: ASbGncskTkGl5YG9tHsjRDqtCKD0LNSBncDMSwC2yfHf52o+WuQ1kqbcOV/Cvio262a
	q7o8PJXViTC6neIp8EO38UWzurhN5NpTjCVZCle+1My0fhkSmxJgNhTRJGBgeJ8buAhhYnRptHW
	fuMd0JFikj4IOmM+BExPdw5z9KY1/0ghvQzdIC0zH7mMXjyAhzHHZ2a7vALxgCx+/OYDAqbZCtT
	ZzigHmlpyqxqXY8z8CYL4nX0AvnqVtDLOLkwcszgeyLaQeKaBWr/tDuCtsYkn0PV+5QbX7NjLTg
	8Cy/THM3Xly9xBGb+wwIYk7Dy0oCKXrRm0icxy8mV7mogoVgDATePnjtTGVUM2efDZ4GI3xL7Bk
	98yjC3Y0oLZARVyiPNekD0qrDc2pugkIlgOsA04RpEII4BO0owHMznBpyBEnFNfu+02Yc9w==
X-Google-Smtp-Source: AGHT+IHNkoboGHrMun5G1DUGWBcXZWuBWQV4A74ZxNJ1t1bghrprssY/hv3V1PDkdyjCOmCzxhKQPQ==
X-Received: by 2002:a05:600c:2d08:b0:45f:2e6d:c9ee with SMTP id 5b1f17b1804b1-45f320ea054mr964325e9.6.1758010565354;
        Tue, 16 Sep 2025 01:16:05 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0372aea2sm217980535e9.7.2025.09.16.01.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 01:16:04 -0700 (PDT)
Date: Tue, 16 Sep 2025 08:16:01 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 04/38] tsm: Support DMA Allocation from private
 memory
Message-ID: <aMkcwZpr84eMc4fF@google.com>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-5-aneesh.kumar@kernel.org>
 <aMfQCoLuVeR0nf02@google.com>
 <yq5a348n823t.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5a348n823t.fsf@kernel.org>

On Tue, Sep 16, 2025 at 09:45:18AM +0530, Aneesh Kumar K.V wrote:
> Mostafa Saleh <smostafa@google.com> writes:
> 
> > Hi Aneesh,
> >
> > On Mon, Jul 28, 2025 at 07:21:41PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> Currently, we enforce the use of bounce buffers to ensure that memory
> >> accessed by non-secure devices is explicitly shared with the host [1].
> >> However, for secure devices, this approach must be avoided.
> >
> >
> > Sorry this might be a basic question, I just started looking into this.
> > I see that “force_dma_unencrypted” and “is_swiotlb_force_bounce” are only
> > used from DMA-direct, but it seems in your case it involves an IOMMU.
> > How does it influence bouncing in that case?
> >
> 
> With the current patchset, the guest does not have an assigned IOMMU (no
> Stage1 SMMU), so guest DMA operations use DMA-direct.
> 
> For non-secure devices:
>  - Streaming DMA uses swiotlb, which is a shared pool with the hypervisor.
>  - Non-streaming DMA uses DMA-direct, and the attributes of the allocated
>    memory are updated with dma_set_decrypted().
> 
> For secure devices, neither of these mechanisms is needed.

I see, thanks for the explanation!

Thanks,
Mostafa

> 
> -aneesh
