Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DA5126C10;
	Fri, 15 Nov 2024 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731687815; cv=none; b=tkQ93B8qppqR5sKsUMxTh5ApJNZxCJaC24WErY5yWUmK/8/az73oUwSov1E4RXDpqygXyrHXmlFUvpb2+rr40Z4ZuJXZiZZHXxKP2Rf71CXl9G58YKeWhzEmHHl7HHwVN6p0yBjDZEgdwbvdX2MepLnVJkszMzBlfT50QdWWRn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731687815; c=relaxed/simple;
	bh=DM27c+y+WOBeLHMhqrwMS7rn3rHMwv1YhipdWe80R8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KH5Ldu5lfT8eaxJOXguv+w/cqTJPtI2BvPlwaPY3nhl8om9A81A5UIYdRb4CDDj4/kXs+qoIXWwVZHwXSw46AcR6hBTAvYzUmW8W0xeGETULayuzuqKo5UOFoAg/jHPFDUwxu1NPuwbEtDZVWkOfs7H6Q/uECK3iD9Uc9UQbYhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745ABC4CED5;
	Fri, 15 Nov 2024 16:23:32 +0000 (UTC)
Date: Fri, 15 Nov 2024 16:23:30 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 4/4] arm64: mte: Use stage-2 NoTagAccess memory attribute
 if supported
Message-ID: <Zzd1giMm-bzUiZgA@arm.com>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
 <20241028094014.2596619-5-aneesh.kumar@kernel.org>
 <87o734ts4m.wl-maz@kernel.org>
 <yq5ar080cq5x.fsf@kernel.org>
 <87jzdst6os.wl-maz@kernel.org>
 <yq5a34k2rw9o.fsf@kernel.org>
 <86ldxozn3i.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ldxozn3i.wl-maz@kernel.org>

(joining the thread as well, though not sure I'm bringing anything new)

On Tue, Nov 12, 2024 at 11:51:45AM +0000, Marc Zyngier wrote:
> On Fri, 08 Nov 2024 07:59:31 +0000, Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
> > Marc Zyngier <maz@kernel.org> writes:
> > > On Mon, 28 Oct 2024 13:28:42 +0000, Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
> > >> Marc Zyngier <maz@kernel.org> writes:
> > >> > On Mon, 28 Oct 2024 09:40:14 +0000, "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
> > >> >> Currently, the kernel won't start a guest if the MTE feature is enabled
> > >> >> and the guest RAM is backed by memory which doesn't support access tags.
> > >> >> Update this such that the kernel uses the NoTagAccess memory attribute
> > >> >> while mapping pages from VMAs for which MTE is not allowed. The fault
> > >> >> from accessing the access tags with such pages is forwarded to VMM so
> > >> >> that VMM can decide to kill the guest or remap the pages so that
> > >> >> access tag storage is allowed.
> > >> >
> > >> > I only have questions here:
> > >> >
> > >> > - what is the benefit of such approach? why shouldn't that be the
> > >> >   kernel's job to fix it?
> > >>
> > >> IMHO leaving that policy decision to VMM makes the kernel changes
> > >> simpler. In most cases, VMM will kill the guest, because these
> > >> restrictions of MTE_ALLOWED are applied at the memslot/vma.
> > >
> > > Where is that captured? The whole idea behind FEAT_MTE_PERM was that
> > > it would be the hypervisor's task to lazily allocate MTE-capable
> > > memory as tagged-access would occur.
> > 
> > Lazily allocating MTE-capable memory requires changes to different
> > kernel subsystems and previous attempts got dropped [1] because it
> > was not clear whether the benefit of saving 3% memory overhead was worth
> > the complexity we add to the kernel.

I'd say the most complex part in Alex's approach was the need to reuse
the tag storage for classic data and kick the pages around when some
other page needs to store tags in there. That approach is pretty much
dead.

In theory, having MTE and non-MTE memory (heterogeneous) without a
carveout reuse would be a bit more manageable - not that far from the
NUMA migration and at least you only migrate the page being accessed
rather than unrelated ones where the tags need to go. But this was not
Alex's goal for Android since people were asking for the reuse of the 3%
carveout rather than a smaller carveout.

Other future deployments, CXL-attached memory etc. may benefit from a
new scheme but I wouldn't rush in implementing anything in the kernel
for now.

The VMM may be in a better position to manage such heterogeneous memory
for the guest if it knows the capabilities of the slots (e.g. some DAX
mmap() vs anonymous mmap()). This would require the VMM replacing a page
within a slot from one memory type to another (while preserving the
data). I don't think we have a concrete use-case yet to be worth the
hassle.

> That's not the point. Tagged memory doesn't have to cover the whole of
> physical memory, and it can be statically allocated. The architecture
> doesn't mandate that all of the memory is MTE-capable.

There's some vague wording that general purpose memory should be MTE
capable if FEAT_MTE2 or later is advertised. But that's not well defined
and one can have other types of memory in the physical space (e.g. CXL)
that don't support tags. Last time I looked we still haven't got a way
to describe memory capabilities in firmware.

For the time being, I think a real use-case for FEAT_MTE_PERM is in the
context of cacheable MMIO (there are some patches around from Nvidia to
do this with VFIO). That memory, if exposed to guest as WB and the guest
enables MTE, may trigger some SErrors. With FEAT_MTE_PERM KVM could trap
and inject a fault back into the guest - maybe SEA. Is it easier to do
this from KVM itself or we would rather exit to the VMM and let it
handle? The latter allows room for other fancier things in the future
but the former may be quicker, in the absence of other strong use-cases.

> > This patchset is not looking at that feature. Instead, it can be used to
> > enable MTE in configurations that currently won't allow MTE. One such
> > example is libkrun which includes linux kernel as firmware in a
> > dynamically linked library (libkrunfw). libkrun can insert the kernel
> > region which got mmaped as part of the library load, directly into the
> > guest memory map instead of copying the kernel. Such a guest config
> > can't enable MTE currently even though we will never use the newly
> > inserted memory regions as tag access memory.

I've never played with libkrunfw. Does it handle inserting a Linux
kernel? Such approach may not work well with MTE. The kernel frees the
init text/data sections back into the page allocator. With MTE
advertised as present, the guest will try to reuse that memory,
potentially as tagged. However, since the VMM mmap'ed the guest kernel
from a file, VM_MTE is not supported in the VMM address space. Even if
the mapping is MAP_PRIVATE and the page copied on write, the vma remains
the original one associated with the file, so VM_MTE_ALLOWED not set.

We could revisit this and allow mprotect(PROT_MTE) to force the CoW on
private file mappings but we'd need some strong requirement for this
(MTE+libkrunfw could be such thing if people need this combination).

> > Similarly, virtiofs dax support can use a page cache region as
> > virtio-shm region. We can use MTE_PERM to enable MTE in this config.
> 
> And this use case doesn't contradict what I am stating above. But it
> definitely contradicts what you wrote: "In most cases, VMM will kill
> the guest".

To simplify things, I think whatever is presented to the VM as standard
RAM (typically present at the VM boot) should either support MTE or MTE
will be disabled for the guest. For other types of memory, whether WB
MMIO or RAM presented as virtio-(pmem, shm etc.) backed by files in the
VMM, the VM should be aware it is not standard RAM and should not
attempt to enable MTE on it. If it does (either by mistake or malice),
FEAT_MTE_PERM should trap and inject a fault back into the guest (or
kill it altogether but for debugging, I'd rather inject a fault if
possible).

-- 
Catalin
