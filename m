Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B004A3EDE7A
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 12:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524864; cv=none; b=M2RLSy+cOcuMBEOyy44QgiA1UUfl58+1Lu6yQl+EBcxwE4+e8rF3BBOBAV5AXuh5P3rg9IIGuXDSSi0BFBJxnp4c9L8yQvTKvRs9ZLghG7qVPaaZW0Axqg4AMWAquOKfTp1tDQ/Q3JzMJdxz/pDgn2uye7yb5k+i3TC3PPYnoF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524864; c=relaxed/simple;
	bh=OEXgFaxElkyQNqe2jsiICRDjpqfpaEVPn4g0Rsq23hA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pl3a2xSAISPLgJXkVa8Ilk9Au+7vpkxgqw65i3cF1JLAV8VrSMg6AlVM1+TEIKZDv8sXHqrKsEm1OTlL4oxNzFjd2WBA2egdERRq12cJmllNxyChtG4MR2y/u6FUSa1epR6jIjak/v53MS4pb1h6jLJ2irbcJEDq4pHFKp6F5KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PVI8YZiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PVI8YZiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1493C1F00A3D;
	Fri,  4 Sep 2026 12:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788524863;
	bh=x0Hyj83GwyW0az30GDRW9Yl6Y6zBtTTr4Affs6LgtNI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PVI8YZiNySWLHiKJGy2d873VK6uoLFV+82IkL2f2U6iEdnDDgyOIwv2bPhNuvyioY
	 qWckikKaijwe0KaigJVWXhk/QMWRHWRO8N7oOKeflA0/EwGspF4yg2RPznH53leDgL
	 jKlNaI/sJt0VyCB6R3zhhZTgNvuqcT2dGzPqwrIwS2VT0pL6WyxEx7MXwyCq1O77RM
	 BEFJ/0sRrK7npXSZh4UqUwDaXiFGCYtbgIn62C5/Wii0MPpbXe6DL+ZpD+0N/r8N6X
	 pytuoevFmDIib1ZV1MzEsKp8d+laB584ldvNtA8NJTdz8TivZeWgJkke9zpK3S2i0r
	 hSn+TAyYwkaiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] arm64: kvm: fix repeated word 'is' in comment
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hemanth Selam" <hemanth.selam@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260904122445.31163-4-hemanth.selam@gmail.com>
References: <20260904122445.31163-1-hemanth.selam@gmail.com>
 <20260904122445.31163-4-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:27:42 +0000
Message-Id: <20260904122743.1493C1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch incorrectly fixes a typo by blindly dropping the second '=
is', resulting in a grammatically incorrect sentence.
--

commit f89cf50275289ffe0b1b52223596e8fc7bd4496d
Author: Hemanth Selam <hemanth.selam@gmail.com>

arm64: kvm: fix repeated word 'is' in comment

This commit modifies a comment in arch/arm64/kvm/pauth.c to resolve a
checkpatch.pl warning by dropping the repeated word 'is'.

> diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
> index d5eb3ae876be4..22ff4b78d0e96 100644
> --- a/arch/arm64/kvm/pauth.c
> +++ b/arch/arm64/kvm/pauth.c
> @@ -5,7 +5,7 @@
>   *
>   * Primitive PAuth emulation for ERETAA/ERETAB.
>   *
> - * This code assumes that is is run from EL2, and that it is part of
> + * This code assumes that is run from EL2, and that it is part of

[Severity: Low]
Does dropping the second 'is' leave the sentence grammatically incomplete?
It now reads as "This code assumes that is run from EL2", which is missing
the subject pronoun "it". Should the original text have been corrected to
"that it is run" instead?

>   * the emulation of ERETAx for a guest hypervisor. That's a lot of
>   * baked-in assumptions and shortcuts.
>   *

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904122445.3116=
3-1-hemanth.selam@gmail.com?part=3D3
