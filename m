Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682782;
	b=mB1gbR8jmGUOPDRIyLFUKly99Zh4WGCBE5U8Km/6KwaeWFvfPD/DppthSrUWF/fqUg6b
	 Ht2uBcAvn49MyjX5P3/vNXwFFYMw20RjcLaRWzY5chk6bMQuomzwqT0vrL/f9be9Uta9o
	 G34EAfS6mC+ngd08bX3Co8y3d7Yxt5IQgu4VKmcKPLhv24Nt8MTcobaOgnacPxlV6Hhns
	 ZNZ3So9E0J1/g72PU60jyDuyNFGS+DkPrNxFbHoMksmR2/FjxNgVtz8OLuqJSXhHn5dol
	 WioblGpHXiWlciyo4kevlHyjcacZ7yb5T1isbISGkzv3QIVrxpLzeTSNkEt2Qa5eZ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682782;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ShNiCMk8Kuf8pc2qB+tQRe+Fq75YJp+jO77Paj5vAT8=;
	b=uaGdScoQCIS40UGofSSVftoKir8TFH2C73m0Xeo6xOiZ2sQH3/8+WUSX50Kf55ncJg5R
	 /w0Mtnl/+YcwzmodQOS8ilQhKpuNZ005TFMYrTbfA/6pIN2RyA/kkSZdsBb1AQvV0s/dS
	 4mu2b/lN6QYVzYs9XJk+WPS1jZAYcGiYi3mFg57i8htvWVZLKB3UXmlEahCFt3IZBRz7D
	 qwDEGJru3tguWD90IuQSa8KJAgvz/43nMSaRr974DWruhQFtgW7M94uETYO4KLfVHxq76
	 /pfljd+g4l+j12DLKxaY88E8ygZHBhchxal9TXN7sFB2hzgT3tKi17EuA6cEkSeSucA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="KG/ahhDT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A1606A319;
	Thu, 22 Oct 2026 15:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KG/ahhDT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB2E1F01828;
	Thu, 22 Oct 2026 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682782;
	bh=ShNiCMk8Kuf8pc2qB+tQRe+Fq75YJp+jO77Paj5vAT8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KG/ahhDTlLfdPHHLRIXec/17R576tWHUPWqYwwZtqRAkH9gmk96VkUbys9bFRitIz
	 hb+W/lY6cQNa2FAKkCQTHppIq0ErCF6chSi8acEObQHS8drrpFbsvrr0T8tmBToh6l
	 +6faJfTY035e2rxW5JZGK+e0/5k1yYr3wObGkLqjPPQPcWqcinYVLyGsnLA624OYnr
	 xvnoPipWUv+m2tGCZEG/J6jzXmcUwmnfL6sTfoRDtoQZvnvXtOHUdTDK9qviFpTFRs
	 FHsqYRElnShhy52IA7WsxqAWEsy/e4NP2E7YRUuUloiPNvuaeXIbrk5q1G8UZOXbbi
	 lyuq0A5swftPg==
Message-ID: <sashiko-outbox-181698@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature
 header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, joro@8bytes.org, "Mike
 Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, "David
 Matlack" <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Alexander Graf" <graf@amazon.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, baolu.lu@linux.intel.com
Cc: sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org
In-Reply-To: <20261021152527.375070-5-tarunsahu@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-5-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:26:21 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: memfd_luo: missing feature header validation in memfd_luo_fi=
nish()
--

commit b960724786ac11078fdfa9ded6bcd2355170cf0b
Author: Tarun Sahu <tarunsahu@google.com>

mm: memfd_luo: Add the 2-bit pair feature header

This commit embeds a 128-byte struct luo_feature_hdr at the start of struct
memfd_luo_ser and defines enum memfd_luo_feature with MEMFD_LUO_FEAT_CORE as
a required feature. It initializes the feature header during
memfd_luo_preserve() and validates it during memfd_luo_retrieve().

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 64f8b8cb75bdb..ea1f4c8cd2591 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c

[ ... ]

> @@ -525,6 +531,14 @@ static int memfd_luo_retrieve(struct liveupdate_file=
_op_args *args)
>  	if (!ser)
>  		return -EINVAL;
> =20
> +	err =3D luo_feature_hdr_validate(&ser->features, memfd_luo_features);
> +	if (err) {
> +		pr_err("memfd_luo_ser feature header validation failed (size=3D%llu, f=
lags[0]=3D%#llx): %pe\n",
> +		       ser->features.size, ser->features.flags[0],
> +		       ERR_PTR(err));
> +		goto free_ser;
> +	}
> +
>  	/* Make sure the file only has seals supported by this version. */
>  	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
>  		err =3D -EOPNOTSUPP;

[Severity: Medium]
Here in memfd_luo_retrieve(), ser->features is validated via
luo_feature_hdr_validate() before accessing any MEMFD_LUO_FEAT_CORE fields,
jumping directly to kho_restore_free(ser) on failure.

However, when a preserved memfd is not retrieved in the target kernel before
the session is finished or closed (for example via luo_session_release() ->
luo_session_finish_one() -> luo_file_finish() -> luo_file_finish_one() ->
memfd_luo_finish() with args->retrieve_status =3D=3D 0), memfd_luo_finish()
reads ser->nr_folios and ser->folios without validating ser->features first:

mm/memfd_luo.c:memfd_luo_finish() {
	if (args->retrieve_status)
		return;

	ser =3D phys_to_virt(args->serialized_data);
	if (!ser)
		return;

	if (ser->nr_folios) {
		folios_ser =3D kho_restore_vmalloc(&ser->folios);
		if (!folios_ser)
			goto out;

		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
		vfree(folios_ser);
	}

out:
	kho_restore_free(ser);
}

According to the ABI contract in include/linux/kho/abi/memfd.h, fields of a
LUO_FEAT_REQUIRED feature such as nr_folios and folios are only guaranteed
present once luo_feature_hdr_validate() succeeds.

Should memfd_luo_finish() also call luo_feature_hdr_validate(&ser->features,
memfd_luo_features) and skip to kho_restore_free(ser) if validation fails,
so it does not pass unvalidated MEMFD_LUO_FEAT_CORE fields to
kho_restore_vmalloc() and memfd_luo_discard_folios()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021152527.3750=
70-1-tarunsahu@google.com?part=3D4
