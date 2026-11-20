Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795191070;
	b=Y4vEZlK/PhLcutyFqQ8NULR0zOaqEgg/Gwb8++gU23IW86C2OlZ0hsf+/L4ozZ7DFL8T
	 UtHEGojp8qKqOMTZRNyNzjuDG0hRV+hcaY4uwd5qSfhHwmQPTRNFPXBxjSzaqkigaDuTi
	 zWlvIQxJosXOa9YkbGDFadQy9qYNh4o60Rn2pqfCoY9e/tKkbgo8EXSvTydEZXzYv+GCR
	 /KVRKGYp2+wf4tLiS2dyYTFYuBLRQpwkWV6Bk/7J9+8Jc/MERcpl6oQgyxujTaqdfA+7Z
	 E4Asi2e8lMxkUQ8FdMVB3WyYPM/QEEJhBNowD3aAVlHkyjOXqDCthZLSA/EJIYiPt3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=ZFb+S8Es0NvUmNBR5T6fgVNGrRH2yKZK48f5XbLVIEc=;
	b=P2p5kzauUHLuxrumgWE+zbud/Uupj72MsNvf8MJ2y4QKAsPtN95gcU7IJXLexI4FtrR/
	 bQttkJmfTPNtPgVsmynltZX+/Gn3Y97WPpAXsSh6kYU1FzFQ+GaqBPDXLxPdtiXyxUvx6
	 2lPRq0uH86bY/n/F/O4P4+aXRRkvQ3z0He9KLTzXHJ5lKuqIUkSTXcYIGrUqzWU/WyxZu
	 2GtNJbydq5LYEDKZJYC8e6U6e9+QsjkjYb8h3tTpJR+7g1mMU6TiOsZ0BXpWUkFMYKvwY
	 PPWmznkCcR/j13O3xYp12J1sWa1cAnq/PeXAKiuG67uKOdwoonkIaqKAlHW0qqSUs5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H/VuAI5B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AC3606A325;
	Fri, 20 Nov 2026 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H/VuAI5B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A251F000C6;
	Fri, 20 Nov 2026 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795191069;
	bh=ZFb+S8Es0NvUmNBR5T6fgVNGrRH2yKZK48f5XbLVIEc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=H/VuAI5BtuQwQd0zk9hcNYwSPn6N63WihBmZ3f6agPjw5j6X4nhjl+xkuBInj2K3G
	 pOag/mfhsLJCuDBPE43lBZguYkWm5Q0XnOYHt8I9NqdQ+atTKMgFYlb1IaF+jtQGld
	 3sUfi6lcLYmIyXlLtnVutUfX01YNRwxTD426bjxP/ztOBKmBROpGn/s6ksznIb2w4q
	 Au1te+hWzLmOyeSjczvD2gxa37Gi2iRY6JeY1uNgS+FOo6aHN7HdwWzWJ76IhqubZC
	 I7wV52HU+JBPo3Q8L36yOGgOyjynFxkC/8obE8WBrvul2HbGE4EceWsI1QomsynUz+
	 KVYj1KF0dneuA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  robin.murphy@arm.com,  maz@kernel.org,
  will@kernel.org,  David Matlack <dmatlack@google.com>,  Alexander Graf
 <graf@amazon.com>,  seanjc@google.com,  jgg@nvidia.com,
  loganodell@google.com,  arnd@arndb.de,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  Bjorn Helgaas <bhelgaas@google.com>,
  oupton@kernel.org,  alex@shazbot.org,  gle.com@google.com,
  pbonzini@redhat.com,  Andrew Morton <akpm@linux-foundation.org>,
  kevin.tian@intel.com,  joro@8bytes.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  Pratyush Yadav <pratyush@kernel.org>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  iommu@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org,  skhawaja@google.com,
  sagis@google.com,  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block
 header
In-Reply-To: <20261110050202.529473-3-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:01:45 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-3-tarunsahu@google.com>
Date: Fri, 20 Nov 2026 16:11:01 +0000
Message-ID: <2vxz8q2n1o16.fsf@kernel.org>
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

On Tue, Nov 10 2026, Tarun Sahu wrote:

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

Yeah, I agree with David here. It makes little sense to have callers
pass in the entry size only to have it ignored (or, only used for
rejection). It would be much better to use the recorded entry size and
hand it over to callers.

>
> This change modifies the serialized layout of struct kho_block_header_ser
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
> diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> index 36bdbaf9b3b8..a40b0906c821 100644
> --- a/include/linux/kho/abi/block.h
> +++ b/include/linux/kho/abi/block.h
> @@ -40,9 +40,10 @@
>  
>  /**
>   * struct kho_block_header_ser - Header for the serialized data block.
> - * @next:  Physical address of the next struct kho_block_header_ser.
> - * @count: The number of entries that immediately follow this header in the
> - *         memory block.
> + * @next:       Physical address of the next struct kho_block_header_ser.
> + * @count:      The number of entries that immediately follow this header in the
> + *              memory block.
> + * @entry_size: The size in bytes of each serialized entry in the block.
>   *
>   * This structure is located at the beginning of a block of physical memory
>   * preserved across a kexec. It provides the necessary metadata to interpret
> @@ -51,9 +52,10 @@
>  struct kho_block_header_ser {
>  	u64 next;
>  	u64 count;
> +	u64 entry_size;

I think this is the wrong place to put this. This header goes before
each block, so it should only hold metadata _for this block_, not for
the whole data structure. Because if you do that, you end up having the
field present in each block, but only the first block is special and the
value is only valid there. The feature header coming later makes this
problem worse.

I think we should follow down the lines of kho_vmalloc and have a
out-of-band structure that describes the whole block set, and then each
block only holds metadata relevant to it.

So this would look like:

	struct kho_block_ser {
		DECLARE_KHOSER_PTR(first, struct kho_block_header_ser *);
		u64 entry_size;
		/* Other things like flags, size, etc... */
	};

[...]

-- 
Regards,
Pratyush Yadav
