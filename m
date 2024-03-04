Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A14322606
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 12:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709556824; cv=none; b=Kji7u5GTGRyVfdA2GLPNx4msI76c9VOMWgwKaaMNGHnKtedSTypwOsJkRKcoEPZzXVooDkHnfMVHXYiuTlA7dMbOEtJUWP5p/pWG2M17D3oc54INFqvjyO+Dsf//FIXxfn8Zbug6FxKA0ybWoujLXl/fzQMkQoG4ptATIHGTCLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709556824; c=relaxed/simple;
	bh=vVz6xIL9tHiA2o75AS9tAoF1SmfRuNfI8s8famUamnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTRSiUWMglscZdl0ML0p4ckegDuFL6jXTM570EcM2DSWDXDpFrLs1jXRlsT3fu3i+EF5JSKEZ2SFkJU1ua127YlPv+2cOA7PmcsbkizYU9ThtiXP5B4ieiLQTL2th0hI9Gdt/9oGnrzLUyi8x6qI/tKEKTri49ZXJ5WhlU0xaDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FirWDRFo; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FirWDRFo"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d2509c66daso55369761fa.3
        for <kvmarm@lists.linux.dev>; Mon, 04 Mar 2024 04:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709556821; x=1710161621; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyJk6hu3JJWbvReoDubwdKriDejEDiVT4W+9pXCxJ+E=;
        b=FirWDRFo8S3dz1aPhWxBxqIETG9jJg7ah/Eyus2rqoEaNBdTjZHOOXy1OO39rIKJJV
         Ji8RgvsReakhjV6ezT9jmuS8pp3RbvFBDGaPjMItF9Yw0FU5hruhNpkU5yrD2cyOUKmk
         dnZQ7Fbq28abH+OWnSFGBWJ+JN0DooJHpiTCesT+NcFWD7HUepMjAT7BTfkpYMzXJp2W
         6r5cK/q5OBFp6Z/+7h7oMjk/5/m3tcEFqt+AvbhonjSs199Y4mK4WFIH6yNRWrmDfmHS
         ZD0Bted3nfy3yTkmzbQgnWrj5ri5hfaU9BGvwyyGJ4bbnsREDTGRrKNftXK3GVpugapz
         lw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709556821; x=1710161621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyJk6hu3JJWbvReoDubwdKriDejEDiVT4W+9pXCxJ+E=;
        b=T4uhIDCtpA8MWoOdSsUkaQwFURDepTa0dxrsQO5O1oWPSVemko6h5rESMai8VGVZab
         f+L8mOP0ex8FVpqdgYylW4sWuFOtYB2mKIPkNwgnXZFNrxoIVwOcJyBQPYT2gb4JGCkE
         SL6ar84W2oOat0qb5T9OxH4B3sfkuhxgctCBWZ/HccQlDcsKZcAwAhLMS2jmYiYNpBkg
         a9iwOJGtN3d1qlydvjdyqNIml9oXYdP5FO3cNOtSMgRD/wWBZvLp/fmrhRxEWVAUleu0
         oDXNuBTNZuTmgvqKrxbBHHHoKnG3ha6KH2TT/OLT0BIg2LYbL+0+MFm4s44UmYvvLQXe
         ZxZw==
X-Forwarded-Encrypted: i=1; AJvYcCXlkysF+qi6CyDzVgfZucwZBlRcfc2ALdlpePzaQNRSkIuYAtBEI5xEcK6j/lee/wHZnTIfcZ03c/muUueN1c1/1rG7D4ik
X-Gm-Message-State: AOJu0YzZc4cuWkTxrKI8uje8sUWUtHnXd980sITfhqsoR5WRg3gXGuoP
	o7p529rw16nj2nXVZIdtzdNwEo7kS+QAMDNU/9e4ScICmdl1iCBeDICFIl0Jew==
X-Google-Smtp-Source: AGHT+IHtjqEhfl4jblKM5MgIY40eq1zkabY+65oqUKrKFxAD8VaMIS1dfXXB8O4itgb1+Pj3fW84dA==
X-Received: by 2002:a05:6512:b8e:b0:513:1f3f:3fef with SMTP id b14-20020a0565120b8e00b005131f3f3fefmr8263628lfv.1.1709556820493;
        Mon, 04 Mar 2024 04:53:40 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id d17-20020a056402517100b005671100145dsm2378285ede.55.2024.03.04.04.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 04:53:39 -0800 (PST)
Date: Mon, 4 Mar 2024 12:53:36 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Fuad Tabba <tabba@google.com>, Matthew Wilcox <willy@infradead.org>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, brauner@kernel.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	keirf@google.com, linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <ZeXEUMPn27J5je8T@google.com>
References: <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <CA+EHjTzHtsbhzrb-TWft1q3Ree3kgzZbsir+R9L0tDgSX-d-0g@mail.gmail.com>
 <20240229114526893-0800.eberman@hu-eberman-lv.qualcomm.com>
 <d8e6c848-e26a-4014-b0c2-f3a21fb4e636@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8e6c848-e26a-4014-b0c2-f3a21fb4e636@redhat.com>

On Friday 01 Mar 2024 at 12:16:54 (+0100), David Hildenbrand wrote:
> > > I don't think that we can assume that only a single VMA covers a page.
> > > 
> > > > But of course, no rmap walk is always better.
> > > 
> > > We've been thinking some more about how to handle the case where the
> > > host userspace has a mapping of a page that later becomes private.
> > > 
> > > One idea is to refuse to run the guest (i.e., exit vcpu_run() to back
> > > to the host with a meaningful exit reason) until the host unmaps that
> > > page, and check for the refcount to the page as you mentioned earlier.
> > > This is essentially what the RFC I sent does (minus the bugs :) ) .
> > > 
> > > The other idea is to use the rmap walk as you suggested to zap that
> > > page. If the host tries to access that page again, it would get a
> > > SIGBUS on the fault. This has the advantage that, as you'd mentioned,
> > > the host doesn't need to constantly mmap() and munmap() pages. It
> > > could potentially be optimised further as suggested if we have a
> > > cooperating VMM that would issue a MADV_DONTNEED or something like
> > > that, but that's just an optimisation and we would still need to have
> > > the option of the rmap walk. However, I was wondering how practical
> > > this idea would be if more than a single VMA covers a page?
> > > 
> > 
> > Agree with all your points here. I changed Gunyah's implementation to do
> > the unmap instead of erroring out. I didn't observe a significant
> > performance difference. However, doing unmap might be a little faster
> > because we can check folio_mapped() before doing the rmap walk. When
> > erroring out at mmap() level, we always have to do the walk.
> 
> Right. On the mmap() level you won't really have to walk page tables, as the
> the munmap() already zapped the page and removed the "problematic" VMA.
> 
> Likely, you really want to avoid repeatedly calling mmap()+munmap() just to
> access shared memory; but that's just my best guess about your user space
> app :)

Ack, and expecting userspace to munmap the pages whenever we hit a valid
mapping in userspace page-tables in the KVM faults path makes for a
somewhat unusual interface IMO. Userspace can munmap, mmap again, and if
it doesn't touch the pages, it can proceed to run the guest just fine,
is that the expectation? If so, it feels like we're 'leaking' internal
kernel state somehow. The kernel is normally well within its rights to
zap userspace mappings if it wants to e.g. swap. (Obviously mlock is a
weird case, but even in that case, IIRC the kernel still has a certain
amount of flexibility and can use compaction and friends). Similarly,
it should be well within its right to proactively create them. How
would this scheme work if, 10 years from now, something like
Speculative Page Faults makes it into the kernel in a different form?

Not requiring to userspace to unmap makes the userspace interface a lot
simpler I think -- once a protected guest starts, you better not touch
its memory if it's not been shared back or you'll get slapped on the
wrist. Whether or not those pages have been accessed beforehand for
example is irrelevant.
