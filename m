Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915597F8
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 00:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721954108; cv=none; b=beBzXQdo3noUCkvq3ALlBwcJrtRbstnYk+MvmUjfuMYod8QfVPR2lQ/39phaQ+fqMDvSRyAySIIgbRv+LQW1baSOOsYHWC3S7t+mCr4rjFe2otpO4mU3agAL8++cZODQ51H7P8jKu5aqubhqMzwGEbnc0dOMnC7Rt8Elnx12yc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721954108; c=relaxed/simple;
	bh=eXsvx/oB2qbjHdSp6vi8FE0sL5fteTwRYvum4R3pSAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JWnMFV02HfujYwByTx9zpRuYzg2EkdDPfgelQAqBQ/y6DgoJBqQ/bVJyto0OT6SR+TXRNuuEipJs7O3iTOYtX8c4PV5XOiCx2mMTOndXEm0SWJ/ioix5zPrjGfEXIoCRliXgSZkDXg0o5LwHBp51/01fsAXowpLW8XpdwQVfbLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rw9ZC07b; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rw9ZC07b"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1fd657c9199so26985ad.1
        for <kvmarm@lists.linux.dev>; Thu, 25 Jul 2024 17:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721954106; x=1722558906; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXmOiT3ja7tbFfoShPzcte9+u5DgaoMfXxdrhdWg4sE=;
        b=Rw9ZC07bD791YcxbAdv7kbX3SoZOvK4JYMGgtkxEGEFBuA2o7QMzXmEdwJv5IM0BUx
         UqeoxLH/xBIHukLSzYNeUm2tTpmSUDFtv5s+5IQN93zFDj2tYGG8KfOaMr5xOZzOlEIn
         vvA/gs8GM6cngdh7eI4LrkUcjwkRLzntbWTmcxw+JeoYEdrMT877//qT1OK/44j8mY2g
         e3HD6ly/5PKKGrGj0R/or3gAqg6IUwRKp6wJjAX11Uk2DV/blyzxdPOSiNVlH0OcTMHp
         3qwMMEar2FKEbyi4lbuY1qwmkCG8oJvBtHLAFdZ8rb+gsTXEL0HVMzZoa58FloTxMJos
         6JCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721954106; x=1722558906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YXmOiT3ja7tbFfoShPzcte9+u5DgaoMfXxdrhdWg4sE=;
        b=HEvPWdunIplBEEPVEnZltORKyFpbMtHb5PuyKkjP3pAuy38fGnqjkg64poCACbkV+c
         qwesxx3Pr+HSq9XnEhCmEaKbVCJ0LJ1blw/p3h/Gvue/Ln8zOTmbA3hw6/Zl2Sg+YMx+
         /WLEUlbHQZAMnTp8OhKho4gMYIflj84fz6CU9kHcKgcdoza3YWId3V8/w0J1CGCnBNYE
         9G05+systBzB9XAceO2ltWatrLRx7xHJfYcn+vdETfbxyA1q6cRqB5CKjYR3TxEbvdtI
         guBdSRgfpfxVlt334E1BdasUd9dKIeCwVln/lRQTTV0SFPSS8K1g11zO0tbD4bMpzZTi
         eQ4g==
X-Forwarded-Encrypted: i=1; AJvYcCVY8bwxfiL+60sEXSrSn0ssnTBphxaUEboVTuIfqWaxoZ28BvNk3J/AFMLR6jCzdo1EdWvUaL8Q9YDHKYkx/R9Ad6zKQRm/
X-Gm-Message-State: AOJu0Yyi6QOLCxkXknImVDaUO/W4F8VZSRrtcRC+e6FLl3IgqtIrzqAv
	zjQIRoL5F4SUZbaxHTR961QnNak7H2DVEsU7V48PU18Purm9UpWCGGqpt6ikOcmIEAuKugRdl8f
	CE9HpC4CH9+7pAUWPqu6JBH3+OUL/p8Ovvkgh
X-Google-Smtp-Source: AGHT+IFnv7tfdYJpXM8klvYkuM0VxwmIgdPCwCR+A2LuBYkT8SZpSWEYLkUMwdBrr+1/n3tswklB7a7UCo/1ZzddTK8=
X-Received: by 2002:a17:903:2988:b0:1f3:3ede:9b0 with SMTP id
 d9443c01a7336-1feee856698mr1378625ad.10.1721954105611; Thu, 25 Jul 2024
 17:35:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-3-jthoughton@google.com> <ZqKUefN3HgBQQkuA@google.com>
In-Reply-To: <ZqKUefN3HgBQQkuA@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 25 Jul 2024 17:34:29 -0700
Message-ID: <CADrL8HXoGeafwNvSyMF0=MMjkbodyYrA6+J638QXgyC_TW76XQ@mail.gmail.com>
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn and kvm_age_gfn
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 11:08=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2024-07-24 01:10 AM, James Houghton wrote:
> > Walk the TDP MMU in an RCU read-side critical section. This requires a
> > way to do RCU-safe walking of the tdp_mmu_roots; do this with a new
> > macro. The PTE modifications are now done atomically, and
> > kvm_tdp_mmu_spte_need_atomic_write() has been updated to account for th=
e
> > fact that kvm_age_gfn can now lockless update the accessed bit and the
> > R/X bits).
> >
> > If the cmpxchg for marking the spte for access tracking fails, we simpl=
y
> > retry if the spte is still a leaf PTE. If it isn't, we return false
> > to continue the walk.
> >
> > Harvesting age information from the shadow MMU is still done while
> > holding the MMU write lock.
> >
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> Aside from the comment fixes below,
>
> Reviewed-by: David Matlack <dmatlack@google.com>

Thank you!

>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/Kconfig            |  1 +
> >  arch/x86/kvm/mmu/mmu.c          | 10 ++++-
> >  arch/x86/kvm/mmu/tdp_iter.h     | 27 +++++++------
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 67 +++++++++++++++++++++++++--------
> >  5 files changed, 77 insertions(+), 29 deletions(-)
> >
> [...]
> > --- a/arch/x86/kvm/mmu/tdp_iter.h
> > +++ b/arch/x86/kvm/mmu/tdp_iter.h
> > @@ -25,6 +25,13 @@ static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_=
ptep_t sptep, u64 new_spte)
> >       return xchg(rcu_dereference(sptep), new_spte);
> >  }
> >
> > +static inline u64 tdp_mmu_clear_spte_bits_atomic(tdp_ptep_t sptep, u64=
 mask)
> > +{
> > +     atomic64_t *sptep_atomic =3D (atomic64_t *)rcu_dereference(sptep)=
;
> > +
> > +     return (u64)atomic64_fetch_and(~mask, sptep_atomic);
> > +}
> > +
> >  static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_=
spte)
> >  {
> >       KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
> > @@ -32,10 +39,11 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_pte=
p_t sptep, u64 new_spte)
> >  }
> >
> >  /*
> > - * SPTEs must be modified atomically if they are shadow-present, leaf
> > - * SPTEs, and have volatile bits, i.e. has bits that can be set outsid=
e
> > - * of mmu_lock.  The Writable bit can be set by KVM's fast page fault
> > - * handler, and Accessed and Dirty bits can be set by the CPU.
> > + * SPTEs must be modified atomically if they have bits that can be set=
 outside
> > + * of the mmu_lock. This can happen for any shadow-present leaf SPTEs,=
 as the
> > + * Writable bit can be set by KVM's fast page fault handler, the Acces=
sed and
> > + * Dirty bits can be set by the CPU, and the Accessed and R/X bits can=
 be
>
> "R/X bits" should be "W/R/X bits".

Thanks. Right, we are clearing all of VMX_EPT_RWX_MASK.

>
> > + * cleared by age_gfn_range.
>
> nit: "age_gfn_range()"

Thanks, will fix this and all the other places where I've left off the ().
