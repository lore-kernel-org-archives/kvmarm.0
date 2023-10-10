Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAC02FE35
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60153C433C8;
	Tue, 10 Oct 2023 17:19:17 +0000 (UTC)
Date: Tue, 10 Oct 2023 18:19:14 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	will@kernel.org, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] KVM: arm64: determine memory type from VMA
Message-ID: <ZSWHkvhutlnvVLUZ@arm.com>
References: <20230907181459.18145-1-ankita@nvidia.com>
 <20230907181459.18145-2-ankita@nvidia.com>
 <ZR7hKYU1Wj+VTqpO@arm.com>
 <20231005165458.GM682044@nvidia.com>
 <ZSVe0nb02S4kz5D2@arm.com>
 <20231010150502.GM3952@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010150502.GM3952@nvidia.com>

On Tue, Oct 10, 2023 at 12:05:02PM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 10, 2023 at 03:25:22PM +0100, Catalin Marinas wrote:
> > On Thu, Oct 05, 2023 at 01:54:58PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Oct 05, 2023 at 05:15:37PM +0100, Catalin Marinas wrote:
> > > > On Thu, Sep 07, 2023 at 11:14:58AM -0700, ankita@nvidia.com wrote:
> > > > > From: Ankit Agrawal <ankita@nvidia.com>
> > > > > Currently KVM determines if a VMA is pointing at IO memory by checking
> > > > > pfn_is_map_memory(). However, the MM already gives us a way to tell what
> > > > > kind of memory it is by inspecting the VMA.
> > > > 
> > > > Well, it doesn't. It tells us what attributes the user mapped that
> > > > memory with, not whether it's I/O memory or standard RAM.
> > > 
> > > There is VM_IO which is intended to be used for address space with
> > > side effects.
> > > 
> > > And there is VM_PFNMAP which is intended to be used for address space
> > > without struct page (IO or not)
> > > 
> > > And finally we have the pgprot bit which define the cachability.
> > > 
> > > Do you have a definition of IO memory that those three things don't
> > > cover?
> > > 
> > > I would propose that, for KVM's purpose, IO memory is marked with
> > > VM_IO or a non-cachable pgprot
> > > 
> > > And "standard RAM" is defined by a cachable pgprot. Linux never makes
> > > something that is VM_IO cachable.
> > 
> > I think we can safely set a stage 2 Normal NC for a vma with pgprot
> > other than MT_NORMAL or MT_NORMAL_TAGGED. But the other way around is
> > not that simple. Just because the VMM was allowed to map it as cacheable
> > does not mean that it supports all the CPU features. One example is MTE
> > where we can only guarantee that the RAM given to the OS at boot
> > supports tagged accesses. 
> 
> Is there a use case to supply the VMM with cachable memory that is not
> full featured? At least the vfio cases I am aware of do not actually
> want to do this and would probably like the arch to prevent these
> corner cases upfront.

The MTE case is the problematic one here. On a data access, the
interconnect shifts (right) the physical address and adds an offset. The
resulting address is used to access tags. Such shift+offset is
configured by firmware at boot and normally only covers the default
memory. If there's some memory on PCIe, it's very unlikely to be
covered and we can't tell whether it simply drops such tag accesses or
makes up some random address that may or may not hit an existing memory
or device.

We don't currently have a way to describe this in ACPI tables (there
were talks about describing special purpose memory, I lost track of the
progress) and the way MTE was first designed doesn't allow a hypervisor
to prevent the guest from generating a tagged access (other than mapping
the memory as non-cacheable at Stage 2). This has been fixed in newer
architecture versions but we haven't added Linux support for it yet (and
there's no hardware available either). AFAIK, there's no MTE support for
CXL-attached memory at the moment in the current interconnects, so
better not pretend it's general purpose memory that supports all the
features.

Other than preventing malicious guest behaviour, it depends what the VM
needs cacheable access for: some GPU memory that's only used for sharing
data and we don't need all features or general purpose memory that a VM
can use to run applications from etc. The former may not need all the
features (e.g. can skip exclusives) but the latter does.

We can probably work around the MTE case by only allowing cacheable
Stage 2 if MTE is disabled for the guest or FEAT_MTE_PERM is
implemented/supported (TBD when we'll add this). For the other cases, it
would be up to the VMM how it presents the mapping to the guest (device
pass-through or general purpose memory).

> > I've seen something similar in the past with
> > LSE atomics (or was it exclusives?) not being propagated. These don't
> > make the memory safe for a guest to use as general purpose RAM.
> 
> At least from a mm perspective, I think it is important that cachable
> struct pages are all the same and all interchangable. If the arch
> cannot provide this it should not allow the pgmap/memremap to succeed
> at all. Otherwise drivers using these new APIs are never going to work
> fully right..

Yes, for struct page backed memory, the current assumption is that all
are the same, support all CPU features. It's the PFN-based memory where
we don't have such guarantees.

> That leaves open the question of what to do with a cachable VM_PFNMAP,
> but if the arch can deal with the memremap issue then it seems like it
> can use the same logic when inspecting the VMA contents?

In the MTE case, memremap() never returns a Normal Tagged mapping and it
would not map it in user-space as PROT_MTE either. But if a page is not
mmap(PROT_MTE) (or VM_MTE in vma->flags) in the VMM, it doesn't mean the
guest should not be allowed to use MTE. Qemu for example doesn't map the
guest memory with mmap(PROT_MTE) since it doesn't have a need for it but
the guest can enable MTE independently (well, if enabled at the vCPU
level).

We have an additional flag, VM_MTE_ALLOWED, only set for mappings backed
by struct page. We could probe that in KVM and either fall back to
non-cacheable or allow cacheable if MTE is disable at the vCPU level.

-- 
Catalin
