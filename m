Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1582EF9B7
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 17:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753464278; cv=none; b=CyB/aqwEm9pxYnxo8B/5YSA6iG+F7UYYdQ6JyCSnB42ANLDUELUqaceIPgi4UoveW8slN1HaCEh7z5yOPsSnzcrg6K+v5R2u3roz0Sf+O+2PbRbbDItYLdTrZ2ATHZhpcmW0AsAnvNBhVHjNX2UGOTTranvteX3NpyGecD5Zg5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753464278; c=relaxed/simple;
	bh=J0guUM/h767F9xI8bVmCra3qNjsxNCxFgAUQKA7tg4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iY7LqGYBALg2fNsg+I26oHfs1G3uHB7lN0+Tc5JESvgwskY8PoQGA72Arq6LzWlmiiW5JyEqJkAcZrmP6ieqIAbdqFYJx++o3dlmQkWV1qDHQpR+hwVtkhqR4f8h2IKAFZUd4T2YVI5PKfMFRig3R3oIJEZVHzUwZpfeophvTmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=36Iz6Fsq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="36Iz6Fsq"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so2007003a91.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 10:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753464276; x=1754069076; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ouGvu65qiGg+JqadVNKAxhqDIWS7jmV1hkTAAApCoHU=;
        b=36Iz6Fsq+UlAND2eyFND7MkTkOopE7rj0YPZiq3aHKR5I51JU3icvnJ08Ujry81cxt
         BjN0hr5VD/w+mwIneE9N4ifnLHoSv+/XZunc2WNsBmfAP8qc5lcUf9f+IlHaXSjRQRir
         Cy/VGTlHbO2ef7TWjdQjpq3W6DIVYciCWfYSCVzuzEpLkCjKsQp9Yr82FakJMsSLoj0N
         ANSZen8pZQxALaA4qlgaFKIYyqV4dfCZoeDzBYZIdIIRlrP2eCyJIDU55FgdHnzuE92G
         1EVuMYVjQVCdkQ4ZvazXpi+8KEeSYiS3kXc5u5VpYHiizDH6JbqnujqTwjsckl4RLPkT
         9YAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753464276; x=1754069076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ouGvu65qiGg+JqadVNKAxhqDIWS7jmV1hkTAAApCoHU=;
        b=nZsA4Xo8P28GeuTdHrmn0NK7tN9werlM4YEYLjGpIG/sqtMeSqvCKJWbtmSjvnE0A3
         Q+efCKU4CAr5I1JJIB0Ynm8/lNgimjAOaWs2HYt+Nsg04T4R9Agv+Q/Ro7izbH90m/Y5
         oLDJ3c556xzcXtK/qCPxMDou7meRWnnUdzKcsDb/jDSMGm3h2g8HxrSxxkLPUJUT46gv
         drA9YyA6v8a4+xh24akNWoiGgeXmmp7qCxIvbyRTuKOOhEeU19aiNXp9Gzp5AZRgT9E/
         cj5jI8fbg9cRPOcu9k0eFSsvVXT1hDOBIG7idEdoc8mLirK9Y7TY7BUJkjYiLgrblvUf
         EsWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtcpPtcRjh5rUr3/3ofoTR3ZJXjdGXD5fAVisQgb+MK4+N1sNPQVEGyGK4H2I6kYhhMZE8reU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfrLzJMcIg5P8jPf9XLmHFQTT8S29/Y2MuPHl6J1rWpvGWCCI7
	ayAbcMIWPNWEImROYd2i5JR8WHA28a2JgbAsqVOIUmkN5tj/jxCXrwJasN7b/WD1j+8q9Z8alqW
	U8cww5A==
X-Google-Smtp-Source: AGHT+IHbAz/eKQpxYLnv3UzRDiNfzFQyWZ03GI8G+wp5sD4kBBYyUq+g8Y0WEpcjXQKRT5uv4bipYXGp6JQ=
X-Received: from pjbsf1.prod.google.com ([2002:a17:90b:51c1:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:514e:b0:312:25dd:1c86
 with SMTP id 98e67ed59e1d1-31e778f7879mr4767541a91.18.1753464276017; Fri, 25
 Jul 2025 10:24:36 -0700 (PDT)
Date: Fri, 25 Jul 2025 10:24:34 -0700
In-Reply-To: <aIOVNcp7p2hU-YHM@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com> <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
 <aIOVNcp7p2hU-YHM@google.com>
Message-ID: <aIO90h_oJsvyxR45@google.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 25, 2025, Sean Christopherson wrote:
> On Thu, Jul 24, 2025, Ackerley Tng wrote:
> I also don't want to effectively speculatively add kvm_gmem_mapping_order() or
> expand kvm_gmem_get_pfn(), e.g. to say "no create", so what if we just do this?
> 
> 	/* For faults, use the gmem information that was resolved earlier. */
> 	if (fault) {
> 		pfn = fault->pfn;
> 		max_level = fault->max_level;
> 	} else {
> 		/* TODO: Call into guest_memfd once hugepages are supported. */

Aha!  Even better, we can full on WARN:

		WARN_ONCE(1, "Get pfn+order from guest_memfd");

Because guest_memfd doesn't yet support dirty logging:

	/* Dirty logging private memory is not currently supported. */
	if (mem->flags & KVM_MEM_GUEST_MEMFD)
		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;

which kills off the kvm_mmu_recover_huge_pages() call from kvm_mmu_slot_apply_flags().
And if KVM ever supports in-place recover for kvm_recover_nx_huge_pages() (which
is doubtful given that mitigation shouldn't be required going forward), lack of
hugepage support means any guest_memfd-based shadow page can't be a possible NX
hugepage.
