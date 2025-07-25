Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9621F541E
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 22:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753480877; cv=none; b=EWs9hTMFIoULP55O/2DWgvmQeelU+Y6gVSRH+L7p6Ne+Th8jl0OSHF0zTbPs3tkoqqodNCzGOfwkLtfnEMu4GZ6UHChISyqvwNIl3AxQI8NSd1ONfKNhpRozxk6hCvg0nCRp7XiV7gFlY9hEDZ+PDi1U9AK/Oo5SKx43GTmaUcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753480877; c=relaxed/simple;
	bh=ZVkE0eW5WS3kJhFfMGAaiYj5nZ5KOR05VaGSZwLtIr8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OKe24LMd7cNlszmFWW+lzQts2VmSSO3Qu+awB9eIWK82tAwCJYgvKRbQMbmzIHx1DIIUFLMlE5dS2TREqkKlFG2XBeAwBoEAJZvXqYEew2qHLokxcaVRqMIlh8tchiYpBQoMRvATyWy17/cg0rmMmgOa878/NBmGuE4PxVHw/80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x8+YLSXD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x8+YLSXD"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313ff01d2a6so2692599a91.3
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 15:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753480875; x=1754085675; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+zp+aFgZ7sosVHgE1JVBc/YF4k2nO+/CVzJ2Y2OlSXk=;
        b=x8+YLSXDGhcFfHuKX4PbkjNY542cyY83KhtJuwBJ8u6swbSH4Li/ASd8LbyiDAZK+y
         IpH3XBLIkAAGZrf0xUsDelq6wcMqDtjEo6tUXbLQaMuptrFZQrwuCzhKGrvW4n+Ik+43
         3C/4w22/BPx5MH9PiBVKd30S9q4dsdAnSgUj21lDA6l6v9IHcCiVexdqBZFuNZWm4kwy
         InpWJb4rFywVL987fTq866HiR3f+3bEBKe3FojjlJIUi1QDBtSDJuOYCTls6dZJwTBw9
         +ACaCxa6bCffkj4MvincrechmUQReD+Uy7tXFGt+LKOBIbZxUrKW2nQF0H1lLW/YHZBp
         ASaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753480875; x=1754085675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+zp+aFgZ7sosVHgE1JVBc/YF4k2nO+/CVzJ2Y2OlSXk=;
        b=G8Y7w9zK0YYJwbDKj7anndT9mZTbEpDgGZ6LksIomkKrkhGMiXomJ+6agbyRL6GlDv
         tsUYwelhFimb+uc5usZXj5klFvdJ4YQwm6XjcOLM6d5KE852hWZ1XC1fQhquk4hTuVeU
         LmkPkvl4FPNS95A0C9IdKL1EnnBwUT8plr1M9NE6jPQ7g8ABYCmWZ/NinsiXyVJCn9fn
         IEXMpKlZy6c4bv/Nsld122qKuhSsuj+dh1NSwFIq5nIdZHN25flFn6uPVpj2mn9W9tw8
         uN1vMI5UpOxJripXi5aTColbcy3Ubp/PwdF2ZQKc+dDGjlcjjkJpdPYA+GjZzEf5xWSk
         pr1A==
X-Forwarded-Encrypted: i=1; AJvYcCWd1Dd+RZLF7f20prY/9AYjKQYNQyezAMKAZyn3h8s8gjVfBgYMpGVdrDD+//W+RDAw4I7if4Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyl7FXo/Lo87Gyohk3nWSqr6XgsR10pVi1L8isMuRmnSMpZCTi3
	YqNqdssfJR/y3LWT1WISJ7dg0Vf6omMY0R2O7KlM8ikVKgjG6YCZjUfyx2QTiR9Q8QJXpMPiYXf
	o9HLvVQ==
X-Google-Smtp-Source: AGHT+IFPjkF2xrZ/Gp6FwQl6jvIg14serRXFzYz5L/ExU8zpV9XgePnP6vcF1X9qmhlTmOaX+wV3Tt+ZntY=
X-Received: from pjvf3.prod.google.com ([2002:a17:90a:da83:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c7:b0:31c:15d9:8aa
 with SMTP id 98e67ed59e1d1-31e77a45647mr3874947a91.34.1753480875031; Fri, 25
 Jul 2025 15:01:15 -0700 (PDT)
Date: Fri, 25 Jul 2025 15:01:13 -0700
In-Reply-To: <diqzpldoc5yq.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
 <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com> <aIPgjOLq8erW06gK@google.com>
 <diqzpldoc5yq.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIP-qSnH1jjuykmP@google.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
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

On Fri, Jul 25, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Fri, Jul 25, 2025, Ackerley Tng wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
> >> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
> >> > instance.
> >> >
> >> 
> >> This is true too, that invoking host_pfn_mapping_level() could return
> >> totally wrong information if slot->userspace_addr points somewhere else
> >> completely.
> >> 
> >> What if slot->userspace_addr is set up to match the fd+offset in the
> >> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
> >> actually mapped into the host at 4K?
> >> 
> >> A little out of my depth here, but would mappings being recovered to the
> >> 2M level be a problem?
> >
> > No, because again, by design, the host userspace mapping has _zero_ influence on
> > the guest mapping.
> 
> Not trying to solve any problem but mostly trying to understand mapping
> levels better.
> 
> Before guest_memfd, why does kvm_mmu_max_mapping_level() need to do
> host_pfn_mapping_level()?
> 
> Was it about THP folios?

And HugeTLB, and Device DAX, and probably at least one other type of backing at
this point.

Without guest_memfd, guest mappings are a strict subset of the host userspace
mappings for the associated address space (i.e. process) (ignoring that the guest
and host mappings are separate page tables).

When mapping memory into the guest, KVM manages a Secondary MMU (in mmu_notifier
parlance), where the Primary MMU is managed by mm/, and is for all intents and
purposes synonymous with the address space of the userspace VMM.

To get a pfn to insert into the Secondary MMU's PTEs (SPTE, which was originally
"shadow PTEs", but has been retrofitted to "secondary PTEs" so that it's not an
outright lie when using stage-2 page tables), the pfn *must* be faulted into and
mapped in the Primary MMU.  I.e. under no circumstance can a SPTE point at memory
that isn't mapped into the Primary MMU.

Side note, except for VM_EXEC, protections for Secondary MMU mappings must also
be a strict subset of the Primary MMU's mappings.  E.g. KVM can't create a
WRITABLE SPTE if the userspace VMA is read-only.  EXEC protections are exempt,
so that guest memory doesn't have to be mapped executable in the VMM, which would
basically make the VMM a CVE factory :-)

All of that holds true for hugepages as well, because that rule is just a special
case of the general rule that all memory must be first mapped into the Primary
MMU.  Rather than query the backing store's allowed page size, KVM x86 simply
looks at the Primary MMU's userspace page tables.  Originally, KVM _did_ query
the VMA directly for HugeTLB, but when things like DAX came along, we realized
that poking into backing stores directly was going to be a maintenance nightmare.

So instead, KVM was reworked to peek at the userspace page tables for everything,
and knock wood, that approach has Just Worked for all backing stores.

Which actually highlights the brilliance of having KVM be a Secondary MMU that's
fully subordinate to the Primary MMU.  Modulo some terrible logic with respect to
VM_PFNMAP and "struct page" that has now been fixed, literally anything that can
be mapped into the VMM can be mapped into a KVM guest, without KVM needing to
know *anything* about the underlying memory.

Jumping back to guest_memfd, the main principle of guest_memfd is that it allows
_KVM_ to be the Primary MMU (mm/ is now becoming another "primary" MMU, but I
would call KVM 1a and mm/ 1b).  Instead of the VMM's address space and page
tables being the source of truth, guest_memfd is the source of truth.  And that's
why I'm so adamant that host_pfn_mapping_level() is completely out of scope for
guest_memfd; that API _only_ makes sense when KVM is operating as a Seconary MMU.
