Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B9A2F508C
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 12:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752668724; cv=none; b=rzSnaosTfL4wHzIMloAEUZw6CyoMZRWe2gSxG20QB8pcK1OzRIP6VYJ9RGhckRUS7icgycdxHynDbqqCXc0F1LgUv9s49z56vnZoaoVH2hXQ6U6zxmq2LkOaMQTomRp93gxGQ8yuP/J/rPpZ3Ax6+muFf0ChW5f+6uHA4mKSUW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752668724; c=relaxed/simple;
	bh=gtidsBFmnOnmsE2Ph+bkFQVbN9NQSEhmnbLqKOPw5OU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tvKiYOcWpmz+sMGMBmkkCA9W5IMaCB1/wDvOmnjTHJYfgvPt4FvvPiJPhfTrWf5eVWh8hOcbuzDgwpW2vZzsYDEDTM4LYuIVCVe5P75QaGYO+naxqJ7USgfSWHRK0LTNPF4y3spk0fIuQkHyoFoZcddg/EJIWwsPYO3Y9D34Td8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2GoKbj4t; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2GoKbj4t"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso440921cf.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 05:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752668721; x=1753273521; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P9vOWQfvk67OEZXIddoGDDceH/a4WGHgT9536w839YE=;
        b=2GoKbj4tfVfl3Rzr+rZxX9u7In4YUcDYL0+4er+iC7CRb25FLU1882nl86xVLV/fuo
         z1YbOES88y3BVvZfChJ9+EWAc7beHvdA2FEGfezRG/Xi422yGHJ3H+94ssyT3hGhUoSi
         kD78Wwa6RDO4qeTxVB5j8soMCjBYFE9S/W4PAMK3R3tNsTlJpGwr/Nb2UZWEoR7IKVqA
         W3JfTDR/rThlixqnu+F6JT2w6k/umbCeyMKcK9nG1sf0/XMqqAV1KeoihPPz5imrtNkR
         fbYKwjxpQjXfGCbRZ0EV6ktsrWqr8XRfIldGFai5WdFDSPpKvApF4dz0JbmQ3QvO2Mny
         FqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752668721; x=1753273521;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9vOWQfvk67OEZXIddoGDDceH/a4WGHgT9536w839YE=;
        b=JyHZnp7zWN9cp4AJ1WSY19WAcBBDYqbrtoTEMfOnOmVq9dOe/0uc6/FvjFRWk9aKqj
         rHbTMMWMPwczd+JIi5OiD1fFjCzbT7pPJ/tcWFpKNZ6YQ2Pkct9cOOEoW5KxmsZuF2OB
         OYWz4IIYkptmGPZnAFlxbbPT8j4U9E14WWXyzKdabun4T388zhJdwVzqKsbxIv+TPcKt
         P6RpqwUonInLZQ6A0PJvhk9qkq5LZkX9DqIc91n4w8CrcT0fMyGVwfgMt3bSISh9WQvp
         WqqTXQE6Becrx+XowaE1ueq9pJbRngd0w5jgSCbXsylAl/EiviZYcySeg4RzI7tXFCIb
         xrtg==
X-Forwarded-Encrypted: i=1; AJvYcCWrkFTozAYQbLaP6NlgUoZuO9BbWC6yJF/wnF+nrP2PY9VeeMpPMmNQcKmA8CzPFt5Dah2cifg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJeAG9pNq2mlXDzyBlVGl+KxZsdGccrUnob965AMPmfwjiDdME
	QtA1VtSPoOi4KetT05JXYCaDg7NTL6fCwpOG2CDokBPyrT44kPYttuGZWdALR320qQzahdtiuMo
	4abpBiKbHrZe4XUdrE3Y5YNCXmlhxZou0VlNKGG+R
X-Gm-Gg: ASbGncsoamoNo1+1vasPSkop/7UTLmDONxS3L9dL2Ju445h6ojEPIpjFlPxMx7ShoS6
	PlVAKM79eudpbIkkt2SRoNM6IU4LfIH0FwHxVBxJG9Ab8bRz9pLgJULujLgVOZy/5/jXQEAz5ej
	mWxRgzraVEvVXLU4SBHR0ef09jivX3HcmUcjgu7vE4yQ+2+masjJbWtbSjyd/rnUJP32V1XJGqK
	c3ELIhZMcRElb9jyfm1yM4wSD2wGM9HMUCPeSl29TdL6A==
X-Google-Smtp-Source: AGHT+IH6bUjoQ8w40IEDFjYBy3Dv0CufD96xSoUjUMk4tkbVg/wklPzfe4Mv0Koy4rNvEv6fRuw2Hc0irdObv5bPYrs=
X-Received: by 2002:a05:622a:151:b0:494:4aa0:ad5b with SMTP id
 d75a77b69052e-4ab9539e674mr2896191cf.2.1752668720187; Wed, 16 Jul 2025
 05:25:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-3-tabba@google.com>
 <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com> <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
 <418ddbbd-c25e-4047-9317-c05735e02807@intel.com> <778ca011-1b2f-4818-80c6-ac597809ec77@redhat.com>
 <6927a67b-cd2e-45f1-8e6b-019df7a7417e@intel.com> <CA+EHjTz7C4WgS2-Dw0gywHy+zguSNXKToukPiRfsdiY8+Eq6KA@mail.gmail.com>
 <47395660-79ad-4d22-87b0-c5bf891f708c@redhat.com> <fa1ccce7-40d3-45d2-9865-524f4b187963@intel.com>
 <f7a54cc4-1017-4e32-85b8-cf74237db935@redhat.com>
In-Reply-To: <f7a54cc4-1017-4e32-85b8-cf74237db935@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 13:24:42 +0100
X-Gm-Features: Ac12FXz8Zm2UQNV9sio4ZrBj9GKyEj5gs20r_CCCNeFGgLSNGsCRuXWEy4xCBgI
Message-ID: <CA+EHjTzOqCpcaNU4caddh6N3bCO0GvrOoZ+rMApdRh4=+BEXNA@mail.gmail.com>
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: David Hildenbrand <david@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

On Wed, 16 Jul 2025 at 13:14, David Hildenbrand <david@redhat.com> wrote:
>
> On 16.07.25 14:01, Xiaoyao Li wrote:
> > On 7/16/2025 7:15 PM, David Hildenbrand wrote:
> >> On 16.07.25 13:05, Fuad Tabba wrote:
> >>> On Wed, 16 Jul 2025 at 12:02, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>>>
> >>>> On 7/16/2025 6:25 PM, David Hildenbrand wrote:
> >>>>> On 16.07.25 10:31, Xiaoyao Li wrote:
> >>>>>> On 7/16/2025 4:11 PM, Fuad Tabba wrote:
> >>>>>>> On Wed, 16 Jul 2025 at 05:09, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
> >>>>>>>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> >>>>>>>>> The original name was vague regarding its functionality. This
> >>>>>>>>> Kconfig
> >>>>>>>>> option specifically enables and gates the kvm_gmem_populate()
> >>>>>>>>> function,
> >>>>>>>>> which is responsible for populating a GPA range with guest data.
> >>>>>>>> Well, I disagree.
> >>>>>>>>
> >>>>>>>> The config KVM_GENERIC_PRIVATE_MEM was introduced by commit
> >>>>>>>> 89ea60c2c7b5
> >>>>>>>> ("KVM: x86: Add support for "protected VMs" that can utilize private
> >>>>>>>> memory"), which is a convenient config for vm types that requires
> >>>>>>>> private memory support, e.g., SNP, TDX, and KVM_X86_SW_PROTECTED_VM.
> >>>>>>>>
> >>>>>>>> It was commit e4ee54479273 ("KVM: guest_memfd: let
> >>>>>>>> kvm_gmem_populate()
> >>>>>>>> operate only on private gfns") that started to use
> >>>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM gates kvm_gmem_populate()
> >>>>>>>> function. But
> >>>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM is not for kvm_gmem_populate() only.
> >>>>>>>>
> >>>>>>>> If using CONFIG_KVM_GENERIC_PRIVATE_MEM to gate
> >>>>>>>> kvm_gmem_populate() is
> >>>>>>>> vague and confusing, we can introduce KVM_GENERIC_GMEM_POPULATE
> >>>>>>>> to gate
> >>>>>>>> kvm_gmem_populate() and select KVM_GENERIC_GMEM_POPULATE under
> >>>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM.
> >>>>>>>>
> >>>>>>>> Directly replace CONFIG_KVM_GENERIC_PRIVATE_MEM with
> >>>>>>>> KVM_GENERIC_GMEM_POPULATE doesn't look correct to me.
> >>>>>>> I'll quote David's reply to an earlier version of this patch [*]:
> >>>>>>
> >>>>>> It's not related to my concern.
> >>>>>>
> >>>>>> My point is that CONFIG_KVM_GENERIC_PRIVATE_MEM is used for selecting
> >>>>>> the private memory support. Rename it to KVM_GENERIC_GMEM_POPULATE is
> >>>>>> not correct.
> >>>>>
> >>>>> It protects a function that is called kvm_gmem_populate().
> >>>>>
> >>>>> Can we stop the nitpicking?
> >>>>
> >>>> I don't think it's nitpicking.
> >>>>
> >>>> Could you loot into why it was named as KVM_GENERIC_PRIVATE_MEM in the
> >>>> first place, and why it was picked to protect kvm_gmem_populate()?
> >>>
> >>> That is, in part, the point of this patch. This flag protects
> >>> kvm_gmem_populate(), and the name didn't reflect that. Now it does. It
> >>> is the only thing it protects.
> >>
> >> I'll note that the kconfig makes it clear that it depends on
> >> KVM_GENERIC_MEMORY_ATTRIBUTES -- having support for private memory.
> >>
> >> In any case, CONFIG_KVM_GENERIC_PRIVATE_MEM is a bad name: what on earth
> >> is generic private memory.
> >
> > "gmem" + "memory_attribute" is the generic private memory.
> >
> > If KVM_GENERIC_PRIVATE_MEM is a bad name, we can drop it, but not rename
> > it to CONFIG_KVM_GENERIC_GMEM_POPULATE.
> >
> >> If CONFIG_KVM_GENERIC_GMEM_POPULATE is for some reason I don't
> >> understand yet not the right name, can we have something that better
> >> expresses that is is about KVM .. GMEM ... and POPULATE?
> >
> > I'm not objecting the name of CONFIG_KVM_GENERIC_GMEM_POPULATE, but
> > objecting the simple rename. Does something below look reasonable?
> > > ---
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 2eeffcec5382..3f87dcaaae83 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -135,6 +135,7 @@ config KVM_INTEL_TDX
> >           bool "Intel Trust Domain Extensions (TDX) support"
> >           default y
> >           depends on INTEL_TDX_HOST
> > +       select KVM_GENERIC_GMEM_POPULATE
> >           help
> >             Provides support for launching Intel Trust Domain Extensions
> > (TDX)
> >             confidential VMs on Intel processors.
> > @@ -158,6 +159,7 @@ config KVM_AMD_SEV
> >           depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
> >           select ARCH_HAS_CC_PLATFORM
> >           select KVM_GENERIC_PRIVATE_MEM
> > +       select KVM_GENERIC_GMEM_POPULATE
> >           select HAVE_KVM_ARCH_GMEM_PREPARE
> >           select HAVE_KVM_ARCH_GMEM_INVALIDATE
> >           help
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 755b09dcafce..359baaae5e9f 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2556,7 +2556,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >    int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > int max_order);
> >    #endif
> >
> > -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> > +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
> >    /**
> >     * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
> >     *
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 49df4e32bff7..9b37ca009a22 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -121,6 +121,10 @@ config KVM_GENERIC_PRIVATE_MEM
> >           select KVM_GMEM
> >           bool
> >
> > +config KVM_GENERIC_GMEM_POPULATE
> > +       bool
> > +       depends on KVM_GMEM && KVM_GENERIC_MEMORY_ATTRIBUTES
> > +
> >    config HAVE_KVM_ARCH_GMEM_PREPARE
> >           bool
> >           depends on KVM_GMEM
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index b2aa6bf24d3a..befea51bbc75 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -638,7 +638,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct
> > kvm_memory_slot *slot,
> >    }
> >    EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
> >
> > -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> > +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
> >    long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user
> > *src, long npages,
> >                          kvm_gmem_populate_cb post_populate, void *opaque)
> >    {
> >
> >
>
> $ git grep KVM_GENERIC_PRIVATE_MEM
> arch/x86/kvm/Kconfig:   select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
> arch/x86/kvm/Kconfig:   select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> arch/x86/kvm/Kconfig:   select KVM_GENERIC_PRIVATE_MEM
> include/linux/kvm_host.h:#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> virt/kvm/Kconfig:config KVM_GENERIC_PRIVATE_MEM
> virt/kvm/guest_memfd.c:#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
>
>
> Why should we leave KVM_GENERIC_PRIVATE_MEM around when there are no other users?
>
> @fuad help me out, what am I missing?

I'm not sure. Splitting it into two patches, one that introduces
CONFIG_KVM_GENERIC_GMEM_POPULATE followed by one that drops
CONFIG_KVM_GENERIC_PRIVATE_MEM ends up with the same result.

Cheers,
/fuad


> --
> Cheers,
>
> David / dhildenb
>
