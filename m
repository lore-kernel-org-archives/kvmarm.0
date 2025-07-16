Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1940286D40
	for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 12:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752668048; cv=none; b=OF7P5CyeeSF4elppBIV+jU+wLHlKPWcnsU6lZ946R7j39934kfDjA15C3l+RZu78Ze8gFojRDUaXGw4XdtfCpyyLSsAv+Fi388iw0+a5NnMLosFZrkbd8H/QYA/ivx99+o/J0zyJN8i6xnOdbab+rGeH1x8Kj99OSvP8sySA1oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752668048; c=relaxed/simple;
	bh=TTKUqSq9eYEOjKlZ3dGOqTof2EgUkFN2BOZDiWZPOe0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FSuos5lIy+XkYKGGaNOGVhB9Mxl7ugF2YrH3yEqSlA+MQh995gQmvklcJkEZmn6uwdjYGH6Ls3PTvKb2BdzVbEYwMK0PhdPAlxwv1SWsxVtaV9LAKyFfH7vqHxxn23YIiCpOR9BIXUKfuW9tKZGJGcu2vNUaR5fYqF0SIQtV1ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c5io0tVW; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c5io0tVW"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab3855fca3so182471cf.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Jul 2025 05:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752668046; x=1753272846; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aG/7TZS+9GKIxRWop/x1+ei5MRrU7wFBpXJxkGG/wu0=;
        b=c5io0tVWBq1w0ZkTbsB/DwrvkHOoyUou5qJJtGP76AzK9afm8q3XW3TPgWKpBhtKTZ
         kS7f8Ote0s8QDHluTo2+kS+cpldu5BHcKdQGqiyEnfbKsCNTXzDBRyclwmR0/h0ka+0g
         CU83gI1CTFWd34+JvVg+uhzEy7pAGUzcNHPyd7fED/wX6klhyX/EupdvJAr+KcYkJTmx
         tySadqnnCEPua0CQlaagf8mgKWXlTBw83hnui0T4yaT977sJ0BgquDl1xdKxrPQvTOgq
         nGZvZt2mPnDpQ/JTCkoL1QUbGz26qsuYCCpQKwG9Oi+8lV+pVyC7FnPLFyOz8AHpQYYb
         XELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752668046; x=1753272846;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aG/7TZS+9GKIxRWop/x1+ei5MRrU7wFBpXJxkGG/wu0=;
        b=nrFOA9MFJE9svKw/u5hB4qjuBDNGvby13R2bmfjWl9HZgnRHD+by8b69v7PhDsi3VQ
         GiXekFoMVoTcNvAXf5L1nD4beYZeReC8IpP2v8PbMHzK86s76AudUQ30QLXXM9MfFXiq
         6/0HMFrnlXkPtLZ06XDsUMm4eHpUKOlRI9mdnd7UedlNf6WDuIrmjq/Z5CZeCoBZcX4c
         UvsYjJ6K87ojrC6p0elYtPU19YaFO+/huXAlqsUwM3XZOVT4uY5PZ7WbmoJc40QFdCMM
         CWz/cdRg2CpXO3KLJr43rZyDH7VK854EWKB/qaNfOWNZqn5HbLWb/UmSDLdw/76kaRuD
         vX7g==
X-Forwarded-Encrypted: i=1; AJvYcCXHEpW4dkqGFqheU+kh5ZWCLgqvB6txdCas40MMlogaYrXAxVNbmwPCCtWZE/WYsKFQCE+hAIY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPVp75bPU7JX9OZax7IzBZe1cmMSpwjexmUfN09NZs3ubt8Qnc
	0tWbYoryGxaByBlQvrv5UTR+58+v43FkfFSDrsedUw9aWzYhWLlRmvON3f2kN+oZDx/3Udh3pAJ
	++qtEX5F3USJ0AizuEZOUQxhAF//zncsWgOj/w/HS
X-Gm-Gg: ASbGncsmiOU5GzUHTQ8EGGmtFvzBjcHgUSFKkOO2g9Tw8ip7xZyDtyk0BKjTdPh+6k5
	C9i+qDzuHQeA2oEXw4t1bXasLXxXWAe8LltYRqCZqrpY6hGdvbocv2WVwncwrtN2i4luNS68Bjb
	v/Yq+UvKEElTb5EIXBImfwrtgCS6NHwgJ7JHn0c9nJMiozg5JsUvEZzPOJySIQUhQjOS7bhvGaE
	gMeTgg2dFlvGLfjTRWoOwhLpcQheM7kqfY=
X-Google-Smtp-Source: AGHT+IE9YVn0eZnxvGtCeiWdCOyAhPrHi/vRfxF0vM9xrH43ByiHOUhO/4d/xBRn5PAZVeSsErTsBb99s/2AYQflYRY=
X-Received: by 2002:a05:622a:1aa0:b0:4a9:b6e1:15a with SMTP id
 d75a77b69052e-4ab954d8746mr2571621cf.24.1752668044950; Wed, 16 Jul 2025
 05:14:04 -0700 (PDT)
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
In-Reply-To: <fa1ccce7-40d3-45d2-9865-524f4b187963@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 13:13:28 +0100
X-Gm-Features: Ac12FXxuj3h3QF7Rhx9ZguI5DX-IFwgDrQ4Jd5znL_s2tRo5HM04_E0MBe2pEsw
Message-ID: <CA+EHjTzb0D3maKLEgvnPuDDcm4KKPb0W=AWif-tcLQw-R44dow@mail.gmail.com>
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
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

Hi Xiaoyao,

On Wed, 16 Jul 2025 at 13:02, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/16/2025 7:15 PM, David Hildenbrand wrote:
> > On 16.07.25 13:05, Fuad Tabba wrote:
> >> On Wed, 16 Jul 2025 at 12:02, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>>
> >>> On 7/16/2025 6:25 PM, David Hildenbrand wrote:
> >>>> On 16.07.25 10:31, Xiaoyao Li wrote:
> >>>>> On 7/16/2025 4:11 PM, Fuad Tabba wrote:
> >>>>>> On Wed, 16 Jul 2025 at 05:09, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
> >>>>>>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> >>>>>>>> The original name was vague regarding its functionality. This
> >>>>>>>> Kconfig
> >>>>>>>> option specifically enables and gates the kvm_gmem_populate()
> >>>>>>>> function,
> >>>>>>>> which is responsible for populating a GPA range with guest data.
> >>>>>>> Well, I disagree.
> >>>>>>>
> >>>>>>> The config KVM_GENERIC_PRIVATE_MEM was introduced by commit
> >>>>>>> 89ea60c2c7b5
> >>>>>>> ("KVM: x86: Add support for "protected VMs" that can utilize private
> >>>>>>> memory"), which is a convenient config for vm types that requires
> >>>>>>> private memory support, e.g., SNP, TDX, and KVM_X86_SW_PROTECTED_VM.
> >>>>>>>
> >>>>>>> It was commit e4ee54479273 ("KVM: guest_memfd: let
> >>>>>>> kvm_gmem_populate()
> >>>>>>> operate only on private gfns") that started to use
> >>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM gates kvm_gmem_populate()
> >>>>>>> function. But
> >>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM is not for kvm_gmem_populate() only.
> >>>>>>>
> >>>>>>> If using CONFIG_KVM_GENERIC_PRIVATE_MEM to gate
> >>>>>>> kvm_gmem_populate() is
> >>>>>>> vague and confusing, we can introduce KVM_GENERIC_GMEM_POPULATE
> >>>>>>> to gate
> >>>>>>> kvm_gmem_populate() and select KVM_GENERIC_GMEM_POPULATE under
> >>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM.
> >>>>>>>
> >>>>>>> Directly replace CONFIG_KVM_GENERIC_PRIVATE_MEM with
> >>>>>>> KVM_GENERIC_GMEM_POPULATE doesn't look correct to me.
> >>>>>> I'll quote David's reply to an earlier version of this patch [*]:
> >>>>>
> >>>>> It's not related to my concern.
> >>>>>
> >>>>> My point is that CONFIG_KVM_GENERIC_PRIVATE_MEM is used for selecting
> >>>>> the private memory support. Rename it to KVM_GENERIC_GMEM_POPULATE is
> >>>>> not correct.
> >>>>
> >>>> It protects a function that is called kvm_gmem_populate().
> >>>>
> >>>> Can we stop the nitpicking?
> >>>
> >>> I don't think it's nitpicking.
> >>>
> >>> Could you loot into why it was named as KVM_GENERIC_PRIVATE_MEM in the
> >>> first place, and why it was picked to protect kvm_gmem_populate()?
> >>
> >> That is, in part, the point of this patch. This flag protects
> >> kvm_gmem_populate(), and the name didn't reflect that. Now it does. It
> >> is the only thing it protects.
> >
> > I'll note that the kconfig makes it clear that it depends on
> > KVM_GENERIC_MEMORY_ATTRIBUTES -- having support for private memory.
> >
> > In any case, CONFIG_KVM_GENERIC_PRIVATE_MEM is a bad name: what on earth
> > is generic private memory.
>
> "gmem" + "memory_attribute" is the generic private memory.
>
> If KVM_GENERIC_PRIVATE_MEM is a bad name, we can drop it, but not rename
> it to CONFIG_KVM_GENERIC_GMEM_POPULATE.
>
> > If CONFIG_KVM_GENERIC_GMEM_POPULATE is for some reason I don't
> > understand yet not the right name, can we have something that better
> > expresses that is is about KVM .. GMEM ... and POPULATE?
>
> I'm not objecting the name of CONFIG_KVM_GENERIC_GMEM_POPULATE, but
> objecting the simple rename. Does something below look reasonable?

Isn't the below practically the same as having one patch that adds
KVM_GENERIC_GMEM_POPULATE, followed by a patch that drops
KVM_GENERIC_PRIVATE_MEM?

Cheers,
/fuad


> ---
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2eeffcec5382..3f87dcaaae83 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -135,6 +135,7 @@ config KVM_INTEL_TDX
>          bool "Intel Trust Domain Extensions (TDX) support"
>          default y
>          depends on INTEL_TDX_HOST
> +       select KVM_GENERIC_GMEM_POPULATE
>          help
>            Provides support for launching Intel Trust Domain Extensions
> (TDX)
>            confidential VMs on Intel processors.
> @@ -158,6 +159,7 @@ config KVM_AMD_SEV
>          depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>          select ARCH_HAS_CC_PLATFORM
>          select KVM_GENERIC_PRIVATE_MEM
> +       select KVM_GENERIC_GMEM_POPULATE
>          select HAVE_KVM_ARCH_GMEM_PREPARE
>          select HAVE_KVM_ARCH_GMEM_INVALIDATE
>          help
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 755b09dcafce..359baaae5e9f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2556,7 +2556,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> int max_order);
>   #endif
>
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
>   /**
>    * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
>    *
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 49df4e32bff7..9b37ca009a22 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -121,6 +121,10 @@ config KVM_GENERIC_PRIVATE_MEM
>          select KVM_GMEM
>          bool
>
> +config KVM_GENERIC_GMEM_POPULATE
> +       bool
> +       depends on KVM_GMEM && KVM_GENERIC_MEMORY_ATTRIBUTES
> +
>   config HAVE_KVM_ARCH_GMEM_PREPARE
>          bool
>          depends on KVM_GMEM
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b2aa6bf24d3a..befea51bbc75 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -638,7 +638,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct
> kvm_memory_slot *slot,
>   }
>   EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
>   long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user
> *src, long npages,
>                         kvm_gmem_populate_cb post_populate, void *opaque)
>   {
>
>
