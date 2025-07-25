Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937702D052
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 19:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753472077; cv=none; b=J2lHLuhB4pjkiWkHvcjcESXhLrFFz9LOE8bUCnjUpRaZL/EpViNxWo1lMS8lGulAY6VQ+AADAieFiZC5JTd223LYrHareBIBbRpNALRt6szFjX4m7oHFg1rQwqaxwLUqnMFG0WW0F6/ULtWQnrN9UgPgCeQLB1dqtkfNhf80u0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753472077; c=relaxed/simple;
	bh=YCSf2LFjWmxkPM80kmN2uNirM0gX9ysri+FUBUCzaU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TnpeUy4tWahMytjAZNxW80srH7PAOoMRJ6J0nj8Y6qjoBDJMFAZnL5l4urDP3cupu+qtm/ToMnHWs0akMow/ZEnQZ+1J1X7RscV2vJgFtiGFPg6tUQ1Q9SnuT0mRPwnIXZIKjX+K2uPD5mirwdNk9sGUij6X1DWcbjGADIq1xnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2DbwVopa; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2DbwVopa"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235e1d66fa6so24466095ad.0
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 12:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753472074; x=1754076874; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNIIO64ZvPt1HNs+swyYLqJ+PxWQ4jTBObewY8wp0+4=;
        b=2DbwVopao/IVdw2gsCsWa4TbZaPBCiMCzjfgCuwK8aTgjhdZvuu8pQREKNDb2UhkyQ
         y2C/j3ai6fOWb0dOijnSEFyKnmqOITOF3LUqk29QHipMSTbfSqnpbqbksttw78d+htGW
         SXifbjq1jsrEDpazu2LLeULLwim+Xya/ZpYf3o3AUoHP1LQjswI72mk7/BDH37cmmb15
         0i48Xi86xYSJGhEC5j6WXp7CetI5Affl1MjT0gNxpteW7gnxPRvKbNTmmOlFRJeC5A9s
         SKyqyGXwDZlg0KgAV1M99LGlZkD7QSzbBF1JevIoXCoaaBW9AfTnt/1zlglScNeWsbqS
         pTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753472074; x=1754076874;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FNIIO64ZvPt1HNs+swyYLqJ+PxWQ4jTBObewY8wp0+4=;
        b=aMjsOLq9dsF1edbfwYJfxlyhQr1hEg5HTSx8/ucrImh4zOPjKdF9BKLXfiOyYtls17
         ygfY9+oMCz3EVn+cCcBEqdWcJ1v36+Ep0+MtOKTrD7iXvO2cHTtdcJEiW2O3d4Jsn8Z9
         NsVIl+wZVQ09OPrtgiYcu8cv87GHPbw42IJrd3JJP7PQb/OtQ93QJLJ6lOlBp6sliD4i
         3KDhg1rbJvdRS80EG7TRgizSUvsedwHnRXatkG0qFuk8gJz0IEGFkTboJ5ynJnoefdKR
         B8b+OvLY1K0n9nUwH9UWxQYRIuUvf+Hc5Gfz2s5ojavDobMx0yjeEWqJRN9OybidAzKk
         NJgw==
X-Forwarded-Encrypted: i=1; AJvYcCUFFMHdzkn+iQCqw+KtTfVyR9dv0huKFs7OpHj3yJkki+QFLnrlvPtKdYeoBQy8a+zyIkLtocU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv0JLRz4qiIvZWoHCt+51D2cEXBdRc8Lcg6WI/q/O+jA1rNJbq
	1Gr7Vdwj3fRwTBNIUi6l7+dV08xBRYy4rvCS+Cgy/6DkNoO/NEgkt++5rx4K4JgtK/3euStHp91
	VC640T7zjaqEqTr76suTjOlU1Zw==
X-Google-Smtp-Source: AGHT+IGnEr3d6PZ3nIW41bH2DK3NPEY+F29AhLyvRFiA1YTCx5wX/C0Qtpn2kKuofqLWGxfCAZp6KUT5h5T5fvXdlg==
X-Received: from pjzz6.prod.google.com ([2002:a17:90b:58e6:b0:313:274d:3007])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:37ce:b0:2ee:d371:3227 with SMTP id 98e67ed59e1d1-31e77af4429mr5242184a91.17.1753472073748;
 Fri, 25 Jul 2025 12:34:33 -0700 (PDT)
Date: Fri, 25 Jul 2025 12:34:32 -0700
In-Reply-To: <aIO7PRBzpFqk8D13@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
Message-ID: <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 25, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>=20
>> > On Thu, Jul 24, 2025, Ackerley Tng wrote:
>> >> Fuad Tabba <tabba@google.com> writes:
>> >> >  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fau=
lt *fault,
>> >> > @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm=
, struct kvm_page_fault *fault,
>> >> >  	if (max_level =3D=3D PG_LEVEL_4K)
>> >> >  		return PG_LEVEL_4K;
>> >> > =20
>> >> > -	if (is_private)
>> >> > -		host_level =3D kvm_max_private_mapping_level(kvm, fault, slot, g=
fn);
>> >> > +	if (is_private || kvm_memslot_is_gmem_only(slot))
>> >> > +		host_level =3D kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
>> >> > +							is_private);
>> >> >  	else
>> >> >  		host_level =3D host_pfn_mapping_level(kvm, gfn, slot);
>> >>=20
>> >> No change required now, would like to point out that in this change
>> >> there's a bit of an assumption if kvm_memslot_is_gmem_only(), even fo=
r
>> >> shared pages, guest_memfd will be the only source of truth.
>> >
>> > It's not an assumption, it's a hard requirement.
>> >
>> >> This holds now because shared pages are always split to 4K, but if
>> >> shared pages become larger, might mapping in the host actually turn o=
ut
>> >> to be smaller?
>> >
>> > Yes, the host userspace mappens could be smaller, and supporting that =
scenario is
>> > very explicitly one of the design goals of guest_memfd.  From commit a=
7800aa80ea4
>> > ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing m=
emory"):
>> >
>> >  : A guest-first memory subsystem allows for optimizations and enhance=
ments
>> >  : that are kludgy or outright infeasible to implement/support in a ge=
neric
>> >  : memory subsystem.  With guest_memfd, guest protections and mapping =
sizes
>> >  : are fully decoupled from host userspace mappings.   E.g. KVM curren=
tly
>> >  : doesn't support mapping memory as writable in the guest without it =
also
>> >  : being writable in host userspace, as KVM's ABI uses VMA protections=
 to
>> >  : define the allow guest protection.  Userspace can fudge this by
>> >  : establishing two mappings, a writable mapping for the guest and rea=
dable
>> >  : one for itself, but that=E2=80=99s suboptimal on multiple fronts.
>> >  :=20
>> >  : Similarly, KVM currently requires the guest mapping size to be a st=
rict
>> >  : subset of the host userspace mapping size, e.g. KVM doesn=E2=80=99t=
 support
>> >  : creating a 1GiB guest mapping unless userspace also has a 1GiB gues=
t
>> >  : mapping.  Decoupling the mappings sizes would allow userspace to pr=
ecisely
>> >  : map only what is needed without impacting guest performance, e.g. t=
o
>> >  : harden against unintentional accesses to guest memory.
>>=20
>> Let me try to understand this better. If/when guest_memfd supports
>> larger folios for shared pages, and guest_memfd returns a 2M folio from
>> kvm_gmem_fault_shared(), can the mapping in host userspace turn out
>> to be 4K?
>
> It can be 2M, 4K, or none.
>
>> If that happens, should kvm_gmem_max_mapping_level() return 4K for a
>> memslot with kvm_memslot_is_gmem_only() =3D=3D true?
>
> No.
>
>> The above code would skip host_pfn_mapping_level() and return just what
>> guest_memfd reports, which is 2M.
>
> Yes.
>
>> Or do you mean that guest_memfd will be the source of truth in that it
>> must also know/control, in the above scenario, that the host mapping is
>> also 2M?
>
> No.  The userspace mapping, _if_ there is one, is completely irrelevant. =
 The
> entire point of guest_memfd is eliminate the requirement that memory be m=
apped
> into host userspace in order for that memory to be mapped into the guest.
>

If it's not mapped into the host at all, host_pfn_mapping_level() would
default to 4K and I think that's a safe default.

> Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out w=
rong, as
> KVM will not verify slot->userspace_addr actually points at the (same) gu=
est_memfd
> instance.
>

This is true too, that invoking host_pfn_mapping_level() could return
totally wrong information if slot->userspace_addr points somewhere else
completely.

What if slot->userspace_addr is set up to match the fd+offset in the
same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
actually mapped into the host at 4K?

A little out of my depth here, but would mappings being recovered to the
2M level be a problem?

For enforcement of shared/private-ness of memory, recovering the
mappings to the 2M level is okay since if some part had been private,
guest_memfd wouldn't have returned 2M.

As for alignment, if guest_memfd could return 2M to
kvm_gmem_max_mapping_level(), then userspace_addr would have been 2M
aligned, which would correctly permit mapping recovery to 2M, so that
sounds like it works too.

Maybe the right solution here is that since slot->userspace_addr need
not point at the same guest_memfd+offset configured in the memslot, when
guest_memfd responds to kvm_gmem_max_mapping_level(), it should check if
the requested GFN is mapped in host userspace, and if so, return the
smaller of the two mapping levels.

> To demonstrate, this must pass (and does once "KVM: x86/mmu: Handle guest=
 page
> faults for guest_memfd with shared memory" is added back).
>

Makes sense :)

[snip]
