Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EC8218E95
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734707683; cv=none; b=paMreus9pr3sLruc61Z8mOoxDu6vR1U5iTazwnG+gN2lCH7nRf2P8jEmxnSHn+I4tQqo+RoN5WGg6lIbY1/i0omZz6vJlns6IXRMEXD7FpuAS1n3aLl8Hw+I71p0wYYNWVEkflMOrhaiAqXyaGG/SQUq7o0f1zsQAjaSlrUJJnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734707683; c=relaxed/simple;
	bh=KfvyMmxFI8nm5OnFkvjaCBVSaSinWfbI/SB9mOMvufM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxS4+kvrDVUBfv/S5Cm3Sd3i9GxnLrWwq8f38npASIk83axhmLUh8SyA30M38MDzEPCoFqOmAk4t+pNTsW6g4mIK3ZM53M45Llxb2MV5CfnY3RXsz20fkMpqvYPk28OBSPztBYqdU++NxaC4AHMWxvN3244NssjW5mFY/HfGZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ldTOOjDh; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ldTOOjDh"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3862ca8e0bbso1548301f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 07:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734707680; x=1735312480; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/FJ/BWMcAeSqIEo73tjEOakYKuswlMcLnlIzYTAvbU=;
        b=ldTOOjDhd21H8rXsU/8lAt83QmnRaoyjp/+dIwwSBSDdc7vAiAKg7bA6L8jMqbetg+
         UXZMl/4lBmP0wvAEy7oJ0a4nZxXT81GPg8ZxKmLi+epIQ886FOuhkNVWZJpqOY+AY5o1
         KGH4GlbFbqJYqEckvqBVrLFuujBRWjzSd7RmMBcNFYpejXfJXXWZ/x3loUObMbdjj457
         4FqDrS8ZZqqrpjj3moiFzCf2Nb50Cqqj5ZABREcIEuWw+dzp3zu9TiT9SiTsC5ozwHkw
         LGOgGOQJcsVzO9eTpAnVKoJ9MznMgmmLbKw/9rH0pxtYwsStDa5MDJV4eq6Dhxpe9fO8
         drkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734707680; x=1735312480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/FJ/BWMcAeSqIEo73tjEOakYKuswlMcLnlIzYTAvbU=;
        b=o5ucB0RtH2lG1HXGfpJMkhOWWIsRRXlo3o+ccpsscu8LK0Y7Y42lrYBeJLnbNKaUlf
         vy+0cRncsO1UC6VfxEXmALYVOoezhypdjD93oJOe9OipijOVjQxZEPJQ1cX+QW6Wnt7d
         IKwVWM1hPvb1TJj2gD/8y8yam36QukhXBvKSIMawQezSf66GMcR6dSks1DmCk+L5Qm4y
         ceH3krR7AjsH/gGxK4+XuhZ5YhIybulQQ9u+SeSuk6C742CJ8OFyokHQfWWX4eP0gim2
         uIKBG6tHGVTIcVdq6vo+PnkE+OYgju6vJenO2ZiW/K8/LCh7zrgvx6qQ4YABsM4vp1RI
         /NJg==
X-Forwarded-Encrypted: i=1; AJvYcCUpAWOMKcGimW9TjDXcxawVcG73+1ob1QNDGWKX4ujjWtd3L7xkwYOdd4v5U3H9aMV0x6ZFFVU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVWvSDnkTeJtVOFlRm4OErutb3NGCj8SDrYaM2VZKueKv4viOp
	HXPEXPmnInp5nBd4VLfuG/rAEH3ab3mbgn558ZPQ38HUy2q+BQDxl7DH5qo+TyzXpzJkTxByZ4k
	BiA==
X-Gm-Gg: ASbGncsdsIWNHcCMuZfMSU4iS2ksH+8RGlBU+2ikr1eYLg86oiK5V4VG4abRchNgUqD
	YaHnGr0zd2LtpmxNl+Vo01+/k//gmLPoHZRnoLLgXJ+E4KYpV5defQIE96L93xFuLPCnDIk32N9
	8C43nDbhOGBa1SR1DdIC5bl5GM0wjowXlN2R5DYsmKULUieIfHiUTv4vfu54C9deSGKYLu6nscb
	JRMM//35Zt60qp96mLeF86tUJpIjFRD6wLCX/kyZDwImqu8Lj7VUVq0yh6RRAKRcfDd6/695IJu
	LwZB7cX+2g1NYLs=
X-Google-Smtp-Source: AGHT+IEG5BXn0iGAPBX0qNzaXa7+CoRYPQ9C8lBuFf1IDtIo1tsZXMYQwfRblUjictWqaHhz0sRuhA==
X-Received: by 2002:a05:6000:4a12:b0:385:df73:2f42 with SMTP id ffacd0b85a97d-38a221fa0cdmr2976447f8f.32.1734707679558;
        Fri, 20 Dec 2024 07:14:39 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f05fd7csm185283966b.172.2024.12.20.07.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2024 07:14:39 -0800 (PST)
Date: Fri, 20 Dec 2024 15:14:36 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Selftest for pKVM transitions
Message-ID: <Z2WJ3F0qiqvV3qTw@google.com>
References: <20241129125800.992468-1-qperret@google.com>
 <20241220141321.GA26794@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241220141321.GA26794@willie-the-truck>

On Friday 20 Dec 2024 at 14:13:22 (+0000), Will Deacon wrote:
> On Fri, Nov 29, 2024 at 12:58:00PM +0000, Quentin Perret wrote:
> > We have recently found a bug [1] in the pKVM memory ownership
> > transitions by code inspection, but it could have been caught with a
> > test.
> > 
> > Introduce a boot-time selftest exercising all the known pKVM memory
> > transitions and importantly checks the rejection of illegal transitions.
> 
> Thanks for doing this!
> 
> > 
> > The new test is hidden behind a new Kconfig option separate from
> > CONFIG_EL2_NVHE_DEBUG on purpose as that has side effects on the
> > transition checks ([1] doesn't reproduce with EL2 debug enabled).
> 
> Hmm. What does a test failure look like without CONFIG_EL2_NVHE_DEBUG
> enabled? Do we still get file:line information?

Nope, sadly we don't, but if you get a failure after turning on that
config then you can at least be confident there is a problem with your
code :-)

As discussed in the other thread, once we get the hyp state into the
vmemmap (I've got patches that do exactly that, happy to send them out)
we could just plain remove the 'skip_pgtable_check()' logic, and then
I'm not opposed to merging CONFIG_PKVM_SELFTESTS and CONFIG_EL2_NVHE_DEBUG
together as the latter won't have the same side effects.

> > +void pkvm_ownership_selftest(void)
> > +{
> > +	void *virt = hyp_alloc_pages(&host_s2_pool, 0);
> > +	u64 phys, size, pfn;
> > +
> > +	WARN_ON(!virt);
> > +	selftest_page = hyp_virt_to_page(virt);
> > +	selftest_page->refcount = 0;
> > +
> > +	size = PAGE_SIZE << selftest_page->order;
> > +	phys = hyp_virt_to_phys(virt);
> > +	pfn = hyp_phys_to_pfn(phys);
> > +
> > +	selftest_state.host = PKVM_NOPAGE;
> > +	selftest_state.hyp = PKVM_PAGE_OWNED;
> > +	assert_page_state();
> > +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> > +	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
> > +	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
> > +
> > +	selftest_state.host = PKVM_PAGE_OWNED;
> > +	selftest_state.hyp = PKVM_NOPAGE;
> > +	assert_transition_res(0,	__pkvm_hyp_donate_host, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
> > +	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
> 
> Should we recheck the unshare transitions here?

Yep, sounds like a good idea.

> > +	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
> > +	selftest_state.hyp = PKVM_PAGE_SHARED_BORROWED;
> > +	assert_transition_res(0,	__pkvm_host_share_hyp, pfn);
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> > +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
> 
> We could check unshare_ffa here.

Sadly no, unshare_ffa() isn't super smart, it'll only check that a
page is SHARED_OWNED from the host's PoV and turn it to PAGE_OWNED. So
we'd break the state in this case :/

> > +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
> > +
> > +	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
> 
> Is it worth trying an extra pin + unpin?

You mean doing pin > pin > unpin > sanity checks > unpin ?

I guess that would test that we can indeed stack the pins, so sounds
like a good idea too.

> > +	WARN_ON(!hyp_page_count(virt));
> 
> Can we assert an exact value (e.g. count == 1)?

Sure.

> > +	assert_transition_res(-EBUSY,	__pkvm_host_unshare_hyp, pfn);
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> > +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
> 
> unshare_ffa again here.

Same as above.

> > +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
> > +
> > +	hyp_unpin_shared_mem(virt, virt + size);
> > +	assert_page_state();
> > +	WARN_ON(hyp_page_count(virt));
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> > +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
> 
> Is this block actually testing anything new? Once we've asserted the page
> state and checked the refcount, the transitions seem redundant to me.

The idea was to check if the previous transitions had other sad effects
not visible through the <state, refcount> pair that would cause
problems. But I guess that is a bit far fetched so happy to remove that
part.

> > +	selftest_state.host = PKVM_PAGE_OWNED;
> > +	selftest_state.hyp = PKVM_NOPAGE;
> > +	assert_transition_res(0,	__pkvm_host_unshare_hyp, pfn);
> > +
> > +	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
> > +	selftest_state.hyp = PKVM_NOPAGE;
> > +	assert_transition_res(0,	__pkvm_host_share_ffa, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
> > +	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
> > +	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
> > +	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
> > +	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
> > +
> > +	selftest_state.host = PKVM_PAGE_OWNED;
> > +	selftest_state.hyp = PKVM_NOPAGE;
> > +	assert_transition_res(0,	__pkvm_host_unshare_ffa, pfn, 1);
> 
> Try it twice?

Sg.

Thanks!
Quentin
