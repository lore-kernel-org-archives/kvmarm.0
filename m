Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710963;
	b=3Gbkcu+NxLyvr1D7sNH0FZZj3KD2m0ZaLqrIyQW5GQay9zf3wjGUw2MKtbOeW9FvueR/
	 uB2wEDr9thyC1e4Fbae23VhEgxOMugZmLkk2TbE0+dsqF6aaRybPUBVVQKYmVfMv+d3BR
	 lCCd/9hddgdAvMFocAqwnE4Tx9fUMdF3HRK7misUJHxNRqt/5rjcSIvVMR1/B0VXsrM8t
	 fyCoTYZSnzk9CpXdI73NrgPTOHJxffu7lWtYf4AwB0PX9Vb3Gc2I/owguGGyxIXNKaaNv
	 +4NfUpfxwRA6qvQKIvu13Nhqzs/xPMknk5uk9SLmh5QgItUMNXtB14fhE7ji/1mB71Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=ATJlsXEmgBegCpn5BwHudI3qqubv1tTP7fksevRvHqo=;
	b=4PZWqiRBnibhE5iMYhR+5eEeueBwZ859CdgR7Vgx/+yhkicWzbKjZCKSIrbZqE8I5Dty
	 m9qBrfNeTkzEuzC3tbSy+NkrchKzy6ZajjoF+h+t8HdQFGNGqLnfUskEPAFE3LL0njwxD
	 a6la+UiixZ72iUcYvqfBnv6VLyrD6eIgvrlt1PoQZm6h/wnMHxcaYwKV7ljXjFeE7Rtng
	 wVIY2n+Nznhe25Lej1C2hv3L1+ACiPKR65t5joFmnni96Ok9hFA4h1pVWnSC3nDfP7WzY
	 LxAnit5oYSRkgN17PgQZgJpZflmPL6ma9qjCk2V65hijBZp0cEZAYO/rhbxtHHCD+QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4YDuVLo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B532606A321;
	Thu, 26 Nov 2026 16:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4YDuVLo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBB51F000C0;
	Thu, 26 Nov 2026 16:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795710962;
	bh=ATJlsXEmgBegCpn5BwHudI3qqubv1tTP7fksevRvHqo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=P4YDuVLowB3qq6ykOWDZcHMLKiSKQ8CQtAy4yUDqIkd8odRAKualfMPxWHGSnkm+R
	 2PWj2HwPnluHX217yIVBnz4ltf8gud7DVpDIOVnWPvj2tmRtQDwkW5GrLyBPVwc1P2
	 H8DVFw6/ujmQyjdb8hK5mKWwhnS5tQTm/FrakhOc6yTOGs/qksPdzN8PYv8RMpUQw7
	 ulmxngnaHoudWBkL+v4xPagIwwh7UNMjhR3rRlw1bwVr1T+AnwXiCuZycThNIvKJJn
	 Anqy+ejek6aYvEhB9sE0PqvuZhyTpgFBZ7BDw7EvqPO1q3MBdMmd2U7pPYubVmNwfN
	 QLihl37EmKX6Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Matlack" <dmatlack@google.com>
Cc: "Pratyush Yadav" <pratyush@kernel.org>,  "Tarun Sahu"
 <tarunsahu@google.com>,  "Pasha Tatashin" <pasha.tatashin@soleen.com>,
  "Mike Rapoport" <rppt@kernel.org>,  <robin.murphy@arm.com>,
  <maz@kernel.org>,  <will@kernel.org>,  "Alexander Graf"
 <graf@amazon.com>,  <seanjc@google.com>,  <jgg@nvidia.com>,
  <loganodell@google.com>,  <arnd@arndb.de>,  <dwmw2@infradead.org>,
  <baolu.lu@linux.intel.com>,  "Bjorn Helgaas" <bhelgaas@google.com>,
  <oupton@kernel.org>,  <alex@shazbot.org>,  <gle.com@google.com>,
  <pbonzini@redhat.com>,  "Andrew Morton" <akpm@linux-foundation.org>,
  <kevin.tian@intel.com>,  <joro@8bytes.org>,  <kvmarm@lists.linux.dev>,
  <linux-pci@vger.kernel.org>,  <kexec@lists.infradead.org>,
  <kvm@vger.kernel.org>,  <iommu@lists.linux.dev>,
  <linux-arm-kernel@lists.infradead.org>,  <skhawaja@google.com>,
  <sagis@google.com>,  <linux-arch@vger.kernel.org>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
In-Reply-To: <DN4H5ST3X9L1.3IUEC1CA5QI8H@google.com> (David Matlack's message
	of "Wed, 25 Nov 2026 09:40:47 -0800")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-4-tarunsahu@google.com>
	<2vxz4idb1i2w.fsf@kernel.org> <DN3VG4JCILOO.YN40XHHSWRPH@google.com>
	<2vxzld6hx97g.fsf@kernel.org> <DN4H5ST3X9L1.3IUEC1CA5QI8H@google.com>
Date: Thu, 26 Nov 2026 16:35:54 +0000
Message-ID: <2vxzse0nwnx1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 25 2026, David Matlack wrote:

> On Wed Nov 25, 2026 at 6:43 AM PST, Pratyush Yadav wrote:
> [...]
>
>> So I wouldn't want to support slab until we have file handlers that
>> churn through a lot of preserved objects.
>
> Makes sense. If KHO slab isn't coming, then I'm fine with the arena.
>
> One thing I realized is that the choice between the two is visible to
> the incoming kernel. With separate allocations, the incoming kernel has
> to free struct kho_vmalloc and struct memfd_luo_ser separately. With
> the arena, it must only free the top-level allocation. So we should
> pick one now (while memfd is bumping its compatible string anyway)
> rather than switching later.
>
> Separate allocations leaves the door open to KHO slab but wastes memory
> in the short term. It's not obvious to me which direction to go :)

Separate allocations aren't any more flexible than arena allocations.
Even if you have separate allocations, you need to know how they were
allocated to be able to free them. If they came from slab, you need to
call kmem_cache_free(), if they came from kho_alloc_preserve(), you need
to call kho_restore_free().

So you need to store the information of their origin somewhere, probably
in a feature flag. Same goes for arena. If we ever want to move away
from arena, we'd have to use a feature flag.

So to me, I think they are about the same in flexibility. Using separate
allocations is a tiny bit easier, arena is a tiny bit more efficient.
Which is why I like arena mode.

-- 
Regards,
Pratyush Yadav
