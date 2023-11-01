Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0B953B1
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 22:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xwve43fp"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5aecf6e30e9so5641947b3.1
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 15:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698878099; x=1699482899; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oVrvOLECZXxSaWjRNpKGTaiE8FNIaCo3DEHHzsR8PGo=;
        b=xwve43fpO78/djCLw5Py29xWrX3pT45kjA1Ld3dDThPhOpt6iRUE3Zljs4/Psr/z8c
         XAVFH0SfADq/+OoqYohTOYstHLsN09maQJFCikYvnWbnDtW7pkQv3SpQTo7LfIGH03n+
         WEQkmV9ZMRhkikgoFnDHWqz4EfH8HqzLKctSQ0G1IDuurpOBV4q7zGWVhljHv+96jlk2
         yz0LeARLUh8YhdqaRyj96bIHqUjEkre/OPmvNxFvU2VwrYzLOytCfNP12nO4bdGd7Ddg
         ZX1jakHB/N629D+GVpBSUsfB0pvrDzpwvmS44dGY+vA4gpVtzPz34fpdp88nR9am+wiu
         PBeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698878099; x=1699482899;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oVrvOLECZXxSaWjRNpKGTaiE8FNIaCo3DEHHzsR8PGo=;
        b=oV8oGFlaboeOtsf1bkL+L0QDnlWiYRc3GfvIGFqu8mlUuGhNIpirD5M9UhY85StT5o
         azL8R229bFsPcHzwLB72Q0bvDEwQkm4iTYB9xwTCvs5FnHuLjd2Eg1wTXMwI+zDu0Ra8
         scmA0/m7SPs1P2ua3WY7nrIwCXAoo5cAT1LNSXxyA6j85Zih8qCUfGqmX2CjTeaFQHBO
         rc+oAQ38RuOG5QPFcfBBtbyH8lylHsEpqEIX/6CQa8Yb2crSbZ4lUdQX+gXBgW9hb8Cc
         guHnGtpWjLuTIdMxrBPTzTGyt6cXYCfdszmiIfqtI/jbLlzMgmTaomibKMEAJNE+q5QC
         i+vQ==
X-Gm-Message-State: AOJu0YzwEJaeupSdHmFzB+bW4FtY0T4klerKl9YUhL8sgwNi4yHPY7TO
	nuEJhYnlHTnQJxxcDTvm9XDpjJl1zgM=
X-Google-Smtp-Source: AGHT+IGD6UN3MOOerdMFLEmny4gzkak60wHqIVXKsA4NlWLNqw1UJj00i84usFlUQuEsQ45Qnt2ok92VRKM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9214:0:b0:5a7:bbdb:6b39 with SMTP id
 j20-20020a819214000000b005a7bbdb6b39mr350826ywg.3.1698878099514; Wed, 01 Nov
 2023 15:34:59 -0700 (PDT)
Date: Wed, 1 Nov 2023 15:34:58 -0700
In-Reply-To: <4ca2253d-276f-43c5-8e9f-0ded5d5b2779@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-18-seanjc@google.com>
 <7c0844d8-6f97-4904-a140-abeabeb552c1@intel.com> <ZUEML6oJXDCFJ9fg@google.com>
 <92ba7ddd-2bc8-4a8d-bd67-d6614b21914f@intel.com> <ZUJVfCkIYYFp5VwG@google.com>
 <CABgObfaw4Byuzj5J3k48jdwT0HCKXLJNiuaA9H8Dtg+GOq==Sw@mail.gmail.com>
 <ZUJ-cJfofk2d_I0B@google.com> <4ca2253d-276f-43c5-8e9f-0ded5d5b2779@redhat.com>
Message-ID: <ZULSkilO-tdgDGyT@google.com>
Subject: Re: [PATCH v13 17/35] KVM: Add transparent hugepage support for
 dedicated guest memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 01, 2023, Paolo Bonzini wrote:
> On 11/1/23 17:36, Sean Christopherson wrote:
> > > > "Allow" isn't perfect, e.g. I would much prefer a straight KVM_GUEST_MEMFD_USE_HUGEPAGES
> > > > or KVM_GUEST_MEMFD_HUGEPAGES flag, but I wanted the name to convey that KVM doesn't
> > > > (yet) guarantee hugepages.  I.e. KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is stronger than
> > > > a hint, but weaker than a requirement.  And if/when KVM supports a dedicated memory
> > > > pool of some kind, then we can add KVM_GUEST_MEMFD_REQUIRE_HUGEPAGE.
> > > I think that the current patch is fine, but I will adjust it to always
> > > allow the flag, and to make the size check even if !CONFIG_TRANSPARENT_HUGEPAGE.
> > > If hugepages are not guaranteed, and (theoretically) you could have no
> > > hugepage at all in the result, it's okay to get this result even if THP is not
> > > available in the kernel.
> > Can you post a fixup patch?  It's not clear to me exactly what behavior you intend
> > to end up with.
> 
> Sure, just this:
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 7d1a33c2ad42..34fd070e03d9 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -430,10 +430,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  {
>  	loff_t size = args->size;
>  	u64 flags = args->flags;
> -	u64 valid_flags = 0;
> -
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> -		valid_flags |= KVM_GUEST_MEMFD_ALLOW_HUGEPAGE;
> +	u64 valid_flags = KVM_GUEST_MEMFD_ALLOW_HUGEPAGE;
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
> @@ -441,11 +438,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	if (size < 0 || !PAGE_ALIGNED(size))
>  		return -EINVAL;
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	if ((flags & KVM_GUEST_MEMFD_ALLOW_HUGEPAGE) &&
>  	    !IS_ALIGNED(size, HPAGE_PMD_SIZE))
>  		return -EINVAL;
> -#endif

That won't work, HPAGE_PMD_SIZE is valid only for CONFIG_TRANSPARENT_HUGEPAGE=y.

#else /* CONFIG_TRANSPARENT_HUGEPAGE */
#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })

...

>  	return __kvm_gmem_create(kvm, size, flags);
>  }
> 
> Paolo
> 
