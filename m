Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19579399369
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 12:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777897743; cv=none; b=nSMwI3OpRI7gjrDxBF9hz8V1yZ/FTUHF3mIA5BNdjjVH+9CFHEHTXvYugKn4acDikrW+scSKvnRtBl9uA1O2ULFZkJh2ohvoU+0ulGW8kLDhFHvOik2B2Kh6hEiuY3xERJpnF4G8ovgYElZnoTzifJ5+B8CF4O5A57dWg/mhOc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777897743; c=relaxed/simple;
	bh=jslPeDjmLXFjY8GLLQ1VcbPt/4kQhObWLw86ZETE8qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCCUngAo16aH8WDcuBqwU3MigpOi/k8+PCsioA5+xbc/dyQ7UmHJ8PNje4CPdHCw6u/6HvYpHZBJNxcvUFU/YzUL78r9NTY9dUMsGi9t1tXRADMSwHmPK7t/XwgOK6rO/LIbVbIJBhfKCAX2L85kyYUR98745gqhGn95BNeO9Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LPi+ZmlU; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LPi+ZmlU"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so175825e9.1
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 05:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777897740; x=1778502540; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=814xa8seFs15bj3a4vxXUsxq6BSSUZsJ1eCZuSdGtu8=;
        b=LPi+ZmlUy1uXOF++5rvQIO697t6Ilk9lAa9aJRqX+K5Qpj/3YA4SbQA7yib14f+1Bg
         TZ5xv37/LoPQ8y5MGwnr+37ir2G2NIj6QC6eg+OkUKwqGVSBWTDODuWTbcSrdK9SdpFt
         8l1/XmSTCSUhzN5xi3QYj5MzqM8e69LFYf8blEfp2D1/6f1s+x9vkpGsk6wXzY+BKdlz
         ttT1u7AxWiQjtO6cUvYTeFS66mz5RYN8SQ2XsqFi7/+4Rqluds98txHM3VuFXKYFxFv4
         eOceYBXK65dDPjIO+Ks9cDrIIgUxiBDc4/If72RshkO8F7Y4I0UgfCR+TEm4bXUBZLjt
         fVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777897740; x=1778502540;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=814xa8seFs15bj3a4vxXUsxq6BSSUZsJ1eCZuSdGtu8=;
        b=rBvhA4ri9cSqexRBUMiG8URIvOl20p/ljzusYvNDhSJ7ZFLdRoSmkVGpp5oHf9tivH
         o9G7TdjDzKCR8JCRUPMZLXQrL1NH6s8IMTMx7nRFKDpqdsfX0aUE/RTjIBlgfTrIWLFy
         Hl0MV6ctQK2d0BwohztCsu60adC8gu6bRT54L2fFmLEvRghoZ+aE8RVOApioF7EbiAPR
         TzSUEEu2MPwNZOM13h4GF8SOwRXQ7cscSOzORQ7HF8EkUfBdjRVzF444x2xYUZvKN+C/
         BQt3vPeumdB+yPgmAOCAfNyrP6Wcwa35h2AH/uS8lBIJAP6BjF1C8Yu/BGWvBl8Icgqc
         +dpQ==
X-Forwarded-Encrypted: i=1; AFNElJ/LFpwQHSjHZoAsj2PL5csoXLHDTIC77d6kFtDDtfop/AHhdADI3qRkqCVY9VZ/4DuIMUCPWr4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPx398L14mNmJsZg9zCo7OHLdir8qpUVb/SsRxFsE0KGCWTG83
	nfuVZYVJIUmiuX0/e7eHkgidQFLFDi3IFHgf3C1oDRmbnw9JltJ4oeaQZLfECZMsiQ==
X-Gm-Gg: AeBDieuesjwrKE58P2qZretRCoZrYuindNmpABmyXUyJSzFStjpO5f9ohuGCwxwoC4j
	/nVfEXWxVpSPgKfBtU1g1Ddsqlj9SgZ0x1L3JOpnPnRTqrEmqloCEbb0AbKS8FWqRmgNW2KI/55
	/pZ4uZX1mIQr44N31vr4Jr+gblE8NCM+iXX1as45rL3jaRARmLC5E/79zEiuoKeFEEI6jEep4XO
	W0LZMuhtJtmvSn01ubOzgC1OEk+qjiEmADx3wBNA2NQ/zuYlIpNBqss2x/mVamyu3n891RMmSSc
	j9FN/yclsi0quULOKNaguHBOLQnIue1K2bjVEka2QNYv/1LrcmxQEV9dLpiymt6f1asIERgrlgj
	LX6rmEq+SlP+wsEOnf/9LPks6yku3DkktXkGGtRfK2XwvObJF3gnPRojrpSKCuaWb6sgkqVwjMb
	pp6+VqiRN+dMNnVCt+1k0x8rXRP/nY35ZACAvZs9JgHbo0WBaLSzfuWmGNFCIW7yzTMEsgZnFxr
	WTlhg==
X-Received: by 2002:a05:600c:8717:b0:475:d905:9f12 with SMTP id 5b1f17b1804b1-48a98102ba3mr3204765e9.4.1777897740070;
        Mon, 04 May 2026 05:29:00 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44b638ac434sm21945298f8f.36.2026.05.04.05.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 05:28:59 -0700 (PDT)
Date: Mon, 4 May 2026 12:28:55 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <afiRB3e3o0G1oZvY@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <20260501130006.GF6912@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260501130006.GF6912@ziepe.ca>

On Fri, May 01, 2026 at 10:00:06AM -0300, Jason Gunthorpe wrote:
> On Fri, May 01, 2026 at 11:19:10AM +0000, Mostafa Saleh wrote:
> > Create a page-table for the IOMMU that shadows the host CPU stage-2
> > to establish DMA isolation.
> 
> Is there a reason you can't just use the CPU S2 for the iommu?
> 
> ie the CCA RMM is doing that, it is how ARM imagined this stuff would
> work.
> 
> Once you start supporting DMA like this you have no choice but to keep
> a fully populated at all times S2 around, why not use that for the CPU
> too to avoid faults?
> 
> I guess there is a reason, but maybe explain in the commit message?
> 
> It sure would be simpler, you wouldn't have to mess with iopgtable at
> all...

Sharing the page table is tricky, this is something I have been thinking
about and my plan was to work on it after this series as it has some
constraints and would require core KVM changes.

So far this is the list of requirements/changes needed share the
stage-2 page table (besides the obvious: same page table format,
granularity, endianness...)

1) HW BBM is not supported in the hypervisor page table, that’s
   because it can generate TLB conflict aborts, which the hypervisor
   can not handle because of the limited syndrome information.
   We can rely on FEAT_BBML3 which was newly introduced to work
   around that, it’s quite niche and not supported in KVM yet or
   have an allow list similar to the kernel
   (as in cpu_supports_bbml2_noabort()) which also limits the number
   of CPUs that can run this.

2) Handling page faults, devices must be able to stall and let the
   hypervisor handle the page fault (which has to proxy through the
   kernel as the hypervisor doesn’t handle interrupts), this includes
   also IO page faults which are hard to get right from the HW which
   and may lead to system stability issues or lockups.
   Alternatively, we can pin the stage-2 pages, that would require some
   hypercalls, hacks to the driver/IOMMU API and possibly new semantics
   in the DMA-API for IDENTITY devices as they will still need to pin
   the pages as they are actually in stage-2 translation and not bypass.

3) SMMUv3 must be coherent.

4) Support BTM/DVM for TLB invalidation, otherwise some hooks are
   still required (although not io-pgtable-arm)

This is not the complete list, I am sure I will run into more issues
when prototyping this.

IMO, 1, 2 are the most tricky parts. It's more work and runs on very
limited systems, However, it can be implemented as an optimization)
which is my plan.

I am not sure how CCA deals with that, I’d expect they have a lot of
constraints on CPUs/SMMUs and DMA capable devices on those systems.

Thanks,
Mostafa

> 
> Jason
