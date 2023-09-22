Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8066A3D969
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 14:30:40 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1c5b1e55d5eso17607985ad.3
        for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 07:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695393040; x=1695997840; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KA5pwz3/DRQHr6a2ee4M3bjnbEYA57TwsoBM67hI6zU=;
        b=OMyQFipCJiV6Xq/uU2WmtGADCGJ+6DZsUvfy2OaVpPGlxAPHSHX5WuKGG0v7kpHOiW
         K9U0apBB6+uwQdaCsBecpFM7sZD7KHM1u7UiqKp5/fshraSbS7eZwSiHEwmeb+g0dYxu
         XnkASUlffNWB9EJbh3hDst/eanc+EpPwEOjOm3hPXL7lveIDITm5SWl0fg3vyBeUVbde
         9m1iTZKN7ehhQ44oiJw9k9X9OCIpb7Z+Y8aiKRKukVOHjkx6j7GiBJPNWaiIhctY5xXB
         NaDA4vN3TrE3BXAGeqlPVsQN7fWKLf99jIX1ISF83gmmCb+bdOOceASVLjByneaJCUHN
         LdOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695393040; x=1695997840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KA5pwz3/DRQHr6a2ee4M3bjnbEYA57TwsoBM67hI6zU=;
        b=i9R8nm2q2GygFgo3oSW6GVdlX3MsuPInaJQF2lA6Y8SBjU0ntrQGSjQ9Yu99JEUN0J
         u3OiiJs7q9sKw0v+BO3H9hVU+dKoFfZkHJ5655XKaWFiZVWRIN4CXdcYxtcckXpfPfBH
         mDyqIlYjZd/qzUksRupRm30fe5BAAelcZY3F9ILIxtLy+vBjPYUm5saCOOwJM84Qeiun
         xXIDm0zBu56hMdmlOsZIgHbHyWY2hPEKQfqPhx2In8YE5Rchqa5hoIlRfa8V9Mc0s9y3
         3PJ+5KXO3FEWgK2h7M0ZMuX0DfJylOo3vw25veKjUz/13CaT8RfJUWuX5oe3KYVBVtYA
         3pzw==
X-Gm-Message-State: AOJu0Yync0Y+BNxgvxzyO2omETHsEVb0OXbgE77Fvc4ZTHmQHX21ZNQ/
	6Y0z4xQaIVV4jzfLxb3hapJhzrXoG0A=
X-Google-Smtp-Source: AGHT+IE7TdAMSox3QZ9i3XY42vmW+YqwJtHLDXCrkzOQDSyIHqr/K/m4w9DaaKuedrPKXRX2zXN/sfp+lRA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1cf:b0:1b9:df8f:888c with SMTP id
 e15-20020a17090301cf00b001b9df8f888cmr102903plh.8.1695393039713; Fri, 22 Sep
 2023 07:30:39 -0700 (PDT)
Date: Fri, 22 Sep 2023 07:30:38 -0700
In-Reply-To: <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com>
Message-ID: <ZQ2lDk3iOEz8NNg0@google.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
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
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 22, 2023, Xiaoyao Li wrote:
> On 9/14/2023 9:55 AM, Sean Christopherson wrote:
> > From: Chao Peng <chao.p.peng@linux.intel.com>
> > 
> > Add a new KVM exit type to allow userspace to handle memory faults that
> > KVM cannot resolve, but that userspace *may* be able to handle (without
> > terminating the guest).
> > 
> > KVM will initially use KVM_EXIT_MEMORY_FAULT to report implicit
> > conversions between private and shared memory.  With guest private memory,
> > there will be  two kind of memory conversions:
> > 
> >    - explicit conversion: happens when the guest explicitly calls into KVM
> >      to map a range (as private or shared)
> > 
> >    - implicit conversion: happens when the guest attempts to access a gfn
> >      that is configured in the "wrong" state (private vs. shared)
> > 
> > On x86 (first architecture to support guest private memory), explicit
> > conversions will be reported via KVM_EXIT_HYPERCALL+KVM_HC_MAP_GPA_RANGE,
> 
> side topic.
> 
> Do we expect to integrate TDVMCALL(MAPGPA) of TDX into KVM_HC_MAP_GPA_RANGE?

Yes, that's my expectation.

> > but reporting KVM_EXIT_HYPERCALL for implicit conversions is undesriable
> > as there is (obviously) no hypercall, and there is no guarantee that the
> > guest actually intends to convert between private and shared, i.e. what
> > KVM thinks is an implicit conversion "request" could actually be the
> > result of a guest code bug.
> > 
> > KVM_EXIT_MEMORY_FAULT will be used to report memory faults that appear to
> > be implicit conversions.
> > 
> > Place "struct memory_fault" in a second anonymous union so that filling
> > memory_fault doesn't clobber state from other yet-to-be-fulfilled exits,
> > and to provide additional information if KVM does NOT ultimately exit to
> > userspace with KVM_EXIT_MEMORY_FAULT, e.g. if KVM suppresses (or worse,
> > loses) the exit, as KVM often suppresses exits for memory failures that
> > occur when accessing paravirt data structures.  The initial usage for
> > private memory will be all-or-nothing, but other features such as the
> > proposed "userfault on missing mappings" support will use
> > KVM_EXIT_MEMORY_FAULT for potentially _all_ guest memory accesses, i.e.
> > will run afoul of KVM's various quirks.
> 
> So when exit reason is KVM_EXIT_MEMORY_FAULT, how can we tell which field in
> the first union is valid?
> 
> When exit reason is not KVM_EXIT_MEMORY_FAULT, how can we know the info in
> the second union run.memory is valid without a run.memory.valid field?

I'll respond to this separately with a trimmed Cc list.  I suspect this will be
a rather lengthy conversation, and it has almost nothing to do with guest_memfd.

> > +Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that it
> > +accompanies a return code of '-1', not '0'!  errno will always be set to EFAULT
> > +or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT, userspace should assume
> > +kvm_run.exit_reason is stale/undefined for all other error numbers.
> > +
> 
> Initially, this section is the copy of struct kvm_run and had comments for
> each field accordingly. Unfortunately, the consistence has not been well
> maintained during the new filed being added.
> 
> Do we expect to fix it?

AFAIK, no one is working on cleaning up this section of the docs, but as always,
patches are welcome :-)
