Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7636C191
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:03:35 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bb982d2572so17187785ad.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690589015; x=1691193815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rJg9MbukUkeAf25VcBnSvGPEfaUIyqqF94QJU8orhSY=;
        b=Zp0GOXqU9vAtanM7byzLEY1ZTAuQCQrnfrak1thKcFFHMBCZO/N4KqKDBd5I3kJffW
         Vh8ovzLtMVpv7R9tgjnJuitRPz0iowTqbSccpqb9sCrit8s8jZkHgE3EKWmaz9/YJybN
         uhR+1LBQ/EGKFm12kofvmo1N8Or8Mhd5I9QIxgAZxJjUnAncn/OfNQ+xg9V9rSfFrTW5
         6+gyXWvxsDfod0XUAEoSS/aCS0HqakbjGuI1/I8BU2Uy6FDW2YJ6LrCVt60GU5GehRX5
         3Ug/sPFW2Iawha4cKCkpfEtG9Mwjo7aL2M8Rz65tztUDm7ObzFqkZ6ozvUAWJtziwaLO
         +gKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690589015; x=1691193815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rJg9MbukUkeAf25VcBnSvGPEfaUIyqqF94QJU8orhSY=;
        b=I9KXKurHqXJwbp+3Jhp+SMVHH++RA24ESTGLI1IWWz6h8GZDrphvPY9PH6MHkxSUru
         wCJGpxQK1WkV8JBntdeR2USyn/piRyDBViXK/qtzpySMaevH0ByFfpwzfy10nac1ECEK
         oYihbuBBpyKrRGSedwqS7Illc5mTauu7Sn8lU5MafF6GpxOivwVur8+hLeQi73hVSg05
         Pls18oIof3OENpdH2AnMvCr9Yxnzi6BIXkjHooiTlzaSAe91HS+WJku7a61dJs6dBjKJ
         +N6ThfAPohNGgwhlcRrmvsJQOIkwvmr9LSlMOJ8SYQkgSk1ueJHx3W9lZpQosdsTCIw/
         Mk8A==
X-Gm-Message-State: ABy/qLZBhYLIE9D5qoom3Dq+l66sp6/TlRpfWGp85yl9HG8AyK3CUzMK
	m/QR9pAy7gyhy5X1dldSpcAYsrShiZc=
X-Google-Smtp-Source: APBJJlGy4rMQGFiWHQC+IuRONPQH0HvvNAt7asJXiFk+bZ/uVjfNOjPYVgrOl+x+eQJGyA+j61wbqvGP0DI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c951:b0:1ae:6895:cb96 with SMTP id
 i17-20020a170902c95100b001ae6895cb96mr12864pla.5.1690589014804; Fri, 28 Jul
 2023 17:03:34 -0700 (PDT)
Date: Fri, 28 Jul 2023 17:03:33 -0700
In-Reply-To: <ZMOJgnyzzUNIx+Tn@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-7-seanjc@google.com>
 <ZMOJgnyzzUNIx+Tn@google.com>
Message-ID: <ZMRXVZYaJ9wojGtS@google.com>
Subject: Re: [RFC PATCH v11 06/29] KVM: Introduce KVM_SET_USER_MEMORY_REGION2
From: Sean Christopherson <seanjc@google.com>
To: Quentin Perret <qperret@google.com>
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
	David Hildenbrand <david@redhat.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 28, 2023, Quentin Perret wrote:
> On Tuesday 18 Jul 2023 at 16:44:49 (-0700), Sean Christopherson wrote:
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -95,6 +95,16 @@ struct kvm_userspace_memory_region {
> >  	__u64 userspace_addr; /* start of the userspace allocated memory */
> >  };
> >  
> > +/* for KVM_SET_USER_MEMORY_REGION2 */
> > +struct kvm_userspace_memory_region2 {
> > +	__u32 slot;
> > +	__u32 flags;
> > +	__u64 guest_phys_addr;
> > +	__u64 memory_size;
> > +	__u64 userspace_addr;
> > +	__u64 pad[16];
> 
> Should we replace that pad[16] with:
> 
> 	__u64 size;
> 
> where 'size' is the size of the structure as seen by userspace? This is
> used in other UAPIs (see struct sched_attr for example) and is a bit
> more robust for future extensions (e.g. an 'old' kernel can correctly
> reject a newer version of the struct with additional fields it doesn't
> know about if that makes sense, etc).

"flags" serves that purpose, i.e. allows userspace to opt-in to having KVM actually
consume what is currently just padding.

The padding is there mainly to simplify kernel/KVM code, e.g. the number of bytes
that KVM needs to copy in is static.

But now that I think more on this, I don't know why we didn't just unconditionally
bump the size of kvm_userspace_memory_region.  We tried to play games with unions
and overlays, but that was a mess[*].

KVM would need to do multiple uaccess reads, but that's not a big deal.  Am I
missing something, or did past us just get too clever and miss the obvious solution?

[*] https://lkml.kernel.org/r/Y7xrtf9FCuYRYm1q%40google.com
