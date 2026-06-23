Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCE02DF15C
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240934; cv=none; b=eulyhhZpKb+j3+Fcffdaq/JiQ6ZtxV91CCo95jZsXwDerP9y+M1eHQBMRI6ZKN+nSdouB5g2vFSqvRm4ho37CBBNwcoTFUcGn0XPn5JAR0AZrHfLaMkvYayB3b+FxrRCKDHfaSCUyCs1pj2NzWkFi2ea4QhMWwm4LqxPTSO59ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240934; c=relaxed/simple;
	bh=DyXHOGzy2zyPCoBRRQV1dTRlVkQT7mrSj4vOq7Vh9S4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q9wdYx+EK1A6CCLzV97x4soWhOlMPfbX01yQIjXQc+krVm4vhLtCnvq2U1gwktZY32eG/KFxnBRarx/AFGEIuFPHkR1YeGk/dFVAv14B1xiFM86PRH8qFyou3vBeF5kX0wFd/9YUlksD90neno3V0jIvjbm8kqSYOVlqHX1C/jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+xKDRXr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+xKDRXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A841F000E9;
	Tue, 23 Jun 2026 18:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240933;
	bh=82HjPKvx2VGcpGQje+GfshQMeDHHu6sM+G2VRWHQoB8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G+xKDRXr4PnJwGy75kgZJyI7IGe0TSuxR6wCqUEYFYVORBjf8XlGuratXxnNwYD4H
	 armTJjb/RcLuJbRNmneXTm/WK/DPtHwkcyrsb6f3SGC7itAjHIbBjmxyO5xRPnKDo8
	 y7dVLoRNWTW7Y1ddBSv7Y/V12WoSZW09V7lrPRgmgZ3JKzFeMVuzGRJ7mUm/vjFQH4
	 PtMJrY53DfQJZ1QSwenpgj6gaae2GAysjhx4TD0KBa4kj5sGGNCO+2skinPtPbmwBL
	 rA4GZFroA2JnfUBJYUaA7mK8QOWgOM1thz/Vc6AO+DyI6w/ep72OaLDGnSFFM5h0Nn
	 QaaDSj8j0GxUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/22] KVM: arm64: nv: Treat DBM as writable at stage-2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260623184201.1518871-9-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-9-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 18:55:33 +0000
Message-Id: <20260623185533.79A841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] DBM incorrectly grants write permission to "No access" stage-2=
 pages, breaking nested guest isolation.
--

commit 99b59d5177f5650f344f4c618e4c4dcd2d5d6d1c
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Treat DBM as writable at stage-2

This commit modifies the stage-2 permission computation to treat the DBM bit
as granting write permission when hardware dirty state is enabled.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -305,6 +305,17 @@ static void compute_s2_permissions(struct kvm_vcpu *=
vcpu, struct s2_walk_info *w
>  		break;
>  	}
> =20
> +	/*
> +	 * Descriptors with the DBM bit set while hardware dirty state are
> +	 * considered writable, even though certain accesses (like AT instructi=
ons)
> +	 * don't actually update the dirty state.
> +	 *
> +	 * Assume that walk_nestd_s2_pgd() made the necessary descriptor updates
> +	 * for the access and just treat DBM as writable here.
> +	 */
> +	if (wi->hd && ws->desc & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> +		s2ap |=3D BIT(1);

[Severity: Critical]
If s2ap is initially 0b00 (No access), this unconditional OR operation will
upgrade it to 0b10 (Write-only) in compute_s2_permissions(). Does this
inadvertently bypass stage-2 memory protections if an L1 hypervisor maps a
page as No access but leaves the DBM bit set?

Without verifying that read access is already granted via s2ap & BIT(0),
this logic grants write permission to a No access page, allowing an L2 guest
to write to memory explicitly protected by the L1 hypervisor.

Additionally, mapping a stage-2 page as Write-only on hosts without
FEAT_S2FWB is architecturally unpredictable and might result in host-level
issues.

Could we gate the DBM write permission upgrade so it only applies if read
access is already established?

>  	trans->readable =3D s2ap & BIT(0);
>  	trans->writable =3D s2ap & BIT(1);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D8
