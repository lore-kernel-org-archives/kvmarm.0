Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207829;
	b=rsjNvs1gw5szYiMXeRn25J76NXPBKngnVSWVbDb2S7p7j+2FnwGkXJTW7xRLabpetkVW
	 fMRUkooK76Tqt30kI/eS4vwqZAawNvob1tyCPW4qEUQSwJK8UdwsRButxOPnCczzqpLtF
	 MzIXibBNIRTOpzCFkjMZm8iOl5HD8tZt5eIulFxnpmGIqfDsGJmfiTn2Io3UHlf2N7f3z
	 3bvy6vW5y3aEYreJtDTM24uExjHfaWBSswY4xU6mVdOw3z3tqa2zM5uNfLR1ohHkWowp3
	 mj09ECHVB75i++FS2PEnIT4XpW7Q+JS7wmTcZN9c0k3m1VtaMkn0wIp9eKw1Imuo3UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=05SG7gAJ008w03i9CCuLSraJDJiyVFmW6Oo7ipBrjbs=;
	b=4EMPikBDoKCMWj8vwTaCapSZRO8Jzk3LYcDxRNl/pWCv1iP1cK7Ean50hAJfNVeWZ8RS
	 +ndICaITPInxXuoaK0vlQHxm7BfOf7jCfP+raAgTnf1VpG2MPaGpQR8AC/T2hBqc4u6uB
	 RoZowgULkSQUOLpJkIjInuhn4gNbfqCAm1XZE9IfC1Qnh/U8Ka8OEfhZnBW9aZlbt8SG6
	 hUiKWs8tqHub3NzasnkF3wcPux6cstVr9Q33W6tb3wA7u2ilv6D5BZAsPHxHPmY0CYQ3R
	 cZElWfwGyUM/fctVYAiOFLD8vNvWeLfcqirYjYRrQH46BUhUKnN8ZX+2wM+r5aPgLDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LIVACHG1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CB6606A320;
	Wed, 28 Oct 2026 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LIVACHG1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A438E1F01828;
	Wed, 28 Oct 2026 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793207828;
	bh=05SG7gAJ008w03i9CCuLSraJDJiyVFmW6Oo7ipBrjbs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LIVACHG1RijgMjCcG/Za6quG10uP/bwvgH9QE8LBE1Ivatgc9Gsxomr3AtpNUFPU0
	 A+6txV+JhFA/FQ9wi7C+7pWYpZ0e+Pc7WqKMe9jkABrVblw1ZFcwlZAztCqgB1P/e3
	 p9b8wN4tDVitUGLc/V+1hQT1NZFTVD7m3WdPU0oqKQlNmHSSGk9l9hK3CeTbNDWqSe
	 VN3sAKFewBC6xe0t5rYtB+sbuiw5e5lDQoKvIRxdjJ0DrtoKis23WnQwx7fOelIVvL
	 Atltab4Pstjrs4D4dYuIJSyaVZnuHq7QWlD07iE6RtqSOvkxEaO4SzTr/vUKZm0prA
	 whzCKqWsehupA==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  tarunsahu@google.com,
  Andrew Morton <akpm@linux-foundation.org>,  joro@8bytes.org,  Mike
 Rapoport <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,
  maz@kernel.org,  arnd@arndb.de,  jgg@nvidia.com,  robin.murphy@arm.com,
  loganodell@google.com,  oupton@kernel.org,  kevin.tian@intel.com,
  alex@shazbot.org,  dwmw2@infradead.org,  pbonzini@redhat.com,
  seanjc@google.com,  will@kernel.org,  Alexander Graf <graf@amazon.com>,
  Bjorn Helgaas <bhelgaas@google.com>,  baolu.lu@linux.intel.com,
  linux-arm-kernel@lists.infradead.org,  linux-arch@vger.kernel.org,
  sagis@google.com,  linux-mm@kvack.org,  kvmarm@lists.linux.dev,
  iommu@lists.linux.dev,  linux-pci@vger.kernel.org,
  kexec@lists.infradead.org,  skhawaja@google.com,  kvm@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string
 with a 2-bit pair feature header
In-Reply-To: <at-8vkVpN2SF3XgB@google.com> (David Matlack's message of "Mon,
	26 Oct 2026 20:49:02 +0000")
References: <atlKsD-aJB3mJr2j@google.com>
	<CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
	<atl7peoVHdP5hz7z@google.com>
	<CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
	<CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
	<CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
	<atpNFEFIlqAoYIwH@google.com>
	<CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
	<attmFVIFU_mS0Y7p@google.com>
	<CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
	<at-8vkVpN2SF3XgB@google.com>
Date: Wed, 28 Oct 2026 18:17:02 +0100
Message-ID: <2vxz8q3hoicx.fsf@kernel.org>
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
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26 2026, David Matlack wrote:

> On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
>> On Fri, Oct 23, 2026 at 9:50=E2=80=AFAM David Matlack <dmatlack@google.c=
om> wrote:
>
[...]
>> The reason I care about keeping the header compact is that we are
>> defining a foundational kernel ABI and want to use this header across
>> almost every serialized data structure so we can evolve them later
>> without breaking compatibility. While some top-level structs are on
>> sparse folios today, other serialized structs are tightly packed, and
>> we are looking to add KHO slab support in the future where tightly
>> packed allocations will be common.
>
> My intuition is we will have a small number of headers per preserved
> file and per preserved FLB. One for the top-level struct and then
> optionally a few more for sub-structs like arch-specific data. That is
> why I am less worried 8 bytes per header, even if we fix the folio
> problem.
>
> Maybe where our visions differ is when there are collections of
> serialized structs, like KHO blocks. For collections I don't think the
> elements will each have their own headers. Otherwise the elements could
> be different sizes.

kho_block today doesn't store entry_size in the serialized payload. It
relies on its caller to do so. With extensible structures, this can get
messy. Sure, the owner of the kho_block_set can track the size somewhere
in its payload, but perhaps we should store the size in
kho_block_header_ser to begin with?

Anyway, not a problem this series needs to solve, but something we
should eventually do.

[...]

--=20
Regards,
Pratyush Yadav
