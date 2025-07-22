Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664BF27780D
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753198288; cv=none; b=E0r2Nq73F8qYZYkQG4cjSL+AZfMw2+Dm3ziVVRiGijGSu6RR5OTSEn4jtBJEGm6U7dvB3iw1SMiFD0G69O4HMAn7CgRpQSokmPNWLMDRGlRAGfLaL6be/JZapjRm7rfsUqpbdNfOIy9tuPWl7pvRD2c4hKZlzQlJEpvKTQKUP58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753198288; c=relaxed/simple;
	bh=LW5+EUwB4aQ0Rg/zMv6/R70G4bT3GIbkfkPj7XRW9Tc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uqf524cF2y3H3DnCtUCiZmitRUtqJ+HwERouIEyLqwDzKRegEubh/7YVPWT+iPeiqNCOlTUu3Hpyj37O0Sjtm3WqD9EA3ztB807UyqxA+I3IQ2EyeUaz9s+dw/i0ST9YcO2pKsxEM49rB8A25HJcySSODGTjTO+qLCsUCGGSWnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Kgnpo11; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Kgnpo11"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ab86a29c98so409941cf.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 08:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753198284; x=1753803084; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D+k0L961GoqoDjJUTKbSYxRUyR6qX1eP68MhWHVJFbg=;
        b=3Kgnpo11nppaC4jwb+MwQu3D/QbSLK1FoJmZ6IuzXsXDbptV8tiVNAT1U5DwB5TTho
         r8qK7AdDj30HlWLbDU4kIIl7FVYbAdyy/mWg349IvssUIX6r+0uJkIYgcQPOrvD0Y/7L
         Ff502lwkGTOeYJif/UnVBxH73eSkZBcAGPrXGmUD+j1zvtr45el7bpmx62GwwiCEtH3c
         j8gPg0rd7nMKaN8LiQ/VGKZVD3f4PoXySLsbVqwb4vuNS29wMaNpw0s9T9b2U170ggZt
         LOrcjY1XN5fP+E+8D07qJShsdPAPNungvEE9P2XJdbdHWZFA5tpK6BuKpWS1psHFbNFx
         eHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753198284; x=1753803084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D+k0L961GoqoDjJUTKbSYxRUyR6qX1eP68MhWHVJFbg=;
        b=AM5Mp7+12fgJCCpH06wPDYBtArIbFE4UshPdej+aVGNaRueL+Q0Roiw8CrEfk0mcWi
         tRpXvDA0Vn8TJjJZukHdDvmWk1aHBLlQYSJkNSC89lyObAy+iBUYibxWDNFgZFTX7LLC
         mKtqVRHOmonRsYFfxAHeWzGroWc+uU4XGw0nf4l/8/CTAf+HlN28e+NsOsFYQNUuJyZ4
         5vujiAvnyi2fes3A2NAjskLZOy0cteCLhjd3JKP1o6+2BEe73qQygl45ogsJePF0+n+e
         0aINWBiYwBtQcYswwCAcLUKIHuxfvRVF2hPStf86hq8xLi5aKhDoMUxieI1PsbPIk/ME
         4FAg==
X-Forwarded-Encrypted: i=1; AJvYcCVy//qQK3mf8Cv1KH8pOdbyyCnWuZ6N93ajlBgO3v1H/QSqMgVoX1VUQdGzJf1irMZ4bxQcq8w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFaR54QqWUrvuT7ubUIx63v6QjsgEf6Y9Kl3m/edZpZb5dLc2i
	X5cvwa6IaZIjSz4aowA8NfEMweoxTVxBvw+uVbXJWrlGPmEDB9WK+eV/TbxvzCAwpginNN34ShR
	xod35kbzksj33sUuikS7sfn+M4UktU+uSrKLpQKfR
X-Gm-Gg: ASbGncs2EsgcCsibcI4OL4AiU1TrhPIppS9kPQY1Ms4+GJUt9qUPHXyiocJKKTxewgc
	DWl+ajDNUgCuphjRW9q6Xrid2p8BcTMmn3yFw9C2YqZiz85G9wkY3SG2xVHmpKzH/QlJdbPp5/R
	BHS2MgXy5AKxg8tWjhJuan95c/P0PeDy5/5jxKSVtNmgQBC3Ya5fGJSzJDA7n8AP0DjWoEpozxM
	QQTIJA=
X-Google-Smtp-Source: AGHT+IGkN/bZLl3GymkOZZTe3VZFknRwnP1HGd5madljrUzwenWrcpSI2BrfChprDgkNjwylakOH9SaFNgyNyjBG86g=
X-Received: by 2002:a05:622a:cf:b0:4a9:a4ef:35d3 with SMTP id
 d75a77b69052e-4ae5f18c0e2mr4176791cf.7.1753198283442; Tue, 22 Jul 2025
 08:31:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com> <aH7KghhsjaiIL3En@google.com>
 <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com> <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
 <aH-g9o5hSMvVRxAP@google.com>
In-Reply-To: <aH-g9o5hSMvVRxAP@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 16:30:46 +0100
X-Gm-Features: Ac12FXxXDPUsj4cKnzMPyZJq3Wv-mApIfbczPw3W9lV495mX4LQQasFKEUdMPqo
Message-ID: <CA+EHjTxn0s-HeNcXE7cMxx-xCypE5BtNP5=dvZhyV5u61Pt12Q@mail.gmail.com>
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
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

On Tue, 22 Jul 2025 at 15:32, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > On Tue, 22 Jul 2025 at 06:36, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> > > - In 0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch,
> > > there is double gmem in the name of vmx/vt 's callback implementation:
> > >
> > >      vt_gmem_gmem_max_mapping_level
> > >      tdx_gmem_gmem_max_mapping_level
> > >      vt_op_tdx_only(gmem_gmem_max_mapping_level)
> >
> > Sean's patches do that, then he fixes it in a later patch. I'll fix
> > this at the source.
>
> Dagnabbit.  I goofed a search+replace, caught it when re-reading things, and
> fixed-up the wrong commit.  Sorry :-(
>
> > > - In 0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch,
> > >    kvm_x86_call(gmem_max_mapping_level)(...) returns 0 for !private case.
> > >    It's not correct though it works without issue currently.
> > >
> > >    Because current gmem doesn't support hugepage so that the max_level
> > >    gotten from gmem is always PG_LEVEL_4K and it returns early in
> > >    kvm_gmem_max_mapping_level() on
> > >
> > >         if (max_level == PG_LEVEL_4K)
> > >                 return max_level;
> > >
> > >    But just look at the following case:
> > >
> > >      return min(max_level,
> > >         kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
> > >
> > >    For non-TDX case and non-SNP case, it will return 0, i.e.
> > >    PG_LEVEL_NONE eventually.
> > >
> > >    so either 1) return PG_LEVEL_NUM/PG_LEVEL_1G for the cases where
> > >    .gmem_max_mapping_level callback doesn't have specific restriction.
> > >
> > >    or 2)
> > >
> > >         tmp = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
> > >         if (tmp)
> > >                 return min(max_level, tmp);
> > >
> > >         return max-level;
> >
> > Sean? What do you think?
>
> #2, because KVM uses a "ret0" static call when TDX is disabled (and KVM should
> do the same when SEV is disabled, but the SEV #ifdefs are still a bit messy).
> Switching to any other value would require adding a VMX stubs for the !TDX case.
>
> I think it makes sense to explicitly call that out as the "CoCo level", to help
> unfamiliar readers understand why vendor code has any say in the max
> mapping level.
>
> And I would say we adjust max_level instead of having an early return, e.g. to
> reduce the probability of future bugs due to adding code between the call to
> .gmem_max_mapping_level() and the final return.
>
> This as fixup?

Applied it to my tree. Builds and runs fine. Thanks!
/fuad

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index eead5dca6f72..a51013e0992a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3279,9 +3279,9 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
>                                      const struct kvm_memory_slot *slot, gfn_t gfn,
>                                      bool is_private)
>  {
> +       u8 max_level, coco_level;
>         struct page *page;
>         kvm_pfn_t pfn;
> -       u8 max_level;
>
>         /* For faults, use the gmem information that was resolved earlier. */
>         if (fault) {
> @@ -3305,8 +3305,16 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
>         if (max_level == PG_LEVEL_4K)
>                 return max_level;
>
> -       return min(max_level,
> -                  kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
> +       /*
> +        * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
> +        * restrictions.  A return of '0' means "no additional restrictions",
> +        * to allow for using an optional "ret0" static call.
> +        */
> +       coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
> +       if (coco_level)
> +               max_level = min(max_level, coco_level);
> +
> +       return max_level;
>  }
>
>  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
