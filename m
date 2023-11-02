Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466A91D69C
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 16:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePyDCfOS"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1cc1682607eso9219505ad.1
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 09:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698941024; x=1699545824; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2iqXbuRKMyvTfyAi0R6oHncN26PfYTo3tctDI41vJWU=;
        b=ePyDCfOS9ww1QuylL8HY8IHPu/x1Bw906v2cMTJ0kCsunQvLorrehIKJEMAlehRPJ5
         wqhQxZ+1Sv7hgfFp3kggG1xFsA2HRW8P6Y/eDGOPGr3+KG29DB14O+ua+aMI+Y2KkjQw
         t0RShHgpCJXmqVOHjHyaF5BWBf+x/VzopW1yB5jHiLA4BYYwWu0vW/ob29dSyi0iZRZG
         Da3H/+3z1tXO0zNB0G3Nw/De4IXE8Jq/5C+WZC56IgQ8ubJd/DlFyj4VI0ZucYzg6mE6
         fjWWaqEshIbDCr9ZN6kAgc3O7E4Q9P8ueuaLeMZQUh2yRbXwaKhDK6XA9Kr+kdD3tzPn
         0naw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698941024; x=1699545824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2iqXbuRKMyvTfyAi0R6oHncN26PfYTo3tctDI41vJWU=;
        b=bpfOy0+c1LoJD3lJeMnGXP1wVZhQYBQUZ+sCIi92oUVap1eANL3JgMrZLqC82AuTu4
         xNlsx96T9bvNZGBx5K/AE/Fjh+lZsx9+1cna44KcGJnDIqVys2SYVgj0GsORT/NMwj32
         M5HJj5FOOzzHzzEvbDh/vakmYdYIIOrdfcSbDAHYcz2Ye5E0Cyebm9rJ+ByLqoVcIMQ5
         MwTAeS0PgvzSL3nlVUcb8lb0DXtSLAA5an+RdfQt+g1eeRILp3ZA5PDWlN33LZy3Qrvx
         mEziCUfxsj6pSNjHr37vBI5c3jh1SNmC9mi+vtWcKuG+vdtksKuY9wnMJyvxqNnZcmKj
         lmuA==
X-Gm-Message-State: AOJu0YygxSwxPmcak37IfwvVgU9KiLDLTHAr8Ih2YNZVfv6RMKeXR9iJ
	W7p3mIj9vurTXWQckD5lMizZ7Ufl7hY=
X-Google-Smtp-Source: AGHT+IFM1Nz2eAP9Xmws9JoQjAGGS19Q55KF/ifRxAflcrAzQHFBFIOS8V+26ERzfv1Lm5CG2bErCCPJO0Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1304:b0:1cc:2ffe:5a33 with SMTP id
 iy4-20020a170903130400b001cc2ffe5a33mr266680plb.8.1698941024519; Thu, 02 Nov
 2023 09:03:44 -0700 (PDT)
Date: Thu, 2 Nov 2023 09:03:42 -0700
In-Reply-To: <6642c379-1023-4716-904f-4bbf076744c2@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
 <ZUFGRyQEuWj4RJS0@google.com> <ZUFzZf-YmCRYP6qo@google.com>
 <CALzav=d9eXZfK=op7A=UftbpuPpUbxqV6CmkqqxxBNuNsUU4nw@mail.gmail.com> <6642c379-1023-4716-904f-4bbf076744c2@redhat.com>
Message-ID: <ZUPIXt1XzZrriswG@google.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>, 
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
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Paolo Bonzini wrote:
> On 10/31/23 23:39, David Matlack wrote:
> > > > Maybe can you sketch out how you see this proposal being extensible to
> > > > using guest_memfd for shared mappings?
> > > For in-place conversions, e.g. pKVM, no additional guest_memfd is needed.  What's
> > > missing there is the ability to (safely) mmap() guest_memfd, e.g. KVM needs to
> > > ensure there are no outstanding references when converting back to private.
> > > 
> > > For TDX/SNP, assuming we don't find a performant and robust way to do in-place
> > > conversions, a second fd+offset pair would be needed.
> > Is there a way to support non-in-place conversions within a single guest_memfd?
> 
> For TDX/SNP, you could have a hook from KVM_SET_MEMORY_ATTRIBUTES to guest
> memory.  The hook would invalidate now-private parts if they have a VMA,
> causing a SIGSEGV/EFAULT if the host touches them.
> 
> It would forbid mappings from multiple gfns to a single offset of the
> guest_memfd, because then the shared vs. private attribute would be tied to
> the offset.  This should not be a problem; for example, in the case of SNP,
> the RMP already requires a single mapping from host physical address to
> guest physical address.

I don't see how this can work.  It's not a M:1 scenario (where M is multiple gfns),
it's a 1:N scenario (wheren N is multiple offsets).  The *gfn* doesn't change on
a conversion, what needs to change to do non-in-place conversion is the pfn, which
is effectively the guest_memfd+offset pair.

So yes, we *could* support non-in-place conversions within a single guest_memfd,
but it would require a second offset, at which point it makes sense to add a
second file descriptor as well.  Userspace could still use a single guest_memfd
instance, i.e. pass in the same file descriptor but different offsets.
