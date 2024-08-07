Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27DD762DF
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723055178; cv=none; b=kbBnlKXvSPkidll0K8kS6QEqoVENintGseZBKw5TzGe96wbFsYeKQJrO5k6Be2/BLpYweMshXyfhfVfjLhRiDhGn5g1lXtN7Z3J0G/j5Lj3su4IQNaMjjm/bzqxhd5/6EoFKM6KOyzETPEcO0gVN2+oh9/u5HjmDvG6E4cEfXI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723055178; c=relaxed/simple;
	bh=LLEn5MDBQHmrgyVACBfMnS4xxjGfc9LgvIlsA65/wbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXhCMOG78TqhCtRSmROrtZWCzVyV+T5GdqjIUsIVTzbNaN4v8AhSoRMCJN3FXnFNgffhOKzUErW8ujf7MiTFwy7LLAzZn+8GUZvHuIwpRIFD1LTwTmKIWcCL8FTXWh9VadDjf0EbTgbadh/4pHpkrv8rUsHJh/6zzr8x0W1SQLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=YFTV2FQv; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="YFTV2FQv"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-260f863108fso103067fac.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 11:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1723055174; x=1723659974; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qIRgOrphujOZNK9+4f2LlAnWUepvShfv1Q6TgIqEiJY=;
        b=YFTV2FQvUEkZNXqiyk1VuBOcbU0DZzWOefYDguvuW8e1/wqO6QhxYUNV8QSO/rmf+k
         +ka6LUf0Ch1PWPP93+mNTr2x1tKXinJgf3eh1lUqm0794jIewGxZO9Te6pUzCU6xQLhW
         PCyK2oYs9r+hqLpYperFaqaHqtCeOMbDMl1/1m+UftzGdyRukl6MPXL8RPVZHnSaz44L
         boteV/KgrJqICVs8uUEeU02RbcPxvr7Vy9xym40wXH8Z0ODARqMGIefdXorfY5A00PBe
         b2PxGZwN2EaM9MSfrS76uKvlXvck6H/9n12TLhdaGOCzKjDlgmKM02S2+09dmNycmatu
         pcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723055174; x=1723659974;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qIRgOrphujOZNK9+4f2LlAnWUepvShfv1Q6TgIqEiJY=;
        b=a/e12B8pb9GM0k+tjY9jC6cvG3RBWNU/n3g+XBF5mZ6T4OeWR4aOAVHmhvDQVqoM/J
         gcfxg/sjd2j0GcGu9hxLJZABWm3iUvNXXHTlDyJCn/8YcBm2gnbupnabK/AsgtthFoQ3
         k3WawXmTudZRxbqE61k0vxOcE0yfQcjI/XzOwB9VxnxQ/35Z7Ahq9R2c5vc+SM5lWOCi
         v6knV3vlfODZsgT3fzPkH6QD7kYM+oIm0EVFSy6jQf/J+vgRWOntDa6FlhQ5ehvC/VFs
         8G4LjD3kGg0l/KrCMjLN7ZAzehyxTjKRzfpevzCglw8rl+DgG1kwY0Z/WONr0fqnwACs
         rLbw==
X-Forwarded-Encrypted: i=1; AJvYcCVBBqnqO7yK7ufGpSSgUMZKpcoXeoFFrQYXrZBVI9LS/v4vKpUXNzKaCcMUwmVjUfV4Fz52ijA9V4aK/QL58u+CfKLYMsvb
X-Gm-Message-State: AOJu0Yz/TKTbJG/Tk3gqMI+FL/SIDyZEL2djQTDo9KaqZsfhRJv3+7YM
	Rn9tO/peVPy+F9Dr3INxPdWyUPqy9APMyE74uG6ONf2pJ6IJFhi9jPwcTF3pxzw=
X-Google-Smtp-Source: AGHT+IF4dmL7QQFh54XoTTYzluGtiIHPWtm1r4ZnSMjpESeur6JHnnxQaalp3hZhfOljJo1uPFxdYA==
X-Received: by 2002:a05:6870:4693:b0:260:e6a6:396c with SMTP id 586e51a60fabf-26891d5aebfmr23740831fac.30.1723055173896;
        Wed, 07 Aug 2024 11:26:13 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.90])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3786bbcffsm82167785a.99.2024.08.07.11.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 11:26:13 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sblMR-003SUs-9y;
	Wed, 07 Aug 2024 15:26:11 -0300
Date: Wed, 7 Aug 2024 15:26:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@redhat.com>,
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
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 05/11] mm: Add fast_only bool to test_young and
 clear_young MMU notifiers
Message-ID: <20240807182611.GH8473@ziepe.ca>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-6-jthoughton@google.com>
 <37ae59f2-777a-4a58-ae58-4a20066364dd@redhat.com>
 <CADrL8HUmQWDc-75p=Z2KZzHkyWCCh8xnX=+ZXm5MZ-drALjKTA@mail.gmail.com>
 <20240806172349.GQ676757@ziepe.ca>
 <CADrL8HXFK=1cUS+0Z5k048U4rzpTNL634f57VtJ7TD_umrbNiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HXFK=1cUS+0Z5k048U4rzpTNL634f57VtJ7TD_umrbNiA@mail.gmail.com>

On Wed, Aug 07, 2024 at 08:02:26AM -0700, James Houghton wrote:
> On Tue, Aug 6, 2024 at 10:23 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Thu, Aug 01, 2024 at 04:13:40PM -0700, James Houghton wrote:
> > > --- a/include/linux/mmu_notifier.h
> > > +++ b/include/linux/mmu_notifier.h
> > > @@ -106,6 +106,18 @@ struct mmu_notifier_ops {
> > >          * clear_young is a lightweight version of clear_flush_young. Like the
> > >          * latter, it is supposed to test-and-clear the young/accessed bitflag
> > >          * in the secondary pte, but it may omit flushing the secondary tlb.
> > > +        *
> > > +        * The fast_only parameter indicates that this call should not block,
> > > +        * and this function should not cause other MMU notifier calls to
> > > +        * block. Usually this means that the implementation should be
> > > +        * lockless.
> > > +        *
> > > +        * When called with fast_only, this notifier will be a no-op unless
> > > +        * has_fast_aging is set on the struct mmu_notifier.
> >
> > If you add a has_fast_aging I wonder if it is better to introduce new
> > ops instead? The semantics are a bit easier to explain that way
> 
> v5 implemented these with a new op[1]. *Just* having the new op is
> kind of problematic -- we have yet another op to do something very
> similar to what already exists. We are left with two options:
> consolidate everything into a single notifier[2] or add a new
> parameter to test/clear_young()[3]. The latter, implemented in this
> v6, is somewhat simpler to implement (fewer LoC, reduces some
> duplication in KVM), though it does indeed make the explanation for
> test/clear_young() slightly more complex. I don't feel very strongly,
> but unless you do, I think I just ought to stick with how the v6 does
> it. :)

If it does makes the code simpler then it is probably the better choice

Jason
