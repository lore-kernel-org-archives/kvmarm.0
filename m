Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C88D4A3F15;
	Fri,  4 Sep 2026 13:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530319; cv=none; b=RNs1c9hHTvETzBhdHvbAb1Jf9vnls9C6shtbTM5be0AP34iaVJ7ZYJXd4NkKRuRP9ZBKj+or6NfRrx5tJIjrD7BxrEyGbunyuToLpbFpwJW2K22ZzMnwKJTOT2rnQJ+eGR6e9hz1Wq+rvWXwJx3pXwUuMz2uj6kduQ1rFU86YEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530319; c=relaxed/simple;
	bh=0Io+8b5siNNySn54C26FDzMmtuJGOEcz7Dc3g0L4wPc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W1q/q/nrz++zDOlO2qYFYT7LdJIFHIZdDigIwud9KMQ3xW7Z+Uq99vWwNYAcHeYI14aNKw/UwoOAclpPhI/h6UxFDp6ydB835k3FmSzT+ttSM/PceJmrKZTRnvnnpTw8zBlXF29uQsPP2vHHUkC0iDx0svZB41l/dENBG8VkwKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inCYgTrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inCYgTrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2971F00A3D;
	Fri,  4 Sep 2026 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788530317;
	bh=IwgzP4TkncXcdMxTeEdvaZ3c6EvOzzwVQNbBb+9a8Po=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=inCYgTrStivAbrYjbYW0qXUjQIoDHUj4TWAtWeF6EIn+41LhFSSK1xOMfafqv+E2+
	 w7LJALLr+fwO6Nn62TM94pSp5HfWSwHhfUUAXjSiblyUkS+wlDfzkRnVS/LsfDcY5R
	 TgBk2+r5a4cD0cdWKszfltBmRK2U5j7lAhkfn8xwulRym62AohyjKNFk9gU4ukirfp
	 wY81mLThjCtUjogKTiY0JOHGP5C9x9BRPti6fOAK8XSqJzU5jjYcV622esO94vGKaR
	 BKSsaU3COW7+0eb5wMGeE4JZwFmDpF1ZAPgy1MP6TqIStB4itf7EgtRypFwpj/U8VW
	 itwqLPPSfGzjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 48/49] KVM: selftests: Add VGICv5 IST save/restore
 coverage
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260904113404.4051341-49-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-49-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:58:37 +0000
Message-Id: <20260904135837.9C2971F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] vgic_v5_expect_sync masks guest assertion failures by treating U=
CALL_ABORT as a generic synchronization mismatch.
--

commit b19e638fa7652548d925247fe7e25bc21571d5e5
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 IST save/restore coverage

This commit adds end-to-end VGICv5 IST save/restore coverage. It verifies
that interrupt state saved from the ISTs can be restored into a fresh VM
before the first run and then consumed by the guest.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index c4c932f4c1d46..6caac6cf7c62a 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
[ ... ]
> @@ -522,6 +748,15 @@ static void vgic_v5_run_spi_line_test(u32 nr_spis, u=
32 expected_spi,
>  	vm_gic_destroy(&v);
>  }
> =20
> +static void vgic_v5_expect_sync(struct kvm_vcpu *vcpu, u64 cmd,
> +				const char *msg)
> +{
> +	struct ucall uc;
> +
> +	TEST_ASSERT(get_ucall(vcpu, &uc) =3D=3D UCALL_SYNC && uc.args[1] =3D=3D=
 cmd,
> +		    "%s", msg);

[Severity: Medium]
Does this logic accidentally swallow guest assertion failures?

If a guest-side test failure triggers GUEST_ASSERT() or GUEST_FAIL(),
the VM exits with UCALL_ABORT. Because this TEST_ASSERT strictly checks
for UCALL_SYNC, it will catch the abort but replace the output with the
hardcoded synchronization mismatch string (msg).

This drops the actual assertion payload (like the specific failure reason
and file context) that REPORT_GUEST_ASSERT(uc) would normally print, which
might make guest test failures difficult to debug.

Should this helper explicitly check for UCALL_ABORT and invoke
REPORT_GUEST_ASSERT(uc) before falling back to the UCALL_SYNC check?

> +}
> +
>  struct vgic_region_attr {
>  	u64 attr;
>  	u64 size;
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D48
