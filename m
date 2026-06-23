Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46791208D0
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 19:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241520; cv=none; b=mUcJJYtUrx7aRkg0uuNN8rmfVXkRdlAxu4eKLoQ/PwawjPew/MEXFlLaRN3X2J6nygyV408eVXAALjmGDrQXrHbeB7cblmJAB3LVyBYUDZbklVFc+BiD8cIilJB6ToC9768o1wz2VeMuMISav5gaDlH/Avq2N++lbAxthA5MRDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241520; c=relaxed/simple;
	bh=NtQ2UtyBzlrlraqkeHj6O8nUEuYp3Ixo3hkgLPKeZyg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S9xKMKXiJD8mIiiYC3HSP6OKCEt+imvVPS8A5ETEwoYM8gWNUK+eQ/jViZMjzxhXo29OMmpwk9s942FhceGrcgILHBvl1b+x/9661fAg/MOcayU60Y9N4aGSd5bv36y8OJFfhFSCom9sv9tnJ1p/3pNpdRDOjYIyH+pXYi731F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5WkCVhf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5WkCVhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECD71F000E9;
	Tue, 23 Jun 2026 19:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241519;
	bh=4O53LxH82MwrEmqp7yBm+47KdOouq6qvNfjzqt0doZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F5WkCVhfLpHAd/rBeuHmo3/FiUF3ZLLrDlITGqwKMs1BfIoEaRmuMs7ZP6rhmWj+5
	 aR+WqC9ylIGcVDCuuS1Hqgz+Khl/LeyE59ytkF9ILuaq4xmJk+i5Qn0Tia2ekKtu/8
	 46LRYEsx12Kmno/y0NntwJTyV6y2Ov5lAL2UQW9omz1L6/j2nMjpCVWCanATJJfb2m
	 ko7yRKVm4nCxEsVwXs/qq+Lcx39brdLUBO0bQcQPIX9shwiy/qy0WSr07hb/M6OL5Y
	 WY7NilG2uJvTC/Doe9KPF/YU3bhov/C7MOPpKTkGkvpNXoNcCNftKX6bioIqhdPX1S
	 ekYikW6nub6sg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 18/22] KVM: arm64: nv: Set access flag on table
 descriptors at stage-2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260623184201.1518871-19-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-19-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 19:05:18 +0000
Message-Id: <20260623190518.CECD71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Stage-2 table descriptors fail to generate an Access Flag fault wh=
en VTCR_EL2.HAFT =3D=3D 1, VTCR_EL2.HA =3D=3D 0, and the descriptor's AF bi=
t is 0.
--

commit 7d14ee3ad8d74a4b9734d83c712bb19ae89c1090
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Set access flag on table descriptors at stage-2

This commit implements access flag updates on stage-2 table descriptors for
nested virtualization, as required by FEAT_HAFT.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 2408d604a1e18..6f540d3481d5a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -424,6 +428,10 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu,=
 struct kvm_walk_access *acc
>  			return 1;
>  		}
> =20
> +		ret =3D handle_desc_update(vcpu, wi, &ws, out, access);
> +		if (ret)
> +			return ret;
> +

[Severity: High]
When VTCR_EL2.HAFT =3D=3D 1 but VTCR_EL2.HA =3D=3D 0, and the table descrip=
tor's AF
bit is 0, will this silently bypass the required Access Flag fault?

If wi->haft evaluates to false (such as when HA =3D=3D 0), handle_desc_upda=
te()
returns 0 without updating the descriptor. The walk then proceeds to the ne=
xt
level without checking if the AF bit is 0, which misses the injection of the
architectural fault.

Should there be an explicit check for the AF bit here similar to the one at
the end of the walk for leaf entries, conditioned on VTCR_EL2.HAFT?

>  		base_addr =3D ws.desc & GENMASK_ULL(47, wi->pgshift);
> =20
>  		ws.level +=3D 1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D18
