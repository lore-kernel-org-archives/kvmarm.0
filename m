Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794377807;
	b=3QgYcRi6O2NKjIqE98xYYVyOqEgGYX5mw71p9Y7PnIB0W6Lpnd15TXwuA2erZnPMLwS2
	 VyWQlvwd5kEU5r97Hl4rpBx35/HlKRqDvvveYExG6mreGd94sXJXlE2pqpgn0lcq1Dew1
	 qLzOA3S/sQRT8t61ST9eVjXrWniAnHLr2ZbRmC/os6pM3wdT8CMVPllmhJeZYVAMqHs2S
	 Mn1aTWL0CCdWofPwMGnlRyfQVvLTkdd/7ZW9Qp5qJLvX0kiP6hhg2lBn14NtaoSJ4FwnC
	 eDQEu3XYE5jNzoZafofxrgUD6rND43JG21bsIUoznOrBXiMSZqr+4+UBdDbtj6Vjtqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794377807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QHfiaWxCcZhurl6F9ZemW3Q0LNncHtCBCbMGBWelkuM=;
	b=yD6bKxRN4yfGAATx8I54If1smQJfx8z0x4Kpz5bwARqhFVks1UpsRS0Di2UvLCpuAvKQ
	 SkQQIKLsHZCxSMjhmF2qG4NUG6x1a+d6Y1YeNcp2YsRSrjIhp3x3/BYVWWcIu6aS/I09+
	 MS/JrCECyx6kzN+BcDYapVnKoLVcMaJSmCwcUe1ig5F1CWvwDpzpNeov4FpmQyaLgu+WY
	 OQuZ087eW7Tagr/+7W+KVgFhpdqe6UXWjpF5SPHZV/h65kFM57YdsWnH32r29RKpDmbuY
	 NO866qHIsnc/CoA9VviB8sPbFdr/L1AUp1AjNySyrMhGKg9KNipMgjXmIRnlljWIItA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EImt61fl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3EA606A320;
	Wed, 11 Nov 2026 06:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EImt61fl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF7C1F00A05;
	Wed, 11 Nov 2026 06:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794377807;
	bh=QHfiaWxCcZhurl6F9ZemW3Q0LNncHtCBCbMGBWelkuM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EImt61flV5cq+7e4hR+ft3m7e7xCstobBu6qSNOHi0GZRaD7AB3LXX/d6RpGrMMHM
	 lwiKJBhIYkVVBiy95ALKfS6qYNOgl5pRLKP8Opd7WFLVXOQSm48YVTbFQ5ctAaUmiv
	 LrNh9151rRHt5atGrFLvwc+vq1Ol/kdiFvqBgWJyi+speMlFnmyJP/b+i/H+aHBIfX
	 SvYO1rGxI/3Tgu2yX1fDFkvTW1qDhgDRUFnvcdw0W6DIgmW1BTuWCTsZl2b7L0SVFU
	 aLqq+V/0C696+ioxmJX5IFJA7ARzQz5QYrbKcogK/13TeXUd6HI65dkA0VCU7pk0L2
	 xWNejiZNeMcOw==
Message-ID: <sashiko-outbox-208414@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/19] liveupdate: Add feature header to struct
 luo_file_set_ser
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, "Bjorn
 Helgaas" <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, gle.com@google.com, pbonzini@redhat.com, "Andrew
 Morton" <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, "Pratyush Yadav" <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, skhawaja@google.com, sagis@google.com, linux-mm@kvack.org
In-Reply-To: <20261110050202.529473-12-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-12-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 06:16:45 +0000
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
- [Low] liveupdate: DECLARE_KHO_SER_HDR() mangles kernel-doc in
  luo_file.c
--

commit 56a2b87048122363acff436905ac6fad2da6e4c3
Author: Tarun Sahu <tarunsahu@google.com>

liveupdate: Add feature header to struct luo_file_set_ser

This commit precedes struct luo_file_set_ser with struct kho_ser_hdr via
DECLARE_KHO_SER and updates the file-set freeze, unfreeze, and
deserialization routines to initialize and validate the feature header.

> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a39992da504fb..02d09a80d7852 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -440,8 +440,8 @@ static void __luo_file_unfreeze(struct luo_file_set *=
file_set,
> =20
>  /**
>   * luo_file_freeze - Freezes all preserved files and serializes their me=
tadata.
> - * @file_set:     The file_set whose files are to be frozen.
> - * @file_set_ser: Where to put the serialized file_set.
> + * @file_set:      The file_set whose files are to be frozen.
> + * @file_set_fhdr: Where to put the serialized file_set.
>   *
>   * This function is called from the reboot() syscall path, just before t=
he
>   * kernel transitions to the new image via kexec. Its purpose is to perf=
orm the
> @@ -472,12 +472,14 @@ static void __luo_file_unfreeze(struct luo_file_set=
 *file_set,
>   * Return: 0 on success, or a negative errno on failure.
>   */
>  int luo_file_freeze(struct luo_file_set *file_set,
> -		    struct luo_file_set_ser *file_set_ser)
> +		    DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr))

[Severity: Low]
Does using DECLARE_KHO_SER_HDR() in documented function prototypes break
kernel-doc output when building htmldocs?

Documentation/core-api/liveupdate.rst includes kernel/liveupdate/luo_file.c
with :internal:, which processes luo_file_freeze(), luo_file_unfreeze(), and
luo_file_deserialize().  Unlike DECLARE_KHOSER_PTR(), DECLARE_KHO_SER_HDR()
has no CMatch transform in tools/lib/python/kdoc/xforms_lists.py.  When
create_parameter_list() in tools/lib/python/kdoc/kdoc_parser.py splits the
parameter list, it replaces the comma inside the macro with '#' and never
restores it, emitting invalid C syntax in Sphinx:

  .. c:function:: int luo_file_freeze (struct luo_file_set *file_set, DECLA=
RE_KHO_SER_HDR(luo_file_set_ser# *file_set_fhdr))

Adding a CMatch("DECLARE_KHO_SER_HDR") rule in
tools/lib/python/kdoc/xforms_lists.py alongside DECLARE_KHOSER_PTR would
let kernel-doc expand the macro cleanly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110050202.5294=
73-1-tarunsahu@google.com?part=3D11
