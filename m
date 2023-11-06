Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7CC29410
	for <kvmarm@lists.linux.dev>; Mon,  6 Nov 2023 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UXCJg3lc"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5a7cf717bacso63996087b3.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Nov 2023 08:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699287183; x=1699891983; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mmoUoGnC/t23H3IPxV2qsT2AAyd7sUSE5gGiJgJlDX0=;
        b=UXCJg3lcanXOaYeYVVAmkTmeP0DzJqG5oCkb4fxfBKoiGoIsWD+qTVXwcxunnQxOgP
         vhCMTPTBSPzQXhlBK+XqKpLrLtAAh8a1oCW3EA6k4M17PhyIkPlaD4Anibzlhql4jtIa
         JmQXJNAr41LAnzF5OHW8hcnAU/4XCSYyHG+N+tNl6qtk1EWz/SJXwRbl051+/qRjwem+
         uNtcjtm53hEUnxTaemR2LDJj34EQGNhutbGJXTUfKhsqJkTegZRVZeb8TA4H+m94WMwM
         IcqYwGh+jiCAWzGGFQjja0ytcH+o9UG9ZzF3xAxkXOe5mBRS2St4oH6BmDnKeSK1thXp
         NWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699287183; x=1699891983;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mmoUoGnC/t23H3IPxV2qsT2AAyd7sUSE5gGiJgJlDX0=;
        b=bM6pj9Xsw0U/BJzvRaAk19wo8OJ3a58tm+th8pPs0VFron6o9yLS3e0lNfo72Nk2cO
         WQqDlOX5rUgK1khqVz2ZcMD/N2ZzqZ3k7K1R4XUKhdB7+v0Yb51+JVyIWTZXIKNH4xT8
         TYc6VQL6eELmfW0zosSfIQvoctqb0AnqOBQhdq8E2gu8Djw1AG0Md1rpCZkzHIfT91Xx
         yVPUXvWwe1HOdL/3wJ4DCNNJb43I9elDc/+v2TX7bL3BOViPvjqiQ22GsMegGBFtiN+Z
         Xrdh3isCyQ0p+DPG5XJPr+PnSSW0nVaL9Sw1130KUg9herqUfSdYoyDge5uTz6ZA1AJi
         03Iw==
X-Gm-Message-State: AOJu0Yyvi5ZtCCeMa8rknORKk4vDgyFpIb9Rk1P3WRCuaUQ3v/L21R5M
	06GYmUgnSHqUIq/lYaHA541NVfvYbPE=
X-Google-Smtp-Source: AGHT+IEuz2kxbbqGFRlRrYjmJAAmCd5YL62xYCCumvx9nTcHzja2SicRUTSCOZ5GtJw0RknzXE1Az5YHDFw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d5d2:0:b0:5a7:ad67:b4b6 with SMTP id
 x201-20020a0dd5d2000000b005a7ad67b4b6mr228755ywd.2.1699287183068; Mon, 06 Nov
 2023 08:13:03 -0800 (PST)
Date: Mon, 6 Nov 2023 08:13:01 -0800
In-Reply-To: <CA+EHjTxy6TWM3oBG0Q6v5090XTrs+M8_m5=6Z2E1P-HyTkrGWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-26-pbonzini@redhat.com>
 <CA+EHjTxy6TWM3oBG0Q6v5090XTrs+M8_m5=6Z2E1P-HyTkrGWg@mail.gmail.com>
Message-ID: <ZUkQjW-yMnLfD7XW@google.com>
Subject: Re: [PATCH 25/34] KVM: selftests: Add helpers to convert guest memory
 b/w private and shared
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
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
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 06, 2023, Fuad Tabba wrote:
> On Sun, Nov 5, 2023 at 4:34=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
> > +void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t=
 size,
> > +                           bool punch_hole)
> > +{
> > +       const int mode =3D FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_F=
L_PUNCH_HOLE : 0);
> > +       struct userspace_mem_region *region;
> > +       uint64_t end =3D base + size;
> > +       uint64_t gpa, len;
> > +       off_t fd_offset;
> > +       int ret;
> > +
> > +       for (gpa =3D base; gpa < end; gpa +=3D len) {
> > +               uint64_t offset;
> > +
> > +               region =3D userspace_mem_region_find(vm, gpa, gpa);
> > +               TEST_ASSERT(region && region->region.flags & KVM_MEM_GU=
EST_MEMFD,
> > +                           "Private memory region not found for GPA 0x=
%lx", gpa);
> > +
> > +               offset =3D (gpa - region->region.guest_phys_addr);
>=20
> nit: why the parentheses?

I simply forgot to remove them when I changed the function to support spann=
ing
multiple memslots, i.e. when the code went from this

	fd_offset =3D region->region.gmem_offset +
		    (gpa - region->region.guest_phys_addr);

to what you see above.
