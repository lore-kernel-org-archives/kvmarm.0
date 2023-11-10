Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BBA3A279
	for <kvmarm@lists.linux.dev>; Fri, 10 Nov 2023 18:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gzQtL+ol"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5b02ed0f886so31980697b3.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Nov 2023 10:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699640581; x=1700245381; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/u2JG0fndtvz5StB0AokXkOquj7NpP7M8gj3x0QBG2E=;
        b=gzQtL+olN6w2uF9qh8/Ogohu2Fmonu7sDqK1tx+y3YKwDexVExLPcl5QAz48YwkjX1
         Rdz5y7ZjHJbLBZaBx8D/4CMr9+7mkJWBcQVY7koFRnSetMbTDh/64gzRZ5bq9Cf8qSWE
         ETiE4jMDWM6XZHoMQWXLetibYp7yBUc+Y/0UWRBaxb7LuDxP8eOhxCceaFepoKRfeRrm
         XcBvjpnK7954nPk9LmRAMuJdSroajhW8TKbq5UfGIEpkixh7tMYuDnogJ128TwR1fdys
         4pUR4eI1vJphCCA8w8enCA6PPLXqE9o3eEPz6icGDtStTix2NP9lq9Q1KIfqGA+jN/9V
         SRkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699640581; x=1700245381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/u2JG0fndtvz5StB0AokXkOquj7NpP7M8gj3x0QBG2E=;
        b=P1JIpZt8+jxEa7jBeFZDHULfiwFzt3MrTHdROBi5n9YvESyVmFaxaH+zoB58pwepZr
         67JgN70qjco5kR5hn1RU8LJ82FVzGvAXLNoQkGXeqm4qbya0HUCYMSR4cf3GkUBvOIOv
         2QkApvk48kZz1M6le6T9/WNQfdIMpFgZXRm84yPXiutBlZmgVbL5wzH7HBZ4a7xSfBfR
         fGM7f5as6suZm5QqwuNcKNLLtHnMKg3JGfN1zdRYlqkwmN62gmAsp3AMp6AAMOIwUQPl
         ExbQJVMk3KDrvlAslPy7xU+si8kfr/WAMPEpBEXfRpO9qDxX+ZWPxZjnkwtbZqyu2uc7
         QF6w==
X-Gm-Message-State: AOJu0YyPmsU0IlUdiOi3qZ75nJMkvDN1/FFPJEewiYPqRwGyDMakjzeu
	juJ13LMdT4FqvN9Abp8FJuZN3Ia8QLU=
X-Google-Smtp-Source: AGHT+IFilgu1/Q1EZiEoL3sTFYKCQfnhtgAeMBBAfAGcs6DHfZF6Y3nZ5EepLJy80XYZ0ZRT2keQkzxRdJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ef0c:0:b0:5be:ae71:d70a with SMTP id
 o12-20020a81ef0c000000b005beae71d70amr242444ywm.4.1699640580898; Fri, 10 Nov
 2023 10:23:00 -0800 (PST)
Date: Fri, 10 Nov 2023 10:22:59 -0800
In-Reply-To: <956d8ee3-8b63-4a2d-b0c4-c0d3d74a0f6f@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-16-pbonzini@redhat.com>
 <956d8ee3-8b63-4a2d-b0c4-c0d3d74a0f6f@intel.com>
Message-ID: <ZU51A3U6E3aZXayC@google.com>
Subject: Re: [PATCH 15/34] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
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
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 10, 2023, Xiaoyao Li wrote:
> On 11/6/2023 12:30 AM, Paolo Bonzini wrote:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 68a144cb7dbc..a6de526c0426 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -589,8 +589,20 @@ struct kvm_memory_slot {
> >   	u32 flags;
> >   	short id;
> >   	u16 as_id;
> > +
> > +#ifdef CONFIG_KVM_PRIVATE_MEM
> > +	struct {
> > +		struct file __rcu *file;
> > +		pgoff_t pgoff;
> > +	} gmem;
> > +#endif
> >   };
> > +static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
> > +{
> > +	return slot && (slot->flags & KVM_MEM_GUEST_MEMFD);
> > +}
> > +
> 
> maybe we can move this block and ...
> 
> <snip>
> 
> > @@ -2355,6 +2379,30 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> >   					struct kvm_gfn_range *range);
> >   bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> >   					 struct kvm_gfn_range *range);
> > +
> > +static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
> > +	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> > +}
> > +#else
> > +static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	return false;
> > +}
> >   #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
> 
> this block to Patch 18?

It would work, but my vote is to keep them here to minimize the changes to common
KVM code in the x86 enabling.  It's not a strong preference though.  Of course,
at this point, fiddling with this sort of thing is probably a bad idea in terms
of landing guest_memfd.

> > @@ -4844,6 +4875,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> >   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> >   	case KVM_CAP_MEMORY_ATTRIBUTES:
> >   		return kvm_supported_mem_attributes(kvm);
> > +#endif
> > +#ifdef CONFIG_KVM_PRIVATE_MEM
> > +	case KVM_CAP_GUEST_MEMFD:
> > +		return !kvm || kvm_arch_has_private_mem(kvm);
> >   #endif
> >   	default:
> >   		break;
> > @@ -5277,6 +5312,18 @@ static long kvm_vm_ioctl(struct file *filp,
> >   	case KVM_GET_STATS_FD:
> >   		r = kvm_vm_ioctl_get_stats_fd(kvm);
> >   		break;
> > +#ifdef CONFIG_KVM_PRIVATE_MEM
> > +	case KVM_CREATE_GUEST_MEMFD: {
> > +		struct kvm_create_guest_memfd guest_memfd;
> 
> Do we need a guard of below?
> 
> 		r = -EINVAL;
> 		if (!kvm_arch_has_private_mem(kvm))
> 			goto out;

Argh, yeah, that's weird since KVM_CAP_GUEST_MEMFD says "not supported" if the
VM doesn't support private memory.

Enforcing that would break guest_memfd_test.c though.  And having to create a
"special" VM just to test basic guest_memfd functionality would be quite
annoying.

So my vote is to do:

	case KVM_CAP_GUEST_MEMFD:
		return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM);

There's no harm to KVM if userspace creates a file it can't use, and at some
point KVM will hopefully support guest_memfd irrespective of private memory.
