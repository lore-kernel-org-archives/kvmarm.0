Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DF7E57F
	for <kvmarm@lists.linux.dev>; Wed, 26 Jul 2023 15:59:56 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d064a458dd5so4628181276.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Jul 2023 08:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690387195; x=1690991995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x1RCz9AGh0t/+COzjYLcha5fkSMq/GNrC4CuEfgGTfc=;
        b=ypSxifbz+3xr2TyQi3H8IoM4jyz7RGQWDnGcHi1NC0Po8RTEHh8icWGPEeM5z47awl
         loHCPZy4rtZMbUI9RqdI0QLfF+ad98/C7r2wxAa7ZpGCgkUVuuHTSwwJ1OUjNqHnXY8X
         84BBat8mly4SBV0f6KqsOvHk8cSJA6wdZ1HsQOFr2IirR9RtsavVXkabaGLdXW2RSaSS
         UJmT6LqQAsULk7Nz99DvDaEAqSJ5Xa6WPtogY6EBxsD6vOblRb8mRKx+BIAVyZOlnkaE
         pEMJT5wcLP195pWDDcCypB4wv+dW/iWZkWl4YuLww/x6MLh6go/yMgsbLUu6B2dDA/yw
         w4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690387195; x=1690991995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x1RCz9AGh0t/+COzjYLcha5fkSMq/GNrC4CuEfgGTfc=;
        b=jtr+m6J0hTMxvx6fNjug10XBehB4SKGRdzIhEtySnuU7F/fGMR05pkjdWpMueIwNNh
         u0/kOuqG3ua+rLewnByk/yEsP5QMu5+xQanxmxJ87QrQ+uy6HefS3MWSQ4qwNEaRgbQc
         LNGwYuZaFxcZZoEWpZDe3s3GJgjT0SG+YG6lbfaBjUKYepnCAb8BNYG+D4ioeH1HM5t1
         yZBQFgLm/E34swLDXKGe1u2ByXobPSPq8+TT5ZNbFWDy0XHNvDm8QwpDMqYahdExx9mD
         3XuxTG1uA+Yjo9jkbkPoVC/BmDcExb+5lVhENdoezJK3dsitoTW+tL5SRh+c4Y+VHKT6
         XLCQ==
X-Gm-Message-State: ABy/qLbodSW/6N2fPwSR6V4QzVvDJZgpy3hpYR6RKYSkB53vZWPkRCUD
	1xGQKNO2z2uV/CJ6MU9BkpcK6sJr7SI=
X-Google-Smtp-Source: APBJJlE6mP/UcpH4lPNK9j4UUpMqMy7oSio4zbtJsZXhMStHU1Br/fIarHdKjyAaokfpTf45S20N2ryKLpo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:99c8:0:b0:d1c:e102:95a5 with SMTP id
 q8-20020a2599c8000000b00d1ce10295a5mr15014ybo.7.1690387195164; Wed, 26 Jul
 2023 08:59:55 -0700 (PDT)
Date: Wed, 26 Jul 2023 08:59:53 -0700
In-Reply-To: <ZL4BiQWihfrD0TOJ@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-9-seanjc@google.com>
 <ZL4BiQWihfrD0TOJ@yilunxu-OptiPlex-7050>
Message-ID: <ZMFC+V6Llv1JWLEt@google.com>
Subject: Re: [RFC PATCH v11 08/29] KVM: Introduce per-page memory attributes
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Vlastimil Babka <vbabka@suse.cz>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 24, 2023, Xu Yilun wrote:
> On 2023-07-18 at 16:44:51 -0700, Sean Christopherson wrote:
> > @@ -1346,6 +1350,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
> >  		kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
> >  		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
> >  	}
> > +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> > +	xa_destroy(&kvm->mem_attr_array);
> > +#endif
> 
> Is it better to make the destruction in reverse order from the creation?

Yeah.  It _shoudn't_ matter, but there's no reason not keep things tidy and
consistent.

> To put xa_destroy(&kvm->mem_attr_array) after cleanup_srcu_struct(&kvm->srcu),
> or put xa_init(&kvm->mem_attr_array) after init_srcu_struct(&kvm->irq_srcu).

The former, because init_srcu_struct() can fail (allocates memory), whereas
xa_init() is a "pure" initialization routine.

> >  	cleanup_srcu_struct(&kvm->irq_srcu);
> >  	cleanup_srcu_struct(&kvm->srcu);
> >  	kvm_arch_free_vm(kvm);
> > @@ -2346,6 +2353,145 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
> >  }
> >  #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
> 
> [...]
> 
> > +static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > +					   struct kvm_memory_attributes *attrs)
> > +{
> > +	gfn_t start, end;
> > +
> > +	/* flags is currently not used. */
> > +	if (attrs->flags)
> > +		return -EINVAL;
> > +	if (attrs->attributes & ~kvm_supported_mem_attributes(kvm))
> > +		return -EINVAL;
> > +	if (attrs->size == 0 || attrs->address + attrs->size < attrs->address)
> > +		return -EINVAL;
> > +	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
> > +		return -EINVAL;
> > +
> > +	start = attrs->address >> PAGE_SHIFT;
> > +	end = (attrs->address + attrs->size - 1 + PAGE_SIZE) >> PAGE_SHIFT;
> 
> As the attrs->address/size are both garanteed to be non-zero, non-wrap
> and page aligned in prevous check. Is it OK to simplify the calculation,
> like:
> 
>   end = (attrs->address + attrs->size) >> PAGE_SHIFT;

Yes, that should work.

Chao, am I missing something?  Or did we just end up with unnecessarly convoluted
code as things evolved?

> > +
> > +	if (WARN_ON_ONCE(start == end))
> > +		return -EINVAL;
> 
> Also, is this check possible to be hit? Maybe remove it?

It should be impossible to, hence the WARN.  I added the check for two reasons:
(1) to help document that end is exclusive, and (2) to guard against future bugs.
