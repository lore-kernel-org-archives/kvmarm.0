Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794377819;
	b=YL/jz7mc8TxoYUtri8DW/sLGtajqfohKy1CLs0qyR1NZtUr8lHbIaIn0JfCzdUp8TTuj
	 A43n49EgqcNwuHfk+iz/qfXhYx1w73pFxoAhZKJ3nvlmhaf5aCXq7cULAf8y+5sljqM2Q
	 ZNj+liWDk4ULTDq9P0eIRmgzD9pdv2BqjtwO19jWoReC8LLkUwJjaEvxsQg4mMz210/q1
	 uKLdb6IBLRfYumSMbwAXR9bLSdUuNhmSyMAF5XfzyX1Clh4nOI9uZADU8lKofLt+Rz/CJ
	 dDQv9/wjyebAG3HnqUYwYeEwrrKlZVmlHtyrbb2lAeaz1x5ZAOxOMVZLdG3mfcYpR5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794377819;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0CG1UcJOAjSNTO8JIN0pN5xZ098zwfCHiKYXyozJu5g=;
	b=c2FFLjqpJ2L77+wtcwOuJbmSN96CaDo1G2OskQu7yJGS6IB6G/RODRh/vtiJu03wva1c
	 gBeil0qo8MgFdx37oX9v3JFO29+OUieSD56yKDbzQSFHHZsWAIyP7RaThlP2Qp1+Gg8Km
	 RNGXklzhW7bwKPNYPlfjjX/mStEz88BwQYacHUKAnBSxhQaVa1RhRN5FtuLxx7ANhgRuQ
	 oD79qDg/L3fyxfYtiJnd6ym2wGwXi6CHicG5GK1l0uXpDqdJVd5BnAa48KWbE/bgiHeKf
	 9ICwRHL0X/LJ8RT0k8D3UhF/Msfju1WyjJxz+MdMRl6xzyl62ooaE6UE3CKcamDABmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbNXobAQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6577606A32D;
	Wed, 11 Nov 2026 06:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbNXobAQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215CD1F00A05;
	Wed, 11 Nov 2026 06:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794377819;
	bh=0CG1UcJOAjSNTO8JIN0pN5xZ098zwfCHiKYXyozJu5g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MbNXobAQp8xUF/BBqw0Es8S0zNZqgPpsP8tSno3whHxWT+eG/GJdAXRflVIdGyAKb
	 TfsZkz+mzhAgqkksMKP8UwAl6jQyxasiCBrTlL6LOV7UVW0MxW2KT0LtffLtBCtU5k
	 KwQTpERdezry2cljcogaGSA8gWqU2BRUOschZo8q5gNjz5FKq731YnejwrxtrzDjrI
	 Adj6uwLe/JvRxCEEQUvvB0yhiZbtLhpM9ajpet7kB1P2xZmjCob5z/COmv1IDGKRTo
	 6k1hrtDHqhtipPQWp771Pk1tPIi/U4O2LWEO/ArfmJ7qEZrWuu+hnCJ6TZCaoAhXfD
	 C5n0O4pSW+0wQ==
Message-ID: <sashiko-outbox-208421@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 18/19] mm: memfd_luo: Add feature header to struct
 memfd_luo_folio_ser
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, "Bjorn
 Helgaas" <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, gle.com@google.com, pbonzini@redhat.com, "Andrew
 Morton" <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, "Pratyush Yadav" <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, skhawaja@google.com, sagis@google.com, linux-mm@kvack.org
In-Reply-To: <20261110050202.529473-19-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-19-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 06:16:57 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: memfd_luo: folio leak on kho_ser_validate() failure in
  retrieve/discard
--

commit c3d8dd278c3f1e63ea2c973472e060bae843ec49
Author: Tarun Sahu <tarunsahu@google.com>

mm: memfd_luo: Add feature header to struct memfd_luo_folio_ser

This commit adds a struct kho_ser_hdr feature header to each serialized
memfd folio entry and validates it during retrieve and discard.

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 94510f73a6069..c00daa8a508e1 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c

[ ... ]

> @@ -384,16 +391,23 @@ static void memfd_luo_unpreserve(struct liveupdate_=
file_op_args *args)
>  	inode_unlock(inode);
>  }
> =20
> -static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *f=
olios_ser,
> +static void memfd_luo_discard_folios(const DECLARE_KHO_SER_HDR(memfd_luo=
_folio_ser, *folios_ser),
>  				     u64 nr_folios)
>  {
> +	const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *fhdr) =3D folios_ser;
>  	u64 i;
> =20
> -	for (i =3D 0; i < nr_folios; i++) {
> -		const struct memfd_luo_folio_ser *pfolio =3D &folios_ser[i];
> +	for (i =3D 0; i < nr_folios; i++, fhdr =3D (const void *)fhdr + fhdr->s=
ize) {
> +		const struct memfd_luo_folio_ser *pfolio;
>  		struct folio *folio;
>  		phys_addr_t phys;
> =20
> +		if (kho_ser_validate(fhdr, memfd_luo_folio_ser)) {
> +			pr_warn("invalid folio feature header, folios not discarded\n");
> +			return;
> +		}
> +
> +		pfolio =3D kho_ser_payload(fhdr, memfd_luo_folio_ser);
>  		if (!pfolio->pfn)
>  			continue;

[ ... ]

> @@ -447,9 +461,10 @@ static void memfd_luo_finish(struct liveupdate_file_=
op_args *args)
>  }
> =20
>  static int memfd_luo_retrieve_folios(struct file *file,
> -				     struct memfd_luo_folio_ser *folios_ser,
> +				     const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *folios_ser),
>  				     u64 nr_folios)
>  {
> +	const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *fhdr) =3D folios_ser;
>  	struct inode *inode =3D file_inode(file);
>  	struct address_space *mapping =3D inode->i_mapping;
>  	struct folio *folio;
> @@ -457,12 +472,20 @@ static int memfd_luo_retrieve_folios(struct file *f=
ile,
>  	int err =3D -EIO;
>  	long i;
> =20
> -	for (i =3D 0; i < nr_folios; i++) {
> -		const struct memfd_luo_folio_ser *pfolio =3D &folios_ser[i];
> +	for (i =3D 0; i < nr_folios; i++, fhdr =3D (const void *)fhdr + fhdr->s=
ize) {
> +		const struct memfd_luo_folio_ser *pfolio;
>  		phys_addr_t phys;
>  		u64 index;
>  		int flags;
> =20
> +		err =3D kho_ser_validate(fhdr, memfd_luo_folio_ser);
> +		if (err) {
> +			pr_err("memfd_luo_folio_ser feature validation failed: %pe\n",
> +			       ERR_PTR(err));
> +			goto put_folios;
> +		}
> +
> +		pfolio =3D kho_ser_payload(fhdr, memfd_luo_folio_ser);
>  		if (!pfolio->pfn)
>  			continue;
> =20
> @@ -472,7 +495,7 @@ static int memfd_luo_retrieve_folios(struct file *fil=
e,
>  			pr_err("Unable to restore folio at physical address: %llx\n",
>  			       phys);
>  			err =3D -EIO;
> -			goto put_folios;
> +			goto next_put_folios;
>  		}
>  		index =3D pfolio->index;
>  		flags =3D pfolio->flags;
> @@ -524,15 +547,22 @@ static int memfd_luo_retrieve_folios(struct file *f=
ile,
>  unlock_folio:
>  	folio_unlock(folio);
>  	folio_put(folio);
> +next_put_folios:
> +	i++;
> +	fhdr =3D (const void *)fhdr + fhdr->size;
>  put_folios:
>  	/*
>  	 * Note: don't free the folios already added to the file. They will be
>  	 * freed when the file is freed. Free the ones not added yet here.
>  	 */
> -	for (long j =3D i + 1; j < nr_folios; j++) {
> -		const struct memfd_luo_folio_ser *pfolio =3D &folios_ser[j];
> +	for (; i < nr_folios; i++, fhdr =3D (const void *)fhdr + fhdr->size) {
> +		const struct memfd_luo_folio_ser *pfolio;
>  		phys_addr_t phys;
> =20
> +		if (kho_ser_validate(fhdr, memfd_luo_folio_ser))
> +			break;
> +
> +		pfolio =3D kho_ser_payload(fhdr, memfd_luo_folio_ser);
>  		if (!pfolio->pfn)
>  			continue;

[Severity: Medium]
Does this leak the remaining preserved folios when kho_ser_validate()
fails?

When kho_ser_validate() fails on entry i in memfd_luo_retrieve_folios(),
it jumps to put_folios with fhdr still pointing at entry i.  The cleanup
loop then calls kho_ser_validate(fhdr, memfd_luo_folio_ser) on that same
entry and immediately breaks, leaving entry i and all subsequent entries
un-restored and permanently leaked.

Similarly, memfd_luo_discard_folios() returns on the first validation
failure instead of continuing or still restoring pfolio->pfn across the
array using fhdr->size, which only checks for unknown required feature
bits while the base payload and entry stride remain valid.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110050202.5294=
73-1-tarunsahu@google.com?part=3D18
