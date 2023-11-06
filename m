Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4311F18644
	for <kvmarm@lists.linux.dev>; Mon,  6 Nov 2023 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rf2uFFOE"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-da04fb79246so5346037276.2
        for <kvmarm@lists.linux.dev>; Mon, 06 Nov 2023 07:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699286165; x=1699890965; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2j2Mtk4lW9HEtWavGEnwteIJF5J/7dhiq9rSq3IBx+E=;
        b=rf2uFFOEtGGoI2uihU7Ol0wutKNpy1S3GWc4ey9SLXO/fljr88MMZsEHnjCiS6eGpB
         AFEKusIFDGh4qGhGbQYa4/UVWaCbWCxhaf61XOy0ezkEWd8+/mvGXtAIUSOIIYUbsUAr
         rExxTIedKoRXBfNlRcIW2N6jFrr227wdrFktmcWOm4r9FLBiUios/dBNHXEDt0Sa9ssR
         DewAn/fDw+FXPngS5b4oi/GQY1BHI4BCxlZrSEdvk4ArOlzy0zWn4MLgt9+PT7UdYr2J
         gO89g354joqELOzaqZZSWgS9pnicDJLPOPl4MF5ho7w+2IoqCff94GxPs1/CJuqL8iVp
         UQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699286165; x=1699890965;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2j2Mtk4lW9HEtWavGEnwteIJF5J/7dhiq9rSq3IBx+E=;
        b=oKY44KGDxVhE+M+vRSyW9FAMEHzhCnM3pdAGenGIU7Uwp0sFhoQkKTI/i9sCBd014b
         EIILd4a7//7Itejb2DfuStnOAe+ju3Ecy5WCrUgjFqDOYoVHnZr1ZWEqC2eNIGyNAaw4
         QniH+DQfgqihHO1653BkiRsvH5s4EkVtEPY9w/+jd9AMfBGgXgbKS18NxEzZPVavYL34
         xn5PH/+Ffh5uUDRVJsID73bFqUoHKwEyaCfcQ4bWeYkOjUugM7W75sLczWNliWlefCRk
         7HNuJxGTuVkwMqP78oRo3MJIBpCpgsEhnqMyPFD+Lp0VndAxXyKT9W4QLk0Y3a4vD1p9
         LQ7A==
X-Gm-Message-State: AOJu0YxxgFMwa7a0eK8cbV4CGIZSA99W3doY0aQUWolKHtWeKWqjUD6+
	C0IMAEp5ZWmTkus2K6OAMJHxH/xL34k=
X-Google-Smtp-Source: AGHT+IERk2b/M7d3G4J3vDGzrJ+T8jAsirv4bBIzvQT8OzuTMUe5AwPvC/SZu8YyGY6aMLoBT08jDOLmS/Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:d9a:c3b8:4274 with SMTP id
 v3-20020a056902108300b00d9ac3b84274mr683795ybu.7.1699286165114; Mon, 06 Nov
 2023 07:56:05 -0800 (PST)
Date: Mon, 6 Nov 2023 07:56:03 -0800
In-Reply-To: <ZUjqJjz0Epf7ii8F@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-21-seanjc@google.com>
 <ZUeSaAKRemlSRQpO@yilunxu-OptiPlex-7050> <CABgObfb1Wf2ptitGhJPM6VcmkCG9haMoQj2BsttjeoV=9F0O9Q@mail.gmail.com>
 <ZUjqJjz0Epf7ii8F@yilunxu-OptiPlex-7050>
Message-ID: <ZUkMk6b6vZe2ANkK@google.com>
Subject: Re: [PATCH v13 20/35] KVM: x86/mmu: Handle page fault for private memory
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
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
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 06, 2023, Xu Yilun wrote:
> On Sun, Nov 05, 2023 at 05:19:36PM +0100, Paolo Bonzini wrote:
> > On Sun, Nov 5, 2023 at 2:04=E2=80=AFPM Xu Yilun <yilun.xu@linux.intel.c=
om> wrote:
> > >
> > > > +static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcp=
u,
> > > > +                                           struct kvm_page_fault *=
fault)
> > > > +{
> > > > +     kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> > > > +                                   PAGE_SIZE, fault->write, fault-=
>exec,
> > > > +                                   fault->is_private);
> > > > +}
> > > > +
> > > > +static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> > > > +                                struct kvm_page_fault *fault)
> > > > +{
> > > > +     int max_order, r;
> > > > +
> > > > +     if (!kvm_slot_can_be_private(fault->slot)) {
> > > > +             kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > > > +             return -EFAULT;
> > > > +     }
> > > > +
> > > > +     r =3D kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &f=
ault->pfn,
> > > > +                          &max_order);
> > > > +     if (r) {
> > > > +             kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > > > +             return r;
> > >
> > > Why report KVM_EXIT_MEMORY_FAULT here? even with a ret !=3D -EFAULT?
> >=20
> > The cases are EFAULT, EHWPOISON (which can report
> > KVM_EXIT_MEMORY_FAULT) and ENOMEM. I think it's fine
> > that even -ENOMEM can return KVM_EXIT_MEMORY_FAULT,
> > and it doesn't violate the documentation.  The docs tell you "what
> > can you do if error if EFAULT or EHWPOISON?"; they don't
> > exclude that other errnos result in KVM_EXIT_MEMORY_FAULT,
> > it's just that you're not supposed to look at it
>=20
> Thanks, it's OK for ENOMEM + KVM_EXIT_MEMORY_FAULT.
>=20
> Another concern is, now 3 places to report EFAULT + KVM_EXIT_MEMORY_FAULT=
:
>=20
>   if (!kvm_slot_can_be_private(fault->slot)) {
> 	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> 	return -EFAULT;
>   }
>=20
>   file =3D kvm_gmem_get_file(slot);
>   if (!file)
> 	return -EFAULT;
>=20
>   if (fault->is_private !=3D kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> 	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> 	return -EFAULT;
>   }
>=20
> They are different cases, and seems userspace should handle them
> differently, but not enough information to distinguish them.

For the first, the memory_fault exit will inform userspace that the guest w=
ants
to map memory as private, and userspace will see that the memslot isn't con=
figured
to support private mappings.  Userspace may not even need to query memslots=
, e.g.
if the gfn in question has been enumerated to the guest as something that c=
an only
be mapped shared.

For the second (no valid guest_memfd file), userspace put the last referenc=
e to
the guest_memfd file without informing the guest or creating a memslot.  Th=
at's
firmly a userspace bug.

For the third and last, userspace will see that the guest is requesting a p=
rivate
mapping but the gfn is configured for shared mappings.

In all cases, userspace has the necessary information to resolve the issue,=
 where
"resolving the issue" may mean terminating the guest.  If userspace isn't t=
racking
memslots or the private attribute, then userspace has far bigger problems.
