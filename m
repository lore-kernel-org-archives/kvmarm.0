Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E42367299
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582558; cv=none; b=JsfybU83QEvxVND80qjOkd1k6/4WtRXZBd61RzJvwhn+GYXNU7+/pYjdz5ueLXhT6nq2ZwC/0zNLQq18UdUnyvaWijWijjp1FXtJossePZq8VTmtoYoef+flCZQ2YdYss3P/S1j9RtaK/nPcWMJkSgWn+jKrNz6+cbfddF166o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582558; c=relaxed/simple;
	bh=sH9hlfmrkF9dZBN/budsXhrCURN6fClLi7pruXZyxm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnRUPgJeSdpuxNBO8cnSxrABDFrfYLAUpXl6DqYwmQvYzcgj/gOV8xSR8ADWiiiX/Qut1VoMBCpqcYMtWx1Ofu/0NyFbo3F+YBfixX7fSw/AhNOI8ird+0ffeDmj8mKlvQC7b/d0ZnFZCI+sTM4BHBluFJlxj/Gs47P0EgHIaHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oggya1Tr; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oggya1Tr"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48d1c670255so1105e9.0
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 03:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778582555; x=1779187355; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gh0YPsx5HT0HEDlr/gUYFUWx5XOdgj6wDtu6dF4cI3k=;
        b=oggya1TrsLgQCj+LvfjquWEkLLKTJLZQc3w+hVjZDxWHRgQhZMf5wS5nPUZFO7X7xx
         qckgbc4ay9hJNiZGfZKTR5gXFnvk6KGJb+A13IEhc4YpXFy0cReBDNQpzZmazKIyOnHj
         BiJ2eo3J15PvEKuHmIFiU5QptDU2g9HqQh4wmW8oJMnhTwtf/GAVh3C1/ZsT4cFI97al
         I84ndfEY4gHC8sMDptQ18mOV7MICn9V0g1yYbAhCqACKOnSFaKzJQSV1DfQ4TSmS6UUH
         sMdTVBhdOPEmkGm8v3IlfmuoONJaGsUKK+5+RzVCWMXbvBShn1IfNXHJDrcnxyeqyiUV
         vamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778582555; x=1779187355;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gh0YPsx5HT0HEDlr/gUYFUWx5XOdgj6wDtu6dF4cI3k=;
        b=Flw0J6RA73m/4qwcuo9UKE5w/j9ea9vwooq6YWvI8iUs4/AzU4B7LSvabUu6VwAzzT
         VOvZZGKKpT9wjfcsVg4lHC/JtwP9vJCrMAnvmV/jsmZYVCJeR0+APRgSI5lUuwo/rL9u
         7CcpZDQd14AzZ0p3IhWsGAQRg6R0nxlLQMvRw0t0FdKF4xxf10aP03d8NBHCzhDGpXJ9
         hNVkR4wlpwFLhvFO5lvn/R73Mi3qirN3vaFL1eyHbClqT+anoCOJY79ZEDKVSonh7o6R
         sglZBSG34gGFYCgS3Qj4Y0Y+4ai2NUOgRKl/pJlrClJqgt7ikVIMgs1LayBCwDrVX2ic
         yP7w==
X-Forwarded-Encrypted: i=1; AFNElJ/CHG3w9a2lBngJ/RdljKXn+LdkzUsTEeYn7TY/huFBzEr8sh0IMdJ/yFzinTGmymGIqhNUyso=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZG/ZKSoYxrHQ/1k3UOJYhUbude3b3R1DoMB55dxrvPT2ULywm
	kpSkQRcgrXDqS9F4IwIImYa7CZIAGClPaBmX8g9BBvaA9DbB/l4v+pTxoP4B4PaGyw==
X-Gm-Gg: Acq92OHuBXMSen0saknddi2sMGmRs19iAmI1P7iYT2bopiXqxYcpMOzSVSqUlCPruXX
	APy3JijPjZWDVvOMTrDY61wbRyZeIA7aMZThPJ1Ox9BTp/PtaCgabd8wsSYW1FL7v5IjTyStI4y
	gRsyTARVLDUR2jiXXzLSBnB6nmJ4vMiTyxH1+oEd679qvo9E0OGXdizKY1fecX/T7hycw+2Tp8M
	c4kEKXFHWbYQO/zh2yf6V6rqV8nxK+OsraeUE53s5I7L2659OYVQX9az0kSLrU8xteIXPTjot9h
	lFz4zYtxhefTumDCmpqYrbJwy73i8NvqSecim3AIP4x9E+KLoL7VPrqKUDBJyd+HfWuwO/P7r9M
	O/gsiWhghwVuueqVnF2YWzRQm5o9M+tj4FWp3BZZaJt9uoSz/8klVVjgG9YoLQ292Q1+Kasqp0P
	W6pzwEpqhgbo24u7hbJs1yq/owLmjwhJJtRbR/ZjQFwwJMODWIpU98xek+hO36ke3UhcOZ5Q6gu
	cO8Gg==
X-Received: by 2002:a7b:c041:0:b0:45f:2940:d194 with SMTP id 5b1f17b1804b1-48e90664de3mr468235e9.2.1778582554477;
        Tue, 12 May 2026 03:42:34 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6b00fsm34945814f8f.11.2026.05.12.03.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 03:42:33 -0700 (PDT)
Date: Tue, 12 May 2026 10:42:30 +0000
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
Message-ID: <agMEFhxsmjpO0thM@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <20260501130006.GF6912@ziepe.ca>
 <afiRB3e3o0G1oZvY@google.com>
 <20260509232714.GI9285@ziepe.ca>
 <agG8XtrHUfWGy-kd@google.com>
 <20260511142232.GP9285@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260511142232.GP9285@ziepe.ca>

On Mon, May 11, 2026 at 11:22:32AM -0300, Jason Gunthorpe wrote:
> On Mon, May 11, 2026 at 11:24:14AM +0000, Mostafa Saleh wrote:
> > On Sat, May 09, 2026 at 08:27:14PM -0300, Jason Gunthorpe wrote:
> > > On Mon, May 04, 2026 at 12:28:55PM +0000, Mostafa Saleh wrote:
> > > > So far this is the list of requirements/changes needed share the
> > > > stage-2 page table (besides the obvious: same page table format,
> > > > granularity, endianness...)
> > > > 
> > > > 1) HW BBM is not supported in the hypervisor page table, that’s
> > > >    because it can generate TLB conflict aborts, which the hypervisor
> > > >    can not handle because of the limited syndrome information.
> > > >    We can rely on FEAT_BBML3 which was newly introduced to work
> > > >    around that, it’s quite niche and not supported in KVM yet or
> > > >    have an allow list similar to the kernel
> > > >    (as in cpu_supports_bbml2_noabort()) which also limits the number
> > > >    of CPUs that can run this.
> > > 
> > > Do you think pkvm will need BBM? Hitless replace of a PTE is already a
> > > pretty advanced feature and the SMMU has its own support matrix there
> > > too. Is it for shared/private conversion?
> > 
> > Yes, we can break block on memory donation which is transfer of
> > ownership to the hypervisor or a guest.
> 
> So you need BBM support on the SMMU too? That is probably a big
> problem because the SMMU is often mismatched to the CPU :\
> 

Yes, that's why it's hard to find systems that can easily share the
CPU page table with the SMMU (some might even have mis-match in
OAS/PS)

> Also io-pgtable arm cannot trigger BBM behaviors, so how do you
> implement it?

At the moment, we workaround this by mapping all the memory with PTE
level, while MMIO remains at block level as they never change ownership
at the moment.

This is one of the missing features I plan to add after this series,
if you look in the cover letter, these are listed under “Future work”

> 
> > > No.. once you turn on IO like this you don't have page faults
> > > anymore. Everything must be permantently mapped into the SMMU view, it
> > > can never be made non-present and you must run without page
> > > faults. That's what you have in the io-pgtable constructed table,
> > > right?
> > 
> > Exactly, but the CPU page table doesn’t guarantee that, so we either
> > have to handle page faults in the IOMMU, or completely change how KVM
> > deals with stage-2 if we want to share the page table with the CPU.
> 
> So that's the real explanation, KVM cannot manage the S2 in the right
> way so you can't share it. RMM/etc are managing the S2 without
> pointless page faults so they can share it.

Well, there is not really a right way, even with a fully populated
stage-2 page table, you can’t guarantee not getting TLB conflict aborts
without FEAT_BBML3 (which is quite recent), unless you map everything
with a leaf level, which then impacts performance.

Thanks,
Mostafa

> 
> > > >    Alternatively, we can pin the stage-2 pages, that would require some
> > > >    hypercalls, hacks to the driver/IOMMU API and possibly new semantics
> > > >    in the DMA-API for IDENTITY devices as they will still need to pin
> > > >    the pages as they are actually in stage-2 translation and not bypass.
> > > 
> > > ?? Then how does this series work?
> > 
> > This series works fine as it shadows the page table and doesn't share it
> > with the CPU, so it fully populates the address space.
> 
> Which is why it is so weird that KVM is using a partially populated S2
> when there is, and must, be a fully populated one for the SMMU. But I
> understand there are reasons fo rthis.
> 
> Jason
