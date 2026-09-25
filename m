Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A9D3D9DB1
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 08:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790326728; cv=none; b=pDXHleJV9oSKXRacahj+QwHgvtmaT5uACSJwkH550se58QF28MRXGJJyF/adCr1UnyfjPFex4jojuRmsLoadCtkqI3Cozf7rMSUnV9zd7kzUQoJvTd9036a/a4MKZXkSuDJfHKEnMBHG85EVW9t+F4c4Xpqw1dMGYnjqtXKmEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790326728; c=relaxed/simple;
	bh=CPMJMbxGiNHs6HUM0/S1qQIZqYoeumPDYi4cNoVGDec=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fgg5zrJSlxnwPxfBEh2H7Tqnc4LhFSuuOcQrlrSh90il28ph9K+mgXKzD9VEA1oHU5jLVBHxxN+RIVJQTAmUfqcT8e9Nlvo5RaDGPZxpOje0QImuN/cG5dO0uDhzy/DqKOxnnQe92/XoQOcmkzNedLuM+kIuj3vsc6dOSYE0ae4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SC6ouB2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SC6ouB2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501EE1F000FF;
	Fri, 25 Sep 2026 08:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790326726;
	bh=GVUy6Klm3ttcZMLBGTSQv95u4AlQg5CdikNcDWNcdiY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SC6ouB2Jkf53Fk05Fzr8sTuagCZaigg5v+6NNr4maw1un0hGO135AkAv614Vs3z7E
	 3qWTDBkM1LVPZ75xh5i0wRhoEHGipcnXONGjwwxa8pZdo86fWAplc6z3eNKTgHA/Uy
	 hNHya1v4lpXxKPLQdn/Ki09Z1dB99CCCMj/czxwUJzCGvaKo7qLRIexqb5vt1lB/KL
	 O4gk5IbFoOeBd1uyFxY2R3pN9ZuJuXACiJjFyaYYcxBNT1Fmmd8KlYse5CWpfpvg9F
	 F0COfMI0cPL6rcJo/LeIPHzFjci195qjDy55hJlh9LC4R+CjnfNblIZ6eFSHHy59B3
	 w1IQ6f+wvTnLw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] Documentation/process: Add a maintainer entry
 profile for KVM/arm64
Reply-To: sashiko-reviews@lists.linux.dev
To: "Matthias Goergens" <matthias.goergens@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260925085621.562448-1-matthias.goergens@gmail.com>
References: <20260924033536.3624334-1-matthias.goergens@gmail.com>
 <877bkb3zjq.wl-maz@kernel.org>
 <20260924083036.1744194-1-matthias.goergens@gmail.com>
 <875wzu4vuv.wl-maz@kernel.org>
 <20260925085621.562448-1-matthias.goergens@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 08:58:45 +0000
Message-Id: <20260925085846.501EE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] docs: unresolved draft placeholders in maintainer profile
--

commit dc2a38b3be99b9dc53f4e7a7537844707bf4e7ca
Author: Matthias Goergens <matthias.goergens@gmail.com>
Subject: Documentation/process: Add a maintainer entry profile for KVM/arm64

This commit introduces a new maintainer profile for the KVM/arm64 subsystem.
It details the development trees, patch bases, review cadence, and testing
requirements for contributors.

Link: https://lore.kernel.org/all/875wzu4vuv.wl-maz@kernel.org/

> diff --git a/Documentation/process/maintainer-kvm-arm64.rst b/Documentati=
on/process/maintainer-kvm-arm64.rst
> new file mode 100644
> index 0000000000000..deba2f812cef3
> --- /dev/null
> +++ b/Documentation/process/maintainer-kvm-arm64.rst
[ ... ]
> +``fixes``
> +  Fixes for the release currently in its -rc phase.  linux-next merges t=
his
> +  branch too.
> +
> +[?: ``master`` still points at a 2020 commit.  Once it follows -rc1, sho=
uld
> +this document mention it?]

[Severity: Low]
This isn't a bug, but should this draft placeholder regarding the master br=
anch
be resolved and removed before the documentation is merged?

> +
> +Changes leave the tree as signed tags, which are pulled into the main KV=
M tree
> +(``git://git.kernel.org/pub/scm/virt/kvm/kvm.git``) and from there reach=
 Linus
> +Torvalds.
> +
> +Unlike the KVM x86 tree, KVM/arm64 has no standing topic branches for
> +contributors to base their work on.  Where a series also touches code
> +maintained elsewhere, most often the arm64 architecture code, the mainta=
iners
> +may set up a shared stable branch, based on an -rc tag, that both trees =
merge.
> +Say in the cover letter which parts of a series touch other subsystems.
> +[?: Is this an accurate description of topic branches and of how
> +cross-tree changes are handled?]

[Severity: Low]
Should this question about topic branches and cross-tree changes be answered
and the text finalized rather than keeping the placeholder in the document?

> +
> +Base for patches
> +~~~~~~~~~~~~~~~~
[ ... ]
> +Key Cycle Dates
> +---------------
> +
> +Fixes for the current release are queued on ``fixes`` and sent throughout
> +the -rc phase.  Changes for the next merge window are queued on ``next``.
> +
> +[?: What are the cut-offs: the last -rc for submitting new features, and=
 the
> +last -rc at which the maintainers decide what goes into the next merge
> +window?]

[Severity: Low]
Should this placeholder regarding merge window cut-offs be updated with the
actual deadlines before the patch is accepted?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925085621.5624=
48-1-matthias.goergens@gmail.com?part=3D1
