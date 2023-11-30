Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5DB4CB41
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 02:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="skm/gwk3"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ca2a6f07b6so8070657b3.2
        for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 18:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701309730; x=1701914530; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p5qGWsyuSpyUxVCjDr7Vtr3DU5QXEtFZRiCX/LhUA7Q=;
        b=skm/gwk3XUw/H5xoqSviVKmD3TnyuI1Hs+sG+eg+SE6OxgzXFOR41qECfD28s9QChg
         4e6c5Fkf9cuIims/NJkpXhonUG3Uqk8ygJBf6yJu92BfVWhsNmNX7Z0XAKZdg7MapbQB
         zYi0Af8ooETm+MtcJbX7MsDS3A9/YhTvTaq/dUT5evqo5uuNaBhFJ8QkILuqWXJHcq2x
         j41f86mm6KZ95WSnT51PLXQQOtPkt012/2EBG2H3XJ1oVMn10zrZxfSN10e9HY5Dddtx
         vIXAqutW65K+8lN4Q0sU1/FqRf+lz/vld6VlhuJki9+WATbAisV+1dxrmM5JxtSghp0e
         b9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701309730; x=1701914530;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p5qGWsyuSpyUxVCjDr7Vtr3DU5QXEtFZRiCX/LhUA7Q=;
        b=Lfpwbb8XMbuUSKvuy6IHR02mRlivNRMsylzBTHTEj5XhioRSRlNFynC+CtxShXXPUz
         wYsY8DNpxFI5SHmuLZom0WzgB+OT6V+CP5cF5BmMT+wswUCViY/V4GkCsg3BxDMx8LmI
         Z83qRqr5fF/hgq4WkHoupy5tY3x0k9UDgYrgCn7ZLrsd5JLxlUnm0wd0zEwzithtm5rp
         R2m+yTsrLobS/iYQXOSUdI7Uh2xytjaiwmIUcScVM/UL97g/92v2WlUVdQYvuspX/x8x
         uGlIvV2Ls+69rEfnrlPrSv7r/+GOR25Ysl+EXFmrBZqnQPVzIfLJYn5zLodAKBnF0bKO
         thzA==
X-Gm-Message-State: AOJu0YyS9lZXK6gij7PY9s6EJ6eNfWFaL5Vathg+eWe0Aorg4vTgj8NT
	yyifWSvfvGAuKau5Jv2BTGeZO6uf8j8=
X-Google-Smtp-Source: AGHT+IFFDXNizpZ3vuH6xJBBRUPvzbuvqFOYFoh+t1YBbvxwcXUL+r5zJu2BpTJXrcb2S71zCUhlon51++M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ec5:b0:5ca:321f:a368 with SMTP id
 cs5-20020a05690c0ec500b005ca321fa368mr767996ywb.7.1701309730213; Wed, 29 Nov
 2023 18:02:10 -0800 (PST)
Date: Wed, 29 Nov 2023 18:02:08 -0800
In-Reply-To: <20231130011650.GD1389974@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
 <87edgy87ig.fsf@mail.lhotse> <ZWagNsu1XQIqk5z9@google.com>
 <875y1k3nm9.fsf@mail.lhotse> <ZWfgYdSoJAZqL2Gx@google.com> <20231130011650.GD1389974@nvidia.com>
Message-ID: <ZWftIIEpbLP2xF5H@google.com>
Subject: Re: Ping? Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c
 unless VFIO is selected
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, James Morse <james.morse@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	Marc Zyngier <maz@kernel.org>, Ingo Molnar <mingo@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, 
	x86@kernel.org, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 29, 2023, Jason Gunthorpe wrote:
> On Wed, Nov 29, 2023 at 05:07:45PM -0800, Sean Christopherson wrote:
> > On Wed, Nov 29, 2023, Michael Ellerman wrote:
> > > Sean Christopherson <seanjc@google.com> writes:
> > > > On Fri, Nov 10, 2023, Michael Ellerman wrote:
> > > >> Jason Gunthorpe <jgg@nvidia.com> writes:
> > > >> > There are a bunch of reported randconfig failures now because of this,
> > > >> > something like:
> > > >> >
> > > >> >>> arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7: warning: attribute declaration must precede definition [-Wignored-attributes]
> > > >> >            fn = symbol_get(vfio_file_iommu_group);
> > > >> >                 ^
> > > >> >    include/linux/module.h:805:60: note: expanded from macro 'symbol_get'
> > > >> >    #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
> > > >> >
> > > >> > It happens because the arch forces KVM_VFIO without knowing if VFIO is
> > > >> > even enabled.
> > > >> 
> > > >> This is still breaking some builds. Can we get this fix in please?
> > > >> 
> > > >> cheers
> > > >> 
> > > >> > Split the kconfig so the arch selects the usual HAVE_KVM_ARCH_VFIO and
> > > >> > then KVM_VFIO is only enabled if the arch wants it and VFIO is turned on.
> > > >
> > > > Heh, so I was trying to figure out why things like vfio_file_set_kvm() aren't
> > > > problematic, i.e. why the existing mess didn't cause failures.  I can't repro the
> > > > warning (requires clang-16?), but IIUC the reason only the group code is problematic
> > > > is that vfio.h creates a stub for vfio_file_iommu_group() and thus there's no symbol,
> > > > whereas vfio.h declares vfio_file_set_kvm() unconditionally.
> > > 
> > > That warning I'm unsure about.
> > 
> > Ah, it's the same warning, I just missed the CONFIG_MODULES=n requirement.
> 
> Oh, wait, doesn't that mean the approach won't work? IIRC doesn't
> symbol_get turn into just &fn when non-modular turning this into a
> link failure without the kconfig part?

Yes, but it doesn't cause linker errors.  IIUC, because the extern declaration
is tagged "weak", a dummy default is used.  E.g. on x86, this is what is generated
with VFIO=y

                fn = symbol_get(vfio_file_is_valid);
                if (!fn)
   0xffffffff810396c5 <+5>:	mov    $0xffffffff81829230,%rax
   0xffffffff810396cc <+12>:	test   %rax,%rax

whereas VFIO=n gets

                fn = symbol_get(vfio_file_is_valid);
                if (!fn)
   0xffffffff810396c5 <+5>:	mov    $0x0,%rax
   0xffffffff810396cc <+12>:	test   %rax,%rax

I have no idea if the fact that symbol_get() generates '0', i.e. the !NULL checks
work as expected, is intentional or if KVM works by sheer dumb luck.  I'm not
entirely sure I want to find out, though it's definitely extra motiviation to get
the KVM mess fixed sooner than later. 
