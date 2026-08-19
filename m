Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC64476CF2
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787149685; cv=none; b=T6j7ZX5zRRIAIK+6XNBBKanuxNm2wXBHo5H5tlW6RkXsAefho2bVPaeo/bGd+TiCJtdOoaLxLgx0gtT5JwqK19gzPVZRDTCrg28xYidAF2Z1Ku5wspBuNAmZkoD1mkXjnpYK/RMUT7Nnr2HnST4dZ7q/4mV2X/pNk0G5QLW/Awo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787149685; c=relaxed/simple;
	bh=HeVS9XsCAoIM35TlkEqB62UzYjPlpdl4VrCCpvJjbC0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WxWjNxDyMlTObzyx6c0udGEkXA25imacg+6jupd0C9D37a0DgOtnbMvZhOfD6if+skT6EmNdJs9tr0ZxwNTaify/sLdn36e4rJdo70ula9DDwAsmM07F3Gi3JMXI16oReBb1hNtLejsGWR4xnzv4zOftPzM1wEZUlH4yyjPac60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gfXeEgpc; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gfXeEgpc"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ccb6823efcso9634755ad.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 07:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787149671; x=1787754471; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NVWozadQO7xAVs0CxEChlrBPcTWGOFFwMoQqLAdxyTc=;
        b=gfXeEgpchYUBpQ5luyPJvu8v+m99DETJC/1hXkr0k8AA0YTlgNQZSRdZf8hhDGQ08E
         Vv+jVbPFUntJksyrJU/oCxv2gf1gakLTqpxxRgCkR5oZEpNa+LXn+CKIgfIgZS2ScWL6
         jH/o8NypCbdxymXmQLglmtp58GSQqk5xxYmk3Ib60uu9kygeL44YLi3sDESGKU58wuW8
         BXIWPuhF963oexBLFsBhyiqgFcitNhvV6pHyz3bn3eCxhoT4kB+vP0ce/lVD0e0rdxN9
         MXPh7xCr4bHHkbgrgCwSKfNU6HJZkt4b/dCToO/AOG7BU3J9xoTc6Pgfk5c9EDm7ksd5
         RzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787149671; x=1787754471;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NVWozadQO7xAVs0CxEChlrBPcTWGOFFwMoQqLAdxyTc=;
        b=eBF3yANlvwmP0U5z6+FIOcmwHN0fABXmVZw2mRrnz+t2B97lxG9h2n3w6py75wlmfh
         jjsrDZ+aHcRbmrhT8A5XjIFB4jL8KY8T0Q2WlfjeRY+T3zFaPpTJnqslvmIDdFDEj3td
         n80nHL7VzOq6qeSi0zJ48SI1dZtpqcBigJZ/jMw2rnKkV8pSFjduWtxa7aBkDRFmMXEH
         IGnPIndhDKxLuaO0AtBeX7b93a9jFjfaB+mT0eDVwo7WCnX5MAqJAc7bY4MmDjMcKfUj
         OV6dHiBeBCeoMiRw84+xd83GoWznfCPaheCN+K63DS53Lfwc8L69TfemDxRpE92qjK3b
         /F+Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqa3EB1B+9kZUAZaoCKcPPvmhotANqG5zfd0nKTaybmKlvm3+wZN8LWYroUY1IcwarFUppe8XE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxENq5Y1LzVL1kHkgGmR85vy8sFm0mms4gJzPrki4LTueS4I+R2
	W5fSiSEpAokwQEf8eTxg9wcdSUX5CCjYD/2I3sCajDzuYZVyrnNx3TTjq4usKjHUUz39uz7Adhm
	GDGniOA==
X-Received: from plos6.prod.google.com ([2002:a17:903:1ac6:b0:2ca:ddbd:a19c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f792:b0:2d3:6fac:d67c
 with SMTP id d9443c01a7336-2d5ff7c849dmr91033865ad.10.1787149671281; Wed, 19
 Aug 2026 07:27:51 -0700 (PDT)
Date: Wed, 19 Aug 2026 07:27:50 -0700
In-Reply-To: <7c368424-80f9-4491-8578-d26ccc7dc835@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <807b4b9f-b1ca-4b5c-bc9e-22bf0637ba33@kernel.org> <aoS4wd6Dy9DlluHl@google.com>
 <7c368424-80f9-4491-8578-d26ccc7dc835@kernel.org>
Message-ID: <aoW9ZhBWucR3HApp@google.com>
Subject: Re: [PATCH v2 0/4] Stop returning struct page from guest_memfd PFN lookup
From: Sean Christopherson <seanjc@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, g@google.com
Cc: Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 19, 2026, David Hildenbrand (Arm) wrote:
> On 8/18/26 21:55, Sean Christopherson wrote:
> > On Tue, Aug 18, 2026, David Hildenbrand (Arm) wrote:
> >> On 8/18/26 11:15, Ackerley Tng wrote:
> >>> KVM currently expects kvm_gmem_get_pfn() to return a refcounted struct
> >>> page. Callers (such as x86 TDP MMU, arm64 Stage-2 fault handler, and SEV-SNP
> >>> VMSA / RMP handlers) hold this refcount across page fault handling.
> >>>
> >>> Holding a page refcount across fault handling is problematic for guest_memfd.
> >>> In-place memory conversions between confidential computing shared and private
> >>> states inspect folio refcounts to ensure exclusive ownership by guest_memfd.  A
> >>> concurrent guest page fault taking a reference on the folio causes conversions
> >>> to fail due to an elevated refcount.
> >>
> >> Right. Won't we still, at least temporarily, grab a reference while looking up
> >> the folio in the page cache, or will we be preventing that concurrent race with
> >> locking?
> > 
> > The latter.  What I want to aim for is that if the relevant guest_memfd range
> > has never been mmap()'d and there are no memory failures, then conversion is
> > guaranteed to not fail due to elevated refcounts.
> > 
> > Or to put it a different way, I want KVM's ABI to be that pausing vCPU is *NOT*
> > required to perform an in-place conversion.
> 
> Having the VM access a page that is currently under conversion (triggered by the
> VM) should not be the common case, no? Except, prefaulting, of course.

"not be the common case" is likely an understatement.  In practice, I don't it
will happen outside of guest bugs and KVM testcases.

It's the testcases that I want to "unblock" though.  If we commit to never having
to pause vCPUs, even if the guest is misbehaving, then that gives us deterministic
behavior we can validate, i.e. a way to detect similar regressions in the future.

I don't expect any regressions would be super problematic, but being able to treat
any failed conversion as a KVM bug (for the curated setup) mitigates the risk of
death by a thousand cuts, i.e. reduces the risk of gradually degrading conversion
performance because more and more transient references being taken by KVM.
