Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795718971;
	b=DliFpQuKO8An4SwNWfHup8T7yxZR27nQF1kkjLzXol2D73nIQryPoLTiCIMicuNWomrQ
	 iYmtFaX3G85svq0I2Vz42Mb7G9dJ4cU0YJX96o5NZ0LZsHOk4S3cQJAjLtL9IsxiH2mn0
	 s6OrYyeRkhqRpGdboba7zGnxya+2N9m0PeTySrKeBgZvuTVstWBAO/Z9E7e/9CdQJ5EzP
	 pEoxWX6A3x2o6gCCbIMMj+mGhYeuhMXPpSzpJs28r8bw7nAPP8tWroHZTvwfNW7XgBvsf
	 ZNaoVslQUXZLD7bGClCO5c1JJEWqedpKU29bKwm8t7CcL5QlxxYth1p3oJm7/THwIQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795718971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=OJrIBssRihwY1hjT7BcClChtfC90/g3C4v7S4XKqBtA=;
	b=1ErA4LhnGlgtuk8MKI7pnLmq49cXV/V2k5icPnzeNImobp3bnavyNU8END0emyu8WUSH
	 7kFegIm5sZsaWAnLY5ZvI4Gp738I1dwxsPMklJFWSdoz6sRemFf0RFrRlhQpcPaYfzD3A
	 Kq6UN7n8NDvn6RYZaCXg5rCJCsePDyO9E+8YMts6raCD556/PHJsxinmZSbrl70LBCAnK
	 s0xisFOo6VBbC/JUduPrSC2o8qPZDhKGPKMVExYJnKoNuUUwvpzA/rDUsDkh3OrqTZOTG
	 UEfVX6RV64JCtw5hat73RargdozJFqZVtepj9gz/tv/PFOkYyRb2TtzpR+/no4uJu6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2CNBE5+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEA5606A31C;
	Thu, 26 Nov 2026 18:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2CNBE5+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5161F000C0;
	Thu, 26 Nov 2026 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795718971;
	bh=OJrIBssRihwY1hjT7BcClChtfC90/g3C4v7S4XKqBtA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=n2CNBE5+M6S3Gti+E4h/BEiW+QZsCLWVg3Z07JmCFD4CJWtQOT7wmTFvMHay90J17
	 FASidj/Tb9qKR6r+t0f8m5l2GSXoRaCyDUjouiMfYBDRAya375OAB8ifBdjby0L3cN
	 XvZu0xkJxI/+pA9AAyI7y3aIotV8xSxGc2csYUvuvg6Uw1JsXVX+0NOYxmoIoYXxv2
	 M34fX1uPVfxBkS9zufumLpfpKWYxQRuFEpxczh1v12sNbqWWyTovgyCerZ8wJElZbL
	 qHPbpDy15BB/FUoYPImERW6CSIHqZ46EBBEwU+aASP6SbeqtKq5FQihbH4FEKfQfVt
	 VyCXs6QVLSDTA==
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
Subject: Re: [PATCH v4 18/19] mm: memfd_luo: Add feature header to struct
 memfd_luo_folio_ser
In-Reply-To: <20261110050202.529473-19-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:02:01 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-19-tarunsahu@google.com>
Date: Thu, 26 Nov 2026 18:49:24 +0000
Message-ID: <2vxz8q2fwhqj.fsf@kernel.org>
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

> Precede each serialized folio entry in the preserved memfd folio array
> with struct kho_ser_hdr via DECLARE_KHO_SER so future per-folio memfd
> features can append fields to struct memfd_luo_folio_ser without breaking
> compatibility between adjacent kernels.
>
> Allocate the preserved folio array using kho_ser_size(memfd_luo_folio_ser)
> per entry and initialize each entry feature header in
> memfd_luo_preserve_folios(). On the incoming path in
> memfd_luo_discard_folios() and memfd_luo_retrieve_folios(), validate each
> entry feature header with kho_ser_validate() and advance between entries
> using fhdr->size so entries written with a different feature layout are
> traversed accurately.

No. The flags in each folio entry is a part of memfd's ABI. These flags
don't have an ABI of their own. If the layout of memfd_luo_folio_ser
changes, it goes in the memfd_luo_ser flags.

Doubling the memory needed to preserve a memfd is not acceptable.

[...]

-- 
Regards,
Pratyush Yadav
