Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D14F622
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 01:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yAFamB+B"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9caf486775so496209276.2
        for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 17:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701306466; x=1701911266; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6N0wFvlno3kNCM+277a2S5UNbGmqd2ft4cb10DJm/tw=;
        b=yAFamB+B4Ma8tTiXEGOg7Rm5IXekM/j7TnGdzH21r2exgOX2jBQWbm86hUsMniZHde
         HqvL/aDuP8ZAyz+cC7lrhyJK+I/3b/H9FEHxYzHUvi0V2Dn0vjpwaxB6OiEFQlAkEfgs
         S9q0R3NUjYyp+trmngFys1L/1+yAD6JOoPdDi9JY/i4hDi8jX6z7uh/L3aEDpzuKoOV3
         4BaU1YpPglL7qhNN9tGrfM/BUaWk8g7w5nvG4lV4M+E9xaM5je7rMEVoVqV6iKQVLZGw
         TQpSKoenarKUT587a/qvKh/6qtf/pgpKXTvC2ySGiHTN8WUm/l48c6XD11C2oUNTYm4X
         y2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701306466; x=1701911266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6N0wFvlno3kNCM+277a2S5UNbGmqd2ft4cb10DJm/tw=;
        b=as3gVVvGIg1bJdw93o2j2Fu3O/iCbxI0iUHHVCygiPU72OooZa0fiOrfws1sZBEFm8
         Ak3+O+cVKgZ6iqyoMh0rQiGKh0kvwsdCLLClCtq9ByVv+uyMHoaHvwuhFpA6IHT2UUir
         +UjBP6GroIDVpNTjhg8PBLHNnVI5mkk/xSDYnyEvg/oYRWtPsYiVH5Pe1zpI8KQH7A2Q
         dqmw9tqwtu1MuqUwO6JuEJ4zDSe7bL9vt+nYdL5dVqR3h8TP1TdH7LwHZBVR7yM20m8c
         5r0CyW3c/QnoqVfeZW7JP/B4LjArM2hs0hVtq0bP8TzstxOXRo6RejtIhVV1kiTZBDuo
         XvlA==
X-Gm-Message-State: AOJu0YydizZaczx57tmCuXwC4nAEi+9sxGeli/2vQ965T0WUnrI1Ld/l
	hYdSnQgFymxi0mei3oDZbyKXs1y7/PA=
X-Google-Smtp-Source: AGHT+IFI+jDPj/rF774qvoJ2qWoHyFZGCHN96iaq8+b2ScA3/i76IDoNcSAJtId/pe2rL3s2OfV75Y20vgc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ca02:0:b0:db3:fc48:35f0 with SMTP id
 a2-20020a25ca02000000b00db3fc4835f0mr615843ybg.6.1701306466524; Wed, 29 Nov
 2023 17:07:46 -0800 (PST)
Date: Wed, 29 Nov 2023 17:07:45 -0800
In-Reply-To: <875y1k3nm9.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
 <87edgy87ig.fsf@mail.lhotse> <ZWagNsu1XQIqk5z9@google.com> <875y1k3nm9.fsf@mail.lhotse>
Message-ID: <ZWfgYdSoJAZqL2Gx@google.com>
Subject: Re: Ping? Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c
 unless VFIO is selected
From: Sean Christopherson <seanjc@google.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
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

On Wed, Nov 29, 2023, Michael Ellerman wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > On Fri, Nov 10, 2023, Michael Ellerman wrote:
> >> Jason Gunthorpe <jgg@nvidia.com> writes:
> >> > There are a bunch of reported randconfig failures now because of this,
> >> > something like:
> >> >
> >> >>> arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7: warning: attribute declaration must precede definition [-Wignored-attributes]
> >> >            fn = symbol_get(vfio_file_iommu_group);
> >> >                 ^
> >> >    include/linux/module.h:805:60: note: expanded from macro 'symbol_get'
> >> >    #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
> >> >
> >> > It happens because the arch forces KVM_VFIO without knowing if VFIO is
> >> > even enabled.
> >> 
> >> This is still breaking some builds. Can we get this fix in please?
> >> 
> >> cheers
> >> 
> >> > Split the kconfig so the arch selects the usual HAVE_KVM_ARCH_VFIO and
> >> > then KVM_VFIO is only enabled if the arch wants it and VFIO is turned on.
> >
> > Heh, so I was trying to figure out why things like vfio_file_set_kvm() aren't
> > problematic, i.e. why the existing mess didn't cause failures.  I can't repro the
> > warning (requires clang-16?), but IIUC the reason only the group code is problematic
> > is that vfio.h creates a stub for vfio_file_iommu_group() and thus there's no symbol,
> > whereas vfio.h declares vfio_file_set_kvm() unconditionally.
> 
> That warning I'm unsure about.

Ah, it's the same warning, I just missed the CONFIG_MODULES=n requirement.
