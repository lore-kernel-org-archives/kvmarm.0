Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C4014F998
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 14:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709128904; cv=none; b=YZPx5EOpNupzQLVPjqzvvPxLg1BKL5z0ME4Plc4saXKUeWq5wRNlFyWts2pCukM6dYHEbK6JQgJtPny53l79QEGrC8zu/G9Ibg2BsUghA5eiqc/P96WkoDg1gWYaM6L85OMrW6Sgd9XiUOLbdFKSaSjgQTWWAXQY53UrN1TyZVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709128904; c=relaxed/simple;
	bh=xc76ZCeLWL3oTqKplyTXLIkjTzvs1c7E0/u3Cpm9N0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCA4gtg8ytkL8pLg1Ye7csBSqGQtoshBFDKXAHcPhpX3/MaaBiNVFlI2Wo+oRFA4VDcHqtfnycB+FN3IvvCbDxOf5fCfHwyiEc2Vx9mnE0jRR6Ezu7BwZyFhCM1hgf7VbsNkh6rowY2tkfpJbZcQyOEC5cHf7XiY4dLWloAHySE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J4BsQYHU; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J4BsQYHU"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a34c5ca2537so742909966b.0
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 06:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709128901; x=1709733701; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EnEXRx8bnyUyfsm70CiXRdEbU0pNvdct3xMdEGSpg+U=;
        b=J4BsQYHUJ+J31zs9elA4Ma0ws8egqKddc6pCfTJDaIAdufmQDd93CuJgg8zkiMFJoB
         Y8P1smcvA7MqmzO5gp/WzpN5xtWmVG+IQP88hLPAUE8u5G9HigKgGagNDeQHAjY1nHPd
         dOPW0OLPkK6gI+sk27NgPbEZcCiNWhi6qIGitRSzg4deN4bLFI96QlPQ++W2GiRreDJg
         BDWyBNabUJE5UnhpyRHDcCDMMfV+CheFCmA8iJ0/tt9niiLBKOHzqsKGWX+aIqaarsQC
         ty+VFqjxJxT24CHqO6WEhzjQ44x/q/yl4ovdRbaCthKnqkuPN5NQR7EQHhJQM3fqzLL4
         pa+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709128901; x=1709733701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EnEXRx8bnyUyfsm70CiXRdEbU0pNvdct3xMdEGSpg+U=;
        b=h9hjSGX9V9Fnb2srxu+qU14wO3c+FO/T/ZsVdGlzgeeHdEnqgNLwgJXb8rcZ1Jz+T7
         a8dr7zIUxPDS0rDy6coz+4kRqiUnlOABuq1hpyoVSmY8l1KHJOLDi/pNQx8QtyTadx9J
         CE+hr/VOtc2QxB8hI/hROYaDI9PNjOexxmOjBRi2n1/DwEf1uvu5cvVLFapXpHEoqoig
         Ha5GSzQm3BfgZ29HhlXPym8WymTUIx08JSDJXNzj0a4P+qjtDSxKvZ0lcZw3mfiZFtpd
         JTeZA5jYHrXkOBvWUdCsxopLkFVE/rYNhyVUZSEFlaMMFpxUB3LeezS6PrxLkjv8UZ69
         VISw==
X-Forwarded-Encrypted: i=1; AJvYcCXG0GpvtTzRiOe6HhYM9HA5fVRNj1kFWnX23vxTiLf8QktFjnV/9+HFdIx8FCAlQ6qAIZYt36fQDYjmOO26x9zxrbwCq6k/
X-Gm-Message-State: AOJu0YyCZ/gFMVPPJSZA03EJBz9XyxqSUbrxSGSjh0EqeqZJ4XBREHXs
	2+6hLc3RzSOi4A3GTz71A0q5J91Ufdh6HSgfuf6a81j8GCeDKlGYKbNDb3iTjQ==
X-Google-Smtp-Source: AGHT+IG+mMPw3nLKhBZME1EV6xBhg5as1F5Nh7tAbzSsU+HTsNt7AekMp+h4F9soXsgzhwe+C3070Q==
X-Received: by 2002:a17:906:af0f:b0:a3f:384a:73ab with SMTP id lx15-20020a170906af0f00b00a3f384a73abmr8640197ejb.71.1709128900636;
        Wed, 28 Feb 2024 06:01:40 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id cx9-20020a170907168900b00a43e8562566sm910600ejd.203.2024.02.28.06.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 06:01:39 -0800 (PST)
Date: Wed, 28 Feb 2024 14:01:36 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, keirf@google.com
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
Message-ID: <Zd88wFzxgGEWrhSb@google.com>
References: <20240222161047.402609-1-tabba@google.com>
 <9e983090-f336-43b9-8f2b-5dabe7e73b72@redhat.com>
 <CA+EHjTyGDv0z=X_EN5NAv3ZuqHkPw0rPtGmxjmkc21JqZ+oJLw@mail.gmail.com>
 <a09996d9-17be-4017-9297-2004f0bc8ed3@redhat.com>
 <CA+EHjTxBOs3M7DNeUfq9EfpZ8wSw5Uh6SOr_fG_9V=xjTH2S_Q@mail.gmail.com>
 <0951868c-911d-4879-bc79-14b5d3959462@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0951868c-911d-4879-bc79-14b5d3959462@redhat.com>

On Wednesday 28 Feb 2024 at 11:12:18 (+0100), David Hildenbrand wrote:
> > > So you don't need any guest_memfd games to protect from that -- and one
> > > doesn't have to travel back in time to have memory that isn't
> > > swappable/migratable and only comes in one page size.
> > > 
> > > [I'm not up-to-date which obscure corner-cases CCA requirement the s390x
> > > implementation cannot fulfill -- like replacing pages in page tables and
> > > such; I suspect pKVM also cannot cover all these corner-cases]
> > 
> > Thanks for this. I'll do some more reading on how things work with s390x.
> > 
> > Right, and of course, one key difference of course is that pKVM
> > doesn't encrypt anything, and only relies on stage-2 protection to
> > protect the guest.
> 
> I don't remember what exactly s390x does, but I recall that it might only
> encrypt the memory content as it transitions a page from secure to
> non-secure.
> 
> Something like that could also be implemented using pKVM (unless I am
> missing something), but it might not be that trivial, of course :)

One of the complicated aspects of having the host migrate pages like so
is for the hypervisor to make sure the content of the page has not been
tempered with when the new page is re-mapped in the guest. That means
having additional tracking in the hypervisor of pages that have been
encrypted and returned to the host, indexed by IPA, with something like
a 'checksum' of some sort, which is non-trivial to do securely from a
cryptographic PoV.

A simpler and secure way to do this is (I think) is to do
hypervisor-assisted migration. IOW, pKVM exposes a new migrate_page(ipa,
old_pa, new_pa) hypercall which Linux can call to migrate a page.
pKVM unmaps the new page from the host stage-2, unmap the old page from
guest stage-2, does the copy, wipes the old page, maps the pages in the
respective page-tables, and off we go. That way the content is never
visible to Linux and that avoids the problems I highlighted above by
construction. The downside is that it doesn't work for swapping, but
that is quite hard to do in general...
