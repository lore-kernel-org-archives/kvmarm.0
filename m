Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3E524DCE2
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 19:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753473168; cv=none; b=kfbwJB5HsEa5EJfKo+1soLHUNobUuvgPOmMUDjL98UXVmslcV3rVsxX8veSTpK+sX3CfbS0DTP3DDw/i8zLw3/4HmEdrAm4ExyVGbVl2iLEDzoDoP+1A9NmliXISsnvaZFeuXG3MIqfDjoM1x+EJ4LjRBUB6xtYx+40saMOUZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753473168; c=relaxed/simple;
	bh=D/BxQwI45NEctT9RKmkNXq7H6TV6FVvhywdeOEV7K08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dRAeb6g4WADIYUQKs6cQD6kU/ZEU0Ogo4omNF3U33zvsWi7l6mcLmyNV5d+EK92aVXGx9aFBg4OoHNIpqsZ4S9Ytnux8j8MgxCxkviWqfET1QSFqMNnJb/Ntb3lsR+QP7e/WYLM9qbPmAAcr8gI9Zf0V32rEOv4aClC8uHEtWYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=khACBVwB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="khACBVwB"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23dc7d3e708so17937755ad.3
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 12:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753473166; x=1754077966; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QGGwHKzNdqzja55fvEizh1HPckulPqbm51MIc4WTZ8o=;
        b=khACBVwBQiJdboVoJNE/cJSUNDtetRKfDU1xQj60H/ds+79vA308NFPi2L0tLHIPiZ
         y7KcjbM5VsEQoHz5YKDu1h+F/a3x9ciaGvwtNYz6JiL3RomyolBLrl6b6RF/+UpxDC/C
         eAAVwuuQ8u8ZdnWqbxSdbURJTHApdYnVuKwzRGn5p9veiZu8nZHm3H9BhgM0EbfQeFoU
         mnqVGsZcuqOcYyr90nYq5J0BUwht9ccv2ATYUoLsUWOaD7Tc2p7Axjf7/tl+J9O3dk2O
         KAooZakcBiIOQAxefoHG50KqVG95EdtHD7Cl2IqLV0Bd+RY665jnnsWsqSVWpMJnHSmg
         s5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753473166; x=1754077966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QGGwHKzNdqzja55fvEizh1HPckulPqbm51MIc4WTZ8o=;
        b=ALJNa2+omc4Z/doh6PptBMlY7/yVQ3WHpw49y5j9FYpXcO5GV/9SHMx6t2nCMiAqyI
         fyuOOf25cNCgHxKEikmOOaGw3RHSBi7KOo7DAAWYTTKMnkjW7gnpWwIO2wTrddkDMtqz
         IuJ/Ag3N5HLslc8+nDaQoOziB1uJnWCGFeVYU78pHXhlfSIRQ923lfDhhNEqk4Mv+YCT
         Pnm+BbZIISJ67aWXrU9UK/aN4oDaEtwZQXzkFG3FZ8v737XOJ5bOxhFYCo7WH7ng7KWV
         tPNqXvX6xXQJyMnBLRVVvJ7iH170Af7wvhrPzF71fCOQpFBcnRPmnFZTSgktI3Fw+dg1
         5U+A==
X-Forwarded-Encrypted: i=1; AJvYcCWRMol6A9sP49eQF5r8fIzrqBb/+XIYZQwiVKym7A8dO7DwiqbMVBClT6yVD7sejC9xXYTUhKQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxO5/bH3wH94Yp7U1IEKytgItwPNkBXopy99i1pYMRYimEFsLVN
	NH/GPxu/vx8L7fSRLmjLW/9ZSwImyVYyE49ph35z7rwXto887j7PxwlL0KGnnLvQ+wSGAvZk09f
	yaJXK0Q==
X-Google-Smtp-Source: AGHT+IGKfp2ZEdZFD4nXV8opXXNSrJNr2MwInumKeRrkZ/nbSrnkah7OjJY3KrZp8KeOnG/KWd4mQPv9Jxk=
X-Received: from pjbqd15.prod.google.com ([2002:a17:90b:3ccf:b0:314:d44:4108])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d414:b0:23f:b4c4:710c
 with SMTP id d9443c01a7336-23fb4c4730amr32702405ad.38.1753473165998; Fri, 25
 Jul 2025 12:52:45 -0700 (PDT)
Date: Fri, 25 Jul 2025 12:52:44 -0700
In-Reply-To: <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
 <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIPgjOLq8erW06gK@google.com>
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
> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
> > instance.
> >
> 
> This is true too, that invoking host_pfn_mapping_level() could return
> totally wrong information if slot->userspace_addr points somewhere else
> completely.
> 
> What if slot->userspace_addr is set up to match the fd+offset in the
> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
> actually mapped into the host at 4K?
> 
> A little out of my depth here, but would mappings being recovered to the
> 2M level be a problem?

No, because again, by design, the host userspace mapping has _zero_ influence on
the guest mapping.

> For enforcement of shared/private-ness of memory, recovering the
> mappings to the 2M level is okay since if some part had been private,
> guest_memfd wouldn't have returned 2M.
> 
> As for alignment, if guest_memfd could return 2M to
> kvm_gmem_max_mapping_level(), then userspace_addr would have been 2M
> aligned, which would correctly permit mapping recovery to 2M, so that
> sounds like it works too.
> 
> Maybe the right solution here is that since slot->userspace_addr need
> not point at the same guest_memfd+offset configured in the memslot, when
> guest_memfd responds to kvm_gmem_max_mapping_level(), it should check if
> the requested GFN is mapped in host userspace, and if so, return the
> smaller of the two mapping levels.

NAK.

I don't understand what problem you're trying to solve, at all.  Setting aside
guest_memfd for the moment, GFN=>HVA mappings are 100% userspace controlled, via
memslots.  If userspace is accessing guest memory, it is userspace's responsibility
to ensure it's accessing the _right_ guest memory.

That doesn't change in any way for guest_memfd.  It is still userspace's
responsibility to ensure any accesses to guest memory through an HVA access the
correct GFN.

But for guest_memfd guest mappings, the HVA is irrelevant, period.  The only reason
we aren't going to kill off slot->userspace_addr entirely is so that _KVM_ accesses
to guest memory Just Work, without any meaningful changes to (a well-behaved)
userspace.

For CoCo VMs (including pKVM), guest_memfd needs to ensure it doesn't create a
hugepage that contains mixed memory, e.g. must not create a 2MiB userspace mapping
if the 2MiB range contains private memory.  But that is simply a sub-case of the
generate requirement that untrusted entities don't have access to private memory,
and that KVM doesn't induce memory corruption due to mapping memory as both shared
and private. 
