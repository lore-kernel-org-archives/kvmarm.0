Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D79C5684
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 19:33:09 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-26d1ec91c8aso3888868a91.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 12:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692646389; x=1693251189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lTUf23UWw1SkKKJ2TYgJ195zKcBZk+aHzDWYw0jOr4Q=;
        b=qpKSqx5ICliXSxPjZu0tOZy7xlqIAe6qVNImHFeHE99jDfjJ0rkalTo5f1yiylL8Zp
         zW/oM/ylnbuxciYR4prkKI8mJaHp2WuQufXKGB2RG8EjyX49+7sODEpJkoODIpJFN+WQ
         d92P7dg0Kdt0AwxXyEzQoriMz6/KeQrNijacO4IuCJVKS1YJTlTz834blo5E9EKqcgWL
         PEM2JeCl6oJE3F68JjqgLe5PECwZdFSwKXlISOg41aNDBtfUtUCqAE2x2tOPTF0xf31f
         3SefiEREMJ5D9AnExP5D9BLT2XJ6ZGgC24sHacNuUQH7uTJzB0bBXanlC1qACw6pUjbt
         /CMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692646389; x=1693251189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lTUf23UWw1SkKKJ2TYgJ195zKcBZk+aHzDWYw0jOr4Q=;
        b=jTp0ienNIepAC2rA5ZKkzqOQHrFAl+63GEnZR9QvswbLAqrG/3GIqR8w4VVtpM2088
         XZ6XxZ8/BYXNQgLW+TUcHL1Lw18HAPzH+wUsUO9nGUhNMPf2opgotUlMO37lpePat+ud
         3gWDN/nlCA4jNzcsd0Lcg2Alkqz7VNo8CpbmzWoCtSDlwqpq8qbkaNUSDr7xvQ5pXyGa
         Y5Mmq/TJkuWjXZguXf7f8hk3JvvaZwi7w45oFEFQTIlT7blnVu54Vl9ZsI3oVWLUwj9f
         Zl3MIfhxP/vKQ54xowmEjHABjQQy1NhRBd4eksFsJ5u3xMAIkqnV8Ne4cBeZytDlSiUR
         kSPg==
X-Gm-Message-State: AOJu0Yy4IZhPTBBHkTZt/AUVYxm93i1gXztpAArE2bISU8eyept5jjev
	QlINFXeDHPpd0fzrictFC+0SwsliAew=
X-Google-Smtp-Source: AGHT+IHapYFA1E8erMKTCUk5o1Pg5iPJ1NuCQ0fs2o2CFjrEymp3AKNMxkfs6EIdF0eDdCPrJxgkHXuIM1g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d90b:b0:26d:1212:7924 with SMTP id
 c11-20020a17090ad90b00b0026d12127924mr1918689pjv.4.1692646388708; Mon, 21 Aug
 2023 12:33:08 -0700 (PDT)
Date: Mon, 21 Aug 2023 12:33:07 -0700
In-Reply-To: <diqzzg2ktiao.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZNvaJ3igvcvTZ/8k@google.com> <diqzzg2ktiao.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <ZOO782YGRY0YMuPu@google.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	willy@infradead.org, akpm@linux-foundation.org, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.p.peng@linux.intel.com, tabba@google.com, jarkko@kernel.org, 
	yu.c.zhang@linux.intel.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	vbabka@suse.cz, david@redhat.com, qperret@google.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 21, 2023, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Aug 15, 2023, Ackerley Tng wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> > Nullifying the KVM pointer isn't sufficient, because without additional actions
> >> > userspace could extract data from a VM by deleting its memslots and then binding
> >> > the guest_memfd to an attacker controlled VM.  Or more likely with TDX and SNP,
> >> > induce badness by coercing KVM into mapping memory into a guest with the wrong
> >> > ASID/HKID.
> >> >
> >> > I can think of three ways to handle that:
> >> >
> >> >   (a) prevent a different VM from *ever* binding to the gmem instance
> >> >   (b) free/zero physical pages when unbinding
> >> >   (c) free/zero when binding to a different VM
> >> >
> >> > Option (a) is easy, but that pretty much defeats the purpose of decopuling
> >> > guest_memfd from a VM.
> >> >
> >> > Option (b) isn't hard to implement, but it screws up the lifecycle of the memory,
> >> > e.g. would require memory when a memslot is deleted.  That isn't necessarily a
> >> > deal-breaker, but it runs counter to how KVM memlots currently operate.  Memslots
> >> > are basically just weird page tables, e.g. deleting a memslot doesn't have any
> >> > impact on the underlying data in memory.  TDX throws a wrench in this as removing
> >> > a page from the Secure EPT is effectively destructive to the data (can't be mapped
> >> > back in to the VM without zeroing the data), but IMO that's an oddity with TDX and
> >> > not necessarily something we want to carry over to other VM types.
> >> >
> >> > There would also be performance implications (probably a non-issue in practice),
> >> > and weirdness if/when we get to sharing, linking and/or mmap()ing gmem.  E.g. what
> >> > should happen if the last memslot (binding) is deleted, but there outstanding userspace
> >> > mappings?
> >> >
> >> > Option (c) is better from a lifecycle perspective, but it adds its own flavor of
> >> > complexity, e.g. the performant way to reclaim TDX memory requires the TDMR
> >> > (effectively the VM pointer), and so a deferred relcaim doesn't really work for
> >> > TDX.  And I'm pretty sure it *can't* work for SNP, because RMP entries must not
> >> > outlive the VM; KVM can't reuse an ASID if there are pages assigned to that ASID
> >> > in the RMP, i.e. until all memory belonging to the VM has been fully freed.

...

> I agree with you that nulling the KVM pointer is insufficient to keep
> host userspace out of the TCB. Among the three options (a) preventing a
> different VM (HKID/ASID) from binding to the gmem instance, or zeroing
> the memory either (b) on unbinding, or (c) on binding to another VM
> (HKID/ASID),
> 
> (a) sounds like adding a check issued to TDX/SNP upon binding and this
>     check would just return OK for software-protected VMs (line of sight
>     to removing host userspace from TCB).
> 
> Or, we could go further for software-protected VMs and add tracking in
> the inode to prevent the same inode from being bound to different
> "HKID/ASID"s, perhaps like this:
> 
> + On first binding, store the KVM pointer in the inode - not file (but
>   not hold a refcount)
> + On rebinding, check that the KVM matches the pointer in the inode
> + On intra-host migration, update the KVM pointer in the inode to allow
>   binding to the new struct kvm
> 
> I think you meant associating the file with a struct kvm at creation
> time as an implementation for (a), but technically since the inode is
> the representation of memory, tracking of struct kvm should be with the
> inode instead of the file.
> 
> (b) You're right that this messes up the lifecycle of the memory and
>     wouldn't work with intra-host migration.
> 
> (c) sounds like doing the clearing on a check similar to that of (a)

Sort of, though it's much nastier, because it requires the "old" KVM instance to
be alive enough to support various operations.  I.e. we'd have to make stronger
guarantees about exactly when the handoff/transition could happen.

> If we track struct kvm with the inode, then I think (a), (b) and (c) can
> be independent of the refcounting method. What do you think?

No go.  Because again, the inode (physical memory) is coupled to the virtual machine
as a thing, not to a "struct kvm".  Or more concretely, the inode is coupled to an
ASID or an HKID, and there can be multiple "struct kvm" objects associated with a
single ASID.  And at some point in the future, I suspect we'll have multiple KVM
objects per HKID too.

The current SEV use case is for the migration helper, where two KVM objects share
a single ASID (the "real" VM and the helper).  I suspect TDX will end up with
similar behavior where helper "VMs" can use the HKID of the "real" VM.  For KVM,
that means multiple struct kvm objects being associated with a single HKID.

To prevent use-after-free, KVM "just" needs to ensure the helper instances can't
outlive the real instance, i.e. can't use the HKID/ASID after the owning virtual
machine has been destroyed.

To put it differently, "struct kvm" is a KVM software construct that _usually_,
but not always, is associated 1:1 with a virtual machine.

And FWIW, stashing the pointer without holding a reference would not be a complete
solution, because it couldn't guard against KVM reusing a pointer.  E.g. if a
struct kvm was unbound and then freed, KVM could reuse the same memory for a new
struct kvm, with a different ASID/HKID, and get a false negative on the rebinding
check.
