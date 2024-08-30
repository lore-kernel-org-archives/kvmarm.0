Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618631BF31D
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725049351; cv=none; b=blPoqVHNjbcdZq0lSp59e9TWY+Ss+Z2WkMsNKgCoeBZT9jPUrNMQG2rxFzKL6hpkxBy/0jvGQlvI9vugb7vuSPwP4DUQwOZj67YJrnNQkqZGwGNRhKWYszZCsr2ivl1gahJ7b9RjGDCE+CPOQchELsAcZZgtvzGJ113x1E45ckI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725049351; c=relaxed/simple;
	bh=69g76M+8hefwuaehmWYZbLKVNzg3ea6UZdDzVjREdlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ICXjj2+6hmhnERJ8cukGroVL8VcShe683VazecchBAMQ8pSUQmmDM2PxOabs9nHidpvxLkvcMXlgeQ0XB1mf6LXvc3fwDfu0rA88CPvaORlhfkyfFrWgJuN6hdjgg2SC0Rr6fY3gpVuMWLJE8JwdSx6/k47yR0LfVqgRYuvhhj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gWjobdhF; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gWjobdhF"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7a8160a7239so60829585a.3
        for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 13:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1725049349; x=1725654149; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JR/0i0yiNSc6+4mgZmofS3FVrEo7P/f9nDPweyfHOlc=;
        b=gWjobdhFHB4xlPe/o8aNk2474gCdGWIYpSCXRzOii/HHgC1y4CpQKALyPyp6KZL4Nf
         osMu8rUec5XCvE80ukywWrJUf9910tDYbOfIkJOlC5RHCUBaoawElgGdx+zRDLhJERe3
         97kdKaYVqurNJA0EhtmlFE324HjA6UsjAJxWcX7UXqN9TFbu4SkdjRQNz0uq8GHrhrdf
         m6T3969+zDbHyRya/tMycM4DN6iQdGpmCB9+FM+vGjyNGqTUNWyO6nY5iBSvy3IknpsY
         DmD/UZzvJWNTVZsmOB8BwcC01QKT5g5kcfg2i2m/7tBmGu73zxi7dTfWN7BDL1nc3E92
         GiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725049349; x=1725654149;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JR/0i0yiNSc6+4mgZmofS3FVrEo7P/f9nDPweyfHOlc=;
        b=t3LyUUJli4U4+ByvoN6TNut48IVpFyDXQ8QuICC+Q7wbe5n6rBKjAxpSCJkADqcmu9
         n+ba/DGIexu/mLT0H7BwjqamYMAk26RaXtZTjwtdwqnnzrLgrKqgLa5qk8mI2FCvhOtD
         oqlMNLL60lMR4/Lnj2lVPjNih0DUE3+KrT5dhIN1boxGLkRRsm3jHM6iaPClwuAV42sI
         nQJAIsslySYigkq8yYS4g53ZROXBb/GDw2weX/g1J+gnkVJ+omsTDhqE9Lbc8lkfPrxK
         GESZPqm0OlQFkM+VKQEcrK28nOeGiwtOm8rBGRIjIK862ds4KCCVltkZEVl4r367lh25
         M9+A==
X-Forwarded-Encrypted: i=1; AJvYcCXlUzna2KJGwoWAjW56aCRS1ORIF4gqhH8d+gh//+XEeNgucNUS6v7iV8Fea+wBeokMPP+tCKk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+fU2smbK+hi0fmRRFpbCwkmiJ4U2cNHS54MgKKgQQjHpV8KXM
	+eBMnGmiaxYg1NNfLSq3b07Q7LRZazu0DrBp7NqAxlGfJSJP8Qi5LBGz46YjSeQ=
X-Google-Smtp-Source: AGHT+IE3fznrLjug1k6BmssxKA2PoSv1rWSM5UMVETLEHHqg9/Fb0jaD+sDVJuxj/qFxWflQcys1Iw==
X-Received: by 2002:a05:620a:f06:b0:79f:57b:f633 with SMTP id af79cd13be357-7a80427797dmr757399385a.56.1725049349148;
        Fri, 30 Aug 2024 13:22:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45682d66c30sm17088371cf.68.2024.08.30.13.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 13:22:28 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sk88a-00Gb36-36;
	Fri, 30 Aug 2024 17:22:28 -0300
Date: Fri, 30 Aug 2024 17:22:28 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
Message-ID: <20240830202228.GB3468552@ziepe.ca>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-3-jthoughton@google.com>
 <Zr_3Vohvzt0KmFiN@google.com>
 <CADrL8HWQqVm5VbNnR6iMEZF17+nuO_Y25m6uuScCBVSE_YCTdg@mail.gmail.com>
 <ZtFA79zreVt4GBri@google.com>
 <20240830124720.GX3468552@ziepe.ca>
 <ZtH8yv5AabMEpBoj@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtH8yv5AabMEpBoj@google.com>

On Fri, Aug 30, 2024 at 10:09:30AM -0700, Sean Christopherson wrote:
> On Fri, Aug 30, 2024, Jason Gunthorpe wrote:
> > On Thu, Aug 29, 2024 at 08:47:59PM -0700, Sean Christopherson wrote:
> > > On Thu, Aug 29, 2024, James Houghton wrote:
> > > > On Fri, Aug 16, 2024 at 6:05 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > > +static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
> > > > > > +             struct kvm *kvm,
> > > > > > +             struct kvm_gfn_range *range,
> > > > > > +             tdp_handler_t handler)
> > > > >
> > > > > Please burn all the Google3 from your brain, and code ;-)
> > > > 
> > > > I indented this way to avoid going past the 80 character limit. I've
> > > > adjusted it to be more like the other functions in this file.
> > > > 
> > > > Perhaps I should put `static __always_inline bool` on its own line?
> > > 
> > > Noooo. Do not wrap before the function name.  Linus has a nice explanation/rant
> > > on this[1].
> > 
> > IMHO, run clang-format on your stuff and just be happy with 99% of
> > what it spits out. Saves *so much time* and usually arguing..
> 
> Heh, nope, not bending on this one.  The time I spend far hunting for implementations
> because of wraps before the function name far exceeds the time it takes me to
> push back on these warts in review.

clangd solved that problem for me :)

Jason
