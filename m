Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BC5239E62
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 19:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753470994; cv=none; b=JzYtwI4+mdwG5mr7CFqOwK+LwOR/IZqnFMBx6bEVHqyLXhgG8PElRC3vMngYN1VVrf0/174SZe+5MacNLJKoUJl33IaF3NcPEUUbrbewA48sgIJljpz4tictWomNvHM/NoLRzWK4jx3knAX73dGsIHRXfvziCpeniiadCaDs+HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753470994; c=relaxed/simple;
	bh=t9FrhtQpYgn6vS+BcC1pt2nWbNWPMHh+SQZ1IZX19Zk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JdJKtfWvpH41N3PHml1dlCJ2wnnRXKyUOGtl92p80YPvEm3ItG5IqFLKLQtTYA1MI79wUlMn5/tZSMXe04zGHqfg+ZYfSmweZlMTfZCmCTQh4WbRFR34YzOuZTi7dj2htXzNFq1gxDVFbBM+zh3JiRAPnCfdceySza642Pmacw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GOMmJxZz; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GOMmJxZz"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-75e28bcec3bso3776695b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 12:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753470993; x=1754075793; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5WlSKTdQJz4BcWRlFGcWGmeAyhSggOtqFKeQJDFCZ8k=;
        b=GOMmJxZzCFccmacsZqtiVweyeYfk7aJR7dWw2vG4172JdsqDvfZ45uX4YUfYuitQsY
         isBv3+V1JJ31e53jXWTSDmWeJwBMIDESiTKMHjRdJKS4CxUTVOwuqJTzbaTnt7WlApNf
         pryT0+kOs1ORtvBPUzTgcmdQwqFSSom8Tk0dKHJQWnNzdJ44uyj5BGt+Urf2wTt/l1+y
         6z06Du7B2j5uaIs36QbIXQvK+E7+b+mdyADEEcHpQzmsphiWmVzoCfMrK1Jx5PtvSK45
         oC1DWh8aOiRoCwwr089VQH1g0z4SWl5dII5IUq8UlO+ighb4F+feYviLbcvhW8uBwOgO
         ZkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753470993; x=1754075793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WlSKTdQJz4BcWRlFGcWGmeAyhSggOtqFKeQJDFCZ8k=;
        b=W+L8MsX2/toAxTS5VQ/dYliOU2tABOTmyMh4eR/SqZ4a1AtneSWUqlXlgqiVwNh7/6
         ClQwBtr6kBHJeOaSERFZX76bOZv/m9z0UeJujrUZpAIGiFtCT6eOAe4HmefiWDeNwD/r
         AUHo6AI5OGrm4OmNCzEv8GqesFGUN34y4xqMmZD9kIU9EKFjyPaVbL2nIuJp7wjUQrF6
         fFkNaCBVbNSPAcrPTt/2uo7jZGz9ANBbQ91jrktHiMnzU/kPd4YAdexI9xcAl2E9vgV8
         wXIhGfjr5zK5t+tSJXtHMYEF2ryz+9VdyeSIh4Q1qsZW92ew+pZrniYe2Vh4I/yMsAKF
         oeBw==
X-Forwarded-Encrypted: i=1; AJvYcCWx8LldwyP9Kp3r3ab1knRa9rKrgvtPFcZ+5/sH42AvDzv94u/IlWhQQELumbYEnX91h2O7AMc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxV33POiIE06aaUeADpMXJn/IvaUK+LYwHTm3Agy4L3lpDJ5u7O
	wDdnBKXowqdVCtvJEy1sIjNa5sWRYFEc6HVCUHSwNnei8GlzQV5yleX9+MnCmsMfjydQoP0VZPX
	zZLDjkgD07crVB2cWcCtDzuqxnQ==
X-Google-Smtp-Source: AGHT+IG5yikix3DRNgEwYyvsz70LuAraxRVgFySsHgY92IzME9+2iJeI2z0Py1tuIkdALoYNsqefn1ymxFcNG6k/Uw==
X-Received: from pfbmd15.prod.google.com ([2002:a05:6a00:770f:b0:746:279c:7298])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:70c8:b0:21e:f2b5:30de with SMTP id adf61e73a8af0-23d700afbc9mr4649670637.12.1753470992563;
 Fri, 25 Jul 2025 12:16:32 -0700 (PDT)
Date: Fri, 25 Jul 2025 12:16:31 -0700
In-Reply-To: <aIO90h_oJsvyxR45@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com> <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
 <aIOVNcp7p2hU-YHM@google.com> <aIO90h_oJsvyxR45@google.com>
Message-ID: <diqzv7ngcc8g.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 25, 2025, Sean Christopherson wrote:
>> On Thu, Jul 24, 2025, Ackerley Tng wrote:
>> I also don't want to effectively speculatively add kvm_gmem_mapping_order() or
>> expand kvm_gmem_get_pfn(), e.g. to say "no create", so what if we just do this?
>> 
>> 	/* For faults, use the gmem information that was resolved earlier. */
>> 	if (fault) {
>> 		pfn = fault->pfn;
>> 		max_level = fault->max_level;
>> 	} else {
>> 		/* TODO: Call into guest_memfd once hugepages are supported. */
>
> Aha!  Even better, we can full on WARN:
>
> 		WARN_ONCE(1, "Get pfn+order from guest_memfd");
>
> Because guest_memfd doesn't yet support dirty logging:
>
> 	/* Dirty logging private memory is not currently supported. */
> 	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> 		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
>
> which kills off the kvm_mmu_recover_huge_pages() call from kvm_mmu_slot_apply_flags().
> And if KVM ever supports in-place recover for kvm_recover_nx_huge_pages() (which
> is doubtful given that mitigation shouldn't be required going forward), lack of
> hugepage support means any guest_memfd-based shadow page can't be a possible NX
> hugepage.

Thanks, this sounds good!
