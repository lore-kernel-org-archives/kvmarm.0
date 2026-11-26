Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795716296;
	b=XvcaJsetn6qmPB0+DDJyoVzeGW2Pb3X58qFO6+z6qIdBzmO2+JsHggLEruMSUshjxmzK
	 5aEgL1ofcjdbYyUVs70zLAxBZEADyhKfjE1dLsDCWA5pSbU7+/3HdPR5owI131BEcfZYf
	 2sf34X4D4mHB4uwr77edZfxDV5jUFfVq4qP1s5j+mX6DW/PFra6YtEf0igqMddRsnr5H9
	 NU3UMI718Fc9f7DXKFidJlWZZ9AU6nE8Mv99sFsSzyfPIfNq/4/2+pomvVbM0W9YEliP7
	 k+HCpsEj/MzUE3MpVzhS7/Uobn6nMPRDqtuB4+mVBpZzGxDhxpQddYvVBKuA7EOKpjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795716296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=wyeadx8A+qjGGKflAd6kjiHqlv7VopvbXaimXP38c3g=;
	b=Mr+K4op17/EH5OR87H4dZrQTeAK6pgMwrzd8KTisIwK05lFFQa0c2oMRJuROg7nZyJYB
	 eVxJ294wxHm5SvLeZoNkdoMoFH3SC+02kLouSLS4zdcr4uUWyisqT0/sTE+ViVmsuIUrr
	 3fhqxN+OkljLyiQPv4CfvyqKVO5VBficibWKs9aoPfYlRQL8bv+pXbUh+hqGPsr8lVIxZ
	 N651u2C8DpSm7/DpOWgj81pDHN8Hkd57Y4AlMQ5PhK+L3ukwHXVHg/YMA1B3NeLlNgtNF
	 yfaN5XN38AbyD7kvE0q+eVtwcfna7cWr2Tfasuv3dWLrHXaWT6r8RgJKHRBDCVwok1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EqS38396;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC1606A31C;
	Thu, 26 Nov 2026 18:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EqS38396
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1B81F000CA;
	Thu, 26 Nov 2026 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795716296;
	bh=wyeadx8A+qjGGKflAd6kjiHqlv7VopvbXaimXP38c3g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=EqS38396Z/iq27cU9pt1bZvkBZNs2vlZLiamVFn+y25C+t9ZVrIAPHvMUWzhklPNP
	 HFlsyNtm+f8t96tCn/siJCDZuV1XtDvPYjdJqVqKSpH7VFHyCh9f6uOi3Z9ejseiY4
	 yiA4CVErYDCkwKKlJKqm8i2Sa7AcFoY130mUzRzuiM+gnKIaLLWvpo800U8dbryzmU
	 Ie6ee1bcLsBZPAJVP+PhrLXv/FwN2eXOmuWWDguEbpYP1xOXMR4fwmkl6C5BmqrEfu
	 d4UA9FhkCeKKlVEZWBE+E/unDJ3VkCOcP+G9AxHsM5x6LxQMUSfXvO2ckf9/IBGfFo
	 /Y/pUt7+dSRtg==
From: Pratyush Yadav <pratyush@kernel.org>
To: tarunsahu@google.com
Cc: David Matlack <dmatlack@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,
  robin.murphy@arm.com,  maz@kernel.org,  will@kernel.org,  Alexander Graf
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
Subject: Re: [PATCH v4 08/19] kho: block: Add the feature header to blocks
In-Reply-To: <9huzse13pxhq.fsf@tarunix.c.googlers.com> (tarunsahu@google.com's
	message of "Sat, 14 Nov 2026 09:34:41 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-9-tarunsahu@google.com>
	<DMRP21FATCC0.ARAURXWV85JP@google.com>
	<9huzse13pxhq.fsf@tarunix.c.googlers.com>
Date: Thu, 26 Nov 2026 18:04:48 +0000
Message-ID: <2vxzcxrrwjsv.fsf@kernel.org>
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

On Sat, Nov 14 2026, tarunsahu@google.com wrote:

> "David Matlack" <dmatlack@google.com> writes:
>
>> On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
>>> Precede struct kho_block_header_ser with struct kho_ser_hdr using
>>> DECLARE_KHO_SER. Each block in a block set starts with struct
>>> kho_ser_hdr followed by struct kho_block_header_ser. Serialized entries
>>> start immediately after the header payload at offset fhdr->size.
>>
>> This adds a feature header to every block in the set, but the layout it
>> describes is a property of the whole set: all blocks are written by the
>> same kernel with the same header.
>>
>> Blocks are only ever added and removed at the tail, so the head block
>> is stable for the lifetime of the set. I'd put a single set-wide
>> header in the first block only, e.g. a struct kho_block_set_ser with
>> its own feature header, and keep the per-block header to next and
>> count.
>>
>> entry_size (added in patch 2) is another set-wide property that belongs
>> there. All blocks in a set have the same entry size, so recording it in
>> every block is redundant, and restore has to check that the copies
>> agree.
>>
>
> Yes, adding a ser_hdr to each block_header is unnecessary and also cause
> 8 bytes to get added to every block. This can be solved like you said by
> adding it only to the first block. But this will make number of entries
> in block[0] to be less than blocks 1..N. I am not sure if that is
> acceptable but if it can be then we can avoid adding ser_hdr to each
> block. Same for entry_size which can be moved to the first block only
> like you suggested part of struct kho_block_set_ser.

I think it is simpler to do as kho_vmalloc does and just have a separate
out-of-band structure to hold all the metadata.

[...]

-- 
Regards,
Pratyush Yadav
