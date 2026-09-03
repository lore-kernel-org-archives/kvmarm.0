Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8244AE138;
	Thu,  3 Sep 2026 16:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452003; cv=none; b=bDn+d7m6h3d3dCY8xoEZwuNldCm3SS1NzDGI1nOdN53ywdtFPir7LSmbp+/vIXR2+7qKkxmDz3JEV3Sh/5X1zyDdo/RXnSsvCX+lLIJAcOx9BEr8GkY/YQjj/39KNz3StqvgixQrrY2m0HJYWu5k4JLpt0cXJc9eOTENuu7UdmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452003; c=relaxed/simple;
	bh=pQTgZM+NU01OQAleiM0P0/sB97WjcvHUraEuVgvlbeo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OczwxZtVJzymrBK9rKXFBW9yS8GgoLU4SeowHfoS2qCG/84R1IagmJsfDXmFiH/lCBOzJVvKNBDuP0KqTHFl+zypASxboUeeFyiesObDRtkkWqfn3UHATUdTh9fBOgr+OVJtCsxOjRM3IeH7UkXlFQ6ouBAPlcknzjiO6FVC0P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8jmUwOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8jmUwOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D581F000E9;
	Thu,  3 Sep 2026 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452001;
	bh=kgU9rfti9Zn0z1Telc05Z2a4p3nvsgX6ZHUGIMmebEk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X8jmUwOtOcLbYXQN+7rvxemPfQsZD3Rg/haUv8175YLlg6o3Psdy2/fzeT21HZWfw
	 iQN2EndVkNsvNMRCnuBScEUqnpD14O7GhUntw0Xg0BKBaRYmm/9+GtUHYOKNVnSbW4
	 wtMme8+psHTvyymDZNKQawl3K6yvz1veIxtQ2xS/KeuOzx3H4CBQ1Mm9qS0gfbpEoE
	 acgTXVlTVpNeZS78Rp3SiOJsNoarbmBTeAynr5G2moEyOGItvu/jzYGYbbY7I/fiJA
	 Olv2VhLlh+g+RaVtdxepT2qAhgkaWMvDcdbkJD+FWjF99MMaUAdjFUmEVTZbAlof30
	 0/yYoNmT9CAmg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 03/28] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig
 option
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260903160623.315525-4-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-4-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:13:20 +0000
Message-Id: <20260903161321.04D581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Add a new configuration option that will be used for KVM SPE emulation.
> CONFIG_KVM_ARM_SPE depends on the SPE driver being loaded because:
>=20
> 1. The SPE driver maintains a cpumask of physical CPUs that support SPE,
>    and that will be used by KVM to emulate SPE on heterogeneous systems.
>=20
> 2. KVM will rely on the SPE driver enabling the SPE interrupt at the GIC
>    level.
>=20
> The option will become user selectable after SPE support in KVM is
> implemented.
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D3

