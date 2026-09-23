Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57835540B3
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176880; cv=none; b=g33SHRG8v4TKS58HyhD07DAzJNCUqLNK0Z/TE8shBy/LdoBi4wzoZMs2bsnQGCGFU/11D4nZzukM2GNJRUmndb1X2VLcGw+gFLHD7YqO2atADnIA6ZCluzCj2XYKKpWD0MYWAbtsdpTJQwJgxx0GCpYn6wo8bP9dY4tHsAJfTcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176880; c=relaxed/simple;
	bh=3T521fW/HpOHDQpMbkHPHKx9NXhNDw5nf7wdl09SmWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iIMxUlzoVBX4vAAArdowig+s64LRsY4+TI3WYWESFAm/xu1P+VCAsn4z0DpIe3cVoLDI0wCvnpwkgwDOVq4jHVlO31vccr4Gxcg2GkoWfIbLoHclxzJbtpQMBItW198W4f0WiVEkSBEoGENtFAco3Jnht3kLGRdOqq+pDNsYuW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uK7ILqEn; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uK7ILqEn"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-498012a61f6so45685e9.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 08:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790176876; x=1790781676; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EE5PAnd1Wf6p3SmBC2optXiNbJWsLePJtC5K69fq2H0=;
        b=uK7ILqEnAMazFwRTHWaAowTZ6uAcojr+0b6npLWASDZs6NMxW6XOsbKnwqS6O+2UzM
         E+ffbXZz7/2L4DAk/9tE5CFtofq9rA5QRcbPi/+110O5AoBGtU8QiT38IFnrS0RZQoZG
         53EHmxWciyUTUFukxDPUwlaDeiUN4iNJOgXtBiZwqyjuadsCSfuNUMttxdDWcbkUgUvN
         Gavq2n+pA0qgfpWHu77JndNXigPvZYTjJfl915bv5MoqjHgWN4boUjdNopIbJEIU/vcM
         0lOJ1oSp3onDUzGpw8XJ7wlyUwwhbAkWjxIjm15x7sjH1HKhKUxMCvOtfs1/Sf7I1z8W
         cWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790176876; x=1790781676;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EE5PAnd1Wf6p3SmBC2optXiNbJWsLePJtC5K69fq2H0=;
        b=BLmwpKgkheGVvaut2S4aTEqEpMUkR4DaUtmKVYrkVz66GQ9av/XsG9lR15KJoNJinq
         b6weYiKghX4CTTARzy5txeN7Zhfl+qxxJBB9Q3C5hU/s5cJTOyKcAN8cJBnlw8761iDi
         3PY5vqw8We+ZcSYErERITB26ekfpy/c2HwReyfjGWoXMAaD70pjLOBrlXMRzR2d/FOIi
         0sGim/uVPq58mM00/4Yr7yLTO2LZF51XHfcSO0FSy6pBuKPr4Fs1UFXzAcXsctQJhPnt
         1mfXg/Nx8d/3r1k9DmU9WvVy5aCRXYjciZvbhSy/8inli+qb208PPBdBDYYRh+BtI37s
         hOfQ==
X-Forwarded-Encrypted: i=1; AKwUvBwmqS/i2wnvp+lfQQl+D6toJkDTQx97j9lrdoofIUZZwcnQ0KqNMDA8Bb4FZdHHiUuNZ8YSV60=@lists.linux.dev
X-Gm-Message-State: AFuF++l3SFqsh8ylO/krxSpMVPDTUAaPIRoFT8S2rkEuPJeB7XHJsVIA
	yKfN/8r3izuRvi4SgH4CIGP7Z0XuATON1IHClWE2qhHUQMc93DpbEZOYG7bnAr6nrA==
X-Gm-Gg: AYBFou2a8odEw7ReXmPDGYmp8IKwblGmYJIO2AryZpayrh5J30dZInZtX3Rnf+FOBZi
	Xm7GlliHirdz2gYhbmW2d8f57LgKTBfP+tfcMScNe2aPz1jZsbQiv3yRfNDcsEZ8RMjtcMyAiwW
	FPeDjLwqMhOrqVb20IDbFr4AEnd+WRVfJ32UobttBP6yY2YQCynB9eVdnXbcYmPDnHLgwpHNt0X
	xUaYW28aU5XrCdKE+VAJq7DeXCRA5286gakR1yPZXHD/C28YkgaNnm+0363eIyIqB7AlKgINYul
	O4X7jYqN6ET0DIGWoFOGnSbWZ1NlxAK6culjTlVrdgubnl2k6/8B2wm2AfqcKcSqKImfohwgl/O
	8FSy1m9+h0ev9+1XBVGseJVxuaptbFd4bpgCkY0ZuiZY3e9DrNPRJ87piCLuL7JSzj4aROKIs8G
	6ufhjvexVbL0eK+AVo7jqOWiPeHgF6k9sWxdqx1h+TF6Em7AhfTrka/1g+LvNVQPcpanmFGNb6G
	r8oJ4BM6U6rELbqP7oRdMUbdM5YWBuSaMiaR+02
X-Received: by 2002:a05:600c:4e8f:b0:49f:e1d3:fe03 with SMTP id 5b1f17b1804b1-49fe586ff32mr27765e9.3.1790176875531;
        Wed, 23 Sep 2026 08:21:15 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c3ed96sm1697075e9.2.2026.09.23.08.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:21:13 -0700 (PDT)
Date: Wed, 23 Sep 2026 15:20:43 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <arPuS9FXrkYJhbiA@google.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
 <20260923130031.GE1540250@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923130031.GE1540250@ziepe.ca>

On Wed, Sep 23, 2026 at 10:00:31AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 23, 2026 at 10:42:39AM +0100, Catalin Marinas wrote:
> 
> > On pKVM, we want set_memory_decrypted() to zero the buffer
> > before the host can access it (I guess currently relying on __GFP_ZERO
> > allocations). Since no cryptographic encryption takes place, there's not
> > much point in memset'ing again after the operation as the content was
> > already zeroed.
> 
> It sounds like this a pkvm unique thing, since RMM always makes the
> memory hidden, pkvm flow should do it too. Either inside its guest
> set_memory_decrypted() or inside the hypervisor like RMM.
> 

pKVM doesn't clear memory on sharing (see __pkvm_guest_share_host()),
and that is not a documented behaviour for ARM_SMCCC_KVM_FUNC_MEM_SHARE
(see Documentation/virt/kvm/arm/hypercalls.rst) which implements
set_memory_decrypted().

The guest is definitely the one knowing what is inside the pages and
whether it can be shared or not.
For example, a while ago I was experimenting with inline decryption
to avoid bouncing, and I imagine it might be used to build on in the
future.
Also as these hypercalls are ABI, I'd argue we shouldn't change their
semantics.


> Hypervisor doing it is the right place, hypervisor always needs to
> ensure guest memory is cleansed whenever the guest gives it up. Either
> via a private to shared, unmap or just exiting.
> 

"gives it up" is different than sharing, for example:
- When the guest dies pKVM will zero the memory before returning it
  back to the host.
- At the moment the guest can not relinquish memory (ballooning) but
  that is supported in Android which can zero the page.

Thanks,
Mostafa

> > I don't think cc_make_shared() has the right information on how to
> > safely and efficiently do the zeroing. That's only known to the
> > set_memory_* backend. So you'd have to propagate the flag down.
> 
> +1
> 
> Jason
> 
