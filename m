Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E9C19BC4
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 16:24:11 +0000 (UTC)
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-63d48c3d242so24965876d6.2
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 09:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690820650; x=1691425450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3bBibAebd9TH21iCDO05hSEk2osKPAFkgUcjQOZN6IE=;
        b=Nxq6zpIl4t0T0IKgYCttihPgWkXDGg2v82UeoDRuJEPiuoZCcaCHDZLE9kkIxiKoGj
         jk+IsC1Guj9oI8nO++cnUqPSWZhSmAdBVc5lsM1hT0kSe4RC/KjMhhSc6wlqkqU2YaQ2
         MlzhwgMrC6YuHdeNmM0ceLnhR0bBMJIyRtICLHnduD/dx0KJOUH8SaivN46+P6VL/13o
         HD2+rdmaVCfzWB1fiLuejcoL89Z+FWgZTnHkXXYaDxZvnDyh2EIFMo2Vuj5jGb8JG448
         0UmR6aeSUdj4a9FGESdjj1akt6y1FHupeca6JLTCIL1tXPbyPZc4VruR8nQPmlFHhYMX
         m2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690820650; x=1691425450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3bBibAebd9TH21iCDO05hSEk2osKPAFkgUcjQOZN6IE=;
        b=CF6qobkMqs9JhHsXiKnVBCoE3JBOJ+QEMldJSsfy84tLEZFc7HqZjemuUilnmFkInD
         nbdNwbotDwUtm+o9bTOK+/nVbpfN2f+3qca6EWOpUR+RWxbFel66H7ePzuIu0hejv7rM
         PDDpHtheS9Zx2iVK3mw6O4PZ8ZrYsC0xghi0V7bU+9zRHYOTRgW8MhSba9naB2XcZGzW
         8NNp4FgID9gUb500EjjSYcx6t1pKVdBZyJh8w3MXeFUatKfbzxBwDS1iRLM9bo3WXfgz
         EL3kXw3NMlmXh+lyFvj2tm769Oi9/C3bDvY8U4zO2tpAt2IPVvbXHO1OsziVC4F+IAsc
         qf3w==
X-Gm-Message-State: ABy/qLa1TPEmUuox3J38pa56F+32RvNcikMVJ9rxHXHdCANc2+HrljSz
	ig9Oy8UTJfqEXUHF1tucBtdRgpbLfHtUVjT4XvS8GQ==
X-Google-Smtp-Source: APBJJlHREYUxXxwX9gGy7EcKK3cJKFiEBqZ2OxDI6ULebXBrqt9zCYKQ0hqOpLlGDOWyAd0KbYFFLQMR5e4GSI0P8JE=
X-Received: by 2002:a0c:ef0a:0:b0:63d:281d:d9cd with SMTP id
 t10-20020a0cef0a000000b0063d281dd9cdmr11195773qvr.57.1690820649949; Mon, 31
 Jul 2023 09:24:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-13-seanjc@google.com>
 <DS0PR11MB637386533A4A10667BA6DF03DC03A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZL/yb4wL4Nhf9snZ@google.com>
In-Reply-To: <ZL/yb4wL4Nhf9snZ@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 31 Jul 2023 17:23:33 +0100
Message-ID: <CA+EHjTwGoMgoTEktL9zq2190TMY=vU29xv+oQ7X2Eeu8c8AmjQ@mail.gmail.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
To: Sean Christopherson <seanjc@google.com>
Cc: Wei W Wang <wei.w.wang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Vlastimil Babka <vbabka@suse.cz>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On Tue, Jul 25, 2023 at 5:04=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jul 25, 2023, Wei W Wang wrote:
> > On Wednesday, July 19, 2023 7:45 AM, Sean Christopherson wrote:
> > > +int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > +                gfn_t gfn, kvm_pfn_t *pfn, int *max_order) {
> > > +   pgoff_t index =3D gfn - slot->base_gfn + slot->gmem.pgoff;
> > > +   struct kvm_gmem *gmem;
> > > +   struct folio *folio;
> > > +   struct page *page;
> > > +   struct file *file;
> > > +
> > > +   file =3D kvm_gmem_get_file(slot);
> > > +   if (!file)
> > > +           return -EFAULT;
> > > +
> > > +   gmem =3D file->private_data;
> > > +
> > > +   if (WARN_ON_ONCE(xa_load(&gmem->bindings, index) !=3D slot)) {
> > > +           fput(file);
> > > +           return -EIO;
> > > +   }
> > > +
> > > +   folio =3D kvm_gmem_get_folio(file_inode(file), index);
> > > +   if (!folio) {
> > > +           fput(file);
> > > +           return -ENOMEM;
> > > +   }
> > > +
> > > +   page =3D folio_file_page(folio, index);
> > > +
> > > +   *pfn =3D page_to_pfn(page);
> > > +   *max_order =3D compound_order(compound_head(page));
> >
> > Maybe better to check if caller provided a buffer to get the max_order:
> > if (max_order)
> >       *max_order =3D compound_order(compound_head(page));
> >
> > This is what the previous version did (restrictedmem_get_page),
> > so that callers who only want to get a pfn don't need to define
> > an unused "order" param.
>
> My preference would be to require @max_order.  I can kinda sorta see why =
a generic
> implementation (restrictedmem) would make the param optional, but with gm=
em being
> KVM-internal I think it makes sense to require the param.  Even if pKVM d=
oesn't
> _currently_ need/want the order of the backing allocation, presumably tha=
t's because
> hugepage support is still on the TODO list, not because pKVM fundamentall=
y doesn't
> need to know the order of the backing allocation.

You're right that with huge pages pKVM will eventually need to know
the order of the backing allocation, but there is at least one use
case where it doesn't, which I ran into in the previous ports as well
as this one. In pKVM (and in possibly other implementations), the host
needs to access (shared) guest memory that isn't mapped. For that,
I've used kvm_*_get_pfn(), only requiring the pfn, so get the page via
pfn_to_page().

Although it's not that big, my preference would be for max_order to be opti=
onal.

Thanks!
/fuad
