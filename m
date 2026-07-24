Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA4D429CD7;
	Fri, 24 Jul 2026 12:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895514; cv=none; b=GeL8t8ocE9Y6TOnGjl+vFmkk/fcFA6wF3RukEy5ysKetpDMwMf4YAKmMd2p7LRZ0zzKmrs0PQl4Ceteb75rlS1E6b5fS6hMR+/Qly2dlMS5vl+GvgU2B8jYdBSWz778qR2y3Sgk5/z/K6nOTLgyqiKDXhqcVUaWIq6gJ+hjpgWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895514; c=relaxed/simple;
	bh=5dznLxp38rDGsAaomkyVEGDCnU0E7ZiTGK0EKFub4Uk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TKEIArviYzrk/hMhrCy0h3mUoPtYrkVCZ2LQtJB8257VOjOOyvHxhH+MpLN5NPWDRN2mRKdZYsG5n4NWdPKJTuiLPj1LnzieYyYMlAG3GY8lC8vfEZcZHe54tBMkDlmQuuxevQUT8CjUxWimm6krV3fzKlIKHYMBbHBQOJlrmeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDqP2dBL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDqP2dBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F181F000E9;
	Fri, 24 Jul 2026 12:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784895510;
	bh=xfCr2PmpN/IPNFcVwUvTlWnqWvD6lHElebJohXABa7M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aDqP2dBLW3M7mCBgogYwdvhqesl/HTwKf6kIqt0sDXUm/C118ZCTw3VJUIOrgxxKC
	 yMuu+o2oSLth6McXvpHc/uCVy3vPH7YEi/u5M2zL7/BsKIx6mczPFWU/W5Gk+SLjui
	 l4JI4rZHE2Fg1ooyacAi4VKzv97YL48KwhVIO/nf6VKU3xz470khGxcT0pAfd2EjOv
	 WkxM1f715S34+iWZn/E7ps1jCyw63sReaVarQyB0ZhGcgE78Va2SSiBv3i92jadmPQ
	 56UfRHFQs6+eRE2Pmx/nXqYofQhKlczgKnmefY2w0WlDcRNWp2DOIKYZoIVJtodRXB
	 iSYxWOKOo1ZMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 47/48] KVM: selftests: Add VGICv5 LPI delivery tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260724104819.1296803-48-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-48-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 12:18:29 +0000
Message-Id: <20260724121829.E2F181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Mismatch between test comment and implementation regarding VPE1's r=
ole.
--

--- Patch [47]: [PATCH v4 47/48] KVM: selftests: Add VGICv5 LPI delivery te=
sts ---
commit bf269c88145be7a460a3fb9663a58422687addf2
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 LPI delivery tests

This commit adds a two-VPE VGICv5 LPI delivery test. It exercises the virtu=
al
IRS ID registers and IST base configuration path before checking interrupt
delivery between the VPEs using a host-backed, unity-mapped userspace memsl=
ot.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c

[ ... ]

> @@ -1179,6 +1365,54 @@ static void test_vgic_v5_spis(void)

[ ... ]

> +static void test_vgic_v5_lpis(void)
> +{

[ ... ]

> +	/* VPE0 programs a linear LPI IST from the virtual IRS ID registers. */
> +	ret =3D run_vcpu(vcpus[0]);
> +	TEST_ASSERT(!ret, "Failed to run GICv5 LPI vCPU0");
> +	TEST_ASSERT(get_ucall(vcpus[0], &uc) =3D=3D UCALL_SYNC &&
> +		    uc.args[1] =3D=3D GUEST_CMD_IS_READY,
> +		    "GICv5 LPI vCPU0 did not become ready");
> +
> +	/* VPE1 observes the IST and enables the LPIs it will receive/send. */
> +	ret =3D run_vcpu(vcpus[1]);

[Severity: Low]
This comment indicates that VPE1 will enable the LPIs it receives and sends.
However, looking at guest_lpi_code(), the LPI configuration via
gicv5_configure_test_lpis() is restricted strictly to VPE0:

	if (!vcpu_id) {
		gicv5_enable_irs();
		gicv5_configure_lpi_ist();
		gicv5_configure_test_lpis();
		WRITE_ONCE(lpi_ist_ready, true);
	}

Could this comment in test_vgic_v5_lpis() be updated to accurately reflect
that only VPE0 performs the LPI configuration step?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D47
