Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E8E2C15A8
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753111602; cv=none; b=gtIigx3qIjNmo1Ogc4yHJoa2abJ/BmdUuHykuDFJE6rnl4wLDzgtBHAU6luacxBT/CI+VLlyUw2UPmPe+LgIvTNKU8b4I2IV450LYyHUAw2hMGurLgMYICXBxbwm5P0XHFtE3DC4E3JSlxMbmeJxYhpXGKUo4MOhA0W8FMv9L6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753111602; c=relaxed/simple;
	bh=8DwP3omhkAVQqs7IffAT+dALozWU0wdNIC142sQ97Ro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=StqBJ3XJd+v6yttI7EzD7Yq5ciqXTsP8gN/S5/MQWeDylILHjuKZ07p4cmvN3NgLVRIIuJ8cG7H4cOuXN8BhJterTEHJMpdxrqTPdilarz+anlNhg1SuitddwnhT65eE0/TOGAsBr0UyNuz6ZDcLbZ4ck7yxQebjv0rmUQ638cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x4t5USbG; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x4t5USbG"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso810061cf.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 08:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753111599; x=1753716399; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+zXX1Cs6v+OQFAHcUcXiOun/0OGx+sBx9HWHDVkm/fI=;
        b=x4t5USbGyzKjY38gCSCcjcu12LCT9XUkQEYmccbyzdlkqEHqli7RFwoTZlP6jI0nBl
         vRPRdqbuetQkjWJHdQOtCu9BjziPP0b65avLqjyHXzHJ9xnEdmHJiFim04QqArnAdvPH
         /R5S57HIx3TUO0ORFdF4Z2x6cRRl6wBiLu4cT+uycUhsHhr17ip60LvdQHTXfNxMKLV4
         Ph95iYWGz7XHxGZEqJhUGRbNXzCZHRRG4U10r0pwWu0zuC7B4Zg9LwGjX3PEgUHwNME7
         LC9aqBvwdvIgaiTqDs/+Jlgw8P5efOwLzFUJmx5gVuXDtM64maWTagupPKMkBTvkhsDZ
         geQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753111599; x=1753716399;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+zXX1Cs6v+OQFAHcUcXiOun/0OGx+sBx9HWHDVkm/fI=;
        b=enAimYM28QXp7pSo/F9n00iJB25vWDk8ZPn0KnC/P860Ebtm+u9DR6DmViEM/RVLhh
         xsuTGp1PJymtJ/NIx8PamApGm5ZsCwT0IUGzp+kTuBQ/Rkx7xdQdkoGqYXW/Fyn3iMFJ
         Wu1Asx1vJCpDsBoUjQptBNP/AN/ByI2tyaw5CdkGf6HdNVmMBeQx7krhYKz1nh7uv77u
         XIM9WapjMN0wfA1BMcId5LyQ+HzT9zpPeFZte/02C7cfChMXTIfWJ38fGklIBbdabEJa
         VTGYbHuq0fwQ/25HCwJuT087qEoRH5u5Wj7hpFK9ZJlQRO+/Mev2t95BrUaM9xNvpGca
         i6xg==
X-Forwarded-Encrypted: i=1; AJvYcCVkDi4QtxG/a5/4kAL5h1Qbv8awQ+4z2v0embRUEugKvFw6oxDT/MPIzfqoEM13EPVBlexCqcU=@lists.linux.dev
X-Gm-Message-State: AOJu0YweAU68kzBxAVF5nrnNmlprswpp5vT5czeCPfH/sHcpu02c949q
	70gVddAfl0gjNSqkbtzDkZeR9Lsqkm9j+mFiNHIE8slceB4kmYxsoID1j3QQAQ7kM1GJb0/FhOG
	+i4evSD6qN0mqR0LVWpD91ObMw3cbo/l6d5ZbG1DQ
X-Gm-Gg: ASbGnctaNtCcEmAMe032Bi9Zwws+PvU/39NRn/mxaD+STm+XXvXf0KBkfzXl08HdYZq
	KZKFxrb2BdchPsKuGR6wbM95pFUk/SaB8qQdtr0G2+l880q3H/aRTa8m5LwJnKo5LbaQMRG1fMQ
	oIC/v+zrcmyTZZfpISCNJ+0dLQdNI+C23o3HPHEBMxKf6thMrCmnpxc604rcZJ6eYtOfmNOMU34
	uGVfuo=
X-Google-Smtp-Source: AGHT+IEJ1agfPLztb2zu+kNSQrf+HNQSH/8YBV9oHV+GLXju3loOkIiAuNIEAfRphTYzBRJ1wUQtlA8Dhv1rRae6lKk=
X-Received: by 2002:a05:622a:a18d:b0:494:4aa0:ad5b with SMTP id
 d75a77b69052e-4ae5ad66634mr161081cf.2.1753111599011; Mon, 21 Jul 2025
 08:26:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-2-tabba@google.com>
 <aH5Z7edFZSPzmJ5w@google.com>
In-Reply-To: <aH5Z7edFZSPzmJ5w@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 21 Jul 2025 16:26:02 +0100
X-Gm-Features: Ac12FXxSI2fqE4AUgjZ2pvOx5zOwfObgBpuUEKoP_2mWQ6ddL7hqgwa3HEbqCBI
Message-ID: <CA+EHjTzemPVuHnm8vZh2Lh25GpZL-CR3kqtFQ7uktKobkjNDUA@mail.gmail.com>
Subject: Re: [PATCH v15 01/21] KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
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

On Mon, 21 Jul 2025 at 16:17, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 17, 2025, Fuad Tabba wrote:
> > Rename the Kconfig option CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM.
>
> Please name this CONFIG_KVM_GUEST_MEMFD.  I'm a-ok using gmem as the namespace
> for functions/macros/variables, but there's zero reason to shorten things like
> Kconfigs.

Ack.

> > @@ -719,10 +719,10 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
> >  #endif
> >
> >  /*
> > - * Arch code must define kvm_arch_has_private_mem if support for private memory
> > - * is enabled.
> > + * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
> > + * enabled.
>
> This is undesirable, and the comment is flat out wrong.  As evidenced by the lack
> of a #define in arm64, arch does NOT need to #define kvm_arch_has_private_mem if
> CONFIG_KVM_GUEST_MEMFD=y.  It "works" because the sole caller to kvm_arch_has_private_mem()
> is guarded by CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y, and that's never selected
> by arm64.
>
> I.e. this needs to key off of CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y, not off of
> CONFIG_KVM_GUEST_MEMFD=y.  And I would just drop the comment altogether at that
> point, because it's all quite self-explanatory:
>
> #ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> {
>         return false;
> }
> #endif

Ack.

>
> >   */
> > -#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> > +#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> >  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> >  {
> >       return false;
> > @@ -2527,7 +2527,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> >
> >  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  {
> > -     return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
> > +     return IS_ENABLED(CONFIG_KVM_GMEM) &&
>
> And this is equally wrong.  The existing code checked CONFIG_KVM_PRIVATE_MEM,
> because memory obviously can't be private if private memory is unsupported.
>
> But that logic chain doesn't work as well for guest_memfd.  In a way, this is a
> weird semantic change, e.g. it changes from "select guest_memfd if private memory
> is supported" to "allow private memory if guest_memfd is select".   The former
> existed because compiling in support for guest_memfd when it coulnd't possibly
> be used was wasteful, but even then it was somewhat superfluous.
>
> The latter is an arbitrary requirement that probably shouldn't exist, and if we
> did want to make it a hard requirement, should be expressed in the Kconfig
> dependency, not here.
>
> TL;DR: drop the IS_ENABLED(CONFIG_KVM_GMEM) check.

Ack.

Thanks!
/fuad
