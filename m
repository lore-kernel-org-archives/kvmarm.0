Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D57466B75;
	Fri, 16 Oct 2026 09:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792141980; cv=none; b=GII0as2LoigkeiFIYS8wvVNyoWXiucGWMlOO4YFQnqNE1X9S5p/qDVEEGD68qx4fn1OOw1OBx876MAnjPiqLqqw/lqv36NII3ngAccO8I9R6GgUreivn9O964KhKJrJR4N/pW/CuqxjNvm27WuapxcLBMl+OzeDiPHKGLzDed2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792141980; c=relaxed/simple;
	bh=tIkUz86ONiXurGzEfoccU/KpLb0S8j0MPoniAWV3O6g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GnVkQeEEB/p/+LvubBv9QBasF5gmHpD6H4ahByto5LJV85+G+Irj+LIyeij3Rct5dyB6CUKQhezQf+oNloLPO/wHY/nSiwQlFHEK/msudYr0iCU8aJPY+xttO4Ri4qzO+R68O/C0fpAUbZiwYWtwh23dEwduv+MaRuIOY4yJK6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYZgl/L4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYZgl/L4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521BE1F000C4;
	Fri, 16 Oct 2026 09:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792141979;
	bh=mQH+kXpKSTymGia/uumXbgT78aV2agpPTvM0izIRqhE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LYZgl/L47fPO8Aq+OVvp5UAIfE6hgsH5zIh9oJrQPyGOyzlbTMZ+sEC6Ba2iivygG
	 TkPuULqc5Ixpat8F42Z/hB853dD7BfPLHituatCT9QtBtX37bYoB2UITBUScGPZJTv
	 /usSd5kkvMwdNHq8GlE8NVjVR68AUrk8rBGTbLTczFneKEc+Vlra2BuBzIxoldvSJD
	 5k/PrxNtsyWoMGyB7jwmq/3ALOfJ2jyscwflYFHeck2tVFD/wKAmWKx5Sd0GuFkzRm
	 5Nais/Vmmp4nMWPIYN3Q5NTbSyK91tqJb4EB8JS7BrO04489Jub9pYLLW9dhx6IUPi
	 ELIJk5iqbinsA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Fred Griffoul <griffoul@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/11] mm: Memory providers for guest_memfd and
 iommufd
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
Date: Fri, 16 Oct 2026 14:42:40 +0530
Message-ID: <yq5a4iem57qv.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Fred Griffoul <griffoul@gmail.com> writes:

> From: Fred Griffoul <fgriffo@amazon.co.uk>
>

 [ ... 24 lines skipped ... ] 

>
> Why a new interface
> ===================
>
> kvm_gmem_ops gives KVM a way in. For devices, the only option today is
> a dma-buf plus a private call that iommufd looks up with symbol_get(),
> which is how vfio-pci works. Each new owner would need another such
> lookup, and iommufd would end up knowing each owner by name. With a
> common interface, a provider module only calls into mm, and nothing
> needs symbol_get().
>
> It also means the provider revokes a range once. The VMM hands the
> same file to KVM and to iommufd; on a revoke the core forwards it to
> every consumer, so KVM clears the range from stage-2, iommufd from the
> IOMMU page tables, and guest_memfd from the VMM's own mapping, all
> before the revoke returns.
>

What confused me was the introduction of memory providers as a subsystem
in their own. What we really need is the ability to map PFNs from
other subsystems into KVM stage-2 and into subsystems such as iommufd?.

Restricting the scope to the above, at least initially, would make this
much easier to reason about.

For my use case, the VFIO fd becomes the backing provider (referred to
as backend below). We can create a guest_memfd using that
resource_fd, allowing MMIO BAR ranges to be mapped into KVM stage-2.

Another feature provided by this series is the ability to map the same
range into iommufd. We probably want to restrict this to shared ranges.
It may be simpler for guest_memfd to drive this. The resulting
relationship would be:

+-----------------------+
| VFIO PCI BAR backing  |
+-----------------------+
            |
            | guest_memfd_backing_ops
            | Supplies BAR PFNs
            v
+------------------------------------------+
| guest_memfd                              |
|                                          |
| Controls shared/private state            |
| Exports shared, accessible PFNs          |
| Revokes consumer mappings when needed    |
+------------------------------------------+
            |
            | mem_provider_ops
            | IOAS_MAP_FILE(fd = guest_memfd)
            v
+-----------------------+
| IOMMUFD               |
|                       |
| Creates and refreshes |
| IOMMU DMA mappings    |
+-----------------------+
            |
            v
      Device DMA access


Another capability the memory-provider interface could provide is
kernel-initiated IOAS mapping, for example by allowing a guest_memfd fd
to be used with IOAS_MAP_FILE.

Currently, a private-to-shared conversion causes a VM exit, followed by
an IOAS_MAP for the newly shared range. Could using guest_memfd with
IOAS_MAP_FILE avoid this?

Perhaps the series could be rearranged as follows:

- Allow a guest_memfd fd to be used with IOAS_MAP_FILE.
- Add a VFIO or other backend for guest_memfd, without calling it a provider.
- Add support for guest_memfd to provide guest PFNs to other subsystems
  through its file descriptor.

Would this work?

-aneesh
