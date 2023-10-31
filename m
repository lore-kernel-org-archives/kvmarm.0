Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41F45255
	for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="31K+uYgz"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9a5a3f2d4fso5398421276.3
        for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 07:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698761092; x=1699365892; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsemryN+7v+wOBolNu7Hy0wHrULeaB9eFsfVkGp1/e8=;
        b=31K+uYgzWFUwPzlVj/IRIh8hr6yVn6WmPfZh+7hEMGoLOcvZeHFmQj0Bf27dgRQA+b
         4d68BDW226VvIVbr/R6glrBBuoQwuddbSIMZT1XaDsxNAQt/6y/98YFcE+hPz2LG2fYk
         NJsmGm+T3SPQqLgXhTcW+MxDuCNQfmhme3meTMyalhS95KzFiWVCrEuuLb60hExNm7X/
         I/7RtZ9s4pQB/Nd6slVQUDIOJvWIMAy8SB6p+sDU0Z2kstplh30cy4BAGBie5fZpAfuO
         98a075NHP5yTEAEoCXwvZQvfrOeT1UWCgk0OF0PnKHyTNzlr20CHG0swzWqMfAnnj0Em
         ZHjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761092; x=1699365892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsemryN+7v+wOBolNu7Hy0wHrULeaB9eFsfVkGp1/e8=;
        b=JDHWL3mnXycSkn2Nneg2BCASvIb96IrLU8PYeGmaO2gm5W2+CDTDdGSMNpS1rVDiAT
         XmhGaNs3XgD7u+wt+bu7bLz5UslsACNyym+X+fI5jmqyojkOqGNJAyeyE+ymMbjcTN91
         S88ekykUhTvEvatcSN9aWcet1MZ5Gz8qAeJ2GYn0fvYE4GuK7luP5oNRsHQlbrwEjCQn
         KI+qs1l2DUhBoCC4QnzTQzZCKS9FSX79jZ75Lb7MiuHYJtIrHqXjfbvCaliqdQG5F+6J
         NR3Ysw4T3HJdYNTYyjnkfB5xO+o3hJ4Zh29qoprA23TwZ90/44Le0l9mik16go6s+4QJ
         T2+A==
X-Gm-Message-State: AOJu0YxCPn1D/dfkVFaSN9C7qLnBv6DsQ47mq0OvdZgS1C80aB7DdPCY
	7Behdw4zbBr3PqZE1jfISYjkr9Pb654=
X-Google-Smtp-Source: AGHT+IGMRYf422gsAhq04hJnKRMCzmHg+RO6tAl4JuMhPFGeve1lxsPBrReypZbUvK9g95iFN5O303NMZlw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:d9a:c3b8:4274 with SMTP id
 v3-20020a056902108300b00d9ac3b84274mr301710ybu.7.1698761092559; Tue, 31 Oct
 2023 07:04:52 -0700 (PDT)
Date: Tue, 31 Oct 2023 07:04:51 -0700
In-Reply-To: <2edd908a-9699-4d8e-9063-c655f1fc9712@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-9-seanjc@google.com>
 <2edd908a-9699-4d8e-9063-c655f1fc9712@intel.com>
Message-ID: <ZUEJg_rBf35NyCG3@google.com>
Subject: Re: [PATCH v13 08/35] KVM: Introduce KVM_SET_USER_MEMORY_REGION2
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
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Xiaoyao Li wrote:
> On 10/28/2023 2:21 AM, Sean Christopherson wrote:
> > Introduce a "version 2" of KVM_SET_USER_MEMORY_REGION so that additional
> > information can be supplied without setting userspace up to fail.  The
> > padding in the new kvm_userspace_memory_region2 structure will be used to
> > pass a file descriptor in addition to the userspace_addr, i.e. allow
> > userspace to point at a file descriptor and map memory into a guest that
> > is NOT mapped into host userspace.
> > 
> > Alternatively, KVM could simply add "struct kvm_userspace_memory_region2"
> > without a new ioctl(), but as Paolo pointed out, adding a new ioctl()
> > makes detection of bad flags a bit more robust, e.g. if the new fd field
> > is guarded only by a flag and not a new ioctl(), then a userspace bug
> > (setting a "bad" flag) would generate out-of-bounds access instead of an
> > -EINVAL error.
> > 
> > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   Documentation/virt/kvm/api.rst | 21 +++++++++++++++++++
> >   arch/x86/kvm/x86.c             |  2 +-
> >   include/linux/kvm_host.h       |  4 ++--
> >   include/uapi/linux/kvm.h       | 13 ++++++++++++
> >   virt/kvm/kvm_main.c            | 38 +++++++++++++++++++++++++++-------
> >   5 files changed, 67 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 21a7578142a1..ace984acc125 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6070,6 +6070,27 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
> >   interface. No error will be returned, but the resulting offset will not be
> >   applied.
> > +4.139 KVM_SET_USER_MEMORY_REGION2
> > +---------------------------------
> > +
> > +:Capability: KVM_CAP_USER_MEMORY2
> > +:Architectures: all
> > +:Type: vm ioctl
> > +:Parameters: struct kvm_userspace_memory_region2 (in)
> > +:Returns: 0 on success, -1 on error
> > +
> > +::
> > +
> > +  struct kvm_userspace_memory_region2 {
> > +	__u32 slot;
> > +	__u32 flags;
> > +	__u64 guest_phys_addr;
> > +	__u64 memory_size; /* bytes */
> > +	__u64 userspace_addr; /* start of the userspace allocated memory */
> 
> missing
> 
> 	__u64 pad[16];

I can't even copy+paste correctly :-(
