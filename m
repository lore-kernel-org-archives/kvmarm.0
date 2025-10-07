Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A576D2E1EE1
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759845503; cv=none; b=jCr7/iJAUnGh6UsZce0ds9B/udXvP6UQP+5FC44JrcvEHN1TsCOoUt7/dcBc3kxDzZxqeub18QfN1R6cyHMGTD1LuuB8iWEv7FvI+tpQoTO4/GwB/IRTr3+06PqFabMu2c5VkRHwFFkiLm7UdFU6r93/YTB8bc3lGhDarCx5ylU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759845503; c=relaxed/simple;
	bh=2p6sw/d5o9WykeyOnWT+2vs8b7uJ9tBZ8iAVCQgjDZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TZxQWBMJde0OuGMpwz93RWk4hHlA8t6/28jcahh2IR1NILdhL+nE7mLZuyeRx9Nw1zJOWOiPtfpD6hT4E/kiX3KwY/KB1hCWV/3oQ6d8bZdXgkCw4scZCammYvMvnNDjWerTWXsNX4zUNRcNO219m6nk+SiL6rt6YzWWWYfO8ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LsOTqgFQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LsOTqgFQ"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b631ba3d31eso794725a12.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 06:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759845500; x=1760450300; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4rlYUY99rqPM8GfD927WUvhieIqn1G/yd0+acs0pn14=;
        b=LsOTqgFQhqUjs6lrD403ftBr6dhTZsd4F99OhQFRoF9PC7DoFErapFwGK6uYIzRbjA
         VOaEOLUHS/Ov2qb8BTp9vfBfNJw0rASxQxWjSO26+YaHlIKHdBVePmqQ1wdRmHL9aVOb
         vcVD6rMkae+SzpVWoNFpTqw5Fuv2V+YSimLjKnIgwTD5jfWt+l6NhaVf1hdn0BaF5q5t
         iQwKq7bH9Lt0zOSsJyeUkjeTMBVHnD61m3Rs6JdRSPS4aLKTdBw72/Mk0pCK51vpOTBm
         V5nhjuvUVwNHwt6CTyykoyXN+uyonVkoiJmDDm6yfYJSTusxSHtMj6SV4tdX4QnhUgxb
         GS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759845500; x=1760450300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4rlYUY99rqPM8GfD927WUvhieIqn1G/yd0+acs0pn14=;
        b=gO0/ZVQBCgW2XHHi229bZo7OJVtlk1E+6/KDNxVLowoDiAGCc8ZiDvkMuy7SEhco14
         2zVYl51/FvkFLkRriYGNeW/cm1E72Zop40QpEVJtjvX3o+ESfDTIG68eRarc/5YkH1g6
         rabkGsVZP7fsgIXB1O4pPXzkfzD6kSO4e7a13CaiFtMCOSJxxVhYBkt98tr91OPPR5qM
         R8JApme6gbmN7rz1Tc3MC5f0qPpVoCd6CKQxMT7FrfxGEEeKlviX2SXnxDDMHnDjmtIt
         hUWBJ9f0QcRDEap9sUfEMmijx7wSOk4AJbCLrTV6UHMHiy+AFUtZy3plkAGpdLPXsIjf
         kbtw==
X-Forwarded-Encrypted: i=1; AJvYcCUYItpfhl0GD8v8BaeCB9Z3wh2NL85rZH9zDNvtjg0ZsY7ggFLBXriC056VuAqCdmIekHiT32E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx15bfO/Eu4F2PMUXB5bus9NVwhAb12tXiQq1Wmjlkj8ff2yn01
	MMtOiXbQDRIc83D0ketWKOqJgnU4KUhweexTYsjC6J1NYHmLgTzIKmmRpYE5hIGXW6g6/TRx8t6
	rWD1sVw==
X-Google-Smtp-Source: AGHT+IH44LYFtR2Z9aj26aSM38dj+lWGcrky74kzzSLe1xZuZzZCEhZOyIjquiME0rIkS/AaVEe3J4tloO4=
X-Received: from pjbmw12.prod.google.com ([2002:a17:90b:4d0c:b0:329:b272:45a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c05:b0:335:2823:3686
 with SMTP id 98e67ed59e1d1-339c274089dmr20831446a91.2.1759845499915; Tue, 07
 Oct 2025 06:58:19 -0700 (PDT)
Date: Tue, 7 Oct 2025 06:58:18 -0700
In-Reply-To: <fc0bb268-07b7-41ef-9a82-791d381f56ac@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-16-pbonzini@redhat.com>
 <fc0bb268-07b7-41ef-9a82-791d381f56ac@amazon.com>
Message-ID: <aOUceqlAnsjQ8mo4@google.com>
Subject: Re: [PATCH 15/34] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
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
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 03, 2025, Nikita Kalyazin wrote:
> On 05/11/2023 16:30, Paolo Bonzini wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Introduce an ioctl(), KVM_CREATE_GUEST_MEMFD, to allow creating file-based
> > memory that is tied to a specific KVM virtual machine and whose primary
> > purpose is to serve guest memory.
> 
> ...
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index f1a575d39b3b..8f46d757a2c5 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> 
> ...
> 
> > -static int check_memory_region_flags(const struct kvm_userspace_memory_region2 *mem)
> > +static int check_memory_region_flags(struct kvm *kvm,
> > +				     const struct kvm_userspace_memory_region2 *mem)
> >   {
> >   	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
> > +	if (kvm_arch_has_private_mem(kvm))
> > +		valid_flags |= KVM_MEM_GUEST_MEMFD;
> > +
> > +	/* Dirty logging private memory is not currently supported. */
> > +	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> > +		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> 
> I was wondering whether this restriction is still required at this stage or
> can be lifted in cases where the guest memory is accessible by the host.

Off the top of my head, I can't think of any reason why dirty logging wouldn't
work with guest_memfd for non-CoCo VMs.  We'd likely need to explicitly enumerate
support to userspace, and there might be some assumptions lurking in KVM, but
fundamentally it should Just Work (TM).

> Specifically, it would be useful to support differential memory snapshots
> based on dirty page tracking in Firecracker [1] or in live migration.  As an
> experiment, I removed the check and was able to produce a diff snapshot and
> restore a Firecracker VM from it.
> 
> [1] https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/snapshot-support.md#creating-diff-snapshots
> 
> > +
> >   #ifdef __KVM_HAVE_READONLY_MEM
> >   	valid_flags |= KVM_MEM_READONLY;
> >   #endif
> > @@ -2018,7 +2029,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >   	int as_id, id;
> >   	int r;
> > -	r = check_memory_region_flags(mem);
> > +	r = check_memory_region_flags(kvm, mem);
> >   	if (r)
> >   		return r;
