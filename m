Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD8B34AB14
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241438; cv=none; b=cij9a6zr4znGxvcUXCRrY1BbRyzbVNUg+diM7YLCa6xJ7dO2DHVBuZWFNuo6eUCHE50tB42IXV09XWMsfeS5NsyIq3462ZTuFvthyVrIImty0qvaCxBVjJRQKrVz8DZI7v1W0pBUXavD9SjaZwVuoSNMJZ5QIBKOgRVZMn6Vp9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241438; c=relaxed/simple;
	bh=SGHGcOPyAq1blbQ7fFsN/FO1zlkr4R1ESVECtZ+CC9o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lJ3MSU+1T4zFcvivqBDvSibW7rKnzuC3XR7ftCsRSpaaQkjHVQtxXP/4H15k1Ud5XWpwA2Vd0NGoStVn5qclXkSn8H2DeLfKJehuQ6FRoD+nCzb1JeD07IMXAoeQte50NIghuQ5aMFy15Wuc0dEzbhd8eRyNmTVieUXGW79QuCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S74csimO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S74csimO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335231F000E9;
	Tue, 23 Jun 2026 19:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241437;
	bh=yE7tPFMXA3Yr3ewa3XXlz6DE0QuzE5jQcJ32OvzgfeE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S74csimOPyPynBDmiU7ErTp6uGPq148DXLK2BU7qU4fL6F//xQmahGFC+feeXjM8S
	 jsLrmK6LQAZH/E9fjv4oSwWWwZhSv6BBUZnd5IoNY/LetnVkoN/U3skugblfs+0/Bx
	 lSnQ1Lcrt9WmGacS1Y+zzbFM424VqRUJwmUH/lUNJmJCpZiFFlfkgL8zuRe8d1vkeC
	 cqnWwpQ0uGL4DJOTAGAcb5Z3WvU24RmwfPxgqn7RgVO1v+wbWToJkjAc1gyP/Cm/Iy
	 Yr4zOZnQbHq06iIZbpgJD8WVj+cNsfutP+XCDSY5Wnr/rkSDc5vWK4RCiYH6ClftKx
	 1InWQ+Z93Y7eA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/22] KVM: arm64: nv: Set dirty state at stage-2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260623184201.1518871-8-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-8-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 19:03:56 +0000
Message-Id: <20260623190357.335231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The kvm_s2_trans struct retains stale descriptor values and perm=
issions because it is populated prior to handle_desc_update(), causing KVM =
to unnecessarily force a second VM exit for write faults on clean DBM pages.
--

commit c42a40795b5eef86805c06b6623a0ccb0c1d888d
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Set dirty state at stage-2
   =20
Set the dirty state on descriptors at stage-2 for write accesses when
DBM is set.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index a70af3b3f05db..e5a407fc0880f 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -422,6 +430,20 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu,=
 struct kvm_walk_access *acc
>  	compute_s2_permissions(vcpu, wi, &ws, out);
>  	out->level =3D ws.level;
>  	out->desc =3D ws.desc;
> +
> +	ret =3D handle_desc_update(vcpu, wi, &ws, out, access);

[Severity: Medium]
Will this result in KVM mapping the shadow PTE read-only on the first fault,
causing a second VM exit?

Because compute_s2_permissions() calculates the out->dirty state based on t=
he
pre-update descriptor, it seems out->dirty will remain false even if
handle_desc_update() successfully sets the dirty bit in guest memory.

When the walk returns, KVM's MMU consumes this in adjust_nested_fault_perms=
()
and strips KVM_PGTABLE_PROT_W, causing the L2 guest to retry the write and
immediately trigger a second VM exit.

Should out->dirty be updated to reflect the newly set dirty bit after
handle_desc_update() succeeds?

> +	if (ret)
> +		return ret;
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D7
