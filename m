Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E82B37A85D
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283817; cv=none; b=e2/W/8SVN6QbvtSzi5vB0z37mhGXwXwqNPG7LzTwVLvBWbpKVCzE03QW4Be2iMZ6I5xwCwIOrQxdDccrhjxsw6xAspS+RWHxRlv8KH65EIt6t2EHN3ONlSVCXe1Aw0GjEdPqkg8QwgiYN5qiIMGtKeAM8AWhzpNpsbYx1TcYXT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283817; c=relaxed/simple;
	bh=+76+CRLLUEWcVR08W6IDqcuN/e9lr18DQtd/7o+Yygk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JPy9jXTebyB45GKfbM1xQyux+pWzVb2O57AYtshjc9qpMNLZ2xVAssjocI+SPI7uIZ4EGJYKrYGL9BsjmuSFNze9ipeQ6OO0HblcniHVDT6Kag3lFNRZ59oG5gFev815TqHFWWtIn5N47lIaSqzk4A2QUDYNetNSWL0DkvRAFIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jp6m4CZ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jp6m4CZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1B41F00A3D;
	Tue,  1 Sep 2026 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788283815;
	bh=CyFz3/RN6X136TAC3lfgI3hqs647kuHY2c4UQP9by4w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jp6m4CZ2N1LM6A05acuqqkYB1HsaVsyzotmafLSuqwjwbAGZW/TuNIGcRq0vtYdDg
	 BxcgZ1pA8XNCeoiNaEDjk91NdptHxiq8wyNKfp+LHEYeCm/FEYk+EwFTOkCAzs+xBH
	 H90kEhPlyGOUTJqPyzLEjUMAhBZ7CLaNYfnvFCq/8tnZWkgcSBBqnUqx05agsGLIyL
	 PHarj4ZDOebSBcHFEBXEH+F3NslI7SsGFL0QjbFolCJhPNYKIR+AFKXFz1of8ODQv1
	 TCpWnNIc+rc1pb6I5tXdT+lP4onUhfXK6BDIwidHCCqs/tUldECZmHlS1CUmHL6IeX
	 2Ff1pfztg+zYQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/5] KVM: arm64: pgtables: Change write bit from
 S2AP_W to DBM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260901171558.2674031-2-leo.bras@arm.com>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-2-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 17:30:14 +0000
Message-Id: <20260901173014.AC1B41F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] walk_nested_s2_pgd() incorrectly evaluates the DBM bit in L1's sta=
ge-2 page tables, leading to L2 memory protection bypass and broken L1 dirt=
y tracking.
--

commit 6c412868c1a4af97b366b23a517db706c4c3511a
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: pgtables: Change write bit from S2AP_W to DBM

As a first step of changing the encoding for the Stage2 PTE descriptor,
introduce the DBM bit, and adapt every usage of writable to use the DBM bit
(51) instead of S2AP[1]/Dirty bit (7).

[ ... ]

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 17123f0b6daba..eb8dfffc32c76 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -386,7 +386,9 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, =
phys_addr_t ipa,
>  	out->output =3D paddr;
>  	out->block_size =3D 1UL << ((3 - level) * stride + wi->pgshift);
>  	out->readable =3D desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> -	out->writable =3D desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +	/* Takes care of both RO/RW and RO/WC/WD encodings */
> +	out->writable =3D desc & (KVM_PTE_LEAF_ATTR_HI_S2_DBM |
> +				KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W);

[Severity: High]
Does this code in walk_nested_s2_pgd() incorrectly evaluate the DBM bit in
the L1 hypervisor's stage-2 page tables?

By checking for the DBM bit unconditionally here, L0 treats L1's read-only
stage-2 PTEs (where bit 51 is 1 and S2AP_W is 0) as writable. This allows an
L2 guest to write to memory that the L1 hypervisor intended to be read-only,
bypassing L1's memory protection.

Additionally, this breaks L1's dirty tracking because L0 never updates L1's
PTE to set the S2AP_W bit on a write.

Since KVM restricts L1's HAFDBS capability to AF-only (no DBM), bit 51 is
architecturally RES0 or ignored for L1. An honest L1 hypervisor might safely
use this ignored bit for software metadata. A malicious L2 guest could then
exploit this to write to read-only pages (such as shared firmware), breachi=
ng
the L1-to-L2 security boundary.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901171558.2674=
031-1-leo.bras@arm.com?part=3D1
