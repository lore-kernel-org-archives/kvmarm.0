Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71E91CF96
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 17:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730742390; cv=none; b=OX2vfXZcuCmf9xOG3hKsNCZXsR+wXJcYWiyHTqcny/dV2aQSde3q1XfYT+2N4o/yaaZwK0Z8HjOoK4TXNeGhqgZIyubYePkiwJP7AbwlMCnhiWCMaPXl78+ZsgPkChxRV9vCRr1zjTtAiaLtdd5BP4gLQQvZxQcsXxPjM5GfeMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730742390; c=relaxed/simple;
	bh=gPkWd2wxoxuxg+h0/hCmbQz5P9HcKQfqFk87B9FTzGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W3klokv6qXxSrhWSlKFDg5QgTbpSxkMBx7GY2Uu6VU9pxcco1V3Knxr9HEj2B2MPm+Vg/N5wXbLXPfxsqBEH3pi3Pt5FaieO0t8hqSKiqouwt60KtYKKQA+S01Z0Hv9Tnt9sIdIF4Pt8eTuYeIAl3ANh8CaTSyNbgV2cFSEARAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YkQXedgE; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YkQXedgE"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c95a962c2bso6198542a12.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 09:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730742386; x=1731347186; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iNoiMjw3OVqv17v9meTG6uSwfwajYIf8B5oUpoOvtpI=;
        b=YkQXedgET8OF7bHP7JhjRKYus34ptRjFwyfItNcKy9uX7wJiOTDNtwZTowPA2u/jX/
         4TzVOSyiqNTSgGDJlgq1O90tlN3UQL7z/zrCHsSpBcndMp8pDuIVpnoK2VHTzxsmMUeq
         P4U8xW1pilAQ4341VwRSbE9MpLQkUxWqZTgXG98pMxV6st/45/IBDchaygbNvvhGSOkR
         X6QTgD4mpqZ2FqkjMXWxcIFAp1KTzrpjFCGeMB99STms35Ovcvu+b/sr0bcVduVTQ6oV
         lHoNH3L15ldK754YwMOjByBRCNLMq4yzuzgS/MsuN5hMlfWhv7kLFRtUmuEL2oi675vk
         xuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730742386; x=1731347186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iNoiMjw3OVqv17v9meTG6uSwfwajYIf8B5oUpoOvtpI=;
        b=pcW7Se35w+fPU5zA7kkmNFtXOyJ/FKJKHTKoH6a0criv7zY8rfcSDxaHrlA4BmzriX
         3mGv52u4eI8JLPf6YELoumoAbhTXiEMs13T30dltmrsGVsvu/FCx+C0eBRluzxDw4juf
         yM0JB/sLFYfbcC8BuMbVz4FRNKNXEu4TSddDq5YlHExZ9yKs9nm+ICpr2vbqONzoKWbJ
         QdMdNa+2hwhKHqZ/2vo6zEoy623lIxltxwSvvNMv0eACRehdY8Sa5ga2n/uGdbBCfWW2
         pGmL+oYr2w7WeXbk0jMEVLAzRlMp23uQ2CluiCWBJNyLQvNerktgTIkeXIIKacp3HYtp
         0Sjg==
X-Forwarded-Encrypted: i=1; AJvYcCWjLcKtuKFw02gfkBZfim+o/y+HjsNJmekaZ2xp3vwltQdaU66ewuIcSBiX3vTBMOBkZ5iquhM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDj0rklGCiPmqLA9aFo+KJhHrHofwqJuoLevPKKfVwWFD7s+Ry
	zn75TPDIN3atEabIgphCsLu8KjMj2BxCFPTBrP54iiLmA41+zovsD8yKbRk2+A==
X-Google-Smtp-Source: AGHT+IGrs35d/XWv8BanrAW8j6PHDnWwBaSo/wZx0w5yxGi7BlKHJcenw8eSrxH3L+MaXjx1Bk+QUg==
X-Received: by 2002:a17:907:7d87:b0:a9a:684e:9a64 with SMTP id a640c23a62f3a-a9e50ba4055mr1494056066b.61.1730742385859;
        Mon, 04 Nov 2024 09:46:25 -0800 (PST)
Received: from google.com (40.162.204.35.bc.googleusercontent.com. [35.204.162.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb1813a33sm9246366b.185.2024.11.04.09.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 09:46:25 -0800 (PST)
Date: Mon, 4 Nov 2024 17:46:22 +0000
From: Quentin Perret <qperret@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] KVM: arm64: Change the layout of enum
 pkvm_page_state
Message-ID: <ZykIbvN8LO7pEan0@google.com>
References: <20241104133204.85208-1-qperret@google.com>
 <20241104133204.85208-2-qperret@google.com>
 <ZykFBhlzrUQtjEjy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZykFBhlzrUQtjEjy@google.com>

Hi Seb,

On Monday 04 Nov 2024 at 17:31:50 (+0000), Sebastian Ene wrote:
> On Mon, Nov 04, 2024 at 01:31:47PM +0000, Quentin Perret wrote:
> 
> Hi Quentin,
> 
> > The 'concrete' (a.k.a non-meta) page states are currently encoded using
> > software bits in PTEs. For performance reasons, the abstract
> > pkvm_page_state enum uses the same bits to encode these states as that
> > makes conversions from and to PTEs easy.
> > 
> > In order to prepare the ground for moving the 'concrete' state storage
> > to the hyp vmemmap, re-arrange the enum to use bits 0 and 1 for this
> > purpose.
> > 
> > No functional changes intended.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 0972faccc2af..ca3177481b78 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -24,25 +24,28 @@
> >   */
> >  enum pkvm_page_state {
> >  	PKVM_PAGE_OWNED			= 0ULL,
> > -	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
> > -	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
> > -	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
> > -					  KVM_PGTABLE_PROT_SW1,
> > +	PKVM_PAGE_SHARED_OWNED		= BIT(0),
> > +	PKVM_PAGE_SHARED_BORROWED	= BIT(1),
> > +	__PKVM_PAGE_RESERVED		= BIT(0) | BIT(1),
> >  
> >  	/* Meta-states which aren't encoded directly in the PTE's SW bits */
> > -	PKVM_NOPAGE,
> > +	PKVM_NOPAGE			= BIT(2),
> >  };
> 
> I guess we will still have to keep around the software bit annotation
> for sharing MMIO regions from the host. This would not be tracked by the
> vmemmap but it will still be in the s2 pagetable. As this is tagged with no
> functional changes intended, are we safe because we are not supporting
> MMIO sharing currently ?

That's right, currently no MMIO sharing is allowed -- see how
host_get_page_state() returns PKVM_NOPAGE for non-memory addresses, so
we should be good!

Sharing/donating devices is absolutely going to be needed eventually,
but I hoped we could make that a separate series. And yes, we'll need
_some_ data-structure at EL2 to track that, possibly the page-table,
but could also be something else similar to how this series moves that
away from the pgt for memory. Hopefully that's an orthogonal discussion
we can have later :-)

Thanks,
Quentin
