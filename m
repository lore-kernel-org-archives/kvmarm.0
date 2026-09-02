Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340B0463B91;
	Wed,  2 Sep 2026 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367829; cv=none; b=KkknGzaCMdt+E7HzQnMCLguNvuYigVFx0nq6SqV9hgWDaIzK+aVpIY1fI9kMQwi8/Y8SccskLf9oWNXJZgN+gMwIfhC5fBglRfLzu/ePaQK43nt0ym+OfflTn+gXleiCEiZweqM6OhqSElKxVnACJgRUScNmoG/BDDqiWpNAzvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367829; c=relaxed/simple;
	bh=1ZUA7k0q5rNkF4Wc7Fa8FWgB4gVdo26aryDGOu3Qcbc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DmhSbsV7TmXZBbPZE1dVr0zDGTHBxKGK71p++UZcgW5V1m5bTzGRwwDYJTunCNsnBngfVsTmJsDM+FGA/3NTRa5kFl7jXmnrUNUrAZ8h50tPRKSY2haX1cOawRbdoi5MHlisO0Q0SS2EPAS8bsCSlUSgscAopGO9x2UtcNbNoGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5gfOjtj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5gfOjtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE6E1F00A3A;
	Wed,  2 Sep 2026 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788367827;
	bh=kRUCtD8HSqIK+B5av6hDNjmbZMjXDF7sjEQPaoe0OJc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H5gfOjtjObHzBIr6mOcgFQBIWUWA3RWfoAWqB7NRdds/pMTQb+9GE5bAuI0ttw112
	 6nTQ0Wg0Oh0ixbFQQ3vafA2n/mC+qxbFpZjG+FpKS1J4WiAbkmYANhwO4dWs4jweVE
	 bzSTQV0TICiMygwUQ/RIzQJRLlXTxH78d+pudTivdsebHAZA5e7w6HptCE5h+HmwN+
	 bPdek4VM9Vn0QyWdNWwIm1WJI7nsYFoFweaPWLQhlEzu1Ub3K0qbfdt0h5nTDaMO8S
	 D+PtGmeAo3Uv3uXlKO9Gn6TP25B3imhscIKsKr2fNqDdNHEP3vsD7G4hTP8ecY/ccC
	 g2APydEyylv0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/20] KVM: selftests: Rename "num" param to
 "nr_pages" for physical page allocators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260902164123.2546762-5-seanjc@google.com>
References: <20260902164123.2546762-1-seanjc@google.com>
 <20260902164123.2546762-5-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 16:50:26 +0000
Message-Id: <20260902165027.3BE6E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Grammatical and missing word errors in the updated function comment.
--

commit fcd1f5cf5e36c06f5f1aaed2058d2615dea81241
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Rename "num" param to "nr_pages" for physical page allocato=
rs

This commit renames the "num" parameter to "nr_pages" in the physical page
allocator APIs to clarify its unit and role. It also reworks the function
comment to drop the kerneldoc style and explicitly state that success is
guaranteed.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 9ddc047d5c275..b071d77dd301f 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2025,33 +2025,20 @@ const char *exit_reason_str(unsigned int exit_rea=
son)
>  }
> =20
>  /*
> - * Physical Contiguous Page Allocator
> + * Allocate contiguous (guest) physical pages in a given memory region, =
at or
> + * the minimum specific GPA.  If the memory is protected/private, also a=
dd the
> + * allocate pages to the region's set of protected pages, e.g. so that a=
rch

[Severity: Low]
This isn't a bug, but there appear to be a couple of typos in the updated
comment block.=20

Should "at or the minimum specific GPA" be "at or above the minimum specifi=
ed
GPA"?=20

Also, should "add the allocate pages" be "add the allocated pages"?

> + * code knows which pages need to be encrypted when launching the VM.
> + *
> + * Note, success is guaranteed!
>   */
> -gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> -			   gpa_t min_gpa, u32 memslot,
> -			   bool protected)
> +gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min=
_gpa,
> +			   u32 memslot, bool protected)

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902164123.2546=
762-1-seanjc@google.com?part=3D4
