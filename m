Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4EF17A317
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749148233; cv=none; b=rxx+qZkTdSN5fiAf7BqOcFJwJ1dZ4H9wIYJ8fv+RTsnKgFCFV4m3qztrtTPTgCGsLSE6+oF+Bq/s2SLBUX6joCnOI2jFUquRYwlN2kapvMjLYciKPYRiNdBFk5ta9PQN9RzrQjgy96KYdryEuptt8iTBUESnAlfUvOWUO/BDGB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749148233; c=relaxed/simple;
	bh=LnyQlmsP5i9Gpf9tYX7BjcukxJuRTi2gzqGvRKTWTn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ji9thxZGWMacYqc3Gj6P1Ky8uBkTU5t1QT8gUQX9DFr8lmKqeduPoADACKJbN89PmfmEXOTUCDvH/21Lc6i6lopsahahtQhCNz2QonnFL/MA0V+1M/nK3+v61IxThfs9mmhfyyHvLEXWV4MLdlX1W4XUQjLYBGql2RLHrDOKDd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B6JQRqhL; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B6JQRqhL"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4a58197794eso35051cf.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 11:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749148231; x=1749753031; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4HrdqA/k41LxSYTdKh0OWWXzlPloxAg6qTNcrag1JWY=;
        b=B6JQRqhLmoE7IfTjMDUoEyQ4KfSaDD0Iz6NX1D8zoDsM9i6uKuuZeh2z9t8QcoRc1t
         rZkiODPx43sFDpwDTVUMbPu8XNXmzF4wHX3S3t1QIrn/Wz382ZiaLtDshg7KpnLo+vGj
         Q9NfHVm5ijSvV7bbihwn1X1OIH7v1qdZP+PQwlESh/3fAUqF3q9TmbjzRL2OtVgEKlXk
         UGm0hNjM/FFohsk4d1VlOQbv5HXChr5PZ67P/KCb/iKQDXgTvy88/KT3MAsBDbdIXCWF
         6BlYq6M4P8p7htq/mDMKR3tTIZu2w5CPZRYmF/WNEBFDAp8P5sOsIQGITwX9rVYrJwjg
         OlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749148231; x=1749753031;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4HrdqA/k41LxSYTdKh0OWWXzlPloxAg6qTNcrag1JWY=;
        b=vBkYYuKFYU+OJ0/w+13Q3QRyWsX2tnYHiXU84PiNNxnW6orTDPwSDhiC5x+My4erGB
         tXuJ0Xfp9EH07dyMauqEVdFmZBEYMvYRfGJQBg2nj0o4bbLkU0c4jzwswgMzgMCdnbo1
         tUR5pqaSA1fCxi446KzFwfgxMedTl8+FBdmp+9Lb/lu+WCBmQHxo4fVohmlVgV9emF6d
         zuV4zlz1jRC2q3+RC8X0Skc7wKKAlylI/0TsXGMJ1LJ3nl/KYRy8xvt9A4mSnPOyL68u
         1UONZTakLyLzz4HVJZPOFw+NL8v1CGBN+pwTIxW22SdiMl9/Oi+4jKQHGrHPHHrV2zQK
         isPQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5MIP39jA/t0qSfWxEEYyvP3OyKxiFyPR6tWi0OAdLfZwiLvUShwNiyjxHreIIdC+7hiRwObE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzp9iITzIipi/cPrmjl4qZ929wfYaFoeqodqVjXFuRriQ1fmMnQ
	XPWkm7yDr1gECA/lbZuj5Frf+sUfEjrA0tW6fkbGrm1MzxwvH6WTPHJ3LWoWMjt2L0AsyBc/7qJ
	2jeyabEjcYQ3/0aEPTzQnJMaxrME3SQxsRrN2oRKz
X-Gm-Gg: ASbGncv5ObQvQgc1+9QIoo82u7WYpj0vOy/EEJrIOdgKN7gY5qA/CT7LYBGiYezEmcj
	Bp3HkAwOewXQS/xNH+qwklgMbk2M6CbW8EwAfTp76GGR+zPDY/MzUIeRZhjWOmChATexb5N/oxY
	S/Rp41sjVKyF82iYkhH4gTkgA/tY70c2Sq/NHd/kZZYLw=
X-Google-Smtp-Source: AGHT+IH7FgESvCVozX/CiDB6ulbbev2isNZ+Soh9txr1mG6fDd4w52Z5DJcOcfE45agVq/Nr3QCWQsAjORWdDsJL18w=
X-Received: by 2002:ac8:41c4:0:b0:48a:ba32:370 with SMTP id
 d75a77b69052e-4a5baa649ccmr283761cf.10.1749148230605; Thu, 05 Jun 2025
 11:30:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-13-tabba@google.com>
 <4909d6dc-09f5-4960-b8be-5150b2a03e45@redhat.com> <CA+EHjTwnAV=tu1eUjixyKAhE4bpNc3XV7EhnMME3+WJ-cu6PNA@mail.gmail.com>
 <8782284c-0ffc-489d-adfe-b25d5ccb77b3@redhat.com> <CA+EHjTw-dgn+QbHd5aCxjLXCGamx7eTr75qcFm+o16qyVydnBQ@mail.gmail.com>
 <637ffae1-a61e-4d68-8332-9ec11a3a78d4@redhat.com>
In-Reply-To: <637ffae1-a61e-4d68-8332-9ec11a3a78d4@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Jun 2025 19:29:53 +0100
X-Gm-Features: AX0GCFsQbfhZC_FlYPxk85rO768zb9vVPjsu-8YXphOrtD0BhntZritMMuHZreE
Message-ID: <CA+EHjTyxJ3VKqPF_9oswYAcbrJM3_MiYoExe6-Dx8A+0bZa+nQ@mail.gmail.com>
Subject: Re: [PATCH v11 12/18] KVM: x86: Enable guest_memfd shared memory for
 SW-protected VMs
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
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

On Thu, 5 Jun 2025 at 18:45, David Hildenbrand <david@redhat.com> wrote:
>
> On 05.06.25 19:43, Fuad Tabba wrote:
> > On Thu, 5 Jun 2025 at 18:35, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 05.06.25 18:11, Fuad Tabba wrote:
> >>> On Thu, 5 Jun 2025 at 16:49, David Hildenbrand <david@redhat.com> wrote:
> >>>>
> >>>> On 05.06.25 17:37, Fuad Tabba wrote:
> >>>>> Define the architecture-specific macro to enable shared memory support
> >>>>> in guest_memfd for relevant software-only VM types, specifically
> >>>>> KVM_X86_DEFAULT_VM and KVM_X86_SW_PROTECTED_VM.
> >>>>>
> >>>>> Enable the KVM_GMEM_SHARED_MEM Kconfig option if KVM_SW_PROTECTED_VM is
> >>>>> enabled.
> >>>>>
> >>>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> >>>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>>>> ---
> >>>>>     arch/x86/include/asm/kvm_host.h | 10 ++++++++++
> >>>>>     arch/x86/kvm/Kconfig            |  1 +
> >>>>>     arch/x86/kvm/x86.c              |  3 ++-
> >>>>>     3 files changed, 13 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>>>> index 709cc2a7ba66..ce9ad4cd93c5 100644
> >>>>> --- a/arch/x86/include/asm/kvm_host.h
> >>>>> +++ b/arch/x86/include/asm/kvm_host.h
> >>>>> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >>>>>
> >>>>>     #ifdef CONFIG_KVM_GMEM
> >>>>>     #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> >>>>> +
> >>>>> +/*
> >>>>> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> >>>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> >>>>> + */
> >>>>> +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
> >>>>> +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> >>>>> +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> >>>>> +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
> >>>>>     #else
> >>>>>     #define kvm_arch_supports_gmem(kvm) false
> >>>>> +#define kvm_arch_supports_gmem_shared_mem(kvm) false
> >>>>>     #endif
> >>>>>
> >>>>>     #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> >>>>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> >>>>> index b37258253543..fdf24b50af9d 100644
> >>>>> --- a/arch/x86/kvm/Kconfig
> >>>>> +++ b/arch/x86/kvm/Kconfig
> >>>>> @@ -47,6 +47,7 @@ config KVM_X86
> >>>>>         select KVM_GENERIC_HARDWARE_ENABLING
> >>>>>         select KVM_GENERIC_PRE_FAULT_MEMORY
> >>>>>         select KVM_GENERIC_GMEM_POPULATE if KVM_SW_PROTECTED_VM
> >>>>> +     select KVM_GMEM_SHARED_MEM if KVM_SW_PROTECTED_VM
> >>>>>         select KVM_WERROR if WERROR
> >>>>
> >>>> Is $subject and this still true, given that it's now also supported for
> >>>> KVM_X86_DEFAULT_VM?
> >>>
> >>> True, just not the whole truth :)
> >>>
> >>> I guess a better one would be, for Software VMs (remove protected)?
> >>
> >> Now I am curious, what is a Hardware VM? :)
> >
> > The opposite of a software one! ;) i.e., hardware-supported CoCo,
> > e.g., TDX, CCA...
>
> So, you mean a sofware VM is ... just an ordinary VM? :P
>
> "KVM: x86: Enable guest_memfd shared memory for ordinary (non-CoCo) VMs" ?
>
> But, whatever you prefer :)

This sounds better. I was thrown off by the KVM_SW_PROTECTED_VM type :)

/fuad

> --
> Cheers,
>
> David / dhildenb
>
