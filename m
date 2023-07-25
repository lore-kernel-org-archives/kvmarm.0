Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6306C23BF1
	for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 16:04:02 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-584139b6b03so19313527b3.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 09:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690301041; x=1690905841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JzfMU5Qs8JliFSPK4e1C5em4CWxZCGfzp6e2iymS9Yg=;
        b=dW59zwmrsLAamcGnirE6A1LfKT51T61DtWDAOhx4/cSvK3sOAiDmr+BlK4XiPthtzP
         CN9MlQi3HhBVcH71uuUqq+M14CfwGnGPEE/BpfevOBdEFKHG7J0iaICViLaRAky8BhEp
         HFcQ65KDccgqhPQn/ChYInnlcEfq7qr0Ma/Jgkr7SmWI+05vO/bEbUCWl8Rn7I2emovI
         UeVOyMZohBruEuz8fBipp3NgVzf/qbnB/hnqT0XX1CDCZ3KOl7DJQE2yXx50QpLL6+Az
         IlluRAj7yyIarMAgzXmFlQrKZdiqjqFyPfBBVM/tbJmItA4hkVu10uPsnU/tUYfyPMpN
         N63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690301041; x=1690905841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JzfMU5Qs8JliFSPK4e1C5em4CWxZCGfzp6e2iymS9Yg=;
        b=MqrsootF5J4xCmBz8FuefShWvyFi04lK+6V6UJD4U0BP+b/E9T+WIIQvM+UYbyeah/
         0vppsa/WLj7o2xJ4dwLs3otdjSetQ3JoOF0a4q8YeoFdMMX5PXXdll6tATrO/JkuSqLE
         6Iu77TpsYF6/e9n/vMRSig74uSIJ4rvdNMSNG+btev4NRWtJ17oLOyxVEPevtQ93Leob
         m8NrR8qkiCOdiq3eUetyJJv40wnm+VvdBqgl1OtukqEFTJb26L6vDsRK7maZVtRtnNV3
         5+LwreFM4mUxUE2enbnvlsRhKsYlwhgue8IQQudmHX9GQfE9B+62SoUYHpu08f/eyebp
         SfZg==
X-Gm-Message-State: ABy/qLZCP1t/WXdxDBtgARDrQSE2pYT03caDiSw4mjbQafYWccOoRwZn
	sOlXNgZIGu6uiEYr9MYVTCCWBpyCsRw=
X-Google-Smtp-Source: APBJJlH1niyzp4cjBeRls9BsaNe03YLK4iKuUQJEO3t7N9JW3OW9U+d5kcfXqA22KUPE/pwVy1vkIiRVphQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:46d4:0:b0:cf9:3564:33cc with SMTP id
 t203-20020a2546d4000000b00cf9356433ccmr81585yba.13.1690301041144; Tue, 25 Jul
 2023 09:04:01 -0700 (PDT)
Date: Tue, 25 Jul 2023 09:03:59 -0700
In-Reply-To: <DS0PR11MB637386533A4A10667BA6DF03DC03A@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-13-seanjc@google.com>
 <DS0PR11MB637386533A4A10667BA6DF03DC03A@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZL/yb4wL4Nhf9snZ@google.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 25, 2023, Wei W Wang wrote:
> On Wednesday, July 19, 2023 7:45 AM, Sean Christopherson wrote:
> > +int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order) {
> > +	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
> > +	struct kvm_gmem *gmem;
> > +	struct folio *folio;
> > +	struct page *page;
> > +	struct file *file;
> > +
> > +	file = kvm_gmem_get_file(slot);
> > +	if (!file)
> > +		return -EFAULT;
> > +
> > +	gmem = file->private_data;
> > +
> > +	if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) != slot)) {
> > +		fput(file);
> > +		return -EIO;
> > +	}
> > +
> > +	folio = kvm_gmem_get_folio(file_inode(file), index);
> > +	if (!folio) {
> > +		fput(file);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	page = folio_file_page(folio, index);
> > +
> > +	*pfn = page_to_pfn(page);
> > +	*max_order = compound_order(compound_head(page));
> 
> Maybe better to check if caller provided a buffer to get the max_order:
> if (max_order)
> 	*max_order = compound_order(compound_head(page));
> 
> This is what the previous version did (restrictedmem_get_page),
> so that callers who only want to get a pfn don't need to define
> an unused "order" param.

My preference would be to require @max_order.  I can kinda sorta see why a generic
implementation (restrictedmem) would make the param optional, but with gmem being
KVM-internal I think it makes sense to require the param.  Even if pKVM doesn't
_currently_ need/want the order of the backing allocation, presumably that's because
hugepage support is still on the TODO list, not because pKVM fundamentally doesn't
need to know the order of the backing allocation.
