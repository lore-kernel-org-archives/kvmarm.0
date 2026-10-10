Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4635F379C23;
	Sat, 10 Oct 2026 07:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791617788; cv=none; b=Yy4pTwyLBz1WoZ24UcJMCMHei6Tbjei4d7Zmgau1zzcBrtdCLXitBw5/iEwGPbfH6xUcn33RDsTReSJBRodZHDJtL/m33zT0C5+cbzHesplY9C5vzMRyUq9KuvSL8QLW3TyDyrRPDycffzXWiQ8PWAjkMSe/BBJVbRBrY/0NzMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791617788; c=relaxed/simple;
	bh=4ko9gSj+vxgBtEJWFjbBisBasVf3lndbjG7WDoYLcn4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=D5I0rc97HVDeTKyClYObvvdQ6vwGbokclXCQLXY4X/y+ZQynOoYSBVqU6LAwFly2sqH0PBKmBuJGMsLFZmXH2Hir91qxZiCaqQ9vAec44RIx7S/O90NByIBF0Hm1UtYmcXwdwKX54bNhP/VHkBFao+SJUwJhUKwXdHLTY+hlUXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O1scjIDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1scjIDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F321F000FF;
	Sat, 10 Oct 2026 07:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791617786;
	bh=lvHacGZHOil6n8X8TWo3a/lv5iJ2YDY90NDrBy/yA4U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=O1scjIDh9Idq26MCPYxo0nalUPgIQV8jPHjj9EAukOJzrIDI+14xcWHlQyw+RQW+z
	 c7bfG0uCWt+vPb6LQbz83ilcKuAN5wvPqekwmSW/kUbYPHVXoZV+KlJYXQjZTB81Cd
	 VxJqf2JFBOtbzVjZ6kkqAF7Dde+UtRdu4nMX+IrjnQrHWWwBN0ZbwR7o5StsVqvnKd
	 ReygXOyiuezuAqNAnHRGyM99QlGFGSNZttQJtO1GHCBElzQxgme2m+vwsQ9rz5XRWx
	 5hiOXKqAE2c85h3nDndjJe1iif63W9teMNiLmh+O8rOw6WU6umu3Kx2kzmp/rr7N7n
	 V56r/87rFYK1A==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Fred Griffoul <griffoul@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
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
	Shuah Khan <shuah@kernel.org>
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
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
Date: Sat, 10 Oct 2026 13:06:09 +0530
Message-ID: <yq5ald8680t2.fsf@kernel.org>
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
> Some drivers manage RAM outside the page allocator: a carve-out, device
> memory, or memory that a host component moves between VMs while they
> run. This memory often has no struct page. The driver wants to lend
> pages to a VM and to its devices, and to take any of them back later.
>
> David Woodhouse's series "KVM: Allow alternative providers of
> guest_memfd backed by PFNMAP memory" lets such a driver back a
> guest_memfd through struct kvm_gmem_ops:
>
>   https://lore.kernel.org/kvm/20260720111259.122911-1-dwmw2@infradead.org/
>
> That covers the guest, but not the VM's devices, which his cover
> letter left as an open question. This series adds a small interface in
> mm: the driver that owns the memory becomes a provider, and the code
> that maps it attaches as a consumer. There are two consumers, a
> guest_memfd backend and IOMMU_IOAS_MAP_FILE in iommufd.
>
> The series is on top of David's v2 (base 0e35b9b6ec0f). Patch 1 was
> part of the earlier dma-buf RFC. The provider backend depends on it, so
> this series carries it.
>


I have been working on something similar for confidential computing use
cases. There is likely some overlap between this series and what I posted
at [1].

I have not reviewed this series in detail yet, but I will compare the two
approaches and identify what can be shared between the use cases. Please
let me know how you would like to proceed.

[1] https://lore.kernel.org/all/20261010072504.536230-1-aneesh.kumar@kernel.org/

-aneesh
