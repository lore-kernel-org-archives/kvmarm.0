Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8074672634
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 21:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753479120; cv=none; b=tarAWkLukLfTErSwL3hdgP2RHToaGJACkO0rCawbMWgsggYieOn8nXPLcicdjsumL1u0aBwwdk6zlZN4j3iY6TfJom/WBrOBrYZYIpmPRNmwyeYHH8fAz4mGoPSquLi2rrdMm2vLkrUvTWuI3LcKV2RxToWcxqN3Ecb/EhM15lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753479120; c=relaxed/simple;
	bh=s8EYSRl4Upj9AAeXNTjEnXg/I8gOZCm1XU7aiYdvk28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cq68TwBv8cnwgcY9bfBiX51VZD53LfdTZM8htt3cSQrBgdstW0zFfO7z8Eov/IpKFKAW7NCD4Q++DJlinATlzmmjbfIxf8RkmaKG+BhJKy6aeSYMAF1OWicCn20n9v48OkWsJx2akXeLs+kxWe5Wzsi29HJTnpKcfIPMFsW7EgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vkubaZvx; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vkubaZvx"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74b29ee4f8bso2359741b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 14:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753479119; x=1754083919; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s/2wQleH7ITFpN7KmyE45uwJ+UkF1jVuCUBrc+xrmHs=;
        b=vkubaZvxc+NgzsuNXx2hu/8bMWjFE8ASqyQZWxPfROHtCC2NPDap3+ASiP60I/Hdbl
         33Iw8llCvR7ajQNuRthlpipxdzSkOruE3wxsdDuQCD90KPTh0pX5WrNwwJDMRA1LU7OW
         QuiwpkzAZeNNiVLnjCNtjAU+z/s3fPmklRiLSHpeSiYuuQthYj/Y0x0sqJJzZqIvaruY
         0i3RMVu5nkQ12miztThsJz9Tp4s3gVPXxvVq3sQOXKmAhPuB4IZNMRokUAKL00ABxfq1
         ukfnwL7cfZkHhticAKrgzGfKTuUHW1yZYt1SB3nN00+tuXRyRdr6YwAkkUyeR2O859uM
         hbFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753479119; x=1754083919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s/2wQleH7ITFpN7KmyE45uwJ+UkF1jVuCUBrc+xrmHs=;
        b=qcANMKKbRV2oaebdJt93zwL+B0tjWEJbyvMq7//lqzJh7Uu5woMsEvWgs0+X05wyC2
         rRRmVLU5krA5wQ2maarrnuyJmY/TKdmtdrpm3xQb4FYHSy1DmZtz4H0mySHLWmDvqSkF
         7+rAMVq/zRYcM2CMiZEr5xmLmocDGjOOM71ePDVxzQaakRjNNcOk/3NuHiuk7qEJtzwO
         tpGD63TCJPxGVKlx5nujPdKNbbqQJFS6AP3NzbizUZuoblOc4bQIHU6ctIdCO1u0cCLK
         0DxTNdRKSTwUUxqLt2kugdd64gvIMLmiVQ3JmXe6RiSYrDPPvbZ/lAjoWnJr7xOQJl0K
         X1vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYd9l4Ss0vrSHOzIvS1Wu8KuTRHssmDe8K3W/v04oIGU4WP4G53pX406cVJfXYjwsMDgeeuMk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHsdX64JlJIbfUpbeHJTqbvRWuDF30zGvhcDKvI06hQeHl5ym7
	Mi388vek1omaIbbCe1D+8oAjjOkVWdWLzI2hmgFjJ2fFn2qHn5rIxkJC5ulJphDYcxSqFQrygyY
	p14Iy/U6H9kS9Q24ekaSSWtFzVw==
X-Google-Smtp-Source: AGHT+IGesKxQTKVmzs1CWmOLMYF7g3871uG3DVQpvVnVgh0Q1qhmnR88/PeohzOlETvzSfBr5Eb7p3CMiXA/OH+/rw==
X-Received: from pfbfj4.prod.google.com ([2002:a05:6a00:3a04:b0:748:fa96:6db3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ac8:b0:74e:a9c0:9b5c with SMTP id d2e1a72fcca58-763358302abmr4894396b3a.13.1753479118583;
 Fri, 25 Jul 2025 14:31:58 -0700 (PDT)
Date: Fri, 25 Jul 2025 14:31:57 -0700
In-Reply-To: <aIPgjOLq8erW06gK@google.com>
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
Message-ID: <diqzpldoc5yq.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 25, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
>> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
>> > instance.
>> >
>> 
>> This is true too, that invoking host_pfn_mapping_level() could return
>> totally wrong information if slot->userspace_addr points somewhere else
>> completely.
>> 
>> What if slot->userspace_addr is set up to match the fd+offset in the
>> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
>> actually mapped into the host at 4K?
>> 
>> A little out of my depth here, but would mappings being recovered to the
>> 2M level be a problem?
>
> No, because again, by design, the host userspace mapping has _zero_ influence on
> the guest mapping.
>

Not trying to solve any problem but mostly trying to understand mapping
levels better.

Before guest_memfd, why does kvm_mmu_max_mapping_level() need to do
host_pfn_mapping_level()?

Was it about THP folios?

>> For enforcement of shared/private-ness of memory, recovering the
>> mappings to the 2M level is okay since if some part had been private,
>> guest_memfd wouldn't have returned 2M.
>> 
>> As for alignment, if guest_memfd could return 2M to
>> kvm_gmem_max_mapping_level(), then userspace_addr would have been 2M
>> aligned, which would correctly permit mapping recovery to 2M, so that
>> sounds like it works too.
>> 
>> Maybe the right solution here is that since slot->userspace_addr need
>> not point at the same guest_memfd+offset configured in the memslot, when
>> guest_memfd responds to kvm_gmem_max_mapping_level(), it should check if
>> the requested GFN is mapped in host userspace, and if so, return the
>> smaller of the two mapping levels.
>
> NAK.
>
> I don't understand what problem you're trying to solve, at all.  Setting aside
> guest_memfd for the moment, GFN=>HVA mappings are 100% userspace controlled, via
> memslots.  If userspace is accessing guest memory, it is userspace's responsibility
> to ensure it's accessing the _right_ guest memory.
>
> That doesn't change in any way for guest_memfd.  It is still userspace's
> responsibility to ensure any accesses to guest memory through an HVA access the
> correct GFN.
>
> But for guest_memfd guest mappings, the HVA is irrelevant, period.  The only reason
> we aren't going to kill off slot->userspace_addr entirely is so that _KVM_ accesses
> to guest memory Just Work, without any meaningful changes to (a well-behaved)
> userspace.
>
> For CoCo VMs (including pKVM), guest_memfd needs to ensure it doesn't create a
> hugepage that contains mixed memory, e.g. must not create a 2MiB userspace mapping
> if the 2MiB range contains private memory.  But that is simply a sub-case of the
> generate requirement that untrusted entities don't have access to private memory,
> and that KVM doesn't induce memory corruption due to mapping memory as both shared
> and private. 
