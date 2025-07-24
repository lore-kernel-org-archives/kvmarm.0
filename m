Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3848923BCEE
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 22:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753397089; cv=none; b=cTi3N8muth6USjGPTr9EiF5nFhgYPOb+TS8ruI7nsVRd7z9cq6Nkucqn/cygG3wMp2+c3dNGSPWicnxp0vxIcvOQSyTONZuBsD8j+pkmNOYNHPtVd+s3k+S8g0tHIbZc0qR5NPIyYtEajp5sb2W3T8UmXuOZj7DW9Jh5GqaF0CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753397089; c=relaxed/simple;
	bh=6azhUsHsH58e3lEd1I2Fl0REPpv57pMkQWJrp2kPK/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EfpgkmfwICXuQ3mBjmR3UEVvWS4Cr9qaF6oAh2ixlI8wc7CKdwM+/ZhL5PBKENSyjqM1JyhqF3HdEIDvsAXupP6Z6kH8INNJ2W2Ew13AzutfzYnMeHZezRA0qj9jkOlpw4n0XgiVz1Ts6/Jtlt+z+BWi9gVEDREfgVaowqxRK8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vQYgWuwR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vQYgWuwR"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31218e2d5b0so2244182a91.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 15:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753397087; x=1754001887; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BrK1nEYl8f9oxCi1PiXZSrMC6WHPAwC1TRayidWzx6U=;
        b=vQYgWuwRtOsqB/Vzi7pKGJ+YRrkaFn0VLtp28v3yyW3O8Yth4ieJdzor2u0cuxCB8a
         NrBINgdX+L7SS92JDA+xnxRWZ0w2wbg3cj8Cgl64pGVbUqcR6ShO8ssatBtRUlAKSQb7
         xEXHRSVfSWVDyx+FwGMWszrgcahnfB+yH7PrbrkyF65aB3RMZRJnbqU91s7j6Apu0pbd
         nzijgGYLd2O/9XlGt3AlQj6RniXxXFGaqsGYYqLJ6pJ8/DGCZ5PCELVcJ8+FjzLBiZh+
         v1PsE+aJUyZWjp5kaKr7lKC3A7hmPn8SWb+xXnmRKe/GDEZVyIeDxOrXCTdJxPCIOagV
         5j9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753397087; x=1754001887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrK1nEYl8f9oxCi1PiXZSrMC6WHPAwC1TRayidWzx6U=;
        b=sF8732LYWI42/EgW6XhvQG9YSTIBv3kYU4XLnJxMwAJXbDWmy1tyWynezXL8QdSpl+
         ardmYXuwMHlM+e9fEk/ukuvpm8pikiOsMg31U2YWOKPUA7ejMBc6QeUD0i6TYtwAE5z6
         yXQeukoIF3V7wgRgQpmAgIME74PkG9fsIP2TqVesFRroVe0gLPRIfWWYrWv1OG7a53S6
         wT9mht0uC8UFaEc9+/vL5+YT/A34nXxhht/SMk8bMfulDuCR5tAJajSXn5yDmn1aESZi
         cO1AR2GOJ3TdqvDyYil8J69JDEtk6cV55oQ/e6eazabQHlJJTsAn7GB8X9OQVmPt7+yF
         CJLw==
X-Forwarded-Encrypted: i=1; AJvYcCUIccLkk1Wv/CrUw6TFFJMeof2f7vfLBrxT2FZQYuPmNlk9KA9TcDNPWyT3D3PgTCo2hux/2p0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yws1UtC2XFAWnQIPqW5W8bBwD0H9AyAK+cULRCC1aOKfwV3M9ya
	PJM4Sf1tzy2ZvkcUYMfytAmIZ2m39ja8YjakJRnJ4kVm9tVxvpM7cOw6CfExTj4kOfeOKoJ7wTU
	BnF46cg==
X-Google-Smtp-Source: AGHT+IGkiU3HYlKz/oDr9suUmMNrF5QXoOj0MoEs/x9E0W6ja+0hEb122R/Wpx0j3kxF2BD1pc55AGtEMgQ=
X-Received: from pjz5.prod.google.com ([2002:a17:90b:56c5:b0:31c:4c97:bf9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3809:b0:31e:4e36:bfcf
 with SMTP id 98e67ed59e1d1-31e507e729bmr10178567a91.30.1753397087358; Thu, 24
 Jul 2025 15:44:47 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:44:45 -0700
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
Message-ID: <aIK3XQ6rGEo4cQ4V@google.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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

On Wed, Jul 23, 2025, Fuad Tabba wrote:
> Ackerley Tng (1):
>   KVM: x86/mmu: Rename .private_max_mapping_level() to
>     .gmem_max_mapping_level()
> 
> Fuad Tabba (15):
>   KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GUEST_MEMFD
>   KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
>     CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>   KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
>   KVM: Fix comments that refer to slots_lock
>   KVM: Fix comment that refers to kvm uapi header path
>   KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
>   KVM: guest_memfd: Add plumbing to host to map guest_memfd pages
>   KVM: guest_memfd: Track guest_memfd mmap support in memslot
>   KVM: arm64: Refactor user_mem_abort()
>   KVM: arm64: Handle guest_memfd-backed guest page faults
>   KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
>   KVM: arm64: Enable support for guest_memfd backed memory
>   KVM: Allow and advertise support for host mmap() on guest_memfd files
>   KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
>   KVM: selftests: guest_memfd mmap() test when mmap is supported
> 
> Sean Christopherson (6):
>   KVM: x86: Have all vendor neutral sub-configs depend on KVM_X86, not
>     just KVM
>   KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly from
>     KVM_SW_PROTECTED_VM
>   KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies iff
>     CONFIG_KVM_INTEL_TDX=y
>   KVM: x86/mmu: Hoist guest_memfd max level/order helpers "up" in mmu.c
>   KVM: x86/mmu: Enforce guest_memfd's max order when recovering
>     hugepages
>   KVM: x86/mmu: Extend guest_memfd's max mapping level to shared
>     mappings

AFAICT, I've run out of things to complain about. :-D

I say wait one more day just in case the peanut gallery comes alive, then spin a
hopefully-final v17 early next week.  Or holler if you want me to tidy things up
and send v17, most of the goofs that necessitate v17 are mine :-)
