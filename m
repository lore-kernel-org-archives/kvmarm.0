Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F283C3C28
	for <kvmarm@lists.linux.dev>; Sun,  5 Nov 2023 16:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qs3HRrP3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699201191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5S45DCFEET4FUlleAs+X25SSP8exRtkoxGaiIZR36AY=;
	b=Qs3HRrP3qIhpoKM72TcYby7LjkynOYF2uGUiYgOpf4cM1NTdPhrht9wGz/KnO3gBjJxfUq
	mza5kadjnoQ8KRXMz4halkRbOGmF7JZQRnmEXEipVlcbqxqYJs2bJ/KxI1kMpBJJetCEJF
	dDxtT0VknqS2ie5C9oxIB6gY14EdZkk=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-GOl83YtPPCezcSugDwzm3g-1; Sun, 05 Nov 2023 11:19:50 -0500
X-MC-Unique: GOl83YtPPCezcSugDwzm3g-1
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-4abf1f457c2so964371e0c.3
        for <kvmarm@lists.linux.dev>; Sun, 05 Nov 2023 08:19:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699201190; x=1699805990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5S45DCFEET4FUlleAs+X25SSP8exRtkoxGaiIZR36AY=;
        b=icsqxuccZdLfQXiTpxYkXj3F95gyeLYIrnq5B7xvSovXc/CitCp6x2WY/5tSOypa35
         fg5vmhg6uecztqbbxPz4RwI07Dg92vyVKWqwl5x7XoBYKIeN+/05008iQ3rCwm0mlnGI
         esHbRmg9W7wh0uv+SipIfDy3CElRu58YiB3SaXw1MUZv3Ml9Cmbup77ALKeemTumSzw7
         WNMkwZr1d/2z3DtakOM5UCKgYy9mwis70adYH/VTUvgN9+TZeHQ5mYGuD6BnANLSoGKX
         gYhD+Sgr+X9kIkNWV7Ck7Twj1Tp+r5WVLp4yCuTttQOFc14xjRrRLOt+bDzQOamVGF5r
         mhYA==
X-Gm-Message-State: AOJu0YwBGyABbfYkFzY4mtlSN0qCmDq5FQ47E8d2eS0USZVhsSzq4cn7
	F4DWZsRK+ERzct/RnYiG+NA7x6LwYmO4XKDE+G0Lcc8bDI20Ops3su3yeW6MVcBniRjutS/OFk9
	MESOg5JpNyh5KNJgCMGfGCewcVHQ1Fmew
X-Received: by 2002:a05:6102:4743:b0:45d:8f83:e10f with SMTP id ej3-20020a056102474300b0045d8f83e10fmr5351488vsb.4.1699201189797;
        Sun, 05 Nov 2023 08:19:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG9PY/ps/exIZhJtEiBPcrHL5I4MFvN3fWtoZJg4K/o1jMHEXmGlTLfpUZIUzDcxTZUf1dOb3c60KPU/ucxafo=
X-Received: by 2002:a05:6102:4743:b0:45d:8f83:e10f with SMTP id
 ej3-20020a056102474300b0045d8f83e10fmr5351461vsb.4.1699201189503; Sun, 05 Nov
 2023 08:19:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-21-seanjc@google.com>
 <ZUeSaAKRemlSRQpO@yilunxu-OptiPlex-7050>
In-Reply-To: <ZUeSaAKRemlSRQpO@yilunxu-OptiPlex-7050>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 5 Nov 2023 17:19:36 +0100
Message-ID: <CABgObfb1Wf2ptitGhJPM6VcmkCG9haMoQj2BsttjeoV=9F0O9Q@mail.gmail.com>
Subject: Re: [PATCH v13 20/35] KVM: x86/mmu: Handle page fault for private memory
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
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
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 5, 2023 at 2:04=E2=80=AFPM Xu Yilun <yilun.xu@linux.intel.com> =
wrote:
>
> > +static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> > +                                           struct kvm_page_fault *faul=
t)
> > +{
> > +     kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> > +                                   PAGE_SIZE, fault->write, fault->exe=
c,
> > +                                   fault->is_private);
> > +}
> > +
> > +static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> > +                                struct kvm_page_fault *fault)
> > +{
> > +     int max_order, r;
> > +
> > +     if (!kvm_slot_can_be_private(fault->slot)) {
> > +             kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > +             return -EFAULT;
> > +     }
> > +
> > +     r =3D kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault=
->pfn,
> > +                          &max_order);
> > +     if (r) {
> > +             kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > +             return r;
>
> Why report KVM_EXIT_MEMORY_FAULT here? even with a ret !=3D -EFAULT?

The cases are EFAULT, EHWPOISON (which can report
KVM_EXIT_MEMORY_FAULT) and ENOMEM. I think it's fine
that even -ENOMEM can return KVM_EXIT_MEMORY_FAULT,
and it doesn't violate the documentation.  The docs tell you "what
can you do if error if EFAULT or EHWPOISON?"; they don't
exclude that other errnos result in KVM_EXIT_MEMORY_FAULT,
it's just that you're not supposed to look at it

Paolo

