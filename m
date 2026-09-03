Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BDD4DD6DB;
	Thu,  3 Sep 2026 16:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451946; cv=none; b=U9NPKS/BfFmkVsten2IgN7XwP3Dm4YQB3rz6CdE0nMBiMCBFQoHQlzwlsuSrg33nme/Nl0//9VR9bT0Cujri1Q0dqI+IvGkoK/lzF2TS2+JltYAq+G1W7A2UzIPn4ljf1VpSMpOgIqvEZpv1u7nTm7uFDtQRn1rAQQRYaNQc4E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451946; c=relaxed/simple;
	bh=Hr/hmL6NYthsMH/QZdUXZp9Eq3eoYz0WlgRPn5aYQP4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eZUyoQ2R/JpTzIWcOB9GHO2x+KaTWBXV79kbEzcEZ923MIPLmMEMg3CXc3iaMjFPexPnjMxnBaa/e5zV/Bf3/DNdGRZrnh8CrfoiY6Hi7fyaN9/iqirkRQ1FVU7ytUOgCdg/QBtPQmpJDFaY7tD2nvxBEWb0u4KbagI5Z4RCCzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/NOV7tZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/NOV7tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB081F000E9;
	Thu,  3 Sep 2026 16:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451945;
	bh=Hr/hmL6NYthsMH/QZdUXZp9Eq3eoYz0WlgRPn5aYQP4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a/NOV7tZ17AdHK0gFT9jLF9hKXDMTyzpn/svgOi8vxwD/u/Vmh5P8dJVTxJUu0m4q
	 Z4QAY47zIyAUf0dwu7WqC59Se6ga/BFdUKvykWsL2dp1ca+AugLLj9G0TEj/ihxWWi
	 cIyzH42O7mQl5CuqDjaSQvjU3ORHXn34Sqn61dtd0ozxFShnfxxfAKEqvo/tW3JVkv
	 Lp9n6702mRMMUfSrlMq3oUJl8aiYQcJjfEO8siX7Ex3sjgkVJOAagUsd52pZSf6exR
	 KZUvqx81oI1QyJf8nnaaGyP13V24tqLtk1Qo3s0UgFGupT9iPNtq6Xr/lc4bV0CvmE
	 HAXI9oQTJnEOQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 02/28] arm64/sysreg: Define MDCR_EL2.E2PB values
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260903160623.315525-3-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-3-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:12:24 +0000
Message-Id: <20260903161225.1BB081F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> KVM will make use of the different values for MDCR_EL2.E2PB, document the=
m.
>=20
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D2

