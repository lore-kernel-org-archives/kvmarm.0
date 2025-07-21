Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729A92E03FD
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753117278; cv=none; b=DZDEN5d6md11NUzWJYJw6bjYG/65TGs9qFNV0YwRTYTzOqQmbTo8jBeUQgADF3hb3blEXkLnlllF+QH6hXOan5sSku/SwetuKsrt4a39rIPD1a92qWhtquho4KjDDx/VjAkYElh+0d5mLk/96eHEZBvmUM0fsqBzQDMjhHZK7NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753117278; c=relaxed/simple;
	bh=nJ55EMQUPVLja/Qbkea12G4WKE4JetlEY4Fh5E8peDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TVfSiUrGSKUPMNnLG7n8NlVuDY6LzOnAyNXsl3f8fIs6Ws+4YBMOTNKRMudjcoKryDBqMg5kpMImGJkSc3KjgeAqGc93bUSmPGukeygAFQRxcYDxwFIAstOL2NgVPBgIs2A8lA05DlB0gPuOM5C6XUViA8xe97KY9xYtIHRFiBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=stgSHuen; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="stgSHuen"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso6471cf.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 10:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753117275; x=1753722075; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vt9ZwUF3fGDVyxUTkyz5qBpDl9or2ldYVWFaw2AS4MQ=;
        b=stgSHuenHGjmyc3QaR7mSEsrO6VVNzmIiGK0lmVaeAugUgQlqUJ4RGhW3HFq5wGYUx
         T1MsKTyAvitjq/Pg+7mGUXtAu+8rRhu9UyUrbxvUP/4nwXrIJNJJ0dxtE86o65CRorlQ
         apZknrI6xsdRJW2PA/00x9Ft0rh/nX9VWXXuz03K+MvuyronLEWjN01NCQxdyLVM7aY7
         +cic5LoMWlBUNChHnyMif2ig79+WePJmFwcZ+ftSKs6Ir0rm/JsXV+iJT88pOAyTZCEO
         Xo/2BbU1HJIMA2uTGkTm9H5cPV/r3/5ci+z4dji1sjx7y36UiQ+g1+vdVWjgsDO9NMGa
         LEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753117275; x=1753722075;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vt9ZwUF3fGDVyxUTkyz5qBpDl9or2ldYVWFaw2AS4MQ=;
        b=Uno5FcB0LniabwL/N8ngOp36kgVjVJgXWc47odnNQ6BdqBDe9Qj0WZhpDr6GrxjygQ
         Tq33N0Zdk8QEUORfcKjj5Vfy5Q0SRIcV6StXXhloez3EYgHuZnLH6IdffyAK3I/oZFyt
         JSnJ4mRf2FqsT7fE+lyoFHZoFhehzAP5T5Wh7/68gAeUOZ6w6izaYwfXkLdXkXNIQUOH
         ZFK6VxY7axbhSWgGcUu5B0ZaIyJjjV0oDtIMU5nEVx1WuJmk7mnUQPSEDhyKTHniHKFf
         DdTfugmJ5QIB4LJv0jzWrslpMmWXVhRTns3jyX3MRw2FeE1acWduaTT+TLXXUUJRM2T0
         YaLw==
X-Forwarded-Encrypted: i=1; AJvYcCXIBt9p+j5KuL5aqLANMMO7DXOPZUKDCPlMBeHim7gmIvtVsApW6WpUjSDgLbClBoEYosIxsm0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaNWWO/g5dglnGIup3MW9Zrz8ExAgRCZrJCGxrkiICiczJFYso
	s9tIu36W0tG2kl6jhrSbBXLdmnPCcMeumeIVRPYC2e6uKBi+VWMlnkFaZFMtuThTYSFFCmdKiKf
	39uwpv7YokJi722d/F2CINmzpd1l/GjHQvg+lAJd3
X-Gm-Gg: ASbGncvDEHD2V2k6uhwlI3Da83X8B0NlwWBN5l0b6xMqxYuLgrt6U+cyFjI1t+AuzEZ
	woha3JTjxk0JeR1jpFHP5Z+RiEiD+EXbpYUhfp696XXwYHrRZrCNzqtPpQi8MEv1em2achg6eNV
	zQrxR/MP6wldSOE28gROwIsxMeQGlnY0R/eG5fWPjQRpDKnrXlbesmYPPYlkVD1h1pjz7Ldfj/X
	Iwwmow=
X-Google-Smtp-Source: AGHT+IE77xfZzLtUStJio5/gr2Lddfq0kwmTtubIneVZ36yQE9cl1kxCYy+WewT5qhlZD3J2u42dfcUp/sDkWx810Uk=
X-Received: by 2002:a05:622a:58cf:b0:4a4:d827:7f93 with SMTP id
 d75a77b69052e-4ae5b42ef1dmr687911cf.0.1753117273637; Mon, 21 Jul 2025
 10:01:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-5-tabba@google.com>
 <aH5uqeQqvzgJOCN0@google.com>
In-Reply-To: <aH5uqeQqvzgJOCN0@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 21 Jul 2025 18:00:36 +0100
X-Gm-Features: Ac12FXwew5QLfnZj03go8Mjw4g5wc-UoRbU-fCLWG340Dw64JFHDBfVakMGYyDc
Message-ID: <CA+EHjTw766UKoLVoxGWDS2adq4m0TWsxwTWMGsjMK=qkSx4iCQ@mail.gmail.com>
Subject: Re: [PATCH v15 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Mon, 21 Jul 2025 at 17:45, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 17, 2025, Fuad Tabba wrote:
> > Introduce a new boolean member, supports_gmem, to kvm->arch.
> >
> > Previously, the has_private_mem boolean within kvm->arch was implicitly
> > used to indicate whether guest_memfd was supported for a KVM instance.
> > However, with the broader support for guest_memfd, it's not exclusively
> > for private or confidential memory. Therefore, it's necessary to
> > distinguish between a VM's general guest_memfd capabilities and its
> > support for private memory.
> >
> > This new supports_gmem member will now explicitly indicate guest_memfd
> > support for a given VM, allowing has_private_mem to represent only
> > support for private memory.
> >
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shivank Garg <shivankg@amd.com>
> > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> > Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> NAK, this introduces unnecessary potential for bugs, e.g. KVM will get a false
> negative if kvm_arch_supports_gmem() is invoked before kvm_x86_ops.vm_init().
>
> Patch 2 makes this a moot point because kvm_arch_supports_gmem() can simply go away.

Just to reiterate, this is a NAK to the whole patch (which if I recall
correctly, you had suggested), since the newer patch that you propose
makes this patch, and the function kvm_arch_supports_gmem()
unnecessary.

Fewer patches is fine by me :)

Thanks,
/fuad

> > ---
> >  arch/x86/include/asm/kvm_host.h | 3 ++-
> >  arch/x86/kvm/svm/svm.c          | 1 +
> >  arch/x86/kvm/vmx/tdx.c          | 1 +
> >  arch/x86/kvm/x86.c              | 4 ++--
> >  4 files changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index bde811b2d303..938b5be03d33 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1348,6 +1348,7 @@ struct kvm_arch {
> >       u8 mmu_valid_gen;
> >       u8 vm_type;
> >       bool has_private_mem;
> > +     bool supports_gmem;
> >       bool has_protected_state;
> >       bool pre_fault_allowed;
> >       struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> > @@ -2277,7 +2278,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >
> >  #ifdef CONFIG_KVM_GMEM
> >  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> > -#define kvm_arch_supports_gmem(kvm) kvm_arch_has_private_mem(kvm)
> > +#define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
> >  #else
> >  #define kvm_arch_has_private_mem(kvm) false
> >  #define kvm_arch_supports_gmem(kvm) false
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index ab9b947dbf4f..d1c484eaa8ad 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5181,6 +5181,7 @@ static int svm_vm_init(struct kvm *kvm)
> >               to_kvm_sev_info(kvm)->need_init = true;
> >
> >               kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
> > +             kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
> >               kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
> >       }
> >
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index f31ccdeb905b..a3db6df245ee 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -632,6 +632,7 @@ int tdx_vm_init(struct kvm *kvm)
> >
> >       kvm->arch.has_protected_state = true;
> >       kvm->arch.has_private_mem = true;
> > +     kvm->arch.supports_gmem = true;
> >       kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
> >
> >       /*
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 357b9e3a6cef..adbdc2cc97d4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12780,8 +12780,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >               return -EINVAL;
> >
> >       kvm->arch.vm_type = type;
> > -     kvm->arch.has_private_mem =
> > -             (type == KVM_X86_SW_PROTECTED_VM);
> > +     kvm->arch.has_private_mem = (type == KVM_X86_SW_PROTECTED_VM);
> > +     kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
> >       /* Decided by the vendor code for other VM types.  */
> >       kvm->arch.pre_fault_allowed =
> >               type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> > --
> > 2.50.0.727.gbf7dc18ff4-goog
> >
