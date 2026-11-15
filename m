Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794764364;
	b=da2LrAfV1PbgiBtx41oIX07baUWoRqa/q82714v1Qf2+ZOOedDkoUg+f7fxgPEzFjJrd
	 T/L5LhnGTCK5jDwdV1uO9wZcoI5AnRFskpoKoO8IeOmymTOqt5M1eMxJFlALc35yvquR5
	 pVOhvzgPRGoXV5wm4qd6N7cciO4BT6Qp6GX/aB50p7iv66RFlTUGiBeEAa1LftIOCxsjO
	 PVPnFSnIukkDQ21xihX6GitWjhn5IQ53uc4ZflSrzcDo3mOeHOZiTFOeE6JzSsvZAhKSB
	 fc7YJqQOEdconYg/udtGDv2Kn8q+JbXkR+oZAt500Yox2suobpj16ojY9Q5VL+iAnkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794764364;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LuvMmI09I/yZkcgOAhuxB6XI4+QcFoSXXJuVeZFzzgs=;
	b=rSqJepcOQAuxIJtk4XW+8VJIyPltADMeKHPTNN6YyUNGyH4x/Gi4O96IAp17LCd0Oeah
	 9sFtlNeV/xe60oMzcDv2dTS7om0pXBgOVXXdiZb9Ae4oc8wwPmygWhRgL5CF2F6z5QjIi
	 7NAUoAenUsI1k5ZInCWeKEegypYBb7nSLWN/lQ/hpD4ebkqVvys5Zi4Bqhi2Hks6Eys5c
	 vgcWlp/O73IeLTttKXOv4Go1kq2VqQkgXyXn3BVHCuli4mN9iffDqeF250B928QTnkg1d
	 MZbiD2BkYTAR3OeAJOok7D2ap7BLUbhPOg1aXihEXeOtwoPdnM7Jour45FpBJ1ZB27A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b3Kdmzc6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA972606A31A;
	Sun, 15 Nov 2026 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b3Kdmzc6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A394A1F000C4;
	Sun, 15 Nov 2026 17:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794764364;
	bh=LuvMmI09I/yZkcgOAhuxB6XI4+QcFoSXXJuVeZFzzgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b3Kdmzc6zR6q5nTMEJclWpKxjsTP9FwKcjQ6sFBtEe5xoLu9qJ3i50GmOc5B1CkvX
	 c1kMrJw4q0qcpsIl0N/hXXvW+2McnXnOTPE8+W6jQxVPNrGJuONKHN93QErv5/3CJV
	 vISHCxyh/xuGazEgvKNhjg0MST+QnVNVfdZ57rqZAly759IX/47XSXDxl3ylzs023E
	 L8muKtVeMxSKoK5CtHTU2DkEqG6x+hf9wYETsjoxfFCWCcBB4J47qvljIHE+NNoyPq
	 uLcmqgjdOgghfHC5P+qQ4Ye3O2579I1aexcft9YfG4EwaYJPWkQ+rpvDGV1WnYXDhn
	 J35YsOgs06Vgg==
Date: Sun, 15 Nov 2026 19:39:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, robin.murphy@arm.com,
	maz@kernel.org, will@kernel.org,
	David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com,
	loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>,
	oupton@kernel.org, alex@shazbot.org, gle.com@google.com,
	pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block
 header
Message-ID: <avnuP7SWE2BdBFBL@kernel.org>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-3-tarunsahu@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110050202.529473-3-tarunsahu@google.com>

On Tue, Nov 10, 2026 at 05:01:45AM +0000, Tarun Sahu wrote:
> Subsystems using the KHO Serialization Blocks framework currently do
> not record the serialized entry size in the block header. The entry size
> is only known to individual callers, which must track and store it in an
> owning serialized data structure. If a newer source kernel adds fields
> to an entry, the changed entry size breaks the stride when an older
> target kernel iterates over blocks.
> 
> Add an entry_size field to struct kho_block_header_ser. On the outgoing
> side, record bs->entry_size into every block header during allocation.
> During restoration, derive the entry stride directly from the block
> header instead of relying on caller-supplied dimensions. The
> kho_block_set_init() interface remains unchanged. A zero entry size,
> or one that differs between blocks of a set, is rejected during
> restoration.
> 
> This change modifies the serialized layout of struct kho_block_header_ser

Imperative voice please.

> and shifts the offset of serialized entries within preserved blocks.
> Bump KHO_FDT_COMPATIBLE from kho-v4 to kho-v5 so that pre-v5 and post-v5
> kernels cleanly reject mismatched handover state during boot. Also
> update the stale compatible string example in the documentation.
> 
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/block.h          | 10 ++++----
>  include/linux/kho/abi/kexec_handover.h |  6 ++---
>  kernel/liveupdate/kho_block.c          | 32 +++++++++++++++++++++++---
>  3 files changed, 38 insertions(+), 10 deletions(-)
> 
> @@ -264,8 +274,21 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
>  	}
>  
>  	while (next_pa) {
> +		u64 capacity;
> +
>  		ser = phys_to_virt(next_pa);
> -		if (!ser->count || ser->count > bs->count_per_block) {
> +		if (!ser->entry_size || (entry_size && ser->entry_size != entry_size)) {
> +			pr_warn("Block contains invalid entry size: %llu\n",
> +				ser->entry_size);
> +			err = -EINVAL;
> +			goto err_destroy;
> +		}
> +		entry_size = ser->entry_size;
> +		bs->entry_size = entry_size;
> +		capacity = (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
> +		bs->count_per_block = capacity;

Nit: can't we just initialize bs->count_per_block directly and drop
'capacity' and the change of the following line?

We are not very strict with 80-chars limit in kho/luo anyway.

> +
> +		if (!ser->count || ser->count > capacity) {
>  			pr_warn("Block contains invalid entry count: %llu\n",
>  				ser->count);
>  			err = -EINVAL;

-- 
Sincerely yours,
Mike.
